Return-Path: <kvm+bounces-70445-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBkyLToBhmlhJAQAu9opvQ
	(envelope-from <kvm+bounces-70445-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:56:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D01FF589
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BE4C8300E449
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2381425CD9;
	Fri,  6 Feb 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OJQd88LL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2284C423A8E;
	Fri,  6 Feb 2026 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770389787; cv=none; b=WG6jIGJ/6U4ST1uP9ssKl+4OckWWxFO3qftjLdc6xe/997wCOSYIspSPEW81CaD60oz0e+ifXxV0TTsiakFS8A2l8+Kncz63nCDfF9uZTSP9Ss5mtviVA8+AC9+JA4N0avmQZrBP0IirmGgm7RNRth8OjRsJGkSCsYtCxAW54tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770389787; c=relaxed/simple;
	bh=e5NaayvadqX37hPlIbigs1pFVlOG1UruqzAjHekCHDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qGb2KUrAWWqF0uLVANekfYOxVJ2qobtZKe9VgULeswi2N1L3ebAs7r50X96Jb77bDwDjjdmU/Mbm5R1core8LpqEJaczAvmi33eASsoraSXov9o4rDw06aGwW5R9f1l4uJIQz1+hdN/djZyKx7ocLVpybMZUpiIm33HlcSlsQbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OJQd88LL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6162qa7j004012;
	Fri, 6 Feb 2026 14:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9Q/VXs
	zN4SnQIVTN5iTZIvCzlCENRnuXj/XyYUdqdEM=; b=OJQd88LLHbmNL/0V10QVO/
	XSBkIKrAlRHrwQieY1vg9dEqJs7p3hDkICLVR/aUR6FebFIPp28mAN1FenOXaedg
	1n047QGUdU2mRGTrBaPBSNZ1YAYm/CI98cvfm1wC5bFCc838IYDmIFGgsmtU6jan
	ts0Q+muLQ/ItZdjjjLeezcetC2UMnFC3cT2lchWPgEp/dkx6A2TUpajGL0V1NjpL
	SBfNfwqlhn5PU8BuMaHjQVlDIy7dPJFOvnT5U0N/Soh+jkij6h8X2pNDtZhCveLn
	zdANKVMIvXTQ/v8ZXNFMbCqrkIJ3r69mx7TaZ1C5xnSH44vl559zNymvtTeNMQiQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f6v605-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:56:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616DfpvX005938;
	Fri, 6 Feb 2026 14:56:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1x9jpacm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 14:56:23 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616EuJlZ49152500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 14:56:20 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0D042004B;
	Fri,  6 Feb 2026 14:56:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EE5720040;
	Fri,  6 Feb 2026 14:56:19 +0000 (GMT)
Received: from [9.111.63.249] (unknown [9.111.63.249])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 14:56:18 +0000 (GMT)
Message-ID: <f5c07226-f748-46c9-a59b-e31494a5524f@linux.ibm.com>
Date: Fri, 6 Feb 2026 15:56:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] KVM: s390: Use guest address to mark guest page
 dirty
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, gra@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@kernel.org, gerald.schaefer@linux.ibm.com
References: <20260206143553.14730-1-imbrenda@linux.ibm.com>
 <20260206143553.14730-2-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 xsFNBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABzSVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+wsF3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbazsFNBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABwsFfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
In-Reply-To: <20260206143553.14730-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RoEZUxP-Kh0E2yKTo9Wib_V9vxU3hUPt
X-Authority-Analysis: v=2.4 cv=drTWylg4 c=1 sm=1 tr=0 ts=69860118 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=tCpJQo87cnYZKYisdpgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: RoEZUxP-Kh0E2yKTo9Wib_V9vxU3hUPt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEwNyBTYWx0ZWRfX/ckiGbArCsNL
 9xgplBEoQVlV35WO13vE545QisGUjcD80WAZBMrC64H8mZf5nZc34mxqHMO7Dp1s6wiaLorqFqx
 nn5T03iDwxBczfR+8f9A4xoGW4mZ4LSRjJxb6wM4/Lf+F68qv9DUppFUEcA8BlzI3zvc4ysPit5
 DVFKNtekntYb/ZBr1hjz4l4yRwffvtkxt2rNqv27+hSK8QuO8FiLrzn2B1zjGSE4+0ruMJF2/3D
 o0Ff1DiezmEUyAT9lGc7FUFO6GSJZYL8D+tTlVfsQCpHajTkw3ncxEmjaQUAbU62eNrVK//fFOd
 jGQD8IvGULk18ehHvyhg2ell41+gpmg5eQhwXZTCd7vTBHS4J+O8wB6DdJe5Hzye+iA1aIWLCBj
 dqOTIImkXWjf3KJjivCmvUg+qE1eh7n6NvICPFtXSIdGC3xjknjiDHHx7KaEsqrBAQOTtb+nUSW
 dbMwXaP8rfWUWprd9+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_04,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060107
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
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_FROM(0.00)[bounces-70445-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: C2D01FF589
X-Rspamd-Action: no action

On 2/6/26 15:35, Claudio Imbrenda wrote:
> Stop using the userspace address to mark the guest page dirty.
> mark_page_dirty() expects a guest frame number, but was being passed a
> host virtual frame number. When slot == NULL, mark_page_dirty_in_slot()
> does nothing and does not complain.
> 
> This means that in some circumstances the dirtiness of the guest page
> might have been lost.
> 
> Fix by adding two fields in struct kvm_s390_adapter_int to keep the
> guest addressses, and use those for mark_page_dirty().
> 
> Fixes: f65470661f36 ("KVM: s390/interrupt: do not pin adapter interrupt pages")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Ouff
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>


We had so many of these issues and I wonder if we should move away from 
making everything u64 and enforce type checks in some form.

> ---
>   arch/s390/kvm/interrupt.c | 6 ++++--
>   include/linux/kvm_host.h  | 2 ++
>   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index f55eca9aa638..1c2bb5cd7e12 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -2768,13 +2768,13 @@ static int adapter_indicators_set(struct kvm *kvm,
>   	bit = get_ind_bit(adapter_int->ind_addr,
>   			  adapter_int->ind_offset, adapter->swap);
>   	set_bit(bit, map);
> -	mark_page_dirty(kvm, adapter_int->ind_addr >> PAGE_SHIFT);
> +	mark_page_dirty(kvm, adapter_int->ind_gaddr >> PAGE_SHIFT);
>   	set_page_dirty_lock(ind_page);
>   	map = page_address(summary_page);
>   	bit = get_ind_bit(adapter_int->summary_addr,
>   			  adapter_int->summary_offset, adapter->swap);
>   	summary_set = test_and_set_bit(bit, map);
> -	mark_page_dirty(kvm, adapter_int->summary_addr >> PAGE_SHIFT);
> +	mark_page_dirty(kvm, adapter_int->summary_gaddr >> PAGE_SHIFT);
>   	set_page_dirty_lock(summary_page);
>   	srcu_read_unlock(&kvm->srcu, idx);
>   
> @@ -2870,7 +2870,9 @@ int kvm_set_routing_entry(struct kvm *kvm,
>   		if (kvm_is_error_hva(uaddr_s) || kvm_is_error_hva(uaddr_i))
>   			return -EFAULT;
>   		e->adapter.summary_addr = uaddr_s;
> +		e->adapter.summary_gaddr = ue->u.adapter.summary_addr;
>   		e->adapter.ind_addr = uaddr_i;
> +		e->adapter.ind_gaddr = ue->u.adapter.ind_addr;
>   		e->adapter.summary_offset = ue->u.adapter.summary_offset;
>   		e->adapter.ind_offset = ue->u.adapter.ind_offset;
>   		e->adapter.adapter_id = ue->u.adapter.adapter_id;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d93f75b05ae2..deb36007480d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -645,7 +645,9 @@ static inline unsigned long *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
>   
>   struct kvm_s390_adapter_int {
>   	u64 ind_addr;
> +	u64 ind_gaddr;
>   	u64 summary_addr;
> +	u64 summary_gaddr;
>   	u64 ind_offset;
>   	u32 summary_offset;
>   	u32 adapter_id;


