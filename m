Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38313504F01
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 12:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiDRKup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 06:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiDRKuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 06:50:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB61165A6
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 03:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650278885; x=1681814885;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RQAO56PUB9HhMoykp+UWau/Sg0r9dEkuTEVKxABJgig=;
  b=R6KVqwHSI4kH1jPjyaImpWbJX2Xh0XNTGoLrI6EI15oBXQW/NBnd+K5X
   zgcrxKFeLHUCqeRQ6OI/CfjNINK7l3Jcll1lioGOqba7Hgbomudl61lKQ
   VPqfyGsogXSXcJKLylWnz+sCaQ/vkkEVikUlZxxx6a1Vuwt5mi44xbVe8
   AZu+vI74c04Wjzg9SAFQSEhsggp/Tho82dBQAIFWkdmqpOX8+fPkra1GS
   YroAKMqt+EAjND1JMKReXRwAAVsQRGGMMAc5w8rwywUdAFTBR2PErTz/q
   G93CupRt9z8aEDUx5SS+R3R0ga1+zsgedvstadXoQGEkdu+GRaJHbLQdL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="349944983"
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="349944983"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 03:48:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="509703077"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 18 Apr 2022 03:48:04 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 03:48:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Apr 2022 03:48:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Apr 2022 03:48:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+Itt/G9wXN6J9/lwhPVRarWUZ598vSrYnsvl4E1NwRrKdkHGMEuatyoHfunpyGyoiUjBPsO+ecKdFXvS6CZjnVmnhUjJnc2eKeOcr/39cUY07qGM6SdjMpsa88582v4Kvnd27lFtC6vQJN7cehwYObaZV2/4WiLZxUEFrTBzzuztjLQxZkKvBGf6NovZt7eY5dIt+ey+v6heWHA9Vjpnl5+98GdBHw4WtHWlHJNVJVcyA5O3WM3ODfKW6rVMr5WwkJeeklo3EAdalFgM0M2X9hEp2GRCt821I7SBj/mPgkcuu54McX/lJmS/sPU2IHyRyC1MTi3ui9taiV1QNeZPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sAOdJuQEEhWh2PBt2KINcvBj7KABe06C8YYJnowliS0=;
 b=YqFn7Q+p9yLmjH0xcwMyDqKFI4Tr81rq+I60cUUA1qhzB2etHPBuHFeJEIr/MEPnCFLENNDJHydIbvWgb3JaRCtatNHtSL6tvOBdStaYRxCi+1vRxYuTdNJixhObJLdo4VjvlsxslQcOIJLN36iuSmEEtmGfHu3C+bYRI4mFB13j8OyvJnoaiElvLkw2aXwJeST11Ijke6I2ykvg0jnxebpMKjPTnfaSm1xDqi+hPaUqYw3APYQVBbRfGENDdO3wC9wZGpGjeAKqxtWR3GmsH/fscNyYMDhEfGWxP2B8Jlmz+TtJzA30Rgie5aQSs20z35OADsgpKxc+0ZT8Mc9VfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by BN6PR11MB1762.namprd11.prod.outlook.com (2603:10b6:404:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 10:47:56 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%8]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 10:47:56 +0000
Message-ID: <b5916063-5c16-b9d0-2825-7b6f858ee3fe@intel.com>
Date:   Mon, 18 Apr 2022 18:47:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 07/12] iommufd: Data structure to provide IOVA to PFN
 mapping
Content-Language: en-US
From:   Yi Liu <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        <iommu@lists.linux-foundation.org>,
        "Jason Wang" <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Niklas Schnelle" <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <7-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <17c0e7f2-77ee-0837-4d81-ee6254455ab7@intel.com>
 <20220413143646.GQ2120790@nvidia.com>
 <42f6e2ac-8abf-8275-01fd-9b0c5dd53b4a@intel.com>
 <dea7b099-cc21-51f0-e674-50901a7a966b@intel.com>
In-Reply-To: <dea7b099-cc21-51f0-e674-50901a7a966b@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR04CA0075.apcprd04.prod.outlook.com
 (2603:1096:202:15::19) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5703645b-76ef-4195-ef53-08da2128e562
X-MS-TrafficTypeDiagnostic: BN6PR11MB1762:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB1762FB918309924D800EFDB7C3F39@BN6PR11MB1762.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+8Eh8DVxjTcaFHbwVsVrxW/NbKwRtbjJ7l9otl0lEOXF0Dt/NKE8yuH++pxIkHu8LHzrLuwGKknwJkTpentvdTpzGSwWZKzIDpcSdui8ksUdt7raWsilTpK+nNK+L9Ou6s4+zdLjitMavyBJFzxZTIwE4TDzI5/EB/NPSEnFmkS63T5S9WdbPcoUdpwDWl9CUwrID4L7wuXRhnf93LSL0HW5A/0JeTKS+vhtgdfcs7yScBI91Vi90eDNcoIVWgvDNDJBzxjwpa4SwrWdhWRGmTv1IGFJGqzE1FY72n7hYjRQvWCS7oaLCuzsHK3LsrXqzpA8zi8RrJti8EzVSKvozTagYQAx6yUvugTTZepx6MVHNKMC7JBNmbDeqqohP1vs4xnNehBgN4v8YAEUQq9VEU1TkteRjretv6yArA2vw2AEsPbpvyJx8vcbvUA9cv0OUU4Kx6KCRx/VT+lgHV1IKrUWyAR02S4Y0PHTNoODGNUkQnbhxD4VYcsRnVUg8q7ETwsoz0P0sSWnGh978BqGZLYzS4d4G+d2x9h5Pq0Xrdxz8Ic/XtvTULFlzcaC8kDqei5PtTRz5cHy0seZBYnfnb/kcB6GG1WOnQh/6tqqVn8M9H24vqtk+oPtsdWOdzfzN6TLI1QzCBUy81O37lEf1ZTfMbBq8zgPSy3CpDiiu5k16frfGvdj5GUHisMICTeWkSzuFq5GbhKwPpOtSUt7kI6xFH5g/QKezP1aCeVcPuYkIYbDbkDuJl4X9TE3wVMAjaKNwfJic9L0zNGsqT58c8crsDby5r/RXGFC0GgurparbG9hETxR+oa1MwX3hAV+W9YO9YhmsNL1N1lBwZjWlmTSCJE1jkzKYLOICu24z0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66476007)(66556008)(66946007)(36756003)(53546011)(7416002)(8936002)(5660300002)(508600001)(31696002)(2616005)(186003)(6486002)(966005)(86362001)(2906002)(8676002)(82960400001)(54906003)(6916009)(316002)(31686004)(6666004)(6512007)(26005)(38100700002)(83380400001)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3RCcXFnUEM2L1ByNTBHOU55cUpZTVo3dlFYVEZlNDlDSXFlS0lyVEFzWVFs?=
 =?utf-8?B?TGo4TzAveGE2VFViYjVkdk1HdXpFb0NldmxhVlM4cVFLUnRuK0ZMemlpd0cw?=
 =?utf-8?B?bEVWY2xtVjMwRkdSQWhsTGJsYjNSTHJwT3dXcDgvemJ2MERlR3JjTkJOQTNQ?=
 =?utf-8?B?UGxQYTZMS2xCOGZMK1ZtY3AyTVdFcjM0MEpSQXR5R2ttMXMwZUJHancwL2Rj?=
 =?utf-8?B?ZHZLTWZ1QjNSSTM0c041c3JJZFVBOU9FcldlbTB2dFlxdGVxeUlJL0hyN0hP?=
 =?utf-8?B?VmlxZlhsMG1odW9QMlVEZ0J1bEpFa0tXY1QwaFArQjhQNTNBd2hHL0prMzVn?=
 =?utf-8?B?dWI5SjlmdTBVMjhrQk1sOG9JRzM1dHFjTHpQbWo3VjN0MzA0MGM1QmtxYzRS?=
 =?utf-8?B?ZEtOc0V0a1VUNkQ3bHQxU2dGbDUzVUc4ZGpON2RhVHJwL0toV3piY0JQaDgx?=
 =?utf-8?B?RHFMVGtObVlVQzBkbno1MnNMR1FCZWl0VHFzalNkM2Z1Y21nRVdncFlSWUhD?=
 =?utf-8?B?K3NJekVHSGprRUpFcEZGUSt6eERXZmx6WjhhRFR4Vk5Hb1BacUpnUmtkYlUz?=
 =?utf-8?B?c1VKMVpRdTZLOXdCUjhrWlVBS3R5VWpCekxwMU1UYjZOM0pZektwUDBXYmFT?=
 =?utf-8?B?UUpsMGYrMzA5T3ZuY1JIVThPcXBkNU12QVAweS9DRzE1SXJkYU83LzMrUkhB?=
 =?utf-8?B?MVpwMzNNenlmclhyaXhKMW5xTW5nRlBEcDNCQnppOXVtU1pSQ2Fnc1Ntb0hh?=
 =?utf-8?B?OWhwUHJDMEorelZ5d3FZSS9Rcm1TaHlqaHdqdnhESEhuZTJ0d3pGRml3ZXBF?=
 =?utf-8?B?WTA3QVJXQVZGV3JDZjRQMDBydXpMaTZMdU9QaDBLYU43NW1QNFBaU2NmWkY5?=
 =?utf-8?B?cmZYREk1TFJid044c3RRcHloUFE2QWRaVFJ2cTlxQ3VpRzhIWHJiM2FUSmpo?=
 =?utf-8?B?Ym5GQzI0RVA0d2l5SlVjSEo0V291SFQ5TGRjc1dBN0xyWENMUng5aTNpbDBw?=
 =?utf-8?B?S1hPZDVZTFY1ejNSdDU1c0piVjhRb002anJkK3F4WFR5TVVBaEFWWTJpWVJZ?=
 =?utf-8?B?QzZSZVF2YkRnS00xN2REWWp5dmFrNmpNckZKNlRWdlBTaVEzcExQRXR5YTZG?=
 =?utf-8?B?RVpqTXlCWDJEWlRsem4rdm93b2gxSkxXbStWa1lFNzc5Vmo0aURQU0Nyb3dH?=
 =?utf-8?B?amRXZ2RYTEg4OVpuaE0rYUE3N08xWFE1OGpIVS9RaWZlZmVxTVp4L2FwWkxy?=
 =?utf-8?B?MGZUZ1JKZTdLVTlUN3lvMHExWldSeUF5ZGsvMGhCL0RlRGtTRmMvZUhOd0pJ?=
 =?utf-8?B?NG5tSGlHaEpSTzJBQWZvR2tOWlVpU3F3cnhZY1gwbkUxTndpbUpmWUNZVm16?=
 =?utf-8?B?L0NEQy9ZN2dSQzJINFJBVytuQW1nSVJtSWpHa0ZiY1VHTmk4b1lqc2tRWjQw?=
 =?utf-8?B?Y2JVVXFhYkRjY3ZpN2U2NWhuV0RpUHB3ZmtseWMyUmgrMTMrbnRkc0w1UkV4?=
 =?utf-8?B?YkRxaGRhaTZ6TC9yRGF0VW5WRHdYa080cHRaZjk4NWltSWFFQ2RkZk5iVW1v?=
 =?utf-8?B?bFF1MlZjcVg0dEhHU2g1dk9PNTJscTVQWGpvSVkydUNUaHhIbGVTYjJ1NllJ?=
 =?utf-8?B?d0gvdGorUUp3MVlYWkV1UkpXOVllcmVxUDdZMTB1Vng4cHNtSjFlK0x0dXR0?=
 =?utf-8?B?ZjZRYUUzS0s5ZWl3REZEOWxQd05oVE9kb1k1bEZWcVZIOG4zdFE5WVY2c0lx?=
 =?utf-8?B?WENFeUZENVc4NmV0QUpmOXNwMndFbjFMdGU0b2tnczJ0cnNOakpUSG51RzY4?=
 =?utf-8?B?d0lVdXcydk5RaGRPaWZCazdDN1hpR09ZdjZRdUhpM2FOQzBWUXY0MU9EOEdG?=
 =?utf-8?B?SXV6VmNqbytXRGN4NWZaSG9iRXFoZE1VeWI3TE56UWMwS1UvVDdFdzZWSTlC?=
 =?utf-8?B?NVR4elFPcHcyVDM5MTFVUlRmTit1bk9QMm43NGtYMngwWjdaSEJmSFYvNU1O?=
 =?utf-8?B?Q1RuM3QrMGFqOTRHZlFkWExDSzJkWWwvallQMnFSWmZUdm5yNnZkbUx0a1pC?=
 =?utf-8?B?ZXNVYWgrNE0wejQyZmxhaFVwSi82NXJKMm5DajRMbUpDOE9aZWZZZjJwalRQ?=
 =?utf-8?B?bkl0MlBlMFdHeTR2ZkhvcU5RM1I0NHJQM3pmK3BKaWtVS2V4eHcxbEVFdS9r?=
 =?utf-8?B?QnNuZzRSSHdLbkNYUVZocnU5U2YxS2xYS1YxeXFUZkFQU2lEMFQwbzVOYlV6?=
 =?utf-8?B?VnJodTdNVXdPUXJ0bE8rbnlPNlJjYUVaNnk4b1pzL2JyaDNGV2ROZzJKOEdl?=
 =?utf-8?B?MFlQM05Uc3czUW9EL1lwY2ZRbVdQbm03TzdNK3hac0I1NlFmanVDQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5703645b-76ef-4195-ef53-08da2128e562
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 10:47:56.0638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSEY8XgCMdnPvelJfZ1l257nmNzzyoyQjd2JU1Zo1MPA6P7+nrIkJm+AIgb8r2d4qKxt5/++2Y4SfaB91HCgZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1762
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2022/4/17 22:56, Yi Liu wrote:
> On 2022/4/13 22:49, Yi Liu wrote:
>> On 2022/4/13 22:36, Jason Gunthorpe wrote:
>>> On Wed, Apr 13, 2022 at 10:02:58PM +0800, Yi Liu wrote:
>>>>> +/**
>>>>> + * iopt_unmap_iova() - Remove a range of iova
>>>>> + * @iopt: io_pagetable to act on
>>>>> + * @iova: Starting iova to unmap
>>>>> + * @length: Number of bytes to unmap
>>>>> + *
>>>>> + * The requested range must exactly match an existing range.
>>>>> + * Splitting/truncating IOVA mappings is not allowed.
>>>>> + */
>>>>> +int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
>>>>> +            unsigned long length)
>>>>> +{
>>>>> +    struct iopt_pages *pages;
>>>>> +    struct iopt_area *area;
>>>>> +    unsigned long iova_end;
>>>>> +    int rc;
>>>>> +
>>>>> +    if (!length)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    if (check_add_overflow(iova, length - 1, &iova_end))
>>>>> +        return -EOVERFLOW;
>>>>> +
>>>>> +    down_read(&iopt->domains_rwsem);
>>>>> +    down_write(&iopt->iova_rwsem);
>>>>> +    area = iopt_find_exact_area(iopt, iova, iova_end);
>>>>
>>>> when testing vIOMMU with Qemu using iommufd, I hit a problem as log #3
>>>> shows. Qemu failed when trying to do map due to an IOVA still in use.
>>>> After debugging, the 0xfffff000 IOVA is mapped but not unmapped. But 
>>>> per log
>>>> #2, Qemu has issued unmap with a larger range (0xff000000 -
>>>> 0x100000000) which includes the 0xfffff000. But iopt_find_exact_area()
>>>> doesn't find any area. So 0xfffff000 is not unmapped. Is this correct? 
>>>> Same
>>>> test passed with vfio iommu type1 driver. any idea?
>>>
>>> There are a couple of good reasons why the iopt_unmap_iova() should
>>> proccess any contiguous range of fully contained areas, so I would
>>> consider this something worth fixing. can you send a small patch and
>>> test case and I'll fold it in?
>>
>> sure. just spotted it, so haven't got fix patch yet. I may work on
>> it tomorrow.
> 
> Hi Jason,
> 
> Got below patch for it. Also pushed to the exploration branch.
> 
> https://github.com/luxis1999/iommufd/commit/d764f3288de0fd52c578684788a437701ec31b2d 

0-day reports a use without initialization to me. So updated it. Please get
the change in below commit. Sorry for the noise.

https://github.com/luxis1999/iommufd/commit/10674417c235cb4a4caf2202fffb078611441da2

-- 
Regards,
Yi Liu
