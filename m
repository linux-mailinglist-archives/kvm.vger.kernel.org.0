Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A838A6043EF
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 13:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiJSLyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 07:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiJSLxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 07:53:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCFE2B1A2;
        Wed, 19 Oct 2022 04:32:14 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JAogxR010728;
        Wed, 19 Oct 2022 11:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : from : subject : content-type :
 content-transfer-encoding; s=pp1;
 bh=5aM8g2MY3TdWDyxO9BYvpT398C7GdmU21Y/b0EmbcvM=;
 b=ZMDIZ+AUcC/b7IHTWRcPlugVkBoQlrbkggA1ScxCnLrzqZjyYd+DQcV/on6Z016uK0j5
 wRxGzDs+QD0pd09bJejO32KAYi9YftqX8SmXS/50RIUbSG3tEEQB+b0t8WOwVJHO+a7E
 kFv2eduBJlSJkyNWBWo00KRVQHV1LOIEtnpbA22fVGCvpBr5kWblpEziI9lkAlMo5Z14
 X5w8JMWnZoErE8dttbgxkkJ6jLqD1qifGEFUaA7vrpQuyM6Fy5IhvXuMe35HwJYEeiXZ
 M1M4wI0+1yARBhtrjGGBiYqH51XTBQanYkQzAlBozmAAzj2hnS6aBsoeDNQe6r5tZQYV zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kafug08hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 11:00:06 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29JApYhg013745;
        Wed, 19 Oct 2022 11:00:05 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kafug08d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 11:00:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29JApgEG031983;
        Wed, 19 Oct 2022 11:00:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg96xhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 11:00:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29JAxx6A31982020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 10:59:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 353674C046;
        Wed, 19 Oct 2022 10:59:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4AFA4C040;
        Wed, 19 Oct 2022 10:59:58 +0000 (GMT)
Received: from [9.171.25.9] (unknown [9.171.25.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 10:59:58 +0000 (GMT)
Message-ID: <ac72ff9d-4246-3631-6e31-8c3033a70bf0@linux.ibm.com>
Date:   Wed, 19 Oct 2022 12:59:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     Michael S Tsirkin <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: 6.1-rc1 regression: virtio-net cpumask and during reboot
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HnCpkbefGhwcBuLKqKSzlMd9aMXP2dCb
X-Proofpoint-ORIG-GUID: Ku55jI4xjKozpKcX4lPb9CqWBBIMTSKb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_06,2022-10-19_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 suspectscore=0 phishscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=831 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210190058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael,

as a heads-up.
I have not looked into any details yet but we do get the following during reboot of a system on s390.
It seems to be new with 6.1-rc1 (over 6.0)

   [    8.532461] ------------[ cut here ]------------
   [    8.532497] WARNING: CPU: 8 PID: 377 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x3d8/0xca8
   [    8.532507] Modules linked in: sha1_s390(+) sha_common virtio_net(+) net_failover failover pkey zcrypt rng_core autofs4
   [    8.532528] CPU: 8 PID: 377 Comm: systemd-udevd Not tainted 6.1.0-20221018.rc1.git15.0fd5f2557625.300.fc36.s390x+debug #1
   [    8.532533] Hardware name: IBM 8561 T01 701 (KVM/Linux)
   [    8.532537] Krnl PSW : 0704e00180000000 00000000b05ec33c (__netif_set_xps_queue+0x3dc/0xca8)
   [    8.532546]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
   [    8.532552] Krnl GPRS: 00000000e7fb8b3f 0000000080000001 00000000b1870700 00000000b0ca1d3c
   [    8.532557]            0000000000000100 0000000000000300 000000008b362500 00000000b133ba48
   [    8.532561]            000000000000000c 0000038000000100 000000000000000c 0000000000000070
   [    8.532566]            0000000084cd3200 0000000000000000 00000000b05ec0c2 00000380010b77c8
   [    8.532575] Krnl Code: 00000000b05ec32e: c0e500187331      brasl   %r14,00000000b08fa990
                             00000000b05ec334: a7f4ff0c          brc     15,00000000b05ec14c
                            #00000000b05ec338: af000000          mc      0,0
                            >00000000b05ec33c: ec76fed8007c      cgij    %r7,0,6,00000000b05ec0ec
                             00000000b05ec342: e310f0b00004      lg      %r1,176(%r15)
                             00000000b05ec348: ec16ffac007c      cgij    %r1,0,6,00000000b05ec2a0
                             00000000b05ec34e: ec680388007c      cgij    %r6,0,8,00000000b05eca5e
                             00000000b05ec354: e310f0b80004      lg      %r1,184(%r15)
   [    8.532600] Call Trace:
   [    8.532604]  [<00000000b05ec33c>] __netif_set_xps_queue+0x3dc/0xca8
   [    8.532609] ([<00000000b05ec0c2>] __netif_set_xps_queue+0x162/0xca8)
   [    8.532614]  [<000003ff7fbb81ce>] virtnet_set_affinity+0x1de/0x2a0 [virtio_net]
   [    8.532622]  [<000003ff7fbbb674>] virtnet_probe+0x4d4/0xc08 [virtio_net]
   [    8.532630]  [<00000000b04ec4e8>] virtio_dev_probe+0x1e8/0x418
   [    8.532638]  [<00000000b05350ea>] really_probe+0xd2/0x480
   [    8.532644]  [<00000000b0535648>] driver_probe_device+0x40/0xf0
   [    8.532649]  [<00000000b0535fac>] __driver_attach+0x10c/0x208
   [    8.532655]  [<00000000b0532542>] bus_for_each_dev+0x82/0xb8
   [    8.532662]  [<00000000b053422e>] bus_add_driver+0x1d6/0x260
   [    8.532667]  [<00000000b0536a70>] driver_register+0xa8/0x170
   [    8.532672]  [<000003ff7fbc8088>] virtio_net_driver_init+0x88/0x1000 [virtio_net]
   [    8.532680]  [<00000000afb50ab0>] do_one_initcall+0x78/0x388
   [    8.532685]  [<00000000afc7b5b8>] do_init_module+0x60/0x248
   [    8.532692]  [<00000000afc7ce96>] __do_sys_init_module+0xbe/0xd8
   [    8.532698]  [<00000000b09123b2>] __do_syscall+0x1da/0x208
   [    8.532704]  [<00000000b0925b12>] system_call+0x82/0xb0
   [    8.532710] 3 locks held by systemd-udevd/377:
   [    8.532715]  #0: 0000000089af5188 (&dev->mutex){....}-{3:3}, at: __driver_attach+0xfe/0x208
   [    8.532728]  #1: 00000000b14668f0 (cpu_hotplug_lock){++++}-{0:0}, at: virtnet_probe+0x4ca/0xc08 [virtio_net]
   [    8.532744]  #2: 00000000b1509d40 (xps_map_mutex){+.+.}-{3:3}, at: __netif_set_xps_queue+0x88/0xca8
   [    8.532757] Last Breaking-Event-Address:
   [    8.532760]  [<00000000b05ec0e0>] __netif_set_xps_queue+0x180/0xca8
