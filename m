Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A23280A65
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 00:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733221AbgJAWob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 18:44:31 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:21984
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733140AbgJAWoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 18:44:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G38AJxi8ZkwmhILExXfQXJ8Ooybhs8NeRWbndf2X5KIQj/mGz1DUEppSDVeVE5cI8yXtJSEpoHT9Wt93sz1QTxPXyb+2CTIuXR2OOG9FxEWCSuMLj3K9E95j1Y0J3vUrd9v1dza+RTKC+Y1u7wuBJUKwZsjHgz3KQ5/KsarU/JYdFdhChfL4i2modfHcUwNgXGp8p0/N/TotnGDqQwPqkvrl/Hm+QLyoATDJ4pxYJYpGWbDMNgn3WicMy0UOmzCJ09/ZuAPNGBeapd5KShhOhgCukByIbETJo1PHDhGha3i3x9WwHObqnTiK8tlk6+SLFlVqjOwF0YnFXs6s6Yppug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEf+g4mo8w0D7XEf1cNEBHsUvG2MK+XzzJpAg645/b8=;
 b=IBJ5opz0O8wxNmWfU9JUbPZDUU0d9bJY8L0XoLgtTRjEaWZgoEgX5R6iHfA0OZ39GVW/ixUY1WLsWwIW1dOOL9mI3blsByAd+mufVPaMtTpB5X55jxuYNi8m9crle7HYxOu/cadJ/45YQv6xFycIvr/kNpiLmsg9j6XgNHA5/mF87hR7dpELPpxUeSFE99AygjqcFpv9sYq4CMTfC3A9ABaSjr3KmS7hoeDz0dC9LEms0Q1ukAuXRXZ2JlIWALbM/SsMMA4pf65dng5Kb4cXHwNi17liwtczXxelX/2bOcL/6dMmEMSAUSyjZS6ZZZnwp2kN7YI62rDUOClf9dPPVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEf+g4mo8w0D7XEf1cNEBHsUvG2MK+XzzJpAg645/b8=;
 b=ZXxnp6t/YxDRquY4idTdiS24BWvX4DF5YPcc6KNNEkK453VbDTHvTlpU/Vm7mNYAYKF2mOVtaZVcbThb0d2T7QMOl51xpmxqdF4uMi4n6DfKpSkIRNUwSK5kxBAiMBUD2LPvsflXoVIW40b6pg4gQpIC+kt15uReGNQkL9SQqv8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0217.namprd12.prod.outlook.com (2603:10b6:4:54::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.36; Thu, 1 Oct 2020 22:44:26 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.034; Thu, 1 Oct 2020
 22:44:26 +0000
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
To:     Peter Gonda <pgonda@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vipin Sharma <vipinsh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tj@kernel.org,
        lizefan@huawei.com, Joerg Roedel <joro@8bytes.org>, corbet@lwn.net,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Grimm, Jon" <jon.grimm@amd.com>, eric.vantassell@amd.com,
        Matt Gingell <gingell@google.com>,
        David Rientjes <rientjes@google.com>,
        kvm list <kvm@vger.kernel.org>, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
 <20200922211404.GA4141897@google.com> <20200924192116.GC9649@linux.intel.com>
 <cb592c59-a50e-5901-71fe-19e43bc9e37e@amd.com>
 <CAMkAt6oX+18cZy_t3hm0zo-sLmTGeGs5H9YAWvj7WBU7_uwU5Q@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <cc3e88df-0c6e-2a8c-80aa-4dc3f0d8cea9@amd.com>
Date:   Thu, 1 Oct 2020 17:44:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAMkAt6oX+18cZy_t3hm0zo-sLmTGeGs5H9YAWvj7WBU7_uwU5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0701CA0034.namprd07.prod.outlook.com
 (2603:10b6:803:2d::15) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0701CA0034.namprd07.prod.outlook.com (2603:10b6:803:2d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Thu, 1 Oct 2020 22:44:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 092f4174-3efe-4de2-e408-08d8665b8cb4
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0217F0D9BC885949104CE1DDEC300@DM5PR1201MB0217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umGVjkEbdPhLngpiKJnfo+2I4qeDHVf9Bx+jGtVkyDS3c7g8H/V71Il9IOL2J2Gm4OHdbpPtkONND26s5fZSEMeNpaS4O9VrpzjIXHDiguY8LGHiE9jBRU7kjq2uVPw8dPzsHcyOJxt4Gu3YVp+0V+0WyeMmRWfzAlLM8maWN5VwDwQ5UZ7qRnT9MRcLvI0NNp90aYexF1amlT4zfJzxpFRi0Ba1w+c1fLqDZySzXp3rdHFVeNUhUrZbsq3W6+KvJJNsagu/l8RM1zbF1TTbdKb9a27xxWFvuP/NowPeGNZjpPEa4EPnE7jAOE8oOe5BgHPVGOjkU2oEUs8rzpVss4NedgH+OLvVQ+A3ulQ5stxoJfTaR0FH0zMpntsezoEn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(66556008)(956004)(31686004)(66946007)(8676002)(5660300002)(36756003)(6916009)(4326008)(26005)(6506007)(8936002)(54906003)(2616005)(316002)(53546011)(2906002)(16526019)(7416002)(6486002)(6512007)(52116002)(6666004)(31696002)(478600001)(83380400001)(186003)(86362001)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UIyvNao9ceFWKNcVaICUKHavdo+4HtJW20MQHFmiBYQgmH3qdj//kKKFIZRjWQoew357Ga4/xv9KqIbt5D5nS996TD+BOjfcvbacpijZXhC482mf6hGGZ10P4DxtRWVKJhnscS9S4v6uZ6bWHOtPdnKGjuYk9LfUvJf8yV5U36wQA7toKeflEbkjz+N7VawiUX7RPof0evqx68SYsvHrfBj+2dwI9jM91+wzf70zjoDWLM1B8CDyFK4SZfju0uENI2otmmCvUpVJNz97/dPyD2aEBCa9XEvYaGKtRKzkH+v+Tm6cEk5e3ddiFMUJpD9z1HEkDx+7Gk0TIoNL4kb/cVR6jLbaYXt4yP9itoP0oHeF0jVgjql4Vc3P3jTTGkPVO9tz0LyMyBM60jhQ4Sa1wrV0l4r5meUl3fOmxqdmImpoiVLU7ZYp4JWfTRZSh6T2vWPfPAkqUTHlVpnXHajOdH4Jy95wNUEXYPnYkCxdXfAwA/ggiEzG0IQL6GOaLwAgVtnJYS5XwqGGiuLQFoBj0ifAakA4bMXx2pgan7M+LjscDyWLEx5BhLbSQ7JdgdaVfhvSlNi5dhfFTt+r0byRhquCwd9w07wvLzxhm+6U/4ecZjTr/JhPFpfXNguEo/4H/y32tVg1mMXfvnKC/OOmYw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 092f4174-3efe-4de2-e408-08d8665b8cb4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 22:44:26.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: diValzkIfbK0sRCFGrYw7GZGDF04bmu589k/RlZpwrE+QgfqOOEtmAwSdSFnXZkbyCoVnyDnQj/oaYBb3Y5HZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0217
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/1/20 1:08 PM, Peter Gonda wrote:
> On Thu, Sep 24, 2020 at 1:55 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 9/24/20 2:21 PM, Sean Christopherson wrote:
>>> On Tue, Sep 22, 2020 at 02:14:04PM -0700, Vipin Sharma wrote:
>>>> On Mon, Sep 21, 2020 at 06:48:38PM -0700, Sean Christopherson wrote:
>>>>> On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
>>>>>> Hello,
>>>>>>
>>>>>> This patch series adds a new SEV controller for tracking and limiting
>>>>>> the usage of SEV ASIDs on the AMD SVM platform.
>>>>>>
>>>>>> SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
>>>>>> but this resource is in very limited quantity on a host.
>>>>>>
>>>>>> This limited quantity creates issues like SEV ASID starvation and
>>>>>> unoptimized scheduling in the cloud infrastructure.
>>>>>>
>>>>>> SEV controller provides SEV ASID tracking and resource control
>>>>>> mechanisms.
>>>>>
>>>>> This should be genericized to not be SEV specific.  TDX has a similar
>>>>> scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
>>>>> (gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
>>>>> would change anything, I think it'd just be a bunch of renaming.  The hardest
>>>>> part would probably be figuring out a name :-).
>>>>>
>>>>> Another idea would be to go even more generic and implement a KVM cgroup
>>>>> that accounts the number of VMs of a particular type, e.g. legacy, SEV,
>>>>> SEV-ES?, and TDX.  That has potential future problems though as it falls
>>>>> apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
>>>>> account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
>>>>> light of day.
>>>>
>>>> I read about the TDX and its use of the KeyID for encrypting VMs. TDX
>>>> has two kinds of KeyIDs private and shared.
>>>
>>> To clarify, "shared" KeyIDs are simply legacy MKTME KeyIDs.  This is relevant
>>> because those KeyIDs can be used without TDX or KVM in the picture.
>>>
>>>> On AMD platform there are two types of ASIDs for encryption.
>>>> 1. SEV ASID - Normal runtime guest memory encryption.
>>>> 2. SEV-ES ASID - Extends SEV ASID by adding register state encryption with
>>>>                integrity.
>>>>
>>>> Both types of ASIDs have their own maximum value which is provisioned in
>>>> the firmware
>>>
>>> Ugh, I missed that detail in the SEV-ES RFC.  Does SNP add another ASID type,
>>> or does it reuse SEV-ES ASIDs?  If it does add another type, is that trend
>>> expected to continue, i.e. will SEV end up with SEV, SEV-ES, SEV-ES-SNP,
>>> SEV-ES-SNP-X, SEV-ES-SNP-X-Y, etc...?
>>
>> SEV-SNP and SEV-ES share the same ASID range.
> 
> Where is this documented? From the SEV-SNP FW ABI Spec 0.8 "The
> firmware checks that ASID is an encryption capable ASID. If not, the
> firmware returns INVALID_ASID." that doesn't seem clear that an SEV-ES
> ASID is required. Should this document be more clear?

I let the owner of the spec know and it will be updated.

Thanks,
Tom

> 
