Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B238D4E51
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 10:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfJLIoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 04:44:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728812AbfJLImM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 04:42:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C8d3I5005712;
        Sat, 12 Oct 2019 08:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=eTLCc8eWlTUmLnYiMct7cflsemw5ED6SJHMEBd984nY=;
 b=j30w7pPALDgopJ4pGWnCJS1/9jQn6QG03r+u5ObslfJMqn7zIKaKQnQS5BAu23EUZP2g
 mf2muP0iGYXuxmFp6bjU8pidcKg9pSU6ec93baDYNfaOdtS2xewSK7WcCLZTkzJ50Lxw
 GqKTU0guXmfG1HFZUQXTGeXskTFdqX1/IyDaVNUhVnk5AMry4eSJFq/TIVDGZUrsEGFu
 PNdpOpR9xlxMjyNutSmxh00Btm84uEtkp5Dl33vEqicctzE0Lq+eKvAO8AjwuPAItQ0b
 Nhy49fJQyAvsFomXvv7Ew3UMO8tjWzwHYNlhx/mYoZzAPIqUCDsZP8MuGCe8JgXVuzXR 1A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vk6sq0pb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 08:40:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C8cGL9154374;
        Sat, 12 Oct 2019 08:40:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vk3xw8vhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 08:40:23 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9C8eIcl029967;
        Sat, 12 Oct 2019 08:40:18 GMT
Received: from [10.191.25.133] (/10.191.25.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Oct 2019 01:40:17 -0700
Subject: Re: [PATCH v5 0/5] Add a unified parameter "nopvspin"
To:     linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, peterz@infradead.org
References: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <d04aacc3-c816-94a6-052f-bf306ec23941@oracle.com>
Date:   Sat, 12 Oct 2019 16:40:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910120081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910120081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The last two patches are reviewed, will any KVM expert be willing to 
review the first three patches?

They are all KVM related changes. Thanks

Zhenzhong

On 2019/10/7 17:04, Zhenzhong Duan wrote:
> There are cases folks want to disable spinlock optimization for
> debug/test purpose. Xen and hyperv already have parameters "xen_nopvspin"
> and "hv_nopvspin" to support that, but kvm doesn't.
>
> The first patch adds that feature to KVM guest with "nopvspin".
>
> For compatibility reason original parameters "xen_nopvspin" and
> "hv_nopvspin" are retained and marked obsolete.
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
>   Documentation/admin-guide/kernel-parameters.txt | 14 +++++-
>   arch/x86/hyperv/hv_spinlock.c                   |  4 ++
>   arch/x86/include/asm/qspinlock.h                |  1 +
>   arch/x86/kernel/kvm.c                           | 63 ++++++++++++++-----------
>   arch/x86/xen/spinlock.c                         |  4 +-
>   kernel/locking/qspinlock.c                      |  7 +++
>   6 files changed, 62 insertions(+), 31 deletions(-)
>
