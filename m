Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E9E76F9AE
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 07:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjHDFvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 01:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjHDFvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 01:51:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1537430D5;
        Thu,  3 Aug 2023 22:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691128308; x=1722664308;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fQpjrZjBGf0CYEdNnUsYHb/gm2q31ZcQOekIlZ8z7/8=;
  b=W1CkfjvT4FEsnmHG/immP1hHmsxgwyFfi28g2mMiBLAYba1rwQ3Ac80G
   qVYLyCIp4dWud1Go9fAwHq9uMFIYqT24ibTzjkosng9VXmdT6ymG678Am
   dKY4BT2z9C4zMyrSpB4GyJTeHuBI2LEn8co2h+9kA4ZnGooml0FPg1Ebn
   ukxaFES5R+cOyGoIgtdg/Q4sbmGSuye42sM0fiCQ0AgxGz4UFI0oLz9xx
   EyhHr9TgxoVGhWyeWOmE/qeGu7BG1wjohFUX9kZDElYdWKOtoMS5myY/l
   c5GbPD+2RmRUg8mdl4vKqmMt3R66fIu4kdAxkT/O0sr+Msqa/fp+E3Hgh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="368977180"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="368977180"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 22:51:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="819973178"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="819973178"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Aug 2023 22:51:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 22:51:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 22:51:47 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 22:51:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWpgZxKP+L/Empnq66B0It83e9J76lqICBXx+EZyqaLztzFS1usf4UdFjrk6qadnZ6PKsbP+G1SxvV5hI6fbWsKFx/4JXvJKWed+SARhx7NaBy7HG2xrczYugNbvZw4YRR771EAU2TQBHUQ8JQ2rzetMVolVPVf/JKiAa6frz1s7mA9qGy+C+L3VzwZJK/fN44U9ZV3QwfRQAYK4artMbnBfX7IwIYR3mUF9nn2J7M1CcSZFyqbAhbiVAzwnbxdTXEdPXhhEM8VKaH1IVDZZM0d+qnoY/LYd0Dyd9PpxSHVA5h69wf+WB5p8ptDMDhbeCE26KTv0WiGKOdyUnzp1IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPkiWR4qNviVnTNNorrtAVqGLgq+NDUHrwoTJ33yi0w=;
 b=m0chCLjbq8P/eXZ5B4iU7VtbMgYMBHrOhVagBHgnLsP1lYe8qxlTVs387GuplKc6HRDpbKlxVAiYq4ZvUF4lLdSO2/QKBpxUnfOWWG2FHJ4bgDjpeEGDBLH2jxmtqwt1ieXLQ9mpan0JoYD02dXJ/80ngpiNHHX6TacX1IltaAMEgmXyvabajzumoHF94M3Gpkg9xsrE4pHyxhnjXojEKFxVeYdPZBsgHw4ne9ts2PTXnVUzcS0KTsF0/5KbzKaH0LoPJc5h8vuXIApf/YB0SL3Ql/RT8Dt8e7A3nShhBm8+Li3BIB3tCsCjshx3AH4VLGWTQL4ixSwfGcqFo367Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB8720.namprd11.prod.outlook.com (2603:10b6:8:1aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 05:51:44 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 05:51:43 +0000
Date:   Fri, 4 Aug 2023 13:51:33 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as
 to-be-saved
Message-ID: <ZMyR5Ztfjd9EMgIR@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com>
 <ZMuDyzxqtIpeoy34@chao-email>
 <83d767df-c9ef-1bee-40c0-2360598aafa8@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <83d767df-c9ef-1bee-40c0-2360598aafa8@intel.com>
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB8720:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c3e66c-b0e8-4fb3-3391-08db94aee195
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UdjJWvQ8awcF11QiLID99yNmrIsBp0UcaLiNjUfJ1fd0zRXF6aC5NpVHMsC8fn94q9X9QPwj0aiCRGLMhVZaYuHjCxtZPQyequpFwzBTh6RwY6LqliR4kX0/xjtfl1kkFhdXpCRWtg9+KGY2OJJuC3gtKOKsqM5SIN3Z2sO8XjrwR2gv7Bw/B4Qm236wk6gSGUt98om4uIq8wVleAU3S5SYnnXK69c3DkNrvqTp5xypdOrVJPKxJywiLLRiGyCl38lT9pEX4nKuDRsdcPf4X3uKWcRr877pmX+aaz8cOMCyamklDODeatBypje2Ek0UBbG/+qzuaoytEcrA5nrrLgNnxvPFAOgcDFLhu2FUBzwsJyrHGz0Ki55cW38IxscBtL7vkiR5IyiqaLlqE4NEG6/OJOCTmi5pCP2hb7ntDcCtHuCS8Wsjw/lw9mj8+nuhYSuEeozZCg0W8bsiktxL4REplOnkFOaVUbsiT2IUkspOCJcq4xAFtnARsm2hkjYjfuLjhsktHC0t/DB/QGVE0Gm+vjYkfSlYUC8/ts6t4fY601IyIlEFZ+kDhOQ7e5Abz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(376002)(396003)(346002)(39860400002)(451199021)(1800799003)(186006)(82960400001)(38100700002)(6486002)(6512007)(6666004)(33716001)(86362001)(9686003)(478600001)(83380400001)(2906002)(316002)(44832011)(4326008)(6636002)(66556008)(66476007)(66946007)(8676002)(6506007)(41300700001)(26005)(8936002)(5660300002)(6862004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PGhaNo8QZF2eqBOTyHqED+8kRXNfEDUoiKmKRl+7u8cGnFJB9JYW0gpWHZT3?=
 =?us-ascii?Q?G14k12twdKKdPQuIXq7Aew1BJSU7igcM35ZkJHXqm/tCEvCY4Zv92zpN7ziP?=
 =?us-ascii?Q?NrtgHm9/IHZF62ODqmjFywN4X0dcYs6iAgrF0GCiu4HVK73TqamcB+9uVQ2A?=
 =?us-ascii?Q?Tj7djj4GL/zFl3tPpXl/Tm8+pM3Wj0TLm/R1/yPRlvJLQK1wjwnioyzxGTYS?=
 =?us-ascii?Q?33rwN3zP5s3yaa26R8CLU5jSCGKI4yHqwCdbIDtpy5mKoWzgECI1UiHaiSZk?=
 =?us-ascii?Q?x7hK07PbDYErTNe1hKY+1zntXc7gckpDIQsYRt7Hj3h4K8ontYlQeJ1CLUBy?=
 =?us-ascii?Q?N0ahehalo5xtxULRTbC5s1PEOiI1bwSIGuUuu4ZxExTPKvtR/rCo2j0KHRYy?=
 =?us-ascii?Q?UnzbpaIKe/ufHOCfqaUml0RubKTh/B+axVxZ+TtOH8OrAUHClDaOwRmUQlcX?=
 =?us-ascii?Q?+3ZAu2kxNGjabFRRbc/9gWWBkf10i7RwdUhTMpDSv7gSz8jk8Fm5wS5ojgoI?=
 =?us-ascii?Q?SxUoTUicw1OPt2qlU6at0ijZoAaPYfGn9acLJwDIKzdyCSXub0dUXeOP9L9A?=
 =?us-ascii?Q?VlKvlwVJr+vGez+EU95XdyzMWH9JnDkeagawdNv9Te7dmPMUJ6VjAedsrjDU?=
 =?us-ascii?Q?xITA70W+KKNAaIjNsh/e2k5FLYqBDUcNW37ggQf0/9meI4NVElv12Up0Pz4c?=
 =?us-ascii?Q?JZ1t57Cn6aNddyuRMFfyGtewcf+Ai4Vw4No2yr5pBXxrkwRQzRgHS6A9sW2H?=
 =?us-ascii?Q?DaCJqWHt7NPbAfNIzsMNxOP4UoKO7WABObdFMc1rqPfePQB1QHocUU/WvjMN?=
 =?us-ascii?Q?kflpLghsF1Sw5YLjdNph6HX07UBQCwpfH33+8dsboaPd4pV4q4ykOQZPvDI0?=
 =?us-ascii?Q?SHCvYISqZewJf8ENUvws67qHecXoZYmPlJmQK37UXZ5fYOdOFCE52Kx7anDD?=
 =?us-ascii?Q?h8dUFRzeufPQiCEzJuPu9db1IcW1nBtA+AWhp3AtIRocNgKOKHedvzOgLb5g?=
 =?us-ascii?Q?iDHAut51P3kdK8QJ/tlyvlz7dNJzQkgg8tz8YRZCrMWN29vjzDsFYe9CQyjX?=
 =?us-ascii?Q?J7/p4qchpNm50h+2EcQT2D5s0PBmPwvHgyOMJYd0GZc90B7+Z5YgXhovPTCa?=
 =?us-ascii?Q?UWoh9GFC/L4Z1OQfiZ+dTUoDFwABBG+gnIeojIKNm3GnxSJV7PyB5fDVgWJ2?=
 =?us-ascii?Q?1XSCivBY/BcsDpqGlPxv3LialRZkZjTBDsRerQmorSafz6NkhrFW7NBQBJxw?=
 =?us-ascii?Q?/FhOgVhC1eRqqg9GFg5O6fsGyrdNo/WTqRX9yvbkeTwWGg9dkkzmqz6NYArq?=
 =?us-ascii?Q?cUawJ5wX6qFV/svB23rF7ldR19Di+zIeHiFwJ6OEiEwP22979TCaOKDiZNM4?=
 =?us-ascii?Q?aJgvigTv+g/nFjLKYr1F3LtV1ucogV5dD7r6OdPVEo9k8o9Q03NcCPIc5CAQ?=
 =?us-ascii?Q?XpHKwhzuWx3aGTGQHRZwetizUfK6BlCWWP/TW+OAFAAXlbTAhyWdYTNmyKbD?=
 =?us-ascii?Q?diW5tCKUCgc3e8AgY+DAhouvBfjuNUqlfduip3wnt9WUCLtMvaVywUYMZfjE?=
 =?us-ascii?Q?6VsKn2PUedUvAYx6qYYojIZtHT5/Pi78rL1HDTfv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c3e66c-b0e8-4fb3-3391-08db94aee195
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 05:51:43.3975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8GqZiGiPCQdaKf5naY8zk8xFrAdIBloI1Ub7yvM1rbNtuEeu/iWJtyDWI0Sumgc6lxFzJ6rWZtwW+trdRa8/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8720
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 11:13:36AM +0800, Yang, Weijiang wrote:
>> > @@ -7214,6 +7217,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>> > 		if (!kvm_caps.supported_xss)
>> > 			return;
>> > 		break;
>> > +	case MSR_IA32_U_CET:
>> > +	case MSR_IA32_S_CET:
>> > +	case MSR_KVM_GUEST_SSP:
>> > +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> > +		if (!kvm_is_cet_supported())
>> shall we consider the case where IBT is supported while SS isn't
>> (e.g., in L1 guest)?
>Yes, but userspace should be able to access SHSTK MSRs even only IBT is exposed to guest so
>far as KVM can support SHSTK MSRs.

Why should userspace be allowed to access SHSTK MSRs in this case? L1 may not
even enumerate SHSTK (qemu removes -shstk explicitly but keeps IBT), how KVM in
L1 can allow its userspace to do that?

>> > +static inline bool kvm_is_cet_supported(void)
>> > +{
>> > +	return (kvm_caps.supported_xss & CET_XSTATE_MASK) == CET_XSTATE_MASK;
>> why not just check if SHSTK or IBT is supported explicitly, i.e.,
>> 
>> 	return kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
>> 	       kvm_cpu_cap_has(X86_FEATURE_IBT);
>> 
>> this is straightforward. And strictly speaking, the support of a feature and
>> the support of managing a feature's state via XSAVE(S) are two different things.x
>I think using exiting check implies two things:
>1. Platform/KVM can support CET features.
>2. CET user mode MSRs are backed by host thus are guaranteed to be valid.
>i.e., the purpose is to check guest CET dependencies instead of features' availability.

When KVM claims a feature is supported, it should ensure all its dependencies are
met. that's, KVM's support of a feature also imples all dependencies are met.
Function-wise, the two approaches have no difference. I just think checking
KVM's support of SHSTK/IBT is more clear because the function name is
kvm_is_cet_supported() rather than e.g., kvm_is_cet_state_managed_by_xsave().

>
>kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)
>
>only tells at least one of the CET features is supported by KVM.
>
>> then patch 16 has no need to do
>> 
>> +	/*
>> +	 * If SHSTK and IBT are not available in KVM, clear CET user bit in
>> +	 * kvm_caps.supported_xss so that kvm_is_cet__supported() returns
>> +	 * false when called.
>> +	 */
>> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>> +		kvm_caps.supported_xss &= ~CET_XSTATE_MASK;
>
