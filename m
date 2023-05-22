Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFAC70CE56
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbjEVWwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjEVWwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:52:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D0A9D;
        Mon, 22 May 2023 15:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684795942; x=1716331942;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wQgW8eAq5Xn6Q9LE2ANQ057bUQ+jHEMzIrwjFA6rY+Q=;
  b=hNsUFUfWdWyNfdOr70prugA0l0aKsDbCuUziZiNvjtyd7Wpot1rtWOmf
   Lrg++A3+gFR5Fs46CbkheHReawYeqxPxFMUw2LlwDQy3qRac9r2JK59H7
   p4p2ezNriQgIuQvfI52p+G92ORFGni0IjNkO9qgQCYfe/2n1UTcwni4Zo
   vxGz5GwN4Pgm5sTOHky9PmGD0FUZxnPG6Ee1qL0U49CRmNbd+RL9CRVgF
   TYvTM9Gv2zIjEKxak/+oBm/iXvCo1QQehMygGV5MiGqRF6xELtywSKec8
   /48d6K+J7ReCMMJHkxHvk3yamkVa/zpGatoyAjRlSEg/T/1zPbflhQXga
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="333428370"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="333428370"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:52:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="706723074"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="706723074"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 22 May 2023 15:52:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 15:52:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 15:52:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 15:52:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJ3SlkoqSkDW5HJt0CAU5+w2yZJpqp2eO44iBkEnQ0zD5ZcbutsUVpBGGnV2UKFcfM1aAM8jpRO/5DgtnZYH82ktTYauSim0w942OLLxAbjdUSgMtSG0cbVR025c2hTEybGqaxeSRQuo4fHONZ/iox8YwKetvvaHPSDIDTKPuOegztv/e2th1s9niDaDD53ss3e7cG0IZKlTHmGY87EVe0aQ9ViGp11Dksp8FV5JqHIaKpm/5P6TjHD159hbAV1UgNNCUQAMelipq6JNjpuOqZWdgGEULhN2FAvE90m+EYyUYp2R/6WgQD+52alNjZC+u89Zohizt0IHNCiQzw7SDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHJQ8Wlkt7wW6mFaWygycViKQ2uhT8JTL1wWzbtFF0Q=;
 b=oBxouH8E5SuVcLNye0anrMDl/77bC/Cv124d8mVbTS2/nU3RIuYkz/pFlFa2vXYKF9Jp4c7rVbE8P/GsLVgx3q51L9951+5n2Y3ZSxZV6RGZE7Sn21AZKvpEFfHaac6wftM8o/nKV8/5HvEiHepYgf0f10i3Fmy7deyZdQnIpU8DkDJN99f255UbYb0Fx2JJTwVF62dEtIf4HjF+WNE8lcjdIzHCll6amWxRP5gooF2gYV7g+QbudcEHn2vea6/3LobMj5VPSatlf6KsQYX/h4XoSqsob55aN1JiTgup6IwCHWYW+0C/SBX7aJH+k3e9aAB7yChhwh+ev+Wt0huuCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA0PR11MB4735.namprd11.prod.outlook.com (2603:10b6:806:92::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 22:52:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 22:52:17 +0000
Message-ID: <9d7fc729-209c-97cb-68fd-88ae6240d952@intel.com>
Date:   Mon, 22 May 2023 15:52:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <alex.williamson@redhat.com>
CC:     <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1683740667.git.reinette.chatre@intel.com>
 <875y8kvwa1.ffs@tglx>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <875y8kvwa1.ffs@tglx>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA0PR11MB4735:EE_
X-MS-Office365-Filtering-Correlation-Id: ac232470-509d-4c20-d451-08db5b17314a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yCMKY/bCNXC6gMBlGXY+hn2krsAad5cRVReutbU5RPWTboyKEh09aNxa3ZDvKFplKrnP3WfS9o4Tx21uCeIHHeFiqtY0gquqxHMjI73VK7SLYYycxP0ZRq8rrppGAEeLfXNJD2mPLNucLVCn5w1jXlAfli+/nh3ggKWjf1RwycUf6A5pNfVfwVPa0vZhZEtpzb1fdOyf76mPMLcxgE5Ax6S0n33MOf5m1O5/BWm8AXfKXp2vMC7lFnftUFP6iLW1lztDdMj9ubdMqvH9sosAMXw9dD+BCFRBF1gnJcq8wR6wY7bqS9HKBqGCeuoZRZjPA0HrcTwDMR/ecu4q4PLOigFPqpY2wRoSJlJMtuHFmXFFYAxB6vVpF++Cjo6kAxuSdWEw+xp6hAwOFmoj1en5s5G17jfj4HLuHt4VkDwe8ovY7yxgwJnur6KkhbhPkXpSqQkR0UMc0E36qrBlBFQftHms7s94wKlpRZ34bN3Fe34fnPJxC9nHdasK8lN+KLWZXiFL0M+d3+pIafUFZzhtvp7asBddR1T2R0YybVM+81ToGZvDHPxPYbLzkFoZqBuDRvWlhfDQnAZnaO+cjLbEhA/b1ffH4p7k51yrX+0TonWv8YVY9PK9PN6ujXgFOYAYwkcgp37Lsxohkvgmgb0Jzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199021)(8676002)(8936002)(44832011)(5660300002)(6512007)(186003)(6506007)(31696002)(26005)(2616005)(86362001)(53546011)(82960400001)(38100700002)(558084003)(478600001)(41300700001)(4326008)(66476007)(6486002)(36756003)(66946007)(66556008)(316002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHR6L1dZbTJsK0xmNTZ0YmdaWUhXQVpScHdNUllXS1F2M1ljeDc5UjFYSFNo?=
 =?utf-8?B?TWhxRkJqQStkU280TFdmOTV6cjRpRzhiVDhWa3paQndGTWorTjVETVdhenpF?=
 =?utf-8?B?RXVBVTZqTkFtNWoyQnBVNlRyN2M4M3Z5Q2prVnRzV0hhWmtTUm13RnhoSFR2?=
 =?utf-8?B?VVI2MU96VG9nNHdxY2xsbDkwOVVwRXgvZHQzUEdDZkEvV2szWlFneWEyaUpq?=
 =?utf-8?B?d09zUXRFakpEakVHeFR0OW9nUS81UFE0WnRueVdDT1JGcEJ6OHM0Z2FJOTBr?=
 =?utf-8?B?SUtHaHlzVlhhUGVNN0F2ZHRDRHZLTmwvMXZSNUQ0djQrbmtJK0tUOURSeU0z?=
 =?utf-8?B?eGlpWDJmSkx1YTJzNVNqQnVzNW9zenhrR2NtWlpuZWxxajNaWkFSM1hNR29j?=
 =?utf-8?B?WDREWUsrK3pzTzMreGliWThLbmlFd0hJMDBDdXMxRll6ZVc1YWhCYXZrUzA4?=
 =?utf-8?B?VktDd1JIZFNQVUpqb0tFcHJocmhnWVhKczN6TkJQakZ4d0NQNEgwa1NBU3I0?=
 =?utf-8?B?cHd2MjB6S1VHZ3QvYVhnMlZGMWRUWFVpOVBTdlBhVWg3Tk9Ob1c0V1BmNjdB?=
 =?utf-8?B?ZUZHV09CcndkaktEZzJyMHhESjUwU0ZXL1dkRnAyR3VkN09EeFhMQzE2N3Ba?=
 =?utf-8?B?UVJqcnhQTisrOHpTbjZuM0lrMUZIMVM4QXBUdGF1eHlPS0loRWNPbVBmM3FC?=
 =?utf-8?B?Z3dhbjdVNHVLK3lCdTBZSE51clZRbHZiNGorU1pYRkErWExFaTRjd2JoTzgy?=
 =?utf-8?B?UzVrRG5Tc2pEWWZNeG5BS0VkZ2RJdHRlUXJoRzRLUW1zYXFFV2FramFKU1Nr?=
 =?utf-8?B?UVlVbWE1ZElwTzBCdjd2WWFkemw2SFVoZ0VzMlBjK2Irb1Q4dlY0OFBCN3pW?=
 =?utf-8?B?YVVFbUVtdWRaTkNWSEgzbmJxUnlFblJMUG4vVzNVcy9NajM0NDlyQ2FKQllQ?=
 =?utf-8?B?ZXZMVDJUK2JjbVNWZlRTcUFrUXh0MU83VklKOWRzOXNiL21VejBsMzZ5WGtU?=
 =?utf-8?B?b3orcUpwY2toNEREOW81VWZ4NG9sRXBpOTgvN1NtN3ByT3BRcFJ5MG04R09t?=
 =?utf-8?B?UTJmOXdaYnQzMHRtYStXODZQemFocjZ0S0hnaE05RC9sbWRtRmlGM21QM3BI?=
 =?utf-8?B?MG0yM05ISDFvOUxJamN0NzhIam5IVGdLWUZyZXNTdW5RNnB6dEpPeVZ5RWFo?=
 =?utf-8?B?Ym1XNHpMR3Z1cGNOd3UzeHhzUjE3Y1RLY0N3WUZnRkxqbFRUeUlxdnFsQXcz?=
 =?utf-8?B?L0h0d2RQeXdxRytZTGwvTUdYUFBRY25RNCt3TEJnMjJPZEViYVBvN1pvL1Vj?=
 =?utf-8?B?eWRQRnhkV0xJK3lHVXY5NTJKajgrRHNGeVRNQUg5R1FnYis1K1pON2N0Wmdn?=
 =?utf-8?B?eGhIVmZKSENQdHBuMnFneEhSbVZQeU1FdWtlVUdvVmc1d3hPdjMwY2pjWUhq?=
 =?utf-8?B?R1M4c3Rub3JTa2JlVXQ0VWNvZlRFcHVBTEpibjNPeFJLTW5reWxnWXhrZklG?=
 =?utf-8?B?bmhGU2dTVTNlMyt4Y0FVdDVxTlo0a2xBbWRHcFN0NEJ4bmlhVTZHa0Fjcitx?=
 =?utf-8?B?VTFnZnVTaE5uUk4xVCtDbFhQTkxsR0o5bkg0N2xiQmZLUlM5cHBLMy95U2JT?=
 =?utf-8?B?K0l2bUo5T2JvSUVRalh2RUozbW1lT0JkRUg3bWwyUy9WcDdrN2RCZFBsMjlh?=
 =?utf-8?B?RUhLeHhJak1ZUXZyWE4rZUJYZ3owdk51QmFSaXNRaG1ZZk5hY1hBa1M1VkVG?=
 =?utf-8?B?bHdYNURKYStLSzRqZnBKMFgycDA0SDVKOFo1MEVTTEpUSXJGK1NoWXR5c1Rp?=
 =?utf-8?B?TFRqU0dGdGp5WjlvTDZ5UUp4YnBvMCtWUm9tR2RRSFlXWXFNdEhZdm4vazZ0?=
 =?utf-8?B?ZzhJK0NkUkhjZUNFdUtRckdlKzNwRWlZRTl1ZHc4SkxpUEZWcFhMUGo1Z0dv?=
 =?utf-8?B?RXZTM1lDU3lMY0ZISW1vS1JIR3RnRWlJK01RQ2JqaGJwTGxkckpzdW1uaVFM?=
 =?utf-8?B?TmZoeFJYaGJManM0a0UyanhrMTBRYll6SERhbUY4L1REWnU1Ung5Vms4RHN3?=
 =?utf-8?B?MEErdWJmWThxMnl0akwxU2U5MnFjVldIeE1EWXZ6WmVmQ3N5WXF2RmVoVmdn?=
 =?utf-8?B?b00wTHQzaU5xSjdpY0lwMEtTMkpPV0NBa0gvVEh0dlVCU0h5VE5jdFpTSVhm?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac232470-509d-4c20-d451-08db5b17314a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 22:52:17.7255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ie1bTwflf9Jsdt2NxCLtqVp/ZiNm1cHhC21iufxuXBjqPplWOgVoKvi6dIWq00jS5CI85RSVsnWEp6lzwFjCsoJjj4R5lCj2I7jS1BI/ISw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/22/2023 3:25 PM, Thomas Gleixner wrote:
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 

Thank you very much Thomas.

Reinette
