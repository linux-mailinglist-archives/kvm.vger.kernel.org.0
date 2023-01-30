Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81CA680728
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 09:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbjA3IMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 03:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbjA3IMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 03:12:52 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07422942E;
        Mon, 30 Jan 2023 00:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675066349; x=1706602349;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gi2zfklUi9/VgjB4bltQBhxIS+6e8MvpnkAY05G/kzo=;
  b=hG3FxTseMYDZGK5xbvAqaaBnXC0Rr4XqOGCQZqXW7O2x1Oz5dFZ8zfUG
   cVxgyrKqQ5zoqnmZrEWl9j6hKaM5nJmtsngDFpxULawbW3I46WdrLQTjw
   QHuZKfxv5ZNz72IQPmvKlnmC1EYjN2O01xDMs+HhoYGDG56/aHzXnDgFf
   2Qrq+mO/cUH3PGOgP7U4eV8v/JW6udiiptdoCXvCnGL6oUY6gJ3+hRve2
   UchsO+93it965NK0s5FSs3y3os4jc73w2DWwEIUQ5RtMVkTvRlgkz8E3A
   SJTT2RHCsPL+QoHMm1835FQz/RyrN4HjD/Os5QTiJEQ4+JzKIkNcjtY8B
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="325199606"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="325199606"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 00:10:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="732605554"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="732605554"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 30 Jan 2023 00:10:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 00:10:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 00:10:30 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 00:10:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CguWcacLmaYeoTj4YVjBNbqM2Rpa3bLbUAKwTfuaWwwf2O2Mxd7Olue/nsn66eIET0WGX/qTUP+n7s/PPNMj0U1Ni8IiUPbOW3YVAR2LlAuDu2qilm/2XIq79O5bhKrQAmBmBgf5oZZ8oDksLs59JjUY3YQCMYNocRDa8NRPhuq7wsxJDKkdOkTWd72EKR2T6uTMlD53bvblaw/Rg0fp7zueDwEdR5jeJ9mLub5xPRLBkel0zMcEaousdbD38TxEyJHuGx/LqywH92W0CQ0ITIi5dgxmhtDV38RvNLp92S2xdaMjXfh1TPQnSV6HhOMkQaPRx57WzHoam2op/9EMlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IY1uMZ7iKQRK+pN1qB5dD8Sj82/V46frAJghYFVme6A=;
 b=ZGiAH/WVtlfwuvFG7cbdDNx1qgkncm084pbKtJivrVYRk1xDVW2od2L/mGeZ94s0u9vn84wUW+P6CKMwKw88CxS3kiD/AccuwwWZAQVgotXfaBwGROkvW0x7o3uL0w7se9fPMUk4bBkLOvFJQAdW4j9g46QoCfK2QRG1ZFFOk4Euc3cgk/WtzVMhACwTHPbVdtnR9Akw6C9MSJCDIU1G4KUDX299A4hSwV+1wEZRovVSUocTLKWfG5er6yAW70wV5TaCJaziGhHOHq7q3R48w3x2SKNnHHvhrTGt/zC6hZlu+RRuTDStMMcxgLbS6eRobgd0NFU2PUVqMGn/PC31DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7313.namprd11.prod.outlook.com (2603:10b6:930:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 08:10:28 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 08:10:27 +0000
Message-ID: <b772cab4-a05e-95f1-c0c5-797acdecbffa@intel.com>
Date:   Mon, 30 Jan 2023 16:10:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 04/15] KVM: PMU: disable LBR handling if architectural
 LBR is available
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-5-weijiang.yang@intel.com> <Y9QvxJbITGaY6Yki@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9QvxJbITGaY6Yki@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:3:17::19) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7313:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d1712ed-07bb-40e2-e3e9-08db0299725b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqrgpgvJz3T+3HxELge/S5bvdQrR3oOLYG6/HitrTs7U2uyMRF+RZ9miLG7/S+/yc3DghHPNiHmEvFD/sQsDSGtwbmfCWg6KlWlDLs3gwsfoSGiLw3hKJmZKkcb5Yz+o0WSKbjdBnwlSx98cApfbiZLHdbgnk92Pbc6ors1C80kXolfmbehI974dtvD3jOk2kb7U/MIoT2Pgy+zSsiN50GXu1+HU0PuH+PSwHDnD+O1JsxgTM01nbnwLCRkoUBhaqn6NnUNN78OSllIh3p9bG2jFA2kQOdXhGK+/2R3MdyCMGNq8O3oMyjsh2o2S4yg7475zP3BRoHJFDXF2oxof1mheASplYaGh+KEunz+bpuW/4QwtzQxGAClzoWDMmvLGSE2JmB8yxuTdtROQc8rTn3NgBsjhOtz65nu/9apSRhAvc/kVzmo8sw2xCkzDC//M4KNxioOeRdjhB2ETwxzwJFGYeLTQAZguiHlTCgIVHVak7A1ahArBcbxCTMpftJtOww0uAl8iwfrFmVJ82CJQx1Xwn3nqpBDIoNNccuZ2eWipiGp0CsDNb//DdBHc9UERKIiPBUXJLpOQhLfAIov0JarqHqz2vEH5bDu0CdRs3NlDhJKD7rtjwR1av0PgbmEmMc4Jq7qZnkdf7UNVq1upK1B9jvmKbHq8r4tXOoLgDS+AdcDM61QkrpEv+uG8q9h1/KNXQ2SVggYobvvtGPAhTG6E3tYCIqerOCZ4DFJIcFo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199018)(4326008)(6916009)(31686004)(41300700001)(66556008)(66476007)(8676002)(6666004)(66946007)(8936002)(316002)(5660300002)(6486002)(83380400001)(36756003)(2906002)(26005)(186003)(6512007)(478600001)(6506007)(53546011)(31696002)(86362001)(2616005)(82960400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2QwbGZXdG5tVjF1Tm83cEt4L1dJWmE1Mnh1SW1HS3ZCcG5mc0lmSzVMaTZo?=
 =?utf-8?B?VitSc2tRKy9DWFdrWTRIN3l0OWRnV3Z0UHlkZVVGZk1RMDloZkI0dUlhK3l1?=
 =?utf-8?B?RW5KU254QVVXS1FMQ21UTDJhYjVvaElNbUprTVFqeUxVQkJNNzg0d0tvZHpp?=
 =?utf-8?B?Z3RQN1VUVnI5RXZGU3hPRFNtK3dlSkl5SnE4b0lDeFhib2RDTzFWV2tlS3U2?=
 =?utf-8?B?MTEzaW8yQ0x3TEcwc210REpVQ2s4N0J2cW43UVNMa21VVStSUCtHclN0Y1VM?=
 =?utf-8?B?MGZpcW9XMTRkMFBsSG9ya28raUZyK2dubFBscWdpTlZRa2JUam1QbVQ4S1cv?=
 =?utf-8?B?NEdrR25tL25JZXBvVG1qaTlEQ3RGS0FIQUdpTmIrV3JpdHgzemNyekZ4dVgv?=
 =?utf-8?B?b2w4ck4rL2M3Ym1BSG1xNGtwMWVYd1J3K0hvTk51elBpdVl5OGJVbWtEakhS?=
 =?utf-8?B?ZmVHM2kyOU1POUZqZWF2UGEwM0twT3Vkazh1clEyL0c1Uk5WL0djNzBRbm4y?=
 =?utf-8?B?cWZialdXS1U1Ym1tWmYyOE13SVNIMlVWa0ZJK3ExLzVlcFNZSUo0elVBQTRF?=
 =?utf-8?B?V3BJZXJRclJZRmkrK0JRMGY0VHdnSCtvbkhnY01uVXY1SnoweTd2eE9nMDZ0?=
 =?utf-8?B?UGJHVWIyUHMveWZwSEw5M2FUZDkzN2lscmFibHRON3h6Qi9ObCtDR3FkUXpo?=
 =?utf-8?B?UkpjN2RBSjU2TGtGNTQvR3gzTjdRMDRKQnFvZEdUcm5hR0l3WXhZMDg5VVVF?=
 =?utf-8?B?dVdGbGpSS1JOQXgrcUlBcUFrV0ZudnEyNmhzQnlUYnl4WUNnZXNSL2JBOFNa?=
 =?utf-8?B?SGRWVTJrNEhqc05EMDgzaENnelQ0WXFCS0dSNm9LVE12UFF1dkNMaTBWYXBo?=
 =?utf-8?B?M0pISGpOREdkUlA1VmVuZkJ2cUkybkEvR0s0M05icnQzd0RGZkdyc2NzWGlu?=
 =?utf-8?B?MVRodkVRZy80bUljVHRDdG8yYXoxTmtuUGd0K3VuU2xCQ1BEWUdzK1Z2YmxS?=
 =?utf-8?B?UjRSb0tIVHl3WGdoTlh1ajFtOWFRNkVncHJFM3BDQ2h1c3lMcXpRckxJRzgr?=
 =?utf-8?B?L2Uvd2Y2UTlGY0RWeE4zRDR6VTRTOXVtVFVFT1RuZzFmUFhxR2pJZGFzT1B3?=
 =?utf-8?B?MFFJSDduN3dOSUdnbDJudU1GMVFHL2orMldlL2pvNVBKV0tLaUFRbmwzcjQ4?=
 =?utf-8?B?aXVsN1M5dVBWU0NiY1QzU2p2OEhvVGhad2xzOFhoRzV4YW9nR29mZkhraG42?=
 =?utf-8?B?eUtyWVNocVNBanZDc0dyTmJFN1ZtZzhhMm5idUxLVkFOWWNNdG1melNLYU5T?=
 =?utf-8?B?RldQSUhIWW9PNkRPd1dRdWpNSW9zd21BdTN3R1Z4aDlLVXpRbmZBd1dMRmJJ?=
 =?utf-8?B?YVB1M3ZJaU45T0IwVVA1dlVHQ0RsYk1Xb3BwVHdXM1BhRnVhTmFyVlNROVBW?=
 =?utf-8?B?TFlqOVBCS3hmalpZRTA0eHhXeWpFRGZTaGRHVDFUYmNOc2lkdGRCTFJ3SFMy?=
 =?utf-8?B?WmVHK0EvT2V6QXZkTEthbDdSMkpDUTU2TkxCK0FPUUVCcVZsTm9hWnVKQzZq?=
 =?utf-8?B?TG11YVNqekR0a282b0xDbTZiSWF1WXhYTEw2SkFoMjdkcE03c0psZHRGNFlQ?=
 =?utf-8?B?Vjl5SFJLM3ZWL01KUUdHdE5PeTdOcDJCU2dJNkRsTTlEckRUd1V3V2JUb0w1?=
 =?utf-8?B?cTd1dTFUSG91MVRQN2pBU1dLWlhhZ1N1aXpkdkVJcTdVNlhsaFVaRHU5c1VD?=
 =?utf-8?B?bUtMRmpQbU5kcTY0SXdKSERSaWN3SUN3TGxjditBZktVQ2U4V2taWXRabjE3?=
 =?utf-8?B?RDF6dlBnUDlPSGdFdk93QlN6QTExWVRBYlFpZVZnYmZGSHJacTFyTlJNNFU2?=
 =?utf-8?B?L3VLcUovZzc1Sit4OFJ2eEpoZitxZUtkczFiM2hQRFFpV1NsVHVqZmRxUFpm?=
 =?utf-8?B?Q2xLeEF0Q2RtdUtyZnRCd215c3pNQTJOZFVrOEZmTW03aHVjZncybnNBR0Nu?=
 =?utf-8?B?aFNaOXRjT0w4b1pPbE02Mm1RZUVXbyttazVINVVLN1ZIQzdCbFJTUlZBTHQ2?=
 =?utf-8?B?N3hlSjV3bGNZQzkydWhjNDFObGQxNWo2ZkpuY0xtYUtFL3B6K3JEYWhUaVNp?=
 =?utf-8?B?N0J1QitrVlBMT2xtK0FlOHdsVEI5TVBPOTFpS2JOL2VsSXNUblNMZXQrcGkx?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1712ed-07bb-40e2-e3e9-08db0299725b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 08:10:27.8214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFcwvoShZmKqYLYO9oh1oj1RaJS7soxY0mR4UwJDtFcU+KzU1H5oew0nGrMtjUUifxJ6ftDUmEZUlr9JlPMOXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7313
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2023 4:10 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> From: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Traditional LBR is absent on CPU models that have architectural LBR, so
>> disable all processing of traditional LBR MSRs if they are not there.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 32 ++++++++++++++++++++++----------
>>   1 file changed, 22 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index e5cec07ca8d9..905673228932 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -170,19 +170,23 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
>>   static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>>   {
>>   	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
>> -	bool ret = false;
>>   
>>   	if (!intel_pmu_lbr_is_enabled(vcpu))
>> -		return ret;
>> +		return false;
>>   
>> -	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
>> -		(index >= records->from && index < records->from + records->nr) ||
>> -		(index >= records->to && index < records->to + records->nr);
>> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
> IIUC, the MSRs flat out don't exist _and_ KVM expects to passthrough MSRs to the
> guest, i.e. KVM should check host support, not guest support.  Probably a moot
> point from a functionality perspective since KVM shouldn't allow LBRs to shouldn't
> be enabled for the guest, but from a performance perspective, checking guest CPUID
> is slooow.


OK, I'll change the check.


>
> That brings me to point #2, which is that KVM needs to disallow enabling legacy
> LBRs on CPUs that support arch LBRs.  Again, IIUC, because KVM doesn't have the
> option to fallback to legacy LBRs,


Legacy LBR and Arch-lbr are exclusive on any platforms, on old 
platforms, legacy LBR is available,

on new platforms, e.g., SPR, arch-lbr is present, so we don't have 
fallback logic.


> that restriction needs to be treated as a bug
> fix.  I'll post a separate patch unless my understanding is wrong.
>
>> +	    (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
>> +		return true;
>>   
>> -	if (!ret && records->info)
>> -		ret = (index >= records->info && index < records->info + records->nr);
>> +	if ((index >= records->from && index < records->from + records->nr) ||
>> +	    (index >= records->to && index < records->to + records->nr))
>> +		return true;
>>   
>> -	return ret;
>> +	if (records->info && index >= records->info &&
>> +	    index < records->info + records->nr)
>> +		return true;
>> +
>> +	return false;
>>   }
>>   
>>   static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>> @@ -702,6 +706,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
>>   			vmx_set_intercept_for_msr(vcpu, lbr->info + i, MSR_TYPE_RW, set);
>>   	}
>>   
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
> Similar to above, I really don't want to query guest CPUID in the VM-Enter path.
> If we establish the rule that LBRs can be enabled if and only if the correct type
> is enabled (traditional/legacy vs. arch), then this can simply check host support.

I understand your concerns, will try to use other efficient ways to 
check guest arch-lbr support.


>
>> +		return;
>> +
>>   	vmx_set_intercept_for_msr(vcpu, MSR_LBR_SELECT, MSR_TYPE_RW, set);
>>   	vmx_set_intercept_for_msr(vcpu, MSR_LBR_TOS, MSR_TYPE_RW, set);
>>   }
>> @@ -742,10 +749,12 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>>   {
>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>   	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>> +	bool lbr_enable = !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
>> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
> Unnecessary guest CPUID lookup and VMCS read, i.e. this can be deferred to the
> !lbr_desc->event path.

OK


>
>>   
>>   	if (!lbr_desc->event) {
>>   		vmx_disable_lbr_msrs_passthrough(vcpu);
>> -		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
>> +		if (lbr_enable)
>>   			goto warn;
>>   		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
>>   			goto warn;
>> @@ -768,7 +777,10 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
>>   
>>   static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
>>   {
>> -	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
>> +	bool lbr_enable = !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
>> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR);
>> +
>> +	if (!lbr_enable)
>>   		intel_pmu_release_guest_lbr_event(vcpu);
>>   }
>>   
>> -- 
>> 2.27.0
>>
