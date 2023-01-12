Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A61667E9A
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbjALTEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240355AbjALTDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:03:53 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49187B4AA
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673549102; x=1705085102;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0SNhk0pdear9jUJzDmSvkF/7VK3ksgdRLkuWL+JfQ9c=;
  b=DNb6imGPay07DXgHrxJ5l5asjf1w5KFTQs1GBy4yPmyRCjsV8Vna7x8s
   Xtik88P9NMtYKC5yP9np3/6Xl/SLBNG+HFYSZpXIp91CJzGpIsd/JgV0y
   RF0Xatl3i+1v0rNnLL1F6jY8OYxdMjiVJdM31kNGzmii9PXd6z5vKZ7Ul
   U5+dTHzzEnCnzKsi0ybK3vIBkVRK+GX4cdvUldW+gikF+6jXYL636/pnh
   mc2KrUqsIbNHL6oTIH3JZCMa5eONfDnyNeSbn48hQJZhQJ2D5a+2lg2WS
   u/hnW50LIiAVytc9TFgsIX3v7ytkfP+X7bGqhoGZxMuqlDE8FkM2SXnkJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="325845124"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="325845124"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 10:45:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="635490805"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="635490805"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 12 Jan 2023 10:45:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 10:45:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 10:45:00 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 10:45:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdyomVAaXBfMNU/Gpv2GgeHpaahHkmxVrRf9Nsh9tN5TuYlWyv7QJQKNxp7Dnxkxefz9CbOroJcYqZJVx9KizaTXGvpNHi5eF3zL4W4dkWcEcHc9FnA692Av/84WJaFtyqUYd53BQKUk9HHogWrIsH9UsJMBTAADxvOG9tl311O63mwqgGYxnBks2HV3gDiuGtOtgdZsU89b8AXGMhk1PYPbPXn3C48I8PfvZMb26jIFe0wawEzpnL33RK/VYF+cY2CqilUE2qVIohCig0lzfiWjWp9KBwE3BtDQgP9FA9min7yxL1r9AkoOWY7mvCs6DZsJ2oIMsDCUr9f+ris43w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urjOplHYhrRJPqavxJ1mJjdwow7Y4WlhwruZBa+r3SM=;
 b=ZnEwaRAIt8KEsiTxuXHtLEyxuSAdC++aRjJ51FJa+X3dWLQKL+yYqJDsSQ/SeIXsmRMfD2xAHBK6GtoGDJHWa6ZLNTk74VeG2doSNhcstBgqrPyErrmlYREittLQUZ+XMZ4KIx8asne3O2MmH7gDmnLBtH4PDXCm4TjYtbDkP14Q8E5KSr4o6x7Qo2UQjzjUC/4FtNnDLgoesuVQJjPwntFL0swKhPWqO2kFMVj3ZV/kwhq1mUetqa/NYL0SwWHN20moz9z+RWng0da7xhRKhvPwf5T8CYOJbPZm13AwWjXlxI6GmIIZvw6VAqFMLDLHfFxCrNGNfaBJz03FkmKDcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by SA1PR11MB6917.namprd11.prod.outlook.com (2603:10b6:806:2bd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 12 Jan
 2023 18:44:57 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916%8]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 18:44:57 +0000
Message-ID: <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com>
Date:   Thu, 12 Jan 2023 10:44:54 -0800
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
        Thomas Gleixner <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
 <Y8BPs2269itL+WQe@google.com>
Content-Language: en-CA
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Y8BPs2269itL+WQe@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0169.namprd05.prod.outlook.com
 (2603:10b6:a03:339::24) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|SA1PR11MB6917:EE_
X-MS-Office365-Filtering-Correlation-Id: dae30bc0-685b-41a0-291f-08daf4cd1a11
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ddve4d8dlMndt5wKjlm00Pxe7l0QDhktmk+6uNNEiShe0XXB7WeJ3x4qzXTPG4eHCmdJDJCYafxn6Zz/HTrq3BvG7VSSQ2OXQOgrihsYTti9nVrXU09HPiSMrCVJZwcihaTfZnqO+ym57dP9Jnh2FIheF+MpKu83/OzjVSax9l+ujNjVt1dBfcVmx/T9eFWh5CZ4dF8f9cuVxdhqzccVu/Rbzx3CjoGRYiuIYllUxM+Jg3we3hNME0HGWfYhrTvy/nCmTE4KGzu77Uwusyxc723ra6AhuOyfQ9SLibyycsBWYYhcToDrcf6p1Yt3HT+jpLl6okNBhrf9nrIAloR58FjjMqDl8dWATXts/3oRntKMzvqx/KqQbxA+cZGvkJioLOebIY+4VQMpyJHYZ7kxqMDcTUIfGSDjDlkVsVGp+fWS29YSBHlOVBBoZ+0Zscw54cOx82ILULdHNLTBBvvWfwIntMPaufTRVwtO3Y5HH5BfFo3XAu4jb7MceSSK5XacOlCz+YEiaqJwXencWPSwGAvW0bZ+t/JFlr28vfNm91b+SiBKzSUWUegs750Z6TPwF2oaDWdZgsDabIUHyC96449CuK3GJVL4yGNMuXIAQbTR1TmoclodtwmUkuLznsfmwTfjtv4WCpryo8iVnnRd9XXRaQ2WQ46HdOJealP9bme7yWwioXKdship/dRxn9Ewcn9mgahw7aHHLuxnNlDxV5Z0WKflbF68fCr7aL/CpaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(8676002)(5660300002)(31686004)(2906002)(8936002)(6486002)(66476007)(66946007)(66556008)(6916009)(54906003)(478600001)(316002)(26005)(6666004)(2616005)(4744005)(6512007)(4326008)(6506007)(53546011)(31696002)(186003)(41300700001)(82960400001)(38100700002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVZBcFN2M2YveC9tMENyZHF6T05BNjRMUEVxaVZBRFRpMnp5UXQ5Zm5PR2pL?=
 =?utf-8?B?Wm91R3E2ZjFzclJFUlNkR0dmdU1HL0ttdHRZdmwxNVRPRXRxRkg1cnBRUXJs?=
 =?utf-8?B?N1djTk9vck5WamxlMnFndnlUUVVtT2l0TlFpVnNISm1sbGQwb2tZNnpSdHF3?=
 =?utf-8?B?QVNPVmVORXRDK1QwYURsbnZhYyt2ZUU1QXIvUjBBQW9xeDFEZDkybGJaMkNY?=
 =?utf-8?B?NGhQZ3RhWmN5L3AyUGhaUzh1c0V5OEY3VGZTZEx4eVo4aTRZRmw0am9zWlpO?=
 =?utf-8?B?R3YvcEYrWlhqZitZUUhlSGV1YVJGRVN1WHRPTmF5MmFVRmtYcEp5ZUNwaWJZ?=
 =?utf-8?B?V3VtZ0E0cUZuZUlIRFlrL0xOY2tsbk0yMDY2emRUVVBrWWtGWG43Q0VrVHR1?=
 =?utf-8?B?SE1CSTZvNkpWNW1kS3FOUkhPa3NRRWRQL2Y1SnlGL0NNR2ZiNWQzOXB2di9E?=
 =?utf-8?B?ZEp6ajZhR3pwWTZzR2sySHNHZEVhVjAvOXpCUytiY2hGNGI5TFVVUEpWRWx5?=
 =?utf-8?B?Qjl1bEVmWUxQdURRUXNFWnI0YzZZV1kwZTk2Zkt6YnNGaFYyYVQzcE1OS0cx?=
 =?utf-8?B?WnJIN1YwYlorQ0ppWU1Tb0ppbTZwQTM3M1ZQdi95Ykt5WFU2cjhtSUdNa2F3?=
 =?utf-8?B?bUVmMjB5VjVTeEJpK3B2T0Z2NDRPaERkcjBJK1pmdlpVbVNZUWtpRFpxK2ZT?=
 =?utf-8?B?dnpyaHFwZ3ZCUEVMeTFmaW1mQXZwN0tBaUtEUVhQemZpT3R1ZXYxTHNBR1Fv?=
 =?utf-8?B?VHRucVp4aGc5ZURnU0tva2FYVXdudXRmTHhWTTl5MlMvckxuU0dtclZpTGE4?=
 =?utf-8?B?RVEwTmxUdTZPckNPT0N5L293R2NzMGJxTG0wWFlEcFkxVHlWR3lvTkRpUVNU?=
 =?utf-8?B?STNiZ2I4azZNOUZCL2Z1RGJrVlozYjdySEdRNFFCamxxS3ZhN2E4bXJUaUZB?=
 =?utf-8?B?NktwanVhTWdnUTc3R0xjbXpiWWRFRk53N3pRVHgyM0NtWFN0VzlZVlpmWWt1?=
 =?utf-8?B?VHU2UUhjUG9yT1BQZUQ2RktRc0RFQzFQWlB0N0sraDdUWGhvSHg2VUI0TXhH?=
 =?utf-8?B?NWljZzkxTWxpa0JKMlpCN3pBNXh5QWRDNVNCZGFNQnROamlpdlFtaEYrU2Q0?=
 =?utf-8?B?Qm1wOUo0RFVhLzIyWnU0ZEtPNmdRRUE3VlpJRWVRUndua1RzVllDczJiZURW?=
 =?utf-8?B?RFBrN3lJOU1vbXE4MTE2R0dXZlN4Z0dBdG53MW5ESWs4dS9Lc2ZuZ3FYYisw?=
 =?utf-8?B?M1NSdU0yVGlrcEZ0RUlqTWZEbXl1UGdyVTNtTlpwaGNYOUNmRTdCQllVZmdG?=
 =?utf-8?B?bkFNand6VnZpZXVYdkg2MHNRblVIQnZuSzc5ejhyT294RllNazNGUzZQekdp?=
 =?utf-8?B?R3lBczRYd1U2aHB3YjFKQkFISk9jYWJPOVBYTHhuZ2RTL3Iwc3JKVXRjdW1u?=
 =?utf-8?B?NUtLbktpN2hCRTFxR29pTER1UjY5RWVpQkxMbjdVY1UyQzFEeTNXZEo4UjZp?=
 =?utf-8?B?UWJhdDJRcUVLaDJIaFI0MGxnY0VuSzMxU0RWQkNHc2xoazlzaG9lZ21FMTBH?=
 =?utf-8?B?RzVMUkZyYmdiV3RNdUtXNSsrU0Y3T1ZsZ0QwbG5vbWJSeFJUT050SzJXdUtl?=
 =?utf-8?B?OGR1ZXIzYnQ2bnRvTW9aWTU4cFBBL1ZEZ2oreUFjcXFnMlRLSWpORlJPQ0w2?=
 =?utf-8?B?c3JtVlJnRVNkMUlPUnZJRkNxSFFiMmkrYi9Mb2dnMFhWVUpyMWZvTWRSMllS?=
 =?utf-8?B?NTJjTENnN0RvVmVLN0RTZ0hMOHpYdTU2b0ZmNGVFcFdJU2F5d3NHQVhPT1VQ?=
 =?utf-8?B?Kyt0MnFtbW5PVHgvWDNpa3lrSjZVc1QxblF5MFZiTVYxTmphN1MyV1hIQkNp?=
 =?utf-8?B?aDRLbkVUUmk3b3hpRFVvczdaNzRnc29aSlVralhaM2NieVA5RjJOc3lsTTds?=
 =?utf-8?B?N3FURzdwZHd5KzBXWDdUQ1N4T0lkTm9neG9GL0tldWNHR252alVwM0Rlc2F3?=
 =?utf-8?B?VGIvQ250YmVwNEQ3ZEJQSEhVWUpmUXRZaHVJQ0g4d05FNVJ2ZmtRbzJ0QmxG?=
 =?utf-8?B?QzdQS1pYYWZvU2c1VENZdUNsUHRmUkhsSytFMGx2K1RPT0s2NGp4S3Jhd1hU?=
 =?utf-8?B?RUNtdkV1Q3NZRktqM054bUpnVHNsLzVLNGlSaGNTZWlWdnc4M1lXZDhqVWlE?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dae30bc0-685b-41a0-291f-08daf4cd1a11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 18:44:57.1507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vm5h5//oSScw5u/Z9YMel4c1JTdT3H8OjU5yk1OYDkhp9I5Afqvqu6cNIue4bpnBPWZrxuXxx+We5jYGTpWrbJrqWCR7l/oIaCrmYHex7Zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6917
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/2023 10:21 AM, Mingwei Zhang wrote:
> 
> Hmm. Given that XFEATURE_XTILE_DATA is a dynamic feature, that means
> XFEATURE_XTILE_CFG could be set without XFEATURE_XTILE_DATA.

No, XCR0 is different from the IA32_XFD MSR. Check this in the SDM -- 
Vol.1 13.3 "Enabling the XSAVE Feature Set and XSAVE-Enabled Features":

"In addition, executing the XSETBV instruction causes a general-
  protection fault (#GP) if ECX = 0 and EAX[17] ≠ EAX[18] (TILECFG and
  TILEDATA must be enabled together). This implies that the value of
  XCR0[18:17] is always either 00b or 11b."

Thanks,
Chang
