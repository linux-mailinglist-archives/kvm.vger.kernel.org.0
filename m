Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2334C0026
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 18:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbiBVR2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 12:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiBVR2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 12:28:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFB016FDD5;
        Tue, 22 Feb 2022 09:27:36 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MHCLcB004681;
        Tue, 22 Feb 2022 17:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kJxQLhCusN9CGzM8gl7P06DfDEE8u11cEs/AZweNNnc=;
 b=To+gQLEZvSoq0QKWZBBiWqyFM2uLkeB7E08teBO44GyNB1HbaevdTClBiJ7KPWOiPn8k
 XcCYBmDf3CNWf1svHnfJNVqpx2RDNBsOAsTl4wGgaRMkouPDpkqZNseOngK3tsptey+l
 O57GoUONkP/X/Q10i2QKabPJg8hn66eeWi6ABipRf1UGNm7s+FvD2MuK4TQSmZLj2dZ2
 82f5i8X7sd6tllRLM2WKIQ+v4nung64qGbbS0LBMMWjKmkpe2eXB6CeDtGZWZDJWIHrw
 LIUQr/Hwgr9OlqsVgdfsHYIhgEti+44mbTw5kGva/Yb5giLUdB2wgm1U7/9C01e9vvuz LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed40y8bt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 17:27:36 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21MHChHI004955;
        Tue, 22 Feb 2022 17:27:35 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed40y8bs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 17:27:35 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MHDqkG022716;
        Tue, 22 Feb 2022 17:27:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ear693h0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 17:27:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MHRRcE42336564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 17:27:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DCAB4203F;
        Tue, 22 Feb 2022 17:27:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 701A742041;
        Tue, 22 Feb 2022 17:27:26 +0000 (GMT)
Received: from [9.145.90.75] (unknown [9.145.90.75])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 17:27:26 +0000 (GMT)
Message-ID: <7e700e23-a608-330e-c6fb-7d894e1b551c@linux.ibm.com>
Date:   Tue, 22 Feb 2022 18:27:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: make use of ultravisor AIV support
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220209152217.1793281-1-mimu@linux.ibm.com>
 <20220209152217.1793281-2-mimu@linux.ibm.com>
 <803275d5-58f4-21d9-8020-e56f05737450@de.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <803275d5-58f4-21d9-8020-e56f05737450@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zPUndn_DnPQD5fgob9wxnuAYFmhGiRb1
X-Proofpoint-ORIG-GUID: CxWUNoCkEpAWQbtO5JkrNW4rydU3Sp4R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_05,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.02.22 09:13, Christian Borntraeger wrote:
> Am 09.02.22 um 16:22 schrieb Michael Mueller:
>> This patch enables the ultravisor adapter interruption vitualization
>> support indicated by UV feature BIT_UV_FEAT_AIV. This allows ISC
>> interruption injection directly into the GISA IPM for PV kvm guests.
>>
>> Hardware that does not support this feature will continue to use the
>> UV interruption interception method to deliver ISC interruptions to
>> PV kvm guests. For this purpose, the ECA_AIV bit for all guest cpus
>> will be cleared and the GISA will be disabled during PV CPU setup.
>>
>> In addition a check in __inject_io() has been removed. That reduces the
>> required instructions for interruption handling for PV and traditional
>> kvm guests.
>>
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> 
> The CI said the following with gisa_disable in the calltrace.
> Will drop from next for now.

The issue is reproducible with the GISA switched of:

echo > 0 /sys/modules/kvm/parameters/use_gisa

In that case the code for gisa_disable() is not touched.

The lock is taken in front of kvm_s390_pv_create_cpu()
in this case.

         kvm_for_each_vcpu(i, vcpu, kvm) {
                 mutex_lock(&vcpu->mutex);
                 r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
                 mutex_unlock(&vcpu->mutex);
                 if (r)
                         break;
         }

I have an idea how to prevent this and will send a patch for both
situations.

[  319.799638] ======================================================
[  319.799639] WARNING: possible circular locking dependency detected
[  319.799641] 5.17.0-rc5-08427-gfd14b6309198 #4661 Not tainted
[  319.799643] ------------------------------------------------------
[  319.799644] qemu-system-s39/14220 is trying to acquire lock:
[  319.799646] 00000000b30c0b50 (&kvm->lock){+.+.}-{3:3}, at: 
kvm_s390_set_tod_clock+0x36/0x250
[  319.799659]
                but task is already holding lock:
[  319.799660] 00000000b5beda60 (&vcpu->mutex){+.+.}-{3:3}, at: 
kvm_vcpu_ioctl+0x9a/0x958
[  319.799665]
                which lock already depends on the new lock.

[  319.799667]
                the existing dependency chain (in reverse order) is:
[  319.799668]
                -> #1 (&vcpu->mutex){+.+.}-{3:3}:
[  319.799671]        __mutex_lock+0x8a/0x798
[  319.799677]        mutex_lock_nested+0x32/0x40
[  319.799679]        kvm_arch_vm_ioctl+0x1902/0x2c58
[  319.799682]        kvm_vm_ioctl+0x5b0/0xa80
[  319.799685]        __s390x_sys_ioctl+0xbe/0x100
[  319.799688]        __do_syscall+0x1da/0x208
[  319.799689]        system_call+0x82/0xb0
[  319.799692]
                -> #0 (&kvm->lock){+.+.}-{3:3}:
[  319.799694]        __lock_acquire+0x1916/0x2e70
[  319.799699]        lock_acquire+0x164/0x388
[  319.799702]        __mutex_lock+0x8a/0x798
[  319.799757]        mutex_lock_nested+0x32/0x40
[  319.799759]        kvm_s390_set_tod_clock+0x36/0x250
[  319.799761]        kvm_s390_handle_b2+0x6cc/0x26f0
[  319.799764]        kvm_handle_sie_intercept+0x1fe/0xe98
[  319.799765]        kvm_arch_vcpu_ioctl_run+0xec8/0x1880
[  319.799768]        kvm_vcpu_ioctl+0x29e/0x958
[  319.799769]        __s390x_sys_ioctl+0xbe/0x100
[  319.799771]        __do_syscall+0x1da/0x208
[  319.799773]        system_call+0x82/0xb0
[  319.799774]
                other info that might help us debug this:

[  319.799776]  Possible unsafe locking scenario:

[  319.799777]        CPU0                    CPU1
[  319.799778]        ----                    ----
[  319.799779]   lock(&vcpu->mutex);
[  319.799780]                                lock(&kvm->lock);
[  319.799782]                                lock(&vcpu->mutex);
[  319.799783]   lock(&kvm->lock);
[  319.799784]
                 *** DEADLOCK ***

[  319.799785] 2 locks held by qemu-system-s39/14220:
[  319.799787]  #0: 00000000b5beda60 (&vcpu->mutex){+.+.}-{3:3}, at: 
kvm_vcpu_ioctl+0x9a/0x958
[  319.799791]  #1: 00000000b30c4588 (&kvm->srcu){....}-{0:0}, at: 
kvm_arch_vcpu_ioctl_run+0x6f2/0x1880
[  319.799796]
                stack backtrace:
[  319.799798] CPU: 5 PID: 14220 Comm: qemu-system-s39 Not tainted 
5.17.0-rc5-08427-gfd14b6309198 #4661
[  319.799801] Hardware name: IBM 8561 T01 701 (LPAR)
[  319.799802] Call Trace:
[  319.799803]  [<000000020d7410de>] dump_stack_lvl+0x76/0x98
[  319.799808]  [<000000020cbbd268>] check_noncircular+0x140/0x160
[  319.799811]  [<000000020cbc0efe>] __lock_acquire+0x1916/0x2e70
[  319.799813]  [<000000020cbc2dbc>] lock_acquire+0x164/0x388
[  319.799816]  [<000000020d75013a>] __mutex_lock+0x8a/0x798
[  319.799818]  [<000000020d75087a>] mutex_lock_nested+0x32/0x40
[  319.799820]  [<000000020cb029a6>] kvm_s390_set_tod_clock+0x36/0x250
[  319.799823]  [<000000020cb14d14>] kvm_s390_handle_b2+0x6cc/0x26f0
[  319.799825]  [<000000020cb09b6e>] kvm_handle_sie_intercept+0x1fe/0xe98
[  319.799827]  [<000000020cb06c28>] kvm_arch_vcpu_ioctl_run+0xec8/0x1880
[  319.799829]  [<000000020caeddc6>] kvm_vcpu_ioctl+0x29e/0x958
[  319.799831]  [<000000020ce4e82e>] __s390x_sys_ioctl+0xbe/0x100
[  319.799833]  [<000000020d744a72>] __do_syscall+0x1da/0x208
[  319.799835]  [<000000020d757322>] system_call+0x82/0xb0
[  319.799836] INFO: lockdep is turned off.


> 
>     LOCKDEP_CIRCULAR (suite: kvm-unit-tests-kvm, case: -)
>                  WARNING: possible circular locking dependency detected
>                  
> 5.17.0-20220221.rc5.git1.b8f0356a093a.300.fc35.s390x+debug #1 Not tainted
>                  ------------------------------------------------------
>                  qemu-system-s39/161139 is trying to acquire lock:
>                  0000000280dc0b98 (&kvm->lock){+.+.}-{3:3}, at: 
> kvm_s390_set_tod_clock+0x36/0x220 [kvm]
>                  but task is already holding lock:
>                  0000000280f4e4b8 (&vcpu->mutex){+.+.}-{3:3}, at: 
> kvm_vcpu_ioctl+0x9a/0xa40 [kvm]
>                  which lock already depends on the new lock.
>                  the existing dependency chain (in reverse order) is:
>                  -> #1 (&vcpu->mutex){+.+.}-{3:3}:
>                         __lock_acquire+0x604/0xbd8
>                         lock_acquire.part.0+0xe2/0x250
>                         lock_acquire+0xb0/0x200
>                         __mutex_lock+0x9e/0x8a0
>                         mutex_lock_nested+0x32/0x40
>                         kvm_s390_gisa_disable+0xa4/0x130 [kvm]
>                         kvm_s390_handle_pv+0x718/0x778 [kvm]
>                         kvm_arch_vm_ioctl+0x4ac/0x5f8 [kvm]
>                         kvm_vm_ioctl+0x336/0x530 [kvm]
>                         __s390x_sys_ioctl+0xbe/0x100
>                         __do_syscall+0x1da/0x208
>                         system_call+0x82/0xb0
>                  -> #0 (&kvm->lock){+.+.}-{3:3}:
>                         check_prev_add+0xe0/0xed8
>                         validate_chain+0x736/0xb20
>                         __lock_acquire+0x604/0xbd8
>                         lock_acquire.part.0+0xe2/0x250
>                         lock_acquire+0xb0/0x200
>                         __mutex_lock+0x9e/0x8a0
>                         mutex_lock_nested+0x32/0x40
>                         kvm_s390_set_tod_clock+0x36/0x220 [kvm]
>                         kvm_s390_handle_b2+0x378/0x728 [kvm]
>                         kvm_handle_sie_intercept+0x13a/0x448 [kvm]
>                         vcpu_post_run+0x28e/0x560 [kvm]
>                         __vcpu_run+0x266/0x388 [kvm]
>                         kvm_arch_vcpu_ioctl_run+0x10a/0x270 [kvm]
>                         kvm_vcpu_ioctl+0x27c/0xa40 [kvm]
>                         __s390x_sys_ioctl+0xbe/0x100
>                         __do_syscall+0x1da/0x208
>                         system_call+0x82/0xb0
>                  other info that might help us debug this:
>                   Possible unsafe locking scenario:
>                         CPU0                    CPU1
>                         ----                    ----
>                    lock(&vcpu->mutex);
>                                                 lock(&kvm->lock);
>                                                 lock(&vcpu->mutex);
>                    lock(&kvm->lock);
>                   *** DEADLOCK ***
>                  2 locks held by qemu-system-s39/161139:
>                   #0: 0000000280f4e4b8 (&vcpu->mutex){+.+.}-{3:3}, at: 
> kvm_vcpu_ioctl+0x9a/0xa40 [kvm]
>                   #1: 0000000280dc47c8 (&kvm->srcu){....}-{0:0}, at: 
> __vcpu_run+0x1d4/0x388 [kvm]
>                  stack backtrace:
>                  CPU: 10 PID: 161139 Comm: qemu-system-s39 Not tainted 
> 5.17.0-20220221.rc5.git1.b8f0356a093a.300.fc35.s390x+debug #1
>                  Hardware name: IBM 8561 T01 701 (LPAR)
>                  Call Trace:
>                   [<00000001da4e89de>] dump_stack_lvl+0x8e/0xc8
>                   [<00000001d9876c56>] check_noncircular+0x136/0x158
>                   [<00000001d9877c70>] check_prev_add+0xe0/0xed8
>                   [<00000001d987919e>] validate_chain+0x736/0xb20
>                   [<00000001d987b23c>] __lock_acquire+0x604/0xbd8
>                   [<00000001d987c432>] lock_acquire.part.0+0xe2/0x250
>                   [<00000001d987c650>] lock_acquire+0xb0/0x200
>                   [<00000001da4f72ae>] __mutex_lock+0x9e/0x8a0
>                   [<00000001da4f7ae2>] mutex_lock_nested+0x32/0x40
>                   [<000003ff8070cd6e>] kvm_s390_set_tod_clock+0x36/0x220 
> [kvm]
>                   [<000003ff8071dd68>] kvm_s390_handle_b2+0x378/0x728 [kvm]
>                   [<000003ff8071146a>] 
> kvm_handle_sie_intercept+0x13a/0x448 [kvm]
>                   [<000003ff8070dd46>] vcpu_post_run+0x28e/0x560 [kvm]
>                   [<000003ff8070e27e>] __vcpu_run+0x266/0x388 [kvm]
>                   [<000003ff8070eba2>] 
> kvm_arch_vcpu_ioctl_run+0x10a/0x270 [kvm]
>                   [<000003ff806f4044>] kvm_vcpu_ioctl+0x27c/0xa40 [kvm]
>                   [<00000001d9b47ac6>] __s390x_sys_ioctl+0xbe/0x100
>                   [<00000001da4ec152>] __do_syscall+0x1da/0x208
>                   [<00000001da4fec42>] system_call+0x82/0xb0
>                  INFO: lockdep is turned off.





[  319.799638] ======================================================
[  319.799639] WARNING: possible circular locking dependency detected
[  319.799641] 5.17.0-rc5-08427-gfd14b6309198 #4661 Not tainted
[  319.799643] ------------------------------------------------------
[  319.799644] qemu-system-s39/14220 is trying to acquire lock:
[  319.799646] 00000000b30c0b50 (&kvm->lock){+.+.}-{3:3}, at: 
kvm_s390_set_tod_clock+0x36/0x250
[  319.799659]
                but task is already holding lock:
[  319.799660] 00000000b5beda60 (&vcpu->mutex){+.+.}-{3:3}, at: 
kvm_vcpu_ioctl+0x9a/0x958
[  319.799665]
                which lock already depends on the new lock.

[  319.799667]
                the existing dependency chain (in reverse order) is:
[  319.799668]
                -> #1 (&vcpu->mutex){+.+.}-{3:3}:
[  319.799671]        __mutex_lock+0x8a/0x798
[  319.799677]        mutex_lock_nested+0x32/0x40
[  319.799679]        kvm_arch_vm_ioctl+0x1902/0x2c58
[  319.799682]        kvm_vm_ioctl+0x5b0/0xa80
[  319.799685]        __s390x_sys_ioctl+0xbe/0x100
[  319.799688]        __do_syscall+0x1da/0x208
[  319.799689]        system_call+0x82/0xb0
[  319.799692]
                -> #0 (&kvm->lock){+.+.}-{3:3}:
[  319.799694]        __lock_acquire+0x1916/0x2e70
[  319.799699]        lock_acquire+0x164/0x388
[  319.799702]        __mutex_lock+0x8a/0x798
[  319.799757]        mutex_lock_nested+0x32/0x40
[  319.799759]        kvm_s390_set_tod_clock+0x36/0x250
[  319.799761]        kvm_s390_handle_b2+0x6cc/0x26f0
[  319.799764]        kvm_handle_sie_intercept+0x1fe/0xe98
[  319.799765]        kvm_arch_vcpu_ioctl_run+0xec8/0x1880
[  319.799768]        kvm_vcpu_ioctl+0x29e/0x958
[  319.799769]        __s390x_sys_ioctl+0xbe/0x100
[  319.799771]        __do_syscall+0x1da/0x208
[  319.799773]        system_call+0x82/0xb0
[  319.799774]
                other info that might help us debug this:

[  319.799776]  Possible unsafe locking scenario:

[  319.799777]        CPU0                    CPU1
[  319.799778]        ----                    ----
[  319.799779]   lock(&vcpu->mutex);
[  319.799780]                                lock(&kvm->lock);
[  319.799782]                                lock(&vcpu->mutex);
[  319.799783]   lock(&kvm->lock);
[  319.799784]
                 *** DEADLOCK ***

[  319.799785] 2 locks held by qemu-system-s39/14220:
[  319.799787]  #0: 00000000b5beda60 (&vcpu->mutex){+.+.}-{3:3}, at: 
kvm_vcpu_ioctl+0x9a/0x958
[  319.799791]  #1: 00000000b30c4588 (&kvm->srcu){....}-{0:0}, at: 
kvm_arch_vcpu_ioctl_run+0x6f2/0x1880
[  319.799796]
                stack backtrace:
[  319.799798] CPU: 5 PID: 14220 Comm: qemu-system-s39 Not tainted 
5.17.0-rc5-08427-gfd14b6309198 #4661
[  319.799801] Hardware name: IBM 8561 T01 701 (LPAR)
[  319.799802] Call Trace:
[  319.799803]  [<000000020d7410de>] dump_stack_lvl+0x76/0x98
[  319.799808]  [<000000020cbbd268>] check_noncircular+0x140/0x160
[  319.799811]  [<000000020cbc0efe>] __lock_acquire+0x1916/0x2e70
[  319.799813]  [<000000020cbc2dbc>] lock_acquire+0x164/0x388
[  319.799816]  [<000000020d75013a>] __mutex_lock+0x8a/0x798
[  319.799818]  [<000000020d75087a>] mutex_lock_nested+0x32/0x40
[  319.799820]  [<000000020cb029a6>] kvm_s390_set_tod_clock+0x36/0x250
[  319.799823]  [<000000020cb14d14>] kvm_s390_handle_b2+0x6cc/0x26f0
[  319.799825]  [<000000020cb09b6e>] kvm_handle_sie_intercept+0x1fe/0xe98
[  319.799827]  [<000000020cb06c28>] kvm_arch_vcpu_ioctl_run+0xec8/0x1880
[  319.799829]  [<000000020caeddc6>] kvm_vcpu_ioctl+0x29e/0x958
[  319.799831]  [<000000020ce4e82e>] __s390x_sys_ioctl+0xbe/0x100
[  319.799833]  [<000000020d744a72>] __do_syscall+0x1da/0x208
[  319.799835]  [<000000020d757322>] system_call+0x82/0xb0
[  319.799836] INFO: lockdep is turned off.
