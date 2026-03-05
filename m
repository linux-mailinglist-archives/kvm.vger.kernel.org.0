Return-Path: <kvm+bounces-72812-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EF0BKKd1qWl77wAAu9opvQ
	(envelope-from <kvm+bounces-72812-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:23:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F34F92118A8
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C2543128D9C
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 12:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EDE39C630;
	Thu,  5 Mar 2026 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fMea0qYR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DC239526B;
	Thu,  5 Mar 2026 12:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772713233; cv=none; b=CBwaWhmHfw7uMxkXTWJbHcySpFr7hnK5JUND+CMKlx3k2KFfwUCnP4gZllyn+Tg/OxHh/+8UAm0aj5MCE+adjXyvRj8hhWSmRahinAGOnYcacs7tsVsALBZpU0i2IwzMKlnPEeJvIXkuooI/JM3azCeL2CQvyUaU7PUw48k/504=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772713233; c=relaxed/simple;
	bh=zjYlGr+Q4H+yOWD7CH1PIwtNgGBpgZU0gjO5j/dRU28=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mYiBt0uVOCtmqWP6+3qfI67PmaCRHqRJ6Jc43uh7oGAAkI8lNWZmhyX7uW3BFiLoNEk0yQDVOIcwEgqt+L6w4sjdwgA2Vt9R39ymauI0CbEKX75L/KF580Rb5Kcw7o+xkSNl8YkXAB4bVADf20YJLGxZLGD1P8ya1Wh8HcgNAJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fMea0qYR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624N9D6s1952726;
	Thu, 5 Mar 2026 12:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=+xwrCVYlATFGZpc2zRPmoixohkIx
	wcGyzwoSf+vq7lI=; b=fMea0qYRC+462SMzEoppMV+qHe1pdmfVwVs1kgD75ZTl
	WJmEpRfcovuGE34seKqvAIR0Zpx7s4KWKo//OmvF/8JrTnq1gQwEVdEMw7FS4Yex
	rxx0kpER0c0McDuW1aEK+H95576gogixEv27koUP4xDAVZYknd/2Hd1LnfQ9G74f
	arDSRy3HEqjRbtHEnjkrr0zzkXAi+nEAae4rxGqP4rVqY6hN/+bLCEJ5pmWEKGWc
	8JsV4IhaIfhxPxv3tdhq5qx9Eb/29YWasadpAI4F+Bb7bCVcel0z2OxaMIgYbH9l
	xsa/GhBtSVj4HfMAcZlkBSQcEPwzcq6oVSaHUU+3+A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrjbmv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 12:20:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 625Ag10B008782;
	Thu, 5 Mar 2026 12:20:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmdd1jx7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 12:20:26 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 625CKMWp57213300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Mar 2026 12:20:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66EF720043;
	Thu,  5 Mar 2026 12:20:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1779220040;
	Thu,  5 Mar 2026 12:20:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Mar 2026 12:20:22 +0000 (GMT)
From: Julian Ruess <julianr@linux.ibm.com>
Subject: [PATCH v3 0/3] vfio/pci: Introduce vfio_pci driver for ISM devices
Date: Thu, 05 Mar 2026 13:20:12 +0100
Message-Id: <20260305-vfio_pci_ism-v3-0-1217076c81d9@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAPx0qWkC/33Ry2rDMBAF0F8JWtdBM6OH1VX/o5Qg69EIajvYr
 UkJ/vfK3tQVossruGcGzYPNYUphZs+nB5vCkuY0DjnQ04m5qx3eQ5N8zgw5So6omyWm8XJz6ZL
 mvuHOOQxCIwrNcuU2hZjuO/f6lvM1zZ/j9L3rC26vG6Q4gPwLLdjwxilLUUklPdDLRxq+7ufU9
 Wc39pu9F/OgSjFy4EZI0hRtUdy2WOg42RQAZQCcB/A2cM19DRAHAKkAxLZ610bSFg12bQ2QR6D
 cQGZAR2W0JdEJCzVA/QLIVQGoDHhvNAluVNCmBuj/AJ0BobpW+GiVgVAD2gMAUABtBqQU3DrTY
 Vv/RDgCWACQASJChdbnM4gSWNf1B2lvG7GsAgAA
X-Change-ID: 20250227-vfio_pci_ism-0ccc2e472247
To: schnelle@linux.ibm.com, wintera@linux.ibm.com, ts@linux.ibm.com,
        oberpar@linux.ibm.com, gbayer@linux.ibm.com,
        Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <skolothumtho@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc: mjrosato@linux.ibm.com, alifm@linux.ibm.com, raspl@linux.ibm.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        julianr@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a9750b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=nE7OQj8zH4wYUFr7v7sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDA5OSBTYWx0ZWRfX1/suCNVGOmLh
 dKhWVQ5a9/rHI2Ikaq7MhZojwesO0mnZJ0mQhYtf1PIqMKkik7VIB7ER56XXF8+agNe1EMruAJO
 eSzPa4bUDQX4WaM0m4nqD7oeRy27IoWDnrcByysZNqieqz3iXxkgtqtDhSd428oa67NwyHXogX4
 vwp2P2wS2XJaxk34krO69ZlmsZ56P6lZx/1FqoOUDTwdiCPXiLmBV+3Y3GaX+Nzo9GymLV4nEJA
 a/8Lf70Y72JgpZcKhCYEXBY9sKLeQUmlUXoIrGH2Sj+VMAlsOXa9U3181IX5CH0xNp9MrjZRQHJ
 WZp9PTSgwtLwb8fTaf62QLITgsGB/hlYw+CcCYwmENssoqQdZiTKHAQXzUlayJ9vJn/+/KfK6hT
 4OP7BwOYc1Gw1TYGT/N4q+TkXxUGCfqQzuemmq/nZaEA0je2AG4DHMxqFQ64/P8uPeJuZJDMcFj
 /bHq3MisXDSxw9OJ3Dg==
X-Proofpoint-GUID: MQnR4TTiYZeLvigTLhFsWYjRIVRFgblY
X-Proofpoint-ORIG-GUID: MQnR4TTiYZeLvigTLhFsWYjRIVRFgblY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050099
X-Rspamd-Queue-Id: F34F92118A8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-72812-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[julianr@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Hi all,

This series adds a vfio_pci variant driver for the s390-specific
Internal Shared Memory (ISM) devices used for inter-VM communication
including SMC-D.

This is a prerequisite for an in-development open-source user space
driver stack that will allow to use ISM devices to provide remote
console and block device functionality. This stack will be part of
s390-tools.

This driver would also allow QEMU to mediate access to an ISM device,
enabling a form of PCI pass-through even for guests whose hardware
cannot directly execute PCI accesses, such as nested guests.

On s390, kernel primitives such as ioread() and iowrite() are switched
over from function handle based PCI load/stores instructions to PCI
memory-I/O (MIO) loads/stores when these are available and not
explicitly disabled. Since these instructions cannot be used with ISM
devices, ensure that classic function handle-based PCI instructions are
used instead.

The driver is still required even when MIO instructions are disabled, as
the ISM device relies on the PCI store‑block (PCISTB) instruction to
perform write operations.

Thank you,
Julian

Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
---
Changes in v3:
- Add comments to ism_vfio_pci_do_io_r() and ism_vfio_pci_do_io_w().
- Format Kconfig.
- Add 4k boundary check to ism_vfio_pci_do_io_w().
- Use kmem_cache instead of kzalloc in ism_vfio_pci_do_io_w().
- Add error handler to struct ism_vfio_pci_driver.
- Link to v2: https://lore.kernel.org/r/20260224-vfio_pci_ism-v2-0-f010945373fa@linux.ibm.com

Changes in v2:
- Remove common code patch that sets VFIO_PCI_OFFSET_SHIFT to 48.
- Implement ism_vfio_pci_ioctl_get_region_info() to have own region
  offsets.
- For config space accesses, rename vfio_config_do_rw() to
  vfio_pci_config_rw_single() and export it.
- Use zdev->maxstbl instead of ZPCI_BOUNDARY_SIZE.
- Add comment that zPCI must not use MIO instructions for config space
  access.
- Rework patch descriptions.
- Update license info.
- Link to v1: https://lore.kernel.org/r/20260212-vfio_pci_ism-v1-0-333262ade074@linux.ibm.com

---
Julian Ruess (3):
      vfio/pci: Rename vfio_config_do_rw() to vfio_pci_config_rw_single() and export it
      vfio/ism: Implement vfio_pci driver for ISM devices
      MAINTAINERS: add VFIO ISM PCI DRIVER section

 MAINTAINERS                        |   6 +
 drivers/vfio/pci/Kconfig           |   2 +
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/ism/Kconfig       |  10 ++
 drivers/vfio/pci/ism/Makefile      |   3 +
 drivers/vfio/pci/ism/main.c        | 343 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c |   8 +-
 drivers/vfio/pci/vfio_pci_priv.h   |   4 +
 8 files changed, 375 insertions(+), 3 deletions(-)
---
base-commit: c107785c7e8dbabd1c18301a1c362544b5786282
change-id: 20250227-vfio_pci_ism-0ccc2e472247

Best regards,
-- 
Julian Ruess <julianr@linux.ibm.com>


