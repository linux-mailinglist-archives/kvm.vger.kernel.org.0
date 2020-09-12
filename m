Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C91F26781F
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 08:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgILGP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 02:15:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52542 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725808AbgILGPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 02:15:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599891352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hYkkhNgkJ+I++Y6K6W6FUcw4iXrMY+1fU6LYC+KZvHA=;
        b=OXR0CspHyierXIguTkY4G9rGWpnSJ2ROfZOakIjlA4v1U3Q4CKEQNFxrZlmawX9NS3BBpb
        tGpT/ttxJbl88D1S+FQi/udz201bOt7afLkwD5vuE1OZlFeC/pdT1Gfn1pw5+bcWoTUSQr
        5C+q8kKzI7/Oe7+sjDF33U2FtMXQlp8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-X1V06T6UO4-v7IYN-T6U-A-1; Sat, 12 Sep 2020 02:15:50 -0400
X-MC-Unique: X1V06T6UO4-v7IYN-T6U-A-1
Received: by mail-wm1-f69.google.com with SMTP id b14so2294874wmj.3
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 23:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hYkkhNgkJ+I++Y6K6W6FUcw4iXrMY+1fU6LYC+KZvHA=;
        b=O1VGYjoT3mK3FqY5GPFJ6IJkb6Lswp7aVxmFvBcBZqMR/as+AoIxThJyshDH8gGqBB
         fFE1lfx+xxydqUFvsog/TSKqEmCpJb9Egwm+vnTwZDYoTwo45Wh4Mrl8uqY+y75WSUww
         NbY3JctSQj/OZQEXez3EgFKZjk1R3UmK4ImaNDXucMHtLAATLS92JX3OJtJQWw71V0J3
         PZRVTVs4Ie0iiEuxMM/TGJaOefUYV2gx/BEMc9Sk5oEPkKIjpWC6Ts5WODxtLaQBsTzZ
         OaadPWUOqOJVJmTMSfVKEzlQEfB8zsehlD2OMzTqugYzZMkBugHgBBYR8fcTraX9QLKj
         I4xA==
X-Gm-Message-State: AOAM531NYlDH3fzCVEgujTKktG/5F+/dPKwRz9/Cm8p1am+snPFtA6a6
        eHJRigZ9meHAfW+HG46b32CCt8Adinl7GpMky5gcJHsUQ00QOtRSI39VoGWxsS14TA4due6sLQ/
        TSJsjTkdIbOsP
X-Received: by 2002:a1c:7d4d:: with SMTP id y74mr5446730wmc.73.1599891348830;
        Fri, 11 Sep 2020 23:15:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtCvkRcwSIjSWR09pA1CZCs6u6O/FehNxkRo6n8yeCCzNuFPbrV9n6E7hdrdtDgwMwb+7uGQ==
X-Received: by 2002:a1c:7d4d:: with SMTP id y74mr5446710wmc.73.1599891348596;
        Fri, 11 Sep 2020 23:15:48 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id a17sm9049061wra.24.2020.09.11.23.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 23:15:47 -0700 (PDT)
Subject: Re: [PATCH RESEND 3/3] KVM: SVM: Reenable
 handle_fastpath_set_msr_irqoff() after complete_interrupts()
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
References: <1599620237-13156-1-git-send-email-wanpengli@tencent.com>
 <1599620237-13156-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <da8342cc-5c7f-b04a-ed79-8527cf74b746@redhat.com>
Date:   Sat, 12 Sep 2020 08:15:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1599620237-13156-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The overall patch is fairly simple:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 03dd7bac8034..d6ce75e107c0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2938,8 +2938,6 @@ static int handle_exit(struct kvm_vcpu *vcpu,
fastpath_t exit_fastpath)
 	if (npt_enabled)
 		vcpu->arch.cr3 = svm->vmcb->save.cr3;

-	svm_complete_interrupts(svm);
-
 	if (is_guest_mode(vcpu)) {
 		int vmexit;

@@ -3504,7 +3502,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
kvm_vcpu *vcpu)
 	stgi();

 	/* Any pending NMI will happen here */
-	exit_fastpath = svm_exit_handlers_fastpath(vcpu);

 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_after_interrupt(&svm->vcpu);
@@ -3537,6 +3534,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
kvm_vcpu *vcpu)
 		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
 		svm_handle_mce(svm);

+	svm_complete_interrupts(svm);
+	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
+
 	vmcb_mark_all_clean(svm->vmcb);
 	return exit_fastpath;
 }

so I will just squash everything.

Paolo

