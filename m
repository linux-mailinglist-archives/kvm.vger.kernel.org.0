Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B852779C6
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 21:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgIXTz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 15:55:26 -0400
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:53921
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726210AbgIXTzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 15:55:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOUwXV6qdrkR0jfpdzSriJ5SOCMpIs8ZYzHBUEoqcZ2TrSzbODugZzNVtx84vtf1CNOXY6BkvDCyUWUmnLmNMQT1xVegkTGqqPhmHgEzr7zH7WtFySWc28SeNHs/YBGN8VOeNOrIbLM0beZ/moVMKxQEchVb9fJx6LqerB0cmtHJD81s2z3kPwIPAtZ8e7m6Cs0pyAiVszDZJQBSGOTt2+jZXUEiNgqt8DaUa1a+TC7pbT+BlxJPOIWXMKbbGu5pPnaupSMbfMeVxxFKUNA7A/6MGP3H2C/ay6KTaIs7H5snu2F25AZbWY12CwIKXeR3s+gVQA957mEwTQhnt3TGHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7UsubZXg6mj4POG76N8fBLORLqTy1tMWbSBMVsqZjc=;
 b=P7fqpWIaQ6RThZ3zCFePnrvj3Vk7qiUjilUQLTTWuK/RuYStpLvb70TOeSJFLcGToGB9JK2ApkuEwIf8vsN00SnfOAkhJwhZAFaUxF08vZivLe9MZ+T+1KN3mWg0GF6cQA3OWEp1QHZyoDxthjSXS5CseoRNV86RMKf58d81Tncy6OBYOuQlU8zMxcuOMU0IzTph3Ccw92BaIq+yPVGJSPxK9JWBqdBk2VEu+az4sYhAw2h6HxgnR6lBpkqQK1XI1pDIggsbhmWrsh1DuuCQafD3m4S8BB6hcczAfycZjTyK1DVC+TGgOS1X0Py/HTUKKuLtO6d24dWuUCvRiyRDzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7UsubZXg6mj4POG76N8fBLORLqTy1tMWbSBMVsqZjc=;
 b=CghLWnKR5Pccxu1UMlfbcFLUu4tLtpyBtQcGsQYeWjDvcHDh7LWnEQmqce4PzQsd1TbbXYkkeVGrfgPDb6bsuRdm9cD0+5Sk37jQcXrpnA8qN63Gk8bStURTJ4LWDLi5DQJVgtMdNDLgynW8IjlTQBOfY9EeIDneo2zBOAFXq/0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.15; Thu, 24 Sep 2020 19:55:21 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Thu, 24 Sep 2020
 19:55:21 +0000
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com,
        joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com,
        rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
 <20200922211404.GA4141897@google.com> <20200924192116.GC9649@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <cb592c59-a50e-5901-71fe-19e43bc9e37e@amd.com>
Date:   Thu, 24 Sep 2020 14:55:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200924192116.GC9649@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0055.namprd05.prod.outlook.com
 (2603:10b6:803:41::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0055.namprd05.prod.outlook.com (2603:10b6:803:41::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.17 via Frontend Transport; Thu, 24 Sep 2020 19:55:19 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 565dbe4a-ac68-4b87-5cf5-08d860c3c4a0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB45162EB4D010AEF9A909D574EC390@DM6PR12MB4516.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sVk8n0wnecpj4TIOc73Jg7A1rMd+dddhaynMF3D2OnN9fpc7rVPq7cPE4jOYiUzEXwnCq9MWZbIqoGLE6ulbz2RZBowIY4SmZwKOGkKiqP7M5aaDRu5x/m7T2Alhlv4aBwwQcURmWJy52sPfxtD601OIPRfafR+Tjcvr4yiZMbxmPAmgU48SaMnaCKWiE28bMne41dJbPqp/dgngYD4tskKif/Eg90z7QfzxulE867rK3bO2X5yYt/vsfrWZh4HwDa0gIQUYmiB/FEp6WoF1Aryjewmw0JoJDW89R1u0DyMHH9zrHjgQbH/oMYO0uXAeSqxfdQDe4x6VACzZ8uP4w/a7NDUiZ4mr/22WrRqwFuqGGhsKo6OgKyqHjd3vBFwITANtn3vI2RfrxAFlBJF6cZ3Xqi0oPzH4v7DEwpFdE2UJJciGMnFSrztW23gyDpNK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(66556008)(6486002)(6506007)(83380400001)(36756003)(53546011)(86362001)(316002)(66946007)(956004)(31696002)(186003)(2616005)(16526019)(2906002)(5660300002)(110136005)(478600001)(26005)(66476007)(7416002)(8676002)(52116002)(8936002)(6512007)(31686004)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: v/RpxGM9SUq8A1JVob1df8v4Kb5rHuWGp70uxxSWt7LnpYqqF9oE+D6Rv9CJUARYq1fzsX2AqhsDq09HDv9RXvEEFkgQUQkYFsw6kN0aPLNdXoemmFvNQhA+WqhlaRehIYv6jdq3oJugrWt7RhRQwRqLWgTQ3W3NWpPkqkLCrs4PiU0eD5V131vk1r0W00U6Cemc7Go7UNz16hqPm6VdNPLKH+89WOA7z9bQiaSu0zpCW9OUwoAF1eAzpGYE4M9Za950n1TFoae1Hd9W5d2n7CpGoAkmE7tnnLNf6ZQtKptyUxe18EMaXkkEgGLD8mNheJOBGY2kFgkVaUicawGgnfkC7nGwW5CJtglG184AVweN0/nJ4pHopYofhP7yc6e3Rfzf2Jnumx49vLvWDpEpGKdVRBnlOcCTn30tugHWPW2Uulc0bkGS2jdt2YTcBphxeU4yNEhhsjeM5/fgoGGOI8MTeN9V2NpnHY9rXKYJULnTW8oM5zB6P6hTcLCq8IQezdsLl7C3dXwcazRWvwu9fcDp0pxuk2Ke+FB30+PZOQzZ+zVnsLfIVQz1gRKyghC9hFzeeTHYNP841iCO+YtkdQjDN3jmNN/RxZ4XU8ZLQvZ/9LDF2NZMG0loES54C6xLupE8EKLM0XVYEDMWBsE/5w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565dbe4a-ac68-4b87-5cf5-08d860c3c4a0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2020 19:55:21.0586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQf0QpxA2nHAof6y6pPTFCWpLo1sN9IYOg5v6XDMTPs10WeHxjLhP7w6R7QLRvvRqDJNzkpyNSuok+tqKpAlzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4516
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/24/20 2:21 PM, Sean Christopherson wrote:
> On Tue, Sep 22, 2020 at 02:14:04PM -0700, Vipin Sharma wrote:
>> On Mon, Sep 21, 2020 at 06:48:38PM -0700, Sean Christopherson wrote:
>>> On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
>>>> Hello,
>>>>
>>>> This patch series adds a new SEV controller for tracking and limiting
>>>> the usage of SEV ASIDs on the AMD SVM platform.
>>>>
>>>> SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
>>>> but this resource is in very limited quantity on a host.
>>>>
>>>> This limited quantity creates issues like SEV ASID starvation and
>>>> unoptimized scheduling in the cloud infrastructure.
>>>>
>>>> SEV controller provides SEV ASID tracking and resource control
>>>> mechanisms.
>>>
>>> This should be genericized to not be SEV specific.  TDX has a similar
>>> scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
>>> (gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
>>> would change anything, I think it'd just be a bunch of renaming.  The hardest
>>> part would probably be figuring out a name :-).
>>>
>>> Another idea would be to go even more generic and implement a KVM cgroup
>>> that accounts the number of VMs of a particular type, e.g. legacy, SEV,
>>> SEV-ES?, and TDX.  That has potential future problems though as it falls
>>> apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
>>> account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
>>> light of day.
>>
>> I read about the TDX and its use of the KeyID for encrypting VMs. TDX
>> has two kinds of KeyIDs private and shared.
> 
> To clarify, "shared" KeyIDs are simply legacy MKTME KeyIDs.  This is relevant
> because those KeyIDs can be used without TDX or KVM in the picture.
> 
>> On AMD platform there are two types of ASIDs for encryption.
>> 1. SEV ASID - Normal runtime guest memory encryption.
>> 2. SEV-ES ASID - Extends SEV ASID by adding register state encryption with
>> 		 integrity.
>>
>> Both types of ASIDs have their own maximum value which is provisioned in
>> the firmware
> 
> Ugh, I missed that detail in the SEV-ES RFC.  Does SNP add another ASID type,
> or does it reuse SEV-ES ASIDs?  If it does add another type, is that trend
> expected to continue, i.e. will SEV end up with SEV, SEV-ES, SEV-ES-SNP,
> SEV-ES-SNP-X, SEV-ES-SNP-X-Y, etc...?

SEV-SNP and SEV-ES share the same ASID range.

Thanks,
Tom

> 
>> So, we are talking about 4 different types of resources:
>> 1. AMD SEV ASID (implemented in this patch as sev.* files in SEV cgroup)
>> 2. AMD SEV-ES ASID (in future, adding files like sev_es.*)
>> 3. Intel TDX private KeyID
>> 4. Intel TDX shared KeyID
>>
>> TDX private KeyID is similar to SEV and SEV-ES ASID. I think coming up
>> with the same name which can be used by both platforms will not be easy,
>> and extensible with the future enhancements. This will get even more
>> difficult if Arm also comes up with something similar but with different
>> nuances.
> 
> Honest question, what's easier for userspace/orchestration layers?  Having an
> abstract but common name, or conrete but different names?  My gut reaction is
> to provide a common interface, but I can see how that could do more harm than
> good, e.g. some amount of hardware capabilitiy discovery is possible with
> concrete names.  And I'm guessing there's already a fair amount of vendor
> specific knowledge bleeding into userspace for these features...
> 
> And if SNP is adding another ASID namespace, trying to abstract the types is
> probably a lost cause.
> 
>  From a code perspective, I doubt it will matter all that much, e.g. it should
> be easy enough to provide helpers for exposing a new asid/key type.
> 
>> I like the idea of the KVM cgroup and when it is mounted it will have
>> different files based on the hardware platform.
> 
> I don't think a KVM cgroup is the correct approach, e.g. there are potential
> use cases for "legacy" MKTME without KVM.  Maybe something like Encryption
> Keys cgroup?
> 
>> 1. KVM cgroup on AMD will have:
>> sev.max & sev.current.
>> sev_es.max & sev_es.current.
>>
>> 2. KVM cgroup mounted on Intel:
>> tdx_private_keys.max
>> tdx_shared_keys.max
>>
>> The KVM cgroup can be used to have control files which are generic (no
>> use case in my mind right now) and hardware platform specific files
>> also.
> 
> My "generic KVM cgroup" suggestion was probably a pretty bad suggestion.
> Except for ASIDs/KeyIDs, KVM itself doesn't manage any constrained resources,
> e.g. memory, logical CPUs, time slices, etc... are all generic resources that
> are consumed by KVM but managed elsewhere.  We definitely don't want to change
> that, nor do I think we want to do anything, such as creating a KVM cgroup,
> that would imply that having KVM manage resources is a good idea.
> 
