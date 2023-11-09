Return-Path: <kvm+bounces-1361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EDFD7E7148
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 19:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6DD12812E8
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 18:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564D8347A2;
	Thu,  9 Nov 2023 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="xF4Sg5Z9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D3730322
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:18:29 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2130.outbound.protection.outlook.com [40.107.8.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA94D3ABF;
	Thu,  9 Nov 2023 10:18:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cl9lqe9EX67YtznLawLp54olwUcSaXnLjD8yQLIfe7isbUZiiGmWUaZ93zZ6G6c7lY5jJf05DcoEdZK34YvJEpm7r1F5zTQw41Jz6Ws2WuLOFKLo33jtFDqgygsU6xKxBrWVLrltT8yPlYCaFRPsGj4le9AZufwrWiBQjKm5K0XDZ7o7SPvogVQg4o1oR7PeGBoWtzA70m3HiaLrYaWJY2QEbBWMkUZ6YGnAKQ5wL5FMWWoYt43JYvrVwPEVf+mEZwSDWG7cd9w91HuX4gLic5UB8w7zQtPElDWkjry+9XEXWT8TQo7t5K+M4IdOC3bK9w2RpkqgdcA2uKHxsI8Vvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blGL05vVxzyIB3Nb5+T1pt8znn1emmrem/DNYcft+zk=;
 b=nDUV2H2WlSEPHVFy0Xr/gZ0A5LgCreD+4B7AuPn8j54xxzqgxUWjeBO0q3SCUUd+0D4wzSd2RN/gCsE0GnF6JcyOyC3RniETLgq8EdjFxwMfATKCjJGCFb9z00YcdHBAJJq/bTNZloMAhpDy/JfRIIQYhGWjClMO3zyjZ3GqqiQSVzXG0ruS3yIQ2Xd9ul+Nj9W/R7Zg7YhMZhDI4GNDtP1aw/+n94NCHrcG3ZTaMCnROKupPHtxIWj5sLGJAIRp/+V42FjcxhhB2FXxB2yTmv5YP6i9OQPpumhOnuAwh84daYIgja85NjkiGVq5CFkXuHp9KdpMRAbPP7s04/B3gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blGL05vVxzyIB3Nb5+T1pt8znn1emmrem/DNYcft+zk=;
 b=xF4Sg5Z9FASzu8MFZh+L3g7n32XV77ItNXzHlurbzA1fZ1I46jmwVxvya94gH9LazeMP87MPjU9aPIiFzJht/eNKr/VEleLk5k6s30KmAyHzq8+1fOoOl1PbK46fngYgb6PvsXsFj+tUvfh12tOj48Nxyhm+ybZaoN+7Shi2wpMVXRvFjy/HY+e3cFmG7U8A0dnAk9oxaN31uyspkhP4hwlD28n/NyuWpwKT6JAhTvssKaHUA7azxLdWViQFC8bR1srvlvo92Thw3Eejf6n5I+7aPBR5Ty2t5uthdVBDgyoVDREeXKRa3yuz6O6w5lxdYaGIBEt9AWMLMbBPIuEwoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12)
 by AS2PR08MB10109.eurprd08.prod.outlook.com (2603:10a6:20b:64c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.27; Thu, 9 Nov
 2023 18:18:25 +0000
Received: from DBAPR08MB5830.eurprd08.prod.outlook.com
 ([fe80::5c2a:3dba:5815:c222]) by DBAPR08MB5830.eurprd08.prod.outlook.com
 ([fe80::5c2a:3dba:5815:c222%4]) with mapi id 15.20.6954.029; Thu, 9 Nov 2023
 18:18:25 +0000
Message-ID: <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
Date: Thu, 9 Nov 2023 19:18:22 +0100
User-Agent: Mozilla Thunderbird
Subject: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@virtuozzo.com>
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <20231109180646.2963718-1-khorenko@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR08CA0227.eurprd08.prod.outlook.com
 (2603:10a6:802:15::36) To DBAPR08MB5830.eurprd08.prod.outlook.com
 (2603:10a6:10:1a7::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBAPR08MB5830:EE_|AS2PR08MB10109:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a0a2a64-96cc-4ce1-4638-08dbe15043c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rRhnb4DqaM9NiRyNRBH6Q9U42FdHdbYBCLERoS6IJA3lkaXT34HSKIvGYwbwU/pOJuB6iyQW1LSm7fi48F4IAqHHHfD0Sgm9zNeK+VDmK/wj+cZjAtNCLRu8Xgux5mXnCRcGq71Po4ksMmMB0+KywoObFvuBSAgqTCbQvj1h4xZ0uOhOHsXk9i1gWXOU5ulNyetKbDpM6krinldw2sBxmpL088gMg1n9ybGtFdH6L6SFPnjqlNm5MRLbng5ekJ6E/2F2STPCuL4eRrWcuoBZU0wy/ei954FLLxH6HFusfW65XGGSIvEYVL4PMBUjhlXWRv8duLKYAe0mlsaB6u3xEpNB3VdbZGF1DA3U61Ltxk2s/qqxTZ4zRj2MlYOUDSTu+a9JllUdKEzkt4jUOas5ZmmN09RLvH12XFL0A4DQVbhiMKrDC7bFOj9R+QLa/Eh7vmCm3ewInObu68jo6TFHI5/GMVDUMs/GcemxvJ5AhTwgDjij0mPW4L5w3nMfiKIYw7nAsq7vcpZwqcMB0kauRj11ZUWDSKuI2dRIqhOjOTLWBhtkvbOs1YmQkzv9FUvK0+Hy2I9gNhrAh5ozqytcYntxPa9RWsLlI2kJpK9XANNrYs4YCCyiQoyQO65x4QW3+ZRFbmr6VIYLgAAI6B7lyg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5830.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(346002)(39850400004)(376002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(36756003)(4326008)(8676002)(5660300002)(83380400001)(8936002)(66476007)(316002)(110136005)(66556008)(54906003)(26005)(2906002)(66946007)(2616005)(6512007)(41300700001)(478600001)(6506007)(53546011)(6486002)(6666004)(7416002)(107886003)(31686004)(38100700002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTFGS05XSkdyYThzUXRBOG9qL1QraWdTem9QSEo3WEFCRWxlUjBKaFdWR0Fq?=
 =?utf-8?B?djkrZ3J0eUxVcVgrb2R5cW5XNVE1WU5PSWo5aWx6cklzZnZ1NHRmU3kySDlr?=
 =?utf-8?B?UURidEhMTXJuTkxXOEhRMXNkeU9BczVtUU1PeEFCa2Z1NUdxeVZ3aStWVTRO?=
 =?utf-8?B?eGhMTXlDbVo2MXB5US9kT1RPdDV6YS96M3FuQnR6bzNZU2JlWSt0ZFBXNVBP?=
 =?utf-8?B?SGtUcVZaN01oMDZhN0JnWkFlWGNzMFg2TEw5UW10b2NsNFVEOExwb2h3NG1w?=
 =?utf-8?B?cXU0a25MVkd2a2I5ek1wUmVNNVNNenNDMncydFpOZEIrRFhieU5KOFBXRFcx?=
 =?utf-8?B?SVJkWE1Ib1lxUGVSc2N5Y3h5b3JYZnlIVEVxbHBVZVVXZmd1TWNDWFJ2eEJV?=
 =?utf-8?B?YmNzUHNicXM5TTY0RWg4Y0VCSEdCSmM4TElmdGhEdVVnTkh6OUl0TzQ4Q0wv?=
 =?utf-8?B?YjJaOHpZQURJcjlRWkhSLzZxUDVBQm9UdURnRndsanRzL2JJNkM4bVdna1R3?=
 =?utf-8?B?VUljOGFtbzRMYzh4cm01RGJ5L0k5THpIMUJjOU8rVjRIT0hWWWY3OU9ZamY0?=
 =?utf-8?B?cVNlZ3I2TUhNMzRDenFsZlVjVlRQSWdSWE1EZW5kS2J6T2VpYTdMdERlNllW?=
 =?utf-8?B?MzdKZjJWV0hlUEZPL2ZRODlHQnpheXJFSngzSjdqa2JpbDd5aGJKdFZtNzZO?=
 =?utf-8?B?S1M3bGJ2ZWd3SGR1TDRlVDY0eTE0dW00Y0x1ME94Y1J5MHBnbURqcEcyZEV2?=
 =?utf-8?B?clNwVFRyanFoSDltLzFkRWhQUTJIRlQ3S1o2aDlvd1ZJcDFuR3UyL3JoeGFs?=
 =?utf-8?B?SUxWdHoxTzVCS1ZGTTd2K0QvZGxEZVRHNXc0dUU4MDFuQWVYc2tDcWZpdnZx?=
 =?utf-8?B?YmtJeGdkcmRSdHYxMURubGdpUGhnazR6Q2J2bGduNkVvVnNjMmRmR2UrSi9w?=
 =?utf-8?B?QmxudDRTWmhDRmQ4RVhjR1BrbkdoUGZOVzEvVzZkMFR2blVwcGRQdHpSRjlU?=
 =?utf-8?B?MUlxK2lQQkdjeFVuWjZLZjFVcDN4UnliUFlGMzd0SmFBSTdvWDNRaW1DNzNi?=
 =?utf-8?B?UzlvQ2U2aEp5aGV1bkFEMnFObnZOZnp3azdTbXlEZkNLRGtLUjJKOWxVQU8w?=
 =?utf-8?B?MTZXcjM2OUYvTlpWVkhEUFJEcWd0STUzNzVCMnZ1S3lveVVwZHdvRXFQMUtU?=
 =?utf-8?B?cDJLYUtsRnpjc0JvME45a05YZk1rS1pTTVEvNHdVaVZkZHpLYUdja29CMWJH?=
 =?utf-8?B?Rm5SR05zKy94Q2lYaHJHRzQxeEZVQjZON1VvcVp1dnZ2RkF2ZG9ucWNvNE5h?=
 =?utf-8?B?Z0VoLzJWeFVtTDZzM2p2WW9sdnlLakRjeVVydWc0VGhEOGEwRmxna2lEWE8r?=
 =?utf-8?B?WW9xK0ZlTVBoUHAweUNqcjMrdFE4MUR1bGNRTGQzblRZVnFyby9NL1V2ajZX?=
 =?utf-8?B?VVVhQmlML2hRMjFNQkRvUHJDeHZkQ1JWem1rWlhoR1JzZ05lR2xtTzFSNVNL?=
 =?utf-8?B?Snc5SE1Ea1BCQlYrdjE0QjZIemhnNlFXeVVOQXFFNXRFNXQ3eTRPMFFvSS9G?=
 =?utf-8?B?R0ljR1lyRlRzK3l4dmxTUDFXMEZMWnVCOE9pNHVKMEFDb0M0RXhJbDlnRUZD?=
 =?utf-8?B?V28zcTBnbktZbmt0SzBZYTJ0WlFMUVNvVVhsaUV1TmVLcklDRFBadjJhZS9l?=
 =?utf-8?B?MGhsTXBqUi9IRVNpVERRYUpUUk1PcTRHdFpYbERqSUNod2tlY1VEcDBKUTYr?=
 =?utf-8?B?MUpDNDg5LytlZ2RGUExzeHkrakdSdnpyWFBoUmV2S3czQlhaSGNITXo3NDRQ?=
 =?utf-8?B?QVBnYzlHZ2lvRnRrdlZUaUxOZ1RZMFlOMUNHbmtDU2hQLzJLdEZLb2p0Y2x3?=
 =?utf-8?B?TmErU0toSXlNbGdoak1KTVNpVzM1cEl0T0wyRUVSQTljN1JwY3NMZ1doRXZQ?=
 =?utf-8?B?dThIVkJHem5qT0xlMDNLM2xNWm0yNlpOK2lnNVRSWnVBcVNPK3djMDZsOS9V?=
 =?utf-8?B?d3pPMW42dGtoRzQweEJTM2s0OWlxV2hCcXpBTTZWTWoxQnFIRnArZmkxbG96?=
 =?utf-8?B?T280MXFpL1VsRWV3TVhuRkJiU0lEaXZoTlE0S0FjNDgzamNZdE5Cbm9qN21E?=
 =?utf-8?B?YnNxUjU1bmorY3Qwd1hicTN6c0s4RnBlRUx5amd6Tis2RkN0TjQ5b2djWEhG?=
 =?utf-8?B?OGc9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0a2a64-96cc-4ce1-4638-08dbe15043c2
X-MS-Exchange-CrossTenant-AuthSource: DBAPR08MB5830.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2023 18:18:25.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F8+JVlnGbRojKs4ppmcmAP1/JZU42ADYGiRPpgFL+7fS1vqPoT6dM3iJzJssefQi/h5vekVnAO7ogOFLwQvXqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10109

Hi All,

as a followup for my patch: i have noticed that
currently Intel kernel code provides an ability to detect if PMU is totally disabled for a VM
(pmu->version == 0 in this case), but for AMD code pmu->version is never 0,
no matter if PMU is enabled or disabled for a VM (i mean <pmu state='off'/> in the VM config which 
results in "-cpu pmu=off" qemu option).

So the question is - is it possible to enhance the code for AMD to also honor PMU VM setting or it is 
impossible by design?

i can try implementing this, but need a direction.

Thank you in advance.

--
Best regards,

Konstantin Khorenko,
Virtuozzo Linux Kernel Team

On 09.11.2023 19:06, Konstantin Khorenko wrote:
> We have detected significant performance drop of our atomic test which
> checks the rate of CPUID instructions rate inside an L1 VM on an AMD
> node.
> 
> Investigation led to 2 mainstream patches which have introduced extra
> events accounting:
> 
>     018d70ffcfec ("KVM: x86: Update vPMCs when retiring branch instructions")
>     9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> 
> And on an AMD Zen 3 CPU that resulted in immediate 43% drop in the CPUID
> rate.
> 
> Checking latest mainsteam kernel the performance difference is much less
> but still quite noticeable: 13.4% and shows up on AMD CPUs only.
> 
> Looks like iteration over all PMCs in kvm_pmu_trigger_event() is cheap
> on Intel and expensive on AMD CPUs.
> 
> So the idea behind this patch is to skip iterations over PMCs at all in
> case PMU is disabled for a VM completely or PMU is enabled for a VM, but
> there are no active PMCs at all.
> 
> Unfortunately
>   * current kernel code does not differentiate if PMU is globally enabled
>     for a VM or not (pmu->version is always 1)
>   * AMD CPUs older than Zen 4 do not support PMU v2 and thus efficient
>     check for enabled PMCs is not possible
> 
> => the patch speeds up vmexit for AMD Zen 4 CPUs only, this is sad.
>     but the patch does not hurt other CPUs - and this is fortunate!
> 
> i have no access to a node with AMD Zen 4 CPU, so i had to test on
> AMD Zen 3 CPU and i hope my expectations are right for AMD Zen 4.
> 
> i would appreciate if anyone perform the test of a real AMD Zen 4 node.
> 
> AMD performance results:
> CPU: AMD Zen 3 (three!): AMD EPYC 7443P 24-Core Processor
> 
>   * The test binary is run inside an AlmaLinux 9 VM with their stock kernel
>     5.14.0-284.11.1.el9_2.x86_64.
>   * Test binary checks the CPUID instractions rate (instructions per sec).
>   * Default VM config (PMU is off, pmu->version is reported as 1).
>   * The Host runs the kernel under test.
> 
>   # for i in 1 2 3 4 5 ; do ./at_cpu_cpuid.pub ; done | \
>     awk -e '{print $4;}' | \
>     cut -f1 --delimiter='.' | \
>     ./avg.sh
> 
> Measurements:
> 1. Host runs stock latest mainstream kernel commit 305230142ae0.
> 2. Host runs same mainstream kernel + current patch.
> 3. Host runs same mainstream kernel + current patch + force
>     guest_pmu_is_enabled() to always return "false" using following change:
> 
>     -       if (pmu->version >= 2 && !(pmu->global_ctrl & ~pmu->global_ctrl_mask))
>     +       if (pmu->version == 1 && !(pmu->global_ctrl & ~pmu->global_ctrl_mask))
> 
>     -----------------------------------------
>     | Kernels       | CPUID rate            |
>     -----------------------------------------
>     | 1.            | 1360250               |
>     | 2.            | 1365536 (+ 0.4%)      |
>     | 3.            | 1541850 (+13.4%)      |
>     -----------------------------------------
> 
> Measurement (2) gives some fluctuation, the performance is not increased
> because the test was done on a Zen 3 CPU, so we are unable to use fast
> check for active PMCs.
> Measurement (3) shows expected performance boost on a Zen 4 CPU under
> the same test.
> 
> The test used:
> # cat at_cpu_cpuid.pub.cpp
> /*
>   * The test executes CPUID instruction in a loop and reports the calls rate.
>   */
> 
> #include <stdio.h>
> #include <time.h>
> 
> /* #define CPUID_EAX            0x80000002 */
> #define CPUID_EAX               0x29a
> #define CPUID_ECX               0
> 
> #define TEST_EXEC_SECS          30      // in seconds
> #define LOOPS_APPROX_RATE       1000000
> 
> static inline void cpuid(unsigned int _eax, unsigned int _ecx)
> {
>          unsigned int regs[4] = {_eax, 0, _ecx, 0};
> 
>          asm __volatile__(
>                  "cpuid"
>                  : "=a" (regs[0]), "=b" (regs[1]), "=c" (regs[2]), "=d" (regs[3])
>                  :  "0" (regs[0]),  "1" (regs[1]),  "2" (regs[2]),  "3" (regs[3])
>                  : "memory");
> }
> 
> double cpuid_rate_loops(int loops_num)
> {
>          int i;
>          clock_t start_time, end_time;
>          double spent_time, rate;
> 
>          start_time = clock();
> 
>          for (i = 0; i < loops_num; i++)
>                  cpuid((unsigned int)CPUID_EAX, (unsigned int)CPUID_ECX);
> 
>          end_time = clock();
>          spent_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
> 
>          rate = (double)loops_num / spent_time;
> 
>          return rate;
> }
> 
> int main(int argc, char* argv[])
> {
>          double approx_rate, rate;
>          int loops;
> 
>          /* First we detect approximate CPUIDs rate. */
>          approx_rate = cpuid_rate_loops(LOOPS_APPROX_RATE);
> 
>          /*
>           * How many loops there should be in order to run the test for
>           * TEST_EXEC_SECS seconds?
>           */
>          loops = (int)(approx_rate * TEST_EXEC_SECS);
> 
>          /* Get the precise instructions rate. */
>          rate = cpuid_rate_loops(loops);
> 
>          printf( "CPUID instructions rate: %f instructions/second\n", rate);
> 
>          return 0;
> }
> 
> Konstantin Khorenko (1):
>    KVM: x86/vPMU: Check PMU is enabled for vCPU before searching for PMC
> 
>   arch/x86/kvm/pmu.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
> 

