Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CEE51056D
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 19:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344407AbiDZRdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 13:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244815AbiDZRdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 13:33:14 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86821129
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:30:02 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso1950365wme.5
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bc1rqbuReor9CC2s2gzOR+H/Jw8Ckn34i3rYm67mPWU=;
        b=CZw4762XWWavWYjoe86A33UFbsr3H7Gg3TP3Zb1xeuingmZidF9NBwXgosIGcuWUz0
         GqJmVWNVYIuMKrM9QFLFBS+yHRcL4PtUT2s+/imf6h0vjY1TPd8ezo13R2ASsqdsjjq/
         Yj3ODHcUAFFKZSoN/gNjHFRCCE1Z1jOVYOMw6hjTIwY/wDQivJn4rQj8Ra6i62//l3k8
         0dJnMUBedkW0y6IvmEAsunVbhBqpkk3yRdvyNZtOH4ROXNuFUU8ngZjrUmkc3K6+WB5S
         EIq/Y0yH0643dKD9JIyENUVSGdxKXDf76RCdCy7Ec/VCfTtiGwIReC3AXtiUrUkustEQ
         abfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bc1rqbuReor9CC2s2gzOR+H/Jw8Ckn34i3rYm67mPWU=;
        b=M6x8xYtIuI4E2kyLovru+TKuL83EVwN/P1JFWYvW0T/mH1lsQUDW0xO7mU0Ko+xuKO
         CPYRgBtq5e1eQIGsrtHR9JimQ8vK4BgMdMwiBWo3b+hGCZJhGbQ4RqHiBJfAgr1et+pw
         w2hY4SZP9EQisbWvME0yHDKYusZJuXmzqLMhWlt4aQ6o2tvN9u1TCJ78T6/t9g7fxwzB
         kW2HYyxBWRlMebhw47v1PpasT25zCcBa/3bNK5cb5PZgRnQV+1/NpK7LsjgHNzGPcXAY
         ZKnTeHPwlV6Eb9Cn7AxVzvY+PukZJdr4G/BnQ2oFgBjoQTWqNtPZ2QyrqzjTem2YbJHK
         34sQ==
X-Gm-Message-State: AOAM530Eoyuddk517xdt3JaoCX37DqwuvcNCYBdfwV870TEZv3BTkHJU
        B9/lhdNklYlPlaOjvu7L960=
X-Google-Smtp-Source: ABdhPJwchjVnW9X66LiqoGj9q4dIXYeWaNxgKbo+w4CUHwybawMHF0AsRnDmu+40xypuyUgFePiK/g==
X-Received: by 2002:a05:600c:a06:b0:37b:fdd8:4f8 with SMTP id z6-20020a05600c0a0600b0037bfdd804f8mr16477881wmp.41.1650994201355;
        Tue, 26 Apr 2022 10:30:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id h10-20020a05600c414a00b0038ebb6884d8sm127959wmm.0.2022.04.26.10.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 10:30:00 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <75de1384-b5c5-009d-7082-c3f5df5cce45@redhat.com>
Date:   Tue, 26 Apr 2022 19:29:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Another nice lockdep print in nested SVM code
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>
References: <8aab89fba5e682a4215dcf974ca5a2c9ae0f6757.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8aab89fba5e682a4215dcf974ca5a2c9ae0f6757.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 18:39, Maxim Levitsky wrote:
> [ 1355.807187]  kvm_vcpu_map+0x159/0x190 [kvm]
> [ 1355.807628]  nested_svm_vmexit+0x4c/0x7f0 [kvm_amd]
> [ 1355.808036]  ? kvm_vcpu_block+0x54/0xa0 [kvm]
> [ 1355.808450]  svm_check_nested_events+0x97/0x390 [kvm_amd]
> [ 1355.808920]  kvm_check_nested_events+0x1c/0x40 [kvm]

When called from kvm_vcpu_halt, it is not even necessary to do the
vmexit immediately.  kvm_arch_vcpu_runnable should do the right thing
anyway (e.g. kvm_arch_interrupt_allowed checks is_guest_mode for both
VMX and SVM).

The only case that is missing is MTF; it needs to be added to
hv_timer_pending, like this

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4ff36610af6a..e2e4f60159e9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1504,7 +1504,7 @@ struct kvm_x86_ops {
  struct kvm_x86_nested_ops {
  	void (*leave_nested)(struct kvm_vcpu *vcpu);
  	int (*check_events)(struct kvm_vcpu *vcpu);
-	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
+	bool (*has_events)(struct kvm_vcpu *vcpu);
  	void (*triple_fault)(struct kvm_vcpu *vcpu);
  	int (*get_state)(struct kvm_vcpu *vcpu,
  			 struct kvm_nested_state __user *user_kvm_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 856c87563883..2744b905865c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3857,6 +3857,10 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
  	       to_vmx(vcpu)->nested.preemption_timer_expired;
  }
  
+static bool nested_vmx_has_events(struct kvm_vcpu *vcpu)
+{
+	return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;
+
  static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
  {
  	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6809,7 +6813,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
  struct kvm_x86_nested_ops vmx_nested_ops = {
  	.leave_nested = vmx_leave_nested,
  	.check_events = vmx_check_nested_events,
-	.hv_timer_pending = nested_vmx_preemption_timer_pending,
+	.has_events = nested_vmx_has_events,
  	.triple_fault = nested_vmx_triple_fault,
  	.get_state = vmx_get_nested_state,
  	.set_state = vmx_set_nested_state,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7f21d9fe816f..231c55c4b33d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9471,8 +9471,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
  	}
  
  	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
  		*req_immediate_exit = true;
  
  	WARN_ON(vcpu->arch.exception.pending);
@@ -12185,8 +12185,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
  		return true;
  
  	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending &&
-	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu))
  		return true;
  
  	return false;


> [ 1355.809396]  kvm_arch_vcpu_runnable+0x4e/0x190 [kvm]
> [ 1355.809892]  kvm_vcpu_check_block+0x4f/0x100 [kvm]
> [ 1355.810349]  ? kvm_vcpu_check_block+0x5/0x100 [kvm]
> [ 1355.810806]  ? kvm_vcpu_block+0x54/0xa0 [kvm]
> [ 1355.811259]  kvm_vcpu_block+0x6b/0xa0 [kvm]
> [ 1355.811666]  kvm_vcpu_halt+0x3f/0x490 [kvm]
> [ 1355.812049]  kvm_arch_vcpu_ioctl_run+0xb0b/0x1d00 [kvm]
> [ 1355.812539]  ? rcu_read_lock_sched_held+0x16/0x80
> [ 1355.813013]  ? lock_release+0x1c4/0x270
> [ 1355.813365]  ? __wake_up_common+0x8d/0x180
> [ 1355.813743]  ? _raw_spin_unlock_irq+0x28/0x40

