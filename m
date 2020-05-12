Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3431CF81B
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 16:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgELO5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 10:57:33 -0400
Received: from mail-mw2nam12on2066.outbound.protection.outlook.com ([40.107.244.66]:6113
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727912AbgELO5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 10:57:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lryK61l0MYRJn6Os1tOQjjIPayBmarFDKw8BfUJuTEo73F6wvfzJHFaj69XR09Ose5a9S0Cyn1xQux9vXvsd9JUU14g/4DcYF9egTDa7VdtUrB4eg0+vqbEK85A/QzXN1j3mC+tVGPcykvq7rzs2OCUOIuumsIv6VY+du3N1g8UwpZXwgnOdyMP33g19MVCOMt/TYA1FHalujvs2+FVOMOiIUvbTIj1bL193FKkUoAopg2HVsOo05KMikKHXLru8Wh0frAMMjrXoOT/yyhyo8P+JoAAtWfcGEUAQbeaQB4SFoluFdCJDwKjPQvdT/BNdWvmA7/YCxOFavZif/EG4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45kUihFBcKzUIEY5cQJg2vbdD2FWx19PEoaMCMuONYU=;
 b=SIJln10/PJlQIFpIWFUrrSn9NONvdfSTq73cWSsPROrgGP7DE8FKmT1bz4mEAZrD/RBQCc3qR86uYtFDsh6fsGUkvjvTJjOaLh/ajm3lONipS9a8LBEOMH18T0/8Y9iHv/AgIgDdJqh7z+o56L4Sn/7eHW5ob8krJxvp8DC9D/P7yh3OJ2f2eSb4ux0Q+wRc0RaylJKg+6QU/5rGEYKg25ZILORnSadtjnV/KRMqBnlAsaaMk1Z2lH/9k2oaRS5YY4m2Q88ZVHeYUDvFtc0HJo5vb17/tMNRYau3qm3bDSXs2pN2Y0EG11l3koeVUWy/6u24QmMH4thM8OyWfT8Jeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45kUihFBcKzUIEY5cQJg2vbdD2FWx19PEoaMCMuONYU=;
 b=ppBOIlZgtSUI03cbLDHu+6OWoP2PggQYk8xxlXmx49oEd2p0yC7EAOhbmtWMxYm20GruMJ9c66M25OYeV9uIMgL8ElEap+5RSY/tXMjKH/MjtYfLBr1yis8yTzvUSqt9hH2Gh7Js+pqder3go5/qt1TBfpP12HFOI3g9jITfJsI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2398.namprd12.prod.outlook.com (2603:10b6:802:26::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 12 May
 2020 14:57:27 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 14:57:27 +0000
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
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <4984c0af-c20b-7084-9bca-5cb6bf385180@amd.com>
Date:   Tue, 12 May 2020 09:57:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <a92f3247-4b1e-0ff2-c1c7-68c149c0142c@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR13CA0071.namprd13.prod.outlook.com
 (2603:10b6:3:117::33) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by DM5PR13CA0071.namprd13.prod.outlook.com (2603:10b6:3:117::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.12 via Frontend Transport; Tue, 12 May 2020 14:57:24 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 183d97b9-845d-4c5d-2c6c-08d7f684c95f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2398:
X-Microsoft-Antispam-PRVS: <SN1PR12MB23981811F49C42166EA9970F95BE0@SN1PR12MB2398.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9o6XKi8fHmxmIrtYDrT8Q8DxXysEBEvKqG1CPsSy7jJFo/0assEqhfGIgoB09WIUuuwz1lv2rUimB/CIsSplH8nALwbLaYw3/yhKtKcn53O3BVHnIDiUY2L/kXIc95vpWvEGUFGN8vbEtEciPB3rs39JRi7yw3NJSwgGbwz7Ta31jJgu1coJKc29i4zyh8cXoRIAmmosJ31GIpFstCutp+t/Mei65uNe4wWkopusf7TDyEoZ3KyOZ6wIIHcAQOiENfHhnRYfqTQxPCl+PgpQlOGPWZu7RaWUEQlIGjhXwhNJNXRdiKkHQ52BkDt3B+uhEXq3KJtABxtS3UWxayEu/rXkxoIxQzvo9yBQGKdbzkic4P9FJwtggtWv4PQFOblLRGHYuOYHJgWSZFrlNul2ekGrP6zLtrTtPGAvt8L+IR33YvwuPO54xD7UgR5K18SSmGK7HQ3BekzlOnYaJrJ83DvM78zI/pD5eRTHL1sHQjMSN5BAeI3YbL6f0BRuPucoPmPZ1COecKv26/CvsZSNJ58reCldiO3t6CG3bPy2mSNsfCm++W86ooezsofzfwJ2RjfT5W+snvAe4tkV3ipJnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(33430700001)(2616005)(956004)(31686004)(33440700001)(36756003)(316002)(2906002)(16576012)(478600001)(5660300002)(8676002)(44832011)(8936002)(6486002)(86362001)(7406005)(26005)(4326008)(7416002)(186003)(53546011)(31696002)(52116002)(16526019)(66556008)(66946007)(66476007)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JDRYRp03iiyUJgdyb6F7kSZJ9/xxM0CzlRXMPZRXo2wBa5ROAQ6lPhmcZhPBKR8EpETJ2RrJxCAPLSJFzL1PIspqc32S3TSyNWec3eC4V0CIZ2zp1JCLh2yXTypJ0JTyANvam5vvRMcJfrvTyFH79bBdj65B5vSy4ri+bWTpxZoW4f1FlY4LwiisPgBe6dXlI+RjAL0DgwC53PGtV4sNTwmKmGbbHQUBg0cbnzZH+0kY251rJYs2OKPUL14OsEK2OQsQvrLCBzh1bejdUEMDRA9BrrAhyAsTsZ9wyRbuAPjYpp83rZFgNqmIUlZm/EjZ0aR+KKxVOldSXMzO4WdcUTBWf1hCid/OsypF8VwH44LF+jhc2qheUCFgWq5m/90ItWShGsPUvqd3IovU2FY9N3o+lWnalQ7sVmHH2xP3GbrQwIn0e4lkdBJw4lqtcsHjmRJl6556qO+o4OpEGOtRySrhyPggBwwxt565Ncl/3/8=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183d97b9-845d-4c5d-2c6c-08d7f684c95f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 14:57:27.5135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3QstCMLwWZpcL0KBrwXS++mmoI4Aqg9wl0G5VgbzKSpfdQkFoaSLCxgsoMZuRKg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2398
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/11/20 6:44 PM, Dave Hansen wrote:
> On 5/11/20 4:32 PM, Babu Moger wrote:
>> AMD's next generation of EPYC processors support the MPK (Memory
>> Protection Keys) feature.
>>
>> So, rename X86_INTEL_MEMORY_PROTECTION_KEYS to X86_MEMORY_PROTECTION_KEYS.
>>
>> No functional changes.
>>
>> AMD documentation for MPK feature is available at "AMD64 Architecture
>> Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
>> Section 5.6.6 Memory Protection Keys (MPK) Bit". Documentation can be
>> obtained at the link below.

I will remove this text. This is not too relevant here.

> 
> I was hoping to see at least *some* justification in this changelog.  Do
> you think having "INTEL_" will confuse users?  Is there some technical
> merit to this change?
> 
> The naming churn is an obviously bad, not technically necessary change.

Yes. Technically not necessary. But can cause some confusion on non-intel
platforms.

> 
>> +config X86_MEMORY_PROTECTION_KEYS
>> +	# Note: This is an intermediate change to avoid config prompt to
>> +	# the users. Eventually, the option X86_INTEL_MEMORY_PROTECTION_KEYS
>> +	# should be changed to X86_MEMORY_PROTECTION_KEYS permanently after
>> +	# few kernel revisions.
>> +	def_bool X86_INTEL_MEMORY_PROTECTION_KEYS
> 
> "after a few kernel revisions" is code for "never". :)
> 
> Could we put an explicit date on this, please?  One year seems roughly
> right.  Or, maybe "after the v5.10" release, so that this will approach
> will make into at least one LTS kernel.
> 
> Maybe:
> 
> # Set the "INTEL_"-free option whenever the "INTEL_" one is set.
> # The "INTEL_" one should be removed and replaced by this option after
> # 5.10.  This avoids exposing most 'oldconfig' users to this churn.
> 
Yes, this should work.
