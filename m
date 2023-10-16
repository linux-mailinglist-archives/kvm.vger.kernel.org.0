Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB5A7CB196
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 19:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbjJPRtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 13:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbjJPRtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 13:49:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B26A7;
        Mon, 16 Oct 2023 10:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697478550; x=1729014550;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mS65GUob0l/E7j8n0Xe5WtoDrOtCgzQmgg5Llv50NtM=;
  b=GrjoGjbreFZkFbTiMmbWAHfCqCNJAUtf8CKfobKhBa9td+cw3vdLwl6Q
   8UV20Vy9ZgZJ/KH19IQXtr1WZehuMqfFyCi69gV5HXLId2qS4Oug+9UAk
   FFliMJBfgr08sfo7S1Ad0Jbm0oYVKxpHvLSC2SrMZK1/KaJx5X2cCcqBx
   Spr9WIRoB8TGj0dYqvf8y5uhK9DuR/QgHAQ+vVNQWK4SjG26DJFecbaQu
   d0qgkqS7o5s2899zXUKPO0xPSUhyz50clOPcxAZj6EvS/Fh3VTZ/yU67M
   9x2hlpGjO9DiknXyA6M6DC/Bl60s+YFCsaodJ8zPdMrtS2mzIsNVlth2J
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="416668883"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="416668883"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 10:49:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="3594300"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Oct 2023 10:47:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 16 Oct 2023 10:49:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 16 Oct 2023 10:49:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 16 Oct 2023 10:49:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LujXrAvyNvAaGfClVkmVlTf5i/C+LHV3QfhADmUaqWA+3uCWcY41olb43CuUFdhohMm3urPijuM2N4vXY6hB0qesbfK4LMH59rR2W6nxa6aYly7DDFBGxw2+bQqDvEdAki1CLryMzGWwjRKldUuT9ZdhDYqMpr9ILpepfMHSnEont5JbduSgOOfNLtJaccdEUymKlqNAMHg3YtWIKV8VhcCJfxw5G8oGa6KaIvdh4tOLs+7DCtlZvMzUd5iLXIMK7v9Sk4Bfaym4+VqntC0+QTYW5APqsGpIkj5dyv7l1pDo/+zRyzO6dRCApef7n7fA5bdlieV/MVwgNwlfaa8RCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Btg55fipP+62GB3GUf1g4pi/6RAPzRkuqzDmCtMZFsY=;
 b=julMevqkt/D6N5YhrLeb+fBGhYwlHaNew0wowrO3+8rcTgWG0NWQVqgK8VItFqypbogquc1MsvJy2C2RWNcdXW4Q+inwuSZ2JxoSe9oyXBGY57bxwW9+V3keKqrIgcmaOB7c6+BDotuD9F6ytnOVzU1fbfiFKhNmJfzPjyNxTMkpvMsEwrbG8MnpGVqxqC8gu6O5LCeHwQOv4vQaxb+VoLozFsN1rHIhRAO75rHss5PPtmR8LsDOYex0skqdGCl48dT1OL1ABcPxLvmrI4BY7OTWZ74UX7j9PeBvh+jQ8pfsmRaWzq1ZJmLoYrb2DnP9ZOC3ETytp4m/MWX5v+tiMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB5921.namprd11.prod.outlook.com (2603:10b6:806:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 17:49:01 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bd70:f215:4a97:c84e]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bd70:f215:4a97:c84e%6]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 17:49:00 +0000
Message-ID: <4cc6e8ce-7e51-46c9-8587-0d37f0f39dfa@intel.com>
Date:   Mon, 16 Oct 2023 10:48:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH V2 14/18] vfio/pci: Add core IMS support
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <cover.1696609476.git.reinette.chatre@intel.com>
 <0f8fb7122814c5c5083799e935d5bd3d27d38aef.1696609476.git.reinette.chatre@intel.com>
 <BN9PR11MB5276891129DCF849D9E6375D8CD2A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB5276891129DCF849D9E6375D8CD2A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0372.namprd04.prod.outlook.com
 (2603:10b6:303:81::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b93cd70-ca5d-4fad-8405-08dbce702dcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JzhV9QDEMfqA0QqRZr81SWZq56Th3FFFYYqc1pkfHs06SLKU5r++5HU9h5+IsJnN7VjpzOH9Jgu7zNTynm7LMHVk4KJnV3leZyVtMcwl8ay8hUBit0OzuFYUqxy5SJti61+Pf9yvg2ihjBcDZHxYUGtP8Ku/u7EyG7iiU3s7ShiFnbHlFviX8H1wAHYQXUbzl4Qvyr95TF88iUAoSh+I67xO3F6ApqueozRvwMdaidPEyKie3jNF88xzv8wsolJo6T42mTiAT+SDteBuVp5ng8+mEZnV6HHi3zu68cNaxmvL5TTVyI4qdEynVEork+Jr6YaD/bYk2EfIRrF9ddTvn5lsvBIv9yhRxH474n8Np2GpAnDfo40q/Vs0A+uZkxIl//ND2wHoD8sH55HLHW8qzBH3kv1DjhIL/TfjqAahPPYukM34NoFfqLWph3XTOMFYhG7GfkaNK3aCZPfRrViDBgea/v71ZN0H2QWxYY5/gIVD4smQUGSh6DNPiVL1AWiI19FRP4GqJd8oFzBfusrqU3FAL97tLRDm1irHlzEkZW6m8tcbhQW717oSdSU6DyZ1MieVrFwhMh91agOn0znfFCknVlI0UeG0EIeG4vUx7gYaB5OJZcSeAHj2fFq3f27WiBeSEIsL9c+t5G+BN/Mbfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(376002)(136003)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(41300700001)(6486002)(110136005)(478600001)(54906003)(66476007)(66556008)(66946007)(6666004)(6506007)(26005)(53546011)(316002)(6512007)(2616005)(8936002)(4326008)(8676002)(2906002)(5660300002)(36756003)(44832011)(31696002)(83380400001)(38100700002)(86362001)(82960400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlBQQnNUY3N5czZjWVpiZFZVS2dkT3BMd3piUHNtaVJmTzNUalhhRWlOdEFR?=
 =?utf-8?B?RFhYRDk0UGUyTVNzZHVDbzZhRTU2UXhNMjRqcEl1TUw0elR3NjlEQ3I2eEhI?=
 =?utf-8?B?YWVsK3ZEd0crSi9IOVZKTHFYZ1dUNENPVlBNNi92K1NwNlF5TTZrcUpmakVK?=
 =?utf-8?B?YkFLZnR0UzczaFlvY0laLzRBV1VlM2FCV2c3K0g0eE5NbjJHclJoWDNvamds?=
 =?utf-8?B?ZjYvOEJ1bzZUaUQ4cEtTc2I1RzUzQXFiSXByTWMxSm8xUVMyaDZXblU2dElV?=
 =?utf-8?B?b0JVY28yWUMyQU4wVHNLallMbFV6K2dKZ2p6RFJqOTlaWUpWR1JmSDZaMVRK?=
 =?utf-8?B?WCtSakhUSUVqL1pTbEt5VVBYbk85dEJYMUd0bklPUCtLZkJMOTNORk9IVUVk?=
 =?utf-8?B?aUZSWDF1eXdGOXQ1R0NBNzAyUjhPbVdVcTA0YUZGVmU0OW4wZktCZlhHbFZ4?=
 =?utf-8?B?elk0bUtJNUc1SUFxakRNSjE1T1ZNUnRQaWQ3eUN6b2dTL1Zza1NLOGxWTGJR?=
 =?utf-8?B?NnUzcDZRV2UwUW1PdE01by9ldmo3ZWh6M1hta1lLdWJtS25IR01MUG41TXo2?=
 =?utf-8?B?UnNIUi9LNitKbGdVUzBsRHdkSGFIZEU4c0tUWFdzK2ZYT285SnFnazRwTTZK?=
 =?utf-8?B?aWN1WmQrVzcwMzAxV2xDR1JSalBkeE5XN0YwMUF6YzFodUZ2WUVTYlhFZ2hl?=
 =?utf-8?B?azdaaWkyc2xSUG1CS0E5cGZlQU5rdmRKK3hQSklZWElhVFErdnh6eXZ5aEsv?=
 =?utf-8?B?QVFaZkFybTkvTGxXVVAyWExjaHdxbDFmMmxHb3ZUQkFmQXltMDg1WVRjdEVp?=
 =?utf-8?B?SEdiUFdNTmwya1RSSVQ0UzdYSmprWWFLM25Velk4TnhHQjltcVR5a0h0cEQv?=
 =?utf-8?B?UkQ0QlV6RWFldjIzTUxEVDR4OWRtbWh5MVNib3lxMVJWYllzWEswTjZ0Z2s4?=
 =?utf-8?B?NXlKVEEzOHZFaVphVEp5dkRuekZXQTlWMFMvTEdmWGQrTFJ3NnI3UkxyclBo?=
 =?utf-8?B?eExJai9WSGNlUnRlNWlENTZzRjJ0RWJkeFZwTFRNWXZtUEtEU3JoSlVRbFcw?=
 =?utf-8?B?emJDZ2xxMG1uamwxTVNrZkFEYzRlWVNWZmtxOUZqZC82TkxsT3Y5RUl1VitP?=
 =?utf-8?B?TnEyU3hvbDN3d2N2QTdwL0NYa0h5Y2VBbDZ0Sk5IWm96RjNXaE5ROVVwNHls?=
 =?utf-8?B?UG5BazRiN1d6bXROVVphTFM4aG9RZ2F5UWp0Uk0reTAwOUhWWlNyZ3ZNRkdH?=
 =?utf-8?B?M0JDalpPWWxrb1U3T2tpRE90dW9hcVdycUMzUG5NUEkzZHFSbTRYVGhHNWhY?=
 =?utf-8?B?ZUdDSFBTMGl5ZVlaN2NBZjZXdmFaay83ZEdIZnRnNEJSY21aclpBWmVKK1Jh?=
 =?utf-8?B?YXdyVG5rcHAzQUJsSmc2eU02bVB1a2JaQU1pdWVCdVMzQkR6S2JPVzFHM2FH?=
 =?utf-8?B?MG1TVDcyUkJNeXBValNJQnZMdzl1YVhnVTE5RWlEVmM5YzRpOHlKUFZlN0U1?=
 =?utf-8?B?ZWZXVS9WYUluNXlVQWpLUFlYOWpya0szOVFxdkNOMjRsMVpCV2cwRnU1TVpW?=
 =?utf-8?B?enJxZ3BMejVpelhaakF2VDZQRmR2bDB2TENTa3RxWm0zTitvbXltS3FKNXBv?=
 =?utf-8?B?MHhYRlFXeFdUY2V5ZUpHVC9Qenc4aHd6dHhEWEF1Vkt1YU5VcTJoM3QyR3NG?=
 =?utf-8?B?NnRNaU9oZDJGVUdvK2cvczgva2JBeEdSekNRZSsxRTFMS2pjODBsVW9aQ1E1?=
 =?utf-8?B?WUZCN2xldmRZN2dQdzcwSGhFcC85aUdHdjZrYlpwTFAyTmxxWko1bGI4V2VK?=
 =?utf-8?B?NVN1clhzaUFMNlp3a3N3VGxwRGNvclNKOGlWNFpLRUpGWmpZejNZN25zbTd0?=
 =?utf-8?B?eU9iSG1odkU0YkkzRkRWTEgxSmNwK1g3cVRSZ0RPbEFVVy9oYmJkSUwveTJ6?=
 =?utf-8?B?NDU0S0JYUjZPbkFybnV4b1lSalI5eXpqMVJIRnJjZTZBN1hkcm5xb245R3ps?=
 =?utf-8?B?TkRRa0g0amF5bzdaOW50WFhyOVhDR3NoamV5ODRkOXlnY1NrcmRGRHkwa1I1?=
 =?utf-8?B?aGN5aDlIemoyM3NIZWxNRnJnWHljdGJPOWNDVytJTU5oMnV2Qy94cHZoRFRZ?=
 =?utf-8?B?TUY0dTZ0TE9oMDV1RmdXU2tOa21pR1RRdW9EbmNER0lNTzlQVld2T0ZDVlFM?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b93cd70-ca5d-4fad-8405-08dbce702dcf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 17:49:00.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3rtyIBPPN5pcjNjrl9i7L81m1JCTMLDyxbfetm3LfAzATDWYwInDEp55WFhvS6xfrqQZ8RaXk/2YatsgoYNXifVPtebwui/iKdC3RnKh9y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5921
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 10/13/2023 1:10 AM, Tian, Kevin wrote:
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Sent: Saturday, October 7, 2023 12:41 AM
>>
>> A virtual device driver starts by initializing the backend
>> using new vfio_pci_ims_init_intr_ctx(), cleanup using new
>> vfio_pci_ims_release_intr_ctx(). Once initialized the virtual
>> device driver can call vfio_pci_set_irqs_ioctl() to handle the
>> VFIO_DEVICE_SET_IRQS ioctl() after it has validated the parameters
>> to be appropriate for the particular device.
> 
> I wonder whether the code sharing can go deeper from
> vfio_pci_set_irqs_ioctl() all the way down to set_vector_signal()
> with proper abstraction. 

There is a foundational difference in the MSI and IMS interrupt
management that is handled by the separate set_vector_signal()
implementations.

For MSI interrupts the interrupts stay allocated but the individual
interrupt context is always freed and re-allocated.

For IMS the interrupts are always freed and re-allocated (to ensure that
any new cookie is taken into account) while the individual interrupt
context stays allocated (to not lose the cookie value associated
with the individual interrupt).

It may indeed be possible to accommodate this difference with further
abstraction. I will study the code more to explore how this
can be done.

> Then handle emulated interrupt in the
> common code instead of ims specific path. intel gvt also uses
> emulated interrupt, which could be converted to use this library
> too.

Thank you for pointing me to intel gvt. 

> There is some subtle difference between pci/ims backends
> regarding to how set_vector_signal() is coded in this series. But
> it is not intuitive to me whether such a difference is conceptual
> or simply from a coding preference.
> 
> Would you mind doing an exercise whether that is achievable?

I do not mind at all. Will do.

Thank you very much for taking a look and sharing your guidance.

Reinette 
