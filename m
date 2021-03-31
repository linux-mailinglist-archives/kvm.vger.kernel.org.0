Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A98634C272
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 06:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhC2EUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 00:20:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhC2EUZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 00:20:25 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T44MqS186987;
        Mon, 29 Mar 2021 00:20:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=IR07W5LIxpzREqRvvNBiQMSIF2pzsSh0D44KCLXQzvE=;
 b=KgB0LIDxMH2NfnuB0mEEJmpdC0HLU+DI0WXdvjDoWRLaOuaXB/euOk4QFLms2npqhazI
 AJfRaZyBfH1rI6+VxdxXLBkARdOCaaEQxBG9WgrYn3eMy0QRjPqkMlNAMI4kJJl67ccx
 tclGDmtPMmLODl4Dq8TungUV5KNecxpau31Vxh3TLNv3jXx3JTAsoPGltxj1T0ErMzhU
 VirzdJDaAKf8dEAu5YwqNuplQhJ+wtJw1aQHQL5WqVIXp4YRda0dAiDe+coPAsH4Sny/
 cLdRO5YcVrprvmtavSZt0pxF1ZntU1aTghDu84hwOYSHsupS6alFfGz5Ia3DK/R0iICP yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhm4b4xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 00:20:01 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12T48dcp000687;
        Mon, 29 Mar 2021 00:20:01 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhm4b4x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 00:20:01 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12T4HcLS013743;
        Mon, 29 Mar 2021 04:19:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 37hvb88rqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 04:19:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12T4JuVe23855434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 04:19:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 357FB4C046;
        Mon, 29 Mar 2021 04:19:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF9974C050;
        Mon, 29 Mar 2021 04:19:52 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.34.103])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 04:19:52 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: [PATCH v2 0/3] ppc: Enable 2nd DAWR support on Power10
Date:   Mon, 29 Mar 2021 09:49:03 +0530
Message-Id: <20210329041906.213991-1-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EyPXyix-vOAiCXaFRJQj6eMW92jyQKB3
X-Proofpoint-ORIG-GUID: mWY1CsqNmpM7uAnNDJHE2hqxBV5MI2bb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_02:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=964 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290029
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables 2nd DAWR support on p10 qemu guest. 2nd
DAWR is new watchpoint added in Power10 processor. Kernel/kvm
patches are already in[1].

Patches apply fine on qemu/master branch (9e2e9fe3df9f).

v1: https://lore.kernel.org/r/20200723104220.314671-1-ravi.bangoria@linux.ibm.com
[Apologies for long gap]
v1->v2:
  - Introduce machine capability cap-dawr1 to enable/disable
    the feature. By default, 2nd DAWR is OFF for guests even
    when host kvm supports it. User has to manually enable it
    with -machine cap-dawr1=on if he wishes to use it.
  - Split the header file changes into separate patch. (Sync
    headers from v5.12-rc3)

[1] https://git.kernel.org/torvalds/c/bd1de1a0e6eff

Ravi Bangoria (3):
  Linux headers: update from 5.12-rc3
  ppc: Rename current DAWR macros and variables
  ppc: Enable 2nd DAWR support on p10

 hw/ppc/spapr.c                                 | 34 ++++++++++
 hw/ppc/spapr_caps.c                            | 32 +++++++++
 include/hw/ppc/spapr.h                         |  8 ++-
 include/standard-headers/drm/drm_fourcc.h      | 23 ++++++-
 include/standard-headers/linux/input.h         |  2 +-
 include/standard-headers/rdma/vmw_pvrdma-abi.h |  7 ++
 linux-headers/asm-generic/unistd.h             |  4 +-
 linux-headers/asm-mips/unistd_n32.h            |  1 +
 linux-headers/asm-mips/unistd_n64.h            |  1 +
 linux-headers/asm-mips/unistd_o32.h            |  1 +
 linux-headers/asm-powerpc/kvm.h                |  2 +
 linux-headers/asm-powerpc/unistd_32.h          |  1 +
 linux-headers/asm-powerpc/unistd_64.h          |  1 +
 linux-headers/asm-s390/unistd_32.h             |  1 +
 linux-headers/asm-s390/unistd_64.h             |  1 +
 linux-headers/asm-x86/kvm.h                    |  1 +
 linux-headers/asm-x86/unistd_32.h              |  1 +
 linux-headers/asm-x86/unistd_64.h              |  1 +
 linux-headers/asm-x86/unistd_x32.h             |  1 +
 linux-headers/linux/kvm.h                      | 89 ++++++++++++++++++++++++++
 linux-headers/linux/vfio.h                     | 27 ++++++++
 target/ppc/cpu.h                               |  6 +-
 target/ppc/kvm.c                               | 12 ++++
 target/ppc/kvm_ppc.h                           |  7 ++
 target/ppc/translate_init.c.inc                | 21 +++++-
 25 files changed, 274 insertions(+), 11 deletions(-)

-- 
2.7.4

