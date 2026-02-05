Return-Path: <kvm+bounces-70310-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NZbNORMhGm82QMAu9opvQ
	(envelope-from <kvm+bounces-70310-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 08:55:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CAAEFA22
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 08:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D304D3034674
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 07:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6559035FF42;
	Thu,  5 Feb 2026 07:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UsJclcUW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4283246F9;
	Thu,  5 Feb 2026 07:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770277919; cv=none; b=uba4yEfo7S3dI2+XrLoaavGrBFf0JtTA+EKfVZwSV6SceC7zDwU7Amdu6bAgnSJNfqQ+ElTFomQnFuLUUKpsbYm/G/khY3q2qplE8gXTvCZZ6fjTI1Vd+Rz+5kQTN6+CJ2VHSfzsi68iMY2t1kwkQUZs8aHGxSYSZ1eAytkoFqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770277919; c=relaxed/simple;
	bh=BfdJyDuGiSEAgpGhOUtN5etZ4gbhKjTFW/HX/yBX3nQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r/B+xtwaxGmRslqzyOCUvex5meMoHi3CMykcOM4gcjAj2DL46kSiotj198Z4PYFIHpLoIqhajAYygZl/M2xdgsEHBMoWbaU+vW7qHRRnPHnY92oaApP95FfJdpEPuoCP9ob4P0sU/h6I0P+iZqAgMUmqbfB1X1l4B+zpmrUrfsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UsJclcUW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6154OUtx012974;
	Thu, 5 Feb 2026 07:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=cLTHeAm+ZHZbscRh8eJEqzfwwSkCXi
	VxD/lO/5kmqKM=; b=UsJclcUWqsTa7Rjj/8e+PF0sgxXv8CVhvGsPPnGXEUfgii
	UTi44W0IFAqvpr/nLgHWqbExEzr18C6uGvHvRJknlYCYJO12czFoiy8kcDTaV9d9
	hwPP61iKXmPk9Fsh9Y7X3dw8hXHXs/Y6c3rOG8Eh6EQ+L7UHcGOfiCHVncoTcGTy
	3lwNP8QdEM1azXXXqayKkF0PWYRi3DAi569oFFsTvCssFlQe0PysJ/X3eNMCVUVk
	nKKZ2Hd/s0JsYPNk3PYuRx4xBnjm3mHf22IdnfdR6b4rZNvK9z6UQ8OjnHeviXIs
	OqxO6RZVVEpjUEnjBuquUCohb4tpPsmNo4OoUzWA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtdmuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Feb 2026 07:51:52 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 6157nBRg012544;
	Thu, 5 Feb 2026 07:51:51 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dtdmus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Feb 2026 07:51:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6156GdDE029053;
	Thu, 5 Feb 2026 07:51:51 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1v2sgy5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Feb 2026 07:51:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6157plQv19530388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Feb 2026 07:51:47 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FCAB2004B;
	Thu,  5 Feb 2026 07:51:47 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04A9E20040;
	Thu,  5 Feb 2026 07:51:47 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  5 Feb 2026 07:51:46 +0000 (GMT)
Date: Thu, 5 Feb 2026 08:51:44 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] s390: remove kvm_types.h from Kbuild
Message-ID: <20260205075144.7870B7f-hca@linux.ibm.com>
References: <20260205073119.1886986-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205073119.1886986-1-rdunlap@infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDA1MSBTYWx0ZWRfX2vgF9SV8/OOL
 +zrVnBlKmVJ5TsEW8R1ApwwMPjxUTWNMyjFj8c1Lvuh0vT7BH7DJCbMYJH0FIZbkS+R/GV82qaS
 EgMHUyf76esKXjucrLcyfq9ufnaaA8ws3GthJjueH+YKizxBAYbkpQ8lj8UOk0HGLai+2ro7BQS
 HUDJQQDbfJXlNjIJehqNFhZ+kJvKQXlbp4m2HuR5ipBIUFfVFYccai+dO+m0nDsZpPLCrXQ7a8G
 10UpyOpmOH9aN7OEdrawHL+qG0CQ/wcanc/PPgsxFDoF9ltix9Rc7JcmyfHQdYuJIYvivcFORN7
 JnDi/NxYf5ePnXaS9Ac+0Cjb2vSrPl0qFXcRPydPWBoTxe0w/hrxlm41DC+ZD/hV+D6giJXJtdC
 IycxVjzCs06WreVnIA7JgQWHDDrXLVrMpJorJy1RLaOmUlFIoIDTmCFAcBdhNb+EeamLuZ2gR7J
 wGxSk5a9Qv6AlEArP+Q==
X-Proofpoint-GUID: fVx6SSbOb64SF4J_C_Q7MacmzMDVCX_h
X-Proofpoint-ORIG-GUID: Qxkn-k2QzZAq8srA8g-khCYlpq6ivTGc
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=69844c18 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8
 a=1XWaLZrsAAAA:8 a=UqMay0hBck4bAEe2IIMA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_01,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602050051
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
	TAGGED_FROM(0.00)[bounces-70310-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hca@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,infradead.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 35CAAEFA22
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 11:31:19PM -0800, Randy Dunlap wrote:
> kvm_types.h is mandatory in include/asm-generic/Kbuild so having it
> in another Kbuild file causes a warning. Remove it from the arch/
> Kbuild file to fix the warning.
> 
> ../scripts/Makefile.asm-headers:39: redundant generic-y found in ../arch/s390/include/asm/Kbuild: kvm_types.h
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> v2: add more Cc:s
> 
> Cc: kvm@vger.kernel.org
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org

The additional cc's still miss Peter :)

https://lore.kernel.org/all/20260205074643.7870A22-hca@linux.ibm.com/

