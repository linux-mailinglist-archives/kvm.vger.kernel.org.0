Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5087377747B
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbjHJJaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjHJJaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:30:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4FE10C0;
        Thu, 10 Aug 2023 02:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691659813; x=1723195813;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sCzdgxjJdDbmflX9WXB+hLUySwRjTPsGAwOAGStd2zY=;
  b=TxXmoVtf0QKvk46zx4KrxaISHavULUYNMU1c9Il6SUqM5vrcAvl+aluW
   /G81aD4zFiy4C9h7VVYw7mdz4voPyaQTXnxJ78/jb+4g1IPPsaml5twqn
   Q/bqtTuA6IFujcrmEvLMtfZgFgNAOmGWlq0lKglfpi/cNltysxwEJAgTP
   8bJqjWzFvqt3JoZsSRlaBWrLyv/Mx/ki1CaNFMjaXATvh8ZQQQTgr2+Ir
   2POQpOQgAmVpwjkIO0ATAA0GE+L43AF9fO9a9yEtmro6xd4JiTvpG7Xaw
   GT2TGdakX3Sqk73pZmo4CqQVJjiMhdkcPT7LCF2PRnZrhd2zhq03XS7nz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="361488428"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="361488428"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:30:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="709082329"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="709082329"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 10 Aug 2023 02:30:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 02:30:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 10 Aug 2023 02:30:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 10 Aug 2023 02:30:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXK4NYELIPpX3g2XhMb3sqAY99TuRJttlWJgifhk3m++iawv7KuY08X6OOoIotzGFX4zRG/WxD/6X4DUpBaN8IgUc9kmGSn9wU6ZXd8hg1uQEqYiYvwKMeyD2IR6mJ9VhnQj7tqJsgZnDXmu6hLjuzBvwM/pskf53YMrTxZ0l9mt00CFvA2mCSqE0gQaJER9W06H7DyekPsuV17fSBiWkyaFmfVdajS+AelINbFfGVW59FTJjEO53+vStniwdjIAMovp1B/Igtinkx8TjVu6orXQHCSjguY3xIWiw1TX4+HpjHDk6YKjQbuNL3u1QFOyXI2sRB8DJ2zzS1xQ5hQZWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EmrXojfQvjwaz/V4C4Ha6h4+sVwpx/1smSVKyUAlGA=;
 b=CSizrT163FsSd6N24yDCoOj7ihYez4bNgBTOYz/Zz78aQosRyVIRJz3fjUJtwOJwD/nFsim1qjY4FZjcTUf4QnljaE+3J+geRmKwPOnGk9BlPpCZTikKwqSwGLx2uMX7rkcK57ysEu1NDx4KC/xA/OsUGZRWPHCvrA+Z741fclw2bh3e93COpZ3lWKSSurwXUf9Ot1TCN5IyNcdRMADC7u7oGR/vwtHH6ddl7dryLVvk3G9b+nB0gWqz99xkXVRCH/MjVvMMUk6DzybGNT/v+/zVWZ0YhS0aOTXU7kwX6vXdsz8Zy8ONv1FgHJPLr7BmfL/lPY5kmMPrvVAXQKpSHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5971.namprd11.prod.outlook.com (2603:10b6:8:5e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6652.30; Thu, 10 Aug 2023 09:30:09 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.028; Thu, 10 Aug 2023
 09:30:09 +0000
Message-ID: <806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com>
Date:   Thu, 10 Aug 2023 17:29:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
To:     <dave.hansen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        <peterz@infradead.org>, <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rick.p.edgecombe@intel.com>, <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM1jV3UPL0AMpVDI@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0042.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eb22112-40ee-4b08-c8f3-08db998463c8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDVPIrxmE/eHizbeKJ8M+DmYfqHLi9TTFM8cId+4RMshGiHouSd9Ijdgz7aH23VWHPPDDYlWjIFr9vzlQ3TZ1/R/MbG4VuU+DRwlnBOGDnZrKJIHBkLHJx3kvMWqKkQaQG8PfUnW/D7JFSye/jX4HGT6O5Quyr0H3fkNbC0EmkaHdkkwLLqQD8wnr24oFoddNdeAXYMXVPYcA2FCa0fs5UTjj+oLHTssSnSrCMkVEog8lOpibLQGiMT9+8XGBf3SbK3Q2BmqXLwC3XIM3onl+Pcv27EP//cc9HFJ5Y5Q4KNU+QkAXLWyGYxm4CVSTBYI7gOGFhRSg6TM0zP4Bng9qFbE3YH1yBa4Z+w4hrPccLJ7U8gAIq8JT5yfD+k7JFGBdnye0mjlfFKPldtayJWkSBlxQ2L1Q6NNEnM2CtGExulS20GW0yVBnzrbARSBwbgOr734G7/3uKnscfvV82D/zu1q+B6QWyfU+M5HVntQNfJLgCsp4S/eIvhatuDbTDI/r/Jqb+9TdAxHSNetnTh/vNVka8zAjsZID6MRcjBj3c3AqZmTjudMadCNlhGfydH8a4MTAjtJot5VLAZg6rl8eosA0qk2RK3Do5f2hIkciNtur3ntNLnwbJt1gTHky9ep5JMGECfWZrPs2Sn2wodpQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199021)(186006)(1800799006)(30864003)(478600001)(110136005)(2616005)(6506007)(83380400001)(26005)(31696002)(53546011)(86362001)(82960400001)(38100700002)(2906002)(6486002)(6512007)(6666004)(36756003)(66556008)(5660300002)(4326008)(66476007)(66946007)(41300700001)(316002)(8676002)(8936002)(31686004)(66899021)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekM3L0ZsV3VzMzNtN0JkYzIveXNDVU5KZTFDM013NG9Zd2QwYmszTU11ak5w?=
 =?utf-8?B?VmZDYkJqTFQvSUxiNEU1YjdtNDRhYjRoWlRBc2pybVBmSlg2dlkxcHZnYlM1?=
 =?utf-8?B?VEZDZ3lFQSs5OEFMZE1EckFWNWxkSlZrQ1dJUnBNWDNnU1JBeUVCK1pjVjZD?=
 =?utf-8?B?SU03NEp2OXV2cGFyNG11U2l4UkZGVVJQaUEvSkJEdDBLdFBnRWV1enc3UkVC?=
 =?utf-8?B?SVVpL3ovQnFvS3ZSN3VvSFZTVmJVcWRjUHBTa1hrQ2gyZzVndFdpZmlBMmVN?=
 =?utf-8?B?UURreEFXcCtVNUxoUk1HN29md2JXdTkxa1lnWUxpNTBVWk1oS3psRnF5OGo5?=
 =?utf-8?B?TStTMkhQSCtWdlliMW03dW90Sko0YXIva3o0aloxMDIwS0habjJWN2ZrZHNF?=
 =?utf-8?B?azc1REt3cHd4UW0wQ25RVmlGeWkyMlNLcXByVEdUc1d6OEk1bmxGSkwwTkJX?=
 =?utf-8?B?K1JQRkhweTJRTFQzZnJWYzNOakg1Z2FkOUROelVYa21HZEdJSHNHbmExUUpq?=
 =?utf-8?B?NFkxTEY3QmxnenpjdW9ZNG8zOHdUZ0xVdWEwazc0NTdnV1d2b0NMeU5WK3ly?=
 =?utf-8?B?a1k1R0ZkaDJXQmJCNlA5VDlMNC9ncklhYXFCNHJUSm5PSVJmaDMwQmRMSDVB?=
 =?utf-8?B?S1kweVFmdDJ0RDFvWFBiOXdEaThJWGEvTTQ3OFcrNXJybzk5MWpIU2haRGZ6?=
 =?utf-8?B?QmdZVFBKM0ZtYTFwOThWYnBXOXNrc1hkd2tUQ21IdFcrK0JUWGZoSTFIZFA1?=
 =?utf-8?B?TXF3QWgwdzBvVjkwZit1QllPZStaQUdwTXNlQkdlMExRTlRYMVJFRWRCQTAz?=
 =?utf-8?B?czVKaUIwS2E2TW84Y095WGFFbTlXN2YzTEVPZm1rVlB3bFpud3MvSGdJOXp1?=
 =?utf-8?B?dWVpSDRFTWJ5MzVXQkE1VlJCZ2dVdVJRY0syZ3JTNHJsamJrWWd3K0hSejVI?=
 =?utf-8?B?NXpZRmRiTHBManI2OW0wOE8vNFRtNVNJUkJUVEl1c3V2SEcvOFpRak9saVF4?=
 =?utf-8?B?UDMrb1I1NmIzbkxQYjlLVi93c3NoYm9oSGtZaVFKMzBYMmNGK0xQQm9xa0N5?=
 =?utf-8?B?dlZkbU15LzBwTDcrclF4ZjJPcUl1b2paa3FoK3lpdGxPMUR2Yks1YjhmT2c4?=
 =?utf-8?B?T2ZsaTA2aVcvN2drMEwxSUtFT0JTT1VreC9yVitSOGE3b051VDg1ZHJwUUR4?=
 =?utf-8?B?L2RMSWtybGI3djZjSjVOZ3d4dlZvSm1VSmRYQUdCTTFlejdNbzR4Z1N4MXdB?=
 =?utf-8?B?Lys4TlduNkpXbkJ0aFJ0a0xUSGU5Y3FoSTM2d2pGU3hXNDcyTWJmK0t5azJS?=
 =?utf-8?B?OTlITDRvcVdGbCtwanRZUllYUDNRUGdEYk0wWWRJb2xKL0YwNzM4akRwWW1r?=
 =?utf-8?B?QUhUejB0R3FVNWk1ZjYvZm5VU3pQbUpCKzM3RUlxbHhvbktxclZnMDhvS3Uv?=
 =?utf-8?B?Z1VRUWFrZ3gyT2g2anQ3TjgvR1FxeFl1anNzazA5WjVqaC9HQk0xME9tcUk1?=
 =?utf-8?B?cEFnaDFUMjZTVEswaDdWK3NyaFdsMzBaL0JlcDhhUFcybWMxdXYvR1hXRkpx?=
 =?utf-8?B?ZmlUbGJLNDE1MlJiY0VjU0ZVd295Rnh5WkJobkN6eUI2Q0JCbTFHS1pqRFJs?=
 =?utf-8?B?TTR0RU1pV0lxZDlPSkJjZEJpMDRVQks4TDNSbEhOUzNRSDJFRWs0L1MzQVVa?=
 =?utf-8?B?Qnp3ZjFwL1RTRHQ4NDk2b09PSWdmeGtleU5qcFg0L0gyQVl5d3Y0L0o1UHBT?=
 =?utf-8?B?dnJ2ZXlTTm1WN2wrakFZU1RiUzByakt5aVlCdHZSWm9HK1IxUFYvUzA1WEJ4?=
 =?utf-8?B?dFZ2Wnk0dTgzZnhvem9EbndTcElaNHZqbi80SWJjbWlIQXh2cWw3WEhlUGpE?=
 =?utf-8?B?Tm5DbndiODBCb0MyaUlNN2pBU3ovcVBxdys2Y3JIMi9WZXFLakwzejY1S0Qw?=
 =?utf-8?B?UDRCRTVZa3JlM2FraHlPamZ1bTlDUGVqdUxYU1ZFc25maXMrdVdXeklxcGwv?=
 =?utf-8?B?WHNVay9rdDFrWUxDUnBtQ3RFZHcvMVR6T1VyZFJLRzUzZmp6dVU4UkV6L3pz?=
 =?utf-8?B?bGduL2NTWlN5dFVDVWQ0MlJJWG81VjM4dnlaTnFGN0J1OGUzNVN0OHRsdDZM?=
 =?utf-8?B?SzhlVGJwQVhVWGVoM05WODlRODZtYXQxT2k2TjgxZUgrMnExbmRSc1ZDQ2tq?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb22112-40ee-4b08-c8f3-08db998463c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2023 09:30:09.4307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ugPVdOrKYItqkiW3FKk4UMV4yWF49IenpU50IQ+Snwr9HcOLZ5VA+1oSlcxXeGYlKFuRwGeEwpOZ0ez6G0gmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5971
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Dave, Thomas and Peter,

I would like to connect you to this discussion loop about CET supervisor states support
in kernel so that you may directly talk to KVM maintainers, thanks!
The discussion background/problem/solution as below:

Background:
When KVM enumerates shadow stack support for guest in CPUID(0x7, 0).ECX[bit7],
architecturally it claims both SS user and supervisor mode are supported. Although
the latter is not supported in Linux, but in virtualization world, the guest OS could
be non-Linux system, so KVM supervisor state support is necessary in this case.
Two solutions are on the table:
1) Enable CET supervisor support in Linux kernel like user mode support.
2) Enable support in KVM domain.

Problem:
The Pros/Cons for each solution(my individual thoughts):
In kernel solution:
Pros:
- Avoid saving/restoring 3 supervisor MSRs(PL{0,1,2}_SSP) at vCPU execution path.
- Easy for KVM to manage guest CET xstate bits for guest.
Cons:
- Unnecessary supervisor state xsaves/xrstors operation for non-vCPU thread.
- Potentially extra storage space(24 bytes) for thread context.

KVM solution:
Pros:
- Not touch current kernel FPU management framework and logic.
- No extra space and operation for non-vCPU thread.
Cons:
- Manually saving/restoring 3 supervisor MSRs is a performance burden to KVM.
- It looks more like a hack method for KVM, and some handling logic seems a bit awkward.

KVM maintainers request it supported in kernel instead of KVM to make things streamlined.

We'd like to hear your voice of in kernel solution, favor vs. objection?
Any important points we omitted?
Appreciated!

Solution:
Below is the supervisor state enabling patch in kernel, not include Sean's suggestion below.
=====================================================================
 From 53f9890c76e4163a0fead3afe198d0c17136120e Mon Sep 17 00:00:00 2001
From: Yang Weijiang <weijiang.yang@intel.com>
Date: Thu, 10 Aug 2023 00:10:55 -0400
Subject: [RFC PATCH] x86: fpu: Enable CET supervisor state support

Enable CET supervisor state support within current FPU states management
framework. CET shadow stack feature is enabled with CPUID(0x7,0).ECX[bit7],
if the bit is set, archchtectually both user and supervisor SHSTK should
be supported, i.e., when KVM enumerates the feature bit to guest, it claims
both modes are supported by the VMM.

The user mode SHSTK XSAVE states comprise of IA32_{U_CET,PL3_SSP},
and supervisor mode states inlude IA32_PL{0,1,2}_SSP. The xstate support
for the former is enclosed in native user mode shadow stack series, but
the latter is not supported yet.

KVM is going to support guest shadow stack which means guest's supervisor
shadow stack states should also be well managed by VMM.

To make KVM fully support guest shadow stack states, there're at least two
approaches, one is to enable supervisor xstate bit in kernel, which is
straightforward and can fit well in all cases. The alternative is to enable
the support within KVM domain and manually save/restore the states per vCPU
thread, i.e., introduce addtional WRMSR/RDMSR at vCPU execution path.

This patch doesn't optimize CET supervisor state management, just follow
the implementation of user mode state support.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
  arch/x86/include/asm/fpu/types.h  | 14 ++++++++++++--
  arch/x86/include/asm/fpu/xstate.h |  6 +++---
  arch/x86/kernel/fpu/xstate.c      |  6 +++++-
  3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index eb810074f1e7..c6fd13a17205 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -116,7 +116,7 @@ enum xfeature {
         XFEATURE_PKRU,
         XFEATURE_PASID,
         XFEATURE_CET_USER,
-       XFEATURE_CET_KERNEL_UNUSED,
+       XFEATURE_CET_KERNEL,
         XFEATURE_RSRVD_COMP_13,
         XFEATURE_RSRVD_COMP_14,
         XFEATURE_LBR,
@@ -139,7 +139,7 @@ enum xfeature {
  #define XFEATURE_MASK_PKRU             (1 << XFEATURE_PKRU)
  #define XFEATURE_MASK_PASID            (1 << XFEATURE_PASID)
  #define XFEATURE_MASK_CET_USER         (1 << XFEATURE_CET_USER)
-#define XFEATURE_MASK_CET_KERNEL       (1 << XFEATURE_CET_KERNEL_UNUSED)
+#define XFEATURE_MASK_CET_KERNEL       (1 << XFEATURE_CET_KERNEL)
  #define XFEATURE_MASK_LBR              (1 << XFEATURE_LBR)
  #define XFEATURE_MASK_XTILE_CFG                (1 << XFEATURE_XTILE_CFG)
  #define XFEATURE_MASK_XTILE_DATA       (1 << XFEATURE_XTILE_DATA)
@@ -264,6 +264,16 @@ struct cet_user_state {
         u64 user_ssp;
  };

+/*
+ * State component 12 is Control-flow Enforcement supervisor states
+ */
+struct cet_supervisor_state {
+       /* supervisor ssp pointers  */
+       u64 pl0_ssp;
+       u64 pl1_ssp;
+       u64 pl2_ssp;
+};
+
  /*
   * State component 15: Architectural LBR configuration state.
   * The size of Arch LBR state depends on the number of LBRs (lbr_depth).
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index d4427b88ee12..3b4a038d3c57 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -51,7 +51,8 @@

  /* All currently supported supervisor features */
  #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
-                                           XFEATURE_MASK_CET_USER)
+                                           XFEATURE_MASK_CET_USER | \
+ XFEATURE_MASK_CET_KERNEL)

  /*
   * A supervisor state component may not always contain valuable information,
@@ -78,8 +79,7 @@
   * Unsupported supervisor features. When a supervisor feature in this mask is
   * supported in the future, move it to the supported supervisor feature mask.
   */
-#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT | \
- XFEATURE_MASK_CET_KERNEL)
+#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT)

  /* All supervisor states including supported and unsupported states. */
  #define XFEATURE_MASK_SUPERVISOR_ALL (XFEATURE_MASK_SUPERVISOR_SUPPORTED | \
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 4fa4751912d9..fc346c7c6916 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -51,7 +51,7 @@ static const char *xfeature_names[] =
         "Protection Keys User registers",
         "PASID state",
         "Control-flow User registers",
-       "Control-flow Kernel registers (unused)",
+       "Control-flow Kernel registers",
         "unknown xstate feature",
         "unknown xstate feature",
         "unknown xstate feature",
@@ -74,6 +74,7 @@ static unsigned short xsave_cpuid_features[] __initdata = {
         [XFEATURE_PKRU]                         = X86_FEATURE_PKU,
         [XFEATURE_PASID]                        = X86_FEATURE_ENQCMD,
         [XFEATURE_CET_USER]                     = X86_FEATURE_SHSTK,
+       [XFEATURE_CET_KERNEL]                   = X86_FEATURE_SHSTK,
         [XFEATURE_XTILE_CFG]                    = X86_FEATURE_AMX_TILE,
         [XFEATURE_XTILE_DATA]                   = X86_FEATURE_AMX_TILE,
  };
@@ -278,6 +279,7 @@ static void __init print_xstate_features(void)
         print_xstate_feature(XFEATURE_MASK_PKRU);
         print_xstate_feature(XFEATURE_MASK_PASID);
         print_xstate_feature(XFEATURE_MASK_CET_USER);
+       print_xstate_feature(XFEATURE_MASK_CET_KERNEL);
         print_xstate_feature(XFEATURE_MASK_XTILE_CFG);
         print_xstate_feature(XFEATURE_MASK_XTILE_DATA);
  }
@@ -347,6 +349,7 @@ static __init void os_xrstor_booting(struct xregs_state *xstate)
          XFEATURE_MASK_BNDCSR |                 \
          XFEATURE_MASK_PASID |                  \
          XFEATURE_MASK_CET_USER |               \
+        XFEATURE_MASK_CET_KERNEL |             \
          XFEATURE_MASK_XTILE)

  /*
@@ -547,6 +550,7 @@ static bool __init check_xstate_against_struct(int nr)
         case XFEATURE_PASID:      return XCHECK_SZ(sz, nr, struct ia32_pasid_state);
         case XFEATURE_XTILE_CFG:  return XCHECK_SZ(sz, nr, struct xtile_cfg);
         case XFEATURE_CET_USER:   return XCHECK_SZ(sz, nr, struct cet_user_state);
+       case XFEATURE_CET_KERNEL: return XCHECK_SZ(sz, nr, struct cet_supervisor_state);
         case XFEATURE_XTILE_DATA: check_xtile_data_against_struct(sz); return true;
         default:
                 XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
--
2.27.0




On 8/5/2023 4:45 AM, Sean Christopherson wrote:
> [...]
> Pulling back in the justification from v3:
>
>   the Pros:
>    - Super easy to implement for KVM.
>    - Automatically avoids saving and restoring this data when the vmexit
>      is handled within KVM.
>
>   the Cons:
>    - Unnecessarily restores XFEATURE_CET_KERNEL when switching to
>      non-KVM task's userspace.
>    - Forces allocating space for this state on all tasks, whether or not
>      they use KVM, and with likely zero users today and the near future.
>    - Complicates the FPU optimization thinking by including things that
>      can have no affect on userspace in the FPU
>
> IMO the pros far outweigh the cons.  3x RDMSR and 3x WRMSR when loading host/guest
> state is non-trivial overhead.  That can be mitigated, e.g. by utilizing the
> user return MSR framework, but it's still unpalatable.  It's unlikely many guests
> will SSS in the *near* future, but I don't want to end up with code that performs
> poorly in the future and needs to be rewritten.
>
> Especially because another big negative is that not utilizing XSTATE bleeds into
> KVM's ABI.  Userspace has to be told to manually save+restore MSRs instead of just
> letting KVM_{G,S}ET_XSAVE handle the state.  And that will create a bit of a
> snafu if Linux does gain support for SSS.
>
> On the other hand, the extra per-task memory is all of 24 bytes.  AFAICT, there's
> literally zero effect on guest XSTATE allocations because those are vmalloc'd and
> thus rounded up to PAGE_SIZE, i.e. the next 4KiB.  And XSTATE needs to be 64-byte
> aligned, so the 24 bytes is only actually meaningful if the current size is within
> 24 bytes of the next cahce line.  And the "current" size is variable depending on
> which features are present and enabled, i.e. it's a roll of the dice as to whether
> or not using XSTATE for supervisor CET would actually increase memory usage.  And
> _if_ it does increase memory consumption, I have a very hard time believing an
> extra 64 bytes in the worst case scenario is a dealbreaker.
>
> If the performance is a concern, i.e. we don't want to eat saving/restoring the
> MSRs when switching to/from host FPU context, then I *think* that's simply a matter
> of keeping guest state resident when loading non-guest FPU state.
>
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 1015af1ae562..8e7599e3b923 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -167,6 +167,16 @@ void restore_fpregs_from_fpstate(struct fpstate *fpstate, u64 mask)
>                   */
>                  xfd_update_state(fpstate);
>   
> +               /*
> +                * Leave supervisor CET state as-is when loading host state
> +                * (kernel or userspace).  Supervisor CET state is managed via
> +                * XSTATE for KVM guests, but the host never consumes said
> +                * state (doesn't support supervisor shadow stacks), i.e. it's
> +                * safe to keep guest state loaded into hardware.
> +                */
> +               if (!fpstate->is_guest)
> +                       mask &= ~XFEATURE_MASK_CET_KERNEL;
> +
>                  /*
>                   * Restoring state always needs to modify all features
>                   * which are in @mask even if the current task cannot use
>
>
> So unless I'm missing something, NAK to this approach, at least not without trying
> the kernel FPU approach, i.e. I want somelike like to PeterZ or tglx to actually
> full on NAK the kernel approach before we consider shoving a hack into KVM.

