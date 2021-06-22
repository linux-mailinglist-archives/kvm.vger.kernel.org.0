Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA543AFF24
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhFVIYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:24:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230419AbhFVIXz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:55 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M84rPG035834;
        Tue, 22 Jun 2021 04:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oz+devSGVPEgUp75BPoF4Yuo++P4Pd3iqxvbll7dtvI=;
 b=p83ZN7R3am5/zF2askEsXbGzl9o1cqsdwGf9Abkd1pTdQAhvMv0OgROQMJFw9C9HzlcI
 kBSR9oxq1QgKdy/bWkrIbgoHnJ9UYEHRsxvb5OWCc5hOJM4n0LNmNfGiTsjapUXby7Fh
 JfwvgU7gQ2BPbTS97OJxPN7l1mji9eBe8WMJ6SqKBPo5vvpQzzpcW0E82Y8UDqjZsVkt
 IAGfGoh6lch007ZeNilWGgB74MN291CSKb4lUYOOSQfEpjjJN80WB73om+vRZ09k1ozX
 /X6VURppHixq2rewEo94IXoZSkYwNF36mA0otSK1+QwhJ3vc6HXfqqeXE3sHv1ZPCon/ fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b8dcp4gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:39 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M85Hch038146;
        Tue, 22 Jun 2021 04:21:39 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b8dcp4g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:39 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8DCrn011269;
        Tue, 22 Jun 2021 08:21:37 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 399878rqgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8LXEi17039646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:21:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E5BBAE058;
        Tue, 22 Jun 2021 08:21:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83593AE04D;
        Tue, 22 Jun 2021 08:21:32 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 05/12] s390x: run: Skip PV tests when tcg is the accelerator
Date:   Tue, 22 Jun 2021 10:20:35 +0200
Message-Id: <20210622082042.13831-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jIhQHs_ZLG6HRMdJI5Ot_095H50Ju5p_
X-Proofpoint-GUID: DhXRlYbi_BBU7A5kg_54cFyX5Bi4RfQ7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TCG doesn't support PV.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/run | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/run b/s390x/run
index 09805044..c615caa1 100755
--- a/s390x/run
+++ b/s390x/run
@@ -15,6 +15,11 @@ ACCEL=$(get_qemu_accelerator) ||
 qemu=$(search_qemu_binary) ||
 	exit $?
 
+if [ "${1: -7}" = ".pv.bin" ] || [ "${TESTNAME: -3}" = "_PV" ] && [ "$ACCEL" = "tcg" ]; then
+	echo "Protected Virtualization isn't supported under TCG"
+	exit 2
+fi
+
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL"
 command="$qemu -nodefaults -nographic $M"
-- 
2.31.1

