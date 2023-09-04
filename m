Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3308791494
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352631AbjIDJPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352614AbjIDJPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:15:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C5E18D;
        Mon,  4 Sep 2023 02:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693818940; x=1725354940;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nxkhT4+4t7jbXoKiS7wLgVY8shFlwhFn1M1EN7TDhwc=;
  b=kQvuKdB5CI+fo43tIZshuklJvJsxc1hcMY3cGMCVPmtS1KJ9B1hzSLtO
   /BDMuFI+SuhQ36UY6YvsMLnmjPxPhom/iMxrViqGPcxxC5A9nbvw/oJ+W
   OSFYLNuGH+YXDhH06f/rj9aRd60stjP9DE8s1FPiyLcx4MqMoOFAACB7e
   uHN6zdTzFLtQ3BfkUWnlacYmF5rV9WN9kyNnptwR9r6t9HGnr1+ZB2Gs9
   ebsH79JIFRMKuar2bzyQ8SEM+8D08wamHt3qLEVLYknt9h4b0ZODyjvLM
   OLF9HPxUE9CzLYQ3tXSqxWfSLJarMdgAflawS6974npRlQaxpdIIkZhkY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="407554769"
X-IronPort-AV: E=Sophos;i="6.02,226,1688454000"; 
   d="scan'208";a="407554769"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 02:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="864268363"
X-IronPort-AV: E=Sophos;i="6.02,226,1688454000"; 
   d="scan'208";a="864268363"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 02:15:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 02:15:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 02:15:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 02:15:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRQsiKMrORNNaSDAiLCxgfbXYa2Iv/9O2sAZYSSTtWH29oOIdnoZIzhhX8Pxaz55b23i9hHq6zevF9bBJG9MESns57EEh48+PzrLVStKXEH73uEU3v3MIjiM5oxXc6kc5LmxflU35izFbWAObdkxNY0skCOgAdhcIdf5G0tDu/MAhqpyFc5H/ukul7+TbxFRH2HrGs0oMl0S79SB6Jc1ekEq4sfBi4gld2p3Nh/14ZPTxjfVkPrvqlACT3VJv2N8G1t10jDTrgIhJ2wGXbrtYUrckdPT2l7WUHchR9i3j/bF3AUHElj9urqpf4lZmNCN/PRJv3K7SxIcKA7N72oMrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WA9dkkYapOW6/EriQb9qBR5OwLfMn8fKBCJNWiFOEo=;
 b=bfCobnEDOMifgVZQGKDJ4BGWLFGxd7BiYIGaAUtJcWF0SM/AtlzEqmJ/cmHTTvvnx/+0p4m3dmar03d/ynrWqjhEEoIsQfS+ui9Ky/OpOUzKPnoSImOUY6sYkYcow4LM2U3DK+qO8pKaI5KTBGa3ug5KUUq+tRX2eAYLnIy7IOS0oRLVGm6tCuWJOXSRaQE98Rhl1mAvXsBpmmZzytQiwaRXscUZKCHKz1EmNwtM4+bCKSfIXAUxCj3MrQx0EEdU2DO8J6NryQrix56133L678UIrz4V1Juy1t2UInzTlYcTsnfJPURP2SgHH74QvdSQb5gMIShawb8Vxr9HYuXCQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6272.namprd11.prod.outlook.com (2603:10b6:8:94::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.32; Mon, 4 Sep 2023 09:15:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 09:15:36 +0000
Date:   Mon, 4 Sep 2023 16:48:00 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 00/12] KVM: x86/mmu: refine memtype related mmu zap
Message-ID: <ZPWZwJ8KQXbWwvxC@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <ZOk2dSCdc693YOKe@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZOk2dSCdc693YOKe@google.com>
X-ClientProxiedBy: SGXP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::15)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6272:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fdd7fec-88a4-4314-f075-08dbad277f82
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hstoLoytZ5EsbffBYbQ1JVKBWEEbtK9EPZ/TqdLH1rcZAHXIgu9DRLEMyO3tnNXyMKVtN3YWRhP9GDn8wUl9IMJ+iYyq7RZ4khVOxY005PhUq0RQ/0swK5hbWN0BiZyfBaOETKcs6Dcep4lR9yZVF2eHaAWFT/DnGBR8kEOqm8SzyybNhw1IAgBEbtwbartKu1kHiHI5lUPsNHvF5RzqH0tF7QK3+/A29nj+NE9NW4V0OZnYCjhmzZLamQq8wYBtpQMzztMLz2aQ5KOzaE8Vg0p2AppTk2FmbEc+fFj1/KrGrjV84YgyYHrzJFC35Og4KFu9qwn/xNxsvYnT1XpZjYlX7NoZ5bamJhuPv1Psni4zENv92m9UVXxBgTD8JcT4XLWdhDzpTuQ1aL1b3pc43nI5I7p+hDj42oN/IFsYOvcpd5yLYpx/VT+HoyjY1+nG5ODoNqp6E6P12olCBvbaOa0dvg1QCvE9avBBcrvb3ZGAZ1+xLb0GqjKGtvcCbGjzZEFzjp7KYCgTbCYCnssLTIXPZx6fH7Ik/+GPAEGMShreG8gyyEoJsSEsQHNlqhde
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199024)(186009)(1800799009)(66556008)(316002)(66476007)(2906002)(66946007)(86362001)(6916009)(8936002)(5660300002)(8676002)(4326008)(41300700001)(6512007)(38100700002)(83380400001)(26005)(3450700001)(478600001)(82960400001)(6486002)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vkuAUybIoP2tEwyyS136+OpTmX0vA70A6m5JcEW6zmSPY4xh+CDZHZQUIWm7?=
 =?us-ascii?Q?DxXDyW3NmUW1IdcXWzKOKWH1bA63JRRoCxjLpaXf+UkX4YkypFDQSlUB/PsF?=
 =?us-ascii?Q?C68d2K7uOumV8Qs+Ap4K/B7b3BCevZtR60ONSmUWwfHA+TEn9QmzRmwhsNBS?=
 =?us-ascii?Q?2+hB8mMAUmEqnblAxqlzNrAHQBNnlvT6PNVCx5XTTFQ7vTr+QAOZ6V9zSOP6?=
 =?us-ascii?Q?lVj66vaEL+/oSRK7Ck3AeaDjZJW022hpr0eNKE5g0BMoIJmtni7mKtmB6pF7?=
 =?us-ascii?Q?EwTTDdfYOeFvx11hmorcT+iG8tFHyo8PZzqbuCta9Vq8lqzouGgkakYARhlz?=
 =?us-ascii?Q?TJ33O/90uv4fvLz4KHher4aaqPPIz52YX4THar1nXmDlVWFxyoLcUVgCfc37?=
 =?us-ascii?Q?DQMCBflEZh1Zs9TRu4+tdR1rjc6whFM1oklBpa6+i1W+MmfKn9wA1OiT6PxT?=
 =?us-ascii?Q?EEWH+3jRzsqc+6r/enEoAwgLL+kGxdgyigZk7Cb4ajDjhC5428hGwtpB73Qx?=
 =?us-ascii?Q?LKyjn2Qy3j49enVz+vSyTYhcOQDy7qB6Qw4DGsOmCqRFwOmixGvYYjl9XvcL?=
 =?us-ascii?Q?r+Wq5OKvE1wLDHRU2CjqiqrP4VL5UhOLMVPyiCqnDmdEchumthaYoxKbu+hA?=
 =?us-ascii?Q?u6bkWnNGsqqsRGP1RghQRdG3EYtHq/zdGeEEhRfTZoUynDMUdCoy5wn7H4my?=
 =?us-ascii?Q?3VeEzu+ep7+OkiUX86BK8Z7u4ZDJxYnLS62Gg7tdiFGSQEvbZuS4HVGq6bZP?=
 =?us-ascii?Q?HbLAu/z075KxBJC5kT9O5FsIWB6nFYAJdtUCX8C/pEcJGGkFHy2OoBVNSHmd?=
 =?us-ascii?Q?JMi+25ptg+6x70n2asSCKiM238vXUNHr2IH+I5Ahd7kdx3npM9Tyyv/tAXGc?=
 =?us-ascii?Q?5CI1f+qujkoUF/hXcErUKUh/6dx/sut7GhO9BAMnEH97Mqh91qQp5eYMpxhl?=
 =?us-ascii?Q?RIlNbTYf8zvNIYs3XvZcJdQFqFXFzVVswjkZQBs2Hy+ou4T1PTKahFqZaYtm?=
 =?us-ascii?Q?EW97CvqlABzQRfC2K5SL0m+4ez4FN2AV22hC5KlZa3MemwVdwmTNzYjP3jwR?=
 =?us-ascii?Q?0utA54nxjjRBqXftKWxjHJF0MPoJMkvZGyZfbbAORYmOzzivf+71WbMU05o3?=
 =?us-ascii?Q?/JqLp4TH3OinbjhsXFGJ1o1yhkyrrcuF7ong09P6o57Ysqti2Ytgy15Sb6H/?=
 =?us-ascii?Q?o2Kmry9uSOIKOK39M8KMMSfVOHJ3bI9YUgKFJYdVgZkBSKdn9HaZVNW7c4Cn?=
 =?us-ascii?Q?M54gVPJ0BFMgjcl06eq0Cp2gkIcZyf5vTTKgjlaqA6H/Amqxrep4PrFnprzy?=
 =?us-ascii?Q?R+7n6MoGzyWkAAAcCYEJ9ZfGsKdUm3Q8hW/eaZsnIuXGqdbipBV3VHwpyAZM?=
 =?us-ascii?Q?9ufH7DWUFnSyx1GqjcvPp019NvJIxUOGx7eraAdkojh9M5K11sZa42Cj8gGz?=
 =?us-ascii?Q?Dt+/63GBov9jtX9Ps/1o9sJlPwxuimnPE4Lr3TpMqmIVLsu4nkPX/tboWhla?=
 =?us-ascii?Q?NZZmx1xBxFMsJaJiIxC+S/+2sOXktQE13l+2nUT/PPfmFPZin6GXLGxKCdNa?=
 =?us-ascii?Q?PdVxMEJhWrqj119htPIfKm47iudsO+Iok4fHBFHk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fdd7fec-88a4-4314-f075-08dbad277f82
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:15:35.9939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThC909xVyRH7k1SZ4R09SZaUKie3elBVpkSVtIjIL7TCwFmd/jx+U2hQoIY6+r/zuKs246Tgnk6Oiw5A8oEZ+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6272
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 04:17:09PM -0700, Sean Christopherson wrote:
> On Fri, Jul 14, 2023, Yan Zhao wrote:
> > This series refines mmu zap caused by EPT memory type update when guest
> > MTRRs are honored.
> > 
> > Patches 1-5 revolve around utilizing helper functions to check if
> > KVM TDP honors guest MTRRs, TDP zaps and page fault max_level reduction
> > are now only targeted to TDPs that honor guest MTRRs.
> > 
> > -The 5th patch will trigger zapping of TDP leaf entries if non-coherent
> >  DMA devices count goes from 0 to 1 or from 1 to 0.
> > 
> > Patches 6-7 are fixes and patches 9-12 are optimizations for mmu zaps
> > when guest MTRRs are honored.
> > Those mmu zaps are intended to remove stale memtypes of TDP entries
> > caused by changes of guest MTRRs and CR0.CD and are usually triggered from
> > all vCPUs in bursts.
> 
> Sorry for the delayed review, especially with respect to patches 1-5.  I completely
> forgot there were cleanups at the beginning of this series.  I'll make to grab
> 1-5 early in the 6.7 cycle, even if you haven't sent a new version before then.
Never mind and thanks a lot regarding to patches 1-5!
I may not be able to spin the next version soon as I got a high priority task and
I need to finish the task first (I wish I can complete it in 1-1.5 months)
Sorry and thanks again!

