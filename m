Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B422ACC6
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 12:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgGWKnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 06:43:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726675AbgGWKnB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 06:43:01 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NAW0wt065837;
        Thu, 23 Jul 2020 06:42:33 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32e1vsu8kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 06:42:33 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06NAYqYw075228;
        Thu, 23 Jul 2020 06:42:32 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32e1vsu8jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 06:42:32 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06NAf8jU021419;
        Thu, 23 Jul 2020 10:42:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 32dbmn1wrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 10:42:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06NAgQUu47120514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 10:42:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43EA411C04A;
        Thu, 23 Jul 2020 10:42:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8CC611C058;
        Thu, 23 Jul 2020 10:42:22 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.40.160])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jul 2020 10:42:22 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     mpe@ellerman.id.au, paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mikey@neuling.org, npiggin@gmail.com,
        pbonzini@redhat.com, christophe.leroy@c-s.fr, jniethe5@gmail.com,
        pedromfc@br.ibm.com, rogealve@br.ibm.com, cohuck@redhat.com,
        mst@redhat.com, clg@kaod.org, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH 0/2] ppc: Enable 2nd DAWR support on p10
Date:   Thu, 23 Jul 2020 16:12:18 +0530
Message-Id: <20200723104220.314671-1-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_03:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=714 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables 2nd DAWR support on p10 qemu/kvm guest. This
series depends on kernel patches:
https://lore.kernel.org/linuxppc-dev/20200723102058.312282-1-ravi.bangoria@linux.ibm.com

Patches apply fine on qemu/master branch (c8004fe6bbfc)

Ravi Bangoria (2):
  ppc: Rename current DAWR macros
  ppc: Enable 2nd DAWR support on p10

 hw/ppc/spapr.c                  | 33 +++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h          |  3 ++-
 linux-headers/asm-powerpc/kvm.h |  8 ++++++--
 linux-headers/linux/kvm.h       |  1 +
 target/ppc/cpu.h                |  6 ++++--
 target/ppc/kvm.c                |  7 +++++++
 target/ppc/kvm_ppc.h            |  6 ++++++
 target/ppc/translate_init.inc.c | 25 ++++++++++++++++++++-----
 8 files changed, 79 insertions(+), 10 deletions(-)

-- 
2.17.1

