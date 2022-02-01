Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F474A5B4B
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 12:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiBALhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 06:37:00 -0500
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:32352
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233560AbiBALg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 06:36:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SC14k/wT4m9yQHabMu93lMzM3E6XxHujcrFMQPpuCsipsZrB5lvLJki6zhd3VzBcH+DXoChFhEK71+PV4uiVQ4mMZtXb4eObyjjJdVapOr2ZmfMnlQ7XjlpTwAchh2eRwD1GEa6QOS1EmRuKsu3yhdJ2rr+2xIdtoKy8Nh9J9b/rLthSO9EiFjcuSOzWI1No5nhlUQaT59AyW8TPKpDbMSGyPcJ5UL5+nCZH1anD30lOHF+CtBIohx+TnkeYM8SxIEOCVd8acGOOM23Ey8sOht7ONN35djjM4aruxgpKa8ZWGT+1P9SmK0J/mMGCGJF/tQ0nrZYdU8twoql/OMn91A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsczJu5hcnyOys5++tuudCnISRJ2wUekVJoD2TffVdI=;
 b=DSxXKCFOybX9s/x8lBIj8njdrhKONENTx1hu4hzMWh9ZUmnBtedmagCm3MlxZ7Tf5MTjwKfXA1MhG8+dng+S/rxp0fw6Z5VB3LqlC1wCTguftGmpblLMCxV5gCPvKF04zMSgsBxO2GJxQqGwqkBbwFkW2eDu4hLCnGCulI7C86CMxSYmueTrxr4C7388PXhw2jYsKObiIWxxhqrWHH4oEdupFTCBT7EGfIwUpK9sRe2/t9IebW6zAxIu3QZ0Z/wxE8qtnWrz5h1fgW+4IOmqweyjF2VwgOiRoaOpi87a/vtAe65Gc/B1S048eW8QYAsjkGWa2rpHy0lEh11CHgdLIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsczJu5hcnyOys5++tuudCnISRJ2wUekVJoD2TffVdI=;
 b=Xuer/ztKUhM21+RSI2MioAsY0aKVOYaiDnHCqsm2SHkMjTMQz+fn+KYh/Ui1WFAR4rTInDDOnj/6YLAKpWm5lMXhoEY/Sp++qUi7IYOIw70qDM908asl0+NmpE1vj1tDTN89aK5V5LhzKM6JRs40o3D+s9bwAimGBbSrmOzEYkgTRWAbLiczBYn+ay7KL/dfjKnDbyIYeZs9qJXNwrPM18SZfKnIW9kVu3t5CYw47NsVnIX6vj/vjynykkcJIMY2TIIEm9rp2nCYejZbHAputTm4tSaMlhwR5RQ6WdjazS+ID5cb3cMvaVDf9QKE8/7IIsdfzAn3dlqFHVWmZ+S0MA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BN7PR12MB2803.namprd12.prod.outlook.com (2603:10b6:408:32::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 11:36:57 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::5565:cbe5:8a6c:c010]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::5565:cbe5:8a6c:c010%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 11:36:56 +0000
Message-ID: <948e7798-7337-d093-6296-cedd09c733f5@nvidia.com>
Date:   Tue, 1 Feb 2022 17:06:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2] vfio/pci: fix memory leak during D3hot to D0
 transition
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20220131112450.3550-1-abhsahu@nvidia.com>
 <20220131131151.4f113557.alex.williamson@redhat.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <20220131131151.4f113557.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::16) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f408b1f7-2604-4c20-1f33-08d9e57726d5
X-MS-TrafficTypeDiagnostic: BN7PR12MB2803:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2803DDEC7E1BE8C7DBFCB10CCC269@BN7PR12MB2803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jiCJMj1hsbLow9Faj055bLAqQKl0X+QXZcd1pMfcdj4RbD3BniduH1riG1RUiOvZYGrmI7bXM1Q2IvIeSKwL+6+X76aO6X5fCUTasvbsd751oX89qR7DlC49ouoq7kwE+ark30+7tA0x7pIwAiBiNU3IYJzShM85ZoeJdG86n3P8+nrtGsyyGJnX9FmRnzScQpeHr7lR10wfJpJQN1O1dRH2DdSThc77Da1mi60FT9e7WjrIwAg5FGkq0woDFma1fLBl5/OD8XueUejCkkG2DHlXEiHsva5XNVRZxC+HCTXqlEKqJSTwDXZUxowKbnMh3kU1yBWsmirp0k3NeoKvr/wjN4+nSpaZdpzeCeeXtDPdRYzTZV4v5agpqsrhVeb3JmhuW9lRrDR0VIqR4BzLUlkPDfHydpycHCzrlLuTLlN+9wZDurx/XqMYcaJ+voHEWZ2+acYEw6jUYbMirEUOgVYqzd4VrFuZIRRcrpmsKm3Z0VGP8Iqo2LN7HwCBRGB+2zFhemUjGcF+Xp90etpE5jPGUMVfb6S3ukdtZLNAPgUC07CzqVQWZY2mFVO38PaIA68OA81xFaZRzYJ5fAGjjknCjx0WKbdqbYGC8/1ns3thmcbcd/2LmR76YiD/U3Y9KCDpoQD+EKj/HtP6bl8l4HUqL50VXJkCr1IJct1lSk03UKHDr1CfocoHMfyHK2m6xxcLA0G5+W74UjYiT4z3VC7XBEIqwlj6xmcjL8eqmegMU5RtKXQiTJtaXdJVwg0hYdsSVEEGu80vpsGd7Lkg6DHsmWtWf8khl8dxqgU8mkmslfPFSZJ0YtvBrhGGuxFdUDHOofF86KrYyBGJSsC/pNKy17D/RK2/ta4JbpehpwM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(8676002)(66476007)(38100700002)(66556008)(66946007)(4326008)(83380400001)(5660300002)(2906002)(55236004)(6916009)(2616005)(31686004)(508600001)(53546011)(86362001)(54906003)(6506007)(31696002)(6666004)(36756003)(316002)(186003)(26005)(6486002)(966005)(6512007)(32563001)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnh6OWlRV09CakdCeVRyQU05QzdjOU9rV0JXdlQzN1lFcWpTWFFrbnMyOFRB?=
 =?utf-8?B?djZyMVgrTjF0cjU4U2U0YU5MUHhTSkZhVjE2QXA1SnhkSEZXUTN0UkVjdDNt?=
 =?utf-8?B?NmlwbENZQml3V0NPb2MwUSt2Nkl0dnJLQ2JXR24ydHJVUUlZL1VEUXZSNTQy?=
 =?utf-8?B?RHNqejJ0WVZIekVZSzU1Z2FtMUZPNkd5WGQ4NnJoWFRQaElMZjVRQ25tdjZj?=
 =?utf-8?B?ZHV4ZEUydUYycWZmMUhzelYwVTdybDhKYlZvUFRKQVBYVzFqSWxJNlpPd2FY?=
 =?utf-8?B?UnFGNXlYV0FaT1Jha1M3RHlONkZKOGRMSERNNVV1aDR1aEpER3ROMHNhN0xL?=
 =?utf-8?B?R0RzbXZBV1haSmNiakRrRWlib0dhbkZ0UmtrQUlJVVNETHFzYWh0S2RVUDJR?=
 =?utf-8?B?dXkyK0lqVXphSnloeVJNbGs3MlhIWWhSZnUwOUZhWkh6bVpUUGtieGZNQ1d4?=
 =?utf-8?B?QXk2dU1YTVJTNE5oNFo1dXNHN01QT3RBMEVOR1hOd1JoZTVoZVhsWmVwdGdm?=
 =?utf-8?B?WEVtbUx5S2xlS3BkYnVLSTJkSzJxMGp2N09oYXRLU1lVKyt2ZFpqYnl5NzRH?=
 =?utf-8?B?WHBvZWtVcnhCSVowNWJTNFRRelgrUTBGOXRUZTMrdURjUHJoRmY0aFZhUmk1?=
 =?utf-8?B?N1BtQXBXK29nSmZCSWVXOHNVUitDenBzeW13MFRMUXlIanVGT05pWDZPQmdG?=
 =?utf-8?B?T3huNHlGNHhVeVhobmoxMVk0ZDc0VTZTM2tUSEtGK3dRbVFTYWR5S3oyZmk5?=
 =?utf-8?B?YjBZQTVUVm5qbnpKTFVueFNTSHhQbVhPdWlCN0M5YjFoVGdaVTNtNzFrRFhD?=
 =?utf-8?B?cGRkcnhnRXYxREMrMVo0dmlNalluanRlL3VlaDNFN0lOMWhXY2d1U3lHQUlF?=
 =?utf-8?B?Wmx5V1NWTTV2ZmtQWGRzdjNwSU9nd2lodElLcEhHT0ZYTjJXUWRVMXNjZjU5?=
 =?utf-8?B?V0EzY2RjdXNmcnZyL2VKNWIwcGoxME9FWjRmV0dIT0w0MEYybUhiaVE1N3hF?=
 =?utf-8?B?V3kvSzc1cjU3cFNiNnBJdjFYRzFEdEZWcUJOU1BqaFRUcTg1a1oraXhkeU5a?=
 =?utf-8?B?NHdtUDJwaGFaNGg5Z1UraGFzY3RveWJuWnQ3TGhkQ1RscnBHa21qdGVqTnBI?=
 =?utf-8?B?WVZMZFlCM3JVSTI3eUJQTkNGL3lPREJGbnBUd1ZyVENVRndrc3VRbmRxN0pi?=
 =?utf-8?B?Z3FuQVpwWUNnTDRTNWxHeTJXYlZ3d0VoRVorY044V2c4UHE2OVNENDdmcFoy?=
 =?utf-8?B?NWhsUjBsQXhIeWFOYVUzZDNGaWlNbnl0V1NlVEZlSmpGS05SZ2RsczFiTFh2?=
 =?utf-8?B?amhyNCsrdFJKcjN0dGNwWlExb0o2NEYrV2lDUlpodGIvVnlRZHROQkRnekow?=
 =?utf-8?B?aFQvbjN0eWNPdmd0RkVKanhYMlVBT3FjaUh4cGIwbjRlWW9XNHJScXJ0L3A2?=
 =?utf-8?B?UnZNaU1yUDZhcExDYlhXY2xkV1R3bitIeVV4OUdEWU5qS296Q1NDVTdpQ3E4?=
 =?utf-8?B?TkIrQzlybkpiYXg4NWt2bG83ZWFITkJZcTgvUjZBVHNvK2tRTzM2VCtRZUo4?=
 =?utf-8?B?OXlDMDBMR0piRFVqRkZyd1M2T2hWU2psWGRISCs3bHJublZPVXBtekN2SlVm?=
 =?utf-8?B?WElBbHdGcFdrdk05bTNTcWk3SDNpSjRpQXN1eDg2MkhhSE1uUTNBNkY2ZVVq?=
 =?utf-8?B?MklYQVY2dkI1OHFmb0Z2NHNURG5IVDFoUlZmbDMvelQwVEpjT1cvYlBUd1Ft?=
 =?utf-8?B?MFg4WWt2MHpOd0VOWXNXcWh3OXBQdHNwb3F4UTVxRjFFeUsxTlFLUW9CTUtD?=
 =?utf-8?B?aURmMFlvRkdJQ3VvYi9XWlJ6M2tSL0cvR0xna0g3cVBWcHhwZm1md1Z2cWNq?=
 =?utf-8?B?ZGRsMndaekJ0R2JORFVEN1B3elNxMXF6SzJxT0RyRWNIMTVnYXFhTnUwTDdr?=
 =?utf-8?B?R1RtbHpMTDgyaXNKWDNhcW8wZ2JPNDhnczV6RVl2bkcyYk12MlNLdGlja2NG?=
 =?utf-8?B?NWhjbUhUMlgycmZHUXQ2N1pGRytTeVlYMDFsNkxGNEYzQ0kvdXkvaHZYc3Mw?=
 =?utf-8?B?RmRBQmowTEkwaGFQRkJVK1dYNDJPWlBIWUxiOEg2TDhSY0Rxa0dodWZSOSt5?=
 =?utf-8?B?bDN6cXEzbWRXYkhXVHROYTZLaFJCUHY4MmpSNExxR1FuRmd5a0cyeDBDZUpU?=
 =?utf-8?Q?AQZSjjnzkG4TKqeMS4MDUqQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f408b1f7-2604-4c20-1f33-08d9e57726d5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 11:36:56.7974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugb8bW+vWNBftuiVYN9694EAl/rJtyU3jtXj687LNCKNSBNSOd2468OjhOeSQb77W/5jXflwBiZGxsQPpstXBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2803
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2022 1:41 AM, Alex Williamson wrote:
> On Mon, 31 Jan 2022 16:54:50 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> If needs_pm_restore is set (PCI device does not have support for no
>> soft reset), then the current PCI state will be saved during D0->D3hot
>> transition and same will be restored back during D3hot->D0 transition.
>> For saving the PCI state locally, pci_store_saved_state() is being
>> used and the pci_load_and_free_saved_state() will free the allocated
>> memory.
>>
>> But for reset related IOCTLs, vfio driver calls PCI reset related
>> API's which will internally change the PCI power state back to D0. So,
>> when the guest resumes, then it will get the current state as D0 and it
>> will skip the call to vfio_pci_set_power_state() for changing the
>> power state to D0 explicitly. In this case, the memory pointed by
>> pm_save will never be freed. In a malicious sequence, the state changing
>> to D3hot followed by VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be
>> run in a loop and it can cause an OOM situation.
>>
>> Also, pci_pm_reset() returns -EINVAL if we try to reset a device that
>> isn't currently in D0. Therefore any path where we're triggering a
>> function reset that could use a PM reset and we don't know if the device
>> is in D0, should wake up the device before we try that reset.
>>
>> This patch changes the device power state to D0 by invoking
>> vfio_pci_set_power_state() before calling reset related API's.
>> It will help in fixing the mentioned memory leak and making sure
>> that the device is in D0 during reset. Also, to prevent any similar
>> memory leak for future development, this patch frees memory first
>> before overwriting 'pm_save'.
>>
>> Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>
>> * Changes in v2
>>
>> - Add the Fixes tag and sent this patch independently.
>> - Invoke vfio_pci_set_power_state() before invoking reset related API's.
>> - Removed saving of power state locally.
>> - Removed warning before 'kfree(vdev->pm_save)'.
>> - Updated comments and commit message according to updated changes.
>>
>> * v1 of this patch was sent in
>> https://lore.kernel.org/lkml/20220124181726.19174-4-abhsahu@nvidia.com/
>>
>>  drivers/vfio/pci/vfio_pci_core.c | 27 +++++++++++++++++++++++++++
>>  1 file changed, 27 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index f948e6cd2993..d6dd4f7c4b2c 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -228,6 +228,13 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>       if (!ret) {
>>               /* D3 might be unsupported via quirk, skip unless in D3 */
>>               if (needs_save && pdev->current_state >= PCI_D3hot) {
>> +                     /*
>> +                      * If somehow, the vfio driver was not able to free the
>> +                      * memory allocated in pm_save, then free the earlier
>> +                      * memory first before overwriting pm_save to prevent
>> +                      * memory leak.
>> +                      */
>> +                     kfree(vdev->pm_save);
>>                       vdev->pm_save = pci_store_saved_state(pdev);
>>               } else if (needs_restore) {
>>                       pci_load_and_free_saved_state(pdev, &vdev->pm_save);
>> @@ -322,6 +329,12 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>       /* For needs_reset */
>>       lockdep_assert_held(&vdev->vdev.dev_set->lock);
>>
>> +     /*
>> +      * This function can be invoked while the power state is non-D0,
>> +      * Change the device power state to D0 first.
> 
> I think we need to describe more why we're doing this than what we're
> doing.  We need to make sure the device is in D0 in case we have a
> reset method that depends on that directly, ex. pci_pm_reset(), or
> possibly device specific resets that may access device BAR resources.
> I think it's placed here in the function so that the config space
> changes below aren't overwritten by restoring the saved state and maybe
> also because the set_irqs_ioctl() call might access device MMIO space.
> 
 
 Thanks Alex.
 I will add more details here in the comment.

>> +      */
>> +     vfio_pci_set_power_state(vdev, PCI_D0);
>> +
>>       /* Stop the device from further DMA */
>>       pci_clear_master(pdev);
>>
>> @@ -921,6 +934,13 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>                       return -EINVAL;
>>
>>               vfio_pci_zap_and_down_write_memory_lock(vdev);
>> +
>> +             /*
>> +              * This function can be invoked while the power state is non-D0,
>> +              * Change the device power state to D0 before doing reset.
>> +              */
> 
> See below, reconsidering this...
> 
>> +             vfio_pci_set_power_state(vdev, PCI_D0);
>> +
>>               ret = pci_try_reset_function(vdev->pdev);
>>               up_write(&vdev->memory_lock);
>>
>> @@ -2055,6 +2075,13 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>       }
>>       cur_mem = NULL;
>>
>> +     /*
>> +      * This function can be invoked while the power state is non-D0.
>> +      * Change power state of all devices to D0 before doing reset.
>> +      */
> 
> Here I have trouble convincing myself exactly what we're doing.  As you
> note in patch 1/ of the RFC series, pci_reset_bus(), or more precisely
> pci_dev_save_and_disable(), wakes the device to D0 before reset, so we
> can't be doing this only to get the device into D0.  The function level
> resets do the same.
> 
> Actually, now I'm remembering and debugging where I got myself confused
> previously with pci_pm_reset().  The scenario was a Windows guest with
> an assigned Intel 82574L NIC.  When doing a shutdown from the guest the
> device is placed in D3hot and we enter vfio_pci_core_disable() in that
> state.  That function however uses __pci_reset_function_locked(), which
> skips the pci_dev_save_and_disable() since much of it is redundant for
> that call path (I think I generalized this to all flavors of
> pci_reset_function() in my head).

 Thanks for providing the background related with the original issue.

> 
> The standard call to pci_try_reset_function(), as in the previous
> chunk, will make use of pci_dev_save_and_disable(), so for either of
> these latter cases the concern cannot be simply having the device in D0,
> we need a reason that we want the previously saved state restored on the
> device before the reset, and thus restored to the device after the
> reset as the rationale for the change.
> 

 I will add this as a comment.

>> +     list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
>> +             vfio_pci_set_power_state(cur, PCI_D0);
>> +
>>       ret = pci_reset_bus(pdev);
>>
>>  err_undo:
> 
> 
> We also call pci_reset_bus() in vfio_pci_dev_set_try_reset().  In that
> case, none of the other devices can be in use by the user, but they can
> certainly be in D3hot with previous device state saved off into our
> pm_save cache.  If we don't have a good reason to restore in that case,
> I'm wondering if we really have a good reason to restore in the above
> two cases.
> 
> Perhaps we just need the first chunk above to resolve the memory leak,

 First chunk means only the changes done in vfio_pci_set_power_state()
 which is calling kfree() before calling pci_store_saved_state().
 Or I need to include more things in the first patch ?

 With the kfree(), the original memory leak issue should be solved.

> and the second chunk as a separate patch to resolve the issue with
> devices entering vfio_pci_core_disable() in non-D0 state.  Sorry if I

 And this second patch will contain rest of the things where
 we will call vfio_pci_set_power_state() explicitly for moving to
 D0 state ?

 Also, We need to explore if setting to D0 state is really required at
 all these places and If it is not required, then we don't need second
 patch ?

 Thanks,
 Abhishek 

> mislead you that we had a more widespread issue with pci_pm_reset(), it
> wasn't clear in my head until now that it was only the
> __pci_reset_function_locked() caller that had the issue.  Thanks,
> 
> Alex
> 

