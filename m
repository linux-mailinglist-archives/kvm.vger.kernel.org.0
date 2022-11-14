Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F4F628D86
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 00:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbiKNXgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 18:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbiKNXgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 18:36:38 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902AD9FD8;
        Mon, 14 Nov 2022 15:36:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0OiHE2tRbQWhjDzIdU8WUeGe2eQ45H+spO9EOujqYdUhSyujhgPh6niW9AxjQN8kn8HWtbCcIvaOCy5LZiIPzBE5hB6rUSgrowlrRb+w4mL0+OLzzARi0VXADq9uFwf4cJYVA3nSh3W0yQ+lfCDh8VHA2QkIwDhBWcDLjsQPtJjFS665HboEyrb5ZhMwnyegQ8ZPN4DfBSWqc64Q2n9oVzwCGqBi408jq1JMSRkFoQl5c3usOgydMM8DEqgjFsrBDuGlbwHCwXrOPwhRFuh6J7T6MBh74VxtTCTkigO5Veavr2LUbmi9mlFZYB3eZdu+LrWOLcesY3NeV67coyBOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xrAWZSILDlomG/qAa79h/Q0/uaWhu9vzOzoxcvMC7I=;
 b=c+ovHnxXoCYKZRBxKn6cc95bETjP+t9H9j2SyDfHNN7e3DhZjJRXRjm45d8XBlED0cEzgJWpOoQDrmnJKiI/P2JjniIjOuBPYrl9jZp9KBT/bbQ4sJGT1G+mm9qjxY74oTNyOdjvH9+g5TPet1p77GtRCytQddN4w11BvkeV0NKgWagdD68mpW0SpMeS8jWzXKSL31zRwmX2/CsBE8L8h9iHpT5hnRJ8odyFIwbrJzmUeOFLuPJkfcgAv7uE1Mwsl4X6r2MME8slnJ65RXWo3cfVdLPyuhaKkJItwTwX/ddEtaJfdY56fkkYQNUoE9KdvEgM6cAky8mIaqrIDkOtqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xrAWZSILDlomG/qAa79h/Q0/uaWhu9vzOzoxcvMC7I=;
 b=LnTnKtoZFp5UMPTGh4iYzZUiJB8cdENiGxH5BKfRZEObWrfPwNnMnkyICY6qfb8LnKR9Y3VEOC44UCq8gAx2+URHvvbr0Ni4Uq39waTx2P2w6i+FKBTlJGXpERSN4YyTyiRcYTqWV0hKiPQoMsmQchZezVUIFMtV6TP54qzHkYo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BL1PR12MB5707.namprd12.prod.outlook.com (2603:10b6:208:386::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 23:36:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 23:36:34 +0000
Message-ID: <c2ce6317-aa51-2a2b-2d75-ad1fd269f3fa@amd.com>
Date:   Mon, 14 Nov 2022 17:36:29 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     vbabka@suse.cz, x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, michael.roth@amd.com,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        "Kaplan, David" <David.Kaplan@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <Y1e5oC9QyDlKpxZ9@zn.tnic> <6511c122-d5cc-3f8d-9651-7c2cd67dc5af@amd.com>
 <Y2A6/ZwvKhpNBTMP@zn.tnic> <dc89b2f4-1053-91ac-aeac-bb3b25f9ebc7@amd.com>
 <Y2JS7kn8Q9P4rXso@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y2JS7kn8Q9P4rXso@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:610:cc::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BL1PR12MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e36b446-b4a0-4f94-783a-08dac699108e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPEoaheO4KNdF6HboC5+0io3JTVk8Uqaw8M1H52nSO4Im1D5xcgABUq23Ti5haY7+uVM2B67gxhzJcsB9tPDqRnRpS2FLtMUa6I2iWE9ZmIwKwA+LQ92HtzxELczZAI/QtVYCoqH94swqwC0h61KkMI4+/DvPsYdMeH4qBGwj7vMES4e2ewXxVza1Wa4rh3fkLMppcAXcTi0dCSCL95qaLEtaXufTgjntda7O3h0WjtyQh5NyRtAW3lwXnqtzaj5tXmXdJk25TRaT+q8c8KoJuUC8AMnEGa9rf80VGbvxAe6nuKNrXCTxFPf+Qh0zzfgpZmugUfc0lMdrVr15YGY9OCdKkEZ+l5sTFhruR37K3fyibVdXo0aYccspGgI/c14FNX6XcQezOj21YJUMEj/AaCOkEFcSbc63Lr9nmj8C16WwaAmuZhA/UgjYJNZsqny8l9A7HmzC0+OM2uOTzViyUQh8Wv3KtwbpucYC5nQsVhRMskt05Vq6suipYDfUv8fJZuRK120v578AD05k4WlTJZqCw8a3UONUJd00ruNR19LSzDUcIvaU1oE8tYK7juA/dDLimlvyyQXl4TqzjnGMtw0l+r1aDH73/WoSWywM5QntLzsRmB6dUkfCnKQccIx/QiAaiWE2W/c0c/Zuds9oIAerbKmmJdY8yy79McTEwxQDF/fmuL8kL3Fd1UWw2sw1ax1h188ZGL43nejBTL+/YRsHRazZjLbiGxTrK2iGQADQWRlU+HOwo2ujK3T2Y1Cdk//1oPDtodz4eZ5xRPCObU8De16yh8rWftw6RIrWBmCXoPmvYHyMdumXMsR7JaQ1HyeEk0srteGkuJeaXoSHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199015)(66946007)(2906002)(38100700002)(66556008)(66476007)(36756003)(4326008)(8676002)(6916009)(6666004)(186003)(53546011)(316002)(6512007)(26005)(2616005)(83380400001)(31696002)(6506007)(86362001)(478600001)(6486002)(31686004)(8936002)(5660300002)(7416002)(7406005)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3haWDI3MXBRa1REdG9xQml0c08vY2JtWEZIQWNvdWpzUm00cDV1bkpuZXJ2?=
 =?utf-8?B?ZWRsNWdNNHpOZ1hGZklVaVVwU20zYlY0UGowTDdNRlZORGZLVW83NXdHZFZ1?=
 =?utf-8?B?N3YxRnhyQU1BV0l3eEgrS2tTSUNSbHBrRWpMYVdERTJQdnV0eWVPR0tmL1cv?=
 =?utf-8?B?ZFhya2N4MWw5cGxHYkRFY2dPNXZ0bUM1UXJsR1hkTEtON3RHbXUrZ1c0aUw4?=
 =?utf-8?B?Wmk2ckxsdmhOQTFXZ0RobHhRbWUxM1RoaG1UWGxLRVJGUDFEQWxkZXJFQ05X?=
 =?utf-8?B?YTNwVkZTKzd3K1YzNWZBU1huV2t0UGg1WVpZTm5tVDNxekRGOVZ6MzZRRVRL?=
 =?utf-8?B?Q01JRzFaRVFsbW1MaGRSVWlSUnlSaFdQVUNBNXBnN3BDL3kxWWNpNU9iTkVT?=
 =?utf-8?B?aHJzcTY3TkNvYll5dDFnNUZTd2srRUt0aGtOV1EzYkhHaTFLR2RNa0toSzhi?=
 =?utf-8?B?ZlB2cUJQUjYxc1FrMVRlblA0bnNHTVBMY3Z6YTBPYnNQY0RrN2xSWkVUSkZJ?=
 =?utf-8?B?NWRTUG5LYm5XRy85TmJETUxnQlY5YnIxdGtFa0I2M3RkZ1BjRlZCQzJHRVRs?=
 =?utf-8?B?WXNtWG1wbFlIcE9ZMC9RTTNIdXI1RGgzL2U4QmREVFZ6Z0hVc1RDUW14ckw4?=
 =?utf-8?B?Ri9tdEJ0cWw1RXh3K05wVHVjVEp5eFZWM1B5Vk9WRWwyTGd0TGNJenkvZ2hS?=
 =?utf-8?B?cloxMU56c3A0TlBQT0Ztd1p5Q1NEZ2hjTnRpNVNaU1lJaUdXaDgxTXZKQTZ5?=
 =?utf-8?B?QW5MVjhSZ2Q3V3ZTczVDb2NwSTByQVp1TlpScEpIeE5JZzNITy9oemNObGpD?=
 =?utf-8?B?enBFV2xEcm11VUN4clVjck9PSmhYNHd4aUZqWHordVd1V1B0emlpRXhaeU43?=
 =?utf-8?B?T20wcWQ3R3MwZHA5LzlrK1l3VndzMmUyM2pCOXVPdXlldDNocFNieElSSm5l?=
 =?utf-8?B?eDBCM1l5K3p0Ty9mQkdLa0poQ1ZuL3VRYytHU2hRbE1QN0tzblYzWEc1UHNp?=
 =?utf-8?B?UnFHU2JjSG55a3dyUjZRSGRpK0V4R2hTb0NBalN0NVFPUDNaOUtuVlJXQTZn?=
 =?utf-8?B?RmhvL0ptVUFhcUV3aG94cjdQa3ZVMkdxc3ljT2hVSEhIY2xsQzdDR0NBMWEy?=
 =?utf-8?B?dWxPaXI2YzBleW1GclZsSWI2V25pOWExaUg3NjNCMWhNSmROVEVWUktLaXdw?=
 =?utf-8?B?VkZ1QTM2bXcrZUpCMkE5STFIdkV2alZnNEtFcWFCazZ3SlczOHFBZ3JCVjhS?=
 =?utf-8?B?Y0U4V0lVajY3OHNZZzhuM1pSc0hBenB5UXgrRVdYbGIvNXd6UlF1aEkrRmp5?=
 =?utf-8?B?MlZOb2FtaEtNM3ZNMjF5Mks3UFlWZlpDZTE3Y1RpSWhzaWdKUmFIZzdiYlhn?=
 =?utf-8?B?Q3JRZGhkWG9LNHZDNnAyaUlpWGFiZjdVa0cxT2lUMXc3RFpiSnQ5ZnNlWmNT?=
 =?utf-8?B?ZDcrZXlHZFpqd2FVYW1yOWUrbE9jOTl5UFN3SUhISkxnMlBkTjNMV3IzVVRl?=
 =?utf-8?B?OUQ0QkJWNnV1Qy9TakFpczNGNVYwUXJucjcvRDFpQm9majNKL1pBaXNTWFE4?=
 =?utf-8?B?RUsyVG5xUzM1YWdvSXJtN2dJZE9MTUlMUytDbWNjVnh6RjFYeFR1ekNFTzhk?=
 =?utf-8?B?VDU3RUhEYjNUbVpPM0wwTDRFWmpkVHE0QVdJVXJEcHVaanAzN0FjVUpTYlBo?=
 =?utf-8?B?bVp4VDVSczNzZzh4dWFzaEJWZm1rMFdhSXpCd240N2tkWGZ4ZjNuR0dDNTZi?=
 =?utf-8?B?dUdId1VObythQUFhZWQ4SGtGZGordERTYmlrZUtxUnh5bnNnWEVmWk9STEsy?=
 =?utf-8?B?dUpJYkIyb1JSYlc4YXl0eVVabm9naWJ4SEpZZStydTJmMG1ZQlh5YmlpRDk0?=
 =?utf-8?B?RDAwT25vTnhTUnJnM2JGcEJxQVFQMk1UUTE3YkNHRnN4QjhCNW8zUUlVay9x?=
 =?utf-8?B?TWhVY0ZSbmFWNlFtUnllQkdNQWZLakgxbER2MmJTRi9YTjVBY1NOZEwvY1Vw?=
 =?utf-8?B?bGxKYTJzRnp6S1ptbCtGa1R3S2FTUDFBSU1KY1ovWkxldjFBZjhSRFA3c25O?=
 =?utf-8?B?RGI3dUtQOWFYWXhDUWhzTUg3bnJvejV6OFpFRTAyTStMNEpLdFFqOUJaRVhm?=
 =?utf-8?Q?z/rhgy8O+DgFY/17g7GYLBzyr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e36b446-b4a0-4f94-783a-08dac699108e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 23:36:34.0477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 451b0rTMcJT/m2fzjQyApsmH8yGJIMTCnUY3egAdqMCsuug4iMaocfKV3351Zzf1WwQ+in8mG2DclCayLev08w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5707
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 11/2/2022 6:22 AM, Borislav Petkov wrote:
> On Mon, Oct 31, 2022 at 04:58:38PM -0500, Kalra, Ashish wrote:
>>       if (snp_lookup_rmpentry(pfn, &rmp_level)) {
>>              do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
>>              return RMP_PF_RETRY;
> 
> Does this issue some halfway understandable error message why the
> process got killed?
> 
>> Will look at adding our own recovery function for the same, but that will
>> again mark the pages as poisoned, right ?
> 
> Well, not poisoned but PG_offlimits or whatever the mm folks agree upon.
> Semantically, it'll be handled the same way, ofc.

Added a new PG_offlimits flag and a simple corresponding handler for it.

But there is still added complexity of handling hugepages as part of
reclamation failures (both HugeTLB and transparent hugepages) and that
means calling more static functions in mm/memory_failure.c

There is probably a more appropriate handler in mm/memory-failure.c:

soft_offline_page() - this will mark the page as HWPoisoned and also has
handling for hugepages. And we can avoid adding a new page flag too.

soft_offline_page - Soft offline a page.
Soft offline a page, by migration or invalidation, without killing anything.

So, this looks like a good option to call
soft_offline_page() instead of memory_failure() in case of
failure to transition the page back to HV/shared state via 
SNP_RECLAIM_CMD and/or RMPUPDATE instruction.

Thanks,
Ashish

> 
>> Still waiting for some/more feedback from mm folks on the same.
> 
> Just send the patch and they'll give it.
> 
> Thx.
> 
