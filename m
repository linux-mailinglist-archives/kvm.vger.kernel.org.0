Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA30A7A1357
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjIOBzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjIOBzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:55:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C644583FB;
        Thu, 14 Sep 2023 18:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694742749; x=1726278749;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uvr/H4duFrOXzLTtp/L+350QxIwHmkS8x1DNZheZzDA=;
  b=P20UPWp3niAUJR923tLUNP7L7ySTbR4akvTvybMDA2QrfT04Oo97AXRq
   tCuLnXxnkpLLLS5GmfisuVncjI4nG7yY/76FmBM6jkt4oBnlDgDHxmSNN
   gc9Sq1NiZyYtoSes2wc/ZirNwmTl+ZXCDu83p26t+vGpdZoZ3BDVa8ks9
   nizUHGMImU0CWDLAID60bg2l/BP8GkgKVtxL4eVpHSffLTrCTrREHMpZH
   G7mSa0tIPRstd2kG5fEYFKPfS+0UdliWK4IFEpuQBPAfJ+8IR6msTzoOL
   616Vbw6LGCWHhzKJZAtPHot+/3uain5zUd4rYnOTW7ZdnvUBrthdOZusH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="369448321"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="369448321"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 18:52:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="774122019"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="774122019"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 18:52:29 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 18:52:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 18:52:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 18:52:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CyPc/YigX6cFk5MN/iZCFRSSEFUI7NmounE0qF6kE9hXd5eW3p8UIlzd3wd3vFjp3Y9FcjrP3/rZ+qyS3RSzqOj/fPp32X6gnIZ2of8qjsCIQvj/7OW3Z3saS8omkNsSoEMXGbndPFfJnux7Oi8yNvSDzgS3U5J6gkhHeo6wbV2n40etA5zUz4zAHnV+xtjjNf3xwYHoJPlzMNt27wGzHdE+nStmoDdzTnmmHrNnEFHFHmjDTw5dXAdWFi9nL0v3klHUtmgCgrSOKZpHeeBUDowdbQhN/ZJ4H/knRH0AUmMZFagjkswmmogd9fB2xo89aWechBAjWICXHBh48HgkyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5lfN95W9LXaYCxJnm8gR3iZcPsNz0r5pZZLg0uutRY=;
 b=gaavyXVMtLcp9x6ybygaoGZ82uo59+l6DSd7NikWDB+fnxn4wJQDQ4wlv5cfFvAsYgEGQLsAmH5kFtXM7TzXzYnuYlPzA2hwPvgjeFuwrM9YPIV4JK8D5baWKW4EfvAdgrU1wBnAjxJ4+JoHWbXl5FZAV5+4DUpwd0PqZP/3aMDX8yUlCObyNkAx2UukEAlmqZ9JH8FIYRN/aHwxGu8BNgrCGtMQBNSDZXZS9HdUPy3P8ehcPepxYKE0WKiZz0guXWgFQvTr4WBy9uyDdbtGNz/rPvNUnAHLTOn+Rmg7zOK+f6bYH0FJsloa5kOWLm56p22XZaPKLnk5mAqolPdGSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5054.namprd11.prod.outlook.com (2603:10b6:a03:2d3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Fri, 15 Sep
 2023 01:52:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 01:52:26 +0000
Message-ID: <05121c7e-b7ad-e5f7-e42c-12e30369e559@intel.com>
Date:   Fri, 15 Sep 2023 09:52:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v6 05/25] x86/fpu/xstate: Remove kernel dynamic xfeatures
 from kernel default_features
To:     Dave Hansen <dave.hansen@intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <chao.gao@intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-6-weijiang.yang@intel.com>
 <d8c3888c-4266-d781-5d0a-381a57a9c35c@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <d8c3888c-4266-d781-5d0a-381a57a9c35c@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB5054:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c443302-6be2-4fed-0ec7-08dbb58e693e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/1t2nav/DtkpYj8hKpiHRnRac1a15taAPwtD9Rr+Q34zsaPIqxK8XIpW5Zo2/u7rl9h6QgWW8ldr3fAPUkF/lzn4Px+H94p51GUf0j9GUN8nsWS62pgJGQ3gHpYD86zTtkAo2yyWh2oG+M2eW/LNwgqRXueZ+cwpSdlgPuA++a9OGVHB9mZDVCXmcsToE6580E2KrgWZdOJ+zItNSe2a97krEWdzrVOTbAwRSijYMDtfJgiHHvLNbhY+5NfSKrr7JCvairtemGEvILQhjwGDQmGq1zamNPZMvvWqO6Pew/7B6wCWz8Bun2gJUfHglN9o/T+mgqqjpmzHXwHlbgJLkFFdBwJCSlSZg7+yiTk7JYtWPVLow8YKoPa8Lyy10+J1yVaNSe6m2tk7WJk3MKiF8rqDlb8g1QrJPDHLxyuEkJaHHa3dyREaarQPWYYN4TXnP7KQCMc+NrN5Q9Zan6RUUWxTWa1xX5yNXA4JuP2CByB7WrHROxZ2W0PwCk7j69MA1hIXJFfpQJRqYSSImR0vbTRFBYoV3heGqHTAjk2fLcUBFkx1vBUEVoC1o4diJ+B1xbBeLQqqPceRxws9a5dmONyc7rYpGwgva5gSd4wux4GCxZNrL1OYqRixoozsmyBvngRjzk8CwMgXrIbAVgjZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199024)(186009)(1800799009)(6512007)(6666004)(6506007)(6486002)(53546011)(83380400001)(26005)(2616005)(5660300002)(66946007)(36756003)(66556008)(66476007)(8676002)(86362001)(31696002)(82960400001)(38100700002)(316002)(41300700001)(31686004)(8936002)(4326008)(2906002)(4744005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3dlTEx2Q0F6YWRHcjdoYmtmaG0xMk5vT3pmUDJBcWhlUUM5NTl5L3pUdG1i?=
 =?utf-8?B?aG8vd2xvM2hhOFBDT1JKL1pyRWtBTW5Jblpha2kyYXQ4N3F2U1hQOVhIRWtP?=
 =?utf-8?B?Wi9IeStYc25rOHV2Z2JpWWJHeVNyV0xPdkxpMGpjMS9sU2hUN0JmMzhvOTQ4?=
 =?utf-8?B?VWN4KzUvRHlzZERZdVNNSk9aTWNqK0d4eWZRbm9SNFdsREg1US9QMlhOYXAx?=
 =?utf-8?B?a0JTeEVDR0U3Z0EvWFE1bWZhMXNBS1FTbWtjN3FmRjRBeGRKNVBrdkNLaEg0?=
 =?utf-8?B?WHVIbjJudkxlazdDSkJaTzg4VlFvZGpXMVJWYWxhbzV0K0VxbVo2aGlETGU3?=
 =?utf-8?B?K2lPalZCeHZBempYbkQwakJiczliWFZKUEJSaHp1aGw0OXI0c0pZVkl3RzRM?=
 =?utf-8?B?ZmpzYS84VTlQZm5vdFRnNEZrQkVyd0ZaeWlEOTlVRmpXVzdKUEs1azhPOTV3?=
 =?utf-8?B?a2grTS91cGlOei9LZ2pJVTZoNTNjUXQ0cEFsQmZvQXM0cDVhb3pXMEhCRWhZ?=
 =?utf-8?B?NDRwMU84OWFzV3JHUDIraGN3NUJXcnhXM0o1UjFGd3U5TW9UZnNHSHZxYnRy?=
 =?utf-8?B?RFBRVEw5WUxsdDIxSEJQUlJQVlYzdklBMTUwd2xsVVRsQXE1T1NqRXM4bXhl?=
 =?utf-8?B?MjNwSm0zMUJBWDJ0a0VpM3JYWE8ydXBYTmZOeHN5aDB3czJIb01MK3BjMVFG?=
 =?utf-8?B?ZXk5a2NwWmpXeGxCbXFUekJBZTYzOWVFL0pQaGpLVjRLQ1dWUkYyL3N1TDBD?=
 =?utf-8?B?SU5zNHpYYUlBRm91YlRGNGp2eC9SNzVDYzJtZk4rMXMzWTFrUGdadkptUWdp?=
 =?utf-8?B?bVJaWUFSd2lFOTYzdVNaWXJYZEpybFUxMWdWTGFnK3FPS3puc1JFdXdNYWNM?=
 =?utf-8?B?R0ttMTVXYUpLeWpPaXhxTlNTMXJWZHhKUlNoaUxFYm9DenlYcWQrdGlUaWpK?=
 =?utf-8?B?RENQa0hSRUF6YTZIdHJ0dlU1Q0hJazA0emo0bkI0L3NTbldpamNweEhVTDlY?=
 =?utf-8?B?aEc3NmIyaDN2Wm9YYSt3ZXJWTW1nWU5ibWFWeEJhV01TQ0Uxb2tWWURndkky?=
 =?utf-8?B?dy9vbzA1OTRGZkFWSE5RZVl6UWFva1h2K1pXU0Q4dVVHMHZmK0FNV1Noc3Fq?=
 =?utf-8?B?VktrcGxOSnI0Ym5ZeDh1UkdIU3UxUDhrYldzcnZ5OTVFcllyampNMWZkbTdQ?=
 =?utf-8?B?alY5NzFHT3h6dkw0THVqNHRyZ2FBMVVHQWs1TU4wM0FMQlpaTmFjSmhMcC9v?=
 =?utf-8?B?UnZmc3ZPRmtPQXdndjJLd3hWdXpTNlZ6UkhycU45QlNvbHV3MG1PTjZhZEs3?=
 =?utf-8?B?eFBkMGpvdjhLK2xGSHVreWJHaTVJRk1xc0pxK0ZnV3ZkS2dPRlVjbDVZN3JW?=
 =?utf-8?B?UEliUStzRnRnenBFUGlVVHBzY0tUZzBNT2s4OEladGJqVHN2VUdoZjFqM0N1?=
 =?utf-8?B?UUpXZkdtekUvUjlYZ0g3V3RGM0tNUFVXZ0ZGVit0dXJFUHBJZS9nSUU4Z1JK?=
 =?utf-8?B?VGlvRE56RWZ3aSsrUlpNWTYycjBYQ0pxQW90M1pYdkFrZG04eDdCZTE4bkU3?=
 =?utf-8?B?Q1lkbDU3dkUxYnVweGV4YjlSZzJpYldkcDZpV2p3dHNualpVaUpzS290WWp6?=
 =?utf-8?B?SThlMC9tZ0hyTGNMdUpEN281cjFnSG5Ld3RFWER5YzJoQlVPMnd5dnh4R2J1?=
 =?utf-8?B?MDRmeHpveUZNaUxPaEdHU0ptNWpMeWdQclN6dWlObTk2a2RvZXdJMWhNSklP?=
 =?utf-8?B?NzBxVFNqSmdVK2lvMEpaNGFwdEhyRXQ3cnZKNGFUZXBGOFJlV2NXQktHeGhB?=
 =?utf-8?B?eWRZbk9MOVZuYmJqVG14NWlNbllkSEZkMnAxR3dIL2s3VFNHUVdnYXlpU0pS?=
 =?utf-8?B?ZlNDTWk5QXhFdkkxYXV4Ui9IYUZDMVFoRXFVT2s4U1RjZldDckNzSkV3Qmdj?=
 =?utf-8?B?MjhMSE0vMUNIOTh5YkhPaU9IN2x3Umt0WkVUa2VoWnVkNGNYN3lieTlVNWMx?=
 =?utf-8?B?NjVQQ2lMR0ZzcnN3bDh0WGxMUkt2OWZvNDg1QUR3dkJwS1ppU1VFb2plYXZ2?=
 =?utf-8?B?cEFXSVhuM09Ba2ZocmZBcGpwUWFzM2l1U0NJaUFMSjh5Skl3MzVOUXZ4cmsx?=
 =?utf-8?B?VUk3WE04Qi9CNEFUckZtdGpaMFdFRnlwWkRaUnpBTGlkMEhORERkOHFseGw0?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c443302-6be2-4fed-0ec7-08dbb58e693e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 01:52:25.9706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5o4frl+vgheLlSJxug36HYSEvqi6vBevS7eP6r4BGLE6upxLx7/Hqy58l8l1M5QGHkMgGFIJaWskF++8UKOXKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5054
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/2023 12:22 AM, Dave Hansen wrote:
> On 9/13/23 23:33, Yang Weijiang wrote:
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -845,6 +845,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>   	/* Clean out dynamic features from default */
>>   	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>>   	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>> +	fpu_kernel_cfg.default_features &= ~fpu_kernel_dynamic_xfeatures;
> I'd much rather that this be a closer analog to XFEATURE_MASK_USER_DYNAMIC.
>
> Please define a XFEATURE_MASK_KERNEL_DYNAMIC value and use it here.
> Don't use a dynamically generated one.

OK,  I will change it, thanks!

