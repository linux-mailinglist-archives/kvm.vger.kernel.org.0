Return-Path: <kvm+bounces-70623-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UIzyMIMXimmsGwAAu9opvQ
	(envelope-from <kvm+bounces-70623-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:21:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F959113006
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E8F903023A69
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BEB38885B;
	Mon,  9 Feb 2026 17:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gj6VFQ+S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A723876DA;
	Mon,  9 Feb 2026 17:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770657649; cv=none; b=Op7csWQI+t6Ws/qsuW0ESuoCa+eHa0slaDQE/T4SKaSfC9Ui5QQfTS9CmNlomc5psT2L+jxgefKF/z5vBMuAb3VNDwYqxVTZO5b7Av7WaGVd2prqgW7Va+ynMV2D58OBzEaVLmQjWOpnMzt6vgujYsWkO2E965vFGI5/iMhvvSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770657649; c=relaxed/simple;
	bh=1IUMEdxL08VdYaLCJcOGBOf6NpUtqYTr5jUCbHwihpw=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=FDUwpifVSM0wgu3VZB7XKRbmfj8G9SjuyajdqfnpPChppc1GPBXN/gI0LXSfdx982QKqLiNYw3+14y3wiuHBPIFsO9Cx5l5MUXbs6JbgsdP4GvCGQaZ3ysu7Dsu3zQwImpYoS/9QchG7CcvOm6HO7T9oHHWYpz5Ka3pdFZhBwZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gj6VFQ+S; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6192tRNg821302;
	Mon, 9 Feb 2026 17:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=twFoeW
	TV2EmvrNgCmrSWhFhKce16jO2O10PiHHBMD2c=; b=gj6VFQ+ShSwblg0Z5e5sgo
	nPLr7ro24kvYbKCcXntH8Pz/y6y0EKldbQ5+xaQsGJ+L52uf3XclRyeJyagfTo7e
	RLQcmk7QN97ASnSLFJHu6OyQRDQa/8yZmsMXv2Jqn8MvP7m0ebvpeGnDjwfAsT4h
	CrBFDzwQ/3lt3cG4GaHN61L7/hhSoJLvix0EbQ/gKtbFRZsIN5wpD/ymhL1Z3ACN
	dGRq0d8k+hvWHf4oeaA6T1odv6zCiZ0SdGVeGvaulAKYsN7YrWM03e0p/6HJ6ebI
	92Aw76C9LAkXdcMkHCsskbT3zjOc6gKo80Eh0nr/a2STQxogoyMcWP68I3dY6H3A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696u8duf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 17:20:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 619Dt3B9012610;
	Mon, 9 Feb 2026 17:20:46 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7k5yyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 17:20:46 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 619HKf3x44302596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Feb 2026 17:20:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D13312004B;
	Mon,  9 Feb 2026 17:20:41 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB76F20043;
	Mon,  9 Feb 2026 17:20:41 +0000 (GMT)
Received: from darkmoore (unknown [9.87.130.153])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Feb 2026 17:20:41 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Feb 2026 18:20:36 +0100
Message-Id: <DGALQWNIDAFQ.VQK91435WO52@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>, <gra@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <david@kernel.org>,
        <gerald.schaefer@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] KVM: s390: Use guest address to mark guest page
 dirty
X-Mailer: aerc 0.21.0
References: <20260206143553.14730-1-imbrenda@linux.ibm.com>
 <20260206143553.14730-2-imbrenda@linux.ibm.com>
In-Reply-To: <20260206143553.14730-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698a176f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=66t2VqmaeCk1KhDUqx4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDE0NSBTYWx0ZWRfX9BjvW+Pd3S6L
 G0D5kH2Tf1FQfn4NblSHYcLCTJ18vEOTsjg93ZUBfyeIb5P9isTNz/ySBfV49D9SiCEgTQY2LFv
 xj2wnypSvbZ8eog3RF2c+mEBphzKtLnwOuEhER8LE20IBo7XRaQ+iitUmkkYoesvVwNo6ERIyPV
 xSEQKOlEk9f/99P+4Cqbd1FEoPuPg04vIVpmlZk2630EZvdOjuwA/I0sjqvuBbXaU2XtmvTHhi+
 3B1y7n/470zKIfjHq81JPg9jsKQUZXPHreQ/QkwDnjEKU1OHye6WgL/43+nwMHfGmQ7NsqSh5ar
 Xgtd2jLrcGdV0ScCb2OdHLpn5z2lJ1QecHl8kstvRR8iOcDFVHa61W1Trs1HYeP5H2c8xbENaST
 4cxYHccEdMSTutMkOWGdAPF3tXyzpDDncvJ6a2Ef5yQCmTtdYThMYVaiVOqTOCSC0+4vZrOvR/P
 TGPDsT8owSuPPrJRlyA==
X-Proofpoint-ORIG-GUID: UWfNcE51SwSljhg4mXx4XzO3U4iWXw4Y
X-Proofpoint-GUID: UWfNcE51SwSljhg4mXx4XzO3U4iWXw4Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1011 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602090145
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-70623-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 7F959113006
X-Rspamd-Action: no action

On Fri Feb 6, 2026 at 3:35 PM CET, Claudio Imbrenda wrote:
> Stop using the userspace address to mark the guest page dirty.
> mark_page_dirty() expects a guest frame number, but was being passed a
> host virtual frame number. When slot =3D=3D NULL, mark_page_dirty_in_slot=
()
> does nothing and does not complain.
>
> This means that in some circumstances the dirtiness of the guest page
> might have been lost.
>
> Fix by adding two fields in struct kvm_s390_adapter_int to keep the
> guest addressses, and use those for mark_page_dirty().
>
> Fixes: f65470661f36 ("KVM: s390/interrupt: do not pin adapter interrupt p=
ages")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/kvm/interrupt.c | 6 ++++--
>  include/linux/kvm_host.h  | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)

