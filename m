Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E267E455FAC
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhKRPka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:40:30 -0500
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:8096
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232226AbhKRPk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:40:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUJuOt7XiBozPWZlA8DIHCVWlRNHC5AOqv9M0b6b7WF7XZ8t556HqbuIMM6qpK6M0WcWyV4JE+k+cFYPR7Hdnp2RhwO72a8R0czEFAL05IQWn3V1jZEg+e0+Y5U0OlBXyxJ3xHgr924fKhzlpJNNoSWQk5wcfx9Ef759u288nLlc8NUQ/hEB3ALJ/XyKofnKzxAb4kgOvWl7G3gV4FCcHagw2S+8jrDMebviwy4yIzNMcSygJIqq3h9LDhMA5wxslsyE54CMZvGqx+tBxX675zkMd/TqywrXXh8Vp4frdUEeJGo+F5W9rXMNE9OuZlLWrPQAI41VmSR+gSfD9m0vYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqE53ATRBlogx+IfBKV0Ef1jEPEpdhq0wAd2k+9QPPU=;
 b=oBesDyZE4Hjp/SnXnpMxuVYJaOpOqBWy52hz4uuMAIsAEeqihgpbW/YMkdtLbalG8uPgGInDFju9nKVgOlzXkP3MHTXM4v1ucdNVSXmrqVW1R5t/l8qRTdPOZNXsVRXW5aE1Zjh+f4Rqh3X+XpY70Nb4JpGm4ksm6GjSbs81eOTvueN/FH1RBKcp+mjd5lJ8C5wAmY2qHsJO9vk73T6gto1bhc0gKRUuKbkAqoM+40KJBFcXdLPw/dvZ3/au5S79hmYpfhvzO0RU60Pwe+1Q47ypZK6B8hTUE00oQeuvW01v6itQkwfx+/DM94nasmCoGB0m2JVol3BkTx9IBNwcdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqE53ATRBlogx+IfBKV0Ef1jEPEpdhq0wAd2k+9QPPU=;
 b=mfJiZQPrxDiqvgKimYuceYVqt9ivEdsAr81iXk25AvGKfUIom3PowSwQTWxlVX60sU0tEKYqT4wMfYNLSgM5+YnIU5y9UJnchCzw9rOqnI9IHlbJiPSvckq1uz4Io4Xq5UVMy5V1TUwkdkUzXSeLIVyuTMGUP+MKQCcgC5HcgZQKMVMRwyG6gjTg/WEIj3N5roYP4cEdWKjOUWogsAirduI1MVGigyg+DitIq8R3f6OYG3gCraRmopYke4RdVAdCDkrxuvsjCM7E+5lXnTY1M7D7NLtca/wSlbgT9Dqcfu0NyPoanjHwsHjc5+TFdulHRY/Gt4hcUCKFmujZRZPuKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB2937.namprd12.prod.outlook.com (2603:10b6:5:181::11)
 by DM5PR12MB1548.namprd12.prod.outlook.com (2603:10b6:4:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.26; Thu, 18 Nov 2021 15:37:27 +0000
Received: from DM6PR12MB2937.namprd12.prod.outlook.com
 ([fe80::ac32:c8f7:f83a:8734]) by DM6PR12MB2937.namprd12.prod.outlook.com
 ([fe80::ac32:c8f7:f83a:8734%7]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 15:37:27 +0000
Message-ID: <73d3025f-e720-8062-7b6c-1f2a4c8cb1a6@nvidia.com>
Date:   Thu, 18 Nov 2021 21:07:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC 1/3] vfio/pci: register vfio-pci driver with runtime PM
 framework
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20211115133640.2231-1-abhsahu@nvidia.com>
 <20211115133640.2231-2-abhsahu@nvidia.com>
 <20211117105254.49227dc1.alex.williamson@redhat.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <20211117105254.49227dc1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0112.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::28) To DM6PR12MB2937.namprd12.prod.outlook.com
 (2603:10b6:5:181::11)
MIME-Version: 1.0
Received: from [10.40.163.75] (115.114.90.35) by MA1PR01CA0112.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 15:37:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6fcf8b6-cf2f-4ac1-abea-08d9aaa95329
X-MS-TrafficTypeDiagnostic: DM5PR12MB1548:
X-Microsoft-Antispam-PRVS: <DM5PR12MB15480623E98381672215A69CCC9B9@DM5PR12MB1548.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J878RbWFFMnOt4/1vleq2yHlSvyUVxdbp0wZEmbM2CLi7oz1fGrjRg7zXnmQp0MwQejDS0boXZy7/bqeid5cxTYAY3tPQh6DBhohO4HxpP2RPnR8GmC1ktCwqODhjPEVE0360ZxnlT75nPDVjg6zdB4zI0B5m8bb2RzT6fuB+xDuH8TYSOwtf9inyhRdxt/nSXo2uipepCD9HZikK9KavUC1TjydwqVcHixnYv88kkUVCChyIkBASzA3kEzT4ps9zEyhelxebhoni0BXbiqC9cc11G+FpXXLsRlRPYGul0jpYftZ8slkdFNH7j+uSkd0UEB14fg/5qofmew1yDw/ZIxCss8040yVFhoq3tSZgZMjVTwGYFt4nJefo654C5YH2ssF5ZKpHCKxNLYBA2OP7WVqMEz5QSnHOk/5wI4AroNv7iWYa9VDtcgelJ3cLb3tH+2n8K+VqCXD1ZZUhv1xpb/nmlvXw4TMnTgrouBG8QJLJP8OJD0fGf4YuHoNraIfwz0NTxqFriGmGMkaSitqB3WemtAJJS7Uu8fiYtxYQt7ry5qthO2VQ8PgH/Sbk27hNy+UHqQYa7kGY5Vl0Hqf8foM5P2fvjq/+3jil9OAY4C4mYxFVA53r3qgClahTRvcP+TMg0fxelwiZbZWKr0fykPAoNEfZO8xBDqw5kABfLBK5kNnv0X4HWaB8M0UtRRoSwEup4+L3sq3tq2J5Z3EuJngKO51tDlqjtxI26wytV0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2937.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(83380400001)(6666004)(6916009)(5660300002)(8936002)(36756003)(86362001)(26005)(6486002)(31686004)(4326008)(66476007)(8676002)(66556008)(66946007)(16576012)(316002)(54906003)(508600001)(55236004)(30864003)(2616005)(38100700002)(956004)(53546011)(31696002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elNaelhOVUZaZHpJZ0R6T3gzUElrTlJJQmlzSTVyKzlPZGJkZk5abDhWZmxP?=
 =?utf-8?B?UHpITFl4cHlKZS9rTHNYSTFXR2s3RTQySTBnY0thWHVPd2RBUzU0OGM4QUp5?=
 =?utf-8?B?Q3JuOGVGZEcxaEZoMi8xeUNHYUg1T3UzSzdYdFJiOFkvM0c3RmR3V2ZTbjNN?=
 =?utf-8?B?VjYwcjk2dUYxRHJDR051cDFjbVIzbWFwSVlLdnZqUE9SOUgrRENyc1RRM3ZQ?=
 =?utf-8?B?UWFIUjJJemNDdlpyUGlaNnlIck9Lc3l1MXFzNEYxTFpWSHdnK3Vwc1FBM01n?=
 =?utf-8?B?MjRCZVQ2azFoOTRnc3lYT1NIV0NJY0owNjN4clplY3J2YVNBajdyVkxXSlh2?=
 =?utf-8?B?dGcyVmU3WnVUS0YvQ0JRQjl5blhzSCtFS0ZsSmJ5cmNRSmVINTJwa0l0Tjdx?=
 =?utf-8?B?bEU0dmNWbElWTW1SUXdFRzJnV28zZVBmL3JOaGpKUXJJZ1NCSDVkSGpkVVU3?=
 =?utf-8?B?dUk4RTk3eElvUHBEZ1NHSVhucUJLSTJEZTQyd3QvUGVSa1cxYmE1U1BVaXl0?=
 =?utf-8?B?SkU0RTdQT1loSWRiUzluK21LMi9leXk5QzdaclRrQ2FFbkxreXJEVXBTc3kw?=
 =?utf-8?B?b3ZWbEN5enNlRVdOVjUvZW94UkxoY0pLQ2FTT1lUTmplamJCemVuRUxFd08y?=
 =?utf-8?B?U05jS2ZYblBtM3RwQmd4R0crcWFlajlkUXFxdER1YkJHZEZVVkkrK2dseGdO?=
 =?utf-8?B?N2JiYjJJQ3lQQ3pOL1YwVEFCMWt5a3RXUnNWREY0am10L2VoYW52dXp3T05F?=
 =?utf-8?B?L3UvT2RvMWJCRVljUkpkcW1BYUtXUmRkTUkxcEJEdDJOdlU5RlJxdS9ZcnQr?=
 =?utf-8?B?cXFMcEk1aVJvWUlLT1d3bW9RUCtxQUIwdlJSK0VFNVhmZGRESTNkeHh3VERi?=
 =?utf-8?B?bHMrNVBSaFZQRUlsbU9aSjhvS1YxTStkeXVIQzJlbW9vRUZSaUtiK1d6ejhh?=
 =?utf-8?B?WVM0cVhSVjlsTTVWeStVclpVQ0pPM0tvWlZoOVZ4azJjLy9NVWNTc3hKTzVW?=
 =?utf-8?B?VmNaZkJ3aE1pSlZaNm8vaEJkeDRsNTQ1RXhDM2xwK1RnaXVENkorRHAzbGxq?=
 =?utf-8?B?Y29jUjZQQlN4Yk5xUDhZZW83UWp3Tkh2OUpSK1VDM2ZuVFBlSUVqa0RzbURv?=
 =?utf-8?B?RFNOQzV3RUxDRkQrblpvUjB2dXFONGNYMHJKaTZoaUMrMVJiVXVUUmU4akth?=
 =?utf-8?B?VFphVnZ3TGh3YVFreDViNlFVbjkzK0pwOGNLTEpKeDhkN1RUbno0NXEvTzZC?=
 =?utf-8?B?TFNrZHh1K3I0cVI3dUFnaFZOZlEvUW5WZWVUaXl6bFI2SzBBOGpDTWhWQjUx?=
 =?utf-8?B?TnNuNTdJcEs3aXM3ZytHK21BcUJRbjBTSFBXb1FDdnlIYzBjcmVnVEZ5cXZ5?=
 =?utf-8?B?VzkxdGlIdVJmaW5LbnVCcHBIV2RqdzhkbndLcnU3cm1Rd3hYZFVuMWFBZkhn?=
 =?utf-8?B?SWZsQWhUaGlsc2VmZCs3SkNqT2pUTlNwaWJsZ2xlN1Z2WE5MWFMzc2RMNmZO?=
 =?utf-8?B?cXgvc1FoM1NkR3BRaEVPa1N1ZEdmckUwRTJmTXM2WnhrVHl1N1ZwZHlwUS8v?=
 =?utf-8?B?eDV3d0k4R1NLWklVSk8veTJVUElzSmk3MWNkOFRqTVpSQ2VCVkY3dmR0NHRZ?=
 =?utf-8?B?RnlYdTJxRXNzYmhXUXBueUZKck9vS2k4V1R3dmRBZ3RBN0JxejlGdzJydmVh?=
 =?utf-8?B?S0FTazQ0dEhMZ3loRjBFOXBiZGxxN2JSbW0rNm8wcVJ1dGpCQnE2a0EyMXVj?=
 =?utf-8?B?Z09DWTZhd3BQOHVTekgrK3RWZ21xVGNxeXRSYlF6UHV5L2VVaWJ3MjFoZzFJ?=
 =?utf-8?B?RGhkRGVsMk41UEI2OW5YNE12eTZzZGxlODN1T004ZDBpZnhXUXJZNUd6Rnky?=
 =?utf-8?B?b0NkTUlheEdyUUlHMXVsTEVaUGQvRjA5NCs2YStZS2tPZThQOThwMERrVkI4?=
 =?utf-8?B?TmJpWUwzOGp3RjRRU2gyR1BCM213aU9QYUhIeFRzK1pWbXNtelRFL2l6Sm5C?=
 =?utf-8?B?SUZqZmVkT1hpWnQxbUJ1dTQxeEs5S085cEM1TzJhckxQeDRNKytId2tLcFIv?=
 =?utf-8?B?bUg3K3ZWQy9xbDJPNG84SWpiSWp0R3JxaTMrcjl5UGFvcmFuNWlheHc4S2NX?=
 =?utf-8?B?VHFkOHBaS1BCT2JKc1J0ZzJHQllvYnlHV3M2VzkrVVoxeGtma0x3VVdpTkd5?=
 =?utf-8?Q?vrr6kekfU6wldZPGSKsWOcg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6fcf8b6-cf2f-4ac1-abea-08d9aaa95329
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2937.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 15:37:27.4638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Na5hTKfyCq53KbZ/+tXAqlLHPKJKS8xfZH8bMA11DmKYhqfsHedBilcgUiuH7WxaJtAYUd8I7FVe2BQJeZLrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1548
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/2021 11:22 PM, Alex Williamson wrote:
> On Mon, 15 Nov 2021 19:06:38 +0530
> <abhsahu@nvidia.com> wrote:
> 
>> From: Abhishek Sahu <abhsahu@nvidia.com>
>>
>> Currently, there is very limited power management support
>> available in upstream vfio-pci driver. If there is no user of vfio-pci
>> device, then the PCI device will be moved into D3Hot state by writing
>> directly into PCI PM registers. This D3Hot state help in saving some
>> amount of power but we can achieve zero power consumption if we go
>> into D3cold state. The D3cold state cannot be possible with Native PCI
>> PM. It requires interaction with platform firmware which is
>> system-specific. To go into low power states (including D3cold), the
>> runtime PM framework can be used which internally interacts with PCI
>> and platform firmware and puts the device into the lowest possible
>> D-States.
>>
>> This patch registers vfio-pci driver with the runtime PM framework.
>>
>> 1. The PCI core framework takes care of most of the runtime PM
>>    related things. For enabling the runtime PM, the PCI driver needs to
>>    decrement the usage count and needs to register the runtime
>>    suspend/resume routines. For vfio-pci based driver, these routines can
>>    be stubbed since the vfio-pci driver is not doing the PCI device
>>    initialization. All the config state saving, and PCI power management
>>    related things will be done by PCI core framework itself inside its
>>    runtime suspend/resume callbacks.
>>
>> 2. To prevent frequent runtime, suspend/resume, it uses autosuspend
>>    support with a default delay of 1 second.
>>
>> 3. Inside pci_reset_bus(), all the devices in bus/slot will be moved
>>    out of D0 state. This state change to D0 can happen directly without
>>    going through the runtime PM framework. So if runtime PM is enabled,
>>    then pm_runtime_resume() makes the runtime state active. Since the PCI
>>    device power state is already D0, so it should return early when it
>>    tries to change the state with  pci_set_power_state(). Then
>>    pm_request_autosuspend() can be used which will internally check for
>>    device usage count and will move the device again into low power
>>    state.
>>
>> 4. Inside vfio_pci_core_disable(), the device usage count always needs
>>    to decremented which was incremented vfio_pci_core_enable() with
>>    pm_runtime_get_sync().
>>
>> 5. Since the runtime PM framework will provide the same functionality,
>>    so directly writing into PCI PM config register can be replaced with
>>    use of runtime PM routines. Also, the use of runtime PM can help us in
>>    more power saving.
>>
>>    In the systems which do not support D3Cold,
>>
>>    With the existing implementation:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D0
>>
>>    With runtime PM:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D3hot
>>
>>    So, with runtime PM, the upstream bridge or root port will also go
>>    into lower power state which is not possible with existing
>>    implementation.
>>
>>    In the systems which support D3Cold,
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3hot
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D0
>>
>>    With runtime PM:
>>
>>    // PCI device
>>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>>    D3cold
>>    // upstream bridge
>>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>>    D3cold
>>
>>    So, with runtime PM, both the PCI device and upstream bridge will
>>    go into D3cold state.
>>
>> 6. If 'disable_idle_d3' module parameter is set, then also the runtime
>>    PM will be enabled, but in this case, the usage count should not be
>>    decremented.
>>
>> 7. vfio_pci_dev_set_try_reset() return value is unused now, so this
>>    function return type can be changed to void.
>>
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci.c      |   3 +
>>  drivers/vfio/pci/vfio_pci_core.c | 104 +++++++++++++++++++++++--------
>>  include/linux/vfio_pci_core.h    |   4 ++
>>  3 files changed, 84 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>> index a5ce92beb655..c8695baf3b54 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -193,6 +193,9 @@ static struct pci_driver vfio_pci_driver = {
>>       .remove                 = vfio_pci_remove,
>>       .sriov_configure        = vfio_pci_sriov_configure,
>>       .err_handler            = &vfio_pci_core_err_handlers,
>> +#if defined(CONFIG_PM)
>> +     .driver.pm              = &vfio_pci_core_pm_ops,
>> +#endif
>>  };
>>
>>  static void __init vfio_pci_fill_ids(void)
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index f948e6cd2993..511a52e92b32 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -152,7 +152,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>>  }
>>
>>  struct vfio_pci_group_info;
>> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>                                     struct vfio_pci_group_info *groups);
>>
>> @@ -245,7 +245,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>>       u16 cmd;
>>       u8 msix_pos;
>>
>> -     vfio_pci_set_power_state(vdev, PCI_D0);
>> +     if (!disable_idle_d3)
>> +             pm_runtime_get_sync(&pdev->dev);
> 
> I'm not a pm_runtime expert, but why are we not using
> pm_runtime_resume_and_get() here and aborting the function on error?
> 

 Thanks for pointing this.
 We should use pm_runtime_resume_and_get() and will abort the function
 in case of error. I will check other places also and see if
 we can use similar API.

> I hope some folks more familiar with pm_runtime can also review usage
> across this series.
> 

 Yes. The runtime PM API usage requires through review.

>>
>>       /* Don't allow our initial saved state to include busmaster */
>>       pci_clear_master(pdev);
>> @@ -405,8 +406,17 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>  out:
>>       pci_disable_device(pdev);
>>
>> -     if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
>> -             vfio_pci_set_power_state(vdev, PCI_D3hot);
>> +     vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
>> +
>> +     /*
>> +      * The device usage count always needs to decremented which was
>> +      * incremented in vfio_pci_core_enable() with
>> +      * pm_runtime_get_sync().
>> +      */
> 
> *to be
> 
> Maybe:
> 
>         /*
>          * Put the pm-runtime usage counter acquired during enable; mark
>          * last use time to delay autosuspend.
>          */
> 

 I will fix this.

>> +     if (!disable_idle_d3) {
>> +             pm_runtime_mark_last_busy(&pdev->dev);
>> +             pm_runtime_put_autosuspend(&pdev->dev);
>> +     }
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
>>
>> @@ -1847,19 +1857,23 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>
>>       vfio_pci_probe_power_state(vdev);
>>
>> -     if (!disable_idle_d3) {
>> -             /*
>> -              * pci-core sets the device power state to an unknown value at
>> -              * bootup and after being removed from a driver.  The only
>> -              * transition it allows from this unknown state is to D0, which
>> -              * typically happens when a driver calls pci_enable_device().
>> -              * We're not ready to enable the device yet, but we do want to
>> -              * be able to get to D3.  Therefore first do a D0 transition
>> -              * before going to D3.
>> -              */
>> -             vfio_pci_set_power_state(vdev, PCI_D0);
>> -             vfio_pci_set_power_state(vdev, PCI_D3hot);
>> -     }
>> +     /*
>> +      * pci-core sets the device power state to an unknown value at
>> +      * bootup and after being removed from a driver.  The only
>> +      * transition it allows from this unknown state is to D0, which
>> +      * typically happens when a driver calls pci_enable_device().
>> +      * We're not ready to enable the device yet, but we do want to
>> +      * be able to get to D3.  Therefore first do a D0 transition
>> +      * before enabling runtime PM.
>> +      */
>> +     pci_set_power_state(pdev, PCI_D0);
>> +     pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
> 
> Let's #define this 1000 at the top of the file with some rationale how
> we arrived at this heuristic (ie. avoid magic numbers in code).  Thanks,
> 
> Alex
> 

 Sure.This autosuspend delay was mainly for back-to-back config read/write
 case. I will move at the top with proper reason.

 Thanks,
 Abhishek 
 
>> +     pm_runtime_use_autosuspend(&pdev->dev);
>> +     pm_runtime_mark_last_busy(&pdev->dev);
>> +     pm_runtime_allow(&pdev->dev);
>> +
>> +     if (!disable_idle_d3)
>> +             pm_runtime_put_autosuspend(&pdev->dev);
>>
>>       ret = vfio_register_group_dev(&vdev->vdev);
>>       if (ret)
>> @@ -1868,7 +1882,10 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>>
>>  out_power:
>>       if (!disable_idle_d3)
>> -             vfio_pci_set_power_state(vdev, PCI_D0);
>> +             pm_runtime_get_noresume(&pdev->dev);
>> +
>> +     pm_runtime_dont_use_autosuspend(&pdev->dev);
>> +     pm_runtime_forbid(&pdev->dev);
>>  out_vf:
>>       vfio_pci_vf_uninit(vdev);
>>       return ret;
>> @@ -1887,7 +1904,10 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>>       vfio_pci_vga_uninit(vdev);
>>
>>       if (!disable_idle_d3)
>> -             vfio_pci_set_power_state(vdev, PCI_D0);
>> +             pm_runtime_get_noresume(&pdev->dev);
>> +
>> +     pm_runtime_dont_use_autosuspend(&pdev->dev);
>> +     pm_runtime_forbid(&pdev->dev);
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
>>
>> @@ -2093,33 +2113,63 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
>>   *  - At least one of the affected devices is marked dirty via
>>   *    needs_reset (such as by lack of FLR support)
>>   * Then attempt to perform that bus or slot reset.
>> - * Returns true if the dev_set was reset.
>>   */
>> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>>  {
>>       struct vfio_pci_core_device *cur;
>>       struct pci_dev *pdev;
>>       int ret;
>>
>>       if (!vfio_pci_dev_set_needs_reset(dev_set))
>> -             return false;
>> +             return;
>>
>>       pdev = vfio_pci_dev_set_resettable(dev_set);
>>       if (!pdev)
>> -             return false;
>> +             return;
>>
>>       ret = pci_reset_bus(pdev);
>>       if (ret)
>> -             return false;
>> +             return;
>>
>>       list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
>>               cur->needs_reset = false;
>> -             if (!disable_idle_d3)
>> -                     vfio_pci_set_power_state(cur, PCI_D3hot);
>> +             if (!disable_idle_d3) {
>> +                     /*
>> +                      * Inside pci_reset_bus(), all the devices in bus/slot
>> +                      * will be moved out of D0 state. This state change to
>> +                      * D0 can happen directly without going through the
>> +                      * runtime PM framework. pm_runtime_resume() will
>> +                      * help make the runtime state as active and then
>> +                      * pm_request_autosuspend() can be used which will
>> +                      * internally check for device usage count and will
>> +                      * move the device again into the low power state.
>> +                      */
>> +                     pm_runtime_resume(&pdev->dev);
>> +                     pm_runtime_mark_last_busy(&pdev->dev);
>> +                     pm_request_autosuspend(&pdev->dev);
>> +             }
>>       }
>> -     return true;
>>  }
>>
>> +#ifdef CONFIG_PM
>> +static int vfio_pci_core_runtime_suspend(struct device *dev)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int vfio_pci_core_runtime_resume(struct device *dev)
>> +{
>> +     return 0;
>> +}
>> +
>> +const struct dev_pm_ops vfio_pci_core_pm_ops = {
>> +     SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
>> +                        vfio_pci_core_runtime_resume,
>> +                        NULL)
>> +};
>> +EXPORT_SYMBOL_GPL(vfio_pci_core_pm_ops);
>> +#endif
>> +
>>  void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
>>                             bool is_disable_idle_d3)
>>  {
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index ef9a44b6cf5d..aafe09c9fa64 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -231,6 +231,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
>>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
>>  void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
>>
>> +#ifdef CONFIG_PM
>> +extern const struct dev_pm_ops vfio_pci_core_pm_ops;
>> +#endif
>> +
>>  static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>>  {
>>       return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
> 

