Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239E2500BAF
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbiDNK7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbiDNK7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:59:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E5C75E57
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933833; x=1681469833;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zVEGcc/XYBKfRfu0mEmRGvau99iQ1VXxU7hFNM/Q8KY=;
  b=O+haN+lYLEtmlOgqGyABRPBxcI5IXY/4xHnWUPTzWUOfp4JwBPDP2Zyk
   mUqbq+9IV/77Z9kZs6FKQmCc5PCJqv3mu6b6y13gDCERwcwOC+B/HuYwb
   icnr04f1T3eGC6ruFDMRqxdNrcZ0pX9sCOaXKM33DRhWBkQxPDUB2XKU4
   U6wD5Oq4ISSMw0ZHFCvTCo8CH1ZjntkC23gE28kglFXI8Wg8wYHRNe2dK
   aKUc1lxaFpo31+xJ6lIh0WBkn1l1YXvzcVzUqP2IzwBRRkTk62pu8TIOX
   1YYuzsXAc7EwpTrvNAAgYJihTW1Mz8mYHYCGIgDsVVzqAEk8kdgjzMmqy
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="287958879"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="287958879"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:56:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803093403"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:56:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 03:56:55 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 03:56:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 03:56:54 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 03:56:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERiKlFqw62dLmf0FCp7L9baLoxGOqVK0eAZf5pPVu4qJIa3hQu8334ZHg1fH3t0ZNdJCM70XTYEI/Lx+mCJAbuDE3DNdeLkmYOyrGmOt6/9zQ4lkLfaHRYD9U66zWwf/gjYR97hq68qWHpurYEJCyzx0dE10RAlWEoP2YLpXti2KCnXdtvy1kvmPa0NU0+03b7U+sIEmoXB+siWMic5zkvb48jVA3+U69/1pgVZ/qHBZ9jAbeG+dW4P117ovsm558QY/9/rnUjq7BENvAUxo4+yCbnfT6DyXdcbLntju+Fr55hGo3gs6KVF0YZKM0Kd4Xef9Ek5P3cTC9xzQUavM8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0EYkus6AXDmD+JzxzkRTKtNvc9AvxrxHpDbqQFt47o=;
 b=b9Lsz85PfwiBjIEz8cFx6PbYo9M0njqvXaRBrk/86GMZWUg0H+lVW9KNy32wI3Sy1R8thcQ3TFxJqgi1gH3B8SZzs25Yf6GM7q5AvQpTSPfOHTJusVDu6kG/SdTQ4xl3BOeLRRr6GAnmcUtraAoR/ze0xAVGgwUwiKL+8oCYoe93poFkhQwKOphOkIJbmGxYn1GDwUhFlt+N38d/zi+R96HRtCA9kgqgaAuhvRGjq7+5Eu+y2F+eJeUlAb6SGJzJYqLzv5WfI0V0ga2jTueDip1dIMm8+vO/KIjHuwJtJyLCyHgWP5M3uGBZefBUv+AcTrpgJm7FJYkJCEUjGSMKNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by CH0PR11MB5689.namprd11.prod.outlook.com (2603:10b6:610:ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 10:56:52 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%8]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 10:56:52 +0000
Message-ID: <5f420205-93e1-f99d-4c28-ba574794e0b2@intel.com>
Date:   Thu, 14 Apr 2022 18:56:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 00/12] IOMMUFD Generic interface
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        "Kevin Tian" <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR04CA0071.apcprd04.prod.outlook.com
 (2603:1096:202:15::15) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 395f904d-c7a6-4797-f99f-08da1e057b56
X-MS-TrafficTypeDiagnostic: CH0PR11MB5689:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <CH0PR11MB5689E8C4821AE9BA9562F55BC3EF9@CH0PR11MB5689.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9FwRZZfAefUn9x/hVKXzO1pVI0v0wG/9v+6JFJeVqWIFUP4Rc3y9Dt6nbZ4Us6ITaPXOn+YcR7u5Fac/9XnPU1HrDODSzAsKrBsoIzNVMz3WhQWKlsnFo5FkGFC9Fcwk0mI5z3yQgUKGXavBNikZ2rhw8rfCbeTuv+LYC+2RGBlF0qE1L50maBHSgHPktN9pfH4+d6GUtWnRW6r10xo6WZYf73NGDUHO4CXyuz7ru/t2x9JxjNnwff631znuqQUVgtCR86Xjfd5loYXJirFTYcYtPaatXgi3nmYz9iit/jaBQDmUZgd6oV6T7CSlG360HzzonhxC/QcmtSgZUo3ftL4D4LBMToq/ohB3NEO7KGg2niwqNf7edAdLCYR76b2HqDB575RDNzqm9aLL3HskkBp1Y/i/ppKZlZzZ+A0/+EEgTe2+BAlNAdisFO2HntBBUW2CCxfie7uYTL6J22twzZ6ARaPc8m3SQrnnR6YVT88fVwEd0jRXozAL+BPQu5z7m5amilkzMpsIaVYAa/Kt8D0qYeQalZuAeDiUn1icyFAmKO6jC0z2fQcziBBOcisKYi7RHsMn2QGnbBn9N3y7v0cONMGcyeanSb6sxEhDhGQPQU/wLAtjCTPOXoUGzhyNa5EcXhKZ/KP0apVmMQoPuXsTry39vUHix2roqibzMClm+4y53LnTyt6rstwaXFRkN0vhz9t33RDOA7zDCW+V0XkMO8DQfIHt5nBoeBHhf2CjQxjAV0jtPk8iSVrHAjimcM60t7XFU1+zkNIBeaToIEGxGWGV2T+PTltcV7vCgvjw9HtAgwfJtQ6xjktJMzVqgvARnwSmKvAnnhtKIETvv7V9yaXR2N7wqAE9FmnLV3qL1pwm7t9cS96+o38O01zK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(66476007)(86362001)(316002)(31686004)(6486002)(966005)(508600001)(186003)(6916009)(54906003)(83380400001)(38100700002)(2906002)(36756003)(66946007)(8676002)(66556008)(4326008)(82960400001)(26005)(8936002)(6666004)(6512007)(6506007)(53546011)(7416002)(5660300002)(2616005)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SktJbXhqUkhJc3E2YkE2a2pBbEc1OXJFNzhFenZrbVZMKzdlWnN6NCtqejJS?=
 =?utf-8?B?QS9Xb3IvVjZ6by92bDg0R2JVbkhqS3RDVFVoeDFINTRPWEdFMmNQYVlncU8x?=
 =?utf-8?B?UnpqQXg4ZjluNkJYVXF3Wm9XNmpsQTIzM1ZnRDVtZzg0M01pNlY0YXZxRW91?=
 =?utf-8?B?K2QvczlUV3IwelZrVzVTUnh6VFo5K3hsb1NFa0Mybk1nekJRUytrNnlPL0Js?=
 =?utf-8?B?TllKSHU5VVdwM3lYckV5RnJUdDAxMlptVEVRb3k5MWFrZFFUcnpDazJEYzdD?=
 =?utf-8?B?cm4xeUg5cTIzYldFZ1NWbEk1QlJZbzdNQ0U4WFhwM0pLZ3Bxc3E3RmFncnRY?=
 =?utf-8?B?K2dVenVzTkRnemJ2N1Z6Y0I4RCtHd2E4Mm9zOHptbW9NYys5OTA3SWxrQnp2?=
 =?utf-8?B?YlQwTC8zeGc5WlBOWXJGVktZYUU0eHBpeVdLMEJoVTZ2SkNqSmk5enRLMHVl?=
 =?utf-8?B?ZjZQQXh6enBYWHl3bGdnZFphVFcwOWY4VFJ3ajdkdjZDWVFPQzdoZmF0UWdH?=
 =?utf-8?B?SlgvaEtuc2Y5VVlsbWx4SGY0S3ZOaVp2WDhxMFNOVHlOZEJFRzR5S2xNcjhj?=
 =?utf-8?B?SEVQa1ZoQVlBRi9YeVI3R1RMUkVZSnhmclBwMUNUdGhjMEdKK0JRRGthcFVN?=
 =?utf-8?B?Y25Lc05uQks0QnZSZGMzOEluVGdHMm5xZTdsTUdGeUhBS0ljZ1ZCVGw2cWIw?=
 =?utf-8?B?eHJiVzJzYXhIZENBVlNDREQ5ZDF1T3Iyenp4dWRhOGl6bW9GT1cwQnRqQWxV?=
 =?utf-8?B?bzJKbXRieVBzOTM5bE8xVE1Oa2V2Vko1YTB1ejRiZ25oSC9uOXZYS0MzMktk?=
 =?utf-8?B?bHcyU2g0djljS01xcFZxdjBPdk5IOFRjaHJsMVVNcXF6RlVreDJ1cVpKc25j?=
 =?utf-8?B?K2dNZmFUaGp4SDBlWWhVdklIb1lhQmJsTDdTUC9TQmFINmo0eno1dmVtdjJt?=
 =?utf-8?B?VmNiRjNCditPTzdoaDQxNzV3MytHUE9TbmNOb1YyMVB0WHBCMGYyR1V6dHE0?=
 =?utf-8?B?elRncWRERWZCMk5BbHA4ODVCc3gySmJTanlDbUd4bVVjVFB0NXBLMFZxQllm?=
 =?utf-8?B?a2ZGRTdYV2lxUVQ5UUsxWHgza2FNeXppcUxBdWlzVkExdlJpUVNCQkhHME1h?=
 =?utf-8?B?VkZrbTd1TzIxVUJxWG0vN20rNUZ4TWhYcFhpbkhkL0hzVDFiZUZkNCtZRjdE?=
 =?utf-8?B?anA5ZW1pbVR3WGF6d2VleDRmMm9HS1FPR3p6ZFVMMDN1SFZzSUhZWHNGQmd5?=
 =?utf-8?B?dXhTVHN3U2lxdGdiaHQzdmExR1huQW9CTXM5Kzh2bi9OSWxUSnRVRE5kTGdS?=
 =?utf-8?B?ZUxYRjg2TEY0RFNOM2lXR3BuTTg2akRtTHF1WFVGRkdDNmdqTGdrdXdhYlJ6?=
 =?utf-8?B?cTFCb2lOTTROdUlMT2FNY2haYmVqVTcwK2tjRG5jcUJkS0lqRUZMUHRGZElH?=
 =?utf-8?B?R20xZlVGU0YvK2Q4Rm4yb2xQVWpzTGxDZGJZc282UWdhMU5QVDg0QXJqRmlP?=
 =?utf-8?B?K1kxSkNibmVXMStLVElBOUxVSG9QeGlnVlFmdmlqdmRUL3J1bGU0RTFLUVFH?=
 =?utf-8?B?VnJ6N09vODZaa3M2UmN4czEzenc4YytESlhOMlRXMHIwZjlqWWlNbGNXaDY5?=
 =?utf-8?B?WEh1MGVHSDUybFVHQkxRbTk1UkVUdkZjUFZnMkdXYTlrSUNKcWVmelgrV2ps?=
 =?utf-8?B?dTYxSm10SlZtazRycFc3NFlLVHVCdkpVWEZRMHJ2L1kzY3ZMemhuMHdQQmlq?=
 =?utf-8?B?alhFblRkTjBPcGEzODh2NDN2QVhib05EeDlqKzVYMFRzdllVYzB1Vnk3Vkhj?=
 =?utf-8?B?aENOWXpDK0dtZ3N3WmRCY1N5Y1VvZlJ4RExDZFd4ZDlucVZZOFRyUjFhcVJj?=
 =?utf-8?B?ZlkxYkE3cEk5TUM5Z1J5WFR3aCtzNXJPdjBNNWtRMzFCL0I0a2syU2FqWm84?=
 =?utf-8?B?bUpad05QZWNoRG1mSlpIQzBpMDZ2OTYzai9YQm56TkV1SVZTVE9FMHgwYzZN?=
 =?utf-8?B?N2VhRGk2UDVJeWhCdWc5emxta1lHQ1dVbzByTVFUeHJyOC9RSUlZUUFQa2h1?=
 =?utf-8?B?L1MzbWJBcW5YNUdEdzljNGViSk56Uys1TkJhcm5WTDVOeElNQjBneTkwT2d0?=
 =?utf-8?B?c1BVeC9LUEd5dlEzVW9vcytSQ2ZSaVRqOU4wVU13WEcwQXV5TEc2ak1vME9H?=
 =?utf-8?B?eWJ3QTZQdU9waXhLb1oyU0I2QkdBc1NzQ1NQU09CaVUvN2hUWlpXUnQwTnMw?=
 =?utf-8?B?d0FiZlNiaGFKb0RjSGtadzlxb0hIODgxd2l3TTRWRFI3aTJzSWt4eHh5eDdz?=
 =?utf-8?B?RDI1Z3hpb0xIS3E1a1dNT0ZPby9SUEJiZzVJL0MreW5TelQ3YklwQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 395f904d-c7a6-4797-f99f-08da1e057b56
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 10:56:52.2906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouBfP5zSJpZS5b65Er3XiOCLvOlc+gqcVSfC+ZcExvDNxrd+6NegZ0+eStHCl/4MGICPvBvXFMIJzb9agRaiPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5689
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/3/19 01:27, Jason Gunthorpe wrote:
> iommufd is the user API to control the IOMMU subsystem as it relates to
> managing IO page tables that point at user space memory.
> 
> It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
> container) which is the VFIO specific interface for a similar idea.
> 
> We see a broad need for extended features, some being highly IOMMU device
> specific:
>   - Binding iommu_domain's to PASID/SSID
>   - Userspace page tables, for ARM, x86 and S390
>   - Kernel bypass'd invalidation of user page tables
>   - Re-use of the KVM page table in the IOMMU
>   - Dirty page tracking in the IOMMU
>   - Runtime Increase/Decrease of IOPTE size
>   - PRI support with faults resolved in userspace
> 
> As well as a need to access these features beyond just VFIO, VDPA for
> instance, but other classes of accelerator HW are touching on these areas
> now too.
> 
> The v1 series proposed re-using the VFIO type 1 data structure, however it
> was suggested that if we are doing this big update then we should also
> come with a data structure that solves the limitations that VFIO type1
> has. Notably this addresses:
> 
>   - Multiple IOAS/'containers' and multiple domains inside a single FD
> 
>   - Single-pin operation no matter how many domains and containers use
>     a page
> 
>   - A fine grained locking scheme supporting user managed concurrency for
>     multi-threaded map/unmap
> 
>   - A pre-registration mechanism to optimize vIOMMU use cases by
>     pre-pinning pages
> 
>   - Extended ioctl API that can manage these new objects and exposes
>     domains directly to user space
> 
>   - domains are sharable between subsystems, eg VFIO and VDPA
> 
> The bulk of this code is a new data structure design to track how the
> IOVAs are mapped to PFNs.
> 
> iommufd intends to be general and consumable by any driver that wants to
> DMA to userspace. From a driver perspective it can largely be dropped in
> in-place of iommu_attach_device() and provides a uniform full feature set
> to all consumers.
> 
> As this is a larger project this series is the first step. This series
> provides the iommfd "generic interface" which is designed to be suitable
> for applications like DPDK and VMM flows that are not optimized to
> specific HW scenarios. It is close to being a drop in replacement for the
> existing VFIO type 1.
> 
> This is part two of three for an initial sequence:
>   - Move IOMMU Group security into the iommu layer
>     https://lore.kernel.org/linux-iommu/20220218005521.172832-1-baolu.lu@linux.intel.com/
>   * Generic IOMMUFD implementation
>   - VFIO ability to consume IOMMUFD
>     An early exploration of this is available here:
>      https://github.com/luxis1999/iommufd/commits/iommufd-v5.17-rc6

Eric Auger and me have posted a QEMU rfc based on this branch.

https://lore.kernel.org/kvm/20220414104710.28534-1-yi.l.liu@intel.com/

-- 
Regards,
Yi Liu
