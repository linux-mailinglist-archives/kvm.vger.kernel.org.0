Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB87743B88
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 14:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjF3MGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 08:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjF3MGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 08:06:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BC34230;
        Fri, 30 Jun 2023 05:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688126742; x=1719662742;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0+YGoY3HZtk4iT0z9CPCpyjHBWCQA4+ecRFehD8KVj8=;
  b=kGEBRTagQgvJ/SAYqzq5gyC7WKFcWa3Z0pz7lPFIV5Iw+QyNURv42g7s
   WYQFbQbitdrrKAMdw5H2saCzJzvEtAP9VOGDSMXRLYuTWgSaEuprl2Mjl
   XenuZOA5uFf1cXYM33+qPxdiA2VMRyRiFOKRTBEfMUPm+B+H2Pkh1hX9k
   MU6OY37g+z83OqDMXtm+gIAtooL/Wi0CnmChwFT3Sj9E4tn8EB8hTrs82
   d+OXT85qbkWXo+aBNSQ2t2ssL8Lb8tm8h99CnW+5yUH0YZoxhcxqWGmJW
   K3W09XAzJv+ElVJ9Wg/8l9dEipZaxwxA/Tzq7g5TyajApu2X8i9xtKtuK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="428422098"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="428422098"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 05:05:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="747406066"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="747406066"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 30 Jun 2023 05:05:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 05:05:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 05:05:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 05:05:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmv0LHUcCrTnnBv4LpPkeVDuCkaaNn+0ET38YYps4sjop01n/tSsWrwH1CLtTKTtpbhVLqldGtzemQT7c70lwCX5vvKNjC/mjaU+AbhmyMt2jg8Is5U/GFUZqSoXqjJxTxEL0+7/B1troJJ4HRJIkooXhTWOdvxRowtqDFvUDGbiCNGsfWhjDN0w3URjSx2/v/wK8nYCg5c0wuKf1ijcnioWSqXgKlZ9zeWMz1VQThl6SexBNfpsO5CTxhTk06aWwvlD0rSjzbBeXNmr5GQcxDQFEn4frqmNTLYin2SkkTBTJUN7m0N1wjn3zO+Jkkd9zFQvnrMqreOK3icCING/ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzSjUzoWbrZsTEQ2+w+i+Sx+KBFll3oyEDVxR62sPH0=;
 b=B7Jy1Fe6Xmm27vEhY3CZ1xM2q7wZEKN0+z7KXS9eQCc2cuqn1KZXPxehDTNpxJ3URCxbJ1SgOqpFF6k25GysMR+ElGhCLfHL9cZJ7OOkTMp0EUKi8pLALsmvyIbaUxmtAL/AI95s4p9mjhUlaJO3h92PT5GwVpt3DeHkiAZ/WgqdsdsoxS9ShE+YoBNA9xdbAiXbtnqELThb3ZxORi2s9ia5Ew6Ce3JDzKP38PUb7eludKc5NQwa4NVX41VzZKwpj9LwMZTIvuPJpFOxLpRQ+cohwHZZSJWliv8kCaTNQ6wvzL16OS2300ftWI1R047QKz5WWCG63NRH/JwWyROBkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB5421.namprd11.prod.outlook.com (2603:10b6:5:398::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 12:05:31 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6544.012; Fri, 30 Jun 2023
 12:05:31 +0000
Message-ID: <8dec8b09-2568-a664-e51d-e6ff9f49e7de@intel.com>
Date:   Fri, 30 Jun 2023 20:05:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
To:     Chao Gao <chao.gao@intel.com>
CC:     Sean Christopherson <seanjc@google.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>, <gil.neiger@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
 <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
 <ZJ6uKZToMPfwoXW6@chao-email>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJ6uKZToMPfwoXW6@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB5421:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f14c017-6b7d-411e-3ff5-08db79624cc7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ev0oXatxadbzDY7XVNdLZbOX3JwUX4JkhhS3+04g+bgZ9ofRD4vf6vBFhq8d5kM9ymlMUXEuTu10PfmiCv5rxnz/UlO2H9bnX6nBW/IhZS11K+qAkHS6FY4Pp5+0Ix8dJdfO4QHMIMrT/N86YvIJlif4SjnVyNo6LwJ52CDx5H5D0cSm7bO1wLeKrPXlczs8dwV+KNw7k95lzsUvjQMb8ctLUWR0+BWm18G20ySRRIvsFZZ0Y657WqK05pSBUcbAdWg1KUocp4VT9PrPoknS9Gr7LL7ByPE+BJUp9Iipzts/ugBKpAnxJmM1I/loCS1tCA1gtMsKiYnKqnWK8BcDZpB8hE0Eiv2KJXtFeDGf6U4Zs0j7NbcVIiiR48UtOE/9PFXBDx+qZWhXTfrmXvBLe3Ik/MmT+Bi6ohRT2kyhxcwZOLACHABFulzeQcvy6UoSlkCv6wVHKP359zK5U6dlX43+qdiVX5dqv3KBd9pJssWyYlydZ3SQhBePaAxwZmpleZBsRMpDA/c4SifQ7w94G2++obaXOMmT7raJqjNmfjSJyWZh9yUOjHUzsF1hY2jLGMXckY64v5cjxOWYs7kdgHJyrVsObZs149f2TV1BZbAklEv/DeTEOzX9kBjLYte5N2ezvEfkG8FBxrzNw1hByw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199021)(31686004)(8936002)(8676002)(5660300002)(66946007)(66556008)(66476007)(6636002)(4326008)(2906002)(316002)(6862004)(41300700001)(37006003)(478600001)(6666004)(6486002)(53546011)(6506007)(2616005)(83380400001)(36756003)(6512007)(186003)(26005)(82960400001)(38100700002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjBZZ0RxQTlSWVZaWjJBdGJFVi8vS2ltSVEwYkxWL0Q4WS9yQXNhRWFabHZh?=
 =?utf-8?B?dDMxTk9Ubi9oM29rRXJjUVlTT0o5bGtMTGNLNHhxWDB5TGFGQllVUENBdDZS?=
 =?utf-8?B?SHR1dkFNOVRudkIyYmNBZ09zUzFrRFBGYmNPRU5XYnBEbDlKMDV6ak9TOWFW?=
 =?utf-8?B?dGp3MkpSdGRmOWdQc3JVUUhta0tkUmI5RFIvb3Q4c0d3N1pvcVc0cWNnU1Iw?=
 =?utf-8?B?OWoxb3RRSzZIV0V0aU5LUmFWa0FJNWo0eGp4enk5RElscUF1ajFSQjJoRFlZ?=
 =?utf-8?B?ZnljTWtHVXFpdUJ3YldrQVlGNDE5blJxcjRjQW5hSG1sdGFFa2VkZVBUY1Ji?=
 =?utf-8?B?V1JWQUNLUXpuaGVvdGVFekhTZXdVcm1MNDRqZlo1VS9WeDczMmZzUCt4UDUv?=
 =?utf-8?B?Uk5qVVpXVnZHT3JtSHBkRGZYNzJOOG1qMlM0VGg4eWRQb2FUeUlRL01iMGRS?=
 =?utf-8?B?TjRwdUdVT0JuanlqOGY4TUtuNWtjTVdpYU0wbTZkOVdoSFVqeDJtVWVDWjV2?=
 =?utf-8?B?bU5nN1NUZlh2YUV5T2hqdXhkVjhKTHV1REgxZXlFem1YaUs2RzdHbzlZOVA5?=
 =?utf-8?B?dlA3Q0Z5cy9xZFY0T0hXNXluS0tHeHhqY0xoamw5MXhxakhpZUJuR0dJUDJa?=
 =?utf-8?B?Z0ZVYm43bjhZOFoxeFlnWkx6NldqWFZGZzYxOTdZcHRHOFFyaS9LaXg3VWV1?=
 =?utf-8?B?RXRmcDJYQ2F4NTIwU2s2S21ocDVnRFdjSWVianliQWs0bW8yQWlGNmhxcURL?=
 =?utf-8?B?QlA1bS9oQWNqNHhoNWhiVFBjVGxSWXJIdnFncWt5Y2RqRGdpancxWGNzRWJP?=
 =?utf-8?B?aERqYVlnZ2wxa0tmK3c5RG1nV2piKzhvY2kxbFB4Nmx1WGlwbUR3cjdscTQ4?=
 =?utf-8?B?YS96Z0Q0TkRhNm13d3VxdGJhdDA2MlgyemFmdXc5RXppWlVpbzJreHJlVHNX?=
 =?utf-8?B?ZVpnZmVLOUkvMGlGR25ONVUzamNDbDF4SGsxKzhzVGcvdHF3Y1dkWGtDUVpz?=
 =?utf-8?B?ZG9jK2NiUTRMbDBpSG1WSzNac0VaY2pzTEN1bnZCblN3bDhaVEhJaUNHaWE1?=
 =?utf-8?B?MmNVWlN5NHhzK0s0eDBZV1Qzd3FnNmkrZUJRMlhKY2MwdDZ0KzJzT3NFZ3A1?=
 =?utf-8?B?Y2g3Ni9YZVhteTd5MHpvWmw1N0NOY1dtU3JibEk3QzZNTk5XR3daemkrMFFk?=
 =?utf-8?B?Y2l3aDNQeGNIRTFESXhZK2N6OFM0Nm9zU2ZQUnF4NmVsOGdHRktUVFdrWDFz?=
 =?utf-8?B?TGd6ckloOE1zaTM2ZWE0ZnQ3WlNXMUpYQW4wQksrZlo4cUxqY1cvcktrNU1D?=
 =?utf-8?B?NWd1YmcwaUZmMHd2K1FxZHRESWpqTlpzQUlIMHpJV0hyanpoUjJIUFd1ZUxq?=
 =?utf-8?B?VU1OeUtkV2NwSE55b2dhN3hhRVkveWJ5SVkxUFZlSmJmMnhlSm8yOC9ha0VI?=
 =?utf-8?B?cDFvbjJvVDVlUzRobGZDblVWb1ZSdTdQY1BlLyt1bE9RNDNJQ2l1TUNiazNY?=
 =?utf-8?B?QUpKSkJVem1QeEFLUlEvZjUyU0hUN1dTUTB6Y3ZxbGszNjdGNVFkL3lGMEIv?=
 =?utf-8?B?bWFTUk1aZXZwemhpUzV3Sm40MmZIaFpKOUVzL0hSYnRwTE5VMWVoMk1aN3FI?=
 =?utf-8?B?ZjgyTi9UOTB2OE9VVkZ2MHRseC8zTUorNTdkMERPdWtkMnhIeVV0ZUFJWFJ4?=
 =?utf-8?B?Q251a1N3K3p5K0dvSi9hdmFQN3NJcjFrZTdzSHVzK1E3Vk9SZHlseUxNNmJC?=
 =?utf-8?B?RWR1V1BDSkJZR2FJaFFVZTFEK213dDZQREluSUdPN2xnazhoTU9jUVFzKzYr?=
 =?utf-8?B?RzAwZk1zSFFnTG5rWSt0b09BMHN2bUc5VWFXeUNiMjJ2K2FXU3Fidm9tWER6?=
 =?utf-8?B?K0w2dU9UTFJFRm9zaEJVRlk5djdRKzhFVFgzVStYc3JtampUVTI5S01RQWZT?=
 =?utf-8?B?dGxTZWpoS0h1YmY0K1lsY2orOGN6YnJ5WXFlR2hwUjJtdG1aNnVnanJPUHNM?=
 =?utf-8?B?WkVDRFdzTTg5ZHhsdlpZdDFPTWVoUzNPWUs0dkZXMWMzOHNubXZyUGdHT0tq?=
 =?utf-8?B?YlJWci8xK0p2ZnV0TDV0OWpnRjV4UjFlWmlWOXMrQlRyY2NET1ZYZWpNbEl2?=
 =?utf-8?B?M04xM0RmZWZMR0pYUzZ0M3RXUzFlZmFXZVIwM0RaeHJMazNua3BhZzJDdGlw?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f14c017-6b7d-411e-3ff5-08db79624cc7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 12:05:30.8515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dq4n8FhUt/C49c9vy/+oZ0JlANXNVm76fZCBWg6V9rZvWnWUj4eJRDIY0j7xpmGR65z54LSw2z9WQ1CKa0edJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5421
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/30/2023 6:27 PM, Chao Gao wrote:
> On Fri, Jun 30, 2023 at 05:34:28PM +0800, Yang, Weijiang wrote:
>> On 6/17/2023 2:57 AM, Sean Christopherson wrote:
>>> On Fri, Jun 16, 2023, Weijiang Yang wrote:
>>>> On 6/16/2023 7:58 AM, Sean Christopherson wrote:
>>>>> On Thu, Jun 08, 2023, Weijiang Yang wrote:
>>>>>> On 6/6/2023 5:08 PM, Chao Gao wrote:
>>>>>>> On Thu, May 11, 2023 at 12:08:46AM -0400, Yang Weijiang wrote:
>>>>>>>> Add handling for Control Protection (#CP) exceptions(vector 21).
>>>>>>>> The new vector is introduced for Intel's Control-Flow Enforcement
>>>>>>>> Technology (CET) relevant violation cases.
>>>>>>>>
>>>>>>>> Although #CP belongs contributory exception class, but the actual
>>>>>>>> effect is conditional on CET being exposed to guest. If CET is not
>>>>>>>> available to guest, #CP falls back to non-contributory and doesn't
>>>>>>>> have an error code.
>>>>>>> This sounds weird. is this the hardware behavior? If yes, could you
>>>>>>> point us to where this behavior is documented?
>>>>>> It's not SDM documented behavior.
>>>>> The #CP behavior needs to be documented.  Please pester whoever you need to in
>>>>> order to make that happen.
>>>> Do you mean documentation for #CP as an generic exception or the behavior in
>>>> KVM as this patch shows?
>>> As I pointed out two *years* ago, this entry in the SDM
>>>
>>>     — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>>>       holds: (1) the interruption type is hardware exception; (2) bit 0
>>>       (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>>>       (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>>>       indicates one of the following exceptions: #DF (vector 8), #TS (10),
>>>       #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).
>>>
>>> needs to read something like
>>>
>>>     — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>>>       holds: (1) the interruption type is hardware exception; (2) bit 0
>>>       (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>>>       (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>>>       indicates one of the following exceptions: #DF (vector 8), #TS (10),
>>>       #NP (11), #SS (12), #GP (13), #PF (14), #AC (17), or #CP (21)[1]
>>>
>>>       [1] #CP has an error code if and only if IA32_VMX_CR4_FIXED1 enumerates
>>>           support for the 1-setting of CR4.CET.
>> Hi, Sean,
>>
>> I sent above change request to Gil(added in cc), but he shared different
>> opinion on this issue:
>>
>>
>> "It is the case that all CET-capable parts enumerate IA32_VMX_BASIC[56] as 1.
>>
>>   However, there were earlier parts without CET that enumerated
>> IA32_VMX_BASIC[56] as 0.
>>
>>   On those parts, an attempt to inject an exception with vector 21 (#CP) with
>> an error code would fail.
>>
>> (Injection of exception 21 with no error code would be allowed.)
>>
>>   It may make things clearer if we document the statement above (all
>> CET-capable parts enumerate IA32_VMX_BASIC[56] as 1).
>>
>> I will see if we can update future revisions of the SDM to clarify this."
>>
>>
>> Then if this is the case,  kvm needs to check IA32_VMX_BASIC[56] before
>> inject exception to nested VM.
> And KVM can hide CET from guests if IA32_VMX_BASIC[56] is 0.

Yes, this scratch patch didn't cover cross-check with CET enabling, thanks!

>
>> And this patch could be removed, instead need another patch like below:
>>
>> diff --git a/arch/x86/include/asm/msr-index.h
>> b/arch/x86/include/asm/msr-index.h
>> index ad35355ee43e..6b33aacc8587 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -1076,6 +1076,7 @@
>>   #define VMX_BASIC_MEM_TYPE_MASK    0x003c000000000000LLU
>>   #define VMX_BASIC_MEM_TYPE_WB    6LLU
>>   #define VMX_BASIC_INOUT        0x0040000000000000LLU
>> +#define VMX_BASIC_CHECK_ERRCODE    0x0140000000000000LLU
>>
>>   /* Resctrl MSRs: */
>>   /* - Intel: */
>> diff --git a/arch/x86/kvm/vmx/capabilities.h
>> b/arch/x86/kvm/vmx/capabilities.h
>> index 85cffeae7f10..4b1ed4dc03bc 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -79,6 +79,11 @@ static inline bool cpu_has_vmx_basic_inout(void)
>>       return    (((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
>>   }
>>
>> +static inline bool cpu_has_vmx_basic_check_errcode(void)
>> +{
>> +    return    (((u64)vmcs_config.basic_cap << 32) &
>> VMX_BASIC_CHECK_ERRCODE);
>> +}
>> +
>>   static inline bool cpu_has_virtual_nmis(void)
>>   {
>>       return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 78524daa2cb2..92aa4fc3d233 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -1227,9 +1227,9 @@ static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx,
>> u64 data)
>>   {
>>       const u64 feature_and_reserved =
>>           /* feature (except bit 48; see below) */
>> -        BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
>> +        BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) | BIT_ULL(56) |
>>           /* reserved */
>> -        BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
>> +        BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 57);
>>       u64 vmx_basic = vmcs_config.nested.basic;
>>
>>       if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
>> @@ -2873,7 +2873,8 @@ static int nested_check_vm_entry_controls(struct
>> kvm_vcpu *vcpu,
>>           should_have_error_code =
>>               intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
>>               x86_exception_has_error_code(vector);
>> -        if (CC(has_error_code != should_have_error_code))
>> +        if (!cpu_has_vmx_basic_check_errcode() &&
> We can skip computing should_have_error_code. and we should check if
> IA32_VMX_BASIC[56] is set for this vCPU (i.e. in vmx->nested.msrs.basic)
> rather than host/kvm capability.

Oops, I confused myself, yes, need to reshape the code a bit and use 
msrs.basic

to check the bit status, thanks!

>
>> +            CC(has_error_code != should_have_error_code))
>>               return -EINVAL;
>>
>>           /* VM-entry exception error code */
>> @@ -6986,6 +6987,8 @@ static void nested_vmx_setup_basic(struct
>> nested_vmx_msrs *msrs)
>>
>>       if (cpu_has_vmx_basic_inout())
>>           msrs->basic |= VMX_BASIC_INOUT;
>> +    if (cpu_has_vmx_basic_check_errcode())
>> +        msrs->basic |= VMX_BASIC_CHECK_ERRCODE;
>>   }
>>
>>   static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d70f2e94b187..95c0eab7805c 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2748,7 +2748,7 @@ static int setup_vmcs_config(struct vmcs_config
>> *vmcs_conf,
>>       rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
>>
>>       vmcs_conf->size = vmx_msr_high & 0x1fff;
>> -    vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
>> +    vmcs_conf->basic_cap = vmx_msr_high & ~0x7fff;
>>
>>       vmcs_conf->revision_id = vmx_msr_low;
>>
>>
