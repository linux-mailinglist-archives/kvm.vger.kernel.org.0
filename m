Return-Path: <kvm+bounces-70624-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QC6yFi4ZimkjHAAAu9opvQ
	(envelope-from <kvm+bounces-70624-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:28:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3BC1130C3
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB55D3037EC6
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC21C38A701;
	Mon,  9 Feb 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DUt28LoU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEAE38886F;
	Mon,  9 Feb 2026 17:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770658056; cv=none; b=IUV4eqia2Me9dBoM8tajZ84ZIGBanrixZi9PfAcW8fkIaCFimG2F6DvHM3fNc2J5jSzL7pJ/w0uF7sy2q2iLBSka/wLxPQrnQeknUOM6Po8Ki1rOWH8oYF7ATBZCPFDDZ7WWtfUIAJs933+XcXEbh1t4MckgGDKLg+QsRbBb8p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770658056; c=relaxed/simple;
	bh=wXb88XD0tB0q4Onp76GOTR47Qj4+GBN93JmiiYOusbA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:Cc:To:
	 References:In-Reply-To; b=Pa03vVgZbluQlLDLNGpiAEair58L4RWOJK17EiwYNcV7NG3n7pZFNmjshcdE2fldhXIJtPt2ls5RBF9XcLpimRdgWT+N4KhYTkJlRXQdj1t1y14GZJP7jF7ehNMPqE7btyXrg3VoXe3ipQtwU9kdXbyBa9gI2oMLvtFj7rWxTyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DUt28LoU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619F9UkJ198637;
	Mon, 9 Feb 2026 17:27:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hbVFqg
	dUeIsksZ+DMctnwQqarcSwdMH67MFwD7eDxuo=; b=DUt28LoUAIxoaQb4W7aId6
	lVPNZrZypm0Bl9KqF+JAyUwP+o1s4bLJ5NWIeeCu28qRKkEUvhyCKOUxyweNdCkJ
	VUwlpd4EXfhq7zjPFPnlNumbzCCCRrpWujKEC+mqGx1JoMzdMNBr8yDDgWjs8BtA
	5UPqa3C+ngAjULy8oJ4Ke36JsBbQONnJGjZieBxEKylOontKPeWHCBfsflmZ6kMy
	eunqZglypGqpSaIj8gRwEia5/1fnL0d6pHfr5d+114hC9PXZfKgnCZn6rKeKhV/s
	zz0CcqapLsG46oUWFbXY4Jk1eL60tNg0wJWl2I1wW6dnrcG3ZcheqF5ce5lSk6+Q
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696u8eyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 17:27:34 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 619DdUCq012693;
	Mon, 9 Feb 2026 17:27:33 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7k60sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 17:27:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 619HRSfn15991110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Feb 2026 17:27:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8774B20043;
	Mon,  9 Feb 2026 17:27:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57DDE20040;
	Mon,  9 Feb 2026 17:27:28 +0000 (GMT)
Received: from darkmoore (unknown [9.87.130.153])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Feb 2026 17:27:28 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Feb 2026 18:27:23 +0100
Message-Id: <DGALW3FURCY8.DRKU9407VTTO@linux.ibm.com>
Subject: Re: [PATCH v1 2/3] KVM: s390: vsie: Fix race in walk_guest_tables()
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>, <gra@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <david@kernel.org>,
        <gerald.schaefer@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260206143553.14730-1-imbrenda@linux.ibm.com>
 <20260206143553.14730-3-imbrenda@linux.ibm.com>
In-Reply-To: <20260206143553.14730-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698a1906 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=wnmpZm2sU0XAGl87Tm0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDE0NSBTYWx0ZWRfX3eSvy7kgsDGE
 5c+Rq2znMuSdlAiq/Ueh5fXZHhKTkRmF6Pznam9HcWPud1qnfqXRTpXlqe3RW+rAfz2Ononxd6z
 gp7kmdy4ZhUYmmrjLaeQGMx3edBBUk0YDJ2UD2qc9OyyAiUrC7kgF5gLePIN0Jioc5CysU341Ei
 3i6ahkdEPma20n2cVFIskXUkE15kHfZAT+P5G0n2WxLV0OO0UFiwN7kthv4ImjjzsyS9TsQwmhS
 HcimwgqVO4kmU/i3vwTrvEnfE8mG46J5UcmgyCd5d9lHLkCZKQcXhB/LZ9ZHHAK5ErIo9YdQC5p
 E1vaNEutMjiJDq32AzYn+CYZYFO6uiIXODGJRuFK7v+V4PPGxMWsPUK9kaZKdyWTg142or1ODi8
 sMaw+FXhq/OJxq2QavEOjsiDl4D2HGhfHP2znsTBG0uV2S33rhp0UL+PZ0Z4nVf7Z3nIAyEM6jz
 p1yTvznwy5ptWmbT8uw==
X-Proofpoint-ORIG-GUID: 3w_4AReP9Y8KTdOn9TF0dBlWqjnEO1Wx
X-Proofpoint-GUID: 3w_4AReP9Y8KTdOn9TF0dBlWqjnEO1Wx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602090145
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-70624-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: BC3BC1130C3
X-Rspamd-Action: no action

On Fri Feb 6, 2026 at 3:35 PM CET, Claudio Imbrenda wrote:
> It is possible that walk_guest_tables() is called on a shadow gmap that
> has been removed already, in which case its parent will be NULL.
>
> In such case, return -EAGAIN and let the callers deal with it.
>
> Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/kvm/gaccess.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 67de47a81a87..4630b2a067ea 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -1287,7 +1287,10 @@ static int walk_guest_tables(struct gmap *sg, unsi=
gned long saddr, struct pgtwal
>  	union asce asce;
>  	int rc;
> =20
> +	if (!parent)
> +		return -EAGAIN;
>  	kvm =3D parent->kvm;
> +	WARN_ON(!kvm);
>  	asce =3D sg->guest_asce;
>  	entries =3D get_entries(w);
> =20


