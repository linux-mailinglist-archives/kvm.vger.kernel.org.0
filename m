Return-Path: <kvm+bounces-71903-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id d/7oLwCJn2nMcgQAu9opvQ
	(envelope-from <kvm+bounces-71903-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:42:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0FAC19EEF9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8F053301B87C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 23:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9840B385521;
	Wed, 25 Feb 2026 23:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Nx61voTY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DB7376BFF;
	Wed, 25 Feb 2026 23:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772062971; cv=none; b=gh9ntpVlSR7lkqq10rRiy7MH9Dgl607zS9lsjxQ5VsrcXPv+E+ioKuF6DX2Ll1QKXBJu0PmP5qzKd0GGUZz8Ayr2pL8OqQI+YVbN9C3d9gcSfXLhPuxoH6nLcqTg2FSSjUU5fjMSC3oGupQ/bXWawtPEN9YYaMNH3SVYFbRNOok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772062971; c=relaxed/simple;
	bh=LJlpi5wuKe2Ygqgec+SIKK0p59KvieoD4ReMMDS1aGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZcleSPwnMC2Pgo15B5AS+fAIjHY+hQIBpgdYLfBRfOMyzMP3hSYJa7wlMYHJybGHpip8H5wdLxChbVVWmPShIBlWroYnFxoPAAGvUJn7wrRrwBvXpenVv6L5GMkDHI2Mn6KvgjesBXyVGoXnOeLX2Q6R4GPj5kHUCGEv48xggQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Nx61voTY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PKla3W2460426;
	Wed, 25 Feb 2026 23:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hmdacT
	ALJh28DvVcdwZtkaL65/31pNSDaP4wG4Nd1t0=; b=Nx61voTYz+2nyc8256tY6C
	jsbH5g83YI7wWorMCCUvjt2I0o/ypc0lVAfNtYvkUDY52N7GZUt/YvTBAJV0PwvE
	UsLagrP5LlqIc5JhT4Zy6QmUTW4dXUTRi96dJjwwhWWF8oF5kfbNoVHaNDfa6B5O
	jxN+hdkYEh/3Aeacx9u1MVfzNEc3p6Ik0esRvDOUTaF0fiWBVniYQ4+xE//C847e
	0MH2DFThS5tmrjuyQSKPTELWQiTLlS7AxYlVYDUrdZLY6q/c/KugTCbX8jinUbNK
	idC6ptlWYeJOs0d6rjCcaz41+cS96ubsdLPQo0EMgoCMHb77HYOIMnRbx1HhUhJQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4cr35n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 23:42:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61PMbpAn015962;
	Wed, 25 Feb 2026 23:42:49 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfq1sr757-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 23:42:49 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61PNglXd66191660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 23:42:47 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68B9B5805D;
	Wed, 25 Feb 2026 23:42:47 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD12D5805A;
	Wed, 25 Feb 2026 23:42:46 +0000 (GMT)
Received: from [9.61.38.72] (unknown [9.61.38.72])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Feb 2026 23:42:46 +0000 (GMT)
Message-ID: <67c8bb91-32ac-4e1e-8b97-9ff8f55a4e61@linux.ibm.com>
Date: Wed, 25 Feb 2026 18:42:46 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: s390: Limit adapter indicator access to mapped
 page
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com, freimuth@linux.ibm.com
References: <20260217090230.8116-1-frankja@linux.ibm.com>
 <20260217090230.8116-2-frankja@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20260217090230.8116-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GEFaDYcRZuzS82YOs7OZ3M7l4lHQHZeK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNiBTYWx0ZWRfXzLRXARkGE/6s
 zgGr/9EyyecA3uozxtH/ogtUfhjEwj8WNBmHCER9il+QGJqIlo2kzTv5wuvwL4xMCntiPrPslxP
 5n5vuUS74fwyDC3bnGvbdZIxXjGBqDfq2n7IwIqTxZN72KAbJL3mKfnglO49V0yGtCQuxN5nx3a
 AxxLRmcmhm4pCKsZ9d0SjSYzU4QfRNgr8COoZWstAOf0naGmhX+hj/a3l8buq/rgPflbtfDMjcX
 UHY6Jbn75gn/9zIfCLco2K08eXdfkjEPWl+jepfZo+/tnULpj/8eonhPOdk9XayY8qSpXvHobTN
 Wh1+edZcnUFNmEDpKwlfiKxZPbCZ/pLp8Rhc8EpS4AvwfPCAq4rquRFUVgAiyFLRwl+TrKpYmAM
 dRWvW9odNxS7ti4LsDzcc8IxmaIGOH23YkGWvEUELD9Gd/8jrk6vQ0H+ysdjnOmw6mZk7D105Os
 4rQWwAO3SYRFHwXGGCQ==
X-Proofpoint-GUID: GEFaDYcRZuzS82YOs7OZ3M7l4lHQHZeK
X-Authority-Analysis: v=2.4 cv=bbBmkePB c=1 sm=1 tr=0 ts=699f88fa cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=G87O5jEwh3kmkZiQiTUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602250226
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71903-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[mjrosato@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: F0FAC19EEF9
X-Rspamd-Action: no action

On 2/17/26 3:54 AM, Janosch Frank wrote:
> While we check the address for errors, we don't seem to check the bit
> offsets and since they are 32 and 64 bits a lot of memory can be
> reached indirectly via those offsets.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
> ---
>  arch/s390/kvm/interrupt.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 1c2bb5cd7e12..cd4851e33a5b 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -2724,6 +2724,9 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>  
>  	bit = bit_nr + (addr % PAGE_SIZE) * 8;
>  
> +	/* kvm_set_routing_entry() should never allow this to happen */
> +	WARN_ON_ONCE(bit > (PAGE_SIZE * BITS_PER_BYTE - 1));
> +
>  	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
>  }
>  
> @@ -2852,6 +2855,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			  struct kvm_kernel_irq_routing_entry *e,
>  			  const struct kvm_irq_routing_entry *ue)
>  {
> +	const struct kvm_irq_routing_s390_adapter *adapter;
>  	u64 uaddr_s, uaddr_i;
>  	int idx;
>  
> @@ -2862,6 +2866,14 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			return -EINVAL;
>  		e->set = set_adapter_int;
>  
> +		adapter = &ue->u.adapter;
> +		if (adapter->summary_addr + BITS_TO_BYTES(adapter->summary_offset) >=
> +		    (adapter->summary_addr & PAGE_MASK) + PAGE_SIZE)
> +			return -EINVAL;
> +		if (adapter->ind_addr + BITS_TO_BYTES(adapter->ind_offset) >=
> +		    (adapter->ind_addr & PAGE_MASK) + PAGE_SIZE)
> +			return -EINVAL;
> +


I think this is slightly off.

The offset should indicate a bit offset from the beginning of the byte, so offsets 0-7 are all within the same byte as the specified address, 8-15 are in the next byte, etc.

I hacked QEMU and tested something like...
1) addr 8126efff offset 7 -- this would be the very last bit in the page.
2) addr 8126efff offset 8 -- this would be the very first bit in the next page.  
3) addr 8126efff offset 9 -- this would be the 2nd bit in the next page.

I expected (1) to pass while (2) and (3) were rejected, but all 3 were rejected by your check.

I think the problem is that BITS_TO_BYTES rounds up.  So:
BITS_TO_BYTES(0) = 0
BITS_TO_BYTES(1..8) = 1
BITS_TO_BYTES(9..16) = 2
and so on.

But your offset check expects
0..7 = 0
8..15 = 1
and so on.

AFAICT replacing BITS_TO_BYTES(offset) with (offset / 8) would work.


>  		idx = srcu_read_lock(&kvm->srcu);
>  		uaddr_s = gpa_to_hva(kvm, ue->u.adapter.summary_addr);
>  		uaddr_i = gpa_to_hva(kvm, ue->u.adapter.ind_addr);


