Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231AC638218
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 02:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKYB1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 20:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYB1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 20:27:54 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3941E3DA;
        Thu, 24 Nov 2022 17:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669339673; x=1700875673;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=lRHRIdbLAV65UGTFsD+yVeNa06mJuHi9Mr+CbvdYOsk=;
  b=TwMVACs3PcYyl7zMUXU+FRPjVh5E40l8BH4a8GZrh1qnNHgtpLvtXvGY
   nyeLPhx4bL0l7ldTLdmW645Tr2/E2o8X4+xjopGJhAanhx1by5w9GPxap
   rq089DZnugGDPIXuZqc76e6ehDuvKNlGAwE8CqQi4MSuwTWeJIhbjtMX3
   a8qXtoY/L1aZYAvV3bosSw3/CutizlgMyG4pDxJjv8K4oJ2WJcZpkk15a
   cgag81eEBsW2cGeOOfIvrUp4JWLsiP/92c3ebXzBSxHfwZninJXBDMQ3o
   m+haWki6Gr//LGWxRRWzwPPBo4JWrChELsXyZxZXYahwesntv5+jjOp9Y
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="297747583"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="297747583"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 17:27:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="620183006"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="620183006"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 24 Nov 2022 17:27:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 24 Nov 2022 17:27:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 17:27:52 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 17:27:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOAZnft47TGES9xzLrbNvd5TUtdYSk80DZwswwz6k+OHEJDF1JIW+6PvDimNc2G1FI9aBGgj+m5cMRao9NQQu7DPyPkvHhfF896I1BeJFn0ogba/ldyeKxBODfXy9hFFIcdQRY6AlXdlRl5+JdlBtOPOksB7Xbbyl20mtxOykifhG1/+eYjuKikqHyz+ELEJkisugY6C1JtWNDxYsdWQ3tk8Ud5lQKnxSC5vHkcOq/V9tvUB+BFGAdpDLhU/m6MrseL0oERE3tiWKMeEa0WRWEF+6xDIHQFPqJWtv/nQPtd/OiiFFinEnsOmap0W15cqsKsxShaF5oMhEapcttlSxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=21fdooOrA1uPHciLaQxwJlLfCTmhSa6yFcQgS7qCHZ0=;
 b=CjqsZCabNmpbEX+s7meSbjExob9I1FUB9qvRZz6Wxtwo+mXuLv0nE0ZeREkGjdiW7cFrmuoumk/hEjtynb45iqBfuRawWp/1fG4woe8AZI0pOR4MrPRCaqVu5rGirRM5Tfcm06201O3wYWJtuD+0d/uMaurs7/RW5bp+ukr5Nu4X2t08DAvjf7njaN+tcsJAmtdBLyOeDEqH8NcakRVsWDcfvsGPVN0VCgeYBqcUh2OU3I+TX8De3FbUKRx7Pbr/blyc+9/129gq1CsM1u+KhZSkUnBSQ3YAToMzxj5uk6tcazd93cmg1LfmfwEVouwe6dHGddyZK0kC6k0untr8/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6907.namprd11.prod.outlook.com (2603:10b6:510:203::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 01:27:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af0:fb9e:4ef9:24e5]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::af0:fb9e:4ef9:24e5%9]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 01:27:44 +0000
Date:   Fri, 25 Nov 2022 09:04:44 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Message-ID: <Y4AUrLJtk7pK082i@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
 <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
 <887a77acc9bf96f7c7bea519ab7ebdd27fb67985.camel@intel.com>
 <Y4AIYGGEU3BdrQgV@yzhao56-desk.sh.intel.com>
 <8e14a7732a2d873846d07c4ec467fb7c48b2307f.camel@intel.com>
 <Y4AOMo00B0vlQfIU@yzhao56-desk.sh.intel.com>
 <1ad20facd81dd346e00ff686ae4a0550123de851.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1ad20facd81dd346e00ff686ae4a0550123de851.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0048.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6907:EE_
X-MS-Office365-Filtering-Correlation-Id: 3419cc3a-23e5-401a-24b4-08dace84408e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+vmSt5nQKyejOM78qJkNu9HTTLiKnXjKZzPkzwa96I2w+m4Ep4dsWPfJaMqig6ShERm8T+Mh081meOo/ayFcCxToe6bt+P6/iMbwDftBq6Xc+s38pZqMkv2zWOZA1Nf/6Jq17NAQjawl+NI1D3wRs6Q7kxlK9g7PY8MEn2AjshB1BLo3zu74VYKfQtaDsD/Rpau6PYSkisn+xh2kfp8V/0MXADmAKNSt7l00bpzyGjTbXbfTzmEyeqcD0OVPTURHW6UwxjMP1q5whoe/nlGCTWfckLS/8KGMzPHDAFnf69arGoMmOGCO16Pa+oI3tUL52PIM1lW+cdUlIlOuDxBBuJwMjfcew8TxK6+DbVd9m8Qo0h2t4TUAj23k3R14TXqpCmdIV5B5sNOV9Z7gT7xfvxOggGMoC+WNGO557wpcPWstC+gFo0U0qfaQpnwCl+oHaobvCtI5Lr3g77U8bNn6mD+EEOKzl4Mif4XGWjrzYtWF25hFolecJX7xfrO+Kv9e7O9vnoe3Sf5XfFN97Kqq1boo7z+PrvXq/SWcEsYpB9zB+ySJd92N3ipzd5Z1t5GBPNLkVlRgKeHlYFpGbZDqbDbn6fijXSGWDuJjCBN+26xF0WcHc+XWgHup16z+STy0DVB+f5A6reFRuhViGgaJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199015)(8676002)(66946007)(6636002)(66556008)(4326008)(66476007)(6486002)(38100700002)(82960400001)(26005)(478600001)(6506007)(83380400001)(86362001)(6512007)(2906002)(3450700001)(41300700001)(54906003)(5660300002)(316002)(4001150100001)(8936002)(6862004)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oTWC0LOO2PQcYkqFY06QLAvfhyy5qAqmUS25nCqgsSXJHqXGJV5Y67aLuFW7?=
 =?us-ascii?Q?97YvPTT2/7Dq5Nm9jd3mVflQOLsV3MFvXlmr4NaauoaKFKfzJLrajanPlO9h?=
 =?us-ascii?Q?u7w/rb1at4E/Akn6wTSXYVwQt9HykxB0JLVkUC/PO72YGf5pcsdHTyAsID88?=
 =?us-ascii?Q?drkc2/kfrciq7mbWnMluwDPJRPjlaQCJwBB8kt1Hb9LS0XiQHUIpXdtdvvoh?=
 =?us-ascii?Q?vjWcmvFQazCNQPjA6PyaM+pwdKLG9a2hk5kvioKt6kv7Ef9yfXLtr/5PmVhL?=
 =?us-ascii?Q?rSnwKAamaTgrLEGhxaKpxYBvhLVoe8JBwb14emuFwPPRYVZRbFyPPxRp1Odd?=
 =?us-ascii?Q?b2Cr+zgDwxolZS7Y47WhowwOjGYWUu67VWWdSPYfuo5FmTdjgxrVIDzsTIBP?=
 =?us-ascii?Q?HPsIRdkafxlp4wo29225Pu1tVD6JW/uDeejC+Rlccmx6jFIJ1ASDmSJXh1AR?=
 =?us-ascii?Q?fXabjsjSrjIfmDD418hsB3VxVVjVk3DUpxuq5QOsSZ+jDtABkE/C6yoor6f/?=
 =?us-ascii?Q?9jgOlVqTJkRE7kF+qo+5ZsD01Vtcc1RHM/Y1pha0IEc5RYDJvJrysGg4CPNZ?=
 =?us-ascii?Q?Jcu4PA3K0QG1QzcuvAmJaSV69K/a+Sc47LxSsEMKllnFoJ9Ll+F3Counhdtd?=
 =?us-ascii?Q?IZYZwfRrO8WCj+OnFWBgnp77s0VpaTTCs5vIUQmdEzwF48W37GLKAFEpLRDa?=
 =?us-ascii?Q?NjEJblJzooO6Mt+AqnvQ/agqPnYsGSea+Tk2wYZAotAZXXgjGKlkzNZofc0h?=
 =?us-ascii?Q?FNBwYhTqtINQg85LKYbA6sNkvukobH7fPj1LCjnhCEgbv/iW8uv7fyZkP5wS?=
 =?us-ascii?Q?Yee1arMeZ68rOm5bt8P7Yxhxb/OxayWqyIU0jf8e0vwA34QiQ3sDWxXg9FZ6?=
 =?us-ascii?Q?SYUWB6RCOTlxR2do60mUPwsrdd1PAYG5osu4auroj9eRRno7My0MZLB4iYYp?=
 =?us-ascii?Q?+EK3xtaunq9Crsx5mF9/29gnxs8giK6+xHWJU4OmGToprojWIZBJHHFPsUuf?=
 =?us-ascii?Q?BM8GytEo1L+5wJYlbCIpPt6G931DKrlX60MMECkKUUlm1oEXZ7Yo9BV7rJKb?=
 =?us-ascii?Q?t/7LLvaD0pWc61kSzaAzmqwkwjGsKODoFB5MoxPTLhVcomfbIWKj565GWCH0?=
 =?us-ascii?Q?iTqDtbuGB1t1D65UfXXewheH8DlGsM5LySfz7ZjI38KCK2IpIiCMmvFP8Tay?=
 =?us-ascii?Q?P9i+FtMeCLm53qFFC50Ejk2TuyUas7peROV2VQiuyOFEY6JhFf9oESThIMQr?=
 =?us-ascii?Q?TlnKe28WejdKIohB+JdriAXj5zXMUzwYJzhmoHvG5nmeDUYMN2xLugyFioUh?=
 =?us-ascii?Q?jlIXWwz7r1FBQwlrN+PFNYQ/X2yLFghAHaxIaUt8t8Zhq+HxPP9ZA4looKnd?=
 =?us-ascii?Q?/28t+I5wc5JyYz1/NaXxnqCA0qw9K5rur9QYQenCHRqOc26FbQ1km8yDuDru?=
 =?us-ascii?Q?TbA0kXTxQNq5gkxPX6fzT+IJi+9mRZq7VYIJIb9qfeKt7mWOMijZfDnjieyp?=
 =?us-ascii?Q?RFu4yUuTmANZr7GgtcsqNsn1c06EJCgY5r7a/fvptPsWv2yMJJ4zmqPJUreG?=
 =?us-ascii?Q?gVBHXC535CiWKhxx+AcIG/lR/ZB3g1WPgoNDhiAe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3419cc3a-23e5-401a-24b4-08dace84408e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 01:27:44.1658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRgTQq3jy3s8W6iMyUm8F+3puorHMWFV1DfkLnxBijIASaroRsccnQtyXw8y1tkvU7mZcw46/KMdlMIMLrtbYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6907
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 09:07:09AM +0800, Huang, Kai wrote:
> On Fri, 2022-11-25 at 08:37 +0800, Yan Zhao wrote:
> > On Fri, Nov 25, 2022 at 08:45:01AM +0800, Huang, Kai wrote:
> > > On Fri, 2022-11-25 at 08:12 +0800, Yan Zhao wrote:
> > > > On Fri, Nov 25, 2022 at 08:13:48AM +0800, Huang, Kai wrote:
> > > > > On Tue, 2022-11-22 at 10:10 +0800, Yan Zhao wrote:
> > > > > > Also make enable_mmio_caching to be a per-VM value?
> > > > > > As if the shadow_mmio_value is 0, mmio_caching needs to be disabled.
> > > > > 
> > > > > If I recall correctly, Sean said we can disable TDX guests if mmio_caching is
> > > > > disabled (we also will need to change to allow enable_mmio_caching to still be
> > > > > true when mmio_value is 0).
> > > > > 
> > > > > SEV_ES has similar logic:
> > > > > 
> > > > > void __init sev_hardware_setup(void)
> > > > > {
> > > > > 
> > > > > 	...
> > > > > 
> > > > >         /*
> > > > >          * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
> > > > >          * instruction stream, i.e. can't emulate in response to a #NPF and
> > > > >          * instead relies on #NPF(RSVD) being reflected into the guest as #VC
> > > > >          * (the guest can then do a #VMGEXIT to request MMIO emulation).
> > > > >          */
> > > > >         if (!enable_mmio_caching)
> > > > >                 goto out;
> > > > > 
> > > > 
> > > > Would enabling mmio caching in per-VM basis be better?
> > > > 
> > > 
> > > We need Paolo/Sean to decide.
> > > 
> > > The thing is TDX guests always require mmio_caching being enabled.  For VMX
> > > guests, normally we will always enable mmio_caching too.  So I think per-VM
> > > basis mmio_caching is not that useful.
> > With per-VM basis enabling, I think we can get rid of the kvm_gfn_shared_mask(kvm)
> > in below code and also in handle_abnormal_pfn()
> > 
> > static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
> > {
> >         return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
> >                likely(enable_mmio_caching || kvm_gfn_shared_mask(kvm));
> > }
> > 
> 
> It needs to go anyway regardless per-VM mmio_caching or not, as explained we
> need to change to allow enable_mmio_caching to be true even mmio_value is 0.

Or it's better to check enable_mmio_caching is true in
kvm_mmu_set_mmio_spte_value() as below. 

void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
{
        WARN_ON(!enable_mmio_caching);
        kvm->arch.shadow_mmio_value = mmio_value;
}
