Return-Path: <kvm+bounces-71998-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHzwFbNVoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71998-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:16:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A6691A7559
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2AEA230BE1F3
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9653A372B44;
	Thu, 26 Feb 2026 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ccdIqG4u"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2027363C67;
	Thu, 26 Feb 2026 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114626; cv=none; b=nrYUzV8z6+pP6aadoAk4v2q2V+vGwgG881/o/HS5ARoGXHP56P5EcjxRwbnGrGuXqGKDWWDyI+Pvbk8RWeXhcwYQQkVzv9m80CFsfsv3WP80Zyhu/8coCbPc2Mik+h++l5up6X6lWeXTRKUmQo+hodqTEFxfAITS0cUxxHMWh6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114626; c=relaxed/simple;
	bh=TGTc+iy5BrdlOPZCyDdQy2gTRrnVhB/7YQfvyKlN4xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f3QN6uCXD9ECFKlD67GXd6AF7Y5cMhs8AoysAresld20ECKEgmnoEPulxHrU7/M9Cg7ezb0H4oVtuJC37ifr6ptCf/prHGYUpQIP8LhEcfChPYNgwbmEBplgGJllQHz6kwNqwsUokykn4qcZ9KaJJK29vZ3uLOr1mwGgrWWQL4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ccdIqG4u; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q9XHBi2347259;
	Thu, 26 Feb 2026 14:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YzKEkB
	RpYafOP3d+slpakxYfL4C894NUmgnNRW74a2w=; b=ccdIqG4uVsfSzE8WeKt1Tp
	3vP/qHZgedZgZxr+EdDpQZLWCZc8ZchYlwQJCpK/JMlH1MU6s19fsr+/q0fkz5P2
	JUKf7Jy8xguiE/SnM+SNrkIWYFOCNBZo+K/yIu0k/dlvfqijvtnBTcQ2sgSU1x+2
	vwQztgydaooTZi9MtEhJmX4l7asM2j7cLwogKekn9XqFCWBa7wuxLabcZkqc5l47
	twMXbmUEhRYRXKuoH/suWLLWjLmGHJwJQVKZp/ziEAmurqNn/rJfKTknt6ePEnZU
	VXcKO5yjUYrIMIf0ElZXFRccKjQwlIA4yoqpbJlcEB6wTcQLWG2KXK3M0cy43wLw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ch858v7jw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 14:03:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QCsjme013411;
	Thu, 26 Feb 2026 14:03:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdybwg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 14:03:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QE3dsD52035872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 14:03:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFAAF2004E;
	Thu, 26 Feb 2026 14:03:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68F1220043;
	Thu, 26 Feb 2026 14:03:39 +0000 (GMT)
Received: from [9.111.63.198] (unknown [9.111.63.198])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Feb 2026 14:03:39 +0000 (GMT)
Message-ID: <8b146431-a45a-42ae-8b51-0856c0f3d038@linux.ibm.com>
Date: Thu, 26 Feb 2026 15:03:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: s390: Limit adapter indicator access to mapped
 page
To: Matthew Rosato <mjrosato@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com, freimuth@linux.ibm.com
References: <20260217090230.8116-1-frankja@linux.ibm.com>
 <20260217090230.8116-2-frankja@linux.ibm.com>
 <67c8bb91-32ac-4e1e-8b97-9ff8f55a4e61@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <67c8bb91-32ac-4e1e-8b97-9ff8f55a4e61@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDEyMyBTYWx0ZWRfXys7Nz1MD8ihE
 JXtgoVFoxK0do2Radci/0OUWx+vGDupvzSK9S5RAYGZpTxFpFwaksUNy+HWe07tQM2/Bih6hkDA
 dvgwCunX8ZkPQw3lMgCqgbs70+WXzP8ADjB3/rLeFZDpZzekqyED375Ufy0bVcv5fKxuCYFAwI7
 C3Rb53nr5sj00SwcpcLdNKMEuttR4mPf+Hv5Hqlv22H5jeEQWlRFAOH5unu0+SQeOlfVSkO/Tdz
 APyCYkpsvOd/VPD1ViVwPHqUiZ5e0pfAL6ORDUXbFljwNgjaaSzzcAlofW79qg9wLHtCn/x2MeQ
 Z+m5gP6O1506mKh7Gd9Gbss59+GTjvbNtoIjQG7eATxwqIl+8nWHCOpgMfQMa3FfWE190J7YGpO
 MTcaH5eMi9MREn4Tp2OLD7wd8NYEN7NbkZG6Nr66dP1IzCsaUiVPqB4bgn38+1OAZj7Ij/WhP8n
 CbrmsPcLv2QYZEUviQg==
X-Proofpoint-GUID: 5H7hgd7Z5DO_OZ28YKctE4OEErHqWbyO
X-Authority-Analysis: v=2.4 cv=S4HUAYsP c=1 sm=1 tr=0 ts=69a052c0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=l1inpYFEJG_sGDLN6k8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 5H7hgd7Z5DO_OZ28YKctE4OEErHqWbyO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260123
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71998-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 1A6691A7559
X-Rspamd-Action: no action

On 2/26/26 00:42, Matthew Rosato wrote:
> On 2/17/26 3:54 AM, Janosch Frank wrote:
>> While we check the address for errors, we don't seem to check the bit
>> offsets and since they are 32 and 64 bits a lot of memory can be
>> reached indirectly via those offsets.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
>> ---
>>   arch/s390/kvm/interrupt.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index 1c2bb5cd7e12..cd4851e33a5b 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -2724,6 +2724,9 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>>   
>>   	bit = bit_nr + (addr % PAGE_SIZE) * 8;
>>   
>> +	/* kvm_set_routing_entry() should never allow this to happen */
>> +	WARN_ON_ONCE(bit > (PAGE_SIZE * BITS_PER_BYTE - 1));
>> +
>>   	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
>>   }
>>   
>> @@ -2852,6 +2855,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
>>   			  struct kvm_kernel_irq_routing_entry *e,
>>   			  const struct kvm_irq_routing_entry *ue)
>>   {
>> +	const struct kvm_irq_routing_s390_adapter *adapter;
>>   	u64 uaddr_s, uaddr_i;
>>   	int idx;
>>   
>> @@ -2862,6 +2866,14 @@ int kvm_set_routing_entry(struct kvm *kvm,
>>   			return -EINVAL;
>>   		e->set = set_adapter_int;
>>   
>> +		adapter = &ue->u.adapter;
>> +		if (adapter->summary_addr + BITS_TO_BYTES(adapter->summary_offset) >=
>> +		    (adapter->summary_addr & PAGE_MASK) + PAGE_SIZE)
>> +			return -EINVAL;
>> +		if (adapter->ind_addr + BITS_TO_BYTES(adapter->ind_offset) >=
>> +		    (adapter->ind_addr & PAGE_MASK) + PAGE_SIZE)
>> +			return -EINVAL;
>> +
> 
> 
> I think this is slightly off.
> 
> The offset should indicate a bit offset from the beginning of the byte, so offsets 0-7 are all within the same byte as the specified address, 8-15 are in the next byte, etc.
> 
> I hacked QEMU and tested something like...
> 1) addr 8126efff offset 7 -- this would be the very last bit in the page.
> 2) addr 8126efff offset 8 -- this would be the very first bit in the next page.
> 3) addr 8126efff offset 9 -- this would be the 2nd bit in the next page.
> 
> I expected (1) to pass while (2) and (3) were rejected, but all 3 were rejected by your check.
> 
> I think the problem is that BITS_TO_BYTES rounds up.  So:
> BITS_TO_BYTES(0) = 0

ugh, right.


> BITS_TO_BYTES(1..8) = 1
> BITS_TO_BYTES(9..16) = 2
> and so on.
> 
> But your offset check expects
> 0..7 = 0
> 8..15 = 1
> and so on.
> 
> AFAICT replacing BITS_TO_BYTES(offset) with (offset / 8) would work.

Yeah, rounding down should work.
I wanted to have a fancy macro but didn't work out...

I'll re-spin and make sure the test will catch this problem as well as 
the issue I'm trying to fix.

