Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECB46918ED
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 08:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjBJHCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 02:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjBJHCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 02:02:02 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E2B48591
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 23:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676012521; x=1707548521;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SMAiRb7JQB7E+t+eFsLJO42MhfLARYqj5rWtLukKqOU=;
  b=DdTl935RFQBvdkJ04046ZE2b5MGd24wTULpEpef54HTVfjckrW/3Pi0+
   2C70j6uONBKyAyPyovI1oF4jGSHUb4FfUH+t90eR2BxUnlnQqWNPTZapY
   xhhLo24/Cd7WEyTlS65Lfj4AKjCluMR9GKJX/QWXk70FalV68AQkflgRA
   Xnjj8NW1aV7bJkrZbFxhWnL5kbBQLPVXRRwdADv5DTTqRT6zE4zsWvCsl
   E0GJ+jEEbgQsUQ+CK434GzKFQvUwZihx3zWavl0IYy/71+S6neP3JySQZ
   WEOeo7WMaAtWbAIuM2lr2tmGY4tNyJUndPHiVHOkMbIw4e+1X30PORuDI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="309985815"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="309985815"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 23:00:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="617795133"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="617795133"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 09 Feb 2023 22:59:12 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 22:59:09 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 22:59:09 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 22:59:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEqS2KH5f5eB6sayAUNYeIwy3FPZt1Ny7qZszSgd6HREmNV+tGK14FDffIaG9HQuk3O1pC687OT6Zwmo7wRtwln65zpYnZyahCrUbrfqKANc1XjRAIeyCJTg5e/ENaYNwh3J0qvHzfNVLm3wDqP2iHr30CpTI8DxrjxDaeCy4eyRRXoBQ77YVgi+DbJZytIw7/HN+V5pN5HBcEAQnoEGGroXbYYGiW567UKKXOud+MuPZRD6Spor0F3WTB1lyhJNmYkeIgiKp1XRL0z6qJbmCTucUnleooYYn9pKiZ3kM8ruzlgijAk8lHpSXXVUtAvfe7o1OKcegv5w63pI80DgdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Tz6XJMJ5TX+8huOESamWeLjJoS1iFoZ2/c7RXA8VsI=;
 b=EfQuVQOljr/IkabVgR6NA0B/fXPQE9fF5dGGZM91LvF8vCKTEHnFwSsCuplJ+ShwhkjBFZQpMJC7JuT74BI8HoZPTQ7W8bPBpDS7dE0qTAk4Qd00OHbpay3ZybXGeD7Gtk6EEBccsekVrAfyLZWyNvqAgN+BB1TftZdj7w1y4RaWcB/nBzWqrn4tKUQjkShRyRut2/WoV4hKiKMtmw2v/XMD6JLa0WjmA8ygwnlLOLzT+ZiSMOjUREHUCcGigstZj7qbjk+2DnsI+lDJFqu5ghqC65nCM4ieF19BFCpe9N1a7mJoe4GPGa4qkwnVaSnbCYqpwVlviD2dwg11DY0v6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS7PR11MB7691.namprd11.prod.outlook.com (2603:10b6:8:e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 06:59:06 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 06:59:06 +0000
Date:   Fri, 10 Feb 2023 14:59:22 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 3/9] KVM: x86: MMU: Commets update
Message-ID: <Y+XrStGM5J/hGX6r@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-4-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-4-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR06CA0238.apcprd06.prod.outlook.com
 (2603:1096:4:ac::22) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS7PR11MB7691:EE_
X-MS-Office365-Filtering-Correlation-Id: 78c5ffae-7d80-422e-b504-08db0b344c96
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDFBNfT1m0ee4oNSXxzfd7QCZt+UqVzqUfOh9A7HdKsMDxlZDc7+vdFf/hs+GCqRhCdN1xcpGoj8q49kj7Mn3l13aj7ZoswxJ8I7+qHx/QblLtesB5EP+lPLQgGa+wBW9OU5cvXrfx3r3M9Fkclqy1JwiQnq4tulFqdOaiof4NXxiTUf7rDrFlQRNWxEHnXOoKoIpvyYn8Heh3Bk5SNeE+/pzBWrLBUMo222DjhZi3rIGzxgYxG+WKj80TQ3giZR53B99ntMCYMD+jeLiGUmBjQRkP1g5OTzaQvxN4dLwgloES7dlXX9BVYq9UNuFg2+6nDyvCnha9fbk7TQPV9mqJVLt+9kxkEgT3+LRXnm7sUZZ8SOQ+53Zl3lHmmoQGN1vL3IpGQSyOfyRAVOkitQLRtFmNY9vc0n4g5A7iWsKztXYKiNGKCTeTVHxEi0OUjZw8fG2NmEcEsFFySZMcx462qgxu5nsoXQKlt9XmBMU4bYLgIj8Fav5eJu0aff83rm/dvFPOUR6Bs2ZBbY4FIadAbTMbc2RaFqREaaNkUmW3iU514tB7kLPTveqy8c/keMhWhpNl016X8W5G4BN+hDoW2+YOAqYYYQxOJYSIPK8Ovj8yPkFfjV+K21ItgEIQVmKXEBTBNwwkoyoNVpo+hFeoyOKfKYtIvjTUNCHZRaVdYg8YnpPL0kpYCseZ3thghk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199018)(26005)(6486002)(83380400001)(2906002)(44832011)(5660300002)(15650500001)(6506007)(6512007)(41300700001)(6666004)(478600001)(186003)(86362001)(6916009)(66946007)(9686003)(4326008)(316002)(82960400001)(8936002)(8676002)(38100700002)(66476007)(66556008)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mlYUvgfh9IMj0dWu9a73YmjblzoACyUUoTOC51IB99NGLo7D2xc/+CGmvfwx?=
 =?us-ascii?Q?m6uEZ6jBUPObo1aNPdfQj8VOPS5QJo4tKb5ohwOD9DlKdiWGlWWFD3lcNyJH?=
 =?us-ascii?Q?nzIggvoshQG3fiJqyTrAooOQWSb9I9TsvF97ch/m0FUw1U7//IL/sU2Jq10d?=
 =?us-ascii?Q?+qu25zzQjDsjNQ5VtIz7kXMzFOCcZ6O1mn80p65tn0kV9pJdN1IUjjKfmiKP?=
 =?us-ascii?Q?m9K+aQQAg4CG4KSD2QAOOYCnQCMB7xUthpfcLgoEQ5C4wrxVSt0w0a2QNBo6?=
 =?us-ascii?Q?cusNwuhpJoj1/vXfA0OOaXzO16O2Oo/J1KYrL+aC04VcWAonL/keyhvp85vj?=
 =?us-ascii?Q?uaAQhb1uNliIHrdStq0be41wtcqeqobN2cfOcVnoy0JQBqcwbLDbGilYr4Mx?=
 =?us-ascii?Q?XsCVekGgfV20B9O7HVoIzZ4ecsbLlfeYR/oyrf0pjhUJUgFtINcl/XXQcPHm?=
 =?us-ascii?Q?2HV8BiOQjLvLExehgGeLC1DkguZ8gXhxl/cFKo6gkukdfWRVvTOyutCH/NNo?=
 =?us-ascii?Q?PVB8Hw+CUnrPDJbnpza0KpzebkHYnDW1jVWmtjtmLa1x9Jdgk3TtmRVN7Yoi?=
 =?us-ascii?Q?oetBFBf4ji6XlshbiiOy8pd1dmn/reejFZWKtWG8niUhEEi+hWlAxJG67atq?=
 =?us-ascii?Q?pVCok+5pN+o+StOzEwLlHOVd4wOsOBxJwVUckNQKdNjkbeYG1vHQUHGTyjhU?=
 =?us-ascii?Q?e8tWXwfYRhRmmUK5zzwUsLBu8xdB0cp0qOS6ffmI9mHytB+GO73AlT2WuMmH?=
 =?us-ascii?Q?2s1HxneZIxesY5HQ982yZXIZeCRUVruhb6oeu3Sf2wkVkaafL0zv0LfW/vlY?=
 =?us-ascii?Q?eTAQESLSB+gyh/B5+amOE8C6w6xHXYfGzjt9Rk+u6sCZ3sCkc+wTDrs5hQbY?=
 =?us-ascii?Q?HdYSVRSIObOXSXpBqoD1PPWVLxtFU3SrKVfKrCp68g8X+503fPhY58rdPsLW?=
 =?us-ascii?Q?0v3BU80X2e6m35phlcwK8gxnYZQG/3dNut+g8W8d++GBgrDAU+MBHZ08cYrx?=
 =?us-ascii?Q?IuSKRsISfdm8O20EOMfHM1YO+VYinOyILsftvcd2LuOggdNmeGPZqquS4nfJ?=
 =?us-ascii?Q?7pur09RaTscLaaAXkSf2+ZfvjSmGyaAqZygWdbK4zwbzhi/bFfUrnKzElT5k?=
 =?us-ascii?Q?DXBH0aIWQvgcIazek2YHy/MXJOhYgatuTcGj5+QM9OYsYZmZPNTnLFnCmkK/?=
 =?us-ascii?Q?SEyY6kqgTBXZJ6Qgq/jp9/EEOsZH54yMikFvYargA5w0PtUasD3XfEX74k/k?=
 =?us-ascii?Q?Krhd1TQWlHcwasPxc2x7SGdB78WpsH9QeiCOPiFGgkE16go1/+41CXGYlTdE?=
 =?us-ascii?Q?61RhMta/GuIK4s8RIJV38zsNendAm7vsOuwOSBzH/5zcJ5XjwsUiH2Um4/V6?=
 =?us-ascii?Q?3m9r+H1cgHki5fv45YDYILYNUK06eKSGWPmuIfo8SQPMT3XCpogjXwljb9X8?=
 =?us-ascii?Q?dZYEHZ6av9Tt6UPlGCHlfQq6pblblN3hU80GnXcAxb44H8TDyovQTIubf9li?=
 =?us-ascii?Q?A2RkAZzvaxLN+/rd4HEKUVjrz+JATc7qpJyL9oyuIxGIstT33A4ZKTwMwhXy?=
 =?us-ascii?Q?oUgb9+QG1J+boJiVjmIOvkZdTVV7cVbtJsOxHthX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c5ffae-7d80-422e-b504-08db0b344c96
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 06:59:05.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p62RY5mrqPLLqjMALmp1PQ2DTZjD1x5RcoRjP1+OyCQfoQiJCfnDSiy2wKBieibWypIAMTVSfWLWezlP3AIl/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7691
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 10:40:16AM +0800, Robert Hoo wrote:
>kvm_mmu_ensure_valid_pgd() is stale. Update the comments according to
>latest code.
>
>No function changes.
>
>P.S. Sean firstly noticed this in

Reported-by:?

Should not this be post separately? This patch has nothing to do with LAM.

>https://lore.kernel.org/kvm/Yg%2FguAXFLJBmDflh@google.com/.
>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>---
> arch/x86/kvm/mmu/mmu.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>index 1d61dfe37c77..9a780445a88e 100644
>--- a/arch/x86/kvm/mmu/mmu.c
>+++ b/arch/x86/kvm/mmu/mmu.c
>@@ -4497,8 +4497,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
> 	struct kvm_mmu *mmu = vcpu->arch.mmu;
> 	union kvm_mmu_page_role new_role = mmu->root_role;
> 
>+	/*
>+	 * If no root is found in cache, current active root.hpa will be (set)
>+	 * INVALID_PAGE, a new root will be set up during vcpu_enter_guest()
>+	 * --> kvm_mmu_reload().
>+	 */
> 	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
>-		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
> 		return;
> 	}
> 
>-- 
>2.31.1
>
