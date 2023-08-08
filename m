Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434AD774058
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbjHHRBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 13:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbjHHRBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 13:01:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36A58693;
        Tue,  8 Aug 2023 09:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691510447; x=1723046447;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RRutMu8a98dNAE/HL/ngLmbdX5hztH+/arupwVRQ25k=;
  b=FR/rq+XktNEc8PdLT+v/9cfij9XubD8C4+uJD2rN6JAjtIjwjuBXKcGI
   2AgEm4y0Q5e6drzl7PbVfKdlCyZMAE+svUJ15hflm0RCcqx6C2bYisdkk
   HOP+ozmHHP5AW+Nvv4AIgv2/kU4KcS+9hRsUlVa5Dhh101b1Wbfbfo7S6
   bYcxTPw4lW5h0+Lw1A06ZD6MWFo1tVDln1DJo/ppTjcE28cCxv8sx2P6S
   ycO5WaQNRimcRwHu2wBndndVB6g2oflOhXxGlPjg0GuCBDyHpAf5mf2Xb
   hQMO921bG90ADPtl484xebkWCnHQpRWumG++J/K5hF4k+W67Y/s1NAaEA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="350442513"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="350442513"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 08:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="855123628"
X-IronPort-AV: E=Sophos;i="6.01,156,1684825200"; 
   d="scan'208";a="855123628"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 08 Aug 2023 08:16:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 08:16:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 08:16:55 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 08:16:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByFk07hJWSviFwjhe10yf5GHuFajoz0Zj4xBCKI0lM1qLi94xQ1A5Fxabngai9fnPGxwFagdtvTf+TTkhltL12KXqcOUCcVyisBkRRDqd7d4bDF72i3txdNxgbWfT4se79kn4RGX/hFc3fuJhh0JupbkybMGaJ6mkccqJ7P3z2RKFE4t36i69O99I0ads14tlnwdM9i86Yxyf5qBihWrZ3zBCF1URmya8Te8DGvzH1XF8hf8eU1wG6d5xkuTv94uOzjbx9dHzZBNUNLiovKkXlt+LALJrGXfdfzk8zvE2+RCM2We/bJIpq7rDziQVHjNTBlkyr4aXuX7wNBEpRhZCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pe0atvKQ3PIiBOPib7d+peAdf98M6qC3AieYbKEl8eg=;
 b=HJzI41ZkEgZjmpZ3MuBQqlTSMJFrV8DqG+1xFMiFFKArpyycKoygPa4Odi/KuAcgp4ohEcqV5jIW2TVjKjxHDvPJR96EUbp7hZf/d7vcWkh42YrLlduGF/lyOsVL+lQccOd3JhmPj91BF9NqcG1lKHwU3wZNjURm0fUxB0HTy5agQnhU2+G/8FIvmtAWpCnNYXFPBP96+aVvOw7GsZ3Ce7f7RpjmrjkqjrotODk4znoBm06qe2HYBFkKQT4D4yCFX2/RI4bu3ukOIJmfk5LrzVtE70mISFLTCUC1wdOW2eToI+HBfKiwYKB1vISKAWc1TfDLmMmC56XOBYbbZ3oZfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7340.namprd11.prod.outlook.com (2603:10b6:930:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 15:16:48 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 15:16:48 +0000
Message-ID: <3558aa15-b084-5641-4f78-00816523a8bc@intel.com>
Date:   Tue, 8 Aug 2023 23:16:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as
 to-be-saved
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Chao Gao <chao.gao@intel.com>
CC:     <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com>
 <ZMuDyzxqtIpeoy34@chao-email>
 <83d767df-c9ef-1bee-40c0-2360598aafa8@intel.com>
 <ZMyR5Ztfjd9EMgIR@chao-email> <ZM1IlPrWz/R6D0O5@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM1IlPrWz/R6D0O5@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::10) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: ae377628-be6a-4dab-a2d6-08db98227ba1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZRFZv0CRJPpHgRm38MHQWGLV2wfjLZZD1hR3ArThDBjgobXquwW7uFwqPABnccRs0Wn+wPWVemZnyH0H9tTq7u62N18o4P9BoJrfXFB0tRgTrNVuB2KBdMYnayqN8FmUAnQdPRPeBr/BSFCjRDQBkH1yJLUIoiAtxCw4NMJSvq1ONRQ45maPlM7rKX0h05YiXI3EJ3X+kWkL3Kvov4u02hHm8Iw64gx1nEeCfPr7cYUFgtOKGs7Wibyo0rXrTWzI8X6VFC6k+b6IBxplZo/Q+M3tGBB/GLioEj/zvccGsPSnKMf0vaJHnqwhbbTx566yKEib1svzBblnAyzihb9jYvwUWFPerKBvtvoxvFok8zFIBxa4PjKx3elosD44a8cASQdUc9/GJZvhF5XyZJzy1nFTStxVB8X+YhYkvGJQp0CAHiOz92skI16OL1DtfjY2dQ+1t9WZ++BvEIGEsdy5EAmqmFNecZs9iV/C9FYJ38nzcrkaUzOMIg9zH6xw5Z/8R5HrVTqwVElAVz/qmgwrd4aUgl1e+nhjom6zmW0tdwkMtn7X0pV5HUuK5sPiLjNkVSZ6JM2/UpIBRzCWuJizWAwPlbe7jfhDqK9CYKet/Dv+gK82u+IfuMOLRzLzNhMkOaAJXzFvTvRtREOdw0iCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(186006)(1800799003)(8676002)(8936002)(5660300002)(6636002)(4326008)(41300700001)(316002)(83380400001)(31696002)(86362001)(2906002)(6512007)(6666004)(6486002)(2616005)(53546011)(26005)(6506007)(36756003)(66946007)(66476007)(66556008)(478600001)(110136005)(31686004)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUEraTFKb2JVUzI1a2lyMnNEZVcxWGg5SVB1bWNRMWF2UzRmSTBHY0JjMFJC?=
 =?utf-8?B?WFR3RlBSckN1Q3psS2VteXVjNitnQ3N2dko3am1nN0VFSXhjV29seVR4a3lu?=
 =?utf-8?B?YXFwRkZubDJ3WlhscjIrRlg3K0dIOWxiUGcrenFYcVIzVUFLclg2UGR4SG5u?=
 =?utf-8?B?Zk82cUxjNys3RWNPOFlQaHpvQWo5ZzZTZjNlTGwvM21wSUtMazhoUDQ0NXlp?=
 =?utf-8?B?d001RmdNOEErZVdzV2xaWDRGZUF4R05jRVRUMTNHMmxFSllqNXc3Y2ZIVEV0?=
 =?utf-8?B?b3J6V2M2WFMxZVdDMVk5bmtOcDBxbTY0RWtuNE9aWnNjdnFqSnJhTThEdzhB?=
 =?utf-8?B?QU9aQXBEekx5amY5bTBVblQxTnAveGVtSXUvNzE2MWZPODdITUhyWElGa3RU?=
 =?utf-8?B?OWtaNjBnRzExU1JIMmZLVytETlpFSGtyejZmTDdsV2NGcE1wdWhFbVNYdVlh?=
 =?utf-8?B?WmRudElQTWdFbU9PZlpzSDdzYXI3dlN3aXBBT3EyL0tVYThIbWtscmRWTDh1?=
 =?utf-8?B?TDcwbWE1ZS8rUVNEQ3UrS1JCSVZPTzhKUXdDaFRYRWFZUFRjT284WG5UcDBk?=
 =?utf-8?B?Tk0vVTVpRTV2cWZzdCsxT2RiamdNWTRrQnpVVFo4ZXdwRjlKSWZIODlMSzJp?=
 =?utf-8?B?WDBsWUpwcDgya2hoTHAyNUtIK2dyVkRUeDZHWWNHUWtnL3FKOUszcGdPVEdJ?=
 =?utf-8?B?aCtWZzdPNDdMOFRhQzI1WUtkTy9SMGh3M3Jrak1YOFIxYUZHSmFiUlRCeGgw?=
 =?utf-8?B?TEVLdE1tQnNNd3dFMkc0MTJ5b0htNHRYeWJOTTNzZGpLcDN2SHlNZ3E4bzdY?=
 =?utf-8?B?RjdwaUVjMVp4TWViSmR1SjhGemt1aTdWbzR2R08yemV6d2pFQmdBdVNmOC9I?=
 =?utf-8?B?dlNweDJlZ25uRVhoTERESmtOc0dhWkMyUnlqblIxTVZncXRjT0dPcElleWlp?=
 =?utf-8?B?bkRud3k0Rk4rTEsvQjg2QktCN1E4TTRBUDZMTnF1ZmFyckpIOW5qNW94amJw?=
 =?utf-8?B?UGZveHRGdmVSRFIzU1l3SUxQRFJIZmNyVG5sQnFzeFVtRFRaU05iNlpDd09C?=
 =?utf-8?B?dFRmcmI3Y2YySlptNTVHQWpiNmNKRDBaOG0vVDVHRjliczE3VU0wVG5PUTBU?=
 =?utf-8?B?bHJ1SW5QY29pSHV3SU5VZFBuZlp3MFZCMzBjRk9VSmFYNnh3Y3NyVkxnK2d5?=
 =?utf-8?B?NVJaUDdCaWRnUGtLbCtQZk1OdG5UQ2JLbGJ1ekg3TnZtWERscmgyZDFmM0JD?=
 =?utf-8?B?ampGc2VjU0ZuZEw2b3JuQXgrV3RBcmlxN3VMUEpZZHo1RUFITERKZTJXYjh5?=
 =?utf-8?B?cVZ3QnRwNlhmS21qekp2VTI1c01wYm5STkZsakpGZHV3RVBDa0N6b3greWVa?=
 =?utf-8?B?VGtPVTljYzlOcXhHSm11SVVaVUF1b1ZWa2ZyU2ZPQXVyN0xrZWJNZmlBU3JQ?=
 =?utf-8?B?dE5Wdjc1MDA1cGdsV2FlT1pGOWFwU2d6Vi9uNUFXZlhxa3M0Z2Rra0dNOFhJ?=
 =?utf-8?B?QUtWdUZrbWFMYm1VR2U2eFNtaktaV1hRWG5WazIzYUpaVG9LNFljUUFDTFpN?=
 =?utf-8?B?b3FKR2duRWpPd1FmNTBxT0hJNTdlSzVHNWJ4RzBrcVkwSmNpQ0g0OSt1VFpX?=
 =?utf-8?B?cmV2bWVXUnUxdDNuTktmUjVvSjNoZTZiSk5RK0ZzVGhDbkNMbnA3ZzZhd1pa?=
 =?utf-8?B?Q0JmeHdROVVrZjdQRTdJUzkrTVE4bkE5NUQ3cE5OaUg2T2g1cGZqNDlhODRJ?=
 =?utf-8?B?dkNKOEVnMnlkYmxWbTBGTHpISFo1VFcrY2FzSlBhRlZsL3h3VTlLb3RxdlJQ?=
 =?utf-8?B?dnNQaFV5WjlMUE1hOWFaeFNCSGE5d2U4cmcrTy9aTWZRRFQ5anhJRFJ6OUZ4?=
 =?utf-8?B?czN3TUpoL3VnV0MzdEhxU0Z5dlhyY1l0QU5mdktCSFlueEo0UzAwVVZDTXl4?=
 =?utf-8?B?dldjN20rcjJOS29mSFZLY0xhek4rRlRpOUJ3dlNDd21qVHovTlJIK2pBQk1B?=
 =?utf-8?B?TTRTYzRXQUFBV2dSQUcxQkhLdTAyRDUvNm5nNVhzRlF3dEZkN0JOa3JTOVRw?=
 =?utf-8?B?bEptd1Q4ZzVYaHRYVmEyR2VKTEFpTW94Z2s5a2VXeU9MeEdRUjUrZjRaZUMw?=
 =?utf-8?B?M0VvRWxKSEdtbFBtemUrcGc3MlNHbko4L2FDbkRlVkdlbzlyaDlVS2RxWFhk?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae377628-be6a-4dab-a2d6-08db98227ba1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 15:16:48.0485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZiwifMUXCRxvD1omXLvh4i5t0EwL/mT0zjDIYd4V5wy2oUSc13USqwweklJVbp+dRbfSaQPPm6to7+MBUvzJyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7340
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 2:51 AM, Sean Christopherson wrote:
> On Fri, Aug 04, 2023, Chao Gao wrote:
>> On Fri, Aug 04, 2023 at 11:13:36AM +0800, Yang, Weijiang wrote:
>>>>> @@ -7214,6 +7217,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>>>>> 		if (!kvm_caps.supported_xss)
>>>>> 			return;
>>>>> 		break;
>>>>> +	case MSR_IA32_U_CET:
>>>>> +	case MSR_IA32_S_CET:
>>>>> +	case MSR_KVM_GUEST_SSP:
>>>>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>>>>> +		if (!kvm_is_cet_supported())
>>>> shall we consider the case where IBT is supported while SS isn't
>>>> (e.g., in L1 guest)?
>>> Yes, but userspace should be able to access SHSTK MSRs even only IBT is exposed to guest so
>>> far as KVM can support SHSTK MSRs.
>> Why should userspace be allowed to access SHSTK MSRs in this case? L1 may not
>> even enumerate SHSTK (qemu removes -shstk explicitly but keeps IBT), how KVM in
>> L1 can allow its userspace to do that?
> +1.  And specifically, this isn't about SHSTK being exposed to the guest, it's about
> SHSTK being _supported by KVM_.  This is all about KVM telling userspace what MSRs
> are valid and/or need to be saved+restored.  If KVM doesn't support a feature,
> then the MSRs are invalid and there is no reason for userspace to save+restore
> the MSRs on live migration.
OK, will use kvm_cpu_cap_has() to check KVM support before add CET MSRs to the lists.
>>>>> +static inline bool kvm_is_cet_supported(void)
>>>>> +{
>>>>> +	return (kvm_caps.supported_xss & CET_XSTATE_MASK) == CET_XSTATE_MASK;
>>>> why not just check if SHSTK or IBT is supported explicitly, i.e.,
>>>>
>>>> 	return kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
>>>> 	       kvm_cpu_cap_has(X86_FEATURE_IBT);
>>>>
>>>> this is straightforward. And strictly speaking, the support of a feature and
>>>> the support of managing a feature's state via XSAVE(S) are two different things.x
>>> I think using exiting check implies two things:
>>> 1. Platform/KVM can support CET features.
>>> 2. CET user mode MSRs are backed by host thus are guaranteed to be valid.
>>> i.e., the purpose is to check guest CET dependencies instead of features' availability.
>> When KVM claims a feature is supported, it should ensure all its dependencies are
>> met. that's, KVM's support of a feature also imples all dependencies are met.
>> Function-wise, the two approaches have no difference. I just think checking
>> KVM's support of SHSTK/IBT is more clear because the function name is
>> kvm_is_cet_supported() rather than e.g., kvm_is_cet_state_managed_by_xsave().
> +1, one of the big reasons kvm_cpu_cap_has() came about was being KVM had a giant
> mess of one-off helpers.
I see, thanks!
