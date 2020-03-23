Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961E418F2EA
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 11:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgCWKgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 06:36:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:46256 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbgCWKgW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 06:36:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584959780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IoLPdCL/ZoJabMu/DNFfz6QUzqJwkSBnf/XifKtjoh0=;
        b=SDiigmo5VJ9csz1LCNbrwkNg6myo0KymTorjkgZJMIlECMxMjVx0B4IBbzMy86Y/9orIiJ
        W77wf18fhNYV6jo9mIfvKt1002b8bwB/t4VIz9j5iFneF6nIdyRnWM6RR0cnzR5wF5p+Oz
        v5NbRv7YEYpq5pbLVfEH1TnuV+3rwOo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-Vo_bIur1Omuy7kXygfAz7w-1; Mon, 23 Mar 2020 06:36:18 -0400
X-MC-Unique: Vo_bIur1Omuy7kXygfAz7w-1
Received: by mail-wm1-f70.google.com with SMTP id f9so3821099wme.7
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 03:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IoLPdCL/ZoJabMu/DNFfz6QUzqJwkSBnf/XifKtjoh0=;
        b=bl6c69LYngtpHiGk/plGJ7IuWW/u5huau4gTWrDfM+pHBl9QVZ3qqLa2RvBU2243S3
         fEy9HWYSC+9dJXwOmXzW68CoHpfQV7pcHcPBBft7nFn/CCy3xWyQqgRoSvpr8eKBUj60
         OIMbYVUy3QUTQ7WinyPXVUtlNHuoMAmHPNX+C8b00U8Mv3qKE5e7x4Ri+Ao9a1VbMhmL
         d0KOIWqTpqz0MjYWSH19ejihUOzDuhq3EbtW6xAk+T0hwk1zDMYwi0Cfwxl0B3aHGRIl
         bHttNkMfCw6j0bRdwYcaUm986d/JDfJVqyVQq25dHqUiydYhGkshwVgSwov9Zk5Np7Fh
         VD1g==
X-Gm-Message-State: ANhLgQ1nTBf6YjLxxqfuVXDfPoInUOKPjoIkJkJ/m1Mo7+uUtn4gWiJR
        8mlqpZoNTMAFxQVErWgzE1Xj04GliHuvgyE3Kl/Ls8gLTxDUNva6tZk+nGCRZxqZvTiPVfsai5T
        t/TL6F3bMbwLt
X-Received: by 2002:adf:a49b:: with SMTP id g27mr28726903wrb.113.1584959777105;
        Mon, 23 Mar 2020 03:36:17 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt0nTXvQ2mg3Batc+i3UrtYFz2joZxiKtpK1KtPhrmV5p5YCOOJhTrWb4nwtB33wpPB5AySEw==
X-Received: by 2002:adf:a49b:: with SMTP id g27mr28726862wrb.113.1584959776689;
        Mon, 23 Mar 2020 03:36:16 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v21sm15963201wmj.8.2020.03.23.03.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 03:36:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v9 4/6] x86/kvm/hyper-v: Add support for synthetic debugger capability
In-Reply-To: <20200320172839.1144395-5-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com> <20200320172839.1144395-5-arilou@gmail.com>
Date:   Mon, 23 Mar 2020 11:36:14 +0100
Message-ID: <87pnd39x41.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Add support for Hyper-V synthetic debugger (syndbg) interface.
> The syndbg interface is using MSRs to emulate a way to send/recv packets
> data.
>
> The debug transport dll (kdvm/kdnet) will identify if Hyper-V is enabled
> and if it supports the synthetic debugger interface it will attempt to
> use it, instead of trying to initialize a network adapter.
>

This commit seem to break tests, e.g. 

# ./tools/testing/selftests/kvm/x86_64/state_test 
==== Test Assertion Failure ====
  lib/x86_64/processor.c:1023: r == nmsrs
  pid=26436 tid=26436 - Argument list too long
     1	0x000000000040a87f: vcpu_save_state at processor.c:1022 (discriminator 3)
     2	0x00000000004011b3: main at state_test.c:171 (discriminator 4)
     3	0x00007f0315cc63d4: ?? ??:0
     4	0x0000000000401357: _start at ??:?
  Unexpected result from KVM_GET_MSRS, r: 60 (failed MSR was 0x400000ff)

The problem is that the newly introduced MSRs don't allow
reading/writing by the host when KVM_CAP_HYPERV_SYNDBG is disabled, I
think we'll need to relax the requirement and allow at reading/writing by
the host. Something like

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f17156d36419..ca1f10498705 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -301,11 +301,11 @@ static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
 	kvm_make_request(KVM_REQ_HV_EXIT, vcpu);
 }
 
-static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
+static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 {
 	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
 
-	if (!syndbg->active)
+	if (!syndbg->active && !host)
 		return 1;
 
 	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id,
@@ -313,7 +313,8 @@ static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	switch (msr) {
 	case HV_X64_MSR_SYNDBG_CONTROL:
 		syndbg->control.control = data;
-		syndbg_exit(vcpu, msr);
+		if (!host)
+			syndbg_exit(vcpu, msr);
 		break;
 	case HV_X64_MSR_SYNDBG_STATUS:
 		syndbg->control.status = data;
@@ -326,7 +327,8 @@ static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		break;
 	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
 		syndbg->control.pending_page = data;
-		syndbg_exit(vcpu, msr);
+		if (!host)
+			syndbg_exit(vcpu, msr);
 		break;
 	case HV_X64_MSR_SYNDBG_OPTIONS:
 		syndbg->options = data;
@@ -338,11 +340,11 @@ static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	return 0;
 }
 
-static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 {
 	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
 
-	if (!syndbg->active)
+	if (!syndbg->active && !host)
 		return 1;
 
 	switch (msr) {
@@ -1174,7 +1176,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		break;
 	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
-		return syndbg_set_msr(vcpu, msr, data);
+		return syndbg_set_msr(vcpu, msr, data, host);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
 			    msr, data);
@@ -1304,7 +1306,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	return 0;
 }
 
-static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
+static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 {
 	u64 data = 0;
 	struct kvm *kvm = vcpu->kvm;
@@ -1343,7 +1345,7 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		break;
 	case HV_X64_MSR_SYNDBG_OPTIONS:
 	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
-		return syndbg_get_msr(vcpu, msr, pdata);
+		return syndbg_get_msr(vcpu, msr, pdata, host);
 	default:
 		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -1433,7 +1435,7 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 		int r;
 
 		mutex_lock(&vcpu->kvm->arch.hyperv.hv_lock);
-		r = kvm_hv_get_msr_pw(vcpu, msr, pdata);
+		r = kvm_hv_get_msr_pw(vcpu, msr, pdata, host);
 		mutex_unlock(&vcpu->kvm->arch.hyperv.hv_lock);
 		return r;
 	} else

Note that I also omit syndbg_exit() when
HV_X64_MSR_SYNDBG_PENDING_BUFFER/HV_X64_MSR_SYNDBG_CONTROL are
written by the host to not get a self-induced exit to userspace, this is
likely not what we want on e.g. migration. Without it, we will fail
again:

==== Test Assertion Failure ====
  x86_64/state_test.c:151: run->exit_reason == KVM_EXIT_IO
  pid=7827 tid=7827 - Argument list too long
     1	0x0000000000401109: main at state_test.c:148
     2	0x00007ff5308d63d4: ?? ??:0
     3	0x0000000000401357: _start at ??:?
  Stage 2: unexpected exit reason: 27 (Unknown),

Alternatively, we may introduce a way to hide unsupported MSRs from
KVM_GET_MSRS but we don't do it for existing Hyper-V MSRs as of yet.

> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  Documentation/virt/kvm/api.rst  |  16 ++++
>  arch/x86/include/asm/kvm_host.h |  14 +++
>  arch/x86/kvm/hyperv.c           | 158 +++++++++++++++++++++++++++++++-
>  arch/x86/kvm/hyperv.h           |   6 ++
>  arch/x86/kvm/trace.h            |  51 +++++++++++
>  arch/x86/kvm/x86.c              |  13 +++
>  include/uapi/linux/kvm.h        |  11 +++
>  7 files changed, 268 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4872c47bbcff..fe992dcf4f93 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5024,6 +5024,7 @@ EOI was received.
>  		struct kvm_hyperv_exit {
>    #define KVM_EXIT_HYPERV_SYNIC          1
>    #define KVM_EXIT_HYPERV_HCALL          2
> +  #define KVM_EXIT_HYPERV_SYNDBG         3
>  			__u32 type;
>  			__u32 pad1;
>  			union {
> @@ -5039,6 +5040,15 @@ EOI was received.
>  					__u64 result;
>  					__u64 params[2];
>  				} hcall;
> +				struct {
> +					__u32 msr;
> +					__u32 pad2;
> +					__u64 control;
> +					__u64 status;
> +					__u64 send_page;
> +					__u64 recv_page;
> +					__u64 pending_page;
> +				} syndbg;
>  			} u;
>  		};
>  		/* KVM_EXIT_HYPERV */
> @@ -5055,6 +5065,12 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
>  event/message pages and to enable/disable SynIC messages/events processing
>  in userspace.
>  
> +	- KVM_EXIT_HYPERV_SYNDBG -- synchronously notify user-space about
> +
> +Hyper-V Synthetic debugger state change. Notification is used to either update
> +the pending_page location or to send a control command (send the buffer located
> +in send_page or recv a buffer to recv_page).
> +
>  ::
>  
>  		/* KVM_EXIT_ARM_NISV */
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 98959e8cd448..c09fa7401b13 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -854,6 +854,19 @@ struct kvm_apic_map {
>  	struct kvm_lapic *phys_map[];
>  };
>  
> +/* Hyper-V synthetic debugger (SynDbg)*/
> +struct kvm_hv_syndbg {
> +	struct {
> +		u64 control;
> +		u64 status;
> +		u64 send_page;
> +		u64 recv_page;
> +		u64 pending_page;
> +	} control;
> +	u64 options;
> +	bool active;
> +};
> +
>  /* Hyper-V emulation context */
>  struct kvm_hv {
>  	struct mutex hv_lock;
> @@ -877,6 +890,7 @@ struct kvm_hv {
>  	atomic_t num_mismatched_vp_indexes;
>  
>  	struct hv_partition_assist_pg *hv_pa_pg;
> +	struct kvm_hv_syndbg hv_syndbg;
>  };
>  
>  enum kvm_irqchip_mode {
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 7383c7e7d4af..cd8d0142a841 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -266,6 +266,115 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
>  	return ret;
>  }
>  
> +void kvm_hv_activate_syndbg(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +
> +	syndbg->active = true;
> +}
> +
> +static int kvm_hv_syndbg_complete_userspace(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_hv *hv = &kvm->arch.hyperv;
> +
> +	if (vcpu->run->hyperv.u.syndbg.msr == HV_X64_MSR_SYNDBG_CONTROL)
> +		hv->hv_syndbg.control.status =
> +			vcpu->run->hyperv.u.syndbg.status;
> +	return 1;
> +}
> +
> +static void syndbg_exit(struct kvm_vcpu *vcpu, u32 msr)
> +{
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
> +
> +	hv_vcpu->exit.type = KVM_EXIT_HYPERV_SYNDBG;
> +	hv_vcpu->exit.u.syndbg.msr = msr;
> +	hv_vcpu->exit.u.syndbg.control = syndbg->control.control;
> +	hv_vcpu->exit.u.syndbg.send_page = syndbg->control.send_page;
> +	hv_vcpu->exit.u.syndbg.recv_page = syndbg->control.recv_page;
> +	hv_vcpu->exit.u.syndbg.pending_page = syndbg->control.pending_page;
> +	vcpu->arch.complete_userspace_io =
> +			kvm_hv_syndbg_complete_userspace;
> +
> +	kvm_make_request(KVM_REQ_HV_EXIT, vcpu);
> +}
> +
> +static int syndbg_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> +{
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +
> +	if (!syndbg->active)
> +		return 1;
> +
> +	trace_kvm_hv_syndbg_set_msr(vcpu->vcpu_id,
> +				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr, data);
> +	switch (msr) {
> +	case HV_X64_MSR_SYNDBG_CONTROL:
> +		syndbg->control.control = data;
> +		syndbg_exit(vcpu, msr);
> +		break;
> +	case HV_X64_MSR_SYNDBG_STATUS:
> +		syndbg->control.status = data;
> +		break;
> +	case HV_X64_MSR_SYNDBG_SEND_BUFFER:
> +		syndbg->control.send_page = data;
> +		break;
> +	case HV_X64_MSR_SYNDBG_RECV_BUFFER:
> +		syndbg->control.recv_page = data;
> +		break;
> +	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +		syndbg->control.pending_page = data;
> +		syndbg_exit(vcpu, msr);
> +		break;
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +		syndbg->options = data;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int syndbg_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> +{
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
> +
> +	if (!syndbg->active)
> +		return 1;
> +
> +	switch (msr) {
> +	case HV_X64_MSR_SYNDBG_CONTROL:
> +		*pdata = syndbg->control.control;
> +		break;
> +	case HV_X64_MSR_SYNDBG_STATUS:
> +		*pdata = syndbg->control.status;
> +		break;
> +	case HV_X64_MSR_SYNDBG_SEND_BUFFER:
> +		*pdata = syndbg->control.send_page;
> +		break;
> +	case HV_X64_MSR_SYNDBG_RECV_BUFFER:
> +		*pdata = syndbg->control.recv_page;
> +		break;
> +	case HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +		*pdata = syndbg->control.pending_page;
> +		break;
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +		*pdata = syndbg->options;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	trace_kvm_hv_syndbg_get_msr(vcpu->vcpu_id,
> +				    vcpu_to_hv_vcpu(vcpu)->vp_index, msr,
> +				    *pdata);
> +
> +	return 0;
> +}
> +
>  static int synic_get_msr(struct kvm_vcpu_hv_synic *synic, u32 msr, u64 *pdata,
>  			 bool host)
>  {
> @@ -800,6 +909,8 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
>  	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		r = true;
>  		break;
>  	}
> @@ -1061,6 +1172,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  		if (!host)
>  			return 1;
>  		break;
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +		return syndbg_set_msr(vcpu, msr, data);
>  	default:
>  		vcpu_unimpl(vcpu, "Hyper-V unhandled wrmsr: 0x%x data 0x%llx\n",
>  			    msr, data);
> @@ -1227,6 +1341,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>  		data = hv->hv_tsc_emulation_status;
>  		break;
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +		return syndbg_get_msr(vcpu, msr, pdata);
>  	default:
>  		vcpu_unimpl(vcpu, "Hyper-V unhandled rdmsr: 0x%x\n", msr);
>  		return 1;
> @@ -1799,9 +1916,16 @@ static struct kvm_cpuid_entry2 evmcs_cpuid_entries[] = {
>  	{ .function = HYPERV_CPUID_NESTED_FEATURES },
>  };
>  
> +static struct kvm_cpuid_entry2 syndbg_cpuid_entries[] = {
> +	{ .function = HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS },
> +	{ .function = HYPERV_CPUID_SYNDBG_INTERFACE },
> +	{ .function = HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES	},
> +};
> +
>  #define HV_MAX_CPUID_ENTRIES \
>  	ARRAY_SIZE(core_cpuid_entries) +\
> -	ARRAY_SIZE(evmcs_cpuid_entries)
> +	ARRAY_SIZE(evmcs_cpuid_entries) +\
> +	ARRAY_SIZE(syndbg_cpuid_entries)
>  
>  int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  				struct kvm_cpuid_entry2 __user *entries)
> @@ -1809,6 +1933,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  	uint16_t evmcs_ver = 0;
>  	struct kvm_cpuid_entry2 cpuid_entries[HV_MAX_CPUID_ENTRIES];
>  	int i, nent = 0;
> +	struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
>  
>  	/* Set the core cpuid entries required for Hyper-V */
>  	memcpy(&cpuid_entries[nent], &core_cpuid_entries,
> @@ -1825,6 +1950,13 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		nent += ARRAY_SIZE(evmcs_cpuid_entries);
>  	}
>  
> +	if (syndbg->active) {
> +		/* Syndbg is enabled, add the required Syndbg CPUID leafs */
> +		memcpy(&cpuid_entries[nent], &syndbg_cpuid_entries,
> +		       sizeof(syndbg_cpuid_entries));
> +		nent += ARRAY_SIZE(syndbg_cpuid_entries);
> +	}
> +
>  	if (cpuid->nent < nent)
>  		return -E2BIG;
>  
> @@ -1878,6 +2010,12 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>  			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;
>  
> +			if (syndbg->active) {
> +				ent->ebx |= HV_X64_DEBUGGING;
> +				ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
> +				ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
> +			}
> +
>  			/*
>  			 * Direct Synthetic timers only make sense with in-kernel
>  			 * LAPIC
> @@ -1921,6 +2059,24 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  
>  			break;
>  
> +		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
> +			memcpy(signature, "Linux KVM Hv", 12);
> +
> +			ent->eax = 0;
> +			ent->ebx = signature[0];
> +			ent->ecx = signature[1];
> +			ent->edx = signature[2];
> +			break;
> +
> +		case HYPERV_CPUID_SYNDBG_INTERFACE:
> +			memcpy(signature, "VS#1\0\0\0\0\0\0\0\0", 12);
> +			ent->eax = signature[0];
> +			break;
> +
> +		case HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES:
> +			ent->eax |= HV_X64_SYNDBG_CAP_ALLOW_KERNEL_DEBUGGING;
> +			break;
> +
>  		default:
>  			break;
>  		}
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 5e4780bf6dd7..45aaaf08bf15 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -73,6 +73,11 @@ static inline struct kvm_vcpu *synic_to_vcpu(struct kvm_vcpu_hv_synic *synic)
>  	return hv_vcpu_to_vcpu(container_of(synic, struct kvm_vcpu_hv, synic));
>  }
>  
> +static inline struct kvm_hv_syndbg *vcpu_to_hv_syndbg(struct kvm_vcpu *vcpu)
> +{
> +	return &vcpu->kvm->arch.hyperv.hv_syndbg;
> +}
> +
>  int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host);
>  int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host);
>  
> @@ -83,6 +88,7 @@ void kvm_hv_irq_routing_update(struct kvm *kvm);
>  int kvm_hv_synic_set_irq(struct kvm *kvm, u32 vcpu_id, u32 sint);
>  void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vector);
>  int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages);
> +void kvm_hv_activate_syndbg(struct kvm_vcpu *vcpu);
>  
>  void kvm_hv_vcpu_init(struct kvm_vcpu *vcpu);
>  void kvm_hv_vcpu_postcreate(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index f194dd058470..bf6c3852868d 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1515,6 +1515,57 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
>  		__print_symbolic(__entry->err, VMX_VMENTER_INSTRUCTION_ERRORS))
>  );
>  
> +/*
> + * Tracepoint for syndbg_set_msr.
> + */
> +TRACE_EVENT(kvm_hv_syndbg_set_msr,
> +	TP_PROTO(int vcpu_id, u32 vp_index, u32 msr, u64 data),
> +	TP_ARGS(vcpu_id, vp_index, msr, data),
> +
> +	TP_STRUCT__entry(
> +		__field(int, vcpu_id)
> +		__field(u32, vp_index)
> +		__field(u32, msr)
> +		__field(u64, data)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_id = vcpu_id;
> +		__entry->vp_index = vp_index;
> +		__entry->msr = msr;
> +		__entry->data = data;
> +	),
> +
> +	TP_printk("vcpu_id %d vp_index %u msr 0x%x data 0x%llx",
> +		  __entry->vcpu_id, __entry->vp_index, __entry->msr,
> +		  __entry->data)
> +);
> +
> +/*
> + * Tracepoint for syndbg_get_msr.
> + */
> +TRACE_EVENT(kvm_hv_syndbg_get_msr,
> +	TP_PROTO(int vcpu_id, u32 vp_index, u32 msr, u64 data),
> +	TP_ARGS(vcpu_id, vp_index, msr, data),
> +
> +	TP_STRUCT__entry(
> +		__field(int, vcpu_id)
> +		__field(u32, vp_index)
> +		__field(u32, msr)
> +		__field(u64, data)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_id = vcpu_id;
> +		__entry->vp_index = vp_index;
> +		__entry->msr = msr;
> +		__entry->data = data;
> +	),
> +
> +	TP_printk("vcpu_id %d vp_index %u msr 0x%x data 0x%llx",
> +		  __entry->vcpu_id, __entry->vp_index, __entry->msr,
> +		  __entry->data)
> +);
>  #endif /* _TRACE_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3156e25b0774..7bfa30d7a525 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1214,6 +1214,10 @@ static const u32 emulated_msrs_all[] = {
>  	HV_X64_MSR_VP_ASSIST_PAGE,
>  	HV_X64_MSR_REENLIGHTENMENT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
>  	HV_X64_MSR_TSC_EMULATION_STATUS,
> +	HV_X64_MSR_SYNDBG_OPTIONS,
> +	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
> +	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
> +	HV_X64_MSR_SYNDBG_PENDING_BUFFER,
>  
>  	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
>  	MSR_KVM_PV_EOI_EN,
> @@ -2906,6 +2910,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 */
>  		break;
>  	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>  	case HV_X64_MSR_CRASH_CTL:
>  	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
> @@ -3151,6 +3157,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = 0x20000000;
>  		break;
>  	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
> +	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
> +	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>  	case HV_X64_MSR_CRASH_CTL:
>  	case HV_X64_MSR_STIMER0_CONFIG ... HV_X64_MSR_STIMER3_COUNT:
> @@ -3323,6 +3331,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_HYPERV_TLBFLUSH:
>  	case KVM_CAP_HYPERV_SEND_IPI:
>  	case KVM_CAP_HYPERV_CPUID:
> +	case KVM_CAP_HYPERV_SYNDBG:
>  	case KVM_CAP_PCI_SEGMENT:
>  	case KVM_CAP_DEBUGREGS:
>  	case KVM_CAP_X86_ROBUST_SINGLESTEP:
> @@ -4178,6 +4187,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  		return -EINVAL;
>  
>  	switch (cap->cap) {
> +	case KVM_CAP_HYPERV_SYNDBG:
> +		kvm_hv_activate_syndbg(vcpu);
> +		return 0;
> +
>  	case KVM_CAP_HYPERV_SYNIC2:
>  		if (cap->args[0])
>  			return -EINVAL;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7ee0ddc4c457..0b573e1155c8 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -188,6 +188,7 @@ struct kvm_s390_cmma_log {
>  struct kvm_hyperv_exit {
>  #define KVM_EXIT_HYPERV_SYNIC          1
>  #define KVM_EXIT_HYPERV_HCALL          2
> +#define KVM_EXIT_HYPERV_SYNDBG         3
>  	__u32 type;
>  	__u32 pad1;
>  	union {
> @@ -203,6 +204,15 @@ struct kvm_hyperv_exit {
>  			__u64 result;
>  			__u64 params[2];
>  		} hcall;
> +		struct {
> +			__u32 msr;
> +			__u32 pad2;
> +			__u64 control;
> +			__u64 status;
> +			__u64 send_page;
> +			__u64 recv_page;
> +			__u64 pending_page;
> +		} syndbg;
>  	} u;
>  };
>  
> @@ -1012,6 +1022,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_NISV_TO_USER 177
>  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
>  #define KVM_CAP_S390_VCPU_RESETS 179
> +#define KVM_CAP_HYPERV_SYNDBG 180
>  
>  #ifdef KVM_CAP_IRQ_ROUTING

-- 
Vitaly

