Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30A9763847
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 16:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbjGZODb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 10:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbjGZOD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 10:03:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B3F2698;
        Wed, 26 Jul 2023 07:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kigfaMPBFXE0/eiU7r2X/cevIYC/tqaH6mQ92FI89EJbXgMW1Y97ilTwKhqBq7u+aeea0q3WaR2DKbX65zk5VpwRGSxU03mG4CZAvO3HcXAiLFKN9V4G1GTWlCPGenzBKC08EGF57Xrt3q0vLcIbOTRmKoHvZA0GXSTIWwnvTzbCWTBrU9KCF6PXrbss4pr/TNR0xXeG0DL5OIiO5mP8TfG3YajQZukvJozvEe5lXLWSgfAM2ydxOYCQcqJJqGa3qtUk8Z9lpZSNTScrCImFHaCikJ57sibULii7X9ZTTVDEGi8Ctxg93SLOqFQk8hARBklVVB4SC3OIAssL8zK3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O16s9mDwXGZepBQKwjqTObxi8BGw6PO073MuYmCbEtE=;
 b=oVr5HtmBxXQD2YkHEX0tzmMvI2OKRhaT4YOGkLSDkVnCDc9PQm67XR6VmmlrKOqL7xEhm7PbJ41qtOq0h5sPum8ycg26JWlYIhrtnNEzXRf5rwnWbUkah8LO9yZw1Y/Ju0IqbJeKyO9+DHPxiuqFK4JdrG3EXhn6d+s4ojR+GVsq/JpK11veiYXPfArNgCx6cOi99zpeHbm9fMb43FMZ3RD0Xxh9tqiwdP3PhnMmcrYMQeEDrOZb6Uiu6uJy14vv82tUBTYminKTxC/7hNKAJpjC62q3GzpHuOFLSNjxNZPRL/Ws8rFbviOygUXxfd6eosFKDZ9s33sHT1Pb9aImSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O16s9mDwXGZepBQKwjqTObxi8BGw6PO073MuYmCbEtE=;
 b=RF7TaSwnx6cqiPbLzsG4dYL3/M7fsOMs6SCYTokCMbKognKeAOBXBoPnG80WzHhyOOJHtK8Drp0mctUTlNxH34t1eiaR/sjt+jvOHGdxTQSfnMA9dSH2F4xEXr/4daZxiiM4rmG0GFT06y31xO6PA8C/n1awohC4rf8CRYD8Ehc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH3PR12MB9217.namprd12.prod.outlook.com (2603:10b6:610:195::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.30; Wed, 26 Jul
 2023 14:03:26 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 14:03:26 +0000
Message-ID: <a9b7df8f-77db-d8dc-efab-9ae7e9ef6922@amd.com>
Date:   Wed, 26 Jul 2023 09:03:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [Question] int3_selftest() generates a #UD instead of a #BP when
 create a SEV VM
Content-Language: en-US
To:     Wu Zongyong <wuzongyong@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     linux-coco@lists.linux.dev
References: <20230726024133.GA434307@L-PF27918B-1352.>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230726024133.GA434307@L-PF27918B-1352.>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0117.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::23) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH3PR12MB9217:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cc4c194-8ae5-4ac4-bba5-08db8de114d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RS7VWxRhHYms9FEfYVIIVr52RIs+aILZ/UocFlnUa0QU1x201+ULJXkg4cFIl1SXp21okAXjnOfYiXcNf8KghvfZfG3Ge2D48+aawJZJLi9ev9qLPGJpLVtfgEkoB/fcs3Q/nBxiXSUsoyv3X9cDL0WFE+lV6qasDYOvN8Y950VVo3Z09SZIiSuquhfdGVHS8ESyvh5//Nk1oDIZnXaN6Fw9xqmDnbqKrk8h7QsmgJQDpba3ZMJz4s+WkzeUynbxYGoPv2okg9F2zcCJD6o17IHwuVqJhpo3SjAa4yUGTiKoteWJv7X6ohCGmSRVB/l9/jfZO2C9vUTh9hQT8Fw0jSjGjCtn/yAxycJg/crvzgC/GO0MVVLuV74ACBKBN7foBg2lziUtOC7IBdxV9pr1etYe9NZGRC8z6mIBOKsAnCeUJpjQSeNhjOykdqzWVUrfOWKSLtmXK62dKSDI7XN6g7SPkD1zBoFg3n5FAM+/uRyiAz0Zc9Z9C0w+sK31GhvyNd9YAGJWOMczNYl43g7nMDyKI+TEw7w5mthyn3XeJJpaUFl3Nmkl+GlTXxnqMFmIDEbFH2okCrvxdMKX6n7iHr5Br2M/W+piygUyRP/xmnagIpce1g+rXNXFXYGQxR5Rd2IvHIVBgmWx1QxXX1VbPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199021)(41300700001)(53546011)(186003)(83380400001)(6506007)(26005)(478600001)(6512007)(2906002)(36756003)(6486002)(45080400002)(31696002)(86362001)(5660300002)(66476007)(4326008)(66946007)(66556008)(8676002)(2616005)(8936002)(316002)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHZET0NmZXQ5dUZCZnRLcVg5NC9lMTBvT3pYU2ZTcWQrc0JPRThyQkRaaDJW?=
 =?utf-8?B?M1d3UUZDNHlBOHJOZEIvL01vOG1kWUlQVERpZTk5U29MS3VSL0Z1YzJmbmo0?=
 =?utf-8?B?OGZwSnhJWnl1dTJnOWE0V25wckl1ZUZsZVJMNllRZUZ2S2t4bERkbkZvWWd0?=
 =?utf-8?B?S2lkSjk1QWV1b0tsQXJ6RVlrTWlVN2x4UWZrZWgvYllCc0xJM3J6NStGaHhn?=
 =?utf-8?B?ZWVqWStjK2M4U25lcmRkNXJHSmZLMGNGd2RUWTJDemN0RW8xVUNMRERoeTZu?=
 =?utf-8?B?bmZUK0xYRjd1ZnBONGxaNHBseGloNXBncFRlVzllN0ZnYVozNjg0NE1VUE5a?=
 =?utf-8?B?OE9kWHExK1VKdGVmV2RJSENOaTI0MXhiWFlWK0lVSnFOZ1VqQVdyVkdHU0NE?=
 =?utf-8?B?cytRdzJoYmY1V0xpckpKdFlKNVlQeUtVOFJqRmZkQWdqZFJlS0lseDF1ZnN3?=
 =?utf-8?B?UnNJenRCN010emxhRkpJVE1DVUpFZ0RzOG5uaE9nWHRKd3FpcGxYNFEzSkMw?=
 =?utf-8?B?K1VkNEdNRGZzdW5ybWdxbHBkTWk5b05uUWNZRGdQWGRUZ0t4YVN4VnM1eUda?=
 =?utf-8?B?c2w3Q1ArcUVQQVAyM1RNYW9QV1pic2VKN0xrQUFBTUNSMm5MYTRDV1daeU50?=
 =?utf-8?B?aWxWRTVJVnJ1S21CNVp4QzJFTnhnS2twa21TLy9vVFJndDdHQWovNVNTNlRZ?=
 =?utf-8?B?M0hscGNsdFVmdzIyWElrY2d5YUs5cytvVjFZdDdSN252emxkaVByYlc3MmxV?=
 =?utf-8?B?RnNjMm56OTdFL3R4VThrajdWeWhuTE54NHB5UHJCRGhmRW5pOEl4TkRBekUx?=
 =?utf-8?B?dkxUMUd1ci9MbkFlM1M4WndoU0pBakp0N1l1VTZrWnBWQmU4N1JETktibGtR?=
 =?utf-8?B?dlhHZE9Jdld0d29ocEtsUlI5OUl3L1dVZWZKdFlucExVZEtjLytQNW1qRzE5?=
 =?utf-8?B?Rkpqc09semJnUUFpT3ptQWVmQ0QzM2NWZlJPak5RTStzeDRmTlRLb2M1L29Q?=
 =?utf-8?B?aFJhQ2Voc2VFT3VJTXMzUHZEbk9TUE5ia2oxY1pkNFRIN1hjM1JJdlZrSGY4?=
 =?utf-8?B?RVNuQXJhM0JOYndkb2FvVjlrcGF2d3QyNzdkUzVzYVV4NzBZaUpObkVZMHZD?=
 =?utf-8?B?Z0pVRXVLSi9JV0s0Rm1YM3NzRTFIeUY2SWRqNy9kTEhUU002SDlHSU03T0U0?=
 =?utf-8?B?MFlFeFV0VTJRSTdYaFY0ajcxUjM3MlhRbkR4TTZUaGxFTERBOXlZUFFXaXZU?=
 =?utf-8?B?SmxTckNPdXBDNW1YNFQ5ZTBYWEZobWhnUEkrREN3cXhhRE9qb0s1MFk5MDJJ?=
 =?utf-8?B?Y3phZ0hWQXlnVEpaQm80S2pOYkRvSGRhdkV3NFFlOHluMzBaMVJUM3p6L1pz?=
 =?utf-8?B?Vk5TTkQ1YmZkbUxuMldjRzRpaG5yRUV1T3p3VWMrNGRTU1UvSk9yd0VZS1kr?=
 =?utf-8?B?aEFCUTJqSlhPVmU0cmgrM3dSb0tacndLaE1ac3pvbklmOFVIUXJCeEhPcjM3?=
 =?utf-8?B?UERZZVdDcVZJVFNPZGtzUkhlTDV5TnFoQzFiWC9iYndNZXlncnpITld2ZlBU?=
 =?utf-8?B?elhxaGIrdkIyRHdNdGtSYWcvRUJsdm5tSzlEMlpIVG1KRHFwSE1zWGpZcWNO?=
 =?utf-8?B?WDcrTmhOdngzK3ZjOGFsblZnZVVmbkdTRDNkOFJWc2txclZzS3k3UVlkZTd1?=
 =?utf-8?B?K2t5Q3Q4U0xINXpscUVzbTRnVFoyRER5TUhsRmo5R0ZjT2hpNTNxektQdUkr?=
 =?utf-8?B?b29rT0NRb01OanZra0dMQUNqeldjNlZzMlNyeURKTDZOVGpSa2I1aDYva09Z?=
 =?utf-8?B?RjU0SERSMlBMd2JIQlNyblROT0JFZHJjY24wK2srekltQVd1R0pKVVVpdnNV?=
 =?utf-8?B?bEw4NC9pWE1xSmpIR1lSUTRlbFBCNmNGNENicVVFK2hUdGdQY0pkdlRpcGNp?=
 =?utf-8?B?V1QwV0ZFQzJnV1dtNVo0N0EvaTJPdzFOWFNTVFJOT0ZabVhmcHluVzdNd3dE?=
 =?utf-8?B?Y0FqMW8zYitPNU01WmtsL3Q3WVRQL1RXY2EzaWN2eUc5R3UySGhxWGtwYWwr?=
 =?utf-8?B?ZzhSbm9WYW9LTmRJeDdwZ25GOHpDcU1vZ3BQT1kwY3ByeEw0QytPRnZ0N2ZN?=
 =?utf-8?Q?oep8Wg6Oe8PvFu0tGMQYyUg9i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc4c194-8ae5-4ac4-bba5-08db8de114d3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 14:03:26.1257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynHqz01pKzZ51Cw1RThyDCBUBf2QkuwUquNZgSSkR9abeIP1Amdsd3ogveVv8SWdVk/rfiStIoh7lu2T8QX9eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9217
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/25/23 21:41, Wu Zongyong wrote:
> Hi,
> 
> I try to boot a SEV VM (just SEV, no SEV-ES and no SEV-SNP) with a
> firmware written by myself.
> 
> But when the linux kernel executed the int3_selftest(), a #UD generated
> instead of a #BP.
> 
> The stack is as follows.
> 
>      [    0.141804] invalid opcode: 0000 [#1] PREEMPT SMP^M
>      [    0.141804] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.3.0+ #37^M
>      [    0.141804] RIP: 0010:int3_selftest_ip+0x0/0x2a^M
>      [    0.141804] Code: eb bc 66 90 0f 1f 44 00 00 48 83 ec 08 48 c7 c7 90 0d 78 83 c7 44 24 04 00 00 00 00 e8 23 fe ac fd 85 c0 75 22 48 8d 7c 24 04 <cc> 90 90 90 90 83 7c 24 04 01 75 13 48 c7 c7 90 0d 78 83 e8 42 fc^M
>      [    0.141804] RSP: 0000:ffffffff82803f18 EFLAGS: 00010246^M
>      [    0.141804] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000007ffffffe^M
>      [    0.141804] RDX: ffffffff82fd4938 RSI: 0000000000000296 RDI: ffffffff82803f1c^M
>      [    0.141804] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000fffeffff^M
>      [    0.141804] R10: ffffffff82803e08 R11: ffffffff82f615a8 R12: 00000000ff062350^M
>      [    0.141804] R13: 000000001fddc20a R14: 000000000090122c R15: 0000000002000000^M
>      [    0.141804] FS:  0000000000000000(0000) GS:ffff88801f200000(0000) knlGS:0000000000000000^M
>      [    0.141804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
>      [    0.141804] CR2: ffff888004c00000 CR3: 000800000281f000 CR4: 00000000003506f0^M
>      [    0.141804] Call Trace:^M
>      [    0.141804]  <TASK>^M
>      [    0.141804]  alternative_instructions+0xe/0x100^M
>      [    0.141804]  check_bugs+0xa7/0x110^M
>      [    0.141804]  start_kernel+0x320/0x430^M
>      [    0.141804]  secondary_startup_64_no_verify+0xd3/0xdb^M
>      [    0.141804]  </TASK>^M
>      [    0.141804] Modules linked in:^M
>      [    0.141804] ---[ end trace 0000000000000000 ]--
> 
> I'm curious how this happend. I cannot find any condition that would
> cause the int3 instruction generate a #UD according to the AMD's spec.
> 
> BTW, it worked nomarlly with qemu and ovmf.

Does this happen every time you boot the guest with your firmware? What 
processor are you running on?

Thanks,
Tom

> 
> Any suggestion would be appreciated!
> 
> Thanks,
> Wu Zongyong
