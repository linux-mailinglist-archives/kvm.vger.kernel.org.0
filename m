Return-Path: <kvm+bounces-69904-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oE67KIXygGkgDQMAu9opvQ
	(envelope-from <kvm+bounces-69904-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:52:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2134CD0557
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 19:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 16984301D30F
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 18:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFEF374185;
	Mon,  2 Feb 2026 18:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pEOj7a3s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="O7YjFebL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39792DB7AE
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770058187; cv=none; b=uTc0O+Yqt0fVPu26I/bfkAsL3Wd312bkJYLkvEWad2n3eENQz2j6j226IqtpCZXWJwX6ZtSgqMmrxLe7NpvbzAM4pY5ERUck6bfB4n50cl12kIeapljUR/ZL2IH/bc1gLl5wo6mqmYgPXNarg9M3UYpJika2IKL1d3RMq+fvdos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770058187; c=relaxed/simple;
	bh=+BB3oprmF3IwDJYflvgD/wWi1jKg30NUMwTP70etfhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8picYxdWuBWX6i3Yv2HzqSSAytDW65ffK0zXUaXMDFXt6mfFEXeS5ESlHj4Xi0t7MCZ2LIl1EJLo87UDOlkpQKPxW2RNT13pgpEoaOxMAKcFBVk9AqW4EkKBmvS/Vv0VRk+9+Okhwm57bQ8qdl21CdQ0hNx6c8p9ycg96rhiVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pEOj7a3s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=O7YjFebL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 612FlDJd3388084
	for <kvm@vger.kernel.org>; Mon, 2 Feb 2026 18:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=McETLnO4ta1TDAPHSx5gBrjB
	YMKIltkUc/cMr5/3QjA=; b=pEOj7a3sf+dmUCl/aWskVTC4TWNe/fNIOQypPRIo
	e28VblZNK1hcy9oPpaREDKlCBo0PDx5kjgDeA1JNgSiZcTvUtSg8NjB1iVg5PNAN
	BH48HLIsizSGBTcH+5I3zm3DoMOICpFQd1HisiSjjCjPEU81G7jD+zzlty+XFhhj
	frUxmqlXUAz7L6oW9pcbVQih9DQck7mNrgrns0yu3/q6L9o9wLGOCHv+qUu6Q5nt
	Ntma4/lTxvzlklcvsFEHKhYLk4XyOIW8EDfu2zr/Q+5YI2jDiP8KROCAA48rngKh
	FkRGWXHSYlpSKdInO4O+pnsS6jFUMhFuC9nR551/ZA/tFA==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c2xvbrky7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 18:49:44 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-124a2d3d1b7so5903305c88.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 10:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770058184; x=1770662984; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=McETLnO4ta1TDAPHSx5gBrjBYMKIltkUc/cMr5/3QjA=;
        b=O7YjFebLtI0J6ZteCc2JsWoqGYBKqkiJQ8Lnq3/r3pctHWtrgAb4RuCiNitrMYzOL4
         cOF5lIg2dHwiNCCv8NawAwA29oJN3nBeMFYhOSkQf/yySkYSaxjG16PSaO+X/T9jDGzb
         GmL3Yrgb4UP7ZpqY2JGrtXUP+0SKHEAbRautGHva3R+Bl1s2N+tT9FDYz1ccZtD5C5QO
         5a6GOkXol11JOkBE+Kxk9kUFH+pgQMuwPXO6nR4LoctBv12/A2xtHSlFcy2IQY4xbi9w
         Q5pg7PeCgDQ36qyCS8lnnRn5Anfout7Oz3xOGLIUWMipSXsYhSABTztazoii2/edfv53
         4HXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770058184; x=1770662984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=McETLnO4ta1TDAPHSx5gBrjBYMKIltkUc/cMr5/3QjA=;
        b=a4uy/f86S5FqNNHrwZS/pJCYj65byvsYicXco0cRdBJSRdOg8tq3t7tqu5hZ1XQ49x
         JJWlLSzErNlW8PNNGh32ndoE/BrV4u9TE6mqiIUTGpPQizrH4L3n+lYR3zEeY0ypqcAv
         fUU09w9bI99GaXU+Y67pDUwfnfSxu5Hyt0USyzr43Bg9vbgeiHILCkcuN917ca7rnCcY
         GVxok0CpLXbaAItbGqKhy230Ble9gS7gVM+N4sajojNd9vOfPFyMCLRI/26LijpybQSY
         d96kOSHeMYeudNj0PFt7olUEhEPVDHFMXUeHlQX0cSJMfFclqGX5YFYm+WrUhyrc1l8J
         3U7A==
X-Forwarded-Encrypted: i=1; AJvYcCVym6do9HBLdcFYLjFK0Df80aycvR3jd4cwPKM/RwjZb0UmLXBP8mA7pD/UGRZ1GkQbOO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkSr85EuF5S7o8CN0cxhahSZbpIh8TDK0w/sHBMt0zk2yz6deN
	XRYNNuBF2BpkRAAmHwloLTkFfafYQb5Ldnv7CGx4llS3PBCnwVd1EuF2D10K78rtmmAYGghgYpL
	RVuR8DTmPON13SoYym2Tw2N8T10EiTYluh/jDNcXO/kpGGA3tM8AP8JI=
X-Gm-Gg: AZuq6aLV1xZB/wTNiBADVUwlmtheZ1AOtFjMWrzf0zHbRJ0OYiKrUichTymIBMNhtS/
	+FkUNbgmkb1h4B3VXkEQyzGsJuRgmmLMbv5pT76lMxFmQQjCWV5JZEpQhz6tH4WKzwS1GZ9yLsI
	A3luQYeYgYvZSI0Rcb4/qnm3SMQVCMBkDgDPNGYQ5FwnePIf0ykIlEf2iU8vDEM+bc8gYmLMxVO
	OAo4gCHQquxGNieifERRCtCzgoE/edanfp2g95KRBKPeAdUN+DFxHN7jZNLPTOOJAnPIfm1PRql
	KhQEhQHWObEWgO3BN+cMYZcgiX8VDk3m0rDXTlVSmnVaMU8YFBq425oDkXctKYe/i8CkcXjE/g8
	VNKChJuV7X+/5Vrf8ugg=
X-Received: by 2002:a05:7022:608f:b0:11b:d4a8:d244 with SMTP id a92af1059eb24-125c0f93c6fmr5769706c88.16.1770058183583;
        Mon, 02 Feb 2026 10:49:43 -0800 (PST)
X-Received: by 2002:a05:7022:608f:b0:11b:d4a8:d244 with SMTP id a92af1059eb24-125c0f93c6fmr5769692c88.16.1770058183010;
        Mon, 02 Feb 2026 10:49:43 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1abedcasm20534927eec.21.2026.02.02.10.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 10:49:42 -0800 (PST)
Date: Mon, 2 Feb 2026 12:49:41 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: pbonzini@redhat.com, corbet@lwn.net, anup@brainfault.org,
        atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org,
        ajones@ventanamicro.com, rkrcmar@ventanamicro.com,
        radim.krcmar@oss.qualcomm.com, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Message-ID: <73zrxri5snnenmezjxrdorbcsps4dlvtrkvkq3w4ain4ggbxdl@hjw4u73msaro>
References: <20260202140716.34323-1-fangyu.yu@linux.alibaba.com>
 <20260202140716.34323-4-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202140716.34323-4-fangyu.yu@linux.alibaba.com>
X-Proofpoint-GUID: CxjhxTvDW8m8H2KLeF81WxZKpBHU0fKw
X-Proofpoint-ORIG-GUID: CxjhxTvDW8m8H2KLeF81WxZKpBHU0fKw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDE0NyBTYWx0ZWRfXzFdd35EwqaI9
 mR/LNwPewtc5JyX287BLTNg2VZnO6b64YH1CHxiIJfMt9BryK3qZ45PDi1txhFnPArq+P4/rhnP
 hW8TW8w7TQFEp1I1ngWLff1VSOVD0FN3ctnra593NQ6JDQcwYUcmaAxEez2uYioN2xcHqB4NhIj
 E9dvtJLayr/Xdx8sX3a8oeJCq6d+QHeDEMYTgKL5BMTnHgwh3Vpdkf5M8E+zTHXiAx6WNVrJQYd
 hejCdBP0TUQ4yERLvMMSFMMozLLOFtanpNRp+vgDTu4p2VFBDQphEHhFMQPfuP1xZJwnPEKivd+
 KbT5KaJYuV7+PRo+k4EoWM6r0i4D7TNp1k0qpFpi93THJrurv/DCd4GjxD4A4h+038fO2aTCYUQ
 Y83ETaw7qahnwi3r9+zFWN0ajZrKvkN5NR2/3RUXw9DwMhmdMWRIclqFWytV0H34mtqm1xG+6WM
 MBdyTH14T51RtqfNcSw==
X-Authority-Analysis: v=2.4 cv=AurjHe9P c=1 sm=1 tr=0 ts=6980f1c8 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=Y8ST6Fl8U4FUF0grvJQA:9
 a=CjuIK1q_8ugA:10 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602020147
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69904-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oss.qualcomm.com:dkim,alibaba.com:email,qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[18];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 2134CD0557
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 10:07:15PM +0800, fangyu.yu@linux.alibaba.com wrote:
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
>  arch/riscv/kvm/vm.c            | 20 ++++++++++++++++++--
>  include/uapi/linux/kvm.h       |  1 +
>  3 files changed, 46 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 01a3abef8abb..1a0c5ddacae8 100644
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

If we only want this to work for rv64, then we should write riscv64 here,
but, as I said in the last patch, I think we can just support rv32 too
by supporting its one and only mode.

> +:Type: VM
> +:Parameters: args[0] contains the requested HGATP mode
> +:Returns:
> +  - 0 on success.
> +  - -EINVAL if args[0] is outside the range of HGATP modes supported by the
> +    hardware.
> +  - -EBUSY if vCPUs have already been created for the VM, if the VM has any
> +    non-empty memslots.
> +
> +This capability allows userspace to explicitly select the HGATP mode for
> +the VM. The selected mode must be supported by both KVM and hardware. This
> +capability must be enabled before creating any vCPUs or memslots.

We should write what happens if the capability (setting the mode) is not
done, i.e. what's the default mode.

> +
> +``KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE)`` returns a bitmask of
> +HGATP.MODE values supported by the host. A return value of 0 indicates that
> +the capability is not supported.
> +
> +The returned bitmask uses the following bit positions::
> +
> +  bit 0: HGATP.MODE = SV39X4
> +  bit 1: HGATP.MODE = SV48X4
> +  bit 2: HGATP.MODE = SV57X4

Could write something along the lines of the UAPI having the bit
definitions rather than duplicating that information here.

> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 4b2156df40fc..3bbbcb6a17a6 100644
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
> @@ -212,12 +215,25 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
> +#ifdef CONFIG_64BIT
> +		if (!kvm_riscv_hgatp_mode_is_valid(cap->args[0]))
> +			return -EINVAL;
> +
> +		if (kvm->created_vcpus || !kvm_are_all_memslots_empty(kvm))
> +			return -EBUSY;
> +
> +		kvm->arch.kvm_riscv_gstage_pgd_levels =
> +				3 + cap->args[0] - HGATP_MODE_SV39X4;
> +#endif
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

