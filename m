Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DCA1C95F3
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 18:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgEGQGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 12:06:14 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:13181
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726521AbgEGQGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 12:06:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrETFDe0t9CsbGE81tBgBMiDv1XL1ezzFl8MBPcDdAnkYw8F5tsUpAQK+yK8wgw6qiRuy0udt+E0UaVkBcMfb61Ns2YIUqQ2LZMXct7JG10MW/tH3FVOMRFrQv7shfWwz+tGOBlS9UGdQc3Ruq4hUBYNOk6c1DYgcvwfv/G2f9aLi/p8/bIHYIBhDl53yr3hqF/VC4jQLJ9PY5EQH9KUvBWGKqn6jIldAXtXPn7ptgQbFQbqGRJrTsJ9TsI8e4qatfDCVg2NdL0xpKFN6XbCqjqv99TvSDHo7sVhorOUL4522JKbGtXIy7iYcsJpgmpJL+jgXeLXfF9qfOUMjWrJKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WnJcudjdFuKmDc8TTqYNQ7jPyl46XGxiucynLzxsbI=;
 b=ku+KbTGfIJc3wFh7kP/3gqm+yI0wWvL07/ejJTQpPeyCJtT0sBFdTN+Bdk6wEUmC8FKnU+g097swcjIywcqYJbOiq9qz2twfinE/QDwUWZSLcN7WcbYIZfV7RJ7uYz4zhFXidWYRR+WOJR/q0wMpqrYGw5me+7gHEGrhbil9OTjJNP9hTV0YfseSTDF4x6FxG5TabaPC9Q/bU9ff80JE14tG/xwzg1uw9klMWyvVYVVO8+fn1uqnBqnas9abH9ZK4gLTCOXgzClN4m6q4YXqYt8yFAhcxzF9vuSLnvCcCvC3X3MJj61xEsQ3sXy22whGuNR7cla0PQTGwJx1Sgt5qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WnJcudjdFuKmDc8TTqYNQ7jPyl46XGxiucynLzxsbI=;
 b=iTOxEfh1mi0HmZqYf5ztrg+HxOXQfEMGaROHvZrw9ZTrcJcmJiMUsfLB2u7tp6/eOEtOFxz7UTZmIVYUlIZr4V4qsNCFRnuKc7ntuD7QciYzBkd3j3IgrltcptEK6x0T1nSbt8MHjsYDU5FYlQrklMo/WzTKt7ZE5wtAGnDiFbc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2351.namprd12.prod.outlook.com (2603:10b6:802:2b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Thu, 7 May
 2020 16:06:07 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 16:06:07 +0000
Subject: Re: [PATCH 1/2] arch/x86: Rename config
 X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, sean.j.christopherson@intel.com, x86@kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com,
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
References: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
 <158880253347.11615.8499618616856685179.stgit@naples-babu.amd.com>
 <4d86b207-77af-dc5d-88a4-f092be0043f6@intel.com>
 <20200507072934.d5l6cpqyy54lrrla@linutronix.de>
 <034cfb90-7f75-8e36-5b1e-ceaef0dfa50d@intel.com>
 <1aca7824-f917-c027-ef02-d3a9e7780c3b@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <4ca2dd51-c30a-c400-146a-8079ac4526c6@amd.com>
Date:   Thu, 7 May 2020 11:06:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <1aca7824-f917-c027-ef02-d3a9e7780c3b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:805:de::28) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by SN6PR05CA0015.namprd05.prod.outlook.com (2603:10b6:805:de::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Thu, 7 May 2020 16:06:05 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc7b4888-ec4f-4a0d-47d3-08d7f2a08d17
X-MS-TrafficTypeDiagnostic: SN1PR12MB2351:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2351179C52CF36608F68BCDF95A50@SN1PR12MB2351.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iqud3NfCz8VSRnrDvKwTQN3vKyTSFG/4gLTkUlVlcV7uwbYWFUVTm9OKDn6pAwAO0q3px/u6EnTDH0ts4SQ1FR7aibLhOSt0geJwd5c7SisS4OySUVQeFkVkIw7ylkNkGHIU/WimvlLsbi6h8/RiuiCvyoQIlY+Qmcu80OC/aGnZrlioaoC+KPIyxm4sUNWONanMP7zRls2/WrxTdxWkLcU9oX2ZcIFG0QQHu0vU3ZepkKDf3qRsgF1YZaTXXdAWZcEf2aw/KGJO8jGplogaCHnkygl9OywH6WyhY/M60r91QEWFOfGalLUSbSxlZLs877RDUhNf273yv++XwENEhcUf7bzlrFcy/OiR7e50pxM8qJc+P8Z0gzzwslCQN+HbBtdCt4yPhGXQGU7YJ6d9dAwD0nIPROBr83liBJJ4qfpmKuu2DQGsvsVrJWQ1b/3TgE/UVMpEIgw9jwJjGo2WoY9bKGSo1RhGFIBiSWtTtgHi+7O1Ptau4JGlFZCqSGTcLXQqfNnoxXfGTUqSCLCkdvhIVnM/fwBkjsS7ChkirYxm+p4wdupg09EvqpFJX/Bpth3107pUr/96qYD0KfWHAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(33430700001)(2616005)(26005)(956004)(31686004)(53546011)(5660300002)(86362001)(52116002)(36756003)(4326008)(186003)(2906002)(16526019)(4744005)(66556008)(33440700001)(66476007)(478600001)(44832011)(31696002)(110136005)(83320400001)(83290400001)(83310400001)(7406005)(6486002)(8676002)(66946007)(83280400001)(316002)(7416002)(16576012)(8936002)(83300400001)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AurmsBcGsd0y/el6wyHtLka6KHmq7f+98Rf6Sh7aqZky5TQBXcBr0ynXI2LoUmi52djyDbZ6wKZ5/OKNXxCsAir5ko1HfdrBEQEgTISsl9/LkS8QCT+7RsloJMikwtbv9wRSkaF2kDhZYEUBPxGAjXQ+kli59xLJZHQGVUaxNNKN0fMTWzbhzSOZPE/M5ryLenzIc8rL7fyi7zHNEqgWdaeydUFAI8zvZkrJVczI21lN/B3lPb6gN+WjhWUrvqomDI13XEEjNLa10Y2XV1Hku6I235ZHzM5LxcNVug1/m8sKWcN2yaZnvDM3fexvyLI/tb4RPDkZjdKfQbSL155iyju2xrV9hpin3s8a2SaOk9AdUsxKDn2kfqpba6xzFAux0dtpcqlZdQ35y6AxNDSOaaiYXBDFjFXDB/Posz0Ua13CXN0mMS5K4z5WV5WJbvH564BeoQpVlhSeZhxnxGKL9ymSWASKaHT6++K19/8kaQUU9Q9cRb4WyM7lyREWFvxKFK1b9KtkD2E2atxxy6SyroDlPqANNj4AiH+DhXE/hjHutafLnTg9399s23k14UAFmtPsDwbdPOUQ6NHQM9qQiMy3H23C8vhwBeeX0+g60lJH43YSIG1RncrIsRf633ZrVxAbHZmSMFKYmf3EzQ/ydoJHsTCdpkWgShgW6bPLp4Y982rmmmCAYyfDaHN3H+YbRwpY6nEsLlKtdq1B036e+mmsCf1lSa6umTJe/liL5ooHLd1hkTzn4qquGFfZbPYqxvja7KGgBQhbM5hlbO3bzxGKJdnbjyY0pkD5Ipqbynk=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7b4888-ec4f-4a0d-47d3-08d7f2a08d17
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 16:06:07.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnmF0w4MDqXar9jmImLPx6TyVI/BTiSvCGwDhZItFbcaQsEMi0u/A/s6pnVotuy5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2351
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/7/20 10:16 AM, Paolo Bonzini wrote:
> On 07/05/20 16:44, Dave Hansen wrote:
>>> You could add a new option (X86_MEMORY_PROTECTION_KEYS) which is
>>> def_bool X86_INTEL_MEMORY_PROTECTION_KEYS and avoiding the prompt line.
>>> Soo it is selected based on the old option and the user isn't bother. A
>>> few cycles later you could remove intel option and add prompt to other.
>>> But still little work for…
>> That does sound viable, if we decide it's all worth it.
>>
>> So, for now my preference would be to change the prompt, but leave the
>> CONFIG_ naming in place.
> 
> I agree.
> 
> What's in a name?  An Intel rose by any other name would smell as sweet.

How about X86_MPK? Or I will use already proposed name
X86_MEMORY_PROTECTION_KEYS.

>  Oh wait... :)
> 
> Paolo
> 
>> If we decide that transitioning the config is
>> the right thing (I don't feel super strongly either way), let's use
>> Sebastian's trick to avoid the Kconfig prompts.
>>
> 
