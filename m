Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A8F465134
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350766AbhLAPRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:17:44 -0500
Received: from mail-dm6nam12on2073.outbound.protection.outlook.com ([40.107.243.73]:47456
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350830AbhLAPQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:16:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clJ4D6AWYY/MofZFaj7WKasaTr3TyyXWyrwQTRy7RtvITleJc+dgPlfSFWMH2YlUYwlipuWKAc8mGCU/Yk1rXjV3An0Js4ZVfvjML6/FHmyYZPNpSQ/q3p3QErtVS+K5Xg3vR6SxsbH8+dxh+djYYCcHZ1BUz/HJNgbljUSuugFd0WaHFQJvMGPEYGMDVojoDTqdnm0Hb4gz0PgmIuOxOU1Q/SwJ/5xvCO/tq0HcCEaYZkOR3dXBYWu7jChsxyYn4Bgp0Hh1XO0gOIN1henEQoOFJzSyQMuveW8fQ8gCqg3cFnLgyHViVmUow65roqNk+xqiMfwJgbr5yh0LJTw4OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tsbsC7hqvfdrvwhYvKfTFx6GfNneplPUrSfO5v6v63M=;
 b=Qaedkn2jj5y5TOCduGBmEzOO7qkXyx1SuUOl6wBRuTe1Gj0XoJfpCHg/4Sd1YCrRBY9x6EU+0z9BD/DAKKGL3q3GZ2LGmX6q0rr5MuvMlshCv2qhmlzH00AvVl7nrov+HePTEhtBqtsVdQG9xQpm9saAMlhgO9Vf9MKJUEZILDzHq2fk3eIdI/XJN1jvzJJ1+72orGBJGBJX8ZXgGdbnnlKN2CsBhAmRNi5W8hCbE39xCqz6j0OLDq/I7ULiOEnd8LnGYz/jXlI31C5y8asuOlzw42h79MWl/tDGUR/OHfh7PHWX7h8Qc4LkDFSxMyUIt6ec4JXxLs8/89cAQ248dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsbsC7hqvfdrvwhYvKfTFx6GfNneplPUrSfO5v6v63M=;
 b=Wn0oIO2QdOXAOwBhgqr8sUJu2hTZpryV9zIsowSd144cpl0X1aKBOKZHwGMFXgowL+2MpKYxhu6nqWH92hhvdmj4YlGoIT4Uu0Awb7ABrDOcNvzsM05H1oWmLiVjEV1ciWuXRIys8gw49bnhfmSNMyKM/99fuCaeJxe3dgsymEc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM8PR12MB5431.namprd12.prod.outlook.com (2603:10b6:8:34::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Wed, 1 Dec 2021 15:13:24 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86%9]) with mapi id 15.20.4669.016; Wed, 1 Dec 2021
 15:13:24 +0000
Message-ID: <4b7ef6d8-c140-7efa-5d72-3e9b8a9b360f@amd.com>
Date:   Wed, 1 Dec 2021 22:13:15 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 2/2] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, peterz@infradead.org, hpa@zytor.com,
        thomas.lendacky@amd.com, jon.grimm@amd.com
References: <20211110101805.16343-1-suravee.suthikulpanit@amd.com>
 <20211110101805.16343-3-suravee.suthikulpanit@amd.com>
 <5148de60-4a9d-67ef-ca64-5c6461034c0c@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <5148de60-4a9d-67ef-ca64-5c6461034c0c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [10.252.73.101] (165.204.80.7) by BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Wed, 1 Dec 2021 15:13:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e128bdb-ffe4-444c-3256-08d9b4dd1e8c
X-MS-TrafficTypeDiagnostic: DM8PR12MB5431:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5431563380884F27526DBBAAF3689@DM8PR12MB5431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZCPkB8cs3K9TcAX3IF9ktkUCHHL7pZATEQ6Hu19mVz7qByDNAPQasfLhx+dj/0jk0sIQnI+sd3ApgcjlRFsp9RidznNDeWqdOzLDffKsl1gsWMrMwmxW9EyXBHgKpdHsDEgvNKemarFu8xcfSOjDTXIcc5OWnHb5a+e6KHUENvIbiaM3Sqd6+XKjgxBdU6CQqiH3y8vGxZIfhZUYMN1GTMOHyC/kqPzEYTw5YDFFmWVYq8Wb+5aEr9Zn/bhjZgBmfFTdPsE/5/wC3PfyV2mRKEnzbMhIM8iJYfbaiBV4UGRA87wm1VDb1/hncpwMa/MbutSiypcDG2NRqLSG8NI/riK7s/oa/5jd+i7yGrZHSoYd1QS1zbvWG+/2GE5ZhWYaWmuoUKdg3Ln9a+rR/D0bTSpeWvU6M6Twli0MlXMzM5Mfd/EvovICJv171nDkXkqZEk/cAn6yBpu7zzgBMNO56CQLdGeMGzMx3x5IkTgvc8ar9hbBAbno4qko8z9spOVHSVjiQTH6beX7hrl+EkndEzRqT9CKLbAEN7BPYKNeZhY3p9R8R9GAxV4HIJoj+N/jL2WIdyT/ThyllOT/5JqHihh4D4zMgBMewhXXM448yb0xh4jyUP1HqeryX0vflu/z3xe+8+58Fd+/vbRfjm1UxWOOfLqvmwh24GBkQsIcSZgAvRSlEi05szRVh065P61PH0MiHIxuWBmzenclkze4kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(31696002)(5660300002)(4326008)(8676002)(6666004)(16576012)(86362001)(31686004)(2616005)(83380400001)(66476007)(6486002)(316002)(66946007)(66556008)(36756003)(956004)(38100700002)(508600001)(8936002)(4744005)(26005)(186003)(7416002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mmx6NC93QXhTMkIvVGNJME0rNzVtazl2ME1IZU1sTHNyVTV2cDFjb2hFb2lY?=
 =?utf-8?B?azdoQWI0bWtQRDFoQm96UTJVTTBRT1hURS9jOGEzdnEvazFPejh0M3FQQmdG?=
 =?utf-8?B?YlJBTStvb1gvRTAyVk9mTzJNc1hlN0pRK2wwc3VJYWw3TXpDMHlnTjNqUjRy?=
 =?utf-8?B?cVVNZEQ5ZXYvQ1FaamU2bFJVZXY1N21lK1lVTVBYQ2ZtVDNmYlFyRGN0SjNT?=
 =?utf-8?B?eXpZU1NEaFhiK0l5OXdUZzhEeGtMYk9sMUxmdCtHNXdRc0ZyUlFMUGt1YmlN?=
 =?utf-8?B?MmNzQkhxQ25CNyt6V1BzSmVSaFBKRW9LVXpYa0wxQkEwMEUrV1NaaG1zWlk5?=
 =?utf-8?B?TDUraCtrVy8wTy9uakVSazFmdlhrdXJlNGYrS2duVHRXWDBLdDRxdWNjNlZM?=
 =?utf-8?B?MFdsc3RkNFNjSW1yb0dIVnFLKzlmWXBkQ1NJTzdyQ2lCOFg5OVo2TmZVTzlE?=
 =?utf-8?B?aE5nZnJCT3dSbFIweHV5NngwVlR1bDRKYWpvRjZPVXhyWHp5MWRoNHp3UnRz?=
 =?utf-8?B?UzkzQVM2NkR5dElITk96U1gyWHRPN2hxcTdEVk9QNjRwc0t4bGh5U09CbDZL?=
 =?utf-8?B?ZWI1d2lXS21JbmdvTmdYMmxVdGh6eTQ3bnR2RGdGeG8wYWozZWlNNWF0NHVo?=
 =?utf-8?B?eGxlK0t1TXI3aHpaNHdQQlBjVCt0UElHWnpKWnMyWTFueUVlY25laW9qZjZx?=
 =?utf-8?B?NFljSUxQdDJIUDZKY2YxV1lkQkdIS0R2T0NwNk9oMG9XY2FSbmNqWU1TbGlL?=
 =?utf-8?B?RnNyYmd1ZVFVTkREM0hHSWI1SDc4MmVuakdiVCtUUE9EWEZtY3pXbVJ5dXJl?=
 =?utf-8?B?eUpwSHl0bnFVTW9RMzBvVlA1c0duRFJqVGt2UXJVWThweDI1RzdEcnpnWkFp?=
 =?utf-8?B?dHpXSWx5eFJVMXpJMzFzalFUUGN0L3VnZ3ZzK3Z3S2YzTTRhZW15SlBBUDlV?=
 =?utf-8?B?WXFTL2VLczB5OGsxM0daWTRnS3hFRnEydUZaN2JoS3B1WE16SjBmZWpDYitE?=
 =?utf-8?B?Z0t3U1NPdS94OGozNmlBcktDc0tja3lQenRNNFJLYmdzb3loLzlsM2pMWlZ1?=
 =?utf-8?B?bXpVbG1ldWh6V2JDQjN6U2g4bTBVbjJYRlcwWW5BK1c4RU1PanFOR0JGem9X?=
 =?utf-8?B?MU1zTnF2SUhpS0pkV0Z3R3pWeG1zb3ZIYmRMTHN5S1pSWU9mUVNEa2ZVM244?=
 =?utf-8?B?aEdPSGNiV2lSSmRLT0xmYTE0TVF4c1BpT3dHMjFkd3hQOTJhd0c1Q3A0bE1a?=
 =?utf-8?B?bnB0c25tT0xtelFITWhvMDltL3g0ZjJpY0F1NURNK0NUVEV5TDhxazEveU9N?=
 =?utf-8?B?QXFDVGpEbFhtZ1RLcU1qZkR2NmIvREM1RWtzSC9VRFdZenNsWjJ3aVUzS0FP?=
 =?utf-8?B?S2Vkd3d5NU1aQ2JLMkFVQXJWYjBPOWd5bXBuZGZWWHYwbk1kc2FKRE40Qm50?=
 =?utf-8?B?Z29NWi9tOFpQcWE1WFgvdHNiSE9nVElQcUt3dHI4UklINDVDNFdLTUh5VDlN?=
 =?utf-8?B?UHFIK0h4aVNzek5ReGpkbjFKRmRtc2VId091eFBURk9SV3VuMFpPd3Fuc2x2?=
 =?utf-8?B?ZXlVUWVFT1BEdjlraC9GcW9FcDJ0N2RCMjRJcjlwNUZpR3ZHOWRHY2xEd3FU?=
 =?utf-8?B?anV0MGJYQTBMYkF5ZzRONFdhU2dNdnRXbWdsRE9BRWpSVHViOXpPY1U0djYv?=
 =?utf-8?B?TE9hWVV1emdzbmNGVjFkNXA3U3UvL3c5NThHSzFYZFFDbEtqQVBqeW5ERHR6?=
 =?utf-8?B?cHFyN1NOU1lNSVZpcXRuMCs4NS80NXh1aXVoZU03SzA0TDFieFMrWWlGZ0Fn?=
 =?utf-8?B?UnJEWFZQV1NsRXpEekQ4K2R6akJXVUZFb3RMS2RmTThEczZWcFc5bUZQV0hw?=
 =?utf-8?B?MktBYjhrWW91bjlOcWRsQytodEZaZmtiMGVmOGVKZi9ieGxWWDlpdWUrckhR?=
 =?utf-8?B?Wk1nRnBKY21nZk4vMTFoOWhNVFVpZVF2cWI5cUxEU3VObzhxQ3VyZm5vTlAw?=
 =?utf-8?B?SG1ka214ZHJFSis5Y3VxcnJ1YkdKZWxycysxR2pqWFA3S0tsUGVCMzdzWlJP?=
 =?utf-8?B?c1JDZWRjeWZHdGt4RkYrWkpwY2lpSUdWWFhhK2NVd0RHaWNhUExlY2Z5Qm9L?=
 =?utf-8?B?WTE1N3FKMGd6Rm5FRkF2WjFkdUN6em1YS2Irei9jQUJvRE5Hc0JYTzYxVnV1?=
 =?utf-8?Q?pCmM0rLT1VCskFQ+sDRK4ik=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e128bdb-ffe4-444c-3256-08d9b4dd1e8c
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 15:13:24.5003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z17bZTsPNghgBomdOEkMmOHpARoFq3ysOatX+CHBXny9lXnAXF/PfzNCJWWvtnIHEKH+3QZWlkaPfBHA94moqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5431
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On 11/17/2021 8:06 PM, Paolo Bonzini wrote:
> On 11/10/21 11:18, Suravee Suthikulpanit wrote:
>> +    if (level_type != 2 || !x2apic_mode) {
>> +        avic_host_physical_id_mask = 0xffULL;
>> +        goto out;
>> +    }
>> +
>> +    core_mask_width = eax & 0xF;
>> +
>> +    max_phys_mask_width = get_count_order(apic_get_max_phys_apicid());
>> +
>> +    /*
>> +     * Sanity check to ensure core_mask_width for a processor does not
>> +     * exceed the calculated mask.
>> +     */
>> +    if (WARN_ON(core_mask_width > max_phys_mask_width))
>> +        return -EINVAL;
> 
> Can it just use apic_get_max_phys_apicid() in x2apic mode, and 0xff in !x2apic mode?  I'm not sure why you need to check CPUID[0xb,0x1].

This is mainly for sanity check of the max_physical_apicid (derived from information in ACPI or MP table),
which can be removed if you think not necessary.

Suravee
