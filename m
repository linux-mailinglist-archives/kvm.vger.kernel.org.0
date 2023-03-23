Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0856C5B96
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 01:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCWA5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 20:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCWA5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 20:57:12 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A3372A8
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 17:57:11 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q15-20020a63d60f000000b00502e1c551aaso5282249pgg.21
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 17:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679533031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kMshf5S1FJmaAxra362BkD+cm0BSDJe9+Dywzm0pGeM=;
        b=mFmV/WGiOKQTREBj4S8Vskv5ddfy+IOwhnbKDyR15A3/75XtKLCeFlr/tcuA/avBIu
         HhBJoTRNL/mCGhykYN7pgu9XFtIoViZAXIPLEFvMyBzE0t9Io6BGF+p1IUYE24fX32/8
         TpUsNQJMfv1Uqi/GhPIJ7UYgGmysGOTiCiQj//1SzpBjci0Plk+oKEdNdBzIRyQQBxxs
         Uy5WcbJfbahWcqfkhXWwiuNZRhmZsQT3riLb0UxAYqCPMHeJT5Yc4j+tY1IcpsiTIq77
         ds5wLwDdjlE277OKQ6zDE+WGSKFsTAC356P3WnRuk9HFnnocmBgYAXV/HJ5wHePuKpOH
         Mk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679533031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMshf5S1FJmaAxra362BkD+cm0BSDJe9+Dywzm0pGeM=;
        b=KIEi2JTLsGWcvQqaFru2Tok84EKbsKzoCl4Eb1n7TZMY1SbBRbVmHsmxNS/ptYVErr
         0FahalOYeE3ppcGBfOE4B/ZTVlFMXSfljBZyZS16CoXh/zRkc+F7QUr+A5iBDIJUTXa2
         4SO39w4z7SQrmF1QECEJaz/1cU3UMUwvJfRk3+8bdJQoat5fXTHDgbaos/IYkYMSAeiP
         7vz/G7gIao33JZBPSNynkzsjUHcKjFlDs9ee62aUh4Kyn8hFXiLAe8WFJNPCl88tYfd5
         7vPQ3MwS4Zn32dHX87aHKyrV/mF1F9wUjvjdqLa0c4/5Vk8cY1hQ5eERGoyTKcbdZnYH
         XUAA==
X-Gm-Message-State: AO0yUKVsKctIDRKnbBJLPmHDctMzxVfpf5ksdodMRc2Jfgbf/NbOnKRB
        XHt48csfoVWZCi7DU1cvXBCcTmqqUGA=
X-Google-Smtp-Source: AK7set8UP/cHwB8/KqElbLOXlTd02HjCbqmSydl8gpdUgmWn5rBdIedze7DRIs7FJbuAuWalkvQV6NuFHzw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5349:0:b0:50c:6cd:cac8 with SMTP id
 w9-20020a655349000000b0050c06cdcac8mr1329234pgr.2.1679533031306; Wed, 22 Mar
 2023 17:57:11 -0700 (PDT)
Date:   Wed, 22 Mar 2023 17:57:09 -0700
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
Mime-Version: 1.0
References: <20230227084016.3368-1-santosh.shukla@amd.com>
Message-ID: <ZBuj5U29Pv2ak47u@google.com>
Subject: Re: [PATCHv4 00/11] SVM: virtual NMI
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, mlevitsk@redhat.com,
        thomas.lendacky@amd.com, vkuznets@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023, Santosh Shukla wrote:
> Maxim Levitsky (2):
>   KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
>   KVM: SVM: add wrappers to enable/disable IRET interception
> 
> Santosh Shukla (6):
>   KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is
>     intercepting VINTR
>   KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
>   x86/cpu: Add CPUID feature bit for VNMI
>   KVM: SVM: Add VNMI bit definition
>   KVM: x86: add support for delayed virtual NMI injection interface
>   KVM: nSVM: implement support for nested VNMI
> 
> Sean Christopherson (3):
>   KVM: x86: Raise an event request when processing NMIs if an NMI is
>     pending
>   KVM: x86: Tweak the code and comment related to handling concurrent
>     NMIs
>   KVM: x86: Save/restore all NMIs when multiple NMIs are pending
> 
>  arch/x86/include/asm/cpufeatures.h |   1 +
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |  11 ++-
>  arch/x86/include/asm/svm.h         |   9 ++
>  arch/x86/kvm/svm/nested.c          |  94 +++++++++++++++---
>  arch/x86/kvm/svm/svm.c             | 152 +++++++++++++++++++++++------
>  arch/x86/kvm/svm/svm.h             |  28 ++++++
>  arch/x86/kvm/x86.c                 |  46 +++++++--
>  8 files changed, 289 insertions(+), 54 deletions(-)

Code looks good overall, I'll fixup the changelogs and comments myself.  I just
need to run it through my usual test flow, which I should get done tomorrow.
