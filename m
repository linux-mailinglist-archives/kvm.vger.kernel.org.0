Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BC65B2CB6
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 05:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiIIDH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 23:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiIIDHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 23:07:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9A11203C4;
        Thu,  8 Sep 2022 20:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662692751; x=1694228751;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TzKoHybW+hbX1cCR2TyqZDPa5xl3MugybeEqxvzAbMY=;
  b=I6nwR6PeyFwzTezGFj4/Gc/nC7EYO3TOTMuMfdvk6g0VTcBEK1zqL8Qr
   jfW058uT04h19x5h4kteRaz/3Bm8YunhRRTRqL/EXoEd/9fVdLMgHtSV5
   YJe1hZW33YCYGwTpX47JtpaC6PeryWGaHj23tTrA9E2apmEfKpBV9l7nj
   NWSQq4E5631j+PL9eDgSbtxMhkJgx6cwt3hy3PuLgAX8zb0/ism9mqPsQ
   S7AOlo4adLtDhb+v/pa8uKqDMcJkHbpmkvPRIsHs8XvpvUh6LPco/ybY/
   2Vha41eVTW/iudfyfhtnyGUUQXtOncDE2BrN2KNCvqYP+uGGS0vOP0zoM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="296118742"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="296118742"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 20:05:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="740909333"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 08 Sep 2022 20:05:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 20:05:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 20:05:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 20:05:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 20:05:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxgqviJ5JV3Fo6N40pBUXexMcPzGQIaTscLhFDSZpSVberiyMFS3OkmtDa5Q76oIst4tbRkZJ8myt0PDqEqpn3/WfJKnUymzYqFC/LesVvZPzXGEFR16I5dDOI907KomVJ2RYbQ/mafheIIvuz0IbcEwAEvNSqO2EeWKwSpZ/+XDscZYwsQRTo2L30Gtl8xSi/vYlv1pS50SbT+I1Tt+/GjD330P/JpwE8tF8NABuEW3efp5bytRMEy9NWYvJSMaFU1q7ry7MfXkqEIK/37E3ntC0XwjWYldpDBXRjCmYkr92Brl7Y6BeIA4cnLawVIgINTl8fIVMHrDnXxZM+CRVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQFlPU9kboG7aUAJ9RlSo9cNFxSu37rAtR8LsDMES7o=;
 b=QSlO1F61CYCiOq6HjtDvt4NLpug4xwc5BRVz4m+ZjvdKQlQFjGQGV8d46p2iM0rulaDWpKBPHFRUHSPWJuF9pHXIVRR70XAh8mc+rAa3SPA0PKwo5OwotjIfTfCzE/Dph31t5om57yWwb1Asp+EjoSZ4crul6H5QbiwBRd8aFAl0ZHV5NAPsaiw5YPRWkDMDPUoswFUlsTvO73dgD03PHcLkpJMWJi+j+gJ4E0I98tVbebFno7bh80bkzPB787KRXbf0o7JMcRBrw/m0wKPBDPTQTJ1d/SNEGfrHyeaXhzqYaCiWlxwwpq/oZQFBIeBgu0UWzyrxw2XltmAmXALFVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by IA1PR11MB6217.namprd11.prod.outlook.com
 (2603:10b6:208:3eb::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Fri, 9 Sep
 2022 03:05:40 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 03:05:39 +0000
Date:   Fri, 9 Sep 2022 11:05:34 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        <isaku.yamahata@gmail.com>, Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Huang Ying" <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 10/26] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <YxqtfmhBGQlkhTvU@gao-cwp>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <c95e36034d7ffd67b7afed3ba790de921426e737.1662679124.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c95e36034d7ffd67b7afed3ba790de921426e737.1662679124.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2P153CA0039.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::8)
 To MWHPR1101MB2221.namprd11.prod.outlook.com (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|IA1PR11MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a6a509-0abe-4b00-f77b-08da92102c80
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2JtHkyEJWispu6dJK0hrSQ4WE0OhF2f3LHJT60TSHgeWfwT54Upe/unsrURVs9PvTCvzoJTmVRh4SeppkAJAbxkVU65uJXhxQUvHiMl+0G5J+HkPoxESpp/CJ9J7tVtzEB9YQNTq1xK1KvSuvckkvQ2OzC31kIi/4b7Qce862sJR7AC2is1JNwIh6buPbpr731Ckk9bNVuigVRgFBWLS8RsLU6F9/Bb9wjgIZH98LVW6q5vm0SjEoRVnxNoCazcyZBIyo4/+A07aVUSI5BETFJgfk4XBzPoazcud08fBUj1/TkICWdNVb/OWUZK8+/vbLAW955N5iF62z5MOeuPmDphI/Smks2/z7ggEbmg/9HPPAS4h5hZuT3P1yHOlKw1auWf7tnSsWmk4qnFvzNDymzdHdC//qdLlqEngfDpGt097YuicHImoHkVPPYaYNlBvn/gIchRPUfG0FNX9zQJa+KVMnhgmeEHhSazS+IamfTucqWp0LJIX6JrPoFd7zNmTnp5ERnCLbDsn+vWgge7qvjlcRQs04JJ5NM9VZ3EtaAQkqU0v7FKElncM2HD8ZdLVglNJwZ2OIyAp7k2Ff+jepEPbNBeodYzrmKO2IS/MYqtL+BQ9HFeOvlACQ17GIDFijrMw8ATGrqGu9ukHQctvSebb6XvofXxL7JrLxJAu+mwZH1AukG7RzlhRns95rEqYnO1fPO9jYMK5ffEdIQz2oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(376002)(136003)(366004)(346002)(39860400002)(26005)(6636002)(83380400001)(7416002)(6512007)(6666004)(9686003)(54906003)(6506007)(478600001)(8936002)(86362001)(44832011)(34206002)(5660300002)(33716001)(2906002)(66476007)(8676002)(66946007)(4326008)(316002)(66556008)(186003)(41300700001)(82960400001)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FFM+/ssT3KBzo0J47pTYutX0zXovW0VrJZoyAugv/6uJYT1M6IJasbikAPJ8?=
 =?us-ascii?Q?8JxrMFjAjasQDyzYSVOE9XbURYUHm4XHBjhSCzkLk2uozy2TLRgRAa8hwV47?=
 =?us-ascii?Q?rjlxLx2E6cGs1G0WKZnPdwe/oWXcq0yvvUlRhrMCmt77wOGNPg2Ui/rfrNVb?=
 =?us-ascii?Q?Xaue1T0No7bHDsmHGhT3jTTBbfMpf+4nbNYC1k5fyO2JFgHuaeUQ1WXVf07E?=
 =?us-ascii?Q?ZufwWeBCJzDZqA9vDbGYTYs8WDW65trPod8TgqXoF39Ndc5XZ7PP97Xx5Nrx?=
 =?us-ascii?Q?8plQZHEe2SCgU8BqNOliX0cFmb7Gf/wpUjk95wdHlcrQlIFCswuOOw6WPaKV?=
 =?us-ascii?Q?KwaOzycIrI1vRbDJ8EbhanXwyGRVna6mmKO9g+BbqyCCV0USLhZHpTW3CDj5?=
 =?us-ascii?Q?LdXGjBHCbUAGbTbjzvt111qwPUswthAfqMydD+gk1lGJgLICup+p2cD0+lOz?=
 =?us-ascii?Q?opdftx38QNfj/I0mcX5EWDI/MbBZoHG18lS+yBK31cUuVN/+xsz+EwJ/3d/C?=
 =?us-ascii?Q?8k+6pxSbB6KRvUXXU57wL2y1aPyTdIs54Xxgeb/k3qUUymffTZAB+Zxk6RHl?=
 =?us-ascii?Q?eXhQS73YESP1aplhpObtjl38d7XqehNEIBn3CzEoGqLznvNF+hxPN/7uH3Fn?=
 =?us-ascii?Q?btEewnR4bUYOV9J1kuQVrUyuAbol7FFNDXpE7oFtzkCo4onMwOj4Ulc/gxp8?=
 =?us-ascii?Q?1pnBvfcYIM9EP0+hKhlIIJHDPQHOsLYowBWIfAi565S56j8RfknxhsOpqC4p?=
 =?us-ascii?Q?nUuzVANARnQA4F5WHVQUrv2NQH8df4umT0pcmVQu+cE60tnPTZ4ydHqVtu2f?=
 =?us-ascii?Q?EUWYh1ZlodYW/hDvoaY/PkNV/amj6VABNp5nc2leRLC+OJAZYO5Pnw6SAVbI?=
 =?us-ascii?Q?XAtuRh0BbgAOi3a7yFhYqa6+aF111TGyUde/WR9QMR8skXtJ13Ho1tiGVj0G?=
 =?us-ascii?Q?qoX90SnqFGkXaWOY5EBhxvALW8aKTKZU/Z7i8jklO+UZJpwLBRYpQPgWfR8K?=
 =?us-ascii?Q?N4QEs/LpWFVy8VdRoH0LVkxjZSEdDETFuyJisBRYrB81Ru2QMnUarIHIitO5?=
 =?us-ascii?Q?8qNCqhwRCMbFixZVQH3/3lSNEvDeMiAl6dZ+gU3DtriIqzAoBTpQ0no4ldVF?=
 =?us-ascii?Q?O//kidOiKLj9XMKo///SGhamTDbtuUqbXVzUyNLMhNH/hAtbRVPqiUJTx3XA?=
 =?us-ascii?Q?i6TFJWJjFKBDChifJlBoQaumVnSZlJK+ESb/tYQQog6LhFlKyXeltUuJet8r?=
 =?us-ascii?Q?3MYCcY62UkBZscubpPNqYB/TmvmpbODvQtANhohfgXFXDehhwNzrrAoMxJGD?=
 =?us-ascii?Q?HjwF3QdQjtpv+VcNLT0YqC2sz52m05aJqGlyZS6T+3o5ncSvn5NQM27mF+7N?=
 =?us-ascii?Q?JuWFYC8KQi3VcvQlLob4kGtaDqn/9AULZyGKTHGtmiTrztue09iHHza6L1p2?=
 =?us-ascii?Q?J6kPdvLp7sacW5GlMCi3pNxtZa1O7N0d6tqjI/YFTg389Qsf7jdB1ypPNPFZ?=
 =?us-ascii?Q?ZCqM/MA3Br+fFIkBD6FVksS9GWSlS/g77olsXSUBnMcBNbFpbOn/rs99LJPO?=
 =?us-ascii?Q?OTpHpUbM5gDyhSqYDGp9RStjhdsc7LM/IIkZ62Wq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a6a509-0abe-4b00-f77b-08da92102c80
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 03:05:39.1377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvVRRysDhMslkXnA0F1FmM620Gy3Y0IRsw4w7XhnmEjb9Pi1yoXzj3aXwCGSx5ff80hu78cacWT/1r7rA7b2Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6217
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

On Thu, Sep 08, 2022 at 04:25:26PM -0700, isaku.yamahata@intel.com wrote:
>-
>-``kvm_count_lock``
>-^^^^^^^^^^^^^^^^^^
>-
>-:Type:		raw_spinlock_t
>-:Arch:		any
>-:Protects:	- hardware virtualization enable/disable
>-:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
>-		migration.
>+                - kvm_usage_count
>+                - hardware virtualization enable/disable
>+:Comment:	Use cpus_read_lock() for hardware virtualization enable/disable
>+                because hardware enabling/disabling must be atomic /wrt
>+                migration.  The lock order is cpus lock => kvm_lock.

Probably "/wrt CPU hotplug" is better.

> 
>@@ -5708,8 +5728,18 @@ static void kvm_init_debug(void)
> 
> static int kvm_suspend(void)
> {
>-	if (kvm_usage_count)
>+	/*
>+	 * The caller ensures that CPU hotlug is disabled by

					^hotplug

>+	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
>+	 * locking.
>+	 */
>+	lockdep_assert_not_held(&kvm_lock);
>+
>+	if (kvm_usage_count) {
>+		preempt_disable();
> 		hardware_disable_nolock(NULL);
>+		preempt_enable();

kvm_suspend() is called with interrupt disabled. So, no need to disable
preemption.

/**
 * syscore_suspend - Execute all the registered system core suspend callbacks.
 *
 * This function is executed with one CPU on-line and disabled interrupts.
 */
int syscore_suspend(void)


>+	}
> 	return 0;
> }
> 
>@@ -5723,8 +5753,10 @@ static void kvm_resume(void)
> 		return; /* FIXME: disable KVM */
> 
> 	if (kvm_usage_count) {
>-		lockdep_assert_not_held(&kvm_count_lock);
>+		lockdep_assert_not_held(&kvm_lock);
>+		preempt_disable();
> 		hardware_enable_nolock((void *)__func__);
>+		preempt_enable();

ditto.
