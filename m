Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700596EC60E
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 08:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjDXGPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 02:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDXGPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 02:15:30 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034CF1BE6;
        Sun, 23 Apr 2023 23:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682316929; x=1713852929;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j45niiS2XCjsTvov+llYrYH39HVgrrv2JGayiftuhjg=;
  b=gZ+mAa9ayYk4q9xAZ3TNsfGYKOIFZJK4dvQqv+g4UAj8K6/1vakCmlzN
   05gMzQUVTe15XNusxWjRYz0SyZcK0ZUoHMoRdIA0yEHjF8eURubRIevYA
   a1uQYJ2okBMkpRTPeKOvB1RXYxp9xl+9AEY2n3F29hlbRQszHhPyTRKMN
   cajIwKA4jGEZ/ltzxLvll96dbIFCVX97ne5gEGXdB5TzesR9km/OIiJpw
   UoWXbjdCpwsqUVa/hmOP+wTDrz+4n5YtI06GO9WerE1fWPT6lcsOGejG0
   s37p3nNc2FejYEI2FTICugR+d9jmfahvuOec5uvbZupiBHR4VVLUu2HBU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="326690922"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="326690922"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 23:15:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="757569956"
X-IronPort-AV: E=Sophos;i="5.99,221,1677571200"; 
   d="scan'208";a="757569956"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 23 Apr 2023 23:15:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 23 Apr 2023 23:15:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 23 Apr 2023 23:15:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 23 Apr 2023 23:15:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRHE+loYynYQkI+WGzceDNCQENRPkPQ0DP/Xr7mjFHLHY2T3kotjxbgNpbnUDJYMKAnOj6o8cD2mA321xY8Yv1PulMnTdcavsnbjC3fkA05W554P09v0ZIBB5i0dJn2blWiU1sCu787HrUmBehKcpKFyZpW7akAl13tafz8PegyoVHg4Hg0DSIpIwQapJOtlfhJLP0HIlZbkVByoSxs+LvZcT0dhqoD5h1E/2dJYBvPrUffUDX/fkL8fW0+5jeM9eizvkRBhnu5oksIfRr2K0dn4vwNNSjyWY0UvlAiqKQmaHmtWQhV9KfwCJzeC+Nua2xyNEI+Lu/IKShSn2OCzGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bw6/iE+uuKTMd9KYT4yTacxRYcNIT52QUqfz7vOf0Ps=;
 b=Z/Hkvb5jViU3F3ZpqRO7ziOkqyh8MQPnnWwu9tyPKYhWYLs32kN+AKDlbVCaRTHRxEt26Ct1mMrBvu+npNmBBUAxXOzPTN1zi65i9R8Mz7ow6BXOFZwSbHUmf6FK8ZUIO4cXC2kJs9Pdm4xYj5dTkkp96W0785G6FHsjGKsZ2JWwc1IE4/AQFIL7irgOWMDgNwjabxqjFQEN2u6Ro9u1qLHbQBPkTfDejIB4ZzBcRsldRbz1+ka5Z+vTG22En0OQQ+Zi5qdirSfX15oWo+HdEP2d6jP2a/oVYm+I0GL44/FuH3GZeR9rkdcOoR25fEsZtdtqj+ALhLvUr4arRFup8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Mon, 24 Apr
 2023 06:15:25 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 06:15:25 +0000
Message-ID: <40be9675-0918-8099-da93-8d085ba738bc@intel.com>
Date:   Mon, 24 Apr 2023 14:15:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 07/21] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <rick.p.edgecombe@intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>, <seanjc@google.com>,
        <peterz@infradead.org>, <pbonzini@redhat.com>,
        <john.allen@amd.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-8-weijiang.yang@intel.com>
 <85f9bf76-05ec-8948-4ef1-42a57d641766@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <85f9bf76-05ec-8948-4ef1-42a57d641766@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: c315843f-61ce-471c-e1a4-08db448b4a73
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+65CGkuUzJyH0ZJ9Rhfz9i936R5vaRxpCindmXaduIP1w7bGLpx6iKeR0C+6W8DEuaOAPiV7ydBH0FBd39C1WkPKHtr5c5uxcGk4QqWuBmryxof9qS4S7Zyiu3n6IbkOz6tmle9mCLLVum7ad+tBm7uqv3Ppdndl2ASgmbJMeDsyCoZjGe3lj8OdkW5tBZhcQ4H1rENlaFAfrY71ET0YV9ZoiBihvIHuVGc84Jo1f8p+2pfIeF95RL7lOIbj1pMrc0zN1QyXR634PLMmiFFtwUeTaI6ASRiHyoquvet2VPPv6PI0q1xIZVW8+M9vTrqhxGYfAwAjwIVPbz8iyMHP439URPvAeR4S8mvn1GX+rE6jEqXcLPrqyfP6Q9B2jJbPbK+q7Dtr9+jn/eFe7ihinh0sADZegkdY+s7H7w8YzHylvUdWY0lIEZ2a7ULk6khipq2EJHftllWH1cvPFvz+YPRIHs9bTzL48rXZKDkDxLwtDIJb6Sps4/SwZJvqwTyYzfD0L7BjaS0nEBPEsBPIkmClm8ZmtfJmSrryNinzlvpL6k2tMSOqrAET9z5MHbH9xKJ6eC6t69Xwm+Rm1uBlVXmI3UkPeQ0wSlkSHNHnVjBernjmHmUrjPTI1fvqIacnzL7zgtvl0dEB3AQrOZJQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(66476007)(38100700002)(8676002)(8936002)(4744005)(2906002)(86362001)(5660300002)(36756003)(41300700001)(31696002)(6486002)(6666004)(6512007)(6506007)(53546011)(26005)(2616005)(31686004)(478600001)(83380400001)(186003)(316002)(82960400001)(66556008)(4326008)(66946007)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2FoWTM3QTd4TmdCL1ZET1pQYllBK0gvbnVDMUovSkN2N0grb1cyaEhxTXc3?=
 =?utf-8?B?MU5aQlNxaDhtNEhibmJVKzUwdUpsSXZBMytJTVpUNUZlRmdGR0xnMGdkRUFR?=
 =?utf-8?B?Q3htaitwclNlajFtNlEvdzJXZDNjZkp0MG1NMDZjY3RKN1Njd1B5WHlSakZF?=
 =?utf-8?B?MEdUbWlvUGRaeGhkajhNV1VhUEloY0hFYmwycy9jN1paUncwUFN5T01Bdy9X?=
 =?utf-8?B?bk8zSk03UWs4RkZrUnd1Wkg1N0pLY1RXTGR3UmUwT3pFOFYyVUZBWjRwcGtw?=
 =?utf-8?B?SDJtVzVTNTQvUVQrWEJ5ampIZURBejJ0L29iVGt5dUlFWTRWUE9NaGl6ZTF6?=
 =?utf-8?B?MEdKektRQTZpMDU5ak9aRVNxSit5VUYxaVRyVlZqazVxR2tNSkNYY21WVTZr?=
 =?utf-8?B?R0hkU0ZYR0hybGpoZDdFRW1rcE1VN0pUSUtSc2JXUlZ3eVBrYkloOTh5bk82?=
 =?utf-8?B?dDd0c2l3bDgvSkg2ZTQ4VkFmcEFTTE9TaVZMeENTT2xpaWRyWGFTUVZUWkNF?=
 =?utf-8?B?bGpTSjFwRHVJUTlxSW4yZVBBSTJTVzc0dUNBUFlhS25SQnJkRWJlMU1PelpC?=
 =?utf-8?B?S1E5eDcrOW5rQ3VxMFdUQXZ4ZmE5Z2tOazZDV3BQNHdONGM1emgvc0l4aUo1?=
 =?utf-8?B?TjRiVEtzOFJXVFBkMUcwMnVEUGJtS1pMN0hDVnpyVDRsV2l4MkMwOWtnc3RR?=
 =?utf-8?B?MlUyRkJRbWZmU2doamY2WnoydVJYVmo5REU1RWdZMWNLMWRqMTBGbGFvZFlx?=
 =?utf-8?B?cjZvT29tWURtVTJsQVhkQ3VBeWhUWW9CakNKN2d5L0hFSTUwWVV3Sm91NVRy?=
 =?utf-8?B?cHRuMHpaUzYyNzZUc3BPUk9CTTZNWDdMRFlaZnlQWlpxcFZyMVN4dFBFczlx?=
 =?utf-8?B?aVBxNDlBZnJGZ2paK3FGWWZESDJqbUNIVEd2eVV1OUhSelZ6cTlGRTRkQjRl?=
 =?utf-8?B?QVZ4bk0rajVJQzk3djg5bWQ4d3dkemxXL25kMkhMMmVYemNxQWRuUlJoWUw1?=
 =?utf-8?B?WktSOUQxNk0zSUxqL253ZlFtZlZVWUhjamMvK1ZSOGpYU0srZEx1UDRiSVdU?=
 =?utf-8?B?UVZnRXFXY2RRc1IyYmJXZDE1QUFRdE1mUjMvTHlsVkNSRFF1c3VHdG53MkNS?=
 =?utf-8?B?YW9ITFRGMVN3MHJXdjRBenVUOTVUZHVDZzFWM1VoaHVvb1JaWXRheEYvU0lU?=
 =?utf-8?B?SG1HeWt6UkRxQ2oxaUUxeTUzdEtiUlArZVVKVGsyWW0xNThSaWMvbFU3V2w5?=
 =?utf-8?B?dE5KRDhzdHJsWWRKSW9weXJTVDR6RWY0WlNMbElUWGVvMHJYY1VHRWNiVmly?=
 =?utf-8?B?NEtJYlFVQkgySldlcTNsaUgycW80aVBIcUlQczAzenVSZ3Vub0FCTE9UOEdG?=
 =?utf-8?B?OEJZMm10aFJZempuaGtleUF0THhJQ3pCaHB2dVl3aU5tV29LSUljalIrdDVs?=
 =?utf-8?B?TVZWYVg3bHVpMlVwZ2FEaEs5ajJuZWN5V0ZWdUY5ekUxOW9kNUxXVndlMTAv?=
 =?utf-8?B?ZUZGVDFjN01nNkM4ZUZJOUJhOVhZd2F4VEdUL3habFVZRGlFdUF6Ukc2YlJH?=
 =?utf-8?B?bXNiQzJZVWFyK3FVTE0wclFGNUpubWZTSk5palZZb1U3c29NM3RYS0tYWWox?=
 =?utf-8?B?LzdoRFBPeW14K3JtVkRPYzVhcFVOZi94Q3NVM005K3pIbktYT3VOWXd5VkdH?=
 =?utf-8?B?cVlSQTdFNUhNQ2dnZ3dLRjM5NTltZ0ZhZGRPV3h5WFlmT0JIeG5udldGY0Nk?=
 =?utf-8?B?QTl5SjArK1c2WCs5YW1NcHMrczRYTlk1U2ttZ1lXV2JUTW1BWFFUS0VSOW5F?=
 =?utf-8?B?Wis3cjA3Nnl0SkZ2bHc0dmJkbDlCSFV2WDJ6ZXp3YVpDMU1wMDZ5MDA5czVU?=
 =?utf-8?B?OFl1MC9SY0wvdm90ZEJDa05WTHBKSkNRM0RUOHZ6cHFQbHlkYVJ3SzhZN3o0?=
 =?utf-8?B?WkUwMWc2U25KZEMxNGcwak5NSjRQSXh0L0hteWJLUzUyT3QwT0R1TjFpdFVo?=
 =?utf-8?B?cVlNYWZoUjBZWm1QeWM1RVhLTlZHa2d0RWdydGZITXBqL3YrZFFuZEtQWk1K?=
 =?utf-8?B?R2NDVFd4OGNDYnZaVDBBbHgwQ0krQ1lLYzZ2eFlCR0FlRnVsTjRJRUwxSDQ1?=
 =?utf-8?B?T3hxdUhLWUJVeUhZbHZVRFBLdnlZZzhQUHRCY3lBU1lxRWc2WWdDSWliS2hR?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c315843f-61ce-471c-e1a4-08db448b4a73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 06:15:24.7785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/LQOCBU+SVy7CcCn1My/ww8A5K8RUDB7tKktkLfcwal/cVzoVnklO6WEvlf4868txiXtsZLgNRXXWSUlwvZ6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/24/2023 9:38 AM, Binbin Wu wrote:
>
> On 4/21/2023 9:46 PM, Yang Weijiang wrote:
>>
[...]
>> @@ -276,9 +276,14 @@ static void __kvm_update_cpuid_runtime(struct 
>> kvm_vcpu *vcpu, struct kvm_cpuid_e
>>           best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
>>         best = cpuid_entry2_find(entries, nent, 0xD, 1);
>> -    if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> -             cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>> -        best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>> +    if (best) {
>> +        if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> +            cpuid_entry_has(best, X86_FEATURE_XSAVEC))  {
>
> Is it necessary to change to use two ifs?

Good catch! I changed the patch a bit, but forgot to re-shape it.

>
>
>> +            u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
>> +
>> +            best->ebx = xstate_required_size(xstate, true);
>>
[...]
