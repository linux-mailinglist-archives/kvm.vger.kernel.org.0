Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF545AA628
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 05:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbiIBDGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 23:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiIBDGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 23:06:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830B36DAE5;
        Thu,  1 Sep 2022 20:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662087968; x=1693623968;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DIcWIr1rTm7VsG/JhLGdlFlS+smTr9s8yee9WbWc4O0=;
  b=eeIThF5HkDbTjkaTJvzd0dTBVeMbKwrWc9+3u8vjNZ41RBO1H4kzgUXY
   dUge+awSSyLbdKjuMLAryejj2UIpuKd1TEsDk65+16aseZkGNmEQ+AGwv
   wuONODW47XqIz+caDwWy/PFkhS9a78uY0MMTYAnyJOQEGIoqq5LrLh1XN
   E9RAyrlJI0VE8gdhvWYWxJQldR5vcsETkw7y090TuuZPGk7eceVK0gxjr
   oijhYD2+odWKhyKcYnV+h88zPrSx0Vu1dog0XvUSbt/PbO/Z+byjqqgA6
   hrwPYrNV/bBlTEOBH0U4PZ0rc7pk/IWBldC3f6uMqc4TykC7MXNvDPzMw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="294621658"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="294621658"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 20:06:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="674172093"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 20:06:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 20:06:07 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 20:06:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 20:06:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 20:06:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3raxn+RM7C+bSI9DCbylBo/FlFXZwEASLb1ls/DMXWMMiQnPlnCBYRqwHG4lANi0BIi+iyST1HVlotVE8pQfdCOR9+adJw5t1yTsT9cliqKZJf/amalo1eAq9IfCp137HvurY2tnWG8YdCXlloiNVp7Eb1OD/QdSsXEYcYE79Elx5GL6uqJGcUVJSrev/dGYK0yU3Is2I6fBoHp4q8+ikSn/JKXTpHTNOiQ0KGT8fvm/KWjvCwdLGMNNkik1RjUHiJokYPrC3bwBlReIE+CmNtb4x5o4CpXzb8NPPn7iL46pfzyvCp9EaBz4C/kv0JmDZAWwiFnhHuG5YHxUzxcdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCAAohG4Xh0cvs0R6zIXKDxT8Wkk2u287JtqPQtAaAA=;
 b=Ou/aJXwFkWW4yhBzuIolTmZTe31+1g7YghliJ/2hGRX3ygMhIajTuBSn2L5yr3FGzdLFq3U4EskhIkQHRoyZ1OORWi2tQAmE/63ZJ+/zJvDdmMinW8/UQrB44DcO7B7gMqsIxeZNAJexf390z6oSKoTKCNj7T0UGwrGNiav/RMlhzoA4YGGKWpT01iLMIPCjEByD0sNtBWThF7ZcEs5nXgNR3lZdi0zHmAf5f98OVf+nN853vCGA9+MiUy2fdRC2BtUeGoEHy66jdSzxSAftBRQEX4BBcqpq0N2CSncSMYFSxNHxpmASrMyJ8v/38N6dwNsrMFKlYKIFr3T4dMNUGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB6741.namprd11.prod.outlook.com (2603:10b6:a03:47a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 03:06:00 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ddb:2488:14dd:3751%7]) with mapi id 15.20.5588.011; Fri, 2 Sep 2022
 03:06:00 +0000
Message-ID: <1d59e5dc-dd1f-9fb9-571e-9f627a52f263@intel.com>
Date:   Fri, 2 Sep 2022 11:05:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 01/15] perf/x86/lbr: Simplify the exposure check for the
 LBR_INFO registers
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
 <20220831223438.413090-2-weijiang.yang@intel.com>
 <YxC/gedFQh5qf5LS@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YxC/gedFQh5qf5LS@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0033.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::20)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c472dfad-e177-4a28-d4d8-08da8c900ffa
X-MS-TrafficTypeDiagnostic: SJ0PR11MB6741:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kIYWZ5HYhSk1x2xQKoHUxHj9mwsoKB0J4vhffPdX4U1EbDnZuiCI3wRaqhSgDwhpIExGT36LLOM0+5kXuHDL8cO7u1YHigIitVaOwPQpvEA8zyv5evSXxLNh80Ph39FL+qaB59qyDG+Bc/mv7iv7YqXYSfpf+Q7MxNX6jgwml4ewWvCkwqaAhZvnAMc6f8RclGWV5aUmGQRkbquwvg7fY1pN7NW+ulwJMF+gAzWUxauvL9POf71Qr9aYvit3LRdFBQt31QMOG7Bx8lgjhRlwkZ2AmwoHWCoOZbzfj2MKAtqrvJ+gbI2cuWx4HC+JGeU8cabIoS8j8dTsArqs0YfDbLDI95CCyVCzqHWOfa0ZfXZ770FnPrYSopu8R4dUWtX2h139ShwAj6sDLi92162Oh7TligAaRn2ngEYAzsW+XApj8vcsIE97+3Sn6s2nJCemnwlcy9sXEY+4TjNnt+94kk068IfY/DacacmzsS3dZb2Z0dQBfC0AAj920OQKl6jjMic6tec5RTgTI0SV+e12Et1/Uqj8xNbCqRGV+yESKt8Z/v2NzdZO+cpDO6/ft9knCgFdIInRfxYdKNE7LTBXatevgfnKr5fMPnao8/v4don1sSV2B0oDX+07VpaRTCDRx8f7FbzVWeE3tJq9QcGqONv1RUK2TVJToEI8xYkgIr1SZQs2odppHf3XwG5IcXd9No8dvFB8xGYb42GdjMTr9jwu/vQL7XdK4E5+NdLNkxLL72i2paUa5o1F8H5nW8T2rbhTsJgeAKTZEgqUeuIhvneN+FHkYwrHeWV+wst89M4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(396003)(376002)(136003)(4326008)(6486002)(31696002)(82960400001)(66556008)(66476007)(186003)(53546011)(86362001)(83380400001)(2616005)(31686004)(8676002)(5660300002)(66946007)(478600001)(26005)(8936002)(36756003)(6666004)(38100700002)(2906002)(6512007)(6916009)(6506007)(316002)(4744005)(41300700001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTZsUDVzMS9yUStnWHZUcFM0SUdGa0I5YXRweDdnRG1Dak1uK2l1YnNWV2xY?=
 =?utf-8?B?NTcvTDMwb05NLzFJV2tOYUlpYkpmRHc5MlFkSkszalp1dnlMcGp6dENtaHN0?=
 =?utf-8?B?VUQ3eG5JUWVUc09OVzQwSXBGZGd4MTR3ejg5S095RE84VCtTMGhhNC84WEhQ?=
 =?utf-8?B?YTRLcmRGUnF1Z1RHczZKZnZ1T3o2UFk1L3lEdjI0dWcrdEd5K2VxMkdwYzhM?=
 =?utf-8?B?VVZHaWRKSERjZ1pWdEZvb1czRE5WeHltS2p5Y05PZDNXY0dTTTJ5bWpmcFpW?=
 =?utf-8?B?SFB4dEhMMzhuaFh1RG1FZG1ieDR5ZmwyZGgrVHRTRGtYVnNld0dYN2FFVmdm?=
 =?utf-8?B?TXp2TnZwYS9hQmlOOWF1cVlCWUlYTGNLS0hNamY5ZEtWQTBSaWZTY09jeW4v?=
 =?utf-8?B?K01pTHdvWUVZNS9TWElVU3hTTmRDeS9OMXNtNXpsdGRxbXROYmY1bmFKbzcx?=
 =?utf-8?B?d0pPVDdMTHJiYVFRbzZYd3Y1dlZzcU1qMEY1ZXRTaFQwRk9YdU5tUW9XMWVW?=
 =?utf-8?B?UWs4WXptOGMvbUhVRlZVQTIyODBBS2h6bkN1TEpKcSswSjJTMWRCWHprd01i?=
 =?utf-8?B?N2NZUkljRCtkUS8xM21TQTZtRWNWb2pnd01QR0dhRExRYmx3OWdnMTRBUjBP?=
 =?utf-8?B?VVFLeEJQVWk0MEZtY1VXTzcxUGFwTzhvWjZPOFVIcUlKQTZHM093TldRRWRr?=
 =?utf-8?B?c2ZMQXAvdHJpa002SUhnY1FBVlY3Zm02dXd2UmtTVi9TZHBnVWdnNStzOTBY?=
 =?utf-8?B?OWhsSkJXV0s3cFJwdy9xeGN1Szh4TUJ6MmNZUzd5RUxxM2tiaFNjeWRMWEhr?=
 =?utf-8?B?ekluUW1FVWFoeFp2Umt4VU1kOW5jWEpDS0dxL0tXeTRpcHVoVWVaOU9uUEls?=
 =?utf-8?B?OGV0Uk1hU3JicVVNdTEyUjdvRnFkRUNCU2NSdVB3M0UycytOZmlIS2x5Q0NC?=
 =?utf-8?B?MmVPSEg1RHFCbmFLcWQ4N2c4Y1o0SHNFaEVnZGJ6cFNnc0FXTFBFeGpyYnZo?=
 =?utf-8?B?WnZjaFJ3OXZab1R0d1JZclVWMTdwdUVzTTBwU3hvNHFMZFJoWmF0R25KeU0y?=
 =?utf-8?B?bUE3UmpJT1o0a05RUDNlNVZPSkFYYWRRSGRDMzQ0NUxvUW5LQkhPTjZEaVNF?=
 =?utf-8?B?VnZvV2FPQVRoTHhQcDRoVFgyeEhsRzR4TTNZUCtoQVlGZFFPcVRCWWxseGRZ?=
 =?utf-8?B?ZVVwNHAxRlMxbkZJaXNtakZlS1FRVkJHejV1U3VnRnZtNWc1dmtnRHJXV2tn?=
 =?utf-8?B?MEY0SGhZZzI3SFRJNWF3b0UrdHlzNFdTdjJkLzB6ZENDdDRKTjE3VlVYYUU1?=
 =?utf-8?B?cUtlUnBOZDZocUQ1Zi9hUjV0N0ZoelNQdVFVUTh1cDczSnBQQ1ZQdDVnY3FY?=
 =?utf-8?B?dUhITGcyL0pUME1KbzluZ3ppNURZMEc3NU1HTFFvOEVIS25hYkhMdE1HaTc3?=
 =?utf-8?B?Z2V3VTN2dlJYNDRBWmNodWRBcGkzank5bFB6QVVGWnJuL0xRTUtLNitmSDVU?=
 =?utf-8?B?TXVoQlN4MnNNK09LOTNUM25xc0tkTFhXQnF1cldmRkxsWHBBSXNHZTN4MGFt?=
 =?utf-8?B?eU9pdWlKZ0dnKyt2Yk5nOWdsbE1NVnp3cUJWbkg2K0o3dmwrQzNkR1ozNjJz?=
 =?utf-8?B?SFAxL0hTVVJweDFIaTZxcytnSm00dk51QU5xcVBLRGhneExHYWl6SmJ5Nmdk?=
 =?utf-8?B?empCbXY5YWh0Zm1QSGhmRWJid1pXbGZZUmRzc2hZVG54dmVCVGpTWlNvTHJU?=
 =?utf-8?B?WWg5bkk2aTF3aUtEaTJkTG0wblUrbjdxN3RBa3pIdXdjb3k5RzFJcmNjMHFo?=
 =?utf-8?B?WDlzZFFJT3BpMjhOSGVKRjNpUVJSMDZqOUZoN1ZBMHllSzhnWUNvUkJuS2Y1?=
 =?utf-8?B?SlFyUnlLUTVqeCtJNW8zQWhPY09DdSt5Z3h5dzYycmV6N09PSlFLVk5UemM1?=
 =?utf-8?B?aC9SSXBHSVU3azdzMHpuTzEvU0dGRzFpQmo4TU51NldsTVYwSUNJa1ozTWRU?=
 =?utf-8?B?eVZ2QjRGNmhlUFJSRE5pdElpUzJrclRnQUtpdXhSTHZSUms1cFpEeE4wTHhi?=
 =?utf-8?B?VW9aNXl2Y1JmQVZWRnNwc0Q4L2U2VFE0SkxsS2FCc1pqME84OE01UjhnSmdk?=
 =?utf-8?B?T1JZdFd2WlFzcXNOWHpxTEw4b1lLekQxK1JRN0F6OVp0cnE4YzBxWDlML2xj?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c472dfad-e177-4a28-d4d8-08da8c900ffa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 03:06:00.0434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjWSVdTzkqpaw12SYz9WGRyZnC4dgVdMLhjVh6bR5jFECM3GT+Bo8najAiGggASHxZ8sYye8D5moySdYg0XaNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6741
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/1/2022 10:19 PM, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Yang Weijiang wrote:
>> From: Like Xu <like.xu@linux.intel.com>
>>
>> The x86_pmu.lbr_info is 0 unless explicitly initialized, so there's
>> no point checking x86_pmu.intel_cap.lbr_format.
>>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
>> Reviewed-by: Andi Kleen <ak@linux.intel.com>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Message-Id: <20220517154100.29983-3-weijiang.yang@intel.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> No need to carry Paolo's SOB for patches that Paolo temporarily queued.  And please
> delete the "Message-Id" entries as well.
Sure, will remove them, thanks!
