Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED52454A8C5
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 07:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbiFNFaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 01:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiFNFaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 01:30:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A426027B22;
        Mon, 13 Jun 2022 22:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655184622; x=1686720622;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O1Wb8ePXWpXMuoIgKifbEicg03OyVOaC4aut2X4nCwU=;
  b=Y4UCW8xu+XaCT3TMUcnAZCpgqRMxg0XjbTu7ZA1Yy+U4ZsdRgCFJmGqs
   e2uMTnZRJg15iPj/dqCVE5beqgvGHa761acX/pex1xpIli2h0Io5zlCH5
   wReqhGe7gLL7NgTRkAVKshih0ZdqkhzEmHxyuRxaJlrzcwBFoN9OgAaFV
   07baEQh24z51XMI/ep3mpoaMy0yJjUid4C8WYFRH0qoWfQvvnuy7iVckZ
   NyGWv9OCr3cUa/WDA67PT5UiiZSgg4j215hFR1mDweTdEPKWVnqw8MP1b
   zMaIxhTvoXtoGKF3/PObVD66krTyBot5u/COB1QVrrEZMlVjG3uS1Ne2k
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="279228831"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="279228831"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 22:30:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="686468790"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jun 2022 22:30:20 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 22:30:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 22:30:20 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 22:30:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgdshhEJelmujZRB/eW0z13gnr3WOiCdbq33wlIFuMhkEqJKH3Q5kcxhapxgwmrjSDRI+EFp/x6ES3TDuBrU7d40CtesqV5/BXI/dClHZDKqnLpVhzgk5e8EYyx1LxKHuk1jxHo0DZ8h5mSv0WKG4XlUtg98szeDn9Sz7NsjV3ekr/YBzjDO6yoYNM82jxFSUJUB79j4UuLMxADyxeUFhingweSlH6LFtUYQPPXIYppYIijc5/+twyPyKuHVkeDuJ4Qevyh8eLyK9/7kqBj6Q60214LxDoXM4D6Ex+q9wnSR21E/RNsFk+Bx0YWfbPH8eQrINTFpPhrN/M1AdZJ1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WK2qK4/YkT+w8beoAl1gwoiuAE8wzljSywQ2ox84HiU=;
 b=gbRHyEv7T5p6vVzfCWqCqHs9EOdomMtAhewrd1lkvKKzWdwvjAqLy63L3ACMVyKFNYe3mdeILAl2uxkqHsDDW9IRf8JqV36NI4tq9o3GA15GljidEM9pN+9Yfyr37gXD8jqtsuMCmYOG3kg/zxigw3rQ2Ty774TgMK7PgAVRvPOJ7TbSCYvq21eeWSSzD9bOoIPp4OAsDhfXkMlyZUUZGePIjYQmwCsMr0ZXzi+g8GHD9cnSZDrmc7kPj2rOn12nsQvzCS55Xbw4QEKbhJ7ukptazYrc/8X7I0Dbur73S+cPtRke4zlhYsmHETrP1wRiPpozRWgLrH1cG+/+DMv3zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by DM6PR11MB2652.namprd11.prod.outlook.com (2603:10b6:5:c7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Tue, 14 Jun
 2022 05:30:18 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6%7]) with mapi id 15.20.5314.019; Tue, 14 Jun 2022
 05:30:18 +0000
Message-ID: <168474bd-579e-a895-31e2-00d855d718de@intel.com>
Date:   Tue, 14 Jun 2022 13:30:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: simplify the mdev interface v2
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>
References: <20220614045428.278494-1-hch@lst.de>
 <0e517684-8b10-5410-8ad0-df7caed860b7@intel.com>
 <20220614051723.GA30556@lst.de>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220614051723.GA30556@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0144.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::24) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3088213c-b779-4f5f-1f36-08da4dc6f784
X-MS-TrafficTypeDiagnostic: DM6PR11MB2652:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB2652F17E9E018E83716710B4C3AA9@DM6PR11MB2652.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p6qgIwsSiV/Z5NE9Cj1Fl9A9neEBvvo5bKisxGYGIrUXLqbH+YLvNyAuTk29/eztG+vwOhM9BjSCXW4pb+LkJVsfRfzue/nDYmASCEfTZ1rK48l8TFvZtX240YU9wFyHSkpt3cK7eHyenSt22w+2SsHrEHKascqlMnL/C7XdbNQ7l5BXhfN9sEB8s+CvBY5pmCIJVyyTJWc8+vehuyONOIm0KOV4OfohZJlmej8njt0CjcP/gaVXfDoznG9OHcgF3BbXW/5zR02HLvRb0/mWba96U5mT6bzjBDUCpZmLFrl73HOy9LAav0LQ8BxDuKM+NBkD9HFXWjHFsxupbDCdRM1TRuJWhPFWoqkk3cfX7zD0lK7nx1aPmRnNO8wcUrEMXeAHaxzbWqAsY+ennc5ow10NWuaQOsMKcMlguohQzIr/3KSbeJyUpIchueB8BCkU+8WeVwsUlUfHs/eq7dfTy+petqqCgW+0inXGEDC6CeDZgH2GN4QvCQY9nk1YonZNqB03Pn74av0exNHVoN910fBn9ZVCAnkBbHjJ+vWM6Vj6QfJxGDyhv8cuOLRiEot8uC7g9yTO8wvVIUdM4paBboD+4814k2FxizhS55px7ZwtpKIolMICLoddkOkQVg0fO+s5vRKS+d++CWX+a8mw8z0SxyupINhgZuBD51U2ysSknAdwhSxt1pShbMAbS1oxAePQxR5T6WBquGjhB2xdt0nv1hSS9BMGJjPAV3SWG+dQ+XG7VQZCvQLNB69x/5yG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(54906003)(6916009)(316002)(4326008)(86362001)(66946007)(2616005)(66476007)(8676002)(31696002)(6666004)(38100700002)(66556008)(26005)(6512007)(6506007)(53546011)(5660300002)(6486002)(82960400001)(36756003)(508600001)(4744005)(2906002)(186003)(8936002)(31686004)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUNONFFhZzNTeldlWHVONXpzVE15Y0hrcjdacXJBRFZWSnVoZklkcnV4U3gz?=
 =?utf-8?B?cEI4WU5YZWIvVWx2MlBUd2d1WGVhZ1BnK3BWV0tuNEJRY1g3VUdOZHBkYkVO?=
 =?utf-8?B?cTROVmRnUHVQcW9NSC9nK0tZSHp1V2dGSXZWdVhLbmRuc1orUUtybndmRUZk?=
 =?utf-8?B?a0JDMnR4Q2NyMWdMODhMbTczbkFZbmdGLy9TcTkrWFF2YTdzc2p0dWNxRkdv?=
 =?utf-8?B?eHdWL0JVYVdCZE5aM2R3YmNDb29NMytZaU9TMnkySUVSeXRCVnJXcG1DV0lm?=
 =?utf-8?B?ckZ0ZzZ3d0lWdnlPR3QwakJwUGJ5eGlqNm1aazVrVU5mVm1aNENLQjlSR0ps?=
 =?utf-8?B?Tm9JWG1abkJzRHk0NTFUVkZVK1NBNGEyME96ajdyZ1E1VTEzRFAvTFplMTFE?=
 =?utf-8?B?dFp6V0J3M0ZHTXhNaFVJVU1nWmN1UlBaU2k1QXVZNEFwTUpyYlBmS2dCQlZI?=
 =?utf-8?B?ZC9TZjRFYlNoQzU1SkxZYWNPT05xVVA1eW5JL1BzNkNJZXFuR0wwV2NIZ3Uz?=
 =?utf-8?B?UVErd3VCUkdnSWplTnFYc2RLVEZERHR0SVdsOGplV3VwRFBsUTlJYy9VSkxl?=
 =?utf-8?B?SjgrZE4wdXZQM2ZEdys1ZHVVWEd4cFlELzFRZERkMWtnMlNOWVU3T255U1VH?=
 =?utf-8?B?WVpYYWQzM1hyaGRjN0xoamw3YURBZFJIdS9yMDczVEt2cVJEdEpuck9XVmx0?=
 =?utf-8?B?akJHL2dMQkhMZTgydndnNm01eTFmOGdUNWdHUGlGUXhOMUhicmZWU2cwWUxT?=
 =?utf-8?B?dEhTd294Z2FTeXQvR0F6RFdtWTI1NHJCa1FUN0JBcnJYSE5jQ0YwZDRTTGZu?=
 =?utf-8?B?ZWR2eVJlblp6OGpnYW5UbHpkSkJhZ1BGaGFObW1pVlU2S0w5US9kZS90R2V5?=
 =?utf-8?B?Z1MyY3BMbDNTeUJ6bXpxOCtlQVFFdzJEZWUyeE50L2FLYWJoMnlBT1Eyemdi?=
 =?utf-8?B?WHl5K1JYZVd4M0wxQlpXdUdRQWd3RTNWNVRxeDRKRlAyVVBNdisyejFEMk9n?=
 =?utf-8?B?Q1NDcSt4eDhQeWRmTXN5VWswa1lDbTlXRnZ0Z0hIQm13N3dodjhmQUtlVlFF?=
 =?utf-8?B?UVE3bE9nb3BveUVqZy9RZStRMHNJbWl6QldWMzljQnN2S2kzMFYydFhHbVNt?=
 =?utf-8?B?UTdDNVlwQ2JBK1dDQ3dvUERabWhxTFk5UXZPZTN0Y00yd1Rib2E4M3NYVktP?=
 =?utf-8?B?bkp3bG04U3dSRk1jSzZGWDIvTWJFdHI2ODhuWUc1S29PUDFZSnUzTUpDRzVX?=
 =?utf-8?B?NWo3amNJbGw0UkpxR1BFWk50Y0pGS2hmTVQxb280dnR3V3QvYzNhVisxamdH?=
 =?utf-8?B?Y3hpakFKTFJydmZkc3piVkRaZVZFbFdvb2ZkUUprU1J3NDFxUkY3T3Q2V0w1?=
 =?utf-8?B?V0tXUDVLdHVFTDBNWFh0N0tJZmRJK0thZ0xRY2ZEOFRyc3paUnVLT1RSNFJH?=
 =?utf-8?B?anQ3dFdnL3NVbGVScld2ZGpDSFp2VENhR3N0ei9jZ2prbGlQOVVWdHZQOTBJ?=
 =?utf-8?B?N0FPNGU1cFdTNXhOR0NQaytURlJhc1ZjeERYK2VTV1RYZVpOSmN6OUFBZ0hw?=
 =?utf-8?B?bHQ5ZzZFOUhlL0oxTXdRSW5oMnFWaW52N2FmVGxnTlA2UzRjVmxvOVZKazhm?=
 =?utf-8?B?TlFrK2JPb2RDNUZFdWJCZXlYblBQUmNlaGpBU3RJdmhmTFB5Y3AxMVZYdE9P?=
 =?utf-8?B?UVZnWFlaRTc5dE9ORHBZVk5pM0Z6RWIvbGVad2FZRUc1aXJQRjB0KzlaRjl5?=
 =?utf-8?B?WUdlVm9sSWtJd2xJNkZpcGx2b20yMkwvSTlTeDlTZFVuZWR0elVNOUE0LzUr?=
 =?utf-8?B?ejZHODQvLzIxd0g1VytqMk1jenYzZG1JajlRTk5Fc2dzOUVEanVJczBRYzNj?=
 =?utf-8?B?ZXlFdmk4SFdTVzc2RlM2YjhHdG0xWU4xRVgyYmI5WGNFRDBJTGhIWXRVd3pI?=
 =?utf-8?B?NjJsbm9Vcjg4RElrQ3FZVTNUdEhjU2hXYkI1VFZFK0lNOXhCSWRwaTU3L3E1?=
 =?utf-8?B?bll6OGt1amkwb1hvTHRvTE41b0Y4MnM3RnVaNnBiU2JuUEVuOTBCK2dQTThJ?=
 =?utf-8?B?UTJzWFY1cGswUHdnUUZyOTlNL2Qrb2JhUUxZOG8vMGlETTBNYVFRUWZtWkdq?=
 =?utf-8?B?MFpMaEpUdHFwVGYrZUdSeUpBejFXUGdvMnZjOG5EQ0d4MTFXNC9wT3dwUkNK?=
 =?utf-8?B?UVErK0FjVFoxeVYxc0twVkxlWll4UUdFUHZNWFhTVTZhZ1p5eDlZazVHVW5k?=
 =?utf-8?B?OGxobjlDaXV4UEtDUzJoTENTckVaVDRSVVNoelZWQzhEWFZScFRISkZRR1NP?=
 =?utf-8?B?M2RaN2gwNlkyTEZvQ2RMdDM5ZDNTazdzNkdKdUFGcWdkNDdvenlqcHY1dE9T?=
 =?utf-8?Q?NbNXX1kwYqwwBgRk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3088213c-b779-4f5f-1f36-08da4dc6f784
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 05:30:18.0858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DvcoJfxFfVBTGNfiiOvpo/nbhQHhr6G9jW0AG50TOHibVQQQT1Rb2+PdDgYRot/qoojIjvh5xInq+QxCgFRnUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2652
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/14 13:17, Christoph Hellwig wrote:
> On Tue, Jun 14, 2022 at 01:03:55PM +0800, Yi Liu wrote:
>> Is this series available on any github repo? I'd like to apply your series
>> and apply my vfio_device cdev series on top of it.
> 
> I have a git repository available, but nothing on crappy platforms like
> github.

haha, could you share me your git repo? :-)

-- 
Regards,
Yi Liu
