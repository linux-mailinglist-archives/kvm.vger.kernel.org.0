Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D180706D24
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 17:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjEQPrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 11:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjEQPrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 11:47:12 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8CB3A80;
        Wed, 17 May 2023 08:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684338419; x=1715874419;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6GgzuqWPMtiYlANy6ZtR1kcDQzE917pk5bQZs+PjnT4=;
  b=YGdP/673aCs1N+hRJVF4UvLg/A2h2S2zdtS72fXVSQDjcACvbircCAlW
   +lf67RIIUmdfksbUik5GEztlRvZd7Bgdq5Bx0nLu1hiQvycs1zuE0z5Fz
   G1jia2Tvr4rmYszvJwd95InDXDtubKFDbEcXqKzqNcVN2SQnnSTMxl6fZ
   vy7Ouqhwk7MSduAGbuVMzlSdh55ZGOQRtlmu1mS9SyHXQ6x6LyInNI+o2
   S3Q+eAz6zswtdWLHvZVpxEY80iX5YeRcwh3pOcHSLAVXAHDw0MILV98gY
   SAFPkv5WrM05hqEOC5ji4xYmhSgJ7r8ORtwWRoYPc+BhbWAiE72oMqCcw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="349299564"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="349299564"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 08:46:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="826007224"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="826007224"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 17 May 2023 08:46:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 17 May 2023 08:46:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 17 May 2023 08:46:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 17 May 2023 08:46:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5U9am9YttWeOBlEY1AW/WaZ81Y+FwijcpilTqTzXtzrnPjxp+XTvy4cGnG9VGalH1oCGI52dkf7SW8REUbATCY2tVtRdjdLCY1tDnWhvgYT+mAkBGqeeidbF2Xa5XTa9ylVe+5W0x5E/5UDkgSxeUCaVPY4bTkx2mkXwB0Wu52mTuPG2sxf8CfMNjZm7EhPVloqzT6rareAl8a2vId7F3d+qF1os5RpvPPCcuwkgouI/EuxkxmCNhB0P+N0X1es5K+wREa0+XL78YRkCluE2WD4R2xuvHHM0WEXwC4ksYT/67q9kFIIzIDNvPpptrFO+nREolV0SMH8tQ6xiW/gbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FwmNo2g2+iB6Hs6D2yhEci1bR65lBSJQyQzt5hSEZ9A=;
 b=iRROeIQX5TxZaXN2JzKFz+xk2a0FRKGn6HxpFxE3MnFwkNrLAR6Jo7ATiifqSvK+kw+j0oOjfR1quY8XE34uKIQ/qCkO8sbes71gTq8Ccsx0dnlx4N3XhDJITEJ2mb0QSVdotY4G0dsXzjoJG6ZGFVf+tOhOYmJTFzB5x+eEDQuc0mupgbKzhY30jft2B/mApxA7/8Yw2aRwdMhYQiiK/6jepJkNMMChITRotxxH2JY2G4o1t57cFLIE+Z5hNVulpkzuKO18imAcuK1C1pWevdM2NK6shi/9xQKIW/u4xwjft6vf3qUuG3q8uL0MEPtCDSKKaB1LJFXJ/xNLXLqV2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY5PR11MB6390.namprd11.prod.outlook.com (2603:10b6:930:39::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 17 May
 2023 15:46:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6387.028; Wed, 17 May 2023
 15:46:55 +0000
Message-ID: <3f980e49-e555-0415-092d-70e581f25dc2@intel.com>
Date:   Wed, 17 May 2023 08:46:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X
 interrupts
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1683740667.git.reinette.chatre@intel.com>
 <20230516165320.229b4928.alex.williamson@redhat.com>
 <BN9PR11MB52766D2B3D4EEA58D540FA858C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB52766D2B3D4EEA58D540FA858C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:303:8e::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY5PR11MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b4831ba-0d02-45cd-e16b-08db56edf116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o76aTu8NcpKJpO5d4iPWQb+ROQ8BlvdKkJIVxTao1T88OUn1AF4+3a+CjNVS/PrZj2pJjgzvtX/BqcvpT8rUJQlJ5bvq2FYIAit4ou+FQoYlOLZFwrgIh88MwwrsUKwiD2ZjsDfP9z6EbIccwlc4gyHSoME39uvWzZUqIk5Wndk+6PnFJ7882rtOxo12WphZFwDCLSJn5bFrb6h3BVXvVwsO+fzZ1frGvc3NKpaWsiisWe0E0Rt6Ep3qQBSlJRKHQbx/zuGikFJuNI4QgUhda+Z+Hjk8ZCc1vIU2Ywu/rxk+wFLKPh3p65EprP85Qonm+YRdUte1eLxa3Qx4Od7QFuxV58uPJAlHrlNe/7UA82/ALtUf2agqtTB8t2YDnfM4w22Tms1p2dahe5Upb7fSOVlOYeJYRpLUixct2+Zr3TOZf/pnK832qEUFjMncTUkM9Ley17lv06/8JVkd4h9TKKC28/WTpLYk/xGPGZJEjkrUahkVuDqm2nFFxYIb8kpWxOnUND924spI9UI1w8qRHsP8AmYq1mce0OqhVLFhqLfUa8j6Er255C916o+4MgnPgrkR6twMTCjjf79JfpO6jyt0Knh1nqY4hqSB/8+/VFtWcaq/nSoK1N22KWu5BaBTio9BtqmOTJ7dXqmmS4eNQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199021)(31686004)(53546011)(6506007)(316002)(2906002)(41300700001)(82960400001)(4326008)(38100700002)(36756003)(6486002)(66556008)(54906003)(478600001)(66946007)(26005)(66476007)(966005)(2616005)(5660300002)(86362001)(6512007)(8676002)(31696002)(8936002)(110136005)(44832011)(186003)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3N6TlljSUM3dnlKcUNxZFo1R1pBT3IwbElUdHh2Z09OaHc5YkN4ZGwyOFNP?=
 =?utf-8?B?eTNEOTFPZWM4NFhmR2tsSDB3TTJueFJBcGRVMXc2ZWhWSjZJVk9rZW1KZzZF?=
 =?utf-8?B?aDlKUzI2dVRmWWVlbWZVdmJ6WXZ2cXRPdWQzY0hqdHU5b1Z5L0t3NC8vZk8z?=
 =?utf-8?B?M1IwNnVKWkd1MlVYNlFlZ1FVWE91Nm92eDU0YW9HeG9QUkFtaUU4SDhabE10?=
 =?utf-8?B?ekkyZVNWRS9FTFBYWnZMOGVIMGxJa1ozUnM1M1hsWTQyYUhkRGt2bk5lMmxm?=
 =?utf-8?B?aXlTTmF2ZzliQlNCZG1VTVlQczV2N0Vxcmk1aGhaTmtneWZRaGtFYUVDcjFG?=
 =?utf-8?B?bUpiWlNOM1BYNXFaSVhha1NscHNPZjdTUm5jOWxsU05xQ2ppRWg5bXpFcjdz?=
 =?utf-8?B?WktSUDdJRWxFdzFlMllzNitqMlk1QlFhSXNtWEQ5a1J0Zi80ZFhiK2VBV0xr?=
 =?utf-8?B?OEQyUHV5VFJHRXYvajBLZ0JQaGRkME5qeGdudWM0SHcvbUJJckpzbUpvTEZn?=
 =?utf-8?B?NDdwb3BseC8rYUhTNEIxaWhmTlZoTWtVMlcvL0VoZzRQcVBuZnVxVi9DZlpV?=
 =?utf-8?B?NDg4Qmgza01nSmVPVzdsVlpHY1RPRmU0emJBc2hFZGdEcE9hWlpUOHFZV20z?=
 =?utf-8?B?OEF0OWg0Nkc0SE94QkZyZEZCcmJTOWVnUXpqWmR4c1V5ZUhiRnpiQlhMYlIx?=
 =?utf-8?B?SDFWNWJtTXN6TXBXa3BLN25SUWs2bVRHQzloM21sdFJDNUdYUmZ1YXZhSjZZ?=
 =?utf-8?B?a0ZKZ3c2NXlRTVh1cmJTZTVMei9YZS9ZZFhocDJnSUlvdzVYbk5vTVFuZW9S?=
 =?utf-8?B?d0NqZG5NWC9yMUpjWVArcUNjQlBSSXgzN3AyMzV4dFhTY2diOFIxT2RoR3VV?=
 =?utf-8?B?aFlKb2tVT2MzR091NmZkZzZESDExL21ZQVArblErRFBaaS9vek42ZFJkNEFP?=
 =?utf-8?B?MGdGMnAvUTE1WGxXRVJyUWdmNXVBWWhHbTU0TG1SY0dRN1RwMENlUUdVMTVF?=
 =?utf-8?B?dXVyU2VZNnZDV1ljbVFWVEg1MWQ1Q2xUS2xUVkJwMXRodE5RT01EVWoyTm5F?=
 =?utf-8?B?eVUyR3N4Um1ZSDN2TkhjcTcxZG1LNWhZQmVZN1Jwa2ppOW1zcU1jTExaMGto?=
 =?utf-8?B?YjB6Q09UVTdxUmdKZEExS3FTd1JveW1jTy9MRGJLS0w1d2FGRk1lKys0Q1dl?=
 =?utf-8?B?bndRYXN6V2VXQWtoVnhETjFwb2xtK3VwYStQWmxsZmFENkhIMXAvcGVJSXI5?=
 =?utf-8?B?RHM3ZHVzSHk4U2Q2WEpZUEswOXpjVEM4SnBCRXJ3UU1SalNsQVNvbk9EaG84?=
 =?utf-8?B?MndqajN4U1N0eUp3a2ZEMkpkdDR4NWplbTdaZnZCTitCSUZHb1NVT0lhVzZH?=
 =?utf-8?B?a2lmY0h2TFFGUTJzb2ZXOWVLQ1dQSTJaeWdQdFlJOGhMNFpDQkkwWDZYeHlU?=
 =?utf-8?B?anc3QVR5N3pzN3RMdlpJaFpSa1NidjlaWjhVdG5PTGxtZFdDUHVEcm03SExv?=
 =?utf-8?B?SnhHa3dMS3hBTUJFeHhTaFU1U0kvS24zSDJybWV6K1BQVld2eTFIend6STVk?=
 =?utf-8?B?bHAwRnhXdU5aV2JsMjUva0tBeVFPUGtKSlRNN0ZYL0VMRlBXSGtVMWlJdnZ2?=
 =?utf-8?B?QXpaYmdabzNMaVFwcndFY3c0Nmo0aFpaSE1DVUxQcE9iS1l2YmJldWZobjhQ?=
 =?utf-8?B?UXJaQ0NaYlowZXdpVUJjWmlMK2RCU2tlaTNNZmxJSlFueFJKVVhTbHZjbDlF?=
 =?utf-8?B?UDIvMGFhRlF2bCtLY00rN0pwYzAyMW5sSGZZcjJXZmRUNXJhMXlScWtlSFU4?=
 =?utf-8?B?VUVyaU9waU1QK2hNQkRpTXNsTUZ2ZE9udnM2cnNON2VqSkJhNFF1V3EvTDd4?=
 =?utf-8?B?U2lmcWJFa0VCalhkdUZRcUQ3dGd4WitTaUNlRVJMZk1tellIYUhjSmJIN1Yy?=
 =?utf-8?B?Q2VsZWtGNTJDQXo4bzFrL0JUbDQ2cmhYZGEwOG9IYmFTbkVxSDNhRFFsVkNP?=
 =?utf-8?B?N2Q1eWxtQmQ1VE9vTEI1WmEvSDdPUzJsZ1lRZVd4NlRMa00vOHV6MTIwVlhs?=
 =?utf-8?B?Y0xYTklkNkIrYTVPZE5TTWIvbTJtM2Qvcjh1SGMzVlRDL21HL0txMkhVcXlS?=
 =?utf-8?B?Ui9SKzJrc3h0U05iQWo1cE05LzNickllOHE3SFJIS2xhTmV1UWgrZG9QVjg5?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4831ba-0d02-45cd-e16b-08db56edf116
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 15:46:55.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ng9BpPS7WwOKCaYn5YLH6wzBIhkIcweWRi2MQ4rNAxFPdzgJtd4nY6tMM1QxJyAsWLio2RgOdaw9h7mHZ6DwCnNCn9Dwf2UIZxy5A3yLxEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6390
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/16/2023 7:14 PM, Tian, Kevin wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Wednesday, May 17, 2023 6:53 AM
>>
>> On Thu, 11 May 2023 08:44:27 -0700
>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>
>>> Changes since V4:
>>> - V4:
>> https://lore.kernel.org/lkml/cover.1682615447.git.reinette.chatre@intel.com
>> /
>>> - Add Kevin's Reviewed-by tag as applicable.
>>> - Treat non-existing INTx interrupt context as kernel bug with WARN. This
>>>   exposed an issue in the scenario where INTx mask/unmask may occur
>> without
>>>   INTx enabled. This is fixed by obtaining the interrupt context later
>>>   (right before use) within impacted functions: vfio_pci_intx_mask() and
>>>   vfio_pci_intx_unmask_handler(). (Kevin)
>>> - Treat pci_irq_vector() returning '0' for a MSI/MSI-X interrupt as a kernel
>>>   bug via a WARN instead of ignoring this value. (Kevin)
>>> - Improve accuracy of comments. (Kevin)
>>> - Please refer to individual patches for local changes.
>>
>> Looks good to me.
>>
>> Kevin, do you want to add any additional reviews or check the changes
>> made based on your previous comments?
>>
> 
> Good to me too. I've given the remaining reviewed-by's.

Thank you very much Alex and Kevin. 

Reinette
