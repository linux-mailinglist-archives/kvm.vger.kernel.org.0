Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8568470B945
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 11:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjEVJnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 05:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjEVJnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 05:43:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855BDB9;
        Mon, 22 May 2023 02:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684748625; x=1716284625;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iOPDZje79uODob2D2aIth/JInj0kQQFqZ5KEdMWdW9U=;
  b=N5+UTHBB4cjeDmNvWtajQlTO4eYPC0U9FIEPGs9sJQZ3z1x9lb9iaMPP
   Zy/kTcyg1MCnGlK1HVFaOUGwCoi0CsNk/IS3Vu3IX0c0Ak6jfnVduCwqp
   dXa/3T5NG7bZ87c8TPWTbNjWbZweZQ/flH6NO7i7mpO8iBedAV53TQrkc
   egj7C2LmjVw2yxZiLE5I67eBaCNbuxMmG90453mEUy6Ezr9iIqykyoibY
   z1NP4dp/Q/usVvwiNu366+F7eIyrMSadIgwN6T/Se35Uz+9wZ+dRuT9zc
   qXOeAFYv0yupycZRga7vZYABHuMwKwM0ktEKzimiOINhSGGhPyYWCun5m
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="342327431"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="342327431"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 02:43:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="815615388"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="815615388"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2023 02:43:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 02:43:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 02:43:44 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 02:43:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHeaowS4v9OlHhwXYv9WP8rjAVTuxpU5epPasZwho4PriWgSw2SK6Ir3SfXkW20WW7MJCY76b6nhc0OciGNIIFLwjdqkXts7heMdxSIdHBTJBoe1wXi9WWROu1l1RB4fVu3at8pWawir9NYuIPgOR7QOiUe3dTHPxUlqaV+HEVpf+tPVCQ4Gd4svOGvteR3qr5XLnQVQLZrQF5i2rQmOFWi1MEAIngkZTP2j7s+FBGbxec2h+N6Zg+kUoLbrOBBotu67VhAHLbJ+mtUZmXp5H/50FfRS9Egm249Q4V+K35RoKJlGKmq0Hb7FgHDGKixBPoOdCDxRJZKWSJvpz/AMwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOPDZje79uODob2D2aIth/JInj0kQQFqZ5KEdMWdW9U=;
 b=E3oaqYVi/fT49htZmODyonUjJZzUjTMS4ONo6jAQ1DfkzXLIjB6qRuez1u/ARYNBg4u7czkLmOSW+TP+spiSrXGJrQ19gcymtGV116NXlEk9lk8Bbr/e3jWfgw5kquPjtDvnoOPOEPWntUPj9dRPYriqMQSow5r226ZMqgtnNtrmQU1hZKSp03oxTq7dAr7ydQ0Hz1LzsmY9gjVX/LL32ioJKIQcbMzNtQkxMKxB+taV3uZ+T3Pw1vl/XKRVNkoNAgbSiwGRDBExzzS6dghAxGbsmEVNbDjJAGcxFTetx4W0fi1usuFokjhTnh0ZElinWPhRYXIblXA/ELRoucYVeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5469.namprd11.prod.outlook.com (2603:10b6:5:399::13)
 by MN2PR11MB4520.namprd11.prod.outlook.com (2603:10b6:208:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 09:43:32 +0000
Received: from DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::e825:c2b5:8df5:e17b]) by DM4PR11MB5469.namprd11.prod.outlook.com
 ([fe80::e825:c2b5:8df5:e17b%4]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 09:43:32 +0000
Message-ID: <00679dfd-5131-d951-f554-94c66c7c357e@intel.com>
Date:   Mon, 22 May 2023 17:43:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH v2 08/11] KVM: VMX: Advertise
 MITI_ENUM_RETPOLINE_S_SUPPORT
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>
CC:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-9-chao.gao@intel.com>
From:   "Liu, Jingqi" <jingqi.liu@intel.com>
In-Reply-To: <20230414062545.270178-9-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0122.apcprd03.prod.outlook.com
 (2603:1096:4:91::26) To DM4PR11MB5469.namprd11.prod.outlook.com
 (2603:10b6:5:399::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5469:EE_|MN2PR11MB4520:EE_
X-MS-Office365-Filtering-Correlation-Id: 3567ce17-2456-4a0a-6d6c-08db5aa90151
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oUqsVPuNfzRyxlBgosUBzODaxhsA3rABRcJdys8zEbadSLyh1bwKXznpJTsk8243a77vwBrCTv/9921+hBSt1FC+71zeetcq3YMi35qiaMCkloazNhqzXuvxER//doHjm9pTQ3R73nOcnUBZnA8cGJ9uNBDUridlQdEdANLDeDCs3TjLb3ssHNZiREJMzEVTqpl247m48K7f7CSPaHlSMy2g9wFUyra5fbC4VjA9iTTqRf4G+mHbG/azHQWQZy2uZNzPN0poDIRwZfnDysDr+Uqz016WqguTsdnLEiX7WLkSTeY+T9ouOuLFJ1wO7qJYTBFzKsiLtj/DvVCffufSRHy3JVOs3OuVSXfjz8TMK1emK7ajv9Kh3ipKgO8sPf9Ig5dVrP1/ydmtlIZ/Jf7DO+P4uS48fzDsBLRAV/lXU5/EA1V4L+upXlibDFkN3r3dfJm6QYZsGyEjL8MOzAIQ99V+RqdjJkA0EixHM94PaQMriaR1JvSYUXZxRsqgCTblSv9xOFWIq7CuKDqub4PjW7GUCkAORkF6s1LXm3gL39ctXo1O7IyzGicASUlfhIEj61ktiFPB4u0R2L+YRJhezhf8kpVFN7/0cq/UC8NlSE3E+XfjKa9VFGi3o3H8hqbsAa1+quplbRLvqlggV8A2rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5469.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199021)(6512007)(6506007)(26005)(53546011)(6666004)(31686004)(6486002)(54906003)(41300700001)(66946007)(66556008)(66476007)(4326008)(478600001)(316002)(8936002)(8676002)(5660300002)(7416002)(31696002)(86362001)(4744005)(82960400001)(38100700002)(2906002)(36756003)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkRGeU9jWkZqaU80UlpqZTMrNUNqRzBMNDhObVFwMkpsVFFGRW9PNGZOdmw2?=
 =?utf-8?B?N29VQWdpc1JDdGRtYWg2U1pmVnRzNkFtWE5vRmxKSnppVmJPa3BrYXNmc3Zt?=
 =?utf-8?B?dGw1RmdZMkRFL2Vhd1gwQldrTlBDZmkwTlFkMHhDR1dnWWQ4QndVQVhZY2RH?=
 =?utf-8?B?MEFlYUwzbW5kWHN1Q3lib0Z5UUdzMkNwV1R4Vkdwd2hOMGplVlJRaEp4REgy?=
 =?utf-8?B?QWwrdmxJdlJSdE9uYkhldDRwSk5oTFB6amticnRjNUJYcFhhSjJ4R1Y4VFVG?=
 =?utf-8?B?YVJNN0NPZkJiNG5IbVZpUWRxSnRPTnQ5bmNydjNGOWxBaXJzQ05mV3ZDVndi?=
 =?utf-8?B?Sm5CZUx3L2hlOFF4NW1QOFhWcEd3ZlpWQVNYVThNWStZS3NIOFZRaVhCWHdI?=
 =?utf-8?B?QWp0UEtoU0pGNi9NZmsxY2pyRnVQM1d0NC9acDdWTUhNZmlsUjF1QmJack1O?=
 =?utf-8?B?WVI5c1RoYUI5Szlkamw3aXVKVkR0QlJUdGh2M0dXaHB0QzFoVEhqcU42L1Ja?=
 =?utf-8?B?SDRGRFg4d2gxYXRGdk5wTkQzaVREWWk3OWNrYXJiTEl3dmZnemFnZTV1YzRG?=
 =?utf-8?B?QTIvbkhZNmh0YjRtWjdmeHc3eUhzVzNyb1pBZU1IdVphK1oveUdrclZ4NGNm?=
 =?utf-8?B?VytQeVdNbno3WXhIZnArNmFCOFc2T1hOemE5N0hxNmtVMjZBSTlBcCtNUnZG?=
 =?utf-8?B?RjhJd3packovOUFVMGNHbFFpTUxxNHd5RTBCb2Q1WHl4T2VmVWtvOThvc3M3?=
 =?utf-8?B?TkFTZTA5NHJCS1kxbkZsMGF2Q0xoYlp2bnI2UFdQVTlvWUVhRU9Pa3NlUSt4?=
 =?utf-8?B?czFRRDJIQURETmlMYWU1NEx3QUI2bmk0NW1XcEFET3FPU0JpeGw0UFdIN1R4?=
 =?utf-8?B?YkNFU3VQNEZ4N09kbFBORDBvWndkanRnbmFuVEtZaTVEQ0hoYk95Zm9SbmU1?=
 =?utf-8?B?SEs1U09hV2ZQWVV2RlgyY1BQMjJ0NitKV0xQRnpEU3h6eXR4bVVtemczS3lP?=
 =?utf-8?B?VkFoUFp3bEtqNDNWWkRJT3FQUmk5WTVLN2dBcFJrakNFUlpZQXlLUVJOOGdZ?=
 =?utf-8?B?aE45SWp6YzROZ0xIYW1ha0t2MytFL0p4TnQ5TCtFRVd4eDUyUTdEalIvOUM5?=
 =?utf-8?B?dUUyd1Q2L1g1RCtic0RkcktzbXo2eHY5a2J4cE0rZXVLQWFyZnlJSlJpUXZl?=
 =?utf-8?B?QzBadjA4VEVJL3gwTGRVYzN3OWRzNEZEeE1BMVdsOXhEZDd4SGRqOCtGMHJq?=
 =?utf-8?B?aWVvL1lIZ04vVFRWN1JqbnBWczM0K29TeGNzOGN5MUNlQ2NjK3dFRE9kcVR2?=
 =?utf-8?B?dWxIMlpGZGQ2aWFuNDhWRmVEVjJrMVNCL2FaWDdMakZvam1WaWFHQThueFM4?=
 =?utf-8?B?TTEwQ1FCN1Vac3lwcHhmM2VPeDRUaVRmMWZIOW1sUUZBcjZ0NG5zU1RlQjdO?=
 =?utf-8?B?dkJOUmlGRmpFSWIzbE1pYjZUY1BhWmNTRmkzMmpBUDdCRlNJeTFIcHFJV0dW?=
 =?utf-8?B?U1QvQmQzNUhYZTd1Q2t2NnRZZjhFVE5UVkxUOS9ISnVJMDJtL0RIZlVIekFS?=
 =?utf-8?B?V0NEcFQzbkdGL3kvSVBuK3R3Z1FCL0RVQk1yUEphM1lCd1JrVUVKQUU0Y3ZG?=
 =?utf-8?B?c0hjM2dCWG80YWluY1Vzb3BXSVArWTBBelN3R0xPK0g0MlBpWDc3VTdGd2dC?=
 =?utf-8?B?Sm9wUi80dlVVaVB6bmhsSk9zRExxTkpNMjNjQ3lDYmd4LzhqM2pBUjRJNzZq?=
 =?utf-8?B?dDJwRUU0aGU4cUlyTSt4Mmt0T2VFc3VwbFFhN29vcXBiSmQ2Zzc5LzJGU3J3?=
 =?utf-8?B?elEzYjllZGRGSlhXZ0tuZjhXeGNhMTR1UjFoNko0MUZDd3o1a0Jiczd1MGlW?=
 =?utf-8?B?Qkt3YmFZeElyOW5Jb2k5WUFCQWpwQ25sZnplOERaVVRUK1htaWlXa3llSnFl?=
 =?utf-8?B?Q2EyZXlpVVdhbkF1aVhkREwzamdtTnBJZ3BPN09ydisyL3hzbHhXYldwaWZn?=
 =?utf-8?B?eUdoYXN0TlM0MzVjN2FJNnRPMzhrVlN3WlY1Z3JuUFlId2hWUnkrcGoxdEhY?=
 =?utf-8?B?aVczcENzSGZsNGx1UzVDTmdZN20vYmJIT3RXRWVObWI0WFNpaS84dXdWVkxM?=
 =?utf-8?Q?xl5ApwM45ccPReHWJxiM9PQt+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3567ce17-2456-4a0a-6d6c-08db5aa90151
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5469.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 09:43:32.4741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXH9TVAkY2yqdkf2/W4/7BYnaHOVKRc8SkB8SpLEgG428UNj+RfH1EuZVB2BC17ETspQ3enZjRoJyeOq4quysw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4520
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/2023 2:25 PM, Chao Gao wrote:
> Allow guest to query if the underying VMM understands Retpoline and
> report the statue of Retpoline in suprevisor mode i.e. CPL < 3 via
s/statue/status
> MSR_VIRTUAL_MITIGATION_ENUM/CTRL.
>
> Disable RRSBA behavior by setting RRSBA_DIS_S for guest if guest is
> using retpoline and the processor has the behavior.
>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
Thanks,
Jingqi
