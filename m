Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839F5414279
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhIVHUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:20:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50208 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233213AbhIVHUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 03:20:35 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M7BrJM003569;
        Wed, 22 Sep 2021 03:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=jO8ssjq+UvAvLsG43IFB0V9U7ELuVYNM7B4IiWciIxY=;
 b=mTovaeMcIXgivEzi52ol99X4LfKOo2ppHjg3w50nIHnJlaEYziboJd6SmrIklAve0YKu
 ItX7Csv8d/UJtJTwGdph6rJV1ZPmDOppizxuRGR0ZsMB9rnBwA4SeYbYq41DiJINmA2v
 pGcSGsl3U/GBxKbc0aT16qqTFPrLvv7a/hKMXSCWwdyC0M3axV8TkR9SAVevoyL8q2QI
 KOfE2zB/33cdBlXG5uRrldKKGAYzzjcOd/UdVLTOpV/NSrEpNOExsLGqvPOduSdVz1im
 kgEHOrX86uhea0qgujlUpQc28ictpvKDh2a6QpLP6F7yPikBlpt0ShmThuHAqzAJavPn aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yvn04a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:18:59 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M7DGZ7007462;
        Wed, 22 Sep 2021 03:18:59 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yvn049k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 03:18:59 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M78nG9024867;
        Wed, 22 Sep 2021 07:18:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3b7q66bayy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 07:18:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M7IrkZ43909422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 07:18:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20B24A4065;
        Wed, 22 Sep 2021 07:18:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48B9EA4051;
        Wed, 22 Sep 2021 07:18:52 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 07:18:52 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, linux-s390@vger.kernel.org,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/9] s390x: Cleanup and maintenance 2
Date:   Wed, 22 Sep 2021 07:18:02 +0000
Message-Id: <20210922071811.1913-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U4DyV9lhPys_ZS7rC0LhTqVhV-mW7WX8
X-Proofpoint-ORIG-GUID: CpxCsexd4LHFdWxqUIx1uSjUeCEweyms
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_02,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here are a few more fixes and cleanups that improve readability and
architectural compliance.

Janosch Frank (9):
  s390x: uv: Tolerate 0x100 query return code
  s390x: pfmf: Fix 1MB handling
  s390x: uv-host: Fence a destroy cpu test on z15
  lib: s390x: uv: Fix share return value and print
  lib: s390x: uv: Add UVC_ERR_DEBUG switch
  lib: s390x: Print PGM code as hex
  s390x: Makefile: Remove snippet flatlib linking
  s390x: Add sthyi cc==0 r2+1 verification
  s390x: skrf: Fix tprot assembly

 lib/s390x/asm/arch_def.h | 14 ++++++++++++++
 lib/s390x/asm/uv.h       | 21 +++++++++++++--------
 lib/s390x/interrupt.c    |  2 +-
 s390x/Makefile           |  2 +-
 s390x/pfmf.c             | 10 ++++++++--
 s390x/skrf.c             |  2 +-
 s390x/sthyi.c            | 20 +++++++++++---------
 s390x/uv-guest.c         |  4 ++--
 s390x/uv-host.c          | 13 ++++++++-----
 9 files changed, 59 insertions(+), 29 deletions(-)

-- 
2.30.2

