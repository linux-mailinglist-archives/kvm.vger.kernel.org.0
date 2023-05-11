Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586366FFBC0
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 23:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238866AbjEKVQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 17:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239215AbjEKVQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 17:16:25 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C2B1FFF
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:16:24 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6436b503faeso9184048b3a.3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683839784; x=1686431784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eH8gR//xYJ4W1EGUtNgoN6c4lYqH8jKsRvjQaXXfguY=;
        b=Mnn3pHxJBj0swVnZ61VZ2LnEtFSmvHpgENByHR7o4QngBT1QGHWwUpbBmacGkqA1gU
         eRprkFiyjcZSMIISPyRZReVagD/SxEEZrNZmD4h7L/lZRycIB1Fg7HaJ30b1tBXYefab
         gkh8K8mp8rF8ScT7IB7nyMTN8uaeLqFHJLBUK3V7YdRr4aZyrx3SJckLBTCvAVy+hN0t
         JEEs1g320gB8mpecAB3cHZgxayfEvHUwNM2bL3hU6RdAatifflEcd3h9V0PJo7PhElAN
         rm0FsJCRFpDxQcJ8XXNSYxIFZMOYkwrBk1MoNHrhLBfHorF8VG1Ag085OqaicXrYT8p6
         /pPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683839784; x=1686431784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eH8gR//xYJ4W1EGUtNgoN6c4lYqH8jKsRvjQaXXfguY=;
        b=kPmA1U08a99T5VtUuR5Wsdq85WTOlbe/81gWQibmBem4WBwK/A4aygoQQLZR+PGrq2
         kuS+Yw8FtfNTQHOGWvpB8/ZdDN0rcEwDUVDIsFTQCO/Y2HytUmFrUn32IhOIOhGsr2hi
         u5AX3qEzXWBabyB+XaYEZCFfppYdR367WcRuTWYyTgn6Ka4kgOBXsMIH892qPwRJnSFS
         NJMrPMFeCTdAhfmH8p7ucVXOLJJ5b2oUMzBeISuQA5A4Wmohf/Tsu6eoCxuoK0emni3r
         En07GQfbwHXax4uW6B3aYTkpTkjIROYKttb0bIWbDpiRHCFmUlEK4rNv4ZgBmqD3vqNq
         NAow==
X-Gm-Message-State: AC+VfDz/Pvq2dyzFozt4TDVUmaPhXWvRUWc2l4hilETJ6roc3pVJfhm0
        hoZzu1BlFxRk9zoBVw22QunvkLdlMZw=
X-Google-Smtp-Source: ACHHUZ7OGIT9Tf4V9m4ctBKsDSTDFIQNfzThBD2UsGzsGFMLq3A9SnXEyZuH5bzDSbrA0USqn9dzGxQDuy4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:7c6:b0:643:599b:4db4 with SMTP id
 n6-20020a056a0007c600b00643599b4db4mr6114797pfu.1.1683839784281; Thu, 11 May
 2023 14:16:24 -0700 (PDT)
Date:   Thu, 11 May 2023 14:16:22 -0700
In-Reply-To: <20230508154457.29956-1-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230508154457.29956-1-minipli@grsecurity.net>
Message-ID: <ZF1bJgJSepCwE02l@google.com>
Subject: Re: [PATCH 6.2 0/5] KVM CR0.WP series backport
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023, Mathias Krause wrote:
> This is a backport of the CR0.WP KVM series[1] to Linux v6.2. All
> commits applied either clean or with only minor changes needed to
> account for missing prerequisite patches, e.g. the lack of a
> kvm_is_cr0_bit_set() helper for patch 5 or the slightly different
> surrounding context in patch 4 (__always_inline vs. plain inline for
> to_kvm_vmx()).
> 
> I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
> a grsecurity L1 VM. Below table shows the results (runtime in seconds,
> lower is better):
> 
>                         legacy     TDP    shadow
>     Linux v6.2.10        7.61s    7.98s    68.6s
>     + patches            3.37s    3.41s    70.2s
> 
> The KVM unit test suite showed no regressions.
> 
> Please consider applying.
> 
> Thanks,
> Mathias
> 
> [1] https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/
> [2] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
> 
> 
> Mathias Krause (3):
>   KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP
>     enabled
>   KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
>   KVM: VMX: Make CR0.WP a guest owned bit
> 
> Paolo Bonzini (1):
>   KVM: x86/mmu: Avoid indirect call for get_cr3
> 
> Sean Christopherson (1):
>   KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission
>     faults

Acked-by: Sean Christopherson <seanjc@google.com>
