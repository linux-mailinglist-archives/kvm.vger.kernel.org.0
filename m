Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AEB77512D
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 05:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjHIDFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 23:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjHIDFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 23:05:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED001BE1;
        Tue,  8 Aug 2023 20:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691550319; x=1723086319;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0tKO3EmqHXAXTLN4Sm3et+uMuKKzpHF395JkpmxIFhs=;
  b=mu65wqIOEyLYmYQ/enlXu5ZtDNeaoTLHTf6nZwITb5n2y21hrO/rRlAW
   yOjfHG81j/S8hJD45ycEp3MVA3MCW9jxKAcDK13x6Lpavu1oSae/zpQbi
   V7zlMDDS1d0OQ5Ya//cGC2qcCA++Lgr5hgSOHdr3tk9woSHXGHJl5josU
   RjZFrfiltK+QoEwDWJZNq4P4+cwYgIwmksOr2MSCs1n0x51jnQfEMpnBd
   cm5YGFIFcAsb0fvL3vA4g+6WH0pn8xkFYfFNZL642jxHSdkn19iKHLYEZ
   snfH/1TjvJxXbwAbTAKXY14xUw0U2b9X8GruCJ7iHcVo5NeWHxxL5UnYP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="401971907"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="401971907"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 20:05:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="731639013"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="731639013"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 08 Aug 2023 20:05:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 20:05:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 20:05:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 20:05:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB6jAL4hTqPAJ1lNVcxUp0oMLlDvZbU8TQWwdd1LoX1iVBRZH3pOyNnbv4rqfIQ3WEezgnR1CkDzn6PSryM8q4MjQyKs4oTntrBkP5p8wWev54JBFrLxfK52Qza4Uzc7HApSVEgTAN1xyYCFPPMen+SBMLJVpAYPThZZ1p2QUPx80B6q6JasuAGQBYIR5RRqKQHEF4evPVg6j+M56WBO4482Vhv1uveF6MVMzqV8vHmTlijoiSquGjwOqYbjQDnS1AfNaWU+zoa3b1Gui1zyZMHoxVqkZJQ4UYsXaH7zGWF29sQ1CnQYyKsdAw3UbB4x/zV41raWTF/Px887VM+akg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tKO3EmqHXAXTLN4Sm3et+uMuKKzpHF395JkpmxIFhs=;
 b=QpZG1Yl5zxNcBDGOyIZpOM4QBeQRe3ol8M1NcnOcDozWfic1S/LOpnt3cq+LVlRGNYpH0dC7bz/kRCUl0OWv9joP2Pj2nDJyI54/JR+W8skr6sfrleufav0txcSyBKb+WyaOVN/6Mb2ArgsMC4gIVHXiYn9Jnq/nxyX5bo5PbBrV7lXP5nY32CjpFrki8ZRuH8/Js9bb65RHJtoPOJFiHHoJVeW1JrExOsdnP8owWTqtuokPGJk+dlywB/nf4p4z9CEBePo/RWVa5jvz5bPPPbtDVY/fXyulbRic2kMbM3oMXG3xKMXrt7mez7jtvjwcD/56sjDT3Su9GTBPl6Am9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB6962.namprd11.prod.outlook.com (2603:10b6:930:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 03:05:15 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 03:05:14 +0000
Message-ID: <27a14f56-3d5a-9d66-83be-e5893d5f0a9e@intel.com>
Date:   Wed, 9 Aug 2023 11:05:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <rick.p.edgecombe@intel.com>, <chao.gao@intel.com>,
        <binbin.wu@linux.intel.com>, <seanjc@google.com>,
        <peterz@infradead.org>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com>
 <b5c8d8cb-90c9-dff3-7f1c-e0f669950191@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <b5c8d8cb-90c9-dff3-7f1c-e0f669950191@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:4:188::19) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB6962:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b0a676c-8a27-4218-c97a-08db988573f5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s6g4gJHX2opFAAK/5kDlJsNPISMghcoK8w/Tf80TNibFBYNqhDozHqZrayrrC4r3vBMXSxkkD2Jn4NQcDpM0/lT9QovRxiUXncLIftlJaBtBdXrdwj9lu/BRilFeHUD8eWVW9t79V0B/jsDpbLVeBQPJRQLhWj8GFX+L3WKk+3sU35jWA8vYed+R86YETcCQ+Ne1CI3MVhUyJXFOLVMEKQ0NoxQGJmBsiqUPakrXszwph93kg6uEfqdVilr9MBZRQALBJ8fKn+l6vcZltJm5bYLfYA3LJYvC9Kf7hFt2ets6Kkrnhfco73ohnUmmwvKMRfDcsE0ADWwU6m1VBbrMWTdpezldkNkoFp/Av3bH4pD9ngCFAXBRDZkpvmNArJmMrpu/a0Pmuw0TcURb0ev1hUZJW/UeTcKWoViUPC6+DcywDDKJZAkJz27qM5iU8hPrBtosk5uIGrxp8I/08dNU3I60yUdI9GPCQsVgNpdg3y5ZTMFtY5EsyDhSWPP8MashKgKvS2e6O2+ZfipbPfg/kAAa4LhLG4ICSzqDNhXn3D5q4qshQG0fisZl3ZLi0k5s+TO7ZS1vmFPC8BlCRU07u83HdVlhJfiTBJdM+lPE7Rz8d6bJX+qNPrLD8BePGyO3XxXYkD6RZ0YC0VpG2sP4mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199021)(1800799006)(186006)(83380400001)(316002)(66946007)(66476007)(41300700001)(6916009)(4326008)(66556008)(53546011)(6486002)(8936002)(26005)(6666004)(6506007)(5660300002)(38100700002)(6512007)(8676002)(478600001)(86362001)(31696002)(2616005)(4744005)(82960400001)(36756003)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3ZZazE4VTZHM3BTOXUxUFJnNDlkb2Z6aWpFSmZBcnZSNGVock1YdDA2QXFw?=
 =?utf-8?B?WGR0c0lJVDVoblNnYTRLamh4bVZlOVZDeEdvT3FvYTh6SkZDWFRMcWorV0Vo?=
 =?utf-8?B?bkZyMDZPZXZRWGFEUHNkUkpPQnJJWlM4VmtSK3M3M0lwMWF1eVpIOTlTaTAw?=
 =?utf-8?B?a3haRWJ6b29CQ3JQNzFWWXVvS0tYa1V5L0preUNBb0ozRnJwdTZDNmdBOUQ3?=
 =?utf-8?B?dUd3S04vbHY3YnFxTnhXUE5ZdHFSYVZFYzNWR3JkWHYvcVQ5VnE1M3ByR3Zu?=
 =?utf-8?B?dWd4L01Rek55RGZiOWIzUzA5NzFWcjVZRE5ySHUxMElUb2t1M0ExL2pDaVRR?=
 =?utf-8?B?UEN1WHNvSFIyNGlZQ0VxUndzaDZaQWx0L0FjODdPbXhDaE9wejIrRXV1UUNu?=
 =?utf-8?B?SUwwQ2ErS1FFWWxlS0pTZWRUVVh2R2ExM21ockNLeVYxcENnZDdTVkpnOXl2?=
 =?utf-8?B?NCtUSHgyMVJrTzV5M0FIYnlYS1g3TXY2aXJzTEdCcUpYMGVRa3Z3M1JNSXFt?=
 =?utf-8?B?Wmx5R00vMTdUeUhkaTBuSFJQNVdJbVViUGpnOTYwZjd0Rm5qMDFBM2dSdU9q?=
 =?utf-8?B?UDJYN01ZMEY4dXVrczRLQjAvN1NZZTA4cDlXMHBRbWtSejQ0eGt4UGZZZFhE?=
 =?utf-8?B?WEtSOUFneDF5UWROZ091UGdaM2NnYnUzaStCZ2FiTUsxMDlkMFlYbzVMSmM3?=
 =?utf-8?B?OStGVVJncGt3UENkNXhsNUVHZ2pYNWNmcWxCWTFXeloxL1NZcmpTdTJrVzQw?=
 =?utf-8?B?WG5VNUVCcTZyUk1ycW9MbVdyWGp1Y1kxOTNuT2loZEFEUlpndkpxSnhZSFI2?=
 =?utf-8?B?Ykpvc2RkUkpoSHk5dWNiV1dORDZlc1BicTM2M2s3Q21RQ3p0bnFYZnZDMzFO?=
 =?utf-8?B?bml2dEp5VDdUYmhKN3RrR01IM05mZi92SkUwK2xubnArVDRMMmxYWUVqWEVn?=
 =?utf-8?B?dE9ZT2tJb3A4ODJadURUUWtsUlRJVEFsbk0xZVU2SXNxZEZ4QUlqK0d2OTc3?=
 =?utf-8?B?RjBiMmZ4TEowcnczaW5ENUJ1NVhrSVRGR1FaeHAra0E0ZGVjWGZzcDIrV09E?=
 =?utf-8?B?TzBXQW9JR1Q5dFBNckZpdEhqdytOZEV6NnU1YnkvNWtSMnI0N0YvbHBIZFR3?=
 =?utf-8?B?aHp6YU4rOWU3ci9BN0JhelF6a2FtOXVNTmExN09CZk9KMHArd2Fxa29nRnJE?=
 =?utf-8?B?OVJGYWQ5VFVlSzExaGtqendWNFdRbjJFTzVVYXlDRVhlOFAxOTBLKzdSaHNp?=
 =?utf-8?B?STBNaC84SmcwT2JJRmpaWEwrRVYyUlo4V1V4c1lmZHZWTGFsYURBVEpBbzZX?=
 =?utf-8?B?cUNSVHd4b0Rodm05QVRndzJJZjhKVXA1dU9qZy9mMXloSlc3RWpsb2J6ZS9a?=
 =?utf-8?B?TXZ3Tno3NXY3cFBOMDN3ZzVXaUkvTnQrQkhoc296cUF3S3hxWENmVlVUelpx?=
 =?utf-8?B?UGtOV2Z4blJKdHR3RzRFK05KNjBBSlg1b2txSTVOVTlId0wyRUZ3MU9DR0pw?=
 =?utf-8?B?L1A2SVkyc0VZV3NkUVBrTzl0VFVNREpUV3ZDelJzRkZ1ckc0djN0bHBRSFl6?=
 =?utf-8?B?YmlNWWFubDkra1dvU3h3MEYwdGRidHRFNUlZcGJyL0V6b09DMXZvYVh5V2VQ?=
 =?utf-8?B?Y3h3RmZCSFBtV2hsdUdkV3pJM2xId2FLNEF5NEFBTlFjVVlhOXJPeWtiYk5T?=
 =?utf-8?B?dVFDTmJ5cEc1SkxGZWlpK3ZLTU5HWmFiV2toam5oazgrczJsM0FYMWJSQm9n?=
 =?utf-8?B?OTFkR1pSZlowQ2hmTWhuUXlkcHF0WFN1eitVQXViSkQ2SlhDTW5aWHdZQTAv?=
 =?utf-8?B?dWF1WGlRUXFFTklkZHV4cS9LTS9Oc1gxc09ybTZJalhBbVprYXdnYm1yQ2xU?=
 =?utf-8?B?bWx0NVJQdFM3SDh5emozd2QxUDZXQVF0Nk1PUCtmM0RUMitnU29GYW9lM3lC?=
 =?utf-8?B?bzVIY0xmMWxuMFFmZWFjZXdLZXBnMGNKSUVxKzEvb21DN0dFd2Nab3lKUkVK?=
 =?utf-8?B?NUdqeTgydDdaeEM1Mm5VZTZ3S0VoWUJoZUJvOUhvYWFLTjlYL3k2QU15WGtP?=
 =?utf-8?B?NUF3WTArRnJoYUlzQ25nN0pCbXBieDdIYlBxY29FdEVSMk5uTkhqc0dybVY3?=
 =?utf-8?B?SmdsT0UxdnNEUFdERDdOcnI5QTRNNlFHSmFyYnZvZGpuWE5WcUVGL0drek1Z?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0a676c-8a27-4218-c97a-08db988573f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 03:05:14.7971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1n8b9FMocvfZ7JqbZgOykLE1fb1m5kY1jTQgwAnrqjIjE2OB5Rm6Grm3HBcKEtUsQ7l7z7XSO31JUcbd7vFsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6962
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 5:40 AM, Paolo Bonzini wrote:
> On 8/3/23 06:27, Yang Weijiang wrote:
>> +        if (msr_info->index == MSR_KVM_GUEST_SSP)
>> +            msr_info->data = vmcs_readl(GUEST_SSP);
>
> Accesses to MSR_KVM_(GUEST_)SSP must be rejected unless host-initiated.
Yes, it's kept, in v5 it's folded in:

+static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,

+struct msr_data *msr)

+{

+if (is_shadow_stack_msr(msr->index)) {

+if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))

+return false;

+

+if (msr->index == MSR_KVM_GUEST_SSP)

+return msr->host_initiated;

+

+return msr->host_initiated ||

+guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);

+}

+

+if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&

+!kvm_cpu_cap_has(X86_FEATURE_IBT))

+return false;

+

+return msr->host_initiated ||

+guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||

+guest_cpuid_has(vcpu, X86_FEATURE_SHSTK); }

+

> Paolo
>

