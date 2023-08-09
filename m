Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F89F775606
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 11:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjHIJBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 05:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjHIJBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 05:01:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188C6183;
        Wed,  9 Aug 2023 02:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691571669; x=1723107669;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zU0od0N0Tn1HwMVsBE+u0qVduZoLZl2Q9nV/i9S75hU=;
  b=Iea5df1HxQZ2Lq6CIbV4jmY6HcNmDPlnfXvHUYYJxk0eP6cnoDH4rtPz
   c5H0dgw8NJ1ocE1b0vJ2C8oZ0kCAocLu9EgpdZAj0Y762HHeCDi2I7g9p
   gx3QPKxK7rjjtWOnN5fIipykIp0E+sc3fwma2T/N4VuYfptzIp3gP+/sw
   J7Zu88vCvBWhNK5duAjzAoWMqMKiC7AkA3902dA+c0qYLFd8oANvMA9HN
   ylKkhNUzcBL+UEv2CtHFHs7fm2PYtpBtfTaf8csAqYCHrpEvgx+l8Hl7m
   lgmPNAM914uFerCy3LAxKpjRomldYiZ+UydH2Jpy9HJUY1eOfn+llFviY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="351378791"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="351378791"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 02:01:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="797095772"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="797095772"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2023 02:01:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 02:01:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 02:01:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 02:01:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=En4yH1XWXJwR1EFAGBHSOdDT56Od88Drq5HzD3ioaEUqnuTueMI05vAh5FdjPLP5zkzI7cdVycqV4ppEzxHcGxdVJ/3yHZks6OOGlaeXtMsK0bysjUusy6t6o/D/qm2/PnLeQ9dOFQIuQJHiG4hNcKBQxidrQj2vP7Z4Whap7xTVUc7Cpu4OsLrhF0ENrYzIXrG6NvkZA0/OR8ubY4gylWrcETCRhc1F0Whn4X/+IcacDE7aQtYl1KutNgJYc8j5MAae0UyE9bBgv5nrei6pcRofBVpwvS8sBaS8VhApJzKYNUozCpn/BCBoGYJkN2/MehRCO5WBGrYK85ubQr0SOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QZj8hOOjjauexQS5p8swv1QTZPvAk8EVGtSRxucG1Dw=;
 b=enZQeE++JdZpOexzYj8YkKSf+wCA/2RVRVyc0Ykh8guzBWBWUs9flbBv/gh3kbBAg3bhtAydzT094lOB77i5E6ewzW67IhTCQTEVozKa2JQ6OBJAjiuhBOY6KKccN3xET8ZysWX2Ie/s+2UGotrbZB1uQrfCcG5ouqjzrJ4/mjXen3go268wHRwmh0YV1VELAwvWf8uGvRJWPGM3qk9lscMpyTEGOtAo/p8osv76YHzLodMfyFLyzmErJsegpUGWh4rEGHWCGkvrhpg1LJMTR/lcjxgeMm0+7GpFCQWlXD8qkKABENuohnkTWpIEq+kshYBtbpiUgN8Lw6FEqyzCeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5392.namprd11.prod.outlook.com (2603:10b6:5:397::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 09:01:03 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 09:01:03 +0000
Message-ID: <35f86383-e2f3-a554-b50d-d7fde9e26675@intel.com>
Date:   Wed, 9 Aug 2023 17:00:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 15/19] KVM:x86: Optimize CET supervisor SSP save/reload
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <john.allen@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
        <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-16-weijiang.yang@intel.com>
 <ZMy6INjzYiVqOKEy@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZMy6INjzYiVqOKEy@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:820::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5392:EE_
X-MS-Office365-Filtering-Correlation-Id: d74ec997-ffb1-4dac-888c-08db98b728a4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8LDR64H82LzJM4QoBoQvBz7dyT00qGQ0NZFlIPHZK43TJ6D4YopJWWA1VC6x9LDNMAo1UWrFu8YvB2D9gT9ZJfqSUdYP7Aj3dw3BUu4U39dJUaYC15utwpI29c1rdibNfkrXFXr8ZFvQRJM2mAp5uuP40ZR/UrLKvhRvv6Cr3BcTANSM8Z7hUCi63qd2nGAHb7DJ5B3Hj58x4okbHwn7uJX3axFIDmIxVZSr1ZG165NkAOUn/CJuknBIIFHicEpx13oywICfY/jvgnczCqleYpXGRqxTHbozxw3i1IA2jFFBflIaVlVgW4vFXLIzSYrH0jWpOqVK9x4r8e9c8LWr7oEZecehE3vUlZzPZrKMnC7IzVBFOeFd340qieVhYuI2pvOrAgnGUBNlZ6EoCQwtW1jU5rxu+iTdxs/0Q7SXUiMjyZ3CadVTFmG2qXgMnEykFslYIwPQe6LcyrNlxK2skOI6xfu5t4PFMZ/Kl2ZrAQPLLLe0KtyxEvsh7PzP8fVduUK7p+dc5x/TH2LfPM5oAJuUUN9Fulm4Up9N96GJfNWlpjMkc4cntuRdgfQemwM7k6VaEZL6Ih9JRJuNJwdlG+9OMO+6kzk+QqkGamRqJEs07Vnat7MQGPZy6bwacENfQknu+uxR1r/AGhJbLgE5mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(366004)(376002)(1800799006)(186006)(451199021)(2616005)(6506007)(26005)(36756003)(53546011)(6512007)(6666004)(6486002)(478600001)(38100700002)(82960400001)(31686004)(37006003)(66556008)(66476007)(66946007)(4326008)(6636002)(41300700001)(316002)(8936002)(5660300002)(8676002)(6862004)(2906002)(83380400001)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU03OHF4bzhodURMSWk3ejQ1ZDg5Z0ZnZHYvZXYxS09kTkE0YlVsc3pORFU4?=
 =?utf-8?B?ak1kU3owOUVTUkJzRDVCb2ltdXVFMnJIMkk4dis0VHhMMnUrVTlLSmZ1ZGUx?=
 =?utf-8?B?cGhaZVVYVTlsZzZ4bklobldmUXVRcjB1bGd2ZEdPTThVODZDNnlCTGFyRHQy?=
 =?utf-8?B?UnNIbkg4U05uMmkzaGJWNWZ3SWpDcGNEcDNvdFJJeER0ZzdZUHB0Njk2K21I?=
 =?utf-8?B?Vi91ZDlnMWhHUlYzcm16N0svQnBFaWRsYWZVV1lXOSt1cnd6SkM4dm41Nkdz?=
 =?utf-8?B?eVAvdWFYcWErSy9JRHc5TXZXNmI1TXg3RllqYXFVN3hoai94SGtxQVF3OTFt?=
 =?utf-8?B?OGJQem9odXpMaU50ZjJNMVJzZklnWW91aXFYKzlMa1ZZT1Q4dHBvbmIzT2tU?=
 =?utf-8?B?N2ZrVmI2ZytseTNDR3ROakFDdm1VZkxrVmppSEg1RTl1T1dCNThsRjVJdUlD?=
 =?utf-8?B?cTl0NGkxSTRna0NOV2pwNUgvWmlqbFRXUGhRMG04dC9ES0FOcnhyaDRyUFJO?=
 =?utf-8?B?TE94WWNNbkxnQk1tdENmTkE1WkZ5aEZ2VFp2WmdzRXBicndTMHZDcm1zMjRB?=
 =?utf-8?B?TUJNZGljdDgvcWc4QlFsNEkrNU9lWGErZzUxRWZZYlg0eUM3YVdwNWJZUG5W?=
 =?utf-8?B?b0trZGZyOG1JU1RZaEF1b285eWRiNTREc1FnbFlNRG9UTmc3VmdPVFltcHhj?=
 =?utf-8?B?ZVc5T2lzcWQxWG50ZzJsRUxVMDRiZHNjVzNvUlROaDQxWGY2WVNjRkdlWW9W?=
 =?utf-8?B?cnU2N0oyY0NudURhSWV1WUpPeUFGYVEyV2R0WS9JNEJYQ3VJM3JPaWlOREx5?=
 =?utf-8?B?U1dhOVJGZDZuc0FqbXppTE5waTUvWXVyc1hoMExKVTRmTC9iMnNPRGx3ZFhy?=
 =?utf-8?B?ZHhQRXNONDZHczRFazEwMy93SGROTmZ6RU41RHZrVEV5ODRoL3NwL2ZGSjNk?=
 =?utf-8?B?a2R5ZjhIbFYydjRGbHZoNFQ0R3dZNW9nRXRGRDRXRGNwTTdCM3FBc2Vta042?=
 =?utf-8?B?bkhFa2o3ZWlqanM3K3dNa1AxRlcxSnpjN3BmMitxT2VSTFFubFpPa2h5TkFr?=
 =?utf-8?B?bjIzd3A3TkxPTDhMOWJIeXBIWENYZ0xWRnBvaUVsQ084NlZqaVlUQzM5U0k5?=
 =?utf-8?B?a1pDT2RoRTB3NnBPdkZ6OXZZaVRiVTNJQ0gyY0VCKzZzL0JiSE5qOGpOQkZC?=
 =?utf-8?B?aEExTzN2bzZRSkx5V3dNTllRbzNCM1ZJTDFSaXJhODF0NHE2dVVrZllZbThv?=
 =?utf-8?B?ZHAvTkw5NjdPQWpZczRMTEtrYnRhRytvQnh2bXpvemhHd2F0THFwWmE4WDNq?=
 =?utf-8?B?S21Tb213blIvZk8vWWNEQ0IxSi8wSGV5bW12bitHM3JMem0zSUI1OVNQZnNR?=
 =?utf-8?B?QlBQMlZiNUFkMythaitpSGlrdFJEN0ZpdnBnZW5ES2duMW5KdkZkNWUraktJ?=
 =?utf-8?B?OW1pbHh2OFdvRzlGeWw2T0pVZVdZZVJ2U282dnZvZXNGZWVnUGRReEZ4Um5G?=
 =?utf-8?B?eGhhbXZnOUNKNnIyekowNXFab0ZlZ3pDYVhVN3ZKT2FxZUVBTjJLbmtPWE9l?=
 =?utf-8?B?R0xETVBuNmxiM284UkxZZTRKTUdmT2RMckhjNTZnMlZLMXZNYlJXU09jT1h3?=
 =?utf-8?B?WnVsSlNYc0drTXhnSlBUdkUwS1VNRm1lUm1TaTAvU2FjUHY4aHJBL0cwNm9s?=
 =?utf-8?B?SjYrK2F1SGhpNW50cG4zVUNRTCtkRkJ0eHFScVhTNHhvQ2c3K2IwQlc0di81?=
 =?utf-8?B?UUk5QnNkRm5hSk8wMTdNc3VKajY0anc3TWFtQ2p6KzZyZ2xVVEY5aXhCb0pS?=
 =?utf-8?B?L1BHMUVFVkUxd0o5RFNHOWp2LytUd0Q4VGdnWTJ0L2RFRUVRbE5jNmxyeVJz?=
 =?utf-8?B?RHFaZ05NeEdmN3FneFBwRG1BbU05alhBeWtabDZvbzQ5WGJzRkpVQyt0WTRN?=
 =?utf-8?B?SWNPZWFBbmh6VWExSzlOc2JLK1ZtYVlwcVV4S3c2TC82SXdHYnBEaUY2dGZR?=
 =?utf-8?B?N0VDVGloaXh0Y1R0c1hwWWF0YmpCOTB5OWF2eFpnMElGM3pyeHIzVjFtOWo2?=
 =?utf-8?B?ZGhxcEFkcW5HcXdhUzdrYWR5NmJ3ZHdVbzhtdjZqU05hdCt2R1pENnEyalow?=
 =?utf-8?B?KzdTV3EySXpKdWswU09aRkl0M1FmZ3VBWDE3NlZ5elBFTVF6SU80U2djM2NU?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d74ec997-ffb1-4dac-888c-08db98b728a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 09:01:03.4627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBFFLmDtu62V761IW3C6DVo7jIKJodlzqNpEIAm6vVYhgrR2SSCpUIk3CO2FcF9Kt8UQDyc8FTgbVS1MWqOPMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5392
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/2023 4:43 PM, Chao Gao wrote:
> On Thu, Aug 03, 2023 at 12:27:28AM -0400, Yang Weijiang wrote:
>> Make PL{0,1,2}_SSP as write-intercepted to detect whether
>> guest is using these MSRs. Disable intercept to the MSRs
>> if they're written with non-zero values. KVM does save/
>> reload for the MSRs only if they're used by guest.
> What would happen if guest tries to use XRSTORS to load S_CET state from a
> xsave area without any writes to the PL0-2_SSP (i.e., at that point, writes to
> the MSRs are still intercepted)?
I need to do some experiments to get the details, but now expect some kind
of error in guest is seen.
>> @@ -2420,6 +2432,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 		else
>> 			vmx->pt_desc.guest.addr_a[index / 2] = data;
>> 		break;
>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
>> +		if (kvm_set_msr_common(vcpu, msr_info))
>> +			return 1;
>> +		if (data) {
>> +			vmx_disable_write_intercept_sss_msr(vcpu);
>> +			wrmsrl(msr_index, data);
> Is it necessary to do the wrmsl()?
> looks the next kvm_x86_prepare_switch_to_guest() will load PL0-2_SSP from the
> caching values.
Oh, yes, it's not necessary after moving the reload logic to kvm_x86_prepare_switch_to_guest().
Thanks!
