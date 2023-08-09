Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947EC77514B
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 05:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjHIDOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 23:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjHIDOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 23:14:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFF41995;
        Tue,  8 Aug 2023 20:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691550876; x=1723086876;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TElIfCAyGbJBDQMYWXyvFwe1iGCJqM++OirbmsUVBhU=;
  b=nVgIg0FAvHRYPMVBPWMn+jwotp3zdlmuq6d6apidki+YTYa0FjGVQaRK
   WQVA69PN316PjWfWTsz692YW4n0bT6LZ7Z7E7QA82zSqgokRNhmTWjDy9
   vnd96fCAImlWytXW2fAG30lxBSriKC76IM3+d2Wm0JBAQbUcYUuYwiwZT
   gtmByrVL3S0u3mxuJrnate7S8EdP5NOgtEi41vnzSSio3R5vBcon9u3tP
   lrtwADhiKW68fezbK3VKzYKmMbFa0qFSuyU0JqbbtV4g2TJI2Hj+hIDzJ
   npPIn+IExS2OfC5ULvJ+cPkDJbZIrLg/w1zWguOQiB+h90epS6vxphmWf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="374717470"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="374717470"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 20:14:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734825466"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="734825466"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 08 Aug 2023 20:14:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 20:14:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 20:14:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 20:14:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bD4gu6cyshsIEtNdRKFR93ZuzqnlTmzXSYEdcEJdADSdDAmThQhZXizKWy3DS4oB+x3A/aeTB2KgToWWMps1GWqEpjuip4fpk9tIhXu83QNWbNTkwpsKbW2uRjFtMj8p2Ud4BaUzLDNECIn9DkKIEQL1bAHXMIGrldC9Jtk5O745QJhuUkGBlJsY6WgmRBVjWJZ3XU/Z+ceJs0+NQ/C3t+rSLMdVuwMJaV8IpfoI5i0qJKwIv0zuyzVNHcMBHUfy6h4SagWzKqbmApjr90lZmQq4pSgaT1swdWw5z+XCG5cpOs/N6BkHwmrtii+S7zXRqpYr22lIJxp1hhuHXNJG5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TElIfCAyGbJBDQMYWXyvFwe1iGCJqM++OirbmsUVBhU=;
 b=XmWVOpPstFmSXBjeTXLS/PY4bxyUEuuheYI0lE3ekI+0035G0QxBrwTDZvrZzfdn6OjIdQ8gw1U1CXLfIPbPQBsbQLQgx1V0vczpHlScBqBG6ylmjpREdfDcHgQv6OmWeL2zgHbFXiE9Zs4twJp41y1KfQwxle3XRnb7d5JBwoHvtv8fvk/90Z2dqBWqXt2rSqWI4EeRsJURFVAuUFncS1IlCUyweAItrHFMDsi1lqHduqzJfBM0WnB/eiGBZ6DUoTA/Fit0/JNgRrbcN5PQ6y4mAKxaE46iXG/kf2Tpq2BYw1HVCGfUJ6jnNH3SnlWglHgLwKOMs/5KsthGifBY1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by LV8PR11MB8605.namprd11.prod.outlook.com (2603:10b6:408:1e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.28; Wed, 9 Aug
 2023 03:14:33 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 03:14:33 +0000
Message-ID: <6ba8ab92-7771-d077-32ba-40896e06b035@intel.com>
Date:   Wed, 9 Aug 2023 11:14:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as
 to-be-saved
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <rick.p.edgecombe@intel.com>, <chao.gao@intel.com>,
        <binbin.wu@linux.intel.com>, <seanjc@google.com>,
        <peterz@infradead.org>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com>
 <6d0b0da3-5df2-46f4-d6ba-75ae6a187483@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <6d0b0da3-5df2-46f4-d6ba-75ae6a187483@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:4:197::20) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|LV8PR11MB8605:EE_
X-MS-Office365-Filtering-Correlation-Id: 02ccc645-9ad3-4fad-794b-08db9886c0b2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r5ryQjKgWs0Py2+IH8Q+oNFt23yLlTST+fxbujja/qvFmyxApfruJEMN0I5FjSRCKjnzYvqcw3MfnMx8c4bGDSwPCTvAuEF8gnSbV4M6g7PgB5BascEnWaLiC7TgX7UXgAc2RIsdvhPspJm2/WJOAekoWQf9x6AJSC9a67Aua2fNuLQgIWm452RkzhIAT3W+bZSmOybiyry2Upup0ST6chTkob7ve7cpa5U2OchWwvrkmA0IfILklkLbsBzJdu9QDeSawMIiiqdfNhCf8gn/j5AC+IO5seYweJ7gh0ZRT5+OqAADDOzYScddpKAbPmhhiVG58LPMQ05FyHduo1GSFkcmy6WMk/f9i6DhvqoRP4BIFSw92aCz1fWZ0ht6efb7k+o4bjE/z1SIGzWOCMXMIB8fctmnfxFJIL3rv/V3rO1ridc6Yve66a9L9aUEjyPbnS+VJ99wxUEFss22kV7STqN7M5ydHHtWKJp8NgDrRk26piI7H4ae10Prn3TmUM/9GoNON7+9oXyl15NppCpsnTM53bYlRU/jo6FxV9B9YTea0Oc3I/GaY9CxEkpuDYse1iXt20p9npRdz9Thxmb9l7YeLf2bzxZih5BXMgspdN3xQIaJ/KwpB500s58AVV1/D/40CmFU8bzJfTWW0qfjgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(396003)(136003)(366004)(186006)(451199021)(1800799006)(82960400001)(26005)(6666004)(53546011)(6506007)(6512007)(6486002)(2616005)(478600001)(2906002)(4744005)(38100700002)(5660300002)(8676002)(8936002)(66946007)(41300700001)(36756003)(316002)(31696002)(6916009)(86362001)(66556008)(66476007)(4326008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dS9mbTcyRjZ4Q0oyUlhFWUU5VTVjdmVaOWlubmc5YWprUVh1RExOTzZiakVY?=
 =?utf-8?B?T2tZeGRXZ2U0SUNvS28zQlVtK2hCcndZbnFrdHE4UXRzL3RiNWxSOXo3T2x6?=
 =?utf-8?B?eEMyM3BaYnB1TTkyYWQ2eTF0aTRNSjVZbzRqeWtLSW0va2gwVHFmN1NZbmRy?=
 =?utf-8?B?VnN2WHZ3TnFvQU5rNGROV3lJL1dnR212Ti9yTEMyOXMwcHBDQUtFVlV0SXFt?=
 =?utf-8?B?T1ZtTDljZDVNdVNZNDVQTjdhajQ3ZHZQRVB3UDBnN0NLK2lRRHRhZlRIanFR?=
 =?utf-8?B?OHpNdjhGWW9CeVRPRTRZMGgzQTVqKy9pZnJtOE5UNXpjWnJZV1lBc01tYjRS?=
 =?utf-8?B?MzlEd3UxZm8zamIwVnZWcitQRzQyeklZNGZVUUpLU25BSUNuRlRwOEwzWDRl?=
 =?utf-8?B?eHhnSE5rYUg3M1ZlamF6emNTUmNGQkxEUFZValJkQUNrNFowMkJZVmgwcUF1?=
 =?utf-8?B?NFFpMkFWUThYWjlxKzNPNEZuUVZyODd4SnVZVTJUMXBzY0tEamJkdWFSMXBG?=
 =?utf-8?B?V0hYZVJUTUQwalFoZTJ2YlJIOVZHdS9hVGpLd1p3K2JIa2l5UXRKRG1nZ1p0?=
 =?utf-8?B?Qm4yNUVwZk9jSmVyaU1zTUd5TnozajI3WlhxODJVQUJPWVBOZEo1cDMxL09o?=
 =?utf-8?B?ZTdEc3EyNktYcC9kM2lxRkdRcDAwcTRnaWd2SGt3QUgzQVgwdTkya3RTYkp0?=
 =?utf-8?B?TFJwamVZeDM4UmdtYW1PS0FuUTBISm01Q0EvQnNaMUt0RjNjNlNrekExZEsy?=
 =?utf-8?B?aVFua3dDMzg4VlpMSjVoZXVESDJHZGcrbWlndFo3UTAxWjBVY2RMNHp5Tmto?=
 =?utf-8?B?b3MyMVRIWjB4Z1FwanErQk9pVU9zQVh3SlhCODQxMC9WaElkLyt0bUExQllV?=
 =?utf-8?B?UUU5TExvbDJaenV6TjhkQ1NnM1RTQldkeGpOMjRCeWZvQ2lsQ0RjSlJZVnNv?=
 =?utf-8?B?TE5ldTZYcVYwSm9MUlJRbUpEMjhTNjZoN0J1S0wzcmx1RlhTT1VNbkRzQSs1?=
 =?utf-8?B?SzRFOTQ5VVM1aVRsVmF4TVM0K3dvSGhnc3ZHMUhGcTJXMXgrZ0w4U0c5TkFv?=
 =?utf-8?B?YTliK2p3UVlac2JBUDd6d1Y4ajBiVGU3VmF2RFg3MnlQbHFyZUVmclNzZ0pr?=
 =?utf-8?B?OTNhQjlFY0htNWVLT0s2RHZHd2U0WTF2ZkdmbFk2RnhMOUtGUWdkMGlwRnlm?=
 =?utf-8?B?eXVvT05DQ2ZtalIwWmsxcldEN3pPOTdCamlPOGsvRXVxVzBsMWU4aFFlak1k?=
 =?utf-8?B?SEYwZGNIQlJyWDQyeFhEVlN3Q3RlQWRTT2QvcTVmdC9DOEFxalhRRDMwQlk2?=
 =?utf-8?B?UjJvY2ZJMzJ2NU9nMWs5ZXZGdW5GNWtFL0t0NkZSQTdWaTNraWkxaW1FYVpp?=
 =?utf-8?B?NFJITWRZaTlieXRiMkg0aEdldnp4T1E2aEhJN1NUNWY0N2ZCNDhWWnBxWWI1?=
 =?utf-8?B?SFk4NjJNVTVvdE9wMUZ2bGtVRURRWW5qUjd3aW1CVnFqWjN5NFdKL2l6RUNj?=
 =?utf-8?B?S3BrTkNwQ2NsMm1xKzlWS3FNUTZOVTdadnVacGJnRVhmK2ZBU1RyeTZZL3hI?=
 =?utf-8?B?eEZBWmhLdWR2Vm9jSGZzTGpONDlTS3FobElYQ2JsT1lRRkRwckdPa3kzbmNQ?=
 =?utf-8?B?UkZLNnFjRzlJOGVSNkJobEpIU2xzVjJhYjVOaHRjOG5kcjFQcEdVdGpJdDk5?=
 =?utf-8?B?Njk3Q09kSGhodGRoVFRoNm5UWGtWc09DVUFtczIvL0tqOTFYTDN0ZmQ1RUlH?=
 =?utf-8?B?SjNXcEVpK3NqYXkrZDZEU0JXOWpGK3dveGlYa1MvK3lUKy9TVExpbHU0VEwr?=
 =?utf-8?B?N1U3Y3JDYUQzdkFtTHBvT05pWDBnZ1FFMGpRT2oyR0NROFdoaGh5eVk1Vk10?=
 =?utf-8?B?ZVQ0cjFFdndCby9PdHh3MXBxc3J6dFdlcEE4MHVMSlp5ZDNlbnBzV29TY1dJ?=
 =?utf-8?B?Z0dYdG9IcWhrUGE4U1hpT04wVVVUUmJnZG1pWlVGZnRlcllXUkpSRVowVTR6?=
 =?utf-8?B?ZHlJMzlFRjFueWZ4TVQ2MzE1UlI3UlFRMExSQ0hhQlB4MWlGMmFna2Z5bzlJ?=
 =?utf-8?B?RFcyT0ltdmVaSkpKNi9qNnB6eGNaVm15ODYyRUxtSG5SQ2cvbkVpU0Q2WENK?=
 =?utf-8?B?VVlMZzZzYitCZmNscmpjOEFXOTBZZGJsemRqazdKVE1YS1A1WlhDMXM5d1M1?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02ccc645-9ad3-4fad-794b-08db9886c0b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 03:14:33.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i16bXYTIrmr9YQ2aQoBr+EVippcm1JVQw2oDIJqmJ5URVsobYoiIfaJGFVwiv22sXNXk7BJ0/FJEcxc3iS6ZSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8605
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 5:47 AM, Paolo Bonzini wrote:
> On 8/3/23 06:27, Yang Weijiang wrote:
>> Add all CET MSRs including the synthesized GUEST_SSP to report list.
>> PL{0,1,2}_SSP are independent to host XSAVE management with later
>> patches. MSR_IA32_U_CET and MSR_IA32_PL3_SSP are XSAVE-managed on
>> host side. MSR_IA32_S_CET/MSR_IA32_INT_SSP_TAB/MSR_KVM_GUEST_SSP
>> are not XSAVE-managed.
>
> MSR_KVM_GUEST_SSP -> MSR_KVM_SSP
>
> Also please add a comment,
>
> /*
>  * SSP can only be read via RDSSP; writing even requires
>  * destructive and potentially faulting operations such as
>  * SAVEPREVSSP/RSTORSSP or SETSSBSY/CLRSSBSY.  Let the host
>  * use a pseudo-MSR that is just a wrapper for the GUEST_SSP
>  * field of the VMCS.
>  */
>
OK,  will take it, thanks!
> Paolo
>

