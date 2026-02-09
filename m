Return-Path: <kvm+bounces-70627-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cN8BHVAdimmtHAAAu9opvQ
	(envelope-from <kvm+bounces-70627-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:45:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 61AF11132CA
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E415C3033FCC
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C3438A73B;
	Mon,  9 Feb 2026 17:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W6WMPEB8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3713C3803D6;
	Mon,  9 Feb 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770658973; cv=none; b=U7oG8m5sbc8eIG57/plnvHHlynvqpiF60c6D+3kb2KW2xZ1zZBZ9vkUwcy285wVaAB2X8j78LUKVizP5R0JRFgrfnQl0al0zmNGDS21UqEj4qPqT2lqndhzP/bndTkQZS7aahA9YU/7gu0KeAt31Vfd7TTv1fsBXEjBUtl+7NAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770658973; c=relaxed/simple;
	bh=4Ph7yzJBp1muwEHbFkXhjAB+O+UID50nelFAeq61LU8=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=WyHqDIwak330+e6pUB/FnCqzM5znwQ3VvAogXFhIwgO/z8b33e2JQGmumpXwaSQmx6wEPzIMfA1bxP2Z/mZWSyRwc0cU8kwKTkEU5WUzjiszrxZPyNDYmDEHFplFsbAMCVekt4TfFjccJwQvLdRR8Si+/mrcbuevvtTWNiVZvN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W6WMPEB8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619EBudl235984;
	Mon, 9 Feb 2026 17:42:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SoPnFT
	eum20VCTputo4e45a7cCikqKyIY0Fca6BeD3w=; b=W6WMPEB8Uy7e2ZjqLfz4rz
	o16gYm4D/BQW+Y6qHoqjmhxGsdhZ47LOrfpFF7KHgkreuVWNmtTvi+NFJAXlVhW+
	LN+pFypRcph5OPsZERsSLkqTqf5RT26R7r8KJgHXbMplvB4BwoY/9urpjglKxQVh
	0OSUp0YohgTsEVLuhc/F7sqOHOZszmX2ehvnbJKcqlIG/pO77V7MrxhI+IdVIYvM
	x9yTSIxKcZgI4vXMNb0cKHv3MExPZKUuYt4VxaW6G++JGsiaJ+CMOsvsPRkAMW7R
	T53cp4pPSUpnw+KSjtW/LG4TBH2eUaZBLh2tg5SH4VfW2DDt9Sd5nroLk2vaSJgg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696u8hya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 17:42:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 619Gecdk002631;
	Mon, 9 Feb 2026 17:42:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6fqseb4t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 17:42:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 619HgkAK61669670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Feb 2026 17:42:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1534C20043;
	Mon,  9 Feb 2026 17:42:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3CDA20040;
	Mon,  9 Feb 2026 17:42:45 +0000 (GMT)
Received: from darkmoore (unknown [9.87.130.153])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Feb 2026 17:42:45 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Feb 2026 18:42:40 +0100
Message-Id: <DGAM7SZPZQU4.3UM38Z6R1DB7Q@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>, <gra@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <david@kernel.org>,
        <gerald.schaefer@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] KVM: s390: vsie: Fix race in
 acquire_gmap_shadow()
X-Mailer: aerc 0.21.0
References: <20260206143553.14730-1-imbrenda@linux.ibm.com>
 <20260206143553.14730-4-imbrenda@linux.ibm.com>
In-Reply-To: <20260206143553.14730-4-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698a1c9b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=XBZ43gOJIXd42L75nJwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDE0NSBTYWx0ZWRfX0KGuyhabyvkx
 2i5TIUIwyiSLieiy70DJxfdx6DSfxEqMoaQ/clG1CSkSlql1l/CGLMhefg6GDD1eC2eP6ri6Kfb
 450ndgBT1kX6Qg0JGOt1uZGe5msFgy/c8HWoWKacV+c4qRcg65fO9SPZM7hbQ6SG8TSKEspOUbB
 y8kpt34IaYqasiRvFJ6lU2qdHR21rG89wD488nFPGh215z+reX/+L5/Jo0HprIVoOvkvgQ50ig6
 /YQyt+4pHUGCDb969ly9ZQmhrfV0BX/59VRSx4MwggHMO6t0H61OkJp1brAv1LhwydtgGs3Lujn
 5mygFKkgQZMMbFesHyk0WXl7dWh9gujOtlnVRrp70z8u37brIDzP6buu8qfKnzPDA8WTNTrooRt
 lWBsXozztnSX7wnoqH9VJCda9zFbiIYz1xc6FvAId4IvJ5KzpAaXiKDXMa68gs+B6JuHowmsvQK
 1Z9HEziQZvplg9cL7dA==
X-Proofpoint-ORIG-GUID: NksxR-cadwXkKTxqUI262NmHaQ2oiJEU
X-Proofpoint-GUID: NksxR-cadwXkKTxqUI262NmHaQ2oiJEU
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-70627-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.ibm.com:mid];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 61AF11132CA
X-Rspamd-Action: no action

On Fri Feb 6, 2026 at 3:35 PM CET, Claudio Imbrenda wrote:
> The shadow gmap returned by gmap_create_shadow() could get dropped
> before taking the gmap->children_lock. This meant that the shadow gmap
> was sometimes being used while its reference count was 0.
>
> Fix this by taking the additional reference inside gmap_create_shadow()
> while still holding gmap->children_lock, instead of afterwards.
>
> Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/kvm/gmap.c | 15 ++++++++++++---
>  arch/s390/kvm/vsie.c |  6 +++++-
>  2 files changed, 17 insertions(+), 4 deletions(-)

