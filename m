Return-Path: <kvm+bounces-72822-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mA7dDZSNqWki/gAAu9opvQ
	(envelope-from <kvm+bounces-72822-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 15:05:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 952A6212FDA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 15:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6D03D301A53F
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 14:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8E63A1A49;
	Thu,  5 Mar 2026 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IpvAJGq2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928EE22258C;
	Thu,  5 Mar 2026 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719499; cv=none; b=HF8O2WYQqfsP3tDA2gT8JpN11c07v7LYbiQ/hOXQUIu6vX4NOfLDnbwNUGOMWXmzFcBC5uGl0fjYORJd4sFZMmzbqcfxuiO0np/VPkOFpfCqQU4x8xlOxMTb3qsvy8Q6W8m3DGXK15vTqpFNxYXJpaQ5LN7tSUafUtDqpW015Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719499; c=relaxed/simple;
	bh=kXAlvYTnWxCa2JtVg7jARp4neeMYO8LpwlXD0aV/0B4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qoUOpTdELzYiuDELrK7UlYLa0/UMPdK2KGhcFALbJJQMzldyfif8l6BjlJuxdKM0lhQkJIQx7N14t8Yr6R2UeAloiQzHP8pp3X3DIN/oLMQelMf/70BuoVC0wHnHDU04AnZvmYuWD6jtmmCvphKzmjcauIWA9OH9DH0k675j1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IpvAJGq2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625CFnAW1118733;
	Thu, 5 Mar 2026 14:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=M2iMHy
	+uU2zWggwyhgY7tSwwmaI0Cj24dPzl8p+zrbI=; b=IpvAJGq2F5FWeXcUdDXl09
	Im+C0bQLQlW0YaQQg3z61CZMwKgbYyw75DxVhGq2BDw0ARrMO4H42LTN4c1HYG48
	any16d5+ZKWCktSpxfAmRjIj5GHvHMKdUGL+KBH9OM4mXtbNNwY2Qk7qI0E/MA6T
	xBcYEsBqPZU7SMbAzy0g4JbzuIqvqBohChwYx/3segvcJx29NuGG8pqY8We4TC93
	DI1LYiRmQ92pXUSkVkbHrs2U3F4JfX4ui4oCl6ZSAdIQy5lNpWwdVGhcP1/b0y64
	+bwv1PzioJnq1Ydb0WFi5+xjkmGGN/BelbiAgXs21GNuG5Y0pG9wDCRUosuDqRsw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrjc0nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 14:04:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 625DxeCu003275;
	Thu, 5 Mar 2026 14:04:56 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmb2ybnc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 14:04:56 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 625E4srj30999048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Mar 2026 14:04:55 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D92EC5805E;
	Thu,  5 Mar 2026 14:04:54 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29DFE5805B;
	Thu,  5 Mar 2026 14:04:54 +0000 (GMT)
Received: from [9.61.30.112] (unknown [9.61.30.112])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Mar 2026 14:04:54 +0000 (GMT)
Message-ID: <9eef692a-7d8f-4082-89e0-22210c407395@linux.ibm.com>
Date: Thu, 5 Mar 2026 09:04:53 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: s390: Limit adapter indicator access to
 mapped page
From: Matthew Rosato <mjrosato@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, freimuth@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
References: <20260303135250.3665-1-frankja@linux.ibm.com>
 <20260303135250.3665-2-frankja@linux.ibm.com>
 <be334141-01d4-4398-b89f-09f84519f29d@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <be334141-01d4-4398-b89f-09f84519f29d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a98d89 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=svPRbppwVNfn8ARwPMIA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDEwOCBTYWx0ZWRfX/TQQJeOlfHFg
 Tk9KKTy17l7TrMB0/G51gII37kcz9ftOS2u8zetR7qwNsU4iqGkWRWwxPl2PCce2PyHxIRdS+/2
 fZnsIGFlddbBikIjmU6SNNzib2bdASzZoifN6ewLP0/Bq/SFTeT0i3MFuPSdsNbCplGKNS4FmCh
 wXgOXSIVuxNTR13MqdxnyCW78jLc0MiQU0+neiv40BFatASVaP2a3B6VIvNI2KUFvh6jrss2evV
 V35zv2HD36l9OTWdfj5608BSZZZNtjEUDbxk5vENird++WLvyW2eK+2dCECMZceqnUdYecbZEhG
 dgvDZ7LkrH5MbqPnWK27UEnR3Lf8yZIn4JUhch0ShZy/Ps6tf1/eLdHIAfcZOZJpn04YEirKM8D
 mA73hqvEUV/ZAzs5p5TUR2uulCi/dSE5kbG53h7e5J5up3y4UqQy+uG7uJhJkIdvumwVp28FxTa
 S59arejb+caUbFSXmow==
X-Proofpoint-GUID: 3bifwhAow5p74o1r3xNGsuwDOsLPw0GQ
X-Proofpoint-ORIG-GUID: 3bifwhAow5p74o1r3xNGsuwDOsLPw0GQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050108
X-Rspamd-Queue-Id: 952A6212FDA
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
	TAGGED_FROM(0.00)[bounces-72822-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[mjrosato@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

On 3/4/26 3:16 PM, Matthew Rosato wrote:
> On 3/3/26 8:46 AM, Janosch Frank wrote:
>> While we check the address for errors, we don't seem to check the bit
>> offsets and since they are 32 and 64 bits a lot of memory can be
>> reached indirectly via those offsets.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
>> Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 

Like with v1, I used a modified QEMU to attempt various invocations to convince myself this works.  So feel free to also add:

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>



