Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC3B628D2E
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 00:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiKNXJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 18:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiKNXIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 18:08:49 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E56438BE;
        Mon, 14 Nov 2022 15:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668467155; x=1700003155;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=iDhMjdt4WxLOz8gXd/cLrlJv3oQ/tPwGApsr9KdBC9A=;
  b=U3ZOh1f494h5D2x5ThaHwOXjE2EzlQsttZ9QMjLUdWB37lEQoG0/ATUR
   vBwelMREuGRY6WAcq0K6VJO1D5nLNKPH1zK7qCCqVYZtQ+aATzaEGC45W
   DH4HbvcQkd7caZgds9JDy5BGo7T9BEFF5oetpBz25KxSXKCjATLJDUfe9
   4+RgxsONBofmbEw7kuL65VCKg6OI2koiDBgGECx8w1FTfELn2VVgClSqX
   druNZmHQsbLFE/njJtogr7RscOPPTF1yHQjCHYqwjOPf6NJyr04nJK2bF
   StwhVlkMzsfHnizLmK9+3rl9exSiGz1TK6Z2yD7gsgI2GRA+7qj4yplKe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="309733034"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="309733034"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 15:05:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="813448272"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="813448272"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 14 Nov 2022 15:05:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 15:05:44 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 14 Nov 2022 15:05:44 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 14 Nov 2022 15:05:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XC4iSGENToiWXVKK7VJekit62mPyiEQZFO36jCodyhU+iFnmwlQppSdek/b1Ju8Sw92ZaRGuVZ49M0tT3E811+KqUQd5jaWJ0HEq+c3YBZVMZwuK8iUVmAGxHDv10eHmun5BL4bHoOO1CLjiDygApFmfbsNIqFJ37wVtbVYqnYe/bJfsETvdRaH6gNqlZ9N5+iqtTSCIhLdxu15bIJ4ejb2vdbH2qqor94ZfDYnZbHzKiRW4YOwzgVnzmcP+H4DTVSbLjSwUu1fLTZcL1qmg6UuOg879+GjGCrdpROLpFsdSUjukQUrKlDE5z9PNqmJESC5Of9BwF/EsXdhfys1KzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oi36g8hBsvnoM3wzrGb1U9v1akHk+K673ZlMo24TChA=;
 b=iv0oxpI6SFTrAvAOPCgi5c5x3QOu+q3zioRyug680+p190PE4ImNTq4LAhWur3Rv/KWksRJarphYr+tqfDJq5nW21urpwHRZ5rz6KGI7W/aWVfHGDrHIIaD9ggvZHtqffSV9gN1fjTvDJKmxhnKiGeP1GlcDaV3RQbKvOrxaC2kq7PXIjvEyFhWJSJLMxh9Lq30KV7z3uSwq6tWRuZdO5peNjaJ5mQOvr2dpDueFmJ+UppULXlAt6cgPmin0Ffn1h8keMf8aRjyJbXB/3ggJ3U4za5DK86nywbUsBWDZQ9li/ahGE+iNaiBZo6f3H+IeLO3XoH+0MKxWVrqQ+8/ggg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Mon, 14 Nov 2022 23:05:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::dc06:6d36:dc8a:fe7f%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 23:05:39 +0000
Date:   Tue, 15 Nov 2022 06:42:45 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <intel-gfx@lists.freedesktop.org>,
        <intel-gvt-dev@lists.freedesktop.org>, <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: add a new page track hook
 track_remove_slot
Message-ID: <Y3LEZXWqk6ztuf7x@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221111103247.22275-1-yan.y.zhao@intel.com>
 <20221111103350.22326-1-yan.y.zhao@intel.com>
 <Y26SI3uh8JV0vvO6@google.com>
 <Y27ivXea5SjR5lat@yzhao56-desk.sh.intel.com>
 <Y27sG3AqVX8yLUgR@google.com>
 <Y3GUdqxnPJvc6SPI@yzhao56-desk.sh.intel.com>
 <Y3JtonYdDYOhbmfG@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3JtonYdDYOhbmfG@google.com>
X-ClientProxiedBy: SG2PR03CA0093.apcprd03.prod.outlook.com
 (2603:1096:4:7c::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4792:EE_
X-MS-Office365-Filtering-Correlation-Id: 051a5b2f-5f28-43e2-a4d0-08dac694bf36
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bvwk/9HQlvH8wIQNldTNDsItzXHlhOeDMPzzjHsxvghLkl4U8Tvd77JqFJhoSGq1aB2LgiV2ILRvasrrPbTN9ezRwrDqSkJ7ylgz867qKFNxId358n1dnyaW4Fx7jNVs+2wNtp0Xd88bBESeofIqZ9CSmxbhpxl5+msSeIioQv7QeYHPu2b/5HHnb+5Y0jW0TgkZ2coN9GtRR9RqluizAQIv7jLen12QrjDuDF9Eb5QBOydfuywOg/4IO0lin1nVaakRuP8uf6fIMKTI7kIBiT9ne33zjCZCMRAaStv5mhUhQEGZ6PYLaMDYMoF4wAmpVfZZhpFRTdpzUFhUrUxdZzmfgq7pEob7Oa4UpXPP7WpcMkPEz+0hbZE9zdAdRzOB8gzuawg/KtYtAFJbHyBDtcn9n2tyLXsExKtn3AbixJ2e9wxsBU1AmYITYYl3pf0W/k/J0QvfpetATeLDmq7zEkRDnP2s7Mr0rnNffI7QzFTD1OSCdluZwmyTBaIjs8DxOCZ5jZag7BwrMIfCIvuZStQNqz+AfiGmPzGo4ur6CWH2NjaQRl9NwRHn0Fdja3rTj5fJ3pEZoIp9mvAdIGIIcmfezUToi735NA5Z/uFgkQMCqRxNvfKvOZKufbKHp2OdjWxhNglz9ncMgQyl/GnysKrSJJv4DpQRoeMQ+Yjpqk50RsekOnWsNkb8rr3jrO2WAt3J+jLSuFg3rVw6a4hHDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199015)(82960400001)(6916009)(316002)(38100700002)(66476007)(5660300002)(66946007)(8936002)(41300700001)(8676002)(6506007)(83380400001)(4326008)(26005)(186003)(6512007)(6486002)(86362001)(478600001)(6666004)(66556008)(2906002)(3450700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0YXQ1Ep+oGvSdg5CSRQqIQyeBMAwHOFmWmOlIx3Cd+km1Lvb0x5mbMBfUVzd?=
 =?us-ascii?Q?YZTh7zrR61Ymt70ev2XownzsjNbPfcRNJb6N4hpCWsYMNsAlKCR/ItQSnAea?=
 =?us-ascii?Q?moTSb1a5uTauXg8tdwHdFlU5zFu16Y8DceWvlfHhFVjwQcpV7Q4xmDNu6JHG?=
 =?us-ascii?Q?Nuhf57s9gNu88+yhQRIvrXRGrPZL94n6qeMbTWnHKqTV6NjF74dcOcqfgdSR?=
 =?us-ascii?Q?7Ao5nF9yTrBDjSYy6D5HakYASGs6oOxVw0gWVNtyU8NGQhotCokyrBj6fsOf?=
 =?us-ascii?Q?R/+4wTIaHD+Hyx6u0+vSAPPFRTJT5BxauxkwiArlO0GMlvhz+bvVhQ8DoNu+?=
 =?us-ascii?Q?k2UHRZlkvpF6hMHbvd7gxmO+6HBskvLCQ+bzLYLf9OzFuM9JY2M1PqSlve7d?=
 =?us-ascii?Q?+SPDL0BB6Jr/UZTvglooapVFQfYT6En2OUTodlUxElyI0LMnLv0pD3eJcdZN?=
 =?us-ascii?Q?xjOTsCAwVVU6ad3HCGWZVY/r6J/o8WdwEe/2tMmo4jFam/HrFJ79DIaLVxph?=
 =?us-ascii?Q?stLl+TUC2qDqX2owpfQO5NMnogNxjcpCT37lnjmmXYcQTMJQl6R66Fk3/vbc?=
 =?us-ascii?Q?rxFQWvVjnuIZBmyHghAJqk8G4tmX40MXp+Zc0VXFh1mMQZSyN9TMy1trTE5M?=
 =?us-ascii?Q?oefUx06YpMg3padz2V8qDrvbM7xXBxowH4luW8iTB9y2JDo3IHDtV1dpXhEK?=
 =?us-ascii?Q?Lm7j7Xh2jvi5fONeyOziO0bjIsbwkwDimjYm1f9uR4CSUrld/sLCTQFTXuag?=
 =?us-ascii?Q?4hO83eOa0XiRMJzYzocL0Zxdv9UQlbPvW4GMagi4vki3kahNEixqIdj2Ko05?=
 =?us-ascii?Q?ugUfb3/XCdp/yHelvmJKVRQ/7sD43Vk/fHxbKfTGWMUszvuAQOQ+E3ch3vUt?=
 =?us-ascii?Q?CZWRtfqQ4U+69+diAr57uuUlnFvatbtWu0V6Qug/7aU80ZNODzbg7u5Hspx2?=
 =?us-ascii?Q?46mWCGj2OSo2XchQxttUdQxOW1xRL5uZiYKbyRe9CZQ7L74t5QxvplDG4GR5?=
 =?us-ascii?Q?DjS+qIfoxOyJ8ga9P9Dfm3T00JCpQ0EW5DNAlJ9+UHWrl3x/ZdgswjxW+/F/?=
 =?us-ascii?Q?mC//Xg+iRAk7xqc800ptELKWxQcK6BWCnoxPicSicLeeCnzflzoz3WL7Nnjl?=
 =?us-ascii?Q?g0UXoHm4ZWlHaWsEWrjt+4pAQ9SZdsRd8lDfJmLxlf7x3F8I7yg/aMPAV1K2?=
 =?us-ascii?Q?sZgqmr4EW/gW5Ek6fk3nQ/I0LN1/Q+FJuiv+mEZSFTSuyfUu4fK9gOcaJ/c4?=
 =?us-ascii?Q?3YzC7neWG1+9v+jkqYdvb8y1vdfOyUm2EoWjSUK2uqxBokIBxF7+M85GympX?=
 =?us-ascii?Q?L6jR4l/Sx7WWyF38TTY8sGxa6qHw0hyvCjz3VYz8SC2PYeSwRm6rWrRJEKwE?=
 =?us-ascii?Q?mCOMk5AKDp0BGdar5fi0IMa7O4o8JPmDTConb/8omtvyaiAREQEUc3Z1mkjq?=
 =?us-ascii?Q?PBtfbT61YEbeYxefkJ0ELne/FmiOouGBv/M3X8p5DJOgSDmZq88BtorYvcxp?=
 =?us-ascii?Q?MvW1B0wDwqWA5pMcXYfjPtpWnb2daGbk8dn05cCQ6K6hc4L0Dq2D2M9z1GEB?=
 =?us-ascii?Q?xfuuj8U5m68Wyr1FY8uE12llg8VY1Pnm9Klz6qzL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 051a5b2f-5f28-43e2-a4d0-08dac694bf36
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 23:05:39.3397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYU1FBmxeELgR7Y6v9b+HzZ5VsPV1aVrHs9ZEtc1zTVPBfoOTYqisBns/F9m24ohl4GbOMMllfcnnfmPdqZNWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4792
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 04:32:34PM +0000, Sean Christopherson wrote:
> On Mon, Nov 14, 2022, Yan Zhao wrote:
> > On Sat, Nov 12, 2022 at 12:43:07AM +0000, Sean Christopherson wrote:
> > > On Sat, Nov 12, 2022, Yan Zhao wrote:
> > > > And I'm also not sure if a slots_arch_lock is required for
> > > > kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page().
> > > 
> > > It's not required.  slots_arch_lock protects interaction between memslot updates
> > In kvm_slot_page_track_add_page() and kvm_slot_page_track_remove_page(),
> > slot->arch.gfn_track[mode][index] is updated in update_gfn_track(),
> > do you know which lock is used to protect it?
> 
> mmu_lock protects the count, kvm->srcu protects the slot, and shadow_root_allocated
> protects that validity of gfn_track, i.e. shadow_root_allocated ensures that KVM
> allocates gfn_track for all memslots when shadow paging is activated.
Hmm, thanks for the reply.
but in direct_page_fault(),
if (page_fault_handle_page_track(vcpu, fault))
	return RET_PF_EMULATE;

slot->arch.gfn_track is read without any mmu_lock is held.
> 
> The cleanup series I'm prepping adds lockdep assertions for the relevant paths, e.g. 
> 
> $ git grep -B 8 -E "update_gfn_write_track.*;"
> arch/x86/kvm/mmu/page_track.c-void __kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> arch/x86/kvm/mmu/page_track.c-                         gfn_t gfn)
> arch/x86/kvm/mmu/page_track.c-{
> arch/x86/kvm/mmu/page_track.c-  lockdep_assert_held_write(&kvm->mmu_lock);
> arch/x86/kvm/mmu/page_track.c-
> arch/x86/kvm/mmu/page_track.c-  if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
> arch/x86/kvm/mmu/page_track.c-          return;
> arch/x86/kvm/mmu/page_track.c-
> arch/x86/kvm/mmu/page_track.c:  update_gfn_write_track(slot, gfn, 1);
> --
> arch/x86/kvm/mmu/page_track.c-void __kvm_write_track_remove_gfn(struct kvm *kvm,
> arch/x86/kvm/mmu/page_track.c-                            struct kvm_memory_slot *slot, gfn_t gfn)
> arch/x86/kvm/mmu/page_track.c-{
> arch/x86/kvm/mmu/page_track.c-  lockdep_assert_held_write(&kvm->mmu_lock);
> arch/x86/kvm/mmu/page_track.c-
> arch/x86/kvm/mmu/page_track.c-  if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
> arch/x86/kvm/mmu/page_track.c-          return;
> arch/x86/kvm/mmu/page_track.c-
> arch/x86/kvm/mmu/page_track.c:  update_gfn_write_track(slot, gfn, -1);
yes, it will be helpful.

Besides, will WRITE_ONCE or atomic_add in update_gfn_write_track() to
update slot->arch.gfn_track be better?

Thanks
Yan
