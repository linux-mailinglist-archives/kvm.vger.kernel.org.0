Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446CE6F08DA
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 17:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244278AbjD0P50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 11:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244266AbjD0P5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 11:57:20 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E58E44;
        Thu, 27 Apr 2023 08:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682611039; x=1714147039;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VopEb5mqd61H2DT7ghEVfjZrc9wSnVIxqrUbBy51ruw=;
  b=PL8gKaw8dAB89DDchVn4c1qqonjnLeX9YMwCE6mWvBpSY4GvxTIzLC0f
   eO2LPvrUigokLRdDd85sbQF+cePf9CvTj+gdtOkLh8e+LlKoEbNsSs+Cm
   ovNbGZGST9csfPx2Pu3OlpVBb5tyeputJ3r3+D6Whn0dkaIaQPEshWaZB
   A7pL3Ld/7t2JDJ6hRs//PsHPNqk7jlcwkEDRueIpdDjSmGtkPRwk6MKtC
   /N12c8LrVQvmFNt++2421gTriTdWTlwOAXZLG0FzxIeSVDGGMW8PlbZtZ
   w0JoWbDQfVh7H6C8GNgA/AO7wNfKEx2ex1cfKZ3at13cEXEUUtt/hVUiA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="433772433"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="433772433"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 08:57:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697128836"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="697128836"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 27 Apr 2023 08:57:18 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 08:57:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 08:57:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 08:57:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqCS7Z6FrwGRdLqU2BA7GWbrraY4r4rrZaIK7giy9CW+wED7qx2eH2EV9Vn/WCqmgolb8WiVC6GT6F6QjSlVSZGBG8bGlXD7I878SRelKySSCClMmAU3xHLsJ4nZ90meHZMTYWnfSaUmr7FKmQVI3fWjGAmoignGpnlDHyhBRk1zDdHHvAsQTb2+HVJi1z0b7RisCcIE0rZSJxQiHqyR/tuSJmVGJB/UIitxQeLN3VHDTxLVEWGDOW8N594Y6vn3he7FsSv/VlRaFVzmAMMvuhbP0NElJQtFil/6IQE/S26jKuiDMfbYG0XBy4a0CBJciD8uIeQGARPsFcvBb3KVVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a32iYS+jqhNM23mqxwrn5bYvjyGhNk8drWFseps4n1c=;
 b=U3YDn4tvG/MeMDVQl4HRQAethtqIrtTNeXLIuqsV4FXQ+8OMLIicXL4Xd48zPtWGtCIAQy5zutHjH6vmd+Z6TxWr/W5qbQDR92+qHx3iwvZaHSt/m36y/yypOn1iBX9ts2sq2iTTujCiI4FLtcEdBtWwXgGJ0oQuowhAgKTtbzW0BIeseBHanKSRqBQysu3kcl8KEuv6hC9m+2+LJKDdu5hIrtV9myy4XvgE0D4+7e7adNAT4fA0O/wgxI42AkwN5NSD5wap3zsrdgi7FkLEflnfJwEeMFrZf4WAsMPEGftWeT1MFsWoDO8518I6iOelB87Qys52xcUL6M794r6WlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5771.namprd11.prod.outlook.com (2603:10b6:a03:424::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Thu, 27 Apr
 2023 15:57:15 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea74:f9ea:fdca:4890%5]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 15:57:15 +0000
Message-ID: <2e5a167b-2923-e92a-b6ed-db6c2cba0827@intel.com>
Date:   Thu, 27 Apr 2023 23:57:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 09/21] KVM:x86: Load guest FPU state when accessing
 xsaves-managed MSRs
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <john.allen@amd.com>, <rick.p.edgecombe@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-10-weijiang.yang@intel.com>
 <a46895fa-3ffa-e2d8-2841-625a1f791ece@linux.intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <a46895fa-3ffa-e2d8-2841-625a1f791ece@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0091.apcprd03.prod.outlook.com
 (2603:1096:4:7c::19) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB5771:EE_
X-MS-Office365-Filtering-Correlation-Id: c549a234-8d67-4fd1-3bd6-08db473811c1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86VNwrdFJxvX6PTnsTMw9bwblxOH6GOlZP+A3iVhvNhU3Os3QuQg7A831MSqt2wvbbR7mo6Zc/70lmUrrlIWQoTTQNC8ImjZtQwGKiRO4/8jz9w9uvq0GU04MBTI39oi/xT5igBTu5jMerDKdvHaEa4tf2PTYXTBJJaC/MUlUcTRw+pyomIp9IZG/L8sl1UB8zEMwNlYz6cKO62RjLeR545PRZPSqm7F/SYpnmb8/PW4D6NOb9zhAVSskCR5QYD7yxWw9yLqz4y5bWX0kyMocgLtUqKcCB7J1L8nf7L3EKu4JWYlzfjM66qj+JOk7CjkGBWzXd1Wrsij4ALLuqKi/0nRmrzPj4JZmkvfvb+oOHjvq6FJoPdC5T452w475yw5TSV2mlre6HuOTLceNNAhiILhDg36XLPOc1/rzVOlDooSTZfNXdJ2IcsrtgxIIb5ml64kYmfSJCZYcAFM0U32eUykcQbX6scSmCuH/3auZPVF7d4RatsGQ+ytL6KLLbQoMO9Hdmv/FkXFmwROwWXdVPX7xBQPHDdmXW6uIIKxxqfDLdzkVqklbzxzmCrWy+JIPxu356EbmQbSu79deEflsSMvO3F4NCroJDboEVUcA7F1UlXvJ0VkdEITW3vh986+0Kk63vibw1pZKELShr/40Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199021)(36756003)(8676002)(8936002)(478600001)(66476007)(4326008)(66946007)(6916009)(66556008)(82960400001)(41300700001)(316002)(38100700002)(2906002)(4744005)(2616005)(5660300002)(186003)(86362001)(6506007)(31686004)(6512007)(53546011)(26005)(31696002)(6666004)(6486002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFRkWlNPMmQ2NWl6WjdwZDAzemt4bjlReDZZWHd4TXBaZlVNOUlpV2ZMZ1RP?=
 =?utf-8?B?dkxFN0ZGZWhqMHM1U1F0RGVOVmtYK2pjZEI4OEllWGVlTkU0TE5wZnVuMlFW?=
 =?utf-8?B?bGRSM09ENFlMT3pQOUVJbFE5V2M5ZE9TR1cwN3hlSVNvaEFRcHVFVFJnc1lt?=
 =?utf-8?B?Qyt6VzhQNlB5UmQzNTlSbEJhcGZ4VjA0Z0M0bGpIQmtnWmF1aVhyY09mVXFZ?=
 =?utf-8?B?bmxkbWVwTW1admZvekdTdTJxeTc4MHhJczBXVjI1R1VHS3lFYWVYRlZkbHRI?=
 =?utf-8?B?QmJ2ZWxQSVBFNmduS3NCbndrSmM0LzdETXpVZ29UMW43ZWh1aWloZGp1N1Zz?=
 =?utf-8?B?S3k5QU45U3dKS1pHT3JoNnlVZUlYYlc0V08yaElTNDhXMGFtTEtMTm9YbEk0?=
 =?utf-8?B?aGNmRlpEVlJQUit3eGw3ZWtMeUNpcDJjT1QyOGUrekVlL2ZhaEhFbmFFQUlC?=
 =?utf-8?B?RW0xZzlZYmFudnoxV1Z5dEVPMElDM0RkZVZObW02aDV4VkZRWjFCK2s5Zit1?=
 =?utf-8?B?d1I4YWM1UXVaSTR6eFFWK3pCOHRwSlVtcUMzb2s1dFpiK1pIY09HOUxRSVcx?=
 =?utf-8?B?QjNidTNRTGJjdVdBNWlMWVR0SW5BcGU5TTh6WUxCVzdPMXdwcnRzWXJML1hO?=
 =?utf-8?B?K3djV1dad2dBNWZZRldoZWhxWE90aGRaSVdESk0xV2RGSTFzcHh5cnJCOE5W?=
 =?utf-8?B?L056TGx2RE1WYXF5L3UxMkJ4alh1bVlFOHQxQXh2L0pmWVFnOHRRNGliREND?=
 =?utf-8?B?czNkZUNCR2YxWmlsd2RvTG9xWHd4Q0pMeFFkUlhCbE15NXZERWYzU3NicE5t?=
 =?utf-8?B?TTMwUFJCS3dDRDJOQXNERFhjdnlzM3E1SXA4YjFjUFRDKy9ROUl4TzNsOGNW?=
 =?utf-8?B?N0p2V2haWWJvay9jSVh1NEloV3phLzJabVZ1RzNYbS9SVFYyUzBNTDR3cDBW?=
 =?utf-8?B?eWZJS1pmY2EzUWxDazhncGhMZEVTNTAvdWxtcHJkbldwckpoMWZ0SUlFWmVN?=
 =?utf-8?B?dWl0d2ZqSGVXc01zUjhWcmtZMk4zRUwyMGhvYnVUSUFINGVBMGJ0aFVuRTBk?=
 =?utf-8?B?TUNYMHdJdGhOMzVzYjlHWUE5YjZNZjVQdFhhSUNNVWdvTlNtMkJSKzBIYU91?=
 =?utf-8?B?VTljbDZiRld5UFBZTjdSeUl5a3JFV0Uvd0oxK093MWNxekNON3dSZ1ZuazFw?=
 =?utf-8?B?Q25NdHJ2Mlozdjd2d0tORkJ5TVEyNVBZRXdFeXQ4bGJ1eHVJcWdGWWZOZDBY?=
 =?utf-8?B?dEtPdnBrTEQrTG5xODBwajFpZUlyQ1l0cXp6K0ZmVHV6T3dpTDI0VVdBcmJC?=
 =?utf-8?B?STFtaWhURkU2WGZ4dVI1bW5HZlQvSEZHYUtrYmhyc1pJd0FCczNMRU9FOWov?=
 =?utf-8?B?MWtuWDZ5eUhEbFJrcmFiMGMxbFc5ekdpb1ZIUVgvazNxZUxkVWkyVlJRVlNT?=
 =?utf-8?B?SGxIWHVFUmovZ2RTNy9FanE5M0g2b0JIaDd3R2dPU0xFMXo3dkFlbkN6MEpZ?=
 =?utf-8?B?K1BGbDhiYU4vN0gxM2lRVDc1TmtIU2ZITzY4ZEZ0cmFIcWRKdGw1eGhHMDVl?=
 =?utf-8?B?S1Y2VDByUjZrenlFVml5TTZQcjQxbGVIM1lFUUUvbjY2VVRHSXhOVDRTeWFU?=
 =?utf-8?B?d0NQZEVLTEhUREdTd25WSGVwVHZwVDU0MlBKTDJqc3pEa3ZJK3o4cS9jTWNq?=
 =?utf-8?B?T2FUNHRxTzV0SmdkMnU0bDVYZnFNb1RVSVZwU29ZTThHTVBUdjhiMHg4anVi?=
 =?utf-8?B?bng4cFBzNzJRcGNXajM4VVhLS1BBTTdwRTJKTU9TMCtYZlNERXh0TVlPYnJY?=
 =?utf-8?B?Y3dLdnNBZlh1UHNUSG9VNWU0aWIxc2x1YVJwOWthalFZVjhpM2gxNGo1enZ1?=
 =?utf-8?B?M0IyUTBubEpadEt5cmd1RnIrMXlsdDJrcXVpNDNKK1NiRitZWDgxemEzSFpF?=
 =?utf-8?B?ZjR0d0VPOTdiK0NGbzJqbTJsN0ttNVFTY2lCM1pSWWY1S3Q2VE00Z0k3bFYx?=
 =?utf-8?B?c3RnNm15TTZQc3dLVFN3ck1KV2V4RmU3ZHl1UUlTUkVhZVJSME5wb0ZvNWNS?=
 =?utf-8?B?VUtGNXk2QmNWVmZIT0dZU0x2dGZaOXFDNmgzR1dGTXVIUUZWd0YvN0tLOXFI?=
 =?utf-8?B?YmlxTGp2S2toL2xRczRqU05pWTNRM0dGMWh2V3BBakRHV2cvdCtubWNnNU5R?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c549a234-8d67-4fd1-3bd6-08db473811c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 15:57:14.9104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rBVlHI43fUOrDIFXkYPtCqUoBG5cD5qC1pUEhNHehezQ15rng5EAVmy5Y5P/pYqbYQwaynQdNCjuTiqwzwYHaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5771
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/27/2023 11:46 AM, Binbin Wu wrote:
>
>
> On 4/21/2023 9:46 PM, Yang Weijiang wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Load the guest's FPU state if userspace is accessing MSRs whose 
>> values are
>> managed by XSAVES so that the MSR helpers, e.g. 
>> kvm_{get,set}_xsave_msr(),
> So far, kvm_{get,set}_xsave_msr() is not introduced yet.
> IMO, it is a bit confusing to understand the whole picture without the 
> following patches.
> May be add some description or adjust the order?

Sure, will add blurbs for the two helpers., thanks!

> [...]
