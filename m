Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80B176456F
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjG0F1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjG0F1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:27:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A21211D;
        Wed, 26 Jul 2023 22:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690435634; x=1721971634;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fX0VB+oC7I8byVGLz/BLLL2XFaXQFpDQDlE6jlgsCsA=;
  b=bl3BkRPaIrPJ0D0SnfOoWzem6ZJGT2py7QCFydJJmVes9oBj1bwAYWEN
   yzeEJ5jov4ileolgT3zXRh8/OSQl1ycXoRLPioYHQdDHMfVYKVBFHBtDn
   8Ce836LukVUtv5ELKWBXP3IsoTvxg7y27tKvY6reJupmHSkwmJ/gJlug0
   ijq/78ZWnXN2hyKqVIDcuz8bbfBm9ojePzGkVnzrIySoTt25OMLG6l5zr
   yD3sw4ISL8yQlxW+Lwtttc5TWojag8Rq10AB3vTj30v4B4UWwOiV71juY
   UtXUtJqo8DJRdmi3f9Oh6CuMgVW07vZNQIeRR9wj/V13Tifo1MOZuv5GQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="367082656"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="367082656"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:27:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="796847132"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="796847132"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jul 2023 22:27:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 26 Jul 2023 22:27:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 26 Jul 2023 22:27:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 26 Jul 2023 22:27:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GB8W5KQnk7QdeACcdeBpzfYTSH/suURvGQcIY+H15G5w4o9cqP0UaszPzwpxWP7ZxepSe5as+iEEaDpHbvcDeY25+1lfuuM+zT2zdPw/j3w4da0WODOMQDAxpT64am2yaigwGH/GlFiY33cb/vrd3Us1+uy1xGB6l3uzJxh4VfZt/20rQiXfT1Cv2ETffSvYImcT8sI8dByYIpjEVHifNG6ooXLFzuIRJIJOIUAMK1LfxF2dGrBKptpNBznLil3yTx+2aXJNl/uueXo41LRXOtn/R8bfRoFnwZNJMSBzsR/zWjuTpLVPbxP3zJLzaPLiqikKlXZYD4MmCTSXizfSeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JXGLNtdkK7rbxaiDCxamnbzlpx5f4L5whiz/URFtxA=;
 b=m+xTnFfwXrKMGqKgh7eu9jQaWcP5lBS6EZkmP9+e3V77TrsrgOEKF30YKCEE3Mw9mafT679XGpnAvq0dmRhbxM/FJDHFRcCX82AHAK7W4GV6aIZf2YZaiwxkD+ZVjzdESZ537jwsn93xQ8efeJhD7ibwh8GNhgb4bT8fnd+jhqg//1jaKTH3rENUwGmwVYwEsDwdzQcWKdQyLJbKssAmcn5/ZXZE94OTVt1g6ApuQmnqdZG9f1IbpBp6inBne8ZQPmT6OeRFcG0aosNRvn7VD7WTa7nO4mXoQqKQTXyythLXW7i2V8Ur33LMVTqCtxNcaDExVfIEpyNLKF6x/GRfGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SN7PR11MB7539.namprd11.prod.outlook.com (2603:10b6:806:343::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Thu, 27 Jul
 2023 05:26:57 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6631.026; Thu, 27 Jul 2023
 05:26:57 +0000
Date:   Thu, 27 Jul 2023 13:26:47 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v4 12/20] KVM:VMX: Introduce CET VMCS fields and control
 bits
Message-ID: <ZMIAF40pG0WCgPNK@chao-email>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-13-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230721030352.72414-13-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR01CA0180.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::36) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SN7PR11MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: 81a22ce2-4bfd-48a2-c520-08db8e62183c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +a4c+1/sdZ1/blFXHR8qcn+HKlMzwpr69c7P1cj8w7BXZgYynjF3CCW09WXJ8i1u6FIEl2r6qtA3+EAIzBlYuhfJZ0jirH99qIUPSLRdo00KQeEzWxDNGS1hNiyb24tjqxqwqwfIrxxlZhthEK/JfgPXlfBwBDhofG0v3XoA196ihs18Ks8h3cxFW7desn5C3i73gGRKwxAUYIiLcHhqzRzGSaxWilrzyprEDiZoHwDQfsYWe61+nsXtefvDX+ek4yfyATG/s9w/AhdCbqImwqEOJlZ+ubQ9XxFhL9UL7Jr7J2c+Y3uAj1RBKyos3RIQN/l6FJDB3qRrBDi+3KK8bPmjBBzRaBfFJIJQmMw4e+b08ZCqjlV5ZHmkLzmip4c+vLib1apxJMhij2vGJLnJIXEV15HeKCb5OvSYHy6nWks+iIue0EmO1Ai23+cVqnnlDG8AJsmv4fkfzmoAuO1YEJiuU1YQcs/NGbVsiAvJhiFbl/jYtqIlUnIZXz0XEUG7XuvF17smN0IDoxyr0f9/tCw6t1QnFy2q+KaVwJns229tCkoeaVPTAZYEaTYIxMP+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(4326008)(38100700002)(66556008)(66476007)(83380400001)(8936002)(9686003)(8676002)(5660300002)(44832011)(478600001)(6486002)(316002)(66946007)(6862004)(6636002)(41300700001)(6506007)(186003)(2906002)(6512007)(26005)(6666004)(33716001)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FKsibVPI8dWecsVo/iC1DxPAVKbNu4yo/5rQ3k8Hzl/R7xzoJDvq76M23T+T?=
 =?us-ascii?Q?G7cH69oF7xWrmxei3mpsfjBjm/9U1cerVu3zobsqH0bQmQ3VaPno7edL5Bp7?=
 =?us-ascii?Q?e5cFIaCoVQDOZsuuHOZtoyMTn1SqPFp209gCS+I25y7qvTjvjEG0dT6lWw53?=
 =?us-ascii?Q?CIAgEcK9YxVD7KwMmsse7iqb0hlnd4RMKTEpHnNHPZRHEvZnD0GbCKsgTVGo?=
 =?us-ascii?Q?nOEfpIDBNjBwN2WpMMi3IcwtJqb3hynStyCnFYabxQG5R7TbCSgknetEVnNN?=
 =?us-ascii?Q?xSyzraoSV1I9SJ/BWyWxSLKCY7ZyL9j7eif6GiIS9eZ6eYdDqqI7GGVTAw6S?=
 =?us-ascii?Q?aToDYJStXPV9FKr6d/vZGi4WeEPHwZauFBs09xxAOEBI0+oeCj7SGsSITyH4?=
 =?us-ascii?Q?sa6WXRAG7SX+ePHYUKQX2pAeQQbnoZKOnnAleSNpTV9R7DWXGy3LNLoCEIRF?=
 =?us-ascii?Q?5mR8K5OdjimyFnPU7JR6Fz7v28ddwcPFcjJg46Wo+UbMQ7IbwU3XkAeDHAs3?=
 =?us-ascii?Q?jSrS+qCESnwR06rsWGtI+H1tArFVOd6R4ko7vdc58SxQr+ldNSj5bvNxc4zc?=
 =?us-ascii?Q?CA6o7YTSEUJuRa2FaWSzg+mqBHNW2ZxZr7O2mRSeomhYt3Mf/8ibxydax/D5?=
 =?us-ascii?Q?elzMAyG3IOuvmIM2JSwjlrt62sH3ZD5rkwSBAqqPb8PcvN85uULWcM4i5q7Y?=
 =?us-ascii?Q?zX6XX1Pc0/Ii1YiGFsF6bDTi+nFvz41U2qqkkM7eXJKHnRpTIJb8FVi4XdgQ?=
 =?us-ascii?Q?HJ+7crqmju1825DypLCPnF2sI0WBMbPXgwgO7tZ6PrI32B2doPkWM3+Pf3QC?=
 =?us-ascii?Q?W3jFYy3CM3kP/J4R5zScj7XzeT/Fadxx49BB+J/CzDS5byXHC1VKACqC/UmX?=
 =?us-ascii?Q?AHE1B3GyaoG5OFmCymjpnbPUMatogJ5Q1LJPas9bHnln1EwKRCa4PUV5V3JO?=
 =?us-ascii?Q?XCRiJM4yiNYqtNAgTdFPwbLx9ckF1RyrY8Qsaj8Dd47j7+vV+RtriSJO3CQJ?=
 =?us-ascii?Q?LRgmXkg/sQCU/G3RQpgxHR2y6VmqabCAA3qdsCo11Zax00QzOZqogPZku9Wl?=
 =?us-ascii?Q?6LhCqIrDWMEj7raZWgm39b8PCwuO50o1kckkh6H0OD31UBsOC2aJ63ctckgS?=
 =?us-ascii?Q?AX+jdTQuwtLuZsfZnxwfS0n46db/uAWK66TdJ3dsDRANju0sq3k3gOSNELU4?=
 =?us-ascii?Q?8+Sm6W17oeNVDpngHMwW+eg9w3dKV26l/cTZXF+zQuQ9TWUalFTRNHO4uTVx?=
 =?us-ascii?Q?TwFAeNxbuBgVQZXTsTh9Hv9Pn2xR6b2vQc6pSIAdDzSNti6DgVaoTNmdCC/W?=
 =?us-ascii?Q?Wwu/lO7dn9HwWfI6O4xeDCO4XNzAjufjm30usi65IrN5V0KTJ/c8YGyFIYe/?=
 =?us-ascii?Q?iY84WJkHjrdJAVC0nscikF3u7/YW+tPUdY6Ftg/3yIC1Vy+0G73PqDpDanSI?=
 =?us-ascii?Q?ccxOrIJi+pbxhWVUNzhk1zV333006uzPF+w6d1U6CHP8BmYociHjnzv/BkU7?=
 =?us-ascii?Q?RDYnl1WiInZyOOa1RGKd0WQQl1b3J7DYmUikflR84wymUdEOcaoXp704AAwK?=
 =?us-ascii?Q?dl+b/+9+ishzBHYOzMpM4YBo/SLz5QOxy7Cetk/N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a22ce2-4bfd-48a2-c520-08db8e62183c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 05:26:57.0411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zVtOwoZJbjg1PPsF/9yGGAJ0c6orc37YbqmyZGCD09EKB+w2oWQeKWcx9NOmwYAfTSXowoQMclcPv7IJ6SBqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7539
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

On Thu, Jul 20, 2023 at 11:03:44PM -0400, Yang Weijiang wrote:
>Two XSAVES state bits are introduced for CET:
>  IA32_XSS:[bit 11]: Control saving/restoring user mode CET states
>  IA32_XSS:[bit 12]: Control saving/restoring supervisor mode CET states.
>
>Six VMCS fields are introduced for CET:
>  {HOST,GUEST}_S_CET: Stores CET settings for kernel mode.
>  {HOST,GUEST}_SSP: Stores shadow stack pointer of current active task/thread.
>  {HOST,GUEST}_INTR_SSP_TABLE: Stores current active MSR_IA32_INT_SSP_TAB.
>
>On Intel platforms, two additional bits are defined in VM_EXIT and VM_ENTRY
>control fields:
>If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host CET states are restored from

Nit: s/VM_EXIT_LOAD_HOST_CET_STATE/VM_EXIT_LOAD_CET_STATE

to align with the name you are actually using.

>the following VMCS fields at VM-Exit:
>  HOST_S_CET
>  HOST_SSP
>  HOST_INTR_SSP_TABLE
>
>If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest CET states are loaded from

Nit: s/VM_ENTRY_LOAD_GUEST_CET_STATE/VM_ENTRY_LOAD_CET_STATE

>the following VMCS fields at VM-Entry:
>  GUEST_S_CET
>  GUEST_SSP
>  GUEST_INTR_SSP_TABLE
>
>Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
> arch/x86/include/asm/vmx.h | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>index 0d02c4aafa6f..db7f93307349 100644
>--- a/arch/x86/include/asm/vmx.h
>+++ b/arch/x86/include/asm/vmx.h
>@@ -104,6 +104,7 @@
> #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
> #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
> #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
>+#define VM_EXIT_LOAD_CET_STATE                  0x10000000
> 
> #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
> 
>@@ -117,6 +118,7 @@
> #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
> #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
> #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
>+#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
> 
> #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
> 
>@@ -345,6 +347,9 @@ enum vmcs_field {
> 	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
> 	GUEST_SYSENTER_ESP              = 0x00006824,
> 	GUEST_SYSENTER_EIP              = 0x00006826,
>+	GUEST_S_CET                     = 0x00006828,
>+	GUEST_SSP                       = 0x0000682a,
>+	GUEST_INTR_SSP_TABLE            = 0x0000682c,
> 	HOST_CR0                        = 0x00006c00,
> 	HOST_CR3                        = 0x00006c02,
> 	HOST_CR4                        = 0x00006c04,
>@@ -357,6 +362,9 @@ enum vmcs_field {
> 	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
> 	HOST_RSP                        = 0x00006c14,
> 	HOST_RIP                        = 0x00006c16,
>+	HOST_S_CET                      = 0x00006c18,
>+	HOST_SSP                        = 0x00006c1a,
>+	HOST_INTR_SSP_TABLE             = 0x00006c1c
> };
> 
> /*
>-- 
>2.27.0
>
