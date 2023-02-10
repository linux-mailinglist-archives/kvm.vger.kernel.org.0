Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D39969172D
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 04:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjBJDid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 22:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBJDib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 22:38:31 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115265CBFF
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 19:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676000311; x=1707536311;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=THKhohS9GAOKEsAZo6FqqWpjy7IwYkfc/S2fx4kssX4=;
  b=eXhA2GU6HeSB8YIMBkiX1e+N4Nx5Jm+QiouFL2E2wx4Pp4rxgD0dCX0s
   KONgypkmPMQFK7sgjYNgC+/ZNIxXawwzFhP/5+xSQdimKsIsZMpH1C0DF
   2Re1++jWjFyTix0D6qSaPdce0HUPEISZ17u65M53BMsg6CVMwR02erv58
   BpV/IP7GWGNp/jAwRvwJW8VBEMd9Ngo18YOoTz3eq412DixUG5mC0XQF2
   CQvSDknwLHctPXDQR9KUSumc1Ro3naCMsJuKWHv75dRS1EBjKDpTsIQ0w
   KXqRusziCy1tuMDrczlzU3dlvMGtm5W70ndyzY+HmXetNc23WzAWtAMSB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="309956800"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="309956800"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 19:38:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="617760077"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="617760077"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 09 Feb 2023 19:38:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 19:38:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 19:38:22 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 19:38:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W98HHZ/3MTdzjoLEVeuh7Q8VouHTDx4yMf4jZ3eYASk99xkRSI99j97S2PkYFde/I7OnFVUdG+J5Z3YH4DMbwB8SGfhnGlg6+Z/T0dZrATxF/YKxUpXmw/DHosNNMBwYAOXmvR2VEN3amJveTOk+2FpgX+NqgbH6ZahAXxja4EFZWYJmEBr8RgzwjekCe7s78eEUHBgFF2Ni/lBTBmK4K6phTJSvwUcNKJfe8bdy3M5PiNiY5wCGOMRjeJphbC23NQ1Vm3HK01XqYSPfSd8EE9rBtRERSKcVu6H1l8Q4qsnDyW1o1dnsw+4rmAryXqnuhJTWhWS1nojTDEx+wIJebQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwi3u+FcEwDkbFdBAMC6s5ee+W2zBA7k/ksXUfFGpRE=;
 b=UF4pjhF4qc2TPCnoMkvIOiz6ecYNw4dalzTuwk0+kzu6AslGhmo/xBC1t3RC4q5K8lEd3YClXm44Wqc8KXFvDXNh5Dfc5UfnQpx1/ueRftZDcUmFDwkpvEUTcJneAetSCHlzwmPu+/Y6VLLqE/Air2cL8M583M3GFE7iwfYfUcGAcO+fm/qjoAh265yKJ2NmINgZ3LCcqrhapwi/uqwpxGRDAA+Mcbj1nKsRoIKsFd+g3SVqDxYrUf0E/RoPRJio/0rga7CH5f/1orik2a/YmySzpnhjjiEyX0vq8hQ4HyFiqt1d+3ykCH6PGMUZ+4WGLzLMpkYXXDWxFZCr5fx0Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB5189.namprd11.prod.outlook.com (2603:10b6:510:3d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 03:38:19 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 03:38:19 +0000
Message-ID: <817d2f5d-79f9-2e2e-ba7d-8e643c75e37b@intel.com>
Date:   Fri, 10 Feb 2023 11:38:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 2/9] KVM: x86: MMU: Clear CR3 LAM bits when allocate
 shadow root
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <kirill.shutemov@linux.intel.com>, <kvm@vger.kernel.org>,
        <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <chao.gao@intel.com>,
        <isaku.yamahata@intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-3-robert.hu@linux.intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230209024022.3371768-3-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0199.apcprd04.prod.outlook.com
 (2603:1096:4:187::13) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB5189:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d9969c-a81d-49aa-6f28-08db0b184089
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqHcra3kGUNpTfbsvtRt8IE7Ejh9fd3YOvd8bkG9iWZIJYq6iQYQduP2hYUUkS+xDs1DNzP4CGp7BnfeVXkwoszzJvovkJlJT+QURIlk8POeFsk4UxCkB+fETl3UgtqwFkWJaIpAG0Pyz64Mrqr7VRvEEE6hlOClCnijEBBVVusA1u+L9vYlpIvnXPbDkyX6IeayBas/PfVz+3B5WcaqVD15hhXpls6PANJMzHMqsQgTftktmhhqbanUOiY5TFb3gxQqBpSo3LuglMepHdBQqO78MYWj6s1JZP3Xr1+k222YELSAItcj0o4++PaBxkRUx+aZUZFsdgA6Tz0DE5rQjE0C9RMd3fbpDm0S8mmqDz3MfeF/yTf/0FBuEeNz7csQUTsD/JSNiAiHcLkqseiXIHsgr3zSjvwmSYOhN4PgeWJZ80sJw2gLcYdlq3mXoEnSTwpWG+iHIAY+llFar8wIdtPei1Pxc4F5naQN9aANeBh41ktmn3+En3IqIrJvKcaesFc/XRai3qb9OCSlt7jkKRjF9z3um6lIKiawIBMoQJ/+TF9+ImpH5HdXq80iBd/utAo2QDka1guBXI/uOm4cNDln4+mz/0KOk0ux5mgofOFoT3O+anIzt3ldYumTyNW74318amU9oLZhYtJe+XV/k0H36c8PFwaZ/venY3nCOg90+6x5e3PJh/KeBqP2UCainephf638AVRMOAfS7i/kqNupV0sZYrwPNZiWUDM9S2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199018)(31686004)(8936002)(41300700001)(66476007)(186003)(38100700002)(316002)(66556008)(8676002)(66946007)(5660300002)(4326008)(36756003)(31696002)(86362001)(82960400001)(6916009)(53546011)(6666004)(6506007)(26005)(6512007)(4744005)(2906002)(2616005)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFQ0WnV1MXY1Q3BqWXViSGpiSzNRTzRhdXc2REQweUFlTWROYUdzV25UaFFN?=
 =?utf-8?B?LzBSL2k0TUVZZlRlZzR2cStRbzdvZ2FFOFJiOUxBOTRGdEpJak5rWHEwNEp0?=
 =?utf-8?B?RkkwNWorV0x3aWhOMzRGS1ZTVDc5TmdFWEVreG1YcTJzTHFpREF6WkRWWXUx?=
 =?utf-8?B?Zm1JakU0d3Q1VGllclJHa0Ewd1NaVHhKQmRhNzRUWlJVbThPRGxvYjg3cWUr?=
 =?utf-8?B?NkYzR1NIRUFIUFZoU3MyU1NWVzhaV3FxcDI2NmlueUpON1NTOTdaZzAvOXVP?=
 =?utf-8?B?b0ZMTnRLWTZUU1RORGhQUnBkNzJXY1J1UXg1MlVCQTZVVnFFWEZDbWYzbTdD?=
 =?utf-8?B?VDJDM0FiRGhZWWtLTnVZaTdnNDF2YWxXbkhzUCtSTFRQWGhWNytENllnRjYv?=
 =?utf-8?B?b1BJRGI4MW9ud1R3VEk2MjlYMDZyRWY4QVBGVGF4KzB6M0Y1cmxtczBXZ3dU?=
 =?utf-8?B?L1d2VnV5UW8xUTQ0cWM5VWhHdWJ4SEU5cmE4MXlkSTh3RzZKb1FobThGNktR?=
 =?utf-8?B?aVFIK3IxY1lCaC9PMVF3anBhUThrNDhzK3VlWHh1VDZ1Nm1BQ3MwdVZiVE5l?=
 =?utf-8?B?TVdKNWxZdG1lMTAyNkpUOTNldU4ya2pBRlovK0FKQTIxTVZMTVdmVTZ5RDQr?=
 =?utf-8?B?UXBXRzBGNmtVMGhRWW9ieG5pQXVxMEw0K2hjcHEvVGViS1d0RjNMa291dTI5?=
 =?utf-8?B?eVZzMGZYZHpUc1VNR1cwbHEySmdYbWJXSzhHZWhLNEJBbjlyV0FxSUJoeVVy?=
 =?utf-8?B?U2ZCUEM5SURrUWI0RHhKZGFIYUM4ODVMTmNpZ2U1azh0d054NmkvMFBoalZH?=
 =?utf-8?B?QVdWaE96NTZ0b29Kak9PVFZzN285N1kxZ3pINmt2S1NUS05tQVdicVQ2WmRY?=
 =?utf-8?B?bzMzSGNQUUtXOVZxYkkrZmRLMGkydnFHMk92ckloR29wcTJZS2dpZGpxN25S?=
 =?utf-8?B?ckhmRmZzaW5tZXlSNVY5bHBpVUVZWXhpNE9SZWt2UTFXUDZZdVRkdnpZT25T?=
 =?utf-8?B?bDJoaCtLYTdhanBhUzc5Z3ZaaTZqd2JYdmdqczBVRmRLenFvcGhaZFdOcFJC?=
 =?utf-8?B?ZyszVVRUREdYQ1VsK3RValhxVUhiT2VlRndUTWkxRjQwaXg2L3U4YzRrR3ly?=
 =?utf-8?B?dWZUM0t6Z01hejNacHRFVWY2ZW9qdzdtVjl0UmQrOTRnck1UQUVCK2ovd2lM?=
 =?utf-8?B?TTlUajFVUzA2SW1RN2tabjVQUW41MDVQQVorWlpuZ0tvUTFkNTdVMFBTR21w?=
 =?utf-8?B?d0FjSDJaYStKOW1sdHRYTkQzeUY1WEdZQTRxWkxWekNucEcrVkt1ZllURSs4?=
 =?utf-8?B?alFKTDh1TVYrVTFsVnhiV0drUHlYS09yU3VSczdFUXV3YkZPQ0YvNE44enBy?=
 =?utf-8?B?YkJDZUJ5MndvYW04VHhlZVltM2VvT3VpQ3g5MVl0S2lOc3JSMzhJeHdac0hN?=
 =?utf-8?B?Tm9BOGI1Qk9xVC9xY2FiTUVoMmhOY0hheG5CMWY1M3d3VnNKRkhQRkM5OXhh?=
 =?utf-8?B?cTdDcVZncTlmNHJ2VXZvSldQYkhwUjNKaGNDQjZnZklhSHBNcDhTZXV6OFVQ?=
 =?utf-8?B?STdPdERxRVNBbzV6NVRiZVhtV0YrNkM4UkU2czFIa1FxY0hLWU1jY1kxdEhx?=
 =?utf-8?B?cE42elBHYjQvVk8rNDFLcXFKc1JuZlpsTGV3K1JwZXdHTzFVRnArYVQ4Lzd1?=
 =?utf-8?B?TzB4SU4vcm5ZKy9YMkM1OHZQU3Y4SFFpUWE3cGJTMkZLa05US2FsWXZ5QzRY?=
 =?utf-8?B?NVZ6M1dQYTFQVFFGeVV3N3hjZE55K3VOT0IwcGN5WHNlNHJiWUlnTFFpVGdh?=
 =?utf-8?B?SWpPNDJCTHBZSHphcnhlN0VpU1dqVEk1Vk9DVjJINzVSWUhGVlNkSUZ2R2dI?=
 =?utf-8?B?U2YreWc0UEZrQ1RTTHBzZlhwSGdtU01Xc3FQcGJFNnJnMXZndGNtTmxxQ0hZ?=
 =?utf-8?B?bER0Z2NsSjBUMnFPVVg0ekw2K2VNcGFuRmRZSGZ0ZHpkOHdnQkxLS21uTnhW?=
 =?utf-8?B?UkxFWUJVQ3FYc21hbnUrY296ekZydkxReDFrcWdqM2x6RzhkRTgybTVyVkxS?=
 =?utf-8?B?dW1OUzMwbXBqOXA2eklQY0NiUFN3a1Nrb3ZTQllwTWpubjVEZUp2NnRKTGZs?=
 =?utf-8?B?eExwRW5Rd2Y0MDQrREVKUEN5VXVGWE8yaWlNeVRUUGdYTU1OQldxYVZrb1JB?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d9969c-a81d-49aa-6f28-08db0b184089
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 03:38:19.6207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFX/34Cp1D95+DPWEnMromBrOP5zZ3U2TCAZUEee9eMj+EBndBE/ecrrcIGDpVoYT5NZWKMDq6xNxEjSZfwjMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5189
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/9/2023 10:40 AM, Robert Hoo wrote:

[...]


> -
> +#ifdef CONFIG_X86_64
> +	root_pgd = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> +#else
>   	root_pgd = mmu->get_guest_pgd(vcpu);
> +#endif

I prefer using:

root_pgd = mmu->get_guest_pgd(vcpu);

if (IS_ENABLED(CONFIG_X86_64))

     root_pgd &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);

I looks more structured.


>   	root_gfn = root_pgd >> PAGE_SHIFT;
>   
>   	if (mmu_check_root(vcpu, root_gfn))
