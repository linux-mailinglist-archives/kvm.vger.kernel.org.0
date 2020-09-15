Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E4F26AE62
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 22:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgIOUEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 16:04:43 -0400
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:3070
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727579AbgIOUEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 16:04:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBJijCCs6FAeVpdxTW9sPunVLWuO2dFbABJFbWKxkwAca/3b8FdAAQuJV999PtaawINdDIH8q4DKWYN162DBD6COrgoJU5y6RUCHz65M399eQpkPzr8qdqoc+LvZkTjhl52jKRcIqx94lw8u5q7CX89xGpMJAaMcq7u2HLz8Zt5O9S317h0lVdGkujnUGR1OlP8ITlgw4uMWXM7PFSMUc9DBP7s2glo9YoEibv5In9iVW9/BY0froKOQKxzYrsmpdZR8DarJ0LvvK5weMzUAWOA/GExDjrag91uBg/zJ0FPtqBxqfb0QjIesv5nePZnMAxjOgY1o0vOUJwWILMZUTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIcLQ76b0sXKdX8t+dTnS0w/Fby4nTAhi4weUo00+co=;
 b=hb7qo28G5en9lu3DvGBOrMJYgiiyer57wEb/fzT1Xh80/7I613kKojJzsXhOsu1MW1ur4CKbBCfqzlPrTicIWM/xBzldtRI2NTIC0yiNpEAjpGDHDDIpRF/kLPyxPWbYcJByTKQzsMLmCQCAEMEr+O5tJnqaWEJTkpOsJzcZFZvIfdM5OpZeT968n7Vz1E9mvy2+35EJKtHbfPli1g+/pFarbYFIZ6g/0siqG+I5+4tZ51GM/7uWHIS/ATtVjp/LkZEN+pCxxNrLPSRxm1DnFBo1g3p8lF+kGml1zorTLauQmKDv4zSDAuftAJ5me7hAc3xB6HxQm98nOOnDIB1A6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIcLQ76b0sXKdX8t+dTnS0w/Fby4nTAhi4weUo00+co=;
 b=cQs2ZqZjfrqPmfDWo9t51CUirPAyY4MQofBX6vzvpZtyz7joL+FVop9EvRQM9S4BonkrY61chEFhmjp9APbYZo8BrNmp2dgTborN4IcmR1qPwTqXBC0kFRKzrJ32h+XcaYwu+FXWQUOX7+hnAnIXIWWtS1MiZkd0bwqimZzrTXI=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 15 Sep
 2020 20:03:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::6d9c:78e0:e7cb:558f]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::6d9c:78e0:e7cb:558f%7]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 20:03:57 +0000
Cc:     brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
 <20200915173202.GF8420@sjchrist-ice>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <06d33abf-28aa-5f1e-2d7e-0b62e77e01e0@amd.com>
Date:   Tue, 15 Sep 2020 15:05:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200915173202.GF8420@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0201CA0064.namprd02.prod.outlook.com
 (2603:10b6:803:20::26) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0064.namprd02.prod.outlook.com (2603:10b6:803:20::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 20:03:56 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3caa7f68-6ca7-4272-d1c2-08d859b27ac8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43826B0D3A6398C7B1C3A029E5200@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mwxbj55g/FU/U+sdniE7atbo0tr+dtrblGi0SG6P69EmuIsW34mbcC6FiEsx+lO5rm4GQNCMC4ZBrVgTIhbZ56PupMm2Aurv9RndSHVsh3IUUGbtwfhd7fzeZ/HibOLNVftFBmzpfgmYSWDFtdZq6W6gk9eX6gP3/XgYaT9sjWfmkwA2Yu/JJFelb3hwCLOd9nLJ3/++GSvn6G4RhpK23Fs8ozTWNDwEv0TQRZmBpalL8WczR0S5b7xW0VcRSSkHsWOPxIwWF979XdMKdW6bCbDSuqUP8PhfM1O9CmH7NzOcrLD+1D+CMKmLLwOvgBKVksmiAMWYU+yOQ0QMyZZpArI2R1BdwdV1VeMkWKuJXIjySGhKAPow3ZEmiraqg3lhbgB25BhNrHwZJBqemLSH9CtYeYuLr+QsWW1uWdz3zodC07U/hp7fMf8R+5LZi/3e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(44832011)(8936002)(110136005)(26005)(4326008)(956004)(2616005)(83380400001)(6512007)(2906002)(478600001)(52116002)(6636002)(8676002)(316002)(7416002)(6666004)(31686004)(16526019)(36756003)(186003)(54906003)(86362001)(66556008)(5660300002)(6486002)(31696002)(53546011)(66946007)(6506007)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3cNVy7NRVhBkjlaL4y2jY3k8eRLdLaqKW1rap/QNst66VquZ3r9vd2cIVNgkc1IxamHO6xDgluisv51B7tUSZn3u0HYNkEi6T05oIC60XjNfsIQiaNicGOSQK466cPFJUarkVJplSRkUN3Z5JE/e8dT1S5fK2qkKD3/6r5vjHve+AiE/XZQe5emtNCaOsEImJdVaMwcto7bEKhjSSIEuICCABSwH7vmNpa6qqVkOMs3dOftVEcQRVIdUMKtXW8g+B5W9xF+eaSJOnAsFBhN7y0Sji1OB9YdK021itxEPlHNvVMh3zK2n5mZXtm9M7iWqZoCCbq+Db1bu+dPD0fStrMkFmfw/9pBZx3pQZHKkZ6nU56gzyuqjQ7K4ka/Jyuw4n4Zm//XQruGdYSYODA2j7WcDmEI7JTfqFGURYEZVXWqWxPa9LSTc1AJmCPiBEuNdRo0LDJ7+OXjzzNn1/M3Q6JMrF1gqkXHEs4T+T734k69xLyKwUEU8xbHUxbB95JNSn8+VCAGfYr5ipW4bBXCc/JJP6FYvGeA4qWIEiT2OUcbs1fYA9zTqgZHhezN6NYA/+Bz6tr5ECgJv00UrzoNNRwaNT8Nonn7kjaGr3eh+CyE7/vrI0hfdZzZWEfNytAerXcNzKku+cpmRRJS+Lbpmiw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3caa7f68-6ca7-4272-d1c2-08d859b27ac8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 20:03:57.5025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bycn4oeYtciZlt5kbYnYsKxFaww+W8WTsR8fTNhU7mXPR1ZZOQlb5gt1wcWR1EdL3WC3eGETxl11G1QhlO/AAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/15/20 12:32 PM, Sean Christopherson wrote:
> On Tue, Sep 15, 2020 at 12:22:05PM -0500, Tom Lendacky wrote:
>> On 9/14/20 5:59 PM, Sean Christopherson wrote:
>>> On Mon, Sep 14, 2020 at 03:15:14PM -0500, Tom Lendacky wrote:
>>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>>
>>>> This patch series provides support for running SEV-ES guests under KVM.
>>> From the x86/VMX side of things, the GPR hooks are the only changes that I
>>> strongly dislike.
>>>
>>> For the vmsa_encrypted flag and related things like allow_debug(), I'd
>>> really like to aim for a common implementation between SEV-ES and TDX[*] from
>>> the get go, within reason obviously.  From a code perspective, I don't think
>>> it will be too onerous as the basic tenets are quite similar, e.g. guest
>>> state is off limits, FPU state is autoswitched, etc..., but I suspect (or
>>> maybe worry?) that there are enough minor differences that we'll want a more
>>> generic way of marking ioctls() as disallowed to avoid having one-off checks
>>> all over the place.
>>>
>>> That being said, it may also be that there are some ioctls() that should be
>>> disallowed under SEV-ES, but aren't in this series.  E.g. I assume
>>> kvm_vcpu_ioctl_smi() should be rejected as KVM can't do the necessary
>>> emulation (I assume this applies to vanilla SEV as well?).
>> Right, SMM isn't currently supported under SEV-ES. SEV does support SMM,
>> though, since the register state can be altered to change over to the SMM
>> register state. So the SMI ioctl() is ok for SEV.
> But isn't guest memory inaccessible for SEV?  E.g. how does KVM emulate the
> save/restore to/from SMRAM?


In SEV, to support the SMM, the guest BIOS (Ovmf) maps the SMM state
save area as unencrypted. This allows the KVM to access the SMM state
saved area as unencrypted.  SVM also provides intercepts for the RSM, so
KVM does not need to fetch and decode the instruction bytes to know
whether the VMEXIT was due to exiting from the SMM mode.


