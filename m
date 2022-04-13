Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC1E4FFA18
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 17:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbiDMP3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 11:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiDMP31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 11:29:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CE460CE3;
        Wed, 13 Apr 2022 08:27:05 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23DDfrA5025994;
        Wed, 13 Apr 2022 15:27:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I0oy/s/LZhoJnhbLzpmA54HgUDSW0x98y/8k/6mPwYM=;
 b=RL7CgzvDyQpQU5ASdKlSd7wCspTGbu6WOFXvKzzeqY8gedLXQ7pFdugWNRUS8bRF77SV
 7x0/axfp7c+8X/DwwGvMKsjc7xplhmWilPuwiDx2YL9tDhuFWs9aonaJqTr5k2xibe1c
 jxM8/5WaEXJIVo7ntGeW/HBG/sVomxW+ie+Oasa4sRu/hcmaB/iqT4azBkoSSZPfYG9Z
 QOlRViSnMkYo+BoJ6ZctfAsZEoxbYT5TRxTt60cGdvtckLJB0ujgUf/PqweJ/EuAGomI
 GzPEB2SQv2eJtGW4vn7nZBelOjhWjAEe+YqfYh/8Ths6BbPL33bSbeGUMVxaNjt3Xexg qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdymfanfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:27:05 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23DEBOiX010664;
        Wed, 13 Apr 2022 15:27:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdymfanet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:27:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23DFHoQ0017832;
        Wed, 13 Apr 2022 15:27:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3fb1dj70cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 15:27:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23DFQxdj33489174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 15:26:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69B734C040;
        Wed, 13 Apr 2022 15:26:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29E414C04A;
        Wed, 13 Apr 2022 15:26:59 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 15:26:59 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/4] s390x: add support for migration tests
Date:   Wed, 13 Apr 2022 17:26:56 +0200
Message-Id: <20220413152658.715003-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220413152658.715003-1-nrb@linux.ibm.com>
References: <20220413152658.715003-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zEsBsC-VGTJRAq8Ctc2qJTNvozQA0rW-
X-Proofpoint-GUID: reX4zq1Laj8fLdIOdZFpJnZ_Y7osSj7x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 adultscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have SCLP console read support, run our tests with migration_cmd, so
we can get migration support on s390x.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/run | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/run b/s390x/run
index 064ecd1b337a..2bcdabbaa14f 100755
--- a/s390x/run
+++ b/s390x/run
@@ -25,7 +25,7 @@ M+=",accel=$ACCEL"
 command="$qemu -nodefaults -nographic $M"
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
 command+=" -kernel"
-command="$(timeout_cmd) $command"
+command="$(migration_cmd) $(timeout_cmd) $command"
 
 # We return the exit code via stdout, not via the QEMU return code
 run_qemu_status $command "$@"
-- 
2.31.1

