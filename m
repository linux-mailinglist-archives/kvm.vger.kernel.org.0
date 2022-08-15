Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E3B593269
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 17:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiHOPrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 11:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiHOPqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 11:46:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5DABCE
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 08:46:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEcjQFeXJ6Vk6xtU5Mpc5ZaBjBzaOLscHHDhOxL8/xLUVHL6Ywj2NHqxdkVVfxyjJz4IScPcpD9zUmW+4Zap6JYs5NjLiKZ/FwMPj0l8duu2KuWEzTfnIHnrj+tPfSreMN1oMXZCytIi/cRRnJlTnIDZ8yolFt3v/mt+BXLiJECAQHdhJDkPNElGa6fZHhG3EIO/v29qeu2nSgnU/hbHI8x2wVowIKNjZDKr1/Ys2usYjToSEpJ5syx2t69+B3wN/5CeXo82Q5E+VfhKcIjpfvrzA+z0j/MQHnBXE6ZqcAhzZkmUhMQpzeEAvFyJzUCL1wS15Wc2X+spBJy10CW9uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hhvrfceAeOA50ZIoMBeOtDIcYWm+dYRAI65+hW5Qug=;
 b=TjGN0u4feldsizou15UmKLopyb6IEmobTigUzM2POwlKI2hfJMsupt76UXvP42njfin4Mr2mtriRAAAswNuwgxA0x5QcCLkoEXXKK4uCYcCE0yCYcRnMzG2kejCEbFHLLKuncbDUh5MIVUlC7uwDnxr023WdGN7/m9z9PZI6UBRiuuUdj7N1ogdebv5E+8iqVAMXxGaK+6pqS2KeoDnrnxWlFsK1Mo58MhHRV02yYjkbSdZKUSsssWe4KDHxGZmWVCBM+CnFj/S2m1UKtd76OusT60PhVvt/ggdxGbUDpx7X1CAEu8mgCWqSlTDC8pqg7r2sxxe5mJDqj9ZNATZWGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hhvrfceAeOA50ZIoMBeOtDIcYWm+dYRAI65+hW5Qug=;
 b=ANldXUZIyGUfn/448ogCIL5XGTocKYir5GnXioeFsRDCQrU8jZ3eRIwc6HNPbSp17tq2CnoIzu1DXYYz9F8NlQWFBPzDZn3dOaX8iOyQGst31sM8TUb3O5R3AcM5Jt1pN3NRBd/Wu2gGj9fxs2BvjAxtgNyLd0x7MQzqpbtTYXGqd1fPpVhUW5kyds2cOIbijcX8RREmtmSB5yaM0FQPgFhoYTAxuar2PPY5ElaPvCikYJoZPwLW7Za2JkFlE4h2xcW5xaBg8rBEFygXFmxpvIwWsZg7UKU9oShk6AuGudmSdmHxhSMDszPyWRdFPm4pP5HwkCfHdVsn2C03AoP1pw==
Received: from DM6PR03CA0087.namprd03.prod.outlook.com (2603:10b6:5:333::20)
 by MWHPR12MB1600.namprd12.prod.outlook.com (2603:10b6:301:f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Mon, 15 Aug
 2022 15:46:47 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::c7) by DM6PR03CA0087.outlook.office365.com
 (2603:10b6:5:333::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.18 via Frontend
 Transport; Mon, 15 Aug 2022 15:46:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Mon, 15 Aug 2022 15:46:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 15 Aug
 2022 15:46:46 +0000
Received: from [172.27.11.227] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 15 Aug
 2022 08:46:43 -0700
Message-ID: <0e8a0d16-3c6f-a649-44b3-ab960801d90f@nvidia.com>
Date:   Mon, 15 Aug 2022 18:46:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Bug report: vfio over kernel 5.19 - mm area
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, <alex.sierra@amd.com>
CC:     <akpm@linux-foundation.org>, jason Gunthorpe <jgg@nvidia.com>,
        "maor Gottlieb" <maorg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, <idok@nvidia.com>,
        <linux-mm@kvack.org>
References: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
 <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
 <20220615080228.7a5e7552.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220615080228.7a5e7552.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd17533c-3a3b-49c0-1e86-08da7ed55c7c
X-MS-TrafficTypeDiagnostic: MWHPR12MB1600:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WS8rNmx5eUs2S0pmVDZNNUFQUTRCZEEra3NCV3JCNm5zTzBnRTgxK3IxY084?=
 =?utf-8?B?dm9BaTQ3SkFHNGJyUDFUV2ZyblZoU2x4UXlqak5vczZwaU94aUJhNDZ4aUFx?=
 =?utf-8?B?enppTUR2VC94MHZwb3ErbmRsYkNpUXAxdnE3U2FOYWtMb0l6eEF2aHJDUEtJ?=
 =?utf-8?B?R001RUNua2R5MWoyOWJoRHN3bVJkSCtmbG8vRDlQZ0NIQjhScHpxZFZka1lQ?=
 =?utf-8?B?M1NuVUZSVjJqT3BmNmZ0bUZPbHQxWDBKWTNVclloYjI3Y0JkT0oyWFZTRlZD?=
 =?utf-8?B?aU1zWDBORTNDQzdYd3RyUGR0aWZDL1BiNHBOWm9QaHV2Wk1HV2MvNFFZY3g2?=
 =?utf-8?B?cW5uRm1WTWJHWmVwdVdDMnM2ZHdLYXFJa3JGczNDRVRYWVNjcFNGVUlBdTZE?=
 =?utf-8?B?NFJTZklIVk53elBzR3VzTkVrQ1RzQ3Rwa1RzbytIMHo2R1M2aFRFSCthM0Y4?=
 =?utf-8?B?YlBPM3R1Um5pNTBDa1NjLzBYblN3NEpWMHpYb3BDV01Nck5JN3A1ZVV4WjNR?=
 =?utf-8?B?L09CSks4K1dqY2t5SnNKellDS0tNWDJWU2JKejl0dFpLUkdTNVV4Z3cvd1ps?=
 =?utf-8?B?RW5wWlRSTFVnV1NlUmFKUUdEWWpMR3pCVFU2VGt5elFzY3UrQjZkUjVvYytM?=
 =?utf-8?B?bTRKYlU1Q0lhdVlrRVlQSEM1SkZlbHVKWkl1K05xY1Fma0wzWEs0UHB5T1Vi?=
 =?utf-8?B?VWxGLzBzaG1FVFBiQ2ZYQmhJTXNLclMvRnZlbjJmM2Znb3JYdEthenFsUGtX?=
 =?utf-8?B?bDQ2dGlwQktqaWQraFR2aDBKdVB3Q0hhSXJucCtsV0xIUWxqRDA5d3QvT3d0?=
 =?utf-8?B?bk5Ra2dRd051a29LYkZacDFaVjZVcllVZ3craVplQWNqS01FZmp5VTJQMTFn?=
 =?utf-8?B?anMvMi9GZHhDRlUwcEF0WW1oZzV6OUZrN3VnUEJuc1dWSjlBMWlPL0M4QWpz?=
 =?utf-8?B?KzRGWStFekdZUUVQaHVqR3I3L2JaWk5UYUVGcEdRcitsVUI3WHJ3MWoyOTZz?=
 =?utf-8?B?QUgxUThTdGtWclB4WWl6SFQwTUttNmY0L01yVGFUbUdQaDNMZHEwYlllbW9y?=
 =?utf-8?B?U1JtanRycCt4eG9lQ3VPM3BVMTFaTFlmV3YwcHZHUXNWd1gvWGZUNFFRbEht?=
 =?utf-8?B?a2lYZW5xNDduRDBTQURTSUl4bGxaTGQyS3c1RGtpMU1nT2pBVWpNcUZneS84?=
 =?utf-8?B?Mlo4RTh2dGdxSzNPMTd2MWxjU3pZcmNJb1JKc1JScEJEeVI5eG1qZkFyY0NY?=
 =?utf-8?B?TjZwWXRsNG1mdXFTUHlIMGFwMVN4TXhpTjcrem5IZy9IVys5bVF1R1pGSEtX?=
 =?utf-8?B?V0VkSkZqeUpPT2ZLY0JHVzczUUlyNXJ0SFNHaEhsYmhNZi9JN0szZ3plVWxt?=
 =?utf-8?B?SnhxOUtIcTR6VXc9PQ==?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(346002)(376002)(40470700004)(46966006)(36840700001)(4326008)(70586007)(70206006)(2616005)(53546011)(26005)(16576012)(316002)(8676002)(83380400001)(31686004)(336012)(426003)(47076005)(186003)(16526019)(36756003)(5660300002)(2906002)(81166007)(356005)(86362001)(82740400003)(31696002)(40480700001)(8936002)(478600001)(966005)(41300700001)(110136005)(54906003)(36860700001)(82310400005)(40460700003)(36900700001)(43740500002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 15:46:46.9712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd17533c-3a3b-49c0-1e86-08da7ed55c7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1600
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/2022 17:02, Alex Williamson wrote:
> On Wed, 15 Jun 2022 13:52:10 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Adding some extra relevant people from the MM area.
>>
>> On 15/06/2022 13:43, Yishai Hadas wrote:
>>> Hi All,
>>>
>>> Any idea what could cause the below break in 5.19 ? we run QEMU and
>>> immediately the machine is stuck.
>>>
>>> Once I run, echo l > /proc/sysrq-trigger could see the below task
>>> which seems to be stuck..
>>>
>>> This basic flow worked fine in 5.18.
> Spent Friday bisecting this and posted this fix:
>
> https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen/
>
> I expect you're hotting the same.  Thanks,
>
> Alex

Alex,

It seems that we got the same bug again in V6.0 RC1 ..

The below code [1] from commit [2], put back the 'is_zero_pfn()' under 
the !(..) and seems buggy.

I would expect the below fix for that [3].

Alex Sierra,

Can you please review the below suggested fix for your patch and send a 
patch for RC2 accordingly ?

Yishai

[1]

See: 
https://elixir.bootlin.com/linux/v6.0-rc1/source/include/linux/mm.h#L1549

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a2d01e49253b..64393ed3330a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -28,6 +28,7 @@
  #include <linux/sched.h>
  #include <linux/pgtable.h>
  #include <linux/kasan.h>
+#include <linux/memremap.h>

  struct mempolicy;
  struct anon_vma;
@@ -1537,7 +1538,9 @@ static inline bool 
is_longterm_pinnable_page(struct page *page)
         if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
                 return false;
  #endif
-       return !is_zone_movable_page(page) || 
is_zero_pfn(page_to_pfn(page));
+       return !(is_device_coherent_page(page) ||
+                is_zone_movable_page(page) ||
+                is_zero_pfn(page_to_pfn(page)));
  }

[2] f25cbb7a95a24ff9a2a3bebd308e303942ae6b2c
Author: Alex Sierra <alex.sierra@amd.com>
Date:   Fri Jul 15 10:05:10 2022 -0500

     mm: add zone device coherent type memory support


[3] Expected fix

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3bedc449c14d..b25f9886bd4c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1544,9 +1544,9 @@ static inline bool 
is_longterm_pinnable_page(struct page *page)
         if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
                 return false;
  #endif
-       return !(is_device_coherent_page(page) ||
-                is_zone_movable_page(page) ||
-                is_zero_pfn(page_to_pfn(page)));
+       return !is_device_coherent_page(page) ||
+              !is_zone_movable_page(page) ||
+              is_zero_pfn(page_to_pfn(page));
  }
  #else
  static inline bool is_longterm_pinnable_page(struct page *page)


>>> [1162.056583] NMI backtrace for cpu 4
>>> [ 1162.056585] CPU: 4 PID: 1979 Comm: qemu-system-x86 Not tainted
>>> 5.19.0-rc1 #747
>>> [ 1162.056587] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>>> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>>> [ 1162.056588] RIP: 0010:pmd_huge+0x0/0x20
>>> [ 1162.056592] Code: 49 89 44 24 28 48 8b 47 30 49 89 44 24 30 31 c0
>>> 41 5c c3 5b b8 01 00 00 00 5d 41 5c c3 cc cc cc cc cc cc cc cc cc cc
>>> cc cc cc <0f> 1f 44 00 00 31 c0 48 f7 c7 9f ff ff ff 74 0f 81 e7 81 00
>>> 00 00
>>> [ 1162.056594] RSP: 0018:ffff888146253b38 EFLAGS: 00000202
>>> [ 1162.056596] RAX: ffff888101461980 RBX: ffff888146253bc0 RCX:
>>> 000ffffffffff000
>>> [ 1162.056597] RDX: ffff88814fa22000 RSI: 00007f9f68231000 RDI:
>>> 000000010a6b6067
>>> [ 1162.056598] RBP: ffff888111b90dc0 R08: 000000000002f424 R09:
>>> 0000000000000001
>>> [ 1162.056599] R10: ffffffff825c2a40 R11: 0000000000000a08 R12:
>>> ffff88814fa22a08
>>> [ 1162.056600] R13: 000000010a6b6067 R14: 0000000000052202 R15:
>>> 00007f9f68231000
>>> [ 1162.056602] FS:  00007f9f6c228c40(0000) GS:ffff88885f900000(0000)
>>> knlGS:0000000000000000
>>> [ 1162.056605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 1162.056606] CR2: 00005643994fd0ed CR3: 00000001496da005 CR4:
>>> 0000000000372ea0
>>> [ 1162.056607] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000
>>> [ 1162.056609] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>> 0000000000000400
>>> [ 1162.056610] Call Trace:
>>> [ 1162.056611]  <TASK>
>>> [ 1162.056611]  follow_page_mask+0x196/0x5e0
>>> [ 1162.056615]  __get_user_pages+0x190/0x5d0
>>> [ 1162.056617]  ? flush_workqueue_prep_pwqs+0x110/0x110
>>> [ 1162.056620]  __gup_longterm_locked+0xaf/0x470
>>> [ 1162.056624]  vaddr_get_pfns+0x8e/0x240 [vfio_iommu_type1]
>>> [ 1162.056628]  ? qi_flush_iotlb+0x83/0xa0
>>> [ 1162.056631]  vfio_pin_pages_remote+0x326/0x460 [vfio_iommu_type1]
>>> [ 1162.056634]  vfio_iommu_type1_ioctl+0x421/0x14f0 [vfio_iommu_type1]
>>> [ 1162.056638]  __x64_sys_ioctl+0x3e4/0x8e0
>>> [ 1162.056641]  do_syscall_64+0x3d/0x90
>>> [ 1162.056644]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>> [ 1162.056646] RIP: 0033:0x7f9f6d14317b
>>> [ 1162.056648] Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00
>>> 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00
>>> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89
>>> 01 48
>>> [ 1162.056650] RSP: 002b:00007fff4fca15b8 EFLAGS: 00000246 ORIG_RAX:
>>> 0000000000000010
>>> [ 1162.056652] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
>>> 00007f9f6d14317b
>>> [ 1162.056653] RDX: 00007fff4fca1620 RSI: 0000000000003b71 RDI:
>>> 000000000000001c
>>> [ 1162.056654] RBP: 00007fff4fca1650 R08: 0000000000000001 R09:
>>> 0000000000000000
>>> [ 1162.056655] R10: 0000000100000000 R11: 0000000000000246 R12:
>>> 0000000000000000
>>> [ 1162.056656] R13: 0000000000000000 R14: 0000000000000000 R15:
>>> 0000000000000000
>>> [ 1162.056657]  </TASK>
>>>
>>> Yishai
>>>   


