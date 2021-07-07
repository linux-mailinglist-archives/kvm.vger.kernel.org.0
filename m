Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7826A3BE965
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhGGOKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:10:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231865AbhGGOKj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:10:39 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167E7GLN100562;
        Wed, 7 Jul 2021 10:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WoZJGI1WH+qGk04nyWXvVnZUJoXFaXJcHp4oU+hLTxc=;
 b=YrkVOdMQBtM0gvZSNWVG+n98z+QUeFMCOvCcM7vCuGRNSkTLfh8N2fNqNtTGN4YAeMyV
 fIkqFI+3HWB+FYr/jHd+3X7oHhIGIkWTJph1n1aLf+ZvbiSWlt82AwjJFsAsmfnhzezd
 fQihQagI7dbQ+YR8VMryewJDYwphmBaigCDMujeSOkPYT7zYCp+U8q4Ba6RJL/XXX2aq
 5pL/vAHQ+XFr0Mc7fA+CSCdhK7DDmBErbyj4Swwc54fYHEb9LPs0iyCYBs2hbfyhwO1T
 RilQh+3NjOs+Hekjv0gWyqTKYi5t0BmrA7nS14mRUQkkd7A5SNOL0mNhEjw1P8FAwuUv Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mk52jdbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:07:58 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167E7wJF102622;
        Wed, 7 Jul 2021 10:07:58 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mk52jc71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:07:46 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167E3OXB016890;
        Wed, 7 Jul 2021 14:03:30 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8ssrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 14:03:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167E1X7m22413714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 14:01:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC646A404D;
        Wed,  7 Jul 2021 14:03:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 351D0A4040;
        Wed,  7 Jul 2021 14:03:27 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.29.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 14:03:27 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 1/8] s390x: snippets: Add gitignore as well as linker script and start assembly
Date:   Wed,  7 Jul 2021 16:03:11 +0200
Message-Id: <20210707140318.44255-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707140318.44255-1-frankja@linux.ibm.com>
References: <20210707140318.44255-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -k3x8jMX--2vt2CV1vKHGl1Lvoj_zu7C
X-Proofpoint-GUID: VlSrsqN8J4fdOoNBKFwSoLbtW--mjOCd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_08:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Snippets are small guests which can be run under a unit test that
implements a simple hypervisor. They can be written in C or
assembly. The C code needs a linker script and a start assembly file
that jumps to main to work properly. So let's add that as well as a
gitignore entry for the new files.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 .gitignore                |  1 +
 s390x/snippets/c/cstart.S | 16 ++++++++++++
 s390x/snippets/c/flat.lds | 51 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)
 create mode 100644 s390x/snippets/c/cstart.S
 create mode 100644 s390x/snippets/c/flat.lds

diff --git a/.gitignore b/.gitignore
index 8534fb74..b3cf2cbd 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,3 +23,4 @@ cscope.*
 /api/dirty-log
 /api/dirty-log-perf
 /s390x/*.bin
+/s390x/snippets/*/*.gbin
diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
new file mode 100644
index 00000000..242568d6
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
index 00000000..ce3bfd69
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
2.31.1

