Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56433E51F2
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505784AbfJYRGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 13:06:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409760AbfJYRGm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 13:06:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PH4U1x123038
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 13:06:42 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vv3ck42cv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 13:06:41 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 25 Oct 2019 18:06:40 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 18:06:37 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PH6aC329687864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 17:06:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA9FBA404D;
        Fri, 25 Oct 2019 17:06:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3722A4057;
        Fri, 25 Oct 2019 17:06:35 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 17:06:35 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/5] s390x: improve error reporting for interrupts
Date:   Fri, 25 Oct 2019 19:06:31 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102517-0016-0000-0000-000002BD9B81
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102517-0017-0000-0000-0000331EE65C
Message-Id: <1572023194-14370-3-git-send-email-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=789 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve error reporting for unexpected external interrupts to also
print the received external interrupt code.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 lib/s390x/interrupt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 5cade23..1636207 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -118,8 +118,8 @@ void handle_ext_int(void)
 {
 	if (!ext_int_expected &&
 	    lc->ext_int_code != EXT_IRQ_SERVICE_SIG) {
-		report_abort("Unexpected external call interrupt: at %#lx",
-			     lc->ext_old_psw.addr);
+		report_abort("Unexpected external call interrupt (code %#x): at %#lx",
+			     lc->ext_int_code, lc->ext_old_psw.addr);
 		return;
 	}
 
-- 
2.7.4

