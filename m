Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45C36C7367
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCWWyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCWWxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:53:45 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E3A2F05E
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:53:31 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e15-20020a65678f000000b0050f9e396342so54060pgr.5
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679612011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w3lHhRnqtm1/nrKLYapHPvJp7ib6gxFANO5Hor8y7To=;
        b=eaFVGS66RA+q5GsktAcZgZhwdriivRY47+TjG3OayhDdZ/U5qF3dnOrwQsmhisniJB
         NjuWjZNuiSTTrEvjVp6+aZuJg0mVyqoRAR5gjBqIFXkgCiel/seP3e7tluT+H6l4EPYF
         yshVuz6Qi2AS3/uBnYkf4NX8rlJd7kx40V+dcRxWXjzv73n7+EOb8btfb5rH8sVflf/J
         Sf9Qs++O+ICXoCfxe7kHR7Y6io8XvrMta0z5mdEEZvkb/ZJrdChRmGWdAZExumOg7Qf1
         RZF97b/V3gu8JiDnUG98ao6La1rs+gc4qS4qXouzOJGHjt5yCKjqRF8ycSifxsOf7aZ+
         kdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679612011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w3lHhRnqtm1/nrKLYapHPvJp7ib6gxFANO5Hor8y7To=;
        b=5oek5AXRkbHh04Awc4RinI1u2A4FlT8MFEUK0GF8NcUhLCaaEIz9Ig1vsYrYAzSXcz
         BwEoXMKSjQBfrSrd/sydJH7xRiUzoUhYP9740mfsBBxcyhVcT5Uj3v2s1aAX0btvN2RG
         lfKyaEK6Q6cHSIfoO1EOOPNvAGoAY7mL/UkqdqLim36RcpfKGiB0RkKP9FnUzmZ5V/It
         AyYm27qTEQokyHxhzWFwOXM9ocmvkusEYWYgBcnTVfZoyHkli/6fJ1pbfWhnji9WAbJm
         +6av2jL+k75dOle2lNiXvQyWXfs2FO9Cj6VpmI/I6nACQjJm7TvHlNhxjHI28BHOQMYp
         lFvQ==
X-Gm-Message-State: AAQBX9eW0aTOhkOam9504UEfxrmA98PKVaYSrsYWEYEZ8O56wGd05096
        GjoAqkOUMNEjSv18YTZ+PaeEY005RM4=
X-Google-Smtp-Source: AKy350aY9ejugf2w7qb3OT6kcoAl6N2fFS5DJgWIHW+zIlvhCAS5Fh17CmMpv9Gx4hW6pPyKq6TX9XLEsQk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:498f:0:b0:509:3be7:eac9 with SMTP id
 r15-20020a65498f000000b005093be7eac9mr48249pgs.0.1679612011090; Thu, 23 Mar
 2023 15:53:31 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:53:09 -0700
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
Mime-Version: 1.0
References: <20230227084016.3368-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167960989477.2547780.13395816723370441701.b4-ty@google.com>
Subject: Re: [PATCHv4 00/11] SVM: virtual NMI
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mail@maciej.szmigiero.name,
        mlevitsk@redhat.com, thomas.lendacky@amd.com, vkuznets@redhat.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Feb 2023 14:10:05 +0530, Santosh Shukla wrote:
> v2:
> https://lore.kernel.org/all/0f56e139-4c7f-5220-a4a2-99f87f45fd83@amd.com/
> 
> v3:
> https://lore.kernel.org/all/20230227035400.1498-1-santosh.shukla@amd.com/
>  - 09/11: Clubbed x86_ops delayed NMI with vNMI changes into one,
>    for better readability purpose (Sean Suggestion)
>  - Series includes suggestion and fixes proposed in v2 series.
>    Refer each patch for change history(v2-->v3).
> 
> [...]

Applied to kvm-x86 svm.  As mentioned in a previous reply, this is somewhat
speculative, i.e. needs acks for the cpufeatures.h change and might get
overwritten by a force push.

[01/11] KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is intercepting VINTR
        https://github.com/kvm-x86/linux/commit/5faaffab5ba8
[02/11] KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
        https://github.com/kvm-x86/linux/commit/7334ede457c6
[03/11] KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
        https://github.com/kvm-x86/linux/commit/5d1ec4565200
[04/11] KVM: SVM: add wrappers to enable/disable IRET interception
        https://github.com/kvm-x86/linux/commit/772f254d4d56
[05/11] KVM: x86: Raise an event request when processing NMIs if an NMI is pending
        https://github.com/kvm-x86/linux/commit/2cb9317377ca
[06/11] KVM: x86: Tweak the code and comment related to handling concurrent NMIs
        https://github.com/kvm-x86/linux/commit/400fee8c9b2d
[07/11] KVM: x86: Save/restore all NMIs when multiple NMIs are pending
        https://github.com/kvm-x86/linux/commit/ab2ee212a57b
[08/11] x86/cpufeatures: Redefine synthetic virtual NMI bit as AMD's "real" vNMI
        https://github.com/kvm-x86/linux/commit/3763bf58029f
[09/11] KVM: SVM: Add VNMI bit definition
        https://github.com/kvm-x86/linux/commit/1c4522ab13b1
[10/11] KVM: x86: add support for delayed virtual NMI injection interface
        https://github.com/kvm-x86/linux/commit/fa4c027a7956
[11/11] KVM: nSVM: implement support for nested VNMI
        https://github.com/kvm-x86/linux/commit/0977cfac6e76

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
