Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0712769596B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjBNGsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBNGsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:48:17 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216862D48
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 22:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676357296; x=1707893296;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nEgYksGvDvk1sPy2HuF2JgeMoWMZVnyXn6kyUWITcbo=;
  b=S0I4r/W+mg6afCHk48A2s6YUvb9SELmJXrFdQhuRJMCVh0N1nypZSXDv
   44tqyy5blOl1kD6O8MhR/gWKmCVpik3HoCQa3ZyjgwsPiPUl1MdSW3XwF
   jVLl6691FSLgdDxhvgGZWEjYHe1z7OcZfXZsD5bFZ9ltmECTZMyTmiPBL
   1BiBpEOuV7lfeg6DcI9lPeITVaUIfVIktcg1XGRsMK+2My1jSWPzTHNJ9
   Q7mJYqNrlJ4ETWarksZxXRwDrAAe+Xm0Mj+LLLQNm5SoeBOVW1oBnRk+2
   ByVYa0Q/g0b9Wu6G+JGBSIZgzGksqshz+X2a478j1jrFjQmEYPwMF2QOF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314737132"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314737132"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 22:48:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701556104"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701556104"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2023 22:48:02 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 22:48:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 22:48:01 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 22:48:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTtnMsFSOjIEk4qEf/2MABWoU1URUrThfAaQYrUFD7luGc7dIvnYB5yw3E3lBmNdZb4tqbRK1RDML4yac6Y/FkgcTo8f3iKlRdeCanDlyUR5wv+7iDdu/V75CQySyH67wHXArT668SzglNFPWx65SGsKmP9ys3gPNTBH9S3TqlMBwRTzWpp5ZiUbWtnc6fBvDBpoORznX9iFVV/NUysjRHQ1wuoOU0Up2jxev3LtbdX5ja11KsYgljRxgPIGGp0RuNg74LcE+JoLBAs3h534dPuvNJgeNoiwG8AaYHGiE7QzkYyT82TGpr8vaYnpcMY9xPyAlLAsVX231nW2rpGM7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oIFKmX668OAHR9XMV+HPHFoAweuMV2BTJnUpan+Gok=;
 b=SgEgeM1GTxxtiCkSjTi4uvimAQbFIv6k6cAlg7yqeRo/u7pvxswAeyynPT03ZOL5q5MJEwnN3NRCSGcEpesOEr6hdV3vuqCQq58VvoCpdS3Na4zzeU/QdVuiu+pHlMPCz+5Hj4YCMZ5B2YE52XOrr7A3li8sIq2GkcD4Qe9rlYQ2xV9ocbJx5dOa61WUMQQ232YyLX3KZHuVjU3HYD6Bxv7vFteo9t2BJr1uy+VSbAbAn9Uptp6A3p30PUx/hYjbWEGD58WgkPiz8otjJ+Wn0BTmj2WGmpoePWw3cUZqkSxZFK0Jhl9eofpwTzuDswxe+mDCKrJ7oHatYOtOQzeZkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA3PR11MB7462.namprd11.prod.outlook.com (2603:10b6:806:31d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 06:47:59 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.022; Tue, 14 Feb 2023
 06:47:59 +0000
Date:   Tue, 14 Feb 2023 14:48:16 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 7/9] KVM: x86: When guest set CR3, handle LAM bits
 semantics
Message-ID: <Y+susAC6ZshFEdpn@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-8-robert.hu@linux.intel.com>
 <Y+mvG8S3W5lXoZNJ@gao-cwp>
 <8ece08328b0ab07303140b9b731e252cfdb38b1f.camel@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8ece08328b0ab07303140b9b731e252cfdb38b1f.camel@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0209.apcprd04.prod.outlook.com
 (2603:1096:4:187::12) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA3PR11MB7462:EE_
X-MS-Office365-Filtering-Correlation-Id: b91b802c-327f-4248-11ef-08db0e5768d3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mPphx51YEts+R/VOXO8XJWpMvA7IsmhMkYkMSlZcGJfp5j/CihZQ0PsM1xSIZDxpwizsCggVfEFy1Jm2ETgS75+Iecxd5OYaYVjO/w8sWNRQsUKq84246O+Y0Hx/u00s11gri5RYTiaapMBynChPKPR3w6Jx8d90lYZVdjjZDX5/Wkc1yG88XyMb7VhIUb4AQP27cngbcZn/d2I8Habt9YNCAoNXKbAhho0b7dXMaBUU+zXVpt0mBqidB0qtAE1VfKJ5ecy3HIUaMx5zuhPXyLotGt6A0YEIECt83uD9wP0Dahn9zYVggeS00lKzqu7H448pKllNC20AsdAeXTCqHmzKkXnLmy86ZSDXXgc5JuEWvo1EzObYBZykSWcyAuG0tybFCx7FVdo8szGOOrZvZxbLY2I9qWJH4OlWVbKymZzRp7WdE6gQCet8iKM9K/383yBlfvfuhA+pBF1bdx77Abro9pGBFcL/IJKcRkqVeaFJX6MWU9SkuLsvujAgZcBNUsjb+iFAZJV6XHA+kFYsQJP1zVUrA3T6+V9cQYsMjuqP0o1K3o8ay6/bu4zGyEOkcG5oQalVof/X0HnjAc1XkgvdW61sS9HooMR7TxbqMzn2MLJNXVJEdIQbyFLz/+eVrLnzYVf0j79csLZYiDhVQgbSoRWDRtqgfNCGvg1dkX+0AcWKSwCspNo60uD9hPCT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199018)(2906002)(41300700001)(82960400001)(38100700002)(478600001)(6486002)(26005)(6512007)(186003)(9686003)(4326008)(66556008)(66946007)(6506007)(8676002)(6916009)(316002)(86362001)(6666004)(83380400001)(33716001)(66476007)(5660300002)(44832011)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5OISKUeNebRtRrTEHU0l463KO7A4kSWVlrfaNu0ct9g7OfUWV5E9LZejwaqR?=
 =?us-ascii?Q?6wvTCnnkmHtOmPAYdYXIh+NC7L1Y/M8ysXAqHaSTo1irqdZZ8qmIvhiRW/Sy?=
 =?us-ascii?Q?/KIV7k025V0uVvvel7AfEC3bXzc9TD837xho3hvkSLhuMubEjXuuejN+R58v?=
 =?us-ascii?Q?MHw19Nf25bMKMIZB8rSBcwwL/dWxb0QhrYG3llhAoLvjcZVV5E6FSTK0Wzk6?=
 =?us-ascii?Q?aCXqCAyiQyORfcyB3sd410eaTbxZvsvPpbxUuCI1krVU7kGRCg0p/ciLkUHN?=
 =?us-ascii?Q?ieolVK7Wo/mHVPdF8TmVn6uFaE+w1OrEqFk0xyWpqRA8tzv2oaUp83XE94mI?=
 =?us-ascii?Q?2F2loydi4VHL2j5PWFT7gxMhfyJTlYbRUk4XYSzv9UYrvO4eYkPQOQ2p2oF8?=
 =?us-ascii?Q?E82wSdrcqnLwwqTWdTUgKBNGVKnxXW1LJfOMNWpxjerS5GE2Gzb3+Of8iG+r?=
 =?us-ascii?Q?Qk/ZVthTXxkzQS5275lla9y5eCvoUw1Ogb1ZmrKjRIMZNpTJaaeM6q3ZKspL?=
 =?us-ascii?Q?Ip1EL6Mh3CGmVC6mlgCOSP6tCIuLL3IUSbp1O7oNtFk0DkD35eJM52dYzNSl?=
 =?us-ascii?Q?ZRTfAAKPMNatJ/eV6PXmjN63stgrlFWmKQQDiNOWOmZl4QPcYxJPyWgE8Qo6?=
 =?us-ascii?Q?gnP16ulaUNDPfA9Smf85N+l1WFcInnHUE4UeZjxG76Dj4FJAEjHb+C9s6Mw6?=
 =?us-ascii?Q?7tf5Hw69dMKC805nhblQ3LqVzHKINZgW7dzByy2wXgBF3G3sQkp1+GIDyXRs?=
 =?us-ascii?Q?pAjzdON2Eh/NktpzBQHkTyMjMAjEpTUlDBw63ZXzIsLt8zR+D05Rm53PE0r1?=
 =?us-ascii?Q?8k9u0i/95TR1bnsbRLEc4QRmTOnaVvONbh/JNGIKujmRKcobmuSCvSE32Xgg?=
 =?us-ascii?Q?OcpZbLS56vPGitfq7puzEKJZkZhK7zDzlPzRbEIQoD0lVQL1JiEsN5wo+8dB?=
 =?us-ascii?Q?Ly+2Z170OUhHGmNs+ie55Z8g/+gor7nkfZTBncWGyVeQigrmWnVJ7GZlHR5n?=
 =?us-ascii?Q?Zzww7eSqBR4BG+g1IUEAXC/Z7sO4iY0eNR9GyUhFItqDcobhuLm1syc631WT?=
 =?us-ascii?Q?RyNp0AB96Egh7B8xLJ0qsZTrxFHZ0rf4KEK33UlzgYOLvRNETysk/D2EIo0+?=
 =?us-ascii?Q?KYL7PfmdI/lUHgzlaQnMmFlTDOxip+y4Jk5h+ckeInjhOjWM9d97vLdOjD9K?=
 =?us-ascii?Q?3aW67weFQj/dQgY9eV56D82Kz82EAbLb1DnsDFXQPYLHmEcCRlkYHmSizRZl?=
 =?us-ascii?Q?lLp+0K8phMk15QJF0xziNalWSGqKCgxG2/PzkhRWDrJv+rnE18igJ3HLQH/r?=
 =?us-ascii?Q?vMtawTjHG44zrEvgWD1bwQxEnOwMJN4VlcPDb+rdW/7txdMq/w+B6OHSs9so?=
 =?us-ascii?Q?mVsK4J3V2xC8Sz7JVZFEuxzZm+KljyVLrNbHgqvXce7bxWhUYfYQCYP9Weoe?=
 =?us-ascii?Q?ryHpq+XXkQ86n89cWWScUSviBcVF8Z1NhB0RtMhFskCGa6a9zCy21UYpvu/I?=
 =?us-ascii?Q?4vx8ODdQaXr8ipEknrTAE2CDPtf0bXqREWf2FmF9/JSBLPe1WlGECNoZ+U0W?=
 =?us-ascii?Q?Ios5JYM2abhwGq0u4nZzi0hzZAoxcIGmFFtos+rz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b91b802c-327f-4248-11ef-08db0e5768d3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 06:47:58.9788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kwQRuU7VHvkdRVy8XxBdaJ2GVURm5n07FpMHRKQch7kTsgZ8B7VlfkPexntgF6y8iAlN3v3PxoLUde+YP5KRkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7462
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 01:28:33PM +0800, Robert Hoo wrote:
>> > +
>> > 	/*
>> > 	 * Do not condition the GPA check on long mode, this helper is
>> > used to
>> > 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee
>> > that
>> > @@ -1268,8 +1272,20 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
>> > unsigned long cr3)
>> > 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>> > 		return 1;
>> > 
>> > -	if (cr3 != kvm_read_cr3(vcpu))
>> > -		kvm_mmu_new_pgd(vcpu, cr3);
>> > +	old_cr3 = kvm_read_cr3(vcpu);
>> > +	if (cr3 != old_cr3) {
>> > +		if ((cr3 ^ old_cr3) & CR3_ADDR_MASK) {
>> 
>This means those effective addr bits changes, then no matter LAM bits
>toggled or not, it needs new pgd.
>
>> Does this check against CR3_ADDR_MASK necessarily mean LAM bits are
>> toggled, i.e., CR3_ADDR_MASK == ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57)?
>> 
>> Why not check if LAM bits are changed? This way the patch only
>> changes
>> cases related to LAM, keeping other cases intact.
>
>Yes, I can better to add check in "else" that LAM bits changes.
>But in fact above kvm_is_valid_cr3() has guaranteed no other high order
>bits changed.
>Emm, now you might ask to melt LAM bits into vcpu-
>>arch.reserved_gpa_bits? ;)

no. I am not asking for that.

My point is for example, bit X isn't in CR3_ADDR_MASK. then toggling
the bit X will go into the else{} branch, which is particularly for LAM
bits. So, the change is correct iff

	CR3_ADDR_MASK = ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57).

I didn't check if that is true on your code base. If it isn't, replace
CR3_ADDR_MASK with ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57).

>> 
>> > +			kvm_mmu_new_pgd(vcpu, cr3 & ~(X86_CR3_LAM_U48 |
>> > +					X86_CR3_LAM_U57));
>> 
>> Do you need to touch kvm_mmu_new_pgd() in nested_vmx_load_cr3()?
>
>Didn't scope nested LAM case in this patch set.

Is there any justificaiton for not considering nested virtualization?
Won't nested virtualization be broken by this series?

