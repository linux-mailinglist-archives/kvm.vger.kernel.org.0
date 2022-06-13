Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA7454846D
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 12:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiFMKPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 06:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241525AbiFMKPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 06:15:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0A5DEAE;
        Mon, 13 Jun 2022 03:14:45 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25D9KffA029522;
        Mon, 13 Jun 2022 10:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=XTyGs/7NSHWhg+0Nlue6vSaUHZcSVrzR6SpXdv+g6LY=;
 b=rfZjNhN9wXKqkvNqEg4cT47Q8EdHkLI3Dlmz5axRsLnBfDSGT4pmPWSgfQw8MnSue++S
 6bDyBdTH9mzSpGNZeJZxPXecN1+EgHHieIhbcQxNeUW6drjpbyWUlgh8gJ5iQ2rjwo9D
 iXbpQO7im9bUj7vDdIeUCq8Hh3xtywvX8f5NVwM59k5lk6995vLraSXYwo7cnOW1x/ii
 ehJm0sFiPfH7/e3FVr3wFmGfI+XlMO8smULKn7fIH6BHITv+/UusdLMFw+Us2xrcT8rS
 x9VqxXIQogJSXa2FwwMk+WlaolFI1Fydaf3EeOXFIdZNEaPIFhRuFb/2kDnHX47gLmu1 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gn5484tdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 10:14:45 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25D9sMTP028047;
        Mon, 13 Jun 2022 10:14:44 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gn5484tdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 10:14:44 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25DACwT2009185;
        Mon, 13 Jun 2022 10:14:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3gmjp92jh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 10:14:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25DAEdWc21102886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 10:14:39 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94B2352054;
        Mon, 13 Jun 2022 10:14:39 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4B04352051;
        Mon, 13 Jun 2022 10:14:39 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 0/1] s390x: add migration test for storage keys
Date:   Mon, 13 Jun 2022 12:14:38 +0200
Message-Id: <20220613101439.557174-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -GS2ALAX4s5OYxZwwqalUmi8crBKq05o
X-Proofpoint-ORIG-GUID: V9YLiWvJiZPI-nB6fnYdCwkj9Iq22TkL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_03,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=986 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4->v5:
----
* don't print message on every skey tested (thanks Janosch)
* extend some comments (Thanks Janosch)

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
 s390x/migration-skey.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 +++
 3 files changed, 83 insertions(+)
 create mode 100644 s390x/migration-skey.c

-- 
2.36.1

