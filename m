Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00022660279
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 15:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjAFOs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 09:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjAFOsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 09:48:25 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF7E1E3FE
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 06:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673016504; x=1704552504;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LwUdgdVts8p6r/LOUSyuDtLp2SvTkW0qYYKzXxaGo1g=;
  b=Vr8vBTGpmTvxR8REQnNIYsvwrnfKUwhnvk9Sk2E8RlxypZV7uZ95g8ZS
   ckVR87uLsrOwIvsI5+IdwyqWBJnVz/fiHzMZQO6jOfwBOyKqbRZEiUtFK
   XFEPnRLv1Army0oCl6SZQ4Vd6s5Zu3To2BTdX/feU3kKekgO3B9RN2Dpc
   MVS3phKftN7bWczYbgyDokv2IykFCV1N6Cpuz7f3IAxSoEJ+1m3Af/YSR
   RR9C2G/vMCgK8YPbNHpEx/Q1OeJEGOl+wuI7ho0AgJ3FB3c7PVMBljwdQ
   rIWOduZTWaGpimBxFRQsDtqqeZpXOKtTLLxmEyHa7aDMtLKDrKtBAwjoM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="322558717"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="322558717"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 06:48:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="657907791"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="657907791"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jan 2023 06:48:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 06:48:21 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 06:48:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 06:48:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVDtI1Y4Y11RDMrkwiyO6szI3GlZm0lA4JS6g90/tPpDT2BUwQ5fh1+HZJk9SojCi99a663mMHs/2qDynprjVM5TUmWGHFcMJfR8qe1AhbkCF0505DDLFMJ0onX8VGfvkC+0v6F8qidEFKHJpbRyKxpjJwNqBQHkMWDiA0zgzkj1U2Kl/F0kv7S6zxDUzcHqyW1yoVUxvIR2MX6Xk4Wt8hQtLxmSG0OLH8NyCxVjX27Iui0zoNLikYopOEC26o4uKbeYLP3Ff23XityfZHyvSHgprbKkrpSzsxbwubFT3VrtBYeqeg2eghTOf8KaxX+a0kcYfiWSX8+2oB/SSvtE4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wixAlzQNBQZf3KzCBwrYBExs8Gph0r7D2ip1ouk6Xbs=;
 b=JLsqGcHWYP/oNvaVSVW9PiII8c3aUk+2H3Pl52bC95Gd6LAtSx/8xgK1QFr/bJwdUsWiNOfNaFMg8M5yVBHHEqAK86XGK+RMfR8vfLfj/msTgJnYxG4xXdfaYi/G21bRK+LJk54wN27XMUkDYH3gNS14WZj6SU3op0Pt1jzKbrHbCPtak9Wc9SvVU4um7eAzbov57ai2iM657/QOgwrsyhmcz3txYymDF6tcCXs1u9V6nsMz6tLc6M/gDCMZBNTkHCVc9w8KZya88/gZjnF+d78GpqXtn9eat64w7Jvup7iOXyRVRtjP6hFzyXE7HV5nDUunh5uO20FDoMQVjbiuyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB8062.namprd11.prod.outlook.com (2603:10b6:510:251::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 14:48:18 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 14:48:18 +0000
Message-ID: <6af126f0-8344-f03a-6a45-9cdd877e4bcd@intel.com>
Date:   Fri, 6 Jan 2023 22:46:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
        <cohuck@redhat.com>, <eric.auger@redhat.com>,
        <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
        <mjrosato@linux.ibm.com>, <chao.p.peng@linux.intel.com>,
        <yi.y.sun@linux.intel.com>, <peterx@redhat.com>,
        <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-6-yi.l.liu@intel.com> <Y7gxC/am09Cr885J@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <Y7gxC/am09Cr885J@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH8PR11MB8062:EE_
X-MS-Office365-Filtering-Correlation-Id: 0590dc41-e06e-46db-f3e0-08daeff50c98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5unoMtRK5lZhASab7skccijzr1JvhltKQnwv9oqIMHOdeMysm4l4HlpuG3Os14ZZQJQkHYcQAMacOlLg89AY2kdyRGmqUENLByFazH/MrROZYdMRN3/nxweM6DbHwYq7xtzWUHGiA/B+q5onyfjTooyvzs6/dmAzRI+s7+4unUnWaWbVgPKnOFvHFTVXZgalIa9KNtX6PBLtc3H2vfp8o2rnF/0TohKnV0H8t9GYLcJ3fS0ytpb8QP5YS4TuJH7iz3dfSuoBNuk0dwZF5ssLszIrz7kXR9CPrh+pFM3iJvyXyTB0yVTJhw/UCqEtlp9ka1v+rqNeGCqrnwnoFuDwOMTMSLjBwqMN2gYJxeVH01oitmKx0TazMAomeruNKTjqZlbabQaMbPE2Pcph/KoZ11BE5wzKdmmS25fFG/uMjJ1914Y1CkIfZyU1dDTJVjLfAGslHJhHrYW13smf/Ex2/0G/x9rj9GyEUcjuhTL4NBGAljZw/iwAlCdE33Sw5L/pfFkDaIg8ImXSj+o+hpcQhnLFPqeY81UJfWDTlmtkZ0RAyC+UulzLj4XW1ovQU32Gsuhq8aqeadyajGfQyBGvi30vBXtfUBVUWXWS32Y1C1SeiEtiveRtrH2ZlMLfOkCyG72I7Xl4riqS8d2slLea7VHHehD4ByWoqvENzvfVkKEMsqMrctZJMobr34PI6nUH8fXOpjKVPtvlgSCchzPKorQmv7/Y7eW+gDDXXBBrQEM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199015)(83380400001)(186003)(26005)(2616005)(53546011)(6506007)(82960400001)(86362001)(36756003)(31696002)(38100700002)(6666004)(8676002)(31686004)(4326008)(41300700001)(7416002)(4744005)(2906002)(5660300002)(8936002)(66556008)(6512007)(66476007)(6486002)(66946007)(316002)(478600001)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzlHdnIyQjNsL0hmQ0svM1ZraTZYeC9PUThOamtBUXo2R1hDSFQyNGxCNHJx?=
 =?utf-8?B?VVIwdWZZS3d4UE1uamdXSTB2YVdIV3QvSHhsa2Jib2VJamFTcWJud2ZNNzdT?=
 =?utf-8?B?d3VSUm1UZE9vZmdvcWF2clk0Z24rN3dTc05MWXBwRVRiZk1acHBweDFmOHhL?=
 =?utf-8?B?Y2hXRjEreEtPWE5nbWt4bVNrN3lpR2JZd3ppU1JpRkkwTXBwR1lna1NzU3ZY?=
 =?utf-8?B?Nm5CcFJJU0krSFFpKy9uQUw3MUtZc3h3VEtRQllFZWpTa1RBRzBockRCeXNz?=
 =?utf-8?B?RXFQK3ZlRkswTzBvcFZPYmZPaXZZVktoakpFbVZNRW54N0VTazZjT0V3aGdJ?=
 =?utf-8?B?ODlKSHhzb1dFZGp1R0Vkc1ZwdXRRUXMrSzZ1bDFJVTBkRmU5eUlRZmZFUFRC?=
 =?utf-8?B?aEwwZ3l6eHdaVHplWFJBamJwODY2eEZEMFgxeXhjaXJjZjhsZTFUUGhicDBp?=
 =?utf-8?B?N2tEc3pOK2ZsMms2bXRHQzlVbG9tblpKTjhpS29iZGlSdEN5c1F0cmVXU09q?=
 =?utf-8?B?cVd1Zi91VldVK0FFZzAvZ2Y1bkVpZmsrcjZwZUlOVTI3d0hlWVJnSVl4MmFE?=
 =?utf-8?B?WHVRc0tHaHM2V3lhNHR1RXdjZmI1VWxFaDc1NitXOHpKS04rN1RuUTR6Ri9P?=
 =?utf-8?B?YU5Jamc0cjA0eUg5NVNuYWc1QjBhUFluMmExc3pzVU0vaG9ON1FlUUdpVjNF?=
 =?utf-8?B?ZUVPYUhEMkY1TzNQK0tRVnBSck80OHpGTzFsOGp0bUZiV29XK1phVVZDZWRi?=
 =?utf-8?B?NGRaRVhTRitYdEF6MEQ0ZDNSZG5iR3NTUHNsbU9PQ1YyS2JaV2ZSczBPVTJK?=
 =?utf-8?B?V2hlUFhXM2NBbjJncHI1dFVtbDJoWHlQZHY2S0drNWIvNW1DTThsZHhzMURZ?=
 =?utf-8?B?aXhsWFZMM2RZUDBpaFlpWHA0eXB2a0VCQ082aEhpZ1NQYzh5TGJGVHloUkFy?=
 =?utf-8?B?N1M4SmJUU3h1TWhyQVVwakNOU2ZKc1VSV2hFeUZUZVl1NXFwOXN6WElzamtJ?=
 =?utf-8?B?dWdUbWtWMEZ4TVgwcVRIbHFOVTZ0WVc2cmt1VHE0OWdySklXWm1SZG03SUNF?=
 =?utf-8?B?ZzBkdEZLc3RqUnRld2RCV2xla2I4REVMVWt1MThFZ3R4TU4xZmlyVXdNYmhS?=
 =?utf-8?B?VnZMMGx4VjdXKzJiN0Qzc2tQam5PQzF1eTBwNjNTT0pEeVhGaDJxWVBWZW9m?=
 =?utf-8?B?QkFLWUNpNFpyVmtrSXQ4bjZkMXh3UWVzaFp2bSthTmRGWFhDQjBUSHphUGh2?=
 =?utf-8?B?R2FEMFlnSGkrVUM0UlljL3JFZDBkR0wxUGJKNWxqVTBMVjhTei81VEZnM0V2?=
 =?utf-8?B?TUdsbHNYYUVRZUZodDJtRHA2TDUrWW1kNFdKa01VZHJtRHVFdklSbW1VTHIy?=
 =?utf-8?B?SnJhclhlaGRVV2Z2RngxTGdhQWxFcE9iK2RYRG1pUHpheWE0RjZqNDJjNHpp?=
 =?utf-8?B?cjZueCs5Zi9tNk5TdWRlcW5xN2Y2dGQyM05KV1Z4MncySjJMTnp5ejBudVZq?=
 =?utf-8?B?WVVtenI0YVd6RkZTWkFWQmJKbGpwTEJ2NEFHR0NvcmcvVTdDSGswZjBCRjRK?=
 =?utf-8?B?eFlnOVo3RU9jc2tjaVd6cmlnVUFNdHdHVE50eXpXY0l2VzhlajRjUFhCend0?=
 =?utf-8?B?ZkQ3OUQ4NEdRY3V4dXhpdTBiUTRrcUJ1MXR1SEpLZk9JK3ErR2lWQnVoNkhQ?=
 =?utf-8?B?YkVpVmNORk0vZFVNaHI5ZDNjWEd6S3AzWnI4SFVOdHJ5QUpGVnZuSVZZUGRX?=
 =?utf-8?B?aVFRM3NHUXc0RExHVnI0ZzNNc3cwdklsTldwWGFFM1lXVGlReWk1SzBkMXYz?=
 =?utf-8?B?L0xCb3c3aHhUcU5jTHdudUJEUkVhNlJGNEVaQ1h1SXpHbUN4cEpxbmlFUGp2?=
 =?utf-8?B?OUsyU3ZFc3YvVDlRY242SFdFa3FjbjRadkFrbGUwZCt4TVNiWkR0WGFZOGsr?=
 =?utf-8?B?RTQ0aW1iZGUzamlDelVJejFWaUg1eVZIMW9hVnduMU1xT1ZKK0diL3FjakF0?=
 =?utf-8?B?RWpIRUZuRTJabGhCaWg0aDBZTGVZMkhrMUYveHIvOFV3V2VnZkhrUm9EYzZP?=
 =?utf-8?B?RmtidVpWeWEyWnQ4Qi9waW1wS1pxQmdNWXZjOXJtd3ZXRElrcHRVV0pUTkZ4?=
 =?utf-8?Q?8wwWGcKZe3mZAM+C0/kL/y70g?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0590dc41-e06e-46db-f3e0-08daeff50c98
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 14:48:18.7003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPcn4vibHCq3y7+NbK6uDEPYF7GNg7FKHROEnnbQ345TArc9904+TQnFq9nXWbf4G/BY4ppcQmEG2Hf/ZWjyZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8062
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/1/6 22:32, Jason Gunthorpe wrote:
> On Mon, Dec 19, 2022 at 12:47:11AM -0800, Yi Liu wrote:
>> This defines KVM_DEV_VFIO_FILE* and make alias with KVM_DEV_VFIO_GROUP*.
>> Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
> 
> Do we have a circular refcount problem with this plan?
> 
> The kvm will hold a ref on the vfio device struct file
> 
> Once the vfio device struct file reaches open_device we will hold a
> ref on the kvm
> 
> At this point if both kvm and vfio device FDs are closed will the
> kernel clean it up or does it leak because they both ref each other?

looks to be a circular. In my past test, seems no apparent issue. But
I'll do a test to confirm it. If this is a problem, it should be an
existing issue. right? Should have same issue with group file.

> Please test to confirm..

will do.

-- 
Regards,
Yi Liu
