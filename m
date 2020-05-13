Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431B31D1A01
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732227AbgEMP4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 11:56:50 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:64032
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729467AbgEMP4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 11:56:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNorBVRuxpaD8D/LOWy+UnGuHGmnHRE2rdSfkw3FcTiPEZHtqXV2tJUiqPPsm9oVzLgryrqtORxQRCczTT1Cr+g2oc9GgxDQ+ojqpYevUGZbvC0wsZsB4yfpGwLCs6s2pgGm/G/wNpIiEWIlfPXtnZmXwRwTUBjf5B1U9JnD8kPFF/uNf9DF8B6qrHAeFwV3+z3eG7yW1zFIfP0AN5uaV45bMpqBGJ31LpeV/4fJdaABeCRRTd/CKdl2LLO4c3NhkRLXHMuIkaXS1BXqjBAJ3nRxB3ALmbPOvwBNjNtUWzcvxrS/eDKCv3KhZGpAYA3osgfOOyywWgBXKhJUYPHFHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhS49n2uFCWGKTNdzzouFd8NNO+6mwBhK3RuDod8mqk=;
 b=R37Ma1N/lGqh44iaIF5EKoE0+Yipt6czNEZe86u+/sw66N1YRTb5HPMrnN2h4S98ZCqXp3l9IUNuzVLQ9xPS9V/3Pd2UIEI74i5mGzwoldf/pdnoZzXil2yxzVVr9NAZ8oRoz+VLOC24/k0VmOmGs+IY2hHlAMrD1sW/6eafp8OwDkowKvTVlWMKz1fz2JzumBmUdwgqxA60Jl5SHl8nhXUaUgJGbiTvb6RutVenWOkSoSGGMPb/0auLfbT+U2IRb5zmcmSTYK5+SYjmlBC/jo1liGm/gWRI3DSOKWOIouPPWA5CRekIZR5db45hMvUZNF+gukNJszl7KdXyx0BQ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VhS49n2uFCWGKTNdzzouFd8NNO+6mwBhK3RuDod8mqk=;
 b=vvrW8v2mk0KvjGR3Ys/btALy9rNa9dh8SR2N4ZyWH9sf3tH81DXaUKS68d9skzFt1DmmnX0uuKHmscjg1E1k2lyWBgiqWz8+pFwO1JddYlYfRTbbLKK8OPx02UqP9MnBuIHcdCvlEKYEDOzRx2cx3cPjVnuIT985g6EM3q+842M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1SPR01MB0002.namprd12.prod.outlook.com (2603:10b6:802:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 13 May
 2020 15:56:45 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.3000.022; Wed, 13 May 2020
 15:56:45 +0000
Subject: Re: [PATCH v4 1/3] arch/x86: Update config and kernel doc for MPK
 feature on AMD
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
References: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
 <158932793646.44260.2629848287332937779.stgit@naples-babu.amd.com>
 <e8dbb26f-9358-cef7-aae2-14d8b5700245@intel.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <e96a653d-bd13-ed25-81e2-b7301d7f92f1@amd.com>
Date:   Wed, 13 May 2020 10:56:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <e8dbb26f-9358-cef7-aae2-14d8b5700245@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:806:6e::13) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by SA9PR11CA0008.namprd11.prod.outlook.com (2603:10b6:806:6e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30 via Frontend Transport; Wed, 13 May 2020 15:56:43 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 44fa5633-fb19-4edc-a8ff-08d7f7563c5f
X-MS-TrafficTypeDiagnostic: SN1SPR01MB0002:
X-Microsoft-Antispam-PRVS: <SN1SPR01MB000254AC8423C263F8A4D7F295BF0@SN1SPR01MB0002.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fg1tEhyoYeZbjg9OgGkLgfotIb+SFsdTSQ05EP22spNSZ3WFo0dZmDXGIoelXYkffZEQ3Bzw4u5p+wXg7yoLxpk8wNjdRgHAvy5lPsn8x1GudZbPOCI/OSqxBoATRSVNQ0ngI2mmQiy/3zQ3TA3KKtkOi9HNHO+iEaMeR5JsK5dZcMURHJ6ArhfgcbOwZIINmEnOweCLkN2By1mc+OevhjGHu8n6FcmVMbQXnEkvcANiF5YvqKVLy+jWHk0i7LUv8n47CrsMvFTkTmIMATDAkqpqq9DmaZOiQQHpLTcThIA00KLVcvTK2rWYfVx8UqMfOJ+OY2IFAaC5OmZPAtitsmsoKrygFEbpcqtcKVB5tEyWmEsp6IdsqK/7Nev7E+2DLaJWG3JzupFCnAGDnPvFBTXwTc/5JQu9YhrG9pSOYnIMvB5KtKsl5Xgy0ODY0k2Gwe1sRY/dipHgnat0UMR7xh+Q/nPTf9bPCTZ3F2Ry6vP5mwobVOoQJoXJtjjDONMY8i6X5yExlPGEQpVetL2G/TluYA0wb6OlYFhwuBfnP8Flo0VGADb9mXtmflwSaanr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(33430700001)(5660300002)(86362001)(31696002)(7416002)(33440700001)(4326008)(36756003)(31686004)(7406005)(8676002)(66946007)(2906002)(8936002)(956004)(66476007)(186003)(478600001)(2616005)(52116002)(6486002)(53546011)(66556008)(26005)(44832011)(16576012)(16526019)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Fwh2/ENBXWiEVhyjGfwwydXVXYgjB/miHZdIalQslalYArXkKiYKC63i8avZ8o1+L6DOh2g6wqNE/mQs/JhJTA1SgXR3oiMSgD8K/OQPeeB57FJ66NdQoFINW8r9asiuDUhVqavTqQ0N5zkGm/mG3aNsh0N4q0oa1DMjqrTWSzY8z2wPsjKBsFFx/+26l6/SlrWEmTO1jeSPJskXTYt+xKhmV8/Ob90CGw3OYZ5b5ueQwBdsGrvgM0oOcv8Kp0ooYxbKWER1KPZYoRsllo7axbYfy1wAeRIbSh/US/06jkPLdX4iymRJbc01nfvDjnkf42S+BT7SgPmHhpAoQP/C0/w6JSNNNeASKD4G80DIT31Aog++iW/2o2sDV8dvQI0pN5ix63WBynf6UllIqrSK0myJbBOq6UWfqjiXQQO4Y/tuhA1AHBYXihWxSKQGi+ZBKkxm6EoIKu8wLI4SsEt4aCS0cL7deQaSdLnS2MQc7kE=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fa5633-fb19-4edc-a8ff-08d7f7563c5f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 15:56:45.2672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6OXcXNgaPlYbF0V0Snz9QIH6sNjaih/zvz56yamlpdD1XGwMPEZt9BPNIbdlMRkd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1SPR01MB0002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/20 10:09 AM, Dave Hansen wrote:
> On 5/12/20 4:58 PM, Babu Moger wrote:
>> +config X86_MEMORY_PROTECTION_KEYS
>> +	# Both Intel and AMD platforms support "Memory Protection Keys"
>> +	# feature. So add a generic option X86_MEMORY_PROTECTION_KEYS
>> +	# and set the option whenever X86_INTEL_MEMORY_PROTECTION_KEYS
>> +	# is set. This is to avoid the confusion about the feature
>> +	# availability on AMD platforms. Also renaming the old option
>> +	# would cause the user an extra prompt during the kernel
>> +	# configuration. So avoided changing the old config name.
>> +	def_bool X86_INTEL_MEMORY_PROTECTION_KEYS
> 
> Hi Babu,
> 
> I made a request earlier for an end date (or version) to be included
> here.  I believe that appeared in one of your earlier versions, but it
> was removed in later ones.
> 
> Was there a reason for that?

Dave, Sorry, I misunderstood that. I thought we probably are not going to
change the sources/makefile(ifdefs mostly) as it was technically not
required. Now I am reading that we are going to change that in the future
and just keep X86_MEMORY_PROTECTION_KEYS going forward.
Sure. I will add the text you proposed. Please feel free to correct again.

> 
> I'd really prefer to put some kind of expiration date on the config
> option.  It will outlive us all otherwise.
> 
>>  Memory Protection Keys for Userspace (PKU aka PKEYs) is a feature
>>  which is found on Intel's Skylake "Scalable Processor" Server CPUs.
>> -It will be avalable in future non-server parts.
>> +It will be available in future non-server parts. Also, AMD64
>> +Architecture Programmer’s Manual defines PKU feature in AMD processors.
> 
> I actually worked pretty hard to make that sentence useful to Linux
> users.  Instead of forcing them to imply that it will be available on
> future AMD CPUs, can we just come out and say it?  Can we give any more
> information to our users?
> 
> Naming the AMD manual in which the feature is defined doesn't really
> help our users.  Let's not waste the bytes on it.
> 
> How about:
> 
> 	Memory Protection Keys for Userspace (PKU aka PKEYs) is a
> 	feature which is found on Intel's Skylake (and later) "Scalable
> 	Processor" Server CPUs.  It will be avalable in future non-
> 	server Intel parts and future AMD parts.

This should be good enough. Thanks.
> 
> Any clarity you can add, such as to say what AMD is doing for server vs.
> client  would be nice.
> 
> BTW, when I first submitted pkeys, I didn't have any statement like this
> in the changelog or documentation.  Ingo, I think, asked for it and I
> worked with folks inside Intel to figure out how much we could say
> publicly about our plans.  A similar effort from AMD would be much
> appreciated here.
> 
