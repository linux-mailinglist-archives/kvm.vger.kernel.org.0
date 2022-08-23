Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D65259CE79
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 04:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbiHWC0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 22:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239563AbiHWC0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 22:26:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BFC5B04B;
        Mon, 22 Aug 2022 19:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661221582; x=1692757582;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pQfckyhHcPxZ+QTFQNhzJYoF4Yzkw6PZY2LJXbPQ6og=;
  b=LfQqBoPFtARibCxI8TZkngnB6DIi/iTRRccbJHeiN7Z6uQMtVpf/13Nn
   8csH7Y3a0AfgiX1S6h9poXI3rE4IQSNsyx+sY8/FJu2Kj+FuFtw9KCWM5
   tqM04Rqd5GE6UhNQWU09HxLrqj1rAC3g1CW5H3GXLzgyTLX638IBYwSpl
   XbUWQn1cKwdH+yitdPafFWu713FlYU/NO3LZwEtaD8qKMa9hM6nFJ2vQn
   ewJn4za2EKaDRLYP84kk04TVG0RAg2xRlH2JKc1aBtXnNwmRt5C2029EK
   WhkdsNwq3Iot5/gX9YI7d/uy0PIZfTrQ0+bOMrCNEXnsPOE2Jy34Ku6ua
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="280544641"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="280544641"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 19:26:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="609179529"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 22 Aug 2022 19:26:21 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 19:26:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 19:26:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 19:26:20 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 19:26:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEJSP7UjtrF/QaLE6l2KV2G9AzFrrYv02lW97SldbRRNSC2NMv2RCqcrZfPWjYqQ0DrPlJluuRGZbMIDU/dWoMmfpP/65F7IhCSgKv6MHzdWsUzTIq+FU9o2Y2KInxg3psSqdzmWeUKsjoB8P9fC0NupNTww7INk/zGqVwRR+NvlHQolAzdZcyhEY99eLCXPaMwqkbUGqwpGQHxoag1XDkx88BPdiHTyStWwjbiCWTQF9kVI9JO4B81OArWuF/cwvq6psDh2c9gowxlv/f45qb/suk/6SADwdb83xTmMlBEg8J+zQZXd55BL0f0zC8/JPrTBhXK4JyGG22JKq3MI6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QoJQK90358OTfee+DlymyT7TaWcPsy3NH+3cyyznYqk=;
 b=UMibCKmrcigyKQUuTaN4MSEhidim7w1WXkOw9JJHv8/fzr7rU7GBjEHn1bfIpUX90jctD9y1wiAA6bu7jQz66ZNbj2apIbqxnExDa/SYDiARcml83MuW6PImp1Xei2yq2vyluuzhpdpna/8LOzSGJzSn1qAzMdiQLt0EOoRrtcLrOy17MeSjvevtf9Df0ePXmaqiVKLrV1C6Hc9f6H9k0giAMm0UUrpnpQKEvL1gTAL5N1gdKXiQxQ9d9Z7A6DnIhUf/QLrYb8zKwAcliLLLbaeIjyhN1Yx1Z/aGHparmSX4yBX3fVKrrEGTUN4Okez847ATVjn8xB8rWItU4sNlrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by SN6PR11MB3390.namprd11.prod.outlook.com
 (2603:10b6:805:c0::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Tue, 23 Aug
 2022 02:26:16 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%6]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 02:26:16 +0000
Date:   Tue, 23 Aug 2022 10:26:09 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        "Will Deacon" <will@kernel.org>
Subject: Re: [RFC PATCH 03/18] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <YwQ6wTmbja4h2TYZ@gao-cwp>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
 <6b07c02dd361f834fea442eb8dae53f23618f983.1660974106.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6b07c02dd361f834fea442eb8dae53f23618f983.1660974106.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2P153CA0035.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::22)
 To MWHPR1101MB2221.namprd11.prod.outlook.com (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a281d1d0-f9a6-4a80-06b5-08da84aedafa
X-MS-TrafficTypeDiagnostic: SN6PR11MB3390:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnPs6fBO1P1xvB043175OhiQUytxTKVvViaYsnolU/WCkG5kqPvwYESkS6MmnQ4JiKSYDLlQc9JLQHsb00dfK+SXCI0bMID7kaXPxFeRztnaqv+L/e2V9ir2H07TXIiimKPZ4BAEoXYDsiAVtNzyLu0VsQtj2Y03wk5/UcCudJ5fRuklfzIoAjp4aXyGh1S5H508l81GDOB+PnbG4uxouFcgDQIL9xL+nf2/pxx0dUHeMqURehUh5/MKFqiIVs/ovzZY7ehItM8eKCMW92+l5kt9a+/+QKVIFRdXMVz1C7LPD2ZAL7RmorXmI65riCheNvnY8DPe+r9wgA5ekX9gOh/pzwY6GqNaNuRGiNFvdQlVsOMuYlkfa2C7TQFTnAgT8Bc82N8vquiIYFU6YnMu0r+O61HE9V6NA6nYYi195Q1wrQcjkAZ/TFsw0Z8uODisrKcP7Qry0jtsO7RcVYFl8OS2v1ux2XAyzeV4IXYHzxtUumQ95Y9bp6o3XDdtvS0EhiVx8uAonm61DB+7WttyFMdabbI8SosanToARHGXmLl9RqJlm9BUOJtrs5IBT9Cjnn51EFKPxGPjCwSW7MzxHiFKQLYqUTgq24Ji5K0QYTH/TPaRdemybK8tab3MJ8GcZ7E7NmRXMOIdf42I2jSq/r9VMNpdAliKPiQW72UknrPplagFz5Xg3LWAGsMjxLnd0Hs0cUrOvsWysX6IPzhAKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(346002)(136003)(366004)(396003)(376002)(6512007)(66946007)(6506007)(186003)(38100700002)(9686003)(26005)(86362001)(83380400001)(82960400001)(33716001)(478600001)(44832011)(5660300002)(6486002)(4326008)(2906002)(66556008)(6666004)(34206002)(8936002)(316002)(54906003)(66476007)(6636002)(41300700001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zvwZhAeqO+ZGnTk3t3yD+xFjZAEcoEOrOM2W/+1GlrVsCoZBXZRjdg2gc6EF?=
 =?us-ascii?Q?CEFEY5MGLG7QUNmVmorqFxtrkBv1OLwKQ4sSWL0wQfClkwmb5SLazXbEwq3h?=
 =?us-ascii?Q?HV6J6AUEtqD4+Q4JQocsrd65uwxxTwzjTT79swTNZDF05E3OWuGb8hwDFoKk?=
 =?us-ascii?Q?awBg+ahA2hoyKhwiF6uuSA+VeI3d+W6wjnaLjz9V4/lXULKnaVCVRzcFkJjo?=
 =?us-ascii?Q?hUnIYAqYXWGHFrUZz+08NQy1qgIhlEHrsIGkvYqA/EsTaz3XdRsAL9+Jo8/K?=
 =?us-ascii?Q?n6CNBwFHYcOurnTrAbvduKkgSxPtdNemM+J8t0LP6UarLdGT4VuJxZXNrIbW?=
 =?us-ascii?Q?0AYVAlYdSFJjX58M9+/9vyZpEPNnODg6BjxE0uPrJzVodAZa50iHxiUleN6g?=
 =?us-ascii?Q?HYt2bhWe03bUymwllyifW2bDPXaEbvZtCzEeQScM/UuhAgNBNs8SN1zmN6sj?=
 =?us-ascii?Q?BEyGr/lW206Y0Fh7bgYLlwZXRa/V8wXc5d4ad+Rzk6TyvtOHxJQtj9W/IVk/?=
 =?us-ascii?Q?GsMCOGeRfu5lukg2Dkkgp+kN2/cZSY6jfUULVklj6KkpC32di1ZNTsxJFL7X?=
 =?us-ascii?Q?VnBo9KZ5t+bW5Jqf0jyq2xoAjZNPI/7Nqd4r9JRs/g20XCn9iUKKsvTamCQ6?=
 =?us-ascii?Q?90ULDtVpRkl02QKPEQuXvbVJp+uA+N6h0/gXSzHpuBHDdeNKr2dzzsHTPVy2?=
 =?us-ascii?Q?lSyjv18G9w9qmVH+xaJn1uJPMTR1oMTdU3tULpri50nzrV0W8Y/nAVQKkuaB?=
 =?us-ascii?Q?VnCmC7kdif0kLPuFK/WzUvpMBOMqNF2ETBZ0D+VEsQYwz2y6eWLSAAOvbz09?=
 =?us-ascii?Q?uFEOOuDx2qTj7UFafpSDK36KlxD1XQ+wvtl+3R8lDIPNqfVTTtcSqqBgN79E?=
 =?us-ascii?Q?5dXolqkUHpMfPgaJCnKJ4KvYI7VSyYYfaW4+gmTFfnqOamSIb1Zw7YjvsUVf?=
 =?us-ascii?Q?By8Fs9AJaz5UmUt+9nwwioTean0CPyz+MWvcv/6MSTzvBQgljOz4//ZK5Q33?=
 =?us-ascii?Q?yVmYCP7w2jYP7iv8cJVyHPj6h8VA391V6wZ47o9ETJHmuGipg4aPspjDLMzs?=
 =?us-ascii?Q?CQ8FauWbgphWOlH86ImDNH90XdrlFEqflKXxUD7IHSLMPF2aguWGpPnQVPh8?=
 =?us-ascii?Q?MV6Hn2PPmA07m0OoCSU8cUvv1y4436mGoVY6BmMRKmcWvK5yzQiJOlaUZz8+?=
 =?us-ascii?Q?/U4+2531Xvmoi0m2YjHOWhto5IWVeYMTBnDPUoV+A89iKD/3R6SqOTn8xENY?=
 =?us-ascii?Q?AS3m/fhyIW4pDm4mQ108o9I3Z/OyfYM9dyI4YxGSEBQgoz/60faRV2aF5E+4?=
 =?us-ascii?Q?umO6XH9LD0r4aEwt9Z6una+BqmqFijOpu1iuMPJ0q1IkZx8HrZ2AbLUsD/oc?=
 =?us-ascii?Q?esU6UhT2ghZdmWL1Jcxa0SLnXi55gN9Ztu1GSqVMQSJns++d40wJVwXsHvE7?=
 =?us-ascii?Q?X2p7P/ZhvCtRG7K01pZ+RZHmOxSN6O3Ac1UuL/ckdhWIGFLfm32zFkxlmcqT?=
 =?us-ascii?Q?wbhddngXjdX8nseDZQ2Z8p71IkCiMAS4ODT2XGddbF6RJ5ccd0Nw8Et6+48i?=
 =?us-ascii?Q?vFp5IBT/xyJaP5wZX4ZlND/EO+nyugdrNC0uYIRH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a281d1d0-f9a6-4a80-06b5-08da84aedafa
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 02:26:16.0903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b35lLoTD/B07WvvBmQIzbIsrD9twiGUAeaP+Q/GBoShuI/+5FavPGwM3yrFxjG5AD75Pzn0mUqJlFWJF6paDww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3390
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022 at 11:00:09PM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Because kvm_count_lock unnecessarily complicates the KVM locking convention
>Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
>simplicity.
>
>Opportunistically add some comments on locking.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>---
> static cpumask_var_t cpus_hardware_enabled;
>@@ -4999,6 +4998,8 @@ static void hardware_enable_nolock(void *junk)
> 	int cpu = raw_smp_processor_id();
> 	int r;
> 
>+	WARN_ON_ONCE(preemptible());
>+
> 	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
> 		return;
> 
>@@ -5015,10 +5016,10 @@ static void hardware_enable_nolock(void *junk)
> 
> static int kvm_starting_cpu(unsigned int cpu)
> {
>-	raw_spin_lock(&kvm_count_lock);
>+	mutex_lock(&kvm_lock);

kvm_starting_cpu() is called with interrupt disabled. So we cannot use
sleeping locks (e.g., mutex) here.
