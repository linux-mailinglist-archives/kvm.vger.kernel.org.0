Return-Path: <kvm+bounces-70952-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Mq8BpbOjWn87AAAu9opvQ
	(envelope-from <kvm+bounces-70952-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 13:59:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D06412DAE8
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 13:59:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 64F13307B7C1
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 12:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B34344036;
	Thu, 12 Feb 2026 12:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ox+m0vZq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A576914A91
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 12:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770901059; cv=none; b=XJLcqDTYSraih1Ho+x1YRZpHFB55puT8NDDjKWmFOKLwI0Fu/iZ7pKg0MiDh0/4IcPNZKBT1HPcjSu4ISYy6OXEyy6LuzYQT/UMDOCuw8krfk/cPLiGtjYp5/2kb853W/EHDxwoKsqm9DkVOFnQf+ULQztRSYAuzg1wndaqr0Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770901059; c=relaxed/simple;
	bh=vKuHTDMti6zpEL3rYV0DdCMF4N/d093St4ruRMzCJdc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TerdaDPr4VClxl54XIuFjIeec30ZoAr3/A0IvDOg7iQZY56AbQ2SDdhPgRe9WKvMMm6nHgWsI65EvPD9WrIrsqsvfr4DC/ddswTE3zFqNXhS4aoKbaERy80j3ph0kXKACYOAcWpiunKmhZf6ItjebxuJIOuN7R3v/EhcAFTNZmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ox+m0vZq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61C6R4cO247099;
	Thu, 12 Feb 2026 12:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=vKuHTD
	Mti6zpEL3rYV0DdCMF4N/d093St4ruRMzCJdc=; b=Ox+m0vZqgjH7hLbJJ6BE4N
	hFQl0KGEA3XA5pVjuJ+OzopAZ7F5brH9AGklRWHOd0K3ZI/9PQr6o+5nAuu2h+uS
	k4kRUW1KwmlHlBbrT1uHcP8Sx96UIOvNCJN2AZMWJB9MXf4zeQaBD7NifVBSbkSq
	9iQ5am9TIFmGm9V1pGPkjv/JtjcYG+30EwQBXLCXLWW8UkYncvTM/zrEAmKQpxTZ
	wJ6v832xbae42lVaryX58jkQ54ls5GFWrQz9Icm6teLA5d+l8K8ARHf9uf3aVgOO
	ntO4GJ2xiKe99xOBKPIH4KIUfAv+UA7q9Wv2jotE9yRtkt/4x7VhPBSR7YomGEUg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v3fhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 12:57:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61CAFKHE001847;
	Thu, 12 Feb 2026 12:57:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je2a5xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 12:57:28 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61CCvOYC51642872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 12:57:24 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 821CD20043;
	Thu, 12 Feb 2026 12:57:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F12B20040;
	Thu, 12 Feb 2026 12:57:23 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.111.78.249])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Feb 2026 12:57:23 +0000 (GMT)
Message-ID: <210594e4dcac9d0adaa1a49c16af7b73075bc1b8.camel@linux.ibm.com>
Subject: Re: [PATCH] s390x/kvm: Add ASTFLE facility 2 for nested
 virtualization
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, qemu-devel@nongnu.org
Cc: Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger	
 <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew
 Rosato	 <mjrosato@linux.ibm.com>,
        Richard Henderson
 <richard.henderson@linaro.org>,
        Ilya Leoshkevich	 <iii@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>, Thomas Huth	 <thuth@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck	 <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Hendrik Brueckner	
 <brueckner@linux.ibm.com>, qemu-s390x@nongnu.org,
        kvm@vger.kernel.org
Date: Thu, 12 Feb 2026 13:57:41 +0100
In-Reply-To: <20260211-astfleie2-v1-1-cfa11f422fd8@linux.ibm.com>
References: <20260211-astfleie2-v1-1-cfa11f422fd8@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDA5NiBTYWx0ZWRfX/GSdhVx35i3w
 YGpaOgwPS/OT7SWQJFZCqB3yklB04xGwPp18XrQG5V1lOVNT8/wWvJFva0SezKNKDbHJdXE4gAH
 BywfNwQZ35KHDJrkiFhzsTSmUI1V54SJD0Dw12CnGk9I+580TowiBiYb3NfRi5XlM3CFp4KTnLs
 gVUK8xguziuvbBBGQJNKFOJr11+IDlUqhee/QoFa8rKpCGFLxw7pCFxUefAZDQsy9PpW/vnW2fQ
 L60ilzTLk/BDP68yCP6lBotzc+YfF3hyamr/8AgWMv7kr0EYH/mqaCRVXxsvBwGZ7K0/Y5UT6id
 C6GIX0KUlSIucIyzTb/JOoalI1FXY6m+ALH+9i7KhW4sN2whV7A6c6HfiKGXV76+XIGOmnFzGwK
 VQSQRaDnf7oj2TANhY3FDBBGewrhx2CmPjFnsZbsQEjkrWFOlN6FTj23ztEbL3KgZidkjMC3UW4
 5LJkr9rk95HGhVmA0sg==
X-Proofpoint-ORIG-GUID: rwa0Ng6_72RHzpFKq1WMuEFNjSmLJMlY
X-Proofpoint-GUID: rwa0Ng6_72RHzpFKq1WMuEFNjSmLJMlY
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698dce39 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=jluB_lIlwI9kuYLZUVYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_03,2026-02-12_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1011 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602120096
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:mid];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nsg@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70952-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: 6D06412DAE8
X-Rspamd-Action: no action

On Wed, 2026-02-11 at 15:56 +0100, Christoph Schlameuss wrote:
> Allow propagation of the ASTFLEIE2 feature bit.
>=20
> If the host does have the ASTFLE Interpretive Execution Facility 2 the
> guest can enable the ASTFLE format 2 for its guests.
>=20
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

--=20
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: Ehningen / Registergericht: Amtsgericht Stuttgart, H=
RB 243294

