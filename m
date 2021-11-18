Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EEA455F4C
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhKRPZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:25:01 -0500
Received: from mail-bn7nam10on2052.outbound.protection.outlook.com ([40.107.92.52]:32672
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230098AbhKRPZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:25:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5BHxP6jhXrIHI3ZmV2mxG0VAHQ3uJ92GApKCxjtomPxwUHXXxvYox6kVbfTK68EZ1GX7CRKgCi3QD6/7Gv6IbvvKDSw71uv3FUcTPiV4biu174UaMQgYR9hmWlE3GWd2mlKI2DBKOpapLTYyc0220EGYTOiosgLYpMx0rZ/7oyeCn0hGZJ4fnmNj4WMSbNjXrF1cWcgceuH8SsEQNsxjkCbEFQDqmTzObdYHeSgievrnwg455e5HObYln3w7B+1wkXAzDLS9oXP8UgTfwIL/5uqTz/fUZfD4m4U7GuOocmLt7jbpQrM8eCmakS/tFujvAf5r7nUkKnUhwW/Gavh6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERxpgQtDimCVjxAZeaHcNvaf9EKn8wPQcPxMHXzXWkM=;
 b=XSkeAuU7OCXL3KL3jLMy6pVoADYnsZH8flywx6bg/hsSRbd5Wm19PbQD1+rKTfTgYUndR7Fq0zGeX+nkuRGTwGRnIF7Mn2WvUYy3u+NDH7SsqxAKPpf0Y3FdrUsEQU6n2j8DGhVJ2sb4FSXC6zD6AHcq4P++HeMlAfZ6xqEtmi2wpDW//m0+xa6s8qQ0GmWipcELn+3zTGHz+btzxmG/hgoHEzrcxo87AIG5cwT5RJ8LV0r0m/il4SY8YaVj0kP0iQwFetdPl/nQd8WB+/FOX1kxzVwC8PbU3+pRQJy8u12aFLfASazCAvvARXEUb3sYq9bSErBPYc0MX78ubfsIEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERxpgQtDimCVjxAZeaHcNvaf9EKn8wPQcPxMHXzXWkM=;
 b=SARxaRR6PFl7E9IIocfX3mqIIyyQEDeHdcB2LSlLf30rVuVYZk8fMlYwhHnBqQhFqV3Otg+bbIeBMNH16HV3CXoCJE6yP+bRllsFG8Zdh92y7Sg+HzbB3+FJ2tdUKRoJf2W4jND/lPt+8y3qJvGMFt7IOhsK56LAocE1rIDLADRgFA8869Xrgjqvg8CgUSOgG5AocMt9rqT27z/6COfiKuI3rPesT8WhmzOh+KmpziVdi1b810q+FfSniYnSWoHL9u4C6iHO5+7JNhK6IOaQ0szZXviPpMVgdNUS21MuySup0hQngnRZVXAWTeCqbGXWm6MpDE2a5xp75D/z0G63jA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2937.namprd12.prod.outlook.com (2603:10b6:5:181::11)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 15:21:58 +0000
Received: from DM6PR12MB2937.namprd12.prod.outlook.com
 ([fe80::ac32:c8f7:f83a:8734]) by DM6PR12MB2937.namprd12.prod.outlook.com
 ([fe80::ac32:c8f7:f83a:8734%7]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 15:21:58 +0000
Message-ID: <8a49aa97-5de9-9cc8-d45f-e96456d66603@nvidia.com>
Date:   Thu, 18 Nov 2021 20:51:41 +0530
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
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20211117105323.2866b739.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0149.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::19) To DM6PR12MB2937.namprd12.prod.outlook.com
 (2603:10b6:5:181::11)
MIME-Version: 1.0
Received: from [10.40.163.75] (115.114.90.35) by MA1PR01CA0149.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 15:21:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bc4addd-c916-41ee-cbb3-08d9aaa72966
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-Microsoft-Antispam-PRVS: <DM5PR12MB248705E6818EEB94ECEFA276CC9B9@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UNH+Sqc78jTStib6TXD9rsnZlW4uqbQEPBhkoWYchKkbvkYMaeM/4KOKBb6DlBS27HzDgsbrohK6lkrrJu/yHs+HCYSNhOmuuJUHuTtW/WZ5FWLOqBedSLlQXCoW07wp2ha83tbIz7IUjtjqi9tmc44+bCGZOrvUlWFJIDjXfNEJyhfRKeN7jbIk5Tw2H+63vYY3cdmplkkJAGvVo3jH3UqdhPT4BftO2cHTwulrXkgVxPQoIGREVTZu+MSynxoePWOPfOE0XfB+4d+T4pIHTUgWaBQ58ZiidhCHTQ6pkPBUYAZwK0clde/GFgO5YGU6IQRhAPhWulzJUJMaGl2+lkJIzwjUmSEAxMP8nLNtK0V9Sh2UIIQuoX+PGu1d2HkjhBijtQfa12si0OGwdDSwrFnn20wjksUrLCYSOMKldLQCUY9fmKKokPGiBHmuOqEitjPZfCh6lo+QI1MGt93hQcVW7MQVDTcayhyZ4lSronBk27o0fOHH0gGN5eIecU/rX0kOKA6ZbKZ9VVllubCElXKSW6X8rS/AUXP38Vv+eH0LwIunlXvwsHmGRz2Z9He3nBGcYrHM8KjRqQmiKU1UYvJkE8dIBH5MMaB9YVZPkBQFONz3R1w36LZ6XlCJ3IbWyVrbgH59xiNd4iGibPM16hPk93wKG0r7b7TpskjgCwXK7zBiyGqmx50WYD/7XGC7CsfXECwDdmltAooqUou4p7AfPPlz9ePSrSqqCbT7N/yW7gKLaHG3oa5So/JYVomn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2937.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(36756003)(8936002)(53546011)(6486002)(2906002)(6916009)(86362001)(66556008)(66476007)(8676002)(186003)(55236004)(316002)(16576012)(31696002)(2616005)(66946007)(956004)(38100700002)(83380400001)(26005)(54906003)(4326008)(31686004)(508600001)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0h0aWFwNnhuRHhRVEpvcnppL3ZpclpKOXVWWWVnT09CUU02dkh4bUpzR1A2?=
 =?utf-8?B?RlBmdXByKytCVXNmRUV2MnVSL1lHcCtTUFVFMGhlM1YwWEVqZEUwT1JZMy81?=
 =?utf-8?B?QmxvS3pBakhNNWY3ZDRYWFZtQjZERWtjd2I3Tkl4Y245L2FFQ0tDbzNlSlRt?=
 =?utf-8?B?Z083QWh5QldSM3lCMVZNeEg4WEVTR3NWWEh6QXIwK1A1eUIzK2p2UE5mcHZO?=
 =?utf-8?B?TXhjRVI5TzlOTXJUbk5nM0NBeFRWWFVGOTdSWWdVUjFSaXQzYkhWZjdHYU50?=
 =?utf-8?B?SkZ2eC9veVI0Z2JyTVVJeUhFa3hUTHZMOGphWDFTZ0Nhdk9OSjVBdTg2dFVn?=
 =?utf-8?B?cVU2TS9CWmRCMG11TWJuTHZpaTdqOXZiQnJjNnZ6SlZDMUhQMVJySnV6Y29q?=
 =?utf-8?B?VndXdCs3OVpmclNHSU5hUVhQa0drdHNQMU84ZUVaelRlT3NrMUFXU01qc2Fx?=
 =?utf-8?B?YndoTWd0aUxON0lwRHNpYXNzSHNYcXdHUEtnMWcvU0lFc2RMa20wWExSS0hQ?=
 =?utf-8?B?TXphblhWYzNJcDRKL1RjVXJBd1owQ1FyZml1MzZ6WmpQcmlZbUdEWE9KWHM3?=
 =?utf-8?B?ZzExUlJHWHp2QWlHT0M0SG00cGV6VmFyWVdDS3FMZmN4cVVYbnZXL0xPZmdM?=
 =?utf-8?B?K1hoS3IvVWJUc1hYZWJsdk85Z01weDIyR3J2NDU4dmVLNkZKT3pCTms3Mlk5?=
 =?utf-8?B?OGtxdk8rZlFLeU5pWE5DSGQwQm43czJuZjJucVRSeTh3Y3lIdGVIYk83QjJU?=
 =?utf-8?B?RWhEQmhLUFdrTDdFSEFBbUlsbExRd0N3bE5NTUxhTm0vQUlaYlRBa3hnNnRS?=
 =?utf-8?B?UUlyRkhObEtKaFF5cHZVYjVOa1dzeUtKaHh1eGdWV2ZuelpSS0UzUjNIQVNS?=
 =?utf-8?B?c3JhRFh6cFBhdm5oVm8wZWpqZDl1djZyT0g0M1BPQXdzODYxNkZ5dzhtOUNp?=
 =?utf-8?B?WHNPeFFyVVJnSVJ4dndUVTM3TVZvenFqbkZaek9pMzlWa0o3aGwxOTZDY2xQ?=
 =?utf-8?B?cVhiaEY1L3pDTEN0YlJUTWFyb0JQRzB5a2U5dDA2bXNHYlRpTmprVjRGaHZN?=
 =?utf-8?B?UkwvWW9KTUVkMDNJU2YwNitnaVpxdDNMb0VPWGpONHQycnYyMk1kTVJCVlFL?=
 =?utf-8?B?Sk9xMkxpUkJCTERCMVlPN1BXVEZDT0V2eWxMNjJCZ0NlNG50d2tac01VTXVS?=
 =?utf-8?B?RWxTeFNFRkx5czJFWnFsYStOZXY2cFYreENNb0FiQ0VRT2FncXBrTWFEZXZV?=
 =?utf-8?B?aWVZYnh3R2dJbU9pcTFEQksxa1lnaG10MHp4TmR5TDZxbUhqNWpYOTBUUjBN?=
 =?utf-8?B?cG1kbDNwWG9BUnp2cFlKSi9TQzh2QjIzS2wxUk1DRVZSb1BjRW8vTHNMVEVy?=
 =?utf-8?B?YkNrMHJLRU9kdkJ5dmhQYmREd3lKQmxCVzEwY1FKQy9Mc0RqUWRVM1p5Rmtk?=
 =?utf-8?B?L3JMR1VWU291N0NKUDFFNWRqUHY5Q2VRTEszQlVLNlBCU0ZJWU50U1k4REdx?=
 =?utf-8?B?K3RweEhQNXZNVFc5dU40OWNUQ2hKZms2aWNVNVBBVzFBU0g4dXJEK2JXMm5Z?=
 =?utf-8?B?aWkyeDVvc2FRNE9jMVRSYitPdzd4akhRMjZRRlRNV21IS0doano3aStxZ25s?=
 =?utf-8?B?MVh3blVoTTJWaDBGVDVGcWcyM0ZqMGZDSEtmYTBhdE1GazZNQmd2ZWZSb0hv?=
 =?utf-8?B?V1BUZnBHVm1pT0EyMXVqQlFyc2VxTXljcW03TXV5OU5SaXBGUkhyaU9HN2c1?=
 =?utf-8?B?SEJ2cU8va3RCYXQ0VFRMaS9BTzFKcm1idWhxc3F4ZkRnWGRId2xoTW4vaWFX?=
 =?utf-8?B?VHhlMmRpbkRBeVdYR0IwbTJkM2ZOeE1UcUdGS2Y4R1pSek40cWZxbXdPdldB?=
 =?utf-8?B?bFpReG4rS3p3empjUUFQdGQ3WERxYmwyQjNJTTlPL2NzcjliUHZQcWkvM28w?=
 =?utf-8?B?VFI1WEoxeU1yMmNNbkl0UG1lclBuT21yaW84c2dKRFpXZ2RhYnZDbGNkdXJa?=
 =?utf-8?B?bUVqSW14T0FuNFpJV3Z3ekpXdUpDTTBZYVJHdTFOOThkdzMxYmM2OVlSYUgy?=
 =?utf-8?B?QjB2S01OTHljQlZnS0x2cjE0eGI3ODFpZS91dFpDdXl5ZHQ5Rlo4NnYvS1Y3?=
 =?utf-8?B?VXV0ejBZaDF0cHpuVWd4SDQxYlVDSGFVSjRlTkdUZXdkMzVDQysrL2hYL0tS?=
 =?utf-8?Q?ubu7E5T3TDXGkDgnAfnkiSY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc4addd-c916-41ee-cbb3-08d9aaa72966
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2937.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 15:21:58.5166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rLqpAl6UI69XWXM9g+j/CvXs6/QIQZsv/43cSCdVxuqcV8p4oAyfDTrjVUjo+3YJWCspc2Rc7FK8j/rtXClkVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/2021 11:23 PM, Alex Williamson wrote:

> On Mon, 15 Nov 2021 19:06:40 +0530
> <abhsahu@nvidia.com> wrote:
> 
>> From: Abhishek Sahu <abhsahu@nvidia.com>
>>
>> Currently, if the runtime power management is enabled for vfio-pci
>> device in guest OS, then guest OS will do the register write for
>> PCI_PM_CTRL register. This write request will be handled in
>> vfio_pm_config_write() where it will do the actual register write of
>> PCI_PM_CTRL register. With this, the maximum D3hot state can be
>> achieved for low power. If we can use the runtime PM framework, then
>> we can achieve the D3cold state which will help in saving
>> maximum power.
>>
>> This patch uses runtime PM framework whenever vfio-pci device will
>> be put in the low power state.
>>
>> 1. If runtime PM is enabled, then instead of directly writing
>>    PCI_PM_CTRL register, decrement the device usage counter whenever
>>    the power state is non-D0. The kernel runtime PM framework will
>>    itself put the PCI device in low power state when device usage
>>    counter will become zero. Similarly, when the power state will be
>>    again changed back to D0, then increment the device usage counter
>>    and the kernel runtime PM framework will itself bring the PCI device
>>    out of low power state.
>>
>> 2. The guest OS will read the PCI_PM_CTRL register back to
>>    confirm the current power state so virtual register bits can be
>>    used. For this, before decrementing the usage count, read the actual
>>    PCI_PM_CTRL register, update the power state related bits, and then
>>    update the vconfig bits corresponding to PCI_PM_CTRL offset. For
>>    PCI_PM_CTRL register read, return the virtual value if runtime PM is
>>    requested. This vconfig bits will be cleared when the power state
>>    will be changed back to D0.
>>
>> 3. For the guest OS, the PCI power state will be still D3hot
>>    even if put the actual PCI device into D3cold state. In the D3hot
>>    state, the config space can still be read. So, if there is any request
>>    from guest OS to read the config space, then we need to move the actual
>>    PCI device again back to D0. For this, increment the device usage
>>    count before reading/writing the config space and then decrement it
>>    again after reading/writing the config space. There can be
>>    back-to-back config register read/write request, but since the auto
>>    suspend methods are being used here so only first access will
>>    wake up the PCI device and for the remaining access, the device will
>>    already be active.
>>
>> 4. This above-mentioned wake up is not needed if the register
>>    read/write is done completely with virtual bits. For handling this
>>    condition, the actual resume of device will only being done in
>>    vfio_user_config_read()/vfio_user_config_write(). All the config
>>    register access will come vfio_pci_config_rw(). So, in this
>>    function, use the pm_runtime_get_noresume() so that only usage count
>>    will be incremented without resuming the device. Inside,
>>    vfio_user_config_read()/vfio_user_config_write(), use the routines
>>    with pm_runtime_put_noidle() so that the PCI device won’t be
>>    suspended in the lower level functions. Again in the top level
>>    vfio_pci_config_rw(), use the pm_runtime_put_autosuspend(). Now the
>>    auto suspend timer will be started and the device will be suspended
>>    again. If the device is already runtime suspended, then this routine
>>    will return early.
>>
>> 5. In the host side D3cold will only be used if the platform has
>>    support for this, otherwise some other state will be used. The
>>    config space can be read if the device is not in D3cold state. So in
>>    this case, we can skip the resuming of PCI device. The wrapper
>>    function vfio_pci_config_pm_runtime_get() takes care of this
>>    condition and invoke the pm_runtime_resume() only if current power
>>    state is D3cold.
>>
>> 6. For vfio_pci_config_pm_runtime_get()/vfio_
>>    pci_config_pm_runtime_put(), the reference code is taken from
>>    pci_config_pm_runtime_get()/pci_config_pm_runtime_put() and then it
>>    is modified according to vfio-pci driver requirement.
>>
>> 7. vfio_pci_set_power_state() will be unused after moving to runtime
>>    PM, so this function can be removed along with other related
>>    functions and structure fields.
> 
> 

 Thanks Alex for checking this series and providing your inputs. 
 
> If we're transitioning a device to D3cold rather than D3hot as
> requested by userspace, isn't that a user visible change? 

  For most of the driver, in linux kernel, the D3hot vs D3cold
  state will be decided at PCI core layer. In the PCI core layer,
  pci_target_state() determines which D3 state to choose. It checks
  for platform_pci_power_manageable() and then it calls
  platform_pci_choose_state() to find the target state.
  In VM, the platform_pci_power_manageable() check will fail if the
  guest is linux OS. So, it uses, D3hot state.
 
  But there are few drivers which does not use the PCI framework
  generic power related routines during runtime suspend/system suspend
  and set the PCI power state directly with D3hot.
  Also, the guest can be non-Linux OS also and, in that case,
  it will be difficult to know the behavior. So, it may impact
  these cases.

> For instance, a device may report NoSoftRst- indicating that the device
> does not do a soft reset on D3hot->D0 transition.  If we're instead
> putting the device in D3cold, then a transition back to D0 has very
> much undergone a reset.  On one hand we should at least virtualize the
> NoSoftRst bit to allow the guest to restore the device, but I wonder if
> that's really safe.  Is a better option to prevent entering D3cold if
> the device isn't natively reporting NoSoftRst-?
> 

 You mean to say NoSoftRst+ instead of NoSoftRst- as visible in
 the lspci output. For NoSoftRst- case, we do a soft reset on
 D3hot->D0 transition. But, will this case not be handled internally
 in drivers/pci/pci-driver.c ? For both system suspend and runtime suspend,
 we check for pci_dev->state_saved flag and do pci_save_state()
 irrespective of NoSoftRst bit. For NoSoftRst- case, pci_restore_bars()
 will be called in pci_raw_set_power_state() which will reinitialize device
 for D3hot/D3cold-> D0 case. Once the device is initialized in the host,
 then for guest, it should work without re-initializing again in the
 guest side. I am not sure, if my understanding is correct.

> We're also essentially making a policy decision on behalf of userspace
> that favors power saving over latency.  Is that universally the correct
> trade-off? 

 For most drivers, the D3hot vs D3cold should not be favored due
 to latency reasons. In the linux kernel side, I am seeing, the
 PCI framework try to use D3cold state if platform and device
 supports that. But its correct that covertly replacing D3hot with
 D3cold may be concern for some drivers.

> I can imagine this could be desirable for many use cases,
> but if we're going to covertly replace D3hot with D3cold, it seems like
> there should be an opt-in.  Is co-opting the PM capability for this
> even really acceptable or should there be a device ioctl to request
> D3cold and plumbing through QEMU such that a VM guest can make informed
> choices regarding device power management?
> 

 Making IOCTL is also an option but that case, this support needs to
 be added in all hypervisors and user must pass this information
 explicitly for each device. Another option could be to use
 module parameter to explicitly enable D3cold support. If module
 parameter is not set, then we can call pci_d3cold_disable() and
 in that case, runtime PM should not use D3cold state. 

 Also, I was checking we can pass this information though some
 virtualized register bit which will be only defined for passing
 the information between guest and host. In the guest side if the
 target state is being decided with pci_target_state(), then
 the D3cold vs D3hot should not matter for the driver running
 in the guest side and in that case, it depends upon platform support.
 We can set this virtualize bit to 1. But, if driver is either
 setting D3hot state explicitly or has called pci_d3cold_disable() or
 similar API available in the guest OS, then set this bit to 0 and
 in that case, the D3cold state can be disabled in the host side.
 But don't know if is possible to use some non PCI defined
 virtualized register bit. 

 I am not sure what should be best option to make choice
 regarding d3cold but if we can have some option by which this
 can be done without involvement of user, then it will benefit
 for lot of cases. Currently, the D3cold is supported only in
 very few desktops/servers but in future, we will see on
 most of the platforms.  

> Also if the device is not responsive to config space due to the user
> placing it in D3 now, I'd expect there are other ioctl paths that need
> to be blocked, maybe even MMIO paths that might be a gap for existing
> D3hot support.  Thanks,
> 
> Alex
> 

 I was in assumption that most of IOCTL code will be called by the
 hypervisor before guest OS boot and during that time, the device
 will be always in D0. But, if we have paths where IOCTL can be
 called when the device has been suspended by guest OS, then can we
 use runtime_get/put API’s there also ?

 Thanks,
 Abhishek  

