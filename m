Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1235E4F9895
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 16:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbiDHOvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 10:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237187AbiDHOvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 10:51:38 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AB0107826;
        Fri,  8 Apr 2022 07:49:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JauatyvO64xM4M7P37DfjmZdpJH/4qimPVVTLBEroNJshKH+H1kpr5Yf3ufDTJs+s3Ho7QEEi4O5fpwOYQ7TXocEtC+XY3TTZUaejEmbWYaqA68xihu78x7jqIAWWpS6hV64ff4lMWoZIz1e7jMNm3ViFKVB10xZllYPTosU3II92kbqj/6owJUwtAGYkeTzBIdMZCLYjqmwa5jR1/7YEH7VjtRgswPYTdZcZIQRbgQbT2noa/Hg4tl/teg5ODxAplmnPsZ6ezREs/2MGiqZxgzdRgdb/tfvPw1KbB2wg/1XQCpl/loT2ruPWlzOZDa18FXPCqL7S6vnQjdS8t7jww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrQrHBFZGlE44WLa9SqAGjHSXQc2twWUzQVRdPC8+FI=;
 b=nvcbYwz/oBw7FhkneZ1giEowdxBqO2zuUx72WMfgRnZoAdt5Zn9HIQySZc2zvNyjEait7Vtr5tlyMw/txW05mXdYZjEEcauMx3dcMLFSukK1IQvY4FrTnHKWm+3s0KpxXXWVEscV+n4ElSjNN+nvzOjJOk3LMk1W81u20qovzOSBt8SmCB15AtfqK9BxvhdvVo1YAKBEBc1hd5ubFO4hIhAv351iqFywkQDm621FpxEtwTJlgGBbHXils38q+LOaaHFaLCpvwYZhy1TVjSlTlsEyF6PExUYHvfPn8MRLyKBT1ruox6E1WbEjra6qvG0iSWsHZxyjRHihb+wg1SEvyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrQrHBFZGlE44WLa9SqAGjHSXQc2twWUzQVRdPC8+FI=;
 b=ZALLKYFQRnzd46zBA9+759VckS5A9uvzvxnhYNSx4op9zQVnoVLySN69hf4A7EQw8apge8XiLohajcFHk8NDIzWat/W7SapnqKmn/FOQzvk8n58FL8ktPvZ45e+IANZhfPOQlHnZe86NJSQA9+7ifEB91ilKo+MsvjJEZIixx3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by BL0PR12MB4690.namprd12.prod.outlook.com (2603:10b6:208:8e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 14:49:32 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::f8a9:fac5:1a6c:dba7]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::f8a9:fac5:1a6c:dba7%9]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 14:49:32 +0000
Message-ID: <ea5dfc33-6bff-27c0-3f10-b31812f1cc52@amd.com>
Date:   Fri, 8 Apr 2022 09:49:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH 1/2] x86/cpufeatures: Add virtual TSC_AUX feature bit
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        wanpengli@tencent.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
References: <164937947020.1047063.14919887750944564032.stgit@bmoger-ubuntu>
 <Yk/5kIlcAuW/RuDj@zn.tnic>
From:   "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <Yk/5kIlcAuW/RuDj@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0085.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::30) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76e329a3-143d-4e6d-8354-08da196efd89
X-MS-TrafficTypeDiagnostic: BL0PR12MB4690:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB469065CD9167869706F412EF95E99@BL0PR12MB4690.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLbibL2KfwrchWLE0zRQ/0fhYderRkGyfptSMYX/MgmlwWahksWGDQDcumqCiK3d1c2Qg8sFJc9e1iF5XzQJywmv/lakkXGPStQ0nbZgl/Uoy2GUo5EudpMJ7M2AJyUy1mKC+KpxH4zJKYZCwC8x8hjmgsGtWOPCs7HfJ7owPGPk9jLcHQGldMBIrewC5AbXxeoQNRzZ3uXjw98Z4HWZMI32GdKeTLb94ZCjKKZSuTrAhvRcbjGuaSU5tI9prrATy9UmGZCYJ+W72UjkZ2iDHuEX0gmW3yORjro9vAtv4s3NAErZ4Q+ElHKsrg6k8SUduzJkqJqLY+XoZ5Q0qmaKDtjgPQVI2iCJeovV+yTM7VEQ8565YRz88c3QuS3FZnIS3Ttz/axxtOh2EBtMMXFTqinB2DLyJauki0wyy15btUaON0xfHEGuKINp8uknUNb6qz0uC92ODrJcpIc56yR0f4vDv/9NEpDbb/LQl6xXO2VbtIZzAWtnvS7CnvvexJ4a2JTEaIdxle3OwNgzybl8VkbLRdIK4BCERkcgxccl4XdJdOQ8GZ9bNCRSk34cseyh2bVg99PVdKSFFi1CZufTW3btxKg1G6VWzHiDc7kBqCDKfblAmBLk3hAiNREk4Sr5+gf9vlL9tm8d52jhmG2RZYpVU7XWM3d/OnUZ/oFe9NIQ/LzIvjd3BdFOeeD9keJS6ETGoSZS0F3f8GrNQmidUVhKVtacqkkhVN1YIZ/IcJQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(31686004)(4744005)(5660300002)(316002)(6666004)(83380400001)(36756003)(6916009)(2616005)(6506007)(6512007)(3450700001)(53546011)(66476007)(4326008)(66556008)(8676002)(2906002)(66946007)(8936002)(6486002)(86362001)(508600001)(26005)(186003)(31696002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UG5GVmRacmViWHR3b1gzajJ3dFRjc2JyNnZFMzZ6RG5LUStLa0haMTJoRDFl?=
 =?utf-8?B?S1YrbG1jbS9LcVhBS3FqajJray8zaHpjOS8wOTY0NGdoTndKbVBBQ1RtdFJV?=
 =?utf-8?B?TGxsbmNUOGlPUFNucGtXdGUvb3ZzV25XS3FvaEd4dDJqeklzbG9aRkxSUjYv?=
 =?utf-8?B?cy9PMFNYblU5aFVzR09WeVA2b1Z6TnFSeUVEYU1xa2dFV3JSd3U1MFFkNjE4?=
 =?utf-8?B?RG1kZy9STmVsSEdZZXErSUFmSXR6ekgxMHEzOGhwbWxYY05QR0VEelY2Z3R6?=
 =?utf-8?B?QmFPVyt2dTh2OXF5UXBWdmpEZTFRcmNYaFV6YnZLSVdXSEFGNUZaMFRwZUln?=
 =?utf-8?B?RDcwNU9UOFdrTFM4Z29IWDdEaU9zM1FzSFlKUG9lRUxTY0RWaVJCN3lFSXp5?=
 =?utf-8?B?WkMxNVA4UmNERzd3ZW82cHJiUDk0b3p4NnQ1aVNJWkppdEVlOFQ4SHZoSTB1?=
 =?utf-8?B?VFcvZUFIM2N0dEtpTVBmTUorRE1IRVYydTF0b3JHMmdjNjlXR1l3SjR6MjNm?=
 =?utf-8?B?dEVLM1JkMXJJa3ZLb2FTNS9jMXIrR1NSTFJ1aFk0VGtiRExMNm44a1Y0Uk5P?=
 =?utf-8?B?T1dpUWcyZHZNQ0JidnZXc2NDZFpVVWxTbzhOc2d6d2ZPV0tZQ09WL09TRURY?=
 =?utf-8?B?OHNkaFFDSm4xcmliMm9OdFZPMCtSL2tIQXVscE1oRkErSDNTVThJMjh1d3Q3?=
 =?utf-8?B?L2p1TUtNNzZlc0FYdE9XUXN6a2FLdkxXTlZLb0VPbldmTmFMS3lNeHhWK2pP?=
 =?utf-8?B?YS9TL0R4YjNKTmNjNXZicjZRUG5Gbll2Q2NOUGw3eUdwMTNhakV3ckd0aWRK?=
 =?utf-8?B?c2VsV1RlZ0N4akVsWWNMbUlHZDFEQlEyRDh5TDVtQzlQVlFoZnRTMUZhaXpu?=
 =?utf-8?B?QXA4NkFlT0JiZytaUFNweW1PTkVlZTQyem9mckUweVlhemlIV29XRDhzRVdJ?=
 =?utf-8?B?MlZWS0lJZXU2ZkVIRWxTS1FxVmlla3hKOHFjWUpyZ25lTWtKZCs1bW5RRGQ2?=
 =?utf-8?B?Rkh2dnZFcTF5Y1pZZWdOM3pxTjhENXpKRjNPKzkwSmduTEV4UzRGckFVNDlu?=
 =?utf-8?B?K2JWY2ZTY1dLalNlSlBUcGdwbE92N25wMmVoVFdWQldkK2FGVWxiZnVXQkdU?=
 =?utf-8?B?Q21qOXAramJKZFFYN2o0Y2xHR0xaeUdZdU05L25yOEZsL0tabGo0NnNFeHBk?=
 =?utf-8?B?UExuYVRFU1ZucWJyUmIwdTYxazIreVU1dzV2S21oa0V0L1NmQnFySDVzSStn?=
 =?utf-8?B?REMrdGFtSzNTS21GTlhYLzZwd1grR0puaTUrRE5kU2s5a0JVOU1YdVpDV2ND?=
 =?utf-8?B?NDZoemNSSm05dHJpSmFLN01yWUZ3T0pDeVlOdDlha081VDR4TE5Qb045ZzFx?=
 =?utf-8?B?ME1XdDR5VGhIR3l6YXBEQXJaVmlpOUxkNExXV1hJOU1DWVpkVkZla2JrN1Fw?=
 =?utf-8?B?MVdERDZqNWE3bnRqUVRSZkd5c0pxLzBURWtqZSsrejlVbzhNbzNDcXdoMXBk?=
 =?utf-8?B?Qk93WHJrM2ppWjBvb1Vhd2VGK1RWVnhZV1NLRkFOSjBFNWVZY3NOT1NlYnIw?=
 =?utf-8?B?SnpQcFNrT3NiTURDcHhxK0NpMVhpclJxZm5FOGhacGt0RWMwS3dYY2tGVzVO?=
 =?utf-8?B?SWsrdlcwZ2Y2ejRJM1E1QUpDcFZpWlcvdENsTmtFNUVZelJKV205bnEyV205?=
 =?utf-8?B?UDhKYnRFa1NmZjVuVjBZSW9PTTkzZ0o0VDZMUkRaSUJNWTc1SFpzZE1PQzZv?=
 =?utf-8?B?Q2VDZlhmRlYreEVpcXlKWHlnbHA5Y0FCYlNaRUR0VHhuem5yZGtmeWg3VGti?=
 =?utf-8?B?MlJYT1V1ZWxZeTdlMlJCZDZqQmJLZHFIV3IwWlhTemVtck5KS1lMa3hJbGN3?=
 =?utf-8?B?TTVTdjdqSzJBTm1RQlI4YW1keFZuRjd6dGZ4Q3JQSnZmaDRDZFEyM2FGOWNz?=
 =?utf-8?B?SC9EblpyNkgrMzZjRmJBWlRESG9McUlPMFlZeWNZcWdQb3U2WUM4THdhaHFB?=
 =?utf-8?B?WkpEL041MlhQT2VNdllKRjFGNWk5NDVTMGYzbEY4OE1KR2dVQ1NFd00rSUF2?=
 =?utf-8?B?Z0xBWjhzZzhPdDh2Z1g1VlI0YXIwbnRMemF6TElJdGErOWJoMGVIeTZseWJM?=
 =?utf-8?B?WUEzRk9yQk1rbk9MdDNlUmgvY25UWVQ2bytMSDVkK0xUMkVXRVNJeHJtQ25I?=
 =?utf-8?B?K3QzQXcyMmppWkx1RVVVSkRLSXIxZUliYjVXYmh2RW1NQlVNZmRlSEJBVDNa?=
 =?utf-8?B?R1RkRktaaExFa0N5TVYvSkswS0dqLzh4TkVhVG14ZElHNU1LdWRoVFdCZUVh?=
 =?utf-8?Q?mfXhsmrnIK0MIBJP8Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e329a3-143d-4e6d-8354-08da196efd89
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 14:49:31.9122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bJSoGjVuf7FLgdflbuPo2HWRtKuFNc7lnIni8imEei3/HRX0YL4avtEUNRuN2Vh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4690
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/8/22 04:00, Borislav Petkov wrote:
> On Thu, Apr 07, 2022 at 07:57:50PM -0500, Babu Moger wrote:
>> The TSC_AUX Virtualization feature allows AMD SEV-ES guests to securely use
>> TSC_AUX (auxiliary time stamp counter data) MSR in RDTSCP and RDPID
>> instructions.
>>
>> The TSC_AUX MSR is typically initialized to APIC ID or another unique
>> identifier so that software can quickly associate returned TSC value
>> with the logical processor.
>>
>> Adds the feature bit and also include it in the kvm for detection.
> s/Adds/Add/
Thanks Boris.  Will fix that.
>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h |    1 +
>>  arch/x86/kvm/cpuid.c               |    2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
> With that fixed:
>
> Acked-by: Borislav Petkov <bp@suse.de>
>
-- 
Thanks
Babu Moger

