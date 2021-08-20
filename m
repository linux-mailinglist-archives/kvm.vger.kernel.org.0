Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB57E3F2B62
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 13:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240010AbhHTLlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 07:41:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232681AbhHTLlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 07:41:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KBb1w7069537;
        Fri, 20 Aug 2021 07:40:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=F9gx7JMmqNO2leRxwhChZ3N09hY9eyO4c/QujyMyquY=;
 b=LKwzYonnaLfdjUKUPdTdN9qJ5+CB0pe1lr54eheri+blUjB2JIbEnr8QhMntdiDElQ09
 ljRisBGK3+bYMXMTN8xDUKTLZlcWMFzHwmKy14xDJYflkf152LCf4bMuitW4mrxgYjJs
 q/aif1J/S4wx29oHdfmQpNXmAplY/8BByPqI4i/JtR96q6kPSTL0Us1EBdX8zJhTsKmG
 dzRZqnGugXDT7O36dEGqagd97szDyWWRUvxlfonfesItYqQv6g9mX2kHRmwKhgn2m74L
 LGOhtTlsG3Ys4V/k0OpRKJWy1vkF3wLLxLrxZHh5/63D4IQqShD2YOKNoc2Nco9Q2BU+ vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ahq8jqrjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:40:36 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17KBbHuv071034;
        Fri, 20 Aug 2021 07:40:35 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ahq8jqrht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 07:40:35 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17KBctVc019393;
        Fri, 20 Aug 2021 11:40:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3ae5f8geuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 11:40:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17KBeVka51904942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 11:40:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B6D1AE0FE;
        Fri, 20 Aug 2021 11:40:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E52A5AE0C9;
        Fri, 20 Aug 2021 11:40:30 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Aug 2021 11:40:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: Cleanup and maintenance
Date:   Fri, 20 Aug 2021 11:39:57 +0000
Message-Id: <20210820114000.166527-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Hw3KZWc2v_5zTKH2Qe9LssQ58xFrNTt-
X-Proofpoint-ORIG-GUID: JppIGlueMRlU-N9CYmwO0I1reZoIzYT1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_03:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=963 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108200062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A bit more cleanup and some extensions before I start adding the PV
SIE support.

https://gitlab.com/frankja/kvm-unit-tests/-/tree/lib_clean_ext

v2:
	* Some of the small patches have been part of the pull and are hence dropped
	* Dropped the bitops patch, I'll add set_bit in the next series
	* Now using BIT_ULL
	* Added comment to decode_pgm_prot() stating we only decode
          the exceptions that are most likely relevant to tests
	* Moved PGM address translation functions to fault.c


Janosch Frank (3):
  lib: s390x: Print addressing related exception information
  s390x: uv-host: Explain why we set up the home space and remove the
    space change
  lib: s390x: Control register constant cleanup

 lib/s390x/asm/arch_def.h | 33 ++++++++---------
 lib/s390x/fault.c        | 76 ++++++++++++++++++++++++++++++++++++++++
 lib/s390x/fault.h        | 44 +++++++++++++++++++++++
 lib/s390x/interrupt.c    | 29 +++++++++++++--
 lib/s390x/smp.c          |  3 +-
 s390x/Makefile           |  1 +
 s390x/skrf.c             |  3 +-
 s390x/uv-host.c          | 11 ++++--
 8 files changed, 177 insertions(+), 23 deletions(-)
 create mode 100644 lib/s390x/fault.c
 create mode 100644 lib/s390x/fault.h

-- 
2.30.2

