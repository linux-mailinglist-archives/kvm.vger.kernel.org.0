Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F356EBD36
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 07:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjDWFhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 01:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDWFhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 01:37:39 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468341987;
        Sat, 22 Apr 2023 22:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682228258; x=1713764258;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=96LhbRImznppKpRmUuTODm7V8mS1ssCno8gRqM2GOu8=;
  b=JxPD2ie3WyF+ogbx/85Xm13v60EjbMdGTQ5dPDsGyHCHXztB+bQjo6Do
   WK19UcwO2bXSfNYHvPSSPVsVrCjEnpjYCZr+Dz4tIU9Dav3jnAfidpolW
   M9S66lPaEnQKFJlPSal2pfsI87s0mjSKHC4fXOQhmeTbqubly84YW9gnu
   s/5Jou2LBoYjmaD4TaKeSiYLraFLa5VJs7Se0tGaTMG3aERjkr9ApZLtK
   +nIB4VgHTlrYXGOiQovYyz3NYRiScmcW+iQ6PvfxQTbM4/DTGyqJi1iMW
   P0wnPGAp/9pMSvQOXFyEVrmkvw6pPUUL3yWz3OU8Td712cRAHP3V0BB1F
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="330453386"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="330453386"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 22:37:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="762008569"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="762008569"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 22 Apr 2023 22:37:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 22 Apr 2023 22:37:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 22 Apr 2023 22:37:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 22 Apr 2023 22:37:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtKkNVlAxBB0LpwTDzaC7YOlXub0Dm0JB8mCmbnQRYYdDO6W3/Dgxp8aKLIi2556pEQQ9Bft7hugqg+9nehaHK7hXwgkTwi+uBCJ9YTaF4OozWfgW4pcyY9ticOTTnmpwmhs9LHeaUi0xxAXyyCM5FMRxQuLw+8TXcBEui48BLV3NC4xf3smxIl1mL+0OYfSBI/5m5vz4yexn4JtPTC3ZgXb9eMDLDf4C/51b7OJ6Tm+J5M4irQKBq3LIlkHIREKe4TWGGw1Y6Z8V6uezmo59uyBuOBJZPIkYksdoiSnK0/T6ySkHq8+TNvDyYMReou8W+xXl7kkwCao6a4Q3ZnKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k58eepagYqQG0ssaesAZNXBY9Lac8o5wtviVSqvsXHg=;
 b=Eb3/sNb/7BH/S+aBWUXLnNqPeY9lBB7g40Q1S/vxlyXLRV5uI9zUimDPAk/QeTXm9zBuUGfPXbot1USr0doW72wLfN2YxlMpomn8uc9EYTHypd03lsAKBQ9JJGqz7UZq6lPia8733TnlEo0kNa9k4EEM7xmrzVSPu3pEfGdpfvYJ77saE6KK5yq8G7B8jMuuVKxfBhNSy7Gwrxx/UibEWSdnAhkpU6a75BOYve4h5gaQYZGySS2wo1Yq61qkn8F4LPaOSF1YVbuhS7N92QIh3XvIXSWEsKq3wBAG3r+rku973KKcVeuw/xv10DNk8k7LjbxgKvKYx6+m3S0jHO63RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MN6PR11MB8243.namprd11.prod.outlook.com (2603:10b6:208:46e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sun, 23 Apr
 2023 05:37:34 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890%5]) with mapi id 15.20.6319.031; Sun, 23 Apr 2023
 05:37:34 +0000
Message-ID: <b9d8632d-7b42-58bf-5849-0291909f3819@intel.com>
Date:   Sun, 23 Apr 2023 13:37:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 00/21] Enable CET Virtualization
Content-Language: en-US
To:     Mike Rapoport <rppt@kernel.org>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <ZEMGA2uUfpJL4rMH@kernel.org>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZEMGA2uUfpJL4rMH@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0171.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::27) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MN6PR11MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: 58fa7b70-0f6f-41a9-02f2-08db43bcd640
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +zZinsPPv/VobxE3ZGrI5n+Tc0fXcK8h8o2K5wIbBmKFNen7k6rf+ZKj8TXu2quA8YlNFL8/Krp72qFrrtNaZ25KEY9ZCOaovFidzzwPKfCMEDmYpyLNJpp1ObwFntHsdSXIRHY8XIBBi6IIyl+OQZiTjX3xU6mVoyriEa2OQl+Zn/OyU0BYwvjnhySip8OUlzAOXSdWqUw5IM2j+EJjFjJgRU7ZdL3HwD4+tKRETMq1yW8f9U9Hy0V6K8cPP1/RCxg31DGJB5eicTY2HN2X3M5fl+ah6GhA563f4KPklY1gfvP0lyvOSo0qjliOPLhc7WC16QZJB9YWsJxPuOYt1+K4LhvfZ2+4doULECIEfqb7KCCv7lMMNUJAf0xi5TJEboFfk334MVnlNGDBy6uzIV3GYTJCclGcsXjilfs61b3+PAe5Xrs/q8fnuXYGqmoIvk875EggOsPyRFUyU/iGu4a4N45tyagFwJAe+oEWI4l82kkpYop4HpgSGW1VDCPVMdWpAV+60IRrDO0vavysRzkpj3yWrFz4LC8RuOxtB0gpwJGK3XlgabAeHsnoplBoQ/39Ftjca7NyDR1zW7yvWUA96+HmeG6o39LLc3dugJvT8YT0Kzct+uV/hD/oiC0Q0vZNrxU673WhtI68k+4dCoDtlQLWncQqwrT3PWTaS7Pql6pMCgobX+noY35Pjyw2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199021)(2906002)(82960400001)(38100700002)(31696002)(86362001)(478600001)(6916009)(316002)(2616005)(41300700001)(66946007)(66476007)(66556008)(4326008)(107886003)(26005)(53546011)(6512007)(6506007)(6666004)(966005)(36756003)(186003)(8676002)(31686004)(6486002)(8936002)(83380400001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVVDMGVma1VPajJFQ1dyRGdMdzRSRE1FR1RXTS9nVHozeng1NDIySGJLVi9t?=
 =?utf-8?B?OU5rY1g5VVlaNmoxNU5Ta3RCaFNLWE81UWlseHY5ang5dlRocDlIUG1vMTlH?=
 =?utf-8?B?aUhSd05iaDRidTZnQ0pmNzRuaVUzVW1hN2pSdFhUSjFHMnhWSFRQYW1mTVcv?=
 =?utf-8?B?cjZJYUE0K09rblNTV0VhNS9aVGFlZm0zSWwzcm5BYnd3V20wb0ZPZFRXbkhv?=
 =?utf-8?B?a1J3QWNWWDgrNm0vc2NlbmpzMHR4REwrazBHZTVaQndIckZwNmpWSHJkeUp2?=
 =?utf-8?B?RGI2R1FXZVhNTXBuTlBUUVp1SnFQU2UwZmlpUDI4NUdNVHNPZVdaUnhadExh?=
 =?utf-8?B?cUwrc3grcks5a2VVZXVldlBLcjZkWDZzS3VISUJaZEI3RTQzeFZjUDZsMWtq?=
 =?utf-8?B?L2I0WHNBbEZzNHg5ZGFqbEl0Tkh4UUVpRmVUNGN0T2d6cko4SGJBc3VLRFpI?=
 =?utf-8?B?SE92N0JMWWsyZEwrR0U1bE1TUHQ4d1gxR0U5MTlucFUvTHdDN0VaMnpoczNM?=
 =?utf-8?B?bXREMzZFWlNXMGhqNTJuV1N4cWxpb1VPcjl3RkQxWXRqUE9EWXZCNGhuQWN6?=
 =?utf-8?B?QXNEQnhBbEpzQUhhWlArV0x2TUdtU2FMcUxlREhkbnBuKzAyQWRZNGZTNThM?=
 =?utf-8?B?d0RNb1Qva3ZmWjNMak5CK2JSMTNNTEpoOUxSSEdLUzhVR3hnUkhXdlZxV0lV?=
 =?utf-8?B?MWRmZUgwT2xjOTk2NGlabVZESnFoVHp4ZHk1WmlOL2t4V3N6UUZsNEExVmxh?=
 =?utf-8?B?eHlYTEprcWRwNFJBSHliL3R3aWpEdE95L2MyT1N3b1VHSzRmb3lVcWlwaTE3?=
 =?utf-8?B?V2wveEhwNnBjeW9aeGZUUDRVTzZLcTEwaHAxa2VoRVJTOWVyK2xzaXV1N2dh?=
 =?utf-8?B?ckpqQmJWL0FFRFY5UXplcG8zd3FIdVpmNkZidzg4aTM3S3V4MEt6c2x6NVly?=
 =?utf-8?B?dnZXcndQY0NVOWxHWFJRcFdTcWRSc1hKb0tQNUlBdEN2MktxYkd6RjZWUGtw?=
 =?utf-8?B?KzBETUZ6Wk9CRm50dFdhakt5bWljbkFYNVBhSjdrSFNVNXlseDh0dE1McTdv?=
 =?utf-8?B?NFp3Q2M4bldNemg0cUFEOThNZjIrS1FCeU5MOGhKK3ExbGRNV2ZCV284TmtP?=
 =?utf-8?B?VWxjMmlZZ0hDUUZLSE5wRkFXNDF6aGZsZmU2emJONnlETUp2cElHUlAwNVdn?=
 =?utf-8?B?S1JXT2hPZTNmZW10UEU2Q1ZhL3U3NHU4MTdJYVQvZEEvSlpGbFdPYkp1UFZq?=
 =?utf-8?B?QzFtUCtPNGJncnNGK1BWd29MMzRtNjgwcCtKelAva3pkL0p6azNhQmxMVkM4?=
 =?utf-8?B?TllqdHUvSVZYY3dUZ2NFcEFBMHljSXplSWROYVN4Y0tmTlJmajc5N3c5UUw2?=
 =?utf-8?B?UU5lY285elFPZkJENUFXYVltZlRSaUV6WCtycVEvOU9OZVhvMXc5NTBSdC9K?=
 =?utf-8?B?REJ5TzkwUWJYczZsemtHc056bHJraC8wL1dwenVXVjFuWXBQUU1HUTcwOGNw?=
 =?utf-8?B?NG5ibmt3V3lialpuRVB6WFJESmRLTm1oVXVhdVVHa1lQUndpYVdsK3RpL3Ur?=
 =?utf-8?B?RCszWEEzaVhDSGZuZE9CbytnZk12WDVUL2N6QlNaV0RsR1hDZW1sc0J1cGE0?=
 =?utf-8?B?aFd5aXhmWk5WejhzSTVpWEdlSWpOOS94TmxuVFZCUDFtOXdMc21CTVY3Z21P?=
 =?utf-8?B?dENRc056R0Noc2h6TzhhQ0VnWVhRSXZmYStwaGRiM1F4U3h2bG9xb1ZYMjNj?=
 =?utf-8?B?SUtNaHEwWXEzSko1c1duZzgvQy9wMVBhbkZaQzZsdXpqZXQ1dDRNVTFTeW8x?=
 =?utf-8?B?Z3hUYlYvbW52d0NSYzUxa1N1OGRnVUo0V0h6L2ZTNnhDNjluc0sxMkxRR3JQ?=
 =?utf-8?B?czFjTG5xSC8zbGs1bXh2bnFRRmdadlg5U080elZ3RHR6ekphTitLd2lnbmRo?=
 =?utf-8?B?b1lrMzFZeVJoaXVyOE9lZ0RIdlZLRnAvbXZtNkh5YmgyWHNUbS84TlNwNGs2?=
 =?utf-8?B?OWRsS1p0SGFGeWc5MHE2c0R2Zk1Db3RwUGZwUUtXdWtldXNKUE1vSGVkUjBX?=
 =?utf-8?B?UWVNYnppd1JOQjM0WmFlRlNwMEpvaXMraWU4NlgwcytLVkxsM2RKNWRrUmxD?=
 =?utf-8?B?ZEgyWm5OM2JiV2N2eXZZU2dHai9JUWl3dVRIRzZuSi9UODVsMnlPWEEwSzdj?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58fa7b70-0f6f-41a9-02f2-08db43bcd640
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 05:37:33.4820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DnJlUDPqGbZ7wIcGgyTPfZF3Q40tqwR5JPw6kH+yt9GvOGtJ/YOPwawPPWlZjQciXUOrMW0SZCJBlRTKOSKGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8243
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/22/2023 5:54 AM, Mike Rapoport wrote:
> Hi,
>
> On Fri, Apr 21, 2023 at 09:45:54AM -0400, Yang Weijiang wrote:
>> [...]
>>
>> [1]: linux-next: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/?h=next-20230420
>> [2]: QEMU patch: https://lore.kernel.org/all/20230421041227.90915-1-weijiang.yang@intel.com/
>> [3]: v1 patchset: https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
>> [4]: Rebase branch: https://github.com/kvm-x86/linux.git, commit: 7b632f72528d (tag: kvm-x86-next-2023.04.14)
>   
> I played a bit with KVM support for shadow stacks on AMD machines and I
> rebased v1 patches along with John's SVM series
>
> https://lore.kernel.org/kvm/20221012203910.204793-1-john.allen@amd.com/
>
> on top of v6.3-rc4 and Rick's series for host shadow stack support. I've
> put this at
>
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=shstk/kvm
>
> if anybody is interested. With this I could successfully run shadow stack
> self test in a guest on an AMD Zen3 machine.
>
> One thing I've noticed while rebasing is that John's patches move
> cet_is_msr_accessible() from vmx/ to x86.c and I also had to make such move
> for cet_is_ssp_msr_accessible().
>
> Would make sense to have them available for both VMX and SVM from the
> start.

Hi, Mike,

Yes, it makes sense to do so. I'll include the change in next version so 
that John's patchset can

omit the work, thanks!

[...]


