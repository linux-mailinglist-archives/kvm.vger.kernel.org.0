Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217F1670B23
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjAQWEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjAQWEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:04:01 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E0D42BFA
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 12:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673987643; x=1705523643;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cqq3gKCtL2ZAoKKsxVa+Xi90uFMDrh/klYjl0VjrBnQ=;
  b=ntf9tgwuEWsyeXc6XDtSr7RK3q/RohaZyjEoxN4ZaP0uttW5nthtQS26
   FRNJ/g9w75B3L3997POUd02c1wETg0Ej3dGchUPWCOeOVgVAQqVxHCBfq
   MVwbO0H5CZo6op5vOMWFCt7+5TDNU/rEY1jS322ZqHj5q8dele8DZQQKb
   6vJjKCE1GTqI87e68MbOtxkCwKr6cEQzC/5CHL7fZLdsylAuQwX/o8qYW
   8M7ssqc9p9dpQaf/G1UGcwnA1RoFOhYGApVDPbokQoOiS6gzSzEoGsltq
   z2EPjVxP0WnQoZojPJiTgmCefxj6gRwOC24UJk1Aoz6X+m6g7usj6dvj7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="326885949"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326885949"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 12:32:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="748168584"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="748168584"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jan 2023 12:32:39 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 12:32:39 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 12:32:39 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 12:32:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 12:32:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3fjlBzOvwp5ax7sLmYdAlf6jG8fs9ngNBkbTMUpgr4p8oVzfMw/ECQ4cb+Z3BFOwlWbHjxsqsjm02e+BIdpB35RzVqTCz52GmkoPon3IL/1i3q/TTNJLvkhPt3BtgyqMfIqBUsOwOiyGmW8o9LgV592HqAJUCnursywpGO8LCwJHabfKSBHZH/Tna3wW6JZuu3wku2VF+hM7byhKrQSCBBrdNhCCSGyi+9jsVuszi5AT9AUb77zSWdC+lrmlHGvAN0dXeaF6BKLs7Bc0bozIwU+x1ODGD1FUghRH33lRQjfyTXxJ2g7CxuV/L6F4axDItYLoqcS/nXP5sVUOW6uIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFhWuvlMI9ShGIVVArIbl2N+laAZ8v7wiSSavYgpXus=;
 b=i7ShoiEFR675ky5RDtJMPCFuGuvmBDyCEwAUh4WkNazDL6eImbUAS7HkCPHuBuom/rTHrmkjDpMGRFrVt+t+ba/1OAz+lFM797OusK/dZWZYJTviRpvRxAfm5qlzUEvZSFBHNEueHKIHgqQsL59zyl8NOByZNHgEc2IaGHzRUZaIpBNc1+4faZbrolbfSrNO5Ci2m0LV/Yj+oKnApzrCBDbIWBWF71OQ+zJ2qiA+FHEIC8au8QCyQk8v8oJSpyyWvWsb65iMdt9IKC4tcUh4BLPh1jzeXhKSEivTL1KDnUgeOKRoPNreZUBFYe3knjhRv78ZJ1Kpe8RXgWXLS+v0jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 17 Jan
 2023 20:32:36 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916%8]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 20:32:36 +0000
Message-ID: <c3be155d-5cff-60ee-fb84-5bda693ea954@intel.com>
Date:   Tue, 17 Jan 2023 12:32:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
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
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com>
 <Y8Bcr9VBA/VLjAwd@google.com>
 <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com>
 <Y8B5xIVChfatMio0@google.com>
 <f65d284f-4f06-739b-a555-37d2811acdf3@intel.com>
 <CAL715WKmJ1BSozF18MOp=jRvMh-28fLWqBJvg87MaK8aOh33cA@mail.gmail.com>
 <CAAAPnDH21dqmHqiM2E3ph-qyEardx4-OkgRzRa27Qc3u2KQ+Zw@mail.gmail.com>
Content-Language: en-CA
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <CAAAPnDH21dqmHqiM2E3ph-qyEardx4-OkgRzRa27Qc3u2KQ+Zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::22) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|IA1PR11MB6097:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fc2f5b8-83d4-4069-4750-08daf8c9f7fb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JfUA49wF388IWKYjziGw5H8jRSazk2WY5uppL/0uNGAfJPOaFMjXdsGyMHpNx62/aybed3bzliJ5JNHT3Wc/TmTMoEKUCX7ZzoUls6tAkK3wC95GCjrDOObjXtqN28oOX+J/QBifwVSNRAZ/r1HPBtI7iR3tWPhxEOUqiwlr2tWuRvawXcumO5/ubvUDuoSVcGtIX+af8NXRP2eDmmPsjtR4vdhw4J+6wX7J3MCOz1FKCiWKzSsOB8u+TUXji9R8FxYJXXNrbE7V+lE5N+rJZMW3gnK8/KIHcefiWJu+EVPOHZmGZdZq7V9NT/UWntJz/5Mj1Uu6P1alHZf/U8S+afw+L0zDptjisu2pnMfKUJE7XWfRJhN5jITNboLoi/G+zziBbdQQ1cLC/h2JKn2czzs0jZUtfEguNOinmNns5a2YI9KjajG27282p5g+UcxlMWDGjckfdN2mlrZzUJPcw+pJCVN4rUGok3HE9vcGlNYwRRZub5VfKy4QJz6fCVRaAga20RpMDsm4jPNYVMrDUXDIuNOJtQGyRRRPp+4fmYSgGB7LmihP/458X8bOAYD89DoIg/Wx69Rf5xdPURvN461mlNtd17jBd9iGqY2e6BaiHcYLzPyrcaAJHJcv6v5nII0uwpPvlAGAwGC7uo8WweCM8xCXg8bZzqd7tuhcmESCwg99BCObVBEDw3rCTkbg10SMjouxGyvwtdgfos7bUoPq//E2V+2cyn9FpcO5gPPwo5Z1TX3KZvTGoeb3573/sFyK2siYfgG4Zz2vHkEzWjMFBU8jwgtv1WTMZgPSCJ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199015)(53546011)(66946007)(6512007)(66556008)(8936002)(8676002)(41300700001)(66476007)(5660300002)(186003)(86362001)(4326008)(31686004)(478600001)(110136005)(54906003)(26005)(36756003)(2906002)(966005)(6486002)(316002)(31696002)(82960400001)(2616005)(38100700002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjFrNUY1SFZJVms2UmR2c1Y5a3BIZ2ErQTRWRU9yLzVKVkRtUXJLMVF5bnBK?=
 =?utf-8?B?dVFWeEF5eTJWUnhkSVBDQ1czdHNocTJBSUVzbWcybVB2b0NibFBjK1VvelYr?=
 =?utf-8?B?R2pqY3RYR2lWK2F5RXArY3JSTHorWFZBbWJnSzd5c2JvM2Iyd3NKdHNITTNM?=
 =?utf-8?B?RUhCR2tnOTlNb3hnQ2FxaVBkTWwyZ1dMZzdhNFBVaFFpSmdBZXdEQ1gyTFdP?=
 =?utf-8?B?blgzelcxUGxDQlcrUzdRQklHNnJnc05NUExsUjdtMzBPb0dyRGdUcTNPRzh5?=
 =?utf-8?B?UXZzN283d2hLdDNkeDk3MVVxejVxOUZKKzBlRDVVU2hLU2UwYWE0NmtSMUhs?=
 =?utf-8?B?SFlKblczTlNrS0JUZThKSHBNMEhmV1YzbDlPRXhTZUJvcW1qc0hZSFdFRXRM?=
 =?utf-8?B?TzVPUHVrUWVhY3VEMWt4TlA2Sys0QnFhT0VvaEhWdUZhOG1sdVZwNUVZZW9k?=
 =?utf-8?B?Unk1MEhRY2VFeDBwK1MrWk5lR1crbXl0TFhvWWR1NVJTcllma05BandsUmd2?=
 =?utf-8?B?WFoyRHppNjZwUmh0a2VJREJ1ck9FZXlQQ0ZnUFoxRXE3ak9OMklOWllEUVdI?=
 =?utf-8?B?WlNJNGhzSkVyczdBRlpsYXN1Q1V1QUM5aVplUGQ5TXVXK3BPZlkvYmtpQy8x?=
 =?utf-8?B?SGdkYzRqeEZOMEZEQjlkd2ppRS9wYS9NRm1US2EzZ0RnbzQ2VkN0eXhsZmI0?=
 =?utf-8?B?ODN4MHFIV0J4Vko1S0wyVlg5N1ZrZUJvZ3pWVG93aVRjSy9qSSt1L2gwYjNm?=
 =?utf-8?B?ZER2VWZ4bnk4VUFjN0lOcEpYVE5TL29vWklqRjVTZmxBUElKTkVuVWVDaktk?=
 =?utf-8?B?ZnBFdDczZkFuL3ZrK1crUE9ERjY4d05vRUxzTVgxRGJiVEp5Qk5kUkZPL21m?=
 =?utf-8?B?WURHckNpVjRxUHVSRWxCYm5LdjBSVjRvTEpvTmF5ZEhhNDl1ZFU3QXZycTc3?=
 =?utf-8?B?YUs3R2VsOTNreFZCL1RBVGdvU1dad2Z2dnl5RFQvQXkvenBOaWc3T2paZzZa?=
 =?utf-8?B?TGczc1lKZm03K1JrdXMrNWd6VnYvNGtvWEcyUjczZ0IxYmVPK2RUdDhpK3dw?=
 =?utf-8?B?KzRuRklRQmpNUkZreXRhM0pZaEcxY3RndHJYY1Fsbks1TFMxazR0WjZrSGFM?=
 =?utf-8?B?K045MTN0QVI4ZjR3a2IwUjlrUTYrV0xZWUVqQkEyb2dKQUQ0VTZYVEE0RVl6?=
 =?utf-8?B?TUQ5dDg1YmZNYmZwQmlpdGNwbDBxdE1QbkhwSkthMUxxV2xCN3lhNmJhRFY0?=
 =?utf-8?B?Skl0aE5yTEdsRDd3WnpQamhhcURCdVRPV1FJWFNUcjd4cGxrbExzYUFzdFlL?=
 =?utf-8?B?VGgzdWJnM0tKUTFSK1BJTWdtNVlRemYyRmFGUk0wQXptYkxwWDhRMXlPcVB4?=
 =?utf-8?B?WG82WTNpV2twamJDeWZUTlNVMk13VGpiUzQ1LytVRUlreEQ3YVFLSDJpL1oy?=
 =?utf-8?B?R0JLR1JlVWFpMFdoNDI0cjExZ2xBK2VwM3hJd3RONWF0SFZZSUIvQ1A4TGVr?=
 =?utf-8?B?UUJlTm9JZGxneUI4R3piN2JpSlduNCtRaStCTXNRdnE4YS90YzFGWFU1MUEz?=
 =?utf-8?B?QVJTa01GVTBoUThqMm1NbkJRZ29rcUozdCtuUEFnRTMrTEFjVENTcFRTanRV?=
 =?utf-8?B?dnRkYVBibjNobHpoV2RkVFMyY3k3VVZtcGhRYXhrVUREeGpIbFdmdFpOQ05E?=
 =?utf-8?B?NEVJMGx1aG9ySFNWbmpRS2VYUXF5MEhCcHZoTlhtaHRxa0MrSHVwU1BvSUpp?=
 =?utf-8?B?WDB3QlNCblNkbFhwT3BtVUdIUm10ZWpSdThaMmtLdG1hRnBJYlRXdDJFL0Ju?=
 =?utf-8?B?UThkTVVVUGdxdG1vMEQ2VmhweHVDZzJhYzEzblZ1a2RPcnhCRHpqTVAvdWgr?=
 =?utf-8?B?WUxQTXczN1lKa1phS2xLcDZ4MjhYQWhUZVZqbHpPRnJKcllvZHpid1pnNFNT?=
 =?utf-8?B?dUU2NXR5SVkrTkhQT3VHYXNPaHEyUDhzM3VsZlFON0pnMVJZVkFYRmVFVzhD?=
 =?utf-8?B?b0kwSmUyV2hjbm0xTFBwLzc2dis3L0dxK0RNUnArbmNJSlEyRjh2L2tBaG1D?=
 =?utf-8?B?am80ZzNkc1ROeXpTOUJzcWJQeGw4Uk9GSEtQdzR2R293L3MvRDh1Q3ZNV1Va?=
 =?utf-8?B?dWlnald1bmhDRmV0eVZBdmlLMkczWUJGTWF1SFB4enpkejc2bFk4cjkwYTZI?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc2f5b8-83d4-4069-4750-08daf8c9f7fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 20:32:36.0776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F74S5xenvbX0d6oaR0dcPgWr+VLVM/WQVK/NKKywYYBR6hsxnI4M+OSKm8dnPVPRtB/UKr3ODM2hXbhZbh6+nw3vaxGI93SsqjYCWRjsb+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6097
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

On 1/13/2023 6:43 AM, Aaron Lewis wrote:
> 
> I'd still like to clean up CPUID.(EAX=0DH,ECX=0):EAX.XTILECFG[17] by
> keeping it consistent with CPUID.(EAX=0DH,ECX=0):EAX.XTILEDATA[18] in
> the guest, but it's not clear to me what the best way to do that is.
> The crux of the issue is that xstate_get_guest_group_perm() returns
> partial support for AMX when userspace doesn't call
> prctl(ARCH_REQ_XCOMP_GUEST_PERM), I.e. the guest CPUID will report
> XTILECFG=1 and XTILEDATA=0 in that case.  In that situation, XTILECFG
> should be cleared for it to be consistent.  I can see two ways of
> potentially doing that:
> 
> 1. We can ensure that perm->__state_perm never stores partial support.
> 
> 2. We can sanitize the bits in xstate_get_guest_group_perm() before
> they are returned, to ensure KVM never sees partial support.
> 
> I like the idea of #1, but if that has negative effects on the host or
> XFD I'm open to #2.  Though, XFD has its own field, so I thought that
> wouldn't be an issue.  Would it work to set __state_perm and/or
> default_features (what originally sets __state_perm) to a consistent
> view, so partial support is never returned from
> xstate_get_guest_group_perm()?

FWIW, I was trying to clarify that ARCH_GET_XCOMP_GUEST_PERM is a 
variant of ARCH_GET_XCOMP_PERM in the documentation [1]. So, I guess #1 
will have some side-effect (at least confusion) for this semantics.

There may be some ways to transform the permission bits to the 
XCR0-capable bits. For instance, when considering this permission 
support in host, the highest feature number was considered to denote the 
rest feature bits [2].

Thanks,
Chang

[1] 
https://lore.kernel.org/lkml/20220922195810.23248-5-chang.seok.bae@intel.com/
[2] https://lore.kernel.org/lkml/878rz7fyhe.ffs@tglx/
