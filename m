Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B79C5EBAC1
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 08:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiI0Gem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 02:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiI0Gel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 02:34:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF1D632E
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 23:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664260474; x=1695796474;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=alRqKkC45E7/hpiu5rw5w+Wa5KnuEyveJCZjO9Z88As=;
  b=J7P03oD5X/pPcf1DJpNQcDyQ+DhGT5FCQ/UkFCBpBMuPbIZVW/ZIU/Dh
   D56mtf+vgcbNIIo4ysnpobm3D+WOatkrOEkAf36pB9KkYDyJ0zgW1Ouhu
   Cs8g0yTkRotbF7OdRN/774tYRaJ6PgmREQGBpJAPDQf19RyFWJPTGH7YL
   CNsLLJzrEXS4/0SjJ2p1PMkXlxRSMiqewPC52L2JtRosetSND+alLkxOY
   tECwHG/h/6HKLvA1Hc6IlSQJdnhBMHaLRg6Od7XtDhUCp5WSFR1s1cHj3
   AGIlgRqh1zkiDX+h2/YjFYK33UVWOHF0ee5T2hpsrGWP4tDJZoPrzi881
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="387524237"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="387524237"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 23:34:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="654612318"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="654612318"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 26 Sep 2022 23:34:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 23:34:32 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 23:34:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 26 Sep 2022 23:34:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 26 Sep 2022 23:34:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dusYJp3X/6HOrOTqU9DufIW3PG7JZnthoM911xTc9YNdQcBJrcSG5OMhx91A6fXoGIKnvIFuL10kQJWa4EL1WNAXjh1ITlRniyW90SSrSH4mjbvbuQ9BS1ziJC7TwqKezvnfPXVDFsTHOvhr1b3VT+fKjsZVw8kH2GLpO7XMbzKf34NY0jEaHr6kbKxqEmgvgvSIY6AYMj+b1sH+5IrpC0cZbGWoBxdZQKhr2vzmilFedQxreGBgHewwOknTsl+3QKQrt4QtMqtB3VYf+R3nrNDKhFOor3qR/WTH/BOKGOc2kH3QPmo5p2QZs+zwTOA4wCKoQ8+YX57B5s4x/14fQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6VnTug+dfrG6mjdPMjW8KLBcOkCeCCRoLtjRYmwcQ4=;
 b=OyZk6kT0KvCgB8BiXbHdGO9ohNBlxPzJNbUIBtMyXWDzYFzws4wpgqnWVY8otsHk/G0G53FSzy9nl8msP1jlj0c96ASKXq+gW1sz/S7mcex2XBe0i/TGYNX0NN1VpcglIZtb1MXoMnZqLG2tu/sXQ1pzDV1CNzbUdaNiAz/lhx/DHyxeHIoIXbB8ocfs4haqNZF3Fe5ZQuQtcn5f1W8wWVWeYyPF7ghRrPadduvFnf/k1FaX0zdnXZ0NrEFgsP3aL6DPu1PnoTKP6TBqA/YPvLeYCETduQdVBi4X3N5A7Yq2AOMz272LIM2bcfWewO0+7PXdXNoAUMZRdoGjE6GQQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH7PR11MB6474.namprd11.prod.outlook.com (2603:10b6:510:1f2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Tue, 27 Sep
 2022 06:34:29 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d28e:a9a1:6df7:dea4]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d28e:a9a1:6df7:dea4%9]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 06:34:29 +0000
Message-ID: <152f5880-04c9-48de-f9b2-e86a8577efca@intel.com>
Date:   Tue, 27 Sep 2022 14:34:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
CC:     Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0226.apcprd06.prod.outlook.com
 (2603:1096:4:68::34) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5658:EE_|PH7PR11MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: b40f680e-e03a-424d-2596-08daa05254b4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gC9bN6kYUjxf7uxyhjHXZy+lGp+2kY2hmIkr8qP/l9IpowOWbWYj/yPxJL4Zmu+QbbNsrTPWY6OrJcKTtJwuM82Fsusl9PlLPrFs189+/+qOW8ItoctSwskefFA+00ohrMCTEonjXpaTFM8RWl4SLcgXnn9HB/1qw6cUcwsZXwEFRSg7ulC7LqryzSJl7fiMAliHnTnDRKDHyX8d1xL1yWp3t0DYTaIaQ+pfsxmPNeWQmounXyNEParXevDHM7vPUTgzJGQ6S0VYrjRH/y9V4zU8dRC9Knuxwk8LSgI86/pXmvdBeFpAE3mDjEvdfk9nGXq0PCn0WpRoJ20ilIDSM2C3saEo0Y857APVvZ7+BixqjRGBvpN2DUy+R8nNIjJ0DdpBshHO3GrZc44ZlDGPCn4My56B5xH9vs0klYcag0Bzc3gDFzzwn88iCNxxsvRH6VOwtTD7V4ItD597gpSFWLtCLSARdcj+N3Dz0mOzPB9sjP5n5UJGgxg/fvhq1JHP3+eZec3erHIhq1O36E7m3JS1TlERndrCcGvMOKBJLVWWaIpVzZoGmotigs13EifpAH0cvKPrzGjEwSZjWsXedIF+D0ba2OxWX5YuRynqaasT7USsL9rmeSOkvUolYfzY00pqK31NGO3tZjCDPX9rR7H41Myq0Oheu4uKykIbdTub7vVR20MmwV+S7+utT2XhpERIe7h3QE2Fb1F+gXiFXDpZcRuMdi+xh6fcQ6uNMlPLJ4TLbsnKvcQnLSv0QdeLJlUUY2CN5CRpXsymWUnPSTS8WBjUCgLPWYTKWZe89jqAoc5CB/2YzDhfbxIyJBbXC7LHgI0vtLPG5rW+dfCI9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(45080400002)(38100700002)(110136005)(54906003)(31696002)(31686004)(316002)(82960400001)(6486002)(478600001)(2906002)(6506007)(2616005)(8936002)(53546011)(6512007)(5660300002)(86362001)(30864003)(26005)(186003)(8676002)(83380400001)(41300700001)(36756003)(6666004)(66476007)(966005)(4326008)(66556008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3pxc3lRclpUSjg0ZmV5OThmc0xhQUh0OWUrKzFrM1lBQ1NtRE9CQ2duaVh4?=
 =?utf-8?B?dGxOaFcyYjFPVkVYejZrTXBiNkRRMEpGVFBZMDBVQ2ZBRkMxZ05CMWZYV3Nu?=
 =?utf-8?B?aDhBeE9QblEyVGtuN2syVDhpNStsMngxOXJ3RFVrOG9FTjJnN1p5LzNtMUls?=
 =?utf-8?B?TDdsWEYrdWdTTzdBK2oyR0J4YkhoSFVscVBiYjJrVHVvSlNNMC90Ujk0dWhs?=
 =?utf-8?B?SEVPdUdKUGZhblhKZEdjTlNWVmVIOFVKcjd2VE5SUXB5OXRYU2tEMVVTam5K?=
 =?utf-8?B?WCswNXo5bmZnaldDMXluQ09RQTVWZGdvc3gzTTR1bmdOWDU1dUR1TFVkSGpl?=
 =?utf-8?B?QXBha05tMU9rTHpmcXFuSzBXR1d2MWcxUEY5K1QvN3I5RGtOVFc1dVZvdVVP?=
 =?utf-8?B?YWxPRjR5ZVpRSGxLWFM5ZzZnbGJJQmxGL2lyRFpFbnF4Q0xTQmpIbk16YzRJ?=
 =?utf-8?B?S0RDOXZ2VTVCVk56ZVFvMjY2Nld4RW12TmtVaGpIN0s0dW9zTXBadGFvZVRC?=
 =?utf-8?B?TFcweHY1QXFZTHhHZ3hsc2pYeWc4Z1lXRm1SVElvVFpPcFNVZUxmNUg4d1dK?=
 =?utf-8?B?SHBxckNEeWs3dnlsWGd5d3FoZWE1N2hMbVcvYnptZlZNQlRqcC8wVlI3dFF6?=
 =?utf-8?B?QVVBbW9XUitsUFk0MC9CSmdMUG8xemNpbXRvL3RPdjRnZDlWaVEzQ01BQmQ0?=
 =?utf-8?B?T2RWVzFGQ3ExV3VHamM4NHdxWEorK1ZrU0RuN2RmRVMzTXFCQ3FpNlphTThr?=
 =?utf-8?B?MXVRVlJyTGpzdnNqWUs0bnRQa0lpRkthQ1RFUWZjcU90aWwzR2dmamhQRzYv?=
 =?utf-8?B?dTRSRGpKVnBaTkNpcUZVaGZPclhsZzlWOFlqNy9yL3lGU0c4T3YxOHlhYkhO?=
 =?utf-8?B?azY4TWFhN3E4N3dXcXM0TUxBQ2swdjhzUEZuZkhtdENnR0N3UzgvaTVtZHlv?=
 =?utf-8?B?bHNBQWZpWjVsTE1iQzB6amJDL25sc1JHOWJFd2hPZ3pDeXNUdGlnNWdNWGN2?=
 =?utf-8?B?OHMzcVc2SXpOM2phNW8wdTRGanVUY3Q1N0xkT3VCcXF2elBVb1lxdVp1Yitp?=
 =?utf-8?B?ZlMrQzhkNWVHTWc2SGJaVGxJd3p1Y2ZoTnFtZnFaVmJiRk5QdytnSGVVcndk?=
 =?utf-8?B?dXBkZ3duV2NtdzZHZFVtbEdtODRueEFNcmg5bE8xQVFDTVFPZStjWFlMdDNm?=
 =?utf-8?B?Kzdrck11SkZlZUZ1RkdOKzM5Y3FZU2pnaDJzN3AwbmtLTDFJWmtBbEVBOVhE?=
 =?utf-8?B?MHErYTNJcFZ3bVBMSGx6RkZqTGtiL3VIditlU0VUVUR6cysxeGczYUhtcG1H?=
 =?utf-8?B?Um9mMDllSzhkWGkxTTU4T1pqZ1IzZ3RjMk5BT3NSNUhWRkhCUDVsUG1hQlF5?=
 =?utf-8?B?ZVBTTWhYaVlYL2czQjBlUXFOTzVkRjU1VkhONkhuY3FtemxDcjE2Sk45eFA1?=
 =?utf-8?B?WHBEYUVubXlFcmtERkZ2ZXF6TFJobVZpRTMwbWdsSHVjSFJDVzBXTzF4RHRj?=
 =?utf-8?B?cUZYelhmREE0SnIvSHBHRDQyR3lGdytvUUpBanNZM1RNTnJwRUZxQmw0OTVy?=
 =?utf-8?B?VWs2M2lmd044dFdsOHUvcVhiL1ZDcVZacTVCMG5ITzFvTDF1M2wyMjBEbCtn?=
 =?utf-8?B?dVpsRTg1bGUwbmd0amhneSt4VGR3VE12SS8wVXFBYXN4QSthc1BoRHV0VUhX?=
 =?utf-8?B?OU9QWTBmeGxhWXRNeGlWTlozUEYwd0pZaEM0emlFVWtyN0JkTko4V1RRMlpU?=
 =?utf-8?B?aWQ0c2lvakdORmgxdXlFTjFPKzJoOXJLY0pCMFFnOGJpZzdtRWVobFMrOS9y?=
 =?utf-8?B?dlVsakJNeG8xb1pQSkN1d0g3SmdyUFp2cWVzYnM2VWVKNzJKWm1sRzV3MHVs?=
 =?utf-8?B?RXVUK3oyZ3NlY3FUdDI0K0YzbGxPTWtHMEZmeU83QnNya0RaTW4rTEp0Vmho?=
 =?utf-8?B?S3EvSmhlUk15dnR1enR5RkZuZTNLWmRFQkFkQ3VOd29YZTRYUGhsdGcyOEFY?=
 =?utf-8?B?WVNNbi9FMHhxL2JmaENuSWduaGVQdjlNY1VoczEraHk0Qk5HKzZQbVJFeGZ3?=
 =?utf-8?B?L2RCY3laWXBFb0xoSmdOenduMVQvc0dJRjZveWdZelZJU3U0bjdVa0hiTnE4?=
 =?utf-8?Q?v43fr/Cj/68GS4AmgDpthnIlT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b40f680e-e03a-424d-2596-08daa05254b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 06:34:29.8168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzeepTqanY2TdnPm9revnbAQizx8VtcuDMtQt2to6z7NZLgHjk/zgrgDWgup1JlTdXbfuszqvylD0dKhnOQH/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6474
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,TRACKER_ID autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/9/23 08:06, Jason Gunthorpe wrote:
> The iommu_group comes from the struct device that a driver has been bound
> to and then created a struct vfio_device against. To keep the iommu layer
> sane we want to have a simple rule that only an attached driver should be
> using the iommu API. Particularly only an attached driver should hold
> ownership.
> 
> In VFIO's case since it uses the group APIs and it shares between
> different drivers it is a bit more complicated, but the principle still
> holds.
> 
> Solve this by waiting for all users of the vfio_group to stop before
> allowing vfio_unregister_group_dev() to complete. This is done with a new
> completion to know when the users go away and an additional refcount to
> keep track of how many device drivers are sharing the vfio group. The last
> driver to be unregistered will clean up the group.
> 
> This solves crashes in the S390 iommu driver that come because VFIO ends
> up racing releasing ownership (which attaches the default iommu_domain to
> the device) with the removal of that same device from the iommu
> driver. This is a side case that iommu drivers should not have to cope
> with.
> 
>     iommu driver failed to attach the default/blocking domain
>     WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
>     Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_ib sunrpc ib_uverbs ism smc uvdevice ib_core s390_trng eadm_sch tape_3590 tape tape_class vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 mlx5_core des_s390 libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core zfcp scsi_transport_fc pkey zcrypt rng_core autofs4
>     CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
>     Hardware name: IBM 3931 A01 782 (LPAR)
>     Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
>                R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
>     Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
>                00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
>                00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
>                00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
>     Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
>                            000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
>                           #000000095bb10d24: af000000            mc      0,0
>                           >000000095bb10d28: b904002a            lgr     %r2,%r10
>                            000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
>                            000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
>                            000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
>                            000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
>     Call Trace:
>      [<000000095bb10d28>] iommu_detach_group+0x70/0x80
>     ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
>      [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
>      [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
>      [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
>     pci 0004:00:00.0: Removing from iommu group 4
>      [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
>      [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
>      [<000000095be6c072>] system_call+0x82/0xb0
>     Last Breaking-Event-Address:
>      [<000000095be4bf80>] __warn_printk+0x60/0x68
> 
> It indicates that domain->ops->attach_dev() failed because the driver has
> already passed the point of destructing the device.
> 
> Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio.h      |  8 +++++
>   drivers/vfio/vfio_main.c | 68 ++++++++++++++++++++++++++--------------
>   2 files changed, 53 insertions(+), 23 deletions(-)
> 
> v2
>   - Rebase on the vfio struct device series and the container.c series
>   - Drop patches 1 & 2, we need to have working error unwind, so another
>     test is not a problem
>   - Fold iommu_group_remove_device() into vfio_device_remove_group() so
>     that it forms a strict pairing with the two allocation functions.
>   - Drop the iommu patch from the series, it needs more work and discussion
> v1 https://lore.kernel.org/r/0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com
> 
> This could probably use another quick sanity test due to all the rebasing,
> Alex if you are happy let's wait for Matthew.
> 
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 56fab31f8e0ff8..039e3208d286fa 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -41,7 +41,15 @@ enum vfio_group_type {
>   struct vfio_group {
>   	struct device 			dev;
>   	struct cdev			cdev;
> +	/*
> +	 * When drivers is non-zero a driver is attached to the struct device
> +	 * that provided the iommu_group and thus the iommu_group is a valid
> +	 * pointer. When drivers is 0 the driver is being detached. Once users
> +	 * reaches 0 then the iommu_group is invalid.
> +	 */
> +	refcount_t			drivers;
>   	refcount_t			users;
> +	struct completion		users_comp;
>   	unsigned int			container_users;
>   	struct iommu_group		*iommu_group;
>   	struct vfio_container		*container;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index af5945c71c4175..f19171cad9a25f 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -125,8 +125,6 @@ static void vfio_release_device_set(struct vfio_device *device)
>   	xa_unlock(&vfio_device_set_xa);
>   }
>   
> -static void vfio_group_get(struct vfio_group *group);
> -
>   /*
>    * Group objects - create, release, get, put, search
>    */
> @@ -137,7 +135,7 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
>   
>   	list_for_each_entry(group, &vfio.group_list, vfio_next) {
>   		if (group->iommu_group == iommu_group) {
> -			vfio_group_get(group);
> +			refcount_inc(&group->drivers);

so the __vfio_group_get_from_iommu() can only be used in the vfio device 
registration path. right? If used by other path, then group->drivers cnt
is not correct. may valuable to have a comment although no such usage in
existing code.

otherwise, this patch looks good to me.

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

>   			return group;
>   		}
>   	}
> @@ -189,6 +187,8 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
>   	group->cdev.owner = THIS_MODULE;
>   
>   	refcount_set(&group->users, 1);
> +	refcount_set(&group->drivers, 1);
> +	init_completion(&group->users_comp);
>   	init_rwsem(&group->group_rwsem);
>   	INIT_LIST_HEAD(&group->device_list);
>   	mutex_init(&group->device_lock);
> @@ -247,8 +247,41 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>   
>   static void vfio_group_put(struct vfio_group *group)
>   {
> -	if (!refcount_dec_and_mutex_lock(&group->users, &vfio.group_lock))
> +	if (refcount_dec_and_test(&group->users))
> +		complete(&group->users_comp);
> +}
> +
> +static void vfio_device_remove_group(struct vfio_device *device)
> +{
> +	struct vfio_group *group = device->group;
> +
> +	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
> +		iommu_group_remove_device(device->dev);
> +
> +	/* Pairs with vfio_create_group() / vfio_group_get_from_iommu() */
> +	if (!refcount_dec_and_mutex_lock(&group->drivers, &vfio.group_lock))
>   		return;
> +	list_del(&group->vfio_next);
> +
> +	/*
> +	 * We could concurrently probe another driver in the group that might
> +	 * race vfio_device_remove_group() with vfio_get_group(), so we have to
> +	 * ensure that the sysfs is all cleaned up under lock otherwise the
> +	 * cdev_device_add() will fail due to the name aready existing.
> +	 */
> +	cdev_device_del(&group->cdev, &group->dev);
> +	mutex_unlock(&vfio.group_lock);
> +
> +	/* Matches the get from vfio_group_alloc() */
> +	vfio_group_put(group);
> +
> +	/*
> +	 * Before we allow the last driver in the group to be unplugged the
> +	 * group must be sanitized so nothing else is or can reference it. This
> +	 * is because the group->iommu_group pointer should only be used so long
> +	 * as a device driver is attached to a device in the group.
> +	 */
> +	wait_for_completion(&group->users_comp);
>   
>   	/*
>   	 * These data structures all have paired operations that can only be
> @@ -259,19 +292,11 @@ static void vfio_group_put(struct vfio_group *group)
>   	WARN_ON(!list_empty(&group->device_list));
>   	WARN_ON(group->container || group->container_users);
>   	WARN_ON(group->notifier.head);
> -
> -	list_del(&group->vfio_next);
> -	cdev_device_del(&group->cdev, &group->dev);
> -	mutex_unlock(&vfio.group_lock);
> +	group->iommu_group = NULL;
>   
>   	put_device(&group->dev);
>   }
>   
> -static void vfio_group_get(struct vfio_group *group)
> -{
> -	refcount_inc(&group->users);
> -}
> -
>   /*
>    * Device objects - create, release, get, put, search
>    */
> @@ -494,6 +519,10 @@ static int __vfio_register_dev(struct vfio_device *device,
>   	struct vfio_device *existing_device;
>   	int ret;
>   
> +	/*
> +	 * In all cases group is the output of one of the group allocation
> +	 * functions and we have group->drivers incremented for us.
> +	 */
>   	if (IS_ERR(group))
>   		return PTR_ERR(group);
>   
> @@ -533,10 +562,7 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   	return 0;
>   err_out:
> -	if (group->type == VFIO_NO_IOMMU ||
> -	    group->type == VFIO_EMULATED_IOMMU)
> -		iommu_group_remove_device(device->dev);
> -	vfio_group_put(group);
> +	vfio_device_remove_group(device);
>   	return ret;
>   }
>   
> @@ -627,11 +653,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>   	/* Balances device_add in register path */
>   	device_del(&device->device);
>   
> -	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
> -		iommu_group_remove_device(device->dev);
> -
> -	/* Matches the get in vfio_register_group_dev() */
> -	vfio_group_put(group);
> +	vfio_device_remove_group(device);
>   }
>   EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>   
> @@ -884,7 +906,7 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>   
>   	down_write(&group->group_rwsem);
>   
> -	/* users can be zero if this races with vfio_group_put() */
> +	/* users can be zero if this races with vfio_device_remove_group() */
>   	if (!refcount_inc_not_zero(&group->users)) {
>   		ret = -ENODEV;
>   		goto err_unlock;
> 
> base-commit: 48a93f393ac698fedde0e63b8bb0b280d81d9021

-- 
Regards,
Yi Liu
