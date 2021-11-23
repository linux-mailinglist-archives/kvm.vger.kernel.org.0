Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0045A075
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 11:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhKWKnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 05:43:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234392AbhKWKnS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 05:43:18 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN8MWNh002782;
        Tue, 23 Nov 2021 10:40:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LHZYaHKhgFGjcnKVhXmXKL1NHRmkGa64mKACwnV7hJM=;
 b=eYcSPChf5Dsl6TBOAGO4caMt10QGbQZ4145bLuCisG1l1ePDjc2078WFftKoz8rZS50n
 wfyeTyxl97u8/cG2MCjhE7UVMplw8URDMoeIOG/fxJuV8d1dkPekjPb4Qep4QETWCVxF
 QMWFRFKUKZB63x4oWHVIb2Z/gLAi/xCOyFUE2++tjJNaw22zebt3pZOeTG2RSvBuTJhx
 inflIzYSBLeUERlztgNZ8elC6FIoJcWlwy+R5qmicU0UiiIy0MznZ7NvnQ7rn/gcbYXc
 TyOP7gM2hBVrqUJhZWsYCWh474zTHQ8xphAX8qj+pYL7qESjAupn6q06B8xDdoJGf5Ib EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgvr0jhv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:10 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANAQMh9022860;
        Tue, 23 Nov 2021 10:40:10 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgvr0jhuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:10 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAcYpW017460;
        Tue, 23 Nov 2021 10:40:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3cern9dk5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANAWt1s61538758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 10:32:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14E83A406F;
        Tue, 23 Nov 2021 10:40:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6EBEA405F;
        Tue, 23 Nov 2021 10:40:02 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 10:40:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/8] s390x: sie: Add PV snippet support
Date:   Tue, 23 Nov 2021 10:39:48 +0000
Message-Id: <20211123103956.2170-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SdBkcMA4iI62285mbfzcr7WBN3yrlY3K
X-Proofpoint-GUID: Chy7DgCeBbfjJH2wRlQBatcpLLUqj2Y6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding PV virtualization support was only a matter of time so here it
is.

The biggest problem that needed solving was having the SE header as a
separate file. The genprotimg tool generates the header and adds a
short bit of code to the image which will put the guest into PV mode
via the diagnose 308 PV subcodes. We don't have and want an emulation
for the diagnose so we don't support this way of starting a PV guest.

Therefore we needed a new tool that generates the PV image separate
from the SE header so we can link both as binary blobs. Marc created
this tool by writing a library which lets users create a SE header and
has bindings to multiple languages. Unfortunately we didn't yet have
time to upstream this but we plan to publish it once we find some.

The first PV snippet test checks the "easy" diagnose calls 0x44, 0x9c,
0x288 and 0x500. We check register contents and responses to PGM
injects.

A huge thanks goes out to Steffen and Marc who helped me make this
possible.

Janosch Frank (8):
  lib: s390x: sie: Add sca allocation and freeing
  s390x: sie: Add PV fields to SIE control block
  s390x: sie: Add UV information into VM struct
  s390x: uv: Add more UV call functions
  s390x: lib: Extend UV library with PV guest management
  lib: s390: sie: Add PV guest register handling
  s390x: snippets: Add PV support
  s390x: sie: Add PV diag test

 .gitignore                                 |   2 +
 configure                                  |   8 +
 lib/s390x/asm/uv.h                         |  99 +++++++++
 lib/s390x/sie.c                            |  20 ++
 lib/s390x/sie.h                            |  54 ++++-
 lib/s390x/snippet.h                        |   7 +
 lib/s390x/uv.c                             | 128 +++++++++++
 lib/s390x/uv.h                             |   7 +
 s390x/Makefile                             |  74 ++++++-
 s390x/pv-diags.c                           | 240 +++++++++++++++++++++
 s390x/snippets/asm/snippet-pv-diag-288.S   |  25 +++
 s390x/snippets/asm/snippet-pv-diag-500.S   |  39 ++++
 s390x/snippets/asm/snippet-pv-diag-yield.S |   7 +
 13 files changed, 692 insertions(+), 18 deletions(-)
 create mode 100644 s390x/pv-diags.c
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-288.S
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-500.S
 create mode 100644 s390x/snippets/asm/snippet-pv-diag-yield.S

-- 
2.32.0

