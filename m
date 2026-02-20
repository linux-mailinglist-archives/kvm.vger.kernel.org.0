Return-Path: <kvm+bounces-71399-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGAhKBIomGlqBwMAu9opvQ
	(envelope-from <kvm+bounces-71399-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 10:23:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 405DA166287
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 10:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 51013309607F
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 09:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9980F31B824;
	Fri, 20 Feb 2026 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HXrxUO7K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9375D31AA95;
	Fri, 20 Feb 2026 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771579178; cv=none; b=f3wnNfCQJ98SqxnlhJKfikleC6dcOWJpfaIthcQGZ1mZdZwpCYJthZVRmaovx8dvnJPqvZXDdgYsP8Rgiy7oUic7d6Bq3rOyTjmkUanw2t5slBQj5vPushrA3/B3hw3+AZNFAcq16yVAwsHT7uTgK1iYSYSTZW/zgeV7ZGn348U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771579178; c=relaxed/simple;
	bh=n3jijSEJWU0KpTJLzgbc+d6hbkgn5eenhXNvnUqGO8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rno98+SjeUWuObAB9q57GFWl7r4r5vv6Af0FHJgFvG2TNYd7Uo8nYYSyA5dy11yrj68DJ0iVzGKLQ9tI48WPpCxaJFmbcCk2YIFoEzMJ3hpfU/BKuYoq14Pg9wSIN7i0QzBwjPv8sRY7asiK/XCGziju9BLHUOTurZO7oKI2Ghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HXrxUO7K; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JKwYpD1294743;
	Fri, 20 Feb 2026 09:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=n+rEej
	NezbCFYXEfgSwtRYb1UC2UqeYH5ndwgqsmi7w=; b=HXrxUO7KhWEw3ANwuieXXu
	twyK+QFdHBTnzP48GlpBc0dLMlmKj/g/0gvKbELUBJ80Fo4/XtwmM/Kct+4mtM4v
	C64gJoN/Zem6ZVxGlv26zACyt2fIl5PiOAlxNiToH7xkC8x0i1hLYzZhHEXHp4wF
	+Vt9t/ko1E3Y/ACzis+IcH6+qSNzTSeeJQ5OvyfOjbMKZrYNyK3TBugcX7HOcPeH
	/1Ji8syZNQj/g7CgIr9Lh8DpS3PvF4ziHf5ItCnTfNlS2iEN2Y5JeKL6FrzRqeGj
	3KTVRMnUu6F7cFyuG/r730ulS8exmug2YMXLi53lBGNGfZJL7A5E+0SmofpqKN5A
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj64gvcb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 09:19:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61K93PUd011912;
	Fri, 20 Feb 2026 09:19:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb277vu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 09:19:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61K9JVwa50856320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 09:19:31 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61F9A20040;
	Fri, 20 Feb 2026 09:19:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB2AD2004B;
	Fri, 20 Feb 2026 09:19:30 +0000 (GMT)
Received: from [9.111.87.59] (unknown [9.111.87.59])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Feb 2026 09:19:30 +0000 (GMT)
Message-ID: <8d5b9395-0d35-4558-9020-71cc634595c2@linux.ibm.com>
Date: Fri, 20 Feb 2026 10:19:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] KVM: s390: vsie: Refactor handle_stfle
To: Christoph Schlameuss <schlameuss@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
References: <20260212-vsie-alter-stfle-fac-v1-0-d772be74a4da@linux.ibm.com>
 <20260212-vsie-alter-stfle-fac-v1-3-d772be74a4da@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20260212-vsie-alter-stfle-fac-v1-3-d772be74a4da@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rgBSdZUzypu-4eLj8nIjVrlmwy5-cn1M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA3OSBTYWx0ZWRfX8uWSQOW/UHV/
 CTG+Q0LuVXmlpija1GY/TQyDtRKeDIuwzoNfU7RHN6n2use3dxyHAQt+EWxvvlNfaQT+g16BRxc
 S42NHytWyRMQOzQidj5yWg5bnMsJx1LMszfH9CXIJwOccGarkBwih+/NTMmROn7314Jj4k5nzUn
 Gd98oWsUyZ7HOnsgLT2Kec4xZeVIA0Vjf5ms8iM1RGOE709BWQLzwJZ/gkHuIn+TUTC/AgtZW0f
 /ix2ZaaydBLkne87989Q/n0QsHcjoFbrbbGlOdnSeaMq2jybc2vMXUDueus9WAMnqBu7KorMI3+
 u0TT6RDBed6wX0EiD6bLmA/Gw8IM34QRFmGsD7S2VGrIojjhWKV0bY0p1jRQjjeHwWIanEAeG93
 z6VXmc06rITeMZ4wrPhiqUlx8FJQ3rYhCwx1JtEymxCuU2J/vQwKwyQ5c8PTnVhKsd740ZgTZ54
 qT9sjxiV+w73VpIMPMg==
X-Proofpoint-GUID: rgBSdZUzypu-4eLj8nIjVrlmwy5-cn1M
X-Authority-Analysis: v=2.4 cv=U+mfzOru c=1 sm=1 tr=0 ts=69982728 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=XpNOKP_mB-KeKCqz8qQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602200079
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71399-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 405DA166287
X-Rspamd-Action: no action

On 2/12/26 10:24, Christoph Schlameuss wrote:
> From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> 
> Use switch case in anticipation of handling format-1 and format-2
> facility list designations in the future.
> As the alternate STFLE facilities are not enabled, only case 0 is
> possible.
> No functional change intended.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

[...]

>   /*
>    * Try to shadow + enable the guest 2 provided facility list.
>    * Retry instruction execution if enabled for and provided by guest 2.
> @@ -1017,29 +1037,30 @@ static void retry_vsie_icpt(struct vsie_page *vsie_page)
>    */
>   static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   {
> -	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> -	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
> +	u32 fac = READ_ONCE(vsie_page->scb_o->fac);
> +	int fac_list_format_mask, fac_list_format;
> +	u32 fac_list_origin;
> +	bool has_astfleie2;

I hate the fact that we called the fld "fac", we have names for that 
field and the parts that it consists of.

Drop the "fac_list_" prefix.
Pull the test_kvm_cpu_feat() up and directly assign has_astfleie2 so 
that the code below is more readable.


Code looks fine to me though

>   
> -	/*
> -	 * Alternate-STFLE-Interpretive-Execution facilities are not supported
> -	 * -> format-0 flcb
> -	 */
> +	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct vsie_page, fac), 8));
>   	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
>   		retry_vsie_icpt(vsie_page);
>   		/*
>   		 * The facility list origin (FLO) is in bits 1 - 28 of the FLD
>   		 * so we need to mask here before reading.
>   		 */
> -		fac = fac & 0x7ffffff8U;
> -		/*
> -		 * format-0 -> size of nested guest's facility list == guest's size
> -		 * guest's size == host's size, since STFLE is interpretatively executed
> -		 * using a format-0 for the guest, too.
> -		 */
> -		if (read_guest_real(vcpu, fac, &vsie_page->fac,
> -				    stfle_size() * sizeof(u64)))
> -			return set_validity_icpt(scb_s, 0x1090U);
> -		scb_s->fac = (u32)virt_to_phys(&vsie_page->fac);
> +		fac_list_origin = fac & 0x7ffffff8U;
> +		has_astfleie2 = test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ASTFLEIE2);
> +		fac_list_format_mask = has_astfleie2 ? 3 : 0;
> +		fac_list_format = fac & fac_list_format_mask;
> +		switch (fac_list_format) {
> +		case 0:
> +			return handle_stfle_0(vcpu, vsie_page, fac_list_origin);
> +		case 1:
> +		case 2:
> +		case 3:
> +			unreachable();
> +		}
>   	}
>   	return 0;
>   }
> 


