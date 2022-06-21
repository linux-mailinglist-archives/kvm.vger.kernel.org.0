Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D155529C6
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 05:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343494AbiFUDfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 23:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239623AbiFUDft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 23:35:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA08313EBC
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 20:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655782548; x=1687318548;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0BuvOAD4FruT9AAmRV4QalVS41NWbJqAXQyllt+yfks=;
  b=IhAAzhBjbktRBMNp0IIfPQ4hq+cByHgMgoIr9cKKX9W4i6G+wuiWPj4e
   2fH5tiSje9eSYsZ1HodNa9VyBTBVOpipmUk5ef1AJE3ctsREFcN9vMsa1
   Yiyhk9tN/UveeU2vf3ZDQb+aCBO5/pePmmAHEOy59lEpUECR6+iPAZuiG
   c4rXXyqyTE0YXgoL4zJqSdIjVqCmC95HPb4qf2ipzqwy2Fj8dhKMnUoyO
   Z3W7ra39tMrW3+IQbG46REHeIvi6Z/NtyW7qmvTNB+IjhX4OtQsMjnlep
   0cvQ0EWi1jn//WRldlJXSq1w/JZaonEMW0N4xYxsDgvcvHp5vpKvdc1HV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="366341256"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="366341256"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 20:35:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="614592594"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 20 Jun 2022 20:35:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 20:35:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 20:35:48 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 20:35:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cx0bOLM3TuInmbX12x3DWu09fHALQm/GWL7SQT6JLuUSEX3nDLBABlN1rufGwpgwajrEUP+Xl6i+THO7uj+1GLtE/bmM0bYo3QUFyPp0jopuLlEZpbiK4lcmcXzZO04qeRsZQ/X/x7s6btY6hHKLqmXvoCbJOQ8PbMYomWv1E+itoItPOWtu9oqPwI1Cfohc9BEZXem6c0UoohB96Yk9QEeKkjtb98mpJLBEG9TTn7PSD5MT8KaC6hdNSEVONcxdJZrlhJzXVS1sX+CYHgMdnGqHoNrvSi4CCD8LWq3g/sVAWlYt4F31aBLPCLGau7E3+nIXWQA0HT5+VlrVjQAJ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxYItbjqXlvg9Ec2q4tM8w/Wnqv37XMJFwUuz6TJ1Fk=;
 b=FnuSpoW6zSJqtpP6TEBWQCbZMBq2Xp6GiMTtSxDk0F/hNGRjyEM0/KS3+W7ZcEFKDyjF9BAPcssqM2RRkm2Fhz91xNjDh/maKfFx3zBeWnRgFwNQBv2AzN87AtQBXga68Xwq2+u7WbPwOEqMC83vpcfpcAp7PacDsgCg8vJXLjtD1yf2utP2v16YdfoGvlHqvs3UKhTKhe2AfmoLO6WcwSV3bOmNVKGMhtVfEsyxocsLXaJTIg0Iw1TH4xz0QhzXVesVYf7C9KooDV8KrPxwe3jUBA67IvRKviZsCTEsOdHEzZWhecWCZdb3u6rkSH6Eyds14g7bfcI2SQT7xFCwwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by SJ0PR11MB4831.namprd11.prod.outlook.com (2603:10b6:a03:2d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Tue, 21 Jun
 2022 03:35:41 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::10cf:116a:e4c:f0f5]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::10cf:116a:e4c:f0f5%7]) with mapi id 15.20.5353.021; Tue, 21 Jun 2022
 03:35:41 +0000
Message-ID: <4569fe37-f72f-631d-9cfb-7451810c65b0@intel.com>
Date:   Tue, 21 Jun 2022 11:35:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
References: <20220620085459.200015-1-yi.l.liu@intel.com>
 <20220620085459.200015-2-yi.l.liu@intel.com>
 <98a0b35a-ff5d-419b-1eba-af6c565de244@linux.ibm.com>
 <39235b19-53e3-315a-b651-c4de4a31c508@intel.com>
 <BN9PR11MB52767FD0F8287BE29E0C660D8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <e0ee6ed6-51ee-8a6b-5bc6-307b0df503e7@intel.com>
 <BN9PR11MB5276887FCA896E53829300F38CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276887FCA896E53829300F38CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0202.namprd13.prod.outlook.com
 (2603:10b6:208:2be::27) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e11101a5-953c-4af2-d229-08da53371d98
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4831:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR11MB48317E10546E7194F2902E61C3B39@SJ0PR11MB4831.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9b0CizTwn7QatK+A20LiSqiCircGaq5hT93o0deVvQryG9D3Ivza5JFbC9H/tbMkg716WE5J3gmJIYo0lA2eCs69SxczMHNj073hL9YD71zZkELdG6lYgOqi+hhvv1OwLW8zOFzdckoKdEoLnFgdXBipQVFrS2Tmz7pRMYzZrqcvWt/MbcrZbJNx8+g6r6GgYXhi9Et6DqgzRdpWq3ecoE+USPyHgDDMdIrvWNy+HSD8+Md7+GkcxgeKC05rzRqjiDVi2GZswC3UqEJPPT7n3K3lLD8IDp/Uw8dNDxw6FU0tCWiA2VPU0zwSnghrRAR4CGWkVBJJW35B50Q4R8EEnJzbn0VsCkn+PZRkiTvzFHtY5wUt34aUH4CJH6yogc8CgAhb2rQL84UxLEdQBkR9iQzoGLtwaJLy42FMdCQ6w3Y/fHJIKouDxI2ORkVqExYrvYqhEORi64dKXL3XvHnGfAgtQv83EAuW5ZheNirfrDPSTi03idgf0F6E2rCs80PnTBZgGDuPNBNH0dbu1W1h6O+OResd4XmVHckbVuY0GfbiCERG2KRwniZ4NbBq7VSsO/M0P23oOTmEB/tU9gGosGc9+MUCb8VXn3LHRV5ehn9HYsNTY+KTe0me9g3Ebtb15LZ/L5IMUtUsrYsnK9HGAOA4dKNV4Q58fytHJaAouuEEm99vVtp6QPBs7RUrUa11WwUT196ADeVtKJ8LvEdrw+08bObtbK3vQG40L05iUl6UeT1ilZtETZA6p270jxW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(346002)(39860400002)(396003)(376002)(4326008)(2616005)(8936002)(86362001)(66946007)(478600001)(26005)(66556008)(186003)(6506007)(6486002)(110136005)(53546011)(31696002)(316002)(8676002)(66476007)(6666004)(54906003)(41300700001)(36756003)(38100700002)(6512007)(83380400001)(82960400001)(31686004)(5660300002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cU5VYVd2dGFBNHIwM0p2WTVJOEhRV0dBMUhra245M3ZqbHQxdDRFcU9iQjFW?=
 =?utf-8?B?YjNCZ0EzVGdkWnFCYWp5cTM1cHVxNDNTaEZ4ek12TDA0SXp2QUpBNUxxRnZ3?=
 =?utf-8?B?Q1VDY1BYYTdUQ2pPazNiLzF1T21tTGt5MUdrcFlQVFNaOHFrazRYTU8zRGpD?=
 =?utf-8?B?RllRaXdTdnJuWEVHTk52QmpwblUwQXRpT3Nxc0N5OTlMQmI3TklxMFdTOWJn?=
 =?utf-8?B?a09DVndWMnEzejhRSy8zdFovL2IwUGt4YmpMbW54a1ZYNGsvODRnS3dhVERu?=
 =?utf-8?B?dHkrcDNiS0lVVFhGNFluUVpoT0hPLzRyVXRsRGFHa2FVdnR3OVE4RDdWR05M?=
 =?utf-8?B?YzVRMVVUR0JYWGROWjR5RW9ldERMdjRwQngyRXRlVm5RMFJsSXM4N0RYTDF0?=
 =?utf-8?B?TVJYODBUcGdmMUhHNG14NFBOaVdHeWtoUmk3MFY5Sm5WTWozeFRxcjl4Vm1q?=
 =?utf-8?B?cmt4Sk5tMjdQWDMvSWVGaUZRdGpTRkZWb3B6NXVPc0lNdVdPaGNVK3kvNitv?=
 =?utf-8?B?S0Zpck9WZEl4UGp0RSs0T1YyOCtQSWFLNGtFQkhkSjAxMzdZWGZaOUI5dFF6?=
 =?utf-8?B?RWVubk9yaXkvSy9YR2ZRUXM4d3hOWE1FQ2VLNURzV2YybWhCYklOOE9KSW5T?=
 =?utf-8?B?YjNTLy9zWGVMdXp6bXoyU2RNTEpsbDhzRGp1dmYrczRMTk1qQ3RZSGt3RFdC?=
 =?utf-8?B?SGNnK2dLdkliR1dLb2lmWnlZRDd6eklBM2xYVllYZkxSeVhMWEtqaFI2RVlt?=
 =?utf-8?B?K1ZNQ29iRGF4UDlCY0U3MlgwVDB1MHFTRkFHSkhUVFQvWlhpRU1MbmI5a0tv?=
 =?utf-8?B?bkJKcGxia00ycFN1eU5CS1NlWTN4M0ZMTlFKZStqUzdjMTVKRS8xa0F1WGVj?=
 =?utf-8?B?d0JGVW1FVGkyNmU4NEtmQnlZa1luUVd2VVZ6OUQrVkV3ZURpaDd1bUNBaXdW?=
 =?utf-8?B?amIwUE5URWhGTjJTN3Era1JTZ3lpYitsc2lXa2hQZER6OG1rckJzbmN2bU5K?=
 =?utf-8?B?ZklPOHdmYkJkOXZ5UTQrTmIwWGNqUkgxUFg3eFJacDVTSmJOenZtNEhhOXdL?=
 =?utf-8?B?QU9zcmdvTVdzL252ZWJCQ3BVQ0lXS2NaTUdmbmdQWEpzTDR5WEJadk9KK3hz?=
 =?utf-8?B?cEgyUlF1cWVkQnZMUVJva0xUdkUzUUErcTlqUHNKdEZyNUlxcUVvOEdrZGNx?=
 =?utf-8?B?d1F1aG5FZVRKTGNRQTJtamtIUHlnWm9adnhrYWg3UitKMlg5V01hc0ZSaS9X?=
 =?utf-8?B?NmxKRktvaDd2ZVJWNmhSbTVPYlJiWk8yRlVqc0gxOXl2SEZKL0w1UVpIQzdN?=
 =?utf-8?B?R0RpS0F1aVk4RHU3UDV6bzEzZnpiMFFqNFJHdmk2Z20zT3V4aHJNYTc3Ni91?=
 =?utf-8?B?bTRBbGFUaDFhR1l4Z0R5dDRtbThZUDh6QlpSYUc5Uys2TnlCbDJUN0M5S08z?=
 =?utf-8?B?OE83WFNGOEZEamhIQ3BqaFZkbXNoOURzSjVPNDlxeTRITVptMEFaMTRNd0Jh?=
 =?utf-8?B?ZlhHbGZnM3FzbGFSc0k5T2kxLzF3VTdGMnMweVFlTzl6S21RZWladFRNTGgr?=
 =?utf-8?B?anE3Q0t2WERlZzNRdWpDU0o0aEtSeXo4S0lSZFlIRWpoSzlHRTFJdXZ0bFlF?=
 =?utf-8?B?Y3o1SlRvRy84RlBiaXdWTGlocldIWlliSDFOV0dSN1AwZjlRQStRTFRBcmJW?=
 =?utf-8?B?MldKeHBQTkxCWUhQNkRib1NNZ2U3aWQvbjMrZ00yMGk4bGQrVjJITFA0MnVE?=
 =?utf-8?B?ckJ1L3lqb0RvUitmbWJ3eXFZR1NENU12NEcrZVdzb3FQUG4rT0ZsVXJaSW1Q?=
 =?utf-8?B?R0JTQWdOL0FMUXlqM2llcURBS3FrdHhUNDh1ckhwOSt5K1JybnhnRlRqY21t?=
 =?utf-8?B?MUtaYjdYVWE0U1ArLzgyZWh2QURVM0wrdDQvMEhFRE0vbHE2V2pQYlpCaUx2?=
 =?utf-8?B?eFkveE9abTIxZ1JHUFBUajcyb2Vzc0kyVkY1NVJlQ2JLeDFPRHNhdVFlaTVw?=
 =?utf-8?B?akRGa3FYMld2YVlJLzdYNDlUUk15ekRRekZxVEMreGhxclhqUmdtblJDbnd5?=
 =?utf-8?B?akRqYTBPZVphRXB2K1VWV1JjQ3RROTZqbGw1UE5ObG9CdVFFZVROZktwaEk0?=
 =?utf-8?B?SkVLMFVsUnNRc3BXTFNaUG9FWHpBNFNleDdwSmVRY2hsN1J1Kythclc1SE5Q?=
 =?utf-8?B?MS83TW5CZllKWlU2S3F2a1M2OWg2WFZXK1orK3VQT3FRQWVrVlB3cTBuYWNj?=
 =?utf-8?B?b2VLdjMrcFJqcktLVlZMQk1tUjI4UFJrd3BpSnlsV3ZSdzlPSnEwdzdtWE8x?=
 =?utf-8?B?L3E0cThjcVpvSytmWm1MWGQrNjk4eUdWRStaUm9UTE16ZEM5cDVWTVpWNTFI?=
 =?utf-8?Q?J1PxA4WF/MO6L9bE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e11101a5-953c-4af2-d229-08da53371d98
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 03:35:41.2938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YI6+Nrs/Ff44x2qdVZrUIGv/tVfdaknHdtP+SA7vugMoHm7+HUDod2T00EKitabtNzR1G8lLm5x203iPX2zh2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4831
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/21 11:26, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Tuesday, June 21, 2022 10:59 AM
>>>>
>>>>> FWIW, this change now also drops group_rswem before setting device-
>>>>> kvm =
>>>>> NULL, but that's also OK (again, just like vfio_device_fops_release) --
>>>>> While the setting of device->kvm before open_device is technically done
>>>>> while holding the group_rwsem, this is done to protect the group kvm
>>>> value
>>>>> we are copying from, and we should not be relying on that to protect the
>>>>> contents of device->kvm; instead we assume this value will not change
>> until
>>>>> after the device is closed and while under the dev_set->lock.
>>>>
>>>> yes. set device->kvm to be NULL has no need to hold group_rwsem. BTW.
>> I
>>>> also doubt whether the device->ops->open_device(device) and
>>>> device->ops->close_device(device) should be protected by group_rwsem
>> or
>>>> not. seems not, right? group_rwsem protects the fields under vfio_group.
>>>> For the open_device/close_device() device->dev_set->lock is enough.
>> Maybe
>>>> another nit fix.
>>>>
>>>
>>> group->rwsem is to protect device->group->kvm from being changed
>>> by vfio_file_set_kvm() before it is copied to device->kvm.
>>
>> yes. this is why vfio_device_open() holds the read lock of group_rwsem
>> around the device->group->kvm copy. However, for the open_device(),
>> callback, I don't think it is necessary to be protected by the group_rwsem
>> lock.
>>
> 
> The kvm object could be freed after device->kvm is set, if
> group_rwsem is not held when calling open_device(). Then you'll
> hit another use-after-free bug when mdev driver tries to obtain
> a reference on kvm.

aha. I see. so group_rwsem prevents the kvm object free as such a thread
should be blocked in the vfio_file_set_kvm() if the vfio_device_open() has
held the group_rwsem. Hence kvm object is safe to be used. thanks!

-- 
Regards,
Yi Liu
