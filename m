Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C156A6BE7
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 12:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCALxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 06:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCALxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 06:53:31 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A4C241C5
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 03:53:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYXEG1cepupmcA45p0ximdV6IAixKxbgaKevqty05MJM8t4r02+6Of4zYpAB6EnC7twxrE1ldFA0w3GI9VbWHxFoIVEeNZhSCvhqz7NY2yRVc10+4Cd95Ze+io2kbRv/ID0PazYPrmM4FI/AE9hGle2kJ88MVm5EFYlP9WDgkrBRqt59JpJW3ixll5d9WCOmIIMHw3nwFinUPHioSXhKelrdIHIzDCcsyZ4vaWJwWd/nlbZQ/CRV65BKYqYE01UDU1q9VjY2CS1lOGdiyC8d+7F2UIEI2OTv4Evg8L9K2shfPKXOLSo9Q3QsPpWoEPTfDvd4wjEnGaV7YJEFYm2bOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPLwTsRLU0aeLp076BGWJ67Jl98/mu7F7mSonQSrlxg=;
 b=NXlG7wAAEW3fywL9Scd+rf5S6tlj9gaFEmTZLnZ+5RP7/LbCrGsss7IS9QeHVADFtTCVBWHZJmcoeViZBXre9FHGwn8hHm5UgD37BCkFtU0Nm/+kL1saXWPJu/QKc6Q+K9h4dZrXCNquU3SFadRSnguHf7OUC3faQYjiiq8sEMrKTevG5PrvtSLtpoRHw8oyACKiIf1Fkp1y7pWwxlVo6o4s+Fq+IHf8YMbXMZSEofwq+YX2NZJKjHNfQJ6Ilu3ecUuMQS44AXjdGP0U823KZS2QfPiVaeiAJcaxE4de/qvjNJ+xxd9QqYnGc2z9+aKLfVcMMlHeTN376bW+wDo6Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPLwTsRLU0aeLp076BGWJ67Jl98/mu7F7mSonQSrlxg=;
 b=cObw5habeCyTmNmq+Pu6BrAs4O0Yxu+k8bZbZbd71LuOXDK9OuFrj3uDsvGTVGzU1KePWfOWC8ooMZ2rHqHVDNgboviGj5ygTxf2HsLYCp1rE7yCCrBcP+0WrcYLiCSteEhhapDpOWjbMTjLpNezIb3bPTIkMXPVWQaNcl0quV/j+q20ySeZNX/b++wjXjQgkpfMDZptdK14R+P6FwsCvXr3q8T87nxlVlZ1piJ6awlWC2AI+fN+5qWAbjJVVLiHiNPl6fYaNT30OhLIg/+rkDMqKJPSWPYGf45Iv3TMP8EOS+b3xwkj8jW0uA7J4K+PC2qdMOmrRWesPgr6t7CtWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by SA1PR12MB6679.namprd12.prod.outlook.com (2603:10b6:806:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Wed, 1 Mar
 2023 11:53:26 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::aca1:caca:b2d7:35f]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::aca1:caca:b2d7:35f%9]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 11:53:26 +0000
Message-ID: <80a7c60e-3c55-e920-e974-7b80868a6c53@nvidia.com>
Date:   Wed, 1 Mar 2023 17:23:14 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Bug: Completion-Wait loop timed out with vfio
Content-Language: en-US
To:     Tasos Sahanidis <tasos@tasossah.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
 <20230228114606.446e8db2.alex.williamson@redhat.com>
 <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1P287CA0023.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:35::28) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:EE_|SA1PR12MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: 68b896d9-52e1-4dbf-84c3-08db1a4b9107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ug1hizJheQXZ6BQIDwHekCXVus/HnPsLvr0Z/w+99376v+SW8azWRr5s0YF2jZ8qwt/MzIbF98XEd45QxTvKRjv4xZX/IucU7sk6Fr/+TIXtlR5ESSoKlxq1gQkgflocqQYvrXfG9d2wu1bAswAha3Y1PhnGGE57G2c2NNXL8stZGDGVxVBaI+CwVNIfCxjBKjrjHiPlwOMNRrd/mVgHOUuidmQfmV+WFoVXJ0hWTIqn/t5u3caMV9enKclV1G67O5NkPuooxGbcYVeT6jzb4vntjzQ3DGCEVRPSJflLchzpHjP2HKSxQ2/tYQnqZiuRuUv7G0NtNAjKe05Y9caWIUwPg3P368qD9bcKjc3vgGawhCMPKiGDRWMn1oMMveFHovm2oRgbwQSmGBXkWL/F+xPYdq4T9ZqKWn8GMZQu2KaEsl7FvXrOTdVSr6bpfQ2QOAMTldDd0mCKNZh7T95ABeTW40fcaumPonh2p2a7lrgynW5ONC53L0iJQHv9RiT7hdbUPrHticSev9TxisrJmnZuneGKwBzmcB36cN5RLKoA7HbnWl4VbQ8HE4F6aJ5UptSxtYpSJOdKKZNQp0cHoVJ31ujg120rsrEVwqs1v5uiHEjL+SzQE0T79V8d+7AXpS7P00PN/pDf/V1IQ1a9+7veV1h4va8Ta9O2a497+RSRJK1QrVKugTevJ2iTK7IXOIZOpOZiiafgKngc2EqjnMRBnM24O1p09VIve3tUzfI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199018)(8936002)(5660300002)(41300700001)(36756003)(2906002)(31686004)(4326008)(66476007)(66556008)(66946007)(31696002)(6486002)(83380400001)(316002)(38100700002)(86362001)(110136005)(6506007)(8676002)(26005)(53546011)(2616005)(478600001)(186003)(6666004)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTV0QTZoalJYOFJwOHpaQi9UQVV5TVNtNlowQ0hEcy9hdWdSZU5sZSsrek9O?=
 =?utf-8?B?MHcrdTl6YVhobDhnNWQ0L3RuTEg2TjVxdFJleDROQ1pIOUZMdEtHRFY0WExQ?=
 =?utf-8?B?K3p4aWJpTGJLZ0JobFFJTWZHL0h6MndWd3RUQm5IRnoyQmNQRWFYSDNhTnZG?=
 =?utf-8?B?OEw2aTc2dVQrRjJkTmQrS3VleFd5WCtQamhPTnNDdDNNOEFVYlgxUE9KWmdo?=
 =?utf-8?B?Rm9BQXRMTUM4OFk2VXZIWjVGZzlDNDBVbmFncHNoTjNzWmJlMDkvQlVPaEUr?=
 =?utf-8?B?SElkWXlEcm45MGVEYzhIQVNzMkNvMFFqcHFNWEpLYXBRalc2a0poY3lvb0I2?=
 =?utf-8?B?azRnZWY3bXJlbW9CTEJicDZPa1p4WEhNSjB6enB6cXd0KzJWNStBTDcxZmlM?=
 =?utf-8?B?RThNZHhpdlRVT1RtWUQ4NVkwTHd5My9IYm10cUsyRVVnbXp0aHU3UU0zcEEy?=
 =?utf-8?B?TkVmcmxTSmpuTlBoZnZFd2ZHZmJ4ejdhY2dna1NlbUlmeStERjdHNnA0L3hh?=
 =?utf-8?B?dnhkRFNKMTNyTE9NcHUxa1NWNk1OMHBOMDZCMWhvdllmL29VbUg4b3hBQkR5?=
 =?utf-8?B?WUhnajQvZ3FwRmpFUlRhTVZndzJSb3hwZzlQSmVaR0RSZ1E4K0FWTGxFTkU1?=
 =?utf-8?B?enVXN0VjaWlmbXArREpzMWdSMjBUaE9kOXVZUTd3N3NPbGxDd3lvbmpQT08v?=
 =?utf-8?B?cG9RYnduMkh1MkU4c3NuNUpXVnBQSGtQWGFneDFjenVvbzFzcWhYQmdsMm9J?=
 =?utf-8?B?OEpreVBMYjdPdUgxRklkRS90L255cTA5K1gra0puMTBRd2xYbkpURDJwaWxF?=
 =?utf-8?B?UDIwWUw3Q05COHNGSzlsYVM5NEdCcWxNdHFubFRqTWw0TU1rd1k0bUdoaDlw?=
 =?utf-8?B?VlRXM2JQSnNWWXh1Tkw4eWtERlI1dkgyWUJKeDFQY2M1K0l4UzZibnFwU1Jv?=
 =?utf-8?B?UVZZTmhNUVBhWVVPb2tXR0RDK3B5a28ya1RKUjhSYSsxRDdJMmZyaEwrMjJn?=
 =?utf-8?B?VHhrYjdWZ3BJWmIreHF0ME1GYytPTVNVM1g1QjJEZ004c21DVjcvWitDMGc4?=
 =?utf-8?B?RjBBZlNLVFpTQ3BRU0k1K2ZqblJMbU91dElyM1ROclpEdERLUnd3RXErZTFT?=
 =?utf-8?B?Z2ZKalk0Mm1PbWQrVkFpc1IrWDFDK3IvdUVoazNDUUlBd05Hb3VIQ2p6bFBr?=
 =?utf-8?B?MGI3Y2hhM0krbmdsNmRydHQ3K0NxREt0QmpBZkZiV1Nka2hBRWoyd1dEb3dy?=
 =?utf-8?B?Ri9YUGR3aWtDSWlMZmxBUUNFc1NuN0laZzVlZC9tclJESWZEWjR1UVc0WHJW?=
 =?utf-8?B?cVpiYUdnaTBuRXZSMkljbHl2OW4zZGt2U0Uyd0FBZzY3eHEyZWNUT3o4Y0ow?=
 =?utf-8?B?VG40TThCay9GTTdTd05RK2RuSC8vVTBiQ1FzQk9nVi94TnZMNFpkUHBKSUpo?=
 =?utf-8?B?cnJvbGhjWXhpODQ4dll1TEo4Zzl5dGx0ZXVJOTRmY1BzOTVtalY1Ylk1RVFz?=
 =?utf-8?B?QUtwZzFJQ3lkZXB3UmZ2NzVkRS91czZIc0l1aXp4WXZLVXNrSHhaaFB3ZnlM?=
 =?utf-8?B?bEphbVNocVlkcTRZNlg4eDZZdFVZeVJsbGtBM2lYRVg4THVuQ0hLeXdsQ0My?=
 =?utf-8?B?UUtKcFpqK0F1S0ozQ2pZeTBYelhQUmVoRHRmSExEcDdJOHZqRlQ3T3ZEaGRP?=
 =?utf-8?B?RmJHQmRFZVlLZHQxV2pqU2lhMVBuRkdEUlEvRnA0NXJzeVNwK0Q5UkdIUCt4?=
 =?utf-8?B?T3RMR2xhV2JlQXlhZlRUMU9PN0FHWmtlUTFMMG1waGJMNU1vL2VGVjd2MXp3?=
 =?utf-8?B?czFSVmRmYzNEZllSdGRnNEtyQm5DbWp1Z1d4NFVrWlZmdkdabnVmY2pqbExq?=
 =?utf-8?B?eXNrR1c3Q0hMakFwTUhSa2RrdHhUTFh4ckh5eVhLakhYV0FnNEpNUFNVZUZx?=
 =?utf-8?B?dGdyLzhkcDRacWlKb3JjU2trM2J5bERpdFBxSmp5ejdCMldyWmxmdTJyazFa?=
 =?utf-8?B?ZUhkVFRPT1pNMFBLcVFuTi9uKzZrYUJJWFpOeW9sVHI5TEl0N09RbHZrejkr?=
 =?utf-8?B?MHNiQllkV2FQUHg4a213Nnk4aXczdnVaMTFCREFiWWFpSjFZRVdjSkFJb3Vo?=
 =?utf-8?Q?YpYlt6J+UqG9+q3FDFqzJtFPI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b896d9-52e1-4dbf-84c3-08db1a4b9107
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 11:53:26.4605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uX43FRN/f3xhps+9PG9hidOMGCgMpDmncQKKutNuQDD5XqIFXcFcKWsN7gFYGlvH7xjKRYIoB93edsuMPFoXHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6679
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/2023 4:04 PM, Tasos Sahanidis wrote:
> On 2023-02-28 20:46, Alex Williamson wrote:
>> Can you do the same for the root port to the GPU, ex. use lspci -t to
>> find the parent root port.  Since the device doesn't seem to be
>> achieving D3cold (expected on a desktop system), the other significant
>> change of the identified commit is that the root port will also enter a
>> low power state.  Prior to that commit the device would enter D3hot, but
>> we never touched the root port.  Perhaps confirm the root port now
>> enters D3hot and compare lspci for the root port when using
>> disable_idle_d3 to that found when trying to use the device without
>> disable_idle_d3. Thanks,
>>
>> Alex
>>
> 
> I seem to have trouble understanding the lspci tree.
> 

 Can you please try following way to confirm the path

 ls -l /sys/bus/pci/devices

 It generally displays the full path like

 0000:03:00.0 -> ../../../devices/pci0000:00/0000:00:1c.5/0000:02:00.0/0000:03:00.0

 Also, Can you please print the runtime PM control entry as well

 /sys/bus/pci/devices/<root_port B:D:F>/power/control

 Thanks,
 Abhishek

> The tree is as follows:
> 
> -[0000:00]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
> [...]      |
>            +-01.2-[02-0d]----00.0-[03-0d]--+-01.0-[04-05]----00.0-[05]--+-00.0  Creative Labs EMU10k2/CA0100/CA0102/CA10200 [Sound Blaster Audigy Series]
>            |                               |                            +-00.1  Creative Labs SB Audigy Game Port
>            |                               |                            +-01.0  Brooktree Corporation Bt878 Video Capture
>            |                               |                            \-01.1  Brooktree Corporation Bt878 Audio Capture
>            |                               +-02.0-[06]--+-00.0  Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM]
>            |                               |            \-00.1  Advanced Micro Devices, Inc. [AMD/ATI] Tobago HDMI Audio [Radeon R7 360 / R9 360 OEM]
>            |                               +-03.0-[07-08]----00.0-[08]--+-00.0  Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder
>            |                               |                            \-01.0  Yamaha Corporation YMF-744B [DS-1S Audio Controller]
>            |                               +-05.0-[09]----00.0  Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
>            |                               +-06.0-[0a]--+-00.0  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
>            |                               |            +-00.1  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
>            |                               |            \-00.2  MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller
>            |                               +-08.0-[0b]--+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Reserved SPP
>            |                               |            +-00.1  Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 Host Controller
>            |                               |            \-00.3  Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 Host Controller
>            |                               +-09.0-[0c]----00.0  Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode]
>            |                               \-0a.0-[0d]----00.0  Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode]
> [...]      |
> 
> The parent root port is either 0000:00:01.2 or 0000:00:02.0, correct?
> 00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge
> 02:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse Switch Upstream
> 
> If so, I tested in 5.18, both before and while running the VM, with 6.2
> both with and without disable_idle_d3, and in all cases they stayed at D0.
> 
> Only difference was the card itself would be at D0 instead of D3hot with
> disable_idle_d3. In the working 5.18, without disable_idle_d3, it would
> still enter D3hot.
> 
> ==> 5_18_before_vm <==
> # cat /sys/bus/pci/devices/0000:02:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:01.2/power_state
> D0
> # cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:02.0/power_state
> unknown
> # cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:06:00.0/power_state
> D3hot
> # cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
> active
> 
> ==> 5_18_running_vm <==
> # cat /sys/bus/pci/devices/0000:02:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:01.2/power_state
> D0
> # cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:02.0/power_state
> unknown
> # cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:06:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
> active
> 
> ==> 6_2_before_vm <==
> # cat /sys/bus/pci/devices/0000:02:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:01.2/power_state
> D0
> # cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:02.0/power_state
> unknown
> # cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:06:00.0/power_state
> D3hot
> # cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
> suspended
> 
> ==> 6_2_running_vm <==
> # cat /sys/bus/pci/devices/0000:02:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:01.2/power_state
> D0
> # cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:02.0/power_state
> unknown
> # cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:06:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
> active
> 
> ==> 6_2_before_vm_disable_idle_d3 <==
> # cat /sys/bus/pci/devices/0000:02:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:01.2/power_state
> D0
> # cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:02.0/power_state
> unknown
> # cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:06:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
> active
> 
> ==> 6_2_running_vm_disable_idle_d3 <==
> # cat /sys/bus/pci/devices/0000:02:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:02:00.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:01.2/power_state
> D0
> # cat /sys/bus/pci/devices/0000:00:01.2/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:00:02.0/power_state
> unknown
> # cat /sys/bus/pci/devices/0000:00:02.0/power/runtime_status
> active
> # cat /sys/bus/pci/devices/0000:06:00.0/power_state
> D0
> # cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
> active
> 
> 0000:00:02.0 is Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge
> and can presumably be ignored.
> 
> --
> Tasos

