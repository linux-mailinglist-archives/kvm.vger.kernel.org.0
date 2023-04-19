Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8224D6E810E
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 20:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbjDSSOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 14:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjDSSOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 14:14:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1F69741;
        Wed, 19 Apr 2023 11:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681928043; x=1713464043;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gLlzJeBxZpHSLZ+pUMcqAY8y2lwzwAL+3HzMeHfw1Jw=;
  b=PFCeHDa23nh4ctY6zEAwcYoO8P2yQ0L6Ejyq8edPjBc/7Y50O5WgVGM+
   Uo0E6SvNSsF0z3GgkilZF0BjAVAeaOVEyTlimDmL/nw+DWF+cnmrmwYwB
   DFzRxp3dasj/OfTX+8TYOOoomFgeu8VvMV5Lq46eEHBVmenKvjdFBAMOQ
   DZUl41KwM/Re8sCE+06QxrsuExEjrgFLLzEx6qmYhOdsqcbVx7IIPFP/E
   Sf8ZruC9XS9nT63nBlN11RN5/pf00KzHWSLniPYW0fu6VSRJXGFN/x9Z/
   YsgCf+6C5+cijNUMtiC1q9NKQw2AMD4acy4wwZ0FbOc+fq3W2dCMdtKNh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="325132666"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="325132666"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 11:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="780932521"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="780932521"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Apr 2023 11:13:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 11:13:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 11:13:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 11:13:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFR8LIhFc1niWuShrtW33OsKkf1i2Vi6X11CaNXrogIazNbJ2b6/USSSfT+RPt6ji3VkZQelWg6JBbhYaA57F7a8h/Wvsv0YbAacR25a3abaaXsnVZq3FcYSM71yt7scGNLpJYuTTRk3auFvE6PBlmq0U+Qx+GSqunMCcJL/51b8FqXdCbqsjETGDa/kn5HDuu91a/m2aScpgcxiyiDlY4JX91AVSlPg5Olku/WNb/k44GMWGsuPqstK+Aek8EUBMGg61JjzG9mAbjC7uyxzC1xnxLON4kUOjj9lBbVpSCo5rBrcLrPmsvJD4bmgGICPritDc2c6UaHfML80BP8APA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3NErtJLfIP3BMswSapAo1+DdfKUlkmG1DRQLzeuTtY=;
 b=RKsGJpHkU1QO0xMrvKoeexjHyoBlidq371FJ2UM9Kb2uoAQYIyvh+cAWoewn4ofJxAPJrzJvuxHRV2IRK3tKhL+JN+WUcgWFnRZA5klPul+0GR5Nfn6DMQbke1Vh+7ELhfAnttxWf3eX4gXQH4r3wFSbF9AQfTuYKEdJBp6qDDL5HWcAluxJ2ioYwkrShybnoOHcTBHNQp5AUyjWelpLMfmpATuDwPGHEctMLqMoyf3TCOOqW00IKr9cCfoz5V2OI8T12GB5nKNykdl3VkQaJwwZ90yTVpuvmy2WxVkvcCchxEWpLQekDWthxXqzo41dnHMpLTZkcmPXUpZChkxI3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by SJ0PR11MB6671.namprd11.prod.outlook.com (2603:10b6:a03:44b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 18:13:33 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::4bd:cce2:58ce:cd6b]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::4bd:cce2:58ce:cd6b%3]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 18:13:33 +0000
Message-ID: <f0d22db8-213d-92f7-963a-9d015c0a9d79@intel.com>
Date:   Wed, 19 Apr 2023 11:13:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH V3 09/10] vfio/pci: Support dynamic MSI-X
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
References: <cover.1681837892.git.reinette.chatre@intel.com>
 <86cda5cf2742feff3b14954284fb509863355050.1681837892.git.reinette.chatre@intel.com>
 <20230418163829.149e8881.alex.williamson@redhat.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20230418163829.149e8881.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:a03:255::12) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR11MB1862:EE_|SJ0PR11MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ad3bf23-3d87-4407-bad7-08db4101c8f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qahYQ1wHKGmZz1t5b6wmIKh8eAvYhxUF08LTO1ydSd6Vhu89vUtb+PN2ipcWlKfF4hno8DCxy/HGjscr8NfQp8H3iQ2O+gyVpVDjT+vqgU3OggE+TeG1PMt35RpzzEp9haw0bpt7w19YUltSy4NtmY7GfpdhQiSyanjARDrrMw15FM6etM9YLRFQgaeB34L1uusStb7VUMKIOT5+fvZuhydIlLCHtAvIAe24dLVZSkmcY2sGjc5N3AbUQ4rla7QvmRyvcI08C+iYMNGs9hA2mwjDZ378miYsJ2ub//GMSeD4RaQXwj5eYVlDj613aFwR2L8QQJI2zF3hKAmtbZYb0lBTKGzg+VBTfv2MT4oZJEUqSpgiCdeQ8gOKX0fGBIfeQTs4ZpW327azbrtYx7KmVVwDSZD4RYyCXW7LO2CDF4GimhuzgdedGBl+dkDOpte2WZ+39AH+tXt5z3/1CW766GCKuFIkWgTv2lqF78+tijS/N/38WeiLoZ77sq5Nbg8fw8DggY1ae0/sgBmGpmiee+0dndGZ95MUQklZZdzG9WL0+QrxZ7ZGxuYwArejADTtvVKm0D/mSi8/RegyjFpuDc2GtQ0oY3JDso5jNwOyIh/o7xcx4R1v9haKd2m+1U2fFzAoP5elICem+tNbhN+BQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(346002)(376002)(396003)(451199021)(38100700002)(8676002)(8936002)(82960400001)(41300700001)(5660300002)(4326008)(31686004)(316002)(6916009)(66476007)(66556008)(83380400001)(66946007)(2616005)(44832011)(2906002)(186003)(36756003)(6486002)(6666004)(478600001)(26005)(31696002)(86362001)(53546011)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzFlUG5UZ3dqRm9kRXk1Qm9pTWRqRmU2cVZzZGZ3eWl0OUFueFdZZ3ZSTE5L?=
 =?utf-8?B?YmhqRDZoaFdXZWY3cEFEMlJIYnJWamduNHFtd20xanBBQ1E2WU9QbWVseExS?=
 =?utf-8?B?aDdpcTZHMUQ4enpVOWFORzdoUnBtamRGbG1vQThta3k5c3ljbGQyTHlHRDA5?=
 =?utf-8?B?R0NTQlNlUFY4WU41QWs1R0Q2czVRKzN0bHVGaDlrRUFFWUlqYmV2eWUzTEtJ?=
 =?utf-8?B?cFZDWkZXSWthUkE1ZHp6RUlHaTFkL1FXNjk0Qmk5c1NoRW0vN1Qya0R1cjNn?=
 =?utf-8?B?WnRJWSt6cnB6eGVOVmpURE83Nkw1QW51TDFadDB3YUdiQk4yNmhYaGRXRmhN?=
 =?utf-8?B?aTg2VU9SdE03aHc1UEc3blowRzJ1UlBLdlJQWXVmdzRmemRQZ25rWU9GUWZU?=
 =?utf-8?B?K2R1TnQwZWhXQ2xnR0hjUHd2a25IOFd4a1h5elpPQnVRNTJwV1FoUllvMHRa?=
 =?utf-8?B?Mk8xektYQ29sbnlnTGUrVnhGQXVQeGlaZnQreGJmMWw3a0RMUGtOb0l6bnM0?=
 =?utf-8?B?c3pSbisxMCtXYjJFNnVsejViblZsaUpuMmhxMUV3dVdlRzNGTUN6ZUgrMDVy?=
 =?utf-8?B?VHVPNi8wQjhuL2dDVXJKeXZ3NEpWQ3dHcU9sbGhtN1M1cjJwc2ttN2pyT3BY?=
 =?utf-8?B?MlBVV2N3SnBOdkhmTFF0R3Qxc0ZMZitLcjFFaUZxMlFQRVZTcWVNd1N0Zlln?=
 =?utf-8?B?ckVUaW81ZXpiZGRmbTVWbzVhUnBhWm02N2dMbElVUVo1MTRpeEhEb2NmeUx6?=
 =?utf-8?B?K0x3dVQwd09oSzNyRkdmY1ZIUW9YTzV4NW92K0lITHZWYmkrU1hwU25rMmJI?=
 =?utf-8?B?L1Nlc0dCcE1mSlJHYTJzaVVQc2FWMUdoYWREZlVlYmlUUnJrbEkvOElXNlRS?=
 =?utf-8?B?ME44dXVXaTBNcFArVTRyRUNvbkl4N1BiNGVaaTNuVDF4RmJsa3ZvOGhDclNI?=
 =?utf-8?B?TTNCbGtmTzl6Wk5aVmFtbWQ2a2gxWTVRS0tzS0ZPQTk4aE1qRjBQZzZXT1kz?=
 =?utf-8?B?b2lIR2FtQVplV1Rsd2xOSkNoYkhidnNacWdtL2IxSlBrZ2lseGdBdkRsSU13?=
 =?utf-8?B?T0poVDNpQ1ZsblVsZjdsS1g5WDh3Umo5TE94YThHZjYrVExscEVmVURhdW0y?=
 =?utf-8?B?MHBSUVpUZThBb2o0WmFCVmRRN2dJeVZoQld2Q09jdzBoWG9XNTBjSHNLc3VQ?=
 =?utf-8?B?R0RWYmpYM1IzZzRQaHd3OUsyUlU1b3N5aGxMUHJmbGg0OVRwZ0tlb2pTaXd3?=
 =?utf-8?B?REpyOGsyUVl3OHExNFkyZU9aZVQwZ0JQM0xNREVwaHplRHNMZlB0SWhHdmxs?=
 =?utf-8?B?UklpQVV6SjFVNUZsR0g1ekhPNHhyS3NOc3pUVXl6MHcyZUJXZ3RRZi9ENHpy?=
 =?utf-8?B?ZXhIRzZydDZ3RUNMSTJ1Q0J0YzF5cEY0c25PVlNtMmNUYWJDRzY0a0RrWlpV?=
 =?utf-8?B?T3JRRjU1aWtNYSt2elk4Zi9XVE9BS1BsNVJiNk9jQ3VOTUJkTTloSWFFYmw5?=
 =?utf-8?B?NXBKaFZQczI3eS9SKzBSNGhjMlhQcUV4Zjh0MmhGMHlWYnJrTjYwRmtoUkNR?=
 =?utf-8?B?am5BQ21kd0dIYWU5RkVRc0N2SktiaXRjUXJMVEZJbmlsdG9zSHJDMnF6L2RK?=
 =?utf-8?B?UlJXYjhTQWlka3QwQitHTktWaEM5aWFsQ01mS3UyQzFrTGtWZVRNb2s0QWd5?=
 =?utf-8?B?YVhxZkpUaDFNL3ZSdWJXQ28xZ1o2YkJhcGF4bnlyQ1N0R0xYN3lqRkFrOU0x?=
 =?utf-8?B?SndRSWFITjNGOXV0ZFduTmxoWVFuQUF4MWRtenBJU0pia01qQmF5N1IzcDls?=
 =?utf-8?B?RE8zMnZDVmVtdWc1a3VvRDZPb3ZsUkNGV1NFM21GWTlpMWh2YlBBMS96SkZ1?=
 =?utf-8?B?S3lWcDZrNW52WC9nTWVwM1ZFd0J2Q2JSdEgxQkVBWGNTK0VUelJqeGs2ZjFT?=
 =?utf-8?B?WTNnN2FMck5VVDkrYzl3YnpHajd3aVBxQzBMQmVqcURmc2RYY3NNWmhEZThW?=
 =?utf-8?B?dEFScml3UGFacUhPVlBET0ZNUXhFMTEvdkpueG80VmpVdmJPRitTcmUzRm1m?=
 =?utf-8?B?QjEyREtnd3hXam04WXp2Y2ZueHhtZEpqUUZkZHJwMzdYOXQwYlc4K0pqYTI5?=
 =?utf-8?B?Zmt4dFQ2c2JmYnBNVjZGQlVHWHh1M0orZmhuOUdUeTdsTkZjYU16QTJoaGF1?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad3bf23-3d87-4407-bad7-08db4101c8f4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 18:13:32.9650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXaDQz3LfA4ZVVZ9NF1vzODtk/zzSuPAV09W6vOQ7UmLy3Jiy7zZGRucy0q011IfwPNtEB1gtDWYozWzue7ohTSMGyNLSaeDpWeKoTtTtDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6671
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 4/18/2023 3:38 PM, Alex Williamson wrote:
> On Tue, 18 Apr 2023 10:29:20 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 
>> Recently introduced pci_msix_alloc_irq_at() and pci_msix_free_irq()
>> enables an individual MSI-X interrupt to be allocated and freed after
>> MSI-X enabling.
>>
>> Use dynamic MSI-X (if supported by the device) to allocate an interrupt
>> after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
>> the time a valid eventfd is assigned. This is different behavior from
>> a range provided during MSI-X enabling where interrupts are allocated
>> for the entire range whether a valid eventfd is provided for each
>> interrupt or not.
>>
>> Do not dynamically free interrupts, leave that to when MSI-X is
>> disabled.
> 
> But we do, sometimes, even if essentially only on the error path.  Is
> that worthwhile?  It seems like we could entirely remove
> vfio_msi_free_irq() and rely only on pci_free_irq_vectors() on MSI/X
> teardown.

Yes, it is only on the error path where dynamic MSI-X interrupts are
removed. I do not know how to determine if it is worthwhile. On the
kernel side failure seems unlikely since it would mean memory cannot
be allocated or request_irq() failed. In these cases it may not be
worthwhile since user space may try again and having the interrupt
already allocated would be helpful. The remaining error seems to be
if user space provided an invalid eventfd. An allocation in response
to wrong user input is a concern to me. Should we consider
buggy/malicious users? I am uncertain here so would defer to your
guidance.

> I'd probably also add a comment in the commit log about the theory
> behind not dynamically freeing irqs, ie. latency, reliability, and
> whatever else we used to justify it.  Thanks,

Sure. How about something like below to replace the final sentence of
the changelog:

"When a guest disables an interrupt, user space (Qemu) does not
disable the interrupt but instead assigns it a different trigger. A
common flow is thus for the VFIO_DEVICE_SET_IRQS ioctl() to be 
used to assign a new eventfd to an already enabled interrupt. Freeing
and re-allocating an interrupt in this scenario would add unnecessary
latency as well as uncertainty since the re-allocation may fail. Do
not dynamically free interrupts when an interrupt is disabled, instead
support a subsequent re-enable to draw from the initial allocation when
possible. Leave freeing of interrupts to when MSI-X is disabled."

Reinette

