Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DC5633BB5
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 12:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbiKVLqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 06:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiKVLp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 06:45:28 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02701A18E;
        Tue, 22 Nov 2022 03:44:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjicyD66hv2PArgQOpi5hZnkRR6qpyDUhlLwv5EZwrLE0POZGTZK+lM+vxsp3FV1oqFA9CPn3O5/hpx6JYTeF08rn3XsdHgFenkg/wJ3HYkMkuB9MbeGIAG0k/ANfR79dmXA+wZ9szFIn9HhSM24Ra2gelTpia+O8toiLq335QO3ks/1YPL5XGlAiKLnB+iOYFzezzPEU016djyETYIYlwkn4xYCFDstev6hsSNIGxFqM9Kzp1KPygSUL4887+gX/YpV5hnlC7acLIIrdba3Wdmhr9efHMIBU471slLfy8OwQ9MHDeRW8Y4OQTCIlnFOdcrIknEUOZ4FfTlKKEDMKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rG+O8qA/JznHKTL5SGNnu1EcRxWH3x1nsy2WGSwLrEE=;
 b=XsbR3ksUZfKOmVefg6quEt7VAL71RxgBh46IB4nytDWk6rjk9B4437wW2Eym/xA2q6kkDtRshLjtCtMwLS+N0GTVxhr1SIqRRAAKaQXqQAUm+4Xxge2WCnKM1zwKiYq0fy92jfP6J0SVbIPXwhaPgttkJ6YUSz39VOIpKMW+XkzyvGlviSLiRQtvMZDYw5/12F7lDXSW0IjpOPPasSAXCq3kNg4+OngmkvxM/M1xlc1kbqu2qpiQ/x8qZk9Yygouy6LWbHlhqVM9c2DeJt/DHZz4sgQPp2SMceejNhXWiQuhXu1P4/8IuVOH01NMhtaceBPF7grQbDEKy+jbRRhZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rG+O8qA/JznHKTL5SGNnu1EcRxWH3x1nsy2WGSwLrEE=;
 b=uHrRsq5ZoLL293LGBOVfVSHFKLT6M9LVqpsTO0Bca115UGxpcodGdbsRetHR6dp1YKqZyGuCPaP/e51fm/BB9OPYyBO/4p9vancAu2BzW0pWDo5IGssC5hEr1/sg0BKypRdVRKlb31rX5s0UKZXpE6BLRMmKMVP9O9N+Um+qGFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA1PR12MB7342.namprd12.prod.outlook.com (2603:10b6:806:2b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 11:44:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:44:53 +0000
Message-ID: <13bd73b6-592c-66c4-cd42-0913380da745@amd.com>
Date:   Tue, 22 Nov 2022 05:44:47 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <b712bc81-4446-9be4-fd59-d08981d13475@amd.com> <Y3qdTuZQoDZxUgbw@zn.tnic>
 <cffed3c2-55a9-bdd3-3b8a-82b2050a64af@amd.com> <Y3yhthJTIWqjjAPK@zn.tnic>
 <d85bf488-9050-13d6-a23b-1440a4df4c81@amd.com> <Y3yoB015qCpbnUzl@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y3yoB015qCpbnUzl@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::9) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SA1PR12MB7342:EE_
X-MS-Office365-Filtering-Correlation-Id: 16151a4c-db62-411b-3389-08dacc7ef82b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jb4LkdwiZOYPkoFdboI5cKlRXy5j0dKozDs+eVVS0+Eu0nTj56PI9qQI+34vov6arZHF3Re6Q/u8eIE0so8cwwlODUyQUH4effKQMCLeE3fqm86AUU4vWp+O0wYHpqGAZP9I4cjVdbjBsEIeGLxe77WB9Mj066OXS1nxQvBJKQ8FgpCoPBz7rJecoxFawcj/j7qSXzG+HP4dY7PcSeboSvb9R3QjaQTdAIJ8b+H0sm1Zw7nhlRGw1pAtLweJvtOkS9QOjT09SourjiaERmJ/LZ9cvNDzcGK7sj4SjDkfxcOFJJZjn3cYBglmJ+YbHtcddeBTi9b0w31QjSPzDpNlD5Otk2mUVsdqufmnLcFEcQqvkqUAmTsP3vsU7ZYdkzfs2X1C+jhmbTF2ZhzB2XOVNV9uLJP3XVdmOEhmZlA3QVeEHRfpho4dWJof5c3wRt4lj1rb3k8F9ZdcXhpID8uJRPYWLAGbp7uUGsi4FSX9b1EPwlmHa54eNf6U39cyTBwFwDpF1QaP/Ih4W1E8b2JlM1ljly6IqMZY0YSPuYm5dunIswI8v1fIyCoQBQIUhkiwyxTTfu4yOk8Vw5loOwn5lBA9+2e51yF/ifgL/8QG0aM+yNbpjcWibGHmGDF8iIQYxXMw3WbhIuvbb7uyIDToZmu8qN0dx7FMHbhX6IiPjNLH4SQQoCD2WzHTVmSa6RGc0YzMaXhXpxiyRG0SgsLx6fw/Olf2c0nbxO5Kf/mr2co=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199015)(38100700002)(5660300002)(86362001)(7406005)(31696002)(31686004)(7416002)(8936002)(41300700001)(66946007)(8676002)(66556008)(4326008)(2906002)(66476007)(316002)(6916009)(36756003)(6666004)(478600001)(6512007)(6506007)(6486002)(26005)(53546011)(186003)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFp6bWtXb2kxZjFmTlJPYWhzVmFMVmFmb290cW5OTno0eXVrUjZaOWdIV1dz?=
 =?utf-8?B?dmx1Vkx6TjA5SUxzVnFtcE9iN3A4R0YrdGJoU2F3SkkzRVpxajZ5V2FoWGx0?=
 =?utf-8?B?SEprWjNrbWhid2g1bXA1ejJLampxRXd2cHhvUnNoU0tMWC9Xemt2VXZuRjhw?=
 =?utf-8?B?anVmdXJMYlBTcVhrNTNwT21RVXBoRFpXNzFjNjdBWUJIY1BlNnl1VXVpZXVG?=
 =?utf-8?B?aExCcng4RmxUTVpuaVV0NVZIbm8vTXg3VzZLYWMzWXViTHRETmRLUkxib0tX?=
 =?utf-8?B?aFBFM0NtaWNOMUFsbFJhdmZEdFpKVS9JUjZPeDZnaHVGNGVKU0VTTzAzYm9D?=
 =?utf-8?B?ZU5NM3ZCRXFkaG1IOTIweHV6STQxTzlRdHNNNm9hZmRTb3RoR1NodWpQaXll?=
 =?utf-8?B?QzhWaitscUkwdGVTK2QwT2o2YW1yNzFXaGhTQk9BdS9Nc0w3L0NCRWJlYzE0?=
 =?utf-8?B?R3NwdUQxUWtHZ1hWVXNMUlV6a01LbC9WRElBMVVvMDlxa2c2a29ydHVwakZq?=
 =?utf-8?B?OGpIcVROMis0bC9Ga3BjUldOcERFaVAvM3pTeFVDS3dFd21SZmVIenJTL0s5?=
 =?utf-8?B?RUdoZWJZSU5ZRmMvNDRmYmNNUFF1WFBmSlEwSVVlbVRsTmpYTW5GNFFST29o?=
 =?utf-8?B?ekZvaXpQUTRhTHFNdnhFVTVtQWg5dTRIakJGMHZBa1h4Q0hPNElUb1h2WHB6?=
 =?utf-8?B?WTk4REhJcWM5dWdRMEdsT0FJMWZYMkZIaS9qVWdZcnhScmNmQUdxV3cwWTMv?=
 =?utf-8?B?QzY4MHV6UjRRZ2NnZUUvY0xpbGxCd0RUdkpVSWVleXNSSmQ4dmJCRmZUSEMz?=
 =?utf-8?B?dVVXVnV3dmFQNFJVbGttY0t1SUNIRk5BUkpKL3RubDdVcmdFbnZPS1BGSUI1?=
 =?utf-8?B?bTVCcGJGaS9EQTR3WjlTZlNoZVY4S3RzY2FvaVUwSUVLRVMzQkw2TE81a05n?=
 =?utf-8?B?ODdMOEJVVFU2ZTJwdGttdkY1K0RXdXVDVzR3SGxoM01OMVhDU2g2dGsyeVdF?=
 =?utf-8?B?ZmlJRWNUeDlLbGlLYitjaDhUZ01lQnp1dDl3QVh2ZTZ5aXF3TE0zeDRyWUlX?=
 =?utf-8?B?TUVYNnpjakpON2ZyNEhRb2JLZlhMNlNNc1VRcU96cU1oMU80RkNXTlpsUDJv?=
 =?utf-8?B?eUpTaDA4KzVMQXVxcUtwcEJ0Ti81LzJFdFBCbjZPaStBL3NXMnZZa0FuT1Fr?=
 =?utf-8?B?TEJaYVFvck5BR29YRDBsNjlndTM3SllVK0VHeUhTMEt6NVhTSFo2WnlNWUhn?=
 =?utf-8?B?dVhTbmVWM24yTENQeVpPVExHOEZ4OElQTXRCbGNueWRIKzV2VThhRmxUb0pT?=
 =?utf-8?B?Y2VLZXVZTVFVUkFtcEp3UkM0YWdSYnFTN3VGTGFJd2hubXdDYlowTzQ0R1JF?=
 =?utf-8?B?bFR2bHRhSm5TcUtCN0FSV2paZm8rbDFRRlhBRi90L1A1TXBIcHFza2Z4Rjhj?=
 =?utf-8?B?YS9weTAyWGthTkVxdkg5UFRGaldPRTEwM25JYmJWZy8zck9vNWMzV0NuTFYw?=
 =?utf-8?B?QW5FZldRNXdmSUduZEpVamlrSnh5VWxhYUYxOWU5NzdBdWlOQXZFSmcwbnJr?=
 =?utf-8?B?eFdKY0NtMVpEaU84MWlJN3l1MzVmdFJLeHFKcndleWZoclhUNG95dEg3dWtP?=
 =?utf-8?B?RzRzd3JlVnlIa0MwYkttajd3eXpPQU1UeDJCeUsyVzM5OTZJbjh4UjZZd08z?=
 =?utf-8?B?STIrWk50VHJabXBTbEdEYWJWWS9aWW96T2crRDBQNTl3cWtETzUwa1hGQUVP?=
 =?utf-8?B?RXhWdllQdXNMM0dYckh3eGZqaWhFTFlick5McmV6ekxvUlRFZjF3YlY1L2Fj?=
 =?utf-8?B?THFOL2Vsc1VRUHEwUDI1YlNYRlNkTTdwNmdvR3FVajliMTAzQ05vZ0M3SFdW?=
 =?utf-8?B?Mjg2MVAvSXFVMk1kWm8vQi9NdG5ZalVkUEdNMTNOaWhwYzZTdkM2RFBKamlR?=
 =?utf-8?B?NTh0Q2ZXNldVM3Rqc0xLaThudFdNYUFuN3orUTZDNjJJQzgwa0JQZ1BmWVlN?=
 =?utf-8?B?bmxtSmhXUDNTdWhyeXkwZnJXbzk0cjI3cGFNSWFZUHF1TS9WSHNWeUdSYmRX?=
 =?utf-8?B?dGlnd2thTlZtYzJHbUszdUVDNkFlSVZJWGUrb1Yxb1pnWE9tWG93RDFCbVVx?=
 =?utf-8?Q?/RLfPj5BUlcXtA2qBiEXgsIQz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16151a4c-db62-411b-3389-08dacc7ef82b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 11:44:53.0060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0zjVbYzUy9TDmVng4gUOTT/wjD9eoVEA98FDx5qQylxGkDSnHX0NOMV4r6q1f4rRwO9XEoXabJuJ7Wb8S86bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/2022 4:44 AM, Borislav Petkov wrote:
> On Tue, Nov 22, 2022 at 04:32:18AM -0600, Kalra, Ashish wrote:
>> Please note that in both cases, these non-reclaimed pages cannot be
>> freed/returned back to the page allocator.
> 
> You keep repeating "these pages". Which pages?

The pages which have been allocated for firmware use (such as for 
SNP_INIT command, TMR memory for SEV-ES usage, etc), command buffers 
used for SEV legacy commands when SNP is enabled.

Here is a detailed description of the SEV legacy command handling when 
SNP is enabled:
The behavior of the SEV-legacy commands is altered when the SNP firmware
is in the INIT state. When SNP is in INIT state, all the SEV-legacy
commands that cause the firmware to write to memory must be in the
firmware state before issuing the command. A command buffer may contain 
a system physical address that the firmware may write to. In case the 
command buffer contains a system physical address points to a guest 
memory, we need to change the page state to the firmware in the RMP
table before issuing the command and restore the state to shared after 
the command completes.

Then there are host buffers allocated for SNP platform status command, 
SNP launch update and SNP launch update vmsa command.

The other pages which can be user or guest provided are SNP guest 
requests and SNP guest debug helpers.

It is important to note that if invalid address/len are supplied, the 
failure will happen at the initial stage itself of transitioning these 
pages to firmware state.

But if the above pages have been successfully transitioned to firmware 
state and passed on to the SNP firmware, then after return, they need to 
be restored to shared state. If this restoration/reclamation fails, then 
accessing these pages will cause the kernel to panic.

> 
> What if you specify the wrong, innocent pages because the kernel is
> wrong?
> 

In such a case the kernel panic is justifiable, but again if incorrect 
addresses are supplied, the failure will happen at the initial stage of 
transitioning these pages to firmware state and there is no need to 
reclaim.

Or, otherwise dump a warning and let the pages not be freed/returned 
back to the page allocator.

It is either innocent pages or kernel panic or an innocent host process 
crash (these are the choices to make).

Thanks,
Ashish
