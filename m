Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF01D203C68
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgFVQVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:21:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729358AbgFVQVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:21:48 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MG392I111758
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:47 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tyts8n0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:47 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MG3rl9114247
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:47 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tyts8myd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:21:47 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MG0cp5022298;
        Mon, 22 Jun 2020 16:21:44 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 31sa37umsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:21:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGLgZu10682750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:21:42 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D67152052;
        Mon, 22 Jun 2020 16:21:42 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2D65C52050;
        Mon, 22 Jun 2020 16:21:42 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/8] x86: add missing PAGE_ALIGN macro from page.h
Date:   Mon, 22 Jun 2020 18:21:35 +0200
Message-Id: <20200622162141.279716-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622162141.279716-1-imbrenda@linux.ibm.com>
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_09:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxlogscore=981 clxscore=1015 malwarescore=0
 impostorscore=0 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PAGE_ALIGN macro is present in all other page.h headers, including
the generic one.

This patch adds the missing PAGE_ALIGN macro to ib/x86/asm/page.h

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/x86/asm/page.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index 073580a..7e2a3dd 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -19,6 +19,8 @@ typedef unsigned long pgd_t;
 
 #ifndef __ASSEMBLY__
 
+#define PAGE_ALIGN(addr)        ALIGN(addr, PAGE_SIZE)
+
 #ifdef __x86_64__
 #define LARGE_PAGE_SIZE	(512 * PAGE_SIZE)
 #else
-- 
2.26.2

