Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B95E7E0D
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 02:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfJ2Bfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 21:35:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfJ2Bfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 21:35:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T1T2BK097401;
        Tue, 29 Oct 2019 01:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1QUjjGC1YE4Daj4tnRMfZjU7tGJjeHUbiYia35CGU+Q=;
 b=UBvcWjJ3wVrUaDWOvolEun+19hgc7V8LByC07kM/vYaktqYS/3+UmORWTEqm2qJzTcoW
 0pJfBgHzHvDJIA6R5EPyUkUioJ23CqK8qTe2uZ9Fah4gYPY62hNcG/npbS3lX5r7pju1
 zMzJuSX/nKfmZZdMXEZ6j6UseD9pkvYnXRRQ2yZmGmJiC9qvf8eNqsUwv6uz64ULs8jh
 o+h+09miusUXunjwcs0PMB9a5hHi1moPHd9sEHIgXt+g373DUkvxOD5tjooJz/mkV7S4
 4EMgzlTJLJwKFP4zf/rZFT+TsN8S4tHs7SQnOv3bRpxQSLrToDJrJNnPmoPEZvwpSJYd 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vvdju5qek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 01:33:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9T1X4og086957;
        Tue, 29 Oct 2019 01:33:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vw09gtewe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 01:33:43 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9T1XYfg008271;
        Tue, 29 Oct 2019 01:33:37 GMT
Received: from [10.191.21.100] (/10.191.21.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 18:33:34 -0700
Subject: Re: [PATCH v8 0/5] Add a unified parameter "nopvspin"
To:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        pbonzini@redhat.com
Cc:     mingo@redhat.com, bp@alien8.de, x86@kernel.org, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com, peterz@infradead.org,
        will@kernel.org, linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org
References: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <86263ee3-f94f-8a6b-3842-f15fb0316798@oracle.com>
Date:   Tue, 29 Oct 2019 09:33:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571829384-5309-1-git-send-email-zhenzhong.duan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290014
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Baolo, Thomas

This patchset is reviewed pass and keep silent for a while, will anyone 
of you

consider to pick it up? Thanks

Zhenzhong

On 2019/10/23 19:16, Zhenzhong Duan wrote:
> There are cases folks want to disable spinlock optimization for
> debug/test purpose. Xen and hyperv already have parameters "xen_nopvspin"
> and "hv_nopvspin" to support that, but kvm doesn't.
>
> The first patch adds that feature to KVM guest with "nopvspin".
>
> For compatibility reason original parameters "xen_nopvspin" and
> "hv_nopvspin" are retained and marked obsolete.
>
> v8:
> PATCH2: use 'kvm-guest' instead of 'kvm_guest'        [Sean Christopherson]
> PATCH3: add a comment to explain missed 'return'      [Sean Christopherson]
>
> v7:
> PATCH3: update comment and use goto, add RB              [Vitaly Kuznetsov]
>
> v6:
> PATCH1: add Reviewed-by                                  [Vitaly Kuznetsov]
> PATCH2: change 'pv' to 'PV', add Reviewed-by             [Vitaly Kuznetsov]
> PATCH3: refactor 'if' branch in kvm_spinlock_init()      [Vitaly Kuznetsov]
>
> v5:
> PATCH1: new patch to revert a currently unnecessory commit,
>          code is simpler a bit after that change.         [Boris Ostrovsky]
> PATCH3: fold 'if' statement,add comments on virt_spin_lock_key,
>          reorder with PATCH2 to better reflect dependency
> PATCH4: fold 'if' statement, add Reviewed-by             [Boris Ostrovsky]
> PATCH5: add Reviewed-by                                  [Michael Kelley]
>
> v4:
> PATCH1: use variable name nopvspin instead of pvspin and
>          defined it as __initdata, changed print message,
>          updated patch description                     [Sean Christopherson]
> PATCH2: remove Suggested-by, use "kvm-guest:" prefix  [Sean Christopherson]
> PATCH3: make variable nopvsin and xen_pvspin coexist
>          remove Reviewed-by due to code change         [Sean Christopherson]
> PATCH4: make variable nopvsin and hv_pvspin coexist   [Sean Christopherson]
>
> v3:
> PATCH2: Fix indentation
>
> v2:
> PATCH1: pick the print code change into separate PATCH2,
>          updated patch description             [Vitaly Kuznetsov]
> PATCH2: new patch with print code change      [Vitaly Kuznetsov]
> PATCH3: add Reviewed-by                       [Juergen Gross]
>
> Zhenzhong Duan (5):
>    Revert "KVM: X86: Fix setup the virt_spin_lock_key before static key
>      get initialized"
>    x86/kvm: Change print code to use pr_*() format
>    x86/kvm: Add "nopvspin" parameter to disable PV spinlocks
>    xen: Mark "xen_nopvspin" parameter obsolete
>    x86/hyperv: Mark "hv_nopvspin" parameter obsolete
>
>   Documentation/admin-guide/kernel-parameters.txt | 14 ++++-
>   arch/x86/hyperv/hv_spinlock.c                   |  4 ++
>   arch/x86/include/asm/qspinlock.h                |  1 +
>   arch/x86/kernel/kvm.c                           | 79 ++++++++++++++++---------
>   arch/x86/xen/spinlock.c                         |  4 +-
>   kernel/locking/qspinlock.c                      |  7 +++
>   6 files changed, 76 insertions(+), 33 deletions(-)
>
