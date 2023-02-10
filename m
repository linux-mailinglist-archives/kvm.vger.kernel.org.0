Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA97691715
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 04:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjBJDRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 22:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjBJDRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 22:17:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384436E8B3
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 19:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675999054; x=1707535054;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iW1bPEehJUmuCeDfrPR02Ck70/LZ0fBpXkeFSAYnUHA=;
  b=fDGMOChBZ9I8zcYViQ5QAv10vM/TySHEmWwH1vX047n15VzZE3pTIg7o
   oopeZX6mKwVLCE4/zmB+P3pmT+6fe56wKJgpA0H9NnFWrxrXPGXxJOqvh
   oraQUjWXAoYQnBJgo8rulmah4/3heZAZRhmnTccX4dIAds8tcubTntSZd
   Chvmj/Zjw1ooiR26eFV4DFum4q+lVn/EOXur4POltbjyCB6mntidFIovP
   4O50D/3TEm9ZiHWJiCJbRTkT0FTf7Wtp+F+BY1FZzGxNIVsS/M/bYqVOk
   3u0mvmNJ/6d+XUOHrF4uYNdg4j1OYrRvPzVvNpaekylMuVts1uENIT0Mj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="310689339"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="310689339"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 19:17:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="756638912"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="756638912"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Feb 2023 19:17:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 19:17:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 19:17:33 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 19:17:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBxnRk9K91bHtFOIYHgIzmO8bKXsxY6h2ttAXOJTPHL5XDLkrfrHeI+PEvWIl51j6d2KUsW63LsvMo+lUiKzQNYQsLrFJSmSa0ZkQ84B6HwabzxnnL4wWYwoNEWyxAgMXHxaT5LeLLU4qSJLkBbP0RRCfKb8kaie4kRqvM6WDNJr6pL4MFOXJJ1ur4gZn2o/98/kVwC0TvN0rq/ijCcNMhGnBPkZZA47XicPbxns81XP5540cMqP/BTyTeiXL8xA7bL3ozt4mJ/1cMGpaYmXUiXX0z4IF0T1IfsrXdsVGlCFUb6WoD3BXiRgFMoG21RopIohtOV78E84DFst2e7Trg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJFg40gDhjWEjmet8eT6bdxen5XhwAUI2vC97vFwky8=;
 b=MBrnnK3OzT4UEF+dx+m7Nwkw52J6TmR2seXpUf/1KBXrvuDRWX0xmwDuoQYs9CA3Jl+C2wbODWqDNVyMw3AGir1D2KRAx//kMAG3+lGOnhrnmDk9pcOpvwgtlHCp7n3ITS+sYidjcV1HEdz4fJsU59aAxotGlrP0Ta8xxV3if0AAHc9C6HSJF67ZxEkdQWfpyjFc+v3sFJBj236rNATBmdSZhH2FgTWyJDTMCAHM5VL+xjpUIkyJpdpOdNCk4NFFa2n9zRYufFJgdANBSFZwXoyxaKkHFs2VxTJSdiVUfp1NiTGQtMJzd+663Qs+Ajd2X2ZRA0mn8wOuPmzs2MWq0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ0PR11MB6693.namprd11.prod.outlook.com (2603:10b6:a03:44b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 03:17:30 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%7]) with mapi id 15.20.6064.036; Fri, 10 Feb 2023
 03:17:30 +0000
Date:   Fri, 10 Feb 2023 11:17:47 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     Sean Christopherson <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
Message-ID: <Y+W3W0f9YXfGeSDY@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <Y+SPjkY87zzFqHLj@gao-cwp>
 <5884e0cb15f7f904728fa31bb571218aec31087c.camel@linux.intel.com>
 <Y+UtDxPqIEeZ0sYH@google.com>
 <abbb29911d4517d87c0694db8d51b7935fd977bd.camel@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <abbb29911d4517d87c0694db8d51b7935fd977bd.camel@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0004.APCP153.PROD.OUTLOOK.COM (2603:1096::14) To
 PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ0PR11MB6693:EE_
X-MS-Office365-Filtering-Correlation-Id: 75b452b3-551b-43ed-b8bb-08db0b1557dd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnwh//KWmIa4Sg2FlWzMIcTlgB3Lh/88IguHfDF39+eB++c8wzYqyuHh1+LtGY3mh861/eno39XlvUCPT/cE9w+LpTcPkW3iqmNyE/cY/A+MeD0VFFYOYy8cE99YyQ7ywTXiS3HLgj2TOq8TQ5uenb7C87FLbcxt9ENXm165F/G9oRQm6eJL1jlbOZQunurhY6kWWWTj4mGjdkmifZCt5p4SPFOhMmrXK6ckMddZXE8/QTWyMu+XyeHc/SG7W3aZY+/rpndCMJ84WAWWfKFyqi2p0RyMgmSH3krZVlmpUKCAtl+GVr+zPO9R59Q/YnyYZkxZb1GqSTVYjURQq9IAThxpieDZB69bE3T/tnFLPuNeP7tPd/5GZKwQlRC/WZwWudR3S42RnqXSnvg/xG3F6wto7dUCqN0ob+KoxHQztXKnNoDVJUoqI9MirIuvHx6CXh4J+WV96N2grjifsS/QPOgInkJcTCM+fa/Ymxpe40ww4wGXjzxMcLUUHE7ysCtGcxBT1cZ3u+xGzigx8aNcZuwXNoVehQzaT5CHZNh7qE9RvZab/1kgAGAkDuWNlrhZLmZvbFWNV7JMPTpO+JpBRVU5UI/gEBuCNie/WD3zOCfCeDF4D+EZ1E4IE+AqVHKe2EQrKoXl5reRmVbvTeEcH3Fow7RDseX1J9mSMMchf+BOI5HC9+tVx/Qxoz5nUUUOwvHfE1yUF9JPbG0xf080TBSFR24DrYFsjwBtQeMjUMU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199018)(33716001)(6666004)(966005)(2906002)(6486002)(316002)(8936002)(41300700001)(38100700002)(5660300002)(82960400001)(186003)(83380400001)(26005)(9686003)(6512007)(478600001)(44832011)(6506007)(6916009)(4326008)(86362001)(66556008)(8676002)(66476007)(66946007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ym9jvySKCKeS8diDTwQprvcGtzLAe6UdzU976Ei4Ywj9wiYG4wEf7nDlL+ql?=
 =?us-ascii?Q?+eQJTfvb09E6RKe0eNoYDCzhfPdnNIraRaEhKnBrNrtia1LyAcSWaJxe3k5H?=
 =?us-ascii?Q?re5nU8vLR3NCyGr0To3ePna2OD+jNVKtmYAx12DoqdmD9kFwyssXEzt/2anv?=
 =?us-ascii?Q?0+4evfeo4YQLMkuoZHkl91AYRO3V5tO8l1cSr8o8PcEtvysJjKiJhFiI/uIl?=
 =?us-ascii?Q?3BGHaP3aJw63/P5REnXaO5dqJlcv2rYMN9RWfEs+NKT+ZLwiJlMINUWB7kFn?=
 =?us-ascii?Q?QylKravbxP3X/jyhUP/4O3cxU3cIYw/b0llSj8I59gLDvBa29ywT4EivzrA1?=
 =?us-ascii?Q?qMVzKDAEMCu9vZuLhA0jvkmb4Fd/Rz9pGOwY8/fHTqqGQCPus+Fur05UF0lG?=
 =?us-ascii?Q?EunwGHS0umkc0/XWcy+HX66zsSRScnFdXrSkv4wpyMtfHMAlfe/zmd06NQcc?=
 =?us-ascii?Q?k3ooeNOh+c527bDozrc+Opep1YTajplr1vQ52+LeFe3TMDMUhtgledN7W260?=
 =?us-ascii?Q?XS/bzQb5imMfWvdteCIEpgYjDoG5JAUKci/taN2BmE4YSOq9YNWl5wgR4vhR?=
 =?us-ascii?Q?dphIjre7TEAUbM71OHyk6Rf5kOXqtsgolqKADHBnWqVytjiswW4fQLTTx+v+?=
 =?us-ascii?Q?kwXruMoMUL5WbheHD9YNYI6bCOqZo4GV2qPWaUfa9vfFExC+8BqL7EUBFxYU?=
 =?us-ascii?Q?oH4KB49Rc8NG7phkOSKOR4EIwCs1UCFT0xHx++aJO1lDulBHesZlKhZtkwLc?=
 =?us-ascii?Q?Cgtq1MMT9ScZ08swh5Uz/jHNn2tbBtvhBVRXtPej93B6cYJh1618mE+L5ayF?=
 =?us-ascii?Q?mnMn2A56rMZv7HoaD9zfGsK9IFYilMfnqt+LClyct7HR4P2XNOSzoNp5D7rI?=
 =?us-ascii?Q?HmhrJfHsf5oyixNsZTYOwaHX1VMvF2XLU2Xk8/zdj9s1bUFuNDENQ6wvmTUF?=
 =?us-ascii?Q?JnH7mXNNY9YmBGEWWRYKDGhvwQZlQ8cGZcDNammvofaB/fbkmyxVXMm/OF9f?=
 =?us-ascii?Q?A02S1xtjrAxlbWXU7A43YQg6iwr7vl1aBQtpq+pRzXZLYnQCWDaDlUiFh7j5?=
 =?us-ascii?Q?398WUMbLeRf2oxt2Ufj3zhdqzaRupSGeHRooVGLU3MvVHLiA8WHjDO0ZkEEN?=
 =?us-ascii?Q?1scyqZBefcf0/LM5wPvqN3DWrlE9AntpyoKohNZZhm12bDQ0SFUE0nazyHV6?=
 =?us-ascii?Q?opjweYGEFPV4u0WdVkwPUMb+K8o5Fkh+xrRXFPoJhqievoAdGsTckRK5TpVO?=
 =?us-ascii?Q?nnmVIGEVhjqUn8BG0wY11dPShzapUwnOmfhYP0MlH7HYD+l3UgXkm/TpC6gF?=
 =?us-ascii?Q?NPaSPJ/0Bn2pAnBE//oLuS/Vn8dF1ygAXi9+Gbadvui/f8Zt+3l2BVvag/GY?=
 =?us-ascii?Q?5Mheua/kFs/0DY9f+18bAyTIKlKQ178Ba6IRGBL///NRw75HwHATFT7dGTEn?=
 =?us-ascii?Q?1ADB8IRS//J03877/JQjnDo6IgP89lkvN3Yp2Yiqmf7SOIATATRyAlJLZc8I?=
 =?us-ascii?Q?m8SfmA1vfhuQQQaB5aZKuKrRoukbYv6CxIakMHbvScF/pd6fQu+ToDhMbMQv?=
 =?us-ascii?Q?MrKVNFI46afY1OlJrWkAMKrqr4Vo+IUy3vIGahrc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75b452b3-551b-43ed-b8bb-08db0b1557dd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 03:17:30.0986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBX/poL+Cbxuhi2RQQ8+NplSkvM5LrNhPX4n+dgfDaO+6YZUIzn4JvPwem8irx3MVEJpfxBtGVmPV0S0VII64Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6693
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 10:07:42AM +0800, Robert Hoo wrote:
>On Thu, 2023-02-09 at 17:27 +0000, Sean Christopherson wrote:
>> On Thu, Feb 09, 2023, Robert Hoo wrote:
>> > On Thu, 2023-02-09 at 14:15 +0800, Chao Gao wrote:
>> > > On Thu, Feb 09, 2023 at 10:40:13AM +0800, Robert Hoo wrote:
>> > > Please add a kvm-unit-test or kselftest for LAM, particularly for
>> > > operations (e.g., canonical check for supervisor pointers, toggle
>> > > CR4.LAM_SUP) which aren't covered by the test in Kirill's series.
>> > 
>> > OK, I can explore for kvm-unit-test in separate patch set.
>> 
>> Please make tests your top priority.  Without tests, I am not going
>> to spend any
>> time reviewing this series, or any other hardware enabling
>> series[*].  I don't
>> expect KVM specific tests for everything, i.e. it's ok to to rely
>> things like
>> running VMs that utilize LAM and/or running LAM selftests in the
>> guest, but I do
>> want a reasonably thorough explanation of how all the test pieces fit
>> together to
>> validate KVM's implementation.
>
>Sure, and ack on unit test is part of development work.
>
>This patch set had always been unit tested before sent out, i.e.
>"running LAM selftests in guest" on both ept=Y/N.
>
>CR4.LAM_SUP, as Chao pointed out, could not be covered by kselftest, I
>may explore it in kvm-unit-test.

Alternatively, add another kselftest for LAM under kselftests/kvm.

>Or, would you mind that separate CR4.LAM_SUP enabling in another patch
>set?

This isn't a good idea. KVM shouldn't advertise LAM to userspace VMM
without CR4.LAM_SUP handling given LAM for supervisor pointers isn't
enumerated by a separate CPUID bit. Then, without the "another patch set",
this series just adds some dead code to KVM, which, IMO, is unacceptable.

>> 
>> [*] https://lore.kernel.org/all/Y+Uq0JOEmmdI0YwA@google.com
>
