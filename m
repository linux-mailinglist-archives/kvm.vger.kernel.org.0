Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893044A451B
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 12:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377381AbiAaLgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 06:36:35 -0500
Received: from mail-mw2nam12on2050.outbound.protection.outlook.com ([40.107.244.50]:48000
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1378607AbiAaLe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 06:34:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMvDTkFIGsoLpjJ0UDa5FDIBqwPwrEp7f00np7ghnN7Es5Zesf4eVN0vOUBmhblVxk9tRNOFrLn0RANKtBT2lTw2S7IA5qx3A8ZAGZBYChtNkLYuzG9ekOuddGCtUTtxbhtdKMbE5JjJK93hRzfOAzG7zHqDBobM5hIJlQot6DMrRXcELzAccoHSlMvm1IeZjoUS3isvZLT8SC9HjIK5ljnYpEB63e282qf26gmAOpUVw9jF216zEvtUs1fGB/TBRmz4tv0ibUHZjXhc20kv6btVq9P7MmVW08Ss5JHhD1XUa6ZMe6hBwZGGJe3ecq7jD/Z68Ifyw84Y7uBUawJjQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FEHsRUfgu54QcIDnEvpXH9IHwL+46yKP+YeRjte9QY=;
 b=jS7kDAvadCkJaO6kVROK2SYCyDPildK9qZqt5LNao6TPLQearpnT3PZQrLATgQii/09kBwfXd7KV2EQZCGc8DyYmnDYNvhAxwE5h1KSUrf5fAWbd4wmAikxW9zfBUwDUXjFFU1aF9F2f/jKB2D6/v12kL9ICMxbVl35FvA6/XCVwwXRt1hvIqd1RbvfagENV2BVnU1q0ysDailF1up59P32CfTufZY1nAcVb+aaLPYje3cq/i3raC094hnGcjmJU9aB2ETQgLvqICsCDj56ngl5sg2NhjIAewg5OoZx3hTbngC3WM+4zq8ILSLehqAgGGnvlO5eUMQnKpU2gAJ+Eew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FEHsRUfgu54QcIDnEvpXH9IHwL+46yKP+YeRjte9QY=;
 b=kATB7AmZb2PPiAFdCjjdF/0WuJ4aLXJh7KKrLFxPBHe2pHBjduFsgbFsFrZqieZZuuYe7dWdrbs9wZPyK5MiTNWG/QDZc8f97FsTKEP0ncs/vjFAKTwQdpUccDeEoYvVHr+NSKw0V7NjGimyNB/m8wUrGI/xCKoo05HoIzY/Me/Zdk9ZyRrceaY4C+5TZfUD2D2jvsjPfVxKogCe9KpxHIUgZRMcuLuXKhZpenWgXQ14ZDmScZ5412W4qfiTb3EAWLjAQN5MK0gFSRJfcYC73ubN008hhF6BlCrhk5l6ud5PCl8abVoAEVLoCwN3zUSfL0gKFk1/KFrRX2emOCwGug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by DM6PR12MB4532.namprd12.prod.outlook.com (2603:10b6:5:2af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 11:34:26 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::5565:cbe5:8a6c:c010]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::5565:cbe5:8a6c:c010%4]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 11:34:26 +0000
Message-ID: <b0f25525-362a-c2dc-f255-22fa533fda26@nvidia.com>
Date:   Mon, 31 Jan 2022 17:04:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v2 3/5] vfio/pci: fix memory leak during D3hot to D0
 tranistion
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
References: <20220124181726.19174-1-abhsahu@nvidia.com>
 <20220124181726.19174-4-abhsahu@nvidia.com>
 <20220127170525.51043f23.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From:   Abhishek Sahu <abhsahu@nvidia.com>
In-Reply-To: <20220127170525.51043f23.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0031.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::17) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc31e807-e970-49aa-1fdf-08d9e4ada27b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4532:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB45322158DC4EB4703E3718CDCC259@DM6PR12MB4532.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T6LZYK2Kyf6qgIfdfKHEhYURhsp1Rnp2KfgY6hVj7Crfzz3mIRMIsuhgBTS8AsnpNoQOgLEItRgOWsRBM9C2n8kP90bDZCqRFiYxwM5XLfepqu2FaWC1zy9G2DjuA362RyaoFHxmwPF0nW4Wr1MJ1SLQFmrEg0uQ9H7+qDPUm+Ajy86J5v8ZGB9v9f9L3CFWC++Z2JsBdYzXZw5pJrSWw2rRNBPZ4MzmnPL5ThVrhPVS6tG5BjYLI+A/ym8TDwym7pkNgnNslXwpz227ci4pJBh1320RHDazKv67djN9Np883VDCmASvC/qbUsga/XrrHLg+0dGj1OC9yL+srTHKNNwvz1YuSxXKL802nbeGbbrfJWq5SoxBmpaI/c0v3P1VAPAW0RJ1QVxYyHwgNwAYa5i+xk1alHKVfqKOz/Rw8H7SiR8kmDujfEJcY18usaD6qsIUH98Lhn5BMs7L3xPsYKTrzoYwqcrEkvI6of9Yj/Ra9NVtqAXgY/wi/xFI01G4078OLbPBKnqPPsINVWcF9NJtK/XrLoDNKazbVB95ZZUvJFgqjZTrmBBHu/aO0d8HpKwewr4Fag9ubjRFz+NARtkvYlSgjFr6vGAWyS/AqrGZWaKKOfcHlHOn5fj0CfOrEB7dIevMXoE9u/647fHPDTXQVuFgZM4038rDDmGvephel+S7LuwcizXDqZhjlZxpujutw2WXbIDMn8jxYgbfFrfFz9zLew8dvX2bvGbCA0IIKUQDx7IVr5UcX8odzzCK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(4326008)(86362001)(83380400001)(66556008)(66946007)(8936002)(31696002)(38100700002)(66476007)(8676002)(6916009)(6506007)(6666004)(6512007)(54906003)(53546011)(55236004)(6486002)(36756003)(5660300002)(508600001)(26005)(2616005)(31686004)(316002)(186003)(32563001)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm1tNmxKL2xZMVRtTFUydUoxcExhNWpQUEs2cml2VW02Um9nb1RldUsyOVpn?=
 =?utf-8?B?SHRqem9CZHBiM001MmxUR2s0ZjBkd1NwQ1BSa216MVI5eUdWb05pTmRQYzBJ?=
 =?utf-8?B?Z0tHenp6TXBIbWZuOW9RZThkQnJ2SEs4NDE4cFIxOGFmWW9URm5UcEtsK29V?=
 =?utf-8?B?b093ZHZrOUFDckhWeGRkVDVqK096bSsrZm5hSFFOdVNIdnZzSHFIOTJBY0VH?=
 =?utf-8?B?QWVhZGJRZ01lcWg2MDN3Z29WM2tOVkQ3c2ViTGcxY0VMYVoyeEN6T1orMkF0?=
 =?utf-8?B?Y0ZxWXJ5dVVDODlHQ1ZyeUMwS292T1c4QVZVWHIvd2lIdGNyTVB3WldSN094?=
 =?utf-8?B?d3dCc3BNRmFhM3BQcEtZbVFKZmZjbTBZMFF2SGxkV0RLanR5WFJyanZQVVBk?=
 =?utf-8?B?R1U1MTVER3djaGpWNVZpM2VMMnpJZFJXaW1seWtPQkpxUVV4dGd6OWM5N28r?=
 =?utf-8?B?c1ZXd2ZmTFA5eFlXL2t0VGRyV2p6dWF1QlZ5WXVqK3kvb2lSUkRURFIrTWEz?=
 =?utf-8?B?UFhLY1ZhNEM4RXZ6WkVBckhJUzVCTHdoRGRpb3RvRmRhc2FmcGsxaHNKSTFm?=
 =?utf-8?B?WWU4S2VMeFk2QXNIa1kvbkZWVFdoTHdXMzhsWWJyQXZzSkpoV2Z1cTM4M2VK?=
 =?utf-8?B?RTFmNm1NNloxWGpkdEpiL1FBM00xZ1Y2QklXb1d2UlNoelJFQVpjNk9Tdk9I?=
 =?utf-8?B?SmxQMms2M2kvbTdqWXFWbCtjS1ZMT0FYTncyUWhYL2FZY2NUWkJ2VGplWXQ4?=
 =?utf-8?B?MjJOck9Vd05qc2JiK2UvRVJDbEZoZUt3aWNPSG1FMmNUNWJKQlBOZ1R0aUM5?=
 =?utf-8?B?cktvNDgrdWEwd00zVjR2ZGVwZUJ2SFNiMUsrT3Q5WExhakxMbmQ0eStRNnpY?=
 =?utf-8?B?SW5wTFNyZlNjeStLdVFJTERzL3M3ZmhTbkFoUGgvYWNiektPd2Y2VkFyOE91?=
 =?utf-8?B?Y2lzdXQzYVI1K1Y2aDl0Y0lGM3BlZGs1QXRiYkdXYUwvVktPWFpNWTByeVFB?=
 =?utf-8?B?am5XYUpYdzdmNHdXcXB3NlBPcjdIQ2d5VHV5VWVvUnliU0VZLzUyN282bXVz?=
 =?utf-8?B?eTZkNmI4aGxQYWpIazdnU0RQWmtrclJ1Y1MvWFRDK1R5M2xJREpWZkJIUnFQ?=
 =?utf-8?B?MGJEaFpaT2NYZW9hbzByMHpORWh3NzVSdzZOVDM4NW5qM1BxMUFEY2EvUVZn?=
 =?utf-8?B?NjhIY0JWMjB6OHBzeFZZZjBzT0lQSTMrbHZlSGN0WkxFNUs0Ty9iWHlHdEpw?=
 =?utf-8?B?Y01obkM5c2JxRVJoTEI0aVpZQ2cwOXRaeXJndnZCRE1jaTN4dlFxZjVOMEtT?=
 =?utf-8?B?aTN0RkJENHRMM2c1QSt3R20vdjAzNmx6QTJJWGNVZ0hlZGxQSUxMQ1gwNCt6?=
 =?utf-8?B?M2hoMVJ6eXplOFNoTkd5aGg2RjdiaTdrUlZZNFIwcE9YaDBJaHhERHpGdGZn?=
 =?utf-8?B?ZFladlN6Tjk2MTdUamVBY0NXeFNjUFVEVXZLWlpWU2lMYjAvUC9oK2ljclpp?=
 =?utf-8?B?M2F3K2pJMWh3cC9PY2kyRm9Oc0JOZWlyZnhqOHRVQzJ4ZUJoSjRQY0tDRlVN?=
 =?utf-8?B?K3FzcjlyM3N3UEx0N0xmNXpRYTBmWWhiakhqcklsbm5yTnNEZUtyNlU3ZUgw?=
 =?utf-8?B?cnhqN0RhUEZWclpQbkJZdk5mVEplME9qRnQycjdhOUZPMzVKT01RMmJCWThn?=
 =?utf-8?B?MTRRaWJIdk1oang5OFlmRXJOYzl2TWxUcnJVU0VZTjZ3Q1dUV0dUU1Y5NWhv?=
 =?utf-8?B?c2Q3L1Y5bmV0elR3RGY4emsxdDlMZnJ1YzNiTVpESGNmQ2Y0a0tBVVdWWG5w?=
 =?utf-8?B?SlpETnlyL3lQQWx6OTR4WUJadFp1MXM0Wk5FdndrWGs2dW9qWWwwVC95cGZz?=
 =?utf-8?B?RzdabVU2bzBSYW5naUNTK0Y0WHhHUEJKaUx4UVZ1QUVqSFUyRTBRZ0RWRjZQ?=
 =?utf-8?B?d3FqcndUVTJqRU0rV296YkRzNWlVYWdpUUZzYytvckVQRzlaYmJkb2E5dzJh?=
 =?utf-8?B?KzZ4SW5Bd0xmTnJBV2RYcGVGYSs4TnAvZGhEOEFzVXc2b2MweE1tOXpWSDJs?=
 =?utf-8?B?UGJhTXFIQk5vMURtMFVrSmhEYytOLzRGbGhkN1JuU1djM1FSNnNIWXJuUlRY?=
 =?utf-8?B?QTVoRHN4ZEkvNjhzOHZCeFRvWlFTaHRHU3pvRVc2cHZKVHRBVWtsTkM0VGpN?=
 =?utf-8?Q?mbxU6YAf6w/HeaMYRMKdhpQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc31e807-e970-49aa-1fdf-08d9e4ada27b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 11:34:26.0463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9UQ6IYgai95ucuLuE1dS5MLr2lxiSajzLf7CBVjtmqTwLT5GHRO6AiAU3lImQJkAY+Yq9mOtNM1pODdnDkTPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4532
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/2022 5:35 AM, Alex Williamson wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Mon, 24 Jan 2022 23:47:24 +0530
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
>> pm_save will never be freed.
>>
>> Also, in malicious sequence, the state changing to D3hot followed by
>> VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be run in loop and
>> it can cause an OOM situation. This patch stores the power state locally
>> and uses the same for comparing the current power state. For the
>> places where D0 transition can happen, call vfio_pci_set_power_state()
>> to transition to D0 state. Since the vfio power state is still D3hot,
>> so this D0 transition will help in running the logic required
>> from D3hot->D0 transition. Also, to prevent any miss during
>> future development to detect this condition, this patch puts a
>> check and frees the memory after printing warning.
>>
>> This locally saved power state will help in subsequent patches
>> also.
> 
> Ideally let's put fixes patches at the start of the series, or better
> yet send them separately, and don't include changes that only make
> sense in the context of a subsequent patch.
> 
> Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
> 

 Thanks Alex for reviewing this patch.
 I have added Fixes tag and sent this patch separately.

 Should I update this patch series or you are planning to review the
 other patches first of this patch series first. 

>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_core.c | 53 ++++++++++++++++++++++++++++++--
>>  include/linux/vfio_pci_core.h    |  1 +
>>  2 files changed, 51 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index c6e4fe9088c3..ee2fb8af57fa 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -206,6 +206,14 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
>>   * restore when returned to D0.  Saved separately from pci_saved_state for use
>>   * by PM capability emulation and separately from pci_dev internal saved state
>>   * to avoid it being overwritten and consumed around other resets.
>> + *
>> + * There are few cases where the PCI power state can be changed to D0
>> + * without the involvement of this API. So, cache the power state locally
>> + * and call this API to update the D0 state. It will help in running the
>> + * logic that is needed for transitioning to the D0 state. For example,
>> + * if needs_pm_restore is set, then the PCI state will be saved locally.
>> + * The memory taken for saving this PCI state needs to be freed to
>> + * prevent memory leak.
>>   */
>>  int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
>>  {
>> @@ -214,20 +222,34 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>       int ret;
>>
>>       if (vdev->needs_pm_restore) {
>> -             if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
>> +             if (vdev->power_state < PCI_D3hot && state >= PCI_D3hot) {
>>                       pci_save_state(pdev);
>>                       needs_save = true;
>>               }
>>
>> -             if (pdev->current_state >= PCI_D3hot && state <= PCI_D0)
>> +             if (vdev->power_state >= PCI_D3hot && state <= PCI_D0)
>>                       needs_restore = true;
>>       }
>>
>>       ret = pci_set_power_state(pdev, state);
>>
>>       if (!ret) {
>> +             vdev->power_state = pdev->current_state;
>> +
>>               /* D3 might be unsupported via quirk, skip unless in D3 */
>> -             if (needs_save && pdev->current_state >= PCI_D3hot) {
>> +             if (needs_save && vdev->power_state >= PCI_D3hot) {
>> +                     /*
>> +                      * If somehow, the vfio driver was not able to free the
>> +                      * memory allocated in pm_save, then free the earlier
>> +                      * memory first before overwriting pm_save to prevent
>> +                      * memory leak.
>> +                      */
>> +                     if (vdev->pm_save) {
>> +                             pci_warn(pdev,
>> +                                      "Overwriting saved PCI state pointer so freeing the earlier memory\n");
>> +                             kfree(vdev->pm_save);
>> +                     }
> 
> The minimal fix for the described issue would simply be:
> 
>                         kfree(vdev->pm_save);
> 
> It seems like the only purpose of the warning is try to make sure we
> haven't missed any wake-up calls, where this would be a pretty small
> breadcrumb to actually debug such an issue.
> 

 I have removed the warning in the updated patch.

>> +
>>                       vdev->pm_save = pci_store_saved_state(pdev);
>>               } else if (needs_restore) {
>>                       pci_load_and_free_saved_state(pdev, &vdev->pm_save);
>> @@ -326,6 +348,14 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>       /* For needs_reset */
>>       lockdep_assert_held(&vdev->vdev.dev_set->lock);
>>
>> +     /*
>> +      * If disable has been called while the power state is other than D0,
>> +      * then set the power state in vfio driver to D0. It will help
>> +      * in running the logic needed for D0 power state. The subsequent
>> +      * runtime PM API's will put the device into the low power state again.
>> +      */
>> +     vfio_pci_set_power_state(vdev, PCI_D0);
>> +
> 
> I do think we have an issue here, but the reason is that pci_pm_reset()
> returns -EINVAL if we try to reset a device that isn't currently in D0.
> Therefore any path where we're triggering a function reset that could
> use a PM reset and we don't know if the device is in D0, should wake up
> the device before we try that reset.
> 
> We're about to load the initial state of the device that was saved when
> it was opened, so I don't think pdev->current_state vs
> vdev->power_state matters here, we only care that the device is in D0.
> 

 I have added this point in the commit message of the updated patch.

>>       /* Stop the device from further DMA */
>>       pci_clear_master(pdev);
>>
>> @@ -929,6 +959,15 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>
>>               vfio_pci_zap_and_down_write_memory_lock(vdev);
>>               ret = pci_try_reset_function(vdev->pdev);
>> +
>> +             /*
>> +              * If pci_try_reset_function() has been called while the power
>> +              * state is other than D0, then pci_try_reset_function() will
>> +              * internally set the device state to D0 without vfio driver
>> +              * interaction. Update the power state in vfio driver to perform
>> +              * the logic needed for D0 power state.
>> +              */
>> +             vfio_pci_set_power_state(vdev, PCI_D0);
> 
> For the case where pci_try_reset_function() might use a PM reset, we
> should set D0 before that call.  In doing so, the pdev->current_state
> should match the actual device power state, so we still don't need to
> stash power state on the vdev.
> 

 I have set D0 state before calling pci_try_reset_function() in
 the updated patch.

>>               up_write(&vdev->memory_lock);
>>
>>               return ret;
>> @@ -2071,6 +2110,14 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>
>>  err_undo:
>>       list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
>> +             /*
>> +              * If pci_reset_bus() has been called while the power
>> +              * state is other than D0, then pci_reset_bus() will
>> +              * internally set the device state to D0 without vfio driver
>> +              * interaction. Update the power state in vfio driver to perform
>> +              * the logic needed for D0 power state.
>> +              */
>> +             vfio_pci_set_power_state(cur, PCI_D0);
> 
> Here pci_reset_bus() will wakeup the device and I think the concern is
> that around that bus reset we'll save and restore the device state, but
> that's potentially bogus device state if waking it triggers a soft
> reset.  We could again wake devices before the reset to make the state
> correct, or we could test pm_save and perform the load and restore if
> it exists.  Either of those would avoid needing to cache the power
> state on the vdev.  Thanks,
> 

 I have made the changes to wake-up the devices.

 Thanks
 Abhishek

> Alex
> 
>>               if (cur == cur_mem)
>>                       is_mem = false;
>>               if (cur == cur_vma)
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index aafe09c9fa64..05db838e72cc 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -124,6 +124,7 @@ struct vfio_pci_core_device {
>>       bool                    needs_reset;
>>       bool                    nointx;
>>       bool                    needs_pm_restore;
>> +     pci_power_t             power_state;
>>       struct pci_saved_state  *pci_saved_state;
>>       struct pci_saved_state  *pm_save;
>>       int                     ioeventfds_nr;
> 

