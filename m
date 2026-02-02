Return-Path: <kvm+bounces-69862-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QECEMtC7gGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69862-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 15:59:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC83CDC2F
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 15:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1B5A63018700
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 14:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0396374175;
	Mon,  2 Feb 2026 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BMjraJs0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F5B36F43E;
	Mon,  2 Feb 2026 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770044248; cv=none; b=eYfvFMv6F8uBo9pjCREGe1w+Y9mJrNj7x5GaHwOs7CxygItcVzSIcPeZC2TEavpc+r3V5wgIyrgVxAzOyPn+VMoqbOrmLk1ukEeFshlq5tjjDQV1K9KSwV7kC2p2ERqICIWFUdisDY/w3GS5D22vEOreqXKCVVi4F2Ibv/0c2Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770044248; c=relaxed/simple;
	bh=seDOKF8I+BWEDcrhAiaU8E+0tt8z0sXGG+AF4rVBcRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wka6bms51vmjaRebZXbds5VjPsDlCn5h0v0z7XOq8Hsk9I31DP1NpdFmZPz1ikKdoz614a7Pji1GmEI2cMB2QPu7oCN7ExjDHNCt04VXkc02BM8W3xmyTlsbcFpzwm0KBVrAB4zMAfPWTNqYQ9Q58oXuJmPXOv536z2DXYuMkGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BMjraJs0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 612Eju4g030016;
	Mon, 2 Feb 2026 14:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nTVGUO
	H7b5IrLpAQPbnZes537H1hEb3YRXDefCvxb38=; b=BMjraJs0XR37GQel+/+M67
	S874CYnXa2BY5l2MKoYRRCwbz4s1JzvgY7kYQsW0LO3rsr/3cCyDyc6yjnZdKns/
	e7uKYe5QlPo75+miL+n8S3ulJnujHBvy9A614NmZpFR8I8kiDUb5KXBrfZkCFTHM
	lC85qo+BuyxwzwqIEaQ9eDWN8EdTGgeMJlo1O4aoeJ0HH4K1bsen2K+KQD4H7ZUZ
	86yBR0Sxf8h+BMGKHlocz6rhFJqGQRP8cIf/tBJ5NHegwB8D49xuVFr+A56OOiQV
	KE5VUQw9e0FimcLCRTji7QhvwaCTIJfqkaGFATFotw5CJQE67o9694BhKvMd34Xw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f68xff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 14:57:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 612EEkSZ004437;
	Mon, 2 Feb 2026 14:57:23 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjnd99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 14:57:23 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 612EvMtl20775474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Feb 2026 14:57:22 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E7105805A;
	Mon,  2 Feb 2026 14:57:22 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AF4E58056;
	Mon,  2 Feb 2026 14:57:21 +0000 (GMT)
Received: from [9.61.91.248] (unknown [9.61.91.248])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Feb 2026 14:57:21 +0000 (GMT)
Message-ID: <1bb228cb-2c3f-45b7-a515-ca932429a3e8@linux.ibm.com>
Date: Mon, 2 Feb 2026 09:57:20 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Replace backup for s390 vfio-pci
To: Eric Farman <farman@linux.ibm.com>, Farhan Ali <alifm@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20260202144557.1771203-1-farman@linux.ibm.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20260202144557.1771203-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2ZM8Hjim10ToBV5WYpKjG7spuiiJHMBQ
X-Authority-Analysis: v=2.4 cv=drTWylg4 c=1 sm=1 tr=0 ts=6980bb54 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=STK_0p3wlTkmVyiQI7oA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 2ZM8Hjim10ToBV5WYpKjG7spuiiJHMBQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDExNyBTYWx0ZWRfX3QKDPQ0PP9HJ
 zF3anw96aiC2JTy1x4uKpiE+bT0pGUPLBfJ+EMDKtVYrhwfAUrPuqQmR/cq9G3fkD2A35GrOS37
 0JL8iXC8y9bqcHWkplkEL21xa3DbMjpyNQcIpZfc8+/amxgeksSFzsKN/5RnVKxn3Fqln3iclon
 DJMCLP6UZ1JE32jK/BZS+t7yvvze6T5Mef9H1FpOp2dgFp9Ee7SF+HPgjrKfUGnPJC88YK1pSS4
 ZQm4g11//4MeGoBUnlIT92Xz+Gf0UO99qTKkFBJXMfk5TJGaAG7PS3pfozikybj/vodXOBbPraR
 WWfzWsOqWXZ0YMUWLXwmy9khhoGRrGPJOY7QXJ0zHCfBnkvBymkr8uS5zQryWlIXOHojcSPNLfs
 Ta0oceYgSCdTH9kDadgtyOaZInFIHP29zHfQHizG561XJebA79unJAqAAt40xR+QIF0QYvrIooP
 cE66V874DT6ECQUMArg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602020117
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69862-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.ibm.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[mjrosato@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 5BC83CDC2F
X-Rspamd-Action: no action

On 2/2/26 9:45 AM, Eric Farman wrote:
> Farhan has been doing a masterful job coming on in the
> s390 PCI space, and my own attention has been lacking.
> Let's make MAINTAINERS reflect reality.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Eric, thanks alot for all of your help with this area in the past.

Farhan, thanks for stepping up to help here!

Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0efa8cc6775b..0d7e76313492 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23094,7 +23094,8 @@ F:	include/uapi/linux/vfio_ccw.h
>  
>  S390 VFIO-PCI DRIVER
>  M:	Matthew Rosato <mjrosato@linux.ibm.com>
> -M:	Eric Farman <farman@linux.ibm.com>
> +M:	Farhan Ali <alifm@linux.ibm.com>
> +R:	Eric Farman <farman@linux.ibm.com>
>  L:	linux-s390@vger.kernel.org
>  L:	kvm@vger.kernel.org
>  S:	Supported


