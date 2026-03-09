Return-Path: <kvm+bounces-73335-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENkGAef7rmnZKgIAu9opvQ
	(envelope-from <kvm+bounces-73335-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:57:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5466A23D2E5
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0DC03138625
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 16:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABC23E9598;
	Mon,  9 Mar 2026 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VOLCym7c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0463E7176;
	Mon,  9 Mar 2026 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773074936; cv=none; b=vCJ/yU6hkOEjy+A+FabwXxDmQ1EgCUTkdHYqhyHXzJnyJ2e7I0572n4vJngSiO564fqIlvj0hG0yL6Afsm9XjQFW2W6yBYamcYstdbBJSxku4wDnv9KW3zVJRkksb5DgX5PUblOWAkDLZ/URs0YdDUQYdMXIoIXXs8g+Ho8AW/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773074936; c=relaxed/simple;
	bh=R2t8aT9AfEryA2jCPKdVCwNrXnUCL7+CnrkUTC8dBXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YtcNQnd3Msquur9e2ewZRv46KeaCm45KmCXH3YoZZm9B2KNboqmJbvFnw4GCqX7f0246KNlWti52F+bpD4YFtPLR7KUaDmO28USthr+ulcpVIlvDLUHeCm3NatacxhSRux/0QWqkTnrf/yoHfx1kIaTaicftrZbCUNaCGCn5ttc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VOLCym7c; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629FEvNG1377495;
	Mon, 9 Mar 2026 16:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=i3dle+
	I6+lhzmsmx2XC26uNVY9RQtVYKjJf8QxUxP/8=; b=VOLCym7cSHKTsdPIZcn3Bz
	AgKP+vTmbDPDV4NLmEvf/4e5NsxZA66ktwlECAFwD4Uv9V8eGCWnhiXzSJlIUo9a
	ztyr9Ll51DyPl4xey/fJduJDIEW76Z0D/mMG1QR1B1SPdCN+9nMVQ3B+wCFiXrHQ
	KfpZTsoj4C7IEEJUUVTbvcqvlIev8uM+2xLWQkCs1SHtmpkGze5ks37/hUE4FYwl
	RWOAgM4L0pQXAwS/hgJEPriHDEPxLQ3ZNbDYUhBe80iDM5Rf3Mt9Qgz6nzYR+1DK
	MwaeLyqKXDlM9jhGxazmvILiDZUebSw7/4Op4/2KgynCKJVDjX6M5OQPM2eLgPXw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvr7arr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 16:48:49 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 629G3Ufs015758;
	Mon, 9 Mar 2026 16:48:48 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs121wfxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 16:48:48 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 629GmkHk525198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Mar 2026 16:48:46 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA5995805C;
	Mon,  9 Mar 2026 16:48:46 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6CF958058;
	Mon,  9 Mar 2026 16:48:44 +0000 (GMT)
Received: from [9.61.251.111] (unknown [9.61.251.111])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Mar 2026 16:48:44 +0000 (GMT)
Message-ID: <7bc3e127-c2de-4e72-9bbb-9554da2c1e22@linux.ibm.com>
Date: Mon, 9 Mar 2026 09:48:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] vfio/ism: Implement vfio_pci driver for ISM
 devices
To: Julian Ruess <julianr@linux.ibm.com>, schnelle@linux.ibm.com,
        wintera@linux.ibm.com, ts@linux.ibm.com, oberpar@linux.ibm.com,
        gbayer@linux.ibm.com, Alex Williamson <alex@shazbot.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc: mjrosato@linux.ibm.com, raspl@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20260305-vfio_pci_ism-v3-0-1217076c81d9@linux.ibm.com>
 <20260305-vfio_pci_ism-v3-2-1217076c81d9@linux.ibm.com>
Content-Language: en-US
From: Farhan Ali <alifm@linux.ibm.com>
In-Reply-To: <20260305-vfio_pci_ism-v3-2-1217076c81d9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE0OSBTYWx0ZWRfX5Mou3i/qOXyH
 d51DrAWmG0eTJ3+qZIuwxwilVK+eZp8qJ02dJiadI3m+SwvyKvvo1BFcq/REYlNA8VpcHU40cy6
 CnLZzzUucMN2CphRQ0WR1SaES0J6amRx5h3yyJ2IjoGMGhOboKFeu6/mOEOnLNTJcuyyEwrmekM
 DQEj4Y+O/F1LRgErr0XpPrwf/rbBak2MRRu0iExmgyevNkfOntEWg41WIDZFkYVMy1Rr8AdC5qH
 Az4020xVFuO6hIOIIVoeidGsXoZ4sMF/oXl37Fl7vEtZorSsYFLSGnP5CvrEQoVcUhU3f8BtMye
 kh9wHxsQAXfhUh+AerBOgLMJr1OEQ6LDWk6psoPUSAkvpJVDnecoDe6JbtFwKAvtZggbpM+s+Yc
 qbauMRcZrE/v2c6fm1jSapPWwt+VaKZbse/O1LHHJ0kJh/n0bgdCw3fkxdKbYafDfio/9cCS3n4
 AP/lhpE5kiaYpzZiMAQ==
X-Proofpoint-GUID: V7IiDIBV_wBRJNM3FNP_d3VmVnEJtneF
X-Proofpoint-ORIG-GUID: V7IiDIBV_wBRJNM3FNP_d3VmVnEJtneF
X-Authority-Analysis: v=2.4 cv=QoFTHFyd c=1 sm=1 tr=0 ts=69aef9f1 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=akap8JHnbm7pTVdsz3UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603090149
X-Rspamd-Queue-Id: 5466A23D2E5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	TAGGED_FROM(0.00)[bounces-73335-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alifm@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.955];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action


On 3/5/2026 4:20 AM, Julian Ruess wrote:
> Add a vfio_pci variant driver for the s390-specific Internal Shared
> Memory (ISM) devices used for inter-VM communication.
>
> This enables the development of vfio-pci-based user space drivers for
> ISM devices.
>
> On s390, kernel primitives such as ioread() and iowrite() are switched
> over from function handle based PCI load/stores instructions to PCI
> memory-I/O (MIO) loads/stores when these are available and not
> explicitly disabled. Since these instructions cannot be used with ISM
> devices, ensure that classic function handle-based PCI instructions are
> used instead.
>
> The driver is still required even when MIO instructions are disabled, as
> the ISM device relies on the PCI store block (PCISTB) instruction to
> perform write operations.
>
> Stores are not fragmented, therefore one ioctl corresponds to exactly
> one PCISTB instruction. User space must ensure to not write more than
> 4096 bytes at once to an ISM BAR which is the maximum payload of the
> PCISTB instruction.
>
> Reviewed-by: Niklas Schnelle<schnelle@linux.ibm.com>
> Signed-off-by: Julian Ruess<julianr@linux.ibm.com>
> ---
>   drivers/vfio/pci/Kconfig      |   2 +
>   drivers/vfio/pci/Makefile     |   2 +
>   drivers/vfio/pci/ism/Kconfig  |  10 ++
>   drivers/vfio/pci/ism/Makefile |   3 +
>   drivers/vfio/pci/ism/main.c   | 343 ++++++++++++++++++++++++++++++++++++++++++
>   5 files changed, 360 insertions(+)

Reviewed-by: Farhan Ali<alifm@linux.ibm.com>


