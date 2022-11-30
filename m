Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A27063CF9E
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 08:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiK3HOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 02:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiK3HO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 02:14:29 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15895F87A
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 23:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669792465; x=1701328465;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eWqr4gaK++k3lYsQytNuo48CDqW1L2ekW+El8kqJAEs=;
  b=bQK59u7H2hNPWoqzgFJJDbw8S2VQCDv7NQfvhlQnc/+iOrlKNmQ2UHgy
   eJbBt3LzW38qP7Yw3+6BxrdPuiwVyqQzLK7H91tLjCWR74MKP92cQWlP5
   5v7Se9BcAXlq6RR2Kxr59GIJV7rC/pX/7U6FqQ2Hlj8JCVGwCAkFTg4NQ
   qTZYjyz3HPjOPnPM4fZXpZXLBWGZs8F+EBsH50rdto9u8sHvAnbMxZDKx
   RF+QZIs009q70YGmlPRVlTm09ZjXZw4GGa4sIk9VV8odaIMW4bjogd8fL
   4Clk9RkzRpF/Hg/8U/1TXaK3hzlXVMdipC35n68Sc9xekFe3qjG7rKRPl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="298695200"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="298695200"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 23:14:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="646224330"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="646224330"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 29 Nov 2022 23:14:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 29 Nov 2022 23:14:22 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 29 Nov 2022 23:14:22 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 29 Nov 2022 23:14:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krfFXZ2dh+eF1P/NS4rTGOHP01B/dTjt8mrgleTZwjsaQHYECMWl6HU0bZ18XIrltjIXF20BUe7lJhb88e0DyIbfoScKZ4SA6Ky5SSle5ORJVEKhIBetHghCJ2ad7MT4TXLV+KrAwbV3qIe6OC+we8WAMdS8XDs82JGY55tc/k8zLJT11XlCqPYqrSElNp7mqWv+4IxmwXTzZC6cq/Bn9EDadTZgAGAxb8IfqpqPMfaKJ2DP2Hhb378JjIbBCppzCABfhkBF2uT92EawqzqAKqCNFf+wLhkRFIvWtmEW5uYfVbTPJjoCZWtlR6tsalbPaTE9oKmJTKfFtBsmbMSVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jaRD0JSJ4UPCiuggflZSPZb19MNDQ1kRlyEzN6lYp5A=;
 b=PPly3KwyEejVcSAskBJ6iNvR80LjWdjPPzKMccuy3uJozqhdMotoqjzWrfHEPGiVWoR1/lOzv/rEh0ZSkbTzKsg0MIuiXVcRbVG8V+5ScGL+1AJNO925sC3Z/c94kXHtlIErfgUWAQskDcooRTgiKixnQICjWoPQGCCtosdzgWfBFwLDpSrZnzdg1Nkzr8B4tjdnVAd1Hw5wfJFsynQ68peUNnhvSB0Y6JHaE6Rw5TmJfRha92N5NuF2wdM298V7+LZcUdgSP9/2gmsnHJfU7mRuTeKuGZzJqKjGNQVzJi30aSjiyNUXx0brZh5Cikwtpkn/Mch2xTd7pntn3p+mwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB4795.namprd11.prod.outlook.com (2603:10b6:806:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 07:13:57 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 07:13:57 +0000
Message-ID: <48c89797-600b-48db-8df4-fc6674561417@intel.com>
Date:   Wed, 30 Nov 2022 15:14:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v6 19/19] iommufd: Add a selftest
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Daniel Jordan" <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "Eric Farman" <farman@linux.ibm.com>, <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <19-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <19-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::7) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA2PR11MB4795:EE_
X-MS-Office365-Filtering-Correlation-Id: 66fc6d83-5d6e-4a5e-43f0-08dad2a27241
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XRroBNlldh9XS6j+lxY0/fM1bNBury2dW1KTCRPv4bS5nAQsAVfkywAQAm64h/I4bnDiVreEEusGbi8y2CTAcmXnn34N7iyrkXdeFQoh3fIpmJV222pJY5LOiYrtdTvWrojtLNhw3gCuf3XYrxUaYub8Gys30v2Ms84tEFF3aXnUGGYQj1AH7kGl9sulHJk8TC5nnXyTKXpL4XVZU4UAXbDz3QzOQVXq/lO8+3ahHxPL/zfoW9ZOQOKgm9E75zRLWZKfVcXyZ38ZNb5dO2X7lmOQ0lMdkkv9Rovm8KMA4SbipwyCKd4JMsEtEaDc48BI1WeFnjE+/0mjyYMPlF4XJRFz92LU/KSjnGxygHke3/uXiJWF1s1l3UXz+Jh35eydeb4qIcCvzbSc3v6eDyAFwkAcTRWnLP4UcS9KnOCpf35uRjjDmxUATTnprgpLmnblDoBEY5ctmo6VSbWoBhs1dSKIGV6dmsUWefmsFk7N7CuUfuU8AgoVdsMkFjzP4jD0TVuHodyCSsHHxBrRF3hLE2lBnk8qQhmxPu9/dQOa9GxXJgKOCrtopBoPZB/kwuenJfNv4yPqCt4dHh63zXAmaJ/PpcpLTMkCb/6K1mDAe/8XtpXzFnm1x/wl10mQcJKk+ckM2IjLMFNccitHOelqWeCubaVytR01GsKEcAUtT3yRB1Xe+YxGfewdo1jxXO56ISzk3IxY4/cHYnzL2V6KZ+alzTO66GZhrpk5D0hd+p8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199015)(8936002)(30864003)(7416002)(2906002)(38100700002)(31686004)(6916009)(31696002)(86362001)(6486002)(36756003)(41300700001)(186003)(82960400001)(478600001)(66946007)(54906003)(316002)(5660300002)(8676002)(66476007)(83380400001)(6666004)(53546011)(6512007)(6506007)(66556008)(4326008)(2616005)(26005)(43740500002)(45980500001)(559001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkhNazFXcEE1T3hVSDhXNVBQOG9GUGFjWWZSWUtaSmRaSTlmYUFSSWEvRHNu?=
 =?utf-8?B?dlpXMFVYYjV1TC9CTmFjRU1URFVibVBkVEZCa0hMWnRwNDd2eXdTVW8xMVcz?=
 =?utf-8?B?VzA3Z3d0V0tXcWNCNmp6M1Z3VW93bUpCMUsvSFBlek9NVFkxZWxua0pGd3Rr?=
 =?utf-8?B?Q1l1dkRZQTlnL2ltc2cxbmtPaTRBM05Sem9LUEx2SlVsVVBBSXlaUW9DeHdC?=
 =?utf-8?B?TThHN1BpdmVVb05xbUh1OE1DQmcyc2JiMHRUZm9wS3IrTEhYeko5T0QwMEc3?=
 =?utf-8?B?YjQ0dkM3L1E3OEtFYVFkWGFrT0IvOWNSaVR5NGoyMUtqZGRoN1IwVC8xZ0kz?=
 =?utf-8?B?YXdzS1ByT2h4Q3Fubm0rSDk0VGtSWUdlbWRYQnJ5V0FyVWlLMmk3dVZCeWgz?=
 =?utf-8?B?SWY4VU92dzF3OHI5NUdMRC92UVNwTktTNmZGSU90N2o4dWIxeXFDZDQ3SUtM?=
 =?utf-8?B?OTgvMm1yY3VxYWFsZFkvT09vaHFTZVZHQzJoNGdhK0hReTIxbitVNG9tNEYv?=
 =?utf-8?B?ZUJPUEx5VXViNUZXUDJNZThsWllMYnN4Ums2WXcwN0V4dEVkYUZWU3pMVTcy?=
 =?utf-8?B?djYyOWxuU1lZYjRNdzBqdXBYTnloMDRwUi9uNk81bGNFazhyWkFWT3U0YjFu?=
 =?utf-8?B?TzdEb3Z3SjFVVVhEL2E5VDBkVUo1RkNHcW4zc3lqQk1ZMmd0TkdOU2cwMld3?=
 =?utf-8?B?aWZGZmVEWld0Yy8rME1IRnlFU2xQVG8yTG1FU3JUaUwxa3lWRWN0V0MvdjBR?=
 =?utf-8?B?YklZdU0vRmc3UDN6YWh3aktIcm5yc1JMVW12ZmJKdDRJeTJ5SEVJZEdVbjAx?=
 =?utf-8?B?WDNyUW9EUVpWRWg2czY2QzRES1JkN1lRTzZ4NCs3R1RMRVZlMVJPalFpWmhU?=
 =?utf-8?B?Yno4bUZCWnBLVm1pLzd0Wnh1aDU0ZTNCeFBPbGY2MnM0ekNleW8xR2ZpVU9p?=
 =?utf-8?B?OHQyU2pZOTZCOUd3VjhQbmE0eWxoM25Pay9Zc3FSaWtRVkRVZXM0OHFKK2Fn?=
 =?utf-8?B?bmtObkxUcGI3aXBzVGZ6Y0ZFVzBnNklNelJCRDlyLzlXRXBGNnFDSE1xZm5a?=
 =?utf-8?B?Vkl3d256Qkw4Y0FXSm04dEpqenE2NHJ6dXVmNlVuQ1d4Sk5YV2h1T0d3dU11?=
 =?utf-8?B?QXFnbzhlcEtUWFJhNnozT3ZRdzhpODBlV2lVNExQdVVJdUNVMWZydXZLV0hZ?=
 =?utf-8?B?ZlJRdzEvMWl6VUtKdldOdHJpcTBtdmRhdVNCcHdOYkJhVmhyWjNDQTY5RVA3?=
 =?utf-8?B?UjVlbFlyUjViN0VTR0hXQzBENmxkajg5UG5MM2JIMDlMNVoxV3NUYjBSRjBL?=
 =?utf-8?B?a25rMDc4K2NGaUd4bjBXN0NRbDNuR1B6MEZWalNMWks5MXEzc2JlOWUwYmI5?=
 =?utf-8?B?ZHJxT2JJWjdtdTNGck55UERxNWplRlJaWE9ob3hsbDExU1IrTVpkVE5tNUc0?=
 =?utf-8?B?UWYxQXl5ek8waHBkTjB1eDdVMTZJMmd0WFZuZ1p2SVB0c1N5ZThnUWZpRGFz?=
 =?utf-8?B?NXhjRHFZNTJkdHJ0TUdQNE02SENvWWJPZG1JYytJM3BnSjBSN2FESHhLWkFW?=
 =?utf-8?B?WEZrWGZkbEx4NFZpSENjT2Z0OEVHWjBQNkoyaXgzbkh2Yll5aVVtN25mUFdT?=
 =?utf-8?B?eUUrNHcvUWxBTkIvNHZMTGxUaXJKRUUxOWZFNDNxS2xoZnIyQ0NndTZNNzVF?=
 =?utf-8?B?LzNYR3JrcVRjTEFtMm9NUzZRamZKZVVjQkNEWGdhQU5QcUV3NUNJL2phaS80?=
 =?utf-8?B?SURQRlp6a3ZBODRsb20vM2xQbkRyN3J0YlJDK0VzMTZkSUFkczRlc2dENzB5?=
 =?utf-8?B?OWR2TW1lSVdIQ1dPV2ZIV1IrR1g0b2dKMUkvSUsySVA0eGlLTVh0UWt3OFhF?=
 =?utf-8?B?MW0wRG05NHp3UC9MVjkzKzR0THU1RnJKSCtTdyt2a3o4NGM0QnVEUDc2NjIx?=
 =?utf-8?B?c1d5ME0zQjNlelhMNXdzK3lUZ1d3OEJYMWRlWUdxMXI5ck1PYzZ5bUJ1MHBh?=
 =?utf-8?B?eVNFTk83Y1NOcDdaNGtMRHRSMDA5NFZTUCtleFNxWThLYlFWWmJ5ZC8zNlJM?=
 =?utf-8?B?aUxpVUd6aEwvT0VlUTkwckZDK3A0SmVQd3REb0J3M1NNRnhSS3hDWUhXUDI2?=
 =?utf-8?Q?+CLdHW45socC487TeeBZsucF7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66fc6d83-5d6e-4a5e-43f0-08dad2a27241
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 07:13:57.5229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CYqTaX+Pdyd26vQu9WlE/Jks309/wNsmpY2GOXrKrkZ8UFUOscYZ9BHU1Ng3t28lpqX6q33huyS7RBFyl7wKgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4795
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/30 04:29, Jason Gunthorpe wrote:
> Cover the essential functionality of the iommufd with a directed test from
> userspace. This aims to achieve reasonable functional coverage using the
> in-kernel self test framework.
> 
> A second test does a failure injection sweep of the success paths to study
> error unwind behaviors.
> 
> This allows achieving high coverage of the corner cases in pages.c.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

with sudo echo 4 > /proc/sys/vm/nr_hugepages

Both "sudo ./iommufd" and "sudo ./iommufd_fail_nth" works on my side.

Tested-by: Yi Liu <yi.l.liu@intel.com>

> ---
>   tools/testing/selftests/Makefile              |    1 +
>   tools/testing/selftests/iommu/.gitignore      |    3 +
>   tools/testing/selftests/iommu/Makefile        |   12 +
>   tools/testing/selftests/iommu/config          |    2 +
>   tools/testing/selftests/iommu/iommufd.c       | 1654 +++++++++++++++++
>   .../selftests/iommu/iommufd_fail_nth.c        |  580 ++++++
>   tools/testing/selftests/iommu/iommufd_utils.h |  278 +++
>   7 files changed, 2530 insertions(+)
>   create mode 100644 tools/testing/selftests/iommu/.gitignore
>   create mode 100644 tools/testing/selftests/iommu/Makefile
>   create mode 100644 tools/testing/selftests/iommu/config
>   create mode 100644 tools/testing/selftests/iommu/iommufd.c
>   create mode 100644 tools/testing/selftests/iommu/iommufd_fail_nth.c
>   create mode 100644 tools/testing/selftests/iommu/iommufd_utils.h
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index f07aef7c592c2e..d6680af7b2956e 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -27,6 +27,7 @@ TARGETS += ftrace
>   TARGETS += futex
>   TARGETS += gpio
>   TARGETS += intel_pstate
> +TARGETS += iommu
>   TARGETS += ipc
>   TARGETS += ir
>   TARGETS += kcmp
> diff --git a/tools/testing/selftests/iommu/.gitignore b/tools/testing/selftests/iommu/.gitignore
> new file mode 100644
> index 00000000000000..7d0703049ebaf4
> --- /dev/null
> +++ b/tools/testing/selftests/iommu/.gitignore
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +/iommufd
> +/iommufd_fail_nth
> diff --git a/tools/testing/selftests/iommu/Makefile b/tools/testing/selftests/iommu/Makefile
> new file mode 100644
> index 00000000000000..7cb74d26f14171
> --- /dev/null
> +++ b/tools/testing/selftests/iommu/Makefile
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +CFLAGS += -Wall -O2 -Wno-unused-function
> +CFLAGS += -I../../../../include/uapi/
> +CFLAGS += -I../../../../include/
> +
> +CFLAGS += -D_GNU_SOURCE
> +
> +TEST_GEN_PROGS :=
> +TEST_GEN_PROGS += iommufd
> +TEST_GEN_PROGS += iommufd_fail_nth
> +
> +include ../lib.mk
> diff --git a/tools/testing/selftests/iommu/config b/tools/testing/selftests/iommu/config
> new file mode 100644
> index 00000000000000..6c4f901d6fed3c
> --- /dev/null
> +++ b/tools/testing/selftests/iommu/config
> @@ -0,0 +1,2 @@
> +CONFIG_IOMMUFD
> +CONFIG_IOMMUFD_TEST
> diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
> new file mode 100644
> index 00000000000000..8aa8a346cf2217
> --- /dev/null
> +++ b/tools/testing/selftests/iommu/iommufd.c
> @@ -0,0 +1,1654 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES */
> +#include <stdlib.h>
> +#include <sys/mman.h>
> +#include <sys/eventfd.h>
> +
> +#define __EXPORTED_HEADERS__
> +#include <linux/vfio.h>
> +
> +#include "iommufd_utils.h"
> +
> +static void *buffer;
> +
> +static unsigned long PAGE_SIZE;
> +static unsigned long HUGEPAGE_SIZE;
> +
> +#define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
> +
> +static unsigned long get_huge_page_size(void)
> +{
> +	char buf[80];
> +	int ret;
> +	int fd;
> +
> +	fd = open("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size",
> +		  O_RDONLY);
> +	if (fd < 0)
> +		return 2 * 1024 * 1024;
> +
> +	ret = read(fd, buf, sizeof(buf));
> +	close(fd);
> +	if (ret <= 0 || ret == sizeof(buf))
> +		return 2 * 1024 * 1024;
> +	buf[ret] = 0;
> +	return strtoul(buf, NULL, 10);
> +}
> +
> +static __attribute__((constructor)) void setup_sizes(void)
> +{
> +	void *vrc;
> +	int rc;
> +
> +	PAGE_SIZE = sysconf(_SC_PAGE_SIZE);
> +	HUGEPAGE_SIZE = get_huge_page_size();
> +
> +	BUFFER_SIZE = PAGE_SIZE * 16;
> +	rc = posix_memalign(&buffer, HUGEPAGE_SIZE, BUFFER_SIZE);
> +	assert(!rc);
> +	assert(buffer);
> +	assert((uintptr_t)buffer % HUGEPAGE_SIZE == 0);
> +	vrc = mmap(buffer, BUFFER_SIZE, PROT_READ | PROT_WRITE,
> +		   MAP_SHARED | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
> +	assert(vrc == buffer);
> +}
> +
> +FIXTURE(iommufd)
> +{
> +	int fd;
> +};
> +
> +FIXTURE_SETUP(iommufd)
> +{
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	ASSERT_NE(-1, self->fd);
> +}
> +
> +FIXTURE_TEARDOWN(iommufd)
> +{
> +	teardown_iommufd(self->fd, _metadata);
> +}
> +
> +TEST_F(iommufd, simple_close)
> +{
> +}
> +
> +TEST_F(iommufd, cmd_fail)
> +{
> +	struct iommu_destroy cmd = { .size = sizeof(cmd), .id = 0 };
> +
> +	/* object id is invalid */
> +	EXPECT_ERRNO(ENOENT, _test_ioctl_destroy(self->fd, 0));
> +	/* Bad pointer */
> +	EXPECT_ERRNO(EFAULT, ioctl(self->fd, IOMMU_DESTROY, NULL));
> +	/* Unknown ioctl */
> +	EXPECT_ERRNO(ENOTTY,
> +		     ioctl(self->fd, _IO(IOMMUFD_TYPE, IOMMUFD_CMD_BASE - 1),
> +			   &cmd));
> +}
> +
> +TEST_F(iommufd, cmd_length)
> +{
> +#define TEST_LENGTH(_struct, _ioctl)                                     \
> +	{                                                                \
> +		struct {                                                 \
> +			struct _struct cmd;                              \
> +			uint8_t extra;                                   \
> +		} cmd = { .cmd = { .size = sizeof(struct _struct) - 1 }, \
> +			  .extra = UINT8_MAX };                          \
> +		int old_errno;                                           \
> +		int rc;                                                  \
> +									 \
> +		EXPECT_ERRNO(EINVAL, ioctl(self->fd, _ioctl, &cmd));     \
> +		cmd.cmd.size = sizeof(struct _struct) + 1;               \
> +		EXPECT_ERRNO(E2BIG, ioctl(self->fd, _ioctl, &cmd));      \
> +		cmd.cmd.size = sizeof(struct _struct);                   \
> +		rc = ioctl(self->fd, _ioctl, &cmd);                      \
> +		old_errno = errno;                                       \
> +		cmd.cmd.size = sizeof(struct _struct) + 1;               \
> +		cmd.extra = 0;                                           \
> +		if (rc) {                                                \
> +			EXPECT_ERRNO(old_errno,                          \
> +				     ioctl(self->fd, _ioctl, &cmd));     \
> +		} else {                                                 \
> +			ASSERT_EQ(0, ioctl(self->fd, _ioctl, &cmd));     \
> +		}                                                        \
> +	}
> +
> +	TEST_LENGTH(iommu_destroy, IOMMU_DESTROY);
> +	TEST_LENGTH(iommu_ioas_alloc, IOMMU_IOAS_ALLOC);
> +	TEST_LENGTH(iommu_ioas_iova_ranges, IOMMU_IOAS_IOVA_RANGES);
> +	TEST_LENGTH(iommu_ioas_allow_iovas, IOMMU_IOAS_ALLOW_IOVAS);
> +	TEST_LENGTH(iommu_ioas_map, IOMMU_IOAS_MAP);
> +	TEST_LENGTH(iommu_ioas_copy, IOMMU_IOAS_COPY);
> +	TEST_LENGTH(iommu_ioas_unmap, IOMMU_IOAS_UNMAP);
> +	TEST_LENGTH(iommu_option, IOMMU_OPTION);
> +	TEST_LENGTH(iommu_vfio_ioas, IOMMU_VFIO_IOAS);
> +#undef TEST_LENGTH
> +}
> +
> +TEST_F(iommufd, cmd_ex_fail)
> +{
> +	struct {
> +		struct iommu_destroy cmd;
> +		__u64 future;
> +	} cmd = { .cmd = { .size = sizeof(cmd), .id = 0 } };
> +
> +	/* object id is invalid and command is longer */
> +	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_DESTROY, &cmd));
> +	/* future area is non-zero */
> +	cmd.future = 1;
> +	EXPECT_ERRNO(E2BIG, ioctl(self->fd, IOMMU_DESTROY, &cmd));
> +	/* Original command "works" */
> +	cmd.cmd.size = sizeof(cmd.cmd);
> +	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_DESTROY, &cmd));
> +	/* Short command fails */
> +	cmd.cmd.size = sizeof(cmd.cmd) - 1;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, IOMMU_DESTROY, &cmd));
> +}
> +
> +TEST_F(iommufd, global_options)
> +{
> +	struct iommu_option cmd = {
> +		.size = sizeof(cmd),
> +		.option_id = IOMMU_OPTION_RLIMIT_MODE,
> +		.op = IOMMU_OPTION_OP_GET,
> +		.val64 = 1,
> +	};
> +
> +	cmd.option_id = IOMMU_OPTION_RLIMIT_MODE;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +	ASSERT_EQ(0, cmd.val64);
> +
> +	/* This requires root */
> +	cmd.op = IOMMU_OPTION_OP_SET;
> +	cmd.val64 = 1;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +	cmd.val64 = 2;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +
> +	cmd.op = IOMMU_OPTION_OP_GET;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +	ASSERT_EQ(1, cmd.val64);
> +
> +	cmd.op = IOMMU_OPTION_OP_SET;
> +	cmd.val64 = 0;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +
> +	cmd.op = IOMMU_OPTION_OP_GET;
> +	cmd.option_id = IOMMU_OPTION_HUGE_PAGES;
> +	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +	cmd.op = IOMMU_OPTION_OP_SET;
> +	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +}
> +
> +FIXTURE(iommufd_ioas)
> +{
> +	int fd;
> +	uint32_t ioas_id;
> +	uint32_t domain_id;
> +	uint64_t base_iova;
> +};
> +
> +FIXTURE_VARIANT(iommufd_ioas)
> +{
> +	unsigned int mock_domains;
> +	unsigned int memory_limit;
> +};
> +
> +FIXTURE_SETUP(iommufd_ioas)
> +{
> +	unsigned int i;
> +
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	ASSERT_NE(-1, self->fd);
> +	test_ioctl_ioas_alloc(&self->ioas_id);
> +
> +	if (!variant->memory_limit) {
> +		test_ioctl_set_default_memory_limit();
> +	} else {
> +		test_ioctl_set_temp_memory_limit(variant->memory_limit);
> +	}
> +
> +	for (i = 0; i != variant->mock_domains; i++) {
> +		test_cmd_mock_domain(self->ioas_id, NULL, &self->domain_id);
> +		self->base_iova = MOCK_APERTURE_START;
> +	}
> +}
> +
> +FIXTURE_TEARDOWN(iommufd_ioas)
> +{
> +	test_ioctl_set_default_memory_limit();
> +	teardown_iommufd(self->fd, _metadata);
> +}
> +
> +FIXTURE_VARIANT_ADD(iommufd_ioas, no_domain)
> +{
> +};
> +
> +FIXTURE_VARIANT_ADD(iommufd_ioas, mock_domain)
> +{
> +	.mock_domains = 1,
> +};
> +
> +FIXTURE_VARIANT_ADD(iommufd_ioas, two_mock_domain)
> +{
> +	.mock_domains = 2,
> +};
> +
> +FIXTURE_VARIANT_ADD(iommufd_ioas, mock_domain_limit)
> +{
> +	.mock_domains = 1,
> +	.memory_limit = 16,
> +};
> +
> +TEST_F(iommufd_ioas, ioas_auto_destroy)
> +{
> +}
> +
> +TEST_F(iommufd_ioas, ioas_destroy)
> +{
> +	if (self->domain_id) {
> +		/* IOAS cannot be freed while a domain is on it */
> +		EXPECT_ERRNO(EBUSY,
> +			     _test_ioctl_destroy(self->fd, self->ioas_id));
> +	} else {
> +		/* Can allocate and manually free an IOAS table */
> +		test_ioctl_destroy(self->ioas_id);
> +	}
> +}
> +
> +TEST_F(iommufd_ioas, ioas_area_destroy)
> +{
> +	/* Adding an area does not change ability to destroy */
> +	test_ioctl_ioas_map_fixed(buffer, PAGE_SIZE, self->base_iova);
> +	if (self->domain_id)
> +		EXPECT_ERRNO(EBUSY,
> +			     _test_ioctl_destroy(self->fd, self->ioas_id));
> +	else
> +		test_ioctl_destroy(self->ioas_id);
> +}
> +
> +TEST_F(iommufd_ioas, ioas_area_auto_destroy)
> +{
> +	int i;
> +
> +	/* Can allocate and automatically free an IOAS table with many areas */
> +	for (i = 0; i != 10; i++) {
> +		test_ioctl_ioas_map_fixed(buffer, PAGE_SIZE,
> +					  self->base_iova + i * PAGE_SIZE);
> +	}
> +}
> +
> +TEST_F(iommufd_ioas, area)
> +{
> +	int i;
> +
> +	/* Unmap fails if nothing is mapped */
> +	for (i = 0; i != 10; i++)
> +		test_err_ioctl_ioas_unmap(ENOENT, i * PAGE_SIZE, PAGE_SIZE);
> +
> +	/* Unmap works */
> +	for (i = 0; i != 10; i++)
> +		test_ioctl_ioas_map_fixed(buffer, PAGE_SIZE,
> +					  self->base_iova + i * PAGE_SIZE);
> +	for (i = 0; i != 10; i++)
> +		test_ioctl_ioas_unmap(self->base_iova + i * PAGE_SIZE,
> +				      PAGE_SIZE);
> +
> +	/* Split fails */
> +	test_ioctl_ioas_map_fixed(buffer, PAGE_SIZE * 2,
> +				  self->base_iova + 16 * PAGE_SIZE);
> +	test_err_ioctl_ioas_unmap(ENOENT, self->base_iova + 16 * PAGE_SIZE,
> +				  PAGE_SIZE);
> +	test_err_ioctl_ioas_unmap(ENOENT, self->base_iova + 17 * PAGE_SIZE,
> +				  PAGE_SIZE);
> +
> +	/* Over map fails */
> +	test_err_ioctl_ioas_map_fixed(EEXIST, buffer, PAGE_SIZE * 2,
> +				      self->base_iova + 16 * PAGE_SIZE);
> +	test_err_ioctl_ioas_map_fixed(EEXIST, buffer, PAGE_SIZE,
> +				      self->base_iova + 16 * PAGE_SIZE);
> +	test_err_ioctl_ioas_map_fixed(EEXIST, buffer, PAGE_SIZE,
> +				      self->base_iova + 17 * PAGE_SIZE);
> +	test_err_ioctl_ioas_map_fixed(EEXIST, buffer, PAGE_SIZE * 2,
> +				      self->base_iova + 15 * PAGE_SIZE);
> +	test_err_ioctl_ioas_map_fixed(EEXIST, buffer, PAGE_SIZE * 3,
> +				      self->base_iova + 15 * PAGE_SIZE);
> +
> +	/* unmap all works */
> +	test_ioctl_ioas_unmap(0, UINT64_MAX);
> +
> +	/* Unmap all succeeds on an empty IOAS */
> +	test_ioctl_ioas_unmap(0, UINT64_MAX);
> +}
> +
> +TEST_F(iommufd_ioas, unmap_fully_contained_areas)
> +{
> +	uint64_t unmap_len;
> +	int i;
> +
> +	/* Give no_domain some space to rewind base_iova */
> +	self->base_iova += 4 * PAGE_SIZE;
> +
> +	for (i = 0; i != 4; i++)
> +		test_ioctl_ioas_map_fixed(buffer, 8 * PAGE_SIZE,
> +					  self->base_iova + i * 16 * PAGE_SIZE);
> +
> +	/* Unmap not fully contained area doesn't work */
> +	test_err_ioctl_ioas_unmap(ENOENT, self->base_iova - 4 * PAGE_SIZE,
> +				  8 * PAGE_SIZE);
> +	test_err_ioctl_ioas_unmap(ENOENT,
> +				  self->base_iova + 3 * 16 * PAGE_SIZE +
> +					  8 * PAGE_SIZE - 4 * PAGE_SIZE,
> +				  8 * PAGE_SIZE);
> +
> +	/* Unmap fully contained areas works */
> +	ASSERT_EQ(0, _test_ioctl_ioas_unmap(self->fd, self->ioas_id,
> +					    self->base_iova - 4 * PAGE_SIZE,
> +					    3 * 16 * PAGE_SIZE + 8 * PAGE_SIZE +
> +						    4 * PAGE_SIZE,
> +					    &unmap_len));
> +	ASSERT_EQ(32 * PAGE_SIZE, unmap_len);
> +}
> +
> +TEST_F(iommufd_ioas, area_auto_iova)
> +{
> +	struct iommu_test_cmd test_cmd = {
> +		.size = sizeof(test_cmd),
> +		.op = IOMMU_TEST_OP_ADD_RESERVED,
> +		.id = self->ioas_id,
> +		.add_reserved = { .start = PAGE_SIZE * 4,
> +				  .length = PAGE_SIZE * 100 },
> +	};
> +	struct iommu_iova_range ranges[1] = {};
> +	struct iommu_ioas_allow_iovas allow_cmd = {
> +		.size = sizeof(allow_cmd),
> +		.ioas_id = self->ioas_id,
> +		.num_iovas = 1,
> +		.allowed_iovas = (uintptr_t)ranges,
> +	};
> +	__u64 iovas[10];
> +	int i;
> +
> +	/* Simple 4k pages */
> +	for (i = 0; i != 10; i++)
> +		test_ioctl_ioas_map(buffer, PAGE_SIZE, &iovas[i]);
> +	for (i = 0; i != 10; i++)
> +		test_ioctl_ioas_unmap(iovas[i], PAGE_SIZE);
> +
> +	/* Kernel automatically aligns IOVAs properly */
> +	for (i = 0; i != 10; i++) {
> +		size_t length = PAGE_SIZE * (i + 1);
> +
> +		if (self->domain_id) {
> +			test_ioctl_ioas_map(buffer, length, &iovas[i]);
> +		} else {
> +			test_ioctl_ioas_map((void *)(1UL << 31), length,
> +					    &iovas[i]);
> +		}
> +		EXPECT_EQ(0, iovas[i] % (1UL << (ffs(length) - 1)));
> +	}
> +	for (i = 0; i != 10; i++)
> +		test_ioctl_ioas_unmap(iovas[i], PAGE_SIZE * (i + 1));
> +
> +	/* Avoids a reserved region */
> +	ASSERT_EQ(0,
> +		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
> +			&test_cmd));
> +	for (i = 0; i != 10; i++) {
> +		size_t length = PAGE_SIZE * (i + 1);
> +
> +		test_ioctl_ioas_map(buffer, length, &iovas[i]);
> +		EXPECT_EQ(0, iovas[i] % (1UL << (ffs(length) - 1)));
> +		EXPECT_EQ(false,
> +			  iovas[i] > test_cmd.add_reserved.start &&
> +				  iovas[i] <
> +					  test_cmd.add_reserved.start +
> +						  test_cmd.add_reserved.length);
> +	}
> +	for (i = 0; i != 10; i++)
> +		test_ioctl_ioas_unmap(iovas[i], PAGE_SIZE * (i + 1));
> +
> +	/* Allowed region intersects with a reserved region */
> +	ranges[0].start = PAGE_SIZE;
> +	ranges[0].last = PAGE_SIZE * 600;
> +	EXPECT_ERRNO(EADDRINUSE,
> +		     ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
> +
> +	/* Allocate from an allowed region */
> +	if (self->domain_id) {
> +		ranges[0].start = MOCK_APERTURE_START + PAGE_SIZE;
> +		ranges[0].last = MOCK_APERTURE_START + PAGE_SIZE * 600 - 1;
> +	} else {
> +		ranges[0].start = PAGE_SIZE * 200;
> +		ranges[0].last = PAGE_SIZE * 600 - 1;
> +	}
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
> +	for (i = 0; i != 10; i++) {
> +		size_t length = PAGE_SIZE * (i + 1);
> +
> +		test_ioctl_ioas_map(buffer, length, &iovas[i]);
> +		EXPECT_EQ(0, iovas[i] % (1UL << (ffs(length) - 1)));
> +		EXPECT_EQ(true, iovas[i] >= ranges[0].start);
> +		EXPECT_EQ(true, iovas[i] <= ranges[0].last);
> +		EXPECT_EQ(true, iovas[i] + length > ranges[0].start);
> +		EXPECT_EQ(true, iovas[i] + length <= ranges[0].last + 1);
> +	}
> +	for (i = 0; i != 10; i++)
> +		test_ioctl_ioas_unmap(iovas[i], PAGE_SIZE * (i + 1));
> +}
> +
> +TEST_F(iommufd_ioas, area_allowed)
> +{
> +	struct iommu_test_cmd test_cmd = {
> +		.size = sizeof(test_cmd),
> +		.op = IOMMU_TEST_OP_ADD_RESERVED,
> +		.id = self->ioas_id,
> +		.add_reserved = { .start = PAGE_SIZE * 4,
> +				  .length = PAGE_SIZE * 100 },
> +	};
> +	struct iommu_iova_range ranges[1] = {};
> +	struct iommu_ioas_allow_iovas allow_cmd = {
> +		.size = sizeof(allow_cmd),
> +		.ioas_id = self->ioas_id,
> +		.num_iovas = 1,
> +		.allowed_iovas = (uintptr_t)ranges,
> +	};
> +
> +	/* Reserved intersects an allowed */
> +	allow_cmd.num_iovas = 1;
> +	ranges[0].start = self->base_iova;
> +	ranges[0].last = ranges[0].start + PAGE_SIZE * 600;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
> +	test_cmd.add_reserved.start = ranges[0].start + PAGE_SIZE;
> +	test_cmd.add_reserved.length = PAGE_SIZE;
> +	EXPECT_ERRNO(EADDRINUSE,
> +		     ioctl(self->fd,
> +			   _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
> +			   &test_cmd));
> +	allow_cmd.num_iovas = 0;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
> +
> +	/* Allowed intersects a reserved */
> +	ASSERT_EQ(0,
> +		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
> +			&test_cmd));
> +	allow_cmd.num_iovas = 1;
> +	ranges[0].start = self->base_iova;
> +	ranges[0].last = ranges[0].start + PAGE_SIZE * 600;
> +	EXPECT_ERRNO(EADDRINUSE,
> +		     ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd));
> +}
> +
> +TEST_F(iommufd_ioas, copy_area)
> +{
> +	struct iommu_ioas_copy copy_cmd = {
> +		.size = sizeof(copy_cmd),
> +		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
> +		.dst_ioas_id = self->ioas_id,
> +		.src_ioas_id = self->ioas_id,
> +		.length = PAGE_SIZE,
> +	};
> +
> +	test_ioctl_ioas_map_fixed(buffer, PAGE_SIZE, self->base_iova);
> +
> +	/* Copy inside a single IOAS */
> +	copy_cmd.src_iova = self->base_iova;
> +	copy_cmd.dst_iova = self->base_iova + PAGE_SIZE;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd));
> +
> +	/* Copy between IOAS's */
> +	copy_cmd.src_iova = self->base_iova;
> +	copy_cmd.dst_iova = 0;
> +	test_ioctl_ioas_alloc(&copy_cmd.dst_ioas_id);
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd));
> +}
> +
> +TEST_F(iommufd_ioas, iova_ranges)
> +{
> +	struct iommu_test_cmd test_cmd = {
> +		.size = sizeof(test_cmd),
> +		.op = IOMMU_TEST_OP_ADD_RESERVED,
> +		.id = self->ioas_id,
> +		.add_reserved = { .start = PAGE_SIZE, .length = PAGE_SIZE },
> +	};
> +	struct iommu_iova_range *ranges = buffer;
> +	struct iommu_ioas_iova_ranges ranges_cmd = {
> +		.size = sizeof(ranges_cmd),
> +		.ioas_id = self->ioas_id,
> +		.num_iovas = BUFFER_SIZE / sizeof(*ranges),
> +		.allowed_iovas = (uintptr_t)ranges,
> +	};
> +
> +	/* Range can be read */
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, &ranges_cmd));
> +	EXPECT_EQ(1, ranges_cmd.num_iovas);
> +	if (!self->domain_id) {
> +		EXPECT_EQ(0, ranges[0].start);
> +		EXPECT_EQ(SIZE_MAX, ranges[0].last);
> +		EXPECT_EQ(1, ranges_cmd.out_iova_alignment);
> +	} else {
> +		EXPECT_EQ(MOCK_APERTURE_START, ranges[0].start);
> +		EXPECT_EQ(MOCK_APERTURE_LAST, ranges[0].last);
> +		EXPECT_EQ(MOCK_PAGE_SIZE, ranges_cmd.out_iova_alignment);
> +	}
> +
> +	/* Buffer too small */
> +	memset(ranges, 0, BUFFER_SIZE);
> +	ranges_cmd.num_iovas = 0;
> +	EXPECT_ERRNO(EMSGSIZE,
> +		     ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, &ranges_cmd));
> +	EXPECT_EQ(1, ranges_cmd.num_iovas);
> +	EXPECT_EQ(0, ranges[0].start);
> +	EXPECT_EQ(0, ranges[0].last);
> +
> +	/* 2 ranges */
> +	ASSERT_EQ(0,
> +		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ADD_RESERVED),
> +			&test_cmd));
> +	ranges_cmd.num_iovas = BUFFER_SIZE / sizeof(*ranges);
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, &ranges_cmd));
> +	if (!self->domain_id) {
> +		EXPECT_EQ(2, ranges_cmd.num_iovas);
> +		EXPECT_EQ(0, ranges[0].start);
> +		EXPECT_EQ(PAGE_SIZE - 1, ranges[0].last);
> +		EXPECT_EQ(PAGE_SIZE * 2, ranges[1].start);
> +		EXPECT_EQ(SIZE_MAX, ranges[1].last);
> +	} else {
> +		EXPECT_EQ(1, ranges_cmd.num_iovas);
> +		EXPECT_EQ(MOCK_APERTURE_START, ranges[0].start);
> +		EXPECT_EQ(MOCK_APERTURE_LAST, ranges[0].last);
> +	}
> +
> +	/* Buffer too small */
> +	memset(ranges, 0, BUFFER_SIZE);
> +	ranges_cmd.num_iovas = 1;
> +	if (!self->domain_id) {
> +		EXPECT_ERRNO(EMSGSIZE, ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES,
> +					     &ranges_cmd));
> +		EXPECT_EQ(2, ranges_cmd.num_iovas);
> +		EXPECT_EQ(0, ranges[0].start);
> +		EXPECT_EQ(PAGE_SIZE - 1, ranges[0].last);
> +	} else {
> +		ASSERT_EQ(0,
> +			  ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, &ranges_cmd));
> +		EXPECT_EQ(1, ranges_cmd.num_iovas);
> +		EXPECT_EQ(MOCK_APERTURE_START, ranges[0].start);
> +		EXPECT_EQ(MOCK_APERTURE_LAST, ranges[0].last);
> +	}
> +	EXPECT_EQ(0, ranges[1].start);
> +	EXPECT_EQ(0, ranges[1].last);
> +}
> +
> +TEST_F(iommufd_ioas, access_pin)
> +{
> +	struct iommu_test_cmd access_cmd = {
> +		.size = sizeof(access_cmd),
> +		.op = IOMMU_TEST_OP_ACCESS_PAGES,
> +		.access_pages = { .iova = MOCK_APERTURE_START,
> +				  .length = BUFFER_SIZE,
> +				  .uptr = (uintptr_t)buffer },
> +	};
> +	struct iommu_test_cmd check_map_cmd = {
> +		.size = sizeof(check_map_cmd),
> +		.op = IOMMU_TEST_OP_MD_CHECK_MAP,
> +		.check_map = { .iova = MOCK_APERTURE_START,
> +			       .length = BUFFER_SIZE,
> +			       .uptr = (uintptr_t)buffer },
> +	};
> +	uint32_t access_pages_id;
> +	unsigned int npages;
> +
> +	test_cmd_create_access(self->ioas_id, &access_cmd.id,
> +			       MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES);
> +
> +	for (npages = 1; npages < BUFFER_SIZE / PAGE_SIZE; npages++) {
> +		uint32_t mock_device_id;
> +		uint32_t mock_hwpt_id;
> +
> +		access_cmd.access_pages.length = npages * PAGE_SIZE;
> +
> +		/* Single map/unmap */
> +		test_ioctl_ioas_map_fixed(buffer, BUFFER_SIZE,
> +					  MOCK_APERTURE_START);
> +		ASSERT_EQ(0, ioctl(self->fd,
> +				   _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
> +				   &access_cmd));
> +		test_cmd_destroy_access_pages(
> +			access_cmd.id,
> +			access_cmd.access_pages.out_access_pages_id);
> +
> +		/* Double user */
> +		ASSERT_EQ(0, ioctl(self->fd,
> +				   _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
> +				   &access_cmd));
> +		access_pages_id = access_cmd.access_pages.out_access_pages_id;
> +		ASSERT_EQ(0, ioctl(self->fd,
> +				   _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
> +				   &access_cmd));
> +		test_cmd_destroy_access_pages(
> +			access_cmd.id,
> +			access_cmd.access_pages.out_access_pages_id);
> +		test_cmd_destroy_access_pages(access_cmd.id, access_pages_id);
> +
> +		/* Add/remove a domain with a user */
> +		ASSERT_EQ(0, ioctl(self->fd,
> +				   _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
> +				   &access_cmd));
> +		test_cmd_mock_domain(self->ioas_id, &mock_device_id,
> +				     &mock_hwpt_id);
> +		check_map_cmd.id = mock_hwpt_id;
> +		ASSERT_EQ(0, ioctl(self->fd,
> +				   _IOMMU_TEST_CMD(IOMMU_TEST_OP_MD_CHECK_MAP),
> +				   &check_map_cmd));
> +
> +		test_ioctl_destroy(mock_device_id);
> +		test_ioctl_destroy(mock_hwpt_id);
> +		test_cmd_destroy_access_pages(
> +			access_cmd.id,
> +			access_cmd.access_pages.out_access_pages_id);
> +
> +		test_ioctl_ioas_unmap(MOCK_APERTURE_START, BUFFER_SIZE);
> +	}
> +	test_cmd_destroy_access(access_cmd.id);
> +}
> +
> +TEST_F(iommufd_ioas, access_pin_unmap)
> +{
> +	struct iommu_test_cmd access_pages_cmd = {
> +		.size = sizeof(access_pages_cmd),
> +		.op = IOMMU_TEST_OP_ACCESS_PAGES,
> +		.access_pages = { .iova = MOCK_APERTURE_START,
> +				  .length = BUFFER_SIZE,
> +				  .uptr = (uintptr_t)buffer },
> +	};
> +
> +	test_cmd_create_access(self->ioas_id, &access_pages_cmd.id,
> +			       MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES);
> +	test_ioctl_ioas_map_fixed(buffer, BUFFER_SIZE, MOCK_APERTURE_START);
> +	ASSERT_EQ(0,
> +		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
> +			&access_pages_cmd));
> +
> +	/* Trigger the unmap op */
> +	test_ioctl_ioas_unmap(MOCK_APERTURE_START, BUFFER_SIZE);
> +
> +	/* kernel removed the item for us */
> +	test_err_destroy_access_pages(
> +		ENOENT, access_pages_cmd.id,
> +		access_pages_cmd.access_pages.out_access_pages_id);
> +}
> +
> +static void check_access_rw(struct __test_metadata *_metadata, int fd,
> +			    unsigned int access_id, uint64_t iova,
> +			    unsigned int def_flags)
> +{
> +	uint16_t tmp[32];
> +	struct iommu_test_cmd access_cmd = {
> +		.size = sizeof(access_cmd),
> +		.op = IOMMU_TEST_OP_ACCESS_RW,
> +		.id = access_id,
> +		.access_rw = { .uptr = (uintptr_t)tmp },
> +	};
> +	uint16_t *buffer16 = buffer;
> +	unsigned int i;
> +	void *tmp2;
> +
> +	for (i = 0; i != BUFFER_SIZE / sizeof(*buffer16); i++)
> +		buffer16[i] = rand();
> +
> +	for (access_cmd.access_rw.iova = iova + PAGE_SIZE - 50;
> +	     access_cmd.access_rw.iova < iova + PAGE_SIZE + 50;
> +	     access_cmd.access_rw.iova++) {
> +		for (access_cmd.access_rw.length = 1;
> +		     access_cmd.access_rw.length < sizeof(tmp);
> +		     access_cmd.access_rw.length++) {
> +			access_cmd.access_rw.flags = def_flags;
> +			ASSERT_EQ(0, ioctl(fd,
> +					   _IOMMU_TEST_CMD(
> +						   IOMMU_TEST_OP_ACCESS_RW),
> +					   &access_cmd));
> +			ASSERT_EQ(0,
> +				  memcmp(buffer + (access_cmd.access_rw.iova -
> +						   iova),
> +					 tmp, access_cmd.access_rw.length));
> +
> +			for (i = 0; i != ARRAY_SIZE(tmp); i++)
> +				tmp[i] = rand();
> +			access_cmd.access_rw.flags = def_flags |
> +						     MOCK_ACCESS_RW_WRITE;
> +			ASSERT_EQ(0, ioctl(fd,
> +					   _IOMMU_TEST_CMD(
> +						   IOMMU_TEST_OP_ACCESS_RW),
> +					   &access_cmd));
> +			ASSERT_EQ(0,
> +				  memcmp(buffer + (access_cmd.access_rw.iova -
> +						   iova),
> +					 tmp, access_cmd.access_rw.length));
> +		}
> +	}
> +
> +	/* Multi-page test */
> +	tmp2 = malloc(BUFFER_SIZE);
> +	ASSERT_NE(NULL, tmp2);
> +	access_cmd.access_rw.iova = iova;
> +	access_cmd.access_rw.length = BUFFER_SIZE;
> +	access_cmd.access_rw.flags = def_flags;
> +	access_cmd.access_rw.uptr = (uintptr_t)tmp2;
> +	ASSERT_EQ(0, ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_RW),
> +			   &access_cmd));
> +	ASSERT_EQ(0, memcmp(buffer, tmp2, access_cmd.access_rw.length));
> +	free(tmp2);
> +}
> +
> +TEST_F(iommufd_ioas, access_rw)
> +{
> +	__u32 access_id;
> +	__u64 iova;
> +
> +	test_cmd_create_access(self->ioas_id, &access_id, 0);
> +	test_ioctl_ioas_map(buffer, BUFFER_SIZE, &iova);
> +	check_access_rw(_metadata, self->fd, access_id, iova, 0);
> +	check_access_rw(_metadata, self->fd, access_id, iova,
> +			MOCK_ACCESS_RW_SLOW_PATH);
> +	test_ioctl_ioas_unmap(iova, BUFFER_SIZE);
> +	test_cmd_destroy_access(access_id);
> +}
> +
> +TEST_F(iommufd_ioas, access_rw_unaligned)
> +{
> +	__u32 access_id;
> +	__u64 iova;
> +
> +	test_cmd_create_access(self->ioas_id, &access_id, 0);
> +
> +	/* Unaligned pages */
> +	iova = self->base_iova + MOCK_PAGE_SIZE;
> +	test_ioctl_ioas_map_fixed(buffer, BUFFER_SIZE, iova);
> +	check_access_rw(_metadata, self->fd, access_id, iova, 0);
> +	test_ioctl_ioas_unmap(iova, BUFFER_SIZE);
> +	test_cmd_destroy_access(access_id);
> +}
> +
> +TEST_F(iommufd_ioas, fork_gone)
> +{
> +	__u32 access_id;
> +	pid_t child;
> +
> +	test_cmd_create_access(self->ioas_id, &access_id, 0);
> +
> +	/* Create a mapping with a different mm */
> +	child = fork();
> +	if (!child) {
> +		test_ioctl_ioas_map_fixed(buffer, BUFFER_SIZE,
> +					  MOCK_APERTURE_START);
> +		exit(0);
> +	}
> +	ASSERT_NE(-1, child);
> +	ASSERT_EQ(child, waitpid(child, NULL, 0));
> +
> +	if (self->domain_id) {
> +		/*
> +		 * If a domain already existed then everything was pinned within
> +		 * the fork, so this copies from one domain to another.
> +		 */
> +		test_cmd_mock_domain(self->ioas_id, NULL, NULL);
> +		check_access_rw(_metadata, self->fd, access_id,
> +				MOCK_APERTURE_START, 0);
> +
> +	} else {
> +		/*
> +		 * Otherwise we need to actually pin pages which can't happen
> +		 * since the fork is gone.
> +		 */
> +		test_err_mock_domain(EFAULT, self->ioas_id, NULL, NULL);
> +	}
> +
> +	test_cmd_destroy_access(access_id);
> +}
> +
> +TEST_F(iommufd_ioas, fork_present)
> +{
> +	__u32 access_id;
> +	int pipefds[2];
> +	uint64_t tmp;
> +	pid_t child;
> +	int efd;
> +
> +	test_cmd_create_access(self->ioas_id, &access_id, 0);
> +
> +	ASSERT_EQ(0, pipe2(pipefds, O_CLOEXEC));
> +	efd = eventfd(0, EFD_CLOEXEC);
> +	ASSERT_NE(-1, efd);
> +
> +	/* Create a mapping with a different mm */
> +	child = fork();
> +	if (!child) {
> +		__u64 iova;
> +		uint64_t one = 1;
> +
> +		close(pipefds[1]);
> +		test_ioctl_ioas_map_fixed(buffer, BUFFER_SIZE,
> +					  MOCK_APERTURE_START);
> +		if (write(efd, &one, sizeof(one)) != sizeof(one))
> +			exit(100);
> +		if (read(pipefds[0], &iova, 1) != 1)
> +			exit(100);
> +		exit(0);
> +	}
> +	close(pipefds[0]);
> +	ASSERT_NE(-1, child);
> +	ASSERT_EQ(8, read(efd, &tmp, sizeof(tmp)));
> +
> +	/* Read pages from the remote process */
> +	test_cmd_mock_domain(self->ioas_id, NULL, NULL);
> +	check_access_rw(_metadata, self->fd, access_id, MOCK_APERTURE_START, 0);
> +
> +	ASSERT_EQ(0, close(pipefds[1]));
> +	ASSERT_EQ(child, waitpid(child, NULL, 0));
> +
> +	test_cmd_destroy_access(access_id);
> +}
> +
> +TEST_F(iommufd_ioas, ioas_option_huge_pages)
> +{
> +	struct iommu_option cmd = {
> +		.size = sizeof(cmd),
> +		.option_id = IOMMU_OPTION_HUGE_PAGES,
> +		.op = IOMMU_OPTION_OP_GET,
> +		.val64 = 3,
> +		.object_id = self->ioas_id,
> +	};
> +
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +	ASSERT_EQ(1, cmd.val64);
> +
> +	cmd.op = IOMMU_OPTION_OP_SET;
> +	cmd.val64 = 0;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +
> +	cmd.op = IOMMU_OPTION_OP_GET;
> +	cmd.val64 = 3;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +	ASSERT_EQ(0, cmd.val64);
> +
> +	cmd.op = IOMMU_OPTION_OP_SET;
> +	cmd.val64 = 2;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +
> +	cmd.op = IOMMU_OPTION_OP_SET;
> +	cmd.val64 = 1;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +}
> +
> +TEST_F(iommufd_ioas, ioas_iova_alloc)
> +{
> +	unsigned int length;
> +	__u64 iova;
> +
> +	for (length = 1; length != PAGE_SIZE * 2; length++) {
> +		if (variant->mock_domains && (length % MOCK_PAGE_SIZE)) {
> +			test_err_ioctl_ioas_map(EINVAL, buffer, length, &iova);
> +		} else {
> +			test_ioctl_ioas_map(buffer, length, &iova);
> +			test_ioctl_ioas_unmap(iova, length);
> +		}
> +	}
> +}
> +
> +TEST_F(iommufd_ioas, ioas_align_change)
> +{
> +	struct iommu_option cmd = {
> +		.size = sizeof(cmd),
> +		.option_id = IOMMU_OPTION_HUGE_PAGES,
> +		.op = IOMMU_OPTION_OP_SET,
> +		.object_id = self->ioas_id,
> +		/* 0 means everything must be aligned to PAGE_SIZE */
> +		.val64 = 0,
> +	};
> +
> +	/*
> +	 * We cannot upgrade the alignment using OPTION_HUGE_PAGES when a domain
> +	 * and map are present.
> +	 */
> +	if (variant->mock_domains)
> +		return;
> +
> +	/*
> +	 * We can upgrade to PAGE_SIZE alignment when things are aligned right
> +	 */
> +	test_ioctl_ioas_map_fixed(buffer, PAGE_SIZE, MOCK_APERTURE_START);
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +
> +	/* Misalignment is rejected at map time */
> +	test_err_ioctl_ioas_map_fixed(EINVAL, buffer + MOCK_PAGE_SIZE,
> +				      PAGE_SIZE,
> +				      MOCK_APERTURE_START + PAGE_SIZE);
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +
> +	/* Reduce alignment */
> +	cmd.val64 = 1;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +
> +	/* Confirm misalignment is rejected during alignment upgrade */
> +	test_ioctl_ioas_map_fixed(buffer + MOCK_PAGE_SIZE, PAGE_SIZE,
> +				  MOCK_APERTURE_START + PAGE_SIZE);
> +	cmd.val64 = 0;
> +	EXPECT_ERRNO(EADDRINUSE, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +
> +	test_ioctl_ioas_unmap(MOCK_APERTURE_START + PAGE_SIZE, PAGE_SIZE);
> +	test_ioctl_ioas_unmap(MOCK_APERTURE_START, PAGE_SIZE);
> +}
> +
> +TEST_F(iommufd_ioas, copy_sweep)
> +{
> +	struct iommu_ioas_copy copy_cmd = {
> +		.size = sizeof(copy_cmd),
> +		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
> +		.src_ioas_id = self->ioas_id,
> +		.dst_iova = MOCK_APERTURE_START,
> +		.length = MOCK_PAGE_SIZE,
> +	};
> +	unsigned int dst_ioas_id;
> +	uint64_t last_iova;
> +	uint64_t iova;
> +
> +	test_ioctl_ioas_alloc(&dst_ioas_id);
> +	copy_cmd.dst_ioas_id = dst_ioas_id;
> +
> +	if (variant->mock_domains)
> +		last_iova = MOCK_APERTURE_START + BUFFER_SIZE - 1;
> +	else
> +		last_iova = MOCK_APERTURE_START + BUFFER_SIZE - 2;
> +
> +	test_ioctl_ioas_map_fixed(buffer, last_iova - MOCK_APERTURE_START + 1,
> +				  MOCK_APERTURE_START);
> +
> +	for (iova = MOCK_APERTURE_START - PAGE_SIZE; iova <= last_iova;
> +	     iova += 511) {
> +		copy_cmd.src_iova = iova;
> +		if (iova < MOCK_APERTURE_START ||
> +		    iova + copy_cmd.length - 1 > last_iova) {
> +			EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_IOAS_COPY,
> +						   &copy_cmd));
> +		} else {
> +			ASSERT_EQ(0,
> +				  ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd));
> +			test_ioctl_ioas_unmap_id(dst_ioas_id, copy_cmd.dst_iova,
> +						 copy_cmd.length);
> +		}
> +	}
> +
> +	test_ioctl_destroy(dst_ioas_id);
> +}
> +
> +FIXTURE(iommufd_mock_domain)
> +{
> +	int fd;
> +	uint32_t ioas_id;
> +	uint32_t domain_id;
> +	uint32_t domain_ids[2];
> +	int mmap_flags;
> +	size_t mmap_buf_size;
> +};
> +
> +FIXTURE_VARIANT(iommufd_mock_domain)
> +{
> +	unsigned int mock_domains;
> +	bool hugepages;
> +};
> +
> +FIXTURE_SETUP(iommufd_mock_domain)
> +{
> +	unsigned int i;
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	ASSERT_NE(-1, self->fd);
> +	test_ioctl_ioas_alloc(&self->ioas_id);
> +
> +	ASSERT_GE(ARRAY_SIZE(self->domain_ids), variant->mock_domains);
> +
> +	for (i = 0; i != variant->mock_domains; i++)
> +		test_cmd_mock_domain(self->ioas_id, NULL, &self->domain_ids[i]);
> +	self->domain_id = self->domain_ids[0];
> +
> +	self->mmap_flags = MAP_SHARED | MAP_ANONYMOUS;
> +	self->mmap_buf_size = PAGE_SIZE * 8;
> +	if (variant->hugepages) {
> +		/*
> +		 * MAP_POPULATE will cause the kernel to fail mmap if THPs are
> +		 * not available.
> +		 */
> +		self->mmap_flags |= MAP_HUGETLB | MAP_POPULATE;
> +		self->mmap_buf_size = HUGEPAGE_SIZE * 2;
> +	}
> +}
> +
> +FIXTURE_TEARDOWN(iommufd_mock_domain)
> +{
> +	teardown_iommufd(self->fd, _metadata);
> +}
> +
> +FIXTURE_VARIANT_ADD(iommufd_mock_domain, one_domain)
> +{
> +	.mock_domains = 1,
> +	.hugepages = false,
> +};
> +
> +FIXTURE_VARIANT_ADD(iommufd_mock_domain, two_domains)
> +{
> +	.mock_domains = 2,
> +	.hugepages = false,
> +};
> +
> +FIXTURE_VARIANT_ADD(iommufd_mock_domain, one_domain_hugepage)
> +{
> +	.mock_domains = 1,
> +	.hugepages = true,
> +};
> +
> +FIXTURE_VARIANT_ADD(iommufd_mock_domain, two_domains_hugepage)
> +{
> +	.mock_domains = 2,
> +	.hugepages = true,
> +};
> +
> +/* Have the kernel check that the user pages made it to the iommu_domain */
> +#define check_mock_iova(_ptr, _iova, _length)                                \
> +	({                                                                   \
> +		struct iommu_test_cmd check_map_cmd = {                      \
> +			.size = sizeof(check_map_cmd),                       \
> +			.op = IOMMU_TEST_OP_MD_CHECK_MAP,                    \
> +			.id = self->domain_id,                               \
> +			.check_map = { .iova = _iova,                        \
> +				       .length = _length,                    \
> +				       .uptr = (uintptr_t)(_ptr) },          \
> +		};                                                           \
> +		ASSERT_EQ(0,                                                 \
> +			  ioctl(self->fd,                                    \
> +				_IOMMU_TEST_CMD(IOMMU_TEST_OP_MD_CHECK_MAP), \
> +				&check_map_cmd));                            \
> +		if (self->domain_ids[1]) {                                   \
> +			check_map_cmd.id = self->domain_ids[1];              \
> +			ASSERT_EQ(0,                                         \
> +				  ioctl(self->fd,                            \
> +					_IOMMU_TEST_CMD(                     \
> +						IOMMU_TEST_OP_MD_CHECK_MAP), \
> +					&check_map_cmd));                    \
> +		}                                                            \
> +	})
> +
> +TEST_F(iommufd_mock_domain, basic)
> +{
> +	size_t buf_size = self->mmap_buf_size;
> +	uint8_t *buf;
> +	__u64 iova;
> +
> +	/* Simple one page map */
> +	test_ioctl_ioas_map(buffer, PAGE_SIZE, &iova);
> +	check_mock_iova(buffer, iova, PAGE_SIZE);
> +
> +	buf = mmap(0, buf_size, PROT_READ | PROT_WRITE, self->mmap_flags, -1,
> +		   0);
> +	ASSERT_NE(MAP_FAILED, buf);
> +
> +	/* EFAULT half way through mapping */
> +	ASSERT_EQ(0, munmap(buf + buf_size / 2, buf_size / 2));
> +	test_err_ioctl_ioas_map(EFAULT, buf, buf_size, &iova);
> +
> +	/* EFAULT on first page */
> +	ASSERT_EQ(0, munmap(buf, buf_size / 2));
> +	test_err_ioctl_ioas_map(EFAULT, buf, buf_size, &iova);
> +}
> +
> +TEST_F(iommufd_mock_domain, ro_unshare)
> +{
> +	uint8_t *buf;
> +	__u64 iova;
> +	int fd;
> +
> +	fd = open("/proc/self/exe", O_RDONLY);
> +	ASSERT_NE(-1, fd);
> +
> +	buf = mmap(0, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
> +	ASSERT_NE(MAP_FAILED, buf);
> +	close(fd);
> +
> +	/*
> +	 * There have been lots of changes to the "unshare" mechanism in
> +	 * get_user_pages(), make sure it works right. The write to the page
> +	 * after we map it for reading should not change the assigned PFN.
> +	 */
> +	ASSERT_EQ(0,
> +		  _test_ioctl_ioas_map(self->fd, self->ioas_id, buf, PAGE_SIZE,
> +				       &iova, IOMMU_IOAS_MAP_READABLE));
> +	check_mock_iova(buf, iova, PAGE_SIZE);
> +	memset(buf, 1, PAGE_SIZE);
> +	check_mock_iova(buf, iova, PAGE_SIZE);
> +	ASSERT_EQ(0, munmap(buf, PAGE_SIZE));
> +}
> +
> +TEST_F(iommufd_mock_domain, all_aligns)
> +{
> +	size_t test_step = variant->hugepages ? (self->mmap_buf_size / 16) :
> +						MOCK_PAGE_SIZE;
> +	size_t buf_size = self->mmap_buf_size;
> +	unsigned int start;
> +	unsigned int end;
> +	uint8_t *buf;
> +
> +	buf = mmap(0, buf_size, PROT_READ | PROT_WRITE, self->mmap_flags, -1,
> +		   0);
> +	ASSERT_NE(MAP_FAILED, buf);
> +	check_refs(buf, buf_size, 0);
> +
> +	/*
> +	 * Map every combination of page size and alignment within a big region,
> +	 * less for hugepage case as it takes so long to finish.
> +	 */
> +	for (start = 0; start < buf_size; start += test_step) {
> +		if (variant->hugepages)
> +			end = buf_size;
> +		else
> +			end = start + MOCK_PAGE_SIZE;
> +		for (; end < buf_size; end += MOCK_PAGE_SIZE) {
> +			size_t length = end - start;
> +			__u64 iova;
> +
> +			test_ioctl_ioas_map(buf + start, length, &iova);
> +			check_mock_iova(buf + start, iova, length);
> +			check_refs(buf + start / PAGE_SIZE * PAGE_SIZE,
> +				   end / PAGE_SIZE * PAGE_SIZE -
> +					   start / PAGE_SIZE * PAGE_SIZE,
> +				   1);
> +
> +			test_ioctl_ioas_unmap(iova, length);
> +		}
> +	}
> +	check_refs(buf, buf_size, 0);
> +	ASSERT_EQ(0, munmap(buf, buf_size));
> +}
> +
> +TEST_F(iommufd_mock_domain, all_aligns_copy)
> +{
> +	size_t test_step = variant->hugepages ? self->mmap_buf_size / 16 :
> +						MOCK_PAGE_SIZE;
> +	size_t buf_size = self->mmap_buf_size;
> +	unsigned int start;
> +	unsigned int end;
> +	uint8_t *buf;
> +
> +	buf = mmap(0, buf_size, PROT_READ | PROT_WRITE, self->mmap_flags, -1,
> +		   0);
> +	ASSERT_NE(MAP_FAILED, buf);
> +	check_refs(buf, buf_size, 0);
> +
> +	/*
> +	 * Map every combination of page size and alignment within a big region,
> +	 * less for hugepage case as it takes so long to finish.
> +	 */
> +	for (start = 0; start < buf_size; start += test_step) {
> +		if (variant->hugepages)
> +			end = buf_size;
> +		else
> +			end = start + MOCK_PAGE_SIZE;
> +		for (; end < buf_size; end += MOCK_PAGE_SIZE) {
> +			size_t length = end - start;
> +			unsigned int old_id;
> +			uint32_t mock_device_id;
> +			__u64 iova;
> +
> +			test_ioctl_ioas_map(buf + start, length, &iova);
> +
> +			/* Add and destroy a domain while the area exists */
> +			old_id = self->domain_ids[1];
> +			test_cmd_mock_domain(self->ioas_id, &mock_device_id,
> +					     &self->domain_ids[1]);
> +
> +			check_mock_iova(buf + start, iova, length);
> +			check_refs(buf + start / PAGE_SIZE * PAGE_SIZE,
> +				   end / PAGE_SIZE * PAGE_SIZE -
> +					   start / PAGE_SIZE * PAGE_SIZE,
> +				   1);
> +
> +			test_ioctl_destroy(mock_device_id);
> +			test_ioctl_destroy(self->domain_ids[1]);
> +			self->domain_ids[1] = old_id;
> +
> +			test_ioctl_ioas_unmap(iova, length);
> +		}
> +	}
> +	check_refs(buf, buf_size, 0);
> +	ASSERT_EQ(0, munmap(buf, buf_size));
> +}
> +
> +TEST_F(iommufd_mock_domain, user_copy)
> +{
> +	struct iommu_test_cmd access_cmd = {
> +		.size = sizeof(access_cmd),
> +		.op = IOMMU_TEST_OP_ACCESS_PAGES,
> +		.access_pages = { .length = BUFFER_SIZE,
> +				  .uptr = (uintptr_t)buffer },
> +	};
> +	struct iommu_ioas_copy copy_cmd = {
> +		.size = sizeof(copy_cmd),
> +		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
> +		.dst_ioas_id = self->ioas_id,
> +		.dst_iova = MOCK_APERTURE_START,
> +		.length = BUFFER_SIZE,
> +	};
> +	unsigned int ioas_id;
> +
> +	/* Pin the pages in an IOAS with no domains then copy to an IOAS with domains */
> +	test_ioctl_ioas_alloc(&ioas_id);
> +	test_ioctl_ioas_map_id(ioas_id, buffer, BUFFER_SIZE,
> +			       &copy_cmd.src_iova);
> +
> +	test_cmd_create_access(ioas_id, &access_cmd.id,
> +			       MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES);
> +
> +	access_cmd.access_pages.iova = copy_cmd.src_iova;
> +	ASSERT_EQ(0,
> +		  ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_PAGES),
> +			&access_cmd));
> +	copy_cmd.src_ioas_id = ioas_id;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd));
> +	check_mock_iova(buffer, MOCK_APERTURE_START, BUFFER_SIZE);
> +
> +	test_cmd_destroy_access_pages(
> +		access_cmd.id, access_cmd.access_pages.out_access_pages_id);
> +	test_cmd_destroy_access(access_cmd.id) test_ioctl_destroy(ioas_id);
> +
> +	test_ioctl_destroy(ioas_id);
> +}
> +
> +/* VFIO compatibility IOCTLs */
> +
> +TEST_F(iommufd, simple_ioctls)
> +{
> +	ASSERT_EQ(VFIO_API_VERSION, ioctl(self->fd, VFIO_GET_API_VERSION));
> +	ASSERT_EQ(1, ioctl(self->fd, VFIO_CHECK_EXTENSION, VFIO_TYPE1v2_IOMMU));
> +}
> +
> +TEST_F(iommufd, unmap_cmd)
> +{
> +	struct vfio_iommu_type1_dma_unmap unmap_cmd = {
> +		.iova = MOCK_APERTURE_START,
> +		.size = PAGE_SIZE,
> +	};
> +
> +	unmap_cmd.argsz = 1;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
> +
> +	unmap_cmd.argsz = sizeof(unmap_cmd);
> +	unmap_cmd.flags = 1 << 31;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
> +
> +	unmap_cmd.flags = 0;
> +	EXPECT_ERRNO(ENODEV, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
> +}
> +
> +TEST_F(iommufd, map_cmd)
> +{
> +	struct vfio_iommu_type1_dma_map map_cmd = {
> +		.iova = MOCK_APERTURE_START,
> +		.size = PAGE_SIZE,
> +		.vaddr = (__u64)buffer,
> +	};
> +
> +	map_cmd.argsz = 1;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
> +
> +	map_cmd.argsz = sizeof(map_cmd);
> +	map_cmd.flags = 1 << 31;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
> +
> +	/* Requires a domain to be attached */
> +	map_cmd.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
> +	EXPECT_ERRNO(ENODEV, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
> +}
> +
> +TEST_F(iommufd, info_cmd)
> +{
> +	struct vfio_iommu_type1_info info_cmd = {};
> +
> +	/* Invalid argsz */
> +	info_cmd.argsz = 1;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_GET_INFO, &info_cmd));
> +
> +	info_cmd.argsz = sizeof(info_cmd);
> +	EXPECT_ERRNO(ENODEV, ioctl(self->fd, VFIO_IOMMU_GET_INFO, &info_cmd));
> +}
> +
> +TEST_F(iommufd, set_iommu_cmd)
> +{
> +	/* Requires a domain to be attached */
> +	EXPECT_ERRNO(ENODEV,
> +		     ioctl(self->fd, VFIO_SET_IOMMU, VFIO_TYPE1v2_IOMMU));
> +	EXPECT_ERRNO(ENODEV, ioctl(self->fd, VFIO_SET_IOMMU, VFIO_TYPE1_IOMMU));
> +}
> +
> +TEST_F(iommufd, vfio_ioas)
> +{
> +	struct iommu_vfio_ioas vfio_ioas_cmd = {
> +		.size = sizeof(vfio_ioas_cmd),
> +		.op = IOMMU_VFIO_IOAS_GET,
> +	};
> +	__u32 ioas_id;
> +
> +	/* ENODEV if there is no compat ioas */
> +	EXPECT_ERRNO(ENODEV, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
> +
> +	/* Invalid id for set */
> +	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_SET;
> +	EXPECT_ERRNO(ENOENT, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
> +
> +	/* Valid id for set*/
> +	test_ioctl_ioas_alloc(&ioas_id);
> +	vfio_ioas_cmd.ioas_id = ioas_id;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
> +
> +	/* Same id comes back from get */
> +	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_GET;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
> +	ASSERT_EQ(ioas_id, vfio_ioas_cmd.ioas_id);
> +
> +	/* Clear works */
> +	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_CLEAR;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
> +	vfio_ioas_cmd.op = IOMMU_VFIO_IOAS_GET;
> +	EXPECT_ERRNO(ENODEV, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
> +}
> +
> +FIXTURE(vfio_compat_mock_domain)
> +{
> +	int fd;
> +	uint32_t ioas_id;
> +};
> +
> +FIXTURE_VARIANT(vfio_compat_mock_domain)
> +{
> +	unsigned int version;
> +};
> +
> +FIXTURE_SETUP(vfio_compat_mock_domain)
> +{
> +	struct iommu_vfio_ioas vfio_ioas_cmd = {
> +		.size = sizeof(vfio_ioas_cmd),
> +		.op = IOMMU_VFIO_IOAS_SET,
> +	};
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	ASSERT_NE(-1, self->fd);
> +
> +	/* Create what VFIO would consider a group */
> +	test_ioctl_ioas_alloc(&self->ioas_id);
> +	test_cmd_mock_domain(self->ioas_id, NULL, NULL);
> +
> +	/* Attach it to the vfio compat */
> +	vfio_ioas_cmd.ioas_id = self->ioas_id;
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_VFIO_IOAS, &vfio_ioas_cmd));
> +	ASSERT_EQ(0, ioctl(self->fd, VFIO_SET_IOMMU, variant->version));
> +}
> +
> +FIXTURE_TEARDOWN(vfio_compat_mock_domain)
> +{
> +	teardown_iommufd(self->fd, _metadata);
> +}
> +
> +FIXTURE_VARIANT_ADD(vfio_compat_mock_domain, Ver1v2)
> +{
> +	.version = VFIO_TYPE1v2_IOMMU,
> +};
> +
> +FIXTURE_VARIANT_ADD(vfio_compat_mock_domain, Ver1v0)
> +{
> +	.version = VFIO_TYPE1_IOMMU,
> +};
> +
> +TEST_F(vfio_compat_mock_domain, simple_close)
> +{
> +}
> +
> +TEST_F(vfio_compat_mock_domain, option_huge_pages)
> +{
> +	struct iommu_option cmd = {
> +		.size = sizeof(cmd),
> +		.option_id = IOMMU_OPTION_HUGE_PAGES,
> +		.op = IOMMU_OPTION_OP_GET,
> +		.val64 = 3,
> +		.object_id = self->ioas_id,
> +	};
> +
> +	ASSERT_EQ(0, ioctl(self->fd, IOMMU_OPTION, &cmd));
> +	if (variant->version == VFIO_TYPE1_IOMMU) {
> +		ASSERT_EQ(0, cmd.val64);
> +	} else {
> +		ASSERT_EQ(1, cmd.val64);
> +	}
> +}
> +
> +/*
> + * Execute an ioctl command stored in buffer and check that the result does not
> + * overflow memory.
> + */
> +static bool is_filled(const void *buf, uint8_t c, size_t len)
> +{
> +	const uint8_t *cbuf = buf;
> +
> +	for (; len; cbuf++, len--)
> +		if (*cbuf != c)
> +			return false;
> +	return true;
> +}
> +
> +#define ioctl_check_buf(fd, cmd)                                         \
> +	({                                                               \
> +		size_t _cmd_len = *(__u32 *)buffer;                      \
> +									 \
> +		memset(buffer + _cmd_len, 0xAA, BUFFER_SIZE - _cmd_len); \
> +		ASSERT_EQ(0, ioctl(fd, cmd, buffer));                    \
> +		ASSERT_EQ(true, is_filled(buffer + _cmd_len, 0xAA,       \
> +					  BUFFER_SIZE - _cmd_len));      \
> +	})
> +
> +static void check_vfio_info_cap_chain(struct __test_metadata *_metadata,
> +				      struct vfio_iommu_type1_info *info_cmd)
> +{
> +	const struct vfio_info_cap_header *cap;
> +
> +	ASSERT_GE(info_cmd->argsz, info_cmd->cap_offset + sizeof(*cap));
> +	cap = buffer + info_cmd->cap_offset;
> +	while (true) {
> +		size_t cap_size;
> +
> +		if (cap->next)
> +			cap_size = (buffer + cap->next) - (void *)cap;
> +		else
> +			cap_size = (buffer + info_cmd->argsz) - (void *)cap;
> +
> +		switch (cap->id) {
> +		case VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE: {
> +			struct vfio_iommu_type1_info_cap_iova_range *data =
> +				(void *)cap;
> +
> +			ASSERT_EQ(1, data->header.version);
> +			ASSERT_EQ(1, data->nr_iovas);
> +			EXPECT_EQ(MOCK_APERTURE_START,
> +				  data->iova_ranges[0].start);
> +			EXPECT_EQ(MOCK_APERTURE_LAST, data->iova_ranges[0].end);
> +			break;
> +		}
> +		case VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL: {
> +			struct vfio_iommu_type1_info_dma_avail *data =
> +				(void *)cap;
> +
> +			ASSERT_EQ(1, data->header.version);
> +			ASSERT_EQ(sizeof(*data), cap_size);
> +			break;
> +		}
> +		default:
> +			ASSERT_EQ(false, true);
> +			break;
> +		}
> +		if (!cap->next)
> +			break;
> +
> +		ASSERT_GE(info_cmd->argsz, cap->next + sizeof(*cap));
> +		ASSERT_GE(buffer + cap->next, (void *)cap);
> +		cap = buffer + cap->next;
> +	}
> +}
> +
> +TEST_F(vfio_compat_mock_domain, get_info)
> +{
> +	struct vfio_iommu_type1_info *info_cmd = buffer;
> +	unsigned int i;
> +	size_t caplen;
> +
> +	/* Pre-cap ABI */
> +	*info_cmd = (struct vfio_iommu_type1_info){
> +		.argsz = offsetof(struct vfio_iommu_type1_info, cap_offset),
> +	};
> +	ioctl_check_buf(self->fd, VFIO_IOMMU_GET_INFO);
> +	ASSERT_NE(0, info_cmd->iova_pgsizes);
> +	ASSERT_EQ(VFIO_IOMMU_INFO_PGSIZES | VFIO_IOMMU_INFO_CAPS,
> +		  info_cmd->flags);
> +
> +	/* Read the cap chain size */
> +	*info_cmd = (struct vfio_iommu_type1_info){
> +		.argsz = sizeof(*info_cmd),
> +	};
> +	ioctl_check_buf(self->fd, VFIO_IOMMU_GET_INFO);
> +	ASSERT_NE(0, info_cmd->iova_pgsizes);
> +	ASSERT_EQ(VFIO_IOMMU_INFO_PGSIZES | VFIO_IOMMU_INFO_CAPS,
> +		  info_cmd->flags);
> +	ASSERT_EQ(0, info_cmd->cap_offset);
> +	ASSERT_LT(sizeof(*info_cmd), info_cmd->argsz);
> +
> +	/* Read the caps, kernel should never create a corrupted caps */
> +	caplen = info_cmd->argsz;
> +	for (i = sizeof(*info_cmd); i < caplen; i++) {
> +		*info_cmd = (struct vfio_iommu_type1_info){
> +			.argsz = i,
> +		};
> +		ioctl_check_buf(self->fd, VFIO_IOMMU_GET_INFO);
> +		ASSERT_EQ(VFIO_IOMMU_INFO_PGSIZES | VFIO_IOMMU_INFO_CAPS,
> +			  info_cmd->flags);
> +		if (!info_cmd->cap_offset)
> +			continue;
> +		check_vfio_info_cap_chain(_metadata, info_cmd);
> +	}
> +}
> +
> +static void shuffle_array(unsigned long *array, size_t nelms)
> +{
> +	unsigned int i;
> +
> +	/* Shuffle */
> +	for (i = 0; i != nelms; i++) {
> +		unsigned long tmp = array[i];
> +		unsigned int other = rand() % (nelms - i);
> +
> +		array[i] = array[other];
> +		array[other] = tmp;
> +	}
> +}
> +
> +TEST_F(vfio_compat_mock_domain, map)
> +{
> +	struct vfio_iommu_type1_dma_map map_cmd = {
> +		.argsz = sizeof(map_cmd),
> +		.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
> +		.vaddr = (uintptr_t)buffer,
> +		.size = BUFFER_SIZE,
> +		.iova = MOCK_APERTURE_START,
> +	};
> +	struct vfio_iommu_type1_dma_unmap unmap_cmd = {
> +		.argsz = sizeof(unmap_cmd),
> +		.size = BUFFER_SIZE,
> +		.iova = MOCK_APERTURE_START,
> +	};
> +	unsigned long pages_iova[BUFFER_SIZE / PAGE_SIZE];
> +	unsigned int i;
> +
> +	/* Simple map/unmap */
> +	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
> +	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
> +	ASSERT_EQ(BUFFER_SIZE, unmap_cmd.size);
> +
> +	/* UNMAP_FLAG_ALL requres 0 iova/size */
> +	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
> +	unmap_cmd.flags = VFIO_DMA_UNMAP_FLAG_ALL;
> +	EXPECT_ERRNO(EINVAL, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
> +
> +	unmap_cmd.iova = 0;
> +	unmap_cmd.size = 0;
> +	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
> +	ASSERT_EQ(BUFFER_SIZE, unmap_cmd.size);
> +
> +	/* Small pages */
> +	for (i = 0; i != ARRAY_SIZE(pages_iova); i++) {
> +		map_cmd.iova = pages_iova[i] =
> +			MOCK_APERTURE_START + i * PAGE_SIZE;
> +		map_cmd.vaddr = (uintptr_t)buffer + i * PAGE_SIZE;
> +		map_cmd.size = PAGE_SIZE;
> +		ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
> +	}
> +	shuffle_array(pages_iova, ARRAY_SIZE(pages_iova));
> +
> +	unmap_cmd.flags = 0;
> +	unmap_cmd.size = PAGE_SIZE;
> +	for (i = 0; i != ARRAY_SIZE(pages_iova); i++) {
> +		unmap_cmd.iova = pages_iova[i];
> +		ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
> +	}
> +}
> +
> +TEST_F(vfio_compat_mock_domain, huge_map)
> +{
> +	size_t buf_size = HUGEPAGE_SIZE * 2;
> +	struct vfio_iommu_type1_dma_map map_cmd = {
> +		.argsz = sizeof(map_cmd),
> +		.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
> +		.size = buf_size,
> +		.iova = MOCK_APERTURE_START,
> +	};
> +	struct vfio_iommu_type1_dma_unmap unmap_cmd = {
> +		.argsz = sizeof(unmap_cmd),
> +	};
> +	unsigned long pages_iova[16];
> +	unsigned int i;
> +	void *buf;
> +
> +	/* Test huge pages and splitting */
> +	buf = mmap(0, buf_size, PROT_READ | PROT_WRITE,
> +		   MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB | MAP_POPULATE, -1,
> +		   0);
> +	ASSERT_NE(MAP_FAILED, buf);
> +	map_cmd.vaddr = (uintptr_t)buf;
> +	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
> +
> +	unmap_cmd.size = buf_size / ARRAY_SIZE(pages_iova);
> +	for (i = 0; i != ARRAY_SIZE(pages_iova); i++)
> +		pages_iova[i] = MOCK_APERTURE_START + (i * unmap_cmd.size);
> +	shuffle_array(pages_iova, ARRAY_SIZE(pages_iova));
> +
> +	/* type1 mode can cut up larger mappings, type1v2 always fails */
> +	for (i = 0; i != ARRAY_SIZE(pages_iova); i++) {
> +		unmap_cmd.iova = pages_iova[i];
> +		unmap_cmd.size = buf_size / ARRAY_SIZE(pages_iova);
> +		if (variant->version == VFIO_TYPE1_IOMMU) {
> +			ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA,
> +					   &unmap_cmd));
> +		} else {
> +			EXPECT_ERRNO(ENOENT,
> +				     ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA,
> +					   &unmap_cmd));
> +		}
> +	}
> +}
> +
> +TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/iommu/iommufd_fail_nth.c b/tools/testing/selftests/iommu/iommufd_fail_nth.c
> new file mode 100644
> index 00000000000000..9713111b820dd7
> --- /dev/null
> +++ b/tools/testing/selftests/iommu/iommufd_fail_nth.c
> @@ -0,0 +1,580 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
> + *
> + * These tests are "kernel integrity" tests. They are looking for kernel
> + * WARN/OOPS/kasn/etc splats triggered by kernel sanitizers & debugging
> + * features. It does not attempt to verify that the system calls are doing what
> + * they are supposed to do.
> + *
> + * The basic philosophy is to run a sequence of calls that will succeed and then
> + * sweep every failure injection point on that call chain to look for
> + * interesting things in error handling.
> + *
> + * This test is best run with:
> + *  echo 1 > /proc/sys/kernel/panic_on_warn
> + * If something is actually going wrong.
> + */
> +#include <fcntl.h>
> +#include <dirent.h>
> +
> +#define __EXPORTED_HEADERS__
> +#include <linux/vfio.h>
> +
> +#include "iommufd_utils.h"
> +
> +static bool have_fault_injection;
> +
> +static int writeat(int dfd, const char *fn, const char *val)
> +{
> +	size_t val_len = strlen(val);
> +	ssize_t res;
> +	int fd;
> +
> +	fd = openat(dfd, fn, O_WRONLY);
> +	if (fd == -1)
> +		return -1;
> +	res = write(fd, val, val_len);
> +	assert(res == val_len);
> +	close(fd);
> +	return 0;
> +}
> +
> +static __attribute__((constructor)) void setup_buffer(void)
> +{
> +	BUFFER_SIZE = 2*1024*1024;
> +
> +	buffer = mmap(0, BUFFER_SIZE, PROT_READ | PROT_WRITE,
> +		      MAP_SHARED | MAP_ANONYMOUS, -1, 0);
> +}
> +
> +/*
> + * This sets up fail_injection in a way that is useful for this test.
> + * It does not attempt to restore things back to how they were.
> + */
> +static __attribute__((constructor)) void setup_fault_injection(void)
> +{
> +	DIR *debugfs = opendir("/sys/kernel/debug/");
> +	struct dirent *dent;
> +
> +	if (!debugfs)
> +		return;
> +
> +	/* Allow any allocation call to be fault injected */
> +	if (writeat(dirfd(debugfs), "failslab/ignore-gfp-wait", "N"))
> +		return;
> +	writeat(dirfd(debugfs), "fail_page_alloc/ignore-gfp-wait", "N");
> +	writeat(dirfd(debugfs), "fail_page_alloc/ignore-gfp-highmem", "N");
> +
> +	while ((dent = readdir(debugfs))) {
> +		char fn[300];
> +
> +		if (strncmp(dent->d_name, "fail", 4) != 0)
> +			continue;
> +
> +		/* We are looking for kernel splats, quiet down the log */
> +		snprintf(fn, sizeof(fn), "%s/verbose", dent->d_name);
> +		writeat(dirfd(debugfs), fn, "0");
> +	}
> +	closedir(debugfs);
> +	have_fault_injection = true;
> +}
> +
> +struct fail_nth_state {
> +	int proc_fd;
> +	unsigned int iteration;
> +};
> +
> +static void fail_nth_first(struct __test_metadata *_metadata,
> +			   struct fail_nth_state *nth_state)
> +{
> +	char buf[300];
> +
> +	snprintf(buf, sizeof(buf), "/proc/self/task/%u/fail-nth", getpid());
> +	nth_state->proc_fd = open(buf, O_RDWR);
> +	ASSERT_NE(-1, nth_state->proc_fd);
> +}
> +
> +static bool fail_nth_next(struct __test_metadata *_metadata,
> +			  struct fail_nth_state *nth_state,
> +			  int test_result)
> +{
> +	static const char disable_nth[] = "0";
> +	char buf[300];
> +
> +	/*
> +	 * This is just an arbitrary limit based on the current kernel
> +	 * situation. Changes in the kernel can dramtically change the number of
> +	 * required fault injection sites, so if this hits it doesn't
> +	 * necessarily mean a test failure, just that the limit has to be made
> +	 * bigger.
> +	 */
> +	ASSERT_GT(400, nth_state->iteration);
> +	if (nth_state->iteration != 0) {
> +		ssize_t res;
> +		ssize_t res2;
> +
> +		buf[0] = 0;
> +		/*
> +		 * Annoyingly disabling the nth can also fail. This means
> +		 * the test passed without triggering failure
> +		 */
> +		res = pread(nth_state->proc_fd, buf, sizeof(buf), 0);
> +		if (res == -1 && errno == EFAULT) {
> +			buf[0] = '1';
> +			buf[1] = '\n';
> +			res = 2;
> +		}
> +
> +		res2 = pwrite(nth_state->proc_fd, disable_nth,
> +			      ARRAY_SIZE(disable_nth) - 1, 0);
> +		if (res2 == -1 && errno == EFAULT) {
> +			res2 = pwrite(nth_state->proc_fd, disable_nth,
> +				      ARRAY_SIZE(disable_nth) - 1, 0);
> +			buf[0] = '1';
> +			buf[1] = '\n';
> +		}
> +		ASSERT_EQ(ARRAY_SIZE(disable_nth) - 1, res2);
> +
> +		/* printf("  nth %u result=%d nth=%u\n", nth_state->iteration,
> +		       test_result, atoi(buf)); */
> +		fflush(stdout);
> +		ASSERT_LT(1, res);
> +		if (res != 2 || buf[0] != '0' || buf[1] != '\n')
> +			return false;
> +	} else {
> +		/* printf("  nth %u result=%d\n", nth_state->iteration,
> +		       test_result); */
> +	}
> +	nth_state->iteration++;
> +	return true;
> +}
> +
> +/*
> + * This is called during the test to start failure injection. It allows the test
> + * to do some setup that has already been swept and thus reduce the required
> + * iterations.
> + */
> +void __fail_nth_enable(struct __test_metadata *_metadata,
> +		       struct fail_nth_state *nth_state)
> +{
> +	char buf[300];
> +	size_t len;
> +
> +	if (!nth_state->iteration)
> +		return;
> +
> +	len = snprintf(buf, sizeof(buf), "%u", nth_state->iteration);
> +	ASSERT_EQ(len, pwrite(nth_state->proc_fd, buf, len, 0));
> +}
> +#define fail_nth_enable() __fail_nth_enable(_metadata, _nth_state)
> +
> +#define TEST_FAIL_NTH(fixture_name, name)                                           \
> +	static int test_nth_##name(struct __test_metadata *_metadata,               \
> +				   FIXTURE_DATA(fixture_name) *self,                \
> +				   const FIXTURE_VARIANT(fixture_name)              \
> +					   *variant,                                \
> +				   struct fail_nth_state *_nth_state);              \
> +	TEST_F(fixture_name, name)                                                  \
> +	{                                                                           \
> +		struct fail_nth_state nth_state = {};                               \
> +		int test_result = 0;                                                \
> +										    \
> +		if (!have_fault_injection)                                          \
> +			SKIP(return,                                                \
> +				   "fault injection is not enabled in the kernel"); \
> +		fail_nth_first(_metadata, &nth_state);                              \
> +		ASSERT_EQ(0, test_nth_##name(_metadata, self, variant,              \
> +					     &nth_state));                          \
> +		while (fail_nth_next(_metadata, &nth_state, test_result)) {         \
> +			fixture_name##_teardown(_metadata, self, variant);          \
> +			fixture_name##_setup(_metadata, self, variant);             \
> +			test_result = test_nth_##name(_metadata, self,              \
> +						      variant, &nth_state);         \
> +		};                                                                  \
> +		ASSERT_EQ(0, test_result);                                          \
> +	}                                                                           \
> +	static int test_nth_##name(                                                 \
> +		struct __test_metadata __attribute__((unused)) *_metadata,          \
> +		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self,           \
> +		const FIXTURE_VARIANT(fixture_name) __attribute__((unused))         \
> +			*variant,                                                   \
> +		struct fail_nth_state *_nth_state)
> +
> +FIXTURE(basic_fail_nth)
> +{
> +	int fd;
> +	uint32_t access_id;
> +};
> +
> +FIXTURE_SETUP(basic_fail_nth)
> +{
> +	self->fd = -1;
> +	self->access_id = 0;
> +}
> +
> +FIXTURE_TEARDOWN(basic_fail_nth)
> +{
> +	int rc;
> +
> +	if (self->access_id) {
> +		/* The access FD holds the iommufd open until it closes */
> +		rc = _test_cmd_destroy_access(self->access_id);
> +		assert(rc == 0);
> +	}
> +	teardown_iommufd(self->fd, _metadata);
> +}
> +
> +/* Cover ioas.c */
> +TEST_FAIL_NTH(basic_fail_nth, basic)
> +{
> +	struct iommu_iova_range ranges[10];
> +	uint32_t ioas_id;
> +	__u64 iova;
> +
> +	fail_nth_enable();
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	if (self->fd == -1)
> +		return -1;
> +
> +	if (_test_ioctl_ioas_alloc(self->fd, &ioas_id))
> +		return -1;
> +
> +	{
> +		struct iommu_ioas_iova_ranges ranges_cmd = {
> +			.size = sizeof(ranges_cmd),
> +			.num_iovas = ARRAY_SIZE(ranges),
> +			.ioas_id = ioas_id,
> +			.allowed_iovas = (uintptr_t)ranges,
> +		};
> +		if (ioctl(self->fd, IOMMU_IOAS_IOVA_RANGES, &ranges_cmd))
> +			return -1;
> +	}
> +
> +	{
> +		struct iommu_ioas_allow_iovas allow_cmd = {
> +			.size = sizeof(allow_cmd),
> +			.ioas_id = ioas_id,
> +			.num_iovas = 1,
> +			.allowed_iovas = (uintptr_t)ranges,
> +		};
> +
> +		ranges[0].start = 16*1024;
> +		ranges[0].last = BUFFER_SIZE + 16 * 1024 * 600 - 1;
> +		if (ioctl(self->fd, IOMMU_IOAS_ALLOW_IOVAS, &allow_cmd))
> +			return -1;
> +	}
> +
> +	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, BUFFER_SIZE, &iova,
> +				 IOMMU_IOAS_MAP_WRITEABLE |
> +					 IOMMU_IOAS_MAP_READABLE))
> +		return -1;
> +
> +	{
> +		struct iommu_ioas_copy copy_cmd = {
> +			.size = sizeof(copy_cmd),
> +			.flags = IOMMU_IOAS_MAP_WRITEABLE |
> +				 IOMMU_IOAS_MAP_READABLE,
> +			.dst_ioas_id = ioas_id,
> +			.src_ioas_id = ioas_id,
> +			.src_iova = iova,
> +			.length = sizeof(ranges),
> +		};
> +
> +		if (ioctl(self->fd, IOMMU_IOAS_COPY, &copy_cmd))
> +			return -1;
> +	}
> +
> +	if (_test_ioctl_ioas_unmap(self->fd, ioas_id, iova, BUFFER_SIZE,
> +				   NULL))
> +		return -1;
> +	/* Failure path of no IOVA to unmap */
> +	_test_ioctl_ioas_unmap(self->fd, ioas_id, iova, BUFFER_SIZE, NULL);
> +	return 0;
> +}
> +
> +/* iopt_area_fill_domains() and iopt_area_fill_domain() */
> +TEST_FAIL_NTH(basic_fail_nth, map_domain)
> +{
> +	uint32_t ioas_id;
> +	__u32 device_id;
> +	__u32 hwpt_id;
> +	__u64 iova;
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	if (self->fd == -1)
> +		return -1;
> +
> +	if (_test_ioctl_ioas_alloc(self->fd, &ioas_id))
> +		return -1;
> +
> +	if (_test_ioctl_set_temp_memory_limit(self->fd, 32))
> +		return -1;
> +
> +	fail_nth_enable();
> +
> +	if (_test_cmd_mock_domain(self->fd, ioas_id, &device_id, &hwpt_id))
> +		return -1;
> +
> +	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, 262144, &iova,
> +				 IOMMU_IOAS_MAP_WRITEABLE |
> +					 IOMMU_IOAS_MAP_READABLE))
> +		return -1;
> +
> +	if (_test_ioctl_destroy(self->fd, device_id))
> +		return -1;
> +	if (_test_ioctl_destroy(self->fd, hwpt_id))
> +		return -1;
> +
> +	if (_test_cmd_mock_domain(self->fd, ioas_id, &device_id, &hwpt_id))
> +		return -1;
> +	return 0;
> +}
> +
> +TEST_FAIL_NTH(basic_fail_nth, map_two_domains)
> +{
> +	uint32_t ioas_id;
> +	__u32 device_id2;
> +	__u32 device_id;
> +	__u32 hwpt_id2;
> +	__u32 hwpt_id;
> +	__u64 iova;
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	if (self->fd == -1)
> +		return -1;
> +
> +	if (_test_ioctl_ioas_alloc(self->fd, &ioas_id))
> +		return -1;
> +
> +	if (_test_ioctl_set_temp_memory_limit(self->fd, 32))
> +		return -1;
> +
> +	if (_test_cmd_mock_domain(self->fd, ioas_id, &device_id, &hwpt_id))
> +		return -1;
> +
> +	fail_nth_enable();
> +
> +	if (_test_cmd_mock_domain(self->fd, ioas_id, &device_id2, &hwpt_id2))
> +		return -1;
> +
> +	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, 262144, &iova,
> +				 IOMMU_IOAS_MAP_WRITEABLE |
> +					 IOMMU_IOAS_MAP_READABLE))
> +		return -1;
> +
> +	if (_test_ioctl_destroy(self->fd, device_id))
> +		return -1;
> +	if (_test_ioctl_destroy(self->fd, hwpt_id))
> +		return -1;
> +
> +	if (_test_ioctl_destroy(self->fd, device_id2))
> +		return -1;
> +	if (_test_ioctl_destroy(self->fd, hwpt_id2))
> +		return -1;
> +
> +	if (_test_cmd_mock_domain(self->fd, ioas_id, &device_id, &hwpt_id))
> +		return -1;
> +	if (_test_cmd_mock_domain(self->fd, ioas_id, &device_id2, &hwpt_id2))
> +		return -1;
> +	return 0;
> +}
> +
> +TEST_FAIL_NTH(basic_fail_nth, access_rw)
> +{
> +	uint64_t tmp_big[4096];
> +	uint32_t ioas_id;
> +	uint16_t tmp[32];
> +	__u64 iova;
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	if (self->fd == -1)
> +		return -1;
> +
> +	if (_test_ioctl_ioas_alloc(self->fd, &ioas_id))
> +		return -1;
> +
> +	if (_test_ioctl_set_temp_memory_limit(self->fd, 32))
> +		return -1;
> +
> +	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, 262144, &iova,
> +				 IOMMU_IOAS_MAP_WRITEABLE |
> +					 IOMMU_IOAS_MAP_READABLE))
> +		return -1;
> +
> +	fail_nth_enable();
> +
> +	if (_test_cmd_create_access(self->fd, ioas_id, &self->access_id, 0))
> +		return -1;
> +
> +	{
> +		struct iommu_test_cmd access_cmd = {
> +			.size = sizeof(access_cmd),
> +			.op = IOMMU_TEST_OP_ACCESS_RW,
> +			.id = self->access_id,
> +			.access_rw = { .iova = iova,
> +				       .length = sizeof(tmp),
> +				       .uptr = (uintptr_t)tmp },
> +		};
> +
> +		// READ
> +		if (ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_RW),
> +			  &access_cmd))
> +			return -1;
> +
> +		access_cmd.access_rw.flags = MOCK_ACCESS_RW_WRITE;
> +		if (ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_RW),
> +			  &access_cmd))
> +			return -1;
> +
> +		access_cmd.access_rw.flags = MOCK_ACCESS_RW_SLOW_PATH;
> +		if (ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_RW),
> +			  &access_cmd))
> +			return -1;
> +		access_cmd.access_rw.flags = MOCK_ACCESS_RW_SLOW_PATH |
> +					     MOCK_ACCESS_RW_WRITE;
> +		if (ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_RW),
> +			  &access_cmd))
> +			return -1;
> +	}
> +
> +	{
> +		struct iommu_test_cmd access_cmd = {
> +			.size = sizeof(access_cmd),
> +			.op = IOMMU_TEST_OP_ACCESS_RW,
> +			.id = self->access_id,
> +			.access_rw = { .iova = iova,
> +				       .flags = MOCK_ACCESS_RW_SLOW_PATH,
> +				       .length = sizeof(tmp_big),
> +				       .uptr = (uintptr_t)tmp_big },
> +		};
> +
> +		if (ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_RW),
> +			  &access_cmd))
> +			return -1;
> +	}
> +	if (_test_cmd_destroy_access(self->access_id))
> +		return -1;
> +	self->access_id = 0;
> +	return 0;
> +}
> +
> +/* pages.c access functions */
> +TEST_FAIL_NTH(basic_fail_nth, access_pin)
> +{
> +	uint32_t access_pages_id;
> +	uint32_t ioas_id;
> +	__u64 iova;
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	if (self->fd == -1)
> +		return -1;
> +
> +	if (_test_ioctl_ioas_alloc(self->fd, &ioas_id))
> +		return -1;
> +
> +	if (_test_ioctl_set_temp_memory_limit(self->fd, 32))
> +		return -1;
> +
> +	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, BUFFER_SIZE, &iova,
> +				 IOMMU_IOAS_MAP_WRITEABLE |
> +					 IOMMU_IOAS_MAP_READABLE))
> +		return -1;
> +
> +	if (_test_cmd_create_access(self->fd, ioas_id, &self->access_id,
> +				    MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES))
> +		return -1;
> +
> +	fail_nth_enable();
> +
> +	{
> +		struct iommu_test_cmd access_cmd = {
> +			.size = sizeof(access_cmd),
> +			.op = IOMMU_TEST_OP_ACCESS_PAGES,
> +			.id = self->access_id,
> +			.access_pages = { .iova = iova,
> +					  .length = BUFFER_SIZE,
> +					  .uptr = (uintptr_t)buffer },
> +		};
> +
> +		if (ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_RW),
> +			  &access_cmd))
> +			return -1;
> +		access_pages_id = access_cmd.access_pages.out_access_pages_id;
> +	}
> +
> +	if (_test_cmd_destroy_access_pages(self->fd, self->access_id,
> +					   access_pages_id))
> +		return -1;
> +
> +	if (_test_cmd_destroy_access(self->access_id))
> +		return -1;
> +	self->access_id = 0;
> +	return 0;
> +}
> +
> +/* iopt_pages_fill_xarray() */
> +TEST_FAIL_NTH(basic_fail_nth, access_pin_domain)
> +{
> +	uint32_t access_pages_id;
> +	uint32_t ioas_id;
> +	__u32 device_id;
> +	__u32 hwpt_id;
> +	__u64 iova;
> +
> +	self->fd = open("/dev/iommu", O_RDWR);
> +	if (self->fd == -1)
> +		return -1;
> +
> +	if (_test_ioctl_ioas_alloc(self->fd, &ioas_id))
> +		return -1;
> +
> +	if (_test_ioctl_set_temp_memory_limit(self->fd, 32))
> +		return -1;
> +
> +	if (_test_cmd_mock_domain(self->fd, ioas_id, &device_id, &hwpt_id))
> +		return -1;
> +
> +	if (_test_ioctl_ioas_map(self->fd, ioas_id, buffer, BUFFER_SIZE, &iova,
> +				 IOMMU_IOAS_MAP_WRITEABLE |
> +					 IOMMU_IOAS_MAP_READABLE))
> +		return -1;
> +
> +	if (_test_cmd_create_access(self->fd, ioas_id, &self->access_id,
> +				    MOCK_FLAGS_ACCESS_CREATE_NEEDS_PIN_PAGES))
> +		return -1;
> +
> +	fail_nth_enable();
> +
> +	{
> +		struct iommu_test_cmd access_cmd = {
> +			.size = sizeof(access_cmd),
> +			.op = IOMMU_TEST_OP_ACCESS_PAGES,
> +			.id = self->access_id,
> +			.access_pages = { .iova = iova,
> +					  .length = BUFFER_SIZE,
> +					  .uptr = (uintptr_t)buffer },
> +		};
> +
> +		if (ioctl(self->fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_ACCESS_RW),
> +			  &access_cmd))
> +			return -1;
> +		access_pages_id = access_cmd.access_pages.out_access_pages_id;
> +	}
> +
> +	if (_test_cmd_destroy_access_pages(self->fd, self->access_id,
> +					   access_pages_id))
> +		return -1;
> +
> +	if (_test_cmd_destroy_access(self->access_id))
> +		return -1;
> +	self->access_id = 0;
> +
> +	if (_test_ioctl_destroy(self->fd, device_id))
> +		return -1;
> +	if (_test_ioctl_destroy(self->fd, hwpt_id))
> +		return -1;
> +	return 0;
> +}
> +
> +TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
> new file mode 100644
> index 00000000000000..0d1f46369c2a30
> --- /dev/null
> +++ b/tools/testing/selftests/iommu/iommufd_utils.h
> @@ -0,0 +1,278 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES */
> +#ifndef __SELFTEST_IOMMUFD_UTILS
> +#define __SELFTEST_IOMMUFD_UTILS
> +
> +#include <unistd.h>
> +#include <stddef.h>
> +#include <sys/fcntl.h>
> +#include <sys/ioctl.h>
> +#include <stdint.h>
> +#include <assert.h>
> +
> +#include "../kselftest_harness.h"
> +#include "../../../../drivers/iommu/iommufd/iommufd_test.h"
> +
> +/* Hack to make assertions more readable */
> +#define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD
> +
> +static void *buffer;
> +static unsigned long BUFFER_SIZE;
> +
> +/*
> + * Have the kernel check the refcount on pages. I don't know why a freshly
> + * mmap'd anon non-compound page starts out with a ref of 3
> + */
> +#define check_refs(_ptr, _length, _refs)                                      \
> +	({                                                                    \
> +		struct iommu_test_cmd test_cmd = {                            \
> +			.size = sizeof(test_cmd),                             \
> +			.op = IOMMU_TEST_OP_MD_CHECK_REFS,                    \
> +			.check_refs = { .length = _length,                    \
> +					.uptr = (uintptr_t)(_ptr),            \
> +					.refs = _refs },                      \
> +		};                                                            \
> +		ASSERT_EQ(0,                                                  \
> +			  ioctl(self->fd,                                     \
> +				_IOMMU_TEST_CMD(IOMMU_TEST_OP_MD_CHECK_REFS), \
> +				&test_cmd));                                  \
> +	})
> +
> +static int _test_cmd_mock_domain(int fd, unsigned int ioas_id, __u32 *device_id,
> +				 __u32 *hwpt_id)
> +{
> +	struct iommu_test_cmd cmd = {
> +		.size = sizeof(cmd),
> +		.op = IOMMU_TEST_OP_MOCK_DOMAIN,
> +		.id = ioas_id,
> +		.mock_domain = {},
> +	};
> +	int ret;
> +
> +	ret = ioctl(fd, IOMMU_TEST_CMD, &cmd);
> +	if (ret)
> +		return ret;
> +	if (device_id)
> +		*device_id = cmd.mock_domain.out_device_id;
> +	assert(cmd.id != 0);
> +	if (hwpt_id)
> +		*hwpt_id = cmd.mock_domain.out_hwpt_id;
> +	return 0;
> +}
> +#define test_cmd_mock_domain(ioas_id, device_id, hwpt_id)                \
> +	ASSERT_EQ(0, _test_cmd_mock_domain(self->fd, ioas_id, device_id, \
> +					   hwpt_id))
> +#define test_err_mock_domain(_errno, ioas_id, device_id, hwpt_id)     \
> +	EXPECT_ERRNO(_errno, _test_cmd_mock_domain(self->fd, ioas_id, \
> +						   device_id, hwpt_id))
> +
> +static int _test_cmd_create_access(int fd, unsigned int ioas_id,
> +				   __u32 *access_id, unsigned int flags)
> +{
> +	struct iommu_test_cmd cmd = {
> +		.size = sizeof(cmd),
> +		.op = IOMMU_TEST_OP_CREATE_ACCESS,
> +		.id = ioas_id,
> +		.create_access = { .flags = flags },
> +	};
> +	int ret;
> +
> +	ret = ioctl(fd, IOMMU_TEST_CMD, &cmd);
> +	if (ret)
> +		return ret;
> +	*access_id = cmd.create_access.out_access_fd;
> +	return 0;
> +}
> +#define test_cmd_create_access(ioas_id, access_id, flags)                  \
> +	ASSERT_EQ(0, _test_cmd_create_access(self->fd, ioas_id, access_id, \
> +					     flags))
> +
> +static int _test_cmd_destroy_access(unsigned int access_id)
> +{
> +	return close(access_id);
> +}
> +#define test_cmd_destroy_access(access_id) \
> +	ASSERT_EQ(0, _test_cmd_destroy_access(access_id))
> +
> +static int _test_cmd_destroy_access_pages(int fd, unsigned int access_id,
> +					  unsigned int access_pages_id)
> +{
> +	struct iommu_test_cmd cmd = {
> +		.size = sizeof(cmd),
> +		.op = IOMMU_TEST_OP_DESTROY_ACCESS_PAGES,
> +		.id = access_id,
> +		.destroy_access_pages = { .access_pages_id = access_pages_id },
> +	};
> +	return ioctl(fd, IOMMU_TEST_CMD, &cmd);
> +}
> +#define test_cmd_destroy_access_pages(access_id, access_pages_id)        \
> +	ASSERT_EQ(0, _test_cmd_destroy_access_pages(self->fd, access_id, \
> +						    access_pages_id))
> +#define test_err_destroy_access_pages(_errno, access_id, access_pages_id) \
> +	EXPECT_ERRNO(_errno, _test_cmd_destroy_access_pages(              \
> +				     self->fd, access_id, access_pages_id))
> +
> +static int _test_ioctl_destroy(int fd, unsigned int id)
> +{
> +	struct iommu_destroy cmd = {
> +		.size = sizeof(cmd),
> +		.id = id,
> +	};
> +	return ioctl(fd, IOMMU_DESTROY, &cmd);
> +}
> +#define test_ioctl_destroy(id) ASSERT_EQ(0, _test_ioctl_destroy(self->fd, id))
> +
> +static int _test_ioctl_ioas_alloc(int fd, __u32 *id)
> +{
> +	struct iommu_ioas_alloc cmd = {
> +		.size = sizeof(cmd),
> +	};
> +	int ret;
> +
> +	ret = ioctl(fd, IOMMU_IOAS_ALLOC, &cmd);
> +	if (ret)
> +		return ret;
> +	*id = cmd.out_ioas_id;
> +	return 0;
> +}
> +#define test_ioctl_ioas_alloc(id)                                   \
> +	({                                                          \
> +		ASSERT_EQ(0, _test_ioctl_ioas_alloc(self->fd, id)); \
> +		ASSERT_NE(0, *(id));                                \
> +	})
> +
> +static int _test_ioctl_ioas_map(int fd, unsigned int ioas_id, void *buffer,
> +				size_t length, __u64 *iova, unsigned int flags)
> +{
> +	struct iommu_ioas_map cmd = {
> +		.size = sizeof(cmd),
> +		.flags = flags,
> +		.ioas_id = ioas_id,
> +		.user_va = (uintptr_t)buffer,
> +		.length = length,
> +	};
> +	int ret;
> +
> +	if (flags & IOMMU_IOAS_MAP_FIXED_IOVA)
> +		cmd.iova = *iova;
> +
> +	ret = ioctl(fd, IOMMU_IOAS_MAP, &cmd);
> +	*iova = cmd.iova;
> +	return ret;
> +}
> +#define test_ioctl_ioas_map(buffer, length, iova_p)                        \
> +	ASSERT_EQ(0, _test_ioctl_ioas_map(self->fd, self->ioas_id, buffer, \
> +					  length, iova_p,                  \
> +					  IOMMU_IOAS_MAP_WRITEABLE |       \
> +						  IOMMU_IOAS_MAP_READABLE))
> +
> +#define test_err_ioctl_ioas_map(_errno, buffer, length, iova_p)            \
> +	EXPECT_ERRNO(_errno,                                               \
> +		     _test_ioctl_ioas_map(self->fd, self->ioas_id, buffer, \
> +					  length, iova_p,                  \
> +					  IOMMU_IOAS_MAP_WRITEABLE |       \
> +						  IOMMU_IOAS_MAP_READABLE))
> +
> +#define test_ioctl_ioas_map_id(ioas_id, buffer, length, iova_p)              \
> +	ASSERT_EQ(0, _test_ioctl_ioas_map(self->fd, ioas_id, buffer, length, \
> +					  iova_p,                            \
> +					  IOMMU_IOAS_MAP_WRITEABLE |         \
> +						  IOMMU_IOAS_MAP_READABLE))
> +
> +#define test_ioctl_ioas_map_fixed(buffer, length, iova)                       \
> +	({                                                                    \
> +		__u64 __iova = iova;                                          \
> +		ASSERT_EQ(0, _test_ioctl_ioas_map(                            \
> +				     self->fd, self->ioas_id, buffer, length, \
> +				     &__iova,                                 \
> +				     IOMMU_IOAS_MAP_FIXED_IOVA |              \
> +					     IOMMU_IOAS_MAP_WRITEABLE |       \
> +					     IOMMU_IOAS_MAP_READABLE));       \
> +	})
> +
> +#define test_err_ioctl_ioas_map_fixed(_errno, buffer, length, iova)           \
> +	({                                                                    \
> +		__u64 __iova = iova;                                          \
> +		EXPECT_ERRNO(_errno,                                          \
> +			     _test_ioctl_ioas_map(                            \
> +				     self->fd, self->ioas_id, buffer, length, \
> +				     &__iova,                                 \
> +				     IOMMU_IOAS_MAP_FIXED_IOVA |              \
> +					     IOMMU_IOAS_MAP_WRITEABLE |       \
> +					     IOMMU_IOAS_MAP_READABLE));       \
> +	})
> +
> +static int _test_ioctl_ioas_unmap(int fd, unsigned int ioas_id, uint64_t iova,
> +				  size_t length, uint64_t *out_len)
> +{
> +	struct iommu_ioas_unmap cmd = {
> +		.size = sizeof(cmd),
> +		.ioas_id = ioas_id,
> +		.iova = iova,
> +		.length = length,
> +	};
> +	int ret;
> +
> +	ret = ioctl(fd, IOMMU_IOAS_UNMAP, &cmd);
> +	if (out_len)
> +		*out_len = cmd.length;
> +	return ret;
> +}
> +#define test_ioctl_ioas_unmap(iova, length)                                \
> +	ASSERT_EQ(0, _test_ioctl_ioas_unmap(self->fd, self->ioas_id, iova, \
> +					    length, NULL))
> +
> +#define test_ioctl_ioas_unmap_id(ioas_id, iova, length)                      \
> +	ASSERT_EQ(0, _test_ioctl_ioas_unmap(self->fd, ioas_id, iova, length, \
> +					    NULL))
> +
> +#define test_err_ioctl_ioas_unmap(_errno, iova, length)                      \
> +	EXPECT_ERRNO(_errno, _test_ioctl_ioas_unmap(self->fd, self->ioas_id, \
> +						    iova, length, NULL))
> +
> +static int _test_ioctl_set_temp_memory_limit(int fd, unsigned int limit)
> +{
> +	struct iommu_test_cmd memlimit_cmd = {
> +		.size = sizeof(memlimit_cmd),
> +		.op = IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT,
> +		.memory_limit = { .limit = limit },
> +	};
> +
> +	return ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_SET_TEMP_MEMORY_LIMIT),
> +		     &memlimit_cmd);
> +}
> +
> +#define test_ioctl_set_temp_memory_limit(limit) \
> +	ASSERT_EQ(0, _test_ioctl_set_temp_memory_limit(self->fd, limit))
> +
> +#define test_ioctl_set_default_memory_limit() \
> +	test_ioctl_set_temp_memory_limit(65536)
> +
> +static void teardown_iommufd(int fd, struct __test_metadata *_metadata)
> +{
> +	struct iommu_test_cmd test_cmd = {
> +		.size = sizeof(test_cmd),
> +		.op = IOMMU_TEST_OP_MD_CHECK_REFS,
> +		.check_refs = { .length = BUFFER_SIZE,
> +				.uptr = (uintptr_t)buffer },
> +	};
> +
> +	if (fd == -1)
> +		return;
> +
> +	EXPECT_EQ(0, close(fd));
> +
> +	fd = open("/dev/iommu", O_RDWR);
> +	EXPECT_NE(-1, fd);
> +	EXPECT_EQ(0, ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_MD_CHECK_REFS),
> +			   &test_cmd));
> +	EXPECT_EQ(0, close(fd));
> +}
> +
> +#define EXPECT_ERRNO(expected_errno, cmd)         \
> +	({                                        \
> +		ASSERT_EQ(-1, cmd);               \
> +		EXPECT_EQ(expected_errno, errno); \
> +	})
> +
> +#endif

-- 
Regards,
Yi Liu
