Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D31276FC38
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 10:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjHDIoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 04:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjHDIna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 04:43:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E995130EB;
        Fri,  4 Aug 2023 01:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691138609; x=1722674609;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4H9snsEMMnELay5FiutyCrGfRhk3Dds2VksmCYHAGJc=;
  b=SxcfTMlXWN/riow/YFQwBHa8WlNv3Vg4Df7fSqt6TeUGdbBvzsNKyxOo
   UgGXkfiFD3NIdxMDdO0mACirfRUYgEYHgzKL8AAU/O6GoiBACIOBibgtH
   WpWVRigQTG2PMkzHGWpW31UP+FO//Q3xPzn1MnaOD+QmbXN9oAMhgBUjw
   C+QxZFNWePFOv4uAAN+KbDpD9fnsEyU5GmZNhKOQBZiWgx3mWj9Hq1w8p
   Rb2U7Y2Xp5/FZbV2YFdR76IfVA7V/Mz3qC3dTkHdKeJBkT1NbqfKmikGz
   hpgy2Q/z9qWoQIOcrI2tDxzdjEvRs6QfX7+U6kOmw+0K3XRmJhL+hf7XW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="373754025"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="373754025"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2023 01:43:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="706917141"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="706917141"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 04 Aug 2023 01:43:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:43:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 4 Aug 2023 01:43:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 4 Aug 2023 01:43:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 4 Aug 2023 01:43:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltsxAU0xDtopIv368tL8kdm/qCZqARom/PzfY5aUpTIB81uAaG3l9GhI8b/NduRFzbZ3YH0P6LSHu2wuv55kP9Il0ja5gIwjnY2bImjPbGWuCNINUFaAC9Wt/++nwoDttuxteNTDTtXhD4U569sMNrA6a3Qe4hHK3F+/x6CrPbs+fLfL0AgSmoRchCdmoAuhYH5CcCi28L8FGPbgQg51aTlnWulsyibQk1hI01GRnOVNYQCPd9OLL7Loyxkl8DRuO55OdhLiBAD9Zx5X4erALJExFe1kPKD7dAxEnc3xr0R7HBJkm9MbiMF+NPbaM5npyODQgAObiN0sYcZC2DTO6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdFuUPLUFVr20ZRfRP0uFQFVY6V689dsiQNCvGba0PM=;
 b=B/UxsO7TthQAWe82WsC7LUF/qeLzRyd1kxM456vmRryktiibcbN1S8sHUhY/NmZZjbYwq3fYCfJOcmamMMa+hohKY6RzMT1suAFA/RYBRhEGFmpUfaJ0WrI9mHuRmr+N5xw8f/oqWgpLEoTBDKayF9wmCL2RrIUl3la79Z5sYdw6SrJYJ7yun7UHvz7w5I3rDVCb3s9QjycfkaULlBZDWNF2oc3fQLogPnyYeB50W+P+G44GY5xha2nstyz3Hbtl8Fw9W4JWKtaUtBpCYE1kkUJSryhlYibzkgv6/C+e3DqmgFT6GOJojnCTi68DP0nqJovmKbFsaIT6GaobYKB22A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CO1PR11MB4993.namprd11.prod.outlook.com (2603:10b6:303:6c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 4 Aug
 2023 08:43:22 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 08:43:22 +0000
Date:   Fri, 4 Aug 2023 16:43:12 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v5 15/19] KVM:x86: Optimize CET supervisor SSP save/reload
Message-ID: <ZMy6INjzYiVqOKEy@chao-email>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-16-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230803042732.88515-16-weijiang.yang@intel.com>
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CO1PR11MB4993:EE_
X-MS-Office365-Filtering-Correlation-Id: ba4fd198-b800-46d2-0379-08db94c6dbe5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVTIToNSVHR15HpQb33M98tFBMP+2eTWADTVlHKTgVpIjF69oJ2qPiyvJmSOoeIRAixpxOw583l12QPix6vFmjg49q32yOb8VAi4ngBGbhAAubv88EhALMz/Op7C6opSQU+poe437W+rFm1/9dqFzFtpRFSybi3w048vAf3swBPusEtVT1tVFUPCc/OsxhRQVF2xHdYPCAZsGtKbI/OXgEJfb9WdgjxMaV+9Ff/BGHyRky4C/JwR5p5YpecVoRm+jEwdd/Il00IOPHI9WBanosmN+XogiqeFry/Dssd+aa13IYLg8vmjODuA8UaGeAMHJvW06Vf1WjWSbp2BPa/9TmFaAjVkMQh/pH4JvSOrrYh28DFgNmz28KrBV6UQHxxVQ9dbIDSTT3vtOvrMpeoAqBqxts4X4zg/q+wvlIne5vG9Ij1KR18tlTjwA4I8Jgi6Q9MF7gvufWRmKrFxcHQjg9sZY9BZWj9PcqDjkPP8ZaQqhrxdBpgiL1dzh2hRy2CvZ0/OfS4ylpE15j/V6IPJV+z6V8PQZxs11jxgGjodAj+L7InrtO/LXs5QrK3ll0OI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(366004)(376002)(39860400002)(136003)(1800799003)(186006)(451199021)(4744005)(86362001)(41300700001)(2906002)(8936002)(8676002)(6862004)(316002)(33716001)(5660300002)(44832011)(9686003)(6512007)(6506007)(26005)(478600001)(6666004)(82960400001)(6486002)(6636002)(83380400001)(38100700002)(4326008)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?259gZQhB1Mw0fJe6eVCw6GVFQ6ZuPX0bsHIYkMUGzs1CebFMFE5F84CYbloy?=
 =?us-ascii?Q?wz0z0sSU3PNtB0I6cO2DekhHGcUzX9GcuJhwHD+/X7YYfVhgzKwEviyrQBGn?=
 =?us-ascii?Q?b9aivmwKzRDH/CtBgbq0AVzJzIhT9ZRtbPSl9lpmOODKnYO/m+x+deoaDrwN?=
 =?us-ascii?Q?YxvmQ6eK8UQS9AZHUiOddj/9LitCCcXCDJLN26/pkP57uSSjm+PXttIktZE3?=
 =?us-ascii?Q?4jgBeQSYm3KBXmX4MT0PBo4kNVprxnlsTEcYsO0f4YEkVtCRhdM9Y/7E+1/s?=
 =?us-ascii?Q?roLKnCdxAwEdX/kT4w5TpP7e0iK8C/vq27a/J0qH746VlR8Gww8zx82zONz3?=
 =?us-ascii?Q?Bt3OvjSpnDAcB/PJzKVGP0eRFEzCA4PA+NlA7/jYtLczcWD4Ri3vLmvTnCxe?=
 =?us-ascii?Q?Nar/gtIbSgLc7H5nDjyVa4WJbmV2XWQuDWJ0XxLASHfRDTAIKQt1xER2v+8A?=
 =?us-ascii?Q?Rjkz9PwL2+lrIVxithJ+bwpRWMjaBX0SaORrO8UbWAOUS7+fck4Yy/4g8CAD?=
 =?us-ascii?Q?H9l6jZ07WUHk2gRDeee3UKoq2dm3A8Ak+gyBPoollxysx5Ih/SwiGzcq5oPu?=
 =?us-ascii?Q?CeIkOMy/ijlYw0d7fc/vMjUjhuPeY8egk47mbXWfOQuFYuJhyy/R9W6VPnBP?=
 =?us-ascii?Q?9FZIHz0W7pFE/xAf20we++dhZMcRX/63xf+KCHLQLOekq9imxtw7aoVSmu/A?=
 =?us-ascii?Q?RR696zud87Ci0zoQsh7f3OCOT/j/bpndc666GqOcyZ6o6xM0JXk8Bw+GDaLS?=
 =?us-ascii?Q?82qjaDHE2s6FNxR4bCADkyRRHiLvMxqwhxduNbTEQygR8TnnwBsh2Gngxhn/?=
 =?us-ascii?Q?RJFtLJ/j7XVmMcYby6mGfkQXCkGRRHGnB0YQQxATRYFVHOcDlrtxPYAC9S4m?=
 =?us-ascii?Q?iawNij06nr2f7apzdkXx0Gs1fjj8xiLPyaxwE5LjJowYaLBODNAQTKtrWvvh?=
 =?us-ascii?Q?HaICpC2ne6wp80S40IS3xzz8P+STH1IyxmScPjJ6xjXp2nPRLDW35jl3Y13A?=
 =?us-ascii?Q?viEsTYcCMfRSdFBoFDtMzCpf7tap8fnnXUILNz26CbGqwno4Ir02dlVk4XHr?=
 =?us-ascii?Q?/F2XCHPMYECqWCYV9fucilkTB3+efXSjNjF3aDUhbiILBh0SwdPCdI85os9r?=
 =?us-ascii?Q?UA4xMlU0gBShlw5Wiz666xLN226WXniCC+B1Z0NVVhxR5dAp8TFfCV54lTQ9?=
 =?us-ascii?Q?ys1CnXLt5AcfCbnUv6WFlqWn/V09uX05EpdM/RKP/syjjg5j0GztN8Y8ghkG?=
 =?us-ascii?Q?QtSYamp+NstWSIB+cGyGQnhZaQur/09UQhugWdcIOfCfk3yK5Dtf78XE2FLi?=
 =?us-ascii?Q?/oNGnI+ATk9GXtE+DKEKYIH/5TBbdfOLnSFGSPQe2U4Fr1HTkARR+JT/8PRA?=
 =?us-ascii?Q?6kmsIjSlELueiw5EqhilD3XCG0HYFFKMs8W42N0Agz7PB+US7LK3KqlfcsXE?=
 =?us-ascii?Q?nwT87WKqT6EO9ysBcTihJwdWcC4Pehi64JSD07hjht9BwEGNKrPUlfN/RFcM?=
 =?us-ascii?Q?PD85PHifOyJv4/lMPuY6DZRrDc2yljl63i41PNKHYXjDv94H5AMuqxpll2u5?=
 =?us-ascii?Q?Srxuk+902N9Q30qzpDs1wN1tfCs0R6eHntJfc5yk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4fd198-b800-46d2-0379-08db94c6dbe5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 08:43:22.0989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8aXUXGGfUXkzpArmp0PvokpvVQchTItziiNoyeWnCQB/ACslJ4jVYAECCkG6xYMGM0f4+Y26b+JHvR4Q6qgyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 12:27:28AM -0400, Yang Weijiang wrote:
>Make PL{0,1,2}_SSP as write-intercepted to detect whether
>guest is using these MSRs. Disable intercept to the MSRs
>if they're written with non-zero values. KVM does save/
>reload for the MSRs only if they're used by guest.

What would happen if guest tries to use XRSTORS to load S_CET state from a
xsave area without any writes to the PL0-2_SSP (i.e., at that point, writes to
the MSRs are still intercepted)?

>@@ -2420,6 +2432,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> 		else
> 			vmx->pt_desc.guest.addr_a[index / 2] = data;
> 		break;
>+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
>+		if (kvm_set_msr_common(vcpu, msr_info))
>+			return 1;
>+		if (data) {
>+			vmx_disable_write_intercept_sss_msr(vcpu);
>+			wrmsrl(msr_index, data);

Is it necessary to do the wrmsl()?
looks the next kvm_x86_prepare_switch_to_guest() will load PL0-2_SSP from the
caching values.
