Return-Path: <kvm+bounces-72827-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBUnKDanqWlSBwEAu9opvQ
	(envelope-from <kvm+bounces-72827-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:54:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 07EE8214EAE
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:54:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ACE06315D1AC
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 15:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BAD93A5E6D;
	Thu,  5 Mar 2026 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YcONHcn0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EEE2BD597;
	Thu,  5 Mar 2026 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725486; cv=none; b=URz8wT7NycZIBUNdM5+i4EGpyiuUXSJGOGq1MduRMS5MJR5RKeoF/c50fixR558afv3ECZJ0RHl1v3xTsN54kC9Ghhf+1Al18Rnu1q+gwxpOy3GtxKwlEN7K5PnuMc5MtOxBP7GEhP0lMATxc0cjWDQ6qfe50cZj8N0vy0IVkuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725486; c=relaxed/simple;
	bh=NqtJ+trbu4iGMt4kIEck36sihnVvTfkaoSyiJqUOlMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sbcIMONaKJBK1u2FwxpZLrTZ8HF48SOgZqxP1jzfJKiY2d9+CsqJ0QECNbC7dfO5rim2ixieDzAyLgttITB79ygb79xaqpMFS9GKmgE3ZrFSNE+7/BGdKV5BvrC5ywbUEoiL0gow8YdTsklfvVfpNLFbFdIdQO5YcoX6Oos2uF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YcONHcn0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625EqNSg1079188;
	Thu, 5 Mar 2026 15:44:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=y5RiM5
	y4h+BeLhlwGRFKjrhFJXZDo+/Y58qpKUHgQCg=; b=YcONHcn0aT3Ul+qBh1mJSB
	7AYj6Yp9Apbjjcun9DitVBuuvhwM0knF07y35exXPYwcWOwsAcz3OxAZXmoKGJTI
	KGoWEsywjUYx96nI8iiwdvjOPpOVrLkumg7rZBfoG4k/OqxtE6T/qojsyNJYY0CK
	+yHL1GaKQhiKnQns/VqbwWhnEpTFTPO7pQmEX7GrdONf2yk21MdSF2INh0mOzfTj
	HnpqirqtDIIVS2DGPk7Rl0NNar9HiKkDfDGAEcFQsi4VtkWqQldgpaqIjZ3Zh8nw
	Qqv+gl4756Bto7haOJvQXGQTRvi3wXgs3hdxI+UiFU0jvm7QENSGugDoQDN2FyOg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskc3w7r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 15:44:25 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 625EWOLi010335;
	Thu, 5 Mar 2026 15:44:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmc6kbtmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 15:44:25 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 625FiLqc50266414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Mar 2026 15:44:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59F722004D;
	Thu,  5 Mar 2026 15:44:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEE5E2004B;
	Thu,  5 Mar 2026 15:44:20 +0000 (GMT)
Received: from [9.52.200.39] (unknown [9.52.200.39])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Mar 2026 15:44:20 +0000 (GMT)
Message-ID: <bb09deb6-41ce-4e27-b6f8-6457a1629d99@de.ibm.com>
Date: Thu, 5 Mar 2026 16:44:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] KVM: s390: Fix a deadlock
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, gra@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, david@kernel.org
References: <20260303175206.72836-1-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20260303175206.72836-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JL_4XwN-Td9BGXepHpvQ-iygMTDl-Tio
X-Authority-Analysis: v=2.4 cv=b66/I9Gx c=1 sm=1 tr=0 ts=69a9a4d9 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=7qIwyxNRPOhrtI9IJb8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDEyNSBTYWx0ZWRfX7IODjhfoIitE
 S9UYrb8k6oPMXPRqrESseHbXRxEjgjNkjJQoei/wPt47Sv7KuPX+n05MofzjoUpZAYkU6XimA0s
 +10juapRJfnFwjIXBJnXf1rSLebcRiczHQftVTa/HQN/Lfmv+4wL5UKMvF/McS9kt+oP6yu/0VM
 xMz1wotmG2zUau1Ag6yTl1rMwTulOWvTtAzm5Zm5/srTvI/xKmNrAVviGNLA1JnOhtdvBtF1sks
 qWknLJENvQN+RPh1sQwXpHggFIo3DEk1qhS+HjHtwTFHC2iCMB+b+LzZ0HnQRr5H9OY6M217iL8
 mIj1jc2s55ZgsBbTqwk9Q1+js1M4COYDcsdj2Q3QnjWXPtzO5o+e9jy6VzJVwZ2rxDZd0vcSZPn
 MmHQrYED1ZqqvEXKw4G4sRdEQSIzN5dy5XiKa+vYjZv5OxjnE+3AI2OFahwJGrj6apPuyyfY3u+
 a/Xdty5DLi2QMEGJ0lw==
X-Proofpoint-GUID: JL_4XwN-Td9BGXepHpvQ-iygMTDl-Tio
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1011 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050125
X-Rspamd-Queue-Id: 07EE8214EAE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-72827-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,de.ibm.com:mid,s.sd:url];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[borntraeger@de.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Am 03.03.26 um 18:52 schrieb Claudio Imbrenda:
> In some scenarios, a deadlock can happen, involving _do_shadow_pte().
> 
> Convert all usages of pgste_get_lock() to pgste_get_trylock() in
> _do_shadow_pte() and return -EAGAIN. All callers can already deal with
> -EAGAIN being returned.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")

Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

I no longer see the rcu stalls.

> ---
>   arch/s390/kvm/gaccess.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 4630b2a067ea..a9da9390867d 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -1434,7 +1434,8 @@ static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union
>   	if (rc)
>   		return rc;
>   
> -	pgste = pgste_get_lock(ptep_h);
> +	if (!pgste_get_trylock(ptep_h, &pgste))
> +		return -EAGAIN;
>   	newpte = _pte(f->pfn, f->writable, !p, 0);
>   	newpte.s.d |= ptep->s.d;
>   	newpte.s.sd |= ptep->s.sd;
> @@ -1444,7 +1445,8 @@ static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union
>   	pgste_set_unlock(ptep_h, pgste);
>   
>   	newpte = _pte(f->pfn, 0, !p, 0);
> -	pgste = pgste_get_lock(ptep);
> +	if (!pgste_get_trylock(ptep, &pgste))
> +		return -EAGAIN;
>   	pgste = __dat_ptep_xchg(ptep, pgste, newpte, gpa_to_gfn(raddr), sg->asce, uses_skeys(sg));
>   	pgste_set_unlock(ptep, pgste);
>   


