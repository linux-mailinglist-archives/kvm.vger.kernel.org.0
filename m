Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8464652D1D
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 08:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiLUHCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 02:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUHCL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 02:02:11 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38494D106
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 23:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671606130; x=1703142130;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ozXrhUY9VaEi8uoF7d+tOgfcGLMudYEzOZf94yZt2SU=;
  b=koHljazjfCM8mlM2X5x+gzd7WZGxz18P6459q6CrrbIkOPEvAz0RS31t
   XWQNZZHwiDnQAhGElzTN9WSb3gP9M/FbYaSvZRn5OWRm6y72Y+dGHnbwi
   Or5de5nRwMZTprsZ0JWZNO9FPuLBtfvIT3CYVQM+n9vLvE/E7lD3NjTSd
   2h7uZ5FJLHxTBDsvnVLzEQXj3oR3hTVvxZ7XEyWvIahcYWGZgxMnM5Gbw
   UfkJIKdgLu/KXGejBmMHYBLp1FnoyRL/xadqcvH7mad3VZ01fCNlSi2bZ
   /YZzf/X3ambFJ9LPchkgExnJ7m2fpgXpyuuWQovv5ktMej6FWvonT92WT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321713031"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="321713031"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 23:02:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="681924651"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="681924651"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 20 Dec 2022 23:02:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 23:02:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 23:02:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 23:02:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1RQN4keK8ufcsnnk/DfKBZgPAW1H6bJ4AlpMCr1R8rnl+HtoAvF7NA8FLUDvvI4uMRm7vhZ5G647uIx+ZG5U1TiTPZ/Zxfdlf1JwpGGbY6F6W+lOmGdGs8oC61DaM/eK3ZIM0B6TGpBRWtiFwNEXqPnXhnQE5zRNPJ/zHTBy5pfE8Q+znz9BN5CXWtkVFGSTdcifojpWMQwDnhG90I+aulwDukVl63yNxIWubvnvafVzIh5sm2mYcfkgyzCpDLrZ9wIfiomN/ZcFH9NyGYL/P63vj5Wg0AF1tuDeMQwcTXqkOf8mGFimO1xokMH5QiC3Y9XsC80bz7GH3c9/ODLwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yxZQ+GiZCa9fAISOfiN5SbS7Bf+21dAi/QbrlVVKn8=;
 b=Vh8wDVMJ5a8+VlE2ds4ma9piTONcOg33SoxL5pR2purbUFauAAKCI7Mj0x7hoQIAm8XnuUGc6r20J+Idm9tzqJGyOUDobpPDKOE0hFyUF9//CvLS6bTPdblFSVDw9zSUb5KzD/uVbWokMNKOYzi9NOVPHweS5BP0Tq8TwM0Og84eKIPOy4tNqvZOF0d8qexm62wYJAHEq0rSoJWH3SNvo0gMNolBBT6fycx2jNGy5VYGbvEf2VdBV5xG+Ak2ZtvnRRheSQ/xSWmDksPLIGP5NU0mKserVlvkxYFgYAQe1yW1IraV5yoOd9RKJkjwpcwdIGz4Iu5JWBfSnnq/trBjaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7361.namprd11.prod.outlook.com (2603:10b6:930:84::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 07:02:02 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8%8]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 07:02:02 +0000
Message-ID: <53e38355-cbdb-13e0-bde9-77175ded6121@intel.com>
Date:   Wed, 21 Dec 2022 15:02:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 03/12] vfio: Accept vfio device file in the driver facing
 kAPI
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-4-yi.l.liu@intel.com>
 <BN9PR11MB527678C180EE0BBD1F40E3698CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527678C180EE0BBD1F40E3698CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: 466fa001-c694-4df1-7ae3-08dae32142b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DtSoVNTdmpE1iOsvHRypsOYNnA7E1gTJjnYwmstfpSzRkckK50RQ6HsgdctmKtzNpvygoPV3I26E6NxFVd8KVf84ou1V4Gmnw+gfwWCb2RJ0XvOs1uwHqmOQpN6oDDs4DthqmRTwSHrRL+NGnVssxex6xDRvma3Pd/mMrXmYD6srriYtQzuQT++Oh+ZnWs/VFoXsPdvMfV/m9+BfoSCtnGnT4l9wh7d4o2UG1rZeRnQP5iCO4GpZVofOaExNDVu4zD1J7Zii+DOvZ2Scu3eEE4bCZ8q6MDi9w6cX0q/6+yqD2mh86LG1WGPawag02A9fCImov4pesAKV8/O/jokEz3dj3n1s/VTw4+VmTKciq8sc9xPyP/uF8xhA5Fi9566kN/FxHe648eKVuyYCiDqIPNpvJw3+Vd6YbfTC1+uBX7acj88W726LzwZUMpknb2P2ZaP5GcAn2fCpdUkutqZidnZc90En1MK516G/P3xCrByR044APvSiP7pbFO0UonUK6CbVY0u7EBQK9XK3B+gV4Tg0SPfPKqwqf2Nf2eJDISMu2Di9YIXnM1Zbx96oKMgArU3/1oNBIFwrGuPExzWNXrOtWwIP+ge+TYPDqJTch4eMW38olBmb1aU7ZMu6fs9SdKjk3FTViCDt0RRsuR/ySN1G3uuv8ZMDHFjHaHqUiGwXJIoUBEVr5nBpqlo5vreJg/n67DLyYsjkxtSiWKAvtl+/l7BGnCu7v88gyx5w/sg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199015)(26005)(31686004)(6512007)(6486002)(2616005)(186003)(6506007)(478600001)(66946007)(4326008)(66556008)(66476007)(8676002)(41300700001)(8936002)(5660300002)(6666004)(2906002)(7416002)(36756003)(110136005)(38100700002)(86362001)(54906003)(31696002)(53546011)(82960400001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEtHZ1ZudDVDeUxlNlUrbzJ1NDNKSy9wL01rYlI0OHI4NHJlRnptWWhhcW5L?=
 =?utf-8?B?d3ZULzlTZXpHVGZuVHhDWWZlSmVtajdOUno5VzdwQVBLVlFneU53YXVVd2xU?=
 =?utf-8?B?aXlOM3hhR0s0QnJVeDc2Z1V2cTA4TFN0aFNzSThEYkl3VDRFenV1S28xZ0x4?=
 =?utf-8?B?dXlNSzgzUm9vTlA3bXlCbjZ6dHRFN2pYT1dDRXcwY0pDNlV3WldocTRVWFhG?=
 =?utf-8?B?TkJYWTY5YUQ0WVRaZUY5VVB6MzNUZzFzZkNVWHFWRm1rYU5kREd2ejVyODh3?=
 =?utf-8?B?VXNaanN0WlVKRzZjcTVwSldxWWxHeWUrcEZZSnVFTGRZaTNjZGF6OFJVRWln?=
 =?utf-8?B?cXdTNnBKajNVVlZIZDZFc0lHU1FVc1UxdUpvSGpHV0hjbXo4TkpnNlhjN2pB?=
 =?utf-8?B?TlFkYXVnQTZtendocFdjQVpyanY2OGl5anFoeWg4UFhPTXg3RFRiQ3JsVGZX?=
 =?utf-8?B?SXhxUDY0d1RBTzNwWFNZOGNnL0Y5b0dRTnNRNGZyOTZtVHdqVWNmaHRvZm5r?=
 =?utf-8?B?UnZzTjdKZWNYbkFGZkVRTFF5eEwwbnNSWFBZZkEwYThSSUxXQTl0QjNHVGxG?=
 =?utf-8?B?Z2paS2VFTm1JSE5jWmtPc0I5UVdrU040aUVjbTlaanlySUE0OHpGcU11WjJK?=
 =?utf-8?B?VDl4UGJZbmthQzBIUk5FaEJoeE1oVXdjZjFSRWZZaTYyMDBYZStxaEdkMER1?=
 =?utf-8?B?dE5LYWhvUDNzQ2x5d08rcjl4em55RzloYng4STRGZHFvSXNCZUpuL1g4V25O?=
 =?utf-8?B?OG9lYk1Wem9DZ1dlcVlJdXNaWDVWWVl0VXZ0S0tmeWk5TTdNd29QWUEyYTNz?=
 =?utf-8?B?N0ttMjN0YytBOVBUaU5CbEVjRmljN3FKVTBub0w3M3pELzYxTWdXVmg3VkF1?=
 =?utf-8?B?c3pxOTF6MUNUVEJTYS8xTS91WmJTVDZTdzNxOFIxdHhjQTFKbHdRUkZqbWRu?=
 =?utf-8?B?OE5PNVhKZGcrMjVLL1dWdzdwLytpY09DSm5oZCs4OWtJdVpBbkNsS290SXd1?=
 =?utf-8?B?bHF5aVRCM2Uzc1B2Ty9sTGcxS2tGOHRVYkhERXp2VnhqSU9kU3JkdHREV0Rw?=
 =?utf-8?B?RitDUVVud0FQK2hnRE42VmVESXRqbEF4Q0lzQ3Qzb1g4YVlmdkF1dytTamVq?=
 =?utf-8?B?MUZjNlp3NnMvOGtYL1F5NjhtdFVNSnpROW16RHV3V2lhNTRmdVlhYmc4Nkxp?=
 =?utf-8?B?OWgvZGhSS1lvNWp1UVFXUDd2akdZWFZtKzhuNXZIYkdIYXJ3M1pFckU4aGhv?=
 =?utf-8?B?TElVTEw3dE1TTktLMkI2VUNEMTNBd29MOExKNHRIa293Q0lYWHNmM3RSeWxM?=
 =?utf-8?B?NmpPQ3l0WnRMSWltU280SVNzUGJ1RmJreWRiWHU2MGZITWVDcU94T3pLMEl6?=
 =?utf-8?B?S0tFT21TMVlQMGdYVXBIenJsYjJGbEVRNVlVU0dzdG9YbzhCRSthcUl3d1k1?=
 =?utf-8?B?STkzQUdIMHBya3N1aTNCYWdDMUVlSVpnY1g0Z0krcmViRG9RWTZuSFlpdGx1?=
 =?utf-8?B?NlR4TWt4Um1ndjd1QlRKdWViU25saXo0NTdlQUxyRTRIMGtpbmdHK25wTGlw?=
 =?utf-8?B?QmczdTlXOHVxVEtpVE8wZDNlOU14bEZBZnpVN2xWdUx0dFlMWUxycXRuWjh1?=
 =?utf-8?B?TEcwTnh0N2dqUDVxWGJ3TGRzVGppMnYwYTl4U1NCSUNlbll6Nm1qRWdCZW5y?=
 =?utf-8?B?bG01cXhWdWkrMi9VYS9IM1M4ZUhRTUg4ZEYyQmwvWnJGUnF5NlZ5RHMybDZZ?=
 =?utf-8?B?VjIxOVVsTnFrdldhTXNyYml3eU5MU2l4M3QxOGh3Ym5wZ3pHNm5COVhCeUhn?=
 =?utf-8?B?Q0ZpVVFZWEZVVytaUndUOTI4anVKQ2gyc0J3TkhHT2FOOUZaSmRGYzkyaDVp?=
 =?utf-8?B?NFB1di9SL1JhR0lvZEUwNjYwTHNVb1FZa2FtUEE1VjFuQThGVy9xOWJqdlcw?=
 =?utf-8?B?RXF1VklrTVNDQ0hWU3RjWHloNDVQZGJsenJjQTJrRDkwRDlUNDFneVgvQkdP?=
 =?utf-8?B?QXUvdDY2TE9pRTZMdlN5R0VaTzNkdzFsVGJaQ05PMFd5ZHhvVjFBRXRBYnNr?=
 =?utf-8?B?M3pnVk5oWFB6WlozQk5sckFQR1FBSnAxZjJjdzFlaDV6Wk1nQWphSlNxWTgv?=
 =?utf-8?Q?21a/wgEjrGovhTOKhe7Hv5qZV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 466fa001-c694-4df1-7ae3-08dae32142b8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 07:02:02.1814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wG49ytuxUAOl7gta0trM8NvzcTGNLpyRdXfjFAcgnqtbwKONfU6yF3Vi5QMxK9qai2WMql8M/wZeNAzxZkW2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7361
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/21 12:07, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, December 19, 2022 4:47 PM
>>
>> +static bool vfio_device_enforced_coherent(struct vfio_device *device)
>> +{
>> +	bool ret;
>> +
>> +	if (!vfio_device_try_get_registration(device))
>> +		return true;
>> +
>> +	ret = device_iommu_capable(device->dev,
>> +
>> IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
>> +
>> +	vfio_device_put_registration(device);
>> +	return ret;
>> +}
> 
> This probably needs an explanation that recounting is required because
> this might be called before vfio_device_open() is called to hold the count.

yes.

>> +static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
>> +{
>> +	struct vfio_device_file *df = file->private_data;
>> +	struct vfio_device *device = df->device;
>> +
>> +	/*
>> +	 * The kvm is first recorded in the df, and will be propagated
>> +	 * to vfio_device::kvm when the file binds iommufd successfully in
>> +	 * the vfio device cdev path.
>> +	 */
> 
> /*
>   * The kvm is first recorded in vfio_device_file and later propagated
>   * to vfio_device::kvm when the file is successfully bound to iommufd
>   * in the cdev path
>   */

got it.

-- 
Regards,
Yi Liu
