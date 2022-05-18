Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54AE52B711
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 12:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbiERKCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 06:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbiERKCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 06:02:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AADF5DA65;
        Wed, 18 May 2022 03:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652868159; x=1684404159;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XLPfJxVZcR9RzEIiMLwPOrMAaYVsxFLoZnZOTCddJXM=;
  b=R80I2cpuPA16nF5UGGd/uPAuwAqJSJaT99pMwEdSNu4wYasDnlgUs25s
   waebYQXa8M0kQ6OzEyX7Z6ZY2rGm9nbxJlg0K0pYc4Bcre2deW2sBlqjT
   Sx+6WOEDu4IeMYQo6aqmoZ9KxXDppzT6qJqkF68xeud2GTgsR/JUZWNPR
   YH2VptXZqFNFXK+RAdVcc1arakndf6gmdSt9i9b5uhfS7JPKbS/w93oEM
   Lql34Sju0f2fxjKMSnni7lvRsY5Dwon902UV+bh2CaNdghunYl+uMSw6h
   rjY6CNbMQF6861s7Shoc+xIjDzsa3d8AgkAjEruNXCiQ2D+wcVnfsNDG+
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="332209769"
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; 
   d="scan'208";a="332209769"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 03:02:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,234,1647327600"; 
   d="scan'208";a="639187969"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 18 May 2022 03:02:38 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 18 May 2022 03:02:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 18 May 2022 03:02:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 18 May 2022 03:02:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uhw6YEaQ96IIlBaGtEcSOOTQnlTsyYcHfFq/qOyRkMXtdMuRUyARaZrqLtd75lYH5NeVZIMuLmkczbGtNTwCS14+AAadjFHdD3dXPjVGH1BzNQ8NGHccbH6llCY74trDpvEhE/6XqqaySpTeTyQW2ynGk3s0TNAOk08sRcDHaw7sSoGDcRp/Rxa3RRLJ7SHYT96P0s9xflkK4G70RnikSid4LG90ZjWU+ttdd09TceeMUS3Gig8HntkDGDLEZtA6EnQpoxr1vHfWHnA/qBrH8lB/gPjuaGKiX7DMoeBKwysp4w5uTzr11yYN//lovf20sqi8a0f+HFW7jiWk49WURw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSo7G7Vz2BaILScGwTxLElrHopAbKyLkSmKSIdbD+UQ=;
 b=jT0m+GfbtPDQVw0G+TZDyDI0/whWybijqQblI/e0boUU5SSfZW4WP5pWPT+6jqen68WXO4MRITL0gmUJ3CEM0GVQFkw3S58slmUobaQ6o9MX4tCWGQEbKpaTvK97ORMtQalL42N6EgmkkpsypLDaERUjMOzA+6KqXx5TthUZ0ir/yk1dkbq7O5+jRFfYdjME9+aj3iO01beK6ll3WDYNoRcv0aQCpxnAppHvNCeaPFxivvRbCJVXcjGrvheTQrObmHtrerbGiMBOwV6aay/Q72f8tfAfZgdEQ8Nq+Jj+O/pDgpKHs3U5WADDPyUkXe4RCJPSfhPpH6q4U8x0ytpM3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN6PR11MB4129.namprd11.prod.outlook.com (2603:10b6:405:83::23)
 by DM6PR11MB2825.namprd11.prod.outlook.com (2603:10b6:5:c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 10:02:34 +0000
Received: from BN6PR11MB4129.namprd11.prod.outlook.com
 ([fe80::1138:3bbd:e4eb:753a]) by BN6PR11MB4129.namprd11.prod.outlook.com
 ([fe80::1138:3bbd:e4eb:753a%6]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 10:02:34 +0000
Message-ID: <e70aa81d-95d6-9a89-2e34-f5e5974b40f1@intel.com>
Date:   Wed, 18 May 2022 18:01:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] KVM: x86: Fix the intel_pt PMI handling wrongly
 considered from guest
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220515171633.902901-1-yanfei.xu@intel.com>
 <YoJYah+Ct90aj1I5@google.com>
From:   Yanfei Xu <yanfei.xu@intel.com>
In-Reply-To: <YoJYah+Ct90aj1I5@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0173.apcprd02.prod.outlook.com
 (2603:1096:201:1f::33) To BN6PR11MB4129.namprd11.prod.outlook.com
 (2603:10b6:405:83::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9577059-8d53-42a6-3ac5-08da38b587ba
X-MS-TrafficTypeDiagnostic: DM6PR11MB2825:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR11MB28250B7890D0A5FAC5CDEE91F0D19@DM6PR11MB2825.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26a0jDP37mPpOdH238GSDGlEPZGH+oAa1nfAOGoHuXFYWVuJoPE3eGIexIYxzfOZrCGFo3yCJXzpMEOkVdq7kcG5/8ISAnskQKAymAnUw5MdHt/Lt7017YkndZJNfZnSnebievMEQdT9JQoujncsZ15LYU4P5EqxEu6CzAyxAzCCmEcaN5HeC69dXPPo5AuKx9SfgYE0dxqv7SWHNgOvAupJMNIn80iFZCFTxJpVGi70lwgUrZDiL1riL4usS55lFl916Onrd48AOLqdwoXV/9BxmBkh1lof5Lzf7wHJKmq/1jtSXVnXeAoJARnzLM+2W/zqR1OQAEmH4/Wva1JepFY1UBzmBoTufFNGoAFdl8JamEmcw/hvrNkIDrZNAs1+dKver1eNwKtGoAjtvTXZYVBrr9NmHsuDB1SCRP+IK+TN/aEMSmSHmB+rbY2R9Zpl1aHR6zw7kg2qaDBRIK/Xc/ENq7B5t+SyGPIhRnk+AExp4dgyUicwEr3sBjbPq2lH21Gi+AACum9vL1v3wW4fxlwyfPd0jSfljecjLbZFUnjs1uRfdREgC1FT+uCtjsX+jlrNCcw5g5juFwlDBkhJaNZvkK4Vt5F125qGqbFXtj//fjm/tJB4jxfbSGTuoZApfhWriP/er+xu14LCHaGYFotugVH7gzYd9wxt1kLp4H0N+OyCJXXY6eSV+2CN+UEf6BezdpMZekdtg06xNnM/yjWmZyL/wFPwXwSOL7f2LLI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4129.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(8936002)(508600001)(2906002)(44832011)(31686004)(83380400001)(7416002)(316002)(66476007)(66946007)(36756003)(66556008)(5660300002)(4326008)(6916009)(8676002)(6666004)(6506007)(26005)(6512007)(2616005)(53546011)(186003)(38100700002)(86362001)(31696002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzZ2N3lQUE1seDY4Rlh2MEpPaG4xczhMaE5jWUttMlB1U1BBOWRiZnpheEFB?=
 =?utf-8?B?KzhSVjQzMEViWW1ZcmhwQVRuTUN3Z3ZBd2ZUWmtoSTNCS3NiMm5wYWJidHND?=
 =?utf-8?B?YnFkUmZjdnZoT25nTUk5MlZBR3c0dzcxLzh4NjZyYkI5KytkZXNmem5iQVkx?=
 =?utf-8?B?TnNHRXdOZ29nZktlTWt6clhBQkVBMVQvcUFIU2doQjFLeEFoYTRTbkZRUHBY?=
 =?utf-8?B?eWxUNG52Z3ZKc0JyUytVcVJhbXptQzdqRTFZUUFkWjQvcW52WjF2L2J6Zmpo?=
 =?utf-8?B?cXEvc2xlMzI3YnBhTHFpeWFzUkxENFp3aFc2UmhNUDF3YmxSRGZFc2YzQ2J0?=
 =?utf-8?B?blFhYU9JR2thWGYwTzBHcVpxWVZXS1dybXZwOWZpd2ViUWhDaWNrZ240cHRF?=
 =?utf-8?B?OFJpM1kzaUZkcmYwSTdwVU5RODdlKy9wOGhtaWl1M1U3QXpzb3E3QkVLSFlm?=
 =?utf-8?B?aVdkYkJUd3JKTTc0WVEzcjZWRnVMRk5PczdRMGJtM1R4WVplcDNLUmVOWWxJ?=
 =?utf-8?B?UEZsVURIWUdvYzJ1RXlMN3VSeCtDNHF3RFh6SlRRYTk3ZFZRaUo0bGUrdkRW?=
 =?utf-8?B?OWV2dnV2V1JNTys2Kyt5RzdpUVVvYjhFZmtRMUhaQWlFNFJMYWZ0N3NsWGds?=
 =?utf-8?B?cVhVMU5EZFpiTW1qa2QzT3hrV3MwOThIT3Z4RlBJWm1rREM1VFNoSHpYNldR?=
 =?utf-8?B?OFJXZ1JVSlY2TEJ0UjFHMjQ4WE1RdDRtcmkxS3JNSXlUbDJlbHY3OTRDd2x3?=
 =?utf-8?B?OHVtaFYybzNMQkM5ejZ1ZkRuQ2FGeVNBTkNxTUc3SG14QmtodkdJbkI5dURO?=
 =?utf-8?B?S0dyVkpxYXZaeDYwNTBTTlQxMFlhYjd3YzZiOEJYOFlaU2E4Q2s5azU0MjBh?=
 =?utf-8?B?ZU9tTitZcXVIL2s3K2NrS0gvZkZ0WW5iOFkwV1dsSkVkeWVMRkttZ2ZuenB6?=
 =?utf-8?B?dlg3QXlqTlVOWllUdzRZb0NSWU9OM0g4dkhyMUpYdWFJdmhVZ1BvRHNWTThW?=
 =?utf-8?B?VUkxRFNZYm1rV1V0TzJGbm8yMUhjSGROd01SYTk3Y2pNcWtjZThMSzBtc2ky?=
 =?utf-8?B?REl0VWxsb2RyUlIzcnJ4MDRzUFArTjdFS2lKWm9ubUNaM0pWMG4zeUp2Wm9G?=
 =?utf-8?B?WFQ5Q2RxdU5WQmY4UTVEZlZqYkpOaUxjbnVpRXk3dXVNTC81K3NWRzBhNWg0?=
 =?utf-8?B?ZUhwTFFUaG9WaFMyUmdEdnNKN204WEdxcjFvU3lub3FGTDV0TjlUUEVNZjJQ?=
 =?utf-8?B?T1BabmI3SGdUTktiZmpJbk9UTVUvL0VsTjZaMGRIa09IZHRrbjR2bDl6WGR3?=
 =?utf-8?B?bVpjUmgyOUlaNDBZeXFEQlBOa1NUZldVTkRMcFBIdWxQRTlGSmRVdS80TlFV?=
 =?utf-8?B?YkVYbzJDdlJoY2wyVmk1Qm9YR2kzTUpoRnF6dVFWSTI2eVhqSlNMakQzR1hQ?=
 =?utf-8?B?TmNhaGZxWklMc3NGckRYNTdtS083L2pocnI4UTJDRHk5UEN6ZUhNeXVqa2Vu?=
 =?utf-8?B?OSswS0ZQbXk2cTJId0ZyWmZqdklzY3dQOHVFeDk1Q2Nic1c3dU5JVkRCTHgy?=
 =?utf-8?B?MzRDVXZJMmRJK0tqenVuTHp1UzdrcXhLSWJkcm82eU4xZmh1WGtlTzFoVHpN?=
 =?utf-8?B?Sm1TaUs5aUtKczZBN2NTa29rclJjdHRaTlFYZ3VoRXpqTDZsS2Y3Q3dkTUhr?=
 =?utf-8?B?Mlhnck53c3JsR2pYYlhOOERxR3orQnp2dkh5dGJGc0dndUJYNE5YUmtSTXhl?=
 =?utf-8?B?VjdkZkFtdmtScFlRcEhNa05SUnBaaXFaNGkxaXBVVkU5dnR0UGZmSVdmdTd5?=
 =?utf-8?B?Q2VXY2FKZDVqQkpiR3B6cFZhcUMycGRXdkdwd2hqd3FibDl5dFBJKy84NGtE?=
 =?utf-8?B?WTYvNmp2Zi9RUHo4dGtjQm9pdEI3VUsyUFNQQURNMWgrUitBV04zOURaY1Yz?=
 =?utf-8?B?L1RtZi8yaGsza3UwUW5yTmJHQmdEKzBRNnNqZFhEUDdUZG1JNWhrUENvN2Q3?=
 =?utf-8?B?Q3REK0xjRTIwWHZKTkJpYkdNRjF2UHdYa0FjYklLYjRuSE1nS3RiSzlkT3g0?=
 =?utf-8?B?Z0drQS9rVVBXZUlDaDhIeUdkZjBiKzBjTjFndmhkNWlWZ0daYzNlb09xd2pC?=
 =?utf-8?B?SlV2MnBlb1JzVlM2RzNvVmcxL05DQXZXenprRnJ0MzBWeDNYZGVjeHBYWTA5?=
 =?utf-8?B?bkN1Z3NpNUp4UmZKNzEvdVZXc3B4ZlE0SUwzR2RQaUt0c1V0blh5eHhBZmRE?=
 =?utf-8?B?U2dEQlRzV3crSmIwNE9aaFVJNFFMZkJKNlNrT1dyMC9BejZ5YmJuUUFjVGZa?=
 =?utf-8?B?aG9NZkdHMVJrb2dud0VkR21YZ1BuVzJjRDlOK21RWFhoQ1VQcXVjZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9577059-8d53-42a6-3ac5-08da38b587ba
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4129.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 10:02:34.7617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72Xqz9rjLbUADSfKvNGb2u7aAMJsCgSi39l2Q9gGdCrSeDHp3yA0XaYb7JQjC5mzPTAzs38FN8VPmjOfIGoSOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2825
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/5/16 21:58, Sean Christopherson wrote:
> On Mon, May 16, 2022, Yanfei Xu wrote:
>> When kernel handles the vm-exit caused by external interrupts and PMI,
>> it always set a type of kvm_intr_type to handling_intr_from_guest to
>> tell if it's dealing an IRQ or NMI.
>> However, the further type judgment is missing in kvm_arch_pmi_in_guest().
>> It could make the PMI of intel_pt wrongly considered it comes from a
>> guest once the PMI breaks the handling of vm-exit of external interrupts.
>>
>> Fixes: db215756ae59 ("KVM: x86: More precisely identify NMI from guest when handling PMI")
>> Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 8 +++++++-
>>   arch/x86/kvm/x86.h              | 6 ------
>>   2 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 4ff36610af6a..308cf19f123d 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1582,8 +1582,14 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
>>   		return -ENOTSUPP;
>>   }
>>   
>> +enum kvm_intr_type {
>> +	/* Values are arbitrary, but must be non-zero. */
>> +	KVM_HANDLING_IRQ = 1,
>> +	KVM_HANDLING_NMI,
>> +};
>> +
>>   #define kvm_arch_pmi_in_guest(vcpu) \
>> -	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
>> +	((vcpu) && (vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)
> My understanding is that this isn't correct as a general change, as perf events
> can use regular IRQs in some cases.  See commit dd60d217062f4 ("KVM: x86: Fix perf
> timer mode IP reporting").
>
> I assume there's got to be a way to know which mode perf is using, e.g. we should
> be able to make this look something like:
>
> 	((vcpu) && (vcpu)->arch.handling_intr_from_guest == kvm_pmi_vector)

Thanks for your comments, I am going to understand these clearly and 
then reply or give a next version.

Regards,
Yanfei

>
>>   void kvm_mmu_x86_module_init(void);
>>   int kvm_mmu_vendor_module_init(void);
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index 588792f00334..3bdf1bc76863 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -344,12 +344,6 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
>>   	return kvm->arch.cstate_in_guest;
>>   }
>>   
>> -enum kvm_intr_type {
>> -	/* Values are arbitrary, but must be non-zero. */
>> -	KVM_HANDLING_IRQ = 1,
>> -	KVM_HANDLING_NMI,
>> -};
>> -
>>   static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
>>   					enum kvm_intr_type intr)
>>   {
>> -- 
>> 2.32.0
>>
