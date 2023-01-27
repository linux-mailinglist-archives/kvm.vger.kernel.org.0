Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D22267E495
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjA0MFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjA0MEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:04:33 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6553C88CCB;
        Fri, 27 Jan 2023 03:59:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2dVr+h6G2+S91yD8ZYyRVRvHMJVCyXHH1OhFylrMAQHAMT0BLszDKTEiy5AhrGmnr+1AzJYBTEm9qQxP/oQps4h3kS6FPFE9dToXfNXsu4iy7wFcpQzyiSWxGgAdHdQU2yGOJIYhHsgdNAmRh6S9G5RMVe+AH4s4JKglzj/PsAiHcYe81dwX385lDmG73goEnrMtrnUKV1OtvkAbngELrJoxKrL7WMI071k8bnm/PY5vZxCSCmYbRjW46gamUpVG3RvOzyofWLDhJt5AWS25IZYdeOQkk4j3LcJIXR56zH0ZcnDBFkf7z4UBK+tIbJwNshJCocFk/XBH5haF1uXEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsjFwKsi+besC1uVje2V767qCwFiZEaZ/C/JA63wEvE=;
 b=DXncIUHjRVrr4ccPZy2IWND8KE/La3bHKSqqbSnRP4HSApeN98zXCSuPMGylvMe9vlmwFDV8Ymf8uCkNAdjCcmnQ2maBBSfxXBUCVt+AVhCE5W5dnuTvtYdWAIEDcco3tS1J7rnJ8izkfSuAe5Mr0SS9NcAL/Gi1XTFDs9EQAZye1iuHxTZlO/3pOYul0qelX+WiGXSBpfXWKiVSvY8pClUWNlp/BP5RStDc9cAWZvP2dwNlBTORlOO3ldXvA5+33tBhMyODELfsvp0ZChOmeF7O15OgT2Bx+DDujFCPcEg52upIH8X86lgr8mJiQP+RJzVdTuCnF88AmUmoGEVE7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsjFwKsi+besC1uVje2V767qCwFiZEaZ/C/JA63wEvE=;
 b=TLTqx8AmOizRxjtc1ohDYzxZIR7Z1zbbrbthFbqF4Ax/nhSk2WL1WtprnECWxpkq2hSmWlpuA29fkzO8SNjHXNKaaAnFa+h3IUbcByjtNei2RkQ7saBDdwDOqVIesTYcobH+fcv7yAGPEldRNLvHyu/EhdbB+e7vKidlj0TaQB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SJ0PR12MB6712.namprd12.prod.outlook.com (2603:10b6:a03:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:56:45 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%7]) with mapi id 15.20.6043.023; Fri, 27 Jan 2023
 11:56:45 +0000
Message-ID: <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
Date:   Fri, 27 Jan 2023 22:56:26 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Content-Language: en-US
To:     Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y9OpcoSacyOkPkvl@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0013.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::18) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SJ0PR12MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: 760afbeb-84c4-4efa-e672-08db005d9011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCm7oVFTQ1BiKs8qSLfrmzdQP0raORZXlxYhVsKPdG1cN7WFIYC2PiIEovWT1nm1nEp6uaNGhQ7CUA0dYs1gEq3ps6btrksP+9LROyDGn6epON4OY662/YxtisnguylCx7y+nPgBillm/2ekY8WDdFCbWtJV0GwQycKY9ZyBENdZ+d7cRq5VTPVcXgrnX/fZK0LjMxDdfKFBSjBPueRXvgjScfO1I09INMaCFvdkxlqoUMNz2Vfsf/HEkvpRfGtV+LBushwW3bT0pnyLfc4xTpzvWUSLug76eU7MEhAlPK1rm57Y3KeItHBAHLvzOs40bvf9ZMF6ml/3KH1wIZXlFyeO8sVLDG0WNoQ7QgUIRT1RfaKpn5Y1E7SBgLfi30IrCQ4YvZQmUPhvRxBHSkw5/CbwQ+qonyV4x7L9qImEVSbumN0oabVRP+qSjZW8qiCyfFl4yxxJZrZy2geBWtzFmLXmdmWPhHFcKQqBE9PP6af/iwj4HxoBQxSSiKIJT93KHDX/YEuI1aOsJGHHK5vFEMXkLEYxCHlCcCBwLh6giy3lmeqGbD9GQKioSr57caIMGscdelO2Fgv7N5PgACYErDLwhmxrlJjL1735x9QCWS0ICKTs2HcThLPs72Oo7M61CROMHL7YfUsR2nl5TlNAZduhYSAyFNIg5TgOgkv/Ot0Ki7EMlEo+SDPxi8wllQk/oAoYzxUekazWPteiDa9+U1fhuK59P0x9oTsUP/SweFhBj/Bp0CWOkgjo9GMT7vBSRiONSC/kbb5Sw/M5LtViYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(451199018)(38100700002)(2616005)(8936002)(2906002)(110136005)(54906003)(966005)(31686004)(316002)(66899018)(41300700001)(6486002)(478600001)(6512007)(186003)(26005)(6666004)(31696002)(7416002)(6506007)(53546011)(66946007)(8676002)(36756003)(5660300002)(66476007)(4326008)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXo4aFR2NHdZNDhxWHEzdys0MkdFdjFpaVFWRW91SlQwd3dzbXArdElPeW5s?=
 =?utf-8?B?MzdxS3hrd21QcjR5a1RLZkkzOTVsSi9tSjMxMlU1Y2p2NzYxVm1pQTd1YVU2?=
 =?utf-8?B?aGdUVW42UEExU1djaGdXTndlUGZuckgwYWFIQ2dqRnU2UGVIUU1aYjlJK0pF?=
 =?utf-8?B?clZjTnlMRHVSaDQ3UnZjMGNmSnpsbkliWjlwbUIzSTN5ZWkrVk1qbEFka3k0?=
 =?utf-8?B?TE8xR1J2UDNENUdNaGNJM1UweVVZZDJzTUd1Y21iUElDcDQ3OGc2NURLZWVO?=
 =?utf-8?B?SHpBTE5aaUxxaTdKbXNZQUNGOHpOVThDUjFSNUxYR0xYVUJMcXBIcXlNYldr?=
 =?utf-8?B?QzZVMHlWSkhLVEppNEZLRjNVbXpMVFR6Y0w3d3NOd0xIU1l5d0xsTEs3Y2pU?=
 =?utf-8?B?dkFsNVU4eW5ZNEJhQnFFNGxoL3NicW00SlM1RUp4TkZOZENycEFEMXREZTls?=
 =?utf-8?B?eWl1MG9XRkVtQjhITitRNHFkTjJqZzNMYzhtd25sZEp1WUwxM0N5WDNZa3dt?=
 =?utf-8?B?aExHWnl1UjBTUEpvLzM3aGVwZUdwRkg0SWU3NURjcWNKL2w2aUZPRjN6Wnh3?=
 =?utf-8?B?bzYvazNoM0NpM0JWbkhBN2srM1k0aFRvVm1pcWMyMVRwZzVENGoyZVBlYm14?=
 =?utf-8?B?V25mQkZJYXU3VS9HSThJQzBmVlFwVWttRHozWFhEczRwSlZHUjM0ZTlFWjlK?=
 =?utf-8?B?ZnRQK0kyaUdxK0RrVWNhMS9hZVUrUUF4ejNzaGRwUWlWeTdnc3JKK0k0MzdR?=
 =?utf-8?B?OWdYeTlHYlRteENYUWpNUXFVckdVM1ZGNGc1eGF6Z3VMZHk0YmFEd21SSWlU?=
 =?utf-8?B?U1RqaVNaTFJwUGlzcnYyaHoxVVJSWWFsWGJJeGhadTVuU2VrdFR4emlUeVM3?=
 =?utf-8?B?OXZpbGdUMnF4VGJiSms4Slg4eDNFMFFXc3Y0WCtEYnN1Qld1NmloRldaOUFq?=
 =?utf-8?B?L016Y0ZDcngrVjFZNEhSY0hkQjIyRVd5REdYUm5uRHBIUExFbDJ3V1lTQ2pV?=
 =?utf-8?B?V0c5VW05SHlnNjZRODc3VnEranpMU0JUY2hqWDhVb0xZVlN3WUQ3NTIzMUtE?=
 =?utf-8?B?ZFBPRVdBYUdQc2NrMEREZVBENmxMN000K3lUbUR2L3Q5ZGRoSlVPTlJETENH?=
 =?utf-8?B?SUt5WWJUU3ltRGErN05iMGpyMEZDajNWRmdHcXJOenF2eVUydldlWEtJdFRX?=
 =?utf-8?B?dGFLajNPc2dUWUtWVXZsWTlOMFBZdmdmVUpwank4S1R0UDdCcUJpUnR2VEFB?=
 =?utf-8?B?a25yRmx5ZksvRyt6b1JHd0ttTGtOYWR2MzAxTHJHMmZ0UXBzK3haOXAzYTZL?=
 =?utf-8?B?Q2tmcFdPdWQ3MFNaMVZQMkZqS3pPb0xLY2poYkUrNklzYW9tdExleFBPWUFQ?=
 =?utf-8?B?ZW15SzBHRXBIa3Z1R2RnbEEzelc0NkppNFZMKzZwbDQ3U1FmN3lOSnhWcUF5?=
 =?utf-8?B?bVRQalkzaHlRWlRaa09FaEtiWGJzOURpTTMrZmN2WE9MMUdmMjdRa0l0ZDBv?=
 =?utf-8?B?UENuY3RnMWJjNFo4enRwV3BoZ0QwRlNGVXVTWnRjRkFwMkhJc2o2Y0NpL1Nt?=
 =?utf-8?B?ME95b2U2MEtWbkVpcGVBWTMrb3pSRmNQckI2NWY3RkJxYS8xRnF1Ty9iQXFu?=
 =?utf-8?B?dG9VbFdCZTMyaTNmMkpsdG9qUG1nNWVmSUF6YzcxZTlvbVJhblZ3UjZqY1BZ?=
 =?utf-8?B?UU5mSnp4ZlpnbU9kckJiWHRyREszZmZ5bCtsTEJuNWxsSmMxUHVhK2dwUjJr?=
 =?utf-8?B?VW9lSzdRVmdXc0xaUS9iU3ZBWGc4Tkxxb1lZeFZqclAyUjBSNXVLUWUrS216?=
 =?utf-8?B?bmZwZTJ1N0NMNm0vZzg4c3VOdTJuNjMya1h5ZXdaVWJYbWhVZXpoVGVnRGpy?=
 =?utf-8?B?ZWxwWGRqdXJJMXlUUlRzcGl4NWxGNFlVaEhBWjR2bXo2VnRDY0FaYlRtTVY2?=
 =?utf-8?B?NHExc1NsVjRWK2RmUFMrT2JaaVcrTEtiUWw3NDkyTG9DRGpHR05vdmlxaGlI?=
 =?utf-8?B?c0NjcmJ6L3lzMXljbVQzVmZPZTI1TmNmM2xmNVU5ZmZIcnY3TC9yQUYzak4y?=
 =?utf-8?B?WUpHTDR1R0dRRlNMTEVaVXhlWWFZOGx3aEV4eU5PTk1URFhvU3FQMVZ6N0tG?=
 =?utf-8?Q?4JY2aXDZSi5P/g8AkvjkWbiZ4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760afbeb-84c4-4efa-e672-08db005d9011
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:56:45.5545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9pK8eyIIBQetGNsiJQMqNzi/icYqq5Sg07r1rFGcUffaFCjMvL0NUpC2OqYQhcUtP76bJA2BA/YkJk/rwv+4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6712
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/1/23 21:37, Joerg Roedel wrote:
> On Fri, Jan 27, 2023 at 10:08:14AM +0100, Peter Zijlstra wrote:
>> Welcome to the wonderful shit show that is x86 exceptions :/
>>
>> I thought sev_es_*() is supposed to fix this. Joerg, any clue?
> 
> Hmm, no, not yet, the stack-trace doesn't make much sense to me. The
> sev_es_* function calls in the NMI path are for re-enabling NMI and
> adjusting the #VC IST stack to allow nested VCs.
> 
> Alexey, can you try to get a more stable backtrace? For example by
> building the kernel with frame pointers?

Do you mean these guys (below)?

aik@aik-Standard-PC-i440FX-PIIX-1996:~$ grep FRAME_POINTER 
/boot/config-$(uname -r)
CONFIG_SCHED_OMIT_FRAME_POINTER=y 

CONFIG_FRAME_POINTER=y 

CONFIG_UNWINDER_FRAME_POINTER=y


Here is the complete output of that VM (200k so not in the email):

https://github.com/aik/linux/commit/d0d6bbb58fcd927ddd1f8e9d42ab121920c7eafc

Note that the original long backtrace appears more than once, I just did 
not copy all of that in the first email.

-- 
Alexey
