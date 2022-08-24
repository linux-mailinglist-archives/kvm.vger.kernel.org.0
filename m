Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60C95A0444
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 00:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiHXWtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 18:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHXWtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 18:49:21 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0328A61B25;
        Wed, 24 Aug 2022 15:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661381360; x=1692917360;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z3vsZLjVC4CUCSUgk1xEzCXpWrYxoIh3AYAWmYKkxaw=;
  b=nK6OdIXohKm4IostGIZIWlLf1FwBjaMgt4OoXAr+ez+8WRHacRAdtkeh
   xbAzWrlD/KwxGYdMUWaoNd7dfffwxy9RTeMJKimM2/lB1JnIBSRg/2Mqu
   IIYuOES47L6dG7BDPcjl1bChiqffc+o0oYpmGdUvtVdltGP5piNW8x+lf
   uUOgztJWllhmTFNWqZ8lQLERnrXpuY7RxU/J5rulN4jnNQ5TRcqYgY2LD
   G+HxyvCU2Y6JrB96wnH0fsuquW5H3xZ1X+k+Yaw8K8ROPTA8o/ucmfasy
   b0PlBb7bUB9RhqOCBCbaIbIMhThkibdsEu2x1IkTslvrfiwX2rT51Y4Ck
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="273846617"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="273846617"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 15:49:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="938085589"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 24 Aug 2022 15:49:20 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 15:49:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 15:49:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 15:49:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 15:49:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvA8dzkgULmE8PDIL3NBIqjQP4gzWjsFH3QW3FJTKam5T7YP49TPRWs8UE8ZT2R7Z08tS3Sh6a0mRNePArfNUOJ0SmALcwCOVDNHXkE0Yhjn3Ng1+BOaTLIeGjrQi8oXtBHPSpNY0Pge8wUevsTjSQn9w0UvC7yAAm5q52caeV4KuZKJtdN+yNInTvtNXETvLd2FiTcp3gUgiMPDtsDcAxVfgBLeWPevcirtQSQIRIbsjQTUgFgoThX8N+HxbmC40ulKnirWfG1/DjgaTpBNi4n2HTVcvOMrxnjEid7Jt8gASH67IG6c/oltRpLXzMTuA0MRdfmPOy0c03i3LIitrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DeiYPIyr4i24v9ZPg0M56UMPtU5xaQ8bArGXYKVrS4=;
 b=I+Ij4nB03fXBKJW8oj+TQ/Br6nhHHEzcC7xbQ4Bvvzf2HwxRkgG4dJb2M7ZK/SPaOB4Gwk0CoZvN4i+BDSbc14bHjMx9Gd2fmrTPN2pRnTZLnm9CHGFBkGfmZbuhp+3kboyZ3yjPWavCBI+wRSaB3lu51dIyLIgYCHv5rmHeywJwvgWtVSl9riSAI9c6TiJyXPrWdIwjlzxwpbA08V9NLuPzUA1I6ERR3OaomWUlmJHRcEGaGWMNFW6kc1LD7mXFbwj7saAf8CMtzXzU1hdIuL/Z1NP0glZ2b26L7T1aDQqgZIb8r2FtRd5r0f98UtacIVcE8dfyc3VbED15hYMzwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by SN6PR11MB3198.namprd11.prod.outlook.com (2603:10b6:805:c3::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Wed, 24 Aug
 2022 22:49:17 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01%3]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 22:49:17 +0000
Message-ID: <08e59f2d-24cb-dca8-b1b8-9e80f8a85398@intel.com>
Date:   Wed, 24 Aug 2022 15:49:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 1/2] KVM: x86: Add a new system attribute for dynamic
 XSTATE component
Content-Language: en-CA
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <yang.zhong@intel.com>
References: <20220823231402.7839-1-chang.seok.bae@intel.com>
 <20220823231402.7839-2-chang.seok.bae@intel.com>
 <YwabSPpC1G9J+aRA@google.com>
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <YwabSPpC1G9J+aRA@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0265.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::30) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 452f93ce-f06d-4ecb-dec7-08da8622dff2
X-MS-TrafficTypeDiagnostic: SN6PR11MB3198:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uuD8Oi1O3nqlqxiwjmtfZJrdHdk34QJDXIZ3c2AAL6C3N68txS31HZClKzUGqkWjDWylenagQRC9z0E7y78ZIBTjBMqittIMQQXfFMmLbh6F8hufCzGef+Gj/BRJoWB75Fd6Peo/+OWaHt4xobBuywm849n2yJXcdHEascdnIYFF5/G0mtSE+9McGatDi1GkFXIAYciTUDBRKu5rOX/0UQ7dPik1KLWVyn05i8DhFYRKRFuEXfhXZMwCr8S/N/7uqTYwlDn3mG/9sPwppLaWWS5szr3eaSyU5K5LQkgax8BdpUyuY7q4qGAItsm456kHnthzFI4EC7qMer0qzxi4Lg1USO7fUs463hMnZ9wbgw2BeDFWX96BEtzVL/EaqlPT9oRWPtohpbwoFKy8pVS9JltayDruJBRYdEG/PSuuXFO4anJ09Zy1/MjfTCXombcyzXwNtEd1/new3zZZweHv8NX8WQOBdDwoAP+DhCupX7HP57mpYk9Pfv8Yj/2I1C9Bhy/AiNJpSEUqCQsuBUWBu363jOkhPrVpHXVghKMSx/yz+PtmNNZAdNLHSzegNGRUiz0zFVM9RdjyM63g3rlUkhXSZh0ptU/hh1qRJiGp0vVAndBgKYaIZx11KXjYH8MwDa83S/yXH75GmLIxbabyY0gJe/4jyRIbb94a2Mcjaq4o6kgNDKRs7DpaURbsKsIMeB2OUZDicNaLPGhMmTGF99305MzP3/N+587h57nPZ5SE2CIFOdUE6F0S51W3TSuz4ebAPsi3YRw2+gGg+027WRKt2yxqG431spyIPOp7Bs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(39860400002)(396003)(6486002)(41300700001)(66946007)(316002)(66556008)(5660300002)(38100700002)(478600001)(107886003)(66476007)(31686004)(4326008)(6916009)(31696002)(36756003)(8676002)(8936002)(2616005)(2906002)(6512007)(53546011)(186003)(6506007)(83380400001)(26005)(86362001)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0Q0cnpIWWM3aW13UGF0Mmw2dUgzUmRrTTNKdVhZRUVWSEd5M3g2aWxzb0tU?=
 =?utf-8?B?K3JhUGY0NnROL1ZGdEZ5K0NCWXRSSEc0NnB1L1c1dGo4UW9jc1FjVjdwMExq?=
 =?utf-8?B?OTVrMHI2cDZaeUJmVTNTS21PL3NTNWhEN2hoSVBac3hJWExYeXY2ais2MzE0?=
 =?utf-8?B?Yk9GdFhlNmg2dmVPclp5cFptQnhwcml2TTAwaDg0a0xRRlRDaDJDRFh0VDRD?=
 =?utf-8?B?OGxrVTdtRW5oV1FNZGZSL0FHNXFDMGFwQXV5OVRLT1Y1di9IWSt2VHVFZXRv?=
 =?utf-8?B?aFcrRUZ5SGtsZEFPUUhubXRpR3RDVkpJNjJBR1Vra1ZKemd4ZERFMkxKdnZp?=
 =?utf-8?B?NXZUMFV1YWZnVmF0SC9VOCtvRTA5TG1VVXVOTUpNYWc5N04yODVEd1hmclla?=
 =?utf-8?B?ZDdkeWZKdE9NQk8zWWJEVW9DeDRkcDNxOTJZbFYzSG8rM2tHM3dzcyt4cXN1?=
 =?utf-8?B?Qm9KOHVJNGN5dTlGa3NVcUZQUis1bFVwOWpyQmRsOW9KNDVKOGxQNkRid3hV?=
 =?utf-8?B?K2dNWHFDQnVxd29yYklXTitLSXBWOVVaMnFNZ2tpczkwdWRYRWI4N3RNNlM2?=
 =?utf-8?B?dEFlL0xaSXZRQUdxVVBuZnJNSWMvN3BZK2c0K1ErcXc4VTh2OGlsa1lROEVH?=
 =?utf-8?B?RlFndXZKalIrRzFZblljSGR6VnljOUtaMEZNNnIxaEFhOE01VEFmS3dDZnZ3?=
 =?utf-8?B?ZkN6YStjenNYUkY5dXJiKytudGN6OE94RGNWdkdyYklndWVWU2QreHg5bTNK?=
 =?utf-8?B?cWZQZXZMR2lCbHRURUg1cG5lOVRNcTZHT1hJd2hZTGhQSXBrUnRBSnpnZXhu?=
 =?utf-8?B?dFNLYjErSU01WlJyaDNFZ0pKRGtDMEwzbXVGWmhGLzRFRy9DWkVsRmVXdW5i?=
 =?utf-8?B?M2hMNGZrOGlvc0JsU3FsQURqNW9OMHNBanZ2L3d3U25WSDROTVpGbWNjekpE?=
 =?utf-8?B?clI3eHExMXdjdmUrc1E5YTIyejk0N3FyRGt1T2RQZ1ZUVG82YU1nREtIZHEr?=
 =?utf-8?B?WWN0M2ZKZlRpbEdpaE9TOHRyUm1WcjdsSWsxRGxDZWJNVzJna2xkSjhQQnBZ?=
 =?utf-8?B?TjlTN2lEczNHbUZuWW1EVHMxb3FseWhhT0JrRnRYMHh6enZ4eFBsRmFyaCt2?=
 =?utf-8?B?OG1ETFlVclhMVnRSV3c0elJGc1lvYWNiRUZVaG1wWUtkcW5KOXFWL2Q0OWpY?=
 =?utf-8?B?U1UzWENaS3dhWGJOQTI0STVsRG9JdlNYcWRsSEFrdVJ1RU5TSytjOThCTGFI?=
 =?utf-8?B?Y2orRkg5N1Y4b2JBbFNFQ3ptSkRCa2hSbUZQeHRSRTVPUkhVODJQKzdaMkIz?=
 =?utf-8?B?SUFxOU5YQWl0U0lyR29rR2pEWTZVdnFsTFRZNkpGdnQ0SEZya283REVlM0lp?=
 =?utf-8?B?OUJ1UyttVXBJenVCLzJzbVlNMWZQbGpYL0M3YjRKY3hHbGFGaWc0Wll2TW15?=
 =?utf-8?B?NXpwTXJuaTNvdVFWT3M3WUxmSDNlZEI0Snc0Q2hLWnN4VnRJN0xJc0p2OXVp?=
 =?utf-8?B?TG1sRTFsbFJtNzh5Q0J5VGovaFpkKzZuaGdvenNYNTN0RW11UjhoSm8vWnZP?=
 =?utf-8?B?eFBrVjZHaDB0Vm1CeUg1L1ZaTWFpYW0zYTB0Qm9OWi9ITEVqQUdxNFpMT3dG?=
 =?utf-8?B?S2tlcjRhVDFVZGVpOUxNKzZiUm1kekM2NklMLzZUZ0dVVlY5RmZ5V1Nab2w5?=
 =?utf-8?B?Y1NOd1Yyck9qeGEwOERzbW9BcmMzV0FEZVN3OTdVSmhCYjczOVlsa0V1amk4?=
 =?utf-8?B?RHpnUFVqeFNvb0kxMkpia1Y2bkpVOU9FNFI3SXIxVTRwd0ZNYmlZbFpYcTRy?=
 =?utf-8?B?UFo5RVJaNllyaDBqcnRlYytBSlZwc2pRTlkrRFlHM1ZMd2VQaDhMOGZjZmJX?=
 =?utf-8?B?bFIyUjdXZStGNmkzQUVoUzBiYXh4UkZYaGNRLzR0V2FHSE5seTMxMWNrbkVH?=
 =?utf-8?B?a0VDWkROc25ENWV3a3VKdW1RN0NGSTU4aFNyRm54c0JsYURRcnJqRHYyOHpT?=
 =?utf-8?B?MjYyU0h3NTlMZ1lUemlkRG9vZ1lvMTNOdElUalB1czVKOFFzdTRpWGZkOU0y?=
 =?utf-8?B?MmFmUGoxd1Nqa202aDd2UjJPZE9sVndtVDVjS3J4RnZZNlk0dG1zM3NhdkRx?=
 =?utf-8?B?bjVscTk1UWtaNFQ2NVFXT1BEdk9xN0pJVWx3eUthUUxyeDZnTlVKZWdnMTNs?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 452f93ce-f06d-4ecb-dec7-08da8622dff2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 22:49:17.2625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNhWvJIJby/wJnHxrPMCtGckbJ+JMFR8kyyM3IM+n/1m48sA4Ysb1b1jY0jZoZA1GnV6klgcfIEbBRSv9/x/fKNzUWi3otLkZ0JRF/QqWug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3198
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/24/2022 2:42 PM, Sean Christopherson wrote:
> On Tue, Aug 23, 2022, Chang S. Bae wrote:
>> == Background ==
>>
>> A set of architecture-specific prctl() options offer to control dynamic
>> XSTATE components in VCPUs. Userspace VMMs may interact with the host using
>> ARCH_GET_XCOMP_GUEST_PERM and ARCH_REQ_XCOMP_GUEST_PERM.
>>
>> However, they are separated from the KVM API. KVM may select features that
>> the host supports and advertise them through the KVM_X86_XCOMP_GUEST_SUPP
>> attribute.
>>
>> == Problem ==
>>
>> QEMU [1] queries the features through the KVM API instead of using the x86
>> arch_prctl() option. But it still needs to use arch_prctl() to request the
>> permission. Then this step may become fragile because it does not guarantee
>> to comply with the KVM policy.
> 
> But backdooring through KVM doesn't prevent usersepace from walking in through
> the front door (arch_prctl()), i.e. this doesn't protect the kernel in any way.

No, I don't think backdooring is established in this proposal. The body 
of the arch_prctl() support is encapsulated inside of the x86 core code. 
KVM is simply calling it like arch_prctl() does.

> KVM needs to ensure that _KVM_ doesn't screw up and let userspace use features
> that KVM doesn't support.  The kernel's restrictions on using features goes on
> top, i.e. KVM must behave correctly irrespective of kernel restrictions.

Maybe this is a policy decision. I don't think that 
ARCH_REQ_XCOMP_GUEST_PERM goes away with this. Userspace may still use 
the arch_prctl() set. But then it makes more sense and consistent to use 
ARCH_GET_XCOMP_SUPP in first place, instead of KVM_X86_XCOMP_GUEST_SUPP, no?

> If QEMU wants to assert that it didn't misconfigure itself, it can assert on the
> config in any number of ways, e.g. assert that ARCH_GET_XCOMP_GUEST_PERM is a
> subset of KVM_X86_XCOMP_GUEST_SUPP at the end of kvm_request_xsave_components().

Yes, but I guess the new attribute can make it simple.

Thanks,
Chang
