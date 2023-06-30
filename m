Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274C8743955
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjF3K2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjF3K2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:28:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB80B297C;
        Fri, 30 Jun 2023 03:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688120892; x=1719656892;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=m1rRnPHoIkeV7F5v9zh2tyfKyllXI0M2UZYr1v69dyg=;
  b=LyMLuAj4XlIdv6K9hYbWtx8rR3tebSV1wIqYIU/CkZwDAOYsJIb8SffY
   ZRfMjkO192fPAGx1cJR8pMcA9Ke/Ps0gF/EBmC9mXoDF67req01Qt3Rh+
   sQFf4T/lnnwIUUW6ddmb6Jni9f9r7sxg1qBxeoQl32oCOqhX33D3Wp8zJ
   VUKy2XiQDMAub7jqpclJO02OyfKcQsJubEyO0JgN+HxA3lpNtYaLnuf08
   VWcrHyVGlxjWbA89nhmVzIrU2LbqgeO7A9lvsmQrat2uZy/5M3hAW5i2f
   MRYEkNtBl7FL0HreJLXi4XoBjjCFm1d4zBIc2rbRRHedpV+GhInpSsYPx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="362404441"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="362404441"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 03:28:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="841824345"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="841824345"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 30 Jun 2023 03:28:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 03:28:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 03:28:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 03:28:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzXJ5yKEeySkNvZgaMQ1VqERrY4m/I4EYCT/FnpbnkjgrVvSGxXWE71TbapyaU4ob59aF1jlgDY2ujHTv1vZmICuSHFZPZ9vPuW5RpGvom2o9eWdDD7E3clJOVks6dTKzMM4B6Q5cVL8IrVhb19RMFwn8rszm4NrCDGNiIz+SUXJEQ+d0tgq0Ipi2My5+1Y9yow3MKO4p61vtXHMOA1NuAuiPJMNBv2tNRS6He/nkYB83HMyQfSRuK+s0A3mRB8UmtHpbX47aiMYUpXqkcJkFkP2vpD81xu/lxRx+prf+1byfJFQIMZLf/qL2X4tmhk3nwrRm6c65fkfHloS5Uf+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Bmo9QA3lqKYrcyw41D7FMgDG0ECuGxAENMm8FT8h8Q=;
 b=kshIp0Y43jzfrotN1owE6Aoh7l5pIHzozrbOqnwHry8mfvPsTuUU9pIL0j01cDWBByRRDoTY1+RMpDFUUuU+S7OBxJeoB0UqV+MHcLWXZ06jy3QSbM++4epkrw+aL/GHLfH98urd7iYs6Lp2TR4hQHwm5QvUnm9Fo6/QZ5NcN3OaQF4AQ5NS9OvBptvFrpcLs1BO9Q0ncg2Ff/WKdHPhjTPgGu6Bz8xU/dZI2VIu6TE0BSgcHhtax7VG6o77jnZXUfXgT9cKyv7hvZ53enRvnnlRBNn9MqUTRssA9W/gceXrUxKPq8Ylyo9BoWuXFBxzxovOrdxDLOK4Nn41mb34rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY5PR11MB6368.namprd11.prod.outlook.com (2603:10b6:930:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 10:28:05 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6544.019; Fri, 30 Jun 2023
 10:28:05 +0000
Date:   Fri, 30 Jun 2023 18:27:53 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     Sean Christopherson <seanjc@google.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>, <gil.neiger@intel.com>
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Message-ID: <ZJ6uKZToMPfwoXW6@chao-email>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
 <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
X-ClientProxiedBy: SI1PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::10) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY5PR11MB6368:EE_
X-MS-Office365-Filtering-Correlation-Id: f861412d-cbff-4ae5-4603-08db7954b07f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGEXPGkln0aits5KGExtTfjDNJfxYl8udEoCHAzo+6WnEgsF7YeZh2rUf9EsmsxFCMzJNdjWSPUFu/Ra7+eIzQuRdB/ThCpAxg1wtv8OUyfmADyjCR+y2DQopq4BN9HDFJZVVLTAATw0yGndqBUP77Rb8IDRlSexdscDpHkMmPN/JBbv6rMqE4MHR6RpBNGN4HIzcLDjAJrHnqv0gSGGvuht6wN1SEw8lnapBLmny9rlrqXH19LWxy5lP4ohXWkR3PgQO4IeAUcHLkIHK3FrmWeN8oX68z2lOy0gDEd7Okrci2wNocA+nojhabwyF8/GAIPtp87gNKBN+Ym/C7r5hwIWs2I7p3p/ZyNRGDSf2nB6KTTq3zoKzlA6Ttjm1I8tdaftDcW0n2FFJzylfyJv1JNbPBSChoI8pXZ9v10i8bU9nLn/qCPzhnFaRqj6uzMGojhkwRQO/G+RxQWnEKgAidfFKUD8RxHuuOCz4J0gP3yp36WBsLYD7f6HYveo8axkF1oUq4FWqHPoCM0dd3L8tK/CCD4keI+ZNQQJ5Kcy8Hyj/Se+AqU5z2k6gsf+0GKo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199021)(41300700001)(2906002)(6486002)(9686003)(6666004)(186003)(82960400001)(38100700002)(6512007)(53546011)(83380400001)(26005)(33716001)(86362001)(6506007)(478600001)(66946007)(4326008)(6636002)(66556008)(66476007)(316002)(44832011)(8676002)(6862004)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDFjaGNsUXo2bndaYkxoVUFUTWtUN2xXOG5NWDUwakh2UXhrTjJjaUhlZHRy?=
 =?utf-8?B?MGFLRVBRN2lMQXlqcmFjV0Rac0dVN0VKQjNvNFNrRnpCYmhIcnp6MmI3Ujlr?=
 =?utf-8?B?a0x6UU0zLzVaV2Z6a3pGQ1F5MDlCN25vM1M1T2VCTVhBcjhYRzBDS1ZqWWJ2?=
 =?utf-8?B?UEdQSWNrMXJ3SzJMaStoRmRtSTJPVG80VDROS3BLREh1NVU2TTdHbkE2K1U1?=
 =?utf-8?B?Y2pDMm9yY0hRZ2ptdHBPOGUzMjNNc0JtbDljSFFGaE5jUDZVVkZwTU5FUjFI?=
 =?utf-8?B?S3kwUzhmYlZUNG16dUU4S3hLSldQV3pEREcwalNycm1NTGZUbDNmN1FLcFRI?=
 =?utf-8?B?bkJVU29Pa3NQRkRrMXN1cEJDeTBOMFJOSGc2ZU9ZaEtiRk5KTGMwN0YzYURl?=
 =?utf-8?B?bHNPOFpET01Vci9BMDhCQW9mYzgweUVwdHpRRm1na3dFV0FHUUpRRmhIY1B1?=
 =?utf-8?B?Vi95UzdDRFdyUXFuSytjUGduWGUwZkw4SjNoQ1BRQkNXT0NjSjJHc3JLeFZK?=
 =?utf-8?B?K0Mzb0NWL3JyTzZGUS80TUErOGF0YUpBNFAxRnVrU0R0Ni9YVjQ5OWRhZndl?=
 =?utf-8?B?UFB3YTRuVjNpaFBTcklucG9DcEQvK1RCTFZDRDlpb0d3bzJEL3Y2d0R0VjY3?=
 =?utf-8?B?VVZhNUVrSTc5Z21GSUlsemdueFhXL1cvUnVSaERoZTJra0dqbGt2Z2ZoVzlu?=
 =?utf-8?B?WkxSdHVESXMrZVRpL05ORXh6SEs1dnJCMWZQODB2RElySzZ6bjRueWVYc3JC?=
 =?utf-8?B?aWg0S0ptSkFoWXJLam0zakRqTlBqKzZ6MWtkc1RZcFpXUDc2cWJsdHluNWVR?=
 =?utf-8?B?MlNoRjRKZk5rcHd1am1QUXpBRTljTDVzUURFVzNPYzhlaFNwUnBMdjZCS0s2?=
 =?utf-8?B?TDNWeWVKWXJkZ0FCeEhNR2x0M2taQk1kZDY5dWpucmo3RVRIOEhmUDNhemZB?=
 =?utf-8?B?bmNxZDIveHV3Y3ptQ1h5cXl2bUUzTTNacVQvS1RLR1N5Q0kvSklOKzZHRGhi?=
 =?utf-8?B?TWl2NmdKcVhYUzJ1bUFiMVN1bmlQcVpRdGh5eHJiYUZ1SjVBMnRhSEU5Rm1y?=
 =?utf-8?B?L0tpWEJ6QlBVQVNPdWZ6S0U3b05xVlB0NGMvMUNDWFpuaytrRmhlNjhGcndu?=
 =?utf-8?B?VjVWZ051dCtpbHVvVzRBR2ZibzVPYjNybTAzVExTZ3NwZ0VpbzVLY3VvSStY?=
 =?utf-8?B?akxpVWNKMjhERlBTZUdlSlhzZVdGSll1ZkpyRjdERURNM0JhVFcybUVPVW9a?=
 =?utf-8?B?NzNOUVY4NVdGNEhKeHZZMWpMMzAyUmxzY25yTW9yaXhNMmhvemlJOVlWTGov?=
 =?utf-8?B?R2QyWHdhRHBvcDU1anlxTmxLODYvN1QyQzAyY0t1cXRxK3pDcFdCMlFMQkZZ?=
 =?utf-8?B?VFJrQkxDdUFuekdqYjNGNUhuSC9MMWZNSERWcWJHZzB0WllBQUdEaXE1RmpS?=
 =?utf-8?B?bTgxUmppSm1zK2UrMlFFZm9QVlVRdjBxRVhWYzNjNVpzZFRYUDI1TG1ITHYy?=
 =?utf-8?B?Vkd6T0ZUSTBiNC96bjhrbTdZZndSZ0xSd08rYnZISUFDTFl1VUtNVUxFRUN6?=
 =?utf-8?B?NkM1dGlHRVUyaEpIVTJtSEFCRThrWnRrL0VmcDEyanlMeklaSXpSUHdEY2ZJ?=
 =?utf-8?B?QityQUJLb1hSYmtEU05zOXErcHIvMHpEQXFscENZYTZNQzlRWWJ6QXdneFJE?=
 =?utf-8?B?Wk9OT0ljL1dyTUduZmVORTV5WEc4VnpvVmdRSnlZVW1odXI2M0VoQ2VIb3Vj?=
 =?utf-8?B?RGl2Y1Y1emZlWkxSQzVGdzNhMm4vZlVLcUxyNDNZOFBpK2g5SkNQQ2NLbTJL?=
 =?utf-8?B?QTFaZTY5amNYWnlyTU8wWnU0UVZKL0FWU2xkZDl5N0tOcU1TaEdjT2RoZ3h4?=
 =?utf-8?B?MTNwa0I1V0hJeUZRcUlMNGhHNXNSRHkwa3R3TjBXQmFWVjM0djd6bHhCM0Zq?=
 =?utf-8?B?NzBtd1BXRHhwbkxUbGxJYkhBa2JGQlNUN0NsdUdydGR5cGJabHp5UW1tdFpF?=
 =?utf-8?B?S3BuTHFFSGhsM1V5MXNGSUpDcnpUNFRLRVVxaUFjQW1SMU11THdhM3JZc0l6?=
 =?utf-8?B?bzRkeGtZVDR6Y0JiMHJQYndXMTVVbG9DaHNPVU9CaEk1Vm0rKzJTcDRmRE1i?=
 =?utf-8?Q?yRNxIhlfrcGqG7ZYUVNCgZ8ZL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f861412d-cbff-4ae5-4603-08db7954b07f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 10:28:05.2846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvRZif3JeNSZ+GkZXa65E/J9Ik/ip0P1dYW9L78UaPLf2dXE1lrZs0RIO7Vg9tCd7aDT2LFnGC4TRbzN9q3W0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 05:34:28PM +0800, Yang, Weijiang wrote:
>
>On 6/17/2023 2:57 AM, Sean Christopherson wrote:
>> On Fri, Jun 16, 2023, Weijiang Yang wrote:
>> > On 6/16/2023 7:58 AM, Sean Christopherson wrote:
>> > > On Thu, Jun 08, 2023, Weijiang Yang wrote:
>> > > > On 6/6/2023 5:08 PM, Chao Gao wrote:
>> > > > > On Thu, May 11, 2023 at 12:08:46AM -0400, Yang Weijiang wrote:
>> > > > > > Add handling for Control Protection (#CP) exceptions(vector 21).
>> > > > > > The new vector is introduced for Intel's Control-Flow Enforcement
>> > > > > > Technology (CET) relevant violation cases.
>> > > > > > 
>> > > > > > Although #CP belongs contributory exception class, but the actual
>> > > > > > effect is conditional on CET being exposed to guest. If CET is not
>> > > > > > available to guest, #CP falls back to non-contributory and doesn't
>> > > > > > have an error code.
>> > > > > This sounds weird. is this the hardware behavior? If yes, could you
>> > > > > point us to where this behavior is documented?
>> > > > It's not SDM documented behavior.
>> > > The #CP behavior needs to be documented.  Please pester whoever you need to in
>> > > order to make that happen.
>> > Do you mean documentation for #CP as an generic exception or the behavior in
>> > KVM as this patch shows?
>> As I pointed out two *years* ago, this entry in the SDM
>> 
>>    — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>>      holds: (1) the interruption type is hardware exception; (2) bit 0
>>      (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>>      (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>>      indicates one of the following exceptions: #DF (vector 8), #TS (10),
>>      #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).
>> 
>> needs to read something like
>> 
>>    — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>>      holds: (1) the interruption type is hardware exception; (2) bit 0
>>      (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>>      (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>>      indicates one of the following exceptions: #DF (vector 8), #TS (10),
>>      #NP (11), #SS (12), #GP (13), #PF (14), #AC (17), or #CP (21)[1]
>> 
>>      [1] #CP has an error code if and only if IA32_VMX_CR4_FIXED1 enumerates
>>          support for the 1-setting of CR4.CET.
>
>Hi, Sean,
>
>I sent above change request to Gil(added in cc), but he shared different
>opinion on this issue:
>
>
>"It is the case that all CET-capable parts enumerate IA32_VMX_BASIC[56] as 1.
>
> However, there were earlier parts without CET that enumerated
>IA32_VMX_BASIC[56] as 0.
>
> On those parts, an attempt to inject an exception with vector 21 (#CP) with
>an error code would fail.
>
>(Injection of exception 21 with no error code would be allowed.)
>
> It may make things clearer if we document the statement above (all
>CET-capable parts enumerate IA32_VMX_BASIC[56] as 1).
>
>I will see if we can update future revisions of the SDM to clarify this."
>
>
>Then if this is the case,  kvm needs to check IA32_VMX_BASIC[56] before
>inject exception to nested VM.

And KVM can hide CET from guests if IA32_VMX_BASIC[56] is 0.

>
>And this patch could be removed, instead need another patch like below:
>
>diff --git a/arch/x86/include/asm/msr-index.h
>b/arch/x86/include/asm/msr-index.h
>index ad35355ee43e..6b33aacc8587 100644
>--- a/arch/x86/include/asm/msr-index.h
>+++ b/arch/x86/include/asm/msr-index.h
>@@ -1076,6 +1076,7 @@
> #define VMX_BASIC_MEM_TYPE_MASK    0x003c000000000000LLU
> #define VMX_BASIC_MEM_TYPE_WB    6LLU
> #define VMX_BASIC_INOUT        0x0040000000000000LLU
>+#define VMX_BASIC_CHECK_ERRCODE    0x0140000000000000LLU
>
> /* Resctrl MSRs: */
> /* - Intel: */
>diff --git a/arch/x86/kvm/vmx/capabilities.h
>b/arch/x86/kvm/vmx/capabilities.h
>index 85cffeae7f10..4b1ed4dc03bc 100644
>--- a/arch/x86/kvm/vmx/capabilities.h
>+++ b/arch/x86/kvm/vmx/capabilities.h
>@@ -79,6 +79,11 @@ static inline bool cpu_has_vmx_basic_inout(void)
>     return    (((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
> }
>
>+static inline bool cpu_has_vmx_basic_check_errcode(void)
>+{
>+    return    (((u64)vmcs_config.basic_cap << 32) &
>VMX_BASIC_CHECK_ERRCODE);
>+}
>+
> static inline bool cpu_has_virtual_nmis(void)
> {
>     return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index 78524daa2cb2..92aa4fc3d233 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -1227,9 +1227,9 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx,
>u64 data)
> {
>     const u64 feature_and_reserved =
>         /* feature (except bit 48; see below) */
>-        BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
>+        BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) | BIT_ULL(56) |
>         /* reserved */
>-        BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
>+        BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 57);
>     u64 vmx_basic = vmcs_config.nested.basic;
>
>     if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
>@@ -2873,7 +2873,8 @@ static int nested_check_vm_entry_controls(struct
>kvm_vcpu *vcpu,
>         should_have_error_code =
>             intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
>             x86_exception_has_error_code(vector);
>-        if (CC(has_error_code != should_have_error_code))
>+        if (!cpu_has_vmx_basic_check_errcode() &&

We can skip computing should_have_error_code. and we should check if
IA32_VMX_BASIC[56] is set for this vCPU (i.e. in vmx->nested.msrs.basic)
rather than host/kvm capability.

>+            CC(has_error_code != should_have_error_code))
>             return -EINVAL;
>
>         /* VM-entry exception error code */
>@@ -6986,6 +6987,8 @@ static void nested_vmx_setup_basic(struct
>nested_vmx_msrs *msrs)
>
>     if (cpu_has_vmx_basic_inout())
>         msrs->basic |= VMX_BASIC_INOUT;
>+    if (cpu_has_vmx_basic_check_errcode())
>+        msrs->basic |= VMX_BASIC_CHECK_ERRCODE;
> }
>
> static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index d70f2e94b187..95c0eab7805c 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2748,7 +2748,7 @@ static int setup_vmcs_config(struct vmcs_config
>*vmcs_conf,
>     rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
>
>     vmcs_conf->size = vmx_msr_high & 0x1fff;
>-    vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
>+    vmcs_conf->basic_cap = vmx_msr_high & ~0x7fff;
>
>     vmcs_conf->revision_id = vmx_msr_low;
>
>
