Return-Path: <kvm+bounces-73229-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2K+RHQperGl/pAEAu9opvQ
	(envelope-from <kvm+bounces-73229-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 18:19:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E4022CDFD
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 18:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2D34301AF5B
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 17:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E3830B53F;
	Sat,  7 Mar 2026 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cY/1KleG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cUqhKd3G"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4E62D2397
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772903926; cv=none; b=RKFmgE9XyeA37ZPrIUACoVsUzjhzcptxFFJ7XbkryENwoCHc8I2VXoZuJ8nElHQov97eIAAF91ndUxBE31HYAAcVCavwN4Q/oeLgLgtVLCM0sTG63yOGSj8kgZhfG09AfBSTOu5hWFCqGbApbiipCpJbJbH0c6wdhxJcruzkz9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772903926; c=relaxed/simple;
	bh=TzNDFmX4MzxWEv07vi9Pe44IF/eXHV2bTD8HyhWUBHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjhNHg9754mIe1lLvlDmJSj21JBHFCRYr5JWRgqUESWFjq3GJBiSeAsLk8WjZPPDgg6znPNCUP04AOc8lT5BCjR55gzu2oe10+OkaFrcAUDTk46umwCQATgFRWFVUhvW2kbgdGKleFFuRWhSEBFFRiWYvCykIeiIkGZRf3gm5/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cY/1KleG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cUqhKd3G; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627BedGc2769501
	for <kvm@vger.kernel.org>; Sat, 7 Mar 2026 17:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=s8k67TJTMj1qQcVF4oBImnAO
	DU96TpZC8jCP+ZBlh6s=; b=cY/1KleGVTSgLS5YlcDghCqjDaPNsNVnmSje19iX
	qRbW5Gs0VTuIxwXLj8ZdR5Y9ZUHTCb2n7irKWeffh4Hd8PsMJN5QEt/2UhbW8FtJ
	O+AXqej3oSFyg1tuIu6Pd3GCGiNGuFRZGDksJXcHXbJjY5L7EBqCdRmKt8ZhBTd/
	8MaoPHbxakb/v69SKvuVdrMub+Z0k+DEmI7hpdD2mY26+HBoKl/IIu+AcjCywiDS
	0uVTd7r9RfsWqxeeC272GtyH6vfZDIxW1rhbneEFYDnSqymJPlNqNriA2jTE3C4S
	17s0rYN0jp9RlmPtxPpd7wC/JWl+oyIUvdGlRMzDyMoDzA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4crbkxs79w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Sat, 07 Mar 2026 17:18:43 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2be2f742c46so31039334eec.0
        for <kvm@vger.kernel.org>; Sat, 07 Mar 2026 09:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772903923; x=1773508723; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s8k67TJTMj1qQcVF4oBImnAODU96TpZC8jCP+ZBlh6s=;
        b=cUqhKd3GLbLBIQl8lMjHGiKeGZkRBCfjoS8eq/gdimSnburm1uxuzSY6FYbocCl4nL
         I43hl+H52QXwnetRsuamg5XAtsl0YguIK/VA3iItILgsvj/XBtvwlmH0R/fqwWDZF1Bl
         FhkV0zhe6wrqMDjstGYv5VbBftmqJNe1YgLYdBydtd16RjcVHCBxPAHF7Z0zdIjB1l1O
         a71fiAYHJ2E1QclvRkL0ZJsvrfMHs+IFknUsBrxnDLS2HiU01vDuHiamOu16t3qH0QTq
         SgKzBsxA2pC4hzspqrG/8F3vyn44G58XWMS1Th0ynT9k5CVYXFy7SE5WzqIR7gUKBCbK
         +3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772903923; x=1773508723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s8k67TJTMj1qQcVF4oBImnAODU96TpZC8jCP+ZBlh6s=;
        b=sd4OJPeY+P6ElN98Psgg1qHDZgWL/deWbhn3qByQqH+odCx4z9iwT6gf9fL30jbRpI
         tD0mh45jMqWpcLp7y/gNPRUZ7sKTvVjok7OhldZFiLhbKB0gdavcEP5XmrY05DAosgFr
         ky8s2oPMLtIkm3KzPiJxHb20FHw1th17JvMrtPhJQp0gue7UU4OwhD0x+PLqxQgNKqoa
         LLlXzHmetVulDGGksA3ypChyqEWSNdIAzv1dX5C85p3OCTqTBk49Xd8qSdhXrABJce/t
         y6f9sh0dNMDCfNsa2wWvDgj/r810cAXq7F18+0VqejCG8u9jxhb/H2Y8Dx1+AlMcXg+g
         o7mQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8Mdf1GerP9jJWUXMO1Y/brfglCgCqQ0VXSFl92p3lEQxFqBm0z5hsJpeGQ9wymHHAbHk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbSeBlKUngl4N5mYkt2Gf69URBiqWE/67KNzXaDS+dqqjQuHmp
	CVjftJd86rNjbpL+R8y96G02pu/XRSBijtjAxxdS0hMnqZFOLLFMp2tLebaXeTn/hdrznRbbcM4
	4zmapHMLHI3IT3KiLtMecjZ8rc6HlDHi+CuFE9bkEIudJ5BpveURrzb4=
X-Gm-Gg: ATEYQzz0SZMPecLaItEP+1Hg8JDyoQtg3Qr/XXDSsbKutlVFe4HrnDoK7ZMmoMPaDGF
	fwroU0GVdZfAcOYKG7oOGRf+vZsfaWHQbIV7oSJ+JOhoV+La9i+EL2uXzlxtEocRLFNVcOVSGmz
	aTp19qLz55BIFeIFZHELUXjUxsKgFQYOgSEqQ7zvXmQF0l/aDv1K+iH5It6mA3Ke60/A5k8kBJb
	ZtvOfTmhcUW7EZ1a5L28dDRUeCCL/gz0qJ/CiImjeHSuh/+HncNZE5RW6EemkmFSlNApgGJ0UH8
	Mc8MGuFu9iXVe6KKY8PFDtdToutLOrzeBuAWs36Goba1YMMmmf/NGYbNOKrWxLIwaXYhxofwskN
	huDeooLDBUt1gshVtSsuDQb38vhzAGV0=
X-Received: by 2002:a05:7301:5795:b0:2be:30ca:1a9d with SMTP id 5a478bee46e88-2be4e04c762mr2263362eec.28.1772903922437;
        Sat, 07 Mar 2026 09:18:42 -0800 (PST)
X-Received: by 2002:a05:7301:5795:b0:2be:30ca:1a9d with SMTP id 5a478bee46e88-2be4e04c762mr2263345eec.28.1772903921799;
        Sat, 07 Mar 2026 09:18:41 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f96aa32sm3669831eec.26.2026.03.07.09.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 09:18:40 -0800 (PST)
Date: Sat, 7 Mar 2026 11:18:38 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: ajones@ventanamicro.com, alex@ghiti.fr, anup@brainfault.org,
        aou@eecs.berkeley.edu, atish.patra@linux.dev, jiakaiPeanut@gmail.com,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, pjw@kernel.org
Subject: Re: [PATCH 1/2] RISC-V: KVM: Fix array out-of-bounds in
 pmu_ctr_read()
Message-ID: <bcshd6j3vdeorxxmsmjmj5vi52mmivfe247aw77mr75zsk4llk@h3rxaqe23sb5>
References: <7cv4cq43l33fvpbikecjecfulomzurfmlbjk45u6amvdmnmrhu@7padusm25g5l>
 <20260307023537.3686946-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307023537.3686946-1-xujiakai2025@iscas.ac.cn>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE2NCBTYWx0ZWRfX6oDPV3VmN/do
 oa5GnhsGJ4oosFOFwUBk6ZJxyIwAguBGrIoemMKd2f+l2PhySIsky15QqI26p93Mv+xIB0lzIDf
 Y4p00TSgKYHZ1SonQilshjYuXcNezfvmQi8mVsGqh/oqrUnlR5/YQUuqy+iSuKVs3QMGa2e93Mm
 hqLTT9lrj7aY0ljE3I19ZTLkjMH+9QrqfUAkAGyXbX9P+NI9pw0NLH+YQ+auuSx00Fbt278Ppcy
 qEH11Yzj0tpStqB5YjuqYJikUKs1AnSXH6yfIy6/wQLP0vMgNUeONaeM0/UuU07/idOlFViMsxl
 Z3XM/27rM90brF+ZXg0UeNXT9pVwxR4ZSZKDhrKNDzqo8XUQJV46081qFWcgX/bCgGqhosdiQPb
 7ZGAksyBMGvLSUg4YLKBACxriasenLQPV3acDbMxY77kyfOjD5WN+G177nKmhRPFnwtFPITpZb8
 VKwhIGKs5OGUxWx3TZQ==
X-Proofpoint-ORIG-GUID: gcw6UFhahILmtk1GGbBbn87T26qR7Sei
X-Proofpoint-GUID: gcw6UFhahILmtk1GGbBbn87T26qR7Sei
X-Authority-Analysis: v=2.4 cv=LOprgZW9 c=1 sm=1 tr=0 ts=69ac5df3 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=uecIoWCG_2LCaAR_9GoA:9 a=CjuIK1q_8ugA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603070164
X-Rspamd-Queue-Id: C4E4022CDFD
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
	TAGGED_FROM(0.00)[bounces-73229-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[ventanamicro.com,ghiti.fr,brainfault.org,eecs.berkeley.edu,linux.dev,gmail.com,lists.infradead.org,vger.kernel.org,dabbelt.com,kernel.org];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,oss.qualcomm.com:dkim];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

On Sat, Mar 07, 2026 at 02:35:37AM +0000, Jiakai Xu wrote:
> Hi Andrew,
> 
> Thanks for the review and the suggestions.
> 
> I agree with your feedback. In v2, I will merge the fixes for both
> pmu_ctr_read() and pmu_fw_ctr_read_hi() into a single commit and remove
> the pr_warn, simply returning -EINVAL instead.
> 
> I have two questions regarding the next version:
> 
> 1. Regarding other pr_warns in PMU emulation code:
> You mentioned that other pr_warns in the code might need auditing. Should
> I address those in this patchset (e.g., converting them to pr_warn_once
> or removing them), or is it better to keep this series focused strictly
> on the out-of-bounds fix and handle the logging cleanup in a separate
> patchset later?

Any changes that come out of the pr_warn audit will result in a separate
patch or patches. That work can be done completely separately and submit
as a separate series. Or, if you do it right now, you could append those
patches to this series. Either way works for me.

> 
> 2. Selftests update:
> I noticed that applying this fix causes a regression in
> selftests/kvm/sbi_pmu_test. The test_pmu_basic_sanity function currently
> attempts to read a firmware counter without configuring it via
> SBI_EXT_PMU_COUNTER_CFG_MATCH first.
> 
> Previously, this triggered the out-of-bounds access (likely reading
> garbage), but with this fix, the kernel correctly returns
> SBI_ERR_INVALID_PARAM, causing the test to fail.
> 
> To fix this, I plan to include a second patch in v2 that updates the
> selftest to properly configure the counter before reading. Here is my
> draft for the fix. Does this approach look reasonable to you?

That's good and we should do that, but we should also do negative testing.
So there should be a test case where we try to read a counter without
configuring it and ensure everything fails gracefully.

> 
> Thanks,
> Jiakai
> 
> ---
>  .../testing/selftests/kvm/include/riscv/sbi.h | 28 +++++++++++++++++++
>  .../selftests/kvm/riscv/sbi_pmu_test.c        |  9 +++++-
>  2 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/riscv/sbi.h b/tools/testing/selftests/kvm/include/riscv/sbi.h
> index 046b432ae896..8c172422f386 100644
> --- a/tools/testing/selftests/kvm/include/riscv/sbi.h
> +++ b/tools/testing/selftests/kvm/include/riscv/sbi.h
> @@ -97,6 +97,34 @@ enum sbi_pmu_hw_generic_events_t {
>  	SBI_PMU_HW_GENERAL_MAX,
>  };
>  
> +enum sbi_pmu_fw_generic_events_t {
> +	SBI_PMU_FW_MISALIGNED_LOAD	= 0,
> +	SBI_PMU_FW_MISALIGNED_STORE	= 1,
> +	SBI_PMU_FW_ACCESS_LOAD		= 2,
> +	SBI_PMU_FW_ACCESS_STORE		= 3,
> +	SBI_PMU_FW_ILLEGAL_INSN		= 4,
> +	SBI_PMU_FW_SET_TIMER		= 5,
> +	SBI_PMU_FW_IPI_SENT		= 6,
> +	SBI_PMU_FW_IPI_RCVD		= 7,
> +	SBI_PMU_FW_FENCE_I_SENT		= 8,
> +	SBI_PMU_FW_FENCE_I_RCVD		= 9,
> +	SBI_PMU_FW_SFENCE_VMA_SENT	= 10,
> +	SBI_PMU_FW_SFENCE_VMA_RCVD	= 11,
> +	SBI_PMU_FW_SFENCE_VMA_ASID_SENT	= 12,
> +	SBI_PMU_FW_SFENCE_VMA_ASID_RCVD	= 13,
> +
> +	SBI_PMU_FW_HFENCE_GVMA_SENT	= 14,
> +	SBI_PMU_FW_HFENCE_GVMA_RCVD	= 15,
> +	SBI_PMU_FW_HFENCE_GVMA_VMID_SENT = 16,
> +	SBI_PMU_FW_HFENCE_GVMA_VMID_RCVD = 17,
> +
> +	SBI_PMU_FW_HFENCE_VVMA_SENT	= 18,
> +	SBI_PMU_FW_HFENCE_VVMA_RCVD	= 19,
> +	SBI_PMU_FW_HFENCE_VVMA_ASID_SENT = 20,
> +	SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD = 21,
> +	SBI_PMU_FW_MAX,
> +};
> +
>  /* SBI PMU counter types */
>  enum sbi_pmu_ctr_type {
>  	SBI_PMU_CTR_TYPE_HW = 0x0,
> diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> index 924a335d2262..0d6ba3563561 100644
> --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> @@ -461,7 +461,14 @@ static void test_pmu_basic_sanity(void)
>  			pmu_csr_read_num(ctrinfo.csr);
>  			GUEST_ASSERT(illegal_handler_invoked);
>  		} else if (ctrinfo.type == SBI_PMU_CTR_TYPE_FW) {
> -			read_fw_counter(i, ctrinfo);
> +			/*
> +			 * Try to configure with a common firmware event.
> +			 * If configuration succeeds, verify we can read it.
> +			 */
> +			ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH,
> +			        i, 1, 0, SBI_PMU_FW_ACCESS_LOAD, 0, 0);
> +			if (ret.error == 0 && ret.value < RISCV_MAX_PMU_COUNTERS && BIT(ret.value) & counter_mask_available)

Put () around the & operator. checkpatch should have pointed that out.

> +				read_fw_counter(i, ctrinfo);
>  		}
>  	}
>  
> -- 
> 2.34.1
>

Thanks,
drew

