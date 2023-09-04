Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6717913F8
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 10:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349741AbjIDIx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 04:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjIDIx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 04:53:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E3C12A;
        Mon,  4 Sep 2023 01:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693817602; x=1725353602;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=T1UdlfRyh6zocWKFdE++UtyujSOIwGUBVG8JX+rjvjs=;
  b=NykUCjs+Ke/xadh1cTFSNZ6CIH87u3DYvo2V7MXT2Ta4r8g2axzJR9V4
   jyVdrUMBOfCdzImybSweUJneIRcrBdnrXGUM4h672mju1zif0oGyJF6Sf
   iiKRi/eWkKX+7VGJbuc5rUWT+7TNQhInHh+a6qVLJv4F+Vkw9deVvn8Dg
   Db73WMhxXoUDWDuPNOAGMcq2PiERAIjR0FmeisAp+0/wrcHmSLTG3i+/c
   43OZ5no8maMD5J61SO0IIAuQTnR+Tq/eocRIj/9Slft1Qt49Q0tp42yh2
   qPfhtiQoUztAZsfykaAJ07CPBCxWZNEIcHkDA3U9WCaK7tw/caO+vigPc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="379267880"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="379267880"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 01:52:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="743865898"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="743865898"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 01:52:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 01:52:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 01:52:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 01:52:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRnPeSigbHSqksggMIpUNZwVAgAw8VdQdxhvjXq9FAW2xZpKbpMMHpGVoXV0NDZyOhbJlV7hAYjHJdnU8ujV9Co3WyBVoMNpDdyZwNw3Dr3D15sdbGHR8LErg57isG5BYadJO2MDRTgCUnNTZQjrNiDWdmo0VRS1GTPPlKW3bXAiwJGgrBzgV5Od5h0gYWoMwA/5JzAf+XPO/58wdCoqcExkUEtNt4s8JGo0VPzF6J2U/8LKdLARGQaGA65ZHk/kax7kbIgfS9stbL8vogtPPUyR2fCW1IWdusYKOxGWW0p4K4h5vDDS0pCWV5LmFeuPNBFuLfYtpf4LUowNefGPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+V0kKSGyIPUHkJ8F84Fe02/O9v+GLlnLMjI7OwLTZ8=;
 b=ceD1N1DlX3gXRRUk1oyq1Wqu9C5aR4HiEtD1EpJhSJuTRvAZfFqwOnd6YS1nOV2DYNs1RDW1C+3Q9Tr4MAd52Ij9bwksAIkdRBJc7p13BbBiqrNqV69tA3vUToxhGtdUztNuo42ntIArEqYiqF1mQk0y+Fab7cZszMvhUOdTkq+Maq0yDjaVFtCZz6Y2nPwBXHEaiR/af3i1rYkZCbK5MvfSza9a6hcQSaE5T5K89MwANxxRlUt7GQaXkakh/enwLWio02rbuxDq6XvnzEIWVW2UWgx+ggh43j0UieCAZIcNij/CTMpnlcHzHHDvTt6RW5ahzIN1zxiOPtVZDU7wCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW3PR11MB4697.namprd11.prod.outlook.com (2603:10b6:303:2c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.32; Mon, 4 Sep 2023 08:52:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 08:52:10 +0000
Date:   Mon, 4 Sep 2023 16:24:30 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 09/12] KVM: x86/mmu: serialize vCPUs to zap gfn when
 guest MTRRs are honored
Message-ID: <ZPWUPnzkqs6AnhMy@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065454.20688-1-yan.y.zhao@intel.com>
 <ZOkvbzR0Sft1lnD1@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZOkvbzR0Sft1lnD1@google.com>
X-ClientProxiedBy: KU1PR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:802:18::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW3PR11MB4697:EE_
X-MS-Office365-Filtering-Correlation-Id: e729e895-3287-498f-aa76-08dbad2439e8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PnAthYVTvwQ9YweLxEFSJgaPRz8pJvIylfsVnfgX7xWAOAynWPmFHK13pVoK6f9pO1kT6unLjPbGuEZax83NndrMQXnDyo/H01DnGLaYvmvbfeUaLboGRJ4ENzrmqVvCCwAVd7Q8qrCvmSiyK1H4Y2rg4F+n3Gq0qbppTCbtVovDpgdWAek6BPY9RGBmvlCRR1I3ExBokn2Od+EI1Y0ttgAfMqMbScx/lc2vA1c4DgQ5DnyX+NdjNg7tyW5J4JeJy7z7f68tBzm/1VStV4yh5IYXSGYuv0lIje3jerPWQxTua81HeGDV2rRh6nJQrXqTHIBPo3fvZXB63bys6l6WcdPWaGcDfwAgR+4wLiW67U9aAmjDgLuDwMWZA32JZUlXjmHT0kWwz1rUuOfVgf/lP6ptjGynKgvieN5XTYUIYaF2eWP3iJpdNJeL01cb+mLTfvt85OXM5W/k48vK6F0B5hC0PwjrHc7dDpL1U/ycj2WAXqGJDbVyhRHCEJsNXmHwJg+jG9GG3EYOAwQL1ymCYenNSXH3eDk2PXEYRxsXY0NmcNp4Ychn1ep78Zt9HqYO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(39860400002)(136003)(346002)(186009)(1800799009)(451199024)(6506007)(26005)(6486002)(6512007)(66899024)(38100700002)(86362001)(82960400001)(83380400001)(3450700001)(8936002)(41300700001)(316002)(4326008)(66476007)(6916009)(66556008)(5660300002)(66946007)(8676002)(2906002)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PEOBUQ0GG6T3ZcXJJ65oNzQhcC5j6hDwSoYo3II1ph0AATmctLLUHnvhkTeN?=
 =?us-ascii?Q?c2MCRiJKWvLKrnFfljPgFmwe7He29LSVMnW3Sud9SVV8wueHrnhDpYyMU0EE?=
 =?us-ascii?Q?pePfJFDQxOFwz2KwTsTrrHIrAqhW5KEn6Xj0GRb3ofzxaZ5ctA9z5vtf6KB7?=
 =?us-ascii?Q?9MmpS88cqWh3+ntNbf9ogEa6Fk8zDYJYLpWBnIhXAK2xBDuscqm/VWJK+Sbm?=
 =?us-ascii?Q?MIaFlTLyp1XTJVt+bqcVBcSfr44kDqoADo29Q7PX3qD8DL+AqhJ0s3bKbp3k?=
 =?us-ascii?Q?ZFQGJvM4Hs4hTCwfLHCxOBroEXQsKq5Ozcb1rrLe1HlpwL0MB7dv9PiXpwT9?=
 =?us-ascii?Q?mjwgkk4Medx/coCX1f/KWpWiQBqtI5uscxTrzIieh7SJM/tLS/LCzNpRBWFB?=
 =?us-ascii?Q?1kPPCLa+S5PxIeRv7as/ionVdTalZ8RHjxdJ+oayCnrQcdIGW9OKb6EeImR1?=
 =?us-ascii?Q?vB8ULfNn7Qs7G6yh07zv3hE85UDERk4QCcwjzq9XsBaZKxL+tT601UsBW8cu?=
 =?us-ascii?Q?VPYaCHpOEjVEIo5cRIIg3Y68oenobMqAwo3Z42/9VynW6xT76DSoKVX7x18y?=
 =?us-ascii?Q?26YtF1GeAQOebLR+NR4BnA8WhfoVx5Wzz1wjS8pujXrXJ5JQfiA81x0Aq5hB?=
 =?us-ascii?Q?3w6OaUTyzrmWfxFXjn9p1FCxnNkIhPUrwgkAyyqH398LuRmPn/UfyT52uE6Z?=
 =?us-ascii?Q?gN/eW0HLaK9dtd/C8Zd0JY+dmvGioSfMkJGHY00hdlc+cRgvjgZh2dKTl7Kb?=
 =?us-ascii?Q?q5DCxOddYEZxlOsd4olxvgwJ6nHm1O1irjvVWToEVw/qD4frpwkTQ9C5azVz?=
 =?us-ascii?Q?fyaGZteBKFUUcuvSEdLoODYkC9JKRl+ifzh5s9HMBDWG1rZk1s6Zll30sadR?=
 =?us-ascii?Q?VpJ1nbWfxg3uVkQ/rTuet7pQOydHv7y58ttKjcJqIt5Q11dnrQ/xte+9W7Et?=
 =?us-ascii?Q?dtx+zryW0Ka3AeH4vshDcHYdug8O0xNfZ+lv7W4/YmwQxPuzSmt73R2DLVAe?=
 =?us-ascii?Q?QhfTpEJfokde8Zi6ffPX3ZQ7vabkOr8Y2VBhiSM7q+03uDOK6cbSYRvuSvaz?=
 =?us-ascii?Q?ofoSVDBQWHdA4QK6Ab8N69ur1UKk9oavJ+O8IrR2sc8vhrYE8xczkLOQ3dlP?=
 =?us-ascii?Q?w1gM1swznexhzjB4R783pNjAzNy+pdjOMubG2398engME+xCtkrBk0wkhIz6?=
 =?us-ascii?Q?zxseFx0Q7VIOpFApGNwwFO3fSk0Pp/2GzHhyO42/su+PiqDDo6lwyfYmse0R?=
 =?us-ascii?Q?lVQtZswHwPEuA8OFwm3AvPcOJ/1mtuEKOubP8Wj+FsaW81gwHlpPeL+nYpGL?=
 =?us-ascii?Q?h4o7CBiahvwLrKem4SF9L/+3tfgiE0T7ocAue7Ji6OJVDLC0kBN893Y62uj+?=
 =?us-ascii?Q?GltylBgcvQFrQ0xo8ZzTv3LuNqNAdJ1hXMXDMeKdub/j+D+88EYIjeAB9siJ?=
 =?us-ascii?Q?MG5KcsUUon/tKQgq2R2Xv8UzmDmYsDfwIJA+pe7MzSrdItwpwCkJsEEuM9FX?=
 =?us-ascii?Q?EiaKwTXGn3l8xHMoUJoyoqIhvRi5i14a87in/sT4oz0Ll/560L9u8owC+/Gx?=
 =?us-ascii?Q?0ghH6CNorZOLRblSg/byaQ+BcI2lQRf/ZbAGqdon?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e729e895-3287-498f-aa76-08dbad2439e8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 08:52:10.7209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d920ia+sMM60gUfwZFxy6QxvFtLaaHb011xK681nM5iMJQTmC6tdM+vC9vT9OV1j9BmAAWaCWHIiXN6a+Q4JNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4697
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

On Fri, Aug 25, 2023 at 03:47:11PM -0700, Sean Christopherson wrote:
> On Fri, Jul 14, 2023, Yan Zhao wrote:
> > +/*
> > + * Add @range into kvm->arch.mtrr_zap_list and sort the list in
> > + * "length" ascending + "start" descending order, so that
> > + * ranges consuming more zap cycles can be dequeued later and their
> > + * chances of being found duplicated are increased.
> 
> Wrap comments as close to 80 chars as possible.
Got it!
I thought it's easy to interpret if a group of words are in one line :)


> > + */
> > +static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
> > +{
> > +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> > +	u64 len = range->end - range->start;
> > +	struct mtrr_zap_range *cur, *n;
> > +	bool added = false;
> > +
> > +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > +
> > +	if (list_empty(head)) {
> > +		list_add(&range->node, head);
> > +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > +		return;
> 
> Make this
> 
> 		goto out;
> 
> or
> 		goto out_unlock;
> 
> and then do the same instead of the break; in the loop.  Then "added" goes away
> and there's a single unlock.
>
Ok.

> > +	}
> > +
> > +	list_for_each_entry_safe(cur, n, head, node) {
> 
> This shouldn't need to use the _safe() variant, it's not deleting anything.
Right. Will remove it.
_safe() version was a legacy of my initial test versions that items were merged
and deleted and I later found they don't have any performance benefit.

> > +		u64 cur_len = cur->end - cur->start;
> > +
> > +		if (len < cur_len)
> > +			break;
> > +
> > +		if (len > cur_len)
> > +			continue;
> > +
> > +		if (range->start > cur->start)
> > +			break;
> > +
> > +		if (range->start < cur->start)
> > +			continue;
> 
> Looking at kvm_zap_mtrr_zap_list(), wouldn't we be better off sorting by start,
> and then batching in kvm_zap_mtrr_zap_list()?  And maybe make the batching "fuzzy"
> for fixed MTRRs?  I.e. if KVM is zapping any fixed MTRRs, zap all fixed MTRR ranges
> even if there's a gap.
Yes, this "fuzzy" is done in the next patch.
In prepare_zaplist_fixed_mtrr_of_non_type(),
	range->start = gpa_to_gfn(fixed_seg_table[0].start);
	range->end = gpa_to_gfn(fixed_seg_table[seg_end].end);
range start is set to start of first fixed range, and end to the end of
last fixed range.

> 
> > +
> > +		/* equal len & start, no need to add */
> > +		added = true;
> > +		kfree(range);
> 
> 
> Hmm, the memory allocations are a bit of complexity that'd I'd prefer to avoid.
> At a minimum, I think kvm_add_mtrr_zap_list() should do the allocation.  That'll
> dedup a decount amount of code.
> 
> At the risk of rehashing the old memslots implementation, I think we should simply
> have a statically sized array in struct kvm to hold "range to zap".  E.g. use 16
> entries, bin all fixed MTRRs into a single range, and if the remaining 15 fill up,
> purge and fall back to a full zap.
> 
> 128 bytes per VM is totally acceptable, especially since we're burning waaay
> more than that to deal with per-vCPU MTRRs.  And a well-behaved guest should have
> identical MTRRs across all vCPUs, or maybe at worst one config for the BSP and
> one for APs.

Ok, will do it in the next version.

> 
> > +		break;
> > +	}
> > +
> > +	if (!added)
> > +		list_add_tail(&range->node, &cur->node);
> > +
> > +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > +}
> > +
> > +static void kvm_zap_mtrr_zap_list(struct kvm *kvm)
> > +{
> > +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> > +	struct mtrr_zap_range *cur = NULL;
> > +
> > +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > +
> > +	while (!list_empty(head)) {
> > +		u64 start, end;
> > +
> > +		cur = list_first_entry(head, typeof(*cur), node);
> > +		start = cur->start;
> > +		end = cur->end;
> > +		list_del(&cur->node);
> > +		kfree(cur);
> 
> Hmm, the memory allocations are a bit of complexity that'd I'd prefer to avoid.
yes.

> 
> > +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > +
> > +		kvm_zap_gfn_range(kvm, start, end);
> > +
> > +		spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > +	}
> > +
> > +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > +}
> > +
> > +static void kvm_zap_or_wait_mtrr_zap_list(struct kvm *kvm)
> > +{
> > +	if (atomic_cmpxchg_acquire(&kvm->arch.mtrr_zapping, 0, 1) == 0) {
> > +		kvm_zap_mtrr_zap_list(kvm);
> > +		atomic_set_release(&kvm->arch.mtrr_zapping, 0);
> > +		return;
> > +	}
> > +
> > +	while (atomic_read(&kvm->arch.mtrr_zapping))
> > +		cpu_relax();
> > +}
> > +
> > +static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
> > +				   gfn_t gfn_start, gfn_t gfn_end)
> > +{
> > +	struct mtrr_zap_range *range;
> > +
> > +	range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
> > +	if (!range)
> > +		goto fail;
> > +
> > +	range->start = gfn_start;
> > +	range->end = gfn_end;
> > +
> > +	kvm_add_mtrr_zap_list(vcpu->kvm, range);
> > +
> > +	kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
> > +	return;
> > +
> > +fail:
> > +	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
> > +}
> > +
> > +void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu)
> 
> Rather than provide a one-liner, add something like
> 
>   void kvm_mtrr_cr0_cd_changed(struct kvm_vcpu *vcpu)
>   {
> 	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> 		return;
> 
> 	return kvm_zap_gfn_range(vcpu, 0, -1ull);
>   }
> 
> that avoids the comically long function name, and keeps the MTRR logic more
> contained in the MTRR code.
Yes, it's better!
Thanks for you guiding :)

> 
> > +{
> > +	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> 
> Meh, just zap 0 => ~0ull.  That 51:0 happens to be the theoretical max gfn on
> x86 is coincidence (AFAIK).  And if the guest.MAXPHYADDR < 52, shifting ~0ull
> still doesn't yield a "legal" gfn.
Yes. I think I just wanted to make npage to be less in kvm_zap_gfn_range().

kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);

> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 32cc8bfaa5f1..bb79154cf465 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -943,7 +943,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
> >  
> >  	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
> >  	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> > -		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> > +		kvm_honors_guest_mtrrs_zap_on_cd_toggle(vcpu);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
> >  
> > @@ -12310,6 +12310,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >  	kvm->arch.guest_can_read_msr_platform_info = true;
> >  	kvm->arch.enable_pmu = enable_pmu;
> >  
> > +	spin_lock_init(&kvm->arch.mtrr_zap_list_lock);
> > +	INIT_LIST_HEAD(&kvm->arch.mtrr_zap_list);
> > +
> >  #if IS_ENABLED(CONFIG_HYPERV)
> >  	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> >  	kvm->arch.hv_root_tdp = INVALID_PAGE;
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index e7733dc4dccc..56d8755b2560 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -315,6 +315,7 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
> >  					  int page_num);
> >  void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
> >  					   u8 *type, bool *ipat);
> > +void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu);
> >  bool kvm_vector_hashing_enabled(void);
> >  void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
> >  int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
> > -- 
> > 2.17.1
> > 
