Return-Path: <kvm+bounces-72661-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GZWMZ3pp2mDlgAAu9opvQ
	(envelope-from <kvm+bounces-72661-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 09:13:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 441881FC52E
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 09:13:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4BA2F309EE14
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 08:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E909938944C;
	Wed,  4 Mar 2026 08:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lUAsbYyo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938C138BF6E;
	Wed,  4 Mar 2026 08:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772611663; cv=none; b=gJU+gEr65Ttmq/V3IS8LxHkSGXd7P67NrmSOB4hyzCclbJFd4O9aZpdh6V7seM/ul4CohLwMXdFfjzVB55/XvHjWPjOukwalFqvKV8rpe5DIlvIyxGxZi7IL0IQJa3wci3xvVomFOHM5ogOHKsm77JMaXJjYH6Wytj3NAwLkNO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772611663; c=relaxed/simple;
	bh=rcPHcNXrbzxbqx56lp7IHJ1UvVp3M42PMVkX0ErHECo=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=tE0u0di3KQTXAah0KZ3nQS0lfZv/lVxvBWjlgxG+njcF5U/J+l8/K1Hi/D94EcsILuvn3LpkFb6UcHtbvHwxTGE7cJJ5GP+Anh7+DHRkqYbk5zY8YDLspYpnNaEvtfopSrHG1TqaKrpX0ROaxQ8ZlgkK0yPcs64R2tSIpcjBbQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lUAsbYyo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6246G5Hg790207;
	Wed, 4 Mar 2026 08:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rcPHcN
	Xrbzxbqx56lp7IHJ1UvVp3M42PMVkX0ErHECo=; b=lUAsbYyojdSR3YzMfndLR4
	aCNrVj8rLQ7hK4wJ5PGPJWsAAOpfbQePKLpHaPSQg0TPryY07wtSphwKIdAhQPlS
	p4oRt/pRn3LQ/3JZOl/UQXusTqjka3/CrT5Iy0NMI0wXHqbLzYuo1YbSb33ZX2wW
	9jtYQQfR8uHeg0J1DEfeD1RfwZT0+FUTXZyyNjieIeNrIcYlyW/zQoMUWF3QdGFZ
	ioY+5J/DqXoLEUth8dAi0zw+CLXQzZ5bc2UEx8s4Q8w/vVm79c5pkOe0CPhlkOli
	oDMGG8gP3tdRuYbt2qj1X1asmoTDI50qSzdrSvF/rXdaKfSFv6jgWVKAM73E2wjQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskbx1vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 08:07:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62440Gnb003266;
	Wed, 4 Mar 2026 08:07:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmb2y5xde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 08:07:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62487Kxv39190944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Mar 2026 08:07:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E53252004E;
	Wed,  4 Mar 2026 08:07:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D082F20043;
	Wed,  4 Mar 2026 08:07:19 +0000 (GMT)
Received: from darkmoore (unknown [9.52.198.32])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Mar 2026 08:07:19 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Mar 2026 09:07:14 +0100
Message-Id: <DGTUDR1X33NN.3HIXKRYFGQV77@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>, <gra@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <david@kernel.org>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] KVM: s390: Fix a deadlock
X-Mailer: aerc 0.21.0
References: <20260303175206.72836-1-imbrenda@linux.ibm.com>
In-Reply-To: <20260303175206.72836-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qvAtrHut1EDav7Q-zPUFpP4Qsbfl3Prr
X-Authority-Analysis: v=2.4 cv=b66/I9Gx c=1 sm=1 tr=0 ts=69a7e83c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=nFlhKrqNoRUYweW6QhYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDA2MSBTYWx0ZWRfX7xhsWYancw0I
 LH1EDiIMvqFuynU+iCLzFUxVMnGTlx8iiln+pOfg7irsoJL/0znD2nWfSdqFcGsYOVnbEG5br8c
 zcUUnuRjG0slPDBWl4iBLpdxavP3MMECuwDJaiFchYntWekDjfH4eJF5VZAs7ZGQ0Q5LGJo/h7Y
 wkRk0MxH3JjdkFGy1rGKgmUG97Hf26YuocBrGZHzrfBXE4bO0upoLIbjwioOf7viWOgqdrE/+Mw
 JKzNr1CFjrM21y8PZ6yIGtlaXxXhook30CBfzqWhgHizqw8HWnAnWlD4Zn9qE74j+L4/KRAmlSi
 hSZ/y2GTau/pmcOvQk4eXjQIkzDhSjjJ6lkQHTuEkqF5vn4aznWerzNkZFUddDHPGpp0C1GXBE1
 VM9StawclopdTRm2hWeaGeagJQFk8Jni0bFGed0/Z9FOPXFOc8d9wpo7f4aYk7TMUDcXgkA4PGr
 hiJbxHVUOY+cOVPZhCg==
X-Proofpoint-GUID: qvAtrHut1EDav7Q-zPUFpP4Qsbfl3Prr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_02,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040061
X-Rspamd-Queue-Id: 441881FC52E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-72661-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

On Tue Mar 3, 2026 at 6:52 PM CET, Claudio Imbrenda wrote:
> In some scenarios, a deadlock can happen, involving _do_shadow_pte().
>
> Convert all usages of pgste_get_lock() to pgste_get_trylock() in
> _do_shadow_pte() and return -EAGAIN. All callers can already deal with
> -EAGAIN being returned.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

