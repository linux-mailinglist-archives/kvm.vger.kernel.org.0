Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775C56044FC
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiJSMTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 08:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiJSMTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 08:19:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15AFE30;
        Wed, 19 Oct 2022 04:54:21 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JB669q024615;
        Wed, 19 Oct 2022 11:12:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=891Vkcr39KSAZ+eG59ZnEj+zRqeyVvQ6OEBU8tTrCCM=;
 b=Etd0PRns/j0AgeFyMjnxINTVRc/3bOi3LX00LdeTeSvadbI3vm/qquSzspVL9YMmD1j9
 EGxUVBkxngYpkAAUBE3hrKH1LmN/mKxOa9RpXLkq96K8HQ9x+VgqVNoJRsCUTE2X3IBK
 y6cQHgnRqXPwobum6dNEcfkMgScT4kw6fI1rQZXRYn5grspxHTQ8As0siMV0x9rH2oxk
 KkbKdjg+9+oscsKWD23OEDoYPwUatKt+58SXyT5qRVbkF64kFgYN5ZX8oFJTjv/IER+/
 rTBgf2hPNjs7qUSVz7uCU9WsdgqshAa21PJiV2GYlvO0K4cb4Ib7XCJSnqPbyWz2H5jr +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kafucrwnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 11:12:30 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JAp6nK026144;
        Wed, 19 Oct 2022 11:12:29 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kafucrwme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 11:12:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JB5XYO019779;
        Wed, 19 Oct 2022 11:12:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg96wx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 11:12:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JB7PCS50004468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 11:07:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B61E4C046;
        Wed, 19 Oct 2022 11:12:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 574BF4C040;
        Wed, 19 Oct 2022 11:12:25 +0000 (GMT)
Received: from [9.171.25.9] (unknown [9.171.25.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 11:12:25 +0000 (GMT)
Message-ID: <7de4aa75-875e-2d65-4cc5-8ce58f87c758@linux.ibm.com>
Date:   Wed, 19 Oct 2022 13:12:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: 6.1-rc1 regression: virtio-net cpumask and during reboot
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Michael S Tsirkin <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <ac72ff9d-4246-3631-6e31-8c3033a70bf0@linux.ibm.com>
In-Reply-To: <ac72ff9d-4246-3631-6e31-8c3033a70bf0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3orn2ZL5a3qQrJXGA1K-PGMcp5t1oBcZ
X-Proofpoint-GUID: 2kzsy4X6yQLbkTVASh2PUl_8Ydl5gchE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_06,2022-10-19_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=942 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 19.10.22 um 12:59 schrieb Christian Borntraeger:
> Michael,
> 
> as a heads-up.
> I have not looked into any details yet but we do get the following during reboot of a system on s390.
> It seems to be new with 6.1-rc1 (over 6.0)

Its not the reboot, its the boot with a kernel with debugging enabled.


> 
>    [    8.532461] ------------[ cut here ]------------
>    [    8.532497] WARNING: CPU: 8 PID: 377 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x3d8/0xca8
>    [    8.532507] Modules linked in: sha1_s390(+) sha_common virtio_net(+) net_failover failover pkey zcrypt rng_core autofs4
>    [    8.532528] CPU: 8 PID: 377 Comm: systemd-udevd Not tainted 6.1.0-20221018.rc1.git15.0fd5f2557625.300.fc36.s390x+debug #1
>    [    8.532533] Hardware name: IBM 8561 T01 701 (KVM/Linux)
>    [    8.532537] Krnl PSW : 0704e00180000000 00000000b05ec33c (__netif_set_xps_queue+0x3dc/0xca8)
>    [    8.532546]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
>    [    8.532552] Krnl GPRS: 00000000e7fb8b3f 0000000080000001 00000000b1870700 00000000b0ca1d3c
>    [    8.532557]            0000000000000100 0000000000000300 000000008b362500 00000000b133ba48
>    [    8.532561]            000000000000000c 0000038000000100 000000000000000c 0000000000000070
>    [    8.532566]            0000000084cd3200 0000000000000000 00000000b05ec0c2 00000380010b77c8
>    [    8.532575] Krnl Code: 00000000b05ec32e: c0e500187331      brasl   %r14,00000000b08fa990
>                              00000000b05ec334: a7f4ff0c          brc     15,00000000b05ec14c
>                             #00000000b05ec338: af000000          mc      0,0
>                             >00000000b05ec33c: ec76fed8007c      cgij    %r7,0,6,00000000b05ec0ec
>                              00000000b05ec342: e310f0b00004      lg      %r1,176(%r15)
>                              00000000b05ec348: ec16ffac007c      cgij    %r1,0,6,00000000b05ec2a0
>                              00000000b05ec34e: ec680388007c      cgij    %r6,0,8,00000000b05eca5e
>                              00000000b05ec354: e310f0b80004      lg      %r1,184(%r15)
>    [    8.532600] Call Trace:
>    [    8.532604]  [<00000000b05ec33c>] __netif_set_xps_queue+0x3dc/0xca8
>    [    8.532609] ([<00000000b05ec0c2>] __netif_set_xps_queue+0x162/0xca8)
>    [    8.532614]  [<000003ff7fbb81ce>] virtnet_set_affinity+0x1de/0x2a0 [virtio_net]
>    [    8.532622]  [<000003ff7fbbb674>] virtnet_probe+0x4d4/0xc08 [virtio_net]
>    [    8.532630]  [<00000000b04ec4e8>] virtio_dev_probe+0x1e8/0x418
>    [    8.532638]  [<00000000b05350ea>] really_probe+0xd2/0x480
>    [    8.532644]  [<00000000b0535648>] driver_probe_device+0x40/0xf0
>    [    8.532649]  [<00000000b0535fac>] __driver_attach+0x10c/0x208
>    [    8.532655]  [<00000000b0532542>] bus_for_each_dev+0x82/0xb8
>    [    8.532662]  [<00000000b053422e>] bus_add_driver+0x1d6/0x260
>    [    8.532667]  [<00000000b0536a70>] driver_register+0xa8/0x170
>    [    8.532672]  [<000003ff7fbc8088>] virtio_net_driver_init+0x88/0x1000 [virtio_net]
>    [    8.532680]  [<00000000afb50ab0>] do_one_initcall+0x78/0x388
>    [    8.532685]  [<00000000afc7b5b8>] do_init_module+0x60/0x248
>    [    8.532692]  [<00000000afc7ce96>] __do_sys_init_module+0xbe/0xd8
>    [    8.532698]  [<00000000b09123b2>] __do_syscall+0x1da/0x208
>    [    8.532704]  [<00000000b0925b12>] system_call+0x82/0xb0
>    [    8.532710] 3 locks held by systemd-udevd/377:
>    [    8.532715]  #0: 0000000089af5188 (&dev->mutex){....}-{3:3}, at: __driver_attach+0xfe/0x208
>    [    8.532728]  #1: 00000000b14668f0 (cpu_hotplug_lock){++++}-{0:0}, at: virtnet_probe+0x4ca/0xc08 [virtio_net]
>    [    8.532744]  #2: 00000000b1509d40 (xps_map_mutex){+.+.}-{3:3}, at: __netif_set_xps_queue+0x88/0xca8
>    [    8.532757] Last Breaking-Event-Address:
>    [    8.532760]  [<00000000b05ec0e0>] __netif_set_xps_queue+0x180/0xca8
