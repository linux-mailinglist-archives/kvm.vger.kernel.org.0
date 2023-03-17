Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F09C6BF4FF
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 23:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCQWVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 18:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCQWVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 18:21:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D276E64217;
        Fri, 17 Mar 2023 15:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679091678; x=1710627678;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iJQIRN54JhJ2oZQ8ou0myNp/rIOlCJCfZI0OE6Rl9Vg=;
  b=ReD0531uk0n2NrTdClnQ0mPMLon1kaSeRvvO96mHP/cnSoNjLbdjbs7A
   HKSZLXEIDDOKi35Kx4ms//v1yF0t/IMZKcKpkLgTABa0twC/NiCafmE8Z
   HRAZ6lLkeOLsUXLQvR5CpWvuuTygbK+n/uJuj1+NJhAEFxDGqb5FOW25G
   GgUlxxJzQbwom4mz3OR/p17oSMV0Yg2XxzrAvkAFst7zowu9pUZH/nN0a
   B7WIvHUFPx6c5ZBQaa9O0LXJMINHJlv/MrC+QU/c3rn7hX+n+lzyPSDdt
   KqSaZJJgZINE04ygxqKxKAvHThETZJnViLvuL48yOng27PmOI5y02SzLF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="424648232"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="424648232"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 15:21:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="673705502"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="673705502"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2023 15:21:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 15:21:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 15:21:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 15:21:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUuLECbGwuW8Hpu+Moa8JK17h5tYphxXjX1IzawFPVTFy2PT7uGFqqAlpBCoqqTuR+wkhCVGBXiL7HzmsRExHxxei1X4l4ZnI+Us09x8Vp1vV2QialE3qyaLebnC4BoREpBY1woG2IF/O/01TMRg82XHtNozGI14f3C9BcmzMmjHcpuLAfeaUQYiBOGosg8ayJYqOR6urIO0J/dPP0pp51ngsPRxIPmIZMyNQejkhM3sR7tQi/3dP1So7/8BODKeNL8+wkAz/qPtPnmmm4dVQBJIfJ35B25HuCVFomkjd4bU3Cp4rBnx0W7yxre9Bu7Cnoy0/pz7NQfkr/jRyQ4mZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mABzLprrTarZAhUL9txPjHnT53/3bzEPGRu8QLzzG84=;
 b=gBT6R/pMME12dQGDjB5OcBU0KcslP3ARNrsRcWiG5hkYY7s19w3kF9cwgJzCTBbbEge+3e2+7QwlG4ohOx44FgRy2hYor34TShp68Jic0qpH+tefmHEX9aCcNmNp54f4r9qmmpsftYMS18D44QOqHPhUNtWdh6rKDBMbHSOvcWJdoIvmLBb+5mQsp7+FLNiwuO0sePLWWgjmEGpWs/D6Kve7bqHWdxEOvavt1E6P5DzuRnyRitO7xHFgjoENYO44PvXBD+SDEEtzyewxwwpw2Mb+DOqV5Dk4ymOljfa8wORHaxfg19o2TKSTdSryKVDBZR0m3qdUQFXDzQ5wUw6wFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by BL1PR11MB5336.namprd11.prod.outlook.com (2603:10b6:208:316::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 22:21:13 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6178.035; Fri, 17 Mar
 2023 22:21:12 +0000
Message-ID: <61296e93-6268-05cd-e876-680e07645a16@intel.com>
Date:   Fri, 17 Mar 2023 15:21:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 8/8] vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1678911529.git.reinette.chatre@intel.com>
 <549e6300c0ea011cdce9a2712d49de4efd3a06b7.1678911529.git.reinette.chatre@intel.com>
 <20230317150554.6bf92337.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230317150554.6bf92337.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::34) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|BL1PR11MB5336:EE_
X-MS-Office365-Filtering-Correlation-Id: 195a1488-7283-42af-3fa3-08db2735ea70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JmdV/KjQJP8rYqKwlopsmg4ngmlScy0gScIG4TFvezfEUDRk6RSTk0pVK18eW0Ic+PPCGW7xDyEp2BS19P++1iJIw1fkWMoeA+aNk1ozN93l/zsVhW3ZXMuXpW8TO5I5XTDPyghE/k6ZTD8gU5ZZu5Ak3SOgf4j+V1/rMOBc+C167SboO0gfyqNp2AhudJ9V9ANzIAnD8S0pWh3hgkr5+faDK+xtTqsq7QUpMtiMsKJngroKKFgn3AmmXTxzcaRwZY0jHoCS+4/2TCLDFIJC8v++H+M5PFVQ1tWtAwBDX2/7p9Ff/qwUHnQXd6ZsyhlnmibEIUEk8piQxN3mXgHaBtlTj2bCVRk/FqsbnJDolePVSoZPKmJOHbcHw3t1lnPvv5T5veiUdqrw5Et1paFJVGaogzrP8m6tHoO8pHNqYDSXCGXghA0QeNfrj+GLIlqqNeNkxHT3oGCtW9yq1XgHB4lUMtqpe7ff+NzoweLDxhnm29JeHnkREcyA62mDxo3bNyqaln6E3t9Fu1fdj5OFLXvHk9dz7FE9vsOVwivu1YzB1VVbD7rZl6wqFDp8qIU3140QAgiCxXKUewY18WkUFNTA4Lm5I9t1HuVIi1wR+yVHdD4Ljf1SuSBcT+vFFxvzx6x8UDglyeZAnNquB0rtKb+JFkyQX6TnByAwVoP7olF5pEKo9s8RaIaZwSnTfsLv2ADT4xJX7gXEWX2Rx0l+t+lpzdKAVWjO0NYZBHZWUcs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199018)(186003)(2616005)(6486002)(83380400001)(478600001)(6666004)(316002)(8676002)(66476007)(6506007)(31686004)(66946007)(6512007)(26005)(53546011)(6916009)(4326008)(41300700001)(66556008)(44832011)(5660300002)(8936002)(38100700002)(2906002)(82960400001)(36756003)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUdpQThxWkpVWmJoT21ya3JFbVJDVERRMUNrZExOdmk0UndtZ0REeGNkUFNF?=
 =?utf-8?B?SVpPUUhtUEQ5eWhyUnRyYU41RzlBOFNGNWwxelJZL01MVDdhSWVTN1RWTkd1?=
 =?utf-8?B?Z2E0cUhYdWlqQkpmeE9QWmtRQXBRWm1qekhEbGRhbEd6OGovZjRuMGFVWG9C?=
 =?utf-8?B?L2lZYW1QSUNqTktocC9VU0NFdUs2b1YwZVRMYjB6SGRwdldXditxWms5eXIz?=
 =?utf-8?B?U0JKQjY2WDBIR20wYVZhb2lVNlF2K2FmZG9ZckNjeExxdFNEa2ZVZmhvUDRD?=
 =?utf-8?B?VFczei9WaDlvQnpCYXJHc3JFUEtyZXlHcldTLzBGOTNSZUowYk95MTlaYzkx?=
 =?utf-8?B?ZXh5MExrUFdJR0dzYzRSZEVkZndFOWdvWnNpTnpFZVRnbXNTWWNkeFNWNmVy?=
 =?utf-8?B?MW84T3UzMlVsVEJ6T0JKbkNDbVJoZXFqc2g1YVhIOEFNRFFpY2pMRXRRYTl6?=
 =?utf-8?B?UTdxY2h4TW93RkY0NHVXOW94bXJWNUxRaXRKT0hKSUFGUTRZZDVrVEVVRWEr?=
 =?utf-8?B?MWRRWFlGbTU4YURzZWJKYmFBbllhaFpVbW5SZEF6V1Z3emFPc2Q5azZZV2NQ?=
 =?utf-8?B?VE5ZeStmU1BlVHBXT1VQVDhka0Z5bE5GOXFvSXZiTHF1Vks3dTBndWExUlNm?=
 =?utf-8?B?K28ySXVBRC9pZnhDbEhJV05QaUVCT2xDcmRUbGlnK0w5ekJrTXNQR0dsaWpO?=
 =?utf-8?B?VFFZZEVtNTM3ZldQdkM0OHNKUG0zcncybGxxYlRPa1hzazJpNGVpeFdrN05a?=
 =?utf-8?B?Y1J3WVpVT2dwaDk3R2h5UllOOVcyU1E4SnhYN21hd0NJMjZXbFRUY1VoZHRa?=
 =?utf-8?B?TXhhbk1oKzFwL1YxRFpJam96UWNMMFRJcEpUWEU3cVFsVWhMb2djVnAyMGNw?=
 =?utf-8?B?bTMzRDFlUndMd1MwYXJKREFINFdmOU9FVnovZlhKN095UVU3eVdiWDBHaUVK?=
 =?utf-8?B?YU14bXdrd2s4Q2R0elhDa3d0cDNPSGk4c0txcUZWNjBqWGM0SGpLT1o2OHh1?=
 =?utf-8?B?dWpoMnVVQjlnVDVxVytGdWQvWG82cm9Hd20vVFdUbHB4Q1IxbGlucXN0N0tF?=
 =?utf-8?B?MWszWGVZWlhURGZHRDNpaytlSUtDUVQvakt2M2RRNzNhTHJmcitITW0reFJt?=
 =?utf-8?B?cEtwUkNnNjNXWWgrbUEwcVZqRkdQbW5HeEVTUklZaUY1dlJMejBXek96MWFa?=
 =?utf-8?B?dzZHTFdxTkhGS1pSalN0VFp1ZitxeE5aOWtRb0ZXUHhmaEMzcExTYVI0ajVT?=
 =?utf-8?B?RE0yeU43bERPNmdia1k5YTZ5T3hYOWlualNueFJaZ0JxZXV3YlJOY1NySFhC?=
 =?utf-8?B?VVFmVmVFb1VTSFFrZ0paS0VvUE1oaXNOWDNYUC8rRlJpaDR2QUEyNDR1RE5q?=
 =?utf-8?B?NlRUbEwyOVlRTU8zNjVCdlVBVzNrdU5UNGpqcEhDVVFqeDNNcUd1aTYzWXF3?=
 =?utf-8?B?UmZLQ2cvbXRid0NmeDNqRXZ5UmRzd2Q4MFlFMHVrQW03RFRhdUpnRENUMXZ1?=
 =?utf-8?B?TC9KYm5VSUtMdjZUalpPT1ErOWE4ME1IL0dKREhwUFl6MVZvdzJiSS9SQk92?=
 =?utf-8?B?ZzdBZkRqZzAyNTNieXZDeDNINEkrVkkrT3VRWXdoWFQvQmxqdjJ4Q2Mxd25q?=
 =?utf-8?B?YVd0MUc5WHRVMXdZM3gxenpmVTBMa21FTm5yMlJYUHRMbUQ4NmJITGV3bzM1?=
 =?utf-8?B?c3hhTk9WZkRSRkI5ZkxJemVMYWR3bHRSQUpoVkN3YmxzUHJiSy9kNEE5b0lz?=
 =?utf-8?B?S1o0RWRER0oxd01VOVlTcVhGRlFtR3lzYm5tc3Nwd21pL050TFNiRVhSRjR1?=
 =?utf-8?B?ZmduRytCdS83WkdGWldEMGRIakowU0VCUUJzeUxqeTk1WDBkUkp6SDJ5bDZJ?=
 =?utf-8?B?L0p0ZFVnVGs5Rm5rOEE3YVRBdTFQRjNGaDM5TkdFclNyRjZxY1BNd0JzM3Ax?=
 =?utf-8?B?di84MXpIWDRLMGk2cGY3YXFsWVhiWDVsY3UyNHJDcUF6RnNVWWlLdHZ2TW5s?=
 =?utf-8?B?ajNSd21vajFqVVJwQ0srN08rcnpHZkJHWGhIK253ME9Mc1pDMFNyTHNMOFoy?=
 =?utf-8?B?UmRoN0pNOFhndVZWQWhoeisxb3g3RnMwSElmZ1BTSHpxYlNQdkNhNUg3dTdB?=
 =?utf-8?B?bHp2ejhzOXVOSW9ldVhrTlA5dDh0TGVsZlNka1Vyc0xPSG0rN1VsbHFzZEtm?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 195a1488-7283-42af-3fa3-08db2735ea70
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 22:21:12.5844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LFpjYgciJ86/HJ4RfvRB1XRLVrJtH9wGX3ffqojNk0x0mjIBeVZLVVf9fw5QZqNN3+hq1j5jKLLaYeuLnU3TF+BJ2oAAZ7UZGPyUGIlW88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5336
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 3/17/2023 2:05 PM, Alex Williamson wrote:
> On Wed, 15 Mar 2023 13:59:28 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 
>> Dynamic MSI-X is supported. Clear VFIO_IRQ_INFO_NORESIZE
>> to provide guidance to user space.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c | 2 +-
>>  include/uapi/linux/vfio.h        | 3 +++
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index ae0e161c7fc9..1d071ee212a7 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1111,7 +1111,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>>  	if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
>>  		info.flags |=
>>  			(VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
>> -	else
>> +	else if (info.index != VFIO_PCI_MSIX_IRQ_INDEX)
>>  		info.flags |= VFIO_IRQ_INFO_NORESIZE;
>>  
> 
> I think we need to check pci_msix_can_alloc_dyn(), right?  Thanks,

Can pci_msix_can_alloc_dyn() ever return false?

I cannot see how pci_msix_can_alloc_dyn() can return false when
considering the VFIO PCI MSI-X flow:

vfio_msi_enable(..., ..., msix == true) 
  pci_alloc_irq_vectors(..., ..., ..., flag == PCI_IRQ_MSIX) 
    pci_alloc_irq_vectors_affinity() 
      __pci_enable_msix_range() 
        pci_setup_msix_device_domain() 
          pci_create_device_domain(..., &pci_msix_template, ...)

The template used above, pci_msix_template, has MSI_FLAG_PCI_MSIX_ALLOC_DYN
hardcoded. This is the flag that pci_msix_can_alloc_dyn() tests for.

If indeed pci_msix_can_alloc_dyn() can return false in the VFIO PCI MSI-X
usage then this series needs to be reworked to continue supporting
existing allocation mechanism as well as dynamic MSI-X allocation. Which
allocation mechanism to use would be depend on pci_msix_can_alloc_dyn().

Alternatively, if you agree that VFIO PCI MSI-X can expect
pci_msix_can_alloc_dyn() to always return true then I should perhaps
add a test in vfio_msi_enable() that confirms this is the case. This would
cause vfio_msi_enable() to fail if dynamic MSI-X is not possible, perhaps even
complain loudly with a WARN.

Reinette
