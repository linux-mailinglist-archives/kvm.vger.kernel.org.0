Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADB6670F02
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 01:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjARAtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 19:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjARAsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 19:48:12 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B6732E49
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 16:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674002110; x=1705538110;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zuwqEWzsthdBzvM590EoQgYXA+4HUt8MUKzNjmQa+I8=;
  b=aMIFkI9pSvr/rQL2umLbSOA6/tLTfxZ8TIV/RTTFam9azW9n5RONH5sm
   ZJ/ASFpr2QI6nUuTtMPbrhxLv4Sn7D3d8i0bbpW5XzpfOab5XOn4H49tU
   /Q8zWpOVpwqfHndNEBR1sflTcudt5gSvCxEWuTHUtpzl4pVxlUYY0Re8y
   Md971faHnUmER8wSggLQ6bTCg0TPRTkYKql7exawZh8u0m2hEzojoHsyG
   GezTdluEyvd1bduzBiUUTecjdkY38vtY7VmpDKQI9jf61f5Tp5oyurmLx
   jmwYOwSYS0veSCe3XjRvo35HxxqbhgfLKSdMQJReqV77eOJzoshIJmmuR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="387209354"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="387209354"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 16:35:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="833355252"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="833355252"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 17 Jan 2023 16:35:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 16:35:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 16:35:08 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 16:35:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdD40z0t9veF50eLnXdNPonPrHzrXYQTOXwNftaUBaU0zt2ioGn3URgtQhZzQEd12PCgElZ212DmpvYhbhZs5Ex/rtJ/zz+Dx7DBf4fQZTQry5iTLxrRctU1kwbkstG0BW0+Q6u9Bx2NFxH5IOkEPnw5o1zilFURjqoTFidB++zT1ampiFqBa7LWHNjETwx95V7CgtaG//YuMpHugjHKjXjQGYuUnZ77uUUL3sRidmmbe1eaZfkGF23ZWWvY5HxxC96AaXVrRGGFqAvBl340sKcThFA0N9MSn89z5o7T1NC/bMyxzKMG+ZkVikiWiyTR+v3R7SgN1OKw7FlFf2b0Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k08ID9kT+Kj/2uHHMWsf2uFpYzpd+Z2Dt+1RWHNi39k=;
 b=ZDTpzVt0Fd7SUMAPn3hCg0A7HXYi34nLTqPiFL3pT4ZKItpSUs2hV5M1aBzWt/Bff+aFc12h+57yOFe6XQ0KCtlKXD1V+jgZ8xo6f5bOdSeutstc1e8/ZlxHRf42TSFykYHxSJ+lh2K7Fp/rCUMCDUCkiCPKNN2vXENPyH3iNSazVjUl4BDeZELsyaKy2i3eOv1M7uTCuWWgbt1pPClp0vNwqgOvUurJXb2YdN7CJiLMXH9wo2iGr0SEL+faGjHF+2aDHZT8Ts469EhoKIum8SsSN45WZLEjo0xk6S/k9a+Ve5w6jnGVONoN2Qy8qYGEMDiK23QkRO0MMnOF3oVevg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH7PR11MB6929.namprd11.prod.outlook.com (2603:10b6:510:204::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 00:35:01 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916%8]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 00:35:00 +0000
Message-ID: <315d3fd9-3809-eee3-cf7d-6530f7538fe5@intel.com>
Date:   Tue, 17 Jan 2023 16:34:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Mingwei Zhang <mizhang@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Neel Natu <neelnatu@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Venkatesh Srinivas <venkateshs@google.com>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
 <Y8BPs2269itL+WQe@google.com>
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com>
 <Y8Bcr9VBA/VLjAwd@google.com>
 <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com>
 <Y8B5xIVChfatMio0@google.com>
 <f65d284f-4f06-739b-a555-37d2811acdf3@intel.com>
 <CAL715WKmJ1BSozF18MOp=jRvMh-28fLWqBJvg87MaK8aOh33cA@mail.gmail.com>
 <CAAAPnDH21dqmHqiM2E3ph-qyEardx4-OkgRzRa27Qc3u2KQ+Zw@mail.gmail.com>
 <c3be155d-5cff-60ee-fb84-5bda693ea954@intel.com>
 <CAL715WLd2PJC71ObgZPcxSKdS+0H-o8Cscsfejw0cq5BGgOx-w@mail.gmail.com>
Content-Language: en-CA
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <CAL715WLd2PJC71ObgZPcxSKdS+0H-o8Cscsfejw0cq5BGgOx-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::20) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|PH7PR11MB6929:EE_
X-MS-Office365-Filtering-Correlation-Id: fd196f05-ad62-485d-8f6c-08daf8ebd53e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLbcJ1/eKO1uKv5Wb2EAsUh0ooFdTDx2b/wfAzeGvQixobEkn7sRmKj+eg3GLl8wd5z9EriBFNBLGOLDyj5r9KNRdPldYFBtpcEcCrrygzm7T4ANotZtBErNmwKRXfBCQSGsJMe6wLEeP54AuWFKJKcuZKkopiWCaWnslHYFsKglrLkHIVHuQpM6Fe4gxTEp7ms/S/hSeQmgjEXyYlpuCTN9PV2nO2nv8oWbxGF4yfRAINLjlG7owSbY6FqkKYBuwk3poY2y5Y2RNshtySMO/DyVBYtzd719oAt7/mXyhk6ZtM7uBjPBXkNJqrdz6iOurT8Q7oAwzLsipXie5J2uep0WPcl+TyR4CGkAdTGJvOzkeZSErZBnQCkMM7CjLKKZm/pvPeD4/GeIJgKggNKHOE1oAsfd9C7fpzrfnMaTuPYF8k1DUYBuKwBUbIwBgGWQnuevaTzmQ3rf4apuxFbfuD+X3tBrOv13mHReys5sTCOPIzONQMVqdLSKx4S8bXrja0NkdABd59fSLtWEap/7SazAB3N8CDjUA7hb6fIeiVs87rt3Sy2IVrdpaxfQN/iD6KCQ7zm4VF9deZcHdSDu7Vqy5fSy1cG1l7dbKprm+2UosIn1ZRebzhQyVgpBLa8VqREJs+Bzc6USbXrEFl+D0PfCL0ekcsYmfuzk28/S4RQa8xYdljA/TyU/XZYX8NtYNMtREWFLbnmrzwlO1CLsIdoaYeYoJivLYTnicK9kEceDtKAI5Zn4JfogeNVHgzqu4A6ICyAZDBHHajEjP8mbcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(31686004)(36756003)(4326008)(6916009)(66556008)(66476007)(8676002)(66946007)(31696002)(8936002)(7416002)(5660300002)(2906002)(38100700002)(82960400001)(966005)(54906003)(478600001)(316002)(86362001)(41300700001)(53546011)(2616005)(6512007)(6506007)(26005)(6486002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Kzkra2FkTDJsYVV0ZUN1RG5FOVdSMXVVU0tpSTVjc21laHVDbFoxeGlxMEY1?=
 =?utf-8?B?YlVqUkt4VU1KV2hJUmV0eE1DejFHemlsYWlGZ3BBdzJlbGU4QjVFM3IvU0Ro?=
 =?utf-8?B?ZVE2b0Q1N1NDeDE5MGJVeDBacWd0OFVwcVRkUnIwRW54UmI0VDdUU1FQYndi?=
 =?utf-8?B?SFp2TGxMcUlWRHI0dXpJWDRwcGJrSG1pRHM0LzhuMUQ1QkRhWlFQY0pjSlJQ?=
 =?utf-8?B?dWRNNVA5dUhLM3BQSFRuSCtXUGlwUWI2T1ZYNGFkWTc5OU1RblZLYktONHBL?=
 =?utf-8?B?TGxOQ1hUTnFZeDhiQklNL0oxL2lzeDNVNnRvZmFqa1h2RzBNczZIanlIWjNk?=
 =?utf-8?B?NUJ5MVUyYWZQUXhDRFdWV1V0aENmREpxOU9RVWJpQU1wajV6dVB1MXd5dktU?=
 =?utf-8?B?OXhvN0FvbVRNZi9OWHRKSHdYbjRrbHFjOEVhYTJLN0hJZDZpWTN3b1A5ZG82?=
 =?utf-8?B?Vkc5dTU3d2tjZWhkUzhGVmdWUlNjNmgvREVjUytUTXBlY0haZTVXY3FkTm5s?=
 =?utf-8?B?RXpXQ1dJUHJsZzJjbGhtcHBlRmUzd2JIVC9CMWx0Q3RMYTk1bkh4Uy9NcVBM?=
 =?utf-8?B?NE1yQ2E1ZlZjZTBiWXcwc25xRis3Y2JKdnpyRDRjYzRGNDV0VnNNWldHZHM1?=
 =?utf-8?B?emJ3QVFnaXhFRkFwdTdBY0tFbmVOczdtTTExRUpyQmlUTk5BQW1tOHpoSmh1?=
 =?utf-8?B?cDhSSDdveUxOemc2WWV1U0MyN2x2a0JvVTZyZmZUcWpTQXFqcnMrMWtaWkNp?=
 =?utf-8?B?ODFxT2tZMFZCOTZxbFFVTHloTE5GTWUyUHVRYkRjalNDTWRzTm4rZ2Z1amtX?=
 =?utf-8?B?c1p3UWs0UE9GZXdzSXFUbjhlQWVCRW5rYm15MTN5dXJERlh0QUx2RmpvTGk4?=
 =?utf-8?B?M1FIVnd3bm1Jd2NSWEF3dzllbzRuTWpTcG5RZjVxT1Q4TUJUeHA1T2lIRzNI?=
 =?utf-8?B?VFh4VjIwbjRpUEsveERZZ1lqdjBUbE5IL1U3TnJTb3pVMzluNjBvZ2pzK1Vw?=
 =?utf-8?B?dUpFQlNGZnhSQ1hhQlEyTkFRekMvaU1yNlFQWUZtNmsvdExvVzFiL2w2S01s?=
 =?utf-8?B?OTE3UFIxUDVjT0wzME8yaUt5V1pDeFNXT1dvQU9yVmQ2Q1lDY2hwQ0FnMFpF?=
 =?utf-8?B?ekZabE83L1hSbkc4b0NLdmVheHhLZ0Vuc2xQeENacHpCblBhbXNoUHdPZlQz?=
 =?utf-8?B?bEhIYnd5d1JMT1hjWVVTeUhCQ0tzN3Q0ck9EUzJHMmxncXREbWtPWGl3Wkk2?=
 =?utf-8?B?UjZrdDE0aldSN29IRk1LVE1PWnM2NGs0bW5xbFVzaFZhNlN3L21BMmpOTU03?=
 =?utf-8?B?ZkpBZTdlVVN4bmV4SmhHZjh1d1NtZThqakg0Q1V0aHZKcFZ5WUQxVEZhbkhx?=
 =?utf-8?B?d3BnWUd6ZVFJZGlLSGlDNGw0aVk2TTlSQWpVQ1J4MUpySnZiYWRHMzYyKzNi?=
 =?utf-8?B?TmluR2cvRGFDMm9ZWHMyYUxQOGUxUGRnU3cvclFEeUlwRW1Ec25ORldRN3hi?=
 =?utf-8?B?bXIwWksyZWFTM3dFcWV0dFVwUzJZcFFSZk8xY0pDYXFjbkJTRDl4UDNrbFV0?=
 =?utf-8?B?TS9Xd2VLK3htYmpMdkN0RWRqN0hVVUt0bDQyM3VZSVhzcEYyVFl4a2RRbFJB?=
 =?utf-8?B?QmdWeDNoRzlIV2FVN1QyZktLejBaQkR2azdtcW4zWnRqYTlQblNoTWNuMndY?=
 =?utf-8?B?a1RkWDllNlBMNS9KT0Q5U2tQakRLMjFGRzc1dkJCRjJwM0wvZVBVTG0vc1c5?=
 =?utf-8?B?WUdNL3VrTEJkeTlYc0hyUW96c1gvYjVYcWl6VFEyc1ZVM2sza0EwbWdKcDR6?=
 =?utf-8?B?YVljZnRxRkNERGdmUVNlMG5yRjVQZzNWTXZXd0J5ZDdyRUJ4L1VtTnVwK05k?=
 =?utf-8?B?TFExL1J4R2cxdFlvUFAxUDdOT3h3alR5NXhmY05XY0Rlb3EvM0lobTF0NXl1?=
 =?utf-8?B?dVBTN0Q3a0JxclFLeXplak93MlZlbVlza1l5UWNTVW9LRnE1MEhzMC9qb1lt?=
 =?utf-8?B?NTFxZnJEOTQ0cHk3SlN4M0xCS1VWSDNkaUJaMGpjSzhiVUhkR0lEemdUSjdF?=
 =?utf-8?B?TGxxQnQvNk5pRlFucCtVWjlHUjdPMFN0SytZbVVMdWJldENiYVg3aDh6RjQy?=
 =?utf-8?B?cVAxNWczMnIrTGp6UXJzc3ZzN3hCYmhjdXhOMmhpSFpicUJQMGdZZTFXT0pF?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd196f05-ad62-485d-8f6c-08daf8ebd53e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 00:35:00.8589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7phLIBCklMbrgCajdhcVKAtUgoSbR66vbRjBrTYcO0n3DeeFop/kfPgedlWmGZgLyAf2pTD+rYb+TEonoh61OTXuuYO//nkmj0IIg1Ls3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6929
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

On 1/17/2023 2:39 PM, Mingwei Zhang wrote:
> On Tue, Jan 17, 2023 at 12:34 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>>
>> On 1/13/2023 6:43 AM, Aaron Lewis wrote:
>>>
>>> I'd still like to clean up CPUID.(EAX=0DH,ECX=0):EAX.XTILECFG[17] by
>>> keeping it consistent with CPUID.(EAX=0DH,ECX=0):EAX.XTILEDATA[18] in
>>> the guest, but it's not clear to me what the best way to do that is.
>>> The crux of the issue is that xstate_get_guest_group_perm() returns
>>> partial support for AMX when userspace doesn't call
>>> prctl(ARCH_REQ_XCOMP_GUEST_PERM), I.e. the guest CPUID will report
>>> XTILECFG=1 and XTILEDATA=0 in that case.  In that situation, XTILECFG
>>> should be cleared for it to be consistent.  I can see two ways of
>>> potentially doing that:
>>>
>>> 1. We can ensure that perm->__state_perm never stores partial support.
>>>
>>> 2. We can sanitize the bits in xstate_get_guest_group_perm() before
>>> they are returned, to ensure KVM never sees partial support.
>>>
>>> I like the idea of #1, but if that has negative effects on the host or
>>> XFD I'm open to #2.  Though, XFD has its own field, so I thought that
>>> wouldn't be an issue.  Would it work to set __state_perm and/or
>>> default_features (what originally sets __state_perm) to a consistent
>>> view, so partial support is never returned from
>>> xstate_get_guest_group_perm()?
>>
>> FWIW, I was trying to clarify that ARCH_GET_XCOMP_GUEST_PERM is a
>> variant of ARCH_GET_XCOMP_PERM in the documentation [1]. So, I guess #1
>> will have some side-effect (at least confusion) for this semantics.
> 
> Right, before talking in this thread, I was not aware of the other
> arch_prctl(2) for AMX. But when I look into it, it looks reasonable to
> me from an engineering point of view since it seems reusing almost all
> of the code in the host.
> 
> ARCH_GET_XCOMP_GUEST_PERM is to ask for "guest permission", but it is
> not just about the "permission" (the fp_state size increase for AMX).
> It is also about the CPUID feature bits exposure. So for the host side
> of AMX usage, this is fine, since there is no partial CPUID exposure
> problem. But the guest side does have it.

I think this is still about permission. While lazy allocation is 
possible, this pre-allocation makes it simple. So this is how that 
allocation part is implemented, right?

> So, can we just grant two bits instead of 1 bit? For that, I find 1)
> seems more reasonable than 2). Of course, if there are many side
> effects, option #2 could be considered as well. But before that, it
> will be good to understand where the side effects are.
Sorry, I don't get it. But I guess maintainers will dictate it.

Also, I would feel the code can be more easily adjusted for the KVM/Qemu 
use if it is part of KVM API [3]. Then, the generic arch_prctl options 
can remain as it is.

>> There may be some ways to transform the permission bits to the
>> XCR0-capable bits. For instance, when considering this permission
>> support in host, the highest feature number was considered to denote the
>> rest feature bits [2].
> 
> Hmm, this is out of my concern since it is about the host-level
> enabling. I have no problem with the existing host side permission
> control for AMX.
> 
> However, for me, [2] does not seem a little hacky but I get the point.
> The concern is that how do we know in the future, the highest bit
> always indicates lower bits? Will Intel CPU features always follow
> this style?  Even so, there is no such guidance/guarantee that other
> CPU vendors (e.g., AMD) will do the same. Also what if there are more
> than 1 dynamic features for a feature? Please kindly correct me.

At least, that works for AMX I thought. I was not saying anything for 
the future feature. The code can be feature-specific here, no?

Thanks,
Chang

[3] 
https://lore.kernel.org/kvm/20220823231402.7839-1-chang.seok.bae@intel.com/

