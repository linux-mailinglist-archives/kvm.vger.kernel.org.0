Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1306D724072
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 13:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjFFLE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 07:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbjFFLDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 07:03:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96D010EB;
        Tue,  6 Jun 2023 04:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686049422; x=1717585422;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/BfsUdul1kj7psCEDZKzIJ+x7xEjhWmKzDzDjym9K84=;
  b=ZCdbXGnZt6+5SOpyfm6e/RGFDcrV4WgaGCAaTKMqohp9GOxvVLAA5J6l
   gPMLnBTNix7KCVW75jp+R+VzQKwVLJpRIuCBv6Wjo3chR2j3IuE3SxZKX
   3hwXv8Q40bH5+IyOBI9ifuhB757q3KUtLjG6alZ87/LGciLIx6knqHiwe
   /wAiGCWAGdIB7dmI7qozM1tnpqHXvO3A4dUNOfYp6kuWhDKjg4RkVZ4zm
   /n7hjNGtdK+sA7edT4/aXZrSULrgWgbt/rwqW2/NXrZJx4JdG2NBApMiN
   rBZrm8R9JPK9kESm5VTBaLcZCy7aa5nqludmbPTmh0tJoUjKCT9bkpWc9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359090210"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="359090210"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 04:03:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="742103339"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="742103339"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2023 04:03:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 04:03:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 04:03:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 04:03:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCd5+orxW6bic5ATh3t1VGIEIjPhwjVgyk+7qWuHaM1mpfSBHeSWIBJJnwdF0tDM8uVN1MXaVSY3VqYL15iEPg7ZyBQc+G434fzJ55sEt1/qX5gyGy+8wShWrVWP80cis8wossYcPIZ3zTIPZM+6kw4v+vlwD2A9BLF8PPr3qHu/TCNMPRm59J6fGTg5dnKiJ6vqm4EKf0XgarNDWiKYAv5aVUyedF8u2f0yaya/fFQYG+v6UCCZehaOlAggbIjIrHd9VqY+h51SrfKYHE02jTxSYDZ8NZihBYTFrPFUzdR2JNyHvJJASlU53Zh/kCSZkZd+FgzWdS3BT+3V1CWRtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIPNVcfomOBtBKcM8pHTH15BPheBdPyOhC1ZbBirngk=;
 b=BO1gEthZBIpJah3sJXqAyzK0FzOZwfVQ88uGgndLsvKFl/ZOXYNWXNVMsBLFfchSRWZnA7IqemOAvGNYbvOSF9A3rGlg9Ja5GKjvc9JiWeTA2nbqNEOQk1g2jS9+j3zLZeLCiuAZieG+ZW5a6MYLXtCsPDOnVjejERO50+dl23ecRNiXuB8dRgAGKtt4ta7zYfI42ChyI7IGOhHENv/af6pAlMdc2xZ5etK6+I1hWBMtw7JJ3TKQQAorP+5qu2rR/N7wV9Gkrh1n7E3qjq9LoI1vWQB0FFJIdoo45FjCCIw7/pGGoRCH/LVasNeIhLPbrh76PUDn7nSvT+Vrvyzj2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA2PR11MB4905.namprd11.prod.outlook.com (2603:10b6:806:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 11:03:38 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 11:03:38 +0000
Date:   Tue, 6 Jun 2023 19:03:26 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v3 12/21] KVM:x86: Add fault checks for guest CR4.CET
 setting
Message-ID: <ZH8Sfv+qh/WR7c8s@chao-email>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-13-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230511040857.6094-13-weijiang.yang@intel.com>
X-ClientProxiedBy: SI1PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::8) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA2PR11MB4905:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b7d8e6d-6d48-4170-455b-08db667dae1b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVyJSsqnvBbj4KarjPQBY+UgNKkneIBLuL+KYvBK9WQdzy56wqa04OvYNkmZ9GT2yg8+/8XquoCFjxkmuEY3Wr3w8mHJGy8kZIVEKQvv/Nu3kvfx+X4fBzyJtdB65A8pua60dmPoGFFW2a3n9MgmaExkTsoIsg0w9Y+TwC+Q7z9qZ80VCfd5uIOzaBCzDsNXsHnV2VAQ3dxtMZESUEOW/bZkRdoaOURYM0rpCy8Y6F399z0WqryMWOqVVzerEGcpPtRj3GFeL98XHcyeUm4qBAoWrmB3ppM8iVsHe1fNZAumfSYPjEsdU4e5QQC24YP8YfJIaTeZAcbiZiHiyZaoJ2R8UoMSb0hPgOOyRZg99fSSvdd4rN8vOz6ZU9o8rkIpIwgK0K/tSFTIfGX8EsC8qL7VfbT+HVp4odSp7Bqejrfqsxj+WbT9RllkblRyKrVZyF36ImKQh1asndI9wYI5/Qr1WJGRSVZnH4ZLITAMfuix792tXv42g530oZ4u8hIe1fr5uUxtTMmyUX+CkUwckIVwqY2mQ8D26omogj2U9ETnRH/qGYILjLK1XgIqUHUs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(6666004)(6486002)(86362001)(38100700002)(82960400001)(6506007)(6512007)(9686003)(26005)(186003)(33716001)(8936002)(5660300002)(41300700001)(8676002)(6862004)(316002)(2906002)(44832011)(478600001)(66946007)(4326008)(66476007)(6636002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tatynjuC4+jUSOXuUKx1CxaHTiwmRw2lcmndwol6B4YlxpsrxJ2Lt8G+Kuqu?=
 =?us-ascii?Q?GAbcxtroI2ngCN/NQj3f6qydwNCVj2/8DWJ0DuNiSagRjlAkMgB7ubuZ3rkW?=
 =?us-ascii?Q?1kPlEIBRVgUsUPh1ccnsjwMRmOjbvMeUSoJHWPa1NoXe/uxfVKIgkEIWo0Pq?=
 =?us-ascii?Q?0/aeDmbLaF6JDUkVey6gjie95zoYmuoCJWWNrLW5T5w4vfwqq0ukbIkqoZl3?=
 =?us-ascii?Q?a49ByepVyXGqkt7TOVVKHzrgP/IVB3p5EkARyz/iFikoIWkEgwrn6t5XYYN/?=
 =?us-ascii?Q?vllXqicAj5tLMWcr1RVeyxFJi9gJ/A/UsZk/JKJK3r1QnJqiHMVYAH9UD6nx?=
 =?us-ascii?Q?RC/l70BfLhmnQfov1a4kDeUWuPB4sDBzCxZZoelA5U2yD/rWnGzhxTPX1gYO?=
 =?us-ascii?Q?up6m9jbtXgJbq5ys+wNohFC2enYSFXwPKZNhunCUj1bOQK6Rclio7Pnu8EQe?=
 =?us-ascii?Q?qhh7rGPwpFD4pLt4QJq4EVawKDgb3dxzwcp3jvuA6U7/5+VA73rGNK4Q49df?=
 =?us-ascii?Q?A/DhqORv2Przj8JapIUce+OrlU5zurZIuRr4USxl3/GwJaXaK+3ZPp8lhl5b?=
 =?us-ascii?Q?1cjjMlTQfqu4KE8Xh9wWD6CXQsJ0MdmGw1XNA17bCFecPZ4dZZkCFIAN3oLT?=
 =?us-ascii?Q?ZJ1IpSBZsW5IsDoz3rAHHhHVFfaCLpz0/fnJx5aQzzkXov8nNFG4tVXTVgUQ?=
 =?us-ascii?Q?xWz/j497LjmGOi82vXa5fXJhp/ONOM3+ECr781q0fItpdcXWWCYzJwx2k68W?=
 =?us-ascii?Q?F2iFxo2EW5N7D8GrLnNiyoXrjQo8O85uk4fSTLgbGugaf8S5mpVjl9TmY/o9?=
 =?us-ascii?Q?ZfoFTTPR+LeX+BGUWeweFhW58OyFAZXwGtJjCWY0AYlMFniDoS5nYHYlwXLm?=
 =?us-ascii?Q?hql1JIACxcbmx5jrPW8Delx+9HJR7fqlzQ4VNbjbitgA/3NBd/GnfHohwBqp?=
 =?us-ascii?Q?twpYyB+bvDWSPOdJdNKkAR79vCeAN1Ae2aPZ+5lkHvQ9UyaIITaAVa88Ax5u?=
 =?us-ascii?Q?TOhmA00Uapv/KV2iuv9zOm+s2ym3WMv/2cBLdnmV2kzDadtmCl/wOxn5D82S?=
 =?us-ascii?Q?1ZhDXP3sYwm5Qh+P5i232Lq+VEUXeivuccOGg75MufDWbjkpdMJUuUDGjSlb?=
 =?us-ascii?Q?bW9SOWxYwhBEmsrqUbLvgGLmcguA7wvx5m2jgeBLbfmy3TODnBLKPvmhADgp?=
 =?us-ascii?Q?xH9V4IJENOHGv+sccLg0v0M0i4aGW64+oYh51BrvCe2XRID8TTIqcm5zzyzF?=
 =?us-ascii?Q?tSpeFMp64kLO82CuM1ppazga3sCZhbBujgHQpufHLbEVl7UfoamVlYQyWxNK?=
 =?us-ascii?Q?cB8QYB0AFCMX2fB+vSbydnV7VuUL7Bt+ABHV0hmyihgiytE2cU9HMbfZF4W6?=
 =?us-ascii?Q?z1ZUk3sKyaY7nuVolJHF+LGvvoYxMTiNNHa0zdSH2dHCZhXvrQbewuPFD3Nx?=
 =?us-ascii?Q?+F9C5L9bsGkZJNO0kUz8jdMF2QAon5CTzapONu4+KnvbAea7egLKqbtLIN1/?=
 =?us-ascii?Q?IRzJD6tUYlqCzybMy2gsrURF3kAJrhplzYyLMwsVesDuRVUEckxOsHJeTsOc?=
 =?us-ascii?Q?+CEOIyH0aFx5Nz4XsZs0tT/HA32KsvdEfN4uMV9V?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7d8e6d-6d48-4170-455b-08db667dae1b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 11:03:38.2656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdBHbiwINBYBpoxE9ugl/oLGNUcoCezvvA4l41v6O+qvTX8OJdoPgQnvtUuAy0gtBGcP+myR2Gfr8pXz0i+6xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4905
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 12:08:48AM -0400, Yang Weijiang wrote:
>Check potential faults for CR4.CET setting per Intel SDM.

>CR4.CET is the master control bit for CET features (SHSTK and IBT).
>In addition to basic support checks,

To me, this implies some checks against CR4.CET when enabling SHSTK or
IBT. but the checks are not added by this patch. Then, why bother to
mention this?

>CET can be enabled if and only
>if CR0.WP==1, i.e. setting CR4.CET=1 faults if CR0.WP==0 and setting
>CR0.WP=0 fails if CR4.CET==1.
>
>Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/x86.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index a768cbf3fbb7..b6eec9143129 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -995,6 +995,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
> 		return 1;
> 
>+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
>+		return 1;
>+
> 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
> 
> 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
>@@ -1210,6 +1213,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> 			return 1;
> 	}
> 
>+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
>+		return 1;
>+
> 	static_call(kvm_x86_set_cr4)(vcpu, cr4);
> 
> 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
>-- 
>2.27.0
>
