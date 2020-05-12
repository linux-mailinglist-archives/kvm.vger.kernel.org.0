Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ED31CF988
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgELPpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 11:45:21 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:52833
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbgELPpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 11:45:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWdTI+c39W7VBIvPzLEXtHT6DE6CunTsB3myduoAd9Bl4jnf2xBXlEYPJtHcz7zA+V3pishKmsK62atIv0UMvnrtx52tnPqQ5sNOf/jnvJ00AKC4jvL4CA6d9ggRchmv+uA7V/8i72tGD68adGATFvuSHc/nC20kKen2brfmTJNSF7Mq76B3hm9vZWaLEwuXuOFZQTAJEn0LIbXyGMC6LmQTREZ2/rKEv5Tj/q1D4UADCKsDXNprsPkL0cyPY8ZaGqounEv/ropp38g28SsR73VPyW7XA6FefiMpuszhAEq25tDPzSTJ+LyCf4WmohvoVvLQDCDiL27B80CkxNOkxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcSef509fKbyFUVk59pAIdfbEmfGiVhViUBhVFwPUOs=;
 b=dakpq8oIC1JfXMOgktDTxL774yxexNePE8p9u3icQGp9DFpeQaAqAy2fiKClZlhEWknncBMImZLjNxoE+xNuNzLeG1GB0iRYoWqJC0lBy0zBh7AzCA6cENianTweaJrJuD79y2cKiIpjYZUK8wu9HhzcxvUZW/tpG67pQY2i/ARuk97EsTJ/OBKhaa7X54R+8GySz3nxAvz4rghXJNXE7pPcejg2pSwYFWwNJMqlroZn/mNonJrUq7XBR1mlr5T6RwOxhoWuA/XSykFOCyqiNlO+T3pYoEn9rjlout8ZO2BPqVCpHgv26BsvzpNoVq19BWYn2mqo4UbmJ4chAhJviA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcSef509fKbyFUVk59pAIdfbEmfGiVhViUBhVFwPUOs=;
 b=4NKot90jXlpx+r87Q4mVY7fpKmSBXPCPib4RKbEMRwVW3IuZZt93wMQuIB4fL7oOCpDZO4jg5mzEKveQLPyK3bT6T/5bwZ045e/Ek/Cl5ycfvuzqFYHZ37NLNIM1jf2g8onxXp4dJhYgu+x7UVvRtZz8AvisUZ5eWZneLStKFX4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2576.namprd12.prod.outlook.com (2603:10b6:802:22::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Tue, 12 May
 2020 15:45:17 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:45:17 +0000
Subject: Re: [PATCH v3 1/3] arch/x86: Rename config
 X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
To:     Dave Hansen <dave.hansen@intel.com>, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com, bigeasy@linutronix.de,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
 <158923997443.20128.16545619590919566266.stgit@naples-babu.amd.com>
 <a92f3247-4b1e-0ff2-c1c7-68c149c0142c@intel.com>
 <4984c0af-c20b-7084-9bca-5cb6bf385180@amd.com>
 <1f4fa674-5709-ad88-c7ae-1bf5584a5b82@intel.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <a77cbb76-8a68-59a6-942b-08b27f86fc04@amd.com>
Date:   Tue, 12 May 2020 10:45:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <1f4fa674-5709-ad88-c7ae-1bf5584a5b82@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0046.namprd12.prod.outlook.com
 (2603:10b6:802:20::17) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by SN1PR12CA0046.namprd12.prod.outlook.com (2603:10b6:802:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 12 May 2020 15:45:15 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 89347c56-43f3-4b08-f22c-08d7f68b77c9
X-MS-TrafficTypeDiagnostic: SN1PR12MB2576:
X-Microsoft-Antispam-PRVS: <SN1PR12MB25761F487C9F75B7A12F902F95BE0@SN1PR12MB2576.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fqzZMoQVuac/TQKNQCBgflzcbZ5rIlTZrnxraf4Yx61o28AaeJkcd3QRh4Tecr5dQvUUvhX9zSK2U4xMhY+KvELISr96LWd4LrYvqcgpF0n5+g5Qk/FjmzbmntmqUj7EBocEzI+X9XOJTAEwgPOM5ZRshxqvD83rB02X+tME6ydnGLjh6vjgP+xc7udfi+yuXxk7dqndybOdNhe9iGTErWGdKqI/IBdTOrrLmJwXrzIoUvTq9hPYl07IfAB3vbX3RIQCRmtqHir3AEpOMwnvcK+HJpMn5OqLhUAAuOkwPeJfkg+xmcJoY5x5mVwF2SjCmVy4xB38EI+avhNqnwU02agxsuOnQBg0muSyzr1Alfp3jjTBi8aM122jngddkvDA4QogvTXO/kGo4iU2AUN+dqCqI85b8zE4VPnCUUr5RphoJ3S9JdpdHE8CtONquxFePZswyda/Y0KWlCllyNOXUzEF76rSs0g/q2sjyCtHByBpQpH87jg+5A9p5gefG7lXVlledatQSpLSsWHz+WvX2BZD4yu7JgcYW+o1yGp0F3rxqI8c9aZ8kimID0Kz3qEmoVzM8A7pmfK/XQnP01YwiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(33430700001)(7416002)(16576012)(8936002)(2616005)(956004)(4326008)(2906002)(31696002)(52116002)(86362001)(26005)(316002)(66476007)(44832011)(16526019)(8676002)(66556008)(5660300002)(66946007)(6486002)(31686004)(36756003)(478600001)(33440700001)(7406005)(53546011)(186003)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wM/uGjswwTSvaNZVX7IuITWBd5SVXOzXGzDBg2+q3Oo1SmzLBDJmTvu8eNBfbwk0IeN7vQ4U2RpF/znHuVDyqdUvnzYzwAvf0s6UeuJQlmGLdCdLbBrztuGvRq/LGZtj9JjLglBpvBK8B1D1B1q4spZojChjPoHvz9yGFTwxlArTAN2M4r85Qp5wLzy63Vas9KbeDYLTT7Co98ZMhpNZgq001qgpv7kbSOSRy9VHfx1wbDzt/Oh1aUTxwhnpEEOb4jEqVhPfl7OR6IjCBwVAXvr3v41LsEytcS9AQQMdQYKxdEnG2J0OtLnYkV/NFiguTPvRQyiRI+rPFpZqWvSBxpMrQe3Q1CkSh8+Koki+O9hDd+hROnBoJi0HIiZnpD2hnK5m0VFVat8+atpTxfUiZowNguXl/e6rPCuq9bc0OUGC2H8fqvwXjkQAvaTflP1/9YjMEshPCgeMJ2MKO5PauO3IoVcQiV+pE3bC1Ck9yAM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89347c56-43f3-4b08-f22c-08d7f68b77c9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:45:16.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvfcxAxnlB4nGCi3dLfrXYqBWQ4QooAOG3t86wt521XmFPu08QRb7GJe7cWcCHUr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2576
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/20 10:19 AM, Dave Hansen wrote:
> On 5/12/20 7:57 AM, Babu Moger wrote:
>>> I was hoping to see at least *some* justification in this changelog.  Do
>>> you think having "INTEL_" will confuse users?  Is there some technical
>>> merit to this change?
>>>
>>> The naming churn is an obviously bad, not technically necessary change.
>> Yes. Technically not necessary. But can cause some confusion on non-intel
>> platforms.
> 
> Seriously, guys, this is buried deep in kernel code.  Who is this confusing?
> 
> To me, this is like anything else we rename in the kernel.  It causes
> churn, which makes patches harder to backport for instance.  That's why
> we don't rename things willy-nilly when we just don't like the names.
> 
> The naming has to cause some practical, real-world problem that we *FIX*
> with the rename.
> 
> I'm just asking for a concrete, practical problem statement in the
> changelog.  If there isn't one, then please don't do the rename.  The
> Kconfig magic is still fine since it fixes a practical problem for end
> users.
> 

Alright. Alright. I will just keep Kconfig magic and update the
documentation(protection-keys.rst). Thanks
