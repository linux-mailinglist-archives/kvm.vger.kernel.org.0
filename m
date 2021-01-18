Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0248D2FA889
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407374AbhARSRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:17:37 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:63200
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405486AbhARSRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 13:17:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWsjm0H28H22VIl9ayDLXbr+QyI6aRxQ6o1ucLfdaENRz0RXRhKhQJ2VJ5xZ+JW6yQG0yAaRGQz+y/N7+ypLRnkk+1WImmleJDLurnnVOMvt6APfdaMrK2fYjwtxTlf4/Vt2eim47NqCA7NRuQJ0+VAooOUCCMIKbYEnXDLYNQyK6/9dqbv+iaBOJLByKup2En4FidRgxeNKum7BzvXpH5Akut+VEDgBLl4nfkeLdDS5pZmEtSeDj+dc2SewLMPv7gGkZyGYmaTX1l8bqJAuJqLoFRoEiu3ygxON9FBjHUTZVEXpZkHUjWlzcWvgqrKqm7IlGbtgjAag4nAO1zFEAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vk1INAZ7D84dX2YdqIZQJ/oTicTmefUYDKLXQF3DtCE=;
 b=KWRB66X4wXr3w1Y6Fm+pSHN0iSxGEmxlIpI08d/GUE1rB2w26G5vQzV20xljwq9DspcTsAM0fJY53MkxotKIQEwl0W+zflSpfcumbyN0rBwayftpVCZWivyXI7n1e6P67AGh4lRtzfxuG9ImgYql0rSMQ2S+0F9tEThc8JPRXh7klAFtfKYAGfm+E9gx1e2LkHRvHxFHz7PnnSsL0aPsUQecuG2rHO5FK7kyDsbWjq3kAQ5dCQXyqQIaoYW7i9SmCIFJlJncptznn+x1ZkJ3YUsAVmzJCvZiRWgDGXIqwF+vmHdgo1JShMaCunZM7wQpQKQaBuUNn+46gqZeNQL9FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vk1INAZ7D84dX2YdqIZQJ/oTicTmefUYDKLXQF3DtCE=;
 b=5iIU82A9DSozrzpzGcHE519w3hTd2K99l/KZ2EfIaDnnJecq1UECzL71jb6fUxl5UVcVU/SsdKEef13wSFg9oHNPogJ8LCVlAEWsnv2lhO7D0M6FusRaVhlR53hNT62LIw4Nyu+cRzSucrXKVE1N3yXaRME1MrHfxooFCKFEE2w=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3690.namprd12.prod.outlook.com (2603:10b6:5:149::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.14; Mon, 18 Jan 2021 18:16:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 18:16:40 +0000
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>
References: <20210116002517.548769-1-seanjc@google.com>
 <015821b1-9abc-caed-8af6-c44950bd04f0@amd.com>
 <2d795f19-2ac8-ea74-4365-41ea07f8eeec@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <efb0ae61-d333-2872-5a5b-9e22e2fab55a@amd.com>
Date:   Mon, 18 Jan 2021 12:16:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <2d795f19-2ac8-ea74-4365-41ea07f8eeec@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 18:16:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2534fde6-b16e-4839-3fde-08d8bbdd3372
X-MS-TrafficTypeDiagnostic: DM6PR12MB3690:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB369028E82661F630BA9B4F2DECA40@DM6PR12MB3690.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bVHCjUcb7CA8jgW0b92oCG5ljVpWAKOgSL2QmUTlSu/26PetSgPOQFBZ2ok88rzDIUZ5l1SbKmqQalLhTHMxiV+6/03nQzLZEyDNpfZTIawYQXi5iViJv3zBg3UMb13grZ54RoLzQ59xQMd31XXygRomVVwW4sCvyEQORylsf9OqfgHmhUJ+nmsDuRvnEajaULxBJCPnNBAjJGn/Twoqy6/xBtfWl2bUCaPd8MZN7F4dtM0rhPrjBFOB05ccs9uIvkE9ZpbsrFb1a1dodij1Dc9Iw/8HFMLLx14WzCProSh10ur2OPaN53NjQJEzx3sPw/8SRoGkKAy6ueN4ssxsxUTsdxR9AmEla8mZltZ7CJ5pl0nxZSsBlGSVTGk6M2BrXB+0MENvBkixLgESbTrDKt4jp/DEgb8zlb4ZMe/zD4pHOlRGPkRqy4z8p4+TmWOo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(8676002)(6486002)(8936002)(2616005)(6512007)(36756003)(7416002)(2906002)(53546011)(31686004)(86362001)(956004)(31696002)(6506007)(54906003)(186003)(26005)(316002)(110136005)(16526019)(66946007)(4326008)(66476007)(478600001)(66556008)(5660300002)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1FKZmVmTXZYbkFTMUd6cXZIM0dFTWhFY2xkMnhubGE1YjhzQlgxL1ZhL2Ns?=
 =?utf-8?B?TGJwbUY4TVk2ZzV3dE1ucHoxR3h5bnUvYzhBZStSVnMyOW03OTJ2QldRQUE3?=
 =?utf-8?B?eGtSODBYSU5KTXg1MEJQanFkRkVuMFVnbEYrR0U4a0hFQVBFM2dkdkVXMWpn?=
 =?utf-8?B?YklKMlFRSWd6dWN2dWhZSnk5NVZ5eHVWNExtNlRIWHV2OCs1M3A0Vk00NFVB?=
 =?utf-8?B?cGNiRlRCcDFLc3hlTS84N1BodjlTaUtQNTZncmpzMGJpN2NVeDdrbmtOYVpu?=
 =?utf-8?B?N2FqRDh0WjhRYTQ2YXM2dVhuYVc2ZGJUQXNJcEhkWVduSHpVUWJ6OVZsVUU1?=
 =?utf-8?B?cUJHZG8wZU5WOUg4RzFaN0hZWmt5NldSZGR1cmN1eXlpaWMzUHlENkdFOXJp?=
 =?utf-8?B?aVBIVC9BTW9ZM045WWNoZEEwYnVSNzVNRGFyYXp2K3VRcHJNN2ZMcmxWUTdq?=
 =?utf-8?B?N1Iyc05VNkN3TmVzMWNwSHFCU3FkNEFzTWJ3V2hPV3FFRHlKNHpVQkp3WDd0?=
 =?utf-8?B?YVRRdENXZnZydTlhYnZ4VGNuNEY3NEhoMFRGL1AwOU1MdlhIcVd5MURnTUR5?=
 =?utf-8?B?UTBLVlpsMFBvVUxoYXhwTlcvRG1jQVpNMy9GN2QwVEdNVmZlUENJcXJsd2Nv?=
 =?utf-8?B?cnVnUU5nUktnQXRrUzRaa1ZrQmVRWEtiV1hUUmY1MVVZYkR4My9yZFFhMHhu?=
 =?utf-8?B?dlJiY2NVKzhtZEdZVk5uUkxKOElxbVNIRTAzajFsa2xyaXRtVU0wenlsRjQ5?=
 =?utf-8?B?WW4rMUo1a0xMeHBtODM5dkNKdGZPYnpIaXExckxEU3E1WU1PLzVndmY1SmxM?=
 =?utf-8?B?RGJJTnR2emlzSXhkN0N3SFpuMGtXLzZ3OTZ1bGZqbVYyVXFWZDVtMW1ETWZE?=
 =?utf-8?B?b0RMOUxvR2NpOGxkMmpGSkRka0lyVHZpWGloTUZZbUlIdm0zdE5GeXZwdVIz?=
 =?utf-8?B?SzFKMG80LzRkbWt2d0xCVERHL1o0V25SaGFGRFZPMTRyelZscTFhd212cERo?=
 =?utf-8?B?S3dnYmJBTUdzeXBibGxNSXlOdEdSdHZRb0J0SU5vNnNQazhETGJKZTRObk5U?=
 =?utf-8?B?THpjcVhkRklqUUFld0lkZlRZZWhZeWVpQUV0T1l0bVlVcG85QVoyY2xxbFg3?=
 =?utf-8?B?clB0QS90ZUp4dkxkRUdIVFU1Szk3QmtZNG1FL0dQck1FNGtEL3JLNEdyTFJm?=
 =?utf-8?B?cVNtUDdyZmI4YVdYdHBOcGRTdTNlb1NGVDZJS3ZTL0JOTk1Zc1kwSTR2R1F6?=
 =?utf-8?B?azBZNHBaQm5LUVAwMDRRajJURXNKTGVkU1RxVElqMUFueDVaZitXTlMrRGhK?=
 =?utf-8?Q?URqA9Ai3G7MvAQr2cJF8CtJEt+wDz7xk7h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2534fde6-b16e-4839-3fde-08d8bbdd3372
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 18:16:40.0256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qx9MWn932ih2Za1cvqPtPvfPQyWsqkpwTTolP5dPXOKk+z1T6AMTjhW+9S+QztRANqmO3LWnOOCeQIlybIL9pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3690
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/21 12:03 PM, Paolo Bonzini wrote:
> On 16/01/21 06:40, Tom Lendacky wrote:
>>
>>> Introduce a new Kconfig, AMD_SEV_ES_GUEST, to control the inclusion of
>>> support for running as an SEV-ES guest.  Pivoting on AMD_MEM_ENCRYPT for
>>> guest SEV-ES support is undesirable for host-only kernel builds as
>>> AMD_MEM_ENCRYPT is also required to enable KVM/host support for SEV and
>>> SEV-ES.
>>
>> I believe only KVM_AMD_SEV is required to enable the KVM support to run 
>> SEV and SEV-ES guests. The AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT setting is 
>> only used to determine whether to enable the KVM SEV/SEV-ES support by 
>> default on module load.
> 
> Right:
> 
>          if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
>                  sev_hardware_setup();
>          } else {
>                  sev = false;
>                  sev_es = false;
>          }
> 
> I removed the addition to "config AMD_MEM_ENCRYPT_ from Sean's patch, but 
> (despite merging it not once but twice) I don't really like the hidden 
> dependency on AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT and thus AMD_MEM_ENCRYPT.  
> Is there any reason to not always enable sev/sev_es by default?

I don't remember where the AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT suggestion 
originally came from. I thought it was from review feedback on the 
original SEV patches, but can't find anything about it. @Brijesh might 
remember.

But I see no reason not to enable them by default.

Thanks,
Tom

> 
> Paolo
> 
