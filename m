Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0BD6EA33F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 07:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjDUFiY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 01:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjDUFiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 01:38:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4D744A4
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 22:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682055501; x=1713591501;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XAf2D0wpVEeqVnxO9qfTUC6YGN/Ouo8I9F/+JAPKuwU=;
  b=L5fAbsp76ezJj5OwpplZGJ8BB/PeY500pgHMfCsGv0oIRh6x4Q3WOaca
   TyuOlDX62stxQ/sTzAuZCEvImEDdcAc9xHdEZD1S78Cmu9aYNuqDIWuN7
   CpjJVfe58PMQ/jrDYfuJqQBRjd6zGUoBaP4HPaKU0HkLUzM2F/832fc71
   J/d4/KBxoP8b8/bmqnLF0xdO8bith6WnS4MB2POIZAcipzjN5TuiNLiTL
   VlQF6h2+lDvHL/2WUO2/YVMD4vUEi6Mx1wc4meqXDhOTlYjv47GjCYEe7
   TU3iI9Fx1JIigO2c4hQo5FgEi3/4wVO60Bjc0clHBiyWkUX74oWZg1XRp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="411187410"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="411187410"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 22:38:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="694853061"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="694853061"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2023 22:38:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 22:38:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 22:38:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 22:38:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsRH16kry8wfo6BUtU3CdYDblg5ql2pXkxwBEm/Qe8Z09nNxOL2pW3SsK32oRsmCHQ2ZoyLUrsIuZo6dMcYDDw1B6BkLkR3CUAQAoJUEsP3tnJrT33WhXYwJTcAVQ7gO7ikwMJgR/2/uzKRjRwCOsvvKdgCOMCwStYOQoMTXAGlzwtg2UVqi6+Nxm07IpwvGvc1boj3imfOJba2bYlx6zKAaiV9NwLsxB8AObaGPl6S353X3lXX+EzmTw77JB/2i9PbaLmXHXR5XCrAmNV9H56c2w69eIsABWbBcxmEVhDqMjJXkuq0F7gakVEfzW3lewfjTKbsWdOUP0Sk95SY/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2NUu7Ec+f0nBIzRA1q/wajc8Yys5aGZchTaFQVB38U=;
 b=RzQ+hXfJqV1z8qSCR2kygrZCQL7VtjDPpd52Ny2KseHpD8vBomEFtGUMiRaI81lfodwiYQFV05YXmOQT3LmyM8JJACT6oHIEarMiWrpVf8xWrkIFXRemTIx7xCZE5rxo/fsmMfJNKEHGSQdrLa9bcCHX7XxEOiMzslV6bPFbYfKgZLOmvImEnpvU95pAfGrCr5LHcdrlJC0HrSteP0VRpFd9m0hFRYrTSJdz3brhjSa/oCMuyEtEDN2r7p2t+4d3r7dUeixWkCWfuFVvuCYZEwqThrtJCH3pIWEsWNIxRU/L+dXzrOR216dNnxHiLAdTo8cs73CZ3UM0jzj8XMY8Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY8PR11MB7748.namprd11.prod.outlook.com (2603:10b6:930:87::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:38:18 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 05:38:18 +0000
Date:   Fri, 21 Apr 2023 13:38:09 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [kvm-unit-tests v3 4/4] x86: Add test case for INVVPID with LAM
Message-ID: <ZEIhQRMtWoZod345@chao-email>
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
 <20230412075134.21240-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230412075134.21240-5-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR01CA0161.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::17) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY8PR11MB7748:EE_
X-MS-Office365-Filtering-Correlation-Id: f4684f98-1e75-42d0-ec77-08db422a9be9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99Pjt80yeX7alhkzQb9RR6uzem1/KSL8OkL3iG6VrjplT9o2p9g4YaX4NYKEDEux8tt5x3nxSukyN6c+HEOpfxI2hPmv2/inst/GStzPuLqUWtEo5t5Ekhq9jm1+Ppvp8+dpqwjUees8U7A+0DRhwVuAXb2YY0uuBYJANzPgwqXtb8q8DYK/Qfzt7+PqfkyDE3zpcCRHJBlgkublR9mCdO/dIcAiin/c7SQwLa9lsP+nNYyYrBNWHLd3BHoecrEcu9Lh8IgTeQQwmWxufJtD2uCWx8i5csGSERMUOToVtyquUR3tqhDIKdTOD6uArjE30u27uFEQYKMwX/Hs4DjzZpnm61eyNhnOBL/KWeyoVQYJInpjEq92w9R33qGJpmTvRNsA+N93RLk0J58osgXVzsA7llmzo3SEdDsq1kt02YRMxJbTY6xICTi8eCtaIP34gmdBRCDhppr6anGXqlLu8JddErIJOTc27IaW81p+GIvrdK1WEqCCCeIA9SYQXG3I2xNbYzD1mEsqopoFpq4ALn6KSkQA7GtDym95TPjedtG8BmYo/zfFPUmPj7DJhMlU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(8936002)(2906002)(38100700002)(8676002)(44832011)(5660300002)(33716001)(86362001)(9686003)(6506007)(6486002)(6666004)(26005)(6512007)(478600001)(83380400001)(4326008)(186003)(316002)(82960400001)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F7x9WxKAPd1PYGVwrnNgxgNRGKUdWfRsYmq3u+Fgy6yEe0bgXTuH/q8QH2Sc?=
 =?us-ascii?Q?iAGUi5smBHIMCb//ye+xMzySd4fRk4msHfmMiftvBwydswgvEwTVXU3kylbO?=
 =?us-ascii?Q?GO8sqwrRCE4OrKF4jorFzmTaWQyJLb0QG+c6Z33kIp5RxRB8hWm4sHjmCEQw?=
 =?us-ascii?Q?7w7YZsxR4vtkhWSvKnDjs9J+nNJnDzGq4bbwWkPYUdZT/ZZHkBQ2/RMbQH0w?=
 =?us-ascii?Q?oIlgDarZJ8CJm+KXFAZUg2jgTH9RDAMq0TKIshvK0qUoyqxXXQutuPtMbwXy?=
 =?us-ascii?Q?krfdXAKolSNianHB1kz+rrUwgO+bJ6fpFm6sxY5AYkatReqJ63Cww+XNHyBR?=
 =?us-ascii?Q?VTIejdpvVLn65iyKHkuVz/swIKuk7IwQtkspG4PW8vPzZ1d22HEvWJJoPcxt?=
 =?us-ascii?Q?aSm22jgz0s+1cb080hG6Waxasf3k9BWL6bl0Hli5AmpdRixdsWoxhPnKFTps?=
 =?us-ascii?Q?jGLhSQvCfWV6LEjRGB/k0P5x7DovAhSL8wkpL5kDoQOYLKTE0VLQzb7N8UDf?=
 =?us-ascii?Q?RreZH0IlmbcYyGr6yt4RGv2VQzMU/ZGd7OFfWayvgKheQ4edJbqHCwv1xmCt?=
 =?us-ascii?Q?bYnVllpCmndJDRb9qdvteCXSi+ta91LkNVpvuj8/VlBgXLk2hNTd/OWquHSa?=
 =?us-ascii?Q?RPxPiKABCHMIHBB/3AkcRbWsSw6XJ/g6Lnf6Kkdv21pjAHtmH7k9mKUKFfPg?=
 =?us-ascii?Q?N0BuFJ9joqMNfCS1uIASWjdClhdfTcRR41FnOtNNclVcsV1HfUKv3FuBIa23?=
 =?us-ascii?Q?kqnaQTt62KUgUzjsrswutEWjDb69zRyN/Ht1FbYO1z87VxSrfID3ozicvFCy?=
 =?us-ascii?Q?d7COraouxx1w9Hx+YAL8m8mIeto19STkbL+B0lLGytGwT+KY8saqFZLAoNAf?=
 =?us-ascii?Q?Mbj/fpjG747ioNYQP/bwq4ilDrxVpU9lDJxu0YlMJZ56gvHZmuUYGNauI7th?=
 =?us-ascii?Q?Hnr/xIcwiyeyB6AWMW7aQUKc0Sq3NoA+a3wyHqg2B825hPlHYTYcxK8BN3RH?=
 =?us-ascii?Q?YOSModNbTyzny1V6hU+J4hOje5bC0FBhqeQq5pRJjYwJD1KFXWRpSBnpv5on?=
 =?us-ascii?Q?3UfyTcM47bJ+FWjFH/CHtvE6YlqoZ+DSf+KLQL1uOgmwimz88fCTEZFrGqWG?=
 =?us-ascii?Q?zZfk3esu2yI8Bf13ukxB1PSRLsbB6VH0ebluwbmVAvXv94QmMmLoLav1Yldr?=
 =?us-ascii?Q?QjPGKU/d6RrVfJ2+NmRoezIfVPcerQmy5btr4MwQUdNGT6AyChm526lvWkBy?=
 =?us-ascii?Q?m3Fi2MyuAf9tPp2WY35Dd10OPZsVAjKc6K0cDPcx0IwItrNaS7wEKI/fO0H5?=
 =?us-ascii?Q?6gY4o5gVHA7WcKqZx2LbedoYQnqXX7nYVwYO8+SCds9OxORKwM3Q19VJoDwR?=
 =?us-ascii?Q?43ZFukkCj/7lT7B2ejAT+yyMY+hW/U/P6B3Xw0whhbZ+aWxJoWWCx0xXWTMV?=
 =?us-ascii?Q?KwyU4b4cH83fl9wwGCTRUKRhvJVOGyUbDWpoJWCiIAI+/hAobeXGoNbY+CVf?=
 =?us-ascii?Q?CFQTyjiCoGljzCTYlt1BbtIw/UH/YUgN/rgGQcDXhl5tuSxov1QhpAnHsQG5?=
 =?us-ascii?Q?qpF6EsYdPbiElXC3Z2+hHUUa+4XRNY4HqNSAyoRw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4684f98-1e75-42d0-ec77-08db422a9be9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 05:38:17.6606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7xtBkQRIhxBLL4Ls1azeEc++gLdGuF17h+X39rjrChJiRVmYjKPv2TwPvm1jPoLR9dSr1KOtWSPIXlTrHfavQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7748
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 03:51:34PM +0800, Binbin Wu wrote:
>When LAM is on, the linear address of INVVPID operand can contain
>metadata, and the linear address in the INVVPID descriptor can
>contain metadata.
>
>The added cases use tagged descriptor address or/and tagged target
>invalidation address to make sure the behaviors are expected when
>LAM is on.
>Also, INVVPID cases can be used as the common test cases for VMX
>instruction VMExits.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

with a few cosmetic comments below:

>---
> x86/vmx_tests.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 60 insertions(+)
>
>diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>index 5ee1264..381ca1c 100644
>--- a/x86/vmx_tests.c
>+++ b/x86/vmx_tests.c
>@@ -3225,6 +3225,65 @@ static void invvpid_test_not_in_vmx_operation(void)
> 	TEST_ASSERT(!vmx_on());
> }
> 
>+#define LAM57_MASK	GENMASK_ULL(62, 57)
>+#define LAM48_MASK	GENMASK_ULL(62, 48)
>+
>+static inline u64 set_metadata(u64 src, u64 metadata_mask)
>+{
>+	return (src & ~metadata_mask) | (NONCANONICAL & metadata_mask);
>+}

Can you move the duplicate defintions and functions to a header file?

>+
>+/* LAM applies to the target address inside the descriptor of invvpid */
>+static void invvpid_test_lam(void)
>+{
>+	void *vaddr;
>+	struct invvpid_operand *operand;
>+	u64 lam_mask = LAM48_MASK;
>+	bool fault;
>+
>+	if (!this_cpu_has(X86_FEATURE_LAM)) {
>+		report_skip("LAM is not supported, skip INVVPID with LAM");
>+		return;
>+	}

...

>+
>+	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
>+		lam_mask = LAM57_MASK;
>+
>+	vaddr = alloc_vpage();
>+	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
>+	/*
>+	 * Since the stack memory address in KUT doesn't follow kernel address
>+	 * space partition rule, reuse the memory address for descriptor and
>+	 * the target address in the descriptor of invvpid.
>+	 */
>+	operand = (struct invvpid_operand *)vaddr;
>+	operand->vpid = 0xffff;
>+	operand->gla = (u64)vaddr;
>+
>+	write_cr4_safe(read_cr4() | X86_CR4_LAM_SUP);
>+	if (!(read_cr4() & X86_CR4_LAM_SUP)) {
>+		report_skip("Failed to enable LAM_SUP");
>+		return;
>+	}

It might be better to enable LAM_SUP right after above check for the LAM CPUID
bit. And no need to verify the result because there is a dedicated test case
already in patch 2.

>+
>+	operand = (struct invvpid_operand *)vaddr;
>+	operand->gla = set_metadata(operand->gla, lam_mask);
>+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>+	report(!fault, "INVVPID (LAM on): untagged pointer + tagged addr");
>+
>+	operand = (struct invvpid_operand *)set_metadata((u64)operand, lam_mask);
>+	operand->gla = (u64)vaddr;
>+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>+	report(!fault, "INVVPID (LAM on): tagged pointer + untagged addr");
>+
>+	operand = (struct invvpid_operand *)set_metadata((u64)operand, lam_mask);
>+	operand->gla = set_metadata(operand->gla, lam_mask);
>+	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>+	report(!fault, "INVVPID (LAM on): tagged pointer + tagged addr");
>+
>+	write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
>+}
>+
> /*
>  * This does not test real-address mode, virtual-8086 mode, protected mode,
>  * or CPL > 0.
>@@ -3282,6 +3341,7 @@ static void invvpid_test(void)
> 	invvpid_test_pf();
> 	invvpid_test_compatibility_mode();
> 	invvpid_test_not_in_vmx_operation();
>+	invvpid_test_lam();

operand->gla is checked only in INVVPID_ADDR mode. So, the lam test should be
moved under "if (types & (1u << INVVPID_ADDR))" a few lines above.

> }
> 
> /*
>-- 
>2.25.1
>
