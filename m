Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2A75AC8A0
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 04:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiIECAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 22:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbiIECAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 22:00:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695C817E2B;
        Sun,  4 Sep 2022 19:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662343203; x=1693879203;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zjVhSt4mGxBWlgnENqFfcUXSuNwTQCZ58ThesleJUvc=;
  b=Sv0Y9UCWkdDPDkgvrwaEy08irNOY/xOrXoxbmvY9aetJH6eDxAvzD7PG
   kp8ippScQTOcJcnes5qj+GeXLlRp5Y9pX879cTc97vaJq21cBBnb+QKfY
   Dys4GW35yyOtf69O2iLYQq7j74c7j8s6RSQamwcD0CutZbos7Q/n/DudP
   yHJYyyy5Tm58XlE2w5Agp/DYcrdJ0Gts6iknJCwFdZz4DS5ec6SclAc0Q
   ArlG80pjzfd27+jjU99QBmdNkEzoF7AzSKHMIh35JXiAXPt6FGr7G1oYv
   NNzSkXtAn1NJ3rDm1leYgVmvQdkgal/EPYY8G83NEFSZ98/30VjZiBnaP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="296291611"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="296291611"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 19:00:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="564583285"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 04 Sep 2022 19:00:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 4 Sep 2022 19:00:01 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 4 Sep 2022 19:00:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 4 Sep 2022 19:00:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 4 Sep 2022 19:00:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nj74jj90DsSQEBvjvO+0qAlQ64RPqTTJLREkRw9AjWC3e8HfVNZzPiaPlr2c7UbIHHzs5LHDuTLwejfmbg38GdUC20yRsvDz3UTT6cyLvTND3ASZJHlw1mmZUxlRd5voe8wIUZbGX4jkAbDaSZEkoKz4seRfMvRfvmzVUnhNX2xyH3EmjiMvFGZW988YIElU4ic6ha1/M0bGoRykjOypVZKH805VMDECnWg69D0LN8NS3DdRh0cHfkR9Koww/3K8L4oAfhGTYRk2b0+vES6mqGitID9b4q7VEwmA781Wjx92CJqNAK3ZuqFF4nd4FgRkGvvgMOmpMrfYkYjVeaYVsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiHqM0bVP/+TNZrscom6Nmk/w5RBy2DGh9ug75zl7gs=;
 b=Hh+gInPxegQSQS7AvDpwOWIL46psWHRlbAE2R0AXjGdbX43Bl6qRoDlfysfn/5KdKvU7q5xHgFrnljFFfF+/LDcCojjbMyD7/0Ts8/tALmfA/PZQ8XlpCfUGcYYAzUf5ztAvU1Iug8YnuKYHS9tQTMJroE+8TZGt56T7syV+bJGlpXDTYmo0vxcetd5S5qh9xN6s50XJVDEuyzeada4yhdoOZbLt3oWZO4/2GqPAT2Ol0fV0HuSY+KZDQM1phUdCtYfj2qOoja+w2Z7znQxdOwvhZEr2SU2PYTVY+Il/slQ+d5LzbVSQ31eGfwui7wBrY1ZqBpgp+W1DRcL9AJbFJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by CY5PR11MB6092.namprd11.prod.outlook.com
 (2603:10b6:930:2c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Mon, 5 Sep
 2022 01:59:53 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5588.015; Mon, 5 Sep 2022
 01:59:53 +0000
Date:   Mon, 5 Sep 2022 09:59:46 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        <isaku.yamahata@gmail.com>, Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Huang Ying" <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 01/22] KVM: x86: Drop kvm_user_return_msr_cpu_online()
Message-ID: <YxVYEhsI9CGKtJZb@gao-cwp>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <25ff8d1bbf41de4bcf93a184826bd57e140a465b.1662084396.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <25ff8d1bbf41de4bcf93a184826bd57e140a465b.1662084396.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0128.apcprd02.prod.outlook.com
 (2603:1096:4:188::20) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a42cc305-ba86-4a87-6090-08da8ee252bc
X-MS-TrafficTypeDiagnostic: CY5PR11MB6092:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRwt/FKYX8Hr4/pB80IYY28IGYu+/YJbt0h2HRtg/eoEv3pH2Eg2UQ6c76DS7kjnuu2uzXHS12aMgelJmIXdSXpZIuBMghq2wsfCt7STP+h7N5wIfMC4a8Uzhw9B9+y5K74KultNYzB3hb/yt1FUGfe+VIfpjXC5nc+R2cA7U08TB0e2sUnrfYF3/8fIjQ5NhTQcxhYb0Fr4HH0HsHUR42XHS+5qWCA2i3x8/0W5epTuP/LDoRgaQIJJp5cuQ/B+/7y9ASNr4m9+JkC6rpj2tl5nbu5SHmwGwmzGE8hpSfefGggIDhxKJxB3vJedcc3al3f+7FbQpBsYQgfOuQJT2Bxw7gKcNoxWrT/hta0l7zWQzmIzy/zu9ci4uoNGlIVK9mewbUQm8T7WiIg6Ufs68Gn1YicYSIxU+fkLtH+cy3Arf9GxV7IEeg0mO6EKaMQ7A0OH3v2eCoR1VoKdCCw2ncz6Rg08z+3FbUKLm43Xqwa+gPTV/KaIhNZegcdu+T18S9NSBGSn4qjULI5v4PeRwM9MYaMo8ZfLD/sGzbOLnh0aalUZwWx7qF1cOgNW6UckXquOO9ricQSIeDK91oPuhvMaFynhxD5gP89lsqF6IDhwg+pJvp+hTf9sBH/+UWpfwTmA2I5jFMMMl4uulUf9mhotmbZl3FMeLNruGNFPMcKlEaf0WqEGloDYuCDEl5zO4+ZZlMMlcj0faWTZb+evVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(136003)(376002)(346002)(39860400002)(66556008)(41300700001)(6636002)(5660300002)(478600001)(316002)(7416002)(186003)(6666004)(6486002)(6512007)(34206002)(6506007)(66476007)(82960400001)(44832011)(8676002)(9686003)(26005)(54906003)(4326008)(8936002)(86362001)(2906002)(33716001)(66946007)(38100700002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4c55nejSyAfUTArTHMuMUapQoOnUVx4PXE4j5ghhjFGoo2EYOFOCGmEGS77a?=
 =?us-ascii?Q?+jVWpHVhKZKViaGnmoc7W7wp0FKn2e6DQvE6PwQB3r5rNySs67G4viXAfXb1?=
 =?us-ascii?Q?t2aXh9iSH7DrG1DpoVfFUp6KE5Cang0v52iFdZMioc1HbcP8NbSGGwBEt/qF?=
 =?us-ascii?Q?D4GhapNeeSZQIv8PKy/f3EOAJoAfh66b/EP5S1DSuwSCaXAisdCC5Uh8KTvn?=
 =?us-ascii?Q?NxV7alC76/X0Ghv038PRApn3wc1eh6ozth2LYnvpdDe/+pUkd1qn4if/JkXh?=
 =?us-ascii?Q?fBRZtl8kACQ+XfM/NhyyPbEK3uI6wZMa/cfUGvocdSRuWB9DX6RQtiyQ3xBP?=
 =?us-ascii?Q?B1jfseyLLMrbbo0zPQ7kPUxcnUu0+Tn80NBLWMXszNl83wNN9mOB+a2iWCWx?=
 =?us-ascii?Q?bD18EbAjH57egC9ukEXM5bDRiDFLqrL1GKIYu15HID1rH4yS8A79kmjQxk1O?=
 =?us-ascii?Q?K1xSNbkuCoxMvieNtotOsv/KXJRBKK8WGPozkKk0wKuwtcFbi4npesCzp46B?=
 =?us-ascii?Q?Zau05JLySqnrhpLS6VcE0jKfjBk6SVNv5wq7tjyekjrgBzJXTlde4oq7Ol1w?=
 =?us-ascii?Q?BkE958RyvqOrtsgoxf7/Ax5TpolScnOXCUiCQdB6rmdiFEBN41yEvIQJhGFu?=
 =?us-ascii?Q?o2weVrU0vTcj5/KcdaH29IQi8nhD27aaITKKRKu/W3OnNIojPDd7bO5jxbPL?=
 =?us-ascii?Q?8BboqWZRmQaf1UKCDfFd3rR9pMjnf94LjCn5Z73NnZPIcHFbzVoFfvLM1Kno?=
 =?us-ascii?Q?rQRunSw5K4EZYsKT4but8CsiJUB4AV5SwqYUJSiiBbf9m4UraIeL36SyLgCI?=
 =?us-ascii?Q?OWxmi0XNRrukabWTwNMRHtXkGXHCqLuMAyHjJlvDrbKw9UmRcJtQ2l6AsGIh?=
 =?us-ascii?Q?/69q3eu8JYZZJ9d9Di+jO0gUf/BoifJRoam0ZEl5qkcq68Ztt2hwvWm1G/iu?=
 =?us-ascii?Q?ZURrZ2dZVqnsY+KrwZtCBp8W6sHTV0t0apgONWmMOUQ4YujFDUI8PMCHdXtA?=
 =?us-ascii?Q?sXF6Yfg16LdISBeXw6BNbomVHdIuWQEI5QN9KI4bE9VKQntnNBSBS63Gj1jg?=
 =?us-ascii?Q?Q5LfQ8Cw1Xg2/zT4vjHvo1voVNv+gwqwoRFtloELwesQqQZ8RRu+pMOROtCc?=
 =?us-ascii?Q?AD7v7LKLAa2uGUriyKW4j+LXIZ2cliibXPfod+7ePk2U7NmHCEh5km8JieQW?=
 =?us-ascii?Q?zLspnS8bY430gUA2Yesp/VyEeLtxPkS8e0DQYct00YHTRp+BXUXVgmpxikps?=
 =?us-ascii?Q?L7BuYdXebDiZo9dAjFKLdwwr5cPlRBvuBFTAZ2f7Ce2f2vG1SRNqKtAPnpRV?=
 =?us-ascii?Q?iYCLyElih913zpZ7XfndNU0djX58dmNPto/TFkA+A4WjcFD1wJMqVuN9muhj?=
 =?us-ascii?Q?bk0BczavNCPzAzqAxHGeOuWmO+9FiNjduTrQ/3Y/AYQ0QaB6fk+kt5eyfE90?=
 =?us-ascii?Q?Rkh3P97UUJxn4FuI2a/sskP6KIhWXrDtwG9OUF5CAhge75i7FFuTkzVsn8pT?=
 =?us-ascii?Q?XChrrsB/cG/6l2Irwe+JlyYV/6Gxgc7IGyHJlgTuwwWUd5x3g4efF4O9MBN8?=
 =?us-ascii?Q?UM9DG3ytUaQVWn34WbKmj1aPT86J21Nr+WXJBIFb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a42cc305-ba86-4a87-6090-08da8ee252bc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 01:59:52.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vtqeP2901O5Bh89Bd8q5YJlekqjLDYee5E3a5W0wJlT+uLc1L9kI3C1/MHhEXXjYUhu3SRCBSV0ks5IwG8sHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6092
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:36PM -0700, isaku.yamahata@intel.com wrote:
>-	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
>+	/*
>+	 * __GFP_ZERO to ensure user_return_msrs.values[].initialized = false.
					^ should be user_return_msrs.initialized

With this fixed,

	Reviewed-by: Chao Gao <chao.gao@intel.com>
