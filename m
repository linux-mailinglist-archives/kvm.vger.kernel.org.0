Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737B149C890
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 12:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbiAZLYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 06:24:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240651AbiAZLYh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 06:24:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643196276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxTDe9k+l0cVdh9Y8SvKgJ9xCWAojpaeVXmZRT97wW8=;
        b=DdEjY1b6TD165agxscvdvGrrHI+NS0+Y3pyOGNT9e4jzoNIvov0cDtwsY/CRhPrLcJQkO9
        Xnsu0bv9y07J6Tq6A95xqO6VRxLhinRz++5+feMEteH1rGc7Mmr/OrNSHvsdXRZrIDxvoU
        wGZGPK/LwSZ8nvYLBLl/f/9F06aF6dI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-zqk8Uq_vMaSX96TU32FyrQ-1; Wed, 26 Jan 2022 06:24:35 -0500
X-MC-Unique: zqk8Uq_vMaSX96TU32FyrQ-1
Received: by mail-ej1-f69.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so4716721ejw.9
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 03:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HxTDe9k+l0cVdh9Y8SvKgJ9xCWAojpaeVXmZRT97wW8=;
        b=tvQ+jvl2+oyZc1Sg3j0KDN9gI714/Cc1J23pQ7v5KYyKbdOgiEinXfwdevRNYhGV0Z
         jd+DhzAfBjIQeuJbuPb4VziBuJPvRi+I1Bzze8DVt6294FSYCh/MEBlQQ7wQhA0fb+Lo
         S4yH+5qS1Lbt9WLnvQqogVfmhUmhdIeIhrVXtLOK31XqF0+9Pb/QhmxgvpTGZ4BVIbua
         831PPMd87cg8FIaR+HnJkcsEseSKFOkEeHdkEisE0Uj1J/iYwmGOaESuR9mAnBbu38OD
         Wf44TlVbGq3Thn9FBJSlt8T8yVsX7Hw7RC7Hx7mA60jitcYP8WW5q3ZKOEkXa/ujmMlL
         29Iw==
X-Gm-Message-State: AOAM533hWsGl0Ew/YJGeb1psDg7zQdvYyIz4DcDu+I0NrrSzjLxX2nB9
        EjH8LWfUXjLnh9H7egV80d2ml6WYGEjLL/R9WTfXyBOfhM9Ozl1DTJcOHMmuoGjVZqCuS70n41Q
        6msEBojkNjcc5
X-Received: by 2002:a05:6402:520d:: with SMTP id s13mr9081337edd.132.1643196273458;
        Wed, 26 Jan 2022 03:24:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKSzmBxOPBhACr9IHnQU3b1GX25Gi03x6GFuTUx+42hSb1bME22xSETT3CEAR2OKoa1XmzGQ==
X-Received: by 2002:a05:6402:520d:: with SMTP id s13mr9081311edd.132.1643196273117;
        Wed, 26 Jan 2022 03:24:33 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id bs4sm5151345edb.84.2022.01.26.03.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 03:24:32 -0800 (PST)
Message-ID: <fd8c060d-06a4-89e1-67fa-3af8a571a449@redhat.com>
Date:   Wed, 26 Jan 2022 12:24:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: Forcibly leave nested virt when SMM state is
 toggled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
References: <20220125220358.2091737-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125220358.2091737-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 23:03, Sean Christopherson wrote:
> Forcibly leave nested virtualization operation if userspace toggles SMM
> state via KVM_SET_VCPU_EVENTS or KVM_SYNC_X86_EVENTS.  If userspace
> forces the vCPU out of SMM while it's post-VMXON and then injects an SMI,
> vmx_enter_smm() will overwrite vmx->nested.smm.vmxon and end up with both
> vmxon=false and smm.vmxon=false, but all other nVMX state allocated.
> 
> Don't attempt to gracefully handle the transition as (a) most transitions
> are nonsencial, e.g. forcing SMM while L2 is running, (b) there isn't
> sufficient information to handle all transitions, e.g. SVM wants access
> to the SMRAM save state, and (c) KVM_SET_VCPU_EVENTS must precede
> KVM_SET_NESTED_STATE during state restore as the latter disallows putting
> the vCPU into L2 if SMM is active, and disallows tagging the vCPU as
> being post-VMXON in SMM if SMM is not active.
> 
> Abuse of KVM_SET_VCPU_EVENTS manifests as a WARN and memory leak in nVMX
> due to failure to free vmcs01's shadow VMCS, but the bug goes far beyond
> just a memory leak, e.g. toggling SMM on while L2 is active puts the vCPU
> in an architecturally impossible state.
> 
>    WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
>    WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
>    Modules linked in:
>    CPU: 1 PID: 3606 Comm: syz-executor725 Not tainted 5.17.0-rc1-syzkaller #0
>    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>    RIP: 0010:free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
>    RIP: 0010:free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
>    Code: <0f> 0b eb b3 e8 8f 4d 9f 00 e9 f7 fe ff ff 48 89 df e8 92 4d 9f 00
>    Call Trace:
>     <TASK>
>     kvm_arch_vcpu_destroy+0x72/0x2f0 arch/x86/kvm/x86.c:11123
>     kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]
>     kvm_destroy_vcpus+0x11f/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:460
>     kvm_free_vcpus arch/x86/kvm/x86.c:11564 [inline]
>     kvm_arch_destroy_vm+0x2e8/0x470 arch/x86/kvm/x86.c:11676
>     kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1217 [inline]
>     kvm_put_kvm+0x4fa/0xb00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1250
>     kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1273
>     __fput+0x286/0x9f0 fs/file_table.c:311
>     task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>     exit_task_work include/linux/task_work.h:32 [inline]
>     do_exit+0xb29/0x2a30 kernel/exit.c:806
>     do_group_exit+0xd2/0x2f0 kernel/exit.c:935
>     get_signal+0x4b0/0x28c0 kernel/signal.c:2862
>     arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
>     handle_signal_work kernel/entry/common.c:148 [inline]
>     exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>     exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
>     __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>     syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>     do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>     </TASK>
> 
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Peeking at QEMU source, AFAICT QEMU restores nested state before events,
> but I don't see how that can possibly work.  I assume QEMU does something
> where it restores the "run" state first and then does a full restore?
> 
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/svm/nested.c       | 9 +++++----
>   arch/x86/kvm/svm/svm.c          | 2 +-
>   arch/x86/kvm/svm/svm.h          | 2 +-
>   arch/x86/kvm/vmx/nested.c       | 1 +
>   arch/x86/kvm/x86.c              | 4 +++-
>   6 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 682ad02a4e58..df22b04b11c3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1495,6 +1495,7 @@ struct kvm_x86_ops {
>   };
>   
>   struct kvm_x86_nested_ops {
> +	void (*leave_nested)(struct kvm_vcpu *vcpu);
>   	int (*check_events)(struct kvm_vcpu *vcpu);
>   	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
>   	void (*triple_fault)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index cf206855ebf0..1218b5a342fc 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -983,9 +983,9 @@ void svm_free_nested(struct vcpu_svm *svm)
>   /*
>    * Forcibly leave nested mode in order to be able to reset the VCPU later on.
>    */
> -void svm_leave_nested(struct vcpu_svm *svm)
> +void svm_leave_nested(struct kvm_vcpu *vcpu)
>   {
> -	struct kvm_vcpu *vcpu = &svm->vcpu;
> +	struct vcpu_svm *svm = to_svm(vcpu);
>   
>   	if (is_guest_mode(vcpu)) {
>   		svm->nested.nested_run_pending = 0;
> @@ -1411,7 +1411,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   		return -EINVAL;
>   
>   	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
> -		svm_leave_nested(svm);
> +		svm_leave_nested(vcpu);
>   		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
>   		return 0;
>   	}
> @@ -1478,7 +1478,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   	 */
>   
>   	if (is_guest_mode(vcpu))
> -		svm_leave_nested(svm);
> +		svm_leave_nested(vcpu);
>   	else
>   		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
>   
> @@ -1532,6 +1532,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>   }
>   
>   struct kvm_x86_nested_ops svm_nested_ops = {
> +	.leave_nested = svm_leave_nested,
>   	.check_events = svm_check_nested_events,
>   	.triple_fault = nested_svm_triple_fault,
>   	.get_nested_state_pages = svm_get_nested_state_pages,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6d31d357a83b..78123ed3906f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -290,7 +290,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>   
>   	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
>   		if (!(efer & EFER_SVME)) {
> -			svm_leave_nested(svm);
> +			svm_leave_nested(vcpu);
>   			svm_set_gif(svm, true);
>   			/* #GP intercept is still needed for vmware backdoor */
>   			if (!enable_vmware_backdoor)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 47ef8f4a9358..c55d9936bb8b 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -525,7 +525,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
>   
>   int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
>   			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
> -void svm_leave_nested(struct vcpu_svm *svm);
> +void svm_leave_nested(struct kvm_vcpu *vcpu);
>   void svm_free_nested(struct vcpu_svm *svm);
>   int svm_allocate_nested(struct vcpu_svm *svm);
>   int nested_svm_vmrun(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f235f77cbc03..7eebfdf7204f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6771,6 +6771,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
>   }
>   
>   struct kvm_x86_nested_ops vmx_nested_ops = {
> +	.leave_nested = vmx_leave_nested,
>   	.check_events = vmx_check_nested_events,
>   	.hv_timer_pending = nested_vmx_preemption_timer_pending,
>   	.triple_fault = nested_vmx_triple_fault,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 55518b7d3b96..22040c682d4a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4860,8 +4860,10 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>   		vcpu->arch.apic->sipi_vector = events->sipi_vector;
>   
>   	if (events->flags & KVM_VCPUEVENT_VALID_SMM) {
> -		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm)
> +		if (!!(vcpu->arch.hflags & HF_SMM_MASK) != events->smi.smm) {
> +			kvm_x86_ops.nested_ops->leave_nested(vcpu);
>   			kvm_smm_changed(vcpu, events->smi.smm);
> +		}
>   
>   		vcpu->arch.smi_pending = events->smi.pending;
>   
> 
> base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4

Queued, thanks.

Paolo

