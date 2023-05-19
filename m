Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09717708CD3
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 02:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjESAVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 20:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjESAUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 20:20:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C3D1985;
        Thu, 18 May 2023 17:20:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jg52UXy5J3UBpj7i1G2Lo4y8kCdEPMo3X2xw1xY16sATDz2nDTosHLnyEz0AG5WLwycLpKWitU7N6sUCn3T89AUMoEP+XvGv4f9NLC6cZdCEAB/puU4NBbNZS8+KvW8sF5VI43Qzu+6BVx3hMVJcNffs80CvB5pDy3L3duSQGnYwcBlZnA5yIcpzK1ySbQnkf3wpBrCOnUfYZzx1ee/2KsJa1EgWQHmsWn7be/rjgijtYixtfjSGasXb3U2e4nstuImbgjYnxXOajAeXAF1oKwTVROHwEvNvwtBxhqE22mJXtCiC7mQHMOo0mTpfY4jEDOyWg9Pxo6N6lPCam0cW4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jqoqfDfrKu9td1gtDfE321huEqdE+N8XNLvzIoixnFA=;
 b=KVRJVqOZ70KO4ofH8E0JlSZMJV4NYDYRpeip2py3+fS5ALUUKA/wAWvuevFILVb381qq9zNDcM8yAs8jNtMppIArEHDmf3YL4jJlg7WVN/sWDs6jxLeDtzdLa/UPEX4QPywGUUyLDPZStdlI16RYFCT8Ao9WDMXjnR0x4sFysLdmlIYYsf/CNbiemsDUIRPWrT9TEkFGJcznLwl0D6g11RcFcAQ0BZezwP7TtwumUoMp2m+v2r7DZfmfutH/LTVntRWHTmedZn9BCDZwOk933pk8LFMd9s+nnSB9JyeqePGt5aGnthI84tilGhvx+Wimwya64B/c5lTcJ3QumxjMDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqoqfDfrKu9td1gtDfE321huEqdE+N8XNLvzIoixnFA=;
 b=NCnk8z56gGge7/RFJkqv8AjWmNSHBWU3Col+FBj0FE0pIW30qE42oy1FG4gHlPi9PlWWX12EfiSBaYYNER9GmwsQNyw6uKzzS4i4QA6Uzf8dUltbqtzSgUUNtOExOj3rwPVyhcaapZ151WhlGTlggpai4TYaGgvnTRBmAsW2ke0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 MN2PR12MB4303.namprd12.prod.outlook.com (2603:10b6:208:198::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17; Fri, 19 May 2023 00:19:14 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::d2ef:d75e:d9b2:835f%7]) with mapi id 15.20.6411.017; Fri, 19 May 2023
 00:19:14 +0000
Message-ID: <4d9397fe-1098-dedb-0f35-d3535040e65f@amd.com>
Date:   Fri, 19 May 2023 10:19:04 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel v5 0/6] KVM: SEV: Enable AMD SEV-ES DebugSwap
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        Borislav Petkov <bp@alien8.de>
References: <20230411125718.2297768-1-aik@amd.com>
 <6a0cde0a-e1a4-9119-75fd-12b7c921b5f2@amd.com> <ZEFM735qNFOCGbnL@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZEFM735qNFOCGbnL@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0085.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:201::16) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|MN2PR12MB4303:EE_
X-MS-Office365-Filtering-Correlation-Id: 60f38559-c15a-44f5-63dc-08db57feacdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EUKxZGAS96Bdyk0UfPm62JwRgX02bKphOxcAOVdaXeZ43U0wdtuQ0W1mqOvtT+PWw7gfpY2ek38uXNOn2I4wj/qnImcGlb3Cakr5lzWKh/IfP4JPEeOmdZdZ4nYKjzf3/SvK+9nYirogfMi/JmALGHhuACk6AukKj5TliAiZ7APb3t9kb1eQOjKT5u4eyK3NiIesWHNQ30URhOQuQ4/xzqgqDXmXsERNP+rqZl5qLws8xyfs+08usen95tXJNr6uIlL8YKnkujgz6LJ5inf9r3u9nmkl+Z5cr2LDdYywAogtLDoCS6SEz3WeMhRbeOVMSqvVAJqfh65duI2HmUPylefY71YykNLFYb/alpdbIebPq/1fOGUwNWI5/DJ3tZ+PNS5a9EIwHAeOWbOhA629ivAAlUlXlogwu0B+StGICMCWCN4NhUah9EwxpfnMuZpbfPngD/fS9BFTO6ryvjjXEbTmgLAkcsrLrfd0jAbi0NVb7QxnhUFJ2I+yCOjjrnsfdG1jBSZ4d9Sd886eHgpvtgvRDd3dmx2+ubd/B3osrR+eLo+PKStUjoovHvBZC8zpqd0I7yiSr8Guzyub3n+sOOyO6e+cZWaF9WbtPrgRQ6L1XG4UnUbCu2rkhT9nc1E4tDyr6BY3kh8GymO0cnDJqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199021)(66476007)(966005)(6486002)(53546011)(31686004)(66946007)(66556008)(6666004)(4326008)(6916009)(316002)(478600001)(54906003)(41300700001)(5660300002)(186003)(26005)(8676002)(6506007)(6512007)(8936002)(2906002)(2616005)(36756003)(4744005)(38100700002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlExbEpQU1NEamlmZ3VZVGw2cGdJRzMrb0FLR21uaDZMNVpObnpRT29PZXB2?=
 =?utf-8?B?QVQ4KzFVK2FWeHBtTkdrRVJNb1U4b0pNYkdxUVcyMTd0UGx1K3ZLeGJ5Y2Ny?=
 =?utf-8?B?aXBWZE5JZloyNm5WMmNDYkYzazZhcDBuWG8rbVJnRjhqNFdmdkZ6eHYvZGxM?=
 =?utf-8?B?QXRWaHoxTjBSVFZzNkVLaVlMS09SOE4wczEyMjY4UmF3MmxSM1ZVUldwelcz?=
 =?utf-8?B?dlZaV2pXSENQZjdWSWthbktZb21vell1WitLeklGY25neHpVMjhqUURTS1I4?=
 =?utf-8?B?ZFF6WXdlVjRxaW5DVTBkQjF5bVI1cHRQNWFCVDRzc0RkT2gxN21Db2tQbFRt?=
 =?utf-8?B?bzhvdWdQSGw2Q2VlR1hncDk5UXp3cTRzd0o5cTdYdzNTN295bkg1YmdZcGpl?=
 =?utf-8?B?NXQrZ0lnOE01aEtjNGZ6WWd4S1ZIUFJxamp6ZlJ6NDliV2hPa3ZGQXBpYjdV?=
 =?utf-8?B?QXQ3YVlRT3hqVkJ1cVkvc21NVENSMDdSYzJjQVRCdnlQcGpSNThhYStNcyth?=
 =?utf-8?B?UEM3cDhVbVF3cllZOHdlcll0TGNVWmxoT3VFRFNjeS9MRUtnbGxlOFNTODhK?=
 =?utf-8?B?ell4STRKQ0xOUVpBRUI0NS9PcFlZQTdyZkhkUStZWTdNb1R1VGJsV2E0bXNM?=
 =?utf-8?B?dll3YjJxbzJIeWNHY3Z4WkJVbWxEa2pXc1hwZWtDVEduQVAreWJVaTJYa1R2?=
 =?utf-8?B?U2RvNGlJNVdLMnVNTHl4Y0RkdnhHMHdOUFBJRHVSL0tCa1UveXFVMUFBN3N5?=
 =?utf-8?B?V29GTmlZaXJTVlNTQU81MXg4ZTdXOXdCWUhsRkdCT1NsbzR2YjZNaUtWUGhB?=
 =?utf-8?B?V3VCNzlvTHpoUHhpSytNcVFYNVVpdk1FdExTZUZPQkJIR1AyaVJ3MUdFbEFC?=
 =?utf-8?B?akV6bjNtZ0c2QU1RZzZEL241dXVxK0lIRTBGeTNJTDdMbjZxeVBpa0V0V3Ur?=
 =?utf-8?B?Y05NUHY3MHAxKzRqbE11RlFKOU9YWEhISk9aYjFiMWlsazFNUW1QMy9RRkNY?=
 =?utf-8?B?ZnRWL25MZTI3a3ZzM1M1dEdmRHk0UFVkTTYxK0s0N0FUNm5pamM5NHpmTEdZ?=
 =?utf-8?B?TzR6djBsN2JpOXdteW5MeW5MOGdjby8ydDVMVkNVa21ZSkpLUkUwbXZOQ0Zi?=
 =?utf-8?B?WVhLb3B4VUtRR0JkR2R4akptbHBqT2gzb1Z5K1pXbEpLd2d2WG5iSSsvYzZG?=
 =?utf-8?B?cjRyR2ZQU01xL1NOWUR1RHl0Y1lGeG1FZllmZGo5ZnJ6VSszRTJ6TG1TNCtx?=
 =?utf-8?B?c1pzb1VZb3MrRVRzV2RjbWtEY2JqR1daQklqd3N6amVuQjRGMjlxaVpVWUZk?=
 =?utf-8?B?R3lLM0pGMUhmeldOSHJEMWN6VEFtTHZlaHQvQnV4MWQ5NWF3N3gyb0habG5Q?=
 =?utf-8?B?OFFDQWFQR1hRWUt6cWhhWjRNMG1taUZFV09yL09kYTBKRXkrL0gvV0I3d29L?=
 =?utf-8?B?azBXamZVVXlFdXU4WDkvQ1lLalBCL0hzU3dWNmFjcTFRMWdwbWhYSHo0TEth?=
 =?utf-8?B?ci9ublFndTJOem4xcURVbG04ZThGZDZGREZzaXdxa2NrNXFnSTlvTlRSbFpQ?=
 =?utf-8?B?cnNVQWthTlR6c1ZxNUJ2QVNXUUkxaTAwazRPSTdVeWdOV2tWREN6OFB3MGZ5?=
 =?utf-8?B?OVd6S1g5TWFhTXpDRCtnekZRMzhpUHQ5M0FRRlhhVWwzTEkvaU1OTkJDcm5W?=
 =?utf-8?B?elJYNzNxR05qUldqQ2RzVE5pVmNzNkpnZmdUMmRWNlpLNk9xbEJ5eXhXT25T?=
 =?utf-8?B?NUZINnYwZGhOOGtOcThjTkptY3NHM1hKQkRjSEFsMHYvYlJYMlIzRjJYdjU5?=
 =?utf-8?B?NE1uYnF6M1FjSGRvYWpDLzJ2NGcwTGdyeDJ2VWxXSCt5RUh3UjF5bHB5VEJR?=
 =?utf-8?B?RUlqTThKSW04bXhGZmErZmZ5QStidnNwYllqcUoyZjJFbUpDVmJIOC9LMlhH?=
 =?utf-8?B?MTVMVXJxTm55V0RqVkhVdFFmOUJId0JQc1hZZjJWeTUvbUxiK0wyVm45Qzh0?=
 =?utf-8?B?R3pXd3RvNUc3K3lkZTdQRytIcnlldW43dFJOSXJWNCsvSVR6a3d0S2lKaFNp?=
 =?utf-8?B?aWE4U1ROZVMrSVIzKzBmSUVVYUFGZFN2dVJ0Si95d0t3c1pGSjMwbUw1d3hL?=
 =?utf-8?Q?M88KdbNTWllD1c5ngAVcg2mWY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f38559-c15a-44f5-63dc-08db57feacdd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 00:19:14.0136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AowfyIeI1B50k2pW9db9kP6D/OqVrJbqibJu6Jrm5HBxNkqn/hH1G8M5u5EGvMJcMcTcJcDL4KuHFzFUtjZOQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4303
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

is that still on the list? Just checking :) Thanks,


On 21/4/23 00:32, Sean Christopherson wrote:
> On Thu, Apr 20, 2023, Alexey Kardashevskiy wrote:
>> On 11/4/23 22:57, Alexey Kardashevskiy wrote:
>>> This is to use another AMD SEV-ES hardware assisted register swap,
>>> more detail in 5/6. In the process it's been suggested to fix other
>>> things, here is the attempt, with the great help of amders.
>>>
>>> The previous conversation is here:
>>> https://lore.kernel.org/r/20230203051459.1354589-1-aik@amd.com
>>>
>>> This is based on sha1
>>> f91f9332d782 Ingo Molnar "Merge branch into tip/master: 'x86/tdx'".
>>>
>>> Please comment. Thanks.
>>
>> Ping?
>> Or should I relax until the end of the nearest merge window (May 6th-ish)?
>> :) Thanks,
> 
> Sorry, the answer is "relax".  I'm likely going to be offline for a few days in
> early May, so it might be more like May 15th until you hear from me, but this is
> on my todo list.

-- 
Alexey
