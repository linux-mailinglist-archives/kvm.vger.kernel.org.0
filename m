Return-Path: <kvm+bounces-69558-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SL12BpB8e2kQFAIAu9opvQ
	(envelope-from <kvm+bounces-69558-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:28:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC1FB16F8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:28:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50170300F9E1
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C694F31355C;
	Thu, 29 Jan 2026 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lm+Pl4lw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WUcV46sq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D27E316904
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769700464; cv=none; b=AMo4of6kJN4AkLokt2AAp8Bw37oL8DTNezMuIDPtBYgRikMJcgSiExLZTGRazJENvNffTtyOyc4O+CgP2OGYRbNGFPqRPizUQ7uwN0ocWjuR9Of4BYmLKbfCGrnFMZeTXR2YAtPa309oOXFHAKTALzChS86mr5hA/rpS/k321XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769700464; c=relaxed/simple;
	bh=hr/f1/qoxYAV6yNHyyt9Ytzb2s7niqZHq8CGNFSla/E=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Subject:Cc:
	 References:In-Reply-To; b=pQkWw96mq5yRbRYmCkZVoWPpX8k3PTrjbHj59chwAQ4tYsFI9B54zfg+1mzqcYj0VJD3C3LNyVJOnIwNU2tk6Y6IhT/u28tk9+aPGE2orjqRpK0hy4a1jJV7LIyQTK5r96iowmmqyX+yfQ6SsWH9OqDWyvv2354kxDq3tD+a5bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lm+Pl4lw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WUcV46sq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TAHD9Y2033220
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ScOC4GuemLF+vD6HqYRKrExatm0/7pF+N+hUpuGlD6w=; b=lm+Pl4lwNanlF8MG
	x05/DQHvA9ngneLxFBxDmTgdaEi2lEc9+nA+8s9bmWNXByRIYIVPCErqeYr5CYxD
	EhuAN+7e5w20mADS3ka/V9dwiShZl6g//O1JD4+t1D1q3dBCOBeIPst1Sltynwf5
	plcXSMY0k1wG1E8KiAEoa2SoeuInJ0n2JJoqfdXZi1mZmFmhgjhob6nteDNrdwtl
	m+XeoiHKr5pjeWJewDgTtjuGc9ro4f01UwfaKq7UZDFRLs4zjS5EmvpwfdCkbWdY
	ppUmw3mo+W01rOKceE7Zf0mUu2mvzK7SDZZG/VIpp19mvArQMm1PMQHkE8PSbnd8
	Js1agQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bytqy30pg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:27:41 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c71655aa11so326218585a.3
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 07:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769700461; x=1770305261; darn=vger.kernel.org;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ScOC4GuemLF+vD6HqYRKrExatm0/7pF+N+hUpuGlD6w=;
        b=WUcV46sqLrKUI1yFNezRJVFDyAzvrFW7vXphSVqxHiOgDbCBvrBUu19ZjjBuGKeA3t
         h+NZSr0O2vdOUCxBN4OTfxcVxGveBJ6Hz+2KVVRpzpnDR+8m5FRGIUyggzE7Bk0Q4qnl
         GWyzycf53666/qJ5a7ormQstc3uhVGIl0h0GtwwZX8VqnjoEFVyx42ijvS+319hBiSOS
         CgqIh6yOx3deWxf0lFiaTQn3IcUYJSURzXK/terpZ2HK1O9iVrFgW3CTjAjbjeZKN3Xl
         826UcQ1QMhwVM8wSbJ4XcCVS+4nMyeup1uM6M8cxqQGArrHh97LIhubJm08LDTJlAULy
         CuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769700461; x=1770305261;
        h=in-reply-to:references:cc:subject:from:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ScOC4GuemLF+vD6HqYRKrExatm0/7pF+N+hUpuGlD6w=;
        b=FyUtUGYgQCklyC23tYyIMP5rNmDpf6A62FjZ7AzNVeB9Kj8oHTz9fyHwozYcC1sB40
         TVPCWYu8HJBZJOjnJVKB7F0bUiiOfFRPSclhXSalHcItMumohVLmjpclmoSEt8YSkOMk
         8QE4xFDZF0bPMoH1i9FeOhtBi2VgEDvO3ncUk3I4gjNUXpqR5elBMWGruz0FBBjrkoVy
         gmtzaQcVLkzKqxDt95RfxnR+/hi9UipXNZedDd2c3W9N0BkGmS/QWzFpvqyeP0sHg9TB
         s/MZOROXWD+g2yBqrKBKHsaPbO831XZ1ALtxWw4bDEfTpbzAHlyaOn5K3q+F58Edcuep
         /mUw==
X-Forwarded-Encrypted: i=1; AJvYcCW8lSNW5hXWxFAB0Kzey2C+6B+I2HSDqU25PZKKxFUsKTctoshw2JQo4wev7JZ+PRQy0/k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzkd831Nb4nDfZBjSGUF3ghV27Yld1zxD+cP5xRaLlqnJfJwt43
	S1ZD6NqLsmKbC8mImf5ozfJfAECzPuuf6aei6F6eYFjRby2lPZb/zV5dkmbNpllRDsnZPdtcwQc
	vBZ9YkFfYoFU0wKHCdH7ZMJCxPRPZ/hCGSwurfHsR+cGpRWrXETZGbx0=
X-Gm-Gg: AZuq6aKt59boUJkla+oKaayAvQGefCMwTFQgWC5a30PVmUH7LNQTIcuHp8gnC1HIsuU
	0Uzf1p+VLOntOJelef89Ev1zSnyWmvjNP/7fvuXu++VwSkT+N1qPDt+tsWC8AJwWG6D3NguSiMv
	cJQeVaKK3xiD5JymJYck3Wa859Yc2oaIxKAwlHUpHnWRI1a/TYo+doCZPL3zxOFTI6OaN8efdhS
	pejGgUmj5mHYrBEwRcXIsBxGut56YlJSNGCfDS7bZrj4xjlVjO530GMrtocJ5fEbHnyLhFqY4mm
	47zbJFQ7RBUHnuLNhBgwmq0W/SD+9IqTVuMKkIZKjPBDzc9ZarZHHylfyBAufcFoTtvg9ISuO5G
	CvO69Ik28VUZ5+I/1CZQvLvfM00GBDe/PuVH/kgZtabnl83eh
X-Received: by 2002:a05:620a:bc8:b0:8b2:eefb:c8a6 with SMTP id af79cd13be357-8c70b92cc4emr1250375085a.88.1769700457622;
        Thu, 29 Jan 2026 07:27:37 -0800 (PST)
X-Received: by 2002:a05:620a:bc8:b0:8b2:eefb:c8a6 with SMTP id af79cd13be357-8c70b92cc4emr1250369285a.88.1769700456838;
        Thu, 29 Jan 2026 07:27:36 -0800 (PST)
Received: from localhost (ip-86-49-253-11.bb.vodafone.cz. [86.49.253.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e131cefdsm15219531f8f.23.2026.01.29.07.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 07:27:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Jan 2026 15:27:35 +0000
Message-Id: <DG16GDMKZOBM.2QH3ZYM2WH7RO@oss.qualcomm.com>
To: <fangyu.yu@linux.alibaba.com>, <pbonzini@redhat.com>, <corbet@lwn.net>,
        <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
        <andrew.jones@oss.qualcomm.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?=
 <radim.krcmar@oss.qualcomm.com>
Subject: Re: [PATCH v3 1/2] RISC-V: KVM: Support runtime configuration for
 per-VM's HGATP mode
Cc: <guoren@kernel.org>, <ajones@ventanamicro.com>,
        <kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20260125150450.27068-1-fangyu.yu@linux.alibaba.com>
 <20260125150450.27068-2-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20260125150450.27068-2-fangyu.yu@linux.alibaba.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDEwNyBTYWx0ZWRfX7jqraTB0qq+z
 unogeS8+1Dj2xFEQSU+0hjFCqK9FxqKquLxWUsk4MReXICEJ/hfQZR9PJNPbqutnyK9j1KRT4dn
 NogxSaLYAJy0zI6kW8DE1uY3yAk+T8yC95gvDr4/NdqMKIpiVMOMjotm2aHxBET5e9kfvSOIUtW
 MD0BoyWpDAA9ghjXzpQB5VmhmPR2EA2cj5vZtpyI3Jrt778v/WsnmbHk/RSs0uznqEG3UOTOrTu
 eW6TNGfZwyOY94eMd7Gbteou805zlDja3v3dxOHb2ovSXmbzR4oqAuXLOCjVxEJm/TuoUpN2RAy
 Ut7p0wElBvOfsrTcZQc8u8oFki7i1qMHoynne7sTgL5V+3uKhFgUbjIYj9xhnbhPpGk0gNDB7IF
 R8g2xe+4LKE5yGHf4ym9dnt3qd6ZzFLYFcIz0GVgJ7AxJopB1CCWiCS6V1myKNZYeRoDHYj5K9Z
 eEpqgeRXUuMdaOU84LQ==
X-Authority-Analysis: v=2.4 cv=Je2xbEKV c=1 sm=1 tr=0 ts=697b7c6d cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=HFCiZzTCIv7qJCpyeE1rag==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=f4C2yWSDeSD6iuI_DtIA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: Cvmkgu9lFjPMtGuNgFHvWS71_Ejcikov
X-Proofpoint-GUID: Cvmkgu9lFjPMtGuNgFHvWS71_Ejcikov
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601290107
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.87 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.79)[subject];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	TAGGED_FROM(0.00)[bounces-69558-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:dkim,oss.qualcomm.com:mid,oss.qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,alibaba.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[radim.krcmar@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6DC1FB16F8
X-Rspamd-Action: no action

2026-01-25T23:04:49+08:00, <fangyu.yu@linux.alibaba.com>:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> Introduces one per-VM architecture-specific fields to support runtime
> configuration of the G-stage page table format:
>
> - kvm->arch.kvm_riscv_gstage_pgd_levels: the corresponding number of page
>   table levels for the selected mode.
>
> These fields replace the previous global variables
> kvm_riscv_gstage_mode and kvm_riscv_gstage_pgd_levels, enabling different
> virtual machines to independently select their G-stage page table format
> instead of being forced to share the maximum mode detected by the kernel
> at boot time.
>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> @@ -87,6 +87,22 @@ struct kvm_vcpu_stat {
>  struct kvm_arch_memory_slot {
>  };
> =20
> +static inline unsigned long kvm_riscv_gstage_mode(unsigned long pgd_leve=
ls)
> +{
> +	switch (pgd_levels) {
> +	case 2:
> +		return HGATP_MODE_SV32X4;
> +	case 3:
> +		return HGATP_MODE_SV39X4;
> +	case 4:
> +		return HGATP_MODE_SV48X4;
> +	case 5:
> +		return HGATP_MODE_SV57X4;
> +	default:
> +		return HGATP_MODE_OFF;

I think default should be an internal error.
We can do "case 0: return HGATP_MODE_OFF;", or just error it too since
KVM shouldn't ever ask for mode without protection anyway.

> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> @@ -319,41 +321,48 @@ void __init kvm_riscv_gstage_mode_detect(void)
> +unsigned long kvm_riscv_gstage_gpa_bits(struct kvm_arch *ka)
> +{
> +	return (HGATP_PAGE_SHIFT +
> +		ka->kvm_riscv_gstage_pgd_levels * kvm_riscv_gstage_index_bits +
> +		kvm_riscv_gstage_pgd_xbits);
> +}
> +
> +gpa_t kvm_riscv_gstage_gpa_size(struct kvm_arch *ka)
> +{
> +	return BIT_ULL(kvm_riscv_gstage_gpa_bits(ka));
> +}

Please define these two functions as static inline in the header files.
They used to be just macros there, so it'd be safer not put LTO into the
equation.

> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> @@ -105,17 +105,17 @@ static int __init riscv_kvm_init(void)
>  		return rc;
> =20
>  	kvm_riscv_gstage_mode_detect();
> -	switch (kvm_riscv_gstage_mode) {
> -	case HGATP_MODE_SV32X4:
> +	switch (kvm_riscv_gstage_max_pgd_levels) {
> +	case 2:
>  		str =3D "Sv32x4";
>  		break;
> -	case HGATP_MODE_SV39X4:
> +	case 3:
>  		str =3D "Sv39x4";
>  		break;
> -	case HGATP_MODE_SV48X4:
> +	case 4:
>  		str =3D "Sv48x4";
>  		break;
> -	case HGATP_MODE_SV57X4:
> +	case 5:
>  		str =3D "Sv57x4";
>  		break;
>  	default:
> @@ -164,7 +164,7 @@ static int __init riscv_kvm_init(void)
>  			 (rc) ? slist : "no features");
>  	}
> =20
> -	kvm_info("using %s G-stage page table format\n", str);
> +	kvm_info("Max G-stage page table format %s\n", str);

Fun fact: the ISA doesn't define the same hierarchy for hgatp modes as
it does for satp modes, so we could have just Sv57x4 and nothing below.

We could do just with a code comment that we're assuming vendors will do
better, but I'd rather not introduce more assumptions...
I think the easiest would be to kvm_riscv_gstage_mode_detect() levels in
reverse and stop on the first one that is not supported.
(I'll reply with a patch later.)

Thanks.

