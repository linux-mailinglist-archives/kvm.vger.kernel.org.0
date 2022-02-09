Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517944AF306
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 14:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiBINjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 08:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiBINjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 08:39:16 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466F0C0613C9;
        Wed,  9 Feb 2022 05:39:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRSUqTK4/E4YZuvVOkVxQ/9NvyqrMfdYMGVIFYWDVsa0p4SptlHl2ij8l0DfCgDd4aMztV/gtuOjN9Y1k9sx/dB9MKonY5A7HqmLqkcfohSJRjPzYlxBfSQ1SoPJ+KUAZyhcK4ck6o4bHIvxfPWi2PXi04d2IeeKxooqnkwB2jbA6nUK1WPkBJL2nMRjUURFofOoPQYyKfJfjaaRe87oEkaYTxgMzKM76hAVJhpSL9680yZ5JpbdcpnKC9G/lgGxOY8STk1T2C9hjWCdC9qze5S5lvp2cuVO12crF5To8LcChA8QbOdhvySgACkl7Kihd5uZMPGnzWJYPkwriQAUnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZWKJ9q21gJEM4U06MYgg5T1TMgxmEIkmsXpZq3NQWo=;
 b=FX2ik+CInFjrjzPYKhwbFDxq/MVDR6e04rSUJdL8MO0+ewSaqWiiMpMZjYc50w7eQCLBZ+zHyG9Mthw1c5fy7QFiiyKb6gKzjcgmcYM2RBPEMnI/mx5fZ76UKALaq+vbspZSY+01p0QJoUcRYpDl2uA3b64pzXltzp4n+EY/sQADz3kljdUse9Riy66TN+vUC04PO49mDucMU4XQFVQyqDfxkwS0W/pYA4BVmKtFgyfOB3Hlz8EGLYDj03pIRtTJicVSAPOx/m4tr/THLeqnDVy71voYCdX8xRZUoNA6XF6tcYoFZtA0Z7J0XbUtPgJiuD7w+L+lvspR9rb6ibVChQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZWKJ9q21gJEM4U06MYgg5T1TMgxmEIkmsXpZq3NQWo=;
 b=TlutHxPI0z6OZsYtzAfGsdHWRHy0a8ZYX9ygiRaLRln+wvNgBx2YjxlyCrzwi19o2eB6quCIXnYohjwrMEkKN3jVJoAbOAFwGUJKwbws/b7Ucul0ejZ/IDTXYUomj/PNolk+PirmuCGiMuIZY9WKX3emoNqxkEjT4oTSLfC2E+nIBSgMyND2mFHvKV6wDTaE9WXmRogirbaTMfhqHA5Wld4WXp4nmu00+kv0FSL+j0frQaUAFHcH7CkoVDtfHkA6azchA9ALLm1DIw8/iu5ILd8tMI7uXDYs9xk5kXxEFm/UFyKBuvvBdafl0Pf9xIflJveKNOOhGc+X0EVRw20PHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by BY5PR12MB4258.namprd12.prod.outlook.com (2603:10b6:a03:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 9 Feb
 2022 13:39:17 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::c1b2:224f:101a:a588]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::c1b2:224f:101a:a588%5]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 13:39:17 +0000
Message-ID: <3575db8e-1752-1216-071a-776a65065ddd@nvidia.com>
Date:   Wed, 9 Feb 2022 19:09:02 +0530
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
 <948e7798-7337-d093-6296-cedd09c733f5@nvidia.com>
 <20220201163155.0529edc1.alex.williamson@redhat.com>
 <f7167fa2-f75c-3fc2-7061-adc7de83f571@nvidia.com>
 <20220208142624.4700fb21.alex.williamson@redhat.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <20220208142624.4700fb21.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::14) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 760e1bdc-39d1-497c-a095-08d9ebd1910c
X-MS-TrafficTypeDiagnostic: BY5PR12MB4258:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42589DC0C1F47A362C0AC594CC2E9@BY5PR12MB4258.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJ44oTO/Ul3OFD1j6P9FgmehAvf1qsMMooDuUzh7pGyC2Pa11Pa2D7DFzfE5wUHiT+24vL9ABrUYGWZedLnbd8nIna4Vq8Psu+KSNOL5MVw91ZtvKA+UfRPuV/2FLZoIGQ8RcjweBGNiCbBUmEhbeg5vGwpDn81uHkLwQtdOYYOTzSJ+NsltSO1JiLTvIDrNvH0IRHjMoIig/Rpvt1J4Wb3xppV5YURYlvmNI1k2vlGTQhR8Sl38buDL2+yEPd7QprSrY3t68aGSs8/yf+Qn4iwwWjJvuGW83qhdSgVljEkea6WlyeLokMMQinV5iNVwX8TFxHLyp5xktkkLUmP3mbll90irgeNTh6avkzt3xmCL6TqjqSSRHaOPiwicTL/9/wLFBDtG4WiraGrMjWhqOVcCYltNgD8wExoE5+hcSamgxXzmyxnaRJQvNFJOfhqKUFja2fOuWESEFMmOiPiMlw9cdCSRp7CG7Mb2MyG7Aaxfzpe749piMvuyuwqpBC0o+8MrYZYf9WNfHdj19z4IeIjvHIJHWcaKQ7wA3SucAl8QpANPkFGbPzQXXk3nMPkCKJWLQ5rYMGmasqRxwy4ijSwvZWp+uxCrSVQcSK2mSgl+hmlsGxy6Zc8pNHHTEuJh+guJy/D49/ORGxHGdvLDXXVTYgIvHFnXj/gBRBucSzfDWKlD1gQg6Fe42N12SdDXkgF6HFIGtq/JtmqPt+TKeEYCbpZInHuB/xHZjhgXjP4SHbXHE82klgrrzVbEovEFei1ZdXlhcmDcpVmtgs7GLJ1hdN4WbBgW72OoTZbfeh1N7KE2dNjgD8DoYycu09SEjOnEsSJLIroZckrYcV8puNcKFRElAM0biAq15k+E8HM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(55236004)(54906003)(6512007)(6666004)(6506007)(31696002)(53546011)(966005)(6486002)(86362001)(8676002)(8936002)(4326008)(316002)(508600001)(66476007)(5660300002)(83380400001)(66556008)(66946007)(30864003)(31686004)(38100700002)(2906002)(36756003)(26005)(2616005)(186003)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WG1iMGpZcHhOYTNyOXUra3lCVGZ1SENncnlYLzI0OVVQeUtvWmNWRkNPNnVL?=
 =?utf-8?B?YlFVRmVZUVcyY0pUcjd3enYzcnhFWFAzZm8zSWt5c2NxTHJjbmdsU1dxYnFT?=
 =?utf-8?B?RElHMzBzMndMNUZUUVlydzg5T2VDaFlYaEFLa3RpMERhQm4wemd4bGk5OVB3?=
 =?utf-8?B?a3h4UEhaMEFsRHZ6M1FXaVRWMzN5UGR3TDkwc1ZtYTZjbHp6S2FNMWNPL0w5?=
 =?utf-8?B?NmpBR2pqYThVc21EWVM4dWdqRTV3dytCZ2JYeTlWWEpPa1lVTFlMVTB1eUZJ?=
 =?utf-8?B?MmdwczB2bFVMWlRQTEMzSGU1RTZUM0hBejYyKzVieGJ0ckZhTjZBamFTSkti?=
 =?utf-8?B?cmZnbHlNRWw5UGRLVFA1YWEyWEJTdjFTTVVHQ3lrVTFJbXI3Y0hWQTk2UEVy?=
 =?utf-8?B?TDFLTFQzbzV6QWt6enFiLzFwVzE0YnNoajdWRnFLODMyZzJqK092Z2dQMGU0?=
 =?utf-8?B?RkNsc3hsb0x0cWZvSS9kZy95enZCL0ZNanRTSzRNNEsyZDBocjRPQU1Yd2FB?=
 =?utf-8?B?ME01aWllYUl1M0ZQb05wTHlybExOY3V3eCtPaUVES0tzQmg2TFZmSEhSWXpv?=
 =?utf-8?B?MHIxTE84R3lwRWM1N3VlQzMzTmFFNnkvVzZWRDczdXZ3OG03MFZUSVR6cHZJ?=
 =?utf-8?B?ZDRBM1F1eXhnd0JXMGNHOVVmYkFZTXBaZEQ5KzNQRkdzTXB1d2xvRFYzeFRC?=
 =?utf-8?B?N3FHQ2ZhbEgzemxxNkNYTDduL3RDVHU5NkdRbXNxTTRJUkEzNm9jWC8xL0Iz?=
 =?utf-8?B?VnZSckNmbFZQMGZ1MmJuWFQvSUlYeFBEUDZQNTVKUm5BZ1F5NTU2bkNZdXJq?=
 =?utf-8?B?d2NTTDQ0eGVTYldhR2RsNEZ1MldjSmVhMVJ2UWg3d2VObVdoMVpndkFwQitB?=
 =?utf-8?B?ak1aNHhJejVIMm5jaGo5dENSVmRCcEFpdWZLNHU4YU11UmNuYk1hRmRVTUsz?=
 =?utf-8?B?dmE4TTRBTWVzSUI1V1RpUWVQSUh5S1BlWFFSSTNBYTRGWXQ0WHRMYkFJSTEr?=
 =?utf-8?B?MEZjTXRUZXBuWFhZWmtaUktnaG1yU3pJVFp4cmdqM3JWK3hRUHp6UDYvTk1w?=
 =?utf-8?B?b2srWi9BaVBUcy9mNVhEbnRFM3ROWkZ2Y0JoQ29USGx2VWtabWNPeVJGWW1K?=
 =?utf-8?B?ZjZsaXFVMEdsZHl2SFJVVlFOT1ZYWDJDR1pkR1ViOThjWUxIdjVlWEM5Wmp0?=
 =?utf-8?B?ZDVaUHo1RjQ2NlFrTWFadUpQa1I2WmswTFVvZitibTg0aFA2d3JsaEMvUTZa?=
 =?utf-8?B?UVJrWjd1MERNdlllK3kzR3ZKK09yOTIyQzFacm1RdUIzT0p6WlMwS1dMeS8x?=
 =?utf-8?B?dnl1QkNIbHp2YXNCaGRkUHVFUkpGbmIzalFSTWlCWU5icU9sMndZK045WFFa?=
 =?utf-8?B?M3pSMDlVNEhWanBRQUJNcVhSdnJEOFpPUG1WalE5bG5UK1BqSEJ4NUxNcXNX?=
 =?utf-8?B?b0pyOG1CVkNWTVk1b29sbm1jMFJZZVpMNnBmOUhtTDVzWHJ1dURQSnp2a2Nl?=
 =?utf-8?B?MVA1Zy9ZTGZLWTQ2MU51S2Y1dFYxOW02bFFESy9LN3d5b0ZEaEh3bWdoVGs4?=
 =?utf-8?B?SnhvbkphSEE2RUxCNXgzRlRyWE1Qdy82TWRzcy9rbmZKL0NBSHd2TSt1Y0FQ?=
 =?utf-8?B?dHlXcTYrTDJ5dUxYNEFDT2JOTmllSlpYUHp3S0lqNU16NFo4dllzTUVFTlIz?=
 =?utf-8?B?eGJKWFkzZmVZZnVkRHJjbmQ5S0I4WlZneGNjc09qcEsyNXNGdDFMSEZ3S1Iy?=
 =?utf-8?B?VHdTendOT1JkaVdZNEU0aXFjd0Mxb0tCRmhqcDBsZjhlTE9TTXdUdTJrU2Zk?=
 =?utf-8?B?YzBZN2pRQWs2Y2V1ZHk5alpJcjNyV2p2SXNVWmN3L0VFbktpQjNkcHVQaU8y?=
 =?utf-8?B?Z3I0dzVZbWxTSFhtcC85ejlSOUV5bkNZSnpDVHd3cmtGaXQ5dnh3K29KRVg2?=
 =?utf-8?B?WlNlL3NqZzR6ZkI4cnJBUFBET0pReXZadHNxcHh1QUdCVVA1WE9lMm1LZ25M?=
 =?utf-8?B?T0puYVh5bTVOUDRGOVIwRVpGb01LTU42WnBTcXJGVlJhK09oQitWKys1dGNn?=
 =?utf-8?B?UGRBeklhR3kyLyt1cTRtT3ZVWU02MDJrcGw0T2EvSnNWZ2ZPaFBwMVQxODY2?=
 =?utf-8?B?WDJJZEFOU21EbDhCb2VTbWVybnZaOWhtQ2EzRXFGejFDemNYRlpOV0E5OFNr?=
 =?utf-8?Q?BioSa89e4gwq/hT1/WBzD8A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760e1bdc-39d1-497c-a095-08d9ebd1910c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 13:39:16.9632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSfVl/GHvlpBh1BwM6IOUo0XMHG7ZaYwf98GT/THoZIGscaDt+3KKK77ioGJa4r0ywDQpT57jY79+xurMul2cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4258
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/2022 2:56 AM, Alex Williamson wrote:
> On Tue, 8 Feb 2022 00:50:08 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
>> On 2/2/2022 5:01 AM, Alex Williamson wrote:
>>> On Tue, 1 Feb 2022 17:06:43 +0530
>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>
>>>> On 2/1/2022 1:41 AM, Alex Williamson wrote:
>>>>> On Mon, 31 Jan 2022 16:54:50 +0530
>>>>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
>>>>>
>>>>>> If needs_pm_restore is set (PCI device does not have support for no
>>>>>> soft reset), then the current PCI state will be saved during D0->D3hot
>>>>>> transition and same will be restored back during D3hot->D0 transition.
>>>>>> For saving the PCI state locally, pci_store_saved_state() is being
>>>>>> used and the pci_load_and_free_saved_state() will free the allocated
>>>>>> memory.
>>>>>>
>>>>>> But for reset related IOCTLs, vfio driver calls PCI reset related
>>>>>> API's which will internally change the PCI power state back to D0. So,
>>>>>> when the guest resumes, then it will get the current state as D0 and it
>>>>>> will skip the call to vfio_pci_set_power_state() for changing the
>>>>>> power state to D0 explicitly. In this case, the memory pointed by
>>>>>> pm_save will never be freed. In a malicious sequence, the state changing
>>>>>> to D3hot followed by VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be
>>>>>> run in a loop and it can cause an OOM situation.
>>>>>>
>>>>>> Also, pci_pm_reset() returns -EINVAL if we try to reset a device that
>>>>>> isn't currently in D0. Therefore any path where we're triggering a
>>>>>> function reset that could use a PM reset and we don't know if the device
>>>>>> is in D0, should wake up the device before we try that reset.
>>>>>>
>>>>>> This patch changes the device power state to D0 by invoking
>>>>>> vfio_pci_set_power_state() before calling reset related API's.
>>>>>> It will help in fixing the mentioned memory leak and making sure
>>>>>> that the device is in D0 during reset. Also, to prevent any similar
>>>>>> memory leak for future development, this patch frees memory first
>>>>>> before overwriting 'pm_save'.
>>>>>>
>>>>>> Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
>>>>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
>>>>>> ---
>>>>>>
>>>>>> * Changes in v2
>>>>>>
>>>>>> - Add the Fixes tag and sent this patch independently.
>>>>>> - Invoke vfio_pci_set_power_state() before invoking reset related API's.
>>>>>> - Removed saving of power state locally.
>>>>>> - Removed warning before 'kfree(vdev->pm_save)'.
>>>>>> - Updated comments and commit message according to updated changes.
>>>>>>
>>>>>> * v1 of this patch was sent in
>>>>>> https://lore.kernel.org/lkml/20220124181726.19174-4-abhsahu@nvidia.com/
>>>>>>
>>>>>>  drivers/vfio/pci/vfio_pci_core.c | 27 +++++++++++++++++++++++++++
>>>>>>  1 file changed, 27 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>>>>>> index f948e6cd2993..d6dd4f7c4b2c 100644
>>>>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>>>> @@ -228,6 +228,13 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>>>>>>       if (!ret) {
>>>>>>               /* D3 might be unsupported via quirk, skip unless in D3 */
>>>>>>               if (needs_save && pdev->current_state >= PCI_D3hot) {
>>>>>> +                     /*
>>>>>> +                      * If somehow, the vfio driver was not able to free the
>>>>>> +                      * memory allocated in pm_save, then free the earlier
>>>>>> +                      * memory first before overwriting pm_save to prevent
>>>>>> +                      * memory leak.
>>>>>> +                      */
>>>>>> +                     kfree(vdev->pm_save);
>>>>>>                       vdev->pm_save = pci_store_saved_state(pdev);
>>>>>>               } else if (needs_restore) {
>>>>>>                       pci_load_and_free_saved_state(pdev, &vdev->pm_save);
>>>>>> @@ -322,6 +329,12 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>>>>>>       /* For needs_reset */
>>>>>>       lockdep_assert_held(&vdev->vdev.dev_set->lock);
>>>>>>
>>>>>> +     /*
>>>>>> +      * This function can be invoked while the power state is non-D0,
>>>>>> +      * Change the device power state to D0 first.
>>>>>
>>>>> I think we need to describe more why we're doing this than what we're
>>>>> doing.  We need to make sure the device is in D0 in case we have a
>>>>> reset method that depends on that directly, ex. pci_pm_reset(), or
>>>>> possibly device specific resets that may access device BAR resources.
>>>>> I think it's placed here in the function so that the config space
>>>>> changes below aren't overwritten by restoring the saved state and maybe
>>>>> also because the set_irqs_ioctl() call might access device MMIO space.
>>>>>
>>>>
>>>>  Thanks Alex.
>>>>  I will add more details here in the comment.
>>>>
>>>>>> +      */
>>>>>> +     vfio_pci_set_power_state(vdev, PCI_D0);
>>>>>> +
>>>>>>       /* Stop the device from further DMA */
>>>>>>       pci_clear_master(pdev);
>>>>>>
>>>>>> @@ -921,6 +934,13 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>>>>>>                       return -EINVAL;
>>>>>>
>>>>>>               vfio_pci_zap_and_down_write_memory_lock(vdev);
>>>>>> +
>>>>>> +             /*
>>>>>> +              * This function can be invoked while the power state is non-D0,
>>>>>> +              * Change the device power state to D0 before doing reset.
>>>>>> +              */
>>>>>
>>>>> See below, reconsidering this...
>>>>>
>>>>>> +             vfio_pci_set_power_state(vdev, PCI_D0);
>>>>>> +
>>>>>>               ret = pci_try_reset_function(vdev->pdev);
>>>>>>               up_write(&vdev->memory_lock);
>>>>>>
>>>>>> @@ -2055,6 +2075,13 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>>>>>       }
>>>>>>       cur_mem = NULL;
>>>>>>
>>>>>> +     /*
>>>>>> +      * This function can be invoked while the power state is non-D0.
>>>>>> +      * Change power state of all devices to D0 before doing reset.
>>>>>> +      */
>>>>>
>>>>> Here I have trouble convincing myself exactly what we're doing.  As you
>>>>> note in patch 1/ of the RFC series, pci_reset_bus(), or more precisely
>>>>> pci_dev_save_and_disable(), wakes the device to D0 before reset, so we
>>>>> can't be doing this only to get the device into D0.  The function level
>>>>> resets do the same.
>>>>>
>>>>> Actually, now I'm remembering and debugging where I got myself confused
>>>>> previously with pci_pm_reset().  The scenario was a Windows guest with
>>>>> an assigned Intel 82574L NIC.  When doing a shutdown from the guest the
>>>>> device is placed in D3hot and we enter vfio_pci_core_disable() in that
>>>>> state.  That function however uses __pci_reset_function_locked(), which
>>>>> skips the pci_dev_save_and_disable() since much of it is redundant for
>>>>> that call path (I think I generalized this to all flavors of
>>>>> pci_reset_function() in my head).
>>>>
>>>>  Thanks for providing the background related with the original issue.
>>>>
>>>>>
>>>>> The standard call to pci_try_reset_function(), as in the previous
>>>>> chunk, will make use of pci_dev_save_and_disable(), so for either of
>>>>> these latter cases the concern cannot be simply having the device in D0,
>>>>> we need a reason that we want the previously saved state restored on the
>>>>> device before the reset, and thus restored to the device after the
>>>>> reset as the rationale for the change.
>>>>>
>>>>
>>>>  I will add this as a comment.
>>>>
>>>>>> +     list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
>>>>>> +             vfio_pci_set_power_state(cur, PCI_D0);
>>>>>> +
>>>>>>       ret = pci_reset_bus(pdev);
>>>>>>
>>>>>>  err_undo:
>>>>>
>>>>>
>>>>> We also call pci_reset_bus() in vfio_pci_dev_set_try_reset().  In that
>>>>> case, none of the other devices can be in use by the user, but they can
>>>>> certainly be in D3hot with previous device state saved off into our
>>>>> pm_save cache.  If we don't have a good reason to restore in that case,
>>>>> I'm wondering if we really have a good reason to restore in the above
>>>>> two cases.
>>>>>
>>>>> Perhaps we just need the first chunk above to resolve the memory leak,
>>>>
>>>>  First chunk means only the changes done in vfio_pci_set_power_state()
>>>>  which is calling kfree() before calling pci_store_saved_state().
>>>>  Or I need to include more things in the first patch ?
>>>
>>> Correct, first chunk as is the first change in the patch.  Patch chunks
>>> are delineated by the @@ offset lines.
>>>
>>
>>  Thanks for confirming this.
>>
>>>>
>>>>  With the kfree(), the original memory leak issue should be solved.
>>>>
>>>>> and the second chunk as a separate patch to resolve the issue with
>>>>> devices entering vfio_pci_core_disable() in non-D0 state.  Sorry if I
>>>>
>>>>  And this second patch will contain rest of the things where
>>>>  we will call vfio_pci_set_power_state() explicitly for moving to
>>>>  D0 state ?
>>>
>>> At least the first one in vfio_pci_core_disable(), the others need
>>> justification.
>>>
>>
>>  Yes. First one is needed.
>>
>>>>  Also, We need to explore if setting to D0 state is really required at
>>>>  all these places and If it is not required, then we don't need second
>>>>  patch ?
>>>
>>> We need a second patch, I'm convinced that we don't otherwise wake the
>>> device to D0 before we potentially get to pci_pm_reset() in
>>> vfio_pci_core_disable().  It's the remaining cases of setting D0 that
>>> I'm less clear on.  If it's the case that we need to restore config
>>> space any time a NoSoftRst- device is woken from D3hot and the state
>>> saved and restored around the reset is meaningless otherwise, that's a
>>> valid justification, but is it accurate?  If so, we should recheck the
>>> other case of calling pci_reset_bus() too.  Thanks,
>>>
>>> Alex
>>>
>>
>>  I was analyzing this part in detail and added some debug prints and
>>  made user space program to understand it better. Also, I have gone
>>  through the patch 51ef3a004b1e (“vfio/pci: Restore device state on
>>  PM transition”).
>>
>>  We have 2 cases here:
>>
>>  1. The devices which has NoSoftRst+  (needs_pm_restore is false).
>>     This case should work fine for all the cases (Apart from vfio_pci_core_disable())
>>     without waking-up the device explicitly.
>>
>>  2. The devices which has NoSoftRst- (needs_pm_restore is true).
>>
>>  For case 2, let’s consider following example:
>>
>>  a. The device is in D3hot.
>>  b. User made VFIO_DEVICE_RESET ioctl.
>>  c. pci_try_reset_function() will be called which internally
>>     invokes pci_dev_save_and_disable().
>>  d. pci_set_power_state(dev, PCI_D0) will be called first.
>>  e. pci_save_state() will happen then.
>>
>>  Now, for the devices which has NoSoftRst-,
>>  the pci_set_power_state() should trigger soft reset and
>>  we may lose the original state at step (d) and this state
>>  cannot be restored.
>>
>>  For example, lets assume the case, where SBIOS or host
>>  linux kernel (In the aspm.c) enables PCIe LTR setting for the
>>  PCIe device. When this soft reset will be triggered, then this
>>  LTR setting may be reset, and the device state saved at step (e)
>>  will also have this setting cleared so it cannot be restored.
>>  Same thing can be happened for other PCIe capabilities. Since the
>>  vfio driver only exposes limited enhanced capabilities to its user
>>  So, the vfio-driver user also won’t have option to save and
>>  restore these capabilities state and these original
>>  settings will be permanently lost.
> 
> Yes, this is my concern, thanks for confirming.
> 
>>  So, it seems we need to always move the device explicitly to
>>  D0 state by calling vfio_pci_set_power_state() before
>>  any reset for the reset triggered by IOCTLs. This is mainly to
>>  preserve the state around soft reset.
> 
> The other option would be to test for vdev->pm_save and if found do a
> load-and-free + restore-state after reset.  For simplicity, I'd tend to
> favor your approach to wake the device with vfio_pci_set_power_state()
> before reset.  Either approach seems roughly equal to me.
> 
>>  For vfio_pci_dev_set_try_reset() also, we can have the above
>>  mentioned situation. The other functions/devices can be in D3hot
>>  state and the D0 transition can cause soft reset there also.
>>  For example, in my case, NVIDIA GPU has VGA (func 0) and audio
>>  (func 1) function. I added debug print to dump the current state
>>  before and after pci_reset_bus(). Before pci_reset_bus() the func 1
>>  state was D3hot and after pci_reset_bus() the func 1 state got
>>  changed to D0. This pci_reset_bus() was called during closing of
>>  func 0 device so there are chances of soft reset for other
>>  function/devices.
> 
> Ok, so we'll always wakeup devices for both the pci_reset_function()
> class of resets and bus resets.  This seems to logically fit with the
> fix to wakeup the device on release, so shall we do patch 1 of the
> fixes series includes the kfree only and patch 2 resolves all the cases
> of waking devices before reset?  Thanks,
> 
> Alex
> 

 Thanks. I will make 2 patches and will send for review.

 Regards,
 Abhishek
