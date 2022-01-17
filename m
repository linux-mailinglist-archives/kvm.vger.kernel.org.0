Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AAE490D0D
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbiAQRAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25862 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241419AbiAQQ77 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 11:59:59 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HFTNCc030239
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Zyoh96kS4O/cQJyvkQkZc2YlVVX7aJZ5CLRbZWgKf+I=;
 b=aOxAHh1woyTwckHvDHm4zCGPA0YmPrjvJYJy57KMYSMa4BetPxLLjsXaXuzuNVyY2UVG
 AbuZWzztwSVc1s7TCqefdn5raBYNgdQta+jDVDjO4iHIG7Sf3vrm6t+H/XgRtk577QRS
 pob7mAoeIJmo0Lw+HLnZaJ+99HRUJidESWHEUork0mHdCpsZbHozqCRNRrk2qX0EcgiM
 ZsXf2OMm7pGRTNUvEVUs+dwgXjwFdjueOW/NbXmuNVph+bOZHetv4+rTZl+llmpzeVPv
 2FdPiuvmigkyP6loy8vpVHCfXCtO21W20DK7Ec86tEJa0GJ+0dZNMtRunpAqQAxDVvQD Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnb4t2emx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:58 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGmJZc015009
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnb4t2em9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGl8Mx019671;
        Mon, 17 Jan 2022 16:59:56 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9e2tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxo9646924272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A78EA405C;
        Mon, 17 Jan 2022 16:59:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F576A4054;
        Mon, 17 Jan 2022 16:59:50 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/13] s390x update 2022-01-17
Date:   Mon, 17 Jan 2022 17:59:36 +0100
Message-Id: <20220117165949.75964-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pdsyace2-KvCV3jbAx11A1IDhe7vWFXW
X-Proofpoint-ORIG-GUID: Wu7iiarHJTEIHysork3aiUEbDGMPbh0F
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

please merge the following changes:
* snippet support for PV (Janosch)
* DMA31 allocation fixes (Janosch)

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/22

PIPELINE:
https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/449739146

PULL:
https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-20220117

Janosch Frank (13):
  s390x: snippets: mvpg-snippet: Remove unneeded includes
  lib: s390x: sie: Add sca allocation and freeing
  s390x: sie: Add PV fields to SIE control block
  s390x: sie: Add UV information into VM struct
  s390x: uv: Add more UV call functions
  s390x: lib: Extend UV library with PV guest management
  lib: s390: sie: Add PV guest register handling
  s390x: snippets: Add PV support
  lib: s390x: Introduce snippet helpers
  s390x: mvpg-sie: Use snippet helpers
  s390x: sie: Add PV diag test
  s390x: smp: Allocate memory in DMA31 space
  s390x: firq: Fix sclp buffer allocation

 configure                                  |   8 +
 s390x/Makefile                             |  73 ++++++--
 lib/s390x/asm/uv.h                         |  99 +++++++++++
 lib/s390x/sie.h                            |  54 +++++-
 lib/s390x/snippet.h                        | 110 ++++++++++++
 lib/s390x/uv.h                             |  28 +++
 lib/s390x/sie.c                            |  20 +++
 lib/s390x/uv.c                             | 128 ++++++++++++++
 s390x/snippets/asm/snippet-pv-diag-288.S   |  25 +++
 s390x/snippets/asm/snippet-pv-diag-500.S   |  39 +++++
 s390x/snippets/asm/snippet-pv-diag-yield.S |   7 +
 s390x/firq.c                               |   2 +-
 s390x/mvpg-sie.c                           |  24 +--
 s390x/pv-diags.c                           | 187 +++++++++++++++++++++
 s390x/smp.c                                |   4 +-
 s390x/snippets/c/mvpg-snippet.c            |   1 -
 .gitignore                                 |   2 +
 17 files changed, 773 insertions(+), 38 deletions(-)
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-288.S
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-500.S
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-yield.S
 create mode 100644 s390x/pv-diags.c

-- 
2.31.1

