Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8946166778A
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 15:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbjALOpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 09:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbjALOoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 09:44:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CCA63D26;
        Thu, 12 Jan 2023 06:32:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCkYj9znb+dn0FezFe0QW7yiSAOxZJiAwmU85VwV0PgR7W09WMEcggqTAmC3VIsOUTuEiwEt7oKSIf/BqgA9FR9FiqXpMZ22sfRRO25BADX2ammuPI5d1EVRLCpvgfVe9518VbTZz2ai0+ug4pmunqSxX0RroBmA8tlyF3ObFCfw+bVScK56jtrsWxy72Eg2YwRR7mLT1uom4s+sC/0gvJQ2X+slvDIVqHdZ3ga9eyTd9RnbErPcmS6nPj44UnbyFVzaGFEzsZeLUkNUHfVz+/AlbgO63nmYVj7gN6wmtFVYm2AoEr+xhshLq6D42AMlecgkgtrz2Zfhuh9feoV2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AqGZEwInKBw7bRMGTiec+BkDHhlWs3fbFSgiGpvgsss=;
 b=U64pAe91rgHpHg08z/952QXae9RyboshzNG5QTMCJEHiaVypNWsP/Ex09p5qrFLcexiBOuhixo+NHYOqWXTiADLhgY79e2fUlxz2w/om5tMsLyjZVN6WmC40CB1jMz+mtWPqz1eZlPYmmX38DMZvOJCmscJfan7VpVGcwzrMMkfew39YOiaEgGLNojlnKQc7gpS4yYoR9g09qkjUb15lT6szZg0hWtY1q+c8Q3Bn3h29HNo1HxutucjDQDUK42NuDG9cywuXWAZ0ELG7Yf3XKKtQX96n937AoVvGRUoN0AcWc1gEX0TSRIw8V90fkCaj/Z86aWp8LnF272x+L5MtCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AqGZEwInKBw7bRMGTiec+BkDHhlWs3fbFSgiGpvgsss=;
 b=ukHsIVrqIguBRoNcIdN6O5INDB+NGSyxQtr9sG2vBzVGVxfMecxZB1lI+tVC07uRGJ2oF+nyPO5JerJO6sIEgt/FS3ERQVNjx83sKEOUUJeZLXL+IjSvz4RgyJ6NahYFknXRtWQ9Gr0tI46ny93YTLpN2THn5v9twxdlS2h+sCE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SA1PR12MB7224.namprd12.prod.outlook.com (2603:10b6:806:2bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 14:32:50 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 14:32:50 +0000
Message-ID: <50e9a5df-b574-5fa5-466e-7bed48523897@amd.com>
Date:   Thu, 12 Jan 2023 08:32:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH kernel v2 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221209043804.942352-1-aik@amd.com>
 <20221209043804.942352-3-aik@amd.com> <Y72nyuKT+VJYiEUi@zn.tnic>
 <f18c83ac-dc9a-6173-7ab3-d5e3718a0047@amd.com> <Y7/u76mREet2IrtQ@zn.tnic>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Y7/u76mREet2IrtQ@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:610:5a::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SA1PR12MB7224:EE_
X-MS-Office365-Filtering-Correlation-Id: 620fa5ed-c51a-4fd0-b7dc-08daf4a9e187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +u4rGJtlwNeA/a4u3S5GVml0X4qIqk+gKHI2d9biGx8mwjSwjnBnUm86w4EAcNKBlGeha3dmOkVfpy8YSEkZG2Mzu+Df+gnT6hkTWyZJsqpDZvUbBsV7ZTCPU5nxNitCUnF6i30LpLceQ+k9yXb9tIz4w+T6Mb5gzYXdVYe3NaorE8ZavO/f5k6tqBI4WoSIijo0pLIBltAOFs6R5g6qJOvylsrwbhg1utt82+YiusGJGz0PjWIv0aFsWSLI7oPiQUdkVfl16Hm0oqSLknKmuhemZcJ5xmrdpOAntryG9pZRs6gGXrX10Y37rstPhjlH0pmO4WCQTPkIce+DjsFTCpFHLWx6q2lJLersljXliwcAR50aWAvkBHB8qlFpdEAAWvFNmk0/fwv75z5w81ZsVpFZVJ4Z3daBexALq1h28ZhiuxAy0JeKhJPd17kaBnvNooP76S7a05WKhn7JaQqlJ6nRF9YcbJcmB0nOTr3KJyI/vMVzt8+RJO0pU2isBGLwfrK+fTddauWmokoqlE5/ZcSa3SnQoqjWd5LrGoSX9t0la38ExnqWdXTF+/olU34SgF6MI1Fw3yHvl88nGGsz+mqKVtM3O/HGOSNlJo/a4bPJr3r0q5NjqHLny93gc2y4ydd74vzPlAf0f2RR3C6wgIsellx+MVfNS9exbc+aiuMiY1rZpWFHL4eBGUaIB4Eat4vrkIoDBgQir75pO/XPpOae4I0RN/GRyLd0uhC2RAA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199015)(8676002)(83380400001)(2906002)(38100700002)(31696002)(7416002)(4744005)(5660300002)(4326008)(66476007)(66946007)(8936002)(6486002)(186003)(110136005)(53546011)(41300700001)(6506007)(26005)(6512007)(6666004)(2616005)(6636002)(54906003)(316002)(478600001)(66556008)(86362001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDcrbGM4ZjRuaFM3d3MxWXRyejFsZFd3aGlyMlo0YnE1WDZlYkRyck5JdDhB?=
 =?utf-8?B?QVNQcERXa2ZYV0EvUlZvb25ONFo5ZlAwK3hKSTVQdENQNVBSSnpmL1VUQXU3?=
 =?utf-8?B?L25CdmRWTm0zUENhc3ZRdUJmNzFEenBXSWlwb3hPVVlsT00zZHhMR3hsZTI2?=
 =?utf-8?B?WjZTVWo1bG5BYk5hM0c3aWo3TW01UVNPdzU5SmNtM1lvZVRuc3VzeElycTZ2?=
 =?utf-8?B?d1ZtZHVQVFBxNnNTVjV3SWtZVXNlZ1Fod2h6a05nS0pVUDlJL0VEM3cvdXZu?=
 =?utf-8?B?UXI1UmUvc0ZXdFFMdUllQytLTUVXWmdFTTN1WVVaYnIxVW1weFJ3Q2VWZTRQ?=
 =?utf-8?B?QkZjNERGTkVHaFpXaWNzdnN6dmRmb3NhMVJ2Yyt4dlZhZFdyNVdraEpqNU9W?=
 =?utf-8?B?QUlYMWRGQTkvZGdWT1VOblNGUTZEakdDSVJpb3g3d2JZTVRKK3lSYjAyMmMy?=
 =?utf-8?B?YUVmMk1iRGVuRk95MGZGMHJhZTdYbm9JUTZuaS9OWU9aMlV0WXFHc00zL1ZH?=
 =?utf-8?B?RFlseXg5cVZrYkFNUkNsRytpSW9VUjlmb2k2TWRWSWtjaThiQ0N2RkV5a1NR?=
 =?utf-8?B?cjZjRk0rSWVJV09jSFowelhhTy9MaWJLSWVWUjJxd01HRmJpbmVVenVJS0xT?=
 =?utf-8?B?Y1JSVzQwM3l6bXdtSzd0L0tSeG5HOTlpdDgwQXJ1bUliWU5BL2pMam9kZHh1?=
 =?utf-8?B?WmpMVEo3SU5zQUlFRm9nS2N3YmJNNXV2aFBBcUY4b1daNW5ISlFmU0JDcGc1?=
 =?utf-8?B?Nmo2YmU0QSs4Ykc5b3JvMzhETnI3MFFwYlAwNG85c3FYc2FxbXFEOGFDUFI4?=
 =?utf-8?B?RHlSWlNGeE5lODNTWklVcHpMNkxaZFZyYmdXWUh5c2gwMENJdlp5cC9OMHVS?=
 =?utf-8?B?UEdnd2NrU1JqeWNCNkdpcU1mVVZZY1dWRjhxUXJQMkR4OGJrdFNhOStLMjQ1?=
 =?utf-8?B?aUNZdGZEb0hGUDVLSVVoU0JlVS9YL0pGcGt3RWRlNSsrU09IUGZzMmQ1dG5R?=
 =?utf-8?B?MDg3dEFzNkZVZGxWdFZSMDArMmhTbStad1h3NlVxd2l6aVJnc3R1TGo2NjQ3?=
 =?utf-8?B?cEt5RGJONzZ0ejRXSG1ka3N3a2ZudzFBNnAvd3hkcXhvOXlmKzlwQWhXcUpn?=
 =?utf-8?B?Rk9NdnhoUUI4NUZWRHM1MElQMmhKRGYvNE8zL3E3bGQxdW5samVNdzhXemxv?=
 =?utf-8?B?cXJZcmtrSmJNdTlOb3FYYU5TT2ZqTFJTcVpMRlc5dS9VNDZ0TVNQT3BtRkgz?=
 =?utf-8?B?M2pLYWE0eTcrSWVlMWpHSHk0ZW1kZkFMSWsxMGZ2YVNqbXpYZ2dYdmdMMlZw?=
 =?utf-8?B?dVB2TVdhNjkveFVEenBPV2F6c1lTTEVNRjhjVUhEMWE0T3lNdFIvYTVNcy85?=
 =?utf-8?B?UlpYQi9wZjNjK01LckMrYUNBbHRVQjFSQkJVMEt5d0ExNUlsckV4ZCswOWIy?=
 =?utf-8?B?Tk9uV1gxSDRBUU5rREtmWWFhVFVFc1QwTW94ajAzTzJwb29EQXo5Y0pQaHU0?=
 =?utf-8?B?WjFOcTAyUG16Y2ZIbjY1THZFcUl0TlNKSXByMXFkN096NTBiRTlteHlBeFdN?=
 =?utf-8?B?dVlQRkUxd3NVSERrU1U1MHBkNFdQaXgwT3BzUkV4Yld2ZVY4Y1R3WUVoVkxY?=
 =?utf-8?B?UVUvVmlTbUQ0QVFIMjlKVGRGSlZVUGY4a24wWnI1cDJ0YWZzTGFrZHZJSGRZ?=
 =?utf-8?B?clYrQk5rbDhqZmNLSWIxS3dCMTZMSFR4aDdPenlLSmZCaXdUMEdZY0h1Y0l6?=
 =?utf-8?B?eUdmSE1kTG0xeHliajlFOVl1cDBsakpESURxWEp6clpYSGJMNFdGUmxYYU1D?=
 =?utf-8?B?UzR1VUFjaWhHUzdxUlB6QzcyUHdQenhEUXYrZGdsY2F2ZHJSUDlEOVBLNjJv?=
 =?utf-8?B?TXI4cGVJMGdCZXdZY1V1MzVZY1U3c2dIa3RPUXJ2WnJhbXZPNXU0U0s3MTBl?=
 =?utf-8?B?RHcrb3VhOGRjeXM0RW1Ca2hmb2NXT2x6V0R4cDVrLzdJQ1IvbGY1TjAva2Vy?=
 =?utf-8?B?RnhUU0s1WFVHQWtwWlIraS9lWWVqTTZVdTVjeUpmZ2xpVjh1YmFuUVh5eEtv?=
 =?utf-8?B?YVJhUHRPQ2dVZHdWRkZTelBiUDVkZDhUZDh1L1VzdURFY1ZKSHk0QmZVeUtL?=
 =?utf-8?Q?9fO3QQW2jCtbyIIp/3HE+eFrt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 620fa5ed-c51a-4fd0-b7dc-08daf4a9e187
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 14:32:49.8795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWSCgkzSuLcUukfLgWMHtHLvE5YdgXxSxrwEXFfTSfvYX+/s1bEIvLC8eVv651o8f8YH3opxbV6jQnu+xLzHqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7224
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/23 05:28, Borislav Petkov wrote:
> On Thu, Jan 12, 2023 at 04:45:34PM +1100, Alexey Kardashevskiy wrote:
>> Well, SEV-ES KVM (ES == Encrypted State) does not save/restore them for the
>> guest (well, as I would expect) as the guest registers are not visible to
>> host to save, they are intercepted and the VM does this GHCB dance with
>> VMGEXIT(SVM_EXIT_WRITE_DR7).
> 
> But they're saved in the VMSA, as Table B-3 says.

Correct, when this feature is enabled, the VMRUN execution will restore 
the guest debug registers on guest entry and save them on guest exit.

Thanks,
Tom

> 
>> Well, the only place in APM is that "Table B-3. Swap Types and the AMD APM
>> volume 2", and it is pretty brief, do I miss something?
> 
> I don't understand that question - please elaborate.
> 
> Thx.
> 
