Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E316FFBBE
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 23:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbjEKVQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 17:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbjEKVQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 17:16:03 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C561FF3
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:16:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-560f6723651so31326877b3.2
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683839761; x=1686431761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DccLY5bihANoBHnSUhcyMOU3VlQaP+9JOSTTPbN2LVk=;
        b=qTOre7YGd6tOwQ3Wf+2rxDmWqyPuRN45MhWiilq7mXIXMgEo7OdKWJ8/wPyL9qJFGN
         k+0jHg9y0d7bVs0H8sUvRvmsUTBrfMrqayPojXqowp2DAwx2Ef2YjA8f6IRWGdAFc3lR
         X8s/jAQpWZpORK9ax/M4iLkiApJBUfzjFijTFhUXXFx1a1Z0AKhQOC8CG+0D4PVUbPVY
         Y5sU32jNZO0xa7wkJZPZfv1qbPTJHs92GUL2ZuC1Sr92V+y8z3tLkGigNQliXid3QkXG
         6uSG3yHCFzHZncWSpkMrEVYy3XUVZmZkeiY2Y6x4iW0OBFAJv4DEHuaeJFOAUGFcJdTG
         gMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683839761; x=1686431761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DccLY5bihANoBHnSUhcyMOU3VlQaP+9JOSTTPbN2LVk=;
        b=U8JsQLhNSBQ5S2hUc+cCP7r8uC/ZWgAO3ALM8MC4TbhU/NqJVVXTZQM23zB3H6KXuY
         LwBXJtj347u+MGmMkdyLtSA8OQYQbDl1tKYuFL7NFsy4mR5zNjjWqXHDqM+195jZOMfv
         RABAkJlpVPQcqxMKD6iP/BW8hw5fVHH/Iu5IYF/UHguZOCQ8YrSogoUmby3uvKIRr97R
         8oQ/qFbNrFYLIlA9j1GAzOgQiLUbJv4k8YDGJls2cX+4KpmCMX3i59pCwcXKirKpXOu1
         elraKc5Y+pGDL1dIoc7WZGk47AFqOhUjel2atNY6uNooFPyKlL6qkJLVRGuiUgTvWhVE
         hPYQ==
X-Gm-Message-State: AC+VfDx7sG0VUkCXF451jrr+SNeM/RlMuXYBNCd/BQX0pCFY2kFE2y+J
        Pua7XWxI/QKPEBEu98l/61f1O5oEggA=
X-Google-Smtp-Source: ACHHUZ6Fz3ZKYrDKLcZSlat0ns9XyQUausbvqoLMPfVFhxA4+fy3AfOXlL+gvLwl3LIg4/ZjcIqc+JBYpFw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a782:0:b0:545:1d7f:acbf with SMTP id
 e124-20020a81a782000000b005451d7facbfmr13475825ywh.10.1683839761401; Thu, 11
 May 2023 14:16:01 -0700 (PDT)
Date:   Thu, 11 May 2023 14:15:59 -0700
In-Reply-To: <20230508154602.30008-1-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230508154602.30008-1-minipli@grsecurity.net>
Message-ID: <ZF1bD0q7yNr8iafW@google.com>
Subject: Re: [PATCH 6.1 0/5] KVM CR0.WP series backport
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
> This is a backport of the CR0.WP KVM series[1] to Linux v6.1, pretty
> much the same as for v6.2.
> 
> I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
> a grsecurity L1 VM. Below table shows the results (runtime in seconds,
> lower is better):
> 
>                         legacy     TDP    shadow
>     Linux v6.1.23        7.65s    8.23s    68.7s
>     + patches            3.36s    3.36s    69.1s
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
