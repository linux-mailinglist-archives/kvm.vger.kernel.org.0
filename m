Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0431349591
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhCYPcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:32:09 -0400
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:57344
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230113AbhCYPbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 11:31:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUuqrvYamgv257yUR8pHHk+KuSx0QMPa9gYuDVnrLy8mmOK1Q/6d4CYo7K+XmJk0s1dfrMvB8u0IEVQ1koVR2ICoXp+uXaGretl+pG8DSuTxIyXZr3promw2IXoQFPXVd3k4EeDnNTE96rzfVx5kvkB4i1rd0ip2isL6RQZmlC9NxBVKSES3ZXy3PBJXg5ctCmMAViVL6H0XaIJq5zaRFoLLMXscAkTgv6wup6/faVqdd3Q7lFA856tECeZat2pYTmEGnEFXBP746naanix51JV7GIN8spJ/WPITfP2FPr3HZGis8kk65K3hlwJlLnWq3OS5vL0PgcY/zQTMVJhR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCQi2xAcIo8lFJkNP4noOrmKq3YlTNXjccMNkQHICSM=;
 b=X7tuuMerSgQdPkTP0w6Kfbq3kO96tH+W17EDbWlzjuwZ+FKzWUZOV7ovOvSUW/iS63NVNf//YJjNySGZmVKQBpN0oMNsejEJ8bMuEBJFQwyyOVNC0C6HjZ3rIcmcwKoViguwSsY7oB0F4K+n1H/6WajFqsGpSTi5rKvdfB7bbHgXiHNw+x1eQqDIdE4Xd6RXjPxCT641U1IiMg88pngyJCsTBQvI84S4mBiqflLt4xdi1eCPBEEzySKvp5mA20POtQYkX98/jafBvCaRMw4DfR3zIQy+7j947wuVKWBv4F2ARiAwuFre7iAY0LGOvhLBTrbVrJNm5FcIsVcnMXZzyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eCQi2xAcIo8lFJkNP4noOrmKq3YlTNXjccMNkQHICSM=;
 b=JtONigxuv1r6AzxBenA5ahpnUvy+0F8XlUr+KQt+7WORg8HH9RqkYgRJQg/a1LwWwerOWXgi9CoMdHW9f7iIhWZ5jtj0lMDJruuUiMaKo29UwqqBLvXrqNlRRftXiu+x3DUJnYBDQFp5LlTnn4yxNA0oi7dpur76X+47OIi1CQw=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2686.namprd12.prod.outlook.com (2603:10b6:805:72::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 15:31:34 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 15:31:34 +0000
Cc:     brijesh.singh@amd.com, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 01/30] x86: Add the host SEV-SNP initialization
 support
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-2-brijesh.singh@amd.com>
 <696b8d42-8825-9df5-54a3-fa55f2d0f421@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <7cbafc72-f740-59b0-01f8-cd926ab7e010@amd.com>
Date:   Thu, 25 Mar 2021 10:31:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <696b8d42-8825-9df5-54a3-fa55f2d0f421@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:806:6f::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR12CA0022.namprd12.prod.outlook.com (2603:10b6:806:6f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Thu, 25 Mar 2021 15:31:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dcb7493b-9cd1-48d5-feb4-08d8efa3128d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2686:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26866750F66E4E6DDF370FC2E5629@SN6PR12MB2686.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2GlDmg1+DteQZ5COW6XFXABlARDvbgC6ycRJuAun80FzuospGh6p9tcM4BbyrazaylYQnLb+/7MYJLRFdF1Lyvr3+2YSMIP6Ipg5O3dzZCwEjYfoOm2401Z2deWmAB2DB+KfnstYfqacbx4/nxELe+Ooyq3YJqPj6q4OAIysN8DXqqT92O9eE5SNrYSILrpmco+9fHt+TRiaqeQByTVIpdUX3Rf3XCXVPnSMQ/Zj5BjlCWyyFnhKLoZR6grmAh+lg4BX6AI1m0AW9ndQR+IQUJFtWbT7lngQvrgp3DYf1IHIH8I16veYTSDu0xKvGbZM3AW0W9a7tKkV5K2gDSQv1YOWX0eBppk8pFY3BZ0iCzdUyTyf+wAeix+GjDj+HEKPnJi0GvUaOG7Hpef0wcOOsJBR+usaV3Jeateh0gOXXLlnhhl8/TtlEmRjaehXPCWI+2LGU31i28r7zTDigskekwt8sipgW18Ck2s97cCRAFe9M+FEGRsPNXJgP/KqdST4FT6LUyKSc9tZl5fX5rRJPWz/UNKIV4+0wXaYE68XUP+qyVWwobjOKAVy3Wgo5rVShG8391FNGL58qO4m2pkyCC23+X+nITduiyc8ZgF64PnAjDLQha9RT8+R5D2ltid0V4EBT8q0Jq80sSuWwoGQrHvFntNulXjtyROHbLxghhAUygZfk74hU8IkdIK0NPSpl0NzZnHebxsFJ6ySuz0UCSviJFaKj7qLRFYII2V8gc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(956004)(6486002)(2616005)(83380400001)(66556008)(16526019)(52116002)(53546011)(2906002)(8676002)(5660300002)(8936002)(36756003)(478600001)(7416002)(66946007)(31686004)(66476007)(6506007)(6512007)(186003)(86362001)(31696002)(54906003)(26005)(4326008)(38100700001)(316002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YW9BOERrZVR0MmlTNzNpTlFsbnQxWDgxMHdNbG5wM1R1ZlN0V2Y1QmE1TkNw?=
 =?utf-8?B?UXZNYzBBK2pGZ0ZNWXV2TjlZdFJId3JBbzN0VTZGOUN5OHBvVDJSTEtyelhl?=
 =?utf-8?B?dE8vaWdMYVZyTmRQeHA5clBNNWR6YU5uVk8xL0t6NUVZSk1yRFNzZUJMSUtE?=
 =?utf-8?B?YjFGdWs2SlFKN2FzUGppMHJHWFNGNHY0L1o4RlZ3MkZwZXlmTFA0MlRXSGR5?=
 =?utf-8?B?dmpvQ09KVnBRYk9VSTduNE4yWnBvbWc3eXhjWWJyeDJhQWtPSTVyR2d0enZB?=
 =?utf-8?B?TGtRaFRBSTNnSHFiUXd1MFowQjlvWXI0V3hmaUVmSlk4ajBQQWsrWjlTMzZX?=
 =?utf-8?B?aERXSlFrSTRWVmdoeld2Z0dxdnN3VHFoTWNuK3pQYk40RXpJVGJoREtweWZn?=
 =?utf-8?B?M1N6KzNtTjdxczRLaXp5cjJmelh3VDBna1FkMGxwa083c0YvMjZTenQ3OFli?=
 =?utf-8?B?YzliYlJtdC9iK1RQYkl0Z29vUE1TdGFtNmJ6M2xydjlOUDU3bHk0L0ZVYXhl?=
 =?utf-8?B?a2VmMjVIWVBWNERqeDlGZ2MzRktQS1RMYUlqN2NUMTE5czNwZVdGZlN3Nm5r?=
 =?utf-8?B?S21ZRHZzNm9pQUxXMGtjR2VTeTJDVjUyTzZ2N2JuWWw1UzlYamhrVVNDVjBS?=
 =?utf-8?B?dnRZcGhIRWtRNnNPdm05djVua1JqQldZTXhrcFlYUm9KMFdaWnBLRFA4cksx?=
 =?utf-8?B?M3ZqOVVlNW5JTFVGTnk4V3gwQ0FCNmVBK2pSQmZmZE1sRzhFN0xJZlh3SVhl?=
 =?utf-8?B?NTlrdEs3d1ZsTmd0MEJrQUlwaE1waG45V2RvZ01pcS9QOGRSaU5BTzdpdEo3?=
 =?utf-8?B?Ni80WkpjdVhpWXlnUlBQZFo2VW1UaVJjZWpzRUxVT1I5WklNeWRGYW94Wmlx?=
 =?utf-8?B?NHFLQ00ybjNrWGFIc0xQWGozeGF5aU9HMUdmWUdTdWRSRDF5ZmdjVW4wTzkr?=
 =?utf-8?B?WVlNaEpyb1N5UklISmk2Mm4rQjUxNzl3cDIzaDlyaVFZdnZnN2J0NGQ3TWdE?=
 =?utf-8?B?YUdLcW0yTDdraGtxeFpwY1V1RlJJenpGQjZGQUtPdW5rRytNM1BmdnR3Rm5J?=
 =?utf-8?B?TjBYU1J5eW1xbkhLM3ZXWXBsd2VKWUZIV1RIcGNqdXpnYXlkYWRpT1d0dHpx?=
 =?utf-8?B?VU0zTkNjeGNCUDhLQmlNaHdhbys4TGthY1JLSDlnSklieldoSUJHS0p4M1pZ?=
 =?utf-8?B?Q3hsSEVYUlRkc0x0SHpwV3dDbkJxckcwL0xQT1E4b1FtVGM4QlcvMkxOam51?=
 =?utf-8?B?WC9EeE5SMEdMOEZYWFdNVllVU0dQcG10VnlvT3RIOG1XMXUrNnFpVlJXM3pz?=
 =?utf-8?B?RFB0Y1hEVGZDU203Yk5DV0plaTdGNUw5NGFLaUdLK2xvRVBJbE5mV2ZDbmdw?=
 =?utf-8?B?Zy9Kd1hxRnMwclpHVVF3MXpOQWdraHAvZlgxYjVJZndYdk5nU1ZQcldCbEp5?=
 =?utf-8?B?STBpRkM4RmlEZFEyQVN0RFU5M1E0SU5PQkxZcXFTWDErb0k3K290TlREdHJ5?=
 =?utf-8?B?T0V6cDl0bEhCUVJuVDJraVZVdFpYZnFGY3IzR0lRUndxcmh1QlNHK0xjVlVl?=
 =?utf-8?B?azQvVTA2SGVMcFRZaGZzbktaMHh2WEkvNGtpMjlvNVBXZVpicXFlK2tiMmVo?=
 =?utf-8?B?NmtLMWdJL0h4ZGVrM245R01tR3duYzBuRTMrbFQvZkRocm9PTnBBV2VpRGZk?=
 =?utf-8?B?aDJ5NFBJa2QzTktaU1plZjNscDUwL1BISjd3eGdsSlJWa3ZVbHN2cU4reW52?=
 =?utf-8?Q?TvK/PYqx7qrKXmuzYxhVyJuPnN/v1CyksIj+Qpx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb7493b-9cd1-48d5-feb4-08d8efa3128d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 15:31:34.5087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0A617UCToaH9qqQP4p9AoMqSQ5Mpm2vgyBzlHh9pZzTJ1W2dVjPTDdzBRLOw2sHLkFXQtN72IYDDDPwKdi0VrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2686
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/25/21 9:58 AM, Dave Hansen wrote:
>> +static int __init mem_encrypt_snp_init(void)
>> +{
>> +	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
>> +		return 1;
>> +
>> +	if (rmptable_init()) {
>> +		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>> +		return 1;
>> +	}
>> +
>> +	static_branch_enable(&snp_enable_key);
>> +
>> +	return 0;
>> +}
> Could you explain a bit why 'snp_enable_key' is needed in addition to
> X86_FEATURE_SEV_SNP?


The X86_FEATURE_SEV_SNP indicates that hardware supports the feature --
this does not necessary means that SEV-SNP is enabled in the host. The
snp_enabled_key() helper is later used by kernel and drivers to check
whether SEV-SNP is enabled. e.g. when a driver calls the RMPUPDATE
instruction, the rmpupdate helper routine checks whether the SNP is
enabled. If SEV-SNP is not enabled then instruction will cause a #UD.

>
> For a lot of features, we just use cpu_feature_enabled(), which does
> both compile-time and static_cpu_has().  This whole series seems to lack
> compile-time disables for the code that it adds, like the code it adds
> to arch/x86/mm/fault.c or even mm/memory.c.


Noted, I will add the #ifdef  to make sure that its compiled out when
the config does not have the AMD_MEM_ENCRYPTION enabled.


>
