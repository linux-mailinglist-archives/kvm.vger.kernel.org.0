Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DC56C0C9B
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 09:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjCTI44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 04:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjCTI4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 04:56:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BFD10A95
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 01:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679302612; x=1710838612;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CnKHabEaoaA0YdXcuFRI2a/FpJSZ8NFWx5Nbdz4iLWA=;
  b=F5nkvasVfSSB7U7FQHf1lkTFOOxywob0osCuYGa0EiPkLrb5lz5uzQI8
   tmX3HxwZS2vtelDzI1CdyS8qiGgWce8+CYSbdhHKwDKHVRwz+5oAcO5rH
   zrqxHBxNouSxpDIr7GN26KAOzI5dguouG1Yavqx3EsDwvhBI+ifqz5QuA
   caHatE2kaAzthu3SwTG6ehH7iA2k6SkTR/mhjYJqoye9gYwkbKgNAgKhe
   chL6Ui694GZuEdtsCSIkdoYqC4i0PIpQU+fzO8OIm8E2Gm/RNN1eWnt/G
   0Id7Fy+NmLCNAPi2XpVnPst78By4Qr4JubTYS/iNk/ua1xEd0Niml6w2X
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="326979663"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="326979663"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 01:56:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="791535041"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="791535041"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2023 01:56:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 01:56:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 01:56:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 01:56:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcIRWigMhrk3jDD3jpPP7eaRwH9JU38QMXe4E1PDYZsZa2zAWW8urd27HAaNr35UJTDewLI69cKjaKQ3xs1wnnT0ECFL3oTvi2Gd5Yk+gXJ6W3WIsKzbkc0IKputKVN7YkShAnA+jRTNHiuxtYpTW25dRIuRIl/7ifI35HclLgDyAEqNmXuXvGmNRSjFpHq4EUa5TCQg0nwU7T6muJL/Bj67LNV0AHHWcPC9AvWWTp7Sd3Lj5i1jRfVmu0DJzbb6GoRIEiA/ZV/6hnkQxYb21S+Y1XE4FjdH5I3onzgAaVyKRvP08vbwtlha1NmJkvX/cfcS4eEkn3wcIiUzfnS2tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COll5wadid+K/TGlOgFAJgDr00CG8Pi8HNSQpifXTRc=;
 b=d/jfH/0LFxcPFZi97QIhdh6QmX1aZtJE9V2S5936FpCQlfQnpQQhToGKZGw5a4GCwy238320LJF/ZMk/ELgrsu6pwhkS0Ho4PdX2letClBkpSGAbAm8z4XtvnIaRO8yrYscD0pKOkye2HB5KBTEKOsV/YhrmZ7pJOTvZubYT9ezCCOQdKTX2CyfvgG3iTfQsU7FvnQwLYlFYmJ2S4+wGJKYRoR9c60h4vvJqiScCr1iiCBOqPNAfp9G3LDDzTOSkSbBVLAi2q+zSU5loR4ojCJIEx1wuL2QNEfnljfrR8opH7ql/IuiYCKzo5N6BT7Xg9UDXr+HhizhWFtJqIOxv0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH3PR11MB7896.namprd11.prod.outlook.com (2603:10b6:610:131::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Mon, 20 Mar
 2023 08:56:47 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%9]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 08:56:47 +0000
Date:   Mon, 20 Mar 2023 16:57:12 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v6 7/7] KVM: x86: Expose LAM feature to userspace VMM
Message-ID: <ZBgf6Kj6veld5xkI@gao-cwp>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-8-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319084927.29607-8-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR06CA0212.apcprd06.prod.outlook.com
 (2603:1096:4:68::20) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH3PR11MB7896:EE_
X-MS-Office365-Filtering-Correlation-Id: 2896bb42-72d2-44e2-e04a-08db29210920
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IK1uVMyQNKOfoXHlBxrEAKtgPLIvGfG24051VbMZGvdPC46qu+ckw15Jov/iMc0p+Gzh42T6fcQQo0a6Dh6A9BA3fzIT7e0pOUogZH5H0nCZU6lDx25VMzpO1+9eKBODmvy0nfIn8GEu0HBj58vqSIAWPhpHokyX4b35juyOZ29gsh0JS8j7ZQPjOIqXOfO/hL6ehb2aJWdMLG0en3Br7CJ2E2sAAfLPuABYu/F5AXRr9NGGXpIN2SiGUB1tt8W4IoLzWhp4jyIc13T9Bg3RzCBi06PQ+B9KyMcv+7ITPZOtZxKeBrBd+nz1BTScvvRMg0Rx/eLThhJJRnI1rFQ9ypFUWG+/XzY43iap/UFiPqC7AoT1PgC8TJHdEaJx6lsVmCDH2PiqO7OlMDwu2z0UBDHH9n5b+WhW3KC8gpg76ixd2dwSR1ZrYeMFlVwJ1Frmhcl/ZW+lIDeta5v3Ph8RnR7NeyqhOQj5x4LQ9WE9fWv8vEbi5shAlLWCvNJXAihFoN0ISspHDyXtzlDEukxeaRU9z12fx5ABHdWS3FljjUxDMEN+f2G7zardrOLkHGVAixsJWJVw1KUyTZJiMNqP/MRyqDRPndo6iccvNppJTsRKET0ENWeuU2PSKquzHvtr4nS3u+AwZ31mbHk/KpZ3hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199018)(2906002)(26005)(82960400001)(33716001)(6512007)(186003)(38100700002)(6506007)(9686003)(44832011)(41300700001)(8936002)(5660300002)(6666004)(6486002)(86362001)(316002)(6916009)(66946007)(66476007)(66556008)(478600001)(83380400001)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uu1+4yiMB0mswnAix2DQhGTFtjgdRCeB1bXDezVuv9xXTxNuUpjd+/IgQ0VX?=
 =?us-ascii?Q?2656qP0wxIOqVhetpt2/zT4AwXgrPepkQXK+w7mKplTVFMfIdF2XUBqnZmiK?=
 =?us-ascii?Q?blpcTpAHwCHD1h1lf5Igck64sjLTMEBou2BKHhwmC49HhOmjXdU3GcVyeMKl?=
 =?us-ascii?Q?DJOaUHnorURfi8Vb/3AGzAu5oulOjbLt1wG4LdPiiEJrcoDxfypz54sRMxYV?=
 =?us-ascii?Q?i337zVFhUrvC/rXUn3nN6+u1p3J/htNcDyE7L+LPEbUcpwBNQkHzJCkQVW2u?=
 =?us-ascii?Q?hK61IEVhCdjMy7L2p4aJU0AUShX+DKIPiSj1laoRM/5yKyIVhWGrqyRGMxVG?=
 =?us-ascii?Q?0/NfyZLJeL6WNcX512hubfFoq3Vg1BefVBLOaWzdRmrJFKapi5c0beKh3aJ1?=
 =?us-ascii?Q?KPe0bVuKiXVAGYLCI3WiPoFGoypj6XLWkN+cPqFcgk88vA6gWNYoecKugAlL?=
 =?us-ascii?Q?Qff6ru15dO1fO8hMLsEmMA3uK/zdEQfUz6MDP9CaKtOTnv4fs8CJKvf1L0Sf?=
 =?us-ascii?Q?CEGxpy0hK+B6wHr9Rga5mN2Q90jU++DRVKx8vdIcR9wbFMSgwWOZBNdTw5AC?=
 =?us-ascii?Q?EDVPqwK+eLqGTt+GrfJVc9pnR4yDw5fgF6MrtxYiB37DMxPm4AX8/lcQEnIm?=
 =?us-ascii?Q?o9kvqrQMYyBOEio2Z+4WQKNG9FUPjw6bKYhzXINcRqlR72a7JfCNgL731In1?=
 =?us-ascii?Q?eUyTDdRvzrS7G7ubVzECpulTxnUVKbZVc7bLpBsCm2s9lTDB8w3BwVH6OT14?=
 =?us-ascii?Q?3X9RM/RppqiYgDlK+0J3BKfLfOlgSRLeU5r4G7smTppIO8R3+T7264zH9fx8?=
 =?us-ascii?Q?Em1vQUJMPzL/0jbiKrGWGK4HoBqfew6mLTryoBFJS5+AoW/bFXBqTczRwvmg?=
 =?us-ascii?Q?kGWfLTsqp5VnYAMrBCvpL2919paeWIWrb2zZ+FHImcZ3l8UN4WvqVfJMWZhq?=
 =?us-ascii?Q?Tq8Dt5oxD2QCBgx7KYERtwD+m5q8VL14MSn8EAKuOvimitQnb58JPBep7Sn4?=
 =?us-ascii?Q?suMMTZMavkHKQEKkn0XI6B1AErPe2UgyUMlGDsBiT5LNL1Dkee6QTAmoeK7h?=
 =?us-ascii?Q?VkhGljsn1VtQ6tF4LYYEcitC/Az8oCNuCqHSz1TIkaBqYfX21zwKySAqvt3n?=
 =?us-ascii?Q?s5pYFYas7Pxjq8RpSSH5iG8EgSQN/8iTS7fF/6Wl2ovKTRfmrtCa7M3JKLqH?=
 =?us-ascii?Q?dgXsH/xJE2CPImakQRqILSDRJ3pB8TP5DyQZrBUfjYfOMyvjyOJCn0XP0FYD?=
 =?us-ascii?Q?HJ9CSeGPrZb7HFWpT898T/yg1Ve75Zh7Ex8/N+dIXnDHKDObppm1cdeTs81W?=
 =?us-ascii?Q?U4C2wH0za9vT2bCCpzFfsiJ1WKV/qQ+dSGq97Cw9I/HG2wVQHhgfjcWQHymg?=
 =?us-ascii?Q?3nptWfz3gfdiYHO5KgROW8SdhptRnA5m5AZ2VCbHWjVdzWhGZxBTKxLXv15D?=
 =?us-ascii?Q?3mYml+4mYNmTrWk/JbImRsdzaQJHjs8LukchdsgYe6EKs2+HcAQXiKAWNZlU?=
 =?us-ascii?Q?WMgQy0E4QtWWCYMv7+CgLvVeAs7U1me+spVELIHpi+xnbzCuLPSu4xVhdGBs?=
 =?us-ascii?Q?68eCXc+eI2BnN9++nryzaMGNgf2Jep6ADoEz595b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2896bb42-72d2-44e2-e04a-08db29210920
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 08:56:46.8897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDM54Iov2U4yS/PP0OcGO0C1fm0NhdUcnu30t5fgXmtYV6raTTr/NGBZWo9wOBaiBc1cVfK5MtANdlhiA1F74w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7896
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 19, 2023 at 04:49:27PM +0800, Binbin Wu wrote:
>From: Robert Hoo <robert.hu@linux.intel.com>
>
>LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
>Expose the feature to guest as the final step after the following

Nit: s/guest/userspace/. Because it is QEMU that decides whther or not
to expose a feature to guests.

>supports:
>- CR4.LAM_SUP virtualization
>- CR3.LAM_U48 and CR3.LAM_U57 virtualization
>- Check and untag 64-bit linear address when LAM applies in instruction
>  emulations and vmexit handlers.
>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
> arch/x86/kvm/cpuid.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index 8f8edeaf8177..13840ef897c7 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -670,7 +670,7 @@ void kvm_set_cpu_caps(void)
> 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
> 		F(FZRM) | F(FSRS) | F(FSRC) |
>-		F(AMX_FP16) | F(AVX_IFMA)
>+		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
> 	);
> 
> 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
>-- 
>2.25.1
>
