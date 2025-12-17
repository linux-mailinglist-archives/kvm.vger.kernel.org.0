Return-Path: <kvm+bounces-66107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C50CC6560
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 08:11:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF3A5301C3EA
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 07:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D22335BBE;
	Wed, 17 Dec 2025 07:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="vStQYSFH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5932EBDEB;
	Wed, 17 Dec 2025 07:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765955472; cv=none; b=uBr86QHp5ZPIkgfEe7ztSBQGoKkRZp44QLvrmX88/6Y//NaJN1r2gNdEt/ammEtfMJIpWGJcj7OSWrVqDOfjhDiX/4typR92hlG1pgFnd9VRIgLoIgvtRuQqvSO5I/ahB/l4PiPSyE1LuPENzamfTqdtY3mLVZbUfYPZCAM7lO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765955472; c=relaxed/simple;
	bh=n/uCSTGUlKz6X+N6VsaW1K8IRZ8ZSw+MIAkeg5VZieE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=eYgXlGowDqtTl4fww36qWyXNqZBvsOVcN8N8YQNZYc8l0jw11+5Jhf65y06QFVvxKofLHVhxljfaX/sdBzfBLY0CaXfRblSTNMK2yTkxVNdXEMDjIyO3ViCb60hLVfk4RotvhL67uQkt67R25GMWtL5qevHkMsH1aBpXMBDHRqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=vStQYSFH; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BH78c5S3570234
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 23:08:38 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BH78c5S3570234
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765955318;
	bh=VpSH+Lu45hqCWLTPfd5kjOJsW+xrjoQNGkj5El5ogLw=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=vStQYSFHt8nzrky/HzVb03ML+ZenXbe2NeQTm+Ht777VGAd7Sdirjqy3AqWS1WH9b
	 /gMvh59GRlHUys06J33Lbztnj2tOAoconqEpeii16Mu3bE9XoOupX6JE8zkfJtt4nt
	 spRImaR2TBoKebHk/tFhZM/WElhOJtVZNmk8t9tjgQwEpcSFf1V/RTmaYTndUge9bi
	 iENo3rP7DUDoLCNjqmL8w2ryl72ueZpWweYVhHNF3cOXJiJJFt4gn6AmzHqOnrIlX1
	 elfHuyJ+yt/CKPbmPJLX25Rq2PznvoIaejUJQ+iHCAPgS70Bjs/W9suA+gErL7zwkz
	 2ZbxcXtnoQcVg==
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] KVM: nVMX: Disallow access to vmcs12 fields that aren't
 supported by "hardware"
From: Xin Li <xin@zytor.com>
In-Reply-To: <20251216012918.1707681-1-seanjc@google.com>
Date: Tue, 16 Dec 2025 23:08:27 -0800
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <70FDA8A5-9B92-459B-A661-159365AE6385@zytor.com>
References: <20251216012918.1707681-1-seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)

> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index 4233b5ca9461..78eca9399975 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -9,7 +9,7 @@
> FIELD(number, name), \
> [ROL16(number##_HIGH, 6)] =3D VMCS12_OFFSET(name) + sizeof(u32)
>=20
> -const unsigned short vmcs12_field_offsets[] =3D {
> +const __initconst u16 supported_vmcs12_field_offsets[] =3D {

I initially misunderstood "supported" to mean the VMCS fields available =
at
runtime.  I'm unsure if it's necessary to make its meaning more =
explicit.
E.g., prefix with kvm_?


> FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
> FIELD(POSTED_INTR_NV, posted_intr_nv),
> FIELD(GUEST_ES_SELECTOR, guest_es_selector),
> @@ -158,4 +158,55 @@ const unsigned short vmcs12_field_offsets[] =3D {
> FIELD(HOST_SSP, host_ssp),
> FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
> };
> -const unsigned int nr_vmcs12_fields =3D =
ARRAY_SIZE(vmcs12_field_offsets);
> +
> +u16 vmcs12_field_offsets[ARRAY_SIZE(supported_vmcs12_field_offsets)] =
__ro_after_init;
> +unsigned int nr_vmcs12_fields __ro_after_init;
> +
> +#define VMCS12_CASE64(enc) case enc##_HIGH: case enc
> +
> +static __init bool cpu_has_vmcs12_field(unsigned int idx)
> +{
> + switch (VMCS12_IDX_TO_ENC(idx)) {
> + case VIRTUAL_PROCESSOR_ID: return cpu_has_vmx_vpid();
> + case POSTED_INTR_NV: return cpu_has_vmx_posted_intr();
> + VMCS12_CASE64(TSC_MULTIPLIER): return cpu_has_vmx_tsc_scaling();
> + VMCS12_CASE64(VIRTUAL_APIC_PAGE_ADDR): return =
cpu_has_vmx_tpr_shadow();
> + VMCS12_CASE64(APIC_ACCESS_ADDR): return =
cpu_has_vmx_virtualize_apic_accesses();
> + VMCS12_CASE64(POSTED_INTR_DESC_ADDR): return =
cpu_has_vmx_posted_intr();
> + VMCS12_CASE64(VM_FUNCTION_CONTROL): return cpu_has_vmx_vmfunc();
> + VMCS12_CASE64(EPT_POINTER): return cpu_has_vmx_ept();
> + VMCS12_CASE64(EPTP_LIST_ADDRESS): return cpu_has_vmx_vmfunc();
> + VMCS12_CASE64(XSS_EXIT_BITMAP): return cpu_has_vmx_xsaves();
> + VMCS12_CASE64(ENCLS_EXITING_BITMAP): return =
cpu_has_vmx_encls_vmexit();
> + VMCS12_CASE64(GUEST_IA32_PERF_GLOBAL_CTRL): return =
cpu_has_load_perf_global_ctrl();
> + VMCS12_CASE64(HOST_IA32_PERF_GLOBAL_CTRL): return =
cpu_has_load_perf_global_ctrl();

Combine the above 2 cases?

> + case TPR_THRESHOLD: return cpu_has_vmx_tpr_shadow();
> + case SECONDARY_VM_EXEC_CONTROL: return =
cpu_has_secondary_exec_ctrls();
> + case GUEST_S_CET: return cpu_has_load_cet_ctrl();
> + case GUEST_SSP: return cpu_has_load_cet_ctrl();
> + case GUEST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();
> + case HOST_S_CET: return cpu_has_load_cet_ctrl();
> + case HOST_SSP: return cpu_has_load_cet_ctrl();
> + case HOST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();

Combine all CET cases?=

