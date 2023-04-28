Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144C76F1E1B
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 20:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346487AbjD1SfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 14:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjD1SfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 14:35:16 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5366010FC;
        Fri, 28 Apr 2023 11:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682706915; x=1714242915;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7eQmSikrbu0QCVAVo8vXoXyMEXM5RYg0Klh1kZ1Ftfs=;
  b=ep1SSKmPMMGLXm6fSLupgAQEyEcKRBgnUusekbfZXyySMxiQU8tbb5O8
   2kVfmhuEcuZy696vH5bNY7roI4azaH+XOIfdb8QIaUvBmpw5XHun80upA
   lCulhmcFHFcxKsDGqzSfrOltPdr+BEVwdis1sWpDStsmUyBGv1d9Kq9XS
   M3N+4YWcV1WzgPLqmUqj0eSqBbGZJF7gnEglHJLbrQuJfdTmDwsWRR28v
   MdwFvOE7u/6Szq56tk8XJNsuc6i64YsrRvMWNnsltiuUlWEOrdR8b2FUw
   FazykCbEXIZ5VjQg0t+vTzgaCm0urKr5nW59EM6CMYNcBeeDB3zk6Oi7F
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="328162330"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="328162330"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 11:35:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="672290993"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="672290993"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 28 Apr 2023 11:35:14 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 11:35:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 11:35:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 11:35:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhgOo+LFdg4IsqPVPp1LaXw3yrGqVyHOqHI2BWL+jukrlWLwOwB6QxeYg/D21avIemhGD75vDSkPMe2qW+9OeWeCAZjHy06Y2DNg6mRdwzEf1fRtm9E/1hu7uDNtoRAgCCffGbR/G5EuOiRpbtLAbnysytaSHKvQ3Mc0zehcRVzzpf9VpJIhA2btsPMQeEbDAFfz3AMWX1YNxXnvjwIkKvutkSHvJ4QxPi0f5O81r8ZeQ5joUJcZuPfLRterftHqSiiqVhpCqIBFwIh912A0psP2OVcF81dLtqtnNeVft2+WC8uRmF4pgWQywtp8TLoVZYvy4Q73OjMFZYJRbMxrZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moW6a3QdE2QfuFLzv5HmcRPmAwfNKMWEdkvnIUNlizU=;
 b=KFC6a/jOurS5ZUaTRlfDsalTryTA7afRGenbKmgghb77QyK06h1ubHmeZbjN8KaV3HgBZmBospfeO1gsqIRaBygrudGkcfvEqJCZ/1na1soxaIq6rWvn2MFaet9QMbfdj20nfoNTpyUgMoDgoSUTRijDeW5/PQ15i5yvSh8aMDs9epWjuBXtFdfDNXuCUokpg7RUExJCpRWelcOsY/0Kly7OmE8Np1DiyIzwSQnFbJdBX/CUSe810tdyGDNbB8JCG3e+mootJVY3q98Bwxfa7Idn6356A9LamgyKp+8vREfQW58yc6zwXZx4WENeoz3qq6BSmmw4wvcASEmjvGWAcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB6689.namprd11.prod.outlook.com (2603:10b6:303:1e9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 18:35:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::591f:4873:fd80:9a6d%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 18:35:12 +0000
Message-ID: <296ec21f-fc7d-eaf2-484c-27ae8815c5a8@intel.com>
Date:   Fri, 28 Apr 2023 11:35:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
 <BN9PR11MB5276B67702AACB0B5BF1EC0A8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <BN9PR11MB5276B67702AACB0B5BF1EC0A8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0132.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: d462cfd0-c931-487b-2956-08db48174d1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VEHhAE/9pBbSfcHGCP7XqaaZLfugldEgSdMRh1i729l1j3ROaHP6NwtXkitpTGeAJM2aY0VtGbTVry26qsanYjoK39srLgvl2nttnwcjafXilUcxtUB+eh1cUS6R+7HRM5G9SGo/Kg8c16+E1ipd3/c6tu1ea9J2ALlZkRj9AgFKdO/WmZjqWmMacibG7WMQ/qm94JFEefJNPOZ82y77FoDtD2q3wliDCLzg5t9vbi3OunXnG46a1Em0pV0K8XJcNSg7+Qxr+9Wa4F4U/pFDMl4/uvxTqLN5JMv4Kv8hPGWQWSm8WK06TYZL/BqLt9r0h5S7eS2sWh8ZypyrOijlcDSgOyUlpetta9MWhu9Sk/6VPlYonU4x7hg0kyHz+zAwBrhV2FFboiH79d1Lc5wcE1X+1U5xI/U2SIVC0smcLpUbroKY8NfH3Fwtf3mZmEGF5U2KddaJfvgYtyXi7boYW8HjR7suuucw6YtgmdXbN1v9gCmMIVePeFwExV/1Eqz0nDt9TIxExFXU0Vyu9OLVCYFGNtOUPu9anDXcV9T8sQadbNqToLGFsnLGsBLFfEgbEY3SUWtnA5LHY0JekVnNW0y8wh2iEcugdF5lDXLcjcsl4fX0M/Hf4tDpmhqL/+6NJuEzVdR3OB5PEgtO5OSBlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199021)(31696002)(86362001)(36756003)(2906002)(8936002)(31686004)(53546011)(6486002)(6666004)(6512007)(2616005)(186003)(83380400001)(6506007)(26005)(44832011)(66556008)(110136005)(478600001)(54906003)(82960400001)(66476007)(316002)(41300700001)(5660300002)(66946007)(38100700002)(8676002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0RSSlVFU3c3akRsUjhLU0lYaXEwR2xNVE0rb2twNVU5NGdNNVJlNzluWDdN?=
 =?utf-8?B?QUMvMk9LRTdYVzVHakxyM01EOG41V2dBTXEvOElVK1BiZXFPWWlRcVM1QVFa?=
 =?utf-8?B?dkZtODFWQk02UnhDMEJQM3dVU1hSeFUrd2ZUVEN1V3ZCK0RJemdEQnBQWDJG?=
 =?utf-8?B?cnFzRlNNV1hyengrdWk1Zi9ZcGdEKzlsOXpHbmY2dm5GZzdKeDYrelJjVWFu?=
 =?utf-8?B?UDllY0lzM0NQZGVCTlJkY1BBRGkxaitNcndLNGltc1c3S0p3UjFFcjNDYWs3?=
 =?utf-8?B?QVZqN1BQSzBLZ1ZaNVY1WUUxd2thbTJjbEt1bExEdDFRYUZJaUJNOGh1ZmJD?=
 =?utf-8?B?Qisvd0NOTEtzMGkxWmhRT1U2aHAzMGw0N09FSlh2cHlTRnJ5b0ZMb1JxV3Bo?=
 =?utf-8?B?akI0RFgxUWgybHF4OUwrUHV4UVBkb21SWjBqYzRjZmcyVHR2SnZOelNXa1Ro?=
 =?utf-8?B?eVE2bDdsUWpoYTkvZlFOV3RMRzN3VTg0cW5sM3picnRQUkJSSjBqbWRZSkNx?=
 =?utf-8?B?Ujh6SWdVRExVZ1JJVDFuWVoybTc4SEFzSlNQczZzKzN6eGM3WGVTUm5GRUIw?=
 =?utf-8?B?UHlkUXluZDRIMEpFNzN3aUdzWGxUWGpCNUlMYitucldwVnRMczZDOXJzL09Z?=
 =?utf-8?B?c3ZubVBldHA1VWFDQkpNN01uY2RVK0ZjTzB3ZzVPZXdFWmo0V2k3c3c2WkNL?=
 =?utf-8?B?a09JeURyVWRSYjMzdlRhTksvaERVZkkrbS91VVRBM1o0YU5tU3F0L0kxNXdN?=
 =?utf-8?B?NlBiWnlDL1JyTVdzeU9DM2RPa1ppYzlsTE1JdkcxVmw0ejA2Tmlvd0luTXVi?=
 =?utf-8?B?WG1LbmcwNWR4elRZc3FUZjVZQUNGUUJqVjgwbS9Ob2tLekFpbEZwQmlWNENE?=
 =?utf-8?B?Qng2WjUrL1BaaDdRTCs2NXByd2FhRzhqSlBXY3NsdCtUSFFvblRVQ1BtZzRX?=
 =?utf-8?B?aThxS09tY1Y3VC85OGJtelFJaXQ5cGJ6SzVtQUJKelAxbnZUU3N0TnNyOGxr?=
 =?utf-8?B?SFQ2U3JucVRzcEVqSjBRUjUxVG9tcWhzOUoyVmVNdGpNWkg3UTllWmVhTWpt?=
 =?utf-8?B?a0FEZWh1V0ZCdVZINzc2L1l6Y3NRWTZCZVI2MmZDT2YwejNPMm9neHBEUWJw?=
 =?utf-8?B?YldvSkxZaWxzRHpiMEJzYjkxZFB4a0ZFb0p4U0VjdDRFdTNwTTFkaEQyK0dE?=
 =?utf-8?B?OCtBNU1kNk1zNUVJbW9STVlXVlcxSFZHNDlMVzJZbHJIMndnNGZzd2ErZDcz?=
 =?utf-8?B?UERQWVJ1RlBzTDdab3grb2hsOGEyS0VXWHRpNGtiM0hCVTNYSXJDc1pTZmpy?=
 =?utf-8?B?T1pmZWxIR05mM1JwOUpQY09iUStyVVIrS09KcVlPMTlEV2JwODN6L3pvaEcv?=
 =?utf-8?B?YXJXeHhaRFVPTVZlbmNtMHdJNW1SWlRRRk5rbEpXL20zVE5rWENiTzlhZmFF?=
 =?utf-8?B?RUlibW93V1krSGZmNFcrWHdFVC9iMkZUdjJZenJtd3dWcUMxYmRMVXZQOThS?=
 =?utf-8?B?OThXVWd4cWNiMW0vWlphODdFWUc2WGpzUlVNZWc1RWxnUVpZVW9yUlh2N1Rt?=
 =?utf-8?B?S2xOYldrL0xadTJPNlBHSjZzRjhjdk5hbzg2YkZFOHAvQnZEa2k5clY1Skc3?=
 =?utf-8?B?bkxmbDV1T09VVzl1QkZhaVNYS01PVXFlTnFBOHJoVlB5TUxMTVNvT0wwOEhm?=
 =?utf-8?B?Q3ZSYjRWdmdGdWtFaE9ocFBwVmdXWWs3VXpiZjVIWUtXR0JEMlVQZUdVZjlW?=
 =?utf-8?B?NEdDLzJXQlF3SjloSGlEZmdyNkpQOEJ4U0xGRXhWd3FrQmNuLzlFM3Fldkxt?=
 =?utf-8?B?Z0tpcE1ZUDhBZzRSUG9JdGZqT051UWxRbXgzWDNod1FKeXowVjNlR3BlZGlV?=
 =?utf-8?B?cUNmc3YxWGs5aktsZTk0dVl5c3RPRFA1WkdMU0NSRTZWYkNSb25zYmNmYS90?=
 =?utf-8?B?K0VtQ2hzL2VnTXFkUEdKcE05ZUJxemZUNTBNMm4xQTJnc0FKSjM4di9RVnpM?=
 =?utf-8?B?eXErSm9SMDdWUjlwRkpVYXg1dGdEK0pkbGxselFwd2ZkYllxVDA4TFFsc1Qy?=
 =?utf-8?B?ZUNDdmEwQVJpeVZMZVhFd1cvV3BUbjA3MmxVeTBDRXB5b2JGT2ZVTGNvUG1k?=
 =?utf-8?B?MmU0MlNsTW1uVDRFeUVUZmMrWEdUOFRFYkpJL2dWTGNaZ09kYTZoUWNia2x5?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d462cfd0-c931-487b-2956-08db48174d1e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 18:35:11.9625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yqK5coaC9oFSGGQbmAVB8hr7DqTKXotvHk6VYYU6dEnrIWVdNxaABbpsVGSvWs8mWl1RF2G2fnvHLCxxJ7+9qjLZxjhEUlyew3yIQnUfkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6689
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 4/27/2023 11:50 PM, Tian, Kevin wrote:
>> From: Chatre, Reinette <reinette.chatre@intel.com>
>> Sent: Friday, April 28, 2023 1:36 AM
>>
>> pci_msix_alloc_irq_at() enables an individual MSI-X interrupt to be
>> allocated after MSI-X enabling.
>>
>> Use dynamic MSI-X (if supported by the device) to allocate an interrupt
>> after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
>> the time a valid eventfd is assigned. This is different behavior from
>> a range provided during MSI-X enabling where interrupts are allocated
>> for the entire range whether a valid eventfd is provided for each
>> interrupt or not.
>>
>> The PCI-MSIX API requires that some number of irqs are allocated for
>> an initial set of vectors when enabling MSI-X on the device. When
>> dynamic MSIX allocation is not supported, the vector table, and thus
>> the allocated irq set can only be resized by disabling and re-enabling
>> MSI-X with a different range. In that case the irq allocation is
>> essentially a cache for configuring vectors within the previously
>> allocated vector range. When dynamic MSI-X allocation is supported,
>> the API still requires some initial set of irqs to be allocated, but
>> also supports allocating and freeing specific irq vectors both
>> within and beyond the initially allocated range.
>>
>> For consistency between modes, as well as to reduce latency and improve
>> reliability of allocations, and also simplicity, this implementation
>> only releases irqs via pci_free_irq_vectors() when either the interrupt
>> mode changes or the device is released.
> 
> It improves the reliability of allocations from the calling device p.o.v.
> 
> But system-wide this is not efficient use of irqs and not releasing them
> timely may affect the reliability of allocations for other devices.

Could you please elaborate how other devices may be impacted?

> Should this behavior be something configurable?

This is not clear to me and I look to you for guidance here. From practical
side it looks like configuration via module parameters is supported but
whether it should be done is not clear to me.

When considering this we need to think about what the user may expect when
turning on/off the configuration. For example, MSI-X continues to allocate a
range of interrupts during enabling. These have always been treated as a
"cache" (interrupts remain allocated, whether they have an associated trigger
or not). If there is new configurable behavior, do you expect that the
driver needs to distinguish between the original "cache" that the user is
used to and the new dynamic allocations? That is, should a dynamic MSI-X
capable device always free interrupts when user space removes an eventfd
or should only interrupts that were allocated dynamically be freed dynamically?

>> +/*
>> + * Return Linux IRQ number of an MSI or MSI-X device interrupt vector.
>> + * If a Linux IRQ number is not available then a new interrupt will be
>> + * allocated if dynamic MSI-X is supported.
>> + */
>> +static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
>> +			      unsigned int vector, bool msix)
>> +{
>> +	struct pci_dev *pdev = vdev->pdev;
>> +	struct msi_map map;
>> +	int irq;
>> +	u16 cmd;
>> +
>> +	irq = pci_irq_vector(pdev, vector);
>> +	if (irq > 0 || !msix || !vdev->has_dyn_msix)
>> +		return irq;
> 
> if (irq >= 0 || ...)
> 

I am not sure about this request because pci_irq_vector() cannot return 0.
The Linux interrupt number will be > 0 on success. 0 means "not found"
(see msi_get_virq()), which is translated to -EINVAL by pci_irq_vector().

>> +
>> +/*
>> + * Where is vfio_msi_free_irq() ?
>> + *
>> + * Allocated interrupts are maintained, essentially forming a cache that
>> + * subsequent allocations can draw from. Interrupts are freed using
>> + * pci_free_irq_vectors() when MSI/MSI-X is disabled.
>> + */
> 
> Probably merge it with the comment of vfio_msi_alloc_irq()?

Sure, will do.

> 
>> @@ -401,6 +430,12 @@ static int vfio_msi_set_vector_signal(struct
>> vfio_pci_core_device *vdev,
>>  	if (fd < 0)
>>  		return 0;
>>
>> +	if (irq == -EINVAL) {
>> +		irq = vfio_msi_alloc_irq(vdev, vector, msix);
>> +		if (irq < 0)
>> +			return irq;
>> +	}
>> +
>>  	ctx = vfio_irq_ctx_alloc(vdev, vector);
>>  	if (!ctx)
>>  		return -ENOMEM;
> 
> This doesn't read clean that an irq is allocated but not released
> in the error unwind.

I can add a comment similar to the location where the trigger is released:
	/* Interrupt stays allocated, will be freed at MSI-X disable. */

Reinette


