Return-Path: <kvm+bounces-71408-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +D4CDYaKmGlwJgMAu9opvQ
	(envelope-from <kvm+bounces-71408-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:23:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 875171694F1
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 748943061E1F
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 16:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD73C330662;
	Fri, 20 Feb 2026 16:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lrwj5RFr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99E52EE607;
	Fri, 20 Feb 2026 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771604598; cv=none; b=qv5GUMthSME8q0f6/YsRzQR753ayh/cBHyRl5woPmfxN/nI88k/ZVgyPqQW6pjLVFrsU2J5aazfrQQGqVS4oyJiP/Lf9Vzk0fUgnE3mMY2+hximaQX05nvFPLJykH5dBAxW+9TJr8CHRMqebvyCz2bOUe9QBO/U5RleGL8Ygfw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771604598; c=relaxed/simple;
	bh=ByY821Zt8d69ZbHD8f7+1fVh4lFhKBxvqxMn20OJyek=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=XMWq/zO9KjOM/oRapiSS3GfvCgRwQPh5NsChnoO0hlgz2U1vL8DIdvCt3whTJPNx0jvGHH2kWSrsqeSkHCE2+vE44SBUtS9FFCb4V+x8kclDJm5MqxVdCjpdXYsojrPyG292hkE1WK1N6ciUX7Ya8pDGSkRwzfYyidnoHyZ5S5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lrwj5RFr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61KECY4K1369639;
	Fri, 20 Feb 2026 16:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=usuyQ5
	U+DZzDsnvNjYL9XwH5Bng08dzw2wl/LQ6wnU4=; b=lrwj5RFr1eK/doOvy++4vf
	ZhZfHZtJQOkuBKxFItdn4OvGxACAUGl34QoM06tV+Y3wiXCFZsSYyCGmFf1tD0rs
	1dshKPVO8omaZUysOfOsw8mSiralt4f6y5iT4n6b3KBpu9EsmkqpAq3l0M0uG4gC
	5k81X+HLNb19I6w5B52hfHHuqN4vE43ePF58Obxmbw1RwYZ+Qo4K8PQOehY4w3Z9
	gsQCUfcLwcVOBTux8t+vlAFmd7NWoRMb0IMh0QFeMO5MAQAaSO2xtnc+RIetsLxJ
	UjV5E38EmstdlF9O2DyQ9GA6vqQV4ipb6FrqOLJo5wH7zlz+/QYAVsDtDpx3qI9A
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcjte7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 16:23:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61KErKaI001432;
	Fri, 20 Feb 2026 16:23:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb2bs1w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 16:23:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61KGN9Db16711972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 16:23:09 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 675E42004D;
	Fri, 20 Feb 2026 16:23:09 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 398A42004B;
	Fri, 20 Feb 2026 16:23:09 +0000 (GMT)
Received: from darkmoore (unknown [9.111.14.199])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Feb 2026 16:23:09 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Feb 2026 17:23:03 +0100
Message-Id: <DGJXEUARFIQE.2Q5WYX7UEFAYN@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>,
        "David Hildenbrand" <david@redhat.com>,
        "Thomas Huth"
 <thuth@redhat.com>,
        "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, <kvm@vger.kernel.org>
To: "Janosch Frank" <frankja@linux.ibm.com>,
        "Christoph Schlameuss"
 <schlameuss@linux.ibm.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: sclp: Add detection of
 alternate STFLE facilities
X-Mailer: aerc 0.21.0
References: <20260211-vsie-stfle-fac-v1-0-46c7aec5912b@linux.ibm.com>
 <20260211-vsie-stfle-fac-v1-2-46c7aec5912b@linux.ibm.com>
 <48e794f6-0dc8-4e7e-8bf7-399015b044c2@linux.ibm.com>
In-Reply-To: <48e794f6-0dc8-4e7e-8bf7-399015b044c2@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M1hL7gqsLBj2CPA8Ervmk7rWGCh5eDUa
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=69988a72 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=VuqxOzA6QbOuqJYyls0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDE0MSBTYWx0ZWRfX8Tlz62g/KhOp
 RLL7uUv6U7mz8hw6R6iA5kX5ZU3YVrPA3vsCj3h0QnFPJL8CZYNXUHd/qLMzufNQZejWdhjQH7Q
 NOuTanIuiUXcqq7EkbqCD3U2KNjzFvxmXi0+h5Spgi9DWcPol8eRXlynew9ny6LDDApgsLK0A+F
 nJwLlJpXDYB7dAV3yeIFUktafGOTtfCSsb1UdPeEjRkqMtcHlc8fX2EqoBkJzUcCmFmYLU2rGKM
 TWUqNgQOk/si+O168dQuHQZ0GTjAZ1cO4xdDpcb9BHDF3LbEwh33y7oNr0yzIZk9bYLSAJRv9bq
 eIaUNbUZn71K3Jl95ZkylvtiP5OAHm10OR9sI1SkiCDaEqwaOx1pAARc1tPz9Du0jaPD41UaZPb
 QpvOSSwp62wcHtKQVK+LpbVuh8auAVnZBRG4or8ytY2T1tszcsSjxB9xl5//XXgOxIujig0WYSG
 ZG/0HrToo8glBlba2Fg==
X-Proofpoint-GUID: M1hL7gqsLBj2CPA8Ervmk7rWGCh5eDUa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_02,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602200141
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_FROM(0.00)[bounces-71408-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 875171694F1
X-Rspamd-Action: no action

On Fri Feb 20, 2026 at 11:20 AM CET, Janosch Frank wrote:
> On 2/11/26 15:57, Christoph Schlameuss wrote:
>> From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>=20
>> Detect availability of alternate STFLE interpretive execution facilities
>> 1 and 2.
>> Also fix number of unassigned bits in sclp_facilities which wasn't
>> adjusted in a prior commit adding entries to sclp_facilities.
>>=20
>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>> ---
>>   lib/s390x/sclp.c | 2 ++
>>   lib/s390x/sclp.h | 6 +++++-
>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
>> index 2f902e39e785ff4e139a39be2ffe11b5fa01edc0..7408b813b6396d572d740c19=
c15175e173fed596 100644
>> --- a/lib/s390x/sclp.c
>> +++ b/lib/s390x/sclp.c
>> @@ -163,8 +163,10 @@ void sclp_facilities_setup(void)
>>   	sclp_facilities.has_cmma =3D sclp_feat_check(116, SCLP_FEAT_116_BIT_C=
MMA);
>>   	sclp_facilities.has_64bscao =3D sclp_feat_check(116, SCLP_FEAT_116_BI=
T_64BSCAO);
>>   	sclp_facilities.has_esca =3D sclp_feat_check(116, SCLP_FEAT_116_BIT_E=
SCA);
>> +	sclp_facilities.has_astfleie1 =3D sclp_feat_check(116, SCLP_FEAT_116_B=
IT_ASTFLEIE1);
>>   	sclp_facilities.has_ibs =3D sclp_feat_check(117, SCLP_FEAT_117_BIT_IB=
S);
>>   	sclp_facilities.has_pfmfi =3D sclp_feat_check(117, SCLP_FEAT_117_BIT_=
PFMFI);
>> +	sclp_facilities.has_astfleie2 =3D sclp_feat_check(139, SCLP_FEAT_139_B=
IT_ASTFLEIE2);
>>  =20
>>   	for (i =3D 0; i < read_info->entries_cpu; i++, cpu++) {
>>   		/*
>> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
>> index 22f120d1b7ea7d1c3fe822385d0c689e5b3459fe..91a81c902eaa8ee6b999184a=
eb8a33633efd1065 100644
>> --- a/lib/s390x/sclp.h
>> +++ b/lib/s390x/sclp.h
>> @@ -129,10 +129,12 @@ struct sclp_facilities {
>>   	uint64_t has_cmma : 1;
>>   	uint64_t has_64bscao : 1;
>>   	uint64_t has_esca : 1;
>> +	uint64_t has_astfleie1 : 1;
>>   	uint64_t has_kss : 1;
>>   	uint64_t has_pfmfi : 1;
>>   	uint64_t has_ibs : 1;
>> -	uint64_t : 64 - 15;
>> +	uint64_t has_astfleie2 : 1;
>> +	uint64_t : 64 - 19;
>>   };
>
> 64 - 17?

Absolutely

> I was wondering why the static assert didn't trigger here. Turns out I=20
> only added it to a feature branch that didn't go upstream yet...
>
> Could you do me a favor and add a patch that introduces the static assert=
:
> _Static_assert(sizeof(struct sclp_facilities) =3D=3D sizeof(uint64_t));

Sure thing, I can add that to the next version. If we want to keep the padd=
ing.

> Then again, why do we pad that at all, it's not a FW struct and I hope=20
> that we never cast it to u64 and copy it somewhere.

I would assume nobody ever questioned that since you introduced the struct =
with
6dff7c9a123c ("s390x: SCLP feature checking")

As the ordering of these bits is nothing like anything anywhere else I agre=
e
that the manual padding is not necessary at all.
So I would rather opt to just remove the padding within its own commit and =
not
add the assertion.

>>  =20
>>   /* bit number within a certain byte */
>> @@ -143,8 +145,10 @@ struct sclp_facilities {
>>   #define SCLP_FEAT_116_BIT_64BSCAO	0
>>   #define SCLP_FEAT_116_BIT_CMMA		1
>>   #define SCLP_FEAT_116_BIT_ESCA		4
>> +#define SCLP_FEAT_116_BIT_ASTFLEIE1	7
>>   #define SCLP_FEAT_117_BIT_PFMFI		1
>>   #define SCLP_FEAT_117_BIT_IBS		2
>> +#define SCLP_FEAT_139_BIT_ASTFLEIE2	1
>>  =20
>>   typedef struct ReadInfo {
>>   	SCCBHeader h;
>>=20


