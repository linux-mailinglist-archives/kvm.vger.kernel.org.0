Return-Path: <kvm+bounces-70240-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEoiNopvg2lgmwMAu9opvQ
	(envelope-from <kvm+bounces-70240-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 17:10:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EAF7E9F75
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 17:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B3B9D309ECE5
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735202D8DA8;
	Wed,  4 Feb 2026 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U94BpjJS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="COaDX+4x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE812BD012
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219135; cv=none; b=Cg9cJW6m+tjwHesrwpz/oBz1ONdG6a2LGvMaL3LrfORmUJfDJ/4oCwp4Dbpdvx85TciiR3YeLrPBkHc+lF0hzAkgK6iDOuH5btp492iFJToqBezK9enscMl9CcGGRXeeNVKN6nbNm4aE7CUxPZAczVcc1k3+M8mO+6AOZGFmmpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219135; c=relaxed/simple;
	bh=jQ/H+uFlXQoG+y9fBq7/d6vFWT2gHX2YV0WdQx3ii8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbeZmGKLhdxcMAGX9g8+U9SVG3ZfT46kFX5x60BOxEiBiVuHYWpdDvcr6Z4MLiYXIkU+7WC41jPd0ygLLfJVFYDxETdWnL2n9KLHsoDnrht3bNDz112+Zxc+VxLazpEnBJCeHkXd8Y/1czildJOQe00LJVsN/iODMhp7Z4lvQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U94BpjJS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=COaDX+4x; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614EGYEN926584
	for <kvm@vger.kernel.org>; Wed, 4 Feb 2026 15:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Bi4g99czQrt2gJHSucwRU9Ng
	jJmZN0TE+9w+nsNMdA4=; b=U94BpjJSBKk18ZTtVDUHRaUn1pI65boZWx5o8lUP
	bI0SpeiXzNAsbpv6LuAeNh58LThBHrP2KPOz/tnpTAQhWUb5MYTO0HHlNnaI/zKY
	+bCuPdaSLYQjt8UBYbT5SLWv6bxVcWd0oU8Z4DQ+IHx4ATCbLDfdKUzua7IJlIBq
	oPCYyq77dVQaCeQCcoVH8LMPDWJk3VcdnWiGDvvlYJUJ3SGl+CWI5VaB4wetx67d
	DyWWl3qDwrlSKm6IX5GAR/ZCZJj8ptxkIDPMKXj9u4KZGVRCZ9IfwnwuqCS8Xie7
	QBPleBDsSTTuiu11R68/glAKNlPFH0/wW99w5IR2wZuPhA==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c47qv87ve-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 15:32:14 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-124743cf760so25384599c88.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 07:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770219134; x=1770823934; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bi4g99czQrt2gJHSucwRU9NgjJmZN0TE+9w+nsNMdA4=;
        b=COaDX+4xtOL71EkgUBDTXInzt8jX1Ayon9sDulwFlgoRZbX5Be7HIgTkgbvPL1LfGG
         LiF/61rQ6oRdedOT3shCA5G6nBAM7XOu8SP0S8+rseGHEcNIEimQlBJvW79MR/aGSvgO
         IAxrdI1xR0hR9fLbNqGfrHx4IchAVizy0l5JC9scZUnXB7StthTt5pAI2EkkbxSLy95i
         Fajd5zPs4Pj24j1TRZxZAOY0g+CvxEyLNnRaCHi6JwRnwTI6JpMM140xL4fmxbAZZCtp
         UttNj9wZJ+EU4FBjui+t3UH8UZTLmcmVVeEYbs8rpiCbTWAIuelmNExztCFmF+GOvb/q
         B3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770219134; x=1770823934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bi4g99czQrt2gJHSucwRU9NgjJmZN0TE+9w+nsNMdA4=;
        b=rM+aIgkFONhY2GZhic3WxRkdX7RA7JTfsDLlB702aI+5pBReC0NgJU3HsdXhK3r8Tw
         TsAtK3RVgDhf7rIdNxsBvhJILl5KiwB3PU9ZK9jN/kzygbJ5cBUc9PeCxsd9NdqY+pGA
         D2HN1uL/FPa1WSx6gr3v7EjIkK1ekGK+VADQMVcAGko2pOWIesbQyCJNFyewkthxWWvp
         4bS8qY6fs3t2xx6WduTiq/NmJMhKZEfGkwAzGvGt2hPPJEvdB7CYACDfsPJ0hnH//CRM
         Kb5ErnQ5VhXGsgUmBNnWVCZJHrygoJjA4+SaZwUgZ+EF9ocI5lJtGMJ74O3F6PXRtSY7
         nlQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR8ihnrz4C6KGaDPpZQBH1jt+xQoFbVId389Yftj9+kz6x40xMTMt26iUJN4f0NZ7NjXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQhoQ6IY6ibkEQzK+ze5k0JvTzE+hxUBue4jrBtAxgK+YExHgg
	jxGUnCx304M4ZCUHpYwovxu+DCavY961+AX06qXyHWJAzYEZDAyfA7uq8d20tR1+u2ngO24eXh6
	eXSIhOzSHJfZMENvonmHjAr+FKnFxX2NJlkGQ3qRXGuGPOO6aEWOuymc=
X-Gm-Gg: AZuq6aLckDAoD/tCAv/s2WKdc632uv8NeKet4cmFEo8MGnWcfM2L4DYKS8cgXZ1fK+d
	dVqIVgG/UycYWDfaXNXNGQywlLQ7fhenHCmOBttXK8wD3+rAgLuKXFI/T1Ai7bw4CWzz1eAxrdt
	FrP7TXKIoBsTXRDD+kl9v0kw5XQmJBZhOT7OBill5Iynh87ywJQ0eS26wCsJxkshXC8gDG30RiG
	bBc2huc45Y1DM0ZaH/DDLIhp2HNwwhd9loY5UPLe7cugXtngwiWfJk03FuoIo8R5MZfd5BtJtni
	+RitykjrBYrH43M1O3QUw3z1xwu8FWTthE3PiYOOxfvo2/JVm5R33zdBHAnv/00qhO+m1yzIRsQ
	4hr1B0rMioXBZ7RoPje8=
X-Received: by 2002:a05:7022:41a5:b0:119:e56b:c74d with SMTP id a92af1059eb24-126f477ec7dmr1578529c88.18.1770219133736;
        Wed, 04 Feb 2026 07:32:13 -0800 (PST)
X-Received: by 2002:a05:7022:41a5:b0:119:e56b:c74d with SMTP id a92af1059eb24-126f477ec7dmr1578502c88.18.1770219133062;
        Wed, 04 Feb 2026 07:32:13 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832faea55sm1748208eec.23.2026.02.04.07.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 07:32:12 -0800 (PST)
Date: Wed, 4 Feb 2026 09:32:10 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: pbonzini@redhat.com, corbet@lwn.net, anup@brainfault.org,
        atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org,
        radim.krcmar@oss.qualcomm.com, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Message-ID: <ocfqo4zpsg6yyaz6kd65jrvudtb35uerdsueazqdk6w7c5lvdf@wvwzhc57gxez>
References: <20260204134507.33912-1-fangyu.yu@linux.alibaba.com>
 <20260204134507.33912-4-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204134507.33912-4-fangyu.yu@linux.alibaba.com>
X-Authority-Analysis: v=2.4 cv=GaEaXAXL c=1 sm=1 tr=0 ts=6983667e cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=JHdZcz8r7pWqP9VHEEMA:9
 a=CjuIK1q_8ugA:10 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-GUID: oVgm6Gai476bV87tOYnCkcQo0cmrNRRU
X-Proofpoint-ORIG-GUID: oVgm6Gai476bV87tOYnCkcQo0cmrNRRU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExOCBTYWx0ZWRfX1pz4PJ6cQKXR
 XlQBN6n9PkGlTc28FKDH0v6knqTPqJX8g5b5dxBQRIitd86AS30uYMDQiX73kHbcov5y+SL59pJ
 jK7tqjfLBztjNYZcRs+tjNZ6mOlGpTRsKlbqojv82pwh5kjBBRZfIXbkd1vCGW0KtghvhsjllHJ
 VftWyLnOtrbbKV5UgGiDsNBT4bpwrz2r/Dwldk2hp+ukz3tcfrru5jUOOtxCeK8vaYTaUYKAlY4
 jH7CC2XJgXIJBR6L9f9SnbicBiSOiHTvjeCKZkqipkLhYVZeXuCy4lpKCTuLaYMAmX45wnyxNLy
 pLC+ayqPbF+yqjIRHcOUkJUPpkxzm/MWbxRD/aWlcM4MrwQKsAE5sHi2w5j2kqygrbQQxOBLHoE
 4BzXV8lkS1nSXSzzL3p40wYS+oPLSi2gmq5oUIHBHtyeHlid9siWIhkJbiyUcoq6BFD3UcyK0ec
 lyX9k1UjXK216qJOLyA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0 spamscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602040118
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70240-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,qualcomm.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,oss.qualcomm.com:dkim];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0EAF7E9F75
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:45:07PM +0800, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> 
> Add a VM capability that allows userspace to select the G-stage page table
> format by setting HGATP.MODE on a per-VM basis.
> 
> Userspace enables the capability via KVM_ENABLE_CAP, passing the requested
> HGATP.MODE in args[0]. The request is rejected with -EINVAL if the mode is
> not supported by the host, and with -EBUSY if the VM has already been
> committed (e.g. vCPUs have been created or any memslot is populated).
> 
> KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE) returns a bitmask of the
> HGATP.MODE formats supported by the host.
> 
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>  Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
>  arch/riscv/kvm/vm.c            | 19 +++++++++++++++++--
>  include/uapi/linux/kvm.h       |  1 +
>  3 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 01a3abef8abb..62dc120857c1 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8765,6 +8765,33 @@ helpful if user space wants to emulate instructions which are not
>  This capability can be enabled dynamically even if VCPUs were already
>  created and are running.
>  
> +7.47 KVM_CAP_RISCV_SET_HGATP_MODE
> +---------------------------------
> +
> +:Architectures: riscv
> +:Type: VM
> +:Parameters: args[0] contains the requested HGATP mode
> +:Returns:
> +  - 0 on success.
> +  - -EINVAL if args[0] is outside the range of HGATP modes supported by the
> +    hardware.
> +  - -EBUSY if vCPUs have already been created for the VM, if the VM has any
> +    non-empty memslots.
> +

Currently the documentation for KVM_SET_ONE_REG has this for EBUSY

  EBUSY    (riscv) changing register value not allowed after the vcpu
           has run at least once

I suggest we update the KVM_SET_ONE_REG EBUSY description to say

(riscv) changing register value not allowed. This may occur after the vcpu
has run at least once or when other setup has completed which depends on
the value of the register.

> +This capability allows userspace to explicitly select the HGATP mode for
> +the VM. The selected mode must be supported by both KVM and hardware. This
> +capability must be enabled before creating any vCPUs or memslots.
> +
> +If this capability is not enabled, KVM will select the default HGATP mode
> +automatically. The default is the highest HGATP.MODE value supported by
> +hardware.
> +
> +``KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE)`` returns a bitmask of
> +HGATP.MODE values supported by the host. A return value of 0 indicates that
> +the capability is not supported. Supported-mode bitmask use HGATP.MODE
> +encodings as defined by the RISC-V privileged specification, such as Sv39x4
> +corresponds to HGATP.MODE=8, so userspace should test bitmask & BIT(8).
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 4b2156df40fc..7d1e1d257df5 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -202,6 +202,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VM_GPA_BITS:
>  		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
>  		break;
> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
> +		r = kvm_riscv_get_hgatp_mode_mask();
> +		break;
>  	default:
>  		r = 0;
>  		break;
> @@ -212,12 +215,24 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  
>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  {
> +	if (cap->flags)
> +		return -EINVAL;
> +
>  	switch (cap->cap) {
>  	case KVM_CAP_RISCV_MP_STATE_RESET:
> -		if (cap->flags)
> -			return -EINVAL;
>  		kvm->arch.mp_state_reset = true;
>  		return 0;
> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
> +		if (!kvm_riscv_hgatp_mode_is_valid(cap->args[0]))
> +			return -EINVAL;
> +
> +		if (kvm->created_vcpus || !kvm_are_all_memslots_empty(kvm))
> +			return -EBUSY;
> +#ifdef CONFIG_64BIT
> +		kvm->arch.kvm_riscv_gstage_pgd_levels =
> +				3 + cap->args[0] - HGATP_MODE_SV39X4;
> +#endif

 'if (IS_ENABLED(CONFIG_64BIT))' is preferred to the #ifdef.

> +		return 0;
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..00c02a880518 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -974,6 +974,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_GUEST_MEMFD_FLAGS 244
>  #define KVM_CAP_ARM_SEA_TO_USER 245
>  #define KVM_CAP_S390_USER_OPEREXEC 246
> +#define KVM_CAP_RISCV_SET_HGATP_MODE 247
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> -- 
> 2.50.1
>

Thanks,
drew

