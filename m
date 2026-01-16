Return-Path: <kvm+bounces-68385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B5CD38546
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 72159301BB19
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65DA39E6D4;
	Fri, 16 Jan 2026 19:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LGtcOnPt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kUuq+dg2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2F2FC037
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768590212; cv=none; b=nYq5KT8wQSLlY6KBmXueLEJwarJYPigKa+hF+wYxvuhs7e2e8HIPdvfFTS97FuJahkYHunZkuz7MpPvG3zQ+766u4Mw8WeM70hGQleoOEktJElNK1F8KK9giEhn/aAuCrxamZBthy8lWIHefUHYo78RCOnRS53iNHN14HT7EwL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768590212; c=relaxed/simple;
	bh=HuX7hUb9VnEgzckNNR8hCXPuRconp2LHDDQtvWoHK74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ew1Qprcg/oWUT6IPYtZksnYG50UExY38okTsQGQnWoFt2+nFZVtoMOG66dWmDa3Wba1Ek+nZTEzHSsBnTvJ7UmSEwd0KL4LmqyVXKnKfH+QmeeyD9maHLzGWRCU2fKRv+8hvPwMc/J8WENrrHwAKJZFh+ZnsPBr/EoszcaPRTcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LGtcOnPt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kUuq+dg2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GGWKD53192151
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 19:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ctdwtzx4woC6De+DgvE6qX6t
	IJzFb2FXyuR20qfZBEg=; b=LGtcOnPtOR+13bTj4jHF6nGlYrcYhfluq4KC3l/S
	6UOnnPz6682Jwq/EWmZW7agEUTEQL9y/l/PX/3AY7ugCJJZv1Nv+Nkf1HOEIVRNK
	VPWJrH9q5xHOVlCTzIs5XWUMYWhk0iG+QMZdlPRjtaH/H0G6GVd+bKz2O9p6xAWB
	hyMIE2I3yBgJAo3Ot+sE+XHGeVz8BZ3xbwVwb5LcR936uamiROOi5uArxm1Rwy33
	/a+kV+OgDTBk/cGmIw16Bz157nFLcOyn8Z8RU7UzEaqzbMIxJh24EJyUfS9gkUrt
	NeAAhMJWuU3AN0XXa8dchBbWjJ6bl+HRWAC6/YsNZ7CYfw==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bq968kba0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 19:03:30 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7cfe286f517so1686257a34.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 11:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768590210; x=1769195010; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ctdwtzx4woC6De+DgvE6qX6tIJzFb2FXyuR20qfZBEg=;
        b=kUuq+dg2LT0/wtIK/KOsZwibRvF5xnSZdZ2ID7zyP6EAz+3u+OdddnQcw/lYeOkwT6
         /9C1f31YlaY4m7z2STzL+i/39RMHbn1j1zR1ovEx/z/OOaXG18X4hjLVVyplH1jnV3eh
         nQ3XRA3aPuDC5SM/4yDMgh4Hq4qU6cGinfwDTY0po9PrtAzebUeT05aPtveN6/uIpq6i
         qsNuM4V1USBvBTSwIBT9qZvVm6W4oJOPlOzuF2fMVKTAF3mxYatkoir2h89/iwL4rtgj
         ODvybTo/pYN3niCdxnI4rNDVLI+6my3nKqnnxVtP+MePXzwXfWlrivzF2QFZ7ssyqSsh
         9CbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768590210; x=1769195010;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ctdwtzx4woC6De+DgvE6qX6tIJzFb2FXyuR20qfZBEg=;
        b=q6y0j290Rg+5ZwNswggxkfV7+PWXG7iLbOoYZYCUP6jWVjhi8FncNHJTcrC4cuC4LI
         9m8Gsa/2t75dof1DEAZt5uoRHsff1IAaW3IwyTeJUqdDFAfK8m1h/L3rtt+EaXg/DY6z
         L/p+z36NGXdYZn70cpB8Qj0ljEwBR5J8wgRA/mWI53voucBwK+hyW9F2xqaroq3jKMiO
         qgJFdqAr+P8NrXQaQORaqFORg0HVmlAzcwi/vBvybQUCmcfNMtVPlay0gu8gcdrp7w/W
         whjQHR1B+XXPrP3fmOjnkKYpkkxlA7NdB8Nkv0kAn+BjwczjL27i0E6dXbIUOWJgWE9P
         +m4g==
X-Forwarded-Encrypted: i=1; AJvYcCXH5ucBTwoMi7Hfcu9/Loi0CFq5SKsb8i1kusLhS16APLeOpaPBncs9hosRFwGtMVW8YR4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsg9CJqDOl1MhUp1dJnQf4vudNVsqIt7PIHMU+O0kaNlFhDkrj
	IpR5AwbU5a+62U9NNVT/+m6eSQiiydmWOXLjYm34vtK/SlD/YlbjxBF+TXKBQvSH1kP4xXhttAT
	tODMyJLVvPJcgb4QwtF681qLjGaBIBnOIJxIKqyh36rcrO2LZEXoNY+M=
X-Gm-Gg: AY/fxX6Qv6IPmtDx/DBF+/gONWPrsee1cNLUg1fC1IOHYBxIKaCquI4VK+7D0YmKJrA
	9XkO7r2fV8twrB7P2hHJEUb1cB97lXjWlba38C9tHyX+1jfzaeCqUbc20RovNwPyss01LjXpRdx
	xqdiZVKm8+xtevFDYo/slD5/ep29jv/aYwwo0y9lLacLhh4JnmfYixC2h1MFKAYSmvPHQRAQUaR
	Z+WpAz1yhGsanUheNaUjOZznnlkZxW+XaItcHx5ffF+g7WzlHYAp0xg6tZjFtnOQLxMLLdjKnxd
	M79j9512iD+vCx0kwGWayLganiezgGtzFkX12GzVZaiiKDVNRYooyBJlBXOYYrgT87AivhEH4V6
	SoFENCwygIRcMX70YxBs=
X-Received: by 2002:a05:6830:7305:b0:7ca:f1fa:e9d7 with SMTP id 46e09a7af769-7cfe013b1cbmr1708169a34.16.1768590210050;
        Fri, 16 Jan 2026 11:03:30 -0800 (PST)
X-Received: by 2002:a05:6830:7305:b0:7ca:f1fa:e9d7 with SMTP id 46e09a7af769-7cfe013b1cbmr1708026a34.16.1768590204813;
        Fri, 16 Jan 2026 11:03:24 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0f0137sm2144941a34.12.2026.01.16.11.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 11:03:24 -0800 (PST)
Date: Fri, 16 Jan 2026 13:03:23 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: pbonzini@redhat.com, corbet@lwn.net, anup@brainfault.org,
        atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org,
        ajones@ventanamicro.com, rkrcmar@ventanamicro.com,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Message-ID: <6txqxrkyqh4afmked4hdi6qekkqrb54ar3q5upz3ennnuaktsi@dtoarqt7e26t>
References: <20260105143232.76715-1-fangyu.yu@linux.alibaba.com>
 <20260105143232.76715-3-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105143232.76715-3-fangyu.yu@linux.alibaba.com>
X-Authority-Analysis: v=2.4 cv=JNg2csKb c=1 sm=1 tr=0 ts=696a8b82 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=JfrnYn6hAAAA:8 a=SRrdq9N9AAAA:8
 a=y9tgS1qgbWeIrQugNAQA:9 a=CjuIK1q_8ugA:10 a=eYe2g0i6gJ5uXG_o6N4q:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: qOz6w11JHMmRU745BbEImIjfhB2zRX6T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE0MSBTYWx0ZWRfX7VpF5LIJrY8S
 WOvSS9UD3LknD9++5HF9h6czO+XrxhYsx7iB5nAfOfCz3MRs7ZofTMpoT7xkaIZ9n3u56dv9m+s
 qFNAavF6gbTuSCVLHf4UNl2FC7LrNq8mGDZQSKc7NDk2rg/X3CyXYXIunxJwE9pH8FeNONQ8lm0
 FxZ3O9GYN9wohN+hTPQmkCHwBFh26Sytqbyh3ABEmLEF4fuip5TKsHfgSwy3rQut9rL9VDkyWkV
 OkzGWPrL9sMVGznwp+PsR0nW7QPhR6Eacqrj9vLv8enJxmTjzZtED6+vC78Q74ExnYywoxXmAPQ
 0xsKXoTnoaEOkh5YKGS5mLea978aZ6VZHIGhpxHlpoTmnUaSB0p5XGup0d5YFZCQ16oRlKLhZs3
 MQlgXcLqMm8rkJvn346nmxE7x9OkaujO6FVSxhKIQFzThWIyc6qO2/7Lvg17Ok4NhkIcQ/GUEZI
 gX/tA5GrQYZ8JyR7JGQ==
X-Proofpoint-GUID: qOz6w11JHMmRU745BbEImIjfhB2zRX6T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_07,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601160141

On Mon, Jan 05, 2026 at 10:32:32PM +0800, fangyu.yu@linux.alibaba.com wrote:
...
> +	case KVM_CAP_RISCV_SET_HGATP_MODE:
> +#ifdef CONFIG_64BIT
> +		if (cap->args[0] < HGATP_MODE_SV39X4 ||
> +			cap->args[0] > kvm_riscv_gstage_max_mode)
> +			return -EINVAL;
> +		if (kvm->arch.gstage_mode_initialized)
> +			return 0;
> +		kvm->arch.gstage_mode_initialized = true;
> +		kvm->arch.kvm_riscv_gstage_mode = cap->args[0];
> +		kvm->arch.kvm_riscv_gstage_pgd_levels = 3 +
> +		    kvm->arch.kvm_riscv_gstage_mode - HGATP_MODE_SV39X4;
> +		kvm_info("using SV%lluX4 G-stage page table format\n",
> +			39 + (cap->args[0] - HGATP_MODE_SV39X4) * 9);

I don't think we want this kvm_info line, particularly if it doesn't also
include a VM ID in some form to allow readers to know which VM is using
the selected format. Let's either drop it or change it to kvm_debug and
include a VM ID.

Thanks,
drew

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
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

