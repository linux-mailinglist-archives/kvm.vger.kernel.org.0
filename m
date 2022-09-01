Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5635A8DDB
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 08:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiIAGAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 02:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiIAGAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 02:00:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73381DFC0;
        Wed, 31 Aug 2022 23:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662012005; x=1693548005;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KFGqwnMilHHQlmS4Bo3ZGMqVL5GABnv8rLkunQ1CwwM=;
  b=h+QNlJC7obYcur9HHncrngm4awocD+BM/M6h07C6fx/r63xhLqxGhxTl
   BQgH2wJQBjY+4IWt7xRGTZpk56V58y4sYQFtHdnBJhAyfG7xU5YVNS5TZ
   by+1nWWGj0PObs3wOC68B/to8wLQ82HRSnzUffhwrDGHkOaocpTMIEpzQ
   icx41tcjSIE1qH7/MpcSw6O2ty7b9BYCMLpvnkgjTnEebTrdkoe8jrdEH
   Ys+fbmRjUKlJpcuLTHPSg+KdHskqzECP5lyYR7N8hfJiE+p8tpjGc4ndr
   yLClrEtNJh093zWqkstdCaaaRxC7T1EWlSdOgxdqnyQ0Cqixy8lvqysrW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="294364567"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="294364567"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 23:00:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="715976064"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 31 Aug 2022 23:00:03 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 23:00:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 23:00:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 23:00:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEVcCvsOBpqNeSKKFvXFo3RzcmGMOxZ/B1ue1lhu/s0uW+C4PuP1AKYXo7/YfTC2+CpBTNco4U1eHWo6MMtk9v+HVcy0F02Qr6crYdwBBuOiqQ0jrQz0tY9HK0p3r5sKCXbtNJD8OlWKReFsXZWB/D17bu8qIUOGvEmDsvsOKvSfnq+mJgB4waM8EiTvU7YAQDSpFIaBitaWII3zJRrDg5I7bzSKq2qjeRuP4QKJ+ysmTm9tNxdH4n2l7wB3WPcPsFylZUM8dVgi+nAAxyUPZ7DfGDuzsg3fz9PVP38P84SaCnVpAXuvQpnlxhM7Sz/1TA/VyRsHik5nEy9diJ/VOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFGqwnMilHHQlmS4Bo3ZGMqVL5GABnv8rLkunQ1CwwM=;
 b=R+7JCTjtigTrZuSDwb68JIu93+gUm+7RiVzf+4xG3duvCeUjKs7JLhLiW/H+5Qfwov/WQWOXctWYi7Qkk6Kso4iZ2nPjh9LCCR6kRnUbo2HPi3z1CY8qRPno7cIrd2F4pSRf6QGgZCUR+wqHrtgDPbh9pyjeS0WzqEL5/IYrU4qkI0qxTJBC0uet4AASbuF+ZkO+sYhrrLLcn55HwqfGhr/VywLoHxetAvq/Y8Es2BOvKPS0m+AjxHav662eh/6N/idn/y2aXBNOjloBzGJctcEa77y65m+DPd6rRzYuxOydA4neuMJD+ZXyJughHkfj96wS8rHmy/tDQhuEVnmb/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by BN6PR1101MB2082.namprd11.prod.outlook.com
 (2603:10b6:405:51::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 05:59:55 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 05:59:55 +0000
Date:   Thu, 1 Sep 2022 13:59:49 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        "Will Deacon" <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 05/19] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <YxBKVfG29/P+Kijv@gao-cwp>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
 <d2c8815a56be1712e189ddcbea16c8b6cbc53e4a.1661860550.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d2c8815a56be1712e189ddcbea16c8b6cbc53e4a.1661860550.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: KU1PR03CA0012.apcprd03.prod.outlook.com
 (2603:1096:802:18::24) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85ea0eff-9691-4085-7278-08da8bdf3163
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2082:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2Q2Pew6iNsSbQnnEwNQw7pMskpyLgXxScg7MdboacjkSMZun5XF3ZAnyrSkpFNEg63LvfLDPV/qLskMA7G16jfuNDAkxiTgmVVWDmuQtHm9Fn8VXbfIhWubBoQoCARmxpq3+eN+E3Iw6Yk1JD3wNwwnnByo4O81ZkYA9PxyV3l0ZHZm61gOvHbYy/p9wEP5HjNoi0X8T9H8O2+4ZQVqdK+SGQ9dTilIq1lKnGnINoxNmFScjo/Cl9rPB9VzEpMqzfU3MxwC6j6wh1c/6IInVm5h2/t/f9Sh5Q3g9n1cH4J0F+jsswwDvc2d/hgTK5GlrDCRwvSALHvzFQsGymSpd9NUagSi/MihYmpCp2m8J+vmM9ytv1t9yycfj/DH7EPlLcklxyrejBjqL622XwNRopRt46LNyWwNdByxFcZn/PB8pjK0V/TyIPkmlG+btVba3AR0qwYmtobFay4YUbH4+DqvKaxb39xE2xD3Py2tvuSoe0J62NJ3BD+Bm5N9A7KbV6N93fMYCRJOXJp646pJLYIHs6fICkyDEtlyqw17Lt1REin/ezZ58+1P3Vp9HENQau7MQ879BSeyoCYCGuJA1+HatsaxJRLxUb5VhMQHH03dnMFe/QnjBG8RY0Ag6/HEEVyLlAF9OIBvT4fcqMnfTiVL7hPsAaJIGrg9wkWORJmSSbGB0N/kmUu/p7icAOY+Vt/rYkAoaeKJMEI31+3C4/9klOA4iaLAsl6mxf207UeuezpSvzo4+EFNAMexUA3qK1tfmK7TNCaEN8XSgdNI0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(366004)(39860400002)(376002)(396003)(136003)(66556008)(66476007)(4326008)(8676002)(66946007)(2906002)(44832011)(316002)(6636002)(34206002)(8936002)(82960400001)(38100700002)(5660300002)(9686003)(186003)(6506007)(6512007)(6666004)(6486002)(54906003)(966005)(26005)(478600001)(41300700001)(33716001)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oSPq8SOs35mG588PIwMapFpjwkysd4w4GcsNWFX7T0+OOVh95MblxKPFwlqb?=
 =?us-ascii?Q?4sGX6rOmsch+QxCEK0MSQmeQabsi3lpWdAyu2h1iSYqVIOejxr6nHhim5SXo?=
 =?us-ascii?Q?PruWjn5CmH70mb/M3rWPPkrwDixhFHWdWUiifAyMtOz04cYTzQIpIuF3DFbR?=
 =?us-ascii?Q?Y2ICbaHeFD6pJmaITK/31bRK7coQwPtbT2qiOlS7tK9lz0Speb3wyTjnTd6w?=
 =?us-ascii?Q?ugfC2J5okmw1S7LG1qFh2ago2eTEhUBcvfoUZ3T/up5Do9zjnj1UntsOGYg/?=
 =?us-ascii?Q?fP9/9xI0XAPABZ3OvA6NbVLET9QHkzvdL0M/ZVNB9/gyAFnceSqNk/5k41Eo?=
 =?us-ascii?Q?R7yKcRT1Weht6D/SgECPOtbQAiON8Klg1VqRhBeUuIS3i/1P2dIjDerEF1cA?=
 =?us-ascii?Q?7bNUbIhhIfM+WjqiWCg1N88QRtENv2wH+F7x1fITcAOU5tUDVd6lLO2iPyF5?=
 =?us-ascii?Q?gXPa2C57unTC6hn0NdB/cg0rlKm+tqsUxr5q8p9Aj+Xea1HU32OuBH+VbwkR?=
 =?us-ascii?Q?YJoeh+t5tGKm+twYZae+pkdPMfesRq73IsA5t28cYvsAhjl0SdSHtEQoywbz?=
 =?us-ascii?Q?4dsa4O1tm+om/O1xt9j+9oVt9nvSxOkfZo4fJufZvJ11Zt2lKe91LBhflLpt?=
 =?us-ascii?Q?D+uYFIBjsL5l0azEJAmSFZH8acCWo4P+U1iyr/QhPrb+L6uBcZHiLU6z9KSs?=
 =?us-ascii?Q?vgkd666bTaLiYiS9uM3pCFLk4DVLqmuAY2ndwcVjn8BH1S2DZozzjyW10dmr?=
 =?us-ascii?Q?2K19eN4wP/E8Ag3EZZErVnLWD/VPjllwS93FOfLq7xbpzzbbR7d+L1Dzk7Lb?=
 =?us-ascii?Q?McGBaJmUhKN32qTkRVoSJxlONoj5WTPllVlop0XYOpX//ahNi5hyzP0+o82+?=
 =?us-ascii?Q?UrjtC9VwDEO3rDqVIARhxXzx/76A9imduJM15XKaHR51mN4Wtu+XBur+uKPt?=
 =?us-ascii?Q?EZ3TiyMifbfm6E7ZqBHTNOdJylNefI3L+lCYVParpkLzEeOb+2JR52imqTvB?=
 =?us-ascii?Q?oscVeKJhIeRDJMlynLMNhJo1i1I9RpfatTFCOmRuIK4wT0Ix+kv8e5ezuP1y?=
 =?us-ascii?Q?v5Vj3BZ1QrU2hxyBKzB9j/Maplj7N/rXoTxinmcqliY/yGQHGoEpAX0Iuf6d?=
 =?us-ascii?Q?ICf2YXilnZIcJOGSnFXshU5GF7Aak4xq7uxUk69QzhtDQ86+xqH286HQD3Jk?=
 =?us-ascii?Q?pH+F5MSGTOi75UWO+P4xsDXDNwXGsd5yVHTt4ufMnAWoFatW+2Pk9nPQkq1k?=
 =?us-ascii?Q?Hh4Wqyt33B4QnGfN6KM7Ga6yIxKMHz2TROh8OK1n56Bu0deDHuzdM9nIRvnX?=
 =?us-ascii?Q?VjnlG2ZP9Lk5zETxcVIP5chE7KJCR4NwlhiXoYGKkjvIsjGRgv1MzdsLvi+C?=
 =?us-ascii?Q?VXdB6lt5+AEqGAsrxXMfwONtIUUiBO5xBkPi/mrBC7zGI8yHJSVOElUN/j+/?=
 =?us-ascii?Q?E2ZsIKa+ydlpCOf2UZAGGxNnVvUbn4V8OWzf51D4ur0FZtEwbMYr9F6hVvvV?=
 =?us-ascii?Q?LfBh8F7YTIFNEBBwIvJymGRaFV9CuVAuqwaCB9He+tSGHX1txVMAdPZK226m?=
 =?us-ascii?Q?ucdaV+4aZkbe5ISbaBJ4mVlsA500+6hgHV9l8wBf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ea0eff-9691-4085-7278-08da8bdf3163
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 05:59:55.0165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySVWZ/ZOZnDzyZ1c/FUnolpMX1lwJnFIYlKTKYUHplRAFwyAAOntQ9amXNLrwUQu1kxfa6PxNBqi5c56j5L39g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2082
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

On Tue, Aug 30, 2022 at 05:01:20AM -0700, isaku.yamahata@intel.com wrote:
>From: Chao Gao <chao.gao@intel.com>
>
>The CPU STARTING section doesn't allow callbacks to fail. Move KVM's
>hotplug callback to ONLINE section so that it can abort onlining a CPU in
>certain cases to avoid potentially breaking VMs running on existing CPUs.
>For example, when kvm fails to enable hardware virtualization on the
>hotplugged CPU.
>
>Place KVM's hotplug state before CPUHP_AP_SCHED_WAIT_EMPTY as it ensures
>when offlining a CPU, all user tasks and non-pinned kernel tasks have left
>the CPU, i.e. there cannot be a vCPU task around. So, it is safe for KVM's
>CPU offline callback to disable hardware virtualization at that point.
>Likewise, KVM's online callback can enable hardware virtualization before
>any vCPU task gets a chance to run on hotplugged CPUs.
>
>KVM's CPU hotplug callbacks are renamed as well.
>
>Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>Signed-off-by: Chao Gao <chao.gao@intel.com>
>Link: https://lore.kernel.org/r/20220216031528.92558-6-chao.gao@intel.com

Note that Sean gave his Reviewed-by for KVM changes.

https://lore.kernel.org/all/Yg%2FmxKrB5ZoRBIG+@google.com/
