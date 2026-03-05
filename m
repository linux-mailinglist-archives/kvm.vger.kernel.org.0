Return-Path: <kvm+bounces-72836-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GD15LM20qWkZCwEAu9opvQ
	(envelope-from <kvm+bounces-72836-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 17:52:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2642B215952
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 17:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C8A413041786
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 16:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2A83D567F;
	Thu,  5 Mar 2026 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rT9UbEND"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63666334373;
	Thu,  5 Mar 2026 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772729538; cv=none; b=gSGfoNJSEq0PcGAbpNfd9Lpwae6RoHyYTtKGAC4UbX9HBuxb2sJI4Ah4gCPIdSCTM5Sz6PAWNCapLyJDk+8qdGTQp8tg3gN3TXlEoa7siNQ2w/GXobRn6j42OzK2fwRidG7p0XgzuE8JTNnAHOAP+CIdVeXIaiUlGsu6D7+Kxrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772729538; c=relaxed/simple;
	bh=U8U1ZcaBVXcZiDVbxuUu5UMuJphWudTh/6BKaUhK/ZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XQe29AT5MzBbjwyZYD2dg/wmcWK22xltYJ/5PdAs97yGGVwHaoJMXobmKAWkBBrceqzr9+HEA4vYYB63qLvi/ORwr2xJWzEHmits/7EPdC9GzxQUf6PTYsV1h8J6KnGhss4a3GGu3vH2SbAOaqH0EJTJcHx4n5ESD76YShMGae4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rT9UbEND; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62525PLB1858431;
	Thu, 5 Mar 2026 16:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1yCLCp
	frJynphjqy1T//BPjiIo/Ja19vGPWuvmi3ehY=; b=rT9UbENDBQ+RKxsQrVWQkn
	mUsbwKtFkwzEDU5lGPsOqvZ+GBYKpG0q3B8XNCOVHViEQSnHMhK8PvDJE7d9Pckg
	Msn270Z2MD2d5LOcxtbKmyPQXxJq4342b1Rlbh01QF4ymvloeg1K9Yr0y2tjstFH
	165/CohPNmaamdEwgMEMfBCwnx+89VXiGlUeZg/atBElDlUiYACfIlzUUJ2YME0Z
	O7d2AE67Igzicz76HNDQUK68E1v94wJH9O9AZxGBGw+01J8epUjbQF0s2xDdcDPZ
	WtErM2t0tBdCbPwLLdo1gxCeJ4HgsOmIa7OirfpHD7or+SyBrlohBq5nYbqSV8UQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrjcr8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 16:52:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 625Dxeqp003275;
	Thu, 5 Mar 2026 16:52:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmb2yc8ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 16:52:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 625GqBId50463156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Mar 2026 16:52:11 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30A6120043;
	Thu,  5 Mar 2026 16:52:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C911320040;
	Thu,  5 Mar 2026 16:52:10 +0000 (GMT)
Received: from [9.52.200.39] (unknown [9.52.200.39])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Mar 2026 16:52:10 +0000 (GMT)
Message-ID: <eb741654-e048-4a04-9d4a-0a64e30e5f76@linux.ibm.com>
Date: Thu, 5 Mar 2026 17:52:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: s390: Limit adapter indicator access to
 mapped page
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, mjrosato@linux.ibm.com, freimuth@linux.ibm.com,
        imbrenda@linux.ibm.com
References: <20260303135250.3665-1-frankja@linux.ibm.com>
 <20260303135250.3665-2-frankja@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260303135250.3665-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a9b4c0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=Wveo7z3TGatblUXlsDUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDEzNSBTYWx0ZWRfXyau62z0UoMMR
 2WD4U48b4XXMzHxcojLMQ/MgSpdUgu84xDdkgmoTEUYNbsXtvPSBlJAwLN5/jOyX+qe65cOYaQA
 z84uFyiEvKR0Zen/2V1Fy9CZrs6bY0O7+H/Kl/UkMHspEp2cSp6Tf+eBnalAa0uyLcV95gLe1nC
 5L01NyyObsiPN2Sv4LOPW8zzaHKDYc/kJOq+B5AUP/4swsK00xw+GcKa6K/i29OsyrB5aY7UnVl
 k/NWX7foKQulf4Ir8FHJPRj/KOhg5g5Xc8Flpj4J0s7x54TYSqvqi45eSK/I2Cre1ZkxC27yd4j
 IBP8U6MvYYxZ2O6w5ziKsjOdxGiPzRLPHlBI8wLQfHia4If6wRj4JqcBgBNX5mCFm6t14FlVpbO
 iXzOSWSilxMlGDncBrsO3tNp0u0+nS1cUjIHO/k5uHc9ej4DTRS1VAjwsGxxbH21zckkhSeFVy5
 DhcR4QjV9o2Eep/u9cw==
X-Proofpoint-GUID: gttwn3_N0qlsBxkkG0fzRRSx5tftrvQk
X-Proofpoint-ORIG-GUID: gttwn3_N0qlsBxkkG0fzRRSx5tftrvQk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050135
X-Rspamd-Queue-Id: 2642B215952
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72836-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[borntraeger@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Am 03.03.26 um 14:46 schrieb Janosch Frank:
> While we check the address for errors, we don't seem to check the bit
> offsets and since they are 32 and 64 bits a lot of memory can be
> reached indirectly via those offsets.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
> Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   arch/s390/kvm/interrupt.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 18932a65ca68..1a702e8ef574 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -2724,6 +2724,9 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>   
>   	bit = bit_nr + (addr % PAGE_SIZE) * 8;
>   
> +	/* kvm_set_routing_entry() should never allow this to happen */
> +	WARN_ON_ONCE(bit > (PAGE_SIZE * BITS_PER_BYTE - 1));
> +
>   	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
>   }
>   
> @@ -2852,6 +2855,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
>   			  struct kvm_kernel_irq_routing_entry *e,
>   			  const struct kvm_irq_routing_entry *ue)
>   {
> +	const struct kvm_irq_routing_s390_adapter *adapter;
>   	u64 uaddr_s, uaddr_i;
>   	int idx;
>   
> @@ -2862,6 +2866,14 @@ int kvm_set_routing_entry(struct kvm *kvm,
>   			return -EINVAL;
>   		e->set = set_adapter_int;
>   
> +		adapter = &ue->u.adapter;
> +		if (adapter->summary_addr + (adapter->summary_offset / 8) >=
> +		    (adapter->summary_addr & PAGE_MASK) + PAGE_SIZE)
> +			return -EINVAL;
> +		if (adapter->ind_addr + (adapter->ind_offset / 8) >=
> +		    (adapter->ind_addr & PAGE_MASK) + PAGE_SIZE)
> +			return -EINVAL;
> +
>   		idx = srcu_read_lock(&kvm->srcu);
>   		uaddr_s = gpa_to_hva(kvm, ue->u.adapter.summary_addr);
>   		uaddr_i = gpa_to_hva(kvm, ue->u.adapter.ind_addr);

we could consider a follow-on patch to use the local adapter variable here
and below as well. But not as part of this fix.

