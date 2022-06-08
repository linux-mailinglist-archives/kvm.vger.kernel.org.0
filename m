Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02214543124
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiFHNNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbiFHNNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:13:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9291320E6E3;
        Wed,  8 Jun 2022 06:13:35 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258DDXcj014455;
        Wed, 8 Jun 2022 13:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=xqsjQTzjcEHWmpRhL6xXQGtu9VxdjrghwE4bl9yjVOw=;
 b=X2s4+n097LtVn1M88liRMQklM+fBaG5kX5pgqfW5V9mQBfIlouB8qlV7XPSUo4a/yoze
 51mty126letAShwHtjeEadnwSrWbtOhmQzXqW3Pd71vMD3+5cpExswVM3XHodMX0rgEc
 BEOGDx7KS4eQMsXq0yDhVDRPMpQY0oTFx+LwuBRSgBP+4jHYgzWEp1gkGEaHCKyPM8RV
 WNWMF+DloGl1FUMRVA99NkRL3ze0e8m0J6BFH1gPtjy9gPoxZuQWVoxqqwxRVIbTsFit
 WtTctcA9zRyMPuAtk75jL4XQrKZm6PXk/kXS4HXIR60rJMD7AiEEGtUJ2CxM85oBkGXl tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjvf68028-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:13:35 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258DDYrw014481;
        Wed, 8 Jun 2022 13:13:34 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjvf6801h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:13:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258D6Jcx008309;
        Wed, 8 Jun 2022 13:13:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnhwac2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:13:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258DDVuu24576424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 13:13:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 093DC5204F;
        Wed,  8 Jun 2022 13:13:29 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BFD425204E;
        Wed,  8 Jun 2022 13:13:28 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 0/1] s390x: add migration test for storage keys
Date:   Wed,  8 Jun 2022 15:13:27 +0200
Message-Id: <20220608131328.6519-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C_qw6XrKNKQCHGLnqedJDpi1oyBJIxJ9
X-Proofpoint-ORIG-GUID: NAAZPDNAYn_k3EdknQ1F9UndWSooooRY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=880 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3->v4:
----
* remove useless goto (Thanks Thomas)

v2->v3:
----
* remove some useless variables, style suggestions, improve commit description
  (thanks Janis)
* reverse christmas tree (thanks Claudio)

v1->v2:
----
* As per discussion with Janis and Claudio, remove the actual access check from
  the test. This also allows us to remove the check_pgm_int_code_xfail() patch.
* Typos/Style suggestions (thanks Janis)

Upon migration, we expect storage keys set by the guest to be preserved,
so add a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
they can be read back.

Nico Boehr (1):
  s390x: add migration test for storage keys

 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 73 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 +++
 3 files changed, 78 insertions(+)
 create mode 100644 s390x/migration-skey.c

-- 
2.36.1

