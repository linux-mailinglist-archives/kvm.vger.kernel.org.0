Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9E270F540
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 13:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjEXL3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 07:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjEXL26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 07:28:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AB0135;
        Wed, 24 May 2023 04:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684927736; x=1716463736;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=NVnC9dvH+B6Ked0LeuedpMQ0Ta25DfgGBAqtUEqieB8=;
  b=Pozv63U/+p4DNzcetlTqefOPC1ggO2jLIPun3QIvckf1LeyTElRPyKHF
   qQGHm3vfgPHisj7PJyIpbq5LWEo5CXW688zHOVUl0mP+dO7GqwL7SF/iY
   RB2ERTHEouNfHRu7yEixTtBE58hjs+p7ZzkYxjKX61/Iv3FhfIE2lOeat
   Z2Z1P0hDa94HlySfyJq2z+YpFKnb8k2gfxgeu4D+C5XBaJAZhyEy42cqW
   oFGctrDwEoGziKS6WKOHEQPs6jUQqzcx+REFki/SVElH3jwnzbGTdOyw7
   AdHFujI3Xb4qjPX0FwOU0aSmsYF9QOELCup3ZFfDSCZs3jXweTvM4EyNs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="419247716"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="419247716"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 04:28:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="848714629"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="848714629"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 24 May 2023 04:28:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 04:28:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 04:28:48 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 04:28:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3+XnTAWIgQWt441MkUEGqB3a+4NDu42d+OU6TkEonyD/XZbUquAVHEJdYlNZGT2icgqICov/9ZtLd4O75ul2WZOBVs2ZpHyIzbl7dz5dJrg5ZRXenI8sohZ57/gxNGPhQpc4en+AANwACY2yzh/cSjLFzC8/9AW2nd448OFycfSdfH3wPVE4QRSdLQsplMeyFbmRG7rgBz37Kqcnmig7oV8BkVbPKxBEtM8bamBgAJv1RYCEERw9OHVcxpxACVzcqCx3WfH9wF8wdcLUBjZK4GT0F99lgNyRf582RTZsgvgDlvp4SVgga5Nvx2n3WhWcIZPYbzGDqqFfWI6pJ0v5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjWvA08/KOqp1r7PCpJvtPaLkR1NLOpNyWrKMekYBe8=;
 b=H2sF/xWrPBzUu82/i5uOubA6wNdh3dPdMffBh6WiQ3RLAzzr1h3ohUYNiO4N6krk71Hau+zcOcu3O8yug+r3PkAmBE89aQBKV7R+InWdXBKmKcaD0wGiwUPudVMRP6+EEgGAzYmRG95Ow5Hd8sJEIZe4TBOc8QxuivHSmNI06/rM8gUiqgTDl/ieM57CwbjFUqPEAU1eqeWcMDIMQmfngtIl3kDNo/LQSQ3U82Ox5IexrFJSWynbq9hCINVM+EKZUVzg+hfp4EbggslYpYcer0DOj2WykkJFxFfYhAYtlaHx8Snz2XDEwJNRW3tfXkBErtI5kcNdZgHQnfKpFhpySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7299.namprd11.prod.outlook.com (2603:10b6:610:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 11:28:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 11:28:45 +0000
Date:   Wed, 24 May 2023 19:03:35 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Robert Hoo <robert.hoo.linux@gmail.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2 5/6] KVM: x86: Keep a per-VM MTRR state
Message-ID: <ZG3vB052ubr1vBQA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
 <20230509135300.1855-1-yan.y.zhao@intel.com>
 <3f09e751-33fd-7d60-78cd-6857d113e8bd@gmail.com>
 <ZGxbat2mM6AfOOVv@yzhao56-desk.sh.intel.com>
 <ZG1WsnYST4zLqTnv@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZG1WsnYST4zLqTnv@google.com>
X-ClientProxiedBy: SG2PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:3:17::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca125c6-854b-4b2a-0126-08db5c4a0890
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t3X2lQXohmsZWMCNt9m2udXFjhG3XuCUHszRl/pYgsw72spTHZNejuKT/9e4EpRmFrqJmgU4yFhQkLkYK78SvaMPyDTcezuJOdxES6embwNG8HNoXLLOgQg8mKM8kZI5PH4ZGxErV+Tn6XAKqdo+IQ2yPYE/BIB3uYMbda31/nH5Z3K7GSpZ8qBKDSjqcP1o/Fwyk4m2pOQELahZitZSzhikRb+MJEJC3GxRStwujjyPjn4pBwdF41dUkJn12o3ImGT+TviaRfsZnq1aDUQA+ZnB2PaZhkvP/b4f+QoGzXibfLgtwfuNKzRD457j9AsNWLT08B5YKyC81GcAY+2vXEAKn7JsK99QvDkJpUQQN1TF4pjSFGJNO3DUBrIgnpDtGxgFM7EyNf9jZNWSO8blXlyob83NRrNrhNlQDNsTyiWJEdGidcFRA1zLee7Du9PZZ4g5lCRGZr0tHJmoNkeZ4qGevsPs9/gUi/1CjGPRknu5IvEJTr9VzOurqTdxfrza2SXy7yXnTin30OckMSZyNzwB5MxMHwwmkF5gp+xqsoY7XkuQG2mOrPKii7Wr26hj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199021)(5660300002)(8676002)(8936002)(186003)(3450700001)(53546011)(86362001)(82960400001)(2906002)(30864003)(83380400001)(38100700002)(6512007)(6506007)(26005)(316002)(66946007)(66556008)(66476007)(6916009)(4326008)(6666004)(478600001)(6486002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hDcOLf/EBpgYfc3nx5LsnCxFB6MoFswLG0CxV0My3nSlem9bh7TTMwlIXpl0?=
 =?us-ascii?Q?r5pBNbeFG2//8N/fR91wbRNo6dA7PHX7gynPUMSQCn2+SM+eO6PBQVNWW73W?=
 =?us-ascii?Q?/p908bsbMWTXm20n5mckkdWTttH8JjEGz8m+9Pw9W9Wduh9KmIH0rf3eM/Ze?=
 =?us-ascii?Q?zHFQ7ALNMzBPagJ9dMXz1yuCn+XRYrfOeWFIkxOh8wwOmKxdnHArqfd9nAnY?=
 =?us-ascii?Q?k7J3s5BuIWCkMWsgrpvn6Wi5bNB6nfU2UKpDf66CPwos2z58eUXHpd3kFDVb?=
 =?us-ascii?Q?9tQdmNIdlPn58Jf3X+jqLM+dcRbYoDxyieDrgsOrqDWaoc+NfeTFFLBwCqLs?=
 =?us-ascii?Q?UGPtGVYywAU0GrZBD7q/BDfL7zB8cQ5+0c2vbMuySEvO0bNYyDUy3PaG4p6s?=
 =?us-ascii?Q?Xx2diQXYx/YP/VpGJrX/uNp9zSbBbh+nHaiKGlX4G1b7SysV14Wru1ANj5eM?=
 =?us-ascii?Q?jk61tIgV6v9sGjimc5nDWeUAcJTNlYHVa6KdTX5o2zOXJIE9+M3lbQzoybs9?=
 =?us-ascii?Q?F4wb6fCdeI8jSbKvhMwHZcE6IOkq1ivfJ3stNmG/AgDXFYD8IPucvOEs73cA?=
 =?us-ascii?Q?AxMlW7gaoiiDnK4vxOd9NAG/weYIY3HkqN8gIadPxosqX6HAl1w9ao7hOS40?=
 =?us-ascii?Q?PUIB3xIaKTBJP3wwtLneMtM3TOxMwvSMsd9nAHL1nF7UoZ8NaXU9KWwWhdD+?=
 =?us-ascii?Q?v8niLuR7ywGzxq1F55xJQEF73OgO8Qf0VZ8hRVv6M0Ol5oXE6DBEMImNXQy7?=
 =?us-ascii?Q?8T/GGucFNuf/UIM8/cWkGZXqzCBPh8i8jghqTzUkrC9xt5P4hzGdHeN71CYv?=
 =?us-ascii?Q?d1gACA3XTpsVardIED07BYRq4Dcv1/ZHxyixkCaimng5IVbky93e+K7UCz4n?=
 =?us-ascii?Q?OaEhwTQlVp3LaESKzacU5z+MtucfgevaTq4A1zpsqUH+is7XRC6LZs9WlI95?=
 =?us-ascii?Q?/Myh7TDvfq5iTayrJ28wLGkHLgawMhABOVUJGYQGULvxi3aW+Ax3GktJekpt?=
 =?us-ascii?Q?H0xikubX8bxYdyndsKuwVrrW15BcT5V36TMMHNpnDxjod5AwuoM5U8uOjtEF?=
 =?us-ascii?Q?Dl0UcXfNqwS1unGHhnVpiJd2Sz2vLO7Y3o2wlSP4v7VzwE8OZSyk2zTPWPC5?=
 =?us-ascii?Q?ApBvbJrsWQwFMJYJSE/wRhbVGK4uGaI6YLLB3XMICIBfuJRmjY24GTUvB5d6?=
 =?us-ascii?Q?rSn8u3AwXz6/5CNE3XZRjTOR7CGDoTq4sxVtK55q55BxfLUqeHP2F9dHpYFW?=
 =?us-ascii?Q?6SKCygh9vsVU9doKFJ+f2T3Xp1u+3Vwg8rR/AKmHG7h7BF/BRy1IkoInNsEb?=
 =?us-ascii?Q?yHYdEDx1LZEoeTiX7xl0nMAnnabAsSVXGqmsX58OSXmL/ofY/GLwm5diotQ8?=
 =?us-ascii?Q?NHMFNO4BjijRPhjeW/t8q2mdJ2x3+tckbi/muxBHpewbXCIZ8MuQoBFPI/6x?=
 =?us-ascii?Q?h3Vh60BBiy1945arej2Fmbdw/r7mRAIXflWH3TXhQooA+6vU0NRHNZI9+M36?=
 =?us-ascii?Q?f3f/Sy2Q+xTCeG4DUpZtkRcQDfOGSztqObO/TwlPR29PVBpJv5//MmSu9IhX?=
 =?us-ascii?Q?RAKlr/OY5nDHMYG3IpG6fwy/i6jR/ZQ3h5kJZrtZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca125c6-854b-4b2a-0126-08db5c4a0890
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 11:28:44.7743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7/vgVrX2J39xgEayyBI9wh6S6m/W3voMm47ORI7i461I4qcecgNnw2wgJvhNIZLSZWZPJyctDqims7jftkKjvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7299
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 05:13:38PM -0700, Sean Christopherson wrote:
> On Tue, May 23, 2023, Yan Zhao wrote:
> > On Sun, May 21, 2023 at 11:44:36AM +0800, Robert Hoo wrote:
> > > On 5/9/2023 9:53 PM, Yan Zhao wrote:
> > > > Keep a per-VM MTRR state and point it to the MTRR state of vCPU 0.
> > > > 
> > > > This is a preparation patch for KVM to reference a per-VM guest MTRR
> > > > to decide memory type of EPT leaf entries when noncoherent DMA is present.
> > > > 
> > > > Though each vCPU has its own MTRR state, MTRR states should be
> > > > consistent across each VM, which is demanded as in Intel's SDM
> > > > "In a multiprocessor system using a processor in the P6 family or a more
> > > > recent family, each processor MUST use the identical MTRR memory map so
> > > > that software will have a consistent view of memory."
> > > > 
> > > > Therefore, when memory type of EPT leaf entry needs to honor guest MTRR,
> > > > a per-VM version of guest MTRR can be referenced.
> > > > 
> > > > Each vCPU still has its own MTRR state field to keep guest rdmsr()
> > > > returning the right value when there's lag of MTRR update for each vCPU.
> > > > 
> > > Can we get rid of per-vCPU MTRR state copies and just have this per-VM state
> > > only? therefore can simplify implementation and avoid hazard of
> > > inconsistency among per-VPU MTRR states.
> > > 
> > > I see in SDM, it notes:
> > > "In multiple processor systems, the operating system must maintain MTRR
> > > consistency between all the processors in the system (that is, all
> > > processors must use the same MTRR values). The P6 and more recent processor
> > > families provide no hardware support for maintaining this consistency."
> > > 
> > > leaving each vCPU's MTRR is just to fully mimic HW?
> > >
> > Yes, leaving each vCPU's MTRR to mimic HW.
> > 
> > As also suggested in SDM, the guest OS manipulates MTRRs in this way:
> > 
> > for each online CPUs {
> > 	disable MTRR
> > 	update fixed/var MTRR ranges
> > 	enable MTRR
> > }
> > Guest OS needs to access memory only after this full pattern.
> 
> FWIW, that Linux doesn't use that approach.  Linux instead only puts the cache
> into no-fill mode (CR0.CD=1) when modifying MTRRs.  OVMF does both (and apparently
> doesn't optimize for self-snoop?).
I think Linux also follows this patten.
This is the call trace I found out in my environment.
cache_cpu_init
    cache_disable
        write_cr0 to CD=1, NW=0
        mtrr_disable
    mtrr_generic_set_state
        mtrr_wrmsr to fixed/var ranges
    cache_enable
        mtrr_enable
        write_cr0(read_cr0() & ~X86_CR0_CD);

For PAT not enabled in guest,
arch_phys_wc_add
    mtrr_add
        mtrr_add_page
            set_mtrr_cpuslocked
                mtrr_rendezvous_handler on each online cpu
                    generic_set_mtrr
                        cache_disable
                            write_cr0 to CD=1, NW=0
                            mtrr_disable
                        mtrr_wrmsr
                        cache_enable


For OVMF and Seabios, I dumped in host to observe their MTRR behaviors:
1. OVMF updates MTRR in below sequence
(1) vCPU 0
    CR0.CD=1
    MTRR disable
    MTRR update
    MTRR enable
    CR0.CD=0
(2) vCPU 1-n
    CR0.CD=1
    MTRR disable
(3) vCPU 1-n    
    MTRR update
(4) vCPU 1-n
    MTRR enable
    CR0.CD=0

2. Seabios can update MTRRs both when CR0.CD=0 and when CR0.CD=1 and follows below
sequence in each CPU
    MTRR disable
    MTRR update
    MTRR enable
I found it can update MTRRs even when CR0.CD=0 to below values:
MSR_MTRRfix16K_80000(0x258): 0x606060606060606
MSR_MTRRfix4K_C0000(0x268): 0x505050505050505
...
MSR_MTRRfix4K_F8000(0x26f): 0x505050505050505
MTRRphysBase_MSR(0): 0xc0000000
MTRRphysMask_MSR(0): 0x3fffc0000800

> 
> > So, I think there should not have "hazard of inconsistency among per-VPU MTRR
> > states".
> 
> Probably not, but despite the SDM's assertion that software "MUST" keep things
> consistent, that's not actually reality.  E.g. a careful kernel that partitions
> memory doesn't need to strictly keep MTRRs consistent.  Ditto for scenarios where
> CPUs are offline (for a variety of definitions of "offline"), in which case only
> online CPUs need to have consistent MTRRs, e.g. before APs are brought up, MTRRs
> are obviously inconsistent.
>
Yes. By "no inconsistency", I mean online vCPUs(who trigger active memory accesses)
need to all in a state that their MTRRs are consistent.
Offline vCPUs, as they will not access memory, it doesn't matter.
But once they are back to online, their MTRRs need to be in sync with online vCPUs.

> > I want to have per-VM MTRR state is because I want to reduce unnessary EPT
> > zap, which costs quite a lot cpu cycles even when the EPT is empty.
> > 
> > In this patch, per-VM MTRR pointer is used to point to vCPU 0's MTRR state,
> > so that it can save some memory to keep the MTRR state.
> > But I found out that it would only work when vCPU 0 (boot processor) is
> > always online (which is not true for x86 under some configration).
> > 
> > I'll try to find out lowest online vCPU
> 
> Picking a single vCPU will always be subject to edge cases.  E.g. I can see something
> like kexec() "offlining" KVM's chosen vCPU and then having problems because KVM
> ignores MTRR updates from other vCPUs in the new kernel.
>
Not familiar with kexec().
I wanted to trap APIC_SPIV and finding the lowest online vCPU id by checking
apic->sw_enabled status. Then only MTRR state of vCPU whose id equals to
the lowest online vCPU id can be written to per-VM MTRR state.
Will that work for kexec()?

> One idea would be to let all vCPUs write the per-VM state, and zap if and only if
> the MTRRs are actually different.  But as above, I'm on the fence about diverging
> from what hardware actually does with respect to MTRRs.
> 
> Argh, stupid quirks.  I was going to suggest we take advantage of the guest needing
> to either disable MTRRs or put the cache into no-fill mode to avoid zapping SPTEs,
> i.e. skip the zap if CR0.CD=1, but KVM's implementation of the quirk is all kinds
> of messed up.  KVM ignores MTRRs and guest PAT when CR0.CD=1, but then doesn't zap
> when CR0.CD is cleared:
> 
> 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
> 	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
> 	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> 		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> 
> which means that either KVM is relying on later MTRR changes to zap the bogus
> WB SPTEs, or more likely things "work" because KVM doesn't install SPTEs for the
> ranges that end up being DMA'd while CR0.CD is set.
> 
> *sigh*  What an absolutely asinine quirk.  KVM should never have taken it on to
> workaround OVMF's stupidity.  Good gravy, that thing was even Cc'd stable@.  Yeesh.
> 
> Aha!  Idea.  There's should be no need to ignore guest PAT when CR0.CD=1 and the
> quirk is enabled.  Even OVMF must be smart enough to map its code as WB in its page
> tables.  And there is no need to zap SPTEs when CR0.CD is _set_, because SPTEs
> created while CR0.CD=0 would have honored MTRRs.  Lastly, DMA when CR0.CD=1 and
> the quirk is enabled simply can't work since KVM historically ignores everything
> from the guest and maps all memory WB.
> 
> So, if KVM zaps SPTEs when CR0.CD is cleared (even when the quirk is enabled),
> then KVM can skip the MTRR zaps when CR0.CD=1 because KVM is ignoring the MTRRs
> and will zap when CR0.CD is cleared.  And to avoid regressing the CR0.CD case,
> if KVM honors guest PAT for the bizarro CR0.CD quirk, then KVM only needs to
> zap non-WB MTRR ranges when CR0.CD is cleared.  Since WB is weak, looking for
> non-WB MTRR ranges doesn't need to actually resolve the memtype, i.e. can be simple
> and just
> process MTRRs one by one.
> 
> Did that make sense?  Minus the code to identify non-WB MTRR ranges (and much
> needed comments), the below is what I'm thinking.  If more intelligent zapping
> provides the desired performance improvements, then I think/hope we avoid trying
> to play games with MTRRs.
> 
> ---
>  arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c |  8 ++------
>  arch/x86/kvm/x86.c     |  6 ++----
>  3 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index a67c28a56417..e700c230268b 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -323,6 +323,9 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
>  	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
>  		return;
>  
> +	if (kvm_is_cr0_bit_set(vcpu, X86_CR0_CD))
> +		return;
This will always make update_mtrr() return here for Linux and OVMF. 
> +
>  	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
>  		return;
>  
> @@ -375,6 +378,22 @@ static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  	}
>  }
>  
> +void kvm_mtrr_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> +{
> +	if (cr0 & X86_CR0_CD)
> +		return;
> +
> +	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> +		return;
> +
> +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
> +		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> +		return;
> +	}
> +
> +	<zap non-WB memory>;
This zap looks will happen on each vCPU. Then only half of zaps are
saved compared to the original count of zaps in update_mtrr().
And pieces of no-WB memory might produce more kvm_zap_gfn_range()?


> +}
> +
>  int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  {
>  	int index;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2d9d155691a7..962abc17afc0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7502,8 +7502,6 @@ static int vmx_vm_init(struct kvm *kvm)
>  
>  static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  {
> -	u8 cache;
> -
>  	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
>  	 * memory aliases with conflicting memory types and sometimes MCEs.
>  	 * We have to be careful as to what are honored and when.
> @@ -7530,11 +7528,9 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  
>  	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
>  		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> -			cache = MTRR_TYPE_WRBACK;
> +			return MTRR_TYPE_WRBACK;
>  		else
> -			cache = MTRR_TYPE_UNCACHABLE;
> -
> -		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> +			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>  	}
>  
>  	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 977dceb7ba7e..3c085b6f9e3c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -941,10 +941,8 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>  	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
>  		kvm_mmu_reset_context(vcpu);
>  
> -	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
> -	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
> -	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> -		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
> +	if ((cr0 ^ old_cr0) & X86_CR0_CD))
> +		kvm_mtrr_post_set_cr0(vcpu, cr0);
>  }
>  EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
>  
> 
> base-commit: 7e998f35c57cb0a2c35f8545b54ab5f4f5a83841
> -- 
> 
