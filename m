Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69BC963A49B
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 10:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiK1JQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 04:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiK1JQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 04:16:38 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473D425EC
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 01:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669626997; x=1701162997;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IX/ykOmD3ol+SP+exPdtOQevIe9cDnHDEGibKetT9vA=;
  b=F3iCQ2dExDyYQJm7umlwncTbvjQhFkP4p72C1Y0MbxJh8UCV2k4SCvoI
   eNd4tqNSu4FIJf4AIJR1o04RRHGbYsA/ynDK6e+Pz/SU0x8KGqFJj+7+G
   YGIh3cMes9eCmTrNFJ+7u/4DfQixd4bz0Gksevg4GnOyZvwKhWZaPPnIg
   FNc7Fwr/hB1qoThnksx6kOyqUh0lubKORDBtNGEb4puvjU/h5Nm3XOZe3
   UmB1SRUd1AQwEwY7S5afbbDogafCXJSLhpea1HhT4r2L0/9huvB1+oZuR
   tj0D77xsTbu+rnWVwInX4YVF8fCPrICjFQkXTQa0mjDwuy4udun0qmr8Q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="341699972"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="341699972"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:16:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="732067617"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="732067617"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Nov 2022 01:16:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:16:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:16:36 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:16:36 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:16:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StRt0I1Tp56zMdUvYA352T+b29bfCpUVprUm0r2Rm4AGuo5IksKL4d5sQ8Tk2YkIiJrvPrUgnJrmq/MmqN2W6/Midag9ccJ8z4BTYGzMbhsMRF1YAUFTKjy8ZnhJf+qjGq/DVcqeSXnndOag37h9iS+hYzQ86Vh8CEk/2x0UYEDqCDSroeIhHIXj3m2mAvSd00RwDtrIvZSPUsk0T0mYJR/YDlsIodkcpENQE9RbaTOUjPERXvRgQ8MkA/ydpAcB7JyFMsm2qijn1jKhfuIqZlmMzVblZxlZXqIvmg3LRQaTbNXG89goZ+aYKS/iWZru5KSUjWwQKz0ARcYJc990pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNfZWN5U6h87xp/7hhLgAwGeAFINOlKYXXiRkQQRt74=;
 b=ZpuYpq2VMGRa9NSpz86bGFESQ+pB/Jip6omDNpUE5LwF+nypF0OX0Y9HE8ayPsYQWzsgJZOO6z0iAomFv/QgrT2Vb4nfUt0Q+OjjQr8nKcGvKEU1ZvFtYAvANEfj2Ow8DS8kt3D5aW28BG+M8QH44DlUsmgR8XyIum5tN0UCfiJBs0o0LoumUiR2GEik896HKO8oZcnl7vo3rMfd3TfvVfAZY8iN+6ACBj7G3FBwQ4xjkxt3pMa1lXp8Q3NCIkxR16DXbgsPpWOivZ8213JosoxB7DyDR1yKePRduSbr4XpViBZW197OWPovD5Hbb+mzcHkquToWbteoUpPVTPxq5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6169.namprd11.prod.outlook.com (2603:10b6:208:3eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 09:16:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 09:16:32 +0000
Message-ID: <4e180f29-206d-8f7c-cc20-e3572d949811@intel.com>
Date:   Mon, 28 Nov 2022 17:17:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 03/11] vfio: Set device->group in helper function
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-4-yi.l.liu@intel.com>
 <BN9PR11MB52768F967E34C3BE70AA0FCD8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52768F967E34C3BE70AA0FCD8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::13) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: edeb602b-5133-4bb9-17a9-08dad1213d50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RSaviJoKi7JREx/hSji6nx08MBRovvpLHzI4oBEm6GQeM5WXw7h3QsVI3ZI9W58GoKvHJd/CtNAc/XWu3NjnGSWdPdERbGbAOcoJD3VHLMEG4GvgUzAiYyNrIlnNI2zVN7zX+/h8xfujeBYwZKe299SZFBQ9elJ80TZfmGkk9/EGUNYZNJyKb1CrMdNr41DYfRAEyfDsEwWLo0zvA5DV8b9rHiBPk59uQ48CcbBYytaCY1aqZPm56ZrEChDS8iLDned3diAbziuogB4gXfBv9TO4cTy1ecq5GYSyYpNadphuA5M56iSslINPzWCy/L6rebwj9/tRiZNJY7aE27ZUfJ+CIwZ82rvzhVyTfypIr0Tw2GKGjovDJC1zuHjImgukJXpmg23I8gP+v6KWZzBpscTxnfIMSphxuhxBpXk7y0gMTWZ3W0ydwIKZ3EszJblrzOqx8wn2CH4qKqK+EY9idQV9LOI+IgnHb/t2jFqTY+qwRl/YMOmo4opEeRUHe0L0mK+nTNey0lfbHXcwiOLzSe3+gE52Whk46D9fGMWyeLZwXsFn8wadou2n3FAUXOxTwMcmb50d5ILLQ6r67ZmWPUmw6NWsJiN6kIu23MUmczyVivp4FiQk6QTuY4LOwQZTCdwzuvUtHfPFmHNqGYlfBtpHkoT9IP1pYxTqDEbANt4gUARThOSdIgrqrGx7NAedSuV7R+/i4ZQRLP3gMMJs0fRjgnUKZlXi9b7ZOcjMyic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199015)(478600001)(6486002)(66946007)(66476007)(66556008)(8676002)(36756003)(4326008)(54906003)(316002)(41300700001)(110136005)(82960400001)(38100700002)(53546011)(6512007)(6506007)(6666004)(2616005)(186003)(26005)(86362001)(31696002)(2906002)(31686004)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZU5GQnhpUWJ6VHl2YkNOV05vd2FFbk4vUkhzbEVzRytRdVNPNkc2Z3p2bndr?=
 =?utf-8?B?TUVvNEZIRXJ6eHZvQ2g4NTlteXU5YXhwSlp3aEtRRzVqVlBGeWRCTW9BeUxN?=
 =?utf-8?B?cTA5eHpLZlJ5SlZVaU1GMmF2cG50Vi9PbDR3MUQ1M1ZST0RVb1BLOG1HQTl3?=
 =?utf-8?B?ODZWNTYxRmhxdHRuQ2VwdHV4R2FMYnVzRjhZbE1jMVMxb2NBaTBNbFZoT0Q5?=
 =?utf-8?B?T3lxNUFsam03RkxqVms1amt5cXRROURIaGZDWEo4clZ5ZmI0SmhsYzkyYjV3?=
 =?utf-8?B?QkdNWlkvZEF1VUFyckNHSjQ5UkhINDMvN3dPWFlMY3J5YjBycVRuTy9aMm9r?=
 =?utf-8?B?M2t5WTdONllLRnMwb3crQ0NyYldZdDdOSm1ZSWlTVXY2T0pSRHJxRC9zMjl2?=
 =?utf-8?B?MElUUWk0bjRIdnE3anlyaTRmRG1sUGNXSHR1ZnZMdzUraEhsT0Z4dGIrQTUx?=
 =?utf-8?B?Y1pNRU9nNmVUSXpWZjh1VnprV1poUlp6cDcrWEwvN0gvSWI2Y0x1c0EvYnJ6?=
 =?utf-8?B?Ynl6VGRmVlBJMnBLQ3ZaRzRiSXFQbHVNT090b0J2V3NxTi9EenRqbmhaRnRq?=
 =?utf-8?B?U2N1Z0VnQ1ErYU5vNWgxQXg4eklLL1VjNi9sanRFdVBOaEJmc0p4TzFmTTlJ?=
 =?utf-8?B?dVlhQS8rSFdya0RCc2RhaG14YzdzcHliS2xxQVdaUkhPMC9aQjJEWG5MU0tB?=
 =?utf-8?B?WWt1dmdyU1pRYVdZYzA5bkoxWDJ6YzNHekt0ODRFWjVDZnNhUVVsN3A1K3VK?=
 =?utf-8?B?UWVKVWlvSVE3U3d4U1MvSndkbE56b0Q4S1owMGhPZXdZUDdobFlyanRrNjk2?=
 =?utf-8?B?clhyNjNlR082bjdxaDJXYVYvcnBvaitiWlFhYWlKbWF2dTJLVXNlaW92R1V4?=
 =?utf-8?B?OUJJOUJRWVdmSEpKd0tUOXdHTWNLam9Yc0dxTGRkUzVCZU5jVUlIU0JHdGxv?=
 =?utf-8?B?Q2VVdHIzQlBqMGJkYVBvME9wQXZaT0hZSEM0NU1EaCtITTJTTVppVnRRNjBL?=
 =?utf-8?B?WUJhM05XL0NYSzlNOC9FUmg5S3RmK0o2NG1VbW5ZaU5DOHRybEd2OXh1UTFH?=
 =?utf-8?B?T2pyTjlyaXZiZFZOMStSdXc0emhDcTRmbEhwakJDcm9tcXhwWDFuQzM3MTVY?=
 =?utf-8?B?YVFYOHJnVFA3TDIyUGlsQUk5Q0pQTFhWVUljRlpWLzlmaVRCd3IvVUowMStS?=
 =?utf-8?B?UGY4cVI3OE1xKzBPQnRpNWJLMmlHSU9vcVNkUzcwNzNHWFVydFZ0UU1sUFNa?=
 =?utf-8?B?YStoZ2M4anBFRzJGRUxMRlIyUWhQUWVSd0E2WEZVa3FvbXlWSjdvdmVuSTRM?=
 =?utf-8?B?MUxWaTVrRjF1c2h4MnpKUWxNcVFoMnJkQkhoeU1oa3FHNmJleWVnWnJQQ2dY?=
 =?utf-8?B?ZHBQdXg2OFdhRUo4YUhheWNnNUhSSDdjOUxDTDBaY0ZnRXJZRlZNdU10QWRr?=
 =?utf-8?B?YUVnV29KRm9Sc3c0ZTVZL25jdTQ5VzRiVGV5SEZMOFFEb0F0eHBtcXdBdG14?=
 =?utf-8?B?cVlyb0FuZDFOTktYdWw3aHhRc01jNVB4WStSWFUxQ1V0U2k3WW5mV0V4YXds?=
 =?utf-8?B?T1dhZ3pobDhUZUFpT3VlODFWcW02SmdXSDVReTNoeDJ3YW5KR2tzR2IxN0x1?=
 =?utf-8?B?MGRYSFlDMDFXcVorbXBJcldXOUNGSkQrNXE4ZjZ5L3dHK0pIRC84Y0tvV2dH?=
 =?utf-8?B?RzJiSlMyVWZjV1dDNUFiVUR5bXRyTVJJL2RDaXpMdlpnc2toSmt6dFZFNngx?=
 =?utf-8?B?ZVEyaEQvbWt1RVNWU3ZxUFdOOTl3SkxJejQwcFU0aDI0ZlRjZjU0TlpGOXlD?=
 =?utf-8?B?czAvd24wKzN6MjNYU1RIa2V0SkxGak40ZWtHcGlKQjZMQVZmc3RoNC9pQnVs?=
 =?utf-8?B?c3hlcHpvaVgwcWYzWHlmUnhTdXlUT3RVMlNxRjlUZ2NYcUtXSGJqZWZMUlk5?=
 =?utf-8?B?LzNsa3QveG9pRkpzNHQ5T051cUZlWEZza2cwV0xGdlZlblJqbmN6SmlTNC9N?=
 =?utf-8?B?QkVSd2g3Qm1DUy81MnBySU9TOXpBV2dhZ0NyZkhDOFhEanU3d1I2cUYrdU9P?=
 =?utf-8?B?TmZuMzgvVDBaZnNzR2JyV2NHMktJU1NsVTNndTZsdElPd1hRV3JGQnlRRlRW?=
 =?utf-8?Q?/Hm9YfXZHkm0uIehGtQflc6nA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: edeb602b-5133-4bb9-17a9-08dad1213d50
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:16:32.2256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zbJxuhHTTDEjbsU2kM4/tnx9nPhzpEsNICTVxYll9Zkvs+r9kAkmVmVGeUML7PA79guWHZ6K2O4JB9jN+bplnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6169
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/28 16:08, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, November 24, 2022 8:27 PM
>>
>> This avoids referencing device->group in __vfio_register_dev()
> 
> this is not true. There is still reference to device->group when adding
> the device to the group->device_list.
> 
> this remark will become true if you put it after patch04.

oh yes. :-)

>> +static int vfio_device_set_group(struct vfio_device *device,
>> +				 enum vfio_group_type type)
>>   {
>> -	int ret;
>> +	struct vfio_group *group;
>> +
>> +	if (type == VFIO_IOMMU)
>> +		group = vfio_group_find_or_alloc(device->dev);
>> +	else
>> +		group = vfio_noiommu_group_alloc(device->dev, type);
> 
> Do we need a WARN_ON(type == VFIO_NO_IOMMU)?

do you mean a heads-up to user? if so, there is already a warn in
vfio_group_find_or_alloc() and vfio_group_ioctl_get_device_fd()


>> @@ -638,6 +651,7 @@ void vfio_unregister_group_dev(struct vfio_device
>> *device)
>>   	/* Balances device_add in register path */
>>   	device_del(&device->device);
>>
>> +	/* Balances vfio_device_set_group in register path */
> 
> "vfio_device_set_group()"

got it.

>>   	vfio_device_remove_group(device);
>>   }
>>   EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>> --
>> 2.34.1
> 

-- 
Regards,
Yi Liu
