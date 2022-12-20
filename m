Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFF2651D28
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiLTJVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbiLTJVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:21:04 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57908183BE
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 01:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671528059; x=1703064059;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=q6BwVv7yQkyGC72tP5yaPu0H9Pc5GSrP5BXlGryUPJ4=;
  b=dYD3fppkU3az0JVFCIQCIN4k4NtbvmhLrQH+CNGX9XZ/pM8RWMyUCIhV
   6PlTz37r9Befswi1e3pV+KbVzrZW9CK2pMWL3rUWwg4vDw/FtsJRgkOo5
   kdNpDsxRZfQzgxtVne09cB83pJwBDaAzRP8pnGOnbGcq4IhwKRjZYc4gw
   33ueFJHlHzlg78aHiR8xOduvdFHAgJNlKd/X7/cYKf9rxz09Ipda2at+k
   0sUR5vGDYvosIvOGLQC+6xBmy2gqc7I6eiP7c9BJzUp8YglS0jU7gHm04
   zQea4wQj/CtOIC0VmOMnPcSxdOpqqfGb+WRTO79LWDcHa2FhmBDMGtCwC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="320747345"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="320747345"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 01:20:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="757999896"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="757999896"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 20 Dec 2022 01:20:58 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 01:20:58 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 01:20:58 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 01:20:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7CJsFni5SNMDdciAti1gBQIOTIpaTMdcQQNfr66Ov6Pshv6bchytKOPs3ic/UN4ErJxyMuzLMYvoeoZDin8sGNenCheHAFxX5yIqoyyvS0KPp4lm19raaTgKo4Q/EXfXltDcXUNJw0myASEMZEI55VLSLIzrYg9Yhk2WkSp7YyOIL2nA6Yp95ZEO8wxncmDqgFh0JqZTg07WTlgkH5YGsGcOA/I7B9WhPbF+eib9Vkmw8lllBGNd2ceS0pYjsvUNyrrP12/OOM+h6En7nx9inQ6cecwi6o5ysVzDbsg1N6gS+Y3ddfBG+ecYH94uwwz8kfBTATQhYWa/V4e9kFV8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBuHb220Hep5H5BgvGyj3WDPCbqHMHNv7lqyGrXMP40=;
 b=n83aneJOrc3nt+YzX2DRyHq6DqalCooL5WH8J4MbxoEVvb20EF/lLPqD7TPU2qAMtjGLDVGg9KJxlw7KlfB0uV7YZ9JT8eR2KJDD/H0f7pJa4sSmzdWFv9Y1Eg3xB4WKy4lk32ekjLYaapGzZWcN82cjkgNtPCkIz0S5d4/QwNQopd/Kke1ibjO+6OCnB/hl0pSIPElI55UhzXmWsy9FI9gI4U2CCh9m/+C32aM0kPZeKCb2HS8glQobyuVBBPMBmaBbC3uzmhQ8LW6DjMFeDWNlfqy9cD+31CvxwxHs8l4rgGO4UVNV6vXNtR636PpQzjokD08TokkG40v9e4zthg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5469.namprd11.prod.outlook.com (2603:10b6:5:399::13)
 by IA1PR11MB6466.namprd11.prod.outlook.com (2603:10b6:208:3a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 09:20:53 +0000
Received: from DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::3469:4423:b988:65db]) by DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::3469:4423:b988:65db%5]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 09:20:53 +0000
Message-ID: <a1491544-5f1d-605e-92bb-7135629ce649@intel.com>
Date:   Tue, 20 Dec 2022 17:20:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 0/9] Linear Address Masking (LAM) KVM Enabling
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
From:   "Liu, Jingqi" <jingqi.liu@intel.com>
In-Reply-To: <20221209044557.1496580-1-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To DM4PR11MB5469.namprd11.prod.outlook.com
 (2603:10b6:5:399::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5469:EE_|IA1PR11MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b295132-7fdd-4ae9-781d-08dae26b7e27
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vlu/43ariie8tmOkx7hkRvQOLtf6HgXg63c0pefs6XL5SR/Mqs//ha5Lhzw5zHyXLXbD0Fge6ZqJLkXqqwcdkpdcdTmZkj+XScWq8/0nQ6Fj98/mEl4fEqkCyUN9whVDVfw8b1RzqqZoJ/lkvLSYNOOWLAXpNEV7xNKxNwpYzcPT6i/fz1a57yp6C5+50iEF+TaozNos4/CuFLGKAiE59tP/QcYmV8rqP2KKSOo9/vKkO4IsI0t5ECSvYa+FPYdVf++HLAoynHVlJlcXhImwuKRuVoKACKULkoSE0o9e2ZWGTTpgPIHYS1ZTf2+sHO880SN37x+0rYeiUy+CGKFFsOu+9RnFWROTo3Obx96LoyHQfi2p29/cqPlVsq5tW92AyjLmSJAXxQ3W0TdtTMAe7Nv4m1VXBwEvuyJxvrJb1h1ZPIU1RB6nkQH8n5UgykxYMXnAhF+JEsN5V9iAym1rwzArs8uyKVilvjQ6GDgPLZxltwZMOwQ9014ktE9ojKHiVbk0jjUC96F7ztGFGsnxrIGuCfniTAYDyY3i7ntb7ZKeZyuNskOy4uepI2t8jQtnRYcEdWWP4CEBDEkhpD4eAihq42wRqo4lvi/GqTF+36BjKsEJQ8Yer0x4cOMvoXyMGgSn/Y/Bds2s7BJ2MdQwk190Qgqb/kxcr9q9u4FWIMHgg/VyR5XpVTiztwoprgd4ueB5l4ppDNUrAuCdRrdGUZ7TQJ3Koc/JGTuBtCZGTiyR9tAq2mtk9P7gTMEYZNxVWEN8k2b6+jrLSAZp0DE7gUpyGIcAw+tM6EFW+jS3jw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5469.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199015)(31686004)(86362001)(31696002)(6486002)(478600001)(316002)(26005)(966005)(36756003)(38100700002)(82960400001)(6512007)(83380400001)(186003)(53546011)(6506007)(2616005)(8676002)(8936002)(2906002)(5660300002)(6666004)(66556008)(41300700001)(66946007)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3VVYlJDUm5RSnBmTFdTMVYza3p3d2xVWGJsbzNOTTBaWFRNQkF3Yy8yK29D?=
 =?utf-8?B?QXBoQjluYVIxRDVSWTUzQkFRcEZhWmd0YkpDTVNpYlNmcjhGTXp5c2h1ZUJR?=
 =?utf-8?B?OUM1WkhpMFZyZHEzeTIzTmI5cWRqNGNLSFlrRVlQTGE0cHFadlArbW5jK2NJ?=
 =?utf-8?B?NC9MWFBYaFhrSzA3bE1paExiWm5HSGJYTlp0dmwxWkRBSFhqdFI5U2RMd1Uv?=
 =?utf-8?B?RWFMbEFFZnVUU2F6OURpSCtxRTRScVplbEpvcXVlMkE4dGxTbDdhTzN2YjhI?=
 =?utf-8?B?dHZuUktSaHRiVVFacUtYYkdGT0JRbXZiOVI1cHVIb0VxNDk0bnA5OW5HZnM0?=
 =?utf-8?B?MktWNWpwSmVoaEdpT1BxaFozUHJIcyt1MjFUeUUwT0N2dkZ6L0RhWmdTWlhQ?=
 =?utf-8?B?bjk2MlYrQTdXV0dGNVgxUVd3dWZmZHUveDBiaVYzaTRjYzc2TTFPT2ovSTlS?=
 =?utf-8?B?bEI2UjBDZkFsN3c3ZWhubTB6Tzc0YnhqZkt2aXk0NUlqUklFS05WdDl4cWlT?=
 =?utf-8?B?WU02ajBDa25yVGg4NHlvaExXamNXcXlYTG1pR3c5TGJsNjBMQ09BMUZNYk1j?=
 =?utf-8?B?TnlZUGZrc2l0cnc5UHZQUllCcHh0Q3dKMCtQaFVlcnpoajkwclZiQlZDQy9T?=
 =?utf-8?B?aVY5RHFMeGpORllnUVJxNnhud3NBWVczWVkvZ3BqaFNuK1dCSVovTXlYd1p1?=
 =?utf-8?B?dENIcHB5YTMxT284SmdMVmxvMUtDbmliVFY0bzJ5MmoxbFp1bXhFZGZ5YytP?=
 =?utf-8?B?cVV1QUNKTWhOb1JzZVhuVGVDU1U0YlgzV0dOVTdkQmZZWU1Db1d4K08rOXAz?=
 =?utf-8?B?VFhMQURGVGZVSklCVVdEc2EzTUJtUk5kcWRXZGc4bTM5ZTJFb0QwL1l4WVZ0?=
 =?utf-8?B?TVU0TXFYKzJYM3NqblI4ZHFNdGdJTnU0czE4enVsM1l3TnNEdGVJODQxcXl4?=
 =?utf-8?B?MHE2cWEzZ002YTBFOWx1M3ZKNXRvd3hLU2luL2VyVXd6RUppMkdTQjByN05Z?=
 =?utf-8?B?dTAwWnFvVzNKWEZFQVp5bUFXUWlUNncwMTVZanc4ZGtIQXJqZmUzK3d5eER5?=
 =?utf-8?B?OGhzSTA1dmxsQnM2d1FSZ2tST1hZUXpWTzcya01aQURXMWQzbURZVU9pMXZu?=
 =?utf-8?B?ekxtOE9XWWl3VXlwa3JnMEN1SDVXY3pDbG9oZjRiSHBrMDBINTk3aHV6bFJM?=
 =?utf-8?B?cGxKM211NU1Xc0k1dTNuOC81Wk9qc3V4TWQvV005OE0yQkxmSy9zSEduQWpm?=
 =?utf-8?B?KzNJNGYxUzJSTldGYWVQZTlwbE04TGJ5ZnJ1dFhuK3ovcitTaTU4YlZ4SlFm?=
 =?utf-8?B?QTBBTEhnMnJySjhwaE8wU045M3h3WDN0bVN2ZmhZM1NWb0Yza2lDY0c1Wm1v?=
 =?utf-8?B?cEo1YVFmTjhKQ0RtTERCMWE5N1pGTTRkYWEveWE3RWRxNXJoMDBTNGNmMHlr?=
 =?utf-8?B?TE44c25jZVgwZzdnZTN1WVpFOUNkMXV3ZEhyRzA2Rmp6L29qQjBNWjhrdlpx?=
 =?utf-8?B?cEtkNnZ4S09lR1NUWkY4d05lc0RVNUN0SEJQNlhnVEc4NHpTSE9CNWEwaDRm?=
 =?utf-8?B?VHpZWDdCL2RnWmlhSnhoaTdhVVlMQ09qbEZLekdiRW1RMXAzL3ZJQXltUmI1?=
 =?utf-8?B?TXFJRmZDSW10OUI4TXhKOVBqSWt0U29DZ1RYa00yYk9OZW1pNW1VaUM4cHBW?=
 =?utf-8?B?V3ZXbzRDbkF0ZWVCYTJVTzRvZFJ2U3RsWENYd2tMZDBWUmYvaFhlNVR0K08r?=
 =?utf-8?B?YXNrd01iV2pIQ20zTzYrL1VrL3V6NU13cjd1NDNEenBoQVZ4emFyN2ZBS1Yr?=
 =?utf-8?B?SmdJTldPZ1VNMmR1YStoZCtRMTcvUXV6bHZNWHdFdXBrYWlvcWxZcWJOWFcr?=
 =?utf-8?B?Tms0YlMybjhlcHpsbWhGcmNMSFdMVUEwWnhZRmt0MWVIZTVZVGt2aTl3cWtl?=
 =?utf-8?B?c1dUWFlFZHV6SDk0VEIrNW1RM0pjL3RwY0FMMW9FV21vUFpiWFZqR3ZoNVBG?=
 =?utf-8?B?U0NOSW9PWTRpQm9JU0hhWTlRUmgvOUMyYUdxdHVrT204UW9aWUhuMEFnZ3p3?=
 =?utf-8?B?QkJZanB1VDF5V0tFbCtOSkU1SEJqQmdBazlGZndQZ0JvWUZ6aEV3SmI4MHVW?=
 =?utf-8?B?VEFEQVdFQUlxTllpV1dPSjZlQXZMZnBxbG1HMXJxQlJmMGdjcTh5RW1TempN?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b295132-7fdd-4ae9-781d-08dae26b7e27
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5469.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 09:20:53.5533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrDNZuDj/NQC9yxTpFAVUMJh6VMgWY6FH5kgajX5hEWqKA+x0ErscqsratzZVVFEZUlZWXRBod5X0uUT8RrJiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6466
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/2022 12:45 PM, Robert Hoo wrote:
> ===Feature Introduction===
>
> Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated
> address (upper) bits for metadata.
> As for which upper bits of linear address can be borrowed, LAM has 2 modes:
> LAM_48 (bits 62:48, i.e. LAM width of 15) and LAM_57 (bits 62:57, i.e. LAM
> width of 6), controlled by these new bits: CR3[62] (LAM_U48), CR3[61]
> (LAM_U57), and CR4[28] (LAM_SUP).
>
> * LAM_U48 and LAM_U57 bits controls LAM for user mode address. I.e. if
>    CR3.LAM_U57 = 1, LAM57 is applied; if CR3.LAM_U48 = 1 and CR3.LAM_U57 = 0,
>    LAM48 is applied.
> * LAM_SUP bit, combined with paging mode (4-level or 5-level), determines
>    LAM status for supervisor mode address. I.e. when CR4.LAM_SUP =1, 4-level
>    paging mode will have LAM48 for supervisor mode address while 5-level paging
>    will have LAM57.
>
> Note:
> 1. LAM applies to only data address, not to instructions.
> 2. LAM identification of an address as user or supervisor is based solely on the
>     value of pointer bit 63 and does not, for the purposes of LAM, depend on the CPL.
> 3. For user mode address, it is possible that 5-level paging and LAM_U48 are both
>     set, in this case, the effective usable linear address width is 48, i.e. bit
>     56:47 is reserved by LAM. [2]
>
>
> ===LAM KVM Design===
>
> Pass CR4.LAM_SUP under guest control.
>
> Under EPT mode, CR3 is fully under guest control, guest LAM is thus transparent to
> KVM. Nothing more need to do.
>
> For Shadow paging (EPT = off), KVM need to handle guest CR3.LAM_U48 and CR3.LAM_U57
> toggles.
>
> Patch 1 -- This patch can be mostly independent from LAM enabling. It just renames
>             CR4 reserved bits for better understanding, esp. for beginners.
> 	
> Patch 2, 9 -- Common part for both EPT and Shadow Paging modes enabling.
>
> Patch 3 ~ 8 -- For Shadow Paging mode LAM enabling.
>
> [1] ISE Chap10 https://cdrdv2.intel.com/v1/dl/getContent/671368 (Section 10.6 VMX interaction)
> [2] Thus currently, Kernel enabling patch only enables LAM57 mode. https://lore.kernel.org/lkml/20220815041803.17954-1-kirill.shutemov@linux.intel.com/
>
> ---
> Changelog
> v2 --> v3:
> As LAM Kernel patches are in tip tree now, rebase to it.
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/
>
> v1 --> v2:
> 1. Fixes i386-allyesconfig build error on get_pgd(), where
>     CR3_HIGH_RSVD_MASK isn't applicable.
>     (Reported-by: kernel test robot <lkp@intel.com>)
> 2. In kvm_set_cr3(), be conservative on skip tlb flush when only LAM bits
>     toggles. (Kirill)
>
> Robert Hoo (9):
>    KVM: x86: Rename cr4_reserved/rsvd_* variables to be more readable
>    KVM: x86: Add CR4.LAM_SUP in guest owned bits
>    KVM: x86: MMU: Rename get_cr3() --> get_pgd() and clear high bits for
>      pgd
>    KVM: x86: MMU: Commets update
>    KVM: x86: MMU: Integrate LAM bits when build guest CR3
>    KVM: x86: Untag LAM bits when applicable
>    KVM: x86: When judging setting CR3 valid or not, consider LAM bits
>    KVM: x86: When guest set CR3, handle LAM bits semantics
>    KVM: x86: LAM: Expose LAM CPUID to user space VMM
>
>   arch/x86/include/asm/kvm_host.h        |  7 ++--
>   arch/x86/include/asm/processor-flags.h |  1 +
>   arch/x86/kvm/cpuid.c                   |  6 +--
>   arch/x86/kvm/kvm_cache_regs.h          |  3 +-
>   arch/x86/kvm/mmu.h                     |  5 +++
>   arch/x86/kvm/mmu/mmu.c                 | 18 ++++++---
>   arch/x86/kvm/vmx/vmx.c                 |  8 +++-
>   arch/x86/kvm/x86.c                     | 51 ++++++++++++++++++++------
>   arch/x86/kvm/x86.h                     | 43 +++++++++++++++++++++-
>   9 files changed, 115 insertions(+), 27 deletions(-)
>
>
> base-commit: a5dadcb601b4954c60494d797b4dd1e03a4b1ebe

It would be better if you can provide a URL link to easily reach this 
base-commit.

Thanks,
Jingqi
