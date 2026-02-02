Return-Path: <kvm+bounces-69880-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +KRuDabigGleCAMAu9opvQ
	(envelope-from <kvm+bounces-69880-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 18:45:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C80B8CFBAE
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 18:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE8593059FE2
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 17:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA1E3876B9;
	Mon,  2 Feb 2026 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i5bEI+OT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3769037D136;
	Mon,  2 Feb 2026 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770054071; cv=none; b=dHIgEJOJxg1dsDwV8C6woB0TqoN691hy3YkDGAAUlaHwpmuGiUoa7sdYpRcZJkkd+5DcYYsRuVLz9BoAYwATV0zQ9dN1sV5aSacNYqVyMV+hGo/0bG3qzqwGtssGFpE5dEpJAyLIr7gn2qNF73FJHkKwmyLug/9RwAjFKhI6Xvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770054071; c=relaxed/simple;
	bh=FpCyJfFuuFXb37hoTr8yir9QjAylNg8XFSFGhFI+cVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ymtjl8ZO/zN+WUIr2/R6+OLwFyY6OjnHtptKlwSbmTFdvTLgiL03mYAyPcelB9HUteRA7GbB5n2VUgXjsgEzwGCmaci6TRpfDCNs/fMe7qDuQCDrxaEvUavwkGHM9+rPLvNznAMZ/dHS4VRRWnbCqb+P2CckWYfmDQNs+2j0dkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i5bEI+OT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 612FjNpp016604;
	Mon, 2 Feb 2026 17:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PCz7dj
	2AzVhYdoJKoe6BuLmGc6b0ebQCXW7Uwtokg6w=; b=i5bEI+OT2dgzYwIP8W9Ua8
	gfJ9z1/nPCt6/oC/pq5hB2R1MqInE2lLgY7wgTbqt5K6zKkyMQS02cjToIfhOCkZ
	7ZA2HCmEuANk5Y1+ulA9buI4Wg+RxKOObDV5vlD8J4q7II7MpMseYyqW0l32jv3E
	iedISdZpvrkEGz+Z7IVtLHk8JVCnsyxmapIj1ESg8n2225xSNX1X79NixbTCwdw/
	lst3cttMLYUTI+L5tOhthPVo/ZiJiXXQDO6ij2hCaGctzEGUB+PG/jA7Nub6YOt0
	5kYQNnwFEYct7ZCrBHRtfQf6dNmR9NzzUcc86Gf4SWqcYau02RyYBelHLsGbZMFg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175mr6ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 17:41:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 612EEk5K004437;
	Mon, 2 Feb 2026 17:41:06 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjnwu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 17:41:06 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 612Hf4Nj26804908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Feb 2026 17:41:04 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7497F58068;
	Mon,  2 Feb 2026 17:41:04 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F28C5804B;
	Mon,  2 Feb 2026 17:41:03 +0000 (GMT)
Received: from [9.61.254.56] (unknown [9.61.254.56])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Feb 2026 17:41:03 +0000 (GMT)
Message-ID: <b77f16da-ff8f-4e22-ae9c-0b9164902912@linux.ibm.com>
Date: Mon, 2 Feb 2026 09:41:03 -0800
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
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20260202144557.1771203-1-farman@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20260202144557.1771203-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MIzsbHEr-GQ8Sqn9jrebdqH0kaKzp4a0
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=6980e1b3 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=STK_0p3wlTkmVyiQI7oA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: MIzsbHEr-GQ8Sqn9jrebdqH0kaKzp4a0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDEzNyBTYWx0ZWRfXyea+Zm6w+Gan
 ZGvBhZg8X3moDJjxtO1NydejJpHeWlX3RlunYRTCp0eanIKIRT3v6+zHW+AQ3Rp98IwAAdlDXKW
 lhgyVXILiSv96Xsg3FoeBb/oPJlCiqpTVT0P11hqLZCWlH2sharr6sbF9ZK8Ju8scd0eMez1797
 fVmj4h6BvKy64j8Z9hiwyHz2RSnB/U+Z8j0BpKVEIN59R/kT3kuMM/Z99T50Opv4EJP6hTU9Tib
 96DqHSnSyDtXmGKk8TiPBl23oQ1+SrpqkNSxtYnUlEOx+yeVI3yvVHm0IzvuobaE+OcOEGqVLbc
 YNnpBjCxZoUZZjJHai/aAnMzv95NlKomTqn9JmVNmcAt++cLrM3a7t7EmIUj5COgneXy1AQykOO
 6PjCYcKkCS3VDanyDwyQJOuZKn6SHplNT1+Yb2ef38SbHa06D/nBWkSv3BC1noZWgmMjscR0FW+
 XBGFG/RxC0+pZg/DnMQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602020137
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69880-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[alifm@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: C80B8CFBAE
X-Rspamd-Action: no action


On 2/2/2026 6:45 AM, Eric Farman wrote:
> Farhan has been doing a masterful job coming on in the
> s390 PCI space, and my own attention has been lacking.
> Let's make MAINTAINERS reflect reality.
>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
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

Thanks a lot Eric!

Acked-by: Farhan Ali <alifm@linux.ibm.com>



