Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B16B69003F
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 07:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBIGPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 01:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBIGPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 01:15:37 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0763F1E1CF
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 22:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675923337; x=1707459337;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IPJsoJqkzDzWtyNoHL886Z2hlpBUNcbXK/peF43ZYqg=;
  b=IGGBmTFIspSWkTDvpVmgkIg/P+KQk8UwSOi3WNTlbVdfe+NFSAURuCzn
   hK0UJ6bzMKoJfMcTepbdfpd5jKvT1K/41dwDUV9fT+enloDCApFLt17WY
   Y81Z8e8p/SX3adrJWhuYkgX+fGsu8Bx0BrSUESgEyHm9xigtQQ5sNVVii
   ImL9ulCPr3Jz2BFDGQivvUuy3ZWt/Z1KfM0QjDZjst9ZezX5/Yt0A6g1t
   naX0c9LjHgLVX2Q+FOUTCX7DDBEDMc6pj3MRZqTiPXe4Wy8CPY1oI0J5N
   ayyuTvuxLR+6H+Czxpm1TwD4p0tBa3hKMTDVchJrE31BcJ1YOATTINKrP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="328673500"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="328673500"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 22:15:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="617474821"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="617474821"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 08 Feb 2023 22:15:33 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 22:15:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 22:15:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 22:15:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6w/pjwtqEIFwrsrFhYMBGBLjU00xGJuQlLd/TWq9/oo7G7ISP7Gl+2bANUAO5xcIeJBZIy08pAlxL0yNIaIwD5SaO8eX3pBI2VRL4KLCRUV9WVLEZs0wTh/4PaYzfCG26Tu9kV/VvapJx381jS03oZy4TKGkeUZxq3nFepwG4vpiWI/OHcmst20ZWLBIbLu1ZCTn1ICee03K132wxBf6Z0QSvLklJfDGWzKblRhLlOoUbkXWwfSYo6LYGava50DqqeylkxLtWjCWBnn/Zb7pjec/GydwGkUHOeT/VOL0S52UuC5aV1CwItwsy0Hdopak3XrNKaq6eJxbrOYIhSr2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nr81ny3PJj3sQVztzdvDSc9bH2b5l46sx8Yv5/M8BZ0=;
 b=bqZk+SYpR0klQEHXBDnKUnkNDVALeO9UVytlV83exT6SMIgj2v7tp1rQeHl9LzCkrgPBRFiS4h12Xll1xRMgm4yMV2vvSHY8pMkFI1gCqpMPokA9nSpJ1/kKZZoLWe0+kqN5SBdQOryuBfYq9ZB+u1k4Cn+yjjoNugt/kSbgENNgoxQOVv756oDUgsT5YTzQTxb8kZGNIwvTRbvI2W8pGfiRje/Vt+aZh2a2C35tqZsDTIovUS/qqwJ7DN2ggCaJwLD169+bJ53CYyf6jnWmNG7MzJzpob1gT7BpZBbmK2PXbhxleqcAYsJEz4I1CSb2g1PKbl6ZbG7eRYGvinTQEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH8PR11MB6682.namprd11.prod.outlook.com (2603:10b6:510:1c5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 06:15:25 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%7]) with mapi id 15.20.6064.036; Thu, 9 Feb 2023
 06:15:25 +0000
Date:   Thu, 9 Feb 2023 14:15:42 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
Message-ID: <Y+SPjkY87zzFqHLj@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0188.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::10) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH8PR11MB6682:EE_
X-MS-Office365-Filtering-Correlation-Id: daa98537-f8b6-4820-f039-08db0a65087a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R2BWAdwsucTlbdcMi4eGuE8KZotyWa7BbX2ilja/ON7ZvNF5Dhqb3lfrKhLxixKVl0uJWnay/TKQkZLh0zbViRw7TGEDS4Xt3wC6LXozBd4MwhhVtndgrIq81q7wv1yBPLh2Z0rBhSQFWcsYFr8jrgXN5+wYjcpbXPm5a+QhgE6nQAk44Vxr5+TBE82jjUF4VtgaWmWr3AzujZNtR4uQwxej2hkT6LcwJvJTL6O6qQxyAw0nz6M7qfXfr/kFZ/JNPPSyAMwQBdRYTr3KxbC93rHwkOF9i3DFTOM26PpJbkqhJWl8Wc5BAO1ha8u6M3t3FNVkouEefB1jJMHWIG+qH8yufANHakuH2wUACH4Gzp8lHoHCL9Z/kLKxi+eyV3P4gqW/kMn/mufu8R3vVwsxPofQSxs06MmNjhLbcvckqreJpN4QcHRxJ6T5ijqxi9LMztFyz+RfXwPcfS5fPbYXIg1uQXmY2LelwUcpH/ZBAf3Wa8dnkFQ14wi4aCVg1Oc34Qe7nia1SZBtSLuCjnO8Pcs0bfzF0QHHIJ4q8lqYjuRLMBQ2ck/lfPLjl8+OYgjV8LI2aKppMEuywpnZ3bmBGbD7cx50VJTjwGUOp4bv/LYtBMneNePeixC1cW3wqX3TGdNiCD4SQ9m4vrsYc/hNk121XyNSkA1J79casn5Nqw2KuJtUriW3GapSy4F5OrBtCxrkYesxdNgSufj4hlWLBhVveXLaNTHAi/UdxAfpB6oUr0xKW2wnj+oLYoPVAwXZMQr8L7xWfy4HmnGAZvMXkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199018)(66476007)(316002)(83380400001)(66946007)(66556008)(5660300002)(8676002)(6916009)(8936002)(4326008)(41300700001)(6666004)(478600001)(26005)(6512007)(6506007)(9686003)(186003)(966005)(6486002)(86362001)(2906002)(33716001)(44832011)(38100700002)(82960400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gzjZyYEnpxyUin6JTODOxlMq8rV/9nk2qWJBwaCNumT3CT3Ns5TLp8kLuDcq?=
 =?us-ascii?Q?z6Z/r1oRwq5QKZCw6Bx1jslM+m/L5eUz+KXxrwzQPWrRLjnLHqG63uP0Aj6g?=
 =?us-ascii?Q?GlrSEMe6xni7cciwWIxRHJYpXeBtDpJlsxLW1+OtM+HZWJCXXIxOwZ7Q6SGZ?=
 =?us-ascii?Q?v+BWLybo1ApTHhnqA+KXdTXDE8zgef1EuK2odxGeb2xuHKO5WWnt84efDYc7?=
 =?us-ascii?Q?qV/DQmiZVT6Tb8ylUV7s9+NCEeUMjZbB76Z6EHXdLFC5dCTSTlpLHPgiMtwp?=
 =?us-ascii?Q?fuhf1pAI34w7chMdVusN5P0bRclJZfyGckszSboI6UbS5YWKakGO67ypOizg?=
 =?us-ascii?Q?Xu1zSLtk8xAfIG01CNG7S/64NBCKPbDZpytLD5FYQbfp8kn99jjsVXfTvqxb?=
 =?us-ascii?Q?JWVOKLdExyJikGlGuvVPOcCUko0HvWk8BPiMjygSRWYLwrAH1M5QYSeUe0Ty?=
 =?us-ascii?Q?2KJXNq66Jm7QPM9IDmFCC2rIO2dVhGeKXcO1dV5kjKiVEvl3nWZbUUo6dfCs?=
 =?us-ascii?Q?gB/08A4I/TgbyztMrM5XDf3p5zBPOltK6ow0dGpnPy65+3s3JDADEfcAD7GU?=
 =?us-ascii?Q?t29A68VqMDPZm3g/RKuqyHDibuh/BpXTxXbT11drqQdV33RrnES88gJ+tn7w?=
 =?us-ascii?Q?WX80gSkyM5CGIaej9N4F2YhurkfU81jlBmzduXBL7ZNAWGxovxY71qifxx32?=
 =?us-ascii?Q?mU7MGZlr2H4dO04h6X085D1i2dlR3ZQfK8xQBELpJcvP8e8O4jXVrAVb5xxc?=
 =?us-ascii?Q?SCC2EMeF8pMf5iwXvpiWBx1gVD1P3sHJnF5g62yMM9rkwLOQGh1Zt+sJdbQ6?=
 =?us-ascii?Q?KPEqkXlmIr9+pq/jB57cq+mwWLtR6phU93plRCx52C/HkDNPOw9YCtXWtHW6?=
 =?us-ascii?Q?7EmBJKhiGoOx8c9UgwJi8Gb15FQxClk0siKTaVJAYNjxlwyJ1qJAIBPhpRmI?=
 =?us-ascii?Q?XPL/appZye5mdVYsJ5wVEx14/daPzqMniYrwSc01VMXhM7fUBGLQNlJIv43Y?=
 =?us-ascii?Q?ryvg0+iwCmUgmqb4eyD7T/BUWLlZ+N4UyvxmNW/Y4cFYKqvyx15R+/GwvZL5?=
 =?us-ascii?Q?yiLvdPTjl70lnyXKg4GcGYs4bMa7vo7UPnR8LSEj+YxW/qKw1qggkRX3VpLw?=
 =?us-ascii?Q?hgdDJILFuTnJqyGAZFyCrNsT+GHFFX49lGRQzFvxxWEvPW7UL7H6zICNBi62?=
 =?us-ascii?Q?/94WNgiMSitNGxd95/9hDfymvkEWQH/gc1Cfp1n/ywOdEYTG/81//RZfZT9F?=
 =?us-ascii?Q?jmXWIAK3LjaJmraTO84KBHlWvmNKrSKT3k/Yrj9KZnME46fOc+q9s6y4ajDS?=
 =?us-ascii?Q?j8AhFecTnJTOtS+Y4FyfshBiiDmYeA2rf3wy3E7gTV5Z4fctLUztIA1FN/H4?=
 =?us-ascii?Q?5sRwIJbbE4ZmINnXtgV7duAV5oHOkjbZA8NAhfwy0wjsQ3OUvPb29E8Wv6e3?=
 =?us-ascii?Q?QQ88Yb744dBUEboOfVd3dSge4cudaLG3Fw7VfG/xtL29EbVXSpA1CFwMr9RL?=
 =?us-ascii?Q?xerr1a3U4bap8xFLHBuqEFoNPJMOtzEMu0V/+wY0znNe01/KKl5UwZ8VEHA1?=
 =?us-ascii?Q?imIv39d6jYFGrWC4a6aJUMoVsLGI1VBzIDgdTXsJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: daa98537-f8b6-4820-f039-08db0a65087a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 06:15:25.4712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqNAEBr5X/kz5/5DUvdRarvkCrRSxgd63Y7Wzjypr3L6XmvioOc8veQcaYEOJ8+kzStkC0NJojzW10K6jiNtTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6682
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 10:40:13AM +0800, Robert Hoo wrote:
>Intercept CR4.LAM_SUP by KVM, to avoid read VMCS field every time, with
>expectation that guest won't toggle this bit frequently.
>
>Under EPT mode, CR3 is fully under guest control, guest LAM is thus transparent to
>KVM. Nothing more need to do.

I don't think it is correct. You have to strip LAM_U57/U48 from CR3 when
walking guest page table and strip metadata from pointers when emulating
instructions.

>
>For Shadow paging (EPT = off), KVM need to handle guest CR3.LAM_U48 and CR3.LAM_U57
>toggles.
>
>[1] ISE Chap10 https://cdrdv2.intel.com/v1/dl/getContent/671368 (Section 10.6 VMX interaction)
>[2] Thus currently, Kernel enabling patch only enables LAM_U57. https://lore.kernel.org/lkml/20230123220500.21077-1-kirill.shutemov@linux.intel.com/ 

Please add a kvm-unit-test or kselftest for LAM, particularly for
operations (e.g., canonical check for supervisor pointers, toggle
CR4.LAM_SUP) which aren't covered by the test in Kirill's series.
