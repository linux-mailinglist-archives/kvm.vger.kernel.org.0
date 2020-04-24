Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7453B1B6ABA
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 03:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgDXBNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 21:13:40 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:29954
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725888AbgDXBNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 21:13:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9Z1ajs/7U6G4Nmum7uieMzjTEegGdg90RnR3jRwZxopO4eQnjwe8Fb78AIbwqoYNkIrhHBDicD+KSD1b7wJZtdQpMpsQxOJjEDgpvOVUY6YnvUrIprITGpCN1tEF5ss5cjIrwp1UUqpfa5vL2vAqiuX16NG+AUW91myfmsY6ErEAAYZOt9Re10ZIT3nL5pMw9DDip1ejD7CHsXNHlhBcHbEENh7FEnsoBAAvUdJZQvt047gZ5Fwhczu/Qpshp/eWZz+I4rCMtVZvKLLXJdBXU8m12G5vfemi/UhtSg4e8CCwWiJ/HKKDEuHcWuZMNv1GxLBQmcZpCcciqwTdzpP9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvTekBnCh3n1jt5W9BCmlYMi9U3ohcO+WTelom/gukY=;
 b=QBO+B5WNYOVCHPxl1YIsgt/muF5WS+b/FwoAIXMg6YQfEN/7ue8sTz/qsDuFvSLLIN1/lKAHd5kntznfSYtpw33xwgQ4dr91ydbWjRrIZNoRDpv5XwNX4Th5n3tXpcw8o0FGscbr8fqr+fBYq0sx7AmxQMZrl3ezIJ+euQoGoTyzeQAMsHfk7dzut+YaFW2y1s6DuJmqwQGzaowE1de6+dEGi40E0F8lN1z5zAU/Qw6W8UflCM0V1BW4YbRDF6hif4Lkv6+sv4n8Qnh9JfiCEX5qldeGUDqqDuYOMw39xtXIReULlo/6otAAfBMY8XAa//jl1/H0Glbr6pY0jeP0YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gvTekBnCh3n1jt5W9BCmlYMi9U3ohcO+WTelom/gukY=;
 b=nRuuAfgaaTDapvYPHWQ4lWsmgpL82kGz08DI3Ck1NIM2KKIsPXFRw1vNZ7LdfdCLedz/WV18TEI/IW0dPPXiEsQ7+hhSS+87GxMhxJEwU0uIGIBR+EVYQ9tWjd+kSiFNlYHCzTXGsg09FlUzmcwkmnOaBiX7eYILvvj5IlcjMuo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from CY4PR12MB1157.namprd12.prod.outlook.com (2603:10b6:903:3b::9)
 by CY4PR12MB1894.namprd12.prod.outlook.com (2603:10b6:903:128::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 01:13:37 +0000
Received: from CY4PR12MB1157.namprd12.prod.outlook.com
 ([fe80::cc4e:93f6:2379:9e59]) by CY4PR12MB1157.namprd12.prod.outlook.com
 ([fe80::cc4e:93f6:2379:9e59%10]) with mapi id 15.20.2937.012; Fri, 24 Apr
 2020 01:13:37 +0000
Subject: Re: KVM Kernel 5.6+, BUG: stack guard page was hit at
To:     "Boris V." <borisvk@bstnet.org>, kvm@vger.kernel.org
References: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
 <d9c000ab-3288-ecc3-7a3f-e7bac963a398@amd.com>
 <ebff3407-b049-4bf0-895d-3996866bcb74@bstnet.org>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <f283181d-b8ff-0020-eddf-7c939809008b@amd.com>
Date:   Fri, 24 Apr 2020 08:13:27 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <ebff3407-b049-4bf0-895d-3996866bcb74@bstnet.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0141.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::33) To CY4PR12MB1157.namprd12.prod.outlook.com
 (2603:10b6:903:3b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:1548:45c4:8dc6:180b:453e) by KL1PR01CA0141.apcprd01.prod.exchangelabs.com (2603:1096:820:4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 01:13:36 +0000
X-Originating-IP: [2403:6200:8862:1548:45c4:8dc6:180b:453e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15edc619-b49a-4220-da85-08d7e7ecb767
X-MS-TrafficTypeDiagnostic: CY4PR12MB1894:
X-Microsoft-Antispam-PRVS: <CY4PR12MB189419E67EDB10594BBA5637F3D00@CY4PR12MB1894.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(16526019)(31686004)(5660300002)(81156014)(8936002)(6512007)(478600001)(186003)(316002)(6506007)(52116002)(36756003)(53546011)(2616005)(2906002)(6486002)(31696002)(86362001)(44832011)(6666004)(66476007)(66556008)(66946007)(8676002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 600jRUfqgCTI2c6Ho769k3hGzzYiaAj58p8BFOh6BHAnT9+D6QX6CiQ499Ppu3gLajxKp0e1gkbeJzbNxgsCA/+G/qhlo+eW/S88Vtu3P2QImIWK/2g6HSnY0BBcr5NbVZgCaaYeKZJxIrCYyudrpNpQuz2deAbv54kZ7GwYBeEoIiaro7SM6wJMM0iSDroY6MzeDLaucCVwxXrAKaK63Ui0BkNw8cgk2klfHH0CJF9tftwfd0cCMYNZitVj1+4vOgP2difskZZq2IKby6REOh1V5zdCP/s+IGlmGdPAKl04d1xUkx6E8DH3biLNiUgHHxrloWZKvBKgpCHDE2YlVGLY/cIcpl5Lc/1sEGZv04Y1d6vXHyYfezzlSy1tQPOz2pysqcXxo8SdL27WKcW5xfmXtfGxhmC7cPtP3tEIH91s4TyIsn48ktrZYuUNJQ4q
X-MS-Exchange-AntiSpam-MessageData: ufK1vMWRyB/44KNNSpjB/jhfVKp5t27AvWh7xMFZi6X4n6qodLmIVKi8WfbqghcHoviO3CorCk9woLvSu+h6Sam+RPtRoQy23CgzjwA9BtpNtlhyLzrl2PV5/AXRNR9vsqGo/A/bfGuEpDelF9iXP3e85VlD5yqLpkcQVg7dqbkooDt1HLMQtS//SUnrOOtwUqfOGcXZIR+zRD75mdN4Rw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15edc619-b49a-4220-da85-08d7e7ecb767
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 01:13:37.5437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8RNmHpFvXvJXp22GIDTA7zRQIYyUD0aXkjlcsdABplJaWDMcO8P8vbIKMigpuERy6bTGE/4ZndOBAFfaGJhHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1894
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Boris,

On 4/23/20 10:33 PM, Boris V. wrote:
> On 2020-04-23 13:54, Suravee Suthikulpanit wrote:
>> Boris,
>>
>> On 4/22/20 12:43 PM, Boris V. wrote:
>>> Hello,
>>>
>>> when running qemu with GPU passthrough it crashes with 5.6 and also 5.7-rc kernels, it works with 5.5 and lower.
>>> Without GPU passthrough I don't see this crash.
>>> With bisecting, I found commit that causes this BUG.
>>> It seems bad commit is f458d039db7e8518041db4169d657407e3217008, if I revert this patch it works.
>>
>> Could you please try the following patch?
>>
>> Thanks,
>> Suravee
>>
>> --- BEGIN PATCH ---
>> commit 5a605d65a71583195f64d42f39a29c771e2c763a
>> Author: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> Date:   Thu Apr 23 06:40:11 2020 -0500
>>
>>     kvm: ioapic: Introduce arch-specific check for lazy update EOI mechanism
>>
>>     commit f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI") introduces
>>     a regression on Intel VMX APICv since it always force IOAPIC lazy update
>>     EOI mechanism when APICv is activated, which is needed to support AMD
>>     SVM AVIC.
>>
>>     Fixes by introducing struct kvm_arch.use_lazy_eoi variable to specify
>>     whether the architecture needs lazy update EOI support.
>>
>>     Fixes: f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI")
>>     Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 2 ++
>>  arch/x86/kvm/ioapic.c           | 3 +++
>>  arch/x86/kvm/svm.c              | 1 +
>>  3 files changed, 6 insertions(+)
>>
> 
> Yes, this this patch works, there is no longer kernel BUG.
> 
> Thanks,
> Boris
> 

Thanks for testing. I'll clean up and send out the patch.

Suravee
