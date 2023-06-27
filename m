Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0271373F8C7
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 11:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjF0Jaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 05:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjF0Ja0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 05:30:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333A41FCD
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 02:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687858222; x=1719394222;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v+5/tCeR3aovdz9jsGswy1Pf9m0KbSftlwWNA5+EsRI=;
  b=IDJu8qdn6eU4pnqwTZkOkstlzg/PEydEc1gFrxpk99I37aS7zVc22TEO
   RGeAzf+bht1uHHsemeKEtu24qQUVuF7LBlHwRy22XpzUW5jncE7MpDHhW
   azRYmwbi31F0oJ90pCqiQl0mcg0RYTa2JgWDTu8Qlzrn3318sXRY4N2FH
   5vZOeiSeSvk45hYZH8tk6FV3EtB1+5ixNHH2+n3sC/TMuTHBcCJIjbNUi
   qwhFI/ri7lFZugJIlBZiIf/NPsn41gIoVmRaz+2qtQASA31n9j1zqaB9R
   TKrMvjHGbFDy902YBCsuygp03ooMdWW529kROwT5pd4E+AwpAhNJDMH35
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="447908151"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="447908151"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:30:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="806398829"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="806398829"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jun 2023 02:30:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 02:30:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 02:30:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 02:30:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/q3Xs0L0SwK7xQTwHF1a28o/mqqF7E5QxV6eA0QF8jEzL6epNQN2MadJYlVemllEMBOFwmUh6TdCdmPpHnc2mHCEYauQDDm2lxC0N5SoDme4l/evMjPLRdvDwcitpycPRGxnh6I+kWF/uKCdYkV3ydskFNl9lKa0UtnW/VGsY5DokMJaX3cMjDC3dCp7HIpfGqQelGXehD6qbMWW7D3ZrZAqzj+QBmLCVwznXBMsc5nrIpSlS/KmJpQQSlbB7VzsNNcZsc7IX84AmeLN/5+ayEUe38niUxNvKs83mIpfhwwN+XVfsweH+hvcNBV0Mz0lU2nZcsxBJ4sJLK2GOZRJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzZ4xP+cArVSFd4aLofoS0aHL6PdNzHrtyOv0KpKXQU=;
 b=bU6ETAf9IaqXJYnc0w+Olv594KEbD3f0smwUBLCwlrq6gU8+estEysTJs8p92KTJHxIOhjYWlHQQnb1J3U9GgLjjXAj3Eotupwf+1koSjPum7kvI6opg4crhK36mMCppzuudW7pAB0gSHCCeaBSigK7sAJfO+sT2+x5pC3FSn2Ztx8h9TbOJ2Cl3BLSKBWXCS+xuXAvE62Rr2ipLcbo+xE+9buuSVTdq+I805PN8Xwg5NkSMP47qMvuMHokyzatE/6v8W133xZPwCe/2qC1gk9qiS+DKWmSJQnyyVgDYdGg5XKlXwR4JgsuPUQtj430LKPRUJtzpI6WDUSMvNrDk8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7043.namprd11.prod.outlook.com (2603:10b6:806:29a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Tue, 27 Jun
 2023 09:30:18 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 09:30:18 +0000
Message-ID: <f7817f4f-13ef-6cda-f001-5cc16f340bd1@intel.com>
Date:   Tue, 27 Jun 2023 17:30:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 3/3] i386/cpuid: Move leaf 7 to correct group
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20230613131929.720453-1-xiaoyao.li@intel.com>
 <20230613131929.720453-4-xiaoyao.li@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230613131929.720453-4-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0215.apcprd06.prod.outlook.com
 (2603:1096:4:68::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7043:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e82842f-349f-4573-79e8-08db76f11ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFwCatEiEPnpp2d8OVOj/ETbZ62lXCZTObwdQCRQHozhigpwprklQ/7JFVBPdSPnCihkKtJK2sKOe9d/xVqv6Rhycn2xxdAu87UbzI3Xm3kgsyt2y61wQVxVHefn1uRGwzDTXDcud04P5r4/0BWu2V1+/m+F6W8C50oKr7ejPizGho7NI6Hq1FoXRHiB5esaEOWIXYzuR/bprjwvBU425TIOcNZQeagILmTkIx6couHZlQNxEwG2lVjtlnPTGAcIva06HtaWlJwThoyfC0KUUfiedhL+ZfC8muhxOpnpDikweOjMTlQaRrOJthiIrSi8mP1soXgZYt3RbmaRXRFRyqRrtE7Ut6Jj00mKk7LZMsiaoR9zi5fc/nOpE7Hze+H3PSWi2Mr1tmcgAQs5W96/6m9nMz3SvjVbM1JkCkAIfQeNIfMSkAyG3SIVBuiyYdanycMTAj/fqzHhiDg7nzGIjHswDCfap5tIaQTlBBGWeof/ojzFAVxvbmIjY0+SXYR6DgaFn0BPi59EapQP2JYm/dSnB6CnFjYkiJ9+5l5mogs6tvue3WucBIxAOs/PQzXJ+IdHkt0IAk2mfnWIXr3fTpQPYTA+qALjsWGRiyz0fZFnxQsBqgGVORcQJGjOAvWD39edg042GjsGmO0dAN7iOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199021)(54906003)(2906002)(6666004)(6486002)(38100700002)(2616005)(83380400001)(82960400001)(26005)(6506007)(186003)(53546011)(31696002)(86362001)(41300700001)(37006003)(478600001)(6862004)(66556008)(6636002)(66946007)(66476007)(316002)(4326008)(36756003)(6512007)(5660300002)(31686004)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXpNbFFNS01DSENoRi83U3REQXdNWUhhdG1GanZPUERWdHdIQVhtM2g1T1Rr?=
 =?utf-8?B?MW84aWZGUW03QlYwNEI5SVJpRXVmZGJjNlpuNUc3a1JqakdYL25GZmt3cGVq?=
 =?utf-8?B?bDN5M2xHMlpwUVRNMjVkQnJ0L2hFZzBKSHVaZldoTkhjdXZ4M3NHUUlMVmJ5?=
 =?utf-8?B?clZMS1BlYk5BZnQ5Mm5CV1RsRXBRc3JRZ3JaK3crRFcxK3BrQXVlQUFXSWJK?=
 =?utf-8?B?TzA0eitxZ21PVHVLNUhOVmJjMktpeUorVXphc3Q2cDJ1aVJkSkFuUkNxcUxo?=
 =?utf-8?B?UmUyMDI1UjF2MlJNdVNIUnFiZnIrNGVUU05PQmJ6WE50dmRjOVRrVFpLZVlF?=
 =?utf-8?B?MU9LZDRLNTZvQnVpWW9OdDRTTkM5Tmp1eFp1dVdZSFZXMzVrUjl4WmJSajFX?=
 =?utf-8?B?VTk2VjFTSXVTdDd0UVJGMmR1WVA2c3JJaFc5VzJmN3BJMHEzaWVmUWlJNFk1?=
 =?utf-8?B?Z3oyNDlyWHVOSHZRUXdoc1FaSVJ3ckxrd3NDR1NWNlNOZ3l2bUJWdnFRL1E4?=
 =?utf-8?B?WWJqYUNHWDN3YjA0anFOWWkzRS9WZmQ5TmVZN0RLS0VFTG12TEdQU01LYzVM?=
 =?utf-8?B?R2ovbDluaUJOb2xZNlJYeDBxemVtRFN0cXVXclgzNlRObEFlN2dHMEJmK21k?=
 =?utf-8?B?c09qTEpmS29sSzBKbmtYWmFDRlFlUjd0SXBuQy9ZNG53ZmNINTliZis3VWdE?=
 =?utf-8?B?SDk2cVdFZWN0cnA4THZONk9qUy9xejhGRzFUUjYzRHA2eUhsYWFMY2hJOTlH?=
 =?utf-8?B?VDIvMFVvT1Zrak1ZSlBFR09DdnNDV25MNmIvVWRqcFk0MlJndEs2TmVYVzRx?=
 =?utf-8?B?czNJK2IwenNQeFVVTVhORVk2bmhzMEkycWJmbmNTazF0VHJ6ZnliRWlPZk5t?=
 =?utf-8?B?MVVPdWFhblgzd1V5Q1UwdjVGZGFVUlR4NWVMUTJtazBlN0hSVnViOThKdlFl?=
 =?utf-8?B?MkphemNUanptUEF5a2ZJSGIxRy8rNmpxdCtDOXBhYXRSeEFDeTVjc0tzdXF2?=
 =?utf-8?B?azVGK0t2QWVOQ0x1V1g5ZFU4cy85NlYyVVp0dmhoc0FHcjIvVUxEY1BzRXB6?=
 =?utf-8?B?L0NpYlhWZ2JKZjAzZWdqc2VhWmtRSW9jdTdob3ROb05TV2l4UU5JQUMvbFEy?=
 =?utf-8?B?TGp0R0xHNzkwYVVpNGJYdjN5MW82Tk8rd1MwM3owajh4a3Ywek9QQXlvWllu?=
 =?utf-8?B?TStEdGNVUDlqNENSUFB1OFROYXg2bjFYRVJlL2lHZVY0U2lQQTlkWUVlcGFz?=
 =?utf-8?B?MDgyZDJjZkVyd1NOajdNd1VPWTQvYXVPMG1HRTRuNlRSbmo3cWpMUC90clpx?=
 =?utf-8?B?QkEzR203TU9XQ3I1eXJlc1FoOHFCcFU3SnY3UVkvbnhmRHIvOUg4T3ErMzZX?=
 =?utf-8?B?dlY3bVpwVmNYUHNuQkVyWlM2bjk3R0d3RXo5dDFkWTRtQ010L2FWeFk3S3hj?=
 =?utf-8?B?WEkxeFM0eHFXcWJNaWZwT2VKWFhBbkNROURXaFRVRUVIbUVNOGxZc1pqeHRi?=
 =?utf-8?B?SEJpa1RPTkVYcXZkSTk5ZVlJSHJYZ3crVThyUTlBVkZsZVhhVGFRR1ZLTzd3?=
 =?utf-8?B?aVpZSWgxcnhvVXNOOG1pd0M2Ny9wWVZPZ1daTTczMS9mRHJtN1dvWHgzRFZS?=
 =?utf-8?B?dzRKMUNVNjJHY0xtWVN0cGliUXhNYWcraVE1blIxd1ZXOE9Ndy84MXd5WFhS?=
 =?utf-8?B?Qk5ZaE13VnVvQ1NtUjkzM3VOV3FJNW1jdVVBSmZXMVMvU21hL1FtdTIwZ1Uw?=
 =?utf-8?B?TE9wZnU4RHU5czg0RGIvN1J5OVZBNDhXOXdQMzBzSFdLM0hFTVJmWGl4b0Zs?=
 =?utf-8?B?cDdSUS94dGg1cExtV0l4TlVLbjlWcGErVXpUK0VBaUVKbzcyc1VHbGo2ZDlC?=
 =?utf-8?B?WVZMWUZhaFpCalFDRmJHZ1JpOWpValZxU21aTll4bnNpQWZuekVnNmdSWVMz?=
 =?utf-8?B?NVNTMStKQzZZdlFqd1lGTUl4TjcrdTBDYzFCT0k1UmpTa0lLM0FmT2V4YzhR?=
 =?utf-8?B?aWVnUmlwajhrZndMR0N1SS9oT3ZNUy9UandLYjJDVE40VE5qemNIKzZpOGM0?=
 =?utf-8?B?S3d5eDBNVVNiZXN0bnZ3c2k1TGdWSkpLQjRCQXJYSjJvOC9pQzI0cTdqbUND?=
 =?utf-8?B?ako4eGJ5OVNYc2w5YTZuZ29meXVTemMvR3BsRDFFSFRHaENmaW5HWSt0cDhu?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e82842f-349f-4573-79e8-08db76f11ef2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 09:30:18.4635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aK1LHmu+nI3ZgPLFHrQSs6XXp6m8c5cozFfOmZWkhN9u07IR+C0FOs9LgA2NTPSWMIu0UIHTKe3cPfaD8aZIAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7043
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


On 6/13/2023 9:19 PM, Xiaoyao Li wrote:
> CPUID leaf 7 was grouped together with SGX leaf 0x12 by commit
> b9edbadefb9e ("i386: Propagate SGX CPUID sub-leafs to KVM") by mistake.
>
> SGX leaf 0x12 has its specific logic to check if subleaf (starting from 2)
> is valid or not by checking the bit 0:3 of corresponding EAX is 1 or
> not.
>
> Leaf 7 follows the logic that EAX of subleaf 0 enumerates the maximum
> valid subleaf.
>
> Fixes: b9edbadefb9e ("i386: Propagate SGX CPUID sub-leafs to KVM")
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   target/i386/kvm/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index d7e235ce35a6..86aab9ca4ba2 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1993,7 +1993,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
>                   c = &cpuid_data.entries[cpuid_i++];
>               }
>               break;
> -        case 0x7:
>           case 0x12:
>               for (j = 0; ; j++) {
>                   c->function = i;
> @@ -2013,6 +2012,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>                   c = &cpuid_data.entries[cpuid_i++];
>               }
>               break;
> +        case 0x7:
>           case 0x14:
>           case 0x1d:
>           case 0x1e: {

Reviewed-by:Yang Weijiang <weijiang.yang@intel.com>

