Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8537547DE6
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 05:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbiFMDSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jun 2022 23:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiFMDSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jun 2022 23:18:41 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F3C1CB2E;
        Sun, 12 Jun 2022 20:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655090317; x=1686626317;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vc2NDR4Vbc0GZDQNzB67W1qeI0BuVtdQtSGTUmSxqfw=;
  b=F8Dx3iBfucBbhNPavTBSdlzhEzUSLGfMLjFBh9yDczSUphtvnMAvN6NU
   Y2MRq+8eVI5/TwFvXqxThG1f0eqynfAPoerRkRdin+XJkTRW1dRjHQVxz
   ECFnP5iQ72H0AGdtIKxhTfUwS65t6MVVxtQIgD0sK4oIwaRMWtlA/xLE4
   lBUKYdsij7jtgO3oMm1/lIZkLC/5HHZBa+PFbY2nNK/RNdHeWASg3FMO9
   Qh8vLJ1vt39+Nh41d5NrPFiZPCAFs2zdWsKD67dSnuFEL0SRf8NeBK5ns
   4WRxORcHL9r2LzC66Dvq5GzU9uqrxPlgHBJi/lEfbrjvlErwQZwFbW8hS
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="266842257"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="266842257"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2022 20:18:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="829556343"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jun 2022 20:18:36 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 12 Jun 2022 20:18:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 12 Jun 2022 20:18:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 12 Jun 2022 20:18:35 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 12 Jun 2022 20:18:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiStrLPRtuUIiTc79wKfF2k150X6GwaVTVfCuuUS786BFfcXBc5paenSTqu1tQiv57E9Qixb/icIELXXmRcvsGOokEFPGaaa4lTyCwReriz/zQOwwyznuO5a5hTi9mQEXcWu/hfHXchW2jy98DHv0XQVLJIfk2xPYdPT41aZsxt8z4xCzlqymkhZhkwJnTD9i8R752DxYbDROrnbpS9wgOqD6uqcOW1mC1mHqsEIVnzN73XR/nwjOU10nwtodgoU31fwY8PmtoBMiRgNfzyezojWtb95hVfO5FGpEO0mw5p/2kelJEhYDCtcezqlU9vG3KC5zciLF8/3bxxuODuOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HpHGCCfLhXuIzC81RJ+lZveXZ5qgl0oWRt2mrPh3wgc=;
 b=D8KLx4zcQhovK8GJTH90t0AqrUc1ehheBJO4Eo/7mn2ODh68AGonVxxLZxZ86k9LYFsPbX6Cqgkey+C1PtqSWIulB3gwUueG48Rw1YuELweLUW5rRIMZp20HkRQHoP3RHr7JoJa3lmzen80Jp8GXsaFzEnBxL2QFLdkTLjGxs/QcOLBRwOrYM3lpABw6gVRZsxuf0JgyJYtk8BtqXbQ5Vxes28NYEprNhX4MgM9028GJC2tPkebxpFc+f+xdgq3GxKaPIalxPjEZn01cjIXu20r0QwqJ2jHJTr6EZWIcm+4z+0pcP+A6+6cZHeXf3oMiH9bkqQQ1l5S110R4uV4Pxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11)
 by SN6PR11MB2879.namprd11.prod.outlook.com (2603:10b6:805:5c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Mon, 13 Jun
 2022 03:18:31 +0000
Received: from MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::e819:fb65:2ca3:567b]) by MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::e819:fb65:2ca3:567b%6]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 03:18:31 +0000
Message-ID: <bdfea446-623c-d423-673f-496b3725ec2c@intel.com>
Date:   Mon, 13 Jun 2022 11:18:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        "Marc Zyngier" <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Roman Gushchin" <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>
CC:     <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-mm@kvack.org>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
From:   "Huang, Shaoqin" <shaoqin.huang@intel.com>
In-Reply-To: <20220606222058.86688-2-yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0066.apcprd02.prod.outlook.com
 (2603:1096:4:54::30) To MN2PR11MB3870.namprd11.prod.outlook.com
 (2603:10b6:208:152::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5361fe13-7218-4173-5c9d-08da4ceb6427
X-MS-TrafficTypeDiagnostic: SN6PR11MB2879:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <SN6PR11MB28790CF879FC31C48205579EF7AB9@SN6PR11MB2879.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iR+UN9XkWGr3EsH8yCbP1Ew1KDjUwEefJW5zTERVqjiVbI8T2cGzv9OGMY5/10I3YWL6MhL0vTOyRF7iKCUPtj0hdcJCNZkEXzqIgucvq1T3h3Ocf7Ve5jeV8bSH6CVP7ZXwPCIFEOZC6TP1IfWWNFgS2yIhYBqZnEe/RPnzZtKON4pvrdpeftOMAM2bUDmR4nKcZBYX+wuvLCtSIyl7NzNdwIbzA0d+3zAamF6z3X9tKNkI2Qp1C5nN9gGTTWLYL94/MsPbZY8gDy+p2DJARqcsf+evpVVLxvOfpXXXc6m0YZt/Zi4A/4whF4N9Vw148WwVMuIVAUeAk9XImmn8SGWstY6q9DyJV1QwAbmwUP4P986XkCbrIxOE3xH27KjTXl64K3wTe3zrtiBdjSFDBhnc0UigjWKpzcJR9k91oSN1zea8p78OjHEUxT8U7rk8qr+rsPTX0/ie/nMBoDcjH69y0LHllLRVjJnjYenRH8mPQPkjwQgNSCWkGcLLKwYi0luNPvZS2kR52+bskwf5uUhxB+hbxNCP4x04B6N5VgZaZiwIsZCGJEwszmLcWbOeQkjuvem7tyscH4ZvKRwG8Uey65K3tFIhRIeXRHhyeAOT0jaORA2utoojzLoRJeIEwRINyUk2Sye5x4OPOp9V10NmFA3mXN5A/md8rKVgU0YpwzQ0DoXWhiZLWpDRM+mTQi+EGIMWe31yYRbWpShyMtWptf0ADa2TgcfsNpZSxPGrbyTiN6gzqTSKGUGtbO7w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(110136005)(7416002)(38100700002)(8936002)(31686004)(508600001)(53546011)(5660300002)(31696002)(86362001)(316002)(921005)(82960400001)(2616005)(2906002)(6666004)(6486002)(36756003)(6506007)(83380400001)(186003)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2g2MC80NEhxQlV2bEpnbzVSL3F2UmE5dFVvSktVMGxRZ0lHVHc4L0dsQkw3?=
 =?utf-8?B?MkN1OE1pY0hKUitNNjQvQ0FnUDdITVJhbGJaeUFmeksvOVFHMm1VemJEbmtn?=
 =?utf-8?B?RVRpbjl0d204QUZEcTBDdERQbEFTNjJhTWNQcDl3NEtQRnlzcUhaQ3lsVzFx?=
 =?utf-8?B?ZTJINlZVRVZaWFFPN2RWZ1ZJUjNWSWpmV0FOaGlTR2R5RXY3QWwvUTZxYzQ4?=
 =?utf-8?B?S1VQWmZ0Yk5pY0h6RDhLdkI4blhscFpUby83T09xbGFNTDBXQXBzWlF2YlJa?=
 =?utf-8?B?WlluWEZ3dUFqNEJ3NDcxV3JDeHRWVHA5QlVUM0JiVXV1ZXQyZEpDWTdsSmdL?=
 =?utf-8?B?cHRJRzQzcWlLOFNvSHdmY1pBS0FDYUx3RVRiRm5BRUplMkFSbi8rMlFleFhu?=
 =?utf-8?B?ekFQY0hhT2tObWFmQVdWeFNBdGtKTDJXV3hLTFJLQkcwYXFhMEU1bk1LT0F4?=
 =?utf-8?B?a2hJWURLeVJQU1hxd0VhRnFLYUZUSUtINFNKekE3Q1dnaVJPbUw3ZE1hUzF4?=
 =?utf-8?B?TS9kTHVibHJwb2c3VGpFUWd2NldvTHpJa2psMHA5eHVQTVQ5bndOWGc5Rmtq?=
 =?utf-8?B?bTRpMWx4ZU5qZFJIeVB4NENjVEFObndpeDF5cXJXSCtRWVZESzRBV1VHak5Q?=
 =?utf-8?B?SzNVRUdpSzZuZmxZUXV2R2NCcDlybFlYYTExR2R5em1qTUI0cDcrZlNUellu?=
 =?utf-8?B?OFVFSUxXMUYvSmZ0ZDhDK2NCTWdzUmY4K0NqdUs1UXF6WkZ4NHRuaHp1Z1dy?=
 =?utf-8?B?R0oyV1lWK1BZOWIyRlFvdjFKQmYxQ3RQYmRISEk1NU5URTdZNzNudEw3WHE4?=
 =?utf-8?B?R3lTSE9lTUdtL3dIaTBWYStVTU9pRnlPeVJHU0pJLzNWVnJZMHhOS25YeDhK?=
 =?utf-8?B?bHZHVnlWRTFKY2daK1dGZERRVU5iOTJ3Mks2QW5uWXZxU1Z3a1AxcEZDZ254?=
 =?utf-8?B?YnV3L3hpcUpCb2hXWVBWZnpWQUVGN0pLcXJoTG9BM0orSXRZanhZSURLT21Z?=
 =?utf-8?B?a3RpZzdPQzZVcG4yVEhDK0hhREtOcEYzdlU5TVczaUxvVXVGTDhzV2k2MjBB?=
 =?utf-8?B?SVlrSnhPeGRCWXJLc1RYcGx6aDNOdzhKdWxCK0pscHZHdzVlQjA4VnlucjUy?=
 =?utf-8?B?ZW1mZEhSNyttbVFKMTFlY2Fvb3NLU2FEcEc5YmxhOWY5ck5BMHY0cE5mMkRL?=
 =?utf-8?B?OHp3VU1jUWszM0tESkVRVDFGbitJWG1oTFk2WTAvdVNoK292R3BYdUI2aTNN?=
 =?utf-8?B?eFRUWVNUYk1uTmVDdkxRK0IyTllnSEsrd0FUVDB0cWwrZ2lJNCt0QkM3QUFh?=
 =?utf-8?B?MmpCYWxObmNOdWZFOUxWaXFsOGwwNjFWN0hubFY5MXh2K3MzNHpLZGJiR1dr?=
 =?utf-8?B?eU01SDM0WUIweTF3RlZUK3JyMHEvdHA1eUNiV2VMZlF2OS91V2FxaUdHeTh2?=
 =?utf-8?B?dWlIenh4ajFxbmNSZ09mdU1LTXRPZnI5UHRWQjhEYmE4Y2wyQkdBckt0TVVR?=
 =?utf-8?B?Tmo4b0RNL1U5YmNhNnQ3YStUVmcvbWdkL2pTYUJVbjA3T0txNlI0ODJyM0xr?=
 =?utf-8?B?NnBhTVhpMEcvZGxyWmFvYlBsbUdXWS8rVWVKeVd4MjFIQnZrNjRQaUdZLzRB?=
 =?utf-8?B?cUNXUkZBcGs5RFNFUFZGRHIxMGo4TXVKOWZxU1A2T214bGxScjNrVmNkS0RB?=
 =?utf-8?B?N2JnWThld0pGdmRET1JIL0crTHhMTm5DenphSGdRMU5OcUZYOXowSC9ST1Vx?=
 =?utf-8?B?L2FyY0RpRzdoTnNreU5QVTh2aVp2UE51aXBMTnNGbmpOZG9jK3RBN2MwdUk5?=
 =?utf-8?B?Q0hvV1RRejNaZitiaG1yRjJ2Rm9YWCt4cVNrSVEzUzgyWGE4Z1MvWHdPaWdZ?=
 =?utf-8?B?MCtldEJSSkFUbDh4TmNlclJxNUtpWndMUVBlUkZDeTVjbzAvUkJKYTVjSjAy?=
 =?utf-8?B?TUNpM1FRT0ZxWVZ2WjRsTWsxSEJPWG9uYmVEbzVwYVN0OUpsZzhBL0ZxanRw?=
 =?utf-8?B?ZmNnUERzVWhUcG9EMjFBR0t0NFZoMGFoVzBJdUhPMC9qV0JEeFI1QVJmUlZT?=
 =?utf-8?B?R28raUI4TDVmQ1ZRVUpOQzRjTFptQU14NXZnVEJtY1dxb3h6b0lJYXlQUGF6?=
 =?utf-8?B?SEtCaWVlQy9BNmYzb0FSUjRuNGVzTVk3WEl0KzE3U295dWNQZTNaNWtJY1NZ?=
 =?utf-8?B?TDdHV1l2WWdKcUlYSEZueklwNk9Oc0FzTG9YMUVJczFLRW0vNWZRRkQ2NEdK?=
 =?utf-8?B?YWdubkZ3TGY3OFZycXMrNUF3MmV2dktpWENPQXpYOEYwL09XZWpNYTduY21l?=
 =?utf-8?B?YWxkRU9uam5IdHhBclpSTUpCb0RVanpycFhPVzRaVm4xN2hVNFdld0Y2WmJR?=
 =?utf-8?Q?Yago5cwbZAf3wz/s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5361fe13-7218-4173-5c9d-08da4ceb6427
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 03:18:31.2360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iy2+gHJ0aLHdxtER0EpkQk1M4DlOohUETodi/mzACfqyBwqumc2hIWej0pN48/fcJbtm/gv4tdcIG9aR7lgHlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2879
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/2022 6:20 AM, Yosry Ahmed wrote:
> Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> KVM mmu. This provides more insights on the kernel memory used
> by a workload.
> 
> This stat will be used by subsequent patches to count KVM mmu
> memory usage.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   Documentation/admin-guide/cgroup-v2.rst | 5 +++++
>   Documentation/filesystems/proc.rst      | 4 ++++
>   drivers/base/node.c                     | 2 ++
>   fs/proc/meminfo.c                       | 2 ++
>   include/linux/mmzone.h                  | 1 +
>   mm/memcontrol.c                         | 1 +
>   mm/page_alloc.c                         | 6 +++++-
>   mm/vmstat.c                             | 1 +
>   8 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 69d7a6983f781..307a284b99189 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
>   	  pagetables
>                   Amount of memory allocated for page tables.
>   
> +	  sec_pagetables
> +		Amount of memory allocated for secondary page tables,
> +		this currently includes KVM mmu allocations on x86
> +		and arm64.
> +
>   	  percpu (npn)
>   		Amount of memory used for storing per-cpu kernel
>   		data structures.
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 061744c436d99..894d6317f3bdc 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -973,6 +973,7 @@ You may not have all of these fields.
>       SReclaimable:   159856 kB
>       SUnreclaim:     124508 kB
>       PageTables:      24448 kB
> +    SecPageTables:	 0 kB
>       NFS_Unstable:        0 kB
>       Bounce:              0 kB
>       WritebackTmp:        0 kB
> @@ -1067,6 +1068,9 @@ SUnreclaim
>   PageTables
>                 amount of memory dedicated to the lowest level of page
>                 tables.
> +SecPageTables
> +	      amount of memory dedicated to secondary page tables, this
> +	      currently includes KVM mmu allocations on x86 and arm64.

Just a notice. This patch in the latest 5.19.0-rc2+ have a conflict in 
Documentation/filesystems/proc.rst file. But that's not a problem.

>   NFS_Unstable
>                 Always zero. Previous counted pages which had been written to
>                 the server, but has not been committed to stable storage.
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index ec8bb24a5a227..9fe716832546f 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -433,6 +433,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>   			     "Node %d ShadowCallStack:%8lu kB\n"
>   #endif
>   			     "Node %d PageTables:     %8lu kB\n"
> +			     "Node %d SecPageTables:  %8lu kB\n"
>   			     "Node %d NFS_Unstable:   %8lu kB\n"
>   			     "Node %d Bounce:         %8lu kB\n"
>   			     "Node %d WritebackTmp:   %8lu kB\n"
> @@ -459,6 +460,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>   			     nid, node_page_state(pgdat, NR_KERNEL_SCS_KB),
>   #endif
>   			     nid, K(node_page_state(pgdat, NR_PAGETABLE)),
> +			     nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
>   			     nid, 0UL,
>   			     nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
>   			     nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index 6fa761c9cc78e..fad29024eb2e0 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -108,6 +108,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>   #endif
>   	show_val_kb(m, "PageTables:     ",
>   		    global_node_page_state(NR_PAGETABLE));
> +	show_val_kb(m, "SecPageTables:	",
> +		    global_node_page_state(NR_SECONDARY_PAGETABLE));
>   
>   	show_val_kb(m, "NFS_Unstable:   ", 0);
>   	show_val_kb(m, "Bounce:         ",
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 46ffab808f037..81d109e6c623a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -219,6 +219,7 @@ enum node_stat_item {
>   	NR_KERNEL_SCS_KB,	/* measured in KiB */
>   #endif
>   	NR_PAGETABLE,		/* used for pagetables */
> +	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
>   #ifdef CONFIG_SWAP
>   	NR_SWAPCACHE,
>   #endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 598fece89e2b7..ee1c3d464857c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1398,6 +1398,7 @@ static const struct memory_stat memory_stats[] = {
>   	{ "kernel",			MEMCG_KMEM			},
>   	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
>   	{ "pagetables",			NR_PAGETABLE			},
> +	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
>   	{ "percpu",			MEMCG_PERCPU_B			},
>   	{ "sock",			MEMCG_SOCK			},
>   	{ "vmalloc",			MEMCG_VMALLOC			},
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0e42038382c12..29a7e9cd28c74 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5932,7 +5932,8 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>   		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
>   		" unevictable:%lu dirty:%lu writeback:%lu\n"
>   		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
> -		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
> +		" mapped:%lu shmem:%lu pagetables:%lu\n"
> +		" sec_pagetables:%lu bounce:%lu\n"
>   		" kernel_misc_reclaimable:%lu\n"
>   		" free:%lu free_pcp:%lu free_cma:%lu\n",
>   		global_node_page_state(NR_ACTIVE_ANON),
> @@ -5949,6 +5950,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>   		global_node_page_state(NR_FILE_MAPPED),
>   		global_node_page_state(NR_SHMEM),
>   		global_node_page_state(NR_PAGETABLE),
> +		global_node_page_state(NR_SECONDARY_PAGETABLE),
>   		global_zone_page_state(NR_BOUNCE),
>   		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
>   		global_zone_page_state(NR_FREE_PAGES),
> @@ -5982,6 +5984,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>   			" shadow_call_stack:%lukB"
>   #endif
>   			" pagetables:%lukB"
> +			" sec_pagetables:%lukB"
>   			" all_unreclaimable? %s"
>   			"\n",
>   			pgdat->node_id,
> @@ -6007,6 +6010,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
>   			node_page_state(pgdat, NR_KERNEL_SCS_KB),
>   #endif
>   			K(node_page_state(pgdat, NR_PAGETABLE)),
> +			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
>   			pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ?
>   				"yes" : "no");
>   	}
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index b75b1a64b54cb..06eb52fe5be94 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1240,6 +1240,7 @@ const char * const vmstat_text[] = {
>   	"nr_shadow_call_stack",
>   #endif
>   	"nr_page_table_pages",
> +	"nr_sec_page_table_pages",
>   #ifdef CONFIG_SWAP
>   	"nr_swapcached",
>   #endif
