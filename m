Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43072816FB
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388085AbgJBPog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:44:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388046AbgJBPo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:44:28 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092FgpHk143003
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WnwSEraaKWEae3aWVDe/6zBtOV1Oh9BhIGV/Eyaawx0=;
 b=LvQKEGbhJuvLwyldoPSfY3Xz5Rg78es93Bf1XGNLS67KEMTc38WQ492/kjInDqDn2kaL
 +4hVc2hvZizg5U17exXvnTFg3NxOztZ/zwoi1e5TEmoEByy/fyGyNQSkqjR8W74d1No7
 VBMydpsZqw193onRUpv9bqHfR48FOuPmgRDIJibLAXgXr96u2T97UpEb39nsHwZi50qx
 ShtFErpKanSQEHTxnukOrUeo1FZjYpnlYmJczWZni2pGI6RfUCtYxSaR97lPXemvukUn
 SF0InzxU+JTlhCroXEpxed2R0Z/e6FxbLuH2ZSjlWILkEzal8WFOhhwWJO+gEFzR3sDN 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x73br0rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 11:44:27 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092FhVI1144150
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:27 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x73br0r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:44:27 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092FgrLo017369;
        Fri, 2 Oct 2020 15:44:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 33wgcu0jxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:44:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092FiMTd32637358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:44:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C92724203F;
        Fri,  2 Oct 2020 15:44:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 686FC42041;
        Fri,  2 Oct 2020 15:44:22 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:44:22 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/7] lib/asm: Add definitions of memory areas
Date:   Fri,  2 Oct 2020 17:44:16 +0200
Message-Id: <20201002154420.292134-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=2 bulkscore=0
 phishscore=0 adultscore=0 mlxscore=0 clxscore=1015 mlxlogscore=800
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add definitions and boundaries of memory areas for some architectures.
This is needed by the next patch.

Most architectures only get one generic memory area, wherease x86 and
s390x get some more attention:

x86 gets
* lowest area (24-bit addresses)
* low area (32-bit addresses)
* the rest

s390x gets
* low area (31-bit addresses)
* the rest

Notice that the number indicates the order in which the areas are
scanned when more than one area is indicated. The default order tries
to get allocations from higher address ranges before trying lower ones.
This tries to keep the precious lower addresses as free as possible.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/asm-generic/memory_areas.h | 11 +++++++++++
 lib/arm/asm/memory_areas.h     | 11 +++++++++++
 lib/arm64/asm/memory_areas.h   | 11 +++++++++++
 lib/powerpc/asm/memory_areas.h | 11 +++++++++++
 lib/ppc64/asm/memory_areas.h   | 11 +++++++++++
 lib/s390x/asm/memory_areas.h   | 17 +++++++++++++++++
 lib/x86/asm/memory_areas.h     | 22 ++++++++++++++++++++++
 7 files changed, 94 insertions(+)
 create mode 100644 lib/asm-generic/memory_areas.h
 create mode 100644 lib/arm/asm/memory_areas.h
 create mode 100644 lib/arm64/asm/memory_areas.h
 create mode 100644 lib/powerpc/asm/memory_areas.h
 create mode 100644 lib/ppc64/asm/memory_areas.h
 create mode 100644 lib/s390x/asm/memory_areas.h
 create mode 100644 lib/x86/asm/memory_areas.h

diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
new file mode 100644
index 0000000..927baa7
--- /dev/null
+++ b/lib/asm-generic/memory_areas.h
@@ -0,0 +1,11 @@
+#ifndef MEMORY_AREAS_H
+#define MEMORY_AREAS_H
+
+#define AREA_NORMAL_PFN 0
+#define AREA_NORMAL_NUMBER 0
+#define AREA_NORMAL 1
+
+#define AREA_ANY -1
+#define AREA_ANY_NUMBER 0xff
+
+#endif
diff --git a/lib/arm/asm/memory_areas.h b/lib/arm/asm/memory_areas.h
new file mode 100644
index 0000000..927baa7
--- /dev/null
+++ b/lib/arm/asm/memory_areas.h
@@ -0,0 +1,11 @@
+#ifndef MEMORY_AREAS_H
+#define MEMORY_AREAS_H
+
+#define AREA_NORMAL_PFN 0
+#define AREA_NORMAL_NUMBER 0
+#define AREA_NORMAL 1
+
+#define AREA_ANY -1
+#define AREA_ANY_NUMBER 0xff
+
+#endif
diff --git a/lib/arm64/asm/memory_areas.h b/lib/arm64/asm/memory_areas.h
new file mode 100644
index 0000000..927baa7
--- /dev/null
+++ b/lib/arm64/asm/memory_areas.h
@@ -0,0 +1,11 @@
+#ifndef MEMORY_AREAS_H
+#define MEMORY_AREAS_H
+
+#define AREA_NORMAL_PFN 0
+#define AREA_NORMAL_NUMBER 0
+#define AREA_NORMAL 1
+
+#define AREA_ANY -1
+#define AREA_ANY_NUMBER 0xff
+
+#endif
diff --git a/lib/powerpc/asm/memory_areas.h b/lib/powerpc/asm/memory_areas.h
new file mode 100644
index 0000000..927baa7
--- /dev/null
+++ b/lib/powerpc/asm/memory_areas.h
@@ -0,0 +1,11 @@
+#ifndef MEMORY_AREAS_H
+#define MEMORY_AREAS_H
+
+#define AREA_NORMAL_PFN 0
+#define AREA_NORMAL_NUMBER 0
+#define AREA_NORMAL 1
+
+#define AREA_ANY -1
+#define AREA_ANY_NUMBER 0xff
+
+#endif
diff --git a/lib/ppc64/asm/memory_areas.h b/lib/ppc64/asm/memory_areas.h
new file mode 100644
index 0000000..927baa7
--- /dev/null
+++ b/lib/ppc64/asm/memory_areas.h
@@ -0,0 +1,11 @@
+#ifndef MEMORY_AREAS_H
+#define MEMORY_AREAS_H
+
+#define AREA_NORMAL_PFN 0
+#define AREA_NORMAL_NUMBER 0
+#define AREA_NORMAL 1
+
+#define AREA_ANY -1
+#define AREA_ANY_NUMBER 0xff
+
+#endif
diff --git a/lib/s390x/asm/memory_areas.h b/lib/s390x/asm/memory_areas.h
new file mode 100644
index 0000000..4856a27
--- /dev/null
+++ b/lib/s390x/asm/memory_areas.h
@@ -0,0 +1,17 @@
+#ifndef MEMORY_AREAS_H
+#define MEMORY_AREAS_H
+
+#define AREA_NORMAL_PFN BIT(31-12)
+#define AREA_NORMAL_NUMBER 0
+#define AREA_NORMAL 1
+
+#define AREA_LOW_PFN 0
+#define AREA_LOW_NUMBER 1
+#define AREA_LOW 2
+
+#define AREA_ANY -1
+#define AREA_ANY_NUMBER 0xff
+
+#define AREA_DMA31 AREA_LOW
+
+#endif
diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
new file mode 100644
index 0000000..d704df3
--- /dev/null
+++ b/lib/x86/asm/memory_areas.h
@@ -0,0 +1,22 @@
+#ifndef MEMORY_AREAS_H
+#define MEMORY_AREAS_H
+
+#define AREA_NORMAL_PFN BIT(32-12)
+#define AREA_NORMAL_NUMBER 0
+#define AREA_NORMAL 1
+
+#define AREA_LOW_PFN BIT(24-12)
+#define AREA_LOW_NUMBER 1
+#define AREA_LOW 2
+
+#define AREA_LOWEST_PFN 0
+#define AREA_LOWEST_NUMBER 2
+#define AREA_LOWEST 4
+
+#define AREA_DMA24 AREA_LOWEST
+#define AREA_DMA32 (AREA_LOWEST | AREA_LOW)
+
+#define AREA_ANY -1
+#define AREA_ANY_NUMBER 0xff
+
+#endif
-- 
2.26.2

