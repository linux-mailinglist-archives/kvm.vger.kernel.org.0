Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66199524F28
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 16:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354920AbiELOBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 10:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354891AbiELOBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 10:01:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890033DDD8;
        Thu, 12 May 2022 07:01:15 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CDBlAj020236;
        Thu, 12 May 2022 14:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=4ohBjU0YdSFHrqWbp3z8Begh0IDivFt3spk1KvQBnsg=;
 b=jIKMymZVKWltgEJUPOSu9wdZiO9+6nGiC8W+httSTRMr9sV0kWBegUlIHLCr7kwWpzdi
 J4GCZJXp8biAXb3AS9+q/qBHdxZ4yeXffcODRS+QCp70kgl8GhywiVVpGfpL17Dx2ksP
 Gc7TEpylYpHbfgyrmk0qWZaI7yKa7fOyfgrBOpc+U8Gl7Cb5DbJlTTH240Tf8xmfhBdW
 qgYTBJqdKDTweW89/08pHcLn8Yo/cw8wyhDb3wb3eZfX1CSHfIf05R4C8TAWIgYdPDGa
 W1bnSTDtSE03iba/SDIUNWBH2RKiLltFLot3sgFNAUjWer8roNwgR7w5StYK4NanN4t7 Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g12wj1buc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:01:15 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CDDBGv024194;
        Thu, 12 May 2022 14:01:14 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g12wj1brb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:01:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CDx3oI014757;
        Thu, 12 May 2022 14:01:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8y570-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 14:01:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CE17Um50069910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 14:01:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7A2FA4062;
        Thu, 12 May 2022 14:01:07 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AA8FA405F;
        Thu, 12 May 2022 14:01:07 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 14:01:07 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 0/2] s390x: add migration test for storage keys
Date:   Thu, 12 May 2022 16:01:05 +0200
Message-Id: <20220512140107.1432019-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: z7lBr2QVcwp-c9sr_u6cTeFj9nvWhEmC
X-Proofpoint-GUID: OUTHt1a3uClQnuUV1ntvBujyPMfbJiQ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_10,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=503 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upon migration, we expect storage keys being set by the guest to be preserved,
so add a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
they can be read back and the respective access restrictions are in place when
the access key in the PSW doesn't match.

TCG currently doesn't implement key-controlled protection, hence add the
relevant tests as xfails. To this end, a check_pgm_int_xfail() is useful, which
is also added in this series.

Nico Boehr (2):
  lib: s390x: introduce check_pgm_int_code_xfail()
  s390x: add migration test for storage keys

 lib/s390x/asm/interrupt.h |  1 +
 lib/s390x/interrupt.c     |  9 +++-
 s390x/Makefile            |  1 +
 s390x/migration-skey.c    | 98 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg       |  4 ++
 5 files changed, 111 insertions(+), 2 deletions(-)
 create mode 100644 s390x/migration-skey.c

-- 
2.31.1

