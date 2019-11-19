Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED3910111B
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 03:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfKSCFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 21:05:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKSCE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 21:04:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ20JOq174419;
        Tue, 19 Nov 2019 02:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LwULDTBc+rigjf0sejI3ferVE3V7uWPReTZ8S+pp39s=;
 b=nhWJqFQPkRIoMDNFK7WxEUVy8QzdSc+fs2Wc6Y3w+YAb9AqfvqN5wDV5ElCfPoHEUkjX
 lLuO9+DwoNmXSapMrkqBvjaG+Ksppzaai/gCAXn9gVXxhR2lJKMIELISSIOwLqESBcFr
 NdO2JxTm/oeAvwpE6EgHNNFpw0PGBK8hIT8V1XTtlxGBGQfQp557AdzPVeCZEmp3At0S
 pWnvuN5AhiaKiUSo7nxeMS+/o1rkagV7qyJ7RiMKWW1Wn9Kcju1YHmllNaKHRzGlhXdi
 a46VvEb73TrvmbFYIPEBuvtN/RlPGcCx2GvCtGdUTGjNJ8gpQ0KwCkRNuDqLKb2LtRML 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wa92pkvs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 02:02:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ1xPOD118317;
        Tue, 19 Nov 2019 02:02:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wc09wja66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 02:02:08 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAJ225L5024440;
        Tue, 19 Nov 2019 02:02:05 GMT
Received: from [10.191.19.228] (/10.191.19.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 18:02:04 -0800
Subject: Re: [PATCH v8 0/5] Add a unified parameter "nopvspin"
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
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
 <86263ee3-f94f-8a6b-3842-f15fb0316798@oracle.com>
Organization: Oracle Corporation
Message-ID: <1ef9b26d-3b21-f285-bb93-063ee30e546f@oracle.com>
Date:   Tue, 19 Nov 2019 10:01:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <86263ee3-f94f-8a6b-3842-f15fb0316798@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190016
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maintainers,

May I get a final update on this patchset?

There is only a few days remaining before my layoff at Oracle. I can't 
login the mail address after that.

No matter if you prefer to reject it, please let me know. I'd like to 
get an end to this patchset.

Thanks

Zhenzhong


On 2019/10/29 9:33, Zhenzhong Duan wrote:
> Hi Baolo, Thomas
>
> This patchset is reviewed pass and keep silent for a while, will 
> anyone of you
>
> consider to pick it up? Thanks
>
> Zhenzhong
>
> On 2019/10/23 19:16, Zhenzhong Duan wrote:
>> There are cases folks want to disable spinlock optimization for
>> debug/test purpose. Xen and hyperv already have parameters 
>> "xen_nopvspin"
>> and "hv_nopvspin" to support that, but kvm doesn't.
>>
>> The first patch adds that feature to KVM guest with "nopvspin".
>>
>> For compatibility reason original parameters "xen_nopvspin" and
>> "hv_nopvspin" are retained and marked obsolete.
>>
>> v8:
>> PATCH2: use 'kvm-guest' instead of 'kvm_guest'        [Sean 
>> Christopherson]
>> PATCH3: add a comment to explain missed 'return'      [Sean 
>> Christopherson]
>>
>> v7:
>> PATCH3: update comment and use goto, add RB              [Vitaly 
>> Kuznetsov]
>>
>> v6:
>> PATCH1: add Reviewed-by                                  [Vitaly 
>> Kuznetsov]
>> PATCH2: change 'pv' to 'PV', add Reviewed-by             [Vitaly 
>> Kuznetsov]
>> PATCH3: refactor 'if' branch in kvm_spinlock_init()      [Vitaly 
>> Kuznetsov]
>>
>> v5:
>> PATCH1: new patch to revert a currently unnecessory commit,
>>          code is simpler a bit after that change.         [Boris 
>> Ostrovsky]
>> PATCH3: fold 'if' statement,add comments on virt_spin_lock_key,
>>          reorder with PATCH2 to better reflect dependency
>> PATCH4: fold 'if' statement, add Reviewed-by             [Boris 
>> Ostrovsky]
>> PATCH5: add Reviewed-by [Michael Kelley]
>>
>> v4:
>> PATCH1: use variable name nopvspin instead of pvspin and
>>          defined it as __initdata, changed print message,
>>          updated patch description                     [Sean 
>> Christopherson]
>> PATCH2: remove Suggested-by, use "kvm-guest:" prefix  [Sean 
>> Christopherson]
>> PATCH3: make variable nopvsin and xen_pvspin coexist
>>          remove Reviewed-by due to code change         [Sean 
>> Christopherson]
>> PATCH4: make variable nopvsin and hv_pvspin coexist   [Sean 
>> Christopherson]
>>
>> v3:
>> PATCH2: Fix indentation
>>
>> v2:
>> PATCH1: pick the print code change into separate PATCH2,
>>          updated patch description             [Vitaly Kuznetsov]
>> PATCH2: new patch with print code change      [Vitaly Kuznetsov]
>> PATCH3: add Reviewed-by                       [Juergen Gross]
>>
>> Zhenzhong Duan (5):
>>    Revert "KVM: X86: Fix setup the virt_spin_lock_key before static key
>>      get initialized"
>>    x86/kvm: Change print code to use pr_*() format
>>    x86/kvm: Add "nopvspin" parameter to disable PV spinlocks
>>    xen: Mark "xen_nopvspin" parameter obsolete
>>    x86/hyperv: Mark "hv_nopvspin" parameter obsolete
>>
>>   Documentation/admin-guide/kernel-parameters.txt | 14 ++++-
>>   arch/x86/hyperv/hv_spinlock.c                   |  4 ++
>>   arch/x86/include/asm/qspinlock.h                |  1 +
>>   arch/x86/kernel/kvm.c                           | 79 
>> ++++++++++++++++---------
>>   arch/x86/xen/spinlock.c                         |  4 +-
>>   kernel/locking/qspinlock.c                      |  7 +++
>>   6 files changed, 76 insertions(+), 33 deletions(-)
>>
