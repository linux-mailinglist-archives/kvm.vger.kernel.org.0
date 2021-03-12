Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D2F3398FE
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 22:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhCLVSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 16:18:54 -0500
Received: from mail-eopbgr700085.outbound.protection.outlook.com ([40.107.70.85]:18913
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235209AbhCLVSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 16:18:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2if8qMx6K3WtjKVcOEfZEHvlMTSu8+Fz168cV0olnKCqzp7ZrSvRjAZhaJ5IxQrKhDpvwkB4ppkaTq2aTqnLaHngEpRsPnxmOgn7VlMhhzPuXI9Ru2i++paoK7ArfDeUTrAtav+5c8UE/IHSAHEnh4YD2s/H+tddjzrJ0zobxSem3UATxKdOMXtnHgW9k3t7mC8Q2gbyNXnUjFD2sU1Z2pxCxm05wP3N33w498unauCnSOYqSx3eywGU3ari2psQaihddd6HQEAM/oIoWU4rCtlKpBrQRCuBHvL5/IPj+PBE7Urk0W1DIxOlrlyFupcenKLg5DiUzD6wHsWmNKALA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18cHAm1AC7Yf5jApTKiftia0rxqWJiiNh+UM0xqalZE=;
 b=m2A3O+O0ZMbjkAtfaDO5qz+xra4btA9a09wuJuPq/JS+q0obZDN1lzAbVjmYv+kSoBo0Y8SLUtVs7+V2cwyIp6H73AM5JeVZoNVQ8Hy8deZol/Z5P75UufBimUgyOWnC+SQWbC0kZt19No3Y9eUVg1LvNyqPDhfkiI+WEBWetAn/mCRhDajZ9kSShFr9caVT3OmOoYDulz7XPEvXD6tTMdgbqOlTExbcrHdxIfyxsIJ5nEMQczKA9FSJo2USJVgQ68HOTOPLWK3+08fxMpsKfpOP3gIAyuLVl7hh+r1Vf2KucUg1fLeQmJQAnXwF6GzZ4U3cJcopkA4GiQg/Fr7liQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18cHAm1AC7Yf5jApTKiftia0rxqWJiiNh+UM0xqalZE=;
 b=aNX7sxStiIzkOyJyVxAzeIpHlv/0LRPkEebFLflQUkYca7YmEx3P3MXFcrutTSH2z7NIEVNyj4nA7kic+uRVwzcIQgUaTCgY6mJGt5rz2+YbOWi9XCs/kH6hWym16U9VH3v5CkR35+jginGCr4mmoLbgF38w5dIZYzf6tc9Sacw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.29; Fri, 12 Mar 2021 21:18:49 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 21:18:49 +0000
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
To:     Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Cc:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        brijesh.singh@amd.com, tj@kernel.org, rdunlap@infradead.org,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com> <YEpod5X29YqMhW/g@blackbook>
 <YEvFldKZ8YQM+t2q@google.com> <YEvUTatAjIoP7dPD@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <04f58780-5392-63ed-589b-259de695e4c3@amd.com>
Date:   Fri, 12 Mar 2021 15:18:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YEvUTatAjIoP7dPD@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0209.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0209.namprd11.prod.outlook.com (2603:10b6:806:1bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 21:18:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc840cf0-b41d-427f-5e15-08d8e59c6dc4
X-MS-TrafficTypeDiagnostic: DM6PR12MB4433:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4433732EE872FE7ADAED05F4EC6F9@DM6PR12MB4433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+dt+EjDK0zlGq938itDwCznXq4xM0zBMZPYPxjdB2YXqacywCTWvyks974iKmASAzdXobHVech8PvsD9/qlupbCUauk2BphydPoUY+U4hOmS82Z9+k4GGnVZ7fLrGlShlj5+IyDnXaUcSEZMnCQoWoo9DljBsJ9VlOKSwq6tN+Yp3B59GXeO1E+tc7OclH+trDqTMWk+H8eh5sc1b/TKVJ45SJjd/PFGi/b/JkH50pcydvjax8MMvtzg6hLyQwO2uDGLzZcfsD8rGfgY0Pz164vrvLKjgLkRnpPuo4YkF1miXsOT3CnqKHA4jLulvsss89lczBLLACotCYW6HPubCvXJtLQxv3iQjDRzGGn1kIASUQWsVxryjdWOG+bunHd7u79hlmkTy0A4f9KjaQj1RXdNfUSygP4J6WhhfbIw6aH+lhCZ+moDjtqqHzK2B0tQwcTlG8zvHr7OG0fH5dc40cHV2hi0tGO85gsIbqYrn2acQcGReug9GRQ5Tc48reDw9h8XlmyhbNEs14YUqnpBzhS7FHTlBnoy+ZF+YY86QFTsOXq8KnZScFbhmwBEYLDBpCEJga7aSt4f0/E/xwjvnmVWjcx3Rz+qOiqOC9I9l4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(2616005)(66946007)(110136005)(186003)(66556008)(4326008)(956004)(8676002)(83380400001)(66476007)(5660300002)(6512007)(26005)(52116002)(7416002)(316002)(6486002)(31696002)(6506007)(36756003)(8936002)(31686004)(6666004)(53546011)(478600001)(2906002)(16526019)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?djBaV1QwcEdudUo0N3JweWR2MVZwR0tXaTBhRkR4QUdheVgwdlk1L3VycDZ5?=
 =?utf-8?B?S2NHanpYYkFPdU5rQzQ4dmtVWS9iWUEzQkt4YkJnQlN1cWlLNWRCSGkrb0Yv?=
 =?utf-8?B?Q0E0MWNCL2RjS1NqTEo5MFVTTjVnakJURGVDZjJFaUJ6M2xBY0lUOHN2THU5?=
 =?utf-8?B?TFp0NStrTU4xRjErcEVoTXd6Sm4yNTk5SFFPVWozMklINFoyWU52TFYzcWJs?=
 =?utf-8?B?R1NtR0M5Q0h4cVJJSkNCcFlMTFRBdHVWY0g2S3lDVUhLT05UZGZscEVpOEJY?=
 =?utf-8?B?UXU2NDduVGNHM3FJTHQyQWljaWdJU1l3aDZheDIzNXoyWVA3a0lsalZRaEl4?=
 =?utf-8?B?OHVLZE0yZGhSelJiRmhka1ZjSUppa0lCN3gyUndDTzFrTW4yVm40UGVtMDNV?=
 =?utf-8?B?RXljdU1tSndXUHV6aUl0RFo0c2hGeFBReDhOWE83V0t1R2sxa3Z1U3JRQThF?=
 =?utf-8?B?TC9abTVwRlZiS3l5SVNoaEhnNk1iWmpqRWplT21tZncxS1R1dWtWK3VISlVs?=
 =?utf-8?B?aS9Cdi8xVzYwcW1tUk5veUZGWU5kaU80SEtyUGk3WVN0WHVKR3dRREdXNjRV?=
 =?utf-8?B?VzJ1QnlJSUtiTlhkTmlPVjhzazNJZ0IwTFdXWVcyZnQ5NHgxc1dMd3N2am0w?=
 =?utf-8?B?ZERGU0Q0Y3BMQ0hOTnRnSklkSGFsaElhajdybDhUcFJ3dEhtWHVZL0VsbURa?=
 =?utf-8?B?TG1wUExrcXhSK3VteVVHWW1xZkFUd2dxNUt4UGhNc216TXhjUzhRQ1VyemRB?=
 =?utf-8?B?NktMaUFtV1ArU0NJclpxN252VGZQcVJUZFJGbXoxNDNVVWk1MWJwZnZ1R0hM?=
 =?utf-8?B?SHZyMlBMb3lKK2Z6bFdGcko0dW5WMFlMQXFNMktmNndXWmt5RCtpMG12QXFY?=
 =?utf-8?B?MEtLTjNVUm5EaW5KV0JSbCsxSHI1Nm9XYXBIMnR1NTkyVFc2WFB1RWZVdWJm?=
 =?utf-8?B?WU5uOHlTakw2UzBWemhPQnEybytTVzAwMzJqa3orQVh6MzhTV1FMa1piZDgx?=
 =?utf-8?B?bDE4VEZkM3oyTERRY3BSMTJ6SmxIRnpCYTcrN2grQVFMVFFRdUR0cnZkam1X?=
 =?utf-8?B?b1ZqblJjRzg3dkVEVmJmS29vbTY1elpCNytQUm9PaFIwNUN3c0EvdCt4aHFk?=
 =?utf-8?B?MFU0d1UyN3JuT040aEFpWnh5UjVEVmJ3QTZuZkZ1a3o3TU1aOExETVdsMlUr?=
 =?utf-8?B?Y3pmaTM4YVYxQm9BSWRPUFBaUnRUMFI2aVpEcG0zdjl0UlFtYjY3QXN0ZjNk?=
 =?utf-8?B?aWg0aFZST0hDZG0xQThlV0xRY2hkc0hMZ24rYmtGTkVrSUNZMkluVVczR3NX?=
 =?utf-8?B?bWFoR2c4blNsNDhnUis5MHdFdWFHbUZkN0pPREIwbS9QVXRvS1ZKSGZQVnRh?=
 =?utf-8?B?bG1FVW1PSkt5YWY4cXNhUmM1SXlOOWI1Tlo5VUd4eEVEMjNmdlg2cHZkTUhQ?=
 =?utf-8?B?bXVOZC9DTGRPeGx5YlI4L1cyU01kaW5xcUo0WXFMTys2V2tNVnNIbjgrSmZr?=
 =?utf-8?B?ejkvWTNjNHBKQ0VFSyszZkJzRmdnZHE5a282VTNvODl2Q2g0V2huUDU1UUdH?=
 =?utf-8?B?eFM2WVhycHlMYzd1WngzdFZBTElEVWJwRmdrcjZLcCtmTUNDdXdqTTZOZC9W?=
 =?utf-8?B?KzFrcnZVRHlmbWZ0TTUwTTVtaTJpNHB2cEtwTExZcWl0dXBhS1llL1Z4VWUr?=
 =?utf-8?B?ekJhQ1I4VGMyMFNQUTdxUU5yTHRNcEJsQ2tBb3pzNjFxSHkwWHhOVVVQb1pQ?=
 =?utf-8?Q?ACFTL2NLKEVaQZa6KnftIh9edzPDRxmOBthL6SU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc840cf0-b41d-427f-5e15-08d8e59c6dc4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 21:18:49.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orvuq65+hAFSm4/Mi6qf5WLC99hIHA/sXfc0LsMPsv0TGde9yUZjyHKSD66GJJVpLMa4JzQ5iBBoaQ+nYy328g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/12/21 2:51 PM, Sean Christopherson wrote:
> On Fri, Mar 12, 2021, Vipin Sharma wrote:
>> On Thu, Mar 11, 2021 at 07:59:03PM +0100, Michal Koutný wrote:
>>>> +#ifndef CONFIG_KVM_AMD_SEV
>>>> +/*
>>>> + * When this config is not defined, SEV feature is not supported and APIs in
>>>> + * this file are not used but this file still gets compiled into the KVM AMD
>>>> + * module.
>>>> + *
>>>> + * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in the enum
>>>> + * misc_res_type {} defined in linux/misc_cgroup.h.
>>> BTW, was there any progress on conditioning sev.c build on
>>> CONFIG_KVM_AMD_SEV? (So that the defines workaround isn't needeed.)
>>
>> Tom, Brijesh,
>> Is this something you guys thought about or have some plans to do in the
>> future? Basically to not include sev.c in compilation if
>> CONFIG_KVM_AMD_SEV is disabled.
> 
> It's crossed my mind, but the number of stubs needed made me back off.  I'm
> certainly not opposed to the idea, it's just not a trivial change.

Right, I looked at it when I was doing the SEV-ES work and came to the 
same conclusion.

Thanks,
Tom

> 
