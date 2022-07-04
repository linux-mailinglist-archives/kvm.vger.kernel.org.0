Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2042A564B8A
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 04:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiGDCQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 22:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGDCQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 22:16:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8BA65AB;
        Sun,  3 Jul 2022 19:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656900981; x=1688436981;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=63qzNZTTM5NT60557fpS+Dn5+i7hBt+yzx+9HVXL9mc=;
  b=nhLgsAtaqHf67QWY1k8BI7GCYYuiPDn2w3VA0iNhYhDxQJGc13iKG7CD
   ER8sUuGaCeITCtPG9agTEUpTeaQBiUX26HLcpvfZZsd0BZanD4m+fcLjS
   bHC6ObDGt8d1g9x5C/tNkXqw8nC1e0aby8epE/9ctWJEkJb1DTdM3mErB
   f/75sDBgG6FQsMDMOoPk3q4wfni34yTqEso/r0IhrbqMT3ai8Ar0+/CIa
   eOTCZx6G/nqqluHycw6fBIjiowhut2BrW1TibxfTzJg9YAG7pjhMEDxSW
   /vPDJ2jvdBTHBxujYGuP2uiKcyNzhJ/aHLCQJlvGKWOMyp8NMImAWTeTw
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="281772680"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="281772680"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2022 19:16:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="734663272"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jul 2022 19:16:20 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 3 Jul 2022 19:16:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 3 Jul 2022 19:16:20 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 3 Jul 2022 19:16:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgbfeL2asvB3BtKb+JjKPW3iEtxklFfvzmHQJo9g+DQMRiBZHIEm4pYXJiGpFRZ2bwbWQLtz0nQoo2LRYhdF6esroExkCdr1et7e1mhn2ii/5ArxWwZUMH6FjOhKETIW8pDBB7loPJ65do0UAk4RLk1ACV0PyperCRKfifgD5fRISyZo7af95A43chcpPHkrRJw35MHJIpGpE6BTV5NqdmnThQoCx3BqBo9ANGpDitGqr1WTyrMIlAnWaJirRapx/ZpRvkwBG0+TIwoXSLRf9XlnhOsvUOvZojTP/ojhpuSgjOZwpyfnoXLRXgzqs1tJqDx6KBOyXxGgcKg7ST+gzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vs3qS80Bam+u/XZFLJ9vURrap9ICcnUKBBAF36YYxFM=;
 b=a1hxGAbRbJ0PE82yVy0cxM6ZtXVxkB4wn5HAcmI4a7APEIm7hfPgEHKYPX32LNdPWbqoo3aGnqQ3ZK9FqvfnP9V0QPNbUrY3rowvS51+2GEc2Ag2FiZlrstjkUk+tfEa9BpZ4v4QBjg2eXN/mnocj+fd4hvOVTjVGGzB9B6J6WcDiXcnAhNUaOc6zo9CHCrvtjns6kR72gHDxOsfio5HrXHhFCuP1IrJeFe00C05nTEhPkfnzDtN21vTt2Lz2Uzqu2rr/Yf8yCgDpBMqoYzSL1RMqhqVlAgT0qg2+zwd9WZEHnUILORJJafF1cuDlUMOtPmIvzi0t8P/se9CDjLt0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by SN6PR11MB2927.namprd11.prod.outlook.com (2603:10b6:805:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 02:16:13 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::88a4:135f:7094:bca3]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::88a4:135f:7094:bca3%6]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 02:16:13 +0000
Message-ID: <00b45910-d4be-d0c1-960e-af95189578d9@intel.com>
Date:   Mon, 4 Jul 2022 10:16:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630234411.GM693670@nvidia.com>
 <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0118.apcprd02.prod.outlook.com
 (2603:1096:4:92::34) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfdb57c0-f11e-410d-9aaa-08da5d632ae3
X-MS-TrafficTypeDiagnostic: SN6PR11MB2927:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HrxvHELOb9tWmhGAI0D9LllRkNIBDMo0JmsnCl8yFpucqkDpG0qfjnV+gVm7esl35TLoNWjr4VT+1nezqv36+Lsq4G0YZXl4X0t7Hgp08U5U+h+B4kwWjrTmW73fYnb2C1TZRg4ggevZyBOiUCGURvjlWvlP7tric8x/tDP8ZtPKBS8cM17cw/WUqpmYjUuuFeY0rCtjhnpXzYvG8wbOmzLxByKOwR0u/6FFm5Me1QwnvU2/ETBZfaarqNWqlhqPk/roGcta0aYp51brxLKDsDyS5ZfZWRcwrwA3gjWFeCJtA42Hw4V1VMKUvdjCzHB+RGODpUFc4zpAt+lieXkUrYy379al/JsrZjT/xje6naq7eBZ6yMj51W1IJOWjTvP6/s9pGTKhqkM1xTdNFNJnzHUA+RQOr96uaQf1wxHwotLMNkQY+0Vz8sBPPbs3q753JfnWUVDW2XaUu1dyVjmanFfIA0g93J4LqY/8UiSoEutrL1muF7H3hZ722Ed3RWMYwPi4CngV4NH5iF6mIwYTn97encjy6Z7trbqYbeFU7KJlhFd/08Y/aLuWg4jIDmzcOejfG3RAFbfr9NOwPvZx9rloS7iUatE9GtEUSLKpXZMhLEN63C8sN211EnNr8G0WSNWrda5xAvQl8jL0tPXZp4FQq03/3xEiR1YBlXl4lab+PZlOnOm2OHzYTcONgoy3lmGHTXFo5dBLyd1dfLok5A7Nv/X92vPl8VDXq6Ih7K/7Uqblz3OD0ywzvuYvfk8ipe3vu1rgO75VuPbXDT89LauuvNrjcr5mv6PK4zJiQtdYmmvFn3sy8yfWs4t4RjP1zWwF+gvXoNgcg9JxfXzQFvB1IHjOaqaWI2/MXkgNrb+NhUg21abI8xYBN3vp8z0zz9QHNmqJjGXaqjl1bPojzTwMabB51WxMTzoSRGoE3NY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(396003)(136003)(39860400002)(8676002)(36756003)(4326008)(66946007)(66556008)(66476007)(31686004)(2906002)(7416002)(8936002)(5660300002)(6486002)(966005)(316002)(110136005)(6666004)(41300700001)(54906003)(478600001)(82960400001)(38100700002)(6506007)(53546011)(2616005)(6512007)(26005)(86362001)(31696002)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnRrV1ZFZ010K2JHUVdZdFpZMXpmYjFyK1BCZWwzV0RTZlh5UlBnUE9VQWx5?=
 =?utf-8?B?bGhTNEw1WFlYbVMyMHBVN29Mdzk2M3VnMDZSc1d5RHJ0WE95dUh6bVVlVS9R?=
 =?utf-8?B?Qld6elFZbGtDTElXV2d6YkF6VSsyaDZ1c1hFZzFTZGVDYjZ3Vi9FbVV1Nyta?=
 =?utf-8?B?V1RKaWFtUjhtZVBRS2xyZ2tkKytDbHBoTFc1aGpGb3ZPd0lvWkZOalRqR2tJ?=
 =?utf-8?B?VzB6NDc3Zjd1ZjRxU0VCS3YzQVdWck10cFVHWFJ2U3JEZTE5MktNTmJ6d0pH?=
 =?utf-8?B?cG9rNVFVTGUvajNtUUVnM0FGMkxVaWovUk9ONk1SUDJtNlhnaEF0eE9GdFFv?=
 =?utf-8?B?cmd6enY1eXZMNk5yUzJIcGIwMGJlcldHSEpYcENRcURGNzJkcGZ1NGRNZE9o?=
 =?utf-8?B?dStyN085dHQ2WmlXd0g1cXgrS0c1U09lVm1oL1FCUjFPaG1SNWNJenl3Szdu?=
 =?utf-8?B?b3AzU1hiNFhzUmNnSXpGR0s2dzFFcXFHU05Pd0JDejVrSTdRRFdFRGpTdU1n?=
 =?utf-8?B?dW5zVVpTVnhUZENkdDI1QnBOV25STVNvZG9KVXo4Q1ZKcHg1bmwvUXQwVXFY?=
 =?utf-8?B?em5Ob1hOaVoyS3pVcFJsMjJVVmxOR1VLd01SN1RSQlhVcm1HWWFmUkRmNVpT?=
 =?utf-8?B?Mk9weVVyYzF4a2R0eEtEZU1XNVVQYnE5MUhwazd3UUY1M245b2EveElNcEhQ?=
 =?utf-8?B?UTVscnRIT1gwVEs5aThOUXN4MEpXc2hINXpVaWxHUE16UGRMQVJmVW52MmVz?=
 =?utf-8?B?S0RHemFzN2dndkluWkhIOGVZUllRMER4bU5BUUJjT3FGRHB4WGtIV2NEMm5r?=
 =?utf-8?B?UU9WalMrS3FzMXhGZTEzNi91VWdtNEtDSXNSNnR2THdWNUhjNjJiUG1vS0F3?=
 =?utf-8?B?MUVsZEpFYy9vd0g0MlRmbEZBL3NsNXJhTkI1ekJ2MTBSVU5oOEdJcTZHZUNG?=
 =?utf-8?B?c1BlWnM1Qzl6QlAvQzZrQUlBUzdBZ0FLQUZQYmNvQXRpb3JoWU5aTkpHYTBs?=
 =?utf-8?B?WWV0TnZEZG54WjU0U1Y1UDFIWGhFN1A0K3Q3blI4Nk8vVFNGU1l3YnRKRkhs?=
 =?utf-8?B?VTFzQVNCUVRQcHZmcy9HTmtQbmdJZ1l3OEdTZGYxdDJqeGl0L3ljakgreDhK?=
 =?utf-8?B?eTgrbnpRNm0zN3lTN3ZZRnl5bWlISkhIaW5TV0RHTm9iYnVnNElnYy9QSDVn?=
 =?utf-8?B?ZC8wR0k0bnRML3VQZU11RFRGZ3RFNFpBYkRieWlPRGlleTdNcmtpZUp4WS9l?=
 =?utf-8?B?bU5CQVNoZVpPbU15bzdmWlhocHhmQytqNGxRRVJybjM3Ky9SUFh4RHRNemQy?=
 =?utf-8?B?bVZsRGppKzJEeDRoWVpwaGVQOFRDVWxUUm15WjFMYUFYMWUvL3VaWE04SjR6?=
 =?utf-8?B?U3VLcExFNTluQTg5SVpaTWhmdTFmZTRBT28xSzI0NDFZTC96VWo0cUwxOUJn?=
 =?utf-8?B?eXRPZm1mU3JVZWNhazVqcVZuZG5TeUJsM3dMb0ZTSlppdlNKQUZzODFwUC9Q?=
 =?utf-8?B?R0xxcExWM2pEZ0pJRHBCUS9NajRFWHc4MUZvVTFSK2YvejdQd3loVCtmTXNj?=
 =?utf-8?B?SEdqTm5la1o2U0syMnorTDNYSHNEVFh4RFQ3TG5WZDRzYXdlUmtyd1FZWERy?=
 =?utf-8?B?cTEybFE4QnRZZWNuc2ltZlVKNGdwRzJrdklDd0tDS3J6NE5TWlBZc3YwVGtn?=
 =?utf-8?B?T3g4UnUwS3cxUXdsYUphQnZoSS82Nlp6c252N1VtMEc1ZWVtS0R1MkxLWjNJ?=
 =?utf-8?B?ZitqSXlxOW1aK1NINk9PNnVadlRYMFpxS0dUbE5NallGeGJ2c3hSMENRZUcy?=
 =?utf-8?B?a2xFNmdDWlBjbmQwME1HbHVoSjFYcWprL2ZiRHVVTVJnQytHb3dCMEhjQTBI?=
 =?utf-8?B?b0NQaTZQRnFkTXdSTVdMZVVkVEJwSnN0K0ZTd3NNNmQrbWlLTEZPNWxzWWRT?=
 =?utf-8?B?a1hoYmt1MnNjVjVRSlFsd3BveG9vQll0WGtjNGY3M2FtZy9oUVlBY25HTlQ4?=
 =?utf-8?B?WlhWV09EVGM2UHdmS3NMcm1TWWZQVlNwODdCZlRxVU9zS3JyR2lvWWlOM2pB?=
 =?utf-8?B?eFdVd0ZpbC9UOEpJWWttallUR1hRMTRQSFRzS3RBaEpDNFZtUkJxRG40bXc5?=
 =?utf-8?Q?C8vi8VNStjXx2yFSuJrunCx+N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfdb57c0-f11e-410d-9aaa-08da5d632ae3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 02:16:13.2019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0IwMr2dDPJCgOTl0/qMcNCPCBA/MwbnV/K3asYl8k/jagHtkl6ErY3WJt1S525K8TMdfGqqygf4QnqhGdsyiug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2927
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/7/1 20:40, Eric Farman wrote:
> On Thu, 2022-06-30 at 20:44 -0300, Jason Gunthorpe wrote:
>> On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
>>> Here's an updated pass through the first chunk of vfio-ccw rework.
>>>
>>> As with v2, this is all internal to vfio-ccw, with the exception of
>>> the removal of mdev_uuid from include/linux/mdev.h in patch 1.
>>>
>>> There is one conflict with the vfio-next branch [2], on patch 6.
>>
>> What tree do you plan to take it through?
> 
> Don't know. I know Matt's PCI series has a conflict with this same
> patch also, but I haven't seen resolution to that. @Christian,
> thoughts?
> 
>>
>>> The remainder of the work that Jason Gunthorpe originally started
>>> [1]
>>> in this space remains for a future day.
>>
>> Lets see.. These were already applied:
>>
>>    vfio/ccw: Remove unneeded GFP_DMA
>>    vfio/ccw: Use functions for alloc/free of the vfio_ccw_private
>>    vfio/ccw: Pass vfio_ccw_private not mdev_device to various
>> functions
>>    vfio/ccw: Convert to use vfio_register_emulated_iommu_dev()
>>
>> This series replaces this one:
>>    vfio/ccw: Make the FSM complete and synchronize it to the mdev
>>
>> Christoph recently re-posted this:
>> https://lore.kernel.org/kvm/20220628051435.695540-10-hch@lst.de/
>>    vfio/mdev: Consolidate all the device_api sysfs into the core code
> 
> Correct. Same for "vfio/mdev: Add mdev available instance checking to
> the core" which you originally had proposed.
> 
>>
>> So this is still left ?
>>    vfio/ccw: Remove private->mdev
> 
> This is by this series (patch 1-4).
> 
>>    vfio: Export vfio_device_try_get()
>>    vfio/ccw: Move the lifecycle of the struct vfio_ccw_private to the
>>      mdev
>>
>> IIRC Kevin's team needs those for their device FD patches?
> 
> That's my understanding too.

yes. You two have great memory. My vfio cdev patches relies on these two
patches. So far, my branch doesn't cover ccw. Do you have plan to 
incorporate them? I would like to apply your ccw series to below branch.

https://github.com/luxis1999/iommufd/commit/e6e52d0d2bba6510c0a9fec8184d5f169a50fda2

>>
>> Thanks,
>> Jason
> 

-- 
Regards,
Yi Liu
