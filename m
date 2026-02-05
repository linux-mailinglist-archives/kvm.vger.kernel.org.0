Return-Path: <kvm+bounces-70338-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aG7gEYG3hGnG4wMAu9opvQ
	(envelope-from <kvm+bounces-70338-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:30:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F2375F4A06
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 16:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 08C153022938
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 15:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2194531D725;
	Thu,  5 Feb 2026 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KU35dBE8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kqH150lc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4721C1D435F
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 15:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770305398; cv=none; b=l1wKkXfBiBoVysNoA/z1u9oQqTSBwOP4iYJmq90ZU/AmlFZUygl4NxCQVOL/E+8WyNhnoudFmH8MK1NTvtzwILmOvTYfH/E1c4dbvVIp7YcTuaRmqqru75D9ivBTTpIvVxy2Jasjg11zbDo9UhiRBfTeIMPN8x+9KmsuARIGAdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770305398; c=relaxed/simple;
	bh=qJ1IoJrLaDLj41deaaBjJa8sn2zNujuIb/CrmnDqtiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIX70MmhVZTXFyNZGRzleBhdtQ+rFGL/q4tby8BzXQaCXjcDs0WosGDjpaUxG1oVxJfudKFLBCQbU6R96N+QreFU761KK8IxBq19z3Inhmnxtm2lxSYBrFmCa7qhW6pIVyvyhGMFJrurZaOpOieW5EpN46/anIwrJqRRLXG7CUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KU35dBE8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kqH150lc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615Et2kT2945176
	for <kvm@vger.kernel.org>; Thu, 5 Feb 2026 15:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=cRJydN6XhmQwgdowUHd7ChTT
	rTbeIpI6IAID2mzzwGs=; b=KU35dBE8bwyUOW9VZSSEqC5HMrNA/wuXACQj6795
	zvdsS6+Pb0H9CAptu1SwDfntMKDOv8Rnv6uZFcrsxiFP1vpmqmkN2/6s21nWH2Kt
	fZPbvr9dYRhPE0toxed61NGV2Epni4Q5d4T67HtkQeWAD1XGPBwuZGhLxEXpww1q
	GQVlmvK5VSDbSxtyNuBGnYp5TAMTV1i07zxNzD9KMvkE+QfJCsm4w+eihPmSojFT
	JTe0ACLX6I4RYOLr01tFraq61Gwq4miX0yV0TGx3vu9amOuPqXowvxK5jwSKCC7l
	CL/MupKKfp6ThJhDQMiR7sqxKiqVqLQhFQ5HL/dV99vRBw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c4q55sd70-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 15:29:57 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2b81ff82e3cso1405253eec.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 07:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770305396; x=1770910196; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cRJydN6XhmQwgdowUHd7ChTTrTbeIpI6IAID2mzzwGs=;
        b=kqH150lcnrdL2PGVk1CNH0wQzaFoMnZP6PdbdSPZtqAQaez9V+BEsusIoRF0KuWaHc
         lnce3WZRXLMx+8oA9zvPiv1Q6jIdSZ/MJNosXDGf/zTlOAnfXgI+t9CAf6vMDgLiDgVg
         C3QAje5xhNnwKCJKR1e1pchVTStJiAFItPclBaurNKyibK9tJBE8iiVAHwGcu9HpqEvh
         ntmwPw0aEwbSAQDyBdCn1Pp5Fl5gWi4j2E7C5nIdSPpVDL9twZJiQy/Dw5sIaHoM3qSe
         ebSp5N2Zzq60gIau+9TQT3xksXaBpey1+P8FHw+by7H4cCnRYmu6KkYWItPVWNvEGiRo
         6zLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770305396; x=1770910196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRJydN6XhmQwgdowUHd7ChTTrTbeIpI6IAID2mzzwGs=;
        b=lc5+/gUZo/ADrRLS0/8Wri3/UXl5mZAfA+iT9iEMCqJxl07zHsLEnvs2jiII2ewFde
         SeeHS5DyKvIu0JOoZ/sf3m8E2wVUDkgbd1a9uSAcv8xAUV+ncr11KjFwPQ22g+nhinPI
         3HLG6CWPoF9DJmVfPKrMwCIZyDI8UMBkMPzAYrb/Bau8uGWmkwLHsulAx8uCmlYg/DKO
         JwrZmp9Kaw3c2lrCACay6ZQmtgNa4qmS9kX1q1jd+rvdre6Amyn4+Am3iLy4KTUUUEuU
         9RxGr+amimE2/8PtH+t9+27OIXXXJfFsthWOQLnuaMoWNh2u8P6xcdzQsm3Ucu5hCFy+
         spig==
X-Forwarded-Encrypted: i=1; AJvYcCWTg9qSVf+Y5IAF04Djc9g84CHPrl+ozwSS+zzEJGwhOTzcWOQRxmGJ6XB7+0FeytJDMuM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE0sC8FTd0w0s258DRIsOftZnw1liWiP+0AUciTbS+ZpmtEBe7
	Q38hldd/fm9MV9BFP47ffvp1fUJFf9OwSMEx4e86kJx1zKDBQtfis25UYIMO4TJczfhhB/580gp
	8ftQFWDx+rHbHtduJ2lpS6O2x9lqUd/uWqs4Moj7oMDl7hy6x+BgKATY=
X-Gm-Gg: AZuq6aK8HfjHvWiwesC0MJU2+VibUNT/KcmoMUWG/IroVN0Tfco7OwiWKsFkWvSVBPG
	UeqCWoMhsJcD5CqP0vIAzNe7sCR5I4ma+ElbfCpeEYdlW+bhDjjDz6F+yBMcOnnHdO6d4b07552
	iT9oySQfzPEQOQZ+qddoEDsFd3OUBF4pTsy5OfQqPZE1tQ5uGreF2RYrrhTWWFALYgET7D9R8Jy
	OK2NDE+sDppjGHiECv4FejXm+zMkzrIQF/EkQk8E/2bETeKDSHGboBUxYa4lTLCQQCP1XSIe0RN
	BVryBxY+8V6ydOyn8aPsaR+Yvo3OcHiW3h23e1mrkwfjr6yaQcAKfwsK/v39lrKnlZ2kWj2JNTh
	Vn494cgL/yr+3F2c1cFs=
X-Received: by 2002:a05:7022:6a5:b0:11d:fd41:62c8 with SMTP id a92af1059eb24-126fc2ef50bmr1459936c88.13.1770305396382;
        Thu, 05 Feb 2026 07:29:56 -0800 (PST)
X-Received: by 2002:a05:7022:6a5:b0:11d:fd41:62c8 with SMTP id a92af1059eb24-126fc2ef50bmr1459922c88.13.1770305395713;
        Thu, 05 Feb 2026 07:29:55 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f503087esm4715815c88.12.2026.02.05.07.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 07:29:54 -0800 (PST)
Date: Thu, 5 Feb 2026 09:29:53 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kselftest@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH v6 1/2] RISC-V: KVM: Validate SBI STA shmem alignment in
  kvm_sbi_ext_sta_set_reg()
Message-ID: <zudnvpsirxbfjwh6plmj5utumgvj4tmzdddegneu3f22vfxdz3@dza2x6bur6pb>
References: <20260205010502.2554381-1-xujiakai2025@iscas.ac.cn>
 <20260205010502.2554381-2-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205010502.2554381-2-xujiakai2025@iscas.ac.cn>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDExNiBTYWx0ZWRfX0H8iraaY9s99
 3nzNIJadRrx9bKinVl6fqgubfvVrXXLeosn+4ugGZTF32qUVLQt0sGlhxZlI55ck0BhhUP2uiyb
 tffoqAgOHWYN5mIE8BcDQx1baruB1udMNrNDBVn02FP/ZwMlnEu0dUHi3wd+P4lUbeZJYr25qwk
 MqHqoQvwfKVin0h6dgK8KWoxCjSAtO9jdZqDVXZ1hfxI9xRL31iw0smmX0XR8cjprGJfk1SkGvx
 xDYH0RTm4R4E4HDQIN8Rc4T+2+zVo+wk3KrpNKTIKFYlPAY8DJUAb0xI5+96sxR9yy6/P6ByBVt
 jf5wOuM2vyN8mBEsO8HD0Wtj6eRL1vCZ5g1WF2ZGTaLGQw+jsqc7ECA3+cTp3CvS2IexiFMZ5iA
 XkabGQgAIdcfjlXjsK6aAfkXzemGbY79/Gg/NW4k5ND44DKd9sPiN7JyfTS10nzFiB1lynyUzmC
 XFlOX+4Pv39Q7nIFcHw==
X-Proofpoint-ORIG-GUID: H5spQNk5oIDGoHjvEjKFlHiKFaldHf7w
X-Proofpoint-GUID: H5spQNk5oIDGoHjvEjKFlHiKFaldHf7w
X-Authority-Analysis: v=2.4 cv=Z6zh3XRA c=1 sm=1 tr=0 ts=6984b775 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8
 a=9wIPkYZYpLDyJTQGRwgA:9 a=CjuIK1q_8ugA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_03,2026-02-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602050116
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70338-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,brainfault.org,linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,redhat.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:email,qualcomm.com:dkim];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: F2375F4A06
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 01:05:01AM +0000, Jiakai Xu wrote:
> The RISC-V SBI Steal-Time Accounting (STA) extension requires the shared
> memory physical address to be 64-byte aligned, or set to all-ones to
> explicitly disable steal-time accounting.
> 
> KVM exposes the SBI STA shared memory configuration to userspace via
> KVM_SET_ONE_REG. However, the current implementation of
> kvm_sbi_ext_sta_set_reg() does not validate the alignment of the configured
> shared memory address. As a result, userspace can install a misaligned
> shared memory address that violates the SBI specification.
> 
> Such an invalid configuration may later reach runtime code paths that
> assume a valid and properly aligned shared memory region. In particular,
> KVM_RUN can trigger the following WARN_ON in
> kvm_riscv_vcpu_record_steal_time():
> 
>   WARNING: arch/riscv/kvm/vcpu_sbi_sta.c:49 at
>   kvm_riscv_vcpu_record_steal_time
> 
> WARN_ON paths are not expected to be reachable during normal runtime
> execution, and may result in a kernel panic when panic_on_warn is enabled.
> 
> Fix this by validating the computed shared memory GPA at the
> KVM_SET_ONE_REG boundary. A temporary GPA is constructed and checked
> before committing it to vcpu->arch.sta.shmem. The validation allows
> either a 64-byte aligned GPA or INVALID_GPA (all-ones), which disables
> STA as defined by the SBI specification.
> 
> This prevents invalid userspace state from reaching runtime code paths
> that assume SBI STA invariants and avoids unexpected WARN_ON behavior.
> 
> Fixes: f61ce890b1f074 ("RISC-V: KVM: Add support for SBI STA registers")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
> V5 -> V6: Initialized new_shmem to INVALID_GPA as suggested.
> V4 -> V5: Added parentheses to function name in subject.
> V3 -> V4: Declared new_shmem at the top of kvm_sbi_ext_sta_set_reg().
>           Initialized new_shmem to 0 instead of vcpu->arch.sta.shmem.
>           Added blank lines per review feedback.
> V2 -> V3: Added parentheses to function name in subject.
> V1 -> V2: Added Fixes tag.
> ---
>  arch/riscv/kvm/vcpu_sbi_sta.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
> index afa0545c3bcfc..3b834709b429f 100644
> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> @@ -181,6 +181,7 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  				   unsigned long reg_size, const void *reg_val)
>  {
>  	unsigned long value;
> +	gpa_t new_shmem = INVALID_GPA;
>  
>  	if (reg_size != sizeof(unsigned long))
>  		return -EINVAL;
> @@ -191,18 +192,18 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
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
> @@ -211,6 +212,11 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  		return -ENOENT;
>  	}
>  
> +	if (new_shmem != INVALID_GPA && !IS_ALIGNED(new_shmem, 64))
> +		return -EINVAL;
> +
> +	vcpu->arch.sta.shmem = new_shmem;
> +
>  	return 0;
>  }
>

Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>

