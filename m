Return-Path: <kvm+bounces-69860-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UNiSMLS8gGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69860-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:03:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC3ACDCF0
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:03:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B65CE3063AF0
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 14:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD8E376493;
	Mon,  2 Feb 2026 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WvRNHDc0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FB1374755;
	Mon,  2 Feb 2026 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043984; cv=none; b=M9oeUzpentqQlKEOE4goWF7oNAuvw1Ipn3fX7EYkocLio9PXa0c8d4oc9hwd4nv3IYxTd3Vrxhig9S9ynXKgvXXsDp67hGPaFVXc4GQPqeLhEbdSzhHfa+mXd3QhVxl1nHFt3yXwdo+2RSBrddAiESxb5kzLUWwYJYbWEXK7wKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043984; c=relaxed/simple;
	bh=HYKnxOHbUBWK9OUfkOeaOdwRcnFCR91hhCBuaogUkg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qsBcX2K0Rh1VzFK67Zc4jQYohTVO4JSJugVL5g8sK1HoY1eb3mmoFbRus7bXfqSx4p5fsvBPqb+wNKucfDTMkdBH72+Et2GPwt/mcr6x0q9m2TFZbIpwuIfByZ7ZqlXDLFp9/avB35mMq07Hk60MbdURGxnMYNHYPjijwMgjVzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WvRNHDc0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 611MZmrP022039;
	Mon, 2 Feb 2026 14:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YNmYnv
	mJe9/iMFyLtwmFx2pkfDw0lg0CRd4MmcC2u8k=; b=WvRNHDc0pumwBq8iBMUu08
	XVffCqwcOtX0El+e2EUr/XWrtO6oerLgfR1WSYT0chU1+eZi5RJHO9chtrZmw0m2
	YyyGzsGy8Qd+8aKtUtZAhOuloEM92azcldka4SQQX8uB1P6DzQCdQ5Bq+HIJmoFZ
	fawA63HUfHgGQsbDjGQRuCdyR7kwdeHr3to37m8fW1bM/i1gZcrlyrY+1fOqijZG
	8HDtjjMTjcLUand79n5qZounuiLp4EVdtquEsCGNnxje2bw/hbYPq9QY5r19qXbn
	5rUTzSKSKeJsVXXrPu6sKRZZMy4ZMK9a29e6B84Pt8bQps67nhYcAhs2UfiHxZXA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f68wvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 14:52:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 612DUZvB029108;
	Mon, 2 Feb 2026 14:52:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1v2s5k23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 14:52:47 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 612Eqi4i11272680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Feb 2026 14:52:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5490D20043;
	Mon,  2 Feb 2026 14:52:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A11520040;
	Mon,  2 Feb 2026 14:52:44 +0000 (GMT)
Received: from [9.52.200.54] (unknown [9.52.200.54])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Feb 2026 14:52:43 +0000 (GMT)
Message-ID: <58fd70f9-f5f7-4e1f-80ad-fd454dabd5be@linux.ibm.com>
Date: Mon, 2 Feb 2026 15:52:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Replace backup for s390 vfio-pci
To: Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20260202144557.1771203-1-farman@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260202144557.1771203-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SQcqznCMfaqB0VfAkRwIUDl6QuLRAjHn
X-Authority-Analysis: v=2.4 cv=drTWylg4 c=1 sm=1 tr=0 ts=6980ba40 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=STK_0p3wlTkmVyiQI7oA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: SQcqznCMfaqB0VfAkRwIUDl6QuLRAjHn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDExNyBTYWx0ZWRfXw1/PJ3Yi3mZi
 9IBmuymBngNrpE4POB9rGezDeb6R/FX90BhUBHrtJlMyJNlAG2/F4lWiUpqQNZdNHD6wJ0b27nR
 iRPfwiXjPjxiC+EcPDT8lJjUj3Qi620WFoM2jToPR+IlNKssCMGVIBZqEpSEgwQmsQS+RPz8yPo
 WMJuoJb8HvHPof0mLUPnKxcv/iO1vht3lS6o6K/XyWBPupOEZ2jaE4ymdLRtMl7qhl5uMbD0juu
 KzJiXq1sPaZ3PHamwj1XCyEXuwanEUEYSNKFRrJP93OFeJcn91uTZKM7CJ5/Dn2t4f/VPlzBz+r
 nUTpJTu3VYlP7FcR+cXrVyfUbt7c/uLWXlhCXYjUQ2klQJaj4Ra/MIfq9RbOawoREzjvCj0RPQn
 f4ywhVjSzBilaVpMPollFhbo6AEao6k4PCNTDTOkWAJ/+Gas/QDndov7Ek76IFN/uKEUN+od9Wg
 kz7+x/poZ1Bg4HzMpgw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602020117
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69860-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[borntraeger@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 7AC3ACDCF0
X-Rspamd-Action: no action

Am 02.02.26 um 15:45 schrieb Eric Farman:
> Farhan has been doing a masterful job coming on in the
> s390 PCI space, and my own attention has been lacking.
> Let's make MAINTAINERS reflect reality.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Thank you both

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

> ---
>   MAINTAINERS | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0efa8cc6775b..0d7e76313492 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23094,7 +23094,8 @@ F:	include/uapi/linux/vfio_ccw.h
>   
>   S390 VFIO-PCI DRIVER
>   M:	Matthew Rosato <mjrosato@linux.ibm.com>
> -M:	Eric Farman <farman@linux.ibm.com>
> +M:	Farhan Ali <alifm@linux.ibm.com>
> +R:	Eric Farman <farman@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   L:	kvm@vger.kernel.org
>   S:	Supported


