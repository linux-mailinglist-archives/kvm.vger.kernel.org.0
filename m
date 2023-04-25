Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE606EDCA7
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 09:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjDYHbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 03:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbjDYHbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 03:31:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99DF12C97;
        Tue, 25 Apr 2023 00:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682407824; x=1713943824;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=m2QN54HYFn3Fo4pxFZanI3XBO3pIxHH1o6Q/NS05kgw=;
  b=AFSebGvOGHWatlztDIWGbe+5QZwEhigO5PMJDhw3IISdYIFrc7dz/xGs
   SFFCLQJqq55yXbX8yBwQT3gnU2lWwKN2ZGl8shVITdVGUN2IoVIu8Ofkh
   SiberWlVrR7ZD41es2M+jCb1hAqclbxipxZ/lvOIIL9t60N+BtpXsl5DZ
   LdPdGtCz620sks8iB4ImCaggQunNgvHkqu676C0gdtCyxD8zKXWcGkhYg
   EfTHDB0hFWackv2Lg/1zus2ft9wo9Pxik8I0wxhyBHmoLoZ8Psp3RnuGL
   yEevs59lIJ8Tkfncu1tTfC93M0itpaShpNd4MlS0wGB6D65cs0q7tUjHU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="330900431"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="330900431"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 00:29:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="804960275"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="804960275"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 25 Apr 2023 00:29:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 00:29:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 25 Apr 2023 00:29:04 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 25 Apr 2023 00:29:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kisJ6tsbNohHPYS7e/zcXACt3Y4Nw7z2udzFmcwSNlIhMMKRhCPdAhaodP2V5NNV7LSLm+zos1P1XjJX9lUZOA12iWVh7xDf3VeHw/0+ErF74LAjXi/rPgAp9A5/NeEkQM5upUmVil2Ofx4pM+blNFz/apEzjwhKgR7s2WQRfjPefbgmRJ6yp/Hz3KoAzMsIMqrcaD2pfHMNfCcb6GXeJTfFhyhwk9sMmr38GStcoGemL3lwdhnu1ytPBHpnB7RCc4/Tl4t1cS5mrYhls3G+9wxBn2bJXcrOut12arz2NuqTLuZAGvAylBnMY190icL219xphXJc8Gx9ZKI9Q05VGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yn0VHfNvfGa/4DITqjt0Aq77mZYgJ0BBjmzK/RjX7kE=;
 b=JBGERU7vQkKac8eSnDp58hmuDo12o0/lOmIc2/4aoDJzrdFuKiVFuq5KGfFQvw3r025l1myliQt1E6RUDh7hdsCUKks3QvFDqGGQLRxz1HQ83vCcPYpXDKiytDMxn+WvKE95HmrpW/63F1snwcq75sADT764PzNy/1dtu47QTeY27St2ty25O5Xh5clnrnyGmVhkGm680dh+7ECUYb7jtJjXA6FQX69guPvBRzWDAvaa3riYJD6Fq1q3NKsH6sU2r36uGZqI+cNIaVxmYq+XuF1oQ6wYuMNMs8HMjC+Vw4hUmBYOr+MF3oVay+erlNvhNPdb/QLCrbQeBjnl8HaWeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW4PR11MB7101.namprd11.prod.outlook.com (2603:10b6:303:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 07:29:01 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 07:29:01 +0000
Date:   Tue, 25 Apr 2023 15:28:48 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM: x86: Set KVM LASS based on hardware capability
Message-ID: <ZEeBMKcQxXHV2ggb@chao-email>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-7-guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230420133724.11398-7-guang.zeng@intel.com>
X-ClientProxiedBy: SG2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:3:17::19) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW4PR11MB7101:EE_
X-MS-Office365-Filtering-Correlation-Id: 471e5be1-53de-4abe-d326-08db455ebd26
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JO4LPThaPe/oic4S11y/REN7yOyAzhhmRi0lNRkJPqnQuL4zD8geD9O2NKWu6B++YUa+vSWDTeLHZIff+EdYuy6zYJT5mhrWafV+o736TiJ31qar8etoUK8LOjciYJeHI2TUPMzJUX3IAjMYNaRkEPog0ED69W9yVD/FSHqlNL82chYZxyLhlfRxDR/ZxsouumGEjZrtNuW9HQiiHKfTCMReR79rgqGvrdsAu+xXwN1nFCY+PkQS72WPmiT07Xc2rhJSwSo9BkSJiULi/mYQaDEqKaXvSmCzUxrVc+Zl/xAEcRBzNhcyEOEWcANRoifS8HV3MUZo72dJga1cNiqdEWl5Ea8u/oR5jXNKV1YXFnr7y/sxERy461knZxYNvJiNnTL9lsQSskg9bVwQ9kcBKAU3IAoj/gT0HJ4KYwN1l7cPv7jPWBp/bdA7J7gh1P/LHsYJlzybYsQr7YvPV88yjaL0mBFlhIeXzCBRBRVwifvBdC+kG0Ozae8v7sqQr/Hs46rU0RUFs7G9r/VObsBaIijIO2BDix9nqNuXNHdwZadWUPbBp98iij9I+KdkxORL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199021)(8676002)(8936002)(54906003)(6862004)(478600001)(66476007)(66556008)(6636002)(66946007)(4326008)(7416002)(44832011)(82960400001)(316002)(41300700001)(2906002)(38100700002)(5660300002)(86362001)(33716001)(186003)(26005)(6506007)(9686003)(6512007)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yH9XJ4x5+CU9xUrD4uKytqQqf7v/b8sRoD1UrTQre84Ql8FZ8nDQMz1CtABs?=
 =?us-ascii?Q?IbUmywFjQpbtJMsqknu+PQsDn1XGDp6U8/zBF9TUr8QuAoulWSO6CY2g+tJi?=
 =?us-ascii?Q?c/O3H+3YAYOKhpHzBFXtj6WGsHqD/qASRrKcxCDlwWLcmFiDnb1HSWO1EmlJ?=
 =?us-ascii?Q?3v+c6D6wGgtzyvlNZIuEVc/Of4qTfOsBZk3oULM+cOBA6fwHjAzynWmGxh1J?=
 =?us-ascii?Q?eWNcZJ32geRbJUQkCsWVP8jECmpTVxxNY7nVmBvyRiH027wZKePSV2Xz8myF?=
 =?us-ascii?Q?aMtzNEUYcDLWcxk4QimYF+/VdTva6e22JzGanj9J2dN8CoKE9XO+Imb58t+w?=
 =?us-ascii?Q?OFuOkgMNYoeheXTbh23K2R+PmMyrBig800jEJqYrYgxbkR0gMGvEbJwyeuHa?=
 =?us-ascii?Q?J+3msDkA20iF9rnxgJ5teVJrUOAQU7yRRiMbiTf5BHnBxNNStDKZNPCvl23B?=
 =?us-ascii?Q?D29qCajepQhPgI/Y+JTZMC7ioP0p/+oQT1fLdfM+tbGn2OCrs2517A8NVezS?=
 =?us-ascii?Q?GTIEHCXLNg7AzfvZTLlwtRks+rmVJOuRrlHjrkfmAmgelobgE3oGngxOqihP?=
 =?us-ascii?Q?peq2bzHoS8WWzXNzQdKFKpdIrGyrega1ZaHJM7fbHm0yC34r/KAbsNlcJc1F?=
 =?us-ascii?Q?utOtcPq/XKApI7A0cTZDHW1yFHpAbAtV5HbYZfotyE5482X01F6KraDN8Jyg?=
 =?us-ascii?Q?3nUAt/V0CY4Zfhfw8iuVjujUfzvYv6L3UyjWyaJAL1cQ+ebPM6DOajQvJPxM?=
 =?us-ascii?Q?XkDLACa0upJjPW2BTSL5F4Re+cOR/f7ONkI0Wbt/BUHGF2BN5sMI4QaNVuTH?=
 =?us-ascii?Q?pgfRhFpG+L0MA9vlYeFIWEH88Yft+a/E37Gx4H+UgWvkz69XVq8hX9wRw1ug?=
 =?us-ascii?Q?UTMTlcxCnO5aBl5NO2HnN59a3FnsOxZsnldNyneYMWDtSAQedmxfjx3z7rwa?=
 =?us-ascii?Q?H5myNK9bxN3sH+uoPs8FGNYeLWjHKaO0FvG9EwdN0rHbKWf4X6jTJzeZ6hN+?=
 =?us-ascii?Q?y44E72qMQgsRkNMk6U/SiUvsX3IfL+oRjbJds3Cqvi2bmebfQptx2VR5AWSP?=
 =?us-ascii?Q?rig03JBThPZDP23QgjcECsaN+eDeTHQ72PHhL/sOSV9lGEpRR2017Ac9DKR0?=
 =?us-ascii?Q?Zgc9Tle7LBaAqyLfJfzg4a+ATQSudsBfOAiFsECTh+RoOxHUswFlSJdr5zfp?=
 =?us-ascii?Q?mpqKBI0PAjMQJ0Z1apNiiY2qUB/gAnBf/fkb8EId5i57ehQvngXdl1mmOLa5?=
 =?us-ascii?Q?3sk+Wt3N1qgZxBbcPYNAgra5E454NfyTfRjtweSXam/0/fdSRVC33WNhGNFl?=
 =?us-ascii?Q?v60QIjy1mnSxMhK63SND+rWqzudqeVq4q9cYLvv/Zy2Q/WJ39AMavift86TA?=
 =?us-ascii?Q?9zvVa1D6uIRrYAWH4rmZMPKgqpOTrAIclWbPLn2+pOSDtZKoToYH71ZR9x4O?=
 =?us-ascii?Q?bPPx2XS06MDhMoZJ7BBIZ/kpSmP0rWbTDdlFs8YJl7N7jEtzanDbWdSeOXX5?=
 =?us-ascii?Q?OsUcvYowlrIgLt2H+scvQZ3RAlO1cnCbYBQkQuuEPDr+3o/v+TOSq9+aku/T?=
 =?us-ascii?Q?nzhs9JKAl7wnbxBw/F3uJGETdH+bYcoh3MjpiKGY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 471e5be1-53de-4abe-d326-08db455ebd26
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 07:29:00.7673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1Y2N2Ued3WBQHHaDrXbkVIba9FlU/4QUxewSYVSCTAAo4XwUAXaLJBCoDdNBuLHjPfdUErwPC+3FAJIq3j9Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7101
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 09:37:24PM +0800, Zeng Guang wrote:
>Host kernel may clear LASS capability in boot_cpu_data.x86_capability
>besides explicitly using clearcpuid parameter. That will cause guest
>not being able to manage LASS independently. So set KVM LASS directly
>based on hardware capability to eliminate the dependency.

...

>+	/* Set LASS based on hardware capability */
>+	if (cpuid_count_eax(7, 1) & F(LASS))
>+		kvm_cpu_cap_set(X86_FEATURE_LASS);
>+

What if LASS is cleared in boot_cpu_data because not all CPUs support LASS?

In arch/x86/kernel/cpu/common.c, identify_cpu() clears features which are
not supported by all CPUs:

	/*
	 * On SMP, boot_cpu_data holds the common feature set between
	 * all CPUs; so make sure that we indicate which features are
	 * common between the CPUs.  The first time this routine gets
	 * executed, c == &boot_cpu_data.
	 */
	if (c != &boot_cpu_data) {
		/* AND the already accumulated flags with these */
		for (i = 0; i < NCAPINTS; i++)
			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];

LA57 seems to have the same issue. We may need to add some checks for LA57
in KVM's cpu hotplug callback.

> 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> 		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
> 	);
>-- 
>2.27.0
>
