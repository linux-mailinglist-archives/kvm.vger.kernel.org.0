Return-Path: <kvm+bounces-69877-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONxdJPTPgGlBBwMAu9opvQ
	(envelope-from <kvm+bounces-69877-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 17:25:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6522FCEECD
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 17:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3D83D3003825
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 16:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F3E36AB77;
	Mon,  2 Feb 2026 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WavQT2vQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YA0nRkeP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6033284880
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770049516; cv=none; b=YOTvwXjMFijeVkl4IIN5+h3p0dQ0HVYLub1CtmUXx3IwCq3YHZQoxdXSUto+hswvtBfbLCyaLX4bcwk5QL/YbFKFSGqqizf6DfOBmHavJJRFjPvxDGDAkQ2pyr93rXoJzmPNrTz6Ix5IencYPRSgQy3n9oTdNnq5d1QuF30UpyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770049516; c=relaxed/simple;
	bh=paczb7xTIphTKc4FGv6FXQ5RkZ8z7Lywe72jBujMH6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nts5bvCagP9oHAkq8Vv+sf5dkH/qbd3FGJrKuzw0QhHX+W+fY2Z4hqUrFXL2YhhUoE2OVUSotJtO4WuOigAoutiQ4BLoFCXxvLA+t29xxkMk1AKQHd573nSpUmxYQ8EyvHrMzTxNGV6SUOF6q+0W6osQu/9+aEBuFl7Lkrfe2R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WavQT2vQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YA0nRkeP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 612B5Rkl3459151
	for <kvm@vger.kernel.org>; Mon, 2 Feb 2026 16:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=i6qnaLJvdDvAW5szsitSpepD
	XeYDqBjigmWEpuJg4Xc=; b=WavQT2vQA0szCh9N45x2/IeMil3eDG+lSJvxEp3Y
	JqK9TTGLwVvgXN/eej2ex1sZPn40sVuI1WpdOKrVoELbmE8coJo3lxDLVbsdEPHu
	etVF6bZBRqAPwcOF/HNzH9QsEENanmYbcQWVfr7btTf4Yor4meBVZGbrJvelDQZs
	w2pHbhN6e/6Jz/J9Mg8SgNkb5kTkEO+yNCFagbHM8VDt5MiQJQeEs0ZZb5QeBmoD
	TV0UIjXlC6tu/GiBvlm22FO3gZKhHsfD+Sj0byLTlaR+6kREIWafLfjaQ7axrCE/
	9oy/FfGTie0IObaGDGJyRl/B23SkLjSyG/rvDfYotSrhNQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c2trbgx8n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 16:25:13 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2b7ef896edcso7108513eec.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 08:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770049513; x=1770654313; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i6qnaLJvdDvAW5szsitSpepDXeYDqBjigmWEpuJg4Xc=;
        b=YA0nRkeP/jFcA1tCoKrxw5Lk/tT2YuwRmnXAD0x2Juwrk640pMUlnUD9FvoBppq/Kq
         qJf4SwTVIisxYaV8vqfzw/hgbo1y9RLNGv+beDZc7Cs9cBehEQHR7L7PniwWFrz9D+83
         muxml1llMHbHUW/bosA6re6vzJ2ZPfLT4M4cQLHcc++n6+RpZRlXDSG9H9fSHi3Tewiq
         9anvM6gcY/e4ymTtjC3LZSHjF6YuJWt7EG8iVosngLf7BoxaM00mJLBiQ6jHkwMmTU/E
         LUvTooqS0Ewy+shxiNK0NqMezsrZNFdcQLkqK5i22iNkhy6NK8OQCmwFitr6bzK4j3ZD
         fn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770049513; x=1770654313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6qnaLJvdDvAW5szsitSpepDXeYDqBjigmWEpuJg4Xc=;
        b=FuQV+nrjCbbpqBv8fypASVuaJVZJI/fxI1sLkDzXidK/j+TJ1Va1NIe5htyAchvN2F
         HbPZMd+Yt6XQ0ftDapkB+QMLU5aOfbmD8dYriNEjM9BjlfKg5g5hYEynScM67Hl5yYBc
         UuASAd6gXU2ZjZ7q5s7tScDSlJBGkgu104J8NYbGVwofQb6mgOvNDh5/QA+NE7t9Guq2
         ov+VfLdVnVWbsgfKBut4iOQX1RiYqQBA/AyoS0F8qyx0wUKBLoBeeRKo8zFj+okeSSw6
         d1VXBjpddaxWwy8uA8FEdhVdkfE4KAU9wqKGft0DklYmdZDmsQRzoIP2I5XWvsPrJ0Oi
         Jj+A==
X-Forwarded-Encrypted: i=1; AJvYcCUEExQmYIIgTrh6hSTn5o+WirHu4v063/MKYeVySLh2CgNayLS9D7uO/BZE6JUjlEczcHk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNs/Gs5WgfScMf9JwNiIt9ZrtVWJLBypE89A+imbDYTrr+Zkz9
	S9AMG1FlG6V0q7YwvLYgn+gngfNWMbEdjfo1XxunxV2uIIjKHzVBqwF+du8cWKMFmo1YzTaQFkZ
	A9SwBf46PE0Mrr4NXZXME9HF5WkRbpdam6r8+ajw4jbYT6p0a178wzsI=
X-Gm-Gg: AZuq6aL649jXyMnXdkCuLxH10A1z3xH5eSDKEj1zWP8fMZHn2Ta1H58D2ddN51QPJpj
	J+vDi0xlsWILk4CeNQ4G7zL4etqP1uRdsDrjnUWDMFP1nFgHMsEZYBTamziMudyvvyJ3h1cKDLo
	8b1ueVCRj7sA6NvsLn5d0ECFKZ3TT8WB6ZPOTrjOtximTFRwS1tqsyUYREVoMj+XLlnAP6lR75c
	j1wmXNGkeqD16AWK8d2o3SzwWqsJGBxe4hrShYhwBixd2DM+mBDVrfIqpN7MEhD+9CRT6jMRFDw
	4B0bKyGIZpIg/rqjVs/9OjBhfUPQy34ZG78JPDoM6i1+JFhHIAHO8bKfrn2DlHlreieqnlRzttX
	HvVl65dtfRzAfxl6Bk8c=
X-Received: by 2002:a05:7300:dc8c:b0:2b7:1cbe:fd1f with SMTP id 5a478bee46e88-2b7c8940615mr6058255eec.36.1770049512420;
        Mon, 02 Feb 2026 08:25:12 -0800 (PST)
X-Received: by 2002:a05:7300:dc8c:b0:2b7:1cbe:fd1f with SMTP id 5a478bee46e88-2b7c8940615mr6058185eec.36.1770049510377;
        Mon, 02 Feb 2026 08:25:10 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16cfaa8sm19714357eec.4.2026.02.02.08.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 08:25:09 -0800 (PST)
Date: Mon, 2 Feb 2026 10:25:08 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>,
        Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH v5] RISC-V: KVM: Validate SBI STA shmem alignment in
 kvm_sbi_ext_sta_set_reg()
Message-ID: <mknpdlex2x4dfqunv77xe7xyn5v35pdxnwp66honlivbma3ykv@zcm37hqow445>
References: <20260202003857.1694378-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202003857.1694378-1-xujiakai2025@iscas.ac.cn>
X-Proofpoint-ORIG-GUID: fsJumW5BxaCiKYYg_gHhFlWt_xoQbme_
X-Authority-Analysis: v=2.4 cv=dcmNHHXe c=1 sm=1 tr=0 ts=6980cfe9 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8 a=pGLkceISAAAA:8
 a=t_rjcDEbpHFVAzgC7Z0A:9 a=CjuIK1q_8ugA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: fsJumW5BxaCiKYYg_gHhFlWt_xoQbme_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDEyOSBTYWx0ZWRfXyh6jV8SnTt1g
 6Wg9WaNX2C2Iv4puYA0g+0GVAVusMfligZCkyAXnTiTsDFWaEBwFZuswmCFD1P0W4DQPWJmZZ38
 rZNvu51Ve0NhpeZTLyv0RfusWtFJ4H4vmOSokLGo+sQDtBM3/wOzAI3gY6mRGf1Hn7tRcZZUdhR
 pJt37eFuzrURBOXZ3oGal7um0WRCP6LhfkOsKEDpvxsX4MCRh1zPxByWwCiIraxWlqnUuSMSFr+
 mISA4nbi/Vkve8noDb7izXypfH7MV3//nA9H7+qAObsQtdhsn3zyADJHmxK/dSzBUwTWabCA6P1
 lPtU1m6qWjg2pA6TFW6W6EQBKjmpV1t9EUAThxMQiFAnJHjPLF8Ph/7Hr4NkaKBKa8dPtbn1JuJ
 05NfEWgL6rf/Ob/KHm6+e/HOPLJTeq6NQB6JNwO/lS+EpMTvRdxuGSlmI0HqRPvbXtN9hoGQ2IL
 yFlxA5T+NUgur/tDs+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602020129
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69877-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,ventanamicro.com,ghiti.fr,eecs.berkeley.edu,dabbelt.com,kernel.org,linux.dev,brainfault.org,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oss.qualcomm.com:dkim,qualcomm.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,iscas.ac.cn:email];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6522FCEECD
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 12:38:57AM +0000, Jiakai Xu wrote:
> The RISC-V SBI Steal-Time Accounting (STA) extension requires the shared
> memory physical address to be 64-byte aligned, and the shared memory size
> to be at least 64 bytes.
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
> Fix this by validating the shared memory alignment at the
> KVM_SET_ONE_REG boundary and rejecting misaligned configurations with
> -EINVAL. The validation is performed on a temporary computed address and
> only committed to vcpu->arch.sta.shmem once it is known to be valid, 
> similar to the existing logic in kvm_sbi_sta_steal_time_set_shmem() and
> kvm_sbi_ext_sta_handler().
> 
> With this change, invalid userspace state is rejected early and cannot
> reach runtime code paths that rely on the SBI specification invariants.
> 
> A reproducer triggering the WARN_ON and the complete kernel log are
> available at: https://github.com/j1akai/temp/tree/main/20260124

Any reason not to add these tests to
tools/testing/selftests/kvm/steal_time.c in the linux repo?

> 
> Fixes: f61ce890b1f074 ("RISC-V: KVM: Add support for SBI STA registers")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
> V4 -> V5: Added parentheses to function name in subject.
> V3 -> V4: Declared new_shmem at the top of kvm_sbi_ext_sta_set_reg().
>           Initialized new_shmem to 0 instead of vcpu->arch.sta.shmem.
>           Added blank lines per review feedback.
> V2 -> V3: Added parentheses to function name in subject.
> V1 -> V2: Added Fixes tag.
> 
> ---
>  arch/riscv/kvm/vcpu_sbi_sta.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
> index afa0545c3bcfc..bb13aa8eab7ee 100644
> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> @@ -181,6 +181,7 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  				   unsigned long reg_size, const void *reg_val)
>  {
>  	unsigned long value;
> +	gpa_t new_shmem = 0;

Sorry I missed this on my first review, but new_shmem should be
initialized to INVALID_GPA, since zero is a valid gpa.

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
> +	if (new_shmem && !IS_ALIGNED(new_shmem, 64))

And then here check 'new_shmem != INVALID_GPA' since we want to allow the
user to set the "disabled shared memory" value (all-ones). Indeed our
testing should confirm that the value is either all-ones (disabled) or a
64-byte aligned address.

Thanks,
drew

