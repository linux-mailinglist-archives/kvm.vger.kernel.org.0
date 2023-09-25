Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CB47ACD10
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 02:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjIYA0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 20:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjIYA0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 20:26:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB02C4;
        Sun, 24 Sep 2023 17:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695601596; x=1727137596;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CMx4RDnvSGMh+23koW2Zr9nBpjLyJRWILuLnWnSpx5Y=;
  b=D1Zm973H/Yn1Pe9vVd8kWP1sv2fIFaYZc3CHmhMUGLr1fTxKl05+Ctjj
   dlnPfSeXsvBpX4lEt8jyr88l/biwtxz/FLEnyuyNyX+9Jdu9MTcOeGmgj
   CjWnIeBniI9vEBMSc/bpFRrJ2GFU1HmpEPMqSDRj6LYfhmBd1hKOVI7/k
   Cxy1MSglo16oME4IiDUJSaI1Hw4nDCvzdtPi7E6vekPrLjM1nlLFF0vWH
   6dTLQ5Oh3gImnUAcL055Tp3EnJvvik+S/3Tbojd4Ko8FErh5nIeSBoNTK
   +u6hEJZwm0brOaj84fdqypg6gfq7dpF9U6dTVGIBSgB/nb66l+4fE7jle
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="412070768"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="412070768"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 17:26:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="751483010"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="751483010"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2023 17:26:36 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 17:26:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 24 Sep 2023 17:26:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 24 Sep 2023 17:26:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dot6jzjNQGPcMuRerEpXX+IBo1aEm+X/9sCEb8Ysne3VLi458pADnn/owoTi2AR6cOBt06fzfo5eEFHEafnQ2p3WovZ+i/ZvDcV/frLBsDgbceG3ld/NO6tk4knTjFBB49b+Hn7yo/xQvcfgNnTLMryFTygMaFYMYBISvbL7lc4ZoTYKUi+O+98dhEPKk94OdZwbSiVnjQ2DEs+TIj+mwwhiZ1BCBhMDwYgYRECTgLVR7IsKTHY950U7MKbLCX9+UkuaEPT40ZP0GrSBb7/KHPlE6HKrX+ASvT6n1FSC1m3OTLHKXid2T/IyWOKanwqmPj4FOsKBXJ5aMwlx53W9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sA/VZh18vFzsIig1x3H2NnH66j05IKQF5i9eTGu77c=;
 b=l+hvf5yTBKRyXDOkrz4uuTgCBzpaag6envYoiVhzlqNKkUMP0lxp/98K8gTK8V2C8lHb3ESwhhMC2ELf4eP/Zq2PT7G2hyu0hjfyChU7tBn/bzExzCFg4op+jgIV13AGdpro4KscO6p7xYUZAq5qlJWBk2KjMsIVXhLrtywE68oVTmuYEQEykZaEPy3zSf1tIFzO9RXjdAJNxF+Prt3FwFUG/efPGDehCLs07brE2B3+OqOR7ZmBSlIPBK4kj0FD7eFDhJGiAxyW6ScXPi5zCY6TEMNzR8IOFCvwLz7EGlvNG7fLCH/bbcd3tgJQcOPfpdIXSHhVv3bUIO+oqc+yRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MN6PR11MB8102.namprd11.prod.outlook.com (2603:10b6:208:46d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Mon, 25 Sep
 2023 00:26:32 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6813.018; Mon, 25 Sep 2023
 00:26:32 +0000
Message-ID: <b6658931-7607-36e8-ad92-41899fce531b@intel.com>
Date:   Mon, 25 Sep 2023 08:26:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 23/25] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To:     kernel test robot <oliver.sang@intel.com>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <chao.gao@intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <202309242050.90b36814-oliver.sang@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <202309242050.90b36814-oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0023.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MN6PR11MB8102:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b9f241-e963-496c-bf33-08dbbd5e118c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7bDx1iB6tePmyhO4vGDunXuLsj9ETBBqtDfrm/Z0HmjeI6fodOrUfieH5pZj/ui8uWsQahrYLuLCcI0pJhzdhTw026Ea2gf0rZCJB4C8o/tTvPvfEUOTVYoiV/15gUMfDqtiXnGGtz3kJ/2QcDzgSyMECv3dL2PwrFYomDnb2xE/L1JKwDXbHgK1lhzxigysWDpbMDeGoj7EwVB/JF43CfmEADRL2Vn0JjM6Eldw8s85nuVmdEXYCCw9/GPplYHTWL46NkFJyvPGoo1YOoNUO6D7/b+3U1ZbMGH2g4T6JMEwMZc6pj/J2af6Slr4QJPF6G8EUxEwZ6XQQiLce2oGJ2a1eEEk26Dk77WDKli4iho3x6JAjlGg2x3Y2CUoTAUZ27mrEYqN51FkLqBTOR8a0WyGPsnMNcVxC4PqnAAAfUqt51wwP2dlyArP5tISuxrw20agFvAnCrNO/nqhVlfPSRWHOyayS0eRe1BymzR/A5a3O8JZx98ttBMtvguSD8nrEEdnu30+l+rzB8ayYO5qvZvyugZjqx8dA7ab+BtuyquQpFJf/9F99KJPoqx5iXCU5+Y3DPYzalzpQt6SQumlMVwq/WDyMLaYsynuc68LSGwkRzyoPcNXAw001q64qJG9ZOr+0PR2TsA6XYtnvPnYGCLuYpPcKtPsGMf8Fa2IlI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(136003)(366004)(376002)(230922051799003)(451199024)(1800799009)(186009)(82960400001)(478600001)(966005)(86362001)(41300700001)(31696002)(38100700002)(8936002)(5660300002)(6862004)(4326008)(2906002)(8676002)(66946007)(66556008)(37006003)(316002)(83380400001)(53546011)(31686004)(36756003)(26005)(6636002)(66476007)(2616005)(6512007)(45080400002)(6506007)(6666004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REhTcjdVWlRZSSsrQS82SkNNcmpVaGVCUlM0bS9VczBpMW5aSHhRRVVvY0c0?=
 =?utf-8?B?Wlovc2IrR2NNaU5YSkFTSHlEMWxwbVZZTFRSaEFxckNxZ2wzeE9TQU1rRjNu?=
 =?utf-8?B?TW1tUWg3VVh4M1RyM3RSVzNNZ2VZeUxXV2hqR3M3aFlkNkIzako0NkF0bmRq?=
 =?utf-8?B?b3QwRjFtQ1U5UUU2MXVPcHlYK1V4S3pVc3BKSjFtRytWc0xnbDJyVFppd1pZ?=
 =?utf-8?B?dlpLWGR3NEI3OGlZcEhzbldnc3hMQVg3d1RJMTBWZlBlbWtIZ3BrRlF3STRD?=
 =?utf-8?B?by9lQ1NVZ1ExSzNIdDJjUlE2b3VVeUFLUmRIY1ArTUs3bmFHNjRwbHV5dnZX?=
 =?utf-8?B?ZFlabldFR3NuNVIxdzZxZXV5ZmJMZ0lBUERsSmpGSEplb0xvSmlxNUFzUXpo?=
 =?utf-8?B?TGxWMjZKV1E4UzQ3Yjg0U3BWUXVLLzB5a1NyU0ZZNnBjQlEyVkJaTEg0M3Nl?=
 =?utf-8?B?Z2FEVWZKa1RVc0tLN2NRbDBXdUJTZmpTWmYrZUpjZVBUZWFIdHRpQitiVUJP?=
 =?utf-8?B?NENYSDFDanA0S2Y4SjhPblI0QWtpS2Q1d2NVVUdYZ1V0M3hMU01CQ0x1SkQv?=
 =?utf-8?B?OThLdW10MkZaYTQ1R1R4VFJCZWZNKzJuZ2I0S0VwbGVZc1BNRXJUcXl0Tjh1?=
 =?utf-8?B?aEhhQzdubGJ5MG5pRjNCZTJiSXhsZ3NqZXNINStqWjdhR002aVU5MXduaC9l?=
 =?utf-8?B?dFBSS0VvK1dSWU5kNXpFcXUwSVc2UFBlSDFKT21WR21YdngvNFVGUXhuTXV0?=
 =?utf-8?B?TENEMmhEd3R1Wnp3MGx2bkhwNGhaTDJwdDNSK0FraFdyQXAvaHdVUXdjeTZZ?=
 =?utf-8?B?U2JJNWtLMXF3TUlVaHFDeVRmOVlmSzIyVE5XdGlva2ExVHpSTmp2d1ByQXc1?=
 =?utf-8?B?ZlU0Rm9vQUxJOU1SOFZxMnhQcTJXTFhKZXRlZXdOc3dTMjZFcWQ1TldYMnQ4?=
 =?utf-8?B?TmRGYVNOWEplaUdFZHlPeWFxNkRlaTdXTVFkQU9Iem53cjkzRW9GbVpGSGg5?=
 =?utf-8?B?OFN1dG9aaHFRL3ZzQnZEbWJvc3ZWRTdmNU1WMHRub3drbHU4b3JDZzBYT0xl?=
 =?utf-8?B?cTR3bDlHNTUxZnRVK3JkMFcyUWprUnArTFlVRThrRzNqL0Z5SW9zZ2hvUThK?=
 =?utf-8?B?dk5VWUkyVS9YSWNzVmdyeWhFeGQwZUZnckxHNWR4dzd0UzdneHBQNy9UUG1k?=
 =?utf-8?B?ZVh4aU9XZ1VOc1lQTzR4RVZlOE0zYXQyemJtM0hOVWF2WE1aanZadmNnd29C?=
 =?utf-8?B?b3BMcWszOFFlb0s0akF2SXZZRXM4YklqUTI4SjRMNzA1NzNwSW9WdHlFV2lU?=
 =?utf-8?B?R0w0bDEzSFZTM3JqVFJvaEZwaFZTdmpSa09IRVd0a1p5dDg2eXByNk1jL3BW?=
 =?utf-8?B?RXNTcFhFdkJiMHRwTkxlVWFUQXJQNGtEREE3enhIMERLekhVUGJIR2Y4ZDJo?=
 =?utf-8?B?RmNRdi9DVEtxQkRTb2xSenhmUVdnSXdWWVNHbjFkbHExbmhhN2Fib3A2VkxQ?=
 =?utf-8?B?RkZ0WmZCME0ya0xhMnppTStvSHR2WjljNXNTSTVVUjJRVnVNS25DUm9kWUd5?=
 =?utf-8?B?NTFHSFFkYWgyQWhLMlU3TlNVS1VmTVJJNzdNaCt0MzdBR3MweWFKeDBFVFlQ?=
 =?utf-8?B?bjVXeHdZN0xxUm1xM241Vm4vdjJlYjMxREQ1WlRFajYrWGo5eDBqOFNXLzFm?=
 =?utf-8?B?Z1hJb3dqQ2EvQU5WNnk1RDE4UVRGampJRFZnQWRFY0ZFeStZcmt4WURvUkZQ?=
 =?utf-8?B?OXNNM1p2L2lGUGhVWDBtZFE3QlFjRUlUTkJTV0FKY2tiN2R6ZVRIVzdDWmRl?=
 =?utf-8?B?dWx5T3pvQWQzOVRoNWZ1U2ExakpCdDNHdEJ2Y3l3K3BkY1JtMFVCYnR2clVq?=
 =?utf-8?B?QWFzUXgzcFJSVTZObmVnRnd0LzRJakhrVVhnMzBaYlFrVUVPdWxOREtRVHRo?=
 =?utf-8?B?RVE3dmFndFk3YnkvUGNJS1Jsb2k0Qk44M256Ny9DWFFvR09ab2xmMkp3TnFq?=
 =?utf-8?B?STdQRk91aU5hQWthNGF1NjA0aitiQXFJS2JLWlI2WGZZWVg0bTg4T0ZjZTVo?=
 =?utf-8?B?QUlyczJuVXplNTVwRXdrRzc5OFF1ckY5VytHZndyL3haa2gvUTBOVGZXN1Q2?=
 =?utf-8?B?OWFSbThOUWRyaGpSZmhDM2QzWUladDNUb3l5MmRBbVFHdUZ4dUVBdTV5RXo0?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b9f241-e963-496c-bf33-08dbbd5e118c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 00:26:32.4460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pTj1m2w6x6RXD1TfueaPy/MFwEsp2JQ0/lIDAGACZugK9Xkvjh/aOGnivODD7DrF8DMznvCHzkGO4Hoi4mhag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8102
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


It's due to lack of capability check, I will fix the calltrace in next verison.

On 9/24/2023 9:38 PM, kernel test robot wrote:
>
> Hello,
>
> kernel test robot noticed "WARNING:at_arch/x86/kvm/vmx/vmx.c:#vmwrite_error[kvm_intel]" on:
>
> commit: 68d0338a67df85ab18482295976e7bd873987165 ("[PATCH v6 23/25] KVM: x86: Enable CET virtualization for VMX and advertise to userspace")
> url: https://github.com/intel-lab-lkp/linux/commits/Yang-Weijiang/x86-fpu-xstate-Manually-check-and-add-XFEATURE_CET_USER-xstate-bit/20230914-174056
> patch link: https://lore.kernel.org/all/20230914063325.85503-24-weijiang.yang@intel.com/
> patch subject: [PATCH v6 23/25] KVM: x86: Enable CET virtualization for VMX and advertise to userspace
>
> in testcase: kvm-unit-tests-qemu
> version:
> with following parameters:
>
>
>
>
> compiler: gcc-12
> test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory
>
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202309242050.90b36814-oliver.sang@intel.com
>
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20230924/202309242050.90b36814-oliver.sang@intel.com
>
>
>
> [  271.856711][T15436] ------------[ cut here ]------------
> [  271.863011][T15436] vmwrite failed: field=682a val=0 err=12
> [  271.869458][T15436] WARNING: CPU: 117 PID: 15436 at arch/x86/kvm/vmx/vmx.c:444 vmwrite_error+0x16b/0x2e0 [kvm_intel]
> [  271.880940][T15436] Modules linked in: kvm_intel kvm irqbypass btrfs blake2b_generic xor raid6_pq zstd_compress libcrc32c sd_mod t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 sg intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha512_ssse3 rapl intel_cstate ipmi_ssif ahci ast libahci mei_me drm_shmem_helper intel_uncore dax_hmem ioatdma joydev drm_kms_helper acpi_ipmi libata mei intel_pch_thermal dca wmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad fuse drm ip_tables [last unloaded: irqbypass]
> [  271.939752][T15436] CPU: 117 PID: 15436 Comm: qemu-system-x86 Not tainted 6.5.0-12553-g68d0338a67df #1
> [  271.950090][T15436] RIP: 0010:vmwrite_error+0x16b/0x2e0 [kvm_intel]
> [  271.957256][T15436] Code: ff c6 05 f1 4b 82 ff 01 66 90 b9 00 44 00 00 0f 78 c9 0f 86 e0 00 00 00 48 89 ea 48 89 de 48 c7 c7 80 1c d9 c0 e8 c5 b7 c4 bf <0f> 0b e9 ae fe ff ff 48 c7 c0 a0 6f d9 c0 48 ba 00 00 00 00 00 fc
> [  271.978720][T15436] RSP: 0018:ffa000000e117980 EFLAGS: 00010286
> [  271.985599][T15436] RAX: 0000000000000000 RBX: 000000000000682a RCX: ffffffff82216eee
> [  271.994345][T15436] RDX: 1fe2200403fd57c8 RSI: 0000000000000008 RDI: ffa000000e117738
> [  272.003044][T15436] RBP: 0000000000000000 R08: 0000000000000001 R09: fff3fc0001c22ee7
> [  272.011865][T15436] R10: ffa000000e11773f R11: 0000000000000001 R12: ff110011b12a4b20
> [  272.020632][T15436] R13: 0000000000000000 R14: 0000000000000000 R15: ff110011b12a4980
> [  272.029340][T15436] FS:  00007f79fd975700(0000) GS:ff1100201fe80000(0000) knlGS:0000000000000000
> [  272.039141][T15436] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  272.046484][T15436] CR2: 00007f79e8000010 CR3: 00000010d23c0003 CR4: 0000000000773ee0
> [  272.055167][T15436] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  272.063980][T15436] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  272.072749][T15436] PKRU: 55555554
> [  272.076985][T15436] Call Trace:
> [  272.080947][T15436]  <TASK>
> [  272.084650][T15436]  ? __warn+0xcd/0x260
> [  272.089420][T15436]  ? vmwrite_error+0x16b/0x2e0 [kvm_intel]
> [  272.096014][T15436]  ? report_bug+0x267/0x2d0
> [  272.101163][T15436]  ? handle_bug+0x3c/0x70
> [  272.106130][T15436]  ? exc_invalid_op+0x17/0x40
> [  272.111483][T15436]  ? asm_exc_invalid_op+0x1a/0x20
> [  272.117132][T15436]  ? llist_add_batch+0xbe/0x130
> [  272.122685][T15436]  ? vmwrite_error+0x16b/0x2e0 [kvm_intel]
> [  272.129113][T15436]  vmx_vcpu_reset+0x2382/0x30b0 [kvm_intel]
> [  272.135741][T15436]  ? init_vmcs+0x7230/0x7230 [kvm_intel]
> [  272.141988][T15436]  ? irq_work_sync+0x8a/0x1f0
> [  272.147302][T15436]  ? kvm_clear_async_pf_completion_queue+0x2e6/0x4c0 [kvm]
> [  272.155191][T15436]  kvm_vcpu_reset+0x8cc/0x1080 [kvm]
> [  272.161154][T15436]  kvm_arch_vcpu_create+0x8c5/0xbd0 [kvm]
> [  272.167584][T15436]  kvm_vm_ioctl_create_vcpu+0x4be/0xe20 [kvm]
> [  272.174297][T15436]  ? __alloc_pages+0x1d5/0x440
> [  272.179723][T15436]  ? kvm_get_dirty_log_protect+0x5f0/0x5f0 [kvm]
> [  272.186757][T15436]  ? __alloc_pages_slowpath+0x1cf0/0x1cf0
> [  272.194079][T15436]  ? do_user_addr_fault+0x26c/0xac0
> [  272.199837][T15436]  ? mem_cgroup_handle_over_high+0x570/0x570
> [  272.206405][T15436]  ? _raw_spin_lock+0x85/0xe0
> [  272.211721][T15436]  ? _raw_write_lock_irq+0xe0/0xe0
> [  272.217414][T15436]  kvm_vm_ioctl+0x939/0xde0 [kvm]
> [  272.223014][T15436]  ? __mod_memcg_lruvec_state+0x100/0x220
> [  272.229278][T15436]  ? kvm_unregister_device_ops+0x90/0x90 [kvm]
> [  272.235978][T15436]  ? __mod_lruvec_page_state+0x1ad/0x3a0
> [  272.242092][T15436]  ? perf_trace_mm_lru_insertion+0x7c0/0x7c0
> [  272.248627][T15436]  ? folio_batch_add_and_move+0xc1/0x110
> [  272.254832][T15436]  ? do_anonymous_page+0x5e2/0xc10
> [  272.260431][T15436]  ? up_write+0x52/0x90
> [  272.265006][T15436]  ? vfs_fileattr_set+0x4e0/0x4e0
> [  272.270502][T15436]  ? copy_page_range+0x880/0x880
> [  272.275831][T15436]  ? __count_memcg_events+0xdd/0x1e0
> [  272.281564][T15436]  ? handle_mm_fault+0x187/0x7a0
> [  272.286855][T15436]  ? __fget_light+0x236/0x4d0
> [  272.291883][T15436]  __x64_sys_ioctl+0x130/0x1a0
> [  272.296994][T15436]  do_syscall_64+0x38/0x80
> [  272.301756][T15436]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [  272.307993][T15436] RIP: 0033:0x7f79fe886237
> [  272.312758][T15436] Code: 00 00 00 48 8b 05 59 cc 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 29 cc 0d 00 f7 d8 64 89 01 48
> [  272.333241][T15436] RSP: 002b:00007f79fd974808 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  272.342024][T15436] RAX: ffffffffffffffda RBX: 000000000000ae41 RCX: 00007f79fe886237
> [  272.350428][T15436] RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 000000000000000d
> [  272.358789][T15436] RBP: 00005606ece4cc90 R08: 0000000000000000 R09: 0000000000000000
> [  272.367151][T15436] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [  272.375587][T15436] R13: 00007ffefe5a1daf R14: 00007f79fd974a80 R15: 0000000000802000
> [  272.383950][T15436]  </TASK>
> [  272.387416][T15436] ---[ end trace 0000000000000000 ]---
> [  272.393295][T15436] kvm_intel: vmwrite failed: field=682a val=0 err=12
>
>
>

