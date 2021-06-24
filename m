Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1091A3B2E7A
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhFXMEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:04:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhFXME3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 08:04:29 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OBmCc7099014;
        Thu, 24 Jun 2021 08:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xF34/s8kmBCR4ag7lSiyu9g6Ui/uwU6UblJdMm+FZXE=;
 b=Qc+EMGSqdDBPUO5xitsnz+H3sAPoVVFg6FC39QNRFSR+1PFiDHIKBFqc05Nox0iEserR
 WtjAEiBo+vTr4S92X/dgXH/xl2Q9elDcOHdaXUZBdtY3B2LR2+lkTquQHEwF/7tdvSZD
 +uYOXnoGhiFOLfRf7oBIh4aPw3OQ6I5IW4eFpacFjfbZIQ8FwJ9TQxdHHkuEFRIxomWE
 KszY3Se+y0pbHY+zpqwnkmavNoui+vr6gNRdA/XQPvxEyuII4DYSn836qEre2pQsHtx1
 QeQ/3IWUWE/v3YKnnsW1YTsnmOy5eU+h4OPqOrImyBRyaZpvD8F+eI3fbMb66DRNB0EI Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39csge8fgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 08:02:09 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15OBn60t101313;
        Thu, 24 Jun 2021 08:02:09 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39csge8ff3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 08:02:09 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15OC26Bb020733;
        Thu, 24 Jun 2021 12:02:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3997uhhdde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 12:02:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15OC23Pj13697392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 12:02:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0D67AE068;
        Thu, 24 Jun 2021 12:02:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B482AE064;
        Thu, 24 Jun 2021 12:02:03 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 12:02:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        seiden@linux.ibm.com
Subject: [PATCH 1/3] s390x: snippets: Add gitignore as well as linker script and start assembly
Date:   Thu, 24 Jun 2021 12:01:50 +0000
Message-Id: <20210624120152.344009-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210624120152.344009-1-frankja@linux.ibm.com>
References: <20210624120152.344009-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cfIPkzSKIXbgiX3W83Z5TYGpHYJUyP-C
X-Proofpoint-GUID: _ankxE21hmnrmY01Y78dQy3vdhX05fVK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_11:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240062
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
 s390x/snippets/c/cstart.S | 15 ++++++++++++
 s390x/snippets/c/flat.lds | 51 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)
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
index 0000000..d7f6525
--- /dev/null
+++ b/s390x/snippets/c/cstart.S
@@ -0,0 +1,15 @@
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
+	brasl	%r14, main
+	/* For now let's only use cpu 0 in snippets so this will always work. */
+	xgr	%r0, %r0
+	sigp    %r2, %r0, SIGP_STOP
diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
new file mode 100644
index 0000000..5e70732
--- /dev/null
+++ b/s390x/snippets/c/flat.lds
@@ -0,0 +1,51 @@
+SECTIONS
+{
+	.lowcore : {
+		/*
+		 * Initial short psw for disk boot, with 31 bit addressing for
+		 * non z/Arch environment compatibility and the instruction
+		 * address 0x10000 (cstart64.S .init).
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
2.27.0

