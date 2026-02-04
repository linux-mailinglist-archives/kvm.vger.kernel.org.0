Return-Path: <kvm+bounces-70238-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eNb8Dqdng2kbmgMAu9opvQ
	(envelope-from <kvm+bounces-70238-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:37:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A91A5E8F84
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F1B673202890
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F68425CD5;
	Wed,  4 Feb 2026 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a/19D7CX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EDD1C84D0;
	Wed,  4 Feb 2026 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218644; cv=none; b=SBWXuE+heSwblI0le4t3CiDHI5z+kBdlQ8vpXApTHLSCXbovHHFiqTQR6oCFrynuMJ/17A2mUGQYLDqwh0iOXmqMyhVG0MgvH/jJcFEk/MRVjDbhc+Deqe5qRixgimprKGxkONzvHqJAaUUBtXBjchN/c35/LJiRg6qbI03bYmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218644; c=relaxed/simple;
	bh=uWY7fOB+LiiUmBddkPW1rqmepZ7GlPohSQ90qGCIIag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oU+wJuw6VVN0/qXTE0WvmiurmNpwR+iuJxh3Qjp30wjUP6fSS4754Qdwub79zxDSJ0FZetEbP7bQ8SrfeI9I++8FmN+4lIj9g5sDUCChNBKeseE9+gIvtHyeW9GFAoInDNqR7v5fVTOAWSXq+D4LqNDnsGDuz9Je1EwHriiJQcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a/19D7CX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613NOM5x001994;
	Wed, 4 Feb 2026 15:24:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=m5qdg2XaLdBjhbT8tebMsuDzrLHbgV
	hXtdSSOJaG13c=; b=a/19D7CXyI3UstzfpF26HD4NhVInjis9tbAb8piScRxDND
	HhfVKmA6Nbo8DwYXJskbQFgMzJvfbYNIp2iwhfT8XJeZAD6NEkmmGX/0vWnSRwfz
	m4Ja1TJ25kwIbeRrcuzWOUhmxCMFPLOtJlXeATseMi1lr3JZ3gcFsfyi7shGGKWV
	PGeZcTSN2MZY91gPqHUWlaZ+voAW8vE3/9l0PKGU2xdxXNCvG4K2S1PxZbimQxSd
	fCSOhFzJPJzlZQvIHln5+RrTILW1rcrVac0aW1prxr73xIYm0e4E5Dp972qltjoQ
	yo41JtmMKqFuRq/s1BU+YLNKMU4jTW8Xj+QlExLw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtag9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:24:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614Cj1HZ025735;
	Wed, 4 Feb 2026 15:24:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1w2mwrap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:24:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614FNuAJ28377580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:23:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B44F20043;
	Wed,  4 Feb 2026 15:23:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2545D20040;
	Wed,  4 Feb 2026 15:23:56 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  4 Feb 2026 15:23:56 +0000 (GMT)
Date: Wed, 4 Feb 2026 16:23:54 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, gra@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        david@kernel.org, gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v7 00/29] KVM: s390: gmap rewrite, the real deal
Message-ID: <20260204152354.6906B2f-hca@linux.ibm.com>
References: <20260204150259.60425-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204150259.60425-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExNyBTYWx0ZWRfX1J8Lp1NuzHDb
 in3VtW8ZIye0Vn0FG2sL2ekA0ZT6rKjF3mq8HXmW1Dsp/hpMsKV56C+i0lga1ncP7Xrq9wO+EjI
 m+cwAVBBbCeHipsF8/G5osb4dkO+PSHQl03lfNyhGMj9c/Ieti0e1alxoH7V+NI1YBoYfoPtwnh
 vOWF/ijw3E753wpKj8f5RugrVh2a6/I7BjyBpe//AilnDggwEQBLXFBdYRj8OG50LM4yz56OK1e
 Dp5/psvqfmqB2VZB/8bFtu4lfGBZ6oaNZ+QgNEuQdPGaW2DD9YjctzLE2e+C76hJAZwQIUZG9cA
 5j1RjTOXwYaoEi+C8ryK08sNepjlUvRzFlqah1Ybx7A8XU/GLG0XhmipIC93OSiyHBKWnpzlL48
 AZjPIeoZTaQi/oJtVAQJMl3o2kx0M4Fi8P6AslDlozg5ppRdh6KmupGWN4oAdzrfC3/d2F9bH3i
 65GaJ7hsXYHMghVP5Xw==
X-Proofpoint-GUID: lJWw9RLpYBM_GQ6KM8oQ2GX-0BMkzTVl
X-Proofpoint-ORIG-GUID: lJWw9RLpYBM_GQ6KM8oQ2GX-0BMkzTVl
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=69836492 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=zp8rA2SfgbRMV71b97gA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602040117
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70238-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hca@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: A91A5E8F84
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 04:02:29PM +0100, Claudio Imbrenda wrote:
> This series is the last big series of the gmap rewrite. It introduces
> the new code and actually uses it. The old code is then removed.
> 
> KVM on s390 will now use the mmu_notifier, like most other
> architectures. The gmap address space is now completely separate from
> userspace; no level of the page tables is shared between guest mapping
> and userspace.
> 
> One of the biggest advantages is that the page size of userspace is
> completely independent of the page size used by the guest. Userspace
> can mix normal pages, THPs, hugetlbfs, and more.
> 
> It's now possible to have nested guests and guests with huge pages
> running on the same host. In fact, it's possible to have a nested
> guest on a guest with huge pages. Transparent hugepages are also
> possible.

FWIW, for everything that touches code which is not only KVM:

Acked-by: Heiko Carstens <hca@linux.ibm.com>

