Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2D94962D9
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 17:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348690AbiAUQdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 11:33:55 -0500
Received: from mail-eopbgr140102.outbound.protection.outlook.com ([40.107.14.102]:17031
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232726AbiAUQdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 11:33:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4e7candqpBxdh0uR34DV+nw9TZGye+BCcTAwiZj4/DgxMQ6Sac7/ZoHLUWndDyDKjFGmVlQVy+oQWMEJu9OUQbU7nZEyaponfw9YpT2SuPU5A5ODM3Whf0rw6qxqk9fNodgNOa/8wjbavDa6MpCa6r+9UjP1nvAMWoyzoLjynOMVxtXWaTz8VY/yeXSNekSHdbeGx312dCYr8+ysVULeVUxHteoRfqh2AoWxZLZRkrs9EnSd8SUx5lpSAEFIJCu+OEZs7W5MTgvBrvwMjbHQtz7QL8WZ2URLYXStGHV9uFiaK7hp4zU44r4LAQvdJ+Thxb+a6Niu23JipJ95g3WUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1FQeDyogy1rogrixE3B4mBoGcmhHbk6d3tZhY1Hl6E=;
 b=I0qZVv++VDmFOqSPuOKd1rB8donJGcT72pQcRGZHT7DUTdHgL6ThIvsderF0b06F/1i0YNmkll3QpTKTSJl1nQRLWj77fCB3Q5Ghqm0KksKR9iGvzBg3GUvKi7UfNrbx5Yskqs1uEhpJA40lmQxNQUkwoqyPnR1QmKHWvpIJMV3hlToc8GZvRW4lU9RM55GC4Uhccot9H6/DEe/AfYApGw77E3xGZpV0/9T1koZTtZsYHp/l2s0Vxr5RSRNNxqOJUgmstFkIaNmBDX/Pq09fNr4Sq1RdBFl08TRA6h00UDpf2bUN+CBvof+ImubQHD+nmluDxv5gbod7pJ9B7oHmtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1FQeDyogy1rogrixE3B4mBoGcmhHbk6d3tZhY1Hl6E=;
 b=L7hwR5ORJ6gwV+u7hZydhcZwQ2XL04vkNWiRlJPJHYXIFijngLKLYo6995rVSEiZN/4iFpNYlTXAG25q9QsfbBuDFqmwTcvIFn0SSxl1nFJzGDdmwxUXdFt89CEFxRh/ysoaVtqAy5Zovcly/0nm0Y94yf3Dc2re92MdGwTRq5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB6737.eurprd08.prod.outlook.com (2603:10a6:20b:304::18)
 by AS8PR08MB6485.eurprd08.prod.outlook.com (2603:10a6:20b:318::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 16:33:50 +0000
Received: from AM9PR08MB6737.eurprd08.prod.outlook.com
 ([fe80::4def:4b08:dfe6:b4bd]) by AM9PR08MB6737.eurprd08.prod.outlook.com
 ([fe80::4def:4b08:dfe6:b4bd%3]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 16:33:50 +0000
Message-ID: <2f3416bf-c6af-fe23-79f6-70c65adc50de@virtuozzo.com>
Date:   Fri, 21 Jan 2022 19:33:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v16] qapi: introduce 'x-query-x86-cpuid' QMP command.
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, lvivier@redhat.com,
        thuth@redhat.com, mtosatti@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, eblake@redhat.com, philmd@redhat.com,
        marcel.apfelbaum@gmail.com, eduardo@habkost.net, den@openvz.org,
        valery.vdovin.s@gmail.com,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
References: <20211222123124.130107-1-vsementsov@virtuozzo.com>
 <87lezbdc59.fsf@dusky.pond.sub.org>
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
In-Reply-To: <87lezbdc59.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0003.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::8) To AM9PR08MB6737.eurprd08.prod.outlook.com
 (2603:10a6:20b:304::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10ee6371-c26f-454a-dd74-08d9dcfbcdd1
X-MS-TrafficTypeDiagnostic: AS8PR08MB6485:EE_
X-Microsoft-Antispam-PRVS: <AS8PR08MB64851D5B0CCF441BA686CC32C15B9@AS8PR08MB6485.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KeRyy4K/1OVJakxzY8dSAhtBsqCg6XZ66JipzuKzvxGPgDzEJ6skQhOfB8xTOBqa493YTLMoACaLGeSXTDvPR0fUQiLRAOphMi5IdiVtzqk+CHyeNU67Yrzw9EWJELoF7cKEuU4fNsmmUPVHjQJF7pgo3IphoHD/I07ajAwQKPamN3vuHt3dLsFlwxvP19U2SiOapiS5LoiuASjBu0d/hpjnBdDo/m9B+i+yqw5P3oaLySnonS+D0Ky9i33RSiKnOD3Z03NZPQtFZVh+q+3JLoMptDlPS0UAZ9u5/PJKJijExo+mguyh9+kC7RZ/XcakbmNxyWUrNOOKRZTg0UEa06Cnbwy/ALJPYLixHAt9fLyPonRN6INhYvoL2vVLXHZptOVftxbCEuPLimyrZwIopl50+ajpBd9mYrKqqQ5kKWzEnZ8U5YZvarZIsq4rt9YISTFaSkFI4/k4fAa8GUhoMWpVk+3FO/EuSigAMGtLJL5iTvZNhhlHkbWs+fwMSSbctRCaNAYGr+xT7euVJ9+CBNH2vscFOrKHOtP4E9MIJIC1uBSoL/sxy93lFGc66HuKBvP6Hef4F7MA9KxrilHRXMQAfJF3gk7XYWuvPtWacS0d87SzsqYcyxKEF0OTn7OuNrJxoyP0KlMfAMLYuCTsxUL2F9Uo2tY4FcOlyGfhG4ZJuHeWCQ8pkArSfKAwsdnt65ZeT/Dhse7hlILM0Nbsknoqt0LwkKTLNbrW2jwsc1Qna70wscoAflpkDeVd3O0V/nUswFFTA6JeriKsiee8Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6737.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6916009)(2616005)(2906002)(6486002)(316002)(6512007)(31686004)(186003)(8936002)(26005)(8676002)(107886003)(508600001)(66946007)(4326008)(66556008)(66476007)(83380400001)(6666004)(5660300002)(38100700002)(38350700002)(6506007)(86362001)(31696002)(7416002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUVBWHdoR1Q5dFJsVk14d2tjaURkdEZHcW1TQkxhWGNPdlhLdzh6VGpwWWFh?=
 =?utf-8?B?bVBBMkczUENyRlBFdExVMm1RcUkvZnNJbGRwdzE4bFRkVTlzeGtYQjJLRWZO?=
 =?utf-8?B?U3V1M1NHbXhHc29DR2k4U0lGTGlPdjEzSEdxb3Z5a1pleitZK1VVNm9IdE9w?=
 =?utf-8?B?ejV3NDBxdUJkWFJVaFBNdGdpa1N1MTV4cTVvNWh3L3JHUDNrdWNicFBBYzRF?=
 =?utf-8?B?SzlBcStDVFJOU3hCVlI5Q3NqNWhpdlFHZFJ6QitveXJUVXRIZElmVEo2NkFW?=
 =?utf-8?B?bzVyeDRLd1dBUUcvR2MwSEwyK2RXWEcvMWdVRUtOSERWeEt6T3lBTStlU3Bj?=
 =?utf-8?B?Z1VObVZFbjJ5cVBQYjNpWi8rZTR6WTBpTnBqWW9oTnZJY2tTZWJmR0RSdUNV?=
 =?utf-8?B?Tml1bmZHdjc4WDQwWmVzcW9LSHlKSnpBbjhDb3RTT2NMNnFZUXltMElYUzht?=
 =?utf-8?B?cFhMRkxpWUtYTWhRUFNjZDNDQVQ0RWZ5MjFDVjZOSExVaW1hV2ZMMXErYzdO?=
 =?utf-8?B?ZWd4c1pkd1Rma21QRmhqSk5NZHpWU0hVVGxNOVJpK0s3V2thOG1CVW5oUnlV?=
 =?utf-8?B?WEpsS1REZis5ci9HNVpKck1XczlVRlFXZ29Da2RwUldRUVVxYTVHWWwrZU1R?=
 =?utf-8?B?THd1cjJ2NU50SEtpdkZYck1ZSVdKTmdwazlsRlVlbHJabFdwOE16cXZVaFdi?=
 =?utf-8?B?K0JLS2FweFhYMHRZV200TVFOVXFiY0NaNFc4NVd2U2JHdW5DVlVWTVIwSGtp?=
 =?utf-8?B?Q2xWU3FkNUErSEFQaURyY2o3WElRSTZ6dnI5OVc1b2FWbnJ0Q0NmbXJaQnpQ?=
 =?utf-8?B?dVEyLzVRWG1WQ1hZQm9jSE1scXljeWZjY2RhOThyNU1GajFlTHZPWjNiYUZl?=
 =?utf-8?B?SUtpOTlWY20zZ1JtYnRrK3NrTUQ5eDFGZlZsMDRzVnBjekRZNmdCNTBoN2tp?=
 =?utf-8?B?dDhJTFVicEhFc1NWbTZwM1l6clNmVHRmRGt4WldweVBhSG1KLzdIdm9KbVFi?=
 =?utf-8?B?cnVyR2hhOXU1TEdsS29HNGtVTjNZNWJZNis4OVR3R3Q1T1NtN3BoaHBLbHdW?=
 =?utf-8?B?U2tvdG4zSkV0anAzcDdpNmhMRUhuMklhU0lOMGRZVVJveUlxNGJFekVBcUFK?=
 =?utf-8?B?RlpoT09UMWRuM29lNVZQQ0E3K3JSbXpzUzYyYTJzQXVzRjVlU2tEbnBNay9q?=
 =?utf-8?B?ZTlVcEtpTmpDM3cvOXMzUnNaMzgxNWV5VHAwTVQyTWlwRVJkdTFIeGdJV1pN?=
 =?utf-8?B?dTZQVk5nV0FOK05VU2lsTDBvVzVGVTJKZGNRRmNPTFNyL2E2cnlxd2VqSjFY?=
 =?utf-8?B?eHkxRXJ4aWFnRTBHOFQzREVaWktKVFcvUGo2TFRlYkNFRDN2OEl4enlHTnB6?=
 =?utf-8?B?dlRxYkw4Unc2VHh2aGRzM2hreHhEM0JIdmJEMzgvakR0YzFUUzlPQWRyeXhs?=
 =?utf-8?B?cEpEQVYzVDEzS3Brc08xZUZEZFdXTVBLOUhHcVM2V3JnMWhybjhFWVkwSDJo?=
 =?utf-8?B?M0ZERmVlUWZXdmlReUU2ZGdOMmpiU25WTXk2bHFmdk9PQ1BEcVNvTFUxUitK?=
 =?utf-8?B?TzZ4eUhFVnFjMklGVWZDVlEwR1JqdTlyWVJMMUxtNllibjJubjZuc1hKTkY0?=
 =?utf-8?B?SlYvZFpyUUFBQ1RmUFo5SlhDTnl3WnBMelVGc3VUS28zeEVMaXRvWWdXWk5y?=
 =?utf-8?B?UVZQdmJnOHlYNkt1YXF1cnFTMlpBTGxxTGtkTHBYN0xqMk53ejJiTklxMEJ2?=
 =?utf-8?B?SWcrdFhpYmhKYlIwNk9TZVh1Q1p6QnQxTkhWY21PdUd5MWJxVGtucDIxaHZP?=
 =?utf-8?B?MjBmZU9NNUVOSFZLVnhlbHVyaEtjM1hRalNtSUtZaHdxYWw3dGJBT2dYSWFj?=
 =?utf-8?B?TjR3MFRDcHM4VzBkRFJDNUZyNVNXc2NKalVKZ0Jqc3JsNWsrVi9kUDhGeHZT?=
 =?utf-8?B?cDR3a0RsRGZTVHBSM0hMRXVSdFdad2xpbmRRcktkYVZlVTZ4eE9CZG9aR1Jx?=
 =?utf-8?B?RHR2aU1uRVpMQnBQUVc4TXA4Qlh2VExSYXh0WEVZcUc3V2J5bWt5RHM1TWJo?=
 =?utf-8?B?RmlMTzMzV2Y5WVNJZVZtMWpwM3Z0Y1FQYTEyMGNpckpnZFV0YzRMTy8zOUdL?=
 =?utf-8?B?UHllMjVCcnlrUkgwNkxaQ01McWovZ2hHVHpZZERCck1iRVFjK3FFVG9GWHVE?=
 =?utf-8?B?bEJxNGdFQTE4WnBlVXZZSVUvMFJ4bGkvQjFtRUhzQWxKOFQ2Rng0THg2elNK?=
 =?utf-8?Q?xODzs9ojHJcp+/Qqp5k/cRoAY/03Su7Z+zfTGWn+BU=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ee6371-c26f-454a-dd74-08d9dcfbcdd1
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6737.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 16:33:49.9651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7yCF1MtRawX4zipYVHmHEbIs+Ls8rkC+AzZnRojr+PyBp8CQ62x+QyX3xeECNFg+qWIHcOsBPYNLTwTD3na+yAerP8aQocJhwDGNe2nerQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6485
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

19.01.2022 17:37, Markus Armbruster wrote:
> Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com> writes:
> 
>> From: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
>>
>> Introducing new QMP command 'query-x86-cpuid'. This command can be used to
>> get virtualized cpu model info generated by QEMU during VM initialization in
>> the form of cpuid representation.
>>
>> Diving into more details about virtual CPU generation: QEMU first parses '-cpu'
>> command line option. From there it takes the name of the model as the basis for
>> feature set of the new virtual CPU. After that it uses trailing '-cpu' options,
>> that state if additional cpu features should be present on the virtual CPU or
>> excluded from it (tokens '+'/'-' or '=on'/'=off').
>> After that QEMU checks if the host's cpu can actually support the derived
>> feature set and applies host limitations to it.
>> After this initialization procedure, virtual CPU has it's model and
>> vendor names, and a working feature set and is ready for identification
>> instructions such as CPUID.
>>
>> To learn exactly how virtual CPU is presented to the guest machine via CPUID
>> instruction, new QMP command can be used. By calling 'query-x86-cpuid'
>> command, one can get a full listing of all CPUID leaves with subleaves which are
>> supported by the initialized virtual CPU.
>>
>> Other than debug, the command is useful in cases when we would like to
>> utilize QEMU's virtual CPU initialization routines and put the retrieved
>> values into kernel CPUID overriding mechanics for more precise control
>> over how various processes perceive its underlying hardware with
>> container processes as a good example.
>>
>> The command is specific to x86. It is currenly only implemented for KVM acceleator.
> 
> Please wrap your commit messages around column 70.
> 
>>
>> Output format:
>> The output is a plain list of leaf/subleaf argument combinations, that
>> return 4 words in registers EAX, EBX, ECX, EDX.
>>
>> Use example:
>> qmp_request: {
>>    "execute": "x-query-x86-cpuid"
>> }
>>
>> qmp_response: {
>>    "return": [
>>      {
>>        "eax": 1073741825,
>>        "edx": 77,
>>        "in-eax": 1073741824,
>>        "ecx": 1447775574,
>>        "ebx": 1263359563
>>      },
>>      {
>>        "eax": 16777339,
>>        "edx": 0,
>>        "in-eax": 1073741825,
>>        "ecx": 0,
>>        "ebx": 0
>>      },
>>      {
>>        "eax": 13,
>>        "edx": 1231384169,
>>        "in-eax": 0,
>>        "ecx": 1818588270,
>>        "ebx": 1970169159
>>      },
>>      {
>>        "eax": 198354,
>>        "edx": 126614527,
>>        "in-eax": 1,
>>        "ecx": 2176328193,
>>        "ebx": 2048
>>      },
>>      ....
>>      {
>>        "eax": 12328,
>>        "edx": 0,
>>        "in-eax": 2147483656,
>>        "ecx": 0,
>>        "ebx": 0
>>      }
>>    ]
>> }
>>
>> Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
>> Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
> 
> This needs review from x86 CPU maintainers.  Eduardo?
> 
> [...]
> 
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index f5ec4bc172..0ac575b1b9 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -341,3 +341,49 @@
>>                      'TARGET_I386',
>>                      'TARGET_S390X',
>>                      'TARGET_MIPS' ] } }
>> +
>> +##
>> +# @CpuidEntry:
>> +#
>> +# A single entry of a CPUID response.
>> +#
>> +# One entry holds full set of information (leaf) returned to the guest
>> +# in response to it calling a CPUID instruction with eax, ecx used as
>> +# the arguments to that instruction. ecx is an optional argument as
>> +# not all of the leaves support it.
>> +#
>> +# @in-eax: CPUID argument in eax
>> +# @in-ecx: CPUID argument in ecx
>> +# @eax: CPUID result in eax
>> +# @ebx: CPUID result in ebx
>> +# @ecx: CPUID result in ecx
>> +# @edx: CPUID result in edx
>> +#
>> +# Since: 7.0
>> +##
>> +{ 'struct': 'CpuidEntry',
>> +  'data': { 'in-eax' : 'uint32',
>> +            '*in-ecx' : 'uint32',
>> +            'eax' : 'uint32',
>> +            'ebx' : 'uint32',
>> +            'ecx' : 'uint32',
>> +            'edx' : 'uint32'
>> +          },
>> +  'if': 'TARGET_I386' }
>> +
>> +##
>> +# @x-query-x86-cpuid:
>> +#
>> +# Returns raw data from the emulated CPUID table for the first VCPU.
>> +# The emulated CPUID table defines the response to the CPUID
>> +# instruction when executed by the guest operating system.
>> +#
>> +#
>> +# Returns: a list of CpuidEntry. Returns error when qemu is configured with
>> +#          --disable-kvm flag or if qemu is run with any other accelerator than KVM.
> 
> Long line, please wrap around column 70.
> 
>> +#
>> +# Since: 7.0
>> +##
>> +{ 'command': 'x-query-x86-cpuid',
>> +  'returns': ['CpuidEntry'],
>> +  'if': 'TARGET_I386' }
> 
> Needs feature 'unstable' now; see commit a3c45b3e62 'qapi: New special
> feature flag "unstable"' and also commit 57df0dff1a "qapi: Extend
> -compat to set policy for unstable interfaces".  Incremental patch
> appended for your convenience.
> 
> 
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 0ac575b1b9..049fa48a35 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -378,6 +378,8 @@
>   # The emulated CPUID table defines the response to the CPUID
>   # instruction when executed by the guest operating system.
>   #
> +# Features:
> +# @unstable: This command is experimental.
>   #
>   # Returns: a list of CpuidEntry. Returns error when qemu is configured with
>   #          --disable-kvm flag or if qemu is run with any other accelerator than KVM.
> @@ -386,4 +388,5 @@
>   ##
>   { 'command': 'x-query-x86-cpuid',
>     'returns': ['CpuidEntry'],
> -  'if': 'TARGET_I386' }
> +  'if': 'TARGET_I386',
> +  'features': [ 'unstable' ] }
> 

Thanks! I'll resend for convenience.

-- 
Best regards,
Vladimir
