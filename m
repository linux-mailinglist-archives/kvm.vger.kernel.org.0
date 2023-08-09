Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5681477505A
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 03:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjHIB3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 21:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjHIB3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 21:29:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5DF173F;
        Tue,  8 Aug 2023 18:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691544592; x=1723080592;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/WZNBxq6I6MCGnubWyEeZzwN/+Ce8WdlSC4QJ8H1zpA=;
  b=abhZihh9lr3ulTAUVAJlbL6sDG3IGccM01kc3lrhTfiW2ibbg0cvxMJy
   vLf9yylupFI1gesvhvOsj+BGKf1rpeRtqPKa4zH3Bkpdv+dRFUG2esZKr
   y8et4J58Zegx1ANZGLmPGlFCkMQWoc/sSFypQeNxC2in7Nx/d+SYiHwT/
   6mE07wkPOFPW8cIlV3F74QhgFxK7hUGLCQ9MFy8j4CfH4nYPrFAzFSfJj
   zgW7Icn/bvPZBT6CkYGujVUYg4ODq2XLA5bqQ82+1X9s8clb1zPk3MPBT
   4GjI57828v8lkclleCrNAXD+osVI6voSYomwNrmAbasmC7AgGtrg2lkdy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="351304186"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="351304186"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 18:29:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="761162689"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="761162689"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 08 Aug 2023 18:29:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 18:29:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 18:29:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 18:29:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqFUJworrrDURoPCF5YrGOiTXqoaAvNtqBgYX0lsBm15UGZksdhgwQXtrbjMQEEC9pPbQlaceEBX+cQRCP4na7wYBNvFnhBeO4+JAMeQi5o4jE5PcYjOGtP8HwADu5Jqu6AnXCz9lRTvjtgQDGMTahwMrZRNLbkV1zZMSuJT1V25JRBmO9lMLMk/ViDBgXiYK6GsjXJDlQgbWWA8tgHp78ASFVL7qYDwWSWmE3dJ1QOuHa4Jw3hchCoE8hes53FfQRH2Vm+XXo0sonee5kAixiX9lRb17qpxkegX/HTmXGZ8xpw4B1ERYb7qgFdqGCeD8YuOnc+NBp/EmqtKSao+Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83xn5JeDmv3newAy06m0YJifnuMPrb22dj2LWGha6qM=;
 b=IHKN3acpSNYMc5NK45qcKES/DhT1u36s01xjWhS3chW7HKh7cCmp20+DfvmaNjUBsyCgkiwqJmiCUuKDlAqdtbl8d0xGL4YA/00+4cBV5ZaoqPovG3mTKGmJ6QFmwMZjNYfzkWfjBXp5Pk3rfKaUhDjZEyi4IEnHVKcsptITM5W+l3yK/zERgKv/SPUpbH3wGWaXUt9wfCQ98IFtyqdkStbSNiLfCtDojv1uAPP94iXgLW/BLAvTovKFwIuRv45XnnSBnDIXiZwDYGmKBuxN68TMdYnjqpkFwmweK6UXwhZUBkuoXn8g8JhqWbP2JzoliuAhvDGfwCazrJm6Pcd2mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7426.namprd11.prod.outlook.com (2603:10b6:a03:4c4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.27; Wed, 9 Aug 2023 01:29:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 01:29:48 +0000
Date:   Wed, 9 Aug 2023 09:02:41 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Like Xu <like.xu.linux@gmail.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "Zhenyu Wang" <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        "Zhi Wang" <zhi.a.wang@intel.com>
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
Message-ID: <ZNLlseYag5DniUg3@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-20-seanjc@google.com>
 <5581418b-2e1c-6011-f0a4-580df7e00b44@gmail.com>
 <ZNEni2XZuwiPgqaC@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNEni2XZuwiPgqaC@google.com>
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: d43866fd-821c-48c1-b877-08db98781e06
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U9eGkO0tIgxmKnAB9VM5z7hfshFwFoQfz98/Wd8qMg4YwF6S+4Ld75m1zcMUAbPQHcOvLYVfM4zKXuyT4NU1KXhY0hVJmKITiR1D7qfpohzPsgtBxwF7Du1FCm93RwieucBEl/GxTOWNm1RaC4tUe70x3iloRZoH6MNwtynYi1pIzOA92dUFFY0j+tob2cQ+y2vt8LoIy8DfCoa4rtt6uGx1JEytbIndLdRVD2+7xW+uhEkj+rcG4OtPwutcqNRMsfZRcL4n2swfXr5Ypf504U7iEWGUDxJ9jBJmyJfoOfmwPdNQjdzDl3fQV0ZwZFcgyiqlxIL7v4/A1foFIV957HVrOmX7+5DnkV5magkvJ7h6E7gUo5UeSeipuu1wRhe5tzYQUTUvcYd3YMdt9NRo7xJXbRzC5WafDE7HZTy5PD6Aw22pgU9O1ca+be58pPq4Q2mkreIDapLcz6sedbEFc3+Qot4bCcvbo3L2MakOo6mUxxXAYUdCoyIVl1LKD0nGCPEu8rVtJXgL0oE0+MXuYIbTA/KMlx/SF7p4XcVa5HK2PQmGptt3gr276C19HRMpB7ZLIcCTs7pRBBXZAV7vs/ofsDP/CGkozx8ioeXqdtd/+4oPhKIftZiw4jbtypcfxXbNtIgePMNZn8uMbX7/gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(366004)(376002)(39860400002)(451199021)(1800799006)(186006)(3450700001)(83380400001)(316002)(41300700001)(6666004)(2906002)(86362001)(5660300002)(8936002)(53546011)(26005)(6506007)(8676002)(54906003)(6512007)(6486002)(66556008)(82960400001)(66946007)(66476007)(38100700002)(478600001)(6916009)(4326008)(26730200005)(19860200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FYJRwQmVIbd0a1o01/B7RLS8dVP2EB5X6fNo4zky2kvm40BtDAbFJ+yrWFHO?=
 =?us-ascii?Q?jl3UAC5hh3CZHxutKfX0snaVTOFPt0IGvO7PlfjwdQfBQYxiagPfOKV2vuqy?=
 =?us-ascii?Q?mwxfoRykN9xozbP8XgUU1kLQrlG9qAQcQxZRndcvBkkyaYOQhUE7ibd1NYZI?=
 =?us-ascii?Q?XRI+KLLLzBcKrVE7G6qgXhZT1KKfvIvNiSXBuMkIDIvLxfxMx094Z8MFuSMI?=
 =?us-ascii?Q?TpYZSX/BCPv83SHi2ICjUkK5QHYCJK9moYqqHRy/7kIw5GrzlkYL3OXd4BBd?=
 =?us-ascii?Q?erIrWjwkAsweTRB8JsdNl/RnI2PK8qlhNThIVr773IgVkma7Jha+lVz+A6ZC?=
 =?us-ascii?Q?MUJjNBNd9hiAWwoP0x0ntfN5pPRT5vM1nVdKvCulsgwUCE/WiDiAZ6G2SpYR?=
 =?us-ascii?Q?6TmcBOiyDlaxmmsJ9Rb3q98xLN3fLWdgxP9j/FhyPaXHHVDW/atE34KofAhg?=
 =?us-ascii?Q?lgHFFChDQOXUZunOJViD6JcnnDGT47Zb8CVaxPZ8dR4OFgfzDa21AVLBBj5Y?=
 =?us-ascii?Q?/KK2n4GiuqzO8WRYXyTQypB4xas65hCv5B5+tjQG/nRwx+Yp6G+FTt5RE5ZT?=
 =?us-ascii?Q?Xs9UK/O+rtbJ+WJkfI4N5fLAYUCUUBTdZfXsdmqw2nmsbMfZGC10lKt8fzNw?=
 =?us-ascii?Q?MA6DqolgcWcBLDHzbVMVgvqU4lxm22T7uW0pcQlazlAL4MU+zR/jYxA22ZU4?=
 =?us-ascii?Q?Xlyip4b/mUmb2GpcdW7VURRCgJV8hjfLWLOBlyh5FKN+3uy8JwEqbMt+c1L9?=
 =?us-ascii?Q?eR1hfPAgdLeAjm+jhAfAoCBZa6ajXR+dPTu6TKQqT91MtKV8G0wJo7RmiKsI?=
 =?us-ascii?Q?4acZzTEdg1WLiZO9IFnf9joOZfPQyesufurnvpSSEaLoEiemhh9X65PWd0Zs?=
 =?us-ascii?Q?OQvQMccM9Yf9ZXvx5aiP8vAZOl9lFQoxiiZhzOS6r58Gs+eBGqRH5wLmGpuR?=
 =?us-ascii?Q?cFflgvl7YaCZX97vpascXgKyitdlDZI7HlSPowYx9h/cWy+5bP6NK2S3MI8j?=
 =?us-ascii?Q?3fiL/obeYbQ2LLX54ENZ4DOvg/tmI4MwLrSEmBMtLY3N+1gLZEtR8o0mjxGr?=
 =?us-ascii?Q?tbLUoiT2pEbEIMZ2Fr9uBH6UPY3VaJ9wfll3BlsWwtbf9tW6YX1TBWGwTZOh?=
 =?us-ascii?Q?XfSFobx2MlzlCR5Q6sQRCydnUe2tGRaQ0dE/Yw3l3cI69mL2jDk0MdnY5poh?=
 =?us-ascii?Q?9UrTbnNv22T7XZiaRpmgzpfjocW3kcL3a2wbqVqkVhlcLH3ecQWZPxZqoSTy?=
 =?us-ascii?Q?qdmKW7m5nv5MG7qAqAT/JQjcxeOazCYdT2CrswOms8yPg0cvWAbcIjm7k+gz?=
 =?us-ascii?Q?bD0jI1saAGm/QlTCjbyfjh+ragx/13bsLxdi9vZ+d+heqlU5z6XHZk6CXvkb?=
 =?us-ascii?Q?+QULTxWLyTXSIfrxHkWJstPA0Qt2RyPOfUQPYMYkYSa27jlVZuXZLJDag+Ny?=
 =?us-ascii?Q?bdnL7uJMOKQHk+aoeeXQJ1zNfNW0YG1qwp92Gnv63FnzIY5/aG9vWcnM9kHL?=
 =?us-ascii?Q?bG86K5DrzTkYhoO4qgA5em8V6WDl5ZcIQHHWlMmoEBL1enRl8i/YnGyxxFwR?=
 =?us-ascii?Q?6++oVHdl2vaBLgt2nElXqSoc69+2hFJegGU4GE+4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d43866fd-821c-48c1-b877-08db98781e06
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 01:29:48.9055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7OUxPR1X2PFYyXv6e1XdMWB3e1RQ8ViyQGto6QqZn8nwJ0fgbIJBG5e0DDzcVLlvk5wD/8Pz5u7lIEqMfdi+2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7426
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 07, 2023 at 10:19:07AM -0700, Sean Christopherson wrote:
> On Mon, Aug 07, 2023, Like Xu wrote:
> > On 23/12/2022 8:57 am, Sean Christopherson wrote:
> > > +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> > > +					const u8 *new, int bytes)
> > > +{
> > > +	__kvm_page_track_write(vcpu, gpa, new, bytes);
> > > +
> > > +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> > > +}
> > 
> > The kvm_mmu_track_write() is only used for x86, where the incoming parameter
> > "u8 *new" has not been required since 0e0fee5c539b ("kvm: mmu: Fix race in
> > emulated page table writes"), please help confirm if it's still needed ? Thanks.
> > A minor clean up is proposed.
> 
> Hmm, unless I'm misreading things, KVMGT ultimately doesn't consume @new either.
> So I think we can remove @new from kvm_page_track_write() entirely.
Sorry for the late reply.
Yes, KVMGT does not consume @new and it reads the guest PTE again in the
page track write handler.

But I have a couple of questions related to the memtioned commit as
below:

(1) If "re-reading the current value of the guest PTE after the MMU lock has
been acquired", then should KVMGT also acquire the MMU lock too?
If so, could we move the MMU lock and unlock into kvm_page_track_write()
as it's common.

(2) Even if KVMGT consumes @new,
will kvm_page_track_write() be called for once or twice if there are two
concurent emulated write?


commit 0e0fee5c539b61fdd098332e0e2cc375d9073706
Author: Junaid Shahid <junaids@google.com>
Date:   Wed Oct 31 14:53:57 2018 -0700

    kvm: mmu: Fix race in emulated page table writes
    
    When a guest page table is updated via an emulated write,
    kvm_mmu_pte_write() is called to update the shadow PTE using the just
    written guest PTE value. But if two emulated guest PTE writes happened
    concurrently, it is possible that the guest PTE and the shadow PTE end
    up being out of sync. Emulated writes do not mark the shadow page as
    unsync-ed, so this inconsistency will not be resolved even by a guest TLB
    flush (unless the page was marked as unsync-ed at some other point).
    
    This is fixed by re-reading the current value of the guest PTE after the
    MMU lock has been acquired instead of just using the value that was
    written prior to calling kvm_mmu_pte_write().






