Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CCF606D75
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 04:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJUCOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 22:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJUCOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 22:14:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0AD33857;
        Thu, 20 Oct 2022 19:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666318473; x=1697854473;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=phFfPbbtVetbqSFk6LQGHsrNbzdkeWC+B4B88LriAIs=;
  b=lYEJVO+QXbs2bWLTU20UlMg8R96kx8BF3SHx2JIkVrMDa1AP/SRPD4tx
   IFLwb2FIG72nCLovtw4o/ew3cySkVB+LxdGozuRMafR4D3a02cfjMbwQo
   /BCz7Qtf0H4JZ50Yj333e9720ljq/mZqkiBsKbJf0fvgE3RnOacaJTdMS
   U1UmXxrbIXZoQXuY4SUZNfVrNpPdDH4lfHyOx4J+nGedLv1inlybiOirg
   E2m67bR37UDndyrbRPjs0KH150+Z5dRJplAs9dA98ZpSZbW9itFYE58WM
   yNBS1yPAiC0XWoKUXphTBpd3YcOAL7Eqv68iPVxYu79TasX3ikHvosic3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="307987969"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="307987969"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 19:14:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="805282155"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="805282155"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 20 Oct 2022 19:14:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 19:14:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 20 Oct 2022 19:14:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 20 Oct 2022 19:14:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ba/qA7Owzwco9ZM1jCag9LU8Pr9yb8fxf4q6Vh/WNRXFItKAwKEMMN1rNPt4YGgfBD48yqbiYo/+FBKYQAXX9thBAH5jJkLK0c6F6pOWgNK3kZhrtAreJ9ouvE5p4d90HvNe4fTRZvWdVLX7IQIfCVGW0dohFuqto/yDtJBDd8y7/WGzmQ82x7epUYzQyVNpGvQagAeEvXQgalIS964YeCLn8n55xFWlSmnf6AeH5rnVXf33g9ETVziEmPkgKi3BuPG9IjyqBAsfI1WGgQWtPHCkyjP0vSJi7gGoup9udJtIeX7ysgNYf5XD2JIW99r+uIRzJ1P8qw7JH8PEl45Y6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4AwTjG1QwMDQflj0pgJUrjHEkwgx8EArhj5Cilk2BU=;
 b=Z3Z4vVmPAFgYG7wmwFAg18mCC4BMMeDfhAn+V0NIP0Ysk7gZCd1dyNOEqu8HP18PiXM/gnyHNnkyNJBf/6UOsAKC/6/ripyMG8rhWgh2KdKOeO+fciU/nVmkyPX8AJ5nt8bFM13BL0p/ckS0ECa0TXRijqPCIz6jFrmonf6p0iVfASl25QW6moIspF8LXb43JLBL8UtlcXdr/SuqaoSPSp39OuedyQxirQOllnqXWubmYB2tKFjh3+j9CSJwYnBIk2m9lA4tE/Ve5ntppFg8GCkQb3XkZeUB61HXqFgYoHB27PLKPVqnUeFIQ9kxhG8bPStkrFC4NpQDntF4dluFyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5263.namprd11.prod.outlook.com (2603:10b6:5:38a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 02:14:30 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::8472:73fa:fc64:3a08]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::8472:73fa:fc64:3a08%6]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 02:14:30 +0000
Message-ID: <c44cbee1-663e-4bc3-357d-d683c4721565@intel.com>
Date:   Fri, 21 Oct 2022 10:14:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 00/15] Introduce Architectural LBR for vPMU
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
 <YxDAa6sV1CUyGpoN@google.com>
 <8b484c6e-915c-a7f6-d2a7-cf80ff67b63e@intel.com>
In-Reply-To: <8b484c6e-915c-a7f6-d2a7-cf80ff67b63e@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0127.apcprd03.prod.outlook.com
 (2603:1096:4:91::31) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5263:EE_
X-MS-Office365-Filtering-Correlation-Id: b4f24e13-b0bf-4dc2-acde-08dab309fcb3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTLszYP3fwjYSFpe/2MR5o+F3ogO/ikthR/1Sf/8SkNPMer8op3noG0eh/i8fL9fUKtLnoGcaJR7Z8Xv4SZWw9LgPNwaxgw/C3lIhvQhXajRNorH6qC/yPFUhhOqy1JJra6KnctdnOgZ4c3d0PqWA/Gllya68e4XDPPwsNUjezker18giayJNg0zJHjhy2sLbphFXU6HCgS+rWQSk7Q1psJ5bCHaCXTa1AQcmp+UCN754YmgUF8xQ0YPS3SqSKy23HY9czy/FHPsYn/WiwBHLCaf8HU7LqX+4WZcFC7D2t/PYX2jJqTtk7lquxC9kbdbQrAnfSnorb+JQgrIdP8zkkKa81sagNSg4TEMHE9aJTQCcwoxjSuo0z+H3FzcFOgwPziSWYwQazrZVygQhF+hI08rojWZ9z/Ee8NMGqqRCxFe+hpp+aTZKx9sGehpyIXFgAOUs5EHqG/cXYyyeOpNDh1K8Qf3QWS9O5a/6r/wBlTX0/bs7qmcXLepl0WTPK1nuPf2K7UJWwa/Prr2iOylovhkFlwu5h5Lq6H+GZL5dB7uJbEGyXS+oz7do8gdRb1LMx34DCIr8OiwkamPQS6PTgwUuB4EgOug4kd9L+1tLPxCoOUjn2RS3avMtTnf6FNmFBEOIQIEayN9IY99rufN8Y4gv4IW9XxhA/kRvwKPuLuZL5FqLbKE304G1IxTyiBKSD2M/6DW8EgoCWRbwdbynr5Ri9qRbcZN2/R9Ub8pQeyMSPvJzTlTHNuhAf0T7JqOutXnjF5u8+g9Rp+jGmcEF1NoTbUTw4cyYg4iJJreOIk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(6506007)(478600001)(4326008)(41300700001)(6666004)(66556008)(66946007)(5660300002)(316002)(66476007)(8676002)(6486002)(2906002)(26005)(6512007)(53546011)(82960400001)(186003)(38100700002)(83380400001)(36756003)(31696002)(2616005)(86362001)(8936002)(31686004)(54906003)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFBoRzd5S2xVSndmQWJJTmZuUVB2Z0V6Q280Z3hSc2dXMGhYNHExQkVtSElo?=
 =?utf-8?B?K25nWUFZbE1GK0ZZODhKYkx5KzY0eDhPeEw1Qnl0VUxOTDRYbDN2S2xkcita?=
 =?utf-8?B?VHQ5ZnBjZUp3MHRydFU3d1hqOVVjQ0V1MUFCVjVrdTFHc0lPaUlOc0ZMcTRK?=
 =?utf-8?B?TVo2UkZQN3dkbnNIVCtKSmVJbHQ4QVRQQkpCWml6bk1YVTF0MFk4Y3dXNnZ2?=
 =?utf-8?B?NTBlVHl3d1lRMUVxN0k1S1dEbTgxNTdHUllUaFNBNk5WRXdtSDBXempmaVdJ?=
 =?utf-8?B?Mk9JRnlNQkFENjgzTXgyZEVXTGVwQnR1N0YvTitlTjFsTmFtL2cvNzZWQ0RD?=
 =?utf-8?B?bGtkZlRFUVdPaTFCcnN1OHU0NjZHUXJsUmxjbk5YWGkzVFJvUHNvdEQxQ2x2?=
 =?utf-8?B?U0xNQzZiQXl5a0lWRVlldFk3MllWa1l5MlBvNTBQZmQwcml5ODdJa1c1azYx?=
 =?utf-8?B?WWc2Smk4Zkw3RlJPcVNTNm54TDdqWXBleVlqUGRBNUpKRGJWN2I3RE1TWmJv?=
 =?utf-8?B?MnNzWXhOWmFuTCthWHczL014Q1Z4dzJoUmV6dmZRVmkwS3RuTHd0QWdGRURu?=
 =?utf-8?B?cGlXU0d2cG5OMEtqNEVQaUk0ZG5MZzlZQmtHU1dFcUo1enEzNDlPb1ZnY3Fi?=
 =?utf-8?B?VDF6Mnc5MEt1ZUJZZFB0QzJ1aStya2xocDlESTlVK0hTcG5sUkt6VEVMeUhJ?=
 =?utf-8?B?cXFjNVE2YjRJUnRSQkRWT0FVL2N2Uk5hRGUvUW1lVUVsSWZOUG12ZDZmOXRt?=
 =?utf-8?B?dnBJdUFvcEJOSUFjVy9PSFRNRFphdkU0TWkzRkx5cG1zU203c0Q5N0xyOHBo?=
 =?utf-8?B?OWhUVFB6K2ZCVWlreTB0MXlsdWVzY1pBTGN0RCtOQVArR0Z4OGxScmJxbkMr?=
 =?utf-8?B?NlRTSkVWaUdWZW5DNG85QTRCcCt3aVNFMXhkYnVaVUtNRU4rV25tdmxJMjZZ?=
 =?utf-8?B?WjNNS3NUQWFCVmorVU5SSExDemFkNWhpUHBaTWtsZWpGbkhtLzVSZjI4d2Ju?=
 =?utf-8?B?S3pNOWhQV1BWV0RLaHJONkNTM2VTa1ArcG9CdldPM0daeDI0a1laQnFlUjJZ?=
 =?utf-8?B?aVF2NkQ5TDZueGdFd0VvTm5VVTg4SEx3bkNRWThreHlaZklTcDRnK3I1UWRV?=
 =?utf-8?B?V0IvczhwOWtUUVpaMjhIU3FuZVdBREVWSDNiUS9oYk5hRWVDQWVjYmN6ZUFH?=
 =?utf-8?B?dnFXYy8yeXdyRjBqYjk3dUY0QUdWSzhuOEZUQ2lUMnlPUzZtUDJmOCtZLzJ2?=
 =?utf-8?B?Z0hnek1GdXcxV0RCK1U3UVliSEpkMVJYaFhzUmFaN0hIemxCUnBCeVVYZ2kx?=
 =?utf-8?B?TTI5SnZZRUxRYnMyNlNPUyszYjBFcXRFWTlwSHF6YXNFcEVEQ0ZPd1FBTTVI?=
 =?utf-8?B?WS9mYk5zcjZ2VTJHMjZrcjNRc3k1Y2thNFh4WldIL3pnZXN4K29wSzRld1Ax?=
 =?utf-8?B?ZG1YTzRENml2OGRBeGNDVlI4ZDFvUGI1c3BTNnU3NFcxalpZd3dQSDlBd1NU?=
 =?utf-8?B?Z3h4RFdxV1JGSi9jajZlUk1VZ1BYTHlxOU9TVEFJbm5uRVVENWtMUVJCWWZo?=
 =?utf-8?B?cXRaeGxBRUZ1QjdsdU1lVnFoYTN4MTgrR2EwSVRiVXZ1SEgzcTY2cm1YUVNK?=
 =?utf-8?B?eGVZdmREYU53TEZFM0tGOUkvZFIvbGExS2xqTFJrekdUeVUva1luL1c4eDA3?=
 =?utf-8?B?RmRyT1cyQVZXSE1FZDB4U3Rqb2x0Y1BTMzJqQy9TL3laR2U5Q0VmS3hqVWtU?=
 =?utf-8?B?Mld4RjVPSEhWS1ZlcmxRNzg4emFKYUZRZzhoVWMyeGlGTG01ak92VjY5MnlD?=
 =?utf-8?B?N21hTFlPNFZncStLYUJzQTVRelVwcFMyM3p0U2d4VVFVVitDdENxb3RoVWk2?=
 =?utf-8?B?UEk4MlJMbDIvQWFzdWU5clUxZjZZM0tJbWc4YjFjMkNlT2tLd1hsMm5aWTdj?=
 =?utf-8?B?blJQRVpRV01XWE1EQzFkRHFqQnp5VjZWQjBDcmlwV3g3bzd6MGJpRklwVW5h?=
 =?utf-8?B?enRnMUdnTkhjOXZJcWU5UVdGUFJKNEVyYXBGSHNsV25SQ0tORkY3cjlWOXY0?=
 =?utf-8?B?ZUtUUG5YaldPdXdrTzIycUF6SXVlL2pIQlZQdmlLYksvbExyc2V4MnVkNUFM?=
 =?utf-8?B?V0pjQkNNL0p5WW0ydDBLL0FrQWhUeXJDMGRyWVpXVHVSbXg2OFJBalNiOGxk?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f24e13-b0bf-4dc2-acde-08dab309fcb3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 02:14:30.4870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VN6YoK5tJ3FwQSJLUoT3bPax7wXcqzZQfYYVGBcY34gOpg0PbYxmcgtdTP9y9CdXOD6wA496U//4wWdIvTR3Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5263
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/2/2022 11:44 AM, Yang, Weijiang wrote:
>
> On 9/1/2022 10:23 PM, Sean Christopherson wrote:
>> On Wed, Aug 31, 2022, Yang Weijiang wrote:
>>> The old patch series was queued in KVM/queue for a while and finally
>>> moved to below branch after Paolo's refactor. This new patch set is
>>> built on top of Paolo's work + some fixes, it's tested on legacy 
>>> platform
>> Please elaborate on what was broken, i.e. why this was de-queued, as 
>> well as on
>> what was fixed an dhow.  That will help bring me up to speed and 
>> expedite review.
> Thanks Sean!
> The de-queued reason I read from community is, the PEBS and Arch-LBR 
> patches broke
> selftest/KUTs due to host-initiated 0 writes to PMU msrs. Paolo tried 
> to fix it but you
> didn't agree on the solution. Plus your comments below:
>
>
> On 6/1/2022 4:54 PM, Paolo Bonzini wrote:
> > On 5/31/22 20:37, Sean Christopherson wrote:
> >> Can we just punt this out of kvm/queue until its been properly 
> reviewed?
> > Yes, I agree.  I have started making some changes and pushed the
> > result to kvm/arch-lbr-for-weijiang.
>
> What are fixed in this series:
>
> 1.  An missing of -1: if ((entry->eax & 0xff) != (1 << (depth_bit - 1)))
>
> 2.  Removed exit bit check in  cpu_has_vmx_arch_lbr(void), moved it to 
> setup_vmcs_config().
>
> 3.  A redundant check kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) in 
> kvm_check_cpuid().
>
> 4.  KUT/selftest failures due to lack of MSR_ARCH_LBR_CTL and 
> MSR_ARCH_LBR_DEPTH in kvm_set_msr_common() before validate pmu msrs.
>
> 5.  Calltrace in L1 when L1 tried to vmcs_write64(GUEST_IA32_LBR_CTL, 
> 0) in vmx_vcpu_reset(), use cpu_has_vmx_arch_lbr() instead.
>
> 6.  Removed VM_ENTRY_LOAD_IA32_LBR_CTL and VM_EXIT_CLEAR_IA32_LBR_CTL 
> from exec_control in nested case.
>
Hi, Sean,

Could you kindly review this post and give some comments on the series 
so that I can prepare next version?

Thanks!

