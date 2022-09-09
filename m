Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517285B2F4D
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 08:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiIIGyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 02:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIIGyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 02:54:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DDB130878;
        Thu,  8 Sep 2022 23:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662706454; x=1694242454;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ntdSXbuwNzppL2dPta51O5KloWO51GN+zOglJ9/G4so=;
  b=V0sMe+4UFMpps+WsvV5Qr3wXmK7hAn6DCsBt11tEMouEnJR7WHEcD9/h
   C5aCuY6Q96jGDsaohZWYts1fT49FYbrPOtn76Odz54zqMp2wVWLcdWi7W
   +QMbyMmUt3p5MU5J1BOxhw7/AXjdEzkNkMOub2s2sfbaqBtozZjAU3nni
   hVl+YVxAGYxK5YQPyu1w3ENNjCp288cP+L6cGGCWACuP0YNZAUI3jKwj8
   I6d5GR75E4gz1kbWRcFKY7eBu4kXNxdFd3XfNLXxXoNMO0/eJMOyZvg55
   GDsKd5LFC9jSepU9bvSGWknd1iCI8NJ7Tk3gHxo9nqSgYkLgWEnSNs0cR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="277800809"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="277800809"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 23:54:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="860316109"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 08 Sep 2022 23:54:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 23:54:13 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 23:54:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 23:54:13 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 23:54:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWn+NZiquY0OEcqgIgPRPy4TCOhshgUQ8+Tj8qOvBl1k4j/9CqqgoQ7j7gQ9DMrtT4QLh1Ok7RVTxp0G69gHMyD8kIS0Tzt6U+uUMOgtKEAoxpRJN+jhQEIyoZ/7gX9NAU40cgtL9/ouBPYCwWZghABOApYk81qyromqdepxOrrrn7sXaEO/fzA6ORz2a/sTPRCNhtmmBbGMzlQfLUOJJzfvfdd0Ns1HH6ej5babSnUBiT4OqlvSvsq7IqGtIAdGEGQ/ckS0Gc9im13zQl65ValJ55oPBnzpJPblSN26NF7zU90l2o4uySv+XCA84qxD2SXbpNWOPsgq54YNqaUL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lCWymx+Z5D+nqwiU3GGOLeezpKuePx62vTunfgfpB0=;
 b=FzHingQG6zoxCWkLAqlchOJkCDT5Y/DgfkvHDUvudOIOovojCAa5YYJGnO6yDRrUK6lE0uIGp8c3pwhiRxGCpluhbiWGOFUtaP6ILjWgtfW5A18Y5SDaWi31VA9ZtYaS+preIu0UTIaTv7yxJmpzJmBI0z+F4PPjcpiFihpESE7ra6cTNdWdkzufBhdHz0PQbv5cXlxl36L72Fg8HDS6dSiERa5BqzUafRBmP7ETy/f/xZ7ehK/84YwVPeXp9UZyhg5ye2krD8iMVry41QzJLIFvw34F/PHML5bydfVl0HJF29gwS2Km0cRdv9B/nsfUKG5pia6gRHw/BBLmPHylpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by BL3PR11MB6362.namprd11.prod.outlook.com
 (2603:10b6:208:3b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 9 Sep
 2022 06:54:10 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5612.019; Fri, 9 Sep 2022
 06:54:10 +0000
Date:   Fri, 9 Sep 2022 14:54:05 +0800
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
Subject: Re: [PATCH v4 16/26] KVM: kvm_arch.c: Remove a global variable,
 hardware_enable_failed
Message-ID: <YxrjDdn5xCxrJYUT@gao-cwp>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <60ca73d7d931ec8046ac50b20f05723a97ef643b.1662679124.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <60ca73d7d931ec8046ac50b20f05723a97ef643b.1662679124.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:3:17::14) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|BL3PR11MB6362:EE_
X-MS-Office365-Filtering-Correlation-Id: 443a93c2-6b03-4943-13b0-08da92301931
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kG1b3cScdBhgA56TPu9bCYOKsZTuecHNhZ1QwWJ+y4h7fCq2VGVZ8Yq9WPoClSkLzQ0CHRFZH8rAIb5dYj0RSy6Uzt+Fq/fAeoU5xdkU1DmrjuuGnIGOa5pPzdIDE1+ZHCJ0f3YrLiNxgg9SdJr0YzGtU1OROnTfmwuma76I5QPySVzbIKSJTW8qHcTk/BtX7fYyoSNaVCxsa1Y7O2qVjO3+hiCtsaKMavDnbQLFndyhIcZCEHFDQiXid+YrWzHCZNvZwuKB67V1qa3goa/8HKVZGyIV5Xw6plhlybnTr4k9kd/md6DMP6R2xAcvo5X88+r936cXWESTxAKC5U3EtGemM5sD0aWm8APU08yzHIxXvpwDWr3fiob5Mj/PBu1WFGoatTu+XIVrrjZ+LpVXcw1kFycxl814Nea93gqjZxr7/QXtXM9tS9rzgMZOF3fatj34v1sUoNesqtyPv9A6pxO9Iq7ayCBuwrj2CatKsgV2a3KBR8CyD2MLGqnP07RTaZiaGAw08MB0JGtqbCuQc9ktQy7BXZKJ4TsciTBYOwgvhTyiV6F9AtUDkZHP7+QqfhM3sf8qmtK9M04j2HPSp3bFX3PYWsK3cImcRDL6GoNShY2EJ71SoQvpHpFyO0tCfE9vhxxfp7ZxyQrXmTJgSfEADu2I0NqNBw8ZIgBB7vmjHcS6oXCznC67ObEgMzdKTTrV95WGcjOsSA2eQJbxYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(39860400002)(346002)(136003)(396003)(376002)(9686003)(6512007)(41300700001)(33716001)(26005)(6666004)(6506007)(7416002)(34206002)(83380400001)(8676002)(5660300002)(66946007)(44832011)(66476007)(66556008)(8936002)(4326008)(186003)(6486002)(6636002)(54906003)(316002)(82960400001)(478600001)(86362001)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OEtpOXcOBKWpoqnNc4T5yLU4EOlGyyJIUVhfWGTuS1yMi+XViFdYDR++g2eG?=
 =?us-ascii?Q?cjDd27WXgpfFFP93bhD5J615Wt9tfZS/1LyAthzcj+cOrnFv3BA7q+WvEbKZ?=
 =?us-ascii?Q?oaRTKFfWuHID/C3UZRpYiYiFqZ6qcgcqobwRqd1G3EZAgkiFpuwUSChFzze7?=
 =?us-ascii?Q?VcsoaOA95QDwhhXApBCtBtt1JkCB/NgqjGqXnvDQkGsy25qaR+I0oydX41U/?=
 =?us-ascii?Q?9qcleGW+BdeyZDWbG1Jv2blV0Y1ITNmGQm/ZyAXUURLVeEFySD/3XYMCeA19?=
 =?us-ascii?Q?EqgLcEwm1rnebdrZUu5aeKVc4S24EnDFAq6kKtF/AGiDM3VF/bGjDi3EIEO7?=
 =?us-ascii?Q?T22cJWfniQFMkx6U24SeFCopa5aq/MTAW9RHAhoTcdJpU/r5rrvT38QwdBkU?=
 =?us-ascii?Q?piaiYisM0JKdcDC/3km0Klt3Shpf3QT83byvVAzdR42jjq8y1SOG+VvVMXXK?=
 =?us-ascii?Q?/UT83Aht665aT0wHrtAICq3VswnNkveGcy1JxeVNcaMdI3akcZZNOv0CFOmH?=
 =?us-ascii?Q?DXCdf/kd8k5OXzWiYQTZwxOEM2zg0UtJrDWDhV2sgczCprLUEKbbJCfN+NUL?=
 =?us-ascii?Q?nzRYzDWRy8GJM6cS84p2/4c2lUmZJcw03rmE6K984JpPj5bQuCxtOHZhspVe?=
 =?us-ascii?Q?48iPUm/JUZZYw4DQRcVfEKu1Da3LVtGzqVxir2NX8VtP19FqNUQM1g/t+EOf?=
 =?us-ascii?Q?CLuF3u3/ySPUsVJb8NdRE+lC1hzTKpSZ9wK/gN5avh7yR1i3L7KB2O1i3j8N?=
 =?us-ascii?Q?fyRu5cLaOWSffSX2qtefFR9FEe8iapm3piYeDAW7K7t+oDQykdDw1idRKd0w?=
 =?us-ascii?Q?a6kbRTnYAqf469pQZfQ3v/ry1yWho+mmuSQVxlEQqUjT7yYxZVbCDjhxMydX?=
 =?us-ascii?Q?GKiZQ03/l7Jlx0/2eKK+9mRdusffYUeUMuwWdQEvDFYkj0CZOWLfehh7pfq/?=
 =?us-ascii?Q?Ax9MopEXhLw7GsDTCQLC0O1Y02yMAAN6lJCfRwBQqGEd0GGQsA9FX38Yhti2?=
 =?us-ascii?Q?cTtbR/6XpKcZx1AKb62wIjU8JZP8MOYMsGiEGXNP+ZIQvUBq2XvyEaEK1iUd?=
 =?us-ascii?Q?5vIM52mrhZfh+r9hZ+CUyTwGb6Z0ilWHJTjTYxsamRQx4OYK9243GQai7KO/?=
 =?us-ascii?Q?EC/0+grY0UEj5/sgp7IlTaPpxiZOnavOOtnXdFtENdqGegtUSdHKeMi/PI4m?=
 =?us-ascii?Q?0XAcCe3gTWIbL4AmgDMPp027BPPPrQf3SdK6J8ZlteGrJ+Qwk9ax0ViEUMFs?=
 =?us-ascii?Q?tx6li/sekMJpzDvQODz/fZK8be6dwPBHoAwl/cRdFR0+IfdDun8GQTtjq8+5?=
 =?us-ascii?Q?+F3GyxPhCAxf8er+z4e2AuEVatvQDzprExfblhQR+Vfam99T7i/SkIaP1Qze?=
 =?us-ascii?Q?Ui8qTEjaavteuUvocgt4AER5hm+69p04KPIfKFnKKgJYw1Jc/97axhlJKpWI?=
 =?us-ascii?Q?uD2A6HZNFLS1mwTXeYELJ/i69QI+LLK1reETZnHvUzIwWXFTEjTLjIrrgfSS?=
 =?us-ascii?Q?jWgRfqzi18dlHtvwxRBIgL/lAbSC2K0B2scXEmdEp2j/gTs8PXt3jixKD4jE?=
 =?us-ascii?Q?1uAAEn7Gxzj0rhkr23km6dw7VCW1S2GzpDLiRPaw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 443a93c2-6b03-4943-13b0-08da92301931
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 06:54:10.6328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwgyLMM9yetI0l84GIKldNT0x6wfRu+wYlKjH4MwNATLzSY4Wvt7RJFjiB9Lc9t0Wavq/rDA4oV6o7vj6s/zng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6362
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

On Thu, Sep 08, 2022 at 04:25:32PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>A global variable hardware_enable_failed in kvm_arch.c is used only by
>kvm_arch_add_vm() and hardware_enable().  It doesn't have to be a global
>variable.  Make it function local.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
> virt/kvm/kvm_arch.c | 62 ++++++++++++++++++++++-----------------------
> 1 file changed, 31 insertions(+), 31 deletions(-)
>
>diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
>index 4fe16e8ef2e5..ad23537ebe3b 100644
>--- a/virt/kvm/kvm_arch.c
>+++ b/virt/kvm/kvm_arch.c
>@@ -13,14 +13,13 @@
> #include <linux/kvm_host.h>
> 
> static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
>-static atomic_t hardware_enable_failed;
> 
> __weak int kvm_arch_post_init_vm(struct kvm *kvm)
> {
> 	return 0;
> }
> 
>-static void hardware_enable(void *caller_name)
>+static int __hardware_enable(void *caller_name)

nit: caller_name can be dropped and use __builtin_return_address(0) instead.

> {
> 	int cpu = raw_smp_processor_id();
> 	int r;
>@@ -28,18 +27,22 @@ static void hardware_enable(void *caller_name)
> 	WARN_ON_ONCE(preemptible());
> 
> 	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
>-		return;
>-
>-	cpumask_set_cpu(cpu, &cpus_hardware_enabled);
>-
>+		return 0;
> 	r = kvm_arch_hardware_enable();
>-
>-	if (r) {
>-		cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
>-		atomic_inc(&hardware_enable_failed);
>+	if (r)
> 		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
> 			cpu, (const char *)caller_name);
>-	}
>+	else
>+		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
>+	return r;
>+}
>+
>+static void hardware_enable(void *arg)
>+{
>+	atomic_t *failed = arg;
>+
>+	if (__hardware_enable((void *)__func__))
>+		atomic_inc(failed);
> }
> 
> static void hardware_disable(void *junk)
>@@ -65,15 +68,16 @@ __weak void kvm_arch_pre_hardware_unsetup(void)
>  */
> __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
> {
>+	atomic_t failed;

nit:
	atomic_t failed = ATOMIC_INIT(0);

then you can drop the atomic_set() below.

> 	int r = 0;
> 
> 	if (usage_count != 1)
> 		return 0;
> 
>-	atomic_set(&hardware_enable_failed, 0);
>-	on_each_cpu(hardware_enable, (void *)__func__, 1);
>+	atomic_set(&failed, 0);
>+	on_each_cpu(hardware_enable, &failed, 1);
> 
>-	if (atomic_read(&hardware_enable_failed)) {
>+	if (atomic_read(&failed)) {
> 		r = -EBUSY;
> 		goto err;
> 	}
>@@ -96,33 +100,29 @@ __weak int kvm_arch_del_vm(int usage_count)
> 
> __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
> {
>-	int ret = 0;
>+	int ret;
> 
> 	ret = kvm_arch_check_processor_compat();
> 	if (ret)
> 		return ret;
> 
>+	if (!usage_count)
>+		return 0;
>+
>+	/*
>+	 * arch callback kvm_arch_hardware_eanble() assumes that

						^ enable
