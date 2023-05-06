Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62F66F8D9F
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 03:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjEFBeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 21:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjEFBeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 21:34:03 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992961991;
        Fri,  5 May 2023 18:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683336841; x=1714872841;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=R1zVdlCTngGMd3N+ji8WBRSAkScLIbifYlfuhkE+yT8=;
  b=cnSDo/HLlYOe5JKdUPijiV1zBhtdgtQAumKhDj2pVEOpsJwj5msPBtNP
   VBjVp4/4vbW2iFvAfpPhGkJiJG/x0Ixy4WDo19xCqs4Efi7bLjNUGVG3/
   5jR4UUIuKjEwRSjt+bVdzF29s7+d2ko8kKoBxRSvVGfQ4a1R4gsDAtH/D
   h6kChXurtgWOPys2QMREvwmsSe9zkblqMh9r4WK6HhSiJINBB+Q93u6vx
   aEfVAqfgHbIBpAV2VzQrWaPxP4pM9bMGPt0qBekkJpCz+zcskCSEfOgyT
   rvIzzeJkldFspnkvu7nuMzddpT2cNCkjgKceu8Moitcz5g05AVRjv3DLV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="414876672"
X-IronPort-AV: E=Sophos;i="5.99,253,1677571200"; 
   d="scan'208";a="414876672"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 18:34:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="697800550"
X-IronPort-AV: E=Sophos;i="5.99,253,1677571200"; 
   d="scan'208";a="697800550"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 05 May 2023 18:34:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 5 May 2023 18:34:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 5 May 2023 18:34:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 5 May 2023 18:34:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGSvF0FARkrxXd2Us+oLN8Ncvs9IcFsA+KamqDhzdWjtTmx8QH1cm2djWe6MJdgLEub2NxuEE6f3a0o7rn7y6DDFA3un4yp6q2JUrW8vA1k3ci9rM76V3zJ/rUtfINn4bq+C4gWyhGymfXmxF6cYKZYFe2uQHIDTLYrd6end+GBDNuxhh23ON8qgAwSjkp9AsdSvaQANHlUFIGZEMV10oCbrOzcqOkNG0X25uLZoq4zYbpC+tyT1O+guwbLADQH3GCIms8p3yW9QbU6wE1dvCNJVMb7dynEDRgWHZeWISKb4sZKwtuK8axvzL80KczKiWX5zQZgXM6b3eH95fdRyDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnWPIPdhb3PWVXtFA6L3hR5QQ3yq8eIKLDBS5DvZ+48=;
 b=RKM2PvLYQPmQrb0a6KrnJUdwHuPhGOWj+uvlvQ8dZSR6pZm6kRo23rLBkjTBFdkkDiPlxAJRsPtm+/XRREDs8kdi97lYAGlakSbU2KwDKvHY31j9VxWMdbni6yadNVbEvFyfyjS9f/DePraOIHKreVZuISvL/uKW8ft1C8VoKgWdxI7iqziYr1uTi31Ctb5gFedPQO3C1N1qM1AeN+lB+MBJ/ZziaLFMmpzDkKE7+m5mDdl5jtwspsIty9rjVJMdypc6vC/fsCmG9SfR8DMOBQTTl+PjdYaXQV9El3dEQs+mM1gAimf/iAVXdLqwHhYSZ5eHUmJhk6DEYU4zy9aO1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8216.namprd11.prod.outlook.com (2603:10b6:610:192::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Sat, 6 May
 2023 01:33:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::a670:49f5:d602:e2e4%6]) with mapi id 15.20.6363.027; Sat, 6 May 2023
 01:33:57 +0000
Date:   Sat, 6 May 2023 09:08:53 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Ben Gardon" <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 20/27] KVM: x86/mmu: Use page-track notifiers iff
 there are external users
Message-ID: <ZFWopeCUzrQxBrUh@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-21-seanjc@google.com>
 <ZBGfmLuORj+ZBziv@yzhao56-desk.sh.intel.com>
 <ZBH4RizqdigXeYte@google.com>
 <ZFQNgKGcexo0nQ4S@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZFQNgKGcexo0nQ4S@google.com>
X-ClientProxiedBy: SG2PR01CA0128.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::32) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8216:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ba2422-a320-401d-c8ba-08db4dd1f5cd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YoGoVW7WA4Zw05I/2EaUjE609Wl41cUwM5qnk1RWr4QpwQqN8wckT8FCq1uJ2EVr2irpx6IyIQiJy9sLRVaQ3INXJy+cYYl2Ij31jwtFmo3oPu/zL0zEOyxZEoZIwjiKsrSKn8nTwNGpNVp9Cac8VobjwuSxijjFWyVLO7YZ+/2eS3O/fArYusYx+/Y8IbjR4PqEeoIj44QW8WYs+PFdpt1B1uJ3dozgV2drH3gnVgx9BJm3j4EROyq/5rgQg3tmvRqAKTcizI8PfACCqYjod2R85RcDmCZxpNfDo/KzIRWNIc3mcypggzMsLC8khEnLpJpoije/u1inPcAzdMiXk93BR9jWeOAsnDpK9nSwvS60Z1cpDWCfc5g6guWd5sWaRW9hrbD9AafunsxPGVRO1Gm7Lg/oKPJoTZVP+1C9ygvyUf3uDfBBnCkKjjQ24qGsDvr8eTfiHM1v+iOhrSSu6FRNRFeus6eR9xHoVkKKCFv+UGNif8r1impWECdVEUalYccuYWoCEK6Gt8XQBgmicpJjSChG8ScH0QgLWLR2gvg3HHetRGTvtMJYDIFd5gUj+Lwdp9388zSmBQMngj766LU2SU5T/lmVsO2m+rttZTlpsp2ifidibI3lcbZRrfnw34XKagOfWtTshydYGplNZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199021)(6916009)(4326008)(66946007)(66476007)(66556008)(8936002)(5660300002)(41300700001)(8676002)(6512007)(26005)(6506007)(3450700001)(54906003)(316002)(478600001)(6666004)(6486002)(2906002)(186003)(83380400001)(82960400001)(86362001)(38100700002)(26730200005)(19860200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MC9iM21mQXVMd1A5WUpzTlF4S20rd1FZUUUvYWZ4a1gvWXZoaEhMQ09Oa2xU?=
 =?utf-8?B?U3crWUNGUWpPbkx3Y3h2Tm5BVUQ0UmhmT2YvRmQrdHBycUprYzZObVBLSVdp?=
 =?utf-8?B?MkJPUGdrWUp3VkFhNS9TYml3M0dMaVBpRUpOUTBkb2RFc2UxMzQxazJvWDJp?=
 =?utf-8?B?Qm9PUkN5VElWRVVZQ1FRT3RyallPWlRPTzRBOUQ2Vjd3M0dKaVNycEREK1d5?=
 =?utf-8?B?QlRxMlIwT1BwOWVnRkxOb3I4cm5haDRTbzRhVzdOR0lnaS9jZmxrZURoWk05?=
 =?utf-8?B?SFlGRSt2b3FiczBQeXR3YmYwSXpGcUxFY0pBcmVTQnVzL3B1S2syRnZMWnV3?=
 =?utf-8?B?M3hLRDgraHpaRFNqYm1pZUJ6UDRYcjBEMkxMTkpNdWdvM2Q2OTdDNndXL0Z2?=
 =?utf-8?B?OG8vNHlSbW1QclI3ckZGaHVQbk9URWVsVHV2eVdJOTNoUHNscENiWVg5dWJB?=
 =?utf-8?B?ZStMSEp3b2pjazBiTStrWldXZkNGa2x6NVl0dG90a055TTEvcUxtSmVOdjJq?=
 =?utf-8?B?dEtsYTY5SURFQUNjKy9kckRPVVlkbnIrMGkzbE5CZjU3aGZUaE9ISG1tbmVC?=
 =?utf-8?B?RWs4d0JINi9UWnlzS2NEWHBMenVzRXM0TDB3UVJWTHh2ZGVsS0JmbnE2eGhq?=
 =?utf-8?B?S0Fibk93d0N2ZFNybHUwMDN1dzIzMi9UM0FuS3h0bE9hY0ZxRHdyN1dOVkp0?=
 =?utf-8?B?VWozZlZ4NlJlWnl3N1RLVGYrZVJhTnNaT2hTTTd6WEdCOFlwOC9LNnFQZEk3?=
 =?utf-8?B?MitrUExzS1FFbHVXYmFTQjFPNFJHUEFJWmZYeStJQ0hISzRVN1JiUmFrTHZn?=
 =?utf-8?B?b0ZPQk95WEFlNnpYSTJJZWhPSEIwa2xVTURGSjFjaUZWRVJrQ2p3a29pVkJk?=
 =?utf-8?B?UzBBanRZbVQ5dlMwcHBaQ3YxOWpQR2xVNEI5NUFLQWpDNkRNRWZiRE5YT0lp?=
 =?utf-8?B?ZjJmcG5Pblo0aVQrSUhDblNOb2V4ays4RXRLMHJiay9lTkNHL0E1WkdsbGdD?=
 =?utf-8?B?Zng2ellOVVRpUnZmVDhWQUlLUXJIV0JZNEh4aWlQWkZaQ1Z0TEZPWmZMWTYv?=
 =?utf-8?B?Q2MrMUhGd25PLzBKOHFFRHMvMjlSbWVTT3B2cHl4WGdZeXRhOW1IN2VnUDY0?=
 =?utf-8?B?WUFJN3V2c04wa0tIUXpaVEZrTlhONHkxVVJRVHR6SExuQlZEcmpydmNwT2o0?=
 =?utf-8?B?aVNLaUVYSDlaNldXOVFsc0E2cHhqWVhJNGcrSXR6TDNuU1R1L1Rwdks4OTlY?=
 =?utf-8?B?M0l3ekNzQnRXall0aUF1NDFxaWFLNlB0MmlPWFFoLzlub1lNR1pVcHRnTllK?=
 =?utf-8?B?RG9BVlRrQkthUHZlcmdLWGh1dk5lYm9nOVUwSEhyUGU0V0RMUFJGdFREcDk4?=
 =?utf-8?B?eHBlYXpTRko1L3hYQVZXSHprQVRIMDErNER6L0FZN3Rud0QrU3pIbjMzTEV4?=
 =?utf-8?B?T3N1bEx5Mm54RWRwaUszNGFtdDYyYUV1OTlYejZiRkFXS2tpa2lJNEQ5Z3ox?=
 =?utf-8?B?OFZmR1FQWFN0RXkxS3hvS003NGJOb1JCeWZ0YVpwOVVOMERHSUVnOU9lWGFv?=
 =?utf-8?B?Rk9Uc0hDZllGSjYrOEFPbFM0S3JCTWQrWWcrcXNRQU9nWnVhdjNlTHZjcElP?=
 =?utf-8?B?ZVNSdTlNSzROU0dqcVJSWFdzN29OejNialZmeUpVYU1wN3E1a3VsNlo3eDNE?=
 =?utf-8?B?eWcxeDNyTW9NeHhTNVBNeWhVWG0xZzZ4ckw4V2ZmYWhvUkU1Q3F0Q1dVTWFF?=
 =?utf-8?B?b0xqKzFZaDdPdEhIalhaeVpmTFMwRFU4RU9INGJJcmRxT3I2N3pmTlJaV0R4?=
 =?utf-8?B?cEF1NktZS3dxcDhIUS90cEIwZVVWK1J1c2FiT3lINlRCMGxyQ25XcFdMVEtr?=
 =?utf-8?B?L2pGcHEzcXNDRTdVUDlvcVhEanpGbzRac01lTCtaR0RyWTBVV0J3V0VCWjYy?=
 =?utf-8?B?M20zYjZyUWJNTy81WWlnN1p6L09LdTczT08zeDYzbjAyY2x1QjUwSnYvZnk3?=
 =?utf-8?B?L0F5UDYyUFc5OG8wb01jWVQxZW5xMG5OTmNycHpCcnN3VUxMajJCbDkyTUNl?=
 =?utf-8?B?cGUyYVpZRHlkY0Y3N3lXYlkzRmFJdk81V05IWVJOREdZVENMaEwvWlFuYUF3?=
 =?utf-8?Q?wE44sQ24H9QMB7VeokG+cAgYx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ba2422-a320-401d-c8ba-08db4dd1f5cd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 01:33:57.2365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SA5pQe8bN9RHSpPZuzbfKADUyl8hSim+9AMbYVra5BDZfsDBWOt+OlNyuGdCbzN6dehd30MPWT9qxzJPaM+oUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 04, 2023 at 12:54:40PM -0700, Sean Christopherson wrote:
> On Wed, Mar 15, 2023, Sean Christopherson wrote:
> > On Wed, Mar 15, 2023, Yan Zhao wrote:
> > > On Fri, Mar 10, 2023 at 04:22:51PM -0800, Sean Christopherson wrote:
> > > > Disable the page-track notifier code at compile time if there are no
> > > > external users, i.e. if CONFIG_KVM_EXTERNAL_WRITE_TRACKING=n.  KVM itself
> > > > now hooks emulated writes directly instead of relying on the page-track
> > > > mechanism.
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm_host.h       |  2 ++
> > > >  arch/x86/include/asm/kvm_page_track.h |  2 ++
> > > >  arch/x86/kvm/mmu/page_track.c         |  9 ++++-----
> > > >  arch/x86/kvm/mmu/page_track.h         | 29 +++++++++++++++++++++++----
> > > >  4 files changed, 33 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 1a4225237564..a3423711e403 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1265,7 +1265,9 @@ struct kvm_arch {
> > > >  	 * create an NX huge page (without hanging the guest).
> > > >  	 */
> > > >  	struct list_head possible_nx_huge_pages;
> > > > +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
> > > >  	struct kvm_page_track_notifier_head track_notifier_head;
> > > > +#endif
> > > >  	/*
> > > >  	 * Protects marking pages unsync during page faults, as TDP MMU page
> > > >  	 * faults only take mmu_lock for read.  For simplicity, the unsync
> > > > diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> > > > index deece45936a5..53c2adb25a07 100644
> > > > --- a/arch/x86/include/asm/kvm_page_track.h
> > > > +++ b/arch/x86/include/asm/kvm_page_track.h
> > > The "#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING" can be moved to the
> > > front of this file?
> > > All the structures are only exposed for external users now.
> > 
> > Huh.  I've no idea why I didn't do that.  IIRC, the entire reason past me wrapped
> > track_notifier_head in an #ifdef was to allow this change in kvm_page_track.h.
> > 
> > I'll do this in the next version unless I discover an edge case I'm overlooking.
> 
> Ah, deja vu.  I tried this first time around, and got yelled at by the kernel test
> robot.  Unsuprisingly, my second attempt yielded the same result :-)
> 
>   HDRTEST drivers/gpu/drm/i915/gvt/gvt.h
> In file included from <command-line>:
> gpu/drivers/gpu/drm/i915/gvt/gvt.h:236:45: error: field ‘track_node’ has incomplete type
>   236 |         struct kvm_page_track_notifier_node track_node;
>       |                                             ^~~~~~~~~~
> 
> The problem is direct header inclusion.  Nothing in the kernel includes gvt.h
> when CONFIG_DRM_I915_GVT=n, but the header include guard tests include headers
> directly on the command line.  I think I'll define a "stub" specifically to play
> nice with this sort of testing.  Guarding the guts of gvt.h with CONFIG_DRM_I915_GVT
> would just propagate the problem, and guarding the node definition in "struct
> intel_vgpu" would be confusing since the guard would be dead code for all intents
> and purposes.
> 
> The obvious alternative would be to leave kvm_page_track_notifier_node outside of
> the #ifdef, but I really want to bury kvm_page_track_notifier_head for KVM's sake,
> and having "head" buried but not "node" would also be weird and confusing.
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index 33f087437209..3d040741044b 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -51,6 +51,12 @@ void kvm_page_track_unregister_notifier(struct kvm *kvm,
>  
>  int kvm_write_track_add_gfn(struct kvm *kvm, gfn_t gfn);
>  int kvm_write_track_remove_gfn(struct kvm *kvm, gfn_t gfn);
> +#else
> +/*
> + * Allow defining a node in a structure even if page tracking is disabled, e.g.
> + * to play nice with testing headers via direct inclusion from the command line.
> + */
> +struct kvm_page_track_notifier_node {};
>  #endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
>  
>  #endif
>
Or check CONFIG_KVM_EXTERNAL_WRITE_TRACKING in gvt.h ?
e.g.

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 53a0a42a50db..005cdc4fb66a 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -233,7 +233,9 @@ struct intel_vgpu {
        unsigned long nr_cache_entries;
        struct mutex cache_lock;

+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
        struct kvm_page_track_notifier_node track_node;
+#endif
 #define NR_BKT (1 << 18)
        struct hlist_head ptable[NR_BKT];
 #undef NR_BKT

The justification is that gvt.h can be include without kvmgt, e.g. xengt
previously.
But given currently there's no such case, I'm fine with both way :)

