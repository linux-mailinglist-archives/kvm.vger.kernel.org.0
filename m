Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0747F79C3D5
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242286AbjILDP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241989AbjILDPP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:15:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD666A79;
        Mon, 11 Sep 2023 19:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694486782; x=1726022782;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OBY7AI2jn30GkzlH0lit+HzsL/q0j7k0eNY1hyBhu4Y=;
  b=mSDa7nvJ752ENK+lIIYiffP+ksv5awB29kzKAV05T1q+Vn3qYGcccsn0
   uqJPQp949eYpB6A3ZMsP2pN3J/2de3BVibXksjINddfcFmsYV/1d0m+zB
   9rheOxkboEfvigzjQSymMm9Eizq9csKJ9fZ2gaB5en87Ow83meUX+kajA
   vDtK8V8FXNhUngNiTO6aTm6HyqTozVTVFMTxKiv1NvZ000hFtHT+R3V18
   edLR0FlEBNdd6fDQb87jLJNcYwdCR6mfTLYGI1/MVm1Yml4FIvdxw80by
   jxeLNsaFFh1qDf3j8/ZZkI4YPJ0YlVLIcu1nB8SMbPGx/FvrgUjmS01lv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="368514714"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="368514714"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 19:46:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="778624985"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="778624985"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 19:46:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 19:46:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 19:46:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 19:46:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzGLfpPI9+0jS7o6qs2AxMGqajYIodBPhnb93gT/pok2uXXsmE4e4TZTmlVVCksqyYq5AkU0mcu3WRy6ygZHoXhYSGSHVzVT1YUr52tQK2DF5IOrnb5cS+aT8s1OJShEY9oq+NYfiwVctjsuFDHJ0ZUaQt9Ox5Pte20ylHFUqnvqJRLpCNIhe9rN7j6wLet3Qu6vY7PhOKhjajIW+2VgCSkiPLqO6AsWJBXJ4xmc4SGpdg2xzEG6dEAoWvQvO1H0PfB7JAqJA+F6vLnw7ORXGw66X9OKupbDVN4D1cdlXM7aLWdw+RU+S7dhvU0UgOuQDY7DinKgTVUQkb13t5HI2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ENK+A2COCqk+yHNaSU/W1NSn5e/4Xwm8qDXdtCVwGMY=;
 b=HUc9a0r6ZmSsjD7nQQOEQ3aBtpG6KNZepGLxjefmnoHbFHIiInVwj+enEfIpQPKbi6+4YhHDddSz4+8k6HkPjBiyWuHfnud2pZlBXOWUCi9Ru24zzvRUlLTXeFZT4H2XJ11BQCTzDd0qjcx1TzDlBLVnGhnGG4/N7C/S/lcDNB9p5wlBKF3UdVshhDEB7qg5qkQJC1NY/cTIpiXBLUCmoP2sjwAypYmvldKnkxCStkMRhly8XaXhPWADXxEGNWs6cpzkaZOqGYDZ1fGQoTWmAKHI6Jj7HtZ7ULYIGU85CEvXRXFDa7VE8CmHGpJceyaOzdzO9pxxJaDOvcwvXHi0UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB6421.namprd11.prod.outlook.com (2603:10b6:8:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.37; Tue, 12 Sep
 2023 02:46:18 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5d9f:7e54:4218:159f%7]) with mapi id 15.20.6768.029; Tue, 12 Sep 2023
 02:46:18 +0000
Date:   Tue, 12 Sep 2023 10:46:07 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Manali Shukla <manali.shukla@amd.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>,
        <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>
Subject: Re: [PATCH 06/13] KVM: x86: Extend CPUID range to include new leaf
Message-ID: <ZP/Q78eSzyWPK0hz@chao-email>
References: <20230904095347.14994-1-manali.shukla@amd.com>
 <20230904095347.14994-7-manali.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230904095347.14994-7-manali.shukla@amd.com>
X-ClientProxiedBy: SG2PR06CA0219.apcprd06.prod.outlook.com
 (2603:1096:4:68::27) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: afd908fa-3f3e-443b-5ab2-08dbb33a7084
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6VyzD87nzctgL4QInN24KxAbsvllv1I7cVi384v65+Sfqm1PexySRGFIXj4Z38K0NyN+/bHepMqv6FJZ7lwCIV68XzNV4UOx2mlrp3sU08WBfDH9fl7i6Fe/sxmzIW51YsVgQQJmWLGCsh4OEYUSgCwcq2NmJiVp68/8FRCCjpD2a9KTRqouxahxapwNleqAGKhShrSKOvhVwmWRO4l2iSJUMy5xDSifIuVg5U+PD0faraYAKHjBX0976PlBwRVfsLHUCzmkk7lNnEztnQvmwfydYJfo3opLp/9q9G7CIFvZRyi4VM4wRgelDsqV4Mfc0QxDX6i6mfUZniGXP+GXAzBuYViayKeMkODOfprWqf+HiZzAL1rO09T8OEooHd92knBu/9c/ICCZB7jYrtbANaR53IZrzu/zjoW0FF7V2YmGIKTkRXQsuUmLgMv+M5iKxxmaj+mlUqayEeh1hVvR55/mYr9ezKsEOwxfH7FrAPotnsqxg+3cO+dlNIeUtjjr7KLOoyUMTB7sJMwAeDqQdaYyarpzE0QfjfGiQAVa07c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(366004)(396003)(136003)(39860400002)(346002)(186009)(1800799009)(451199024)(41300700001)(7416002)(82960400001)(38100700002)(33716001)(6666004)(86362001)(2906002)(478600001)(26005)(6512007)(9686003)(6506007)(6486002)(66946007)(316002)(6916009)(66476007)(66556008)(5660300002)(8936002)(44832011)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qV941qrnLGfCpEFEOCQsEHPhiecYbocrPcwr8LGhdWg2fsOHo7OQU5kB2kTO?=
 =?us-ascii?Q?CmYZfQrYo30G+wJlHmlMaOQR+rELNeIPFPZS3FzeXwALvn+zwxYz7vytWy11?=
 =?us-ascii?Q?dBdxpaHfbZRph0LAmGQALJ8vK5QXSLigV9w/+rnouB0hbzrX0OrWsAX9u0H3?=
 =?us-ascii?Q?edF+vTyXvRwHZXMHG65Va43wCmKo/zCDcu30AbC9jgjobrr01VyYAQEZ8BsI?=
 =?us-ascii?Q?JSgPEf22ShpahAvnFaZBprip05Meuc9ejVc9DqUv94fhEFtYVwndjelpe6dl?=
 =?us-ascii?Q?++bmK4deIViVL5wFfSW3q/hqL1vax42aepCV16w2O08GfaEOehPa1aGFQl2x?=
 =?us-ascii?Q?9/v8ZHm/8Ui7cDWQi1g58sMWR38onk76YvFq/416zP0IojmEEPcsQzYERPDO?=
 =?us-ascii?Q?TcTkIw/6RnWctXMi0N5Fvzc9h6i4i+77ElAxtsjkk8tWKnGpyat6r0WwVWwh?=
 =?us-ascii?Q?yVS8VJwVqbdBuHlTJreQV3vRhFPS+2BTkeNX9z1gfpNyzKJYM1E86EvnV2G7?=
 =?us-ascii?Q?pjNk0i3FZMw9i1RZU+A9Su8oh7gID06gV2qRtjW6bYq46ANWucMjNXWwf9ve?=
 =?us-ascii?Q?BmSRuPLNc3AGaYvkPZU6C9q0ktUS1tOmxm5wMWPFO/QSvZdfsMgj5YyKEMmW?=
 =?us-ascii?Q?Ubum03nf5NmW30zlsQk2oXgd5wSfiw7aSEz2MC0aoQGiG8cyahKofSyZp8jW?=
 =?us-ascii?Q?bifQ9v2Pb47olLdynKf3m8AhrGOITA4ZhxM/Wa4nUgGdh+KRn2w4O1mIdli4?=
 =?us-ascii?Q?nWJvAerpEbFVPfiCOFzg8imYEDkq5lgxdjByN2co7ZScl3eXMXyGv5vNcb94?=
 =?us-ascii?Q?+4xbsoBWFptF4+NuK6K+ZxN5S88k2QceXNdTyY5+aaQn+GDnd+jc4y8EeExr?=
 =?us-ascii?Q?09FCUIYVYEJcxQT7nEa5I5NjNd8sBcXc5OA1Kgsfw5A/tWW6Lu1dOdKSdZ+8?=
 =?us-ascii?Q?oeMv3r6HoLIFFpgSQmBN7ARqym3b707G7OtjwhI3gODELvVIH6PJ1GX4YYTt?=
 =?us-ascii?Q?Gu68XJd2xSwhry0aNrPtzS1ZzQWjYsEgK5OzDsC6xT7IdFVzq7L1ULj1XI3C?=
 =?us-ascii?Q?J0/Q51DFIF7jp29NFHBdOYK9bp77fjrhzoI9pI9t8MuoqtsrtV7d0lh4Jfl/?=
 =?us-ascii?Q?EDhKAw3riKpvnC1rn1tKV+ztftZAe+fQR+fBJ+ify0HUAIEUiH6+mnmFJYwQ?=
 =?us-ascii?Q?YNVxS7HK3EabL+5Z2TRuS1NMJQ8KZy2RjxXDFRUOvNVEKk0/Jm5YB72hHEAM?=
 =?us-ascii?Q?lwhji58rVYpjxUKVhqKtNtoRChdzalncMIi1FVrFYJ8oa2g9u68nw6oSY0PS?=
 =?us-ascii?Q?ZnydKOXSkF9fnpcSpCA0t9j7PMD1bMD5N4pxqwHGPrXRDTBHkBi3yWFPs+sS?=
 =?us-ascii?Q?z6qEuDnrkzWzbhvFNz5rpRlqbk+MogYQ9W/37Bf75iNpIOCX44otDzi2mWml?=
 =?us-ascii?Q?n9zt1MScWPTFBf8kytiufkOTNpcmcMRwUcrjFuM0oY5lJlflwNhlnDTVGeq/?=
 =?us-ascii?Q?8kGS1xT+lwR4Ap8zFL9LXy7vdnyHet8WKjjk8B3l1C2KzH4bnulFAnF4BgP9?=
 =?us-ascii?Q?xT02rnrxBVtKdvjeXEJrhaY6JujNaHAy8RzusI+2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afd908fa-3f3e-443b-5ab2-08dbb33a7084
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 02:46:18.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OJ9EsWCqFrNdKPEZjpqd16KOC6jwGxNwI5k/MnrgmzcoMKo/6B/Zz3zRyv406JCIHqhej3lWoQGEy0Pfb8m9Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6421
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:53:40AM +0000, Manali Shukla wrote:
>CPUID leaf 0x8000001b (EAX) provides information about
>Instruction-Based sampling capabilities on AMD Platforms. Complete
>description about 0x8000001b CPUID leaf is available in AMD
>Programmer's Manual volume 3, Appendix E, section E.4.13.
>https://bugzilla.kernel.org/attachment.cgi?id=304655
>
>Signed-off-by: Manali Shukla <manali.shukla@amd.com>
>---
> arch/x86/kvm/cpuid.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
>
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index 0544e30b4946..1f4d505fb69d 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -771,6 +771,12 @@ void kvm_set_cpu_caps(void)
> 		F(PERFMON_V2)
> 	);
> 
>+	/*
>+	 * Hide all IBS related features by default, it will be enabled
>+	 * automatically when IBS virtualization is enabled
>+	 */
>+	kvm_cpu_cap_init_kvm_defined(CPUID_8000_001B_EAX, 0);
>+
> 	/*
> 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
> 	 * KVM's supported CPUID if the feature is reported as supported by the
>@@ -1252,6 +1258,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> 		entry->eax = entry->ebx = entry->ecx = 0;
> 		entry->edx = 0; /* reserved */
> 		break;
>+	/* AMD IBS capability */
>+	case 0x8000001B:
>+		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;

nit: no need to clear entry->eax to 0 because it will be overwritten right below.

>+		cpuid_entry_override(entry, CPUID_8000_001B_EAX);
>+		break;
> 	case 0x8000001F:
> 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
> 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>-- 
>2.34.1
>
