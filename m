Return-Path: <kvm+bounces-69751-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGYbORMZfWkhQQIAu9opvQ
	(envelope-from <kvm+bounces-69751-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 21:48:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 29304BE872
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 21:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 485E8301FFBD
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 20:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADAD352921;
	Fri, 30 Jan 2026 20:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dXGSsY+h";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Nrv4q/VW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1432E6CA0
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 20:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769806086; cv=none; b=KlOA8/d6k/1Lv2TXEvkdRnwcaT4EykLKcjN1sv5LWb2PRjBAfuH5LY+iWPsMX1PlZU/xHizfD3CGYxDGK6ZHWy09qTshvUPYzIoM7q9RG+btzqaAPZHvuzanEgSB8p14lLdwUIBS1PNjOECg6mRizqQY/5eJtCVhjRLIeUHyKEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769806086; c=relaxed/simple;
	bh=E8YzsbkCcsy5Kf9JTj7IxzfDcepCNQOBDNJuJSlrldU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YcnyKuectSc8PVful+zELjgQItBd35bhmre6oC+7sJmlXIfb2i67wE+PT9xzVJ2uN3sHDjx76v4X/8ji3TsRhHNaA5p6CYYlkhqM83qrtMuCoMI1H3wJ32B1hQRfbhxWR2iegUrJc7wPQb0oja2Y+cOi5a6qhmBoiCcK7gZMi3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dXGSsY+h; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Nrv4q/VW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UK1hdP1022153
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 20:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=nX+GGcv58sT3+6A/ukn6uGr+
	PmhTbKUYkNYsXb8LOA0=; b=dXGSsY+hqRrbv8uy3gXwlzkQquz4q7A/7+sVeh3e
	nX8WJvsbcVFnGDcZJIj7ud6qWqx7iABDzrIi1nv3BefikVOd5wkvFYNVHTrgecLe
	Ctwfl6nZorKuaOpWe+sDzuuuwry9hcKsV4VcP7IDLus1gyXpciZ/heo61UvnC7Vb
	yAJ8rkTnnD+GMitvFkFG5RJotv11bKlIZDak4/6SCXN3Y6a/eSgi5vFkIl6yYC1B
	LOubGkAHI12SZrGeu9/C+Pex1I5qpasESHiysC7RzAGuUCAw3CRRGmUQVDfIYYcw
	asaJh2+/uNgLcistcwBM1jMCPqk8EORuWQm/RmWIVDk2QA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c0e3kc3tw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 20:48:04 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2b6b9c1249fso4053643eec.1
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 12:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769806083; x=1770410883; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nX+GGcv58sT3+6A/ukn6uGr+PmhTbKUYkNYsXb8LOA0=;
        b=Nrv4q/VWNmzsnP+6ndXCO90bJbG5AO7utxcURiuCwlaCGTQyJrHLC+Y9K/vDHYhGSC
         q3URj4YLHEaVKaLrOXzFehJsjFXMvbt29Prl54CCHbxVmwhq5MPzoZi/J6gXD6oYBubu
         dkEoiJ/WW9nis5Qb9voJXadPWiN+kkj0xVDXMByyziVoQnHQZasmgmom12YX1lsHE+Qi
         zMNft+xoWlcHxrAWXbhbF3ynkJ/wqIaiAfZVcC9z22rmbkDglJndCadMIpwzp5fO7ILU
         LcUCowU2q+IJoRCx+sIhhkBdIrW4zof2ZEHd21YTwoJFNi+8JgQYMeqFdIOnewl1sOyp
         NQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769806083; x=1770410883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nX+GGcv58sT3+6A/ukn6uGr+PmhTbKUYkNYsXb8LOA0=;
        b=UoegwGOYKzXIr2i9+s+y9IsMkm6xmbPkUmaABduvp4YWbYisviWW84XvpqMsMbyl77
         z3x3gYqW/WV9TrjM0EQp3l2mtqSSlc7nZthYvO+Qe1SiDbAOxaTYri8kJYiOd7o7DpRe
         CBEOxqCN68uAfG+HKXEp/q/R1FwQjZXThlugYB7wDdkf/10gFM4G6h8dbDNWzeMpglhP
         Uka3I6NUA6N81UWK2+FFAYAOXYvGa9n6vMmtdFYta1G3c1kokvTNdvVCDwbw4g3yH6PG
         QMD3bPb6kvde3gkBNDKroGA9MygwPzD0C0YSO6R9oYblD62jZTPvHmfYKrqstr+O/d28
         3wUg==
X-Forwarded-Encrypted: i=1; AJvYcCVENwQOix55P4rvVhg7FyrpXwA2dPPZa4gwejblkuJgzY1xdcyMCoq7UKTHXYMmz4QQMIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLft66X+wDoba8cG/yc2VGyBIzeONMiYEAx7BDQF/mC8uge31T
	AmkIl0wiaV8ud5F2eZhh7V5i/Y0tqGrAnBNiU784x0BmNptSlGwDom12yUgAD4sEIwIDUdTeQcA
	QielGTTMlfV2w9goo+fiPstQUq9DMPfvZ5IOYg7/J+k8LaXtp+YQh65w=
X-Gm-Gg: AZuq6aI8Km2GqUFO1B1t76GdF+/Llb+OB7bpw/GNFps71H0E6J4qlcj63OXEE9ddZLg
	wWBSKu1URwY/hc0pQlBSwMSQvkJ10QRXMSDIse6IX85QDtCGf6oEloWQ9bpcSEmSDaq6JRtTN8H
	mv4X8l9wE76WJ8vpq5Nuye92X86LDeJi92wS8Dd7j1n0t7ZQxqwb7F9FnKo/hp2dBYTZDZIzdE/
	drpUqhk/TZ5Cylp6koU60W8iy4UjOifzEzSCiItMdMUL2fvOfy6WEuF3gD+FijolzQp2sWXcqDg
	/Ua4h3MaNTpV/MjdoHUkcLZWbJTJMb1TbGBihX7P12D35x+wA8rnPDfKMhkJydIhkD0gsO7W+yB
	ulQUDjC0PZ8Pfjrhp7+g=
X-Received: by 2002:a05:7300:4302:b0:2b7:1d38:3596 with SMTP id 5a478bee46e88-2b7c863300amr2186692eec.4.1769806082980;
        Fri, 30 Jan 2026 12:48:02 -0800 (PST)
X-Received: by 2002:a05:7300:4302:b0:2b7:1d38:3596 with SMTP id 5a478bee46e88-2b7c863300amr2186680eec.4.1769806082432;
        Fri, 30 Jan 2026 12:48:02 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9d6b906sm12831536c88.4.2026.01.30.12.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 12:48:02 -0800 (PST)
Date: Fri, 30 Jan 2026 14:48:00 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>,
        Jiakai Xu <xujiakai2025@iscas.ac.cn>
Subject: Re: [PATCH] RISC-V: KVM: Validate SBI STA shmem alignment in
 kvm_sbi_ext_sta_set_reg
Message-ID: <ydibz63oh6tj66utjlemeikxg7iateqoox3bwg7r4pdvbwijoj@5zxhlhesvv2t>
References: <20260124022042.2168136-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124022042.2168136-1-xujiakai2025@iscas.ac.cn>
X-Authority-Analysis: v=2.4 cv=VI3QXtPX c=1 sm=1 tr=0 ts=697d1904 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=ZDiY3XfEgKCrtrtHt9QA:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: efa2-oE7xJYDNy6dvfFoj9VVrFXjw4hJ
X-Proofpoint-ORIG-GUID: efa2-oE7xJYDNy6dvfFoj9VVrFXjw4hJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MSBTYWx0ZWRfXwRZASpgEEk6u
 TeyxDK3OKsxqHcvWAnqzzN3cs0zjGO32p+f8NrhYuBsu4hUiOQ7ZyXtNAd1vMXHTHA/n4cVcrPe
 xxIXduAKUgKo+sBDpmerDGjc59EUG0UxtMa57sQR3QPSHAVpI7/gKynOg9D86fBIng87CRmKRAn
 VBGJbKxl/2eFywoon8DgmsPRjIm63qB5NmvIo1vQ9QMqHa0NZjq3h0MbWYgIN0VdXdhiz+1yRTM
 ohAr3rQpX1uj6tcOu4qFYg+FsPEVu/Kt7h4q1vrttRrX5En0bzYw3mwOfy9yo934RPZ33vButyq
 5PKDZ9JwRXy7b4hESN8xQAFzh9YuCmYX//0PwLiAiUZuI5Non/Kxr/AgTgO4jVxzIHQykZGh+yg
 dQ/ZQJ1zaMNut/XdsikFzdMJyUPQCDqGzBRIOkWCEbafB4woC2OMFi2G/SpRPF0Rta2gaRd6cYz
 TqnxoQalgoIOT2XIQ0Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601300171
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-69751-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:dkim,oss.qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 29304BE872
X-Rspamd-Action: no action

On Sat, Jan 24, 2026 at 02:20:42AM +0000, Jiakai Xu wrote:
...
> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
> index afa0545c3bcfc..7dfe671c42eaa 100644
> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> @@ -186,23 +186,25 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  		return -EINVAL;
>  	value = *(const unsigned long *)reg_val;
>  
> +	gpa_t new_shmem = vcpu->arch.sta.shmem;

Please declare new_shmem at the top of the function and there's no
need to initialize it to vcpu->arch.sta.shmem. Actually it appears you
meant to initialize it to NULL, based on the 'if (new_shmem ...)' check
below.

> +
>  	switch (reg_num) {
>  	case KVM_REG_RISCV_SBI_STA_REG(shmem_lo):
>  		if (IS_ENABLED(CONFIG_32BIT)) {
>  			gpa_t hi = upper_32_bits(vcpu->arch.sta.shmem);
>  
> -			vcpu->arch.sta.shmem = value;
> -			vcpu->arch.sta.shmem |= hi << 32;
> +			new_shmem = value;
> +			new_shmem |= hi << 32;
>  		} else {
> -			vcpu->arch.sta.shmem = value;
> +			new_shmem = value;
>  		}
>  		break;
>  	case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
>  		if (IS_ENABLED(CONFIG_32BIT)) {
>  			gpa_t lo = lower_32_bits(vcpu->arch.sta.shmem);
>  
> -			vcpu->arch.sta.shmem = ((gpa_t)value << 32);
> -			vcpu->arch.sta.shmem |= lo;
> +			new_shmem = ((gpa_t)value << 32);
> +			new_shmem |= lo;
>  		} else if (value != 0) {
>  			return -EINVAL;
>  		}
> @@ -210,7 +212,10 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  	default:
>  		return -ENOENT;
>  	}

Please add a blank line here.

> +	if (new_shmem && !IS_ALIGNED(new_shmem, 64))
> +		return -EINVAL;
>  
> +	vcpu->arch.sta.shmem = new_shmem;

And another blank line here.

>  	return 0;
>  }
>  
> -- 
> 2.34.1
>

Thanks,
drew

