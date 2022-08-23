Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C952759D2A1
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 09:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241307AbiHWHuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 03:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241284AbiHWHuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 03:50:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7F365540;
        Tue, 23 Aug 2022 00:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661241042; x=1692777042;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+N2EYIj5Y/kAfNRjxZ9A6hyRC0mYBBeB8H9Ch63v6B0=;
  b=ZL0EPOtpjn+LGc109FFJW8xM0TrvMQo3YipCAKJE/cuPvOPTDVueU/kj
   0UnT/1D8ilBlCXlDl2EaKDY+BC27bbgV7xqLBK+SIK7UUqX9/D9evmuT9
   nm4EJ3nt8zMh148dVP+ZG7bmQ9l8/R5mQfTxqIZh0hs9ZbcOVSHpLB/dl
   2zAknY6Q4m3FXwMkbRDxYgXhLvj6hvewmsnNVL7sOfAr34Dsl3U7GxWTh
   M6Yqxu7mprDYNwZPSnZMrfVupYPdWvbPGJaiWIecyZ8o3xT3AalAyAerI
   M4J4CU4G502uydYhwhnFxW95Hy4tZ1N++pnbD/S5mhNsAp4J1NrcKxWeq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="379909972"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="379909972"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:50:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="560065993"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 23 Aug 2022 00:50:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 00:50:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 23 Aug 2022 00:50:17 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 23 Aug 2022 00:50:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnZxVY7v/1pOi3ykG4dzFMaIrCG6rj7ovQFeCjkqXGAbKrmxNYY6PXLp1phzIJ0ga+jphG+llzB2cjYU5oojxao4gTg9Gf3g8hORcLueDCVDZcJhZRTka61jmY3SNjJZee/ZBa9s2RMP/evvyiOfH+JVMLrNcvDxT9NtJsq5vWCSrsCSXWSeVDr93iHsgx37ZyPx9Yt3KCaRUc6niMHnVnKH6MXpCYEqdqpKPr0GiiX9GZo7gO+PsmMm86ThDMczZk+VOzZS1IDTR4DVixTfoPKyn6AR6fDBIfuB7gvoPtno+c/rgn9I+tB+VF58q3Q+81buRb/lKMpY+9KKOu71Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOFcFosSlPHdejH5jJXmzVxjaO1fGWlLXcpNWCU6X4U=;
 b=Kw74IVDkjNWEuAXIfU8mDivfs4eN0HC4RqUCOBee4GZvH3y7CxMQgfKYfttRLydoKC5ZAhmIXy7hya5hVrfEQ6G6ymKujNVZmIWctDhVk3ysFlY+75BPbwRjy7gm6x38H8z3a7AsSoccs9WpEuObwI/2hdYF8xNuKjbCq9gDM5l5x4poXjDXXwkKz0rJBpD4lOrhArOm4FKDu6T15ugFD5+WByTV6+YCjOx+GCaeCCXmEbNcQrHGBDae0su0BbCi8iCIzGeFE5oC8BNnSm03oTWnnr0cfuo4FEHzWwYmprfT/iGpC7gsHw25uWiEJyymhwSE77yvhuKEvNvothyj8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by DM4PR11MB6066.namprd11.prod.outlook.com
 (2603:10b6:8:62::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Tue, 23 Aug
 2022 07:50:15 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%6]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 07:50:15 +0000
Date:   Tue, 23 Aug 2022 15:50:09 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        "Will Deacon" <will@kernel.org>
Subject: Re: [RFC PATCH 12/18] KVM: Do processor compatibility check on cpu
 online and resume
Message-ID: <YwSGsbpuJ5cdNmDG@gao-cwp>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
 <60f9ec74499c673c474e9d909c2f3176bc6711c3.1660974106.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <60f9ec74499c673c474e9d909c2f3176bc6711c3.1660974106.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0098.apcprd02.prod.outlook.com
 (2603:1096:4:92::14) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c1f5945-c0a2-466b-78db-08da84dc1dd4
X-MS-TrafficTypeDiagnostic: DM4PR11MB6066:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uUPFlfpis/gFUjzYXD2NiEcNncCIK2omVYQPldntjr2cvjrqV15p8jek0QAqQzBUlCPLv7OdrhLo3h0M0XlxD59cCBE7Wy+qjUCwmZYC/X7J+LLww2QbTBrVRdP9eCW0m/fIgDz/OCKmh3zuY5HRdLU8CegqK5ccyRuJZtvY9e8KpXb9PAcNncOvoSEAgGvt/yEIB8mFLJxAliG8gh1Xh//3mhp8bXJUMHqc5uLlUGYLR58P3nmvD0OFhUPaOrd2zk6K5X0nI6hgr4LIFVT1MN751hiHECcNnXnzT7j6KKjSJjWRxycipXeWL2StLZaEqQ+rPbQ4kMjdKdxGlKLAfNngflLri30DR11uHdXhM8zpdSeW5FWE37J/q7tre0RRF2nPdotOiTAH0cP7XVaqmiykD0R+4TiI+whgL2OtCk46hhTuM6XNEzzVrYeXMl9dMGuHv+ZZbnQ+bzru+DJunY7gXYCh8o3cmtdu0SvFsYozZ5XkwOEytvZd2awl6u0AexGpijHZD1kfD40CvVF7Pir0gbB2a1IzhH0+QgjKHrBG0ex8kIV3jZPSxa7y+XpcfISe8onGHUoeVrG/Q6PVtPr6FHfXNofjsn5MwIfCiCktgyiL0kutsLBU+i55hT6Z8zKfb6JwAvi1eYvyYasyEJQpsV6p46wYjnUdAxAE80TOppa0p6dyhjWBzejaJtw1XMMymAjYgcs95iUaFqrwEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(366004)(376002)(396003)(136003)(346002)(38100700002)(6636002)(316002)(86362001)(34206002)(8936002)(82960400001)(66946007)(66476007)(66556008)(5660300002)(8676002)(2906002)(4326008)(9686003)(6512007)(6506007)(33716001)(6486002)(44832011)(478600001)(54906003)(83380400001)(186003)(41300700001)(26005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LkqPJkguJ0hJ+aopFOv1tKxsusEgkmBoZj5i1v2AZuLg5YOcYJl6gcl1AV3x?=
 =?us-ascii?Q?LHcZ3XARJDYsnNYOVQNApdvcFcivQMcZA1db1pNwVI95EsoIKbbz5knnD8Nh?=
 =?us-ascii?Q?xRMv5l7zC6qdCCXVoubtSjRS/Omm0Xed2WILEZIk6CIAMPYHVkMaIHstJ0tK?=
 =?us-ascii?Q?4tPulVUIXxRBg1dYE7SK3W9+O6Ih4FItf0QWdrB1proOKyUmTtbsyg6DneJq?=
 =?us-ascii?Q?uw2IKnF/BKDSsIU7+UbD/3fHh05Xw9I1Yx79tRFIj0xwJpYzFIp6Cwlan+eU?=
 =?us-ascii?Q?dATKITaxEAYlq1Go+ItS/IyfUEafLV6Vh0CZ7wLlXhSJq+wLbD7BFs3jbt5n?=
 =?us-ascii?Q?y69GljZNAT4xAN6OaSK3xID+0DhaRFyLyTrVyt6vlo/9t6BJAVan9ORP5fPe?=
 =?us-ascii?Q?6dlI8cJnWj8biWD1VOC+wP2O3cKEjzxgxLARoBQZKfnmbVluUNw93msNO7PF?=
 =?us-ascii?Q?B4zxXdjBTXYLgdAurXJmBWrGv0X61Scd1zpCNtcx4nxbGi3B9pXc7Yw5odu7?=
 =?us-ascii?Q?nnAIT36gQ8nWd0L2FkMx5NRgsyTbDB7FPiZqP1RO28i03b1LicoxMaupTq17?=
 =?us-ascii?Q?TZNfytJl6utrFiDXI69sHc7MT+BjtvjlAu3sulwME1jnU4FYA3tA/ZBQbm4F?=
 =?us-ascii?Q?/WeFGnoBWslryxX3n5AMywqxwLP1ngCTXePOcujl5R6MlNMmXkfCs3HcbL79?=
 =?us-ascii?Q?hfNiLqycRgcEo2c9ns+3dC0HR4McfH4T6NbxhuJC2M69dyjhi8ojXyD0obqA?=
 =?us-ascii?Q?PX7Ruc1wcbBCqVlftVBqxIK4/x2ZUBSCdg/bdrOQhh3oe8j6vZJBsOMk6xML?=
 =?us-ascii?Q?o2FzAh+X1jziiM/p8Zx++ju5DZb/GLBNk5l8ShhZod34nm6j0SgmQBwKSz9O?=
 =?us-ascii?Q?oiAYXybZEWlpXilEAZ7xE6EBR51cmJWr3qghY9xpFrfw1LM96pyvM8Z0p2vt?=
 =?us-ascii?Q?L0XymTGsxKpbn6e58SWTB3pdEyedOkgceO5dKrqz7W071YqvM9/9ZOwBmfmN?=
 =?us-ascii?Q?JPjh9ePbjwUBYKDYU+I5ooiuCjsTdsmc8gs0pKCLhukeTZFIB+9CyFpvI/Z4?=
 =?us-ascii?Q?1i2gUJZe6HZNQJAkvXwL84gPPaPGg5ZodjATFSb3p1qPElITJIDz3sfoQ/cI?=
 =?us-ascii?Q?+lmtsn7tt0pRNAK4iMa72pYKSWPWPYOkDptUwztOe22kbxRnVhjO9tQ16RBf?=
 =?us-ascii?Q?XLXEJYgaqnegHw9ST1CfMoChIOh2pWA1vU8uJFwDNchdcR8IPwneFnFLn1XX?=
 =?us-ascii?Q?yDbjhJ8mwxxvtfd59tHofmSmW9YiaJWjqqJXVHDSyNDxwo3Fc0jRCxI2uCDh?=
 =?us-ascii?Q?QNslCApXMYZswMA0ap5VFFYoriLpOYhpLtSD5JlGAR+OK4mfyfvGRU9TXCOr?=
 =?us-ascii?Q?xtbu9FWVVyRnK2Z2eOQp0B6r5OnY8r2GdOaFpi/ZyLrgJV5j91EuZ8Z2koys?=
 =?us-ascii?Q?PjYkyaBgin8a3RZGVgJDQ0sOeMn2pas9/KUb/Pnysq+dPKQdvTX343Pv/7eB?=
 =?us-ascii?Q?/CVkv0vzcTeTqaHXuHua/uaQAinYn9SzK1r/X/hs9C14f/abwyDhwdgJSkhb?=
 =?us-ascii?Q?DOhm8IiOl8BuCi2NMrE3K+Gt412uJyheYS+HWHrR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1f5945-c0a2-466b-78db-08da84dc1dd4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 07:50:15.6200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tZTh6ItXi4hI1SM8FYU+VXQ8Fngjd9a88V1RYdEdkOSG109duZ5kU0OM/lHuhPwVwW5xRiNCB+okbG//TsyCGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6066
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022 at 11:00:18PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>So far the processor compatibility check is not done for newly added CPU.
>It should be done.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> virt/kvm/kvm_arch.c | 20 +++++++++++++++-----
> 1 file changed, 15 insertions(+), 5 deletions(-)
>
>diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
>index 2ed8de0591c9..20971f43df95 100644
>--- a/virt/kvm/kvm_arch.c
>+++ b/virt/kvm/kvm_arch.c
>@@ -99,9 +99,15 @@ __weak int kvm_arch_del_vm(int usage_count)
> 
> __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
> {
>-	if (usage_count)
>-		return __hardware_enable();
>-	return 0;
>+	int r;
>+
>+	if (!usage_count)
>+		return 0;
>+
>+	r = kvm_arch_check_processor_compat();
>+	if (r)
>+		return r;

I think kvm_arch_check_processor_compat() should be called even when
usage_count is 0. Otherwise, compatibility checks may be missing on some
CPUs if no VM is running when those CPUs becomes online.

>+	return __hardware_enable();
> }
> 
> __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
>@@ -126,6 +132,10 @@ __weak int kvm_arch_suspend(int usage_count)
> 
> __weak void kvm_arch_resume(int usage_count)
> {
>-	if (usage_count)
>-		(void)__hardware_enable();
>+	if (!usage_count)
>+		return;
>+
>+	if (kvm_arch_check_processor_compat())
>+		return; /* FIXME: disable KVM */

Ditto.

>+	(void)__hardware_enable();
> }
>-- 
>2.25.1
>
