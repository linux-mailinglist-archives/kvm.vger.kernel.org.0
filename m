Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B01693C00
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBMCB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBMCB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:01:26 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A165183D6
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676253685; x=1707789685;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=i4fUPYR+Yqglq0zIL2PiM+tBPC+AEOVrtN4ee9svy44=;
  b=e+BtaQKJ7qpBiaLBVvNQPyb8PtsUrX3LWenE9Cmz17JMJPiUhAJXPNq2
   YCSJJrYbYEX3IFs3XYRe/5GMLWf3Ew75NNw1yUpXQ+hTITuKEkHqiGTBF
   b5DghgDSCp/17SCS4rZFjNmvalIAUjC8tYJVhttXKfocs04KcrzMsPcSZ
   gE1SBrFXjntGEMUccKgQUp6kx9aWFyMkTvQCFX4EUa657RUJnFeOq89eR
   nrPg2mA+AnUVeMqrYZqDkgzAAieoIiiuRP1o5FeaCX3y5pzgL+YY+gRt7
   Ez2XIUlAT0pM3xwcDOE7HpzAQ/xxx2ehwJ+FdxTSME5UYCqGlGQvrkLLr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="393188676"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="393188676"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2023 18:01:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="997531280"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="997531280"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 12 Feb 2023 18:01:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 12 Feb 2023 18:01:21 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 12 Feb 2023 18:01:21 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 12 Feb 2023 18:01:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFmih3wKk8L/uMUBijBpxudS45RID38f8P0Uf8cOY6hGjHK6luXMJmzjMGL4mHVONmjjCWobLp9r34iDbNe/GpDg2GMxze5E7WhZN26xh7ZmkX6ggjl+EYAIQRCE4m2xSNk6cZldEHCTt1SGrTSjQWbHFKvPL4SaHp3aNwYBQC8DzqCACKMmmfP9oK7c6Q4w0ate+2gvmj3VyGJXGIqC88FSuFLF4ow5IgC/pHURv73+qT3Xn0cU60XIluJ0CJcMK9yPGffVf2H55y/E1WA8/GrK9K8jiSbwd1zMw8XRZDUpMpHVAWUFkOpFH8n3YtsgMjWIjo5jen+/dQgpQgqthQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GSVjE5Wqou1E6iD64BffiWNc/fj3xLPQFfm+NcgoLdM=;
 b=BDL+Xn/M64tbW1EJa/ZNJXskqCkvnY52KvRd7TAyjhSvEhnWMf9RPL5ryc2zFtpn0CXSz0LZy4WLAennjnb8dPGwzDE75NzUIYuJCAIa76ORcuxDOQhE47hsmCncjjCd5NCAfcknmOlbYGkgy8cUUM0B/tFIezTBK+Q1MmKacdcr0aamZ6jcW2PmAbjXLPaypuwN+Pzbtb10LErIIquB319lKdC8EsdKPgPsqdlMnHwkrJ0SL+NhDNmbF1TKuxzc7jGt+5w21sRlM4VkJF4aub9ujyw9hIrXf9HSUH/Bi7kv+IvkFllvQNxPBdKpivPCEYU/oCON7PhKbFsmz9Z6sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH0PR11MB4872.namprd11.prod.outlook.com (2603:10b6:510:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 02:01:16 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.022; Mon, 13 Feb 2023
 02:01:16 +0000
Date:   Mon, 13 Feb 2023 10:01:34 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 6/9] KVM: x86: When KVM judges CR3 valid or not,
 consider LAM bits
Message-ID: <Y+mZ/ja1bt5L9jfl@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-7-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-7-robert.hu@linux.intel.com>
X-ClientProxiedBy: SGBP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::17)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH0PR11MB4872:EE_
X-MS-Office365-Filtering-Correlation-Id: 678e58af-7ccb-4ff2-db8f-08db0d663086
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LlR8FJWN3u3KJm+BQ20U7/P2X4P4dYo9tplQDYvROWZU3ALUheT2UERRq63AYki2eyVGPr2pMAwE54mvFbm05GBcQKpBCLy+JFGfg0MadKJgYEU2r+EuxCQaBKKxCg3CcsSzvePUEuUS3HnwYp3NrY/D95bq4sEsdHsqffRKZDKFdEawei1MLGc99M1ulpDA3hrrZUQhf5hkx5Z8S1GoP8SB9fkkZYRL3yF2ipXMGMVsyxpHWjGFNy401Ol7dPl/UxGgnObxHdA47L79ywG7QNS0Zlraal8HpCSvZMrxeJOe9+4tCcJLnUA87l5HqSzoF5pYOTJ2BHYg/Zx4IdrCWZGAbc4tvyMHw41Nf6W3AQW7X2qlPox3dooq6kmM7DJJyCkaahg+ippCGi7Xog5bPK0KkZEVFBttLMNi+k4K7JIGMNIQ/ll4U7U2Wxmzx3aLa7V+B8w/jN/N0gPWaWVJAyr7fhrb8i1ASZhe3XBvlIKswgug9ePrmL8udIm93QS0snIWFI2YX3Tf542uqHqgImGsM1S1wyQMHuUjr62NyF/g+aW8pnCoL3Oy1963q4W9xD0y4tOCgRH5aXTbDDcaCjQXOqgTtGquq435qOHgpRO+djWZnEXvXPo6pS5zN1nBX4VXDVKFhpVr25hdxQ7Orw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199018)(86362001)(316002)(4326008)(8676002)(66946007)(33716001)(6486002)(478600001)(6666004)(2906002)(44832011)(6916009)(41300700001)(66476007)(8936002)(5660300002)(82960400001)(66556008)(38100700002)(26005)(9686003)(6506007)(6512007)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RRiAAYIu83Zi1aV/HZADyoamGPvQF0TYx8bBh4twFzHreFKMxXPWmgpV5GrG?=
 =?us-ascii?Q?kFbpbwtydkYjk6TfkVBVx8UrUFcezZD0vZCbNPSS11RkKm5m5dY0JrULWTTk?=
 =?us-ascii?Q?zURKTGJb9dsTTRYgEVC/zcrTXzx+iKgjwXKKbcJ0rBpgxBaOSTPf5z1gkMfG?=
 =?us-ascii?Q?LnxWSLjVsMknpDRI+y3sjEvEYgPWUW7lw1gaVaVuDgdZmCX3b7ET6PaHWvOA?=
 =?us-ascii?Q?CMGl63PlkWZTJC40ZSz9nL+tprPyWsjbj2E90fNNq/kuM5E6LalRh3e4xILs?=
 =?us-ascii?Q?YerCOrS84PfDylDzc4Jgndz/g+qrTUTIY6Bf1JmNs+QOAccd1R4lvts3kbxL?=
 =?us-ascii?Q?i+rTGd9yESCfn8igpfUf8BCuwU9Ev0310kF0h72G/xbn05QWeDvcxgaWu2l3?=
 =?us-ascii?Q?2ikGLsxok9BoOLnWaRCtObI5nQTtgOd7z30Up1sCxVJcJgoZkdqj5RX2ed1d?=
 =?us-ascii?Q?ZOAy0wvmNtlLOr27WT7DTpSAup/GNC0VoKQMA8KPCw4CneAzlsjOmbV/+7cE?=
 =?us-ascii?Q?cDkiz0FblYmwX2ryqhQ5YGGF3X7/VPhH49dRk6PGQwDLCcX5rnaJHkrG6IgD?=
 =?us-ascii?Q?kpw5w4UwSChNQOIiVdxzT43pRprUJg4EVXhlkVhLaf/ZLhKv8uzQ9+oK1qaO?=
 =?us-ascii?Q?gTpGBGYCZfUlGBNx0RgBlqV9N+E7zjlmbfYqrI1E9IkXvDGu7QI1hVn8dMls?=
 =?us-ascii?Q?mOJgiFi8y9NkFsDXEvir68zhtkZAMIJw213F3CPByzwGAOa03FvccOGiroym?=
 =?us-ascii?Q?GbzOaXL/TGju61XGnxMHZL42SZo/7HBiMJVb9/12KEfBIQSTKq5ioOhV2ToH?=
 =?us-ascii?Q?GsqC7Wi/YImPD1tcwPji3eoPhHQgA6reMX6VLOAYPl3gDMcxmvoCF8vaVU9p?=
 =?us-ascii?Q?TUfuSJa/4f48u94fH6nI1CoQrmr3kNKqMf4HQIZkGqOFQ0XS7pqGSYCywjCJ?=
 =?us-ascii?Q?vpmSV67CTXRNa5xsLNtDsL9G8iR5dga3BvCDFREqOMKQ/85+vCvC5MT0xmp8?=
 =?us-ascii?Q?0QVldy0d5IDR6HeGbLEzE/5bh3hII06JQOpz6MgNDCfaEoCIbjHUzyEMwcaZ?=
 =?us-ascii?Q?9UURoCiUZHqL2Y6FC9HyP9IaWk71f7zHgXrRhED8eiGvncSiX+uhUdPF9bkv?=
 =?us-ascii?Q?+SoSy33jHWip/IQ8Ya7+4tC5UtFmtjXKGFxzK6wJwCFIOsKMwphDn6nRH5Kv?=
 =?us-ascii?Q?fblViQt6XcttgZ8l4FlPG9ZWq6Imo6r9Uo3M/fC90r6OLYrknqUVpmL3NnFj?=
 =?us-ascii?Q?+swge06n69p5R4n6LJTe1W6Fjc9uDzeYsXdjngIHJz2/3M2M146AHWTSqtn4?=
 =?us-ascii?Q?djDwG/zp/8BCEPMkuI5b2mLWydhYJLytbzmgmL8NSSM+AttIov/bSvm2C4Wc?=
 =?us-ascii?Q?4LZl3RT9k5FvasL88+wgXJcOrcGQFLeQjCII+IlXa0TpqbROPD3s9b1UZtLX?=
 =?us-ascii?Q?UskfCJcATUzLqBLH0u4BzWwqpEBglBrYXha5UKFh1rdCe9FgEtHOt5q97Xgt?=
 =?us-ascii?Q?Z/zRdsDHu9MsfIDEDBXPG3P7GeTxb0kPD16dRtVM3N66PUOU3jtOGGmg7Dun?=
 =?us-ascii?Q?pXdW4rMO8npic91FKUJvrwkgKXjQOEkb+p3DF3Fd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 678e58af-7ccb-4ff2-db8f-08db0d663086
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 02:01:15.6744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VODkxG1m5VljI3g/blvRk4HoBHq1CL4ZWBLGDD9RGMU4sTxjQ+zgCXLLxL2e3mrmo7s8BxpRSqQgXIHQU9H94w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 10:40:19AM +0800, Robert Hoo wrote:
>Before apply to kvm_vcpu_is_illegal_gpa(), clear LAM bits if it's valid.

I prefer to squash this patch into patch 2 because it is also related to
CR3 LAM bits handling.

>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
>---
> arch/x86/kvm/x86.c | 10 +++++++++-
> 1 file changed, 9 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 1bdc8c0c80c0..3218f465ae71 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1231,6 +1231,14 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
> 	kvm_mmu_free_roots(vcpu->kvm, mmu, roots_to_free);
> }
> 
>+static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)

Since this function takes a "vcpu" argument, probably
kvm_vcpu_is_valid_cr3() is slightly better.

>+{
>+	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))

check if the vcpu is in the 64 bit long mode?

>+		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
>+
>+	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
>+}
>+
> int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> {
> 	bool skip_tlb_flush = false;
>@@ -1254,7 +1262,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
> 	 * the current vCPU mode is accurate.
> 	 */
>-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
>+	if (!kvm_is_valid_cr3(vcpu, cr3))

There are other call sites of kvm_vcpu_is_illegal_gpa() to validate cr3.
Do you need to modify them?

> 		return 1;
> 
> 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>-- 
>2.31.1
>
