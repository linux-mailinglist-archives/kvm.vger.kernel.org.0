Return-Path: <kvm+bounces-70459-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gATZFWkXhmk1JgQAu9opvQ
	(envelope-from <kvm+bounces-70459-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 17:31:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F03561004AF
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 17:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CD0F8300D4EF
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 16:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C73E3328F8;
	Fri,  6 Feb 2026 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ex0DD7CL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB115328B75;
	Fri,  6 Feb 2026 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770395366; cv=none; b=KTPS6cp3vHDf42QQRC+Xee7UKLUFeAlFOHEp8SPD89VChFx3DTGQ0gh7aewyIpPcdkfJDIxqg0POfkKrxklj2iXZ9THlXFnjKSJB3SSnb1hLGM1/hWWkZUM2ODVT02q4en0JVAiMfZ2ft4R2GILWR+6Spv3sgaIevw2LMUDnHTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770395366; c=relaxed/simple;
	bh=h8VOFi6tP/rRrpw+ZQx9hJ0/5NEfHpTxu++qhjrV80c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f2fK+GBz+SaKOjNTRH/CAh91VU69LDzEeZ898+ByuOiLMaoxheirIi5OW4JutOpkJC9yBzcTsRYrrqUyoIn6YmloqnkDXgqwPvktvoKo6+UJ/ow/VF23YEsggRqpIjseAsIQSu6irP1ryGqSV3PTRgPEsj3sWNho+QkqcuOTzw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ex0DD7CL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616FSA8v003180;
	Fri, 6 Feb 2026 16:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=oh5jBWRYQDuUXvmU4nBzgRSa+Sxu5l
	CT+lyEhhKEkig=; b=Ex0DD7CLA/bMl3gtpFErZPZIxHwkOpH5soFeUSlwBNhkw6
	snq3JTey1KNLW8oSgutvfK02z1ZJnYfN5+WKoCbxODbziOwnBFCl2vB+jxbnNuus
	lCZv01+trhoT1ENZgRmuGtGE6+4oRRl16cOsp+N5tj1LTHHhhCQzTVBN4lnsUuDM
	KSOwVil1e3f1UibdUaQA6Wu9ykiil3b/7BNusuDzuq7YIGidNa7sjoiDbeN7fKtY
	7sf/+ZY9hXhPMpuyaS0DyzYhqWcj5EdxOlj4Z6qKys9+8K7ujsVQk7V9GWERE4Pj
	btLU7Ky1VGBa+UZreW/Q2J/sB13VTRxeGTWSBFSA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f6vhwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 16:29:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616D7sve005921;
	Fri, 6 Feb 2026 16:29:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1x9jpmm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 16:29:23 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616GTJ5r59769308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 16:29:19 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EF5420043;
	Fri,  6 Feb 2026 16:29:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE5A420040;
	Fri,  6 Feb 2026 16:29:18 +0000 (GMT)
Received: from osiris (unknown [9.111.23.118])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  6 Feb 2026 16:29:18 +0000 (GMT)
Date: Fri, 6 Feb 2026 17:29:12 +0100
From: Steffen Eiden <seiden@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        gra@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        david@kernel.org, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v1 1/3] KVM: s390: Use guest address to mark guest page
 dirty
Message-ID: <20260206162912.38172-A-seiden@linux.ibm.com>
References: <20260206143553.14730-1-imbrenda@linux.ibm.com>
 <20260206143553.14730-2-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206143553.14730-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iFV9PLZnv1LLuw_Pwl_PqNsZ2Pj4-QSD
X-Authority-Analysis: v=2.4 cv=drTWylg4 c=1 sm=1 tr=0 ts=698616e4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=66t2VqmaeCk1KhDUqx4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: iFV9PLZnv1LLuw_Pwl_PqNsZ2Pj4-QSD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDExOSBTYWx0ZWRfX87aVVqAbRuTT
 NTZv3E260c/I0/ITXV2jjuk8dCnPTHnmqwKn88Rm1S64XHL3yh1/TYymsJdtRwFN4bXjFhH78c9
 4Nt2KGUeHcoeDSbF4WzJ7H+pFrjWc7yTJ6/aXTAWDVv81XyEQ67edfZp6H2PxwZwKf2uoqkik4M
 qs9MAZBHtfDFoin5fQ2DEoDk7wEvgq3CHcrdRyFDNbSBgRmNn7983GQJfm2l4kTFv+Rt00TX++h
 uzSneSIw593dq9Z8nYsN4CYHYK2Ci23bRHjKakuXxdRJp7YjwdkEA76OGKnJYM2WHJ3YtHxtB8p
 LJctKK21geTGZD10Bpoaw45TLElhNTf0BKHg9kTMhh1Utrzg3lzywa1SwKPiEfW+Ndeluf4G4iJ
 1Tfs4Q1a1EP/nQUNL1Of7meHsHPDdlvUeV009TTHRuWk4hajvVxO4cct2Q0U7pKyDQXdMGyxSgo
 kmsc6TJRdJrPCtqCqIQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060119
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70459-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seiden@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: F03561004AF
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 03:35:51PM +0100, Claudio Imbrenda wrote:
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
Great catch!

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>

...

