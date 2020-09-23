Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407EB275910
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 15:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIWNsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 09:48:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726504AbgIWNsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 09:48:15 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NDjpCQ072552;
        Wed, 23 Sep 2020 09:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HKrkWBEuFGWFXMFgwqcloq7fR6fgdbqjq9vYv+wKCdo=;
 b=io1gICMEW4/EWwKqHx45VNcDQ/Z0b0AddPMrglGMdwzr/sr+Kl3saO5kdJ5sG1G3M497
 A+fc4m7Ty07A4r4GrnqTlseQPJGcNQ49Lt74YswPqhG54Nhp5omX8tD5dxAz9JzPGSHd
 s2CfZp7iVrDNglIaI2WEjtvC03s8HCdyeai/s6O8UiG4wKxOSH19MLs6ZDs+w+Ur1oiC
 zPhBUofVBh8sBV5a6luk66UNg1bGdAMFAV3tWVrEb4QdokqcyC/qbcCf9ymzgSbGopEi
 n5uzSFpj4UeAtLHYrplJ34GXN6yexZ60tDEzphP7fmFxsm/j/tvVXvVOqBBK7WlYst7+ xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r7hk817a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08NDlnCI076303;
        Wed, 23 Sep 2020 09:48:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r7hk816v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:13 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08NDkjtU025166;
        Wed, 23 Sep 2020 13:48:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 33n9m8c732-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 13:48:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08NDm9HH27197832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 13:48:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 406C74C059;
        Wed, 23 Sep 2020 13:48:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D79194C044;
        Wed, 23 Sep 2020 13:48:08 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.64.218])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 13:48:08 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH kvm-unit-tests v2 3/4] run_tests/mkstandalone: add arch_cmd hook
Date:   Wed, 23 Sep 2020 15:47:57 +0200
Message-Id: <20200923134758.19354-4-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923134758.19354-1-mhartmay@linux.ibm.com>
References: <20200923134758.19354-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_09:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=981 spamscore=0
 suspectscore=13 adultscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows us, for example, to auto generate a new test case based on
an existing test case.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 scripts/common.bash | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index c7acdf14a835..a6044b7c6c35 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -19,7 +19,7 @@ function for_each_unittest()
 	while read -r -u $fd line; do
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			if [ -n "${testname}" ]; then
-				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 			fi
 			testname=${BASH_REMATCH[1]}
 			smp=1
@@ -49,11 +49,16 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 	fi
 	exec {fd}<&-
 }
 
+function arch_cmd()
+{
+	[ "${ARCH_CMD}" ] && echo "${ARCH_CMD}"
+}
+
 # The current file has to be the only file sourcing the arch helper
 # file
 ARCH_FUNC=scripts/${ARCH}/func.bash
-- 
2.25.4

