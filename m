Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0A34BF349
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 09:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiBVIOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 03:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiBVIOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 03:14:02 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD36151D11;
        Tue, 22 Feb 2022 00:13:36 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M5i68e034594;
        Tue, 22 Feb 2022 08:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lGaoqB+I1Qhcqjra4EUA0AvpIwVnPNTy6OTIlddlfh0=;
 b=YiWhq0uYxZ2IgHr6WtEltbFStQNtkVsznxNGXuCZBguyezvbapKoK5MD9qBsGllR5xZk
 kcyD+JgCIIeoPjnPq2K9KmzmbpfsIjeeWm1BgOAHFt6nVI94Ns7TUTqi6qvblYLs3u3N
 YLbvnWL8Ssrs9CuYmAbLTDG7OKLDzMN4bMerVHGQpGH5AKi6xc7P7/OuJhWakUbBhBAF
 phnpNLsm5RHnHxSyKnoCMrUXiRseRdQfahMhl3vnK3ULv4NF9wKl4+PNU8afk1sMCjeZ
 VQOiR0GBZ4v8dDgUHpkm1CRHZ+/Pt1b8SPd+K3x8fkKw1pJJm0UZ3dhT5iPYun5tbIOx Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecsxp32yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 08:13:35 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M7QZv6025188;
        Tue, 22 Feb 2022 08:13:35 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ecsxp32yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 08:13:35 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M8DKl6027371;
        Tue, 22 Feb 2022 08:13:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3ear68yuak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 08:13:33 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M82r3t14876998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 08:02:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 251584C052;
        Tue, 22 Feb 2022 08:13:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA54B4C064;
        Tue, 22 Feb 2022 08:13:29 +0000 (GMT)
Received: from [9.171.12.252] (unknown [9.171.12.252])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 08:13:29 +0000 (GMT)
Message-ID: <803275d5-58f4-21d9-8020-e56f05737450@de.ibm.com>
Date:   Tue, 22 Feb 2022 09:13:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: make use of ultravisor AIV support
Content-Language: en-US
To:     Michael Mueller <mimu@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220209152217.1793281-1-mimu@linux.ibm.com>
 <20220209152217.1793281-2-mimu@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20220209152217.1793281-2-mimu@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0NOii0dwTeZo61rlj5DTBu81nmkp1AhT
X-Proofpoint-GUID: sf-kCLE0x2hFhhUQl2edQV6PvZBJDZog
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 09.02.22 um 16:22 schrieb Michael Mueller:
> This patch enables the ultravisor adapter interruption vitualization
> support indicated by UV feature BIT_UV_FEAT_AIV. This allows ISC
> interruption injection directly into the GISA IPM for PV kvm guests.
> 
> Hardware that does not support this feature will continue to use the
> UV interruption interception method to deliver ISC interruptions to
> PV kvm guests. For this purpose, the ECA_AIV bit for all guest cpus
> will be cleared and the GISA will be disabled during PV CPU setup.
> 
> In addition a check in __inject_io() has been removed. That reduces the
> required instructions for interruption handling for PV and traditional
> kvm guests.
> 
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>

The CI said the following with gisa_disable in the calltrace.
Will drop from next for now.

    LOCKDEP_CIRCULAR (suite: kvm-unit-tests-kvm, case: -)
                 WARNING: possible circular locking dependency detected
                 5.17.0-20220221.rc5.git1.b8f0356a093a.300.fc35.s390x+debug #1 Not tainted
                 ------------------------------------------------------
                 qemu-system-s39/161139 is trying to acquire lock:
                 0000000280dc0b98 (&kvm->lock){+.+.}-{3:3}, at: kvm_s390_set_tod_clock+0x36/0x220 [kvm]
                 but task is already holding lock:
                 0000000280f4e4b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x9a/0xa40 [kvm]
                 which lock already depends on the new lock.
                 the existing dependency chain (in reverse order) is:
                 -> #1 (&vcpu->mutex){+.+.}-{3:3}:
                        __lock_acquire+0x604/0xbd8
                        lock_acquire.part.0+0xe2/0x250
                        lock_acquire+0xb0/0x200
                        __mutex_lock+0x9e/0x8a0
                        mutex_lock_nested+0x32/0x40
                        kvm_s390_gisa_disable+0xa4/0x130 [kvm]
                        kvm_s390_handle_pv+0x718/0x778 [kvm]
                        kvm_arch_vm_ioctl+0x4ac/0x5f8 [kvm]
                        kvm_vm_ioctl+0x336/0x530 [kvm]
                        __s390x_sys_ioctl+0xbe/0x100
                        __do_syscall+0x1da/0x208
                        system_call+0x82/0xb0
                 -> #0 (&kvm->lock){+.+.}-{3:3}:
                        check_prev_add+0xe0/0xed8
                        validate_chain+0x736/0xb20
                        __lock_acquire+0x604/0xbd8
                        lock_acquire.part.0+0xe2/0x250
                        lock_acquire+0xb0/0x200
                        __mutex_lock+0x9e/0x8a0
                        mutex_lock_nested+0x32/0x40
                        kvm_s390_set_tod_clock+0x36/0x220 [kvm]
                        kvm_s390_handle_b2+0x378/0x728 [kvm]
                        kvm_handle_sie_intercept+0x13a/0x448 [kvm]
                        vcpu_post_run+0x28e/0x560 [kvm]
                        __vcpu_run+0x266/0x388 [kvm]
                        kvm_arch_vcpu_ioctl_run+0x10a/0x270 [kvm]
                        kvm_vcpu_ioctl+0x27c/0xa40 [kvm]
                        __s390x_sys_ioctl+0xbe/0x100
                        __do_syscall+0x1da/0x208
                        system_call+0x82/0xb0
                 other info that might help us debug this:
                  Possible unsafe locking scenario:
                        CPU0                    CPU1
                        ----                    ----
                   lock(&vcpu->mutex);
                                                lock(&kvm->lock);
                                                lock(&vcpu->mutex);
                   lock(&kvm->lock);
                  *** DEADLOCK ***
                 2 locks held by qemu-system-s39/161139:
                  #0: 0000000280f4e4b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x9a/0xa40 [kvm]
                  #1: 0000000280dc47c8 (&kvm->srcu){....}-{0:0}, at: __vcpu_run+0x1d4/0x388 [kvm]
                 stack backtrace:
                 CPU: 10 PID: 161139 Comm: qemu-system-s39 Not tainted 5.17.0-20220221.rc5.git1.b8f0356a093a.300.fc35.s390x+debug #1
                 Hardware name: IBM 8561 T01 701 (LPAR)
                 Call Trace:
                  [<00000001da4e89de>] dump_stack_lvl+0x8e/0xc8
                  [<00000001d9876c56>] check_noncircular+0x136/0x158
                  [<00000001d9877c70>] check_prev_add+0xe0/0xed8
                  [<00000001d987919e>] validate_chain+0x736/0xb20
                  [<00000001d987b23c>] __lock_acquire+0x604/0xbd8
                  [<00000001d987c432>] lock_acquire.part.0+0xe2/0x250
                  [<00000001d987c650>] lock_acquire+0xb0/0x200
                  [<00000001da4f72ae>] __mutex_lock+0x9e/0x8a0
                  [<00000001da4f7ae2>] mutex_lock_nested+0x32/0x40
                  [<000003ff8070cd6e>] kvm_s390_set_tod_clock+0x36/0x220 [kvm]
                  [<000003ff8071dd68>] kvm_s390_handle_b2+0x378/0x728 [kvm]
                  [<000003ff8071146a>] kvm_handle_sie_intercept+0x13a/0x448 [kvm]
                  [<000003ff8070dd46>] vcpu_post_run+0x28e/0x560 [kvm]
                  [<000003ff8070e27e>] __vcpu_run+0x266/0x388 [kvm]
                  [<000003ff8070eba2>] kvm_arch_vcpu_ioctl_run+0x10a/0x270 [kvm]
                  [<000003ff806f4044>] kvm_vcpu_ioctl+0x27c/0xa40 [kvm]
                  [<00000001d9b47ac6>] __s390x_sys_ioctl+0xbe/0x100
                  [<00000001da4ec152>] __do_syscall+0x1da/0x208
                  [<00000001da4fec42>] system_call+0x82/0xb0
                 INFO: lockdep is turned off.
