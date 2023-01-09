Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AD3661DE8
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 05:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbjAIEfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 23:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbjAIEe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 23:34:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09295F55
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 20:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673238359; x=1704774359;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2Z5BrFoEXcGXQF1RUyj+pQ8GiLO29VqcaBIwjwdwc0Y=;
  b=iyR1wA2kWo56YGVqj1JKlq5YP6u/B+GyqZ1UErCCYwRdkwuOuh27iTjW
   G0bT2VTz1nkfe7xnqnuacY5yWGbufflhrS9zFSMh6246VGcU1LVbb/qEd
   SC7af8H43IMFYS7ZCZtZvOvvR44mGMULrua54FFURhR2JqVopgDc9MyTz
   zccryPGWej61bqxcK2Z5N19jljN5CDIDizRN/YbcR9vL8rFv1FQW6+KKY
   0xe8BUX4GRyMIry+LVJ1td5jv7ci7HDm5u4CZ9JsKPGipYBIvW1vL8VvA
   vS6Aj7EnuGLLGrH/E9xHAOUlD+DXO4Ee9/qo2i6DU2NfQjnLd9v5GN9O/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="324037476"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324037476"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 20:25:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="780561234"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="780561234"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 08 Jan 2023 20:25:58 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 20:25:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 20:25:58 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 20:25:58 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 20:25:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4dEXu6pE8AM+h+2hfCbysVB+qzByd7gH9oN6GDKF9jD9BeEe2Qfbn+3P1aR9DcgWJiQOKja0g/v9T9A6Ervqq/0OtitaNsUoDYRsIibAkhzCQov1O9KyPmUeXTdCa5D0ifyheI0Zq+5T50bZEFRSl5jVAYGPU0Qo/BayM3AW8ah+bWswaLBAn9PHtQAGSONi0QqUbAviEcevzQj1aBfFsxsQhfQ3Dt6gOT+OsZohzmJGLcJpKmwbhGxYJLTgw0D0KzS3n6XTevYxvkFQW0kPBUp1hlUiHfvb5o/meZp8UgbalPwq/WKoz1vQIjqRHYpcUOPoHBE8+TIsFUGCySNTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjXmX46zJkYHerwBYk6AOGfeAVFxkV1PY80Xmd3S+Cg=;
 b=IflcojgGF6L9ElCMIFTcgEROG9434jXXgZLaXeEx3tfbWqOLix1Oe/U0IbaW8FJDZ/Oa35hQHA+mtj+fV27geRafmvvOEqMbiQ+7Vg4+9EFx6j5JEdaFp5TDY99WmBx41fj01wUjEEV2BSWmr60+J1N2dUHcSVzonfSBiiC72oGtHlL4DAY2yvHf1gaCsnbRbxulRQwPmHAP0LR1PfGA2Y1hhXjBH/7/pRbmsKenYPb1StAlQElFc1iOVWMr2AeAMgn0QB9JdaACJG96aq79NRi4Q11C8fPdHrAyibmYJQ7aagoaqk0u0g8lapFzNi3XPD8zytYL0Ep4RxnLiiqgCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6526.namprd11.prod.outlook.com (2603:10b6:8:8d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 04:25:54 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 04:25:54 +0000
Message-ID: <705b848a-1502-99b9-f95a-dde64e448aa9@intel.com>
Date:   Mon, 9 Jan 2023 12:26:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-6-yi.l.liu@intel.com> <Y7gxC/am09Cr885J@nvidia.com>
 <6af126f0-8344-f03a-6a45-9cdd877e4bcd@intel.com>
 <Y7g2WhrDFHpPPsaH@nvidia.com>
 <17e6b31c-1149-018b-e76f-f3c82e702144@intel.com>
 <BN9PR11MB52769A6BCF689E45DBACD0AB8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52769A6BCF689E45DBACD0AB8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB6526:EE_
X-MS-Office365-Filtering-Correlation-Id: da911407-d578-440f-7de1-08daf1f9990b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +cy+ZrWahcf1tIDr6GFAW9mugsgPyKfUAfDDRg1oN0EUAZ1mrvUwZPb0Vm+nbyBKuTQpRsSZppDK8V9+cWdoBSwfVT+KLsYFaLZLaarJSWugC/iwUIyYPztd5UB8CK9EhOvzfQH8EDssv7mMKKPIvozL2PjSP6LV9GEfpaSowpCs87oU/jHFCcnxyngL1LYuCbmrEPufW7UBX0bNhLShVZQka8i18D9ASL7TK59N6n7J9L5bCVwC2lDdDXu/8wYDFuIbeBPDiUOIZotkpxgRcVqh7PnnKWk14WdsbUo1Q6+oPyZDnNIWDlxvfNa+ApgfL9F/36VnAsFeQBgrZrL9DF+phDW0Mjb7kZpcGjx2133gvcNosEPJjfwoER7ErZVK+wYTru3l6jT01u46mxAVkpTDcBAajIXA8cAQ5iBlQK5jRAtO9oI6Q29jl3GnaxTCQrhvRt7V171GgFuFj14uliK0fb7wwdbGQDZRzhM4h/+qSOUMkXRoKsx0BcRk8LzVvUH6x5dCNrjM71UcWlIblzNKTwQb1qHnXm4aZRh+UsG9u/nYfMUV3ZN+7hxFObGCaByeKXbV8ozIQiX22i7G5jfjLScVWGptw+kAogzACgHfiKYyirSa9FMV50b2YyUD7telk8ARCEDps+bTvLNtlltTFUUR0yWbvlAPqJ25wivZFvs0NfZJvWVXuO5UWvRJdxI2P1jHjnRlqzLVqZcAUrqDIF8+wWvIr+oWtuzl+Fc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(53546011)(2906002)(6506007)(6486002)(478600001)(186003)(6666004)(6512007)(26005)(31686004)(54906003)(110136005)(316002)(2616005)(36756003)(66476007)(66556008)(8676002)(66946007)(4326008)(41300700001)(8936002)(83380400001)(5660300002)(38100700002)(82960400001)(7416002)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU05ZE9ycTZMOXBYdm1KSlFLTGVMWXZlZC9OL3RKdHBkTGFrQ3dOM2ZwaWdM?=
 =?utf-8?B?N2lxdHVVd2NZdlNmVHBJMVJ2ZmZoL0cwSDh5NzBmNGJJSDVRMlNrYjZuTU1s?=
 =?utf-8?B?UGZKQUNrQ3BHVkNwbFRkVVpqY3E5UzcyZTZVQ2k4bG1kckd4RUxJWnVMOEwr?=
 =?utf-8?B?QWY3NXoyMDR4dUl2ejErUmdKMDNQb0o4S2dMNHM5aHNob0pZcHVxR0wrcklO?=
 =?utf-8?B?WFhqMEkySjZSWWg5Z2ZGaFNvQjM1UXkzSDlLcHpISnllZW1aNUZNVko2VGlR?=
 =?utf-8?B?dTJLc2UzUDJ0SEhiZCtHd2N3bEVUWU54MzF0ei93T1N0TEJyelJOME42RytJ?=
 =?utf-8?B?SlgyYjRaeng5ZTJpZEtLT2oxRWNRdG16cExMWDBYaUVwaVZ6Y3IvZ1RnOFU1?=
 =?utf-8?B?YkJxWXJ3OEtWb0pTb3NxUjdLd21NK01ma2FxZ3MrVFdMYnRDL2JnYWNtTWZG?=
 =?utf-8?B?cGh2OW5Tald1TkVDTTcrN1hTU2VKNWhUSDlJdDd2Kzg0RGo2Q3E2ZUxGcXdN?=
 =?utf-8?B?WHMyamtlMUJCNTBDalZQNEJKMmRrWVFBejdScE1KNmxiT2dkS0RsbnBVVHg2?=
 =?utf-8?B?KzVEQkdIdC9vLzdZZmdmdUNPbDdaQnE4ZFVvYjhwSGxyWHFoRnp6ejNQTld1?=
 =?utf-8?B?VU9UNXZ6QlFlQXZJT3NOalU1QVVmZWhoUnQvbFUva0FublR4VG5VSUN5RFFF?=
 =?utf-8?B?TTVYN3E1Q3NtdVNabmNxTzlqa2lmeGhDSEhZRmppMW1BNXdIRmpHajA4bW9E?=
 =?utf-8?B?SmpZYW5PTi9EcTIzL01STWF6ZzAxVStFWGpuYi9aRklpMDBsSVlYQjErSDF0?=
 =?utf-8?B?T0h3Qzczd3Nta3Q0d0xHeEdqS2xyK29xdGI2S0tJMm9kWVU5NkVYQmZhVHd1?=
 =?utf-8?B?cVFldnB3ZGRuQ3F6V1FXOTkvTUFFVUpVN29UbXlGSlppUkJ4cUU3SWQ5cFNZ?=
 =?utf-8?B?T1J1MlJ1MzMrZE1DcEdVSXNGUmV4bmpkWVpGb2pZaG1zK2hRVmtNVzFRQXh4?=
 =?utf-8?B?d3ZLR0VVZ2tJakpHU2VGWXZKNVhVUnJKajJBY1NuNTVJaEtHNGVFZVkzaFYr?=
 =?utf-8?B?dW5SMy8vZzNNMitsWXl6Ym1vYUtzNjRGY2VJZSt5NDdOQ1hlcTVjUVVpR055?=
 =?utf-8?B?ZXNGR0Fzamc4THFoOW1TSFBneEdFK0lqNGkrVWl6K3JEcDhWamFjbDRGS3lN?=
 =?utf-8?B?aDI0YVpLa0Y4ZjU5V0IzRmpCdkQrZ0hXUktmNVZSOXlZTnA1T3IwZjZTZEVC?=
 =?utf-8?B?UXIwZTlsTFJYQi9zaFJpYTVuckgydktyV1I3TEk0ZENjWXF6QnVRdUZJS0Zs?=
 =?utf-8?B?d2NueXZGR2JOT0hUMTVUcGFBMDAxMDZXNkR4VCt3SWxCUFNhUXVTRFh1MDBx?=
 =?utf-8?B?V0hXb0ZwR0pnaEI0ZmQyekwyOFNuWGxxTnh0dy9XMUMrMlI0OXpMa0xpekY0?=
 =?utf-8?B?cXhmU000NnVLYktla1Y5clRiTkRGUUwzVTFmSkZQOHNOejhvVVJZL2ZoOGNw?=
 =?utf-8?B?clN1RFFPSTFYaVg4WG9CUTJ0VkUzMTduWStCV1EwNHVMNFd2dTNqVzgxUjZo?=
 =?utf-8?B?RHpnMDhyNm1uMEdiV3dCdGpNbUwxTzNGNkU2N0ZNZU1OakpXOVZXZnpFNU5C?=
 =?utf-8?B?KzJJaGxMU2VFcjhBMm0zNmZrNlJ2QUhTS0UwaTJhYVpnQ3FIN3VsUFhRdEYx?=
 =?utf-8?B?SWVLWFF0MGEyMDdEWnU4eXdXVjdoT1Bkb2l1SElQVjRvaGtyTk1QWVhRMGJG?=
 =?utf-8?B?MEpSVWxiaGhDcy83d3Y2eHEvV21USVFrS0ZMbUVibEEzdmJHZFh2SjFaT2Ew?=
 =?utf-8?B?V0MyZktCVWkvRzBBcHJKNXphMENYaVhmS1lVeEdtTmFqNXJ5WjJPNS9tSU1v?=
 =?utf-8?B?NFZhNzBaOFl4Rmo3SjdDNFBtTCtEb2daZ2s2dHFhZU5yMGhnK2dpaXNmNmFn?=
 =?utf-8?B?WVp2ODZUcjJ5Zm9kV3BxMlVTMkJMMW1QNVlWa2ZWZ0Z6MHJTSnNodWJyUmZP?=
 =?utf-8?B?OWZnaDJYNi9UOGcrbCtkcFR6WTlVRHUva0hzajI0NXBRYlcrMVZkSmlRc2Qz?=
 =?utf-8?B?MzJLcWRZaUNpcmxpaTRtWUZtN3ZaeEx3WTF4bG5oVzVJbU1jd1kvQlJreUtq?=
 =?utf-8?Q?vE4bqJdYm/8GaqJgrnnd2asjW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da911407-d578-440f-7de1-08daf1f9990b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 04:25:54.4569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ew2YaSp+M3AKWKFzn3SMYVapuvDQYWFfJnMfhDSdHll+BJ0pUSys0Vl8iE8KfgDcOEZKG47OeE7h9C8btDyZlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6526
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/1/9 12:17, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, January 6, 2023 11:05 PM
>>
>>>
>>> Probably kvm needs to put back the VFIO file reference when its own
>>> struct file closes, not when when the kvm->users_count reaches 0.
>>
>> yes. Seems no need to hold device file reference until las kvm->user_count.
>> At least no such need per my understanding.
>>
> 
> looks just replacing .destroy() with .release() in kvm_vfio_ops...

yeah, this seems to be the easiest way. Let kvm_vfio_ops implement the 
.release() op. Other kvm_devices won't be affected.

>          /*
>           * Destroy is responsible for freeing dev.
>           *
>           * Destroy may be called before or after destructors are called
>           * on emulated I/O regions, depending on whether a reference is
>           * held by a vcpu or other kvm component that gets destroyed
>           * after the emulated I/O.
>           */
>          void (*destroy)(struct kvm_device *dev);
> 
>          /*
>           * Release is an alternative method to free the device. It is
>           * called when the device file descriptor is closed. Once
>           * release is called, the destroy method will not be called
>           * anymore as the device is removed from the device list of
>           * the VM. kvm->lock is held.
>           */
>          void (*release)(struct kvm_device *dev);

-- 
Regards,
Yi Liu
