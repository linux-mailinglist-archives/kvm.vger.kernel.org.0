Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B58F67956E
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 11:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbjAXKiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 05:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjAXKig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 05:38:36 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2072.outbound.protection.outlook.com [40.107.212.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B3D442E4;
        Tue, 24 Jan 2023 02:38:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnMDJ3Xe9SEjMBRszIZViXjwbufmtrjV1ft8HNFngihwfnWQrVfRlzAMHv9cotnvxB0O9rpQc4xXf8jhskQeSnrrfYWcVYMaGmKvo52L8NG+zkyJgwElctbzuH5JuODhnVE29fzRP0VIZlTITyJs2TeKjtWymUNelt3OEbRovQwbB49SDQLxMKkJy3ntyQkXP+m170iiTnwzWqFhvCz2XmovFJLPEQ2nVkENcfyeuaRxKH+TuOEyhBqZGXzsK4tuO2WCQqxqRSVyxs8vPHt/p9HtSePefY3blYZMt1BrVrjjvyw4y1vheUfBPKVviH4omDpImimHsgfRVUW/Z+P7VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJl+CqeTHqG9HqrxeIm8oCMwHLFgXI/3Jjfpbt6NEGU=;
 b=kqzfFwy9arHSV8A7E0e14UKO6cPMFjpklzYhofcR5/av+VED8gWX/KXZOV0k8P7Wdy8YX6FXSQiJHApXjeJ0T82K1IThnnu9+oEu0tW8L8dILSgP/i9y7+P4+dvLx//g8nnbNKWALsinBu+qnvovYey4oE8SC+wUdDi9+gpEtLhEAed/au2wbGwRjDX1O2PJ/IVo9GqVcdC/0+yd3aa/0k3fUXB53C2R812LHVNUHtYdJEfxn/FgOBFLMqaMp7q/VwHNq1sM+cke6Cj+zccGLedAYgfO17RzF7EvZZq7qiSL9kZGtk2ANkQbKj84kU2/8Xc0KB0/jlbSi6yTW0Q3zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJl+CqeTHqG9HqrxeIm8oCMwHLFgXI/3Jjfpbt6NEGU=;
 b=zjjPAgAe+t1ARLoYdbLVYrzj+0fAdqmCxUj2JvCmuhzyj9aestvkpHb9Shelr2m0Min541wdLX+Fpz+wE9T0G8kL0WbhnZgSS+6fTb4+0cQez2UAI9FqFlros8lW1kETCB9yTJoOHcwL6PDmKo6hvyN+YkyOP42GQbJE42NzdWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH8PR12MB7255.namprd12.prod.outlook.com (2603:10b6:510:224::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 10:38:09 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%8]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 10:38:08 +0000
Message-ID: <b30d6f61-2dc9-4c4f-dbdb-a48c186745d3@amd.com>
Date:   Tue, 24 Jan 2023 16:07:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH kernel v3 3/3] x86/sev: Do not handle #VC for DR7
 read/write
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20230120031047.628097-1-aik@amd.com>
 <20230120031047.628097-4-aik@amd.com>
 <adc11ed3-de89-a389-e629-3c951257469c@amd.com>
 <533c5c83-b68b-eff0-d36d-9963194ab844@amd.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <533c5c83-b68b-eff0-d36d-9963194ab844@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0210.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH8PR12MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: 06b330d3-6bdd-4cb5-dbb0-08dafdf7152d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eYFrj2kEdQqwFDvEMSYwRtOCeucK1ZQUvnyjbyzQl3m+oe/sGuB3ZxMvr+qGO3iqfPIxVYpyGHDWo9RSkRjiU+mly8467X6e7cJm+vMZav88dSlDmIIVmzeOG0d32MsxQ2geqYtHZL3gIosepf6t1f/0S4hRs92NiYtO4iblRcAoQNIE5sBytoMSl1xk2bGkMFguY3renneOK8WjPxRh79sI2G4GduKevGXpiClgA/zHEgaAduiNGHGliiEc4D9ZlG4VYmgkR9/OsOg2qZ/GHZKif1tFXzdD3iNpjW9Kf9Q1h2bFb95eIrLtee/D8gNyORQxezRFxff+9OgCcZ9ktucKKRngVUgOToXnvGbQ5xit0bUdDQ+aPZ0lryz1Fjor9eLRaaxZ7NKlccBsVB6uCGo/heh/eC5F+C2R3dwa9qX1dMfq9DrtrupfA6QXkY3Xn+sYN61RRmSbzuo4vALP6Dj4W8t8nTUoGInZzq+5SnB9BnSRKedv+y7Qp7q7TdYNVWOlREWDxOJKaEN6QL/jdOm5qj4UAEyjqzgh5u8+J3YBJvMG99ERE/LppG+B0eXKDdH7qndLqogsjYz5aSL8MiTdHyMZSzuNFHrrc4NpwpIqizTwWs1UUfcc4lSRv98UrV4TvgFd7iLr3Q+lbUR7iGRYTrkY/cTEL73G38U2kfv/9nlRB4CqqEJWNbj1ghMnd59YVOl6tte3lPTVVBoNMyUePwx+64+4dWUfKb+NY4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199015)(31686004)(2616005)(478600001)(2906002)(31696002)(41300700001)(38100700002)(6862004)(5660300002)(4744005)(7416002)(8936002)(66476007)(66946007)(4326008)(8676002)(36756003)(66556008)(54906003)(186003)(6512007)(26005)(6636002)(316002)(37006003)(6486002)(83380400001)(6506007)(6666004)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEszTnh6MUppc1F6N3NmVUhUQ2RmUkRNVUE2b3VjbGZoNGQrZXViRlhGV2g3?=
 =?utf-8?B?bzZBQ3RnejlzQ0FocU9kVmZXRStHVHFkU3ltaXNhMFBFWUtaS0FGWWRicXlT?=
 =?utf-8?B?bWFFb3JXcDJWMTVoK0VSZFo0WDJOaWVrOXFQdmtVOXhva1Zxa2ZyV2lmMlF3?=
 =?utf-8?B?SFIwQjVyQzY2VFMwZU1nZUxvRms0WUxGQ2hUaXpsbHRFcTJhekhpOGxsUEsv?=
 =?utf-8?B?Z1pIVWtxYVVCUFZ0R2M0MEkyc09nckdjT1Q5a3Y0R2tZOTZpUzFBY3VQUHpp?=
 =?utf-8?B?OTlMcDA5a0gyeDdzOVZpUFJVNmJjZGdvZXZIak5kc0lDTWl1c3dpMzN0T1Ux?=
 =?utf-8?B?b0k3Q3BxQUlNcjFGR29HYVVmQmZaTUlYZ0xrUm1hMnhwalRMM3FnQWNzMVJG?=
 =?utf-8?B?cVJHeTl1SDAxN1NOcXNuZVR3SUVycnd2cjFjNlhLWnRpVWdmUFlYVFZkb3Fj?=
 =?utf-8?B?ME9IU05Fc3pCa3Y4clAxY2xscXhwN3FWS2hyR0FBbE8weFI2cGwzQnFnVkpn?=
 =?utf-8?B?WWZiMnAwbzYwaUo1d1hVRlZTckhWT0JHdUppcFFyc1NKSjVHMUZYS3hua2Q0?=
 =?utf-8?B?N3c1akszSFYrcUZoQTA0NmZMeGxFck5rcjdqUFF2bkFYbVZlR200SnI3K3ho?=
 =?utf-8?B?YkljRlpYN1hLbktQMUFFZnpJNG5JbXF4eEJoMVZ2cHlZWE9TOWgwaXBLN2hR?=
 =?utf-8?B?cmFlK1JKQ2N5MXV5WHVrbXZXUWREeXVYbkozczRzaHUwMW9JM2s4Wkc2K1hh?=
 =?utf-8?B?dUVQTUlsa3ZtejlYeTdGZVBLdVJnRjZXRTFnRjl2eEo0ejA5ZTJ2d2VRMnJw?=
 =?utf-8?B?YjAxOHZmakRDaVl2SmY5YWg3ZW4vU0xxTnJsS29ZRTl4bGRGVEFHSngyakpU?=
 =?utf-8?B?WmwrSjJDbWpVS2xGMFNoSlVub0ZDWG9DSFN0U2kvcVlWZVc4TGlXQ1dwMXFl?=
 =?utf-8?B?TGF0ZXl1TEUra1puRkVQdWk2djdRcmpuM3d4aWJRaDdKdnEzWllkMnhJQ2tm?=
 =?utf-8?B?VFpYY093U3crSW1GbmpGUGQ4YWVJTzE3NWI3ZGdrZzg0NElTWGRSSFNKV3Jk?=
 =?utf-8?B?OTBOMGEzWERuNU1JVmZuRlVReXg3WnJJQlJWTm4xdEJUVkxBS25WenRhaVhW?=
 =?utf-8?B?SE84bjdrL2VRK3NFaVB3dmNsMUU4QTFlTnpObTM5Rmc4ZG9kUkF5RmhaUkd5?=
 =?utf-8?B?L2JxWnNqemM5WHpMZE0wdDRka3I3UlIvajNmcFBERFk1dkhjWWxyUFc1T3gw?=
 =?utf-8?B?dHhMd2svOCttTXVIaVVVS1h3UzhtdUY2cXg3OHNvaW9ZRGZuL0NueXN5azNN?=
 =?utf-8?B?UFRoZGJaSCtBWUZEdWROOVk5aUdhQ0lnVmNhR0V5anplT04vR3E5VjY1WTRO?=
 =?utf-8?B?UHRKbUdEMlFDQU9rU29iMWNLUGlxUEwvT1pVOURoekZZdlgwU1RqS21oUGpN?=
 =?utf-8?B?SVdlb2hoZkNGTFVRMjJqV2xsQlpaWUNhT0I3K3JBcGs3ZmVLYXB3bllJL0dN?=
 =?utf-8?B?RHV4UHc1SEcvNTRkcTRxRmMzby9vaGdablR6MWFhaEJLTzM0bnRERHkrMHlH?=
 =?utf-8?B?T25TRVcyUDNrc1F6N3FCcTNNMC9FcEZOUS8xTUZJM1lDdVVab2dod3Y1NkJZ?=
 =?utf-8?B?SmZ0SXR0WldzN29DeFlNWkF4aCtZSG1OSHBLRlp5amMzMUkrbDByUmlXL1Bl?=
 =?utf-8?B?TkZuT0ZCQ2s0OS9ETzhsbU1kcjZLZUQvSFM5WUx4SzVzWVRqUHFtcFRWbzVz?=
 =?utf-8?B?R2doTGRKd2tvUUhFbkZWcnN1L3VKUDJqZ3RnMUYwaDlzYWtqTmtjanhEakdS?=
 =?utf-8?B?YUEvTk95VDVQdG9nRmVkZWo2MGNneldTdFhZZUU3M0NRM3ZVNU9IeFgzZjFV?=
 =?utf-8?B?ampGY3crc3hnMjJ6eGc4K2ZDaGNVNyticTIrc3BmUTQ3RVVPMlBWOW5iMzls?=
 =?utf-8?B?MU1VaUY2OWxrYU9qQWk2cExmTzhJWTZ3eG93a0tFTGxiZnd3clNxT1M5S3hx?=
 =?utf-8?B?MUNpbjdEMEljU25JNDRjeFkzbW12VytSQWhqcGJQVldhL1liOWxMMXp5b3RK?=
 =?utf-8?B?REZsWFE3YWJQYmF1V0xvNjViU00xci95U3I3Um9QUllKR3NyUFVrcVFqWmtV?=
 =?utf-8?Q?1IdiFm2LOwmhE5P8GFX2Rxzze?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b330d3-6bdd-4cb5-dbb0-08dafdf7152d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 10:38:08.6337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8e1UTBhYJMudd//Z5RVx+mVkYdrXrs81T8rk66rOEEo/jtB2saRD4N9kyh+FjQttragKDSVpQPhIJXwkIadL7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7255
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/01/23 15:53, Alexey Kardashevskiy wrote:
> It is MSR_AMD64_SEV_DEBUG_SWAP (SEV, not SNP), it is an SEV-ES thing. 

Yes, noticed that, earlier analysis was that Debug Swap shouldn't need any guest side changes, but it does need it.

> Why is that feature negotiation SNP-only and not SEV?

As per the spec, GHCB termination request: reason code: 0x2 is SNP features specific.

Regards
Nikunj

