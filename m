Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EB96DB0CB
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 18:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDGQo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 12:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjDGQox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 12:44:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068B46A47;
        Fri,  7 Apr 2023 09:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680885892; x=1712421892;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OhexWNqX1XlJvQVIJYA7ww+Tn7mDbFIcqwT+8CPBWHU=;
  b=WBq60k5GJj+ICCakc/dXbQdr7rPy9yOhRlqCQpi+GLj8Sm5LXxNddoBp
   dT1p2mz3uM0xc+hm8SJo57mBYcClMPXDsRtlJtx3kDIJVcVe51spJf8WB
   U6765saWFlRLRhHV/Jebndit1Xz4YE+bbPf0pbZce1KNMOa/dJArGipFe
   RubX16uH1eO3GQoOyRwKto9sEWPyNuV928UXIDkC79Y/Rld4wmvI4YuT4
   5jIxG/TJ4+6FlEyeLlFJYCV+al4ra8IqKxb2Riy/SFVIVbXsAncVpCVtx
   Iw6McZrhTMMJe7+Afd5Bs1YSpJIObea+CjvWpWiJHB64gTs928iGK7BeG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="405842148"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="405842148"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 09:44:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="798751200"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="798751200"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2023 09:44:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 09:44:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 09:44:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 09:44:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFbESWoBPY2KSYCbCvjewRRNEVQhcxGWg2CaCA/8qFFhgXbbQDzwCErshaVa/v+YLslnD4zxCJsvOksa1xdSp3/FAtaRFKxTjuN2CAWwtcPU9xO29+AP9KhlCIdkqm+As7BiApQiZX9mr+FgA8MIf1xmHb8bd2Bsu6pyu4mwEr76A3j9GK1cghoEoVWOTi/DsI9uSPnGP20NCk8KOOp039r81PG3cxv12zmnCtWSqGkpR4dl9mmnhHv2BSTC9+uDLcqeMzd+Lz+I63YTCZCZR1AiNHe3LiQIAq+Lu1dyfKaV3MxHwLLo7ObkuyyAQWWDeZPKWgY/V5NfCcg9oJ+piw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJN7i6an7S0Fsinbtr7JmcWsPuWiah2i6JfiBKdTKeY=;
 b=DB/J619C/1bsJmiNyF2+s6op1dUEubd4JAD/uBxgZxfJnALy8dA4QDfOGtcdfE8xCBD0GuPFBLUFY8J9mTZjRdWhcGL7I6w5JbH9kdptgRv2a7lFHckOVnQjZgxreOFc2NvVX172cAkqFRpfNz+VqLhME0jPdqvSllLxMgMeBTDHXRu7U6ALjnbEaG99imWZdL4GJEvBR0kpLo/2QtI3XvmIFzK4tZnJCiT6udST7CtHdOWHQ8/ZZuzluPOBxt7TAxOZfuCH/AAxV6BfeUilS4kawXmy62nz0p4lJ5HPUOKmwrSIm6iYNmLzufSq0K3pnV3d+RgTZzH5WYInKSg5sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by IA1PR11MB7811.namprd11.prod.outlook.com (2603:10b6:208:3f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Fri, 7 Apr
 2023 16:44:48 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 16:44:48 +0000
Message-ID: <6cf2d0c9-a589-cc28-d748-8d4b193e9e18@intel.com>
Date:   Fri, 7 Apr 2023 09:44:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2 4/8] vfio/pci: Use xarray for interrupt context storage
Content-Language: en-US
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <8e9aaee36eac32c4b22f6a2c334721ca84132d61.1680038771.git.reinette.chatre@intel.com>
 <CY4PR11MB1238E93B038C09DD38269BD2A9969@CY4PR11MB1238.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <CY4PR11MB1238E93B038C09DD38269BD2A9969@CY4PR11MB1238.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::29) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|IA1PR11MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 19e7421a-0185-40a9-ac37-08db37876601
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XUUniMWbKmnAtsbebSeG+hUX+T2kYzypDU7TplYoMC6IY7ED4uz7P1R+AnVNriZ7RXuLow7W6Ttt0vZNnUNZFuThJsjNNyy9DwpaGVc3nEMfgmqcLfGauGj7XR4IT4hNgBtdpPu3q20XsKjLhInWr0d4sj0+FZxOkcEA7wESnuXf3ZdLqBASAnhurpBPZGxBZkDCK5bFmfR6EhrfscWsewa81qHCFQkJVbTRU5JbHF5bhXLqdsSsHh2IQMtxS6fofrRaNvHSw/hvTTEgoJ2gpbv+F2jJ5K81YsflrqwvgbKULwy4wctntmFopFOhU2g/2X9TncYcH6LVvO7JFOu7uS/owle5zOrwWS1xyCVaq+EIaBqBrwxFG8mEQ0Bjx4Rn48d9Ojie1LhAuo7UTWk1K3OoXYOVvFaXU2iFuBcA4Q50PcOBY9O5t6K8qcwIbi+CCw2Y6esDtpKImsW9fvfDOJfsuoJz4KWkX13Out0I3makfHYlEOUDO/7imdY/YTnxHZCsjVIIt/EfnM/8Astr9r0KFO6EvzKdqiaeH8Q1SaCZqmbZMIMGpZv5ug5mlfxFeNjyWa8fmBtwlfrpQ6NSvs6kE3t05GcUPPX8Vkp9M+Xp8BxheQP9OmIf/JZmJIkeYnYfCkf2YticSNuEAzYIfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(39850400004)(136003)(451199021)(2906002)(36756003)(31696002)(31686004)(44832011)(86362001)(6506007)(4326008)(966005)(2616005)(6486002)(186003)(53546011)(6666004)(26005)(6512007)(83380400001)(66946007)(66476007)(66556008)(41300700001)(38100700002)(8676002)(54906003)(110136005)(478600001)(5660300002)(82960400001)(316002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVVCcjVCODBYcFRYMGluaE5zNFpVL3ByOC92NDRyU3E5dkg0WVVoSEFOUDdS?=
 =?utf-8?B?UEtBQXJzbHA2anNOdGF4Q2J5T0FxcE54QUkzaWh5bzIyeExQRnF2aDRSSDBn?=
 =?utf-8?B?WnBmWjZLMGhRQ1ZKR3Q1WmM2QXVuSXJVekQvaW4wdzVZak5lOWdFbEhmejdp?=
 =?utf-8?B?ZVVlUHRScHlIVXp5dDg3b1NDUjJSalBPTlR0WlFWMzF6Q3dLVkxaeEF4YUlt?=
 =?utf-8?B?SVZyK25scU5sazR6eEt4MUhSd0JIelVoakJQOCtsVDlPb242YUErbXlNOFdB?=
 =?utf-8?B?bElYeDhyaDBZM0ZTbVF0dkVlM3BLNFV5SERxTERhcnVZSVFuYVhKQUx0TjQ0?=
 =?utf-8?B?MjFORnYvTkF3WFdQaGM5QTEyc1E1dTE1eDRhK0djTklwdWMyZzZVZ2lXNU4w?=
 =?utf-8?B?ckxSaUpuTklmWUJzK0QwQmoxWWJJR1h6ZEQ2SGZHRzhyVHc0NnhiYm50c2FE?=
 =?utf-8?B?d1B4NmhWdVdla0ZvSEF2UUYwQXgxR1FnOXlwa2Y1SFdVZE5xYVdEdlV3N2kx?=
 =?utf-8?B?ZVRxOXRIalRtL3VwTnExS2NhNElxQ1NaRG1uZDdTVGpPNG1PMjNMMGpYWW5n?=
 =?utf-8?B?RjdJRHY5SFdrMTZ1TnZNZ25YOVVhM0paRlZka2xGRWswNnc3R2JtdFNGRE15?=
 =?utf-8?B?dU1xTHp5QmRnRVdyY1lIOHNqL0NpdkU2VVpucDZQWmhhb1MwM2hPWDJaRlRT?=
 =?utf-8?B?cXUxbWoyTkN5L1RhRnBITzZnMVBSc2JqeVgvbFY0aE8yRXRxQTQyOHZlTDlr?=
 =?utf-8?B?TEIzZWYwZ01wd2t0TkpvQnpQUndJem5hd0Q2NjFESnhOZUNma1d2aFRKTW9r?=
 =?utf-8?B?SHp0ZGJ2MzVZcVJYWnpOUjllZnp1TyttZ3FYendtclFEOCtnUlBpVlVPWmY0?=
 =?utf-8?B?N21jTGtaaHo4bGE3ZXVPb1ZQRUNSSC9pQ3I0WkRWc3YyUXNtUmdMZi92MjdZ?=
 =?utf-8?B?RnludlduMTJYWjczUlRaZ2t2RXV0TUJiK01lME9oVVNsWGdRVjY1bFFaNEFU?=
 =?utf-8?B?NURYR0swTzk1bHVhTS8yS2VvQTJPUUxmVmtUZ1ZXTngrQzczM21wVDZrQjJj?=
 =?utf-8?B?cEYvRC84MHV3WUF0bzdXNHdMVm9RdUFaa3J1eVVidjNONkRVczh4Wk5OZnpJ?=
 =?utf-8?B?M0RjOEJBaDZ0ZHA3SEpVc1BuM0NjbUlhdTk4TkhDSkljcDZJTndYQ3M5Qksv?=
 =?utf-8?B?Rkxwem91NUFiZmtxVFErSUhnUWlHL1puUlh5Q1lrZGszRmRqZGhYRjE1dnNZ?=
 =?utf-8?B?QjJaeERZREVqNVhZcUtvT3FybnMrYVZIM09pNUxubzdJa28vdG90SVVKMEp3?=
 =?utf-8?B?RWM3SW9TM3E0N1ZDSm9sbjBwc2gxOHdlRElCRWFscndpbEtxakhOblBCbS9m?=
 =?utf-8?B?Nkx5OHFQdTZTVlE5R1BZKzlRSlo3OHhqR083OXNoZ0RxWEdDWE0xNXF3QXNt?=
 =?utf-8?B?M1gyb3llODkrTEpqcGxwdmdLa3ViR1JjWlp3MDl6YXM4VEVVNUY5OW8yMGFE?=
 =?utf-8?B?UnM4ZHpmN1UyVEJSSVp2RDd6U3BEWUlnczRlZDRRQXpUNTBxakRBM0dVbW4x?=
 =?utf-8?B?MGI4YXphclFBb3dsSUVkaGxQMUc0VWJseUg2dVlXM2Ezb2ZvMFdUZXZGSWJm?=
 =?utf-8?B?OUFydDVCV2tHckFZRS9sMzdaWFl5cnRVczNEdlVwQmNqR0Q5M2JWTEFLa25a?=
 =?utf-8?B?QVRaRUdCdjlqRmV6OHVrV3JNR2s1eEUyeW8wUzZFN3BSNU5tUWFyZWJOZ09P?=
 =?utf-8?B?RCttR3Z3c1k3L2ppZXJXYlVaL2RVZWc0VURPOUdWUVVrU1ZSQUkzTzFkdC9z?=
 =?utf-8?B?Q1lka2NhSEtIZHFFV3VNL2dzZFduNHE5aHdYYzhwU0ZMRUVGVXZUa0x1RmN1?=
 =?utf-8?B?TThrSzZ0SWcvWStid016OFJBV0hGVG5CTlVMY2JQZUY2MDdqaXNXODdmNm9E?=
 =?utf-8?B?ZHM1bGF0NHZBK2dQUzBKUDl2TFhUTTM3RnJUMGM1NGpOVUI2SFVDYXNvSDFK?=
 =?utf-8?B?aTdDTitodElETHF3b2VXeURNeFJWOVBFY2dUZ1VISFY1TGZ0bEJnY1lUOGpk?=
 =?utf-8?B?OVJzQTVnL3R4QkVhclhLRUVaWHpNZis1SCs1WEJFQ2VhSnlEUmtkaHhZaWRM?=
 =?utf-8?B?VGNtZUQrM2ZQN3JxektVNHk1dGhVclFDY1lOMlBsK25Qdnh5U3RxeS9Dc3F3?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e7421a-0185-40a9-ac37-08db37876601
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 16:44:47.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ipI8MhZndvAyjal0YiFc0bnXvj9MkAtsqGPAoJFDB6/VHjKgbalBzxKONYIQOnq6K0Vvx6vUiG/WLo5N/uv++TnqT/cs+M098vJeEox6gVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7811
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On 4/7/2023 12:21 AM, Liu, Jing2 wrote:
> Hi Reinette,
> 
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Subject: [PATCH V2 4/8] vfio/pci: Use xarray for interrupt context storage
>>
>> Interrupt context is statically allocated at the time interrupts are allocated.
>> Following allocation, the context is managed by directly accessing the
> elements of the array using the vector as index. The storage is release
> when interrupts are disabled.
>>
> 
> Looking at the dynamic allocation change for the time after MSI-x is
> enabled in vfio_msi_set_vector_signal(), do we need to consider changing 
> the allocation of context/interrupt in vfio_msi_enable() for MSI-x to the 
> same way, which only allocates for vectors with a valid signal fd when 
> dynamic MSI-x is supported?
> 
> Because in dynamic logic, I think when enabling MSI-x, not all vectors from 
> zero to nvec should be allocated, and they would be done until they are really
> used with setting the singal fd.
> 
> Not sure if this comment being replied here is the good place since
> vfio_msi_enable() seems no change in this series. 😊 

This is a good question and from what I understand it could be done either way.

vfio_msi_enable()->pci_alloc_irq_vectors() would always be required because
pci_alloc_irq_vectors() enables MSI-X in addition to allocating the vectors.

I expect it to be efficient to allocate a range using pci_alloc_irq_vectors()
at the same time as MSI-X enabling in anticipation of their subsequent activation
after needing to only take the vfio and MSI locks once.

As you indicate, it is also possible to only allocate one vector during MSI-X
enabling using pci_alloc_irq_vectors(), leaving the other allocations to
vfio_msi_set_vector_signal(). Not a major issue but this would require some
additional special cases within vfio_msi_enable() while the current solution
allocating all vectors using pci_alloc_irq_vectors() works for all types.

Considering which would be more efficient would depend on the use cases. The
current solution may be considered less efficient if the user enables MSI-X
by providing a range of vectors without triggers(*). From what I can tell
this is not a possible use case when using Qemu. Qemu enables MSI-X by
calling VFIO_DEVICE_SET_IRQS for vector 0 with a trigger. Making a change
to only allocate vector 0 using pci_alloc_irq_vectors() and the rest using
vfio_msi_set_vector_signal() would thus have no impact on Qemu. Both
implementations behave the same for Qemu.

Considering the efficiency of allocating multiple vectors together that
works for all interrupts (MSI, non dynamic MSI-X, and dynamic MSI-X) without
any impact to Qemu I do lean towards keeping the current implementation.

Reinette

(*) Whether it is less efficient may possibly be debated considering that 
it may be desirable to use allocated interrupts as a cache:
https://lore.kernel.org/lkml/20230404122444.59e36a99.alex.williamson@redhat.com/
