Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702343BD69F
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhGFMl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:41:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55816 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241538AbhGFMUr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:20:47 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166C9HmY194620;
        Tue, 6 Jul 2021 08:18:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2sg6cU1z0ZZtwBi4r6u+qOT0Hll+XoyJ57Awdhl5O8I=;
 b=tHz8CL4/mJZTexC4WjEqXKg7VFKlQisXV8mluQxmSAz+U+Ol+9yR6CpWXFF9D/HVv2Wv
 QNw5vTfl1eQQQx7lFZ7a2x7mArmRkTRDPVKLaJ2Gz9R9vSCzapgqG/ulkR8uXdpEUrdo
 6WHhCBPHCqFZqxfF86Siq30un3pEDwPswqYNFjRMnOz//pBEQcEhMt/BDZ279pqScl+c
 e2nRrV2T6iJwn3i36V4NGny8CPsDlFNYeZ4ET1PVtV0UEogD1Eb1+MW4jSnbEF9tW9E1
 YXfbK7YfniEOD0OoXg6PeyMuLzeOYBIlJ+j8J3g39K+maP2RtWEyIdIQc9ejWFtAlfge wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m5q1r99v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:08 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166C9lAb196463;
        Tue, 6 Jul 2021 08:18:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m5q1r98h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:08 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166C2imK003604;
        Tue, 6 Jul 2021 12:18:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8s863-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 12:18:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166CI3xw31916434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 12:18:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6845242054;
        Tue,  6 Jul 2021 12:18:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17B2542070;
        Tue,  6 Jul 2021 12:18:03 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 12:18:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/5] s390x: sie and uv cleanups
Date:   Tue,  6 Jul 2021 12:17:52 +0000
Message-Id: <20210706121757.24070-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2lM2rv8YFqP7hJ79fzAOAtFLWTmQxMb7
X-Proofpoint-GUID: UgKYYVDmyUSI45gQoKDlqVcjkvF-feEE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 mlxlogscore=641 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV and SIE additions brought in some minor problems which I want
to address now.

v2:
	* Dropped UV int type patch
	* Fixed uv_query reserved field name
	* Fixed sie info print if
	* Added patch to remove an old print in the pgm handler

Janosch Frank (5):
  s390x: sie: Add missing includes
  s390x: sie: Fix sie.h integer types
  lib: s390x: uv: Add offset comments to uv_query and extend it
  lib: s390x: Print if a pgm happened while in SIE
  lib: s390x: Remove left behing PGM report

 lib/s390x/asm/uv.h    | 33 +++++++++++++++++----------------
 lib/s390x/interrupt.c | 14 ++++++++------
 lib/s390x/sie.h       | 11 +++++++----
 3 files changed, 32 insertions(+), 26 deletions(-)

-- 
2.30.2

