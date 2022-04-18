Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CF9504FBB
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 14:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbiDRMMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 08:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236281AbiDRMMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 08:12:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7431A810
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 05:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650283798; x=1681819798;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vNtIi4dudy65Nb1CG738wGEcbxpCOhqEoR0+yUEQB2E=;
  b=Jitp+1IC/Z0dI9zlWPErBi/1kFfAycN84YCTjBi2ADI3DrxTDO8JbkzD
   FRGNCumpPKcaIN5MvkzOehWD6WWEYIi9NrsjHF7DVkyqcSnchS9KZJt0e
   E4xBT5Pzli4aO0aDPnezTDR8v4WFOWH+ndGaQcIzYW/1vlPH0QjXsMhzs
   TLCy3FJqj2y0L6216q4vjriAPQXFPBSH3ozqa0c2Di8OxaMHBVhBx//hf
   pA/EBVhU9NSqOjmXyK52DnhHld8QckOdMHv++7Snm/InJCnEZiRiz1LUn
   6Jnp4vel7kCcEODM/VqRex0/uVpqL9/sZmW5WJn9SpYvfrSrMFt9cVt/C
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="250806953"
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="250806953"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 05:09:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,269,1643702400"; 
   d="scan'208";a="592375823"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 18 Apr 2022 05:09:57 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 05:09:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Apr 2022 05:09:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Apr 2022 05:09:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8sE73/pPO3owBW61DjuarVzi9TPiqMC0Lh8gFFzDfBOQrET0QWBANat/0Yu4z+vHCrMS072CyNQN8l1YTlprdhplU1yMfZYqkkVG7S8bPRCliuQIzmPm0Alh/VtkKT9JU+OFnVVN9LajeARxzmeUD9MFbSnjh632rxzYRUD+wYCzHp2x9QrMrkrF0yVj6EFrVLvJ9XU0/BsTl4yfN332fUlmHTMEMpX7iYCi/L1+yEZKWpqV+Xhhr29sOAMCzJPfR0Y6qnGTbQsTdYKNvMDq0QiHq0zAUYx8fSZBvakWMsI8vwFRNrVbdaStXsuaqp2mUtegJpmYUsXVvniOu0dKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGkJUwEoJ4gcwM8feW/zj0aRpYKahu+OjJg70HQENvU=;
 b=PD8eKPGc2HpVH8QUiHzDqqJ4MQdfgRMXuPSjETCf3smX3KhMu4GflMvHGNtO6DIr7Vhnt0/aQrzAfq7ukC5VAgyLta+cuSQ06e6w+aW7UdKf3jhf0jgk9vBAEiE9l//vI5Oa810z8bch1SMVrqyjEv0a472lbDt9mBEvEy8Jb6jvLJgy/h1yLIfM5KNKlDpNqK9tYekPgoHJYNCP6mtyvewM4Lcwa8ODLNl/gLKLPQGELpwsX2TxLkCmAgNKsvYXGSSdFAHrisGLdJITQA0pQO9Vzvqed+FardlzPBjMk8+UMxPWYEa6xqih55KqHE06EQ2VEMJKGeZCXj4oPMTU6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by SJ0PR11MB5085.namprd11.prod.outlook.com (2603:10b6:a03:2db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 12:09:54 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%8]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 12:09:54 +0000
Message-ID: <abfebe33-149d-ce34-a178-f735afe2ca95@intel.com>
Date:   Mon, 18 Apr 2022 20:09:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <BN9PR11MB5276085CDF750807005A775B8CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276085CDF750807005A775B8CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0181.apcprd02.prod.outlook.com
 (2603:1096:201:21::17) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a65b7425-d04e-4680-3f5d-08da21345925
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5085:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR11MB5085578BEF1E2BB9BC0B0CECC3F39@SJ0PR11MB5085.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRW3Uu8UDZJ/2dqnLO5QAx/l411f2EU/y8KhQ8YaHlae+CUw/+CffPTsJ3luI8X5nWzUIM5GOMokSmBPXgBsEryPeiVsPQeuK+BPOEMsTJ9ODSirKuOLEpx1dN7GdKAw+sDRzhgLcyBsc4124o4bTNgl7ERDX6MKKyxwbVLlTjqnc1FCrxFgSEu807mMtLICc1wfwjJ5fpdFfJFC9K+0P+CB4UnxRXvN5YMksPWmYE2gEhhDWUZ8AyUpl/vWpf652bmwyuFFpE52pr55DBKxwc64vLEOWFj/mm0apL/kuD0M8kXzLdrAtrAvzgi6RsNPjjvof9c831hjfRuFiWRHmyTevvl2BARmx5hVkeKyvpDQJqJOvlf1E43pnE21y5Bt15BT5vEcgsWkJp0CZUN8MO4BSNaYMDybwh0ZZWjr4VRlo2ns9VGaXELPZBk0nnpAOxkZIg0ou+thB4neqckWNf93RWJkjqQTsngcC16tiRSisWnyDCpwzRr5j+OHr0QAoVLZ2DLQBsutCQ9euQenfjkASp6nJ0CPSCspp7TCszdpWW08VVLU9COE27RRF2iISKZsJ/tirVye3e1SXdD4j10PXWtOo6gFVQx+ZGK/jOfAIQGfQ/s8+8IuIrOHnqkZzCgGSKiH3B/a10GtJy9mLP3Q1jiLqkAJ8GXgnBzGsZ839THcT/9dOK1GcvQgOukD1MzkWzkspdu5Yib7L2fBdsCJUCOgzH8nGH56k2pYszsLNc6L3NiXLkZyT6mn5ARAwuXNms88IBPWE1CqpRS/b0oTbNdNgsKwikM4V2PWNN9hsAuTJcGl00sJm2RER4jIsuoLrimrFkj2yCGCJOHjQnz35pBbR42rkbVVyL2pmEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6666004)(6512007)(7416002)(8936002)(2906002)(966005)(508600001)(6486002)(83380400001)(38100700002)(2616005)(31696002)(53546011)(186003)(26005)(86362001)(6506007)(82960400001)(54906003)(110136005)(8676002)(66556008)(66476007)(36756003)(4326008)(316002)(31686004)(66946007)(19627235002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjYrSmMzZkJRVE1PNUVnZmtxV2JCOTN2TFlkMEJueUhFdTgwQkwzaWRXM2xk?=
 =?utf-8?B?Zk9KMkVlWnhmZTJWbTFQZlZjZDNCeVIwN2pvME9mbkVMQlVJM0lleldtcHo1?=
 =?utf-8?B?alRlV0luMDJuUmJNeC83aGVnQXJtNXdjcVNIWWdiOGJKUUE3V1IxdTdkMUJO?=
 =?utf-8?B?RUxSZHdJU21NbXBHVDJKVEY4b2l0WVprSU0zSzFHWEl5bEU1RnVuUGVtbDJl?=
 =?utf-8?B?OE5nMFJLaldDMmk4NVpKSDlXZ1kwaGJOWXJXT0c2NkZIamFWSURtckpaQ3ZR?=
 =?utf-8?B?RFlOOGJ6aG5yVWxxSzRGRnFzakVHNTF5WTB3N2tkSVNyM29ZNGE3b2NwUGNr?=
 =?utf-8?B?UVlqMWZ6dytua3FpTlJMWDMydEpSdzJYV3hIK1NUcGhoY0laOEFpaVVMT3h5?=
 =?utf-8?B?YTNjZ1JKaTJKcGlYeFRmV1dWMmlyNTAzQWwrSmZ6SGRnY3JabFl6QVJhcE1U?=
 =?utf-8?B?WTFWUWwwbWlmRmhFVGVlWlNQRlFJRFFiRUR5SExja09LeTdRMFlTUC9uTjdB?=
 =?utf-8?B?TWZ6Q1BoakkyVG5QRDVxL1JHV1g5czNZekQ2ZWlPK1VrWmxManVuVld1ZVhk?=
 =?utf-8?B?TjV1TmM3WUJZOHJwRDdEWGtXUHFMc2lSK0FvNXQzcVNDLzZ4eEk5dlZwTkVE?=
 =?utf-8?B?WUYrV2I5bDFnZE5icTdmWEJhQTZjUlFvS2VrYy82R2dVN25hTWF6bHl5M2sy?=
 =?utf-8?B?V09iRWdMbVpQRE9jbGtlWEJmMVNnQ1dmRnNwd2wxUytWelQvckVHNmhvUnR4?=
 =?utf-8?B?aUJWUnM2cEh1U1o1WjJlcjRkZWlFOERiV1hFWVB5bDFwdG83UDJ6aHZUb0ls?=
 =?utf-8?B?MTNKMUpNU0hWM0hWOEp2TkJ0Q2U2YlY0V0FYNHdmeFZSRUR5Z05rUDFPc2VE?=
 =?utf-8?B?R2ZSRm8xdS9XQ3pJYXh3R0JSV0Fac1BFOHNlV2NLR25QNHIxSjdyOElFb0NG?=
 =?utf-8?B?RjlaZm5WMThxTG9wUldXV0U0VGh6ZERJTWJQaXRYV1dONzFhT0ZBcmY0VDNP?=
 =?utf-8?B?cTZYQVBnUExoNm43S1VtTkRYSFN3TmkzNjlIYTBSN0UvMFQwTUMwaitUSUxr?=
 =?utf-8?B?Ymkwb3puWHdqSWo5NjdrcUM0cFc3Z0pPOW04eWxvV1Jod3g5K2hGYUJCeE5H?=
 =?utf-8?B?OG5vR0pqaGtFNDdsdGdiZll2QTM3RFJrMU9nWXE3TmZDdldnMTRDZDVpYWx3?=
 =?utf-8?B?V0tXRDkyM0ZLdW0wV1dsc1RJQVo5YWNXUUNMWndZeitjalYzUlpDRWZmSUR3?=
 =?utf-8?B?WkRjUEQ1eVRyOWt2RHVBbkFndDQvbzkwL3JEdlVPUXBwY0RJcUNjRmFBWTlk?=
 =?utf-8?B?Q1FaYzU4L011SXZtTncxd3d0eHVyMm44L1VhV09qOFJadmZDSU0vd2hoSmFn?=
 =?utf-8?B?cjd2cktKbm00end2dTZyZGJrdUloUUN0RTZaejZQNGtTVExOSTVGUWdmOHZI?=
 =?utf-8?B?bW9WelZVVTBFNHJZTDRqZGt2bEdjUTByZ2dVNThRMEc4WUdZUm1QckZQTWxM?=
 =?utf-8?B?QVJQbFcwMU1SM29KQjdqdVVYM0JYYzhoRGwwYXQvYjZGQVFreStnV3dWYXpu?=
 =?utf-8?B?K3ZPSnh6dU1uWTh0SFhBbEQzWm5jbzA5NDJlQXJYNWJwL3FqdTZabUdib0NW?=
 =?utf-8?B?bHNxVjM3Yk92bXgwNUVOUUMya3llU0VUWnI1TDFTTjY5ODc4b3dkd0FWcnZI?=
 =?utf-8?B?cjhCdjA1OExrcG42eDJQWDkwTDBDb0JSVkt1WFpvNUtXakR0b1k1UUVzVmo0?=
 =?utf-8?B?MFlqaFFsTzRFc3R6S1FLYjB3S1RNOWFPaTBsR0tybG1zWHdSQ1FwMFNOWkpN?=
 =?utf-8?B?NEJwOWhha2duV2J2VGh4SGxHcFdtdnU4djJDNlg3aThUc0VEbzI2dlJsN1VK?=
 =?utf-8?B?dDAwaTBLS21yTlptRW5HNFRXREwxb09oWVBPY09GQkhib3VXTW0xUjVpYkdR?=
 =?utf-8?B?NCtydHFPSG9yTzZ4ejFibVdTOGpPdFdCVXc0dWJGT3MvVFNjSmNwK00rNVds?=
 =?utf-8?B?TFNRMjkxUXcrbW92MXBsQ0pDaFliNHd1dGtBdFZWQkdFdGlkQnZzRzJBSG9s?=
 =?utf-8?B?NktOUkRzMi94VlF4MnFXNFZEdDRFRFp0bnZnUlpTZU15aWhrdzJjaXU1dlhE?=
 =?utf-8?B?QkNDeFozVm52clNibmJhZDY0MWtobUdFSWhEekRyck1pRWtHdTg3TXJiNDJz?=
 =?utf-8?B?dEZEZkEyNCtoYWk2VEpFM09reEJhNm1abmx2am81MkZkUHF2MmNrUEZTOHFO?=
 =?utf-8?B?Mmp2eGdOV0REb0syU29CVlpNVGtPYjRKUHFwT0Nqc1hGS2tOTzdJY0NXcjNM?=
 =?utf-8?B?ZGNUQnFWUWVJNmIrU3hMTmQxVGFLeEY1Q0lTZnpVUFFoK0ZwRCtudmZJRUtS?=
 =?utf-8?Q?rnZgMyZOTWQekFU8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a65b7425-d04e-4680-3f5d-08da21345925
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 12:09:54.5381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FEKlab/RzEVxhQMNFocbkvSRmURtPrPZz0xBv5xiSs+T8qP61BEs+azPoCFWcKcdeI8v7PRtUmLn8bOCwzPg1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5085
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 2022/4/18 16:49, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, April 14, 2022 6:47 PM
>>
>> With the introduction of iommufd[1], the linux kernel provides a generic
>> interface for userspace drivers to propagate their DMA mappings to kernel
>> for assigned devices. This series does the porting of the VFIO devices
>> onto the /dev/iommu uapi and let it coexist with the legacy implementation.
>> Other devices like vpda, vfio mdev and etc. are not considered yet.
> 
> vfio mdev has no special support in Qemu. Just that it's not supported
> by iommufd yet thus can only be operated in legacy container interface at
> this point. Later once it's supported by the kernel suppose no additional
> enabling work is required for mdev in Qemu.

yes. will make it more precise in next version.

>>
>> For vfio devices, the new interface is tied with device fd and iommufd
>> as the iommufd solution is device-centric. This is different from legacy
>> vfio which is group-centric. To support both interfaces in QEMU, this
>> series introduces the iommu backend concept in the form of different
>> container classes. The existing vfio container is named legacy container
>> (equivalent with legacy iommu backend in this series), while the new
>> iommufd based container is named as iommufd container (may also be
>> mentioned
>> as iommufd backend in this series). The two backend types have their own
>> way to setup secure context and dma management interface. Below diagram
>> shows how it looks like with both BEs.
>>
>>                      VFIO                           AddressSpace/Memory
>>      +-------+  +----------+  +-----+  +-----+
>>      |  pci  |  | platform |  |  ap |  | ccw |
>>      +---+---+  +----+-----+  +--+--+  +--+--+     +----------------------+
>>          |           |           |        |        |   AddressSpace       |
>>          |           |           |        |        +------------+---------+
>>      +---V-----------V-----------V--------V----+               /
>>      |           VFIOAddressSpace              | <------------+
>>      |                  |                      |  MemoryListener
>>      |          VFIOContainer list             |
>>      +-------+----------------------------+----+
>>              |                            |
>>              |                            |
>>      +-------V------+            +--------V----------+
>>      |   iommufd    |            |    vfio legacy    |
>>      |  container   |            |     container     |
>>      +-------+------+            +--------+----------+
>>              |                            |
>>              | /dev/iommu                 | /dev/vfio/vfio
>>              | /dev/vfio/devices/vfioX    | /dev/vfio/$group_id
>>   Userspace  |                            |
>>
>> ===========+============================+=======================
>> =========
>>   Kernel     |  device fd                 |
>>              +---------------+            | group/container fd
>>              | (BIND_IOMMUFD |            | (SET_CONTAINER/SET_IOMMU)
>>              |  ATTACH_IOAS) |            | device fd
>>              |               |            |
>>              |       +-------V------------V-----------------+
>>      iommufd |       |                vfio                  |
>> (map/unmap  |       +---------+--------------------+-------+
>>   ioas_copy) |                 |                    | map/unmap
>>              |                 |                    |
>>       +------V------+    +-----V------+      +------V--------+
>>       | iommfd core |    |  device    |      |  vfio iommu   |
>>       +-------------+    +------------+      +---------------+
> 
> last row: s/iommfd/iommufd/

thanks. a typo.

> overall this sounds a reasonable abstraction. Later when vdpa starts
> supporting iommufd probably the iommufd BE will become even
> smaller with more logic shareable between vfio and vdpa.

let's see if Jason Wang will give some idea. :-)

>>
>> [Secure Context setup]
>> - iommufd BE: uses device fd and iommufd to setup secure context
>>                (bind_iommufd, attach_ioas)
>> - vfio legacy BE: uses group fd and container fd to setup secure context
>>                    (set_container, set_iommu)
>> [Device access]
>> - iommufd BE: device fd is opened through /dev/vfio/devices/vfioX
>> - vfio legacy BE: device fd is retrieved from group fd ioctl
>> [DMA Mapping flow]
>> - VFIOAddressSpace receives MemoryRegion add/del via MemoryListener
>> - VFIO populates DMA map/unmap via the container BEs
>>    *) iommufd BE: uses iommufd
>>    *) vfio legacy BE: uses container fd
>>
>> This series qomifies the VFIOContainer object which acts as a base class
> 
> what does 'qomify' mean? I didn't find this word from dictionary...
> 
>> for a container. This base class is derived into the legacy VFIO container
>> and the new iommufd based container. The base class implements generic
>> code
>> such as code related to memory_listener and address space management
>> whereas
>> the derived class implements callbacks that depend on the kernel user space
> 
> 'the kernel user space'?

aha, just want to express different BE callbacks will use different user 
interface exposed by kernel. will refine the wording.

> 
>> being used.
>>
>> The selection of the backend is made on a device basis using the new
>> iommufd option (on/off/auto). By default the iommufd backend is selected
>> if supported by the host and by QEMU (iommufd KConfig). This option is
>> currently available only for the vfio-pci device. For other types of
>> devices, it does not yet exist and the legacy BE is chosen by default.
>>
>> Test done:
>> - PCI and Platform device were tested
> 
> In this case PCI uses iommufd while platform device uses legacy?

For PCI, both legacy and iommufd were tested. The exploration kernel branch 
doesn't have the new device uapi for platform device, so I didn't test it.
But I remember Eric should have tested it with iommufd. Eric?

>> - ccw and ap were only compile-tested
>> - limited device hotplug test
>> - vIOMMU test run for both legacy and iommufd backends (limited tests)
>>
>> This series was co-developed by Eric Auger and me based on the exploration
>> iommufd kernel[2], complete code of this series is available in[3]. As
>> iommufd kernel is in the early step (only iommufd generic interface is in
>> mailing list), so this series hasn't made the iommufd backend fully on par
>> with legacy backend w.r.t. features like p2p mappings, coherency tracking,
> 
> what does 'coherency tracking' mean here? if related to iommu enforce
> snoop it is fully handled by the kernel so far. I didn't find any use of
> VFIO_DMA_CC_IOMMU in current Qemu.

It's the kvm_group add/del stuffs.perhaps say kvm_group add/del equivalence
would be better?

>> live migration, etc. This series hasn't supported PCI devices without FLR
>> neither as the kernel doesn't support VFIO_DEVICE_PCI_HOT_RESET when
>> userspace
>> is using iommufd. The kernel needs to be updated to accept device fd list for
>> reset when userspace is using iommufd. Related work is in progress by
>> Jason[4].
>>
>> TODOs:
>> - Add DMA alias check for iommufd BE (group level)
>> - Make pci.c to be BE agnostic. Needs kernel change as well to fix the
>>    VFIO_DEVICE_PCI_HOT_RESET gap
>> - Cleanup the VFIODevice fields as it's used in both BEs
>> - Add locks
>> - Replace list with g_tree
>> - More tests
>>
>> Patch Overview:
>>
>> - Preparation:
>>    0001-scripts-update-linux-headers-Add-iommufd.h.patch
>>    0002-linux-headers-Import-latest-vfio.h-and-iommufd.h.patch
>>    0003-hw-vfio-pci-fix-vfio_pci_hot_reset_result-trace-poin.patch
>>    0004-vfio-pci-Use-vbasedev-local-variable-in-vfio_realize.patch
>>    0005-vfio-common-Rename-VFIOGuestIOMMU-iommu-into-
>> iommu_m.patch
> 
> 3-5 are pure cleanups which could be sent out separately

yes. may send later after checking with Eric. :-)

>>    0006-vfio-common-Split-common.c-into-common.c-container.c.patch
>>
>> - Introduce container object and covert existing vfio to use it:
>>    0007-vfio-Add-base-object-for-VFIOContainer.patch
>>    0008-vfio-container-Introduce-vfio_attach-detach_device.patch
>>    0009-vfio-platform-Use-vfio_-attach-detach-_device.patch
>>    0010-vfio-ap-Use-vfio_-attach-detach-_device.patch
>>    0011-vfio-ccw-Use-vfio_-attach-detach-_device.patch
>>    0012-vfio-container-obj-Introduce-attach-detach-_device-c.patch
>>    0013-vfio-container-obj-Introduce-VFIOContainer-reset-cal.patch
>>
>> - Introduce iommufd based container:
>>    0014-hw-iommufd-Creation.patch
>>    0015-vfio-iommufd-Implement-iommufd-backend.patch
>>    0016-vfio-iommufd-Add-IOAS_COPY_DMA-support.patch
>>
>> - Add backend selection for vfio-pci:
>>    0017-vfio-as-Allow-the-selection-of-a-given-iommu-backend.patch
>>    0018-vfio-pci-Add-an-iommufd-option.patch
>>
>> [1] https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-
>> iommufd_jgg@nvidia.com/
>> [2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
>> [3] https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1
>> [4] https://lore.kernel.org/kvm/0-v1-a8faf768d202+125dd-
>> vfio_mdev_no_group_jgg@nvidia.com/
> 
> Following is probably more relevant to [4]:
> 
> https://lore.kernel.org/all/10-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com/

absolutely.:-) thanks.

> Thanks
> Kevin

-- 
Regards,
Yi Liu
