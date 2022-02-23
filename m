Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492344C1421
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240915AbiBWNaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiBWNaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:30:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0B2AA2C6;
        Wed, 23 Feb 2022 05:29:47 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NDPY9e018873;
        Wed, 23 Feb 2022 13:29:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=SitxeyJ8Yteq62L62kk5e07lQyXO4FAypunUXGWS8OM=;
 b=cefLE5iHcuvnNdZ5kIWN1cMSOH234WiY1rocPmAkSRSdmZQwsFiczSuXo1Ud37Ah5Pk5
 iWZ6pV7v9A1xydJfH/H87N5gmT5DCHop2LaBbDuQoPhZmmCIDmpsPsM1hWlnCOcDXSfD
 9txtVxzYDx8xwcHMGdsd5Jy1SWwFdf3xvoln+UfEhwSj0Z4TI0g+CS+YOlue1NeBYv6m
 zPtyDsFECszumsj6kyDYeloCipLBY7rwuPKtpjL7ERdUPK8rIua7mv+q03EnaclOJAAe
 2t6jMsgOhMhOHdUQNnnkTlT1f+6DTrDCCeOO3jKr8Qin9Zx6wrPByjeFoQElargZ168z tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edk21bnre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:46 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NBuOTM012463;
        Wed, 23 Feb 2022 13:29:46 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edk21bnqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NDOYnP025381;
        Wed, 23 Feb 2022 13:29:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ear69a8t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NDJ1X352494780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 13:19:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0C54A4040;
        Wed, 23 Feb 2022 13:29:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5B03A405B;
        Wed, 23 Feb 2022 13:29:40 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 13:29:40 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/8] s390x: Extend instruction interception tests
Date:   Wed, 23 Feb 2022 14:29:32 +0100
Message-Id: <20220223132940.2765217-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WtcPKNvI21QxTKAWfPQCZqtoovFhBNz8
X-Proofpoint-GUID: ShDvJ62Fr4zDSnXnh4M1ndJL0eGvNMoA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_05,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=966 phishscore=0 adultscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series extends the instruction interception tests for s390x.

For most instructions, there is already coverage in existing tests, but they are
not covering some failure cases, e.g. bad alignment. In this case, the existing
tests were extended.

SCK was not under test anywhere yet, hence a new test file was added.

The EPSW test gets it's own file, too, because it requires a I/O device, more
details in the respective commit. 

Changelog from v2:
----
- Don't run the sck test under PV
- Include commit of the QEMU PMCW fix in the MSCH and STSCH commit messages

Nico Boehr (8):
  s390x: Add more tests for MSCH
  s390x: Add test for PFMF low-address protection
  s390x: Add sck tests
  s390x: Add tests for STCRW
  s390x: Add more tests for SSCH
  s390x: Add more tests for STSCH
  s390x: Add tests for TSCH
  s390x: Add EPSW test

 lib/s390x/css.h     |  17 +++
 lib/s390x/css_lib.c |  60 ++++++++++
 s390x/Makefile      |   2 +
 s390x/css.c         | 278 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/epsw.c        | 113 ++++++++++++++++++
 s390x/pfmf.c        |  29 +++++
 s390x/sck.c         | 134 +++++++++++++++++++++
 s390x/unittests.cfg |   7 ++
 8 files changed, 640 insertions(+)
 create mode 100644 s390x/epsw.c
 create mode 100644 s390x/sck.c

-- 
2.31.1

