Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A726F1C3B
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 18:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344729AbjD1QGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 12:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjD1QGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 12:06:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB9940F8;
        Fri, 28 Apr 2023 09:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682697960; x=1714233960;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yO+OpdOQ6Siaz1WCBYdwl+92Lb1zta6RHYaWHshrI4g=;
  b=QI2aWficOjuILncaTtvtUa1JtQsSLVqeGtBbeSTz6qIuqoHRD7ZoFwCM
   eFDG/oYtQ6TftKOdaD+AMaRdBYWiOIqpniq2nI2KTZ8NmC3oL073ljw0P
   xwjAvMkOpn9kYQnf/vXfkQVi6j0+6vxgOrRMHt5xN3BgoSkNelrpIWiN5
   lLuGe/RiN/zsJh7b+t51NprdtF/RAmIDMORGLDZsxKOEjyBj09l/yOgQz
   mDQC8s91iV4cdaJO0MyGWf1/q/Z2wI1Nxw07QTC8rVKrfH9yACx1mH3bi
   Ajc2HOIpzjkRvmycU3Sg8EQAL4w43xfCm8iWz7LzNU1v/mDL/cUszwJhO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="328123745"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="328123745"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 09:06:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="725395425"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="725395425"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 28 Apr 2023 09:06:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 09:05:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 09:05:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 09:05:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpJ1Q3BPO5C2VDlQvXNTNdVn6V1DkO04N5mzwMc6fSiKE2sKLWiU0AXRr1a9AZXMaiDI+DpViiQzuUaaq/t0pv49Mqf+fn+Vemx9Fw8LtHnGfLvrMqkCqxivc7DJyGzbKWK0LqPkaeKNPbT+gkPrNFcef+Z37aX0IpOKCcfGSP/u1z84IKCdcAZrqhktDHdsBoh9ekOf/Y4FUMzwjKkytkvnZ/DLJwsQbfvhVZ+oND3a6Mv89d6Bp6/BWLgnYmpmTzKOE/SVuaFKxiryt/GLkJz9BFDR5L4o2+CPvnbA/4Fimv5OvviapC5CiLa2C8NzIgYT0t+kgEcOaebljK5A3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7giEEjhuWgMZ4xC8v1M5TcxmXf1JOdd/9wDb1cZ8R6I=;
 b=KAo6tAuX9aSaDpvlUbPyT0DTvuoqEFZHeSuFvnXkgIJTHZ4A7Fsz0VxKSN8hp+yKtyI2HhkXdcMdjDzojRgPwI57rt7vODA18YiLRglRkPEpIzEpM7mSh+bntC9XgLBTxY5AlSm9Yr31b6k1uDyJ+Lb+F+ayZjKnAYfebXZqoSOwBf+dTFye+nCQsJDev98EQmB8nxnYBNDTmxwPI5H/8qGNEO7o1Jit/PptXjHLmcHm2CMMlj4EsFQvxvJdHR5TCVtbC42U3284qCQ9QAz3igMefpA3wekBp3qY7W2tS/MCnoOqO5CfFSeMjySUFvt9yAE5zQUJfxMX8ZWQvzYOvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW3PR11MB4761.namprd11.prod.outlook.com (2603:10b6:303:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 16:05:57 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 16:05:57 +0000
Message-ID: <3b83d829-048b-174f-a21d-b28ad0b7b49e@intel.com>
Date:   Sat, 29 Apr 2023 00:07:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
 <ZEu3Ga9cIQAykBGf@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ZEu3Ga9cIQAykBGf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0110.apcprd03.prod.outlook.com
 (2603:1096:4:91::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW3PR11MB4761:EE_
X-MS-Office365-Filtering-Correlation-Id: db1c504d-7d71-4c88-4955-08db480273a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4MmevqNMz5cIY8lPqcHldKBei7uNwh4xsUJ/8UAu/2k9NLaWqHhudMOdbMzbq3d0h62HEUlYMkRTevJiSP1CIre4MUfAEHQ6WPoP8WOLvPg2ccThp/T5frLmMoVSjm0D7bqgTeFqm7ZsVW1+R0JEm1AK4wDoI46jnbDpII+kjOthDmEN8RbUg8jL+VCy8j5mLHEx7QKlRRvdkdQx2/uv3qT1K5g5bm2aMx77JzixBpKFtrNSSYM0XE8IeRxFjiLxr7z0h3dhyb+wXcfWsXhpjA5DRvpTfsvJTapIK2yq7sRdZVOlCyGpwGXZ1+aipn8x+QICMpLtAHqjWDszHF9ULrjG+UIcBlDCsnmt3o2KNWX2KDwUTExRJX3u8dxfE/ayx+ILKWBEC0wIbner6KjWtmY0nl0JTvhMIviIymdpLlQxznvLeO6P0bOYB0P7xp4BMX60QTfjV2lCh2lto9FThMfdQvHzdWGxgLfW6Iiam4nwyJ4tRcOZCr4CEX4EmtxCT97aweKDx0IxmeskmQhnsTbSwa9cEPPdz2p/FARIyc9hBKMnkgfn5upc2RStcvJ05hrfFWbxYc50ic9QJ/naD9LwlJ2L43ZahGX9+kxcrQa/E6HYHFZLYGnR7NTJoo2Xf/jh1ACKCQPljaW+VPBgFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199021)(66556008)(38100700002)(5660300002)(31696002)(66946007)(66476007)(8936002)(8676002)(82960400001)(41300700001)(316002)(86362001)(4326008)(7416002)(6916009)(53546011)(186003)(26005)(6506007)(6512007)(6666004)(6486002)(36756003)(83380400001)(2616005)(31686004)(2906002)(478600001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUp0UFkxZHN4YXJYUlRkWVkrMjRwTTRLdW1xY0NiVXB6NzExTVp1UXZpWXBm?=
 =?utf-8?B?YmRxajdnTHJ5TEliV2ZZOU5idFNiUzd2Um9lYXJ4amwvN3hjTW03M21IQk80?=
 =?utf-8?B?V0JRbzh2aCtuMWlxc2VkcDBEREZmdG1XNkMvb1FmRm9XMWNGdGRmTnROVzFT?=
 =?utf-8?B?cVdMZ2pGeFZ2ZEZpUHVWejBnRFR1Z2hvaW5OZXJlQ2U3eElEdytYSk1KVmhQ?=
 =?utf-8?B?ajNodEFKOVdhYnErTVZXU2JNcGxsb0pGU280Z3dWZ0FXVjNYMWZqVm9Bb0Fr?=
 =?utf-8?B?UngyaWNhdmRYSmFwd1o3QWZSV3k0UTlNd0d1aVVIRjdrUXViU0FINmVUaDNw?=
 =?utf-8?B?T0c4eG1TUmIyb0c2NmRoM2IxVmdQNXRKVlh2ZkFJSmYzRmd3bEpKMjFmSEZP?=
 =?utf-8?B?Si9PQ3NBUXFJMW8ra1psYzZVR0toQ0VrS25xR3VRLzVVVTdwcCtkbVV0Mklm?=
 =?utf-8?B?VVd6YTdJVjlCbXFmNHJlUjh6bFpSZFphU3R0TFBiK3hFM0pGNkdHMEhiNG9E?=
 =?utf-8?B?WkJ2OG04Sm9ZS29UUHVwRm1sWjJYUmxUTTNGRGxDZjRlekxYL2hpRTh6VFFo?=
 =?utf-8?B?MnVHem9aTkFack5tZCtmY3lsU29SV0RvTDFiQ3k0OWZmeHIwVk1aSzE1R3FB?=
 =?utf-8?B?S3RieGRncEt2Y0VyaWpINUxBMFRXOW5TVkN1TXBKUjBnSmJDYW1wK3dCWVJv?=
 =?utf-8?B?Y2RzRFpFMzVCSE41MGJiNTF2Q21YR2ZZekZvdjJqMWRHZzdtVmtuQWFmQU41?=
 =?utf-8?B?V1p5UWE2TFhhZStpbUxxSmZOMlArYUtxdDAyMTVhY2x6bTJEMVIzRTUraGhj?=
 =?utf-8?B?eFRwU3F1UFBCTURCajhoYWdQNUtkUWN3L3lrVUkvUkIwVng2NnczMlB1TW52?=
 =?utf-8?B?cU5lNlVwVzlaU3BRdndHaFl6alZrUUVJblF2YXQ0V3p3MzdrN01Ha3lFUjNu?=
 =?utf-8?B?Z21UT0hPSUxXMWcwUGNtKzZWN2s0YXhCTHBNTWhDRmxibm9tVXNydGh4d3Qv?=
 =?utf-8?B?aENDcTlQc2xEQ0ZDR1ZmaGJoNmpiSVg0b2dBZVg5REI4T09zbzFjcDE5OUtk?=
 =?utf-8?B?UmxsREZyRjl1bTF3VzNkcGxMcDRXdUdCYVRMWk1IazJTb2ZQUG5RNU1PQ2d5?=
 =?utf-8?B?OEVXMENlNXNFb3FneUYvVkZIdU95djVnbmRtbHYrYVdHUlJBcG5JODZmMktD?=
 =?utf-8?B?NWZtL3ZqWDZVZ1VGdHJCZk8xVm1KZk1jclJFWW5jdVp3TnB1eEtuNytIQXYy?=
 =?utf-8?B?dWU5Q3lzbnl1SDVIYm5ROTE5dHFTbEhxTVkwaDlIcUZibHlIL3BjblBQazQx?=
 =?utf-8?B?bDBMQytHU1Uza0tYNVJUWVh1TW55RDJGTm80K0VSNUdHMU9ITUNJSm5US3Fy?=
 =?utf-8?B?VlA2SllWOWlWZVpvS2ZsOEh4MkNWVmkyZ29VYjFJaU1hSmRQQUdTNUg2Vm9D?=
 =?utf-8?B?WURkbWRLaWszbFA4Mm52N3Jock1RNDRDTWZWK0JnUXFwSjlaZENadkQ4dVR1?=
 =?utf-8?B?M09rbDl5NUdxVzdPblhSYkgvYkhzeVRyZ0N3azRHbVNsSFd2aEx3czJ0UEVz?=
 =?utf-8?B?UnB3N1l0anlycVdKU2RIVThhelE4anBwTEJaVnl1dWVEc0hLRnNTVS9VWm53?=
 =?utf-8?B?elBrOGpSQUpqUTBlSUFkSEpETHRnclB4YmVIcWFmRnhaenRBZ1hsenUvYllV?=
 =?utf-8?B?azdDcGVsaW9PYVJBMlhraHp3bFN3VVMrNnBVTFZGMFphNjJuMWhhMVZHUVFa?=
 =?utf-8?B?WGprTFJTaHpqS3hPSEU0YXJCV216WWJQbVNROS8vb1FvSUxtcW5yQTRoNUxi?=
 =?utf-8?B?UWpmd2Y3bmFIaUQ2WXZGNHZYYUxEVWVVaTczOForYlpQQ3g1TWd0cFNnYzVJ?=
 =?utf-8?B?dTMyWDd5dU16MmFPSGF1UTlNNXlTVVR0VUNGeWlwcStTVHhHZU50MEdBOUt3?=
 =?utf-8?B?bzM1ZHRLYTdxQXh1RXhOK2tNNnlXWTZKU2FHQjU4c052amtnS2hDeE5CUTVu?=
 =?utf-8?B?RlR0TVRWYitIOExGVmhuYzF3NkU3M1Z5YzNueFpyS2FvUUZVQ2t5d0IrVndt?=
 =?utf-8?B?WGQ1MTdoUFVFU2lhbnJ3SnlHMi9KaDRNaStobkU4SG9oSFl4MERTcjc5THJT?=
 =?utf-8?Q?U1IkVQnOOaM70FAKMpjd5HivH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db1c504d-7d71-4c88-4955-08db480273a4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 16:05:57.4564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjIXySuzWE/J4BbqM1MhS2d1F/EzdtBaaZUrygPLIFYOBP3HHAbKnaMdfyM/pbe0YCsQwahL8MDgg0v39bZYDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/4/28 20:07, Jason Gunthorpe wrote:
> On Fri, Apr 28, 2023 at 02:21:26PM +0800, Yi Liu wrote:
> 
>> but this patch needs to use vfio_iommufd_emulated_bind() and
>> vfio_iommufd_emulated_unbind() for the noiommu devices when binding
>> to iommufd. So needs to check noiommu in the vfio_iommufd_bind()
>> and vfio_iommu_unbind() as well.
> 
> I'm not sure this is strictly necessary, it just needs an access
> 
> The emulated stuff is for mdev only, it should not be confused with
> no-iommu

hmmm. I guess the confusion is due to the reuse of 
vfio_iommufd_emulated_bind().

> 
> Eg if you had a no_iommu_access value to store the access it would be
> fine and could serve as the 'this is no_iommu' flag

So this no_iommu_access shall be created per iommufd bind, and call the
iommufd_access_create() with iommufd_access_ops. is it? If so, this is
not 100% the same with no_iommu flag as this flag is static after device
registration.

> 
> The only purpose of the access at this moment is to get an iommufdctx
> id to return to userspace.

yes. and it is the iommufd_access ID to be returned to userspace.

-- 
Regards,
Yi Liu
