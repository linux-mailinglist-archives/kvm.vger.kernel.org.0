Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8A4EAA57
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 11:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbiC2JUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 05:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbiC2JUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 05:20:03 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8229DDEC8
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 02:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648545500; x=1680081500;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RSiRlIEIQUJvQK8NHopmClIZFFJOG6MC0URDm73Uk5I=;
  b=JyAD0XcPTSNoDfYjNJY9/1Xux4+LBs7Ng6xvTlRzD51dvJnuA4GcsZAi
   VqND/EXFIIPlLpWUEC9nkKeowJaC8Vy5K+80DMB0L5LNJJ2sPTD7ZIy2b
   FUj4HsHBJeM9FOSzmwAp7PjIUih90ukeaO+2Pu0J5K+UJk5V+ZyDcMvri
   4YrqM2CjWCKLJBlo+qhlDSCtnGEHflasLAQiTSDNzzRcu3+/a536Zjui8
   pMPV98t257SLf+Y60/UCpyVqYEy45P0P69VjfnBSmDM/nxLqXWractbye
   i79RygVOM2jaSGj6KEKT2MHx/bu2nLBnCk61CXSSUHlXZvZM3+WkTd4JS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="284102206"
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="284102206"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 02:18:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,219,1643702400"; 
   d="scan'208";a="518808964"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 29 Mar 2022 02:18:20 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 29 Mar 2022 02:18:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 29 Mar 2022 02:18:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 29 Mar 2022 02:18:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQzuatK13quYHR402PhDB5Prt6RleqL1VCfAbKdMLUp+mjbnOIsmeFB8NXTfOOrPAjtBRthos72jvwHwgMBhRTnc32SwC3PGpT9PG/DuKwKq7hNA970CoPW21Ijz+3OW0soBhYbI6nqug46Ag/wCOOG9PwtRHPPuy9ALrrfZlMYGdsqe0br9xQCpwjNwrzWkbEPkfdTLZxnahaexawuKdYWLbM7t8X7zKIH+YcWVW6Xrw27Z5iEEBXgA+IvuK5vCde7uIwKHFIn8rQtdLI+f1ceh3PFhd62Nl/ON2yan67PcePduRTJEL8HR6QtH51s6IYiJNINRNcZGo9Su/aj18Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4eiYlbTdLGdXpavQcJZgpl6t7x5mpitjXkize6oE34=;
 b=YWqPqNBBCvG4bTVkp29vw5qeW1zO/ujvH13vHajIekzbmU+i8/EwKIfa3afaJNv9EY8ftFOcBLhCLkt7pUEIMyfY8yq13iLEkdSG9GwvsLwO8dI6uDFtU5dOiDw3N4vBVVzFNcdXHWCUOya5FNHQMODbynak5QmTZNMnrZRQypqmWkVyIM8lt+DNChqWYpTe2SI3jkWRgnnmHecWyssHVQsY2igC3j3XtybF1KqOOEfMsUJf3DqBkZ9gXILrXt5Ki+NeWDvl0ZLRL4LbBUuhHCJzxBCeGqx4wNqt6cIYxbJpYMl1q67onAQrFLxJ19gKG9E/GdtcJPXPJn66Q+VWTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by BN6PR11MB1556.namprd11.prod.outlook.com (2603:10b6:405:d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Tue, 29 Mar
 2022 09:18:16 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::bc9d:6f72:8bb1:ca36]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::bc9d:6f72:8bb1:ca36%7]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 09:18:16 +0000
Message-ID: <e7bb7cf3-5781-22d4-96ad-cb95afaf91d1@intel.com>
Date:   Tue, 29 Mar 2022 17:17:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
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
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220323165125.5efd5976.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:202:2e::24) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f7e13c6-303f-460a-a368-08da11650ee1
X-MS-TrafficTypeDiagnostic: BN6PR11MB1556:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR11MB155640D176D09CC7F1481E9BC31E9@BN6PR11MB1556.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CIvb26NEKm/Pyb5hzL+e2i3HfB7I5TVAJ2699q+shABy30AffIfi0i/aavbTPNuU8ieIQDJDJd12HbzBi9woj4pVs/01kXy2AlsywNUfTmygJrw/0D6WuabDQGPqjCjvHUpA8oYvDXBdsPR0Kp9nvQQCffyrTWDinA5UMgQVstJsqhPOd3S1olYk0C4NRL/V5EsIbyZ/U3KL4GNEtKQvSkV0I930YlV0mtTqv0N1c5OqiKp4EiwEqnBIgdU8LnOUXe5NkP076h7QLor5qMhjm+4ZjLSNmwf4kWpO78WwcWWYEH3MC76hvpjfevXDQ33XHTmMJHSw73L45Tci3l2xx2xpd5sf5+EKKQI1sRZkpkOPrbm16dFCaLPh4elvSiGUgDzSHY24/b+e+SZhsd4Wj60s5CvjQP9j7SB3YajsiAhHUCxmir48RZaXUFWRGvzs9VzjUbAtLQHyTIasI3Lk5/ubikdn6qxvMT+PI4PLMa7iAndGp5zBXA3Mmpd4V7Cq4t/5HS5DhJVxdsLn5jETinOWhoWYdzGDPIlZSPTjOtuM8G97/4FUa7Yld1D/vqQaarMARzoxT84c8MTXeb9MTi4EujoLRp6Cyva7sy5/SdJdJe9qY4t7AjzN9iPb9ojgWnp8XVlCutLrc6WtySNPjkftlaH4Ay6Hibsd2sB/FWLGrTlOrq5vzzTA0dEw30DSBw93zuXYhLppheEwxwLhJDgx3qEbSMh5jW8DTg+3x4tz9A0mzhxA85Rgka5lhWJWvj9GXfJ1gg7Qp6kCSLoxaVAl1f5hfrQQtrtt4kRjIeksLRyRY2xACNyVU8TFxNRv9iU3HFLcwp0b2SwesimZaoBy1fQSVFcC92c7e5b06cU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(36756003)(31696002)(86362001)(82960400001)(6506007)(31686004)(53546011)(186003)(26005)(2616005)(6666004)(508600001)(6486002)(6512007)(2906002)(66476007)(83380400001)(4326008)(8936002)(110136005)(316002)(54906003)(66556008)(8676002)(5660300002)(7416002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnVSbHdYcGxqdEJkU3NGRjdkS3l2K3pBamRwM3NtSm5CNFRMYW01cm9lZE1l?=
 =?utf-8?B?YnoxREdOWU0vWlNQQ1NBY2h0VUdYbXhsTXlHZW8ydFh4SGIzNUh4cFJPaEE5?=
 =?utf-8?B?b1RBVlp6NDFYN3R2NnVBVjZKbVlzelIweU1LcTNkdDAxbHhIdGRrQ0tkZzZq?=
 =?utf-8?B?aElMaHNMVFRCOXcyNGs3cVN3b3ZtRTdRckNtbU94U2tUQ2kranZVT1NMcGxC?=
 =?utf-8?B?cjVDeVpiY3EyRDlsN1RrZWdzSHU4eDhjZ3JtM3hyK2JZMzFJcU5BdWJSZk93?=
 =?utf-8?B?L3hwbTBnUFdYVy84RDFjVzZIY2hjSTNrTlpUbHNUKy9mRWh2MU8yNEpETzdi?=
 =?utf-8?B?WjRqYU5XV09MMER4Z0JOR2xPSjRYYllSalVNak1IUHVqQnNJZjE4bWJZWEtz?=
 =?utf-8?B?ZXdRaGpSTURNZk5Lc2ZJY1dpK3o4WkVsQ1dkY1JFdFptUlNLRW9Tb3BqUS92?=
 =?utf-8?B?RGdxMnJvQThMRndMejdiUXBDcmVDbjVwenUyaGpDUk9iM1E0NDB2MmlhSFBv?=
 =?utf-8?B?TTBqbXZPMXAvYWl5eUZGd0RBUFJIL2dvWjU5cjROMi9aVmtTSTNxRTVXUUR0?=
 =?utf-8?B?cllaQ25jejRZS1ZoVTQzWkp4eDJ4NzhocmpaMjNiMkpzUHkxUXdybU5uUTNv?=
 =?utf-8?B?T09LSWdOY3VQMUdoSkRBQ3BVUmpNbkh1NTIrenNsTURBQVdDcFp3RzFsdmNO?=
 =?utf-8?B?anIxeGJLUzBmaG9YQkVaYkZ4ZDdIc3J0ZUsrSmJSZG91a2lmb253Mm91RWFE?=
 =?utf-8?B?QVRSSE1neDlMTG00aUpTOUU4NWhEOXZXdGVVR1ByWVlEejZFYllTelpHVE8z?=
 =?utf-8?B?YzBVMmJjaFVEN1lvOW1WeUh0NklYYk5oaTRnMjkrZW5LRHVVYmYrOXQrYXJL?=
 =?utf-8?B?RHYyRWpzckRpNzRNb01aTzlaWmwwMmlmWG54b0dYalh2a3puSm15cXQ5UWlj?=
 =?utf-8?B?ajVTNWNQbzJGdXBaMHVQMEFyajJXbkcwSDNhcE5vQ3FkalhVTmxVSHdPRnp1?=
 =?utf-8?B?MFBOcm5NdEl2MnRVTUJJaGhwaEtQOXc3VS9Jbk8yRE5waHdXejhldWpDVFdl?=
 =?utf-8?B?TEVwQzYyMU1nbTM1U3QwN3Y0QjJmWnR2WEN5dzlwaG5iMTJUSjJTeFNZMTQx?=
 =?utf-8?B?Qmh1N0lCSjVNMEVGWUd3RU4yaERSTDRjVUdnSkYxRmRhSkl2Y1FMTWU2dVpp?=
 =?utf-8?B?cmNDanh0Njk0WTVuYWxwcjFYL3dGbDlnTFhvRHlEay95TmJnR2trMHBhWW5k?=
 =?utf-8?B?YjV4emZLOStQYjlvbXAycFVWVDlrVGFSdWpSek9nL0tpbzlIbG5udVI4SUpC?=
 =?utf-8?B?dmZaRTBVZ01DS3Zzd0xQOEVWNHVISVd5eStlWldYMGhkV25wWWc0SFNsQlla?=
 =?utf-8?B?R2d1VDEwRHh2K2VXR3hqRllyRlFNcnpCWU5FWFNzTGxyRXg1Ky9VUVJxdmRG?=
 =?utf-8?B?RWRKdmhTOXU3bk5SYXhibnVKOEFCNnhvdmlPSUF6OTJMSmgram9hN2ljSVk5?=
 =?utf-8?B?V0Nyei8wWjBvd2NWd1Jab0xvdFlRY1ZyRENUb1phQjAxb0wyZjQ4eGlpOWRG?=
 =?utf-8?B?OVhzWDRMVVZZcDJ0V0ZYYTdWdFRMcml1Wm82SytpQm5hcDl0QnV2VjFKRnc4?=
 =?utf-8?B?R1FrelJVd29Id05URjVueEd1cEgyZktSVkNvUEJ3ckNsL2N0bWVGZkZvM21x?=
 =?utf-8?B?YmtKOVp0b3RkM3J4bWdER2V3ekRvcC9hMFozc0dyRmxFYlhJbEJFR2NrMVFX?=
 =?utf-8?B?OHhJQllQWm4zYzdLTzI5L0dzR1kydFpUQUtCRjNQZWVManh0R3VuSVpmQjky?=
 =?utf-8?B?VWd0NC84S0J1ODBJMXFwcmpsaENLYy8wOUxvN1hTVXN2TEVFeTBWRCs2SGpk?=
 =?utf-8?B?SmJBUkR4ZW1OWmtHMU5IeU9ITWhYSzdseUp6UmlPYTVWOHF4bVA0TzIyUGty?=
 =?utf-8?B?UThUWTNFRzBmMHEvNUQvajNWVDFpNWNwNVNoU2xUbTdLQTNuRGlTSW11b1Rz?=
 =?utf-8?B?SGJPOHRZTGZhRGhwSHRoVUZPdVNPRUcrY05GSk9CWGtsTEgwV3dmMGJmRW1B?=
 =?utf-8?B?MVJiOGZzREVLMmNJdCs0bkZsM0NaRi9YMVZwWmNRZit4UzhxSmw4TC9sZWRt?=
 =?utf-8?B?ZVhuQTdUV09yT3hwMTdWck42UmxqbCt0eHAwaE5mckpqK2kyTm5zWEVIV1ky?=
 =?utf-8?B?Qm4yMnRDR0xnZmZFWWc3bkozdkZ3QkV5ZkZYUWpGVk41WWhiblVDSDBOQ1I1?=
 =?utf-8?B?SXBTMUR6ZUZKNzUxN25aSzFKY0ttNGRUM0dyb0pMamwweWM2SXFWU1VBSVUx?=
 =?utf-8?B?UUp3c3JHV1RpSGpmUXp5OG1vbFB2aUkrYlFlL3hQZU9MeVVKMGdkUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7e13c6-303f-460a-a368-08da11650ee1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 09:18:16.6790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDF+rarHDxHMirkMVYEdTIPYCpYpV0YiDHeOQyR0DupFUMqTYUNhNMPBTM4coay71BB1zp3txlxOZemrMRfeSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/3/24 06:51, Alex Williamson wrote:
> On Fri, 18 Mar 2022 14:27:36 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> iommufd can directly implement the /dev/vfio/vfio container IOCTLs by
>> mapping them into io_pagetable operations. Doing so allows the use of
>> iommufd by symliking /dev/vfio/vfio to /dev/iommufd. Allowing VFIO to
>> SET_CONTAINER using a iommufd instead of a container fd is a followup
>> series.
>>
>> Internally the compatibility API uses a normal IOAS object that, like
>> vfio, is automatically allocated when the first device is
>> attached.
>>
>> Userspace can also query or set this IOAS object directly using the
>> IOMMU_VFIO_IOAS ioctl. This allows mixing and matching new iommufd only
>> features while still using the VFIO style map/unmap ioctls.
>>
>> While this is enough to operate qemu, it is still a bit of a WIP with a
>> few gaps to be resolved:
>>
>>   - Only the TYPE1v2 mode is supported where unmap cannot punch holes or
>>     split areas. The old mode can be implemented with a new operation to
>>     split an iopt_area into two without disturbing the iopt_pages or the
>>     domains, then unmapping a whole area as normal.
>>
>>   - Resource limits rely on memory cgroups to bound what userspace can do
>>     instead of the module parameter dma_entry_limit.
>>
>>   - VFIO P2P is not implemented. Avoiding the follow_pfn() mis-design will
>>     require some additional work to properly expose PFN lifecycle between
>>     VFIO and iommfd
>>
>>   - Various components of the mdev API are not completed yet
>>
>>   - Indefinite suspend of SW access (VFIO_DMA_MAP_FLAG_VADDR) is not
>>     implemented.
>>
>>   - The 'dirty tracking' is not implemented
>>
>>   - A full audit for pedantic compatibility details (eg errnos, etc) has
>>     not yet been done
>>
>>   - powerpc SPAPR is left out, as it is not connected to the iommu_domain
>>     framework. My hope is that SPAPR will be moved into the iommu_domain
>>     framework as a special HW specific type and would expect power to
>>     support the generic interface through a normal iommu_domain.
> 
> My overall question here would be whether we can actually achieve a
> compatibility interface that has sufficient feature transparency that we
> can dump vfio code in favor of this interface, or will there be enough
> niche use cases that we need to keep type1 and vfio containers around
> through a deprecation process?
> 
> The locked memory differences for one seem like something that libvirt
> wouldn't want hidden and we have questions regarding support for vaddr
> hijacking and different ideas how to implement dirty page tracking, not
> to mention the missing features that are currently well used, like p2p
> mappings, coherency tracking, mdev, etc.
>
> It seems like quite an endeavor to fill all these gaps, while at the
> same time QEMU will be working to move to use iommufd directly in order
> to gain all the new features.

Hi Alex,

Jason hasn't included the vfio changes for adapting to iommufd. But it's
in this branch 
(https://github.com/luxis1999/iommufd/commits/iommufd-v5.17-rc6). Eric and 
me are working on adding the iommufd support in QEMU as well. If wanting to 
run the new QEMU on old kernel, QEMU is supposed to support both the legacy 
group/container interface and the latest device/iommufd interface. We've 
got some draft code toward this direction 
(https://github.com/luxis1999/qemu/commits/qemu-for-5.17-rc4-vm). It works 
for both legacy group/container and device/iommufd path. It's just for 
reference so far, Eric and me will have a further sync on it.

> Where do we focus attention?  Is symlinking device files our proposal
> to userspace and is that something achievable, or do we want to use
> this compatibility interface as a means to test the interface and
> allow userspace to make use of it for transition, if their use cases
> allow it, perhaps eventually performing the symlink after deprecation
> and eventual removal of the vfio container and type1 code?  Thanks,

I'm sure it is possible that one day the group/container interface will be
removed in kernel. Perhaps this will happen when SPAPR is supported by 
iommufd. But how about QEMU, should QEMU keep backward compatibility 
forever? or one day QEMU may also remove the group/container path and hence
unable to work on the old kernels?

-- 
Regards,
Yi Liu
