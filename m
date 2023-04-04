Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1C26D6995
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjDDQzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235107AbjDDQzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:55:39 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D1944B5;
        Tue,  4 Apr 2023 09:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680627319; x=1712163319;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yfCOhdXuRrNrMEcZ/5o5YTOzCdzSWh8ZdcGcQX0SnmU=;
  b=hYZQeBO9b1lWhkY9LMLDwFazA2Dt0innlA4YsXoFMCz0skEMW4zHokoP
   ui88rWf5DprLBwnLZ44Kp0+bgSvEbCtQjpeK1lDA6osVtwiTJwJGQGHCa
   Hgn1abLx1MjI1tAGYtdQqAqjiVPTvdv/jgZYFJ/dK0UV+1h1o9WcIE1Zs
   EplYylg523gbdoOpyhFSAKZ4SCD7CAISmByNDyYQ42zzdyJKmpmPed526
   zzAHq7v4hSh2R+Q03EWksFcA4Cq9S+7MFsHRxwd0TJpqZD2Fq1SDZ/qS2
   lcbkbFnahfZCHDKUQLP5bMl6mpkHMduwa0wXblOTO2rYs7Y9SiD6C5oOh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="405007978"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="405007978"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 09:54:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="716719502"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="716719502"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 04 Apr 2023 09:54:52 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 09:54:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 09:54:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 09:54:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVAxGPX2KaXLpjGLBFoXQAx+D+iV8xpD8NEm6x3OpspMa9zFthhE96NKrVi05/gELl3A6hJEzY5y95DnaLcMIJZXpAGvrv0eeldPg6Jxc5Yu73DgRuHjhujxUUv1cIG+aLkX/5hzzlKzRHr69YHu0i04YpWlmohc9K4dR44n65kbBm7LlUAljnzCeQAvYH3JCjOTPa0Tqzdp/Do7rmd0YsEWAEmZBP5VvmjNM81P50Jr1T9bTph+/+jETwpa16m87ehEUDflscOIbyI7pK/6Era6vmPtG1qGivFMdcZcjWqwFuzld8kubJ3Vl9gxpmAXlteUeBpuAKlX6puvqoQ9BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6PXM6h2qmStuWdOmady8rP4xfqwRHMBIsfK+kgem4E=;
 b=nh8L5zBJdFclsZGHgSNZ2jMBupMm8rPthnay/Zh/96bZ2nQXgoqs9coP8L6YhHKtcbL0izOwRwPPmEoIA2WrkFoQV/vwotuBeyPnzYeVMKCfWI3iGPZTbhiGpSLpC9CdjZNh2q0qpMi9mVDWLgvC6LJ1rrtdsB1P7AEK91a3jFdIXDI0MLNhrrQEk2O0SLfNBPXyXN9SnIol7Ejt7i7KaV/62Q+H0YwpwuJBiOjuTJzMkJmJDhbVApgNxeM4Z8qpUtPJGGe4xOV6txHJon0LfJIILoFH/0bf6Fp78w7i+tLcYv4wynvaVzGFAA2TbeaH9VclR/GW00VvOI+5ScgDKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by DS0PR11MB7767.namprd11.prod.outlook.com (2603:10b6:8:138::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 16:54:50 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::d651:ac39:526d:604f%12]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 16:54:50 +0000
Message-ID: <5efa361d-012b-bdb6-b5e5-869887bde98d@intel.com>
Date:   Tue, 4 Apr 2023 09:54:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
 <20230330164050.0069e2a5.alex.williamson@redhat.com>
 <20230330164214.67ccbdfa.alex.williamson@redhat.com>
 <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
 <20230331162456.3f52b9e3.alex.williamson@redhat.com>
 <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
 <20230403142227.1328b373.alex.williamson@redhat.com>
 <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
 <20230403211841.0e206b67.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230403211841.0e206b67.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0049.namprd11.prod.outlook.com
 (2603:10b6:a03:80::26) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|DS0PR11MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: 7be69f94-85cb-4307-a220-08db352d4d95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ixJf7kUlHqXMCZyr4P4olPaTxOC3kvQIVMmowDbh4Jgl78pVIWni/ybM7KlMOgxqpihtTIF0pcbc13WkAn0PM1nYlr2ajV05Om8yCt5IRDXr4nqiPGkr0HhLpVv7pdpOKI/6kNOw+QFElYlZ7w8lVZ+eEvJT2ic4yFEOqiG1My+jq5vblotSLrEWlvqrzSTbsOdAUJZKxhrmIktl4gGthFz+mI2IKMiNzGYSUHkzzykhJcHdqDFIPRuDfUgPBS1UkQQBnkXMDdcb433IyqTBGPOBIZnrog6rkh8SNM6RfyKrqWdlVMJS/GKrwgLOtKahFoZWZEj3JoETfWIdT2Kaw0GjP/NqB+ftEzYWsmMK7YJbkUvvPbtn3U5CUWNQ3NiQrPfFkb4XksAEemx6B4zPPBl2acVHIfxR107kaqcna1Nyrekn59hhwFOFFBNH8KuzUqmgkaJRhncOsuOQ7kVqjpfQvJSxllrj2MEHPSjQz8RHMUuo7Oxcma98Id2FiccB04QssnRmUEgVHUKA24Gjeg19F6M/kw0JOwQftZ4Q8b8wJ2CQwBof2/xxJcD47In7vgYnazW28fqztNAbFE+vEK27rQVi/eRp9p8u1p1Iz2PFdHk4heiCFWHPFSFOje0Ea+UmlAnXnKkacQswExONA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199021)(31686004)(2906002)(44832011)(38100700002)(5660300002)(82960400001)(36756003)(66476007)(66946007)(8936002)(66556008)(6916009)(4326008)(41300700001)(8676002)(6506007)(316002)(2616005)(31696002)(83380400001)(86362001)(53546011)(6666004)(478600001)(186003)(6512007)(26005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tll4ekpON2FXUlpRNUFXbzZTTXVBazJvMi94bjV1SURlNCsrV3N0SE5aNCt1?=
 =?utf-8?B?SE9zZU81YnhpbmJ3OGEyMFpoa1hOb0NCWnEzV0pLNW5Nc0M4Wm5zSGJvMFVF?=
 =?utf-8?B?WktqVFp5alk4bXpjRkhFWEhvWnJhZVlsS2FlSjZGUEd0UWxtOG5sOUpiQkZP?=
 =?utf-8?B?ZEN6RzFwcEZZWmtrOWh6KzVsdGZaNGxUaHNmYXlKNHhBR09HWU1SeTFjR0V4?=
 =?utf-8?B?VUFhUEtSOHdhYlNvM1RiNDBTaFJlUjNCWjB1NURPRjlSdDlNa2ZaZXlGd3dr?=
 =?utf-8?B?TnpYUFpySml4V3hBeWFNaTlUUGgwY2tscDVRazFuaXk4WEh2TmdtMmlrWWF1?=
 =?utf-8?B?clJITW1DeFluYmNPTGp3ZGFDcEUyTWhDUjE3TExuRzduTmtLWW8weThYTVBw?=
 =?utf-8?B?MTBMRlo0UWl0VmZmTnZ6bHo0cXJ6ZjJwMlE1eGZ1aWdaWnFuQVV3dnlaeVUv?=
 =?utf-8?B?M3VtdFJKa2svdzRkVE5Nc29YWW1QUzdoa0hBQ1pVSUNpYXRkZGhoaFpVcGRZ?=
 =?utf-8?B?eERMVU9nOWpYNTg1K1NWbjJMRDErZUx0eENITDBzNkl6cDRHUkpLdWVEWTly?=
 =?utf-8?B?OEpqWHg1WEZKS2h0QlBqTUVlNXVGbTYveEFNdXlCcS9CWWUrdTJNbXdNWWpZ?=
 =?utf-8?B?U094bEZTWHZQZVJlVDl1UXJxQ2RpVU44VzU4bllQemxWWFJvNUF1NHFOcngy?=
 =?utf-8?B?RndJOFR0YXRCRWVGK3lQcGVsM3pCVmJackRaYkZsQm16MnhWekQ2b1E5bnMy?=
 =?utf-8?B?S3JXK0VaZHVoTS9IWnVVbjVIWDNYQ2NGVHByaGhoOWpHaWNLc0ptcnZHNDJk?=
 =?utf-8?B?SWF0eCsxNzE4NXlSR3gwUGtVNklEditoS1l1RW1zVHNaUXU4SFpxUlgvY0Z6?=
 =?utf-8?B?Szh1THJWbi93WHRIb01BUTZxNDJKQ2taRXY0bVBIajZlb1RMb0VsdVdmZjl3?=
 =?utf-8?B?UXFnTjRXKzFnOUdEOTUzWUJzZXByUWp5dDZGQ0RBc1dlYXBMN3lISlBZNFhp?=
 =?utf-8?B?WXo5SmlFS2tscW1jamFLZ2FDbFVCb0JrS0NReEFoWVQ2RHk1MGtZditmcHF3?=
 =?utf-8?B?NGFtd0xPR0VFLzROSXlnaEZDNHU5VGwwNUppWks3Zkljc0JId04wVnF0TCtG?=
 =?utf-8?B?b0tZeXJiMzlzcG5kaHp3WlhQcm5CS1FKcE1QNFEwak50ZjBkVFBOaEduYUgy?=
 =?utf-8?B?MlB0Y3Y1NjYwd0N0dlZkQXFWbXhOdndHZkpoTC9xb2Z1MEZYdXVmZVM5VVV6?=
 =?utf-8?B?OWphTE1HalJZa1ZUdTRta1FSZ1lnV1A2bGFtRmpLZG55UFNONFRhNGFLTXQ5?=
 =?utf-8?B?WE45VjRrVkI0aVdEN2NCOXRxc3BDeWNlRGRWMmtkRmlVRnR1M0ZTMDc2WHFv?=
 =?utf-8?B?ZWpIdkNpSU5qdlBOVy9GSFFrRlB6UmliTHJ6REZkWVVzMDlwR2IyZk9YRStu?=
 =?utf-8?B?S2k4WnlLVHUzUnRCN2xmUjNxM3Z6REd5M0NTSzhJYWgwTm8rakcrazV2VFE1?=
 =?utf-8?B?THFHVUxzOHdtb3hJaVI0TTJnQlozKzlJNUpLeDV3T0hnQlhWQ3YxR3VhOEtj?=
 =?utf-8?B?OEtheWQzL005QnJUaEZnWWo2RXBCYkJEQ0RMaldrT2RwRmRLTFp3d3JhM29j?=
 =?utf-8?B?TGY0UHkxeDZ2VjlvRENBa04vVjFraUw5dlY4Y2hmdURNQkhMaHBDM1lQeHY1?=
 =?utf-8?B?eCszb0RlUXFuVEdzWUxQS0t5WTJqdTEyeW1raDhxdUloM1VxZHBIVVVKeTk1?=
 =?utf-8?B?QU90SFUwRzVxRS9IVXljVHoza2VxUnE3OUdkbHQ0Mm5KYjIrTFJQY0JPSWZH?=
 =?utf-8?B?V01WS0lMYkY4NWpJUmc0aHR1RlI3eE9DdkR4cUJLYjVnZnYzd0wwa3I2VEpT?=
 =?utf-8?B?WXBXTnNSVEJOeDRZVG1lekpMN21nV3AzRXI5Ly9NZ1Q4SlpXSHlaVjhlaDR6?=
 =?utf-8?B?MzR6Z05FKzM2bFlLdEp6L1BFakEwQjJuWFp2WTY5Z25NL2dxZkt0WmwyVGFW?=
 =?utf-8?B?ZlNKVlRWVDYxUnhKOU1aZDA2MFE3ajVCRDFKZkZtYTIva1pnOUN5YjZQVENT?=
 =?utf-8?B?TnpZRGJDUlVBYmtNb29makpaeEdETlQwTTM0enA4WHFkS1BldE12MDVvcUx3?=
 =?utf-8?B?MDJReG1neElTMytGc2FJTkkyTHpubGdCQlhOd1V5WXJNdjhkSk9iSzZhRUo4?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be69f94-85cb-4307-a220-08db352d4d95
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 16:54:49.8721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZ09pTkb2o6pM7Ss8X6zLFYQcKrcD6lLHD38fXuUQMn18PPJnM5mZ2df0jg762B0M+yCYZ/AcU/PgsRh1068msMpJkY7J9M2HlG5NoKvGGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7767
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 4/3/2023 8:18 PM, Alex Williamson wrote:
> On Mon, 3 Apr 2023 15:50:54 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>> On 4/3/2023 1:22 PM, Alex Williamson wrote:
>>> On Mon, 3 Apr 2023 10:31:23 -0700
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>> On 3/31/2023 3:24 PM, Alex Williamson wrote:  
>>>>> On Fri, 31 Mar 2023 10:49:16 -0700
>>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:    
>>>>>> On 3/30/2023 3:42 PM, Alex Williamson wrote:    
>>>>>>> On Thu, 30 Mar 2023 16:40:50 -0600
>>>>>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>>>>>       
>>>>>>>> On Tue, 28 Mar 2023 14:53:34 -0700
>>>>>>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>>>>>>      


...

>>> If the goal is to allow the user to swap one eventfd for another, where
>>> the result will always be the new eventfd on success or the old eventfd
>>> on error, I don't see that this code does that, or that we've ever
>>> attempted to make such a guarantee.  If the ioctl errors, I think the
>>> eventfds are generally deconfigured.   We certainly have the unwind code
>>> that we discussed earlier that deconfigures all the vectors previously
>>> touched in the loop (which seems to be another path where we could
>>> de-allocate from the set of initial ctxs).  
>>
>> Thank you for your patience in hearing and addressing my concerns. I plan
>> to remove new_ctx in the next version.
>>
>>>>> devices supporting vdev->has_dyn_msix only ever have active contexts
>>>>> allocated?  Thanks,    
>>>>
>>>> What do you see as an "active context"? A policy that is currently enforced
>>>> is that an allocated context always has an allocated interrupt associated
>>>> with it. I do not see how this could be expanded to also require an
>>>> enabled interrupt because interrupt enabling requires a trigger that
>>>> may not be available.  
>>>
>>> A context is essentially meant to track a trigger, ie. an eventfd
>>> provided by the user.  In the static case all the irqs are necessarily
>>> pre-allocated, therefore we had no reason to consider a dynamic array
>>> for the contexts.  However, a given context is really only "active" if
>>> it has a trigger, otherwise it's just a placeholder.  When the
>>> placeholder is filled by an eventfd, the pre-allocated irq is enabled.  
>>
>> I see.
>>
>>>
>>> This proposal seems to be a hybrid approach, pre-allocating some
>>> initial set of irqs and contexts and expecting the differentiation to
>>> occur only when new vectors are added, though we have some disagreement
>>> about this per above.  Unfortunately I don't see an API to enable MSI-X
>>> without some vectors, so some pre-allocation of irqs seems to be
>>> required regardless.  
>>
>> Right. pci_alloc_irq_vectors() or equivalent continues to be needed to
>> enable MSI-X. Even so, it does seem possible (within vfio_msi_enable())
>> to just allocate one vector using pci_alloc_irq_vectors()
>> and then immediately free it using pci_msix_free_irq(). What do you think?
> 
> QEMU does something similar but I think it can really only be described
> as a hack.  In this case I think we can work with them being allocated
> since that's essentially the static path.

ok. In this case I understand the hybrid approach to be required. Without
something (a hack) like this I am not able to see how an "active context"
policy can be enforced though. Interrupts allocated during MSI-X enabling may
not have eventfd associated and thus cannot adhere to an "active context" policy. I
understand from  earlier comments that we do not want to track where contexts
are allocated so I can only see a way to enforce a policy that a context has
an allocated interrupt, but not an enabled interrupt.

>> If I understand correctly this can be done without allocating any context
>> and leave MSI-X enabled without any interrupts allocated. This could be a
>> way to accomplish the "active context" policy for dynamic allocation.
>> This is not a policy that can be applied broadly to interrupt contexts though
>> because MSI and non-dynamic MSI-X could still have contexts with allocated
>> interrupts without eventfd.
> 
> I think we could come up with wrappers that handle all cases, for
> example:
> 
> int vfio_pci_alloc_irq(struct vfio_pci_core_device *vdev,
> 		       unsigned int vector, int irq_type)
> {
> 	struct pci_dev *pdev = vdev->pdev;
> 	struct msi_map map;
> 	int irq;
> 
> 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX)
> 		return pdev->irq ?: -EINVAL;
> 
> 	irq = pci_irq_vector(pdev, vector);
> 	if (irq > 0 || irq_type == VFIO_PCI_MSI_IRQ_INDEX ||
> 	    !vdev->has_dyn_msix)
> 		return irq;
> 
> 	map = pci_msix_alloc_irq_at(pdev, vector, NULL);
> 
> 	return map.index;
> }
> 
> void vfio_pci_free_irq(struct vfio_pci_core_device *vdev,
> 		       unsigned in vector, int irq_type)
> {
> 	struct msi_map map;
> 	int irq;
> 
> 	if (irq_type != VFIO_PCI_INTX_MSIX_INDEX ||
> 	    !vdev->has_dyn_msix)
> 		return;
> 
> 	irq = pci_irq_vector(pdev, vector);
> 	map = { .index = vector, .virq = irq };
> 
> 	if (WARN_ON(irq < 0))
> 		return;
> 
> 	pci_msix_free_irq(pdev, msix_map);
> }

Thank you very much for taking the time to write this out. I am not able to
see where vfio_pci_alloc_irq()/vfio_pci_free_irq() would be called for
an INTx interrupt. Is the INTx handling there for robustness or am I
missing how it should be used for INTx interrupts?

> At that point, maybe we'd check whether it makes sense to embed the irq
> alloc/free within the ctx alloc/free.

I think doing so would be the right thing to do since it helps
to enforce the policy that interrupts and contexts are allocated together.
I think this can be done when switching around the initialization within 
vfio_msi_set_vector_signal(). I need to look into this more.

>>> But if non-active contexts were only placeholders in the pre-dynamic
>>> world and we now manage them via a dynamic array, why is there any
>>> pre-allocation of contexts without knowing the nature of the eventfd to
>>> fill it?  We could have more commonality between cases if contexts are
>>> always dynamically allocated, which might simplify differentiation of
>>> the has_dyn_msix cases largely to wrappers allocating and freeing irqs.
>>> Thanks,  
>>
>> Thank you very much for your guidance. I will digest this some more and 
>> see how wrappers could be used. In the mean time while trying to think how
>> to unify this code I do think there is an issue in this patch in that
>> the get_cached_msi_msg()/pci_write_msi_msg()
>> should not be in an else branch.
>>
>> Specifically, I think it needs to be:
>> 	if (msix) {
>> 		if (irq == -EINVAL) {
>> 			/* dynamically allocate interrupt */
>> 		}
>> 		get_cached_msi_msg(irq, &msg);
>> 		pci_write_msi_msg(irq, &msg);
>> 	}
> 
> Yes, that's looked wrong to me all along, I think that resolves it.

Thank you very much.

Reinette

