Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B98459CBD
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 08:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhKWHaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 02:30:30 -0500
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:36242
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233737AbhKWHa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 02:30:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0gCLJcGzRpsuNoACWspjmRmDwn8avwCIQZEZiSa0DGbubzl+R/zASe3FaqdMlVbSfBV29tr9D02zWp+J4ppi4WsqMuaENoYPW5igCY0VtWWLu4DFKE2FKquMa8ZaRfdgJFddQinJQRPS4PjMtg6pnKh2fQcl+GMTiZ6/XSophJTfZ4JbqCoR591qVBLd8o+9oBnm3J6DsjajtMe3eAx+sBcDqNmqNvB0BvWcIZBicP0u1SQGI33rJsiAJN2Zex99NFgYMwD9mkA4qzT1UDjGzFfaSWIQ84fD/BmcBkKw7f0OMbVtg6ZHfF7oqQ2gD8KmpyzGVCnpysYhd6fqJZ1uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CwqKPDBOYIkBSYK/p/p1lc5YN+9OM9T3xt+cqp/Bns=;
 b=aiQYD8RQJajfXjzZXA1OnwejLEl23sE3+z7t0LEQai4cHIqH92pqqjEbUpGgxJ5jvhnAEPJZL7/mMyxPrb9tzr/79P8RIagt2GuhIOJOljjSEvy/pNkGiJoa2WR0iE0Cy7JoigXEPjq0hpWiDaNFAqJ96d8akh0V0x1FaVHI2FbPQg7TjBcUuJQ+H6zg66FIYd5lxNpgjppftatdLiXmrQi2R/uoK5cSUzhfG3KZO1p+MyWFGy+nqItlrwBN5aXSJk8RHt4ju1ADEgB+10ZxpCt7epeyO4BjEYbiRP6f1sm0/xnQM9lRG/+jlyhal3PrxQk5eEtArRtGGke8wQD4Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CwqKPDBOYIkBSYK/p/p1lc5YN+9OM9T3xt+cqp/Bns=;
 b=QyLwGMcztoo4MXMydBH3MFNBkXROmTpmHD5fFY6yURn9m2f7+UTH7SWHmZeSNdmRrK0bwMO4i6k+Vk5LQrrAAcoDBa+B0AVzzQ7CRCakdHU76Y1nYvUzvLYLv8uHtfcVwtusxse7A1VYip4N9NMIq46gRv6Wsk0K3V2pH9xSI9palo6reb4rHJpfX9o+xG9fl/gJF73/rX4S3NHzcuQTmoa89+SOb1sPuAi1qOyTVS/mJb6/S2s+ERoti4T4RabtMqS22OxApRVYKELnGmqq3Wiu36Ij/yxQbZ1/5jVDJyg1xn0iWXtwtK2k1X30SkH6uKxu7Ibn7BAd2KJtR3PWxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2937.namprd12.prod.outlook.com (2603:10b6:5:181::11)
 by DM6PR12MB3593.namprd12.prod.outlook.com (2603:10b6:5:11c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 07:27:19 +0000
Received: from DM6PR12MB2937.namprd12.prod.outlook.com
 ([fe80::ac32:c8f7:f83a:8734]) by DM6PR12MB2937.namprd12.prod.outlook.com
 ([fe80::ac32:c8f7:f83a:8734%7]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 07:27:19 +0000
Message-ID: <e12b81b3-f31a-79a0-2978-255132e2a81b@nvidia.com>
Date:   Tue, 23 Nov 2021 12:57:05 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC 3/3] vfio/pci: use runtime PM for vfio-device into low power
 state
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20211115133640.2231-1-abhsahu@nvidia.com>
 <20211115133640.2231-4-abhsahu@nvidia.com>
 <20211117105323.2866b739.alex.williamson@redhat.com>
 <8a49aa97-5de9-9cc8-d45f-e96456d66603@nvidia.com>
 <20211118140913.180bf94f.alex.williamson@redhat.com>
 <20211119084548.2042d763.alex.williamson@redhat.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <20211119084548.2042d763.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR0101CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::20) To DM6PR12MB2937.namprd12.prod.outlook.com
 (2603:10b6:5:181::11)
MIME-Version: 1.0
Received: from [10.40.163.79] (115.114.90.35) by MA1PR0101CA0058.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 07:27:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 675f6efd-d626-4929-dc3a-08d9ae52ae73
X-MS-TrafficTypeDiagnostic: DM6PR12MB3593:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3593FC3A18E22CEC2E740EF9CC609@DM6PR12MB3593.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvY6ewc7fnyS75HgkCa/P3GkDZ2NJqaWA1+2lSes94sprWKHINfWXu3UTgZ2gSVyqffQ1mCYqkz4XUP6t2FXS2uVwsIwZNn2qbTvxfovIDGpLPDpc5J5FD/f+nd41iGOYfApfAINzzaK4YRsKk7qHnAluy/6x+P8kX+eLlMdyTIWAzmX6GVoUPu47hZ+VGAicj2vRW8ToDOEeQqOO+GIYFRZR49RMN3/SSCxAMDFBPTPUSymtvLfm6DUBV5eowcCDZVED/KgxVkloEZs2kvjZx/YGpV68XZLWoRrKTklRz9f+cxTp+uryTe7AWMLEUjcCdF7SiWLgc9SU3zgkbrvtdGDgZMO7+dfBFPFjp91o7HKfNaey/6b1z0yeRw/n6GB/IRP6c4UFA9DhSJKUVuK8VLl0rMqj2dT8rzFy+JaFBXZr88U0G7gjHW/333jitANO7h30vz0DPzdV8GNvAzE3Tn6yHcseHLUfccxpOls1N3H/poqh32xI8mI2tECJinRYWDlpI6g8Xqu14pIEFAyQHXrcui01On1TjVKrK7REXu8EXjoZe15QaT46evdvcXdK6cmnBYvRfi3L/TOW/kAKorsrsjyrQipArUgPFNkX0+L+5G7fLd7dR5NrhwOG2dqGsNfneydsKEQIHhuyJyZrMymX2bN2RpL1kydUUDfAJeFy3ue9rfmvmIZL34/lAMq+jxXfPmHET+g7KtfgVDnUgJWIJxJelp3VlwyrpCOcn8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2937.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(54906003)(30864003)(66476007)(6916009)(66556008)(66946007)(956004)(6666004)(2616005)(31696002)(36756003)(26005)(53546011)(38100700002)(55236004)(8676002)(2906002)(86362001)(8936002)(5660300002)(508600001)(316002)(31686004)(16576012)(6486002)(83380400001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmN0b3dzVWZiUEt0MnZURW81b0ZFRDJsMlVieG5LZzhBY09rcUN2UVlLK3Bj?=
 =?utf-8?B?WEg5VG55QmlkVmh2SThoM0gwRmx4SHYzVzNGam1BZE54L3JsYURUc3U2QXg0?=
 =?utf-8?B?VlgvY0dOMjVBMTRMTjJ3c3FERUgzTkNHTCs0dXhURjhLSW9SUlB6aGNXQzl1?=
 =?utf-8?B?anhmZVdFUW5FZTducG1ienpXUWd4VXpmVnpaQWhhK05wNWtyQm5UVldQSUNX?=
 =?utf-8?B?OEN5RmtLd2Zld0VqK0dMQ28xNlF0S0VRMndFSWN2VHlOaWcrdEN5QXVLSk9R?=
 =?utf-8?B?WTA2VzJodVBiWFZ4YXlPWUo1VnNYaXlCRHVtS2plWmY5bGlraTBYaWkrWE54?=
 =?utf-8?B?bHlWYzZWaFJkSXp5a29zVHVYRVVRaHo1NEp2VlNYK3NTUHhhMlNCY3AvdTdF?=
 =?utf-8?B?OUZwVEpIVjJIcnhJYkRKYXRKQTU2WStEUVRPMlo1ZHpTK0NkVmhGT01GWEc5?=
 =?utf-8?B?Z2daK0UrcEFQM2FwSTRjSUVzbXpoV3NhVm9mS2hGMTBod3cySEU3R0xHYVpZ?=
 =?utf-8?B?dHlUUmFCU0x3a0hsd3h3cVl1azVPbzRTVS9wa2JzNDFtNTdXZVFBY3ZzNitt?=
 =?utf-8?B?VFJQSFdURjg5eURxM0g5R01LMW9HYzJldnd4UmkzOUR4Nk4yeEYxOFVLa3Rh?=
 =?utf-8?B?REltZkRiVDUzMXpTL202V2t2a1VWL0R0YytpQWlFaHpsZnNRUHhQRCthR2lt?=
 =?utf-8?B?a0pOYUlOc0tJV2JVeFJHV25KUWk3WTMwTnVUcmpsY1VaN01UMWFPZjhmRWh3?=
 =?utf-8?B?SzFENVpRcmRaSjFxYlBwb2RtMjgwWVBQWjFBZ1ZQdjBQWU4wK0gxM3JaczFH?=
 =?utf-8?B?SzNZTlNaRE9ZNHBzK2RNZHVwOFpkRDdnb1NDdzdQbFhnMU1JcmxaaVdsLytp?=
 =?utf-8?B?MjQrbDhieUQyazBOWFM1Y0txODhsdjBHYmxpV1BHWkt1TjlvQmlCYm1hNUJI?=
 =?utf-8?B?Rnd0bDVjK1ZqdjkySWRHc3lRbmhLQlJyeTZzT0lkZ284Yk90dUZPbGdzTmdr?=
 =?utf-8?B?TkNGcGkvck9oUUphSmxwQTd6UFAvZ3dqRW9tOUlBN21PUXlJK1VlMUtsMHNw?=
 =?utf-8?B?OGxWb25XK055bVpudDR5ek96RHplMExIS1RjRlBoU1hmQ3NmTEVLbW8wZ01L?=
 =?utf-8?B?aGZhSXZPSDZmRWpUbFpTMmZaOHpiTmFKWDJLZ3F0OXYrOHgveGxzMW0xMmRm?=
 =?utf-8?B?NnExU2t4UzBCbWl0dFQzVTA1K3o2WkphUmY1b0FTNkpKRVhrdTdCWlhwaVh2?=
 =?utf-8?B?TXR6ajNoNHJ5NVdOU1BQOUxHcndPSGlpREYrcUZJenN0Ymh4aTlERURTTnFW?=
 =?utf-8?B?S0k2aVA2bmp1d3NFUzVXQ25adzd6cE1aQy82QUhvVDFMYkpXbHBSZU5WK05h?=
 =?utf-8?B?dStjdVZ1cGtBSWJuWEtRU3hPZ3JGa1pZZmJDeHVoOG5jVWpTU0Z0MlVvVjN6?=
 =?utf-8?B?dkJyLytFbzl2aDF0WUpQSVkxVEd5azZQZFJaV1NZN0luSVlCZGYzY3YwK2tl?=
 =?utf-8?B?MWN0Tmw0aktxSkFaSFJGVE4zZ3hyZTZ2MmFVeXBtTXVmREhLb1AvKzJpcHJH?=
 =?utf-8?B?SkpEdGZiU25ZVzJPdVZXeVBTck5zeTVkVi83NGVXSzdYQWZaQ3plMnZMWGZs?=
 =?utf-8?B?WWR6WHYxZFZmeGJvMEswV1BobUs5Mi9SaDBZVmNQREpTT2M2Sk53bnZiYW1H?=
 =?utf-8?B?N0tpMEVuQzNpNlQrNDROUGwyNWJVbDRZUWszOEhnQ2RCS0FWZ1B5YjRRR3BZ?=
 =?utf-8?B?UmJyNUVwbm95WDI3cGE3VHYwZExySGttcndmYm83aWRJMHJxNVdHRXZLcXBo?=
 =?utf-8?B?a2wyUnRDRU04SnU3Zy9UZVNYUmpFU1JBRzhlSkM2d1BkYWtDY0hPNE95TDlR?=
 =?utf-8?B?d2pTTnc0WjNMckhLa2lqL00zckpCdFgva3dUYWNJQTlxWm8ydU5jRW5jeFpt?=
 =?utf-8?B?RUptSHI2VkxmdnlSOFJHdGpFcFhualQ0Qjk1dytMUmZpOWpjNnhmOHZGaCs2?=
 =?utf-8?B?ZFFIT2RnTTNNK25HK1BhMTNZVVlGSFRUUWI0eTZJRHF3VURsUHhxUWR1Zlh1?=
 =?utf-8?B?MlJRQ09ORWZvUXRSaTB3SlJTT29hVytuYkhiOXQ2cHBpUzRSTmJYL2VORjZu?=
 =?utf-8?B?OXhoaVRGaVJ6VUFZR2Q4d1JzbGZQd2o1bUdlMmdRdkpLNlBaTEpuMERCT1BL?=
 =?utf-8?Q?uPkYWhB7ja970u4vT2jsKIo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675f6efd-d626-4929-dc3a-08d9ae52ae73
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2937.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 07:27:19.1613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtAvFSYXh50W06qn6a/u6qC/reGCz3THq6PfdYRZFLpU9i5IkLrMJ+3AJRNkcfOnGZaQ9f9h1gOe+aZJBRyJcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3593
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/2021 9:15 PM, Alex Williamson wrote:
> On Thu, 18 Nov 2021 14:09:13 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Thu, 18 Nov 2021 20:51:41 +0530
>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>> On 11/17/2021 11:23 PM, Alex Williamson wrote:
>>>  Thanks Alex for checking this series and providing your inputs.
>>>
>>>> If we're transitioning a device to D3cold rather than D3hot as
>>>> requested by userspace, isn't that a user visible change?
>>>
>>>   For most of the driver, in linux kernel, the D3hot vs D3cold
>>>   state will be decided at PCI core layer. In the PCI core layer,
>>>   pci_target_state() determines which D3 state to choose. It checks
>>>   for platform_pci_power_manageable() and then it calls
>>>   platform_pci_choose_state() to find the target state.
>>>   In VM, the platform_pci_power_manageable() check will fail if the
>>>   guest is linux OS. So, it uses, D3hot state.
>>
>> Right, but my statement is really more that the device PM registers
>> cannot be used to put the device into D3cold, so the write of the PM
>> register that we're trapping was the user/guest's intention to put the
>> device into D3hot.  We therefore need to be careful about differences
>> in the resulting device state when it comes out of D3cold vs D3hot.
>>>>>   But there are few drivers which does not use the PCI framework
>>>   generic power related routines during runtime suspend/system suspend
>>>   and set the PCI power state directly with D3hot.
>>
>> Current vfio-pci being one of those ;)
>>
>>>   Also, the guest can be non-Linux OS also and, in that case,
>>>   it will be difficult to know the behavior. So, it may impact
>>>   these cases.
>>
>> That's what I'm worried about.
>>
>>>> For instance, a device may report NoSoftRst- indicating that the device
>>>> does not do a soft reset on D3hot->D0 transition.  If we're instead
>>>> putting the device in D3cold, then a transition back to D0 has very
>>>> much undergone a reset.  On one hand we should at least virtualize the
>>>> NoSoftRst bit to allow the guest to restore the device, but I wonder if
>>>> that's really safe.  Is a better option to prevent entering D3cold if
>>>> the device isn't natively reporting NoSoftRst-?
>>>>
>>>
>>>  You mean to say NoSoftRst+ instead of NoSoftRst- as visible in
>>
>> Oops yes.  The concern is if the user/guest is not expecting a soft
>> reset when using D3hot, but we transparently promote D3hot to D3cold
>> which will always implies a device reset.
>>
>>>  the lspci output. For NoSoftRst- case, we do a soft reset on
>>>  D3hot->D0 transition. But, will this case not be handled internally
>>>  in drivers/pci/pci-driver.c ? For both system suspend and runtime suspend,
>>>  we check for pci_dev->state_saved flag and do pci_save_state()
>>>  irrespective of NoSoftRst bit. For NoSoftRst- case, pci_restore_bars()
>>>  will be called in pci_raw_set_power_state() which will reinitialize device
>>>  for D3hot/D3cold-> D0 case. Once the device is initialized in the host,
>>>  then for guest, it should work without re-initializing again in the
>>>  guest side. I am not sure, if my understanding is correct.
>>
>> The soft reset is not limited to the state that the PCI subsystem can
>> save and restore.  Device specific state that the user/guest may
>> legitimately expect to be retained may be reset as well.
>>
>> [PCIe v5 5.3.1.4]
>>       Functional context is required to be maintained by Functions in
>>       the D3 hot state if the No_Soft_Reset field in the PMCSR is Set.
>>
>> Unfortunately I don't see a specific definition of "functional
>> context", but I interpret that to include device specific state.  For
>> example, if a GPU contains specific frame buffer data and reports
>> NoSoftRst+, wouldn't it be reasonable to expect that framebuffer data
>> to be retained on D3hot->D0 transition?
>>

 Thanks Alex for your inputs.

 I got your point. Yes. That can happen.

>>>> We're also essentially making a policy decision on behalf of
>>>> userspace that favors power saving over latency.  Is that
>>>> universally the correct trade-off?
>>>
>>>  For most drivers, the D3hot vs D3cold should not be favored due
>>>  to latency reasons. In the linux kernel side, I am seeing, the
>>>  PCI framework try to use D3cold state if platform and device
>>>  supports that. But its correct that covertly replacing D3hot with
>>>  D3cold may be concern for some drivers.
>>>
>>>> I can imagine this could be desirable for many use cases,
>>>> but if we're going to covertly replace D3hot with D3cold, it seems
>>>> like there should be an opt-in.  Is co-opting the PM capability for
>>>> this even really acceptable or should there be a device ioctl to
>>>> request D3cold and plumbing through QEMU such that a VM guest can
>>>> make informed choices regarding device power management?
>>>>
>>>
>>>  Making IOCTL is also an option but that case, this support needs to
>>>  be added in all hypervisors and user must pass this information
>>>  explicitly for each device. Another option could be to use
>>>  module parameter to explicitly enable D3cold support. If module
>>>  parameter is not set, then we can call pci_d3cold_disable() and
>>>  in that case, runtime PM should not use D3cold state.
>>>
>>>  Also, I was checking we can pass this information though some
>>>  virtualized register bit which will be only defined for passing
>>>  the information between guest and host. In the guest side if the
>>>  target state is being decided with pci_target_state(), then
>>>  the D3cold vs D3hot should not matter for the driver running
>>>  in the guest side and in that case, it depends upon platform support.
>>>  We can set this virtualize bit to 1. But, if driver is either
>>>  setting D3hot state explicitly or has called pci_d3cold_disable() or
>>>  similar API available in the guest OS, then set this bit to 0 and
>>>  in that case, the D3cold state can be disabled in the host side.
>>>  But don't know if is possible to use some non PCI defined
>>>  virtualized register bit.
>>
>> If you're suggesting a device config space register, that's troublesome
>> because we can't guarantee that simply because a range of config space
>> isn't within a capability that it doesn't have some device specific
>> purpose.  However, we could certainly implement virtual registers in
>> the hypervisor that implement the ACPI support that an OS would use on
>> bare metal to implement D3cold.  Those could trigger this ioctl through
>> the vfio device.
>>

 Yes. I was suggesting a some bits in PM_CTRL register.
 We can identify some bits which are unused like bit 22 and 23.

 23:22 Undefined - these bits were defined in previous specifications.
 They should be ignored by software. 

 and virtualize these bits for passing D3cold related information 
 from guest to host. These bits were defined for PCI-to-PCI 
 bridge earlier. But this will be hack and will cause issues
 if PCI specification starts using these bits in future revisions.
 Also, it needs the changes in the other OS. So, it won't be good
 idea.
 
>>>  I am not sure what should be best option to make choice
>>>  regarding d3cold but if we can have some option by which this
>>>  can be done without involvement of user, then it will benefit
>>>  for lot of cases. Currently, the D3cold is supported only in
>>>  very few desktops/servers but in future, we will see on
>>>  most of the platforms.
>>
>> I tend to see it as an interesting hack to promote D3hot to D3cold, and
>> potentially very useful.  However, we're also introducing potentially
>> unexpected device behavior, so I think it would probably need to be an
>> opt-in.  Possibly if the device reports NoSoftRst- we could use it by
>> default, but even virtualizing the NoSoftRst suggests that there's an
>> expectation that the guest driver has that support available.
>>

 Sure. Based on the discussion, the best option is to provide IOCTL
 to user for transition to D3cold. The hypervisor can implement the
 the required ACPI power resource for D3Hot and D0 and then once
 guest OS calls these power resource methods,
 then it can invoke the IOCTL to the host side vfio-pci driver.

 The D0/D1/D2/D3hot transition can happen with existing way
 by directly writing into PM config register and the IOCTL
 needs to transition from D3hot to D3cold via runtime PM
 framework.

 I will do more analysis regarding this by doing code changes
 and will update.

>>>> Also if the device is not responsive to config space due to the user
>>>> placing it in D3 now, I'd expect there are other ioctl paths that
>>>> need to be blocked, maybe even MMIO paths that might be a gap for
>>>> existing D3hot support.  Thanks,
>>>
>>>  I was in assumption that most of IOCTL code will be called by the
>>>  hypervisor before guest OS boot and during that time, the device
>>>  will be always in D0. But, if we have paths where IOCTL can be
>>>  called when the device has been suspended by guest OS, then can we
>>>  use runtime_get/put API’s there also ?
>>
>> It's more a matter of preventing user actions that can cause harm
>> rather than expecting certain operations only in specific states.  We
>> could chose to either resume the device for those operations or fail
>> the operation.  We should probably also leverage the memory-disable
>> support to fault mmap access to MMIO when the device is in D3* as well.
> 

 Sure. I can explore regarding this as well.

> It also occurred to me last night that a guest triggering D3hot via the
> PM registers must be a synchronous power state change, we can't use
> auto-suspend.  This is necessary for nested assignment where the guest
> might use a D3hot->D0 power state transition with NoSoftRst- devices in
> order to perform a reset of the device.  With auto-suspend, the guest
> would return the device to D0 before the physical device ever timed out
> to enter a D3 state.  Thanks,
> 
> Alex
> 

 Okay. I think if we can use IOCTL based way to trigger D3cold, then
 autosuspend should not be required. Also, in that case, the transition
 to D3hot can happen with existing way of writing directly into PCI
 PM register. I will validate this use-case after doing changes
 with IOCTL based design. I will make the changes in QEMU locally
 to validate my changes. 

 Thanks,
 Abhishek
