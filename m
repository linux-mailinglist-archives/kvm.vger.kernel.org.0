Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB56C3ED6DB
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbhHPNYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:24:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64642 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239278AbhHPNVu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:50 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD5n64057374;
        Mon, 16 Aug 2021 09:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wZYY9x2WtEEy89PBMzJUuH/YuOKcBMfES8hiomFRLwk=;
 b=Er0wtLKou8m6v7fyRu596x1YRpqmVwOtq0xiVx+bDl+3mJvLhsXyM04AFElFP+LjL4EG
 498RWyIRClCMFJw1vT+M6jIyXY5S7fbyg6ClL9sZ5mue3LNXVuZVAOgIx3lacFBiKaXv
 n9NmuiWcWCgfWDyujLETKGaWU+tnX1S0TTKtxRCV+pOjFnl2kGnD3dhq/NzsiBJwMDUo
 uvoUisNnLR23pm8OKYOdgY8C6gCRO0rICxdIQlxl9lGiuhOTsQ/HSGvi7orlvYHd8Pum
 BchVLH/f7MMDb233BIEVKgxHbXVY5utSEpdqff2FT+2F8O1tq/kNpV6W8X8c8dJlVtBn Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeud8ffvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:18 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD7b81065952;
        Mon, 16 Aug 2021 09:21:17 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeud8ffuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:17 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDCvEZ020414;
        Mon, 16 Aug 2021 13:21:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8b9yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDLCIn54657296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:21:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 358B911C050;
        Mon, 16 Aug 2021 13:21:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A1A511C05C;
        Mon, 16 Aug 2021 13:21:11 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 05/11] s390x: lib: Introduce HPAGE_* constants
Date:   Mon, 16 Aug 2021 15:20:48 +0200
Message-Id: <20210816132054.60078-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5ujdLupgYXTpkcJEDeNV3eqQ4M4E-_vY
X-Proofpoint-ORIG-GUID: 0JM_QyyvgssOxtXdEffgRCJF6gvY1rV6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They come in handy when working with 1MB blocks/addresses.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/page.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/s390x/asm/page.h b/lib/s390x/asm/page.h
index f130f936..2f4afd06 100644
--- a/lib/s390x/asm/page.h
+++ b/lib/s390x/asm/page.h
@@ -35,4 +35,8 @@ typedef struct { pteval_t pte; } pte_t;
 #define __pmd(x)	((pmd_t) { (x) } )
 #define __pte(x)	((pte_t) { (x) } )
 
+#define HPAGE_SHIFT		20
+#define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
+#define HPAGE_MASK		(~(HPAGE_SIZE-1))
+
 #endif
-- 
2.31.1

