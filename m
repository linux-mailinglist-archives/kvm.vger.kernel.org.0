Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5326D13C4
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjC3XzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjC3XzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:55:07 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4782CA26;
        Thu, 30 Mar 2023 16:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680220506; x=1711756506;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cixcBaVxCryMA/SKOMCoTL6UmFfFC27pjmCf07aJ3zw=;
  b=h8DzM+95zSFlyRfzVPo+w4Ikkobo9tn3Mtr9jMQGBhFfdrga2IIfQBAn
   TiGLF7YvrIIiTVd1KD3fgoil3qlVG4K4QKvBFjNnUmd+ggZ85b6XRjYTf
   8ffGJthkOYfPU0MaGetG1shoSe6fOEx53ts8bwbspNJ/rVV3VxW1m+7Zh
   t7sQGkCrW50XwACy2sUEwv4ZsH438QN9EslhfOwkOf7pjTzfVfistQZzM
   m7Wyk1uRtnVbhrUqtG/15xnLQaQIJCOJgdXEz9mk3L4y53mz2FqWLxYUG
   NXZLShHVIWEwULg4HBuFdQeUCpgMIuu1VnFS9kPGM/EGyrJipEQqj+n0P
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="406314964"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="406314964"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 16:55:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="754200232"
X-IronPort-AV: E=Sophos;i="5.98,306,1673942400"; 
   d="scan'208";a="754200232"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2023 16:55:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 16:55:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 16:55:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 16:55:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZO12mPRpzTzp25u7h8mrrwms64JmQS/aVoQdiNgKf5jpi1OfK9LRdi5HuDgKneg369M+Elwith2UKS77yukeUvMMw51Z4zvbT8higuqhk0aoCUCetATkH0jHAzSDCUDFxiASlaGubZVAByrG72L3wrY3V8JvdKJcn+T337kjdNqoZqb7QAJCnIxLitgwP5wuq1Ftj+BdV1ePU2tTEv1wxQ/6O6IR3J7YQDz6nFe76N/vml8FC2aLTBZhRLqihjgA/NFGPzSgRRz69gs39YBpX4hl8eLkFIYLfuu3509LW6xppufHqMp6bP6xYRHmNLfqIi7dZULMnbCShL7JaPZU2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbSX1H9w5IeTCqGdTRyYJ/t4WLJL48W0zir3cOEd9TE=;
 b=jjzdghbui7qp2SyxxvYnfZ36r9dWp0lYXvjUkOcdwSOVokp/Bi5A3BNwcIUtWNPFIuDvR6mifH/FevCcClcmMf2X2eR3CxWOTiaeex/5FvARjo+jP08F5Pe/2kULNjSfZ/nL36WM2zWkvutN9rtUtyCppOgCxgVAVQcHiz1oBIlJipU4E/xml4SltOUMKN+RQwTvZ98rZRJ/2qrr7IR2v127HRtixduPuG+b/zfT2apIdiKm81bozjbQO5AJa99hftgAvtfshBsWPt7pAuxtToK/hwfP8vsBQdx4VvwACBZAfojeDtk9SPlukcPB/9HfzV7VnIVooU18WpfZIvRmAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by DM6PR11MB4593.namprd11.prod.outlook.com (2603:10b6:5:2a3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:55:02 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6254.022; Thu, 30 Mar
 2023 23:55:02 +0000
Message-ID: <65669f7f-e1fd-5b6b-f879-9166bd9a474c@intel.com>
Date:   Thu, 30 Mar 2023 16:54:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH V2 2/8] vfio/pci: Remove negative check on unsigned vector
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <0dc2a0c8e25b13a3a41db75ab192f387a1548c80.1680038771.git.reinette.chatre@intel.com>
 <20230330142657.3930c68b.alex.williamson@redhat.com>
 <460fdc5f-7613-5164-0247-254939cedc71@intel.com>
 <20230330165445.7bf7cdd6.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230330165445.7bf7cdd6.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::10) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|DM6PR11MB4593:EE_
X-MS-Office365-Filtering-Correlation-Id: ff46f854-8b3e-4ca3-ef46-08db317a2d8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjs6rAxWCTIl7anyFZ5ubFUbyxsRIJ/Ow92hrcAPzRp5rhl1Y7LEZckxfmrf4MYUbjrHNN5PMxDgyWvsAateUT5TFi2tPSCyatw5IOIBuHe+n063VR+999I/7cUnrVRSD64nRxfn85UzzHTybvMV7lrWtJ3Z/cKNmNWBTwzHflnb5AdK+DzLlDYbu5sCdoFoS9vIsYUajIQqiSgdtb7+Gam6dmK1wMrPDuhh4fYksZzwPvmGvIu0Z2vFUaqL+nSvXLDElqw8Vb4wGEQhRCTdSTXgkHIEq0cNc7W5L3aQZUJ4H3/voLg0+STs1q8wQtEfXqz1lfrI5neaPhGjNNUvISvDAKaBS5elzVSZW3UOF4Nkdp1bGmr4Sy00fPL2LvIg3B9pD0+WIPUvT6vMWxO3KTj/cjI5ozLeq+qNQaOZUKp76ZGvRrtzrlYsW5yBpRHcF5WJRZ5M+ROduQY39C6z9JygsfQBeoqRT75QY0JlHXBL+6uBwATEgQ4omrC2t38GDPNoWQsuNkFsAskKfhv5eyWlKrL7IVcEHxUpI6QTiRc5/QsmvoACI0jaTQUk/BPD6k7Oi1/xsR2JwN2HQ7A3g9x2PK4dkvGJPtodda7OaxtpO8QMuurqlQXSTVG5wpMVNZTozNYw9w/889wYIHPCtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(6512007)(6506007)(316002)(6666004)(86362001)(82960400001)(8936002)(5660300002)(2616005)(31696002)(41300700001)(66946007)(6916009)(36756003)(8676002)(66476007)(4326008)(66556008)(53546011)(186003)(26005)(38100700002)(83380400001)(44832011)(478600001)(2906002)(31686004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1ZJdThydFMreXppT0p4M0Z2YTNtUFgwQlhyanN5dUFaSm9lYnhTTVJBa1Y0?=
 =?utf-8?B?RS9DbzdMV0l2VVdSNW8vdmNpUEFpandHQzdyWWthWGp1S0RCNFpobmVsem9V?=
 =?utf-8?B?VXE2VnZOaUpBb3RTMzNObkdoSmJPYkpyTHRaOTNTdFVuSVQrZmVoK3lxQzcz?=
 =?utf-8?B?bkorSXp3MFdpbm1XV3l4WnZwcmVIRENrcGx3N21vUG9UMmpuUjJjRFlvbkxU?=
 =?utf-8?B?WGlybGkxQWZHTlpwTDl3VmQ4TFVFYTZWUklQbGpQM2NGbXNQVTdZZkRleDdk?=
 =?utf-8?B?YzNZcEtwcEFuM2ovV2Y0QU1tazdvZVJVMU5vMFpWZDEySU5rYS9Odm4rK0NY?=
 =?utf-8?B?dVcva2dpQm1rZCtkdE56N0dOZG1BbnJPa2lDZW1pZFREZ0psdHNTNjFRay9N?=
 =?utf-8?B?eVV5QVR1QmxxUDBwQk1uczlOMDlhbm5sK051djRSMDhCQzZwRWFjZWxjT2wy?=
 =?utf-8?B?Y3RkV0tmRUkrdTJqRDQvbHplVTFuMC9yNEdEZWtLVjZENFFzcURKMjFSbDRz?=
 =?utf-8?B?YWxnYmwwd2Nsdmh1dktlNzI3OUhtanNPaE0rZGV6aWNCL216Q1Q0VmVaOWc1?=
 =?utf-8?B?alFxSVpDZFZCVlB6MDBkMjRuYkwvQ1lhTWtQYzVuL1BJeHppa2JLN3FBcG1i?=
 =?utf-8?B?a0FYRWhQc1QzVlZFdittUnRmUTdFa2dacUF6c3plcXZKNW1TNXl6V2FqVVVO?=
 =?utf-8?B?UnNYUW1Oc2ZZVUhSZWgvK3JuaDl6RGJHVDNsa3g3TjVOWmNHa2lnMTQxb2dX?=
 =?utf-8?B?N0h1dHpNTlZlOHNDOER5V3F1TUJ1eDV0cEdRbWo3V2VMKzc5MFdzQXFuYks0?=
 =?utf-8?B?ZVhXam51TG5NR0dlVDBza1Zkcm13SW5JRjJMbzl6L1NBbTRWVWRIQ0drb2w2?=
 =?utf-8?B?RU1rVXJPcEZ1dnJJZXRjNWwrK01iN3BodHRDVlpCbFprenFCWVd1clVkcnQy?=
 =?utf-8?B?UUg4a2dlQy9VbmE3V3llajl6ZnJoVkgrazFFQXl5VVZ1aFQrd2NEcEplaE4w?=
 =?utf-8?B?eFptamVSU0J1M2RJUXRVY1A1SC8zV1Vxb0IzTmFiNEthU0NsN1M4aWRSQ0Y3?=
 =?utf-8?B?WHhqM3ZmR0EvRjBiMWJiWllxeFREQXVMdk85VkRhOW5CU2ZKenFONjNNd1BW?=
 =?utf-8?B?N1FVL0l4MEQyYU9ST1BKbXlaUzFkTmM5YU5FNWViV3lxeUxDcnY3eER5aFVk?=
 =?utf-8?B?Z01YRVZWM1BGWFR4dE9JZzNrWWhYSjFNZ3RsdXZuTGVkNk9GcUswckhxaC85?=
 =?utf-8?B?NDY2aEI2UFVRSUJmc0NnMFZFZW9RV0RwQkFnWFFmajJaZHlCQitvMHpYU0dD?=
 =?utf-8?B?bVVJZ3ErYVp3aHBxWThoRXp0Y28ySHhzMjd0RHVKR1owUE1mQmdPUXVFR3dE?=
 =?utf-8?B?SzBrWVhsNkRyN1dTR3FlY3luNEhta1RPZ3FMTEdWTXEwUFU5WnYwU3JvOVY3?=
 =?utf-8?B?SkxxMXBxendhUGxtUmVMRithdzJvVmNWdTBvdzVCT1M5c2dreVI5QlgwRnNx?=
 =?utf-8?B?NnVyY1BMWVJMbGhwY3k0bjFmRFlNbmpTVXVJdEdBUkxERXFRa1VrN0ZlQjc2?=
 =?utf-8?B?bXdldExRbDgwMXppTkhVbmg1RDVidFJnOExzOHYrRjE1OXVZZEoxVmM5WUNi?=
 =?utf-8?B?K2pKRXhrNUc3ajREYi9wcnVyYitoZWRlOXJtb3hDOGRxWUdNbEpsYzhlc1Mv?=
 =?utf-8?B?ZVV1TWJpNVNNQTUwSHEvbEVzbWprMnUraFZvdW5Rdnd2ZWFWNUhFc1c5bGJr?=
 =?utf-8?B?OGtwR0p3Qm9ERno4RmtJVkhIbEFpS3gzWnM5QzdIUTF6MURoelkxYURSa0g1?=
 =?utf-8?B?RmZraWxNMmFHaFhRVVN5ck9wVzh6VmpudlMxS3RiZWRNdHF3bHpvQUNOTWpl?=
 =?utf-8?B?TERNanUwTXRhWHFENUlkQTVzdDVXMWYrcFpPVENsLytXM0srVTVNZTJwL3Vs?=
 =?utf-8?B?NWJJYWVWei96eVV1aGNTNDZRWDVrZVU5REUvMzRRKzdmVzNiWlpLRWhEeW5W?=
 =?utf-8?B?SWlrMm1LVTFRUHJKdzlJd2tTN2cxWVdxOEUvdnlsV0czVVlLdHF3amNZNXZ2?=
 =?utf-8?B?MFltY2lUTGQ5YVhVdExFOHJ3R2ZPN2RyVUZ0WC9Fa3YwRDBpQzFjRFBYUWdE?=
 =?utf-8?B?bkkzU0h0QkFLMDBFNktmVHJkTjhqN3FRalBqWUo3dFYwYU9tYkNWd0x1R2ZQ?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff46f854-8b3e-4ca3-ef46-08db317a2d8a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:55:02.5799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kjrKk8gu3bkA2am8wODkqPXS75IVZ3auwC4h6+ObsI3pk4nigas7n0x0RIx3thUCTyiv6TDiF1sGYdxmyF7jag3/98JQ39s9ANTKnexiQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4593
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 3/30/2023 3:54 PM, Alex Williamson wrote:
> On Thu, 30 Mar 2023 15:32:20 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>> On 3/30/2023 1:26 PM, Alex Williamson wrote:
>>> On Tue, 28 Mar 2023 14:53:29 -0700
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:  
>> ...
>>
>>>> @@ -399,7 +399,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>>>  static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
>>>>  			      unsigned count, int32_t *fds, bool msix)
>>>>  {
>>>> -	int i, j, ret = 0;
>>>> +	int i, ret = 0;
>>>> +	unsigned int j;
>>>>  
>>>>  	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
>>>>  		return -EINVAL;  
>>>
>>> Unfortunately this turns the unwind portion of the function into an
>>> infinite loop in the common case when @start is zero:
>>>
>>>                 for (--j; j >= (int)start; j--)
>>>                         vfio_msi_set_vector_signal(vdev, j, -1, msix);
>>>
>>>   
>>
>> Thank you very much for catching this. It is not clear to me how you
>> would prefer to resolve this. Would you prefer that the vector parameter
>> in vfio_msi_set_vector_signal() continue to be an int and this patch be
>> dropped and the "if (vector < 0)" check remains (option A)? Or, alternatively,
>> I see two other possible solutions where the vector parameter in
>> vfio_msi_set_vector_signal() becomes an unsigned int and the above snippet
>> could be one of:
>>
>> option B:
>> vfio_msi_set_block()
>> {
>> 	int i, j, ret = 0;
>>
>> 	...
>> 		for (--j; j >= (int)start; j--)
>> 			vfio_msi_set_vector_signal(vdev, (unsigned int)j, -1, msix);
>> }
>>
>> option C:
>> vfio_msi_set_block()
>> {
>> 	int i, ret = 0;
>> 	unsigned int j;
>>
>> 	...
>> 		for (--j; j >= start && j < start + count; j--)
>> 			vfio_msi_set_vector_signal(vdev, j, -1, msix);
>> }
>>
>> What would you prefer?
> 
> 
> Hmm, C is fine, it avoids casting.  I think we could also do:
> 
> 	unsigned int i, j;
> 	int ret = 0;
> 
> 	...
> 
> 		for (i = start; i < j; i++)
> 			vfio_msi_set_vector_signal(vdev, i, -1, msix);
> 

Much better. Will do. Thank you very much.

Reinette
