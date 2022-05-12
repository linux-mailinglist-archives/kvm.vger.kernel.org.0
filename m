Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F638524E83
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 15:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354555AbiELNmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 09:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354533AbiELNmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 09:42:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1626162CD1;
        Thu, 12 May 2022 06:42:41 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CC1rYL003778;
        Thu, 12 May 2022 13:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rEZOKojTTThAvghjjgKfvYBgH3Aqz+CoBHgXPZ3iK4E=;
 b=e3kY1zYQ9lWBmpMDF4yByQz4oe4jN/4jTk8CcdInGrGe93gmWrj/RLuekb3u9HMXzpot
 Rp2Flbky3kQJjcD4skUsSyhl3FIvKH8p0Qs0Z/dlYUqOpLen9Ha62WULxkRqnQViRE/C
 eisGQJ0WOqLPHMH/AgazIS+D8+Dc+VzNVNVNbBrotVkMlb40pJZpBpEusM02lmzFwAPl
 bo6Btterge/GA01mw45g1XhtvR5eDlv1fi88JphSrgSlLMyE42+7aNjhe2WxXfOrLFA0
 i9PZ8g8KdPRQQOLjRIx16YT/lcESGeYxnhwUvVrcASbo2o5OcmWmQC9CpOOL7+xtGYWF xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g11vr2h4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:42:40 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CDZeVO012104;
        Thu, 12 May 2022 13:42:40 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g11vr2h3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:42:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CDdFPj029006;
        Thu, 12 May 2022 13:42:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8y4c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:42:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CDgYMU48038394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 13:42:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C9154C046;
        Thu, 12 May 2022 13:42:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E011A4C040;
        Thu, 12 May 2022 13:42:33 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 13:42:33 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] s390x: add migration test for CMM
Date:   Thu, 12 May 2022 15:42:31 +0200
Message-Id: <20220512134233.1416490-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ypP94GmM5S4Lbx_QBH3yEH8afEt19T-W
X-Proofpoint-ORIG-GUID: tsBL3JkZRAMDBy4MfJXLK3ElXGJ3xXuo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_10,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 impostorscore=0
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 mlxlogscore=890 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205120065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2->v3:
---
* remove unneeded include asm-offsets.h (Thanks Claudio)
* change prefix of test to match filename (migration-cmm instead of
  cmm-migration)

v1->v2:
---
* Rename cmm-migration.c to migration-cmm.c (Thanks Janosch)
* Replace switch-case with unrolled loop (Thanks Claudio)
* Migrate even when ESSA is not available so we don't hang forever

Upon migration, we expect the CMM page states to be preserved. Add a test which
checks for that.

The new test gets a new file so the existing cmm test can still run when the
prerequisites for running migration tests aren't given (netcat). Therefore, move
some definitions to a common header to be able to re-use them.

Nico Boehr (2):
  lib: s390x: add header for CMM related defines
  s390x: add cmm migration test

 lib/s390x/asm/cmm.h   | 50 ++++++++++++++++++++++++++++
 s390x/Makefile        |  1 +
 s390x/cmm.c           | 25 ++------------
 s390x/migration-cmm.c | 77 +++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg   |  4 +++
 5 files changed, 135 insertions(+), 22 deletions(-)
 create mode 100644 lib/s390x/asm/cmm.h
 create mode 100644 s390x/migration-cmm.c

-- 
2.31.1

