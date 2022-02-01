Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78AC4A5EB5
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 15:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbiBAO5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 09:57:12 -0500
Received: from mail-mw2nam10on2070.outbound.protection.outlook.com ([40.107.94.70]:61921
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239524AbiBAO5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 09:57:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbzXCOjPgQ8Mqi+sEZsiGAHQaD6FsJwddyxJ/9GGt11MBx8g2GSZCyKg531UZvJnVvysIHtGsy9j+oewI8XAk/mIlTuMMnZhRsnxRdh63V6Y8gc2uFRxSpDDf5TygG6y7aP+SK6QSovhRMJNg7RqXiFV8aNooBMqO3X8YyA9Id36TuY4/vAAhYmwq4Jip6aDed3bw+bUIardh5Nl66esnnlKQ6Kf9MNUWlpQN35IpM5Ex5W7bDv45HTdWsI7hNZgr4vCRNb8Wl7ZTdObR7P7A7ARqntIx2JItop2IItZWR9EfpLwTXIf+zw/m1A42G8XD05F/drFFakxc6ArfFHGFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjx35/uJcyZYEs230TYCYDgFv9i5OYEdIM4EHWeZo8U=;
 b=CBx/2q2gsAG3UQtjkqvnjV4VLfj/41y+IN768WQRJHW5k1lzFFj/JtBtPppuDn3TSDDH/nd5llcm3AWq5f4FzbVKnJi+VPH2DoY0egViSJ2Mco/lNH4e1L4y8GjTR5J3vQia0kONvoTdZb2ljrHVF0AZMyInRtZqBjerTfakNTOv/WdoEx+BuuqC8h3FmfsAFtRYf8wHN8UQEXSmnUYuwWv7nSORXIDQI454KFjkK1lWuBlaoOw1NmuqWlWXhHyDzCHFj3RqocmElHOY1PwiVVxqpl61yFfrTRAMS/4mGU8iEorR0fD82hWrI8ubLlaZEEJUTpYO9O/u89ehl/qaxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjx35/uJcyZYEs230TYCYDgFv9i5OYEdIM4EHWeZo8U=;
 b=fp8qed3O42+MeTWHGCYy1tFLaRBo1v9SnrP+FFMhoxD+MGlpYJ0mU3FSZ+C0ZzHYCHnCyKH1DHr17p3iz4cTcneLLXP34+ttkKostc5+yCJkcLfJ3F4um6zJE7aRzEdvYeCXgCHUwimgS+33WIzz5lLjL83M4+eIcp4VU++t4o4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CO6PR12MB5476.namprd12.prod.outlook.com (2603:10b6:303:138::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 1 Feb
 2022 14:57:08 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643%5]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 14:57:08 +0000
Message-ID: <45c0c1c2-f660-afb4-9631-e73cbbe60465@amd.com>
Date:   Tue, 1 Feb 2022 21:56:55 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v3 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
 <Yc3qt/x1YPYKe4G0@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <Yc3qt/x1YPYKe4G0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::18)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 983af616-ad3d-4b92-ab6c-08d9e5931e4d
X-MS-TrafficTypeDiagnostic: CO6PR12MB5476:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5476A36B48FD247B3BF162CFF3269@CO6PR12MB5476.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9l4o4wuDBmqAK5QPl7KUCmL6hQtVFW4mo1vNHAtTq5GYtBIB2ewYKFJHf57Nbu/06m5xGpt/eFoIzQgjAJ5TuhHEMlOSDXltfes15Nhem8NqehH9pKExyw9+TKBccQA87x9eaMss3Qp7mZaUpGd43AjpwQ9UEontQgZpo1ZPB8WW5y3igKb0VZO//80PCTMRgncMxQ9b4Pvq03EETkoCxX8FbOlf6TBlLMSdRTSLHsoJohuhhL+2RgddagQXkJQowNbWZm3eqEM8xQQ7DDYQmn6Oz+xA5IoOtlyGs8P3a17NUFF9BWaEPDtrYf0OKLcTsWOwXbRh3VCVKzTDPP4KiNcoWrcxliV+JhAThR3R0nAtVAG05DaFOwWxPmGYpP7/wsJEyI70Nc0c+5azguEVazLh/jJ19F9Wq2Mxu2QFN6A5WcKvbmaFQlzcSlMpl/6oPLIL0TyuhjMhQ6RGXy7kb0wKb/stvip5Y+lWXnchOSfsofcbcYO9JFC7P+hVf6B0XLCEyNkTtiC13v8e8d8MnktBCQ67683Y287ajCLD6K6T1K/8TwZcdSKFltgfbn0uKhDyzn6dzZpF0iGL0zRyIwA3YKeXqyjEm6Ce1cwvtDweEkkC3hhq7SSylTjsNksc+K/tWEY3c+OWyXQFhwjHuR1hbi9Ugyd18U88BytzXOFgEPjF0KwMbJfqN5PgRiTY6uh5e4Kf0Ab/P+Rg9VQSU6amWM5mhLRp9o2hypqGu90=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(31696002)(86362001)(31686004)(8676002)(6486002)(53546011)(26005)(4326008)(36756003)(2906002)(186003)(2616005)(5660300002)(8936002)(66476007)(66556008)(7416002)(66946007)(6916009)(38100700002)(6666004)(6512007)(6506007)(316002)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0pIcThCTVAxZy85Y2EzUkI2OElWS0ZXT01XMjR5ZWJtVXlzS05vR3BtaU5V?=
 =?utf-8?B?SDVNTGJFaHkvTEw5aTJ1ZnZVZmRsZE1ZZlZJbEl6YXl5SVVrV2hldUUwWW9P?=
 =?utf-8?B?R3RLMytjQUlwOExTYnNic0ZWUXRXZ1FTNmtueURXU1d3ZHh4SUtnMkJQTkpj?=
 =?utf-8?B?RDFKejdGeEVMb2NpWmJyNElBaDJPa3hQQm9ZWGY1NFlOWHFpOHVNdjFiT2Vx?=
 =?utf-8?B?OUNtTGdQNFJrZm9yL0pZWGZOYjZHVG9HZ3FkY21VOVFZUzRZakh5T0s4ZTVp?=
 =?utf-8?B?cEhmSDVjaGtoS096MnROWHo5WXNrVkY5czlXWHNyT3RjNmVnOXpPempXZXZP?=
 =?utf-8?B?QitVUUtPdWF1b3pGaVFzVFJ0ak9PTWF6a3g2UVBpdkFBam5WVkI4eGxjL2hZ?=
 =?utf-8?B?NWFMb3NrY01MRDBEM1NFVytsZUN4dzNhNUpqN1BRYmJSdUZFTUhaY0NYWmJn?=
 =?utf-8?B?aVhvcDBHNEJMVzVQWUFpMHlWT285MkxpVk14WGRQSXJFeHU0ejJHcHkxQ1Q4?=
 =?utf-8?B?dWdkWEcwMnU1eDIvYUk5N3FiRG1DTnJFZWN2NDZNR3R6d2ZEUDJVZHJkTVJB?=
 =?utf-8?B?S0NkS0ZjdGhGYnVVL3U1T1VMKzdEVW03Z0hvdkxwZFBHd3NXWXZ2WWFMWktw?=
 =?utf-8?B?aEp0VHF1ajRhdzMvUFVHelRYcld1UThRcys5OVE2Z25zMlJhdnA4ck1qQWw4?=
 =?utf-8?B?b245YUVpajRVYkl4c0Q2UksxNlIrK3lnciszd3VVVld4eGpMUmdFZGxKQ05o?=
 =?utf-8?B?dDFKVnFwN0dZT1lYbVMwUzBGeWxQNnZncHRYaS9sdDVQcGJpMDlHTzZvMTNj?=
 =?utf-8?B?aHpWYVlja2NKMzBSdU1kUXoxd3hmblFSRTM5RzUybm1aVkEwdGtPK3J0Q25T?=
 =?utf-8?B?K2hLbkpjQUhvUk9PdVc4dVBkdElXZ3lJcWJxekNmN2xLL1ZOeS9scmR2VXVZ?=
 =?utf-8?B?RU01eEd4Z2l2RndZZ1NlK0pkb1ZCVjlCNk9sWXQrbUFwUDhpalpMZzd6MjVN?=
 =?utf-8?B?TVBmQXlMWWV3SG1KTUtxWTdVc01sSStGRHRhNFFrOGtYR0Z6WnQydVRnZThr?=
 =?utf-8?B?OTBMNjNXcG01WTl3ZlNHUEFmUnpuZ0tkSm1YSnJrcTA5a1AyOXg5dHlWcmV1?=
 =?utf-8?B?c1g5dzZ4U0dSdWJIZVhDOExUaGRUR1JTV2NZc3UrUHRnWVBadE5GSVRqWVVz?=
 =?utf-8?B?TjA0czZOdWMxdkpjTDU2ZlBYbjN4anhyWXpmUTUvSHUyQy9TUk5FN1AzN1lN?=
 =?utf-8?B?OGpKUVlUUFZTWmYyTVdRU0lmbFdhSGdqWEc0SDNsWlJ5NEc4b2FGL2Rsdmxj?=
 =?utf-8?B?Q296Z2FNMFk4emdRSmw3WkNEaWdHYVd4cHlOSWdHdXkxRjdmcW1PYStHZGNX?=
 =?utf-8?B?TTV6eEEyckFMVGxwMzZqdm9yMmtJU3JqSkdmN3Z4Tnlkak5xV0RoeWhTb3Fq?=
 =?utf-8?B?RlFaak1wT3dKeld6UHF4b2VSTDd2S3ZtQVFxYmpreWtGYUVPWkQ4R1VaNGlw?=
 =?utf-8?B?RkJBNzg0K1NvQkY1d0hrVWd0ZEZLU0RIMFlWcHl0TU5iQWNZbGJibHlZL0Q2?=
 =?utf-8?B?emdmRUtZQTB6cHprWk5zOW5UbmkyeVFNNXVhZWdDd1RWajZKSkM5UXRwVHlp?=
 =?utf-8?B?bVNyb0RyR2F3VVlLSDdnQzFBd01zZVJ5U0VBSldwUXJDNlNVTDlyMjRWMkFG?=
 =?utf-8?B?WnNnNVVCVndkN09kUEFCOEZUeGgwWkdRNDJXRExZeGJ1TFUrL0dQcDFPdnJv?=
 =?utf-8?B?WHU0ZVd0NkVpd2N0TWtaTGxmMEVYS2YzYk5INjFYbHBWN2d4aGRMU2o4SzFa?=
 =?utf-8?B?RGFjRmJFYlZPRytyVkk5ODJkbC9xVkZVWDF3L0V5UHJaOGJ6eHlHMHpJMjdC?=
 =?utf-8?B?YTVsKzFLVlIzbDgzTzQ2b0hySGhxeW9sS1EyZHhjd0FkR1RlS1ZXSHhxS2lF?=
 =?utf-8?B?SFo2dFJGUEFHZmlmV0VhLzgrLy9UVEM2WFFrYjd1MFR6bXJFM3ZKVzhjdENa?=
 =?utf-8?B?WFllcTczd3N5SGwzaXpzc0dsVHN0SEhzZnU3dmIzMGJMcEdUUXpSZUZ2cktl?=
 =?utf-8?B?Q2kxME9nbXJVbzcrQ3BpbUVCMXJRZmE5aFBvYjhjK3NaaW5LcFB0Ty9rMjFj?=
 =?utf-8?B?azc4WW1aTm5ONjNDa2l1SlNKQm56NDU2OW1USU5HSkZVU0NOd2lvdGNTME1G?=
 =?utf-8?Q?Oboy6HR0HvC4TJzC9VL15Q8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 983af616-ad3d-4b92-ab6c-08d9e5931e4d
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 14:57:08.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NHwzt/5++tnh9nWpce7FKEBVPEQyLAZGKNjNICWJLCSVMmreqivtBetCKAv1DYj1G8+ta3ryb+pm839A3nXjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5476
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

On 12/31/2021 12:21 AM, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Suravee Suthikulpanit wrote:
>> The AVIC physical APIC ID table entry contains the host physical
>> APIC ID field, which the hardware uses to keep track of where each
>> vCPU is running. Originally, the field is an 8-bit value, which can
>> only support physical APIC ID up to 255.
>>
>> To support system with larger APIC ID, the AVIC hardware extends
>> this field to support up to the largest possible physical APIC ID
>> available on the system.
>>
>> Therefore, replace the hard-coded mask value with the value
>> calculated from the maximum possible physical APIC ID in the system.
> 
> ...
> 
>> +static void avic_init_host_physical_apicid_mask(void)
>> +{
>> +	if (!x2apic_mode) {
>> +		/* If host is in xAPIC mode, default to only 8-bit mask. */
>> +		avic_host_physical_id_mask = 0xffULL;
> 
> Use GENMASK(7:0) instead of open coding the equivalent.  Oh, and
> avic_host_physical_id_mask doesn't need to be a u64, it's hard capped at 12 bits
> and so can be a simple int.
> 

Actually, shouldn't it be u16 since the value returned from kvm_cpu_get_apicid()
would typically be 16-bit value (despite it has int as a return type).

Regards,
Suravee
