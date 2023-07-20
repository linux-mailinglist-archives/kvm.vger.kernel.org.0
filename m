Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C83775A430
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 03:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjGTB7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 21:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTB7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 21:59:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9701FF3;
        Wed, 19 Jul 2023 18:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689818340; x=1721354340;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3t1SHACMvKkgzldcXVBWQAgkszh46YfH6BrHLSXX6BA=;
  b=giuVrVdK9YSvGetDL2dkFNWEgLxUAkroKAb/b9RDbxTH2ECvFsRBkRLI
   0cu6hcYjBfxzpUr1CC2Zp82IWsQMPV1vJE1GeWFEIYJeplyBJKrYxwbna
   UInnArSolLarHlwoAbASESML4PzSbAd7XItgv+lU2AFQabvGG/rI9BsjY
   8OqGSFYaMJQstnKb5RkmTeJw6R7QT55fSEDEjKFHjnitn+loUg4rhXEZx
   VFRkc4xPjF3/TTCM3f0XW1IEUfrB/yexTYp0v3ETS8Dk7gfFEehDmKVea
   ww3MazfFH+8lG45RAQ6VEHI0OFaxMDlg7gGMlhoRT1a+lWKHwdUpyXiIt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346916562"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346916562"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 18:59:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="753899576"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="753899576"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 19 Jul 2023 18:59:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 18:58:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 19 Jul 2023 18:58:59 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 19 Jul 2023 18:58:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXvKceWaJGYgjPLwmoG5O+c0wcjYChbboo0yWY/4NnSycvXLGLhBrfmLH1pGcQQnmkSKN1bq/qVXaH1BdWBarjpKlgW/r1dQuSa61esz3qmaaW1iX1ssTwdEgexXrkyVGlzppMD6bO9aEWQzZtFBUWkKMdEDZPxE7BX+Txo3FnvhqAE0zXNHuFkQmKOAU7CaSgkTqSIfAy2sOK7Xu6KtICZ0Z3nhmDIH1Ns6F8d5Zga3ekorOUjM5m4EmDNjLMp8vSPgFmhpHDpWJQ72voCCDkWLF4+i8aPwCUW9H1Oqh3HOeZ3RW7Tklnr3wTAzmf1q8fSwxt8C4iRX3JALe0DZnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ih7f/Bg6XZfCEPlAb9LPJ+8/KQ+5AEdhv5Kv8Yeow1s=;
 b=ZR3ZrluWcTjD6/Nj1WoM3YYY7jILoFc8Qt1dqTejGGDqMHiWhJoKPWQLWLdZArTCbDb6XTTHE7bPqydvOhLkKzAhHBKSKbuy2G3sLYY0juYghdtNjCgeDmLVCqg3z7Kf1dWA4FYQg18svS2jpLR/oXXqrBAOeatK/P0q8x9VMuipKPdNj16/EVxjOXtaH1DQx59D3jkg2HFMX9ywvU6QZxsu9hnsaDco6ZSOwTsnNosR8sF5AFLFmzxd3G4Gd4iE4Q9gkPLoiY8eXGD7o7AXe03EdbhHqLaQIat5zC5jT4V2Fs5vyMuS0b+zk594yGyfXxdC9QS6g6VMx44n3kDqlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB5125.namprd11.prod.outlook.com (2603:10b6:510:3e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Thu, 20 Jul
 2023 01:58:46 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::f99f:b4d:65e6:7d47]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::f99f:b4d:65e6:7d47%6]) with mapi id 15.20.6588.031; Thu, 20 Jul 2023
 01:58:46 +0000
Message-ID: <e986331e-c084-ed66-fb78-e4cced1f2ae5@intel.com>
Date:   Thu, 20 Jul 2023 09:58:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Chao Gao <chao.gao@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com>
 <147246fc-79a2-3bb5-f51f-93dfc1cffcc0@intel.com>
 <ZIyiWr4sR+MqwmAo@google.com>
 <c438b5b1-b34d-3e77-d374-37053f4c14fa@intel.com>
 <ZJYF7haMNRCbtLIh@google.com>
 <e44a9a1a-0826-dfa7-4bd9-a11e5790d162@intel.com>
 <ZLg8ezG/XrZH+KGD@google.com> <ZLhG/0HAkX/ZtJTw@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZLhG/0HAkX/ZtJTw@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0130.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::34) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB5125:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f60499e-ed31-473f-1e4a-08db88c4da0e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fjb+mJl7dPDV50h45SrhnF4ph1CzX+kJbMUQ0Bx/njdkBFzcZQRLv11Qcht7DrFXiKtKJ/CllW/qDOniIVz+65o0+q2SOdppU2La+9d3Td3p39qIersoxa+feB/a4bay465Zi2W8LOPNYdK7zHsOcRywzg6oTJ69Pzv6X1P5Iw24dwVcN03GtjBiy80cfJ0dup83AN/bs0yzyGJaGrrL0uepp/nnwvuy6WZik44LKVp2YiuyCMAbOXMDSaL96VQXWBo/2SwCoyu+A/9WM+VmAu0RYSiQk2RJWRJEgeHjJ7iydBOfQQzNRzNg+62yIa61ICMHMIQNJ34JleVY2puJIMzWatxJ9698kpEKKxblO9BFD2lBVY/udRiQIiLlKCcyXf/kVf+rO03p9wxlUTd38zsB0Pe1HsXsdE+5+OCvB6Abcrc+jtUdBKUTj2qEIxJQRJcesIpqFV8vAPAp9kbhd51ziXSBtBYO/5AfkcKPwCDKdraxHoUc3HT7z+hlavrizh/8eNW2h08g+XDep29upIBmVs9n42Kw3eN7fi3ui9wYN2WrPSeG5o9WAHxWRj8Zq6CGW3PSX/qpIqnQTK9iBvupNAlKD9FF4w6G6uJ1L4mcEiS8MIcrkr/XbQSuay1F+Z9Hi260jaNUS1L84qUiYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199021)(86362001)(478600001)(186003)(38100700002)(41300700001)(26005)(31696002)(4744005)(31686004)(8676002)(6916009)(53546011)(8936002)(316002)(2906002)(4326008)(6512007)(66556008)(66946007)(6486002)(66476007)(6666004)(6506007)(82960400001)(2616005)(36756003)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akJjSWtjbXJ1QURGVCtHcnFwSnFueFlvQVl6TTd0WjAwd05WUEU2VG5JbXAz?=
 =?utf-8?B?cEZndVU5WDYwME1LanRHbXQ5WWpKMmEzVStUTHBWV3JYb0U5ajNRTk5WQytG?=
 =?utf-8?B?anRMMlFvVUpaWGZIdE15TmlKVjVEV2FkTUJvRWlVRVM1U0trcW4ySWhoSGty?=
 =?utf-8?B?ZXE5T3U4ZWJWcUJURGJqY0hxKzM2em4wM0FubDl6SldpbXVENmdoanE2UytF?=
 =?utf-8?B?MERwbTlUdkZiVjVGUm5OSE9WdzQzOHZSZ2RueGJlRlh4azB0WXk0T25GM2Ri?=
 =?utf-8?B?NTlsRGxjdHU1YktPRUhrYzNSb3hMWEVzRml1c1UrWU5Ddk9lSEJoZmF1UWkz?=
 =?utf-8?B?UGZzNmVQcDI0OVpqR3E3YlVVZm9VRmZrL1phSjlpc2pUcXNEckhTQVNyWVpl?=
 =?utf-8?B?V1NBZEl4SHdYWlE5aXpmdEMyTXhDK3lvYXo1dXByUnYwMXNjaUFhc2Y5VGNs?=
 =?utf-8?B?Zzk2RmtLb0tlMGdkM3ZVVEllSWFFYUJIWW5hWTFvNThTdWNkQjZlV3hMQWVa?=
 =?utf-8?B?VlNTVWs1dkpIZ1VSa3VsTnF4ekQ3OUMxTG1Wd3pDRlVqSXpNNXdEcVk1K29X?=
 =?utf-8?B?VGt0aktIUGtIOVFBRGY1NWJkMW1CeVRjZWZZNTY4cXpMUGcxYkZxNEZjRHl0?=
 =?utf-8?B?NTJrM012RFV5dXh5bVN2bFhISFhodGRzR3EySVNDZ3NqdXBxUzVndE9lK3ov?=
 =?utf-8?B?YlBQR05ha2Q0TnY1UFllb091N0hEMjlSalpGYTZmQ0Z3ZjhvVWplOGlLQ3BO?=
 =?utf-8?B?VmgrRE5Teng4VTczR3JnZUNueXJBRWYwaWFDZDVocG8wUEFvU213Yi9TdUQx?=
 =?utf-8?B?Qzd1UE1aZ2ZvYm81TTBhWnFVWTExSVpSSjhBOXhiTlh6Y3lkVWk0WHJtdkgz?=
 =?utf-8?B?cE5PY3FwaXhkMzY3UFFPZzdKY1VWTWNVV1Z3RVpLMkNGbUUzYmNYZGNZZm9J?=
 =?utf-8?B?NE5Mc1NrSUhpcjdsMXpFRlpPb2pkb240QTlwT0JISTc5OWczT2RVQktOWXMy?=
 =?utf-8?B?QXVqUVdxTXZZV0xZa1VsK012ZkNvNjF2QWl6ZHJlRDJ0VlFzSHhhcUFLTjVX?=
 =?utf-8?B?cE9wc1JsZVNmSkVZM3F2b3RWWjJFZzVVN2ZVWG5vTmNRWDE0NTUxMVl0YjM1?=
 =?utf-8?B?T0hTNXorMnk4dHl3cDNHcy9NRE4vRzAwVTUvOHJsMllPa05qN0F0TDUvUDAy?=
 =?utf-8?B?RmN4R0NOWFFJS0hscHRFdjNWVE1Cayt6QktSOGlQZlZ0NyticTc1T3Y1WW5E?=
 =?utf-8?B?YjlyWmlCUXJzUFhYWlBhZkRXRXJzL2pubnhQeGxQTWh4Zzk1V1BZRjlzeG5a?=
 =?utf-8?B?eFBsY0VvMTVnRWpRZGpaV1FaUUFpM0d4STV0TExOMEw4STBhTWs2Z2RQQ25O?=
 =?utf-8?B?cHVENkRacXFkc3dJS3BVZVRrM3prS3hvaU9RVG4vUWRaMStNTC94UlF5WG5B?=
 =?utf-8?B?cFhsL1VjbUpWZHRCV3BveXpxejcwd2lIK3RUQ1dWTlNzTisycVA5dlNPeWwy?=
 =?utf-8?B?RTZWK0YreENNcTRQMU9SQWlxQ01BZENjOXA4QWp2K0VIRGE1VmpvYStSenZG?=
 =?utf-8?B?MjUvdXIxellkdCs2QzhuQ09aUHBxeElDVzI5NG9PU1Y5NzA1bHNJejdOT1FS?=
 =?utf-8?B?c0tDU1hCT2c4dUNHejhDVWprMnZJYklCellua01UemFTMXliSWR0a2dBUnZx?=
 =?utf-8?B?SGRtTlgxM3ZyaDd4OEp1dFpPUytJbDg1SVdjTXZNbGNsdS8wVVJzUjIrZ2tI?=
 =?utf-8?B?OWtNTUZ4d3EvVk1rZFNsYnNZRWJ1SUZ3bFJQRG9CTXlUaEtoaHRiRGNWcnM0?=
 =?utf-8?B?UVdWbGdvWXpCcENlTC9XWS92dFBNU1JkakI5eUkwaitVYjliQnl1d3ZVdEQw?=
 =?utf-8?B?V3ZSY1Nta2R3V3FjR3lVV3ZKTk5mNW9QNDRvRnkzcXRSa2lNTFgvc00rVFln?=
 =?utf-8?B?dStOWmcvcXZ6UGlrMkppQnI5RE5GVEtDd04yemdoNHI3WUMyTzMxblJQQVdK?=
 =?utf-8?B?RzhLUkZUTUZ2NTcyQXI1Ky9RcWRwcUU5NWxnanUyUVYvZ0lGY1RnL3pkQkoy?=
 =?utf-8?B?M0lPbVgzZkI3QVhOcDRCS2tQb0wzU09Cb0NNNVlpYno2bENqWXBwb0x6dkt6?=
 =?utf-8?B?RUI3akhjcUlMWGQ1SnR0TkJqUG5TN25iNlNuYjZtSzRMdEN0MUFocEoydmdG?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f60499e-ed31-473f-1e4a-08db88c4da0e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 01:58:46.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lfpsrjMNrDxvGJ3fxs5zbSEc4N4ZRr6kQAwrk6257HydYvoIuoNVDhK/UOw+xQF5lFzuE/HpV6Bz1xvxpdarg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5125
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/20/2023 4:26 AM, Sean Christopherson wrote:
> On Wed, Jul 19, 2023, Sean Christopherson wrote:
>> On Mon, Jul 17, 2023, Weijiang Yang wrote:
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index e2c549f147a5..7d9cfb7e2fe8 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -11212,6 +11212,31 @@ static void kvm_put_guest_fpu(struct kvm_vcpu
>>> *vcpu)
>>> ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ trace_kvm_fpu(0);
>>> ï¿½}
> Huh.  After a bit of debugging, the mangling is due to mutt's default for send_charset
> being
>
>    "us-ascii:iso-8859-1:utf-8"
>
> and selecting iso-8859-1 instead of utf-8 as the encoding despite the original
> mail being utf-8.  In this case, mutt ran afoul of nbsp (u+00a0).
>
> AFAICT, the solution is to essentially tell mutt to never try to use iso-8859-1
> for sending mail
>
>    set send_charset="us-ascii:utf-8"

It made me feel a bit guilty as I thought it could be resulted from 
wrong settings of my email system :-)

