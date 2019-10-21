Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6E2E005E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 11:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388570AbfJVJIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 05:08:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388565AbfJVJIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 05:08:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M94JXw156336;
        Tue, 22 Oct 2019 09:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=z26nZqDxzBOJ9BRfbSpqDpmsq0mVNNYQLDQL4WWklhc=;
 b=HIgodUMs9ZAbI6mH8+OJx/CTveL/ZDZUlvQ1TK9BjEaPawvfoZ/ZJMPAIHKHTRF5mcs7
 gYIuc8aYW2jcbW44bsg4ROuMW6xqNsp4r1l4ymwWmUfYbUS7HqZWApB30EQ15g7Wb14a
 T2g7VLoL8sS7PWCkZ9LBgPwhutXZc37mDwtHSOPW45gpwV+smSPktILa9iaHAQmpvvHE
 /EBvqORUSoxJDRg0DLAqf3ekx9PD3nkzlxffAJlvd/bSRWbGBZYJdW/z5O4yJuTtCeUD
 C69XyztcMJ+z00Uemi3Jwoeb1r8/GzbJ1Mmp5n1/iJD0pxzxg0vc9EBo7iFuHzj8Q2Br 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqtepn899-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 09:06:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M937NR014871;
        Tue, 22 Oct 2019 09:06:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vsx2qbb6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 09:06:26 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9M96H0I006689;
        Tue, 22 Oct 2019 09:06:21 GMT
Received: from z2.cn.oracle.com (/10.182.70.159)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 09:06:17 +0000
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com, peterz@infradead.org,
        will@kernel.org, linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH v7 0/5] Add a unified parameter "nopvspin"
Date:   Mon, 21 Oct 2019 17:11:11 +0800
Message-Id: <1571649076-2421-1-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All the patches have Reviewed-by now, I think v7 could be the final
version.

There are cases folks want to disable spinlock optimization for
debug/test purpose. Xen and hyperv already have parameters "xen_nopvspin"
and "hv_nopvspin" to support that, but kvm doesn't.

The first patch adds that feature to KVM guest with "nopvspin".

For compatibility reason original parameters "xen_nopvspin" and
"hv_nopvspin" are retained and marked obsolete.

v7:
PATCH3: update comment and use goto, add RB              [Vitaly Kuznetsov]

v6:
PATCH1: add Reviewed-by                                  [Vitaly Kuznetsov]
PATCH2: change 'pv' to 'PV', add Reviewed-by             [Vitaly Kuznetsov]
PATCH3: refactor 'if' branch in kvm_spinlock_init()      [Vitaly Kuznetsov]

v5:
PATCH1: new patch to revert a currently unnecessory commit,
        code is simpler a bit after that change.         [Boris Ostrovsky]
PATCH3: fold 'if' statement,add comments on virt_spin_lock_key,
        reorder with PATCH2 to better reflect dependency                               
PATCH4: fold 'if' statement, add Reviewed-by             [Boris Ostrovsky]
PATCH5: add Reviewed-by                                  [Michael Kelley]

v4:
PATCH1: use variable name nopvspin instead of pvspin and
        defined it as __initdata, changed print message,
        updated patch description                     [Sean Christopherson]
PATCH2: remove Suggested-by, use "kvm-guest:" prefix  [Sean Christopherson]
PATCH3: make variable nopvsin and xen_pvspin coexist
        remove Reviewed-by due to code change         [Sean Christopherson]
PATCH4: make variable nopvsin and hv_pvspin coexist   [Sean Christopherson]

v3:
PATCH2: Fix indentation

v2:
PATCH1: pick the print code change into separate PATCH2,
        updated patch description             [Vitaly Kuznetsov]
PATCH2: new patch with print code change      [Vitaly Kuznetsov]
PATCH3: add Reviewed-by                       [Juergen Gross]

Zhenzhong Duan (5):
  Revert "KVM: X86: Fix setup the virt_spin_lock_key before static key
    get initialized"
  x86/kvm: Change print code to use pr_*() format
  x86/kvm: Add "nopvspin" parameter to disable PV spinlocks
  xen: Mark "xen_nopvspin" parameter obsolete
  x86/hyperv: Mark "hv_nopvspin" parameter obsolete

 Documentation/admin-guide/kernel-parameters.txt | 14 ++++-
 arch/x86/hyperv/hv_spinlock.c                   |  4 ++
 arch/x86/include/asm/qspinlock.h                |  1 +
 arch/x86/kernel/kvm.c                           | 74 +++++++++++++++----------
 arch/x86/xen/spinlock.c                         |  4 +-
 kernel/locking/qspinlock.c                      |  7 +++
 6 files changed, 71 insertions(+), 33 deletions(-)

-- 
1.8.3.1

