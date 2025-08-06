Return-Path: <kvm+bounces-54101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D01EBB1C2BC
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 11:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11E7B16FB33
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A08289371;
	Wed,  6 Aug 2025 09:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oT7O54bD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA35289353;
	Wed,  6 Aug 2025 09:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754471005; cv=none; b=kmQU4oHkpRdYTGBnWYkXDmY8flUMnvubqvJRrkxdIeGBJt4a2CZqhEKFR8jaGWPNtZp0iAK3pCh66yNqQTnqxjf4STy44bdg4XoziPP5yrGbVy17sQi2aaOSnw2hdO6RlKIArucwJQgM6JNpLpc5S4GxmFAk5EW8VH4Os7fVrC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754471005; c=relaxed/simple;
	bh=klJaCPkxHO3iA02bycImPY4bFZkjJtcJl83fmkJxGzg=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=JqR8YfXCmTOMWipPSpaR6XH88HJL2VOLaWdqOQS1kL3gghr4ng3qSwcC3RKgzoEbXEPOmBBtkZxnDwQS5kF5tfP6fIBpca6Ba5baUjm7+fnbT9mRCgTOGn70dfrb5y71NMIkhffnQoWRbCuyOUEX1+WWoF/39hZNwTQvEy9GwEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oT7O54bD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5767MkjB012350;
	Wed, 6 Aug 2025 09:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=klJaCP
	kxHO3iA02bycImPY4bFZkjJtcJl83fmkJxGzg=; b=oT7O54bDdXOT979zt+wt5B
	aQNhZu/SUmeuDSyzTuQ31gWF5XmmnxDky1++9J5Z+P8MgKe4x2tpzR3aJgcp/3oO
	JjLQa87p4ITSONoctW4Ue9I3mIO3brVfiVWu4sKD8ikUcBW+9q2+A152dvC9rZr3
	U65zD2fouRUgcVPEqno5iq5LTqlG3dEtosEyGpP5CNPxCLNY+BqgEdTE5d5MH/Lb
	Al9Z6kVj2gY0QZ4HQKWmTaonGBE752+Nrktrv9p1H67JDlWELpLzUHWEcz67Xg7F
	pCX42xBpHjWk0npO57xSTNiRwOqzp/jCVRTrXCjHF8ZTA3EsD5gnJQrWPbA91ZBA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bq63k6sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 09:03:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57683Pfs022699;
	Wed, 6 Aug 2025 09:03:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwqav7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 09:03:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57693GnO15139148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 Aug 2025 09:03:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 134AF2004E;
	Wed,  6 Aug 2025 09:03:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0048D2004B;
	Wed,  6 Aug 2025 09:03:16 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  6 Aug 2025 09:03:15 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 06 Aug 2025 11:03:10 +0200
Message-Id: <DBV826C4QLJX.1DV3DNBWNHHTJ@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>, <david@redhat.com>,
        <frankja@linux.ibm.com>, <seiden@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <hca@linux.ibm.com>, <mhartmay@linux.ibm.com>,
        <borntraeger@de.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
X-Mailer: aerc 0.20.1
References: <20250805141746.71267-1-imbrenda@linux.ibm.com>
 <20250805141746.71267-3-imbrenda@linux.ibm.com>
In-Reply-To: <20250805141746.71267-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDA1MyBTYWx0ZWRfX5FT6MckmRIxn
 b3/DseWqEQw4d3oYnsx/CAw7DU0LsjF0pgbpEFZ5ABXHlRdYXSS6VBOZwmy2wXqWjsaLDnXBoGL
 70SKgS1z07JuN7cKSSMgcYLk2tAUjqBieJrYc/Pzia/I0nmZSGtDiMD2rAy8q8Jtha+oIcTJxBF
 ZQLLTRJdqeK8omxA/d+p6/R9TxIJjeP1aKxI9Asq9V6RBTVpbXfI62M/AATC4Dp/4Dq88SfTqHu
 mquDGEFWXeOlohnuzDnjqrD/pl5rHtwDRmIaEIN52ocaJV4yokLK2nyjkrOW/Jbt00dXzGrm94K
 jiKt1L74v+h9Yp6jTUtWhjGiCZ/1AeiN7I21nYnabKw2iFD0gXLI/bVKxoogWdwmt2Erd3ZdPi+
 p9PLqEHdZveDpIAb6Mg72knCYWTfHLQc0CKjV86LBFZrHe/R4pTZpGURWljK9JyqqjBPp5M4
X-Proofpoint-ORIG-GUID: YZbFSikTNA7D89C74hhgQJzL0qu2wYMi
X-Authority-Analysis: v=2.4 cv=LreSymdc c=1 sm=1 tr=0 ts=68931a59 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=hKoHGS1yLziZwobD-tEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: YZbFSikTNA7D89C74hhgQJzL0qu2wYMi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_02,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=699 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508060053

On Tue Aug 5, 2025 at 4:17 PM CEST, Claudio Imbrenda wrote:
> Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
> FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
> instead.
>
> This still works because they happen to have the same integer value,
> but it's a mistake, thus the fix.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interru=
pts in KVM")
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

[...]


