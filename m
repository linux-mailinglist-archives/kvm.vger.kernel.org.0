Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541033B7315
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhF2NVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:21:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47668 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233056AbhF2NVa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:21:30 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TD47j9121693;
        Tue, 29 Jun 2021 09:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ehRmju4XQmQixIY4yGvA3orR93G4jBQpLgsf1WMVBbY=;
 b=lKJCCLRsDSPCGsURFjiOJ0phYjDvR6vgFV1AHA1xywVTeIg7CCVqKSQYni6EI7RfDKau
 34si62HPQVxzp6Y3wC+zRFLFv5Ws8JfuPUWvZjrnhn5TL6UMEHCvCXDC5Qni72IvRIJ2
 N34cUm0X4o26f3GZmz5SybzYfYoqRunIbK8MckdR7tDqmqFGoI8yNa8iIy6EkJLggLsU
 Fl3MIHixKgQJS3Mle+/9zpN+CI4OGu3SxCQTw7boBMmXJYUtPM7sj1xC0wwNjjZcTpOm
 LCqUTFS6S83I16ntAiGJRVDVAkMaUQJDNdxxi+nhH1m+CLOZYQGKTGQN3nKyw2963hsJ tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g19cwagt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:19:03 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TD49vH121998;
        Tue, 29 Jun 2021 09:19:02 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g19cwafx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:19:02 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDEmel025420;
        Tue, 29 Jun 2021 13:19:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 39duv8gp8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:19:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDIwka34013600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:18:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05B724C052;
        Tue, 29 Jun 2021 13:18:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE08A4C06A;
        Tue, 29 Jun 2021 13:18:57 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:18:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/3] s390x: snippets: Add gitignore as well as linker script and start assembly
Date:   Tue, 29 Jun 2021 13:18:39 +0000
Message-Id: <20210629131841.17319-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629131841.17319-1-frankja@linux.ibm.com>
References: <20210629131841.17319-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WfHCeWfoXZROnkxl45P0N0OehNH65CJz
X-Proofpoint-ORIG-GUID: 9FEEU6TeBBfY1hFoFtDY7k9H2CuQlcbs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0
 impostorscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Snippets are small guests That can be run under a unit test as the
hypervisor. They can be written in C or assembly. The C code needs a
linker script and a start assembly file that jumps to main to work
properly. So let's add that as well as a gitignore entry for the new
files.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 .gitignore                |  1 +
 s390x/snippets/c/cstart.S | 16 ++++++++++++
 s390x/snippets/c/flat.lds | 51 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)
 create mode 100644 s390x/snippets/c/cstart.S
 create mode 100644 s390x/snippets/c/flat.lds

diff --git a/.gitignore b/.gitignore
index 8534fb7..b3cf2cb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,3 +23,4 @@ cscope.*
 /api/dirty-log
 /api/dirty-log-perf
 /s390x/*.bin
+/s390x/snippets/*/*.gbin
diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
new file mode 100644
index 0000000..242568d
--- /dev/null
+++ b/s390x/snippets/c/cstart.S
@@ -0,0 +1,16 @@
+#include <asm/sigp.h>
+
+.section .init
+	.globl start
+start:
+	/* XOR all registers with themselves to clear them fully. */
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	xgr \i,\i
+	.endr
+	/* 0x3000 is the stack page for now */
+	lghi	%r15, 0x4000 - 160
+	sam64
+	brasl	%r14, main
+	/* For now let's only use cpu 0 in snippets so this will always work. */
+	xgr	%r0, %r0
+	sigp    %r2, %r0, SIGP_STOP
diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
new file mode 100644
index 0000000..ce3bfd6
--- /dev/null
+++ b/s390x/snippets/c/flat.lds
@@ -0,0 +1,51 @@
+SECTIONS
+{
+	.lowcore : {
+		/*
+		 * Initial short psw for disk boot, with 31 bit addressing for
+		 * non z/Arch environment compatibility and the instruction
+		 * address 0x4000 (cstart.S .init).
+		 */
+		. = 0;
+		 LONG(0x00080000)
+		 LONG(0x80004000)
+		 /* Restart new PSW for booting via PSW restart. */
+		 . = 0x1a0;
+		 QUAD(0x0000000180000000)
+		 QUAD(0x0000000000004000)
+	}
+	. = 0x4000;
+	.text : {
+		*(.init)
+		*(.text)
+		*(.text.*)
+	}
+	. = ALIGN(64K);
+	etext = .;
+	.opd : { *(.opd) }
+	. = ALIGN(16);
+	.dynamic : {
+		dynamic_start = .;
+		*(.dynamic)
+	}
+	.dynsym : {
+		dynsym_start = .;
+		*(.dynsym)
+	}
+	.rela.dyn : { *(.rela*) }
+	. = ALIGN(16);
+	.data : {
+		*(.data)
+		*(.data.rel*)
+	}
+	. = ALIGN(16);
+	.rodata : { *(.rodata) *(.rodata.*) }
+	. = ALIGN(16);
+	__bss_start = .;
+	.bss : { *(.bss) }
+	__bss_end = .;
+	. = ALIGN(64K);
+	edata = .;
+	. += 64K;
+	. = ALIGN(64K);
+}
-- 
2.30.2

