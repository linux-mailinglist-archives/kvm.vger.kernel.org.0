Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFB1623AFC
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 05:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiKJEdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 23:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKJEdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 23:33:02 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8911EC7A
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 20:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668054781; x=1699590781;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ik+bd4NDhR1yaj0c6u6JILWQTLANITZ+rcnec08UxXM=;
  b=BVHzsqJgvpvvO3T3RtK9dhk4C6uLjXlkFKiT6IPBYmThG4eHSiZcoyNd
   U6Q7GJJE8u0yWR3Ygiqs6wAOcAzCiPQtmoRGiG+wg2vrgMh6YUqkZR+EC
   E+0nJjRxar9Jt8Gpsv5v6WIXpH2NiO5xX9/BDWTY0iS8cdwdoAQ6bIjeZ
   Ltad45nrt4suITxYGhOKP0JEC1IIVI6CSLIE32MlwAH5kmjMVx45DgJeP
   D1GBXNQUOwXwMw61XUsmXPh2Yv04sPSHfx1ni/qpXt29nwGx/C017QE+O
   1G8l1wN7WZ9pQkj34jB6fSueSq/d84UdLdkdB4kN/1Aob2Xzzh1Mn1adv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="373324205"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="373324205"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 20:33:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="639466337"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="639466337"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 09 Nov 2022 20:33:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 20:32:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 20:32:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 20:32:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTgWx77sUkPPaS3YQEc2OoxIQPKDijr5ndB5kSRg9IcaGQdoy0+kkhfx1191oi+pvi6UWz5+At5I/Kn/2B2jL9EEmhKqJ87i94VVOcG/pVhu4f+vFHrLpNMIRLDWjKoXsgqcxbfncRU3fE+pOTfaHPpuhyc+FZsTpTf7m8s9MzrPTw/XEIs7GyvhhDLXSJH2dwuMXeSsOxEv5qv+s2Hneydb1wgXWuKF5/cACikiVbT54ZZQOXSyvj1v3HzZdi4YBcfVSdYnlF+LZjcoIFZjWhv6mewh148KJmraiMf/hM+R6e1ZfyLn+dV89kqISKu7ZuOWFNZc6gXBo/LeDWUWVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOqni16ioIH+d37MBBcZePrFUt36I7BsHZLEnUVcUN0=;
 b=DXGbHFxX0jLd8tzEKOMni5SgjC9wVM3XeC6FBlTB7gTcT6otH4jkMkMJdmOdEm+38ZGgHUfehRN6pmQ33yZnXjzFozoWxfC5kev9NlOsra1aInl/PL/0F5Z7nfb1zyXC60rN4rUlaVEmzBY9d/T5BHHxnvg/I3kgvV50hkb5ALxxN8uzYD8GhQlIoq9x6g0OjZiQI/wJMlWUrCkGfgiJQB9hxqqES8v9VGToja1tFBL9jXcL36naeWfRk/ImoZUTN38q4YIAL89ofmB6xGMuSL7tTqR2thhfQgMs5h+0z7XyzCGIzDDg5gRVC3nQ/MjeU1yLs0cOp+kzUpasyD517A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5474.namprd11.prod.outlook.com (2603:10b6:610:d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 04:32:55 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ad39:e00a:a7cb:4ada]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ad39:e00a:a7cb:4ada%7]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 04:32:55 +0000
Message-ID: <94ddb1f0-7a6a-3acd-7008-511512041dab@intel.com>
Date:   Thu, 10 Nov 2022 12:33:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v6 3/3] vfio/pci: Check the device set open count on reset
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Anthony DeRossi <ajderossi@gmail.com>, <kvm@vger.kernel.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <abhsahu@nvidia.com>, <yishaih@nvidia.com>
References: <20221110014027.28780-1-ajderossi@gmail.com>
 <20221110014027.28780-4-ajderossi@gmail.com>
 <49b64e4b-43b9-ec7b-23d2-2fa1bf921046@intel.com>
 <20221109211715.7cdacf3d.alex.williamson@redhat.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221109211715.7cdacf3d.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::34)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH0PR11MB5474:EE_
X-MS-Office365-Filtering-Correlation-Id: ff67ba93-f95c-4b14-65e6-08dac2d4a2da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gk6vbJ/+bZzlkbgxSFwFNDXd2w2FS/ZRJQtN7RNQcp/WfSVsgWjVGBFt6FhYozheBnu8c2pO7EuEZfgfIZaW9U9b4EKkvogKddcMVLZS5Ko5tdz4+BIaDOiuqNf6oqYimRQSBiDy63NzducRNAJw5Yb4w5WRxrBOFx3oyXAogK1Z6ycEmkDUt7ysobGCGbhQ0Y11yim89jeMXkEYg+6huGW/FlyGB+wtQHJLv3v6vYJ1ZPZpmTFXJ+6STcf7xQoHmyVpOa0QCNa78STWk27NtCYX8qMvVJJQ4a0Xx4NZIVxxd2WNXN19aTk1mzPoedtXtj8hM7QArwfjJUUIe7GLZNNUHP/aroGV4+U3+v0ESeqVhIxyYefIUlPOJ8ibAhr5Jdimc1jc2R3I9B5RhAxWwBoUgSZ6LW19YsnKF3WVrRYoYg/lHmvxk8nC5D6m+XairZo3UNfTLHT/WKybPH/pBsYjEhHdEexk57pDXnWV4MB4rb0f9Mk4wRsXKyRCAIsqb/u/jeuqp43v4yhFYO9Mb+DuHwWoj1IyUNHperjNwhdnb73dPDhvFwt5DBIYdk8p73IayWSoL7dS8SOO1EQgIQlicRy3I3uoshPeODEVmqwgikarFOnyyx8/dglXqJJBu/QhIA79Qmin23EwTqz0pdrhXtAqdGbOkqXNVhBijVObrLpJgsCpp4Hdkk9aDZs+3g9GFnam7s2kmqvuqLsjeufsrQJACV8ciOoAjQapz4IM1YVkTUgbs1V5ojpW3/hNvWlqaGHLEy7R3seoKd1x3euw1h+va4hruCrwb80lOvwAtx4wbqImsfDNTjmlImujnG/+9gKtRItVvTTEfZDXDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199015)(316002)(6666004)(6916009)(6512007)(2616005)(8936002)(4326008)(26005)(5660300002)(41300700001)(2906002)(36756003)(186003)(66556008)(6506007)(8676002)(66946007)(31696002)(86362001)(66476007)(83380400001)(53546011)(31686004)(38100700002)(478600001)(966005)(82960400001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0FiQzF1UkZnSWNNVTBVa0dzTnAvMEMxVTNZb0hRRGNjU1Z3OWhlN1RseE9t?=
 =?utf-8?B?azd6Szk5SkoyZTl4Qnlpc3p2OUhMSUd4S1RIeXNKTUdSZmd0QXJJd1FleXA4?=
 =?utf-8?B?c25YQ3lwOTlJUjZqR2t4ZFNjNUMzUUZtdjJuallGSkF5VTdVdHdoVTl6bkQ1?=
 =?utf-8?B?MXdXd1BubWJYY0ZRb1ljdUdLK2NMMWpGZFJJRnFFNmxJMERQd0NVREpkaUxJ?=
 =?utf-8?B?RHdCZlNpNW1yeTJIWDBiNFlGcGEvaWN4N0w4SHg1YVpUNWVwenlvaUlrNEJa?=
 =?utf-8?B?ZmZGck9BaVkwclFDdE9WVUpNQjZVL2JEYlJ6TlhiQWFkNFVibHNibDl2VElS?=
 =?utf-8?B?Y0N0KzZ0NG9LRXNwREI1NkhhSGlDZ2RaaTluZ2hPeE9lU0ZXejhpeTJPZHJt?=
 =?utf-8?B?YUZWV0dLQ20zMUdHc1ptQW4xaVJkUnBudGw4Nmc2OTF1bm9xY2pWQ21FNHpU?=
 =?utf-8?B?ZzR2QTlldllMVDYzellLZmwvUkp2VDgwNTh1ZnVuVmQ3MzQ0ZDY5TjJDTEFk?=
 =?utf-8?B?dnV6U1NHaExMdE1rQWJObmJ6WWxscHlHd1F0bHVIcmdyUUtqQm9ZUUI0eGlZ?=
 =?utf-8?B?aTZubklBUmk4NXh0UVg5TGMyb2kvL1E5VHMyWTE3QmxPZWNOMWNSMUNHeHBr?=
 =?utf-8?B?VjZQSWdsRDVlOUg2SkVvRlVxOUJTdHhiOFVlTFZkR2Q2c2g2NU9XMTA5MDNY?=
 =?utf-8?B?WnNTSlIxd1VRa2pXUFBKdkdzS1d0dk5qSXJVc0dROUtOaDJVZ1F6Qm1uby84?=
 =?utf-8?B?R0x3bm1Wdm9ESTlCOGxYaDZoL2w3SFcyT2RqRXdhUk4weWgyZEZYL1lVTWcz?=
 =?utf-8?B?UHBmWXdYRWdjNG45WGJCYTl0cHlQUFp6b3JnYnloZUNPUHZnZHpJWEZpOGlK?=
 =?utf-8?B?azBLNm8wM21iM0FQbit6Y0kzQkNDQk5SODJKeG96YmpiQXZ0bkZYQVZ5WWlY?=
 =?utf-8?B?MlNaNUhwaDJVaUpiVXBZME9oN3ZSaUhVR3hka1dFaS83T0VpRnk0QkIySEdV?=
 =?utf-8?B?L3dWRHVWazVSbEwwcVpUVEVqY1libHY0SGwrbmg3Tk55TTl5M2FZOWIyOUM1?=
 =?utf-8?B?WTBXSGFlY2ozaDNCVzRWR2NlMFdzNTZpUjRZV3VXRXEvVWNLMThUMGNMQnUx?=
 =?utf-8?B?Q3h2ekJiTmM4OUFscXV2bkZ3bStLSGxQZDFTWURjV1hJWmYxeUhJNGx1WUta?=
 =?utf-8?B?MlRkZjAwZkYwWXFHV2tOMzJSWktETGRnRnA2YS9tYXpuUU9LbHJrL25GQkM1?=
 =?utf-8?B?U3pqVFdPOUpvRWh3TkswVlJtNisvUUEwODhwZTVGUzVmR0kyQXBJbWcyS0oy?=
 =?utf-8?B?RFUzazJFR0VUTWlrd09YYXFHZ20vYUo1Z3BmK09DbDljb3FaYWJjRUhabzZU?=
 =?utf-8?B?NkZBQkZpZzdWRHJJdlpTdTlLVG5tZXBENVhVNTloS0lwMjRBVmcxeG5TNXZn?=
 =?utf-8?B?bm1NeUROUHRsOHFIWHFEUFpFVC82VG1xM1ZtYloyVUlWR1Ayc2ZQL3VXdVFQ?=
 =?utf-8?B?am4zam9ZL2kxWkhtRHJyaDErRXJlWjUwMmh4RlExUEJIaVdmZXh4c3N2NUdB?=
 =?utf-8?B?VnlCQy9KNG9QdkZwVzdHbHpjSkJnUDlCVHhNdHdFWE9YZFIvakdCSVhGc3lG?=
 =?utf-8?B?UGU1aGpUSTFBdjM0eFlRaktaNiswN3VFNlcybHBnemVGdlJ5LzRDU2kwT1Mv?=
 =?utf-8?B?VVBqT3IwbnVST2NScVBYbldJc3ZRSFB0Ym9uUG9NNUFyLzVQOG1GUStYbUYx?=
 =?utf-8?B?VWh5ZnhjRXkvUWZIUHZxZ0FtRW4wcEpBaG9vQXd5cWcvTkh0WGJtcUw2YUFL?=
 =?utf-8?B?VnRSOTh4UWJFRUx4SitaMjdQSTIvUDBYdlRLaDFrM2EveURNRGlHSWFlSFFz?=
 =?utf-8?B?SHhXWlZORkVSYktaU3RWMkNsQUhZQThnVjJ5NjFhMmVDSmI4SmJyZmR6R2Nr?=
 =?utf-8?B?alNkY3loZzNPRnZtcnJaYndEN1Jhd2RheHU2WWlKSTlYRklZK1lQanRhMmpm?=
 =?utf-8?B?a2RDY042dVhGcEFYRFJIZ2twNFB1NW1CNHJLZHV0S082NnBhR2RpUjRmYm14?=
 =?utf-8?B?dXdteWhPNWFJZm9KR2xVSzIyWTlNZlNSa29oWXhWRnFNQTV4aUtyNDl6NDJ3?=
 =?utf-8?Q?fcgG4VzXb2ZYQXMeedcusog+8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff67ba93-f95c-4b14-65e6-08dac2d4a2da
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 04:32:55.0548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfQ++URa+g4mppJCJDAEu8qNyNislGT7cB37axJ+lfs0L37rxm8HWJYJ0F6k89OidYiY8HBks/b1s2VHm8Mbdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5474
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/10 12:17, Alex Williamson wrote:
> On Thu, 10 Nov 2022 11:03:29 +0800
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> Hi DeRossi,
>>
>> On 2022/11/10 09:40, Anthony DeRossi wrote:
>>> vfio_pci_dev_set_needs_reset() inspects the open_count of every device
>>> in the set to determine whether a reset is allowed. The current device
>>> always has open_count == 1 within vfio_pci_core_disable(), effectively
>>> disabling the reset logic. This field is also documented as private in
>>> vfio_device, so it should not be used to determine whether other devices
>>> in the set are open.
>>
>> haven't went through the prior version. maybe may question has been already
>> answered. My question is:
>>
>> the major reason is the order problem in vfio_main.c. close_device() is
>> always called before decreasing open_count to be 0. So even other device
>> has no open fd, the current vfio_device still have one open count. So why
>> can't we just switch the order of open_count-- and close_device()?
> 
> This is what was originally proposed and Jason shot it down:
> 
> https://lore.kernel.org/all/Y1kY0I4lr7KntbWp@ziepe.ca/

got it. :-)

>>> Checking for vfio_device_set_open_count() > 1 on the device set fixes
>>> both issues
>> tbh. it's weird to me that a driver needs to know the internal logic of
>> vfio core before knowing it needs to check the vfio_device_set_open_count()
>> in this way. Is vfio-pci the only driver that needs to do this check or
>> there are other drivers? If there are other drivers, maybe fixing the order
>> in core is better.
> 
> Please see the evolution of reflck into device sets.  Both PCI and FSL
> can have multiple devices in a set, AIUI.  The driver defines the set.
> This ability to test for the last close among devices in the set is a
> fundamental feature of the original reflck.  Thanks,

thanks for the info.

-- 
Regards,
Yi Liu
