Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EB47A22F9
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 17:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbjIOPyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 11:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbjIOPyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 11:54:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5327E6D;
        Fri, 15 Sep 2023 08:54:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQKT3tERVEqgp7+jeIk1hij4B8557Mq/lBhgvgZs0OH5+3b510b9Tfkd9vWCBhK/VU/oPl/PABLa1+jyQ2s2DxiJ/Droxo2PloLlcoi6RPZ4AasRaOy5YSK8OyEyQw4Gxtzmn89IdLjU2QXazdVde8ySyNCgfkqmunnISBaB6ZlQWhnt+dkpMMAYPn0edh35uKLFgMH91s9nQ/2PEy6nWoOLJijpu3bynj+yQ93QQOc5rcPiY4SpbmzZUiTsYyAwzvKD37f1wguH9Q0XegTsoc47U3Zl4WJHmmTbgltHzBgPFJuLbDgIK2mPc3SVmaxYROtBKgsjJpRVM4pTzwve7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ukvevd3zLEiGJTBaEs70vFMhmXKMPQWH2QjaYKtH778=;
 b=nhjEsjCPcFp0ncLUEQCAktk9sYOBsizBSrtMhdhqWIWeVEe2uFdNo3UJkcfQfXMrCmngGCaboKYcZBhc0rj9YGSJ0N9ZW5iPHiuaJfnedf6sNY9v6tN4+kqq0p1MVbHlWlqga66BOGHj7Iu49Onyfyi2ZUX1/nd1iS5URN2AfxnYWWhc+u41sDonBnuJ+yEBSW953fVfwOZIWJSQvja9LsX89huI4PYVmTg0lGDrk3GIcrUj7q3vD5RGkIvPn93Fg1ch/ZgJ0JBnSsowKaJDi7b+JiuFZ2mT3M2mG/0GbEuRrNnbbxvZtSI1GSFRnMTSpcWc2FN/ABIanuAynCqP4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ukvevd3zLEiGJTBaEs70vFMhmXKMPQWH2QjaYKtH778=;
 b=aU/RcjsRWuITPCDyeZR0ZYEZuK0tkrL17Q6JAJ0aM1nXAF1C0fbBMOVo5LwH8ZTWWhdT8fBzAq+H4Wsvhe4BB0pGtONE2IsWAWnjrT3T2CsLFTlFeWdeHj3pSFDwEV6+lvHjmek0dClZl5haTLSuNlD/j0Au1CbguEE+FF89shI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH2PR12MB4088.namprd12.prod.outlook.com (2603:10b6:610:a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Fri, 15 Sep
 2023 15:54:04 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::ee63:b5d6:340c:63b2%5]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 15:54:04 +0000
Message-ID: <011ad9da-1df9-3129-1f8d-543e8f598ee5@amd.com>
Date:   Fri, 15 Sep 2023 08:54:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH vfio 3/3] pds/vfio: Fix possible sleep while in atomic
 context
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     jgg@ziepe.ca, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        dan.carpenter@linaro.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shannon.nelson@amd.com
References: <20230914191540.54946-1-brett.creeley@amd.com>
 <20230914191540.54946-4-brett.creeley@amd.com>
 <20230914163837.07607d8a.alex.williamson@redhat.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20230914163837.07607d8a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::10) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH2PR12MB4088:EE_
X-MS-Office365-Filtering-Correlation-Id: 559754b0-2388-44ae-6cf0-08dbb603fc83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: shkNxVcnYTIdtMPKkqIS2w3sWBqlhObAjf0RUvLXUV2TfKVTHI14IEdrgAalK8Ia9R9vuOKz4VTjWtTNZaKaDFp4RUfs5XqmBKTz7GRj387xoQkuzh2t9ZvkIH2qa9rBWIZ7S/WpFoLOIkGaINzMEAwIhVTBGZLxrlW37A87cPIvcRJPM2Om0SvAv6JbTbsZJhvorD3MBCW5lwBt396XZxF30jhCxg98WFKXF/MoE/4c0f2Ec/nKaGifZFEGkMfLZq2GSDxGJ4Oy23a/gQCFe02TGEK4lzl/xbzAzH+QN42vbNn4OJa5Fl4R6Ob3EK8vh80Vkwtpw1EYHblKQ/saVjR6tOQ4wh+H5dKYHmjtss7CdGp23aZVp236YK24VZwP7x+u77q4fz1RVf6eoCbYQYk59i8x9AsUZJOZuXU5onDPYQ4SGoJ1bcrDdPa6JRwc1V+HbSeW8nrTnm8jrV0sAO+z0YqU+g3lC+1IqKRNOSEGp2lhuxwig9XtIDIE38tZt2FOm1eeBFjez3KZjpk00c9xobcoTqAB5CZlmfLKhD/ac1UOw7dOfLKwfV9l2UbtzQnrXPNxe3lhH57u9b9SEPPFgHvgKfH0F3kvpNYpKARjSJE8dA3x9skg3hNGbbwtkablhhmdWeLPp+JXDZ7DmhnZdkStBCjRoLIWB55vOPN5sgkrODu3iGEeKqW5c+KN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(396003)(39860400002)(366004)(186009)(1800799009)(451199024)(26005)(8936002)(8676002)(2616005)(4326008)(83380400001)(2906002)(36756003)(6486002)(6506007)(38100700002)(6666004)(53546011)(31696002)(966005)(5660300002)(31686004)(6512007)(41300700001)(66556008)(66476007)(110136005)(6636002)(66946007)(316002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0dUMlhXK2hiWFZXU00ycDQ1RlpUTU9WcFU5eHJKS0p1ZEJUUUlkdzFMeGxv?=
 =?utf-8?B?Y251SEpiNm44Y3dkN2FFYUtTRDVrNElpaEU5cUE2QzZkc3l4cmpyZnpBZ3Zy?=
 =?utf-8?B?bWV3YXNPaWZ5RjZmTHQ3THpOQ0Vkc3JCeFZEcElKdnplZXN0M2tuTGVjRGVR?=
 =?utf-8?B?d05FU1FRUHdOWER1Q25OWlZuRkRuT0YvT0VLbVYrOXZSTUV4OHY0ak56cUZQ?=
 =?utf-8?B?Y2tUR0I3aWhzR1EyT1pyeTk3UTN5TmgveFF2d3FGRlJ3TEZnZUoxMm5VdTJs?=
 =?utf-8?B?OGVWdEQ2TFFuVUY5eVFyd2M2VC9UcEp2UnMxajNRb2VuUXFNWEt4ZEIzK0Np?=
 =?utf-8?B?WEYvcnhQUVlWd2ErUkFyWDUxbGZ4MTgvWGMySWN4R0IxRHBHR21odmNTNHB2?=
 =?utf-8?B?Q09zL2VRbjVDZE1GaFRlREhvcGFKTTIzUlRBbzkzUGxZZ3BjMFhYU0FjR3dD?=
 =?utf-8?B?ZXVCbUgrWjNRR01jbWxTZm45bnY3V3cxWk9WYVR4RWtvWlY1cVF6cmY5LzRk?=
 =?utf-8?B?MWZFUVlHVC9jQkpkcTN6dDZReGFLSXVLb3ozSnZ6U0N6dDlmTXlvVW1XanFT?=
 =?utf-8?B?UWtFRm9vZlJIMHFtaTFSZFF4amllakgwdzlwQlFpUHJQa3d2ZEk2T0txZ1U2?=
 =?utf-8?B?bEt3SjFsMUpGN1Vabm14Q0VhUWdjYVNsV0d0UE5vSkxQUVJueVFORlNTMVBX?=
 =?utf-8?B?NzgveUNSTlZERGhaa1dhaHhQNG1wYkFQSitaTWFUQ2xGeVlnQURnaGFXRlFX?=
 =?utf-8?B?R2M2LzFvVXZoUHg0ODlLSm50TFBjbFdnUGZySEcxT01EY29QWVQ1L1llaThy?=
 =?utf-8?B?Y3U2RFZRVWl6azdsOElsckQzUkNkYVJhVWFJcllzWURHRmRGTExRK2ZWQXZ0?=
 =?utf-8?B?b21qTzl4L2JpOWU4dzdJNVArK0NGNVg5OFBlb1Nta0xSMG1sUm9XeFY5c2d2?=
 =?utf-8?B?M0pjMEhjSzNReWVJNVU0eVptZG81UHBrQkZSSGNLVXRxajRqSmpRcFRRUVVB?=
 =?utf-8?B?TmZDRm1TVFJrcy9tQUhOVkMzUGtOYXR2cmg2UDV0OVJsT056Y0VMYVpma2FF?=
 =?utf-8?B?R1RldnhMQmRwekdlSmY1c2dNdVk3dmlyTTRMbHNDOUh1RHZaYXFJSVlxS3RT?=
 =?utf-8?B?TlZEUERjSE83a28zcjlHNkZKQWlWTCtCWDE1bmppU2phTVZGa0lucU5RcFFT?=
 =?utf-8?B?bkpacmFMS3pEZTF2dC9RRjhzTmp6a1NyVytvL0s5Wk5UVitwK0tpajUrVGJR?=
 =?utf-8?B?dFlZY21JUFNrNTN1ZklrWi9qSi85MmtrL055VmlMMXVmcHhHbEx6SldIaHJM?=
 =?utf-8?B?dWxOOTI3cnZKOXZpN2xOd2ZxTkQrTzN4ZytINGVWS2Zwek51V2lVK2N4OGN2?=
 =?utf-8?B?UXFicExHckhXSUVYeXprNHhDVjhaL0wwbXF1VG1GbWNxUmNFbE9iQndzZi96?=
 =?utf-8?B?N1htMkhKQ0JtYmZVYlhqLzZpNUQwYW1YSGQ2TGdZbW5iYmFUNVVhaHR0VXVo?=
 =?utf-8?B?SjJubmFkYlhydk05YTUwSEV5cTBIWjlhbnVFLy9CWXZLZDJQaFJrdEsveXJN?=
 =?utf-8?B?SnNXU1h5TjFjVVNYZVBndlRDTzkydzlOSDc0M1ZiU2dZSVRROE5LMjIxMGFI?=
 =?utf-8?B?TEREUFB0VkgxeTZvdlR2OWlQeG1lTlZPVWhjSUdTTFMrMW9PNHNBa3MycFFt?=
 =?utf-8?B?WDVTY2w3VmdCWmFiT2xMeFNSSktMNHlFeWRYdkQxTXEvSHFxU2drQmlRTTY3?=
 =?utf-8?B?NVNQQ3VXcWloVDZBQy9wdHd4V3NtOHhCck9BbmZ6czJiWks3aGcwTG5Wd0VC?=
 =?utf-8?B?YUFlVjB0MkEySzBvOVAxYVpJUm5Wdmg2KzBkanRHc0FxcmlhM0pLb2lVY003?=
 =?utf-8?B?b0k0OVZmQ1BDUUl1NEtUY2g5SnFPWEt6b2hHeU9oenJSOWdrQTUvQUd4dVpS?=
 =?utf-8?B?WUVwak1CdmpqeUROT2p2NVlCclA1UjJsTlVFVGJ6aFN5dWEvaStBT2lZbmlJ?=
 =?utf-8?B?ZHArLzlxck1wL1psNDhiUEZaQnNCTU11THVVL21lb2N1djVsK0w3b3dWd1p0?=
 =?utf-8?B?Y0VjS2tEMmNzangvQ1I2NVE5M0JrWDhkQmtTdDlBalJ4OWNmcUhUVjlhRUFX?=
 =?utf-8?Q?F5zDDDDANrRf97c5TFxIvFuvf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559754b0-2388-44ae-6cf0-08dbb603fc83
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 15:54:04.1929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sB5StMSyOuR9sAXRaKUClsT0Qo5RDCG7HdL5Bly8iYWH4vn++dw6qzZ6Q9fw0v8qzWgQW8jqMCLOxmHIvU/T9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4088
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/2023 3:38 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Thu, 14 Sep 2023 12:15:40 -0700
> Brett Creeley <brett.creeley@amd.com> wrote:
> 
>> The driver could possibly sleep while in atomic context resulting
>> in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
>> set:
>>
>> [  227.229806] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283
>> [  227.229818] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2817, name: bash
>> [  227.229824] preempt_count: 1, expected: 0
>> [  227.229827] RCU nest depth: 0, expected: 0
>> [  227.229832] CPU: 5 PID: 2817 Comm: bash Tainted: G S         OE      6.6.0-rc1-next-20230911 #1
>> [  227.229839] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
>> [  227.229843] Call Trace:
>> [  227.229848]  <TASK>
>> [  227.229853]  dump_stack_lvl+0x36/0x50
>> [  227.229865]  __might_resched+0x123/0x170
>> [  227.229877]  mutex_lock+0x1e/0x50
>> [  227.229891]  pds_vfio_put_lm_file+0x1e/0xa0 [pds_vfio_pci]
>> [  227.229909]  pds_vfio_put_save_file+0x19/0x30 [pds_vfio_pci]
>> [  227.229923]  pds_vfio_state_mutex_unlock+0x2e/0x80 [pds_vfio_pci]
>> [  227.229937]  pci_reset_function+0x4b/0x70
>> [  227.229948]  reset_store+0x5b/0xa0
>> [  227.229959]  kernfs_fop_write_iter+0x137/0x1d0
>> [  227.229972]  vfs_write+0x2de/0x410
>> [  227.229986]  ksys_write+0x5d/0xd0
>> [  227.229996]  do_syscall_64+0x3b/0x90
>> [  227.230004]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>> [  227.230017] RIP: 0033:0x7fb202b1fa28
>> [  227.230023] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
>> [  227.230028] RSP: 002b:00007fff6915fbd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>> [  227.230036] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fb202b1fa28
>> [  227.230040] RDX: 0000000000000002 RSI: 000055f3834d5aa0 RDI: 0000000000000001
>> [  227.230044] RBP: 000055f3834d5aa0 R08: 000000000000000a R09: 00007fb202b7fae0
>> [  227.230047] R10: 000000000000000a R11: 0000000000000246 R12: 00007fb202dc06e0
>> [  227.230050] R13: 0000000000000002 R14: 00007fb202dbb860 R15: 0000000000000002
>> [  227.230056]  </TASK>
>>
>> This can happen if pds_vfio_put_restore_file() and/or
>> pds_vfio_put_save_file() grab the mutex_lock(&lm_file->lock)
>> while the spin_lock(&pds_vfio->reset_lock) is held, which can
>> happen during while calling pds_vfio_state_mutex_unlock().
>>
>> Fix this by releasing the spin_unlock(&pds_vfio->reset_lock) before
>> calling pds_vfio_put_restore_file() and pds_vfio_put_save_file() and
>> re-acquiring spin_lock(&pds_vfio->reset_lock) after the previously
>> mentioned functions are called to protect setting the subsequent
>> state/deferred reset settings.
>>
>> The only possible concerns are other threads that may call
>> pds_vfio_put_restore_file() and/or pds_vfio_put_save_file(). However,
>> those paths are already protected by the state mutex_lock().
> 
> Is there another viable solution to change reset_lock to a mutex?
> 
> I think this is the origin of this algorithm:
> 
> https://lore.kernel.org/all/20211019191025.GA4072278@nvidia.com/
> 
> But it's not clear to me why Jason chose an example with a spinlock and
> if some subtlety here requires it.  Thanks,
> 
> Alex

It would be good to get some feedback from Jason on this before thinking 
about a different solution.

Thanks,

Brett

> 
>> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>> Closes: https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vfio/pci/pds/vfio_dev.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
>> index 9db5f2c8f1ea..6e664cb05dd1 100644
>> --- a/drivers/vfio/pci/pds/vfio_dev.c
>> +++ b/drivers/vfio/pci/pds/vfio_dev.c
>> @@ -33,8 +33,10 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
>>        if (pds_vfio->deferred_reset) {
>>                pds_vfio->deferred_reset = false;
>>                if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
>> +                     spin_unlock(&pds_vfio->reset_lock);
>>                        pds_vfio_put_restore_file(pds_vfio);
>>                        pds_vfio_put_save_file(pds_vfio);
>> +                     spin_lock(&pds_vfio->reset_lock);
>>                        pds_vfio_dirty_disable(pds_vfio, false);
>>                }
>>                pds_vfio->state = pds_vfio->deferred_reset_state;
> 
