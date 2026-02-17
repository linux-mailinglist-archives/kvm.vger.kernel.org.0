Return-Path: <kvm+bounces-71147-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCDpCDYslGmdAQIAu9opvQ
	(envelope-from <kvm+bounces-71147-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 09:52:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DC6A14A1A1
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 09:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1D917301AAB7
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 08:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D8C2DAFDA;
	Tue, 17 Feb 2026 08:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XQ0AcDXp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9ED2877F4
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 08:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771318322; cv=none; b=u0W77KvjESvglR3+Z1bsQF1pNlk7ThVPftJVroheZuwSu03DwKIt7DFosmweNffwOkxmzNG+MgW/RIBgvccDGS+blAYvP9wX5Ymckc6DhVuRJ5cLHPMQoHBJqC24W+ea6vvnnGnhzE9IhzPoww3wqc/KWBTG5tdx/PnAeiZuZ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771318322; c=relaxed/simple;
	bh=z9v2eGPO98yQYxa7pdi54Q3clFHoZ4yUqPrRZ6jGAaM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:Cc:To:
	 References:In-Reply-To; b=PKMiZBiF2b8Z8KSrY5jZPI2rlj9GBXgKFBz1GVvZWbGnqmsYVDQehk1v/1q2HclF6YHma8Hz6C9Yj3FX7sKjC/2uroZzCgHkcCqSembacfQNZWgfpv7rguLXhZGl9Yf6lvNOC7C0YpoBesmNKLnx/FKlQXHJksavBbekLC9C1G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XQ0AcDXp; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61H6Hl4u3548407;
	Tue, 17 Feb 2026 08:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=z9v2eG
	PO98yQYxa7pdi54Q3clFHoZ4yUqPrRZ6jGAaM=; b=XQ0AcDXpfiaOodHABrfBPc
	lOFLVfJGtRTUhSRkl59AsdJUMimcica5DAe28XeDCKwb7ZsAJ3AsFksjP7CYtwEq
	DCgXaoC3brt7bNwIx3QT9NYL+7LrMrpv15kCS6heLMkqSV1sXvEOppbDoetz+XGn
	JzCwoQgKVyxImJiEqNBsTlhSxi3GOfHi0cd55WlzZ0C6ctXpZT1a8L0apqpHMngT
	hBMnVcobWnnK8NHq3gDhK6AQeAQxb0hcBBx7DfNz5gxMosl5Bafexr2K3Z3RHa6f
	8OqlKAHXqUU97qeue5HJLoT1Mc12I3blzizWoL+m9x8fyX61tFMRjAJkvIbqFoGw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcqu5mr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 08:51:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61H3OSbN011898;
	Tue, 17 Feb 2026 08:51:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb26ss63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 08:51:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61H8pkDE23593326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 08:51:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71FBC2004D;
	Tue, 17 Feb 2026 08:51:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D3142004B;
	Tue, 17 Feb 2026 08:51:46 +0000 (GMT)
Received: from darkmoore (unknown [9.87.130.124])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Feb 2026 08:51:46 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Feb 2026 09:51:41 +0100
Message-Id: <DGH3XLSWU2OB.29T9W7UBKFNRS@linux.ibm.com>
Subject: Re: [PATCH] s390x/kvm: Add ASTFLE facility 2 for nested
 virtualization
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: "Halil Pasic" <pasic@linux.ibm.com>, "Eric Farman"
 <farman@linux.ibm.com>,
        "Matthew Rosato" <mjrosato@linux.ibm.com>,
        "Richard
 Henderson" <richard.henderson@linaro.org>,
        "Ilya Leoshkevich"
 <iii@linux.ibm.com>,
        "David Hildenbrand" <david@kernel.org>,
        "Thomas Huth"
 <thuth@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Cornelia Huck"
 <cohuck@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Hendrik
 Brueckner" <brueckner@linux.ibm.com>,
        "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>,
        <qemu-s390x@nongnu.org>, <kvm@vger.kernel.org>
To: "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        "Christoph
 Schlameuss" <schlameuss@linux.ibm.com>,
        <qemu-devel@nongnu.org>
X-Mailer: aerc 0.21.0
References: <20260211-astfleie2-v1-1-cfa11f422fd8@linux.ibm.com>
 <8f5f2131-b5cc-4a9a-84f7-57586c3df928@linux.ibm.com>
In-Reply-To: <8f5f2131-b5cc-4a9a-84f7-57586c3df928@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9tM4ANgpK_AQqaAow0r-uO8I94VAgi36
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDA3MSBTYWx0ZWRfXxhPkqfcZfJhD
 R994RWTLLlXqN2+XV2LfkQunSZT3HP33ZCqK+QYwpPqfNQub1iLwylz6H51/UmzaHkstYUMpJKB
 64JdfAXccyw/Wh76r4YsknDiY0KfrGeLglchV3+I2YgdyoulFKEXyS+ypVQUM4j63kvsdZ79I6F
 PqEZUJRnbOP0CZlxi4K4n4ux/Ul6LrzEM1G0N1KN5V9XgSdUBZYf786Azkx261CKM+vFo21eezV
 qwkEnExDsJwhkFcKXbSqLoTQ0+9qFDCq3sfL/mbRDo5XGTOP1UCm2eigCw5mrynBnGTFC2W7jRI
 2ia0zmxflLxa9ofzZyAgzqT0CGnRpWoHYfMjInoWY2nqhN3fokZxf9mfrNy28uscuV/wZpp8Dsf
 WaTmsYV9KeZxxWhdjmqMCYVz2fnujRVoOlyZt5ITs6pHL/CT/T6B3OejQ2zQ2jtGnjutS3wuCYr
 kVMZR1IHc7403efbUzw==
X-Authority-Analysis: v=2.4 cv=UPXQ3Sfy c=1 sm=1 tr=0 ts=69942c27 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=69wJf7TsAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=Iy1ZBe_RzdfgodXlwn4A:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
 a=Fg1AiH1G6rFz08G2ETeA:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: 9tM4ANgpK_AQqaAow0r-uO8I94VAgi36
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_01,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170071
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-71147-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:email];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 5DC6A14A1A1
X-Rspamd-Action: no action

On Mon Feb 16, 2026 at 8:44 PM CET, Christian Borntraeger wrote:
>
>
> Am 11.02.26 um 15:56 schrieb Christoph Schlameuss:
>> Allow propagation of the ASTFLEIE2 feature bit.
>>=20
>> If the host does have the ASTFLE Interpretive Execution Facility 2 the
>> guest can enable the ASTFLE format 2 for its guests.
>>=20
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>> Cc: qemu-devel@nongnu.org
>> Cc: Halil Pasic <pasic@linux.ibm.com>
>> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
>> Cc: Eric Farman <farman@linux.ibm.com>
>> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
>> Cc: Richard Henderson <richard.henderson@linaro.org>
>> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Thomas Huth <thuth@redhat.com>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Cornelia Huck <cohuck@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
>> Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> To: qemu-s390x@nongnu.org
>> Cc: kvm@vger.kernel.org
>> ---
>>=20
>> @Christian, @Hendrik: Please confirm that we want to add ASTFLEIE2 to
>> the Z16 default facilities.
>
> This depends on the sie facility (sie format2) so I guess it should not b=
e default
> but rather FULL model.

Thank you, will limit it to the full model in the next version.

