Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F762CF579
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfJHJBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 05:01:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51306 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfJHJBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 05:01:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x988haR7176900;
        Tue, 8 Oct 2019 08:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=GG6cP5QBwbQ2dOIhVepa60W9cY9VD9HYe0NrpQU/UHY=;
 b=nIpOjhZaA3ifKtsH0MHXkLf4tMmBywm1QxQ96NRefEzjE95zQCiQPfBvoYxwfCBr4KlO
 qAce0qW7xqpqNHa7p1EmhX3yZuqiOHScxixjwp56SLrO6+F8e1dV+7Y3rOYu2/3g8GDZ
 QtuNZ/1XZIezCDNk7b+qubWSWk+BIHQszJNW0wS75FAxowm6eDvYHWV9j5RyfTWn+KJr
 dwHIAeZz5Rxlrr3Flc9fcd8WIGIha9Crhndms+TSZDUEkANNcEaRbWJmke//TvSENj4P
 CmB/YZOVwSw+74WwXUSmiO0Nci2mQL7LEOx35zGw45HFk8fXwUPNw4bXliYcf7bvnF/T 9g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vektrbvhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 08:59:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x988hu2O027563;
        Tue, 8 Oct 2019 08:59:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vg205ur5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 08:59:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x988xoHX006734;
        Tue, 8 Oct 2019 08:59:50 GMT
Received: from z2.cn.oracle.com (/10.182.71.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 01:59:50 -0700
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, peterz@infradead.org,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: [PATCH v5 0/5] Add a unified parameter "nopvspin"
Date:   Mon,  7 Oct 2019 17:04:26 +0800
Message-Id: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are cases folks want to disable spinlock optimization for
debug/test purpose. Xen and hyperv already have parameters "xen_nopvspin"
and "hv_nopvspin" to support that, but kvm doesn't.

The first patch adds that feature to KVM guest with "nopvspin".

For compatibility reason original parameters "xen_nopvspin" and
"hv_nopvspin" are retained and marked obsolete.

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

 Documentation/admin-guide/kernel-parameters.txt | 14 +++++-
 arch/x86/hyperv/hv_spinlock.c                   |  4 ++
 arch/x86/include/asm/qspinlock.h                |  1 +
 arch/x86/kernel/kvm.c                           | 63 ++++++++++++++-----------
 arch/x86/xen/spinlock.c                         |  4 +-
 kernel/locking/qspinlock.c                      |  7 +++
 6 files changed, 62 insertions(+), 31 deletions(-)

-- 
1.8.3.1

