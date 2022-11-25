Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B2E638BD0
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 15:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKYOFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 09:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKYOFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 09:05:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C0F1EC48
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669385138; x=1700921138;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8zVbPwg1NkkBR46g/f1+N612R66gZrujW5VyehyyK1E=;
  b=bRCAjjH7kvw4rFcPWs8NSGh7njLQXpxI450nCR1Q66R7O4yOuvxFFd/d
   MO4eWJ3qPp0NX9bfV77n6epRBlFI+zcwDacNXOzHAnqM1KvAI3gzyrANg
   Ao4HG8Y43MgqtERqNSVkZBRwjRNlXyAmxCBVcnchFbfoDALHpexxEb5Ls
   Uw1JWGMU5pmCY1zjhu1gq/FfgSApKsTHV2OzOB5aP8zq1+sIW8On/lp6g
   4sjfY9MpipZ2zPf7V3ZxwfTCnBrUZAHEgEKQQ9n/Wyy0BAWQR/X+gFXTl
   HclMa9GL8n3c0U6+Vs/CPfu5+60VYuIbc0NIUtGHn5jVakj55kHUgx4ur
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="302059599"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="302059599"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 06:05:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="971580620"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="971580620"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 25 Nov 2022 06:05:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 06:05:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 06:05:37 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 06:05:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlArbESkm4PDeLUYgJxyHwJEVpeV0lHg0Aup6mktJOiZghrXC/iCwJP1SzJVCCl8HZCyadV5z5g75+57JrEuJJ5ujCfvPdn7aaK0JNdQpkevYrG5RGvvqLlT6BSSBCkThtaWJqwFsSM5mizSeC381FDjmfA1loZsfwwxeLlGdXpUjEPRHx6tiRWvetFuZ+KqscreGagK/Px+xKiNKcC0tpGYvBnpakhgHKgeSF2ijdCyhOBLvsHnF9QtcqJJQhIeaQ4hR8apRbmxpzUsnNvufaX7EuVsjMqFuEJHuBjWgXQMOiOb+pVsb6T1PNiXAkJMCyEGJF9nqAYswe85RI1IpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASaeS3WUKfmGUiPIVuP/KcS8aQZ/clCDqNlhMuioMYY=;
 b=Dvt9yBoWz/WpNrqw4ezJssfz82Sn0loSnf/L4T7sQ1F/dKJmRfPhjIXjaZvmGku8ci1sJLW/h/KLrjtbF7wqR40+cWRsivtFlrHWZFFOkQXdZnCFZTPdJlYRva9FIhmrDEaD9PdbXe7uHZyIgfvG9XT9m83DhwnuUSbAyG7BqCqZVTgh0HdOb/VQDb8ts2WdRPuzNRq9WN1dsG74fBygb1lNTMYDN1/9x8hN0LrPSGOMPwr2CyULoPHWZbey5yiyIVmu97gXgCfGfZlgIVt2gw4goL5l92YQ9IrpsNxeNVcB8uRIPURbaxwA2d0wqKZSXWp2FiabAOWfFY1Bx8Ra9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6855.namprd11.prod.outlook.com (2603:10b6:510:22c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 14:05:35 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 14:05:34 +0000
Message-ID: <f73ee554-807b-0123-bd93-3e3ba24feaaf@intel.com>
Date:   Fri, 25 Nov 2022 22:06:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and
 _last_close()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <eric.auger@redhat.com>, <cohuck@redhat.com>,
        <nicolinc@nvidia.com>, <yi.y.sun@linux.intel.com>,
        <chao.p.peng@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-9-yi.l.liu@intel.com> <Y3+GHbf4EkvyqukE@nvidia.com>
 <955100c9-970a-71a0-8b80-c24d7dbb35f2@intel.com>
 <Y4C28lraaKU1v8NE@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y4C28lraaKU1v8NE@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0163.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH8PR11MB6855:EE_
X-MS-Office365-Filtering-Correlation-Id: e18a4bf9-8556-4b85-f6a3-08daceee1f24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JG+wdNo3exEYP0r3sFfpne7ut+WP7ICFP66z130vE/RSIhcqndtosCokKxviixAgrLuSwHEact9zpIMAYJwQJ4SjFWIyyUgaQmrnjfdFe3KHe8p6oXWErg6vuiG/C/LYS3ZJerM6N1Cs5jAI8nfyCZFJ/uGK8rJFgsui7+muBCNeSZyj0n8MpvGfT/wC/XqAeIeCgRpqPtoW7zsQP1krP9bQomQE47zHtpGLkd/LJQ7WE6Sa+0cg7KyHzkuZRqkWKfj7G2DL7dgr+Nl/+hFaIvE8YHYZkJk0PtNw39iY9sdENQCH9JaqabMkyfuuJgvJO9k46eXuhGix/FWHves0EM1jjJcQwGo8y/LQSoeDC8+LPkwUS1f/eQwmv1sXFzlu2WB1knoQZ1TOUFoNlo/ThX6ImR0I6zWZLj8m+/CjTXkXfk6eT4jiGKxPBjnRt0Pkz9STVe2cSJSXyoI3WdxgMnw+Dn2UfxjFMaVWY4wOwphlE47yppStATRubsu7hHoGU7aT9W060s/Nlk0gfG9WYAZL9mQIx3pgOYmbpm4+JBHUvGbm33QRPkjRRRDIS6iHZxRenWW/QkGKIA5O7fTByz1yK5VQGBV/ELgtYUxVGuNNiUUqKUZ2evEDRGb5BPjqjjyuw2gG5XdR8e2QidNntvW4VlQX/gyBX0QSOBfj69KaLR7ghEkPfezBVXidhjXcHGhe74CWoamJnS5byakgl7/E34wH34pukhPfKD0pW0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(136003)(396003)(39860400002)(451199015)(2906002)(26005)(31686004)(36756003)(8936002)(83380400001)(5660300002)(31696002)(41300700001)(2616005)(186003)(86362001)(66476007)(66556008)(8676002)(4326008)(66946007)(6512007)(6506007)(6666004)(53546011)(478600001)(316002)(6916009)(6486002)(38100700002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3hQN0sxZlZReElaaEVSSnZkUWVqYVBrekdrMzdaMHdOMFRha2YxcStHZ01U?=
 =?utf-8?B?TTZ2RENFRE5YY3FHaFpySk8zM2JDSzcyV0h6RE9VUDA4T2FiYlFERXRqNlR4?=
 =?utf-8?B?LzNvRDQ1dzl3NUo5ZWFFeUhsQjdMdVlnUnBwSkhxamJ1eUZkbHYyZUNlWmlX?=
 =?utf-8?B?TlYvaTBJUm55YUV0R2NSVk91YWlEMkE4THQ3OTZoY1U1WDd0S3hSUE9HWUd3?=
 =?utf-8?B?R1B2a0lZc1FKRVZWT3E3M3IveWpIekJjcTZIUk8zMW9rSnNwd3dSaWlGVk9O?=
 =?utf-8?B?MkhyTWJJSGpFUG8yMHM5VmJYRE1rL0Z4Si9oNzFMYklBbWw0QWxpZGdMS3dC?=
 =?utf-8?B?RW9ZUW9HdGkwaDIvbDBPam9ob0IwS1huZmh6aEVCR292eVhBaEdqYnJmR05H?=
 =?utf-8?B?YllneG9zQkVSL1JyV2F1ZE9zMCt3ai9YeHVVWDh3em40eS9KN093NmdZUlNz?=
 =?utf-8?B?WkhjOVN0dDNSM3N4eWhIaWxneGVTZ2J4OGVGdlRUNC9qTFlRaFMyM0FNU1JF?=
 =?utf-8?B?ZStKd3Ryc2kvczk3S2Z3NGZPVmEvblJKREt5OWJ3dlowYjAwUk0zcjh1T2hZ?=
 =?utf-8?B?UDBBWTdmRVFUcmRzWDZRRWwvdnhZMlBScnVBNHVtdHFwdnF1dnc4ZFczbm1o?=
 =?utf-8?B?UUFyQUtCNW9uVkpJZmpaMFlhZGNIVG9DcWxwUUovTGRCdXhkbzkzRXQxRjhy?=
 =?utf-8?B?NUNHUVU2cVNieTg5ckkvcENmdkg3aS9PMHduOGZOWnp4T0FrMmtxWUVOOG5Y?=
 =?utf-8?B?VnpodW5FcllwUGVQaWd4bVk1QjJDT2puOW9MZmhVZ0lmT3dCN3d0VHV3Tlg5?=
 =?utf-8?B?S29yRUVkWEs1aTVpRWhyNkRWaFZPNkxZbmxYZFJsOE9HTFphQURaOUhET2tM?=
 =?utf-8?B?VEtpZ0VmRnpFa1dhZkw0NVoxYno4UEpFc0dXa1VYZHNHZFVsQnY2N1FTY0dl?=
 =?utf-8?B?SGNvYUJIL1A3WWp1TTRmTDFuV2JCUkJzZlBrYXhyd2hxcTV3NUk2UDJ3c2RQ?=
 =?utf-8?B?N0FTYnljZUxkNDdHQXRZMURTYUZTWDg4QTN2NUYrL2YwalBJRXN5TlpJamFs?=
 =?utf-8?B?ZldrVjA4NXRVYkFUcFlDTXRQWWFLVFA1UndrbkZ4ZFhibmxtNkJIK3R6NHlF?=
 =?utf-8?B?eGNQT3IwZEt2NWIrUlpOUkFlWGRZd1RoRjk5YWV4S0FxSDhRRXoxeUVFUTZ6?=
 =?utf-8?B?Rk5oOUFyNHZQeGUvVi8rS3lsdGFtUkVaK2NGclVzbU1kQ29ZcHcxcHJ3VHlE?=
 =?utf-8?B?alZDL1ltK01Fd2JJKzdRVWFWMnZaL3hyRllFeDJSeHlSeklFR3lnQ2NkT3VN?=
 =?utf-8?B?dStKdlMvdXRoVnA3SzRvRkx6eTBPdFNka2pQMlhMa2p3WTZTNDJFejZqVnhS?=
 =?utf-8?B?UWFvK2xVYXM4NzZNc3BDMm5GT3BLNXo2dmVHR1d2cDFWTGUvMUxKYktOZTA3?=
 =?utf-8?B?dlZ1d1oxSU52NFE5RGFnMGFJYUNTVDhGUnR5dFpHNHVpTWpKU3dQUTdCYjdM?=
 =?utf-8?B?aFAwbWV2N1FmQjNON0xhM21GcFBxemlDalYzRG9ib0VGcmVBVjYvV3pkVWxF?=
 =?utf-8?B?VmU5L0p1cEFlTGw4L1dpM045cTJPOGhHNnRBMVlqd01MUnM5R0xKaCt6bGh6?=
 =?utf-8?B?cHZwS05Ka2FDdlplLzhDa0JwRXlMaVdpMlB3bnlIOXJWeWY1TCtVV3pTbk5j?=
 =?utf-8?B?Tmk1MzNGZ1ZHMkxrZk9hcXVBU0IweDNuaFhkc29nWmxoNHBZWlRMRFhrV3cy?=
 =?utf-8?B?SDhqT3ozbURZckhtRU5OaGxhQkErTHVOUkI4ZnovSVZhY0JrelpsaEkyNnJm?=
 =?utf-8?B?QjZRak9lbEhxZkdGblZuRUkvVGFKWmxORTBCNERJODl4SlU1L1A5VDVHMzMr?=
 =?utf-8?B?cUxjOG9SOXdVMGFzanJjYW9XaGZ3RFNGZXlsenpxaTFmYmlQT21uZDRsb3No?=
 =?utf-8?B?Z0U5ai9SNThRVjE3LzliVFlnaDBHVm41Wk1WN3FxRUlZdC9QeTBneW5YWHJZ?=
 =?utf-8?B?NW9tM0lZSXN6anVJQTdzbTdFWVQzYkZOaUpaQ0JyYkw4RWszNVp2WHhYbHNu?=
 =?utf-8?B?UEQveUgwL0xJRmRPZWROWFZxRlViK1lGM1ZEc0JEaTdvekZSbXZIMmlMR011?=
 =?utf-8?Q?g4cpZzNyJb0UyDYOCNv8f5OHg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e18a4bf9-8556-4b85-f6a3-08daceee1f24
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 14:05:34.7651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBFyPMytCc9kNLK03ma6aQtfeHkrFUI6ASzCwZrJ5HDGj5Agx5OFvOpnZCOuASxxooOhhwMxNo8loeM/bmy15g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6855
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/25 20:37, Jason Gunthorpe wrote:
> On Fri, Nov 25, 2022 at 04:57:27PM +0800, Yi Liu wrote:
> 
>>> +static int vfio_device_group_open(struct vfio_device *device)
>>> +{
>>> +	int ret;
>>> +
>>> +	mutex_lock(&device->group->group_lock);
>>
>> now the group path holds group_lock first, and then device_set->lock.
>> this is different with existing code. is it acceptable? I had a quick
>> check with this change, basic test is good. no a-b-b-a locking issue.
> 
> I looked for a while and couldn't find a reason why it wouldn't be OK

ok, so updated this commit as below:

 From dd236de34a4f736041456fb46bd4a5eab360681b Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Wed, 2 Nov 2022 04:42:25 -0700
Subject: [PATCH 08/11] vfio: Refactor vfio_device_open/close()

With this refactor, vfio_device_open/close() is the common code to open
device for the current group path, and also the future vfio device cdev
path. It calls the vfio_device_first_open() and _last_close() to handle
the legacy container path and the compat iommufd path.

Current caller of vfio_device_open/close() are vfio_device_group_open
and vfio_device_group_close(). They take care of group_lock, iommufd_ctx
pointer and also kvm pointer.

Future caller in the vfio device cdev path just need to care about the
iommufd_ctx pointer and kvm pointer. This is not part of this commit.

This prepares for moving group specific code out of vfio_main.c and also
compiling out the group infrastructure in future.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
  drivers/vfio/vfio_main.c | 133 +++++++++++++++++++++++++--------------
  1 file changed, 87 insertions(+), 46 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6898a492acc0..b49c48f3bcc8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -772,7 +772,38 @@ static bool vfio_assert_device_open(struct vfio_device 
*device)
  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
  }

-static int vfio_device_first_open(struct vfio_device *device)
+static int vfio_device_group_use_iommu(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+	int ret = 0;
+
+	lockdep_assert_held(&group->group_lock);
+
+	if (WARN_ON(!group->container))
+		return -EINVAL;
+
+	ret = vfio_group_use_container(group);
+	if (ret)
+		return ret;
+	vfio_device_container_register(device);
+	return 0;
+}
+
+static void vfio_device_group_unuse_iommu(struct vfio_device *device)
+{
+	struct vfio_group *group = device->group;
+
+	lockdep_assert_held(&group->group_lock);
+
+	if (WARN_ON(!group->container))
+		return;
+
+	vfio_device_container_unregister(device);
+	vfio_group_unuse_container(group);
+}
+
+static int vfio_device_first_open(struct vfio_device *device,
+				  struct iommufd_ctx *iommufd, struct kvm *kvm)
  {
  	int ret;

@@ -781,77 +812,56 @@ static int vfio_device_first_open(struct vfio_device 
*device)
  	if (!try_module_get(device->dev->driver->owner))
  		return -ENODEV;

-	/*
-	 * Here we pass the KVM pointer with the group under the lock.  If the
-	 * device driver will use it, it must obtain a reference and release it
-	 * during close_device.
-	 */
-	mutex_lock(&device->group->group_lock);
-	if (!vfio_group_has_iommu(device->group)) {
-		ret = -EINVAL;
+	if (iommufd)
+		ret = vfio_iommufd_bind(device, iommufd);
+	else
+		ret = vfio_device_group_use_iommu(device);
+	if (ret)
  		goto err_module_put;
-	}

-	if (device->group->container) {
-		ret = vfio_group_use_container(device->group);
-		if (ret)
-			goto err_module_put;
-		vfio_device_container_register(device);
-	} else if (device->group->iommufd) {
-		ret = vfio_iommufd_bind(device, device->group->iommufd);
-		if (ret)
-			goto err_module_put;
-	}
-
-	device->kvm = device->group->kvm;
+	device->kvm = kvm;
  	if (device->ops->open_device) {
  		ret = device->ops->open_device(device);
  		if (ret)
-			goto err_container;
+			goto err_unuse_iommu;
  	}
-	mutex_unlock(&device->group->group_lock);
  	return 0;

-err_container:
+err_unuse_iommu:
  	device->kvm = NULL;
-	if (device->group->container) {
-		vfio_device_container_unregister(device);
-		vfio_group_unuse_container(device->group);
-	} else if (device->group->iommufd) {
+	if (iommufd)
  		vfio_iommufd_unbind(device);
-	}
+	else
+		vfio_device_group_unuse_iommu(device);
  err_module_put:
-	mutex_unlock(&device->group->group_lock);
  	module_put(device->dev->driver->owner);
  	return ret;
  }

-static void vfio_device_last_close(struct vfio_device *device)
+static void vfio_device_last_close(struct vfio_device *device,
+				   struct iommufd_ctx *iommufd)
  {
  	lockdep_assert_held(&device->dev_set->lock);

-	mutex_lock(&device->group->group_lock);
  	if (device->ops->close_device)
  		device->ops->close_device(device);
  	device->kvm = NULL;
-	if (device->group->container) {
-		vfio_device_container_unregister(device);
-		vfio_group_unuse_container(device->group);
-	} else if (device->group->iommufd) {
+	if (iommufd)
  		vfio_iommufd_unbind(device);
-	}
-	mutex_unlock(&device->group->group_lock);
+	else
+		vfio_device_group_unuse_iommu(device);
  	module_put(device->dev->driver->owner);
  }

-static int vfio_device_open(struct vfio_device *device)
+static int vfio_device_open(struct vfio_device *device,
+			    struct iommufd_ctx *iommufd, struct kvm *kvm)
  {
  	int ret = 0;

  	mutex_lock(&device->dev_set->lock);
  	device->open_count++;
  	if (device->open_count == 1) {
-		ret = vfio_device_first_open(device);
+		ret = vfio_device_first_open(device, iommufd, kvm);
  		if (ret)
  			device->open_count--;
  	}
@@ -860,22 +870,53 @@ static int vfio_device_open(struct vfio_device *device)
  	return ret;
  }

-static void vfio_device_close(struct vfio_device *device)
+static void vfio_device_close(struct vfio_device *device,
+			      struct iommufd_ctx *iommufd)
  {
  	mutex_lock(&device->dev_set->lock);
  	vfio_assert_device_open(device);
  	if (device->open_count == 1)
-		vfio_device_last_close(device);
+		vfio_device_last_close(device, iommufd);
  	device->open_count--;
  	mutex_unlock(&device->dev_set->lock);
  }

+static int vfio_device_group_open(struct vfio_device *device)
+{
+	int ret;
+
+	mutex_lock(&device->group->group_lock);
+	if (!vfio_group_has_iommu(device->group)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * Here we pass the KVM pointer with the group under the lock.  If the
+	 * device driver will use it, it must obtain a reference and release it
+	 * during close_device.
+	 */
+	ret = vfio_device_open(device, device->group->iommufd,
+			       device->group->kvm);
+
+out_unlock:
+	mutex_unlock(&device->group->group_lock);
+	return ret;
+}
+
+static void vfio_device_group_close(struct vfio_device *device)
+{
+	mutex_lock(&device->group->group_lock);
+	vfio_device_close(device, device->group->iommufd);
+	mutex_unlock(&device->group->group_lock);
+}
+
  static struct file *vfio_device_open_file(struct vfio_device *device)
  {
  	struct file *filep;
  	int ret;

-	ret = vfio_device_open(device);
+	ret = vfio_device_group_open(device);
  	if (ret)
  		goto err_out;

@@ -904,7 +945,7 @@ static struct file *vfio_device_open_file(struct 
vfio_device *device)
  	return filep;

  err_close_device:
-	vfio_device_close(device);
+	vfio_device_group_close(device);
  err_out:
  	return ERR_PTR(ret);
  }
@@ -1120,7 +1161,7 @@ static int vfio_device_fops_release(struct inode 
*inode, struct file *filep)
  {
  	struct vfio_device *device = filep->private_data;

-	vfio_device_close(device);
+	vfio_device_group_close(device);

  	vfio_device_put_registration(device);

-- 
2.34.1



-- 
Regards,
Yi Liu
