Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9487445F3
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 03:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjGAB6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 21:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjGAB6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 21:58:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E653C01;
        Fri, 30 Jun 2023 18:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688176689; x=1719712689;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n+ezUcFXgy88lh64ZWBPaMaMha2T5iHmw5VsGfQURBs=;
  b=OXqusafdwbBByMdE0iTrYyuKyGgoQBx913y93gHmU8NUjRiMlbf2eIal
   y0XlqmvIwPYhpS06/otBVsjzYOwprEoWUOcHcdV+yi/4gVgWAYEl60bN9
   YifCrsxahrsGPSCTdJxbanO2ZQKLntlsyizRniy8TWrmr361JtyUnGPM3
   Uardjy6b2fuqHljDF/LrGIhRgeo1S2LgUrxIo004Vuytlibf0IaplYb7H
   57yS+Ps0mlzVn6S26xksIqYNS1sG7r1P0jUryGB39S7MDbSyPQl5vFa8n
   iedoYh5HZQoIMGlptoVNaICOJ9qjnmEiamosY91DJFeJ9dda5PMcRxX9G
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="393263927"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="393263927"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 18:58:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="721155976"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="721155976"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jun 2023 18:58:09 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 18:58:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 18:58:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 18:58:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4jLFI4XeOudp5o9eP7B2nUF5P42xWoKfm1vcDxMtS3WNeq+REQzp8B7QF5iNaABZpvD+QhcekzisDme++BKI3pvkzZn/nuX9XSP+7UwPgsAP56L/1/2qPTYf1Z/CDU9OR8+VQ4Zoj53EC9deAwmZ1fymo56JHkd7hRExU7mep0cx6vbv4XkQBhhyg/zkBPtGpnbFeyNYC8By3xQSC1zgbMl2bbtVd+Ss1Rgw4vuxOqfyLE5GSSWEBRLhooB0yLarQixQyPyOQETwdvwfXfRvuuWGjRGoAWTcQvh1+25n8F2/trcbomm18FucSWMOG5Jh0YjueCgHPdORrqMRb53Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykkf/WAehJMtWi/dJFAf0WtquGGQpWuPq169U+uJtgo=;
 b=PBq/iF0tsquuixLjwNXu/G8gdgl9JaBzYclZ7eLXyiHw/zF2aJUY7J86Tja6hL5vR0LCQZoALNj9MlGxwq3l4A025KwSCip/z8YDMZtKoJVU45rUgcHc15bsKVOeSmMimWw0Ju1G90OcrIhP9IBqFN2XVZ1RSMysQfs3jtEbnzRYiFH1KOt/1FmTweeiZpMRo9oEF0endkAE7TPYuX4/82QoqWV6vedL/30SzvGDPcBBNaoWoonND2mMzPly+p+dxKyIobFGDJ9fupyEL3sqdri6uiAxPAQ5DIBrSJI2qT/HGRlkLyCEHgYuNStODDLt7tBUTFqrlJXG8jK/DQJTtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL1PR11MB5955.namprd11.prod.outlook.com (2603:10b6:208:386::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Sat, 1 Jul
 2023 01:58:04 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6544.024; Sat, 1 Jul 2023
 01:58:04 +0000
Message-ID: <3a001aac-fe54-cd6e-d7bb-82bd8791ca20@intel.com>
Date:   Sat, 1 Jul 2023 09:57:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <pbonzini@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <rppt@kernel.org>,
        <binbin.wu@linux.intel.com>, <rick.p.edgecombe@intel.com>,
        <john.allen@amd.com>, <gil.neiger@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
 <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
 <ZJ7vyBw1nbTBOfuf@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJ7vyBw1nbTBOfuf@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::35)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL1PR11MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ed4ca01-871f-43bb-ce4c-08db79d69b68
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CK//X0ZdI8hsxiIhXXacjYFKSJ1+iLH71CV69DHeN/xtdvb1cWi2/7dBSfIo6xqIXEckluCX7KlaDNIUvb2wwY56qJ60AiJ7YEwxlHq1GYsVAGmaquw6k6f2nwLucBUYv9MwjtXjv3OfCn6lXqDXcHhosA/Cs7/VFzI/VXO4icCTHQ/gDRwZUTNfoQdjAoZEbHs5mZv3eXLOD2yAiouKvBgOGrJWLS8xN20sup4tsct3LvuyvQQeC0VMAZeZRJB18ZcpQW3kygD6uJiW/s5enzN/DngiZ5ULJx6pXfCG6qWwrnlPGOdlKLgWht+bFsnDz4pheT24khgaI5Tkcb+F7G9E31S2abqfdrG+Y3KEEJS0WmdiU+UHqmHHzosJdQWrRajHBJaFtnGNmm6WhdHG6MsN8HDl22JsTCXxuBBlfIJL7vwFw3dXluqvp7AhDzz9MPMuk3R1oo1qtB8Jmg7o5jS8qAZlY226e64vWFTw4J0Uj0ujOYVKcJpBPeXPC1yeacPPW6AA3VOU7NSjzRDNoBY6Hjme74V18sxqho51Xnlp7yglKquOAQdae7TSaXsfpy9Sd0PDILd/xM81TRqQPJJDuxWJGk9JtvJyEnzEVAFzUeg4fTI5P8vaOatzwCzsC6vGKgRePpFjHNl1SD4OPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199021)(53546011)(6916009)(6666004)(6486002)(83380400001)(6506007)(2906002)(6512007)(2616005)(26005)(186003)(478600001)(5660300002)(36756003)(316002)(4326008)(31696002)(82960400001)(66946007)(38100700002)(8936002)(41300700001)(66556008)(86362001)(66476007)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2J3djMvZTd5Qld6ckVxOCtrTGZNQ010alZHcTBvb3cyK3BTZ0l1VEJIOXdX?=
 =?utf-8?B?enhFYlhBdEhEZkJ2REVickoraDNubVBISlFrU1JrT1FlMm9WS1FVZEo5WFNQ?=
 =?utf-8?B?QVdYcUhKU05pN1FMb1FUcDRhSnEwMWpXbGphdi80ZVFVMGphdTQvUFNhNG5q?=
 =?utf-8?B?U0Y5R01kKyt5dkZuMWJSL0ZBTGpDdEQ0TDhqS2l3RUlmdEdHM2NxN295cE9l?=
 =?utf-8?B?b3M5aDZCTHFDcGlSVnduYU1WSjJTYldFaG1ZQUJUZUFwN2xWOGR4bW1XYUpI?=
 =?utf-8?B?czdNTkRKbnBDYXNwTlJVeGhSaDFvNjhoODA3T09rdmRqbk5zVHlwejVpRzFI?=
 =?utf-8?B?cC84Yk9pb29tNHoxdEF6R09vR2FIMDgyYVRWZnVDTi8xNXBXK0o0dWxibzJq?=
 =?utf-8?B?ZUpBbU9IQnYwdUlUYWlxZ3JMSkZGMThhTnVML21iTngyWCttWkVEcUZWQmR6?=
 =?utf-8?B?bDY1Um1GL2VzRlo0MFVhbFRPYVcyVEp3SEFZUFRDQldhNEQ0ZFZhRURKazNO?=
 =?utf-8?B?Zk9Ma2JqUzhuZWtBNG1rQTYrOEloWlNMVjBGUFJWcy9jcFhwT2xHZnVWRTMx?=
 =?utf-8?B?b1MvY0F3azJ5MkRxTEU4S1ZJU0p3ZzA1aWxVa1o0NmZpUmh4b2s4R1ovZ25a?=
 =?utf-8?B?bEdGalh2NkVBeFc3MnBZSmlkVEZVZmU5Nks0aFBHcUxoRkM5Z1dBSzBSWVYz?=
 =?utf-8?B?bFhSL2FQOFJVWE1IMTBKTVRVTE0zZW44QkpwL1VvcmV0T1NmWThFeWpNUEFH?=
 =?utf-8?B?bnhQSFpNYVFlNStpZkxWSjc2c2lsWmlMdE84Q0RISWE1Z3ppQkxhYWt1YURS?=
 =?utf-8?B?U3QyNXIrQnJCanM0RktDSHVIYUZZemVGUSsxOUtVSW92d1VvSmZRNVJSWmtC?=
 =?utf-8?B?K3ZIdmpLaFY4VVBxRThBa0U5Si8xbW1Wb2dPdkRyTkMyNFdnRWlnN2hDV044?=
 =?utf-8?B?ZUczTEpWcGxlSWswcXVhMnBjaEZpUDhhTk5wMkcxK2pkSjJ1b3Myems3K01U?=
 =?utf-8?B?VDRUYzJRanhtQVlqaHlvQ3hMaHlEWmt3Yk14WHRqYnM4Y1I5eHpiMW40aUpi?=
 =?utf-8?B?TVFEL1h2NmlZQkExa1RIT3FTaHdVOHJGMytHMHpPVU1HYUpCemZJVDF0LzBv?=
 =?utf-8?B?QTAwZU5PUm1Rck9HdVlrNHZEWjk1T0hiaittMTcxYzNDMWdBRkh5U3pTZXhu?=
 =?utf-8?B?dC80eFNacU1vYnJXckRnSE8xQVM3cTlSWEtlV3BZNkJETmZLOG9zMGVnK1Bu?=
 =?utf-8?B?UW9ucU9wNzNoS2VFZy85SnlRMVZBZXBVVHhUV2F5R2ZzNXBDS0gzaEt1VXNH?=
 =?utf-8?B?bHNCeWdnd01NR2gyUEhESW8vTlVFblhvYkp5Snd3ZjU1NmVwNDAxTitPRXBs?=
 =?utf-8?B?akpmTEgzRDB2c0RDV2w4cDJPWFcyeHNaZVkrNXYrZFJrcWFUTDRsdWtXRm92?=
 =?utf-8?B?TmkwQU05SDE5amJxK0d0MG5JdW5zbk1qUXFoL2FMZ2JaUHBsUGx4TFZwVnNi?=
 =?utf-8?B?UTYySEFPeFl1Y0NmZVB3K0cvVW5Wa0RHQ3lXbTlPR21TQ3FXdXhPN0RwSCtV?=
 =?utf-8?B?S1JyUzJIMmdLOWtIOXkzdFkzVW9pajcxaFRiVmFEY004RFo5cWRCZ054VnY2?=
 =?utf-8?B?ck02bmJHWGhad2lkTThVS2FiaXBpVjdoOGg5SWtPZ3hNbC9uN2NOVFpXRW1I?=
 =?utf-8?B?a2pJZFFYM0EwdStYcGxnSVBZTHlDa1dpZlZXOWJwMFlHYlZBVUVETzZSUXNC?=
 =?utf-8?B?WHg1N1hTRDRBY0xybkpoNHgreVo5MWplZU5zRFcydnI1NWhoWXhsSkpTRUF1?=
 =?utf-8?B?YlNEcVdSaDBkc0wwSjQvOEdNT2F3WEVYam1UUzJxemJJd0kxQzJGaEQyaUYy?=
 =?utf-8?B?L1A0K2pueS85RlVMckx6T3dXb3dVUll4R2h0c1NQMTBoRUF4WmhjcjZFMHhq?=
 =?utf-8?B?cmhRVVZLVEV2Qi9HVm9BTEdxMTFMblBMa1V4Yi9wNEZVVHhJSllZRmtmL1Ra?=
 =?utf-8?B?MkQvRitLNlNuL3g0ZEpHTjlsRW5oVk1tTkExNlN3M09ZL0hqR0Y0SzVtOEZP?=
 =?utf-8?B?Y3JnWVVERThLTEk1Ykd5dkUvWEl5REtmQitIRVdqTEEvc2pROHlNODZhQlRO?=
 =?utf-8?B?RFJhNkxoMHhxeUdObzlLaGRPSloxd1cvV2lxamR5WCtDRk1hWHhJWkNsWFl0?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed4ca01-871f-43bb-ce4c-08db79d69b68
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2023 01:58:04.4980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWumbCByGMm7VTOqgZTCtKvMkFQWioX6+E75nQc7tSlYrCQgyWYy0cNuA2ZbvMLmBTdSkZlbqaw2/SLhVFR70g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/30/2023 11:07 PM, Sean Christopherson wrote:
> On Fri, Jun 30, 2023, Weijiang Yang wrote:
>> On 6/17/2023 2:57 AM, Sean Christopherson wrote:
>>>> Do you mean documentation for #CP as an generic exception or the behavior in
>>>> KVM as this patch shows?
>>> As I pointed out two *years* ago, this entry in the SDM
>>>
>>>     — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>>>       holds: (1) the interruption type is hardware exception; (2) bit 0
>>>       (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>>>       (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>>>       indicates one of the following exceptions: #DF (vector 8), #TS (10),
>>>       #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).
>>>
>>> needs to read something like
>>>
>>>     — The field's deliver-error-code bit (bit 11) is 1 if each of the following
>>>       holds: (1) the interruption type is hardware exception; (2) bit 0
>>>       (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>>>       (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
>>>       indicates one of the following exceptions: #DF (vector 8), #TS (10),
>>>       #NP (11), #SS (12), #GP (13), #PF (14), #AC (17), or #CP (21)[1]
>>>
>>>       [1] #CP has an error code if and only if IA32_VMX_CR4_FIXED1 enumerates
>>>           support for the 1-setting of CR4.CET.
>> Hi, Sean,
>>
>> I sent above change request to Gil(added in cc), but he shared different
>> opinion on this issue:
> Heh, "opinion".
>
>>   It may make things clearer if we document the statement above (all
>> CET-capable parts enumerate IA32_VMX_BASIC[56] as 1).
>>
>> I will see if we can update future revisions of the SDM to clarify this."
> That would be helpful.  Though to be perfectly honest, I simply overlooked the
> existence of IA32_VMX_BASIC[56].
>
> Thanks!
>
>> Then if this is the case,  kvm needs to check IA32_VMX_BASIC[56] before
>> inject exception to nested VM.
>>
>> And this patch could be removed, instead need another patch like below:
>>
>> diff --git a/arch/x86/include/asm/msr-index.h
>> b/arch/x86/include/asm/msr-index.h
>> index ad35355ee43e..6b33aacc8587 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -1076,6 +1076,7 @@
>>   #define VMX_BASIC_MEM_TYPE_MASK    0x003c000000000000LLU
>>   #define VMX_BASIC_MEM_TYPE_WB    6LLU
>>   #define VMX_BASIC_INOUT        0x0040000000000000LLU
>> +#define VMX_BASIC_CHECK_ERRCODE    0x0140000000000000LLU
> "Check Error Code" isn't a great description.  The flag enumerates that there the
> CPU does *not* perform consistency checks on the error code when injecting hardware
> exceptions.
>
> So something like this?
>
>    VMX_BASIC_NO_HW_ERROR_CODE_CC
>
> or maybe
>
>    VMX_BASIC_PM_NO_HW_ERROR_CODE_CC
>
> if we want to capture that only protected mode is exempt (I personally prefer
> just VMX_BASIC_NO_HW_ERROR_CODE_CC as "PM" is a bit ambiguous).

I like VMX_BASIC_NO_HW_ERROR_CODE_CC too :-), thanks!

>
>> @@ -2873,7 +2873,8 @@ static int nested_check_vm_entry_controls(struct
>> kvm_vcpu *vcpu,
>>           should_have_error_code =
>>               intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
>>               x86_exception_has_error_code(vector);
>> -        if (CC(has_error_code != should_have_error_code))
>> +        if (!cpu_has_vmx_basic_check_errcode() &&
>> +            CC(has_error_code != should_have_error_code))
> This is wrong on mutiple fronts:
>
>    1. The new feature flag only excempts hardware exceptions delivered to guests
>       with CR0.PE=1.  The above will skip the consistency check for all event injection.
>
>    2. KVM needs to check the CPU model that is exposed to L1, not the capabilities
>       of the host CPU.
>
> Highlighting the key phrases in the SDM:
>
>    The field's deliver-error-code bit (bit 11) is 1 if each of the following holds: (1) the interruption type is
>                                                        ^^^^^^^
>    hardware exception; (2) bit 0 (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
>    (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector indicates one of the following
>    exceptions: #DF (vector 8), #TS (10), #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).
>    
>    The field's deliver-error-code bit is 0 if any of the following holds: (1) the interruption type is not hardware
>                                               ^^^^^^
>    exception; (2) bit 0 is clear in the CR0 field in the guest-state area; or (3) IA32_VMX_BASIC[56] is read as
>    0 and the vector is in one of the following ranges: 0–7, 9, 15, 16, or 18–31.
>
> I think what we want is:
>
> 		/* VM-entry interruption-info field: deliver error code */
> 		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
> 		    !nested_cpu_has_no_hw_error_code_cc(vcpu)) {
> 			should_have_error_code =
> 				intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> 				x86_exception_has_error_code(vector);
> 			if (CC(has_error_code != should_have_error_code))
> 				return -EINVAL;
> 		}

It looks good to me, will take it, thanks a lot!

