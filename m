Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C38071EF65
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 18:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjFAQpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 12:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjFAQps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 12:45:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4414184;
        Thu,  1 Jun 2023 09:45:46 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351GQhsC028271;
        Thu, 1 Jun 2023 16:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3X85rIK3GwcW8RMcgsQfoD26zUR3CyAHqSU+mUVxa0M=;
 b=aOCbETMpCp5BSFr5M9k6KlEgVrNyuIgmvf0o9KRt4KnR/zFZtg5uAQj1ejweIdroN9u8
 52bULehbKrWoa42+gM8tnEAlkt5VgQkdR3Fe79dM9MBmNAvkN8i3gqDu8zqahn7czbJ1
 zpj3hSrnWfD2p+R4GJ5RH2fn6nKsEk2jrC+jkPKCbeZNUTxfs3KzTH3TR/7FvsuuDrAs
 i3G3vWqzUEpdUIc0UEY1L8kn3WvZnoHcdyzCYf6oB/LAgSQoAOKPvH2pe64T7cz7TAOg
 lYBA7tVvMGnLARhuQttRyDr1iZ0FRCRc09kb4GvBZ1sHZpsAFPr+udTPxjFuwQ6F4yPG ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxwfkm7se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:46 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351Gfs5Y005927;
        Thu, 1 Jun 2023 16:45:45 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxwfkm7rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3514beT2028976;
        Thu, 1 Jun 2023 16:45:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qu94e2mua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351GjdZB56689014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 16:45:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E768E20040;
        Thu,  1 Jun 2023 16:45:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DCA620043;
        Thu,  1 Jun 2023 16:45:38 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.12.131])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 16:45:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 0/2] Fixing infinite loop on SCLP READ SCP INFO error
Date:   Thu,  1 Jun 2023 18:45:35 +0200
Message-Id: <20230601164537.31769-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0W43b1WtfnDNhajjrTYL59KB8e2ZVWse
X-Proofpoint-ORIG-GUID: eexUedTY5062swMN2ug56gMlOo-6D2yP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 mlxlogscore=523 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aborting on SCLP READ SCP INFO error leads to a deadloop.

The loop is:
abort() -> exit() -> smp_teardown() -> smp_query_num_cpus() ->
sclp_get_cpu_num() -> assert() -> abort()

Since smp_setup() is done after sclp_read_info() inside setup() this
loop only happens when only the start processor is running.
Let sclp_get_cpu_num() return 1 in this case.

Also provide a bigger buffer for SCLP READ INFO when we have the
extended-length-SCCB facility.

Pierre

Pierre Morel (2):
  s390x: sclp: treat system as single processor when read_info is NULL
  s390x: sclp: Implement extended-length-SCCB facility

 lib/s390x/sclp.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

-- 
2.31.1

since v4:

- changed comments
  (Nico)

- use a big buffer from the start if possible
  (Claudio)

since v3:

- added initial patch and merge with comments
  Sorry for the noise.

since v2:

- use tabs in first patch
  (Nico)

- Added comments

- Added SCLP_RC_INSUFFICIENT_SCCB_LENGTH handling
