Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022A96E14D9
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 21:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjDMTJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 15:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjDMTJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 15:09:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D827AB7
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 12:09:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j6-20020a255506000000b00b8ef3da4acfso14009646ybb.8
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 12:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681412986; x=1684004986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QlxEmfRbaPGBG4xTcOle4NNs8xZaFaj6SUpCI6QcOZE=;
        b=EfJBXjoqWE9fgL6w2LFufKhkyBayJKeI9Eam9TM7bUvYFtgTht80zGAcUXHSvaHJKx
         687CXBkQdSR3umjs/d3rYGJWW4hlH0zfYE3TAokRj6mc9++o9GraXcRPmgQ0p+s6YwUB
         SuddqmnidpgIpg9AdAW8A0Lw2mq0UnrX2jdqI/j18ghl9fcrJSfIrwZrkOpfUQSdqurd
         JH2vs74D4QwwETVLue08hVSX4gIYDb8dxqeR567hO157IsNO/JMoQ/VggQxOsZFzCH0E
         3hWZAmehV5ROf2IvhV/VoOGVXwikbf3ZkN0xHC+1Ih4Yhnl353QNrjuULv/IYD7lSpFS
         S7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681412986; x=1684004986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QlxEmfRbaPGBG4xTcOle4NNs8xZaFaj6SUpCI6QcOZE=;
        b=HB15Tt1VNetIGfdvApq6WvLZcGY8XRW047lvJ6zA65tVorS4OTvfKFruIuCw4WX9O0
         gREMOOz9e6vWjzky+1gUAhx7cB9lC+6QE1P2Uakl+5WtdP44MQXIt0FELGjJlYJHpZh0
         FreD+F1ZGvlI2D537znEvC/ys22ub1gN/mJhaviGiTCMt7OVTDUsl4V4ojFo+i7xnhCv
         jr4Hgx/iavFaxOJHgq5PeBbNWqt51xoYfvXJQkk5RT3NDeGbkja0Fpg6P163TND/Y5YC
         j9RxHPH+PJsChsKinFH+WP4KDjQM9dEpAOp4tbPWsuzErPHV26Fu/Eeq9L7xq5c3t5a2
         hKzw==
X-Gm-Message-State: AAQBX9eVhbcWk0DyTDT4Od52kG1Sd+65CmHbRWqM0WbfxtQH5I4c+VjU
        CUnqbQrHsgW/dTCxEgKMFxU8BMHUkiA=
X-Google-Smtp-Source: AKy350ZUWa/zrIdpGrk3bcqiUdqbJeatjAfoqJF0+bOQmwOBxI0wvdh6ylLbB5QhKoXBwjU3GntOUvGGrvA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:450c:0:b0:54f:96bb:3683 with SMTP id
 s12-20020a81450c000000b0054f96bb3683mr2029655ywa.1.1681412985923; Thu, 13 Apr
 2023 12:09:45 -0700 (PDT)
Date:   Thu, 13 Apr 2023 12:09:44 -0700
In-Reply-To: <ZDg6w+1v4e/uRDfF@google.com>
Mime-Version: 1.0
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com> <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
 <ZDSa9Bbqvh0btgQo@google.com> <ecd3d8de-859b-e5dd-c3bf-ea9c3c0aac60@linux.microsoft.com>
 <ZDWEgXM/UILjPGiG@google.com> <61d131da-7239-6aae-753f-2eb4f1b84c24@linux.microsoft.com>
 <ZDg6w+1v4e/uRDfF@google.com>
Message-ID: <ZDhTeIXRdcXDaD54@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023, Sean Christopherson wrote:
> Aha!  Idea.  There are _at most_ 4 possible roots the TDP MMU can encounter.
> 4-level non-SMM, 4-level SMM, 5-level non-SMM, and 5-level SMM.  I.e. not keeping
> inactive roots on a per-VM basis is just monumentally stupid.

One correction: there are 6 possible roots:

  1. 4-level !SMM !guest_mode (i.e. not nested)
  2. 4-level SMM !guest_mode
  3. 5-level !SMM !guest_mode
  4. 5-level SMM !guest_mode
  5. 4-level !SMM guest_mode
  6. 5-level !SMM guest_mode

I forgot that KVM still uses the TDP MMU when running L2 if L1 doesn't enable
EPT/TDP, i.e. if L1 is using shadow paging for L2.  But that really doesn't change
anything as each vCPU can already track 4 roots, i.e. userspace can saturate all
6 roots anyways.  And in practice, no sane VMM will create a VM with both 4-level
and 5-level roots (KVM keys off of guest.MAXPHYADDR for the TDP root level).
