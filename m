Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB3D2FEDB0
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 15:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732197AbhAUO4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 09:56:37 -0500
Received: from mail-eopbgr770040.outbound.protection.outlook.com ([40.107.77.40]:1148
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732137AbhAUO4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 09:56:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgRX2ZVAzm2P438N1i0TLZrvUtnjeOZzb1sHtTTs9drfbVNaQdnMzG+frgZ90nv7EjnxxvyY/WBsORiiZPeozy4vyJ6c5D/ZGj+Tk55MTAZhJ5WNqkbTsIcL5No1V65Fa6pBXmdrjruuK3heBDuUqZ9PIDP+WnkY7fLSCm3Mla109jLS5ApL4kK1KFeHMg0M48J/1swUt8yCg+rVRpvwp571OR50wYyDWAnXog97KYxgaY7FOHjDVzAxRQc5DXvE7tS9IsNNmYhAdPrB6Rm6u+8U/k4gc+9zUiisXAb4lGpP7LvyNCBUq24LNk/D77qzPBWWIc9FpvxN3xMkiCmU4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WPCFin+KBqWX0/DLdvou3LUlcQ9/2RoWQ1Gp+5oQ6M=;
 b=khevPdz8kTuqFiT8qcXYlvR2EA4J9FnT3q0zTL4o+zlAWquLl7fJKFd82bPdLpeiYk4O6NIzTFF2jm6VOz0voqGOFA9KEQHKs1HweXfd0wZ/APwGJ9endtzgxZ6P8SdXXttT6wVsDegWL4O99uCZygzC96D8cF1der6KCyCSmMGkKGJjLedahAQ6Mt2SbUozzT0q93sfoZvENBXyv7Va/YUMEKEQ4KWThEF2Wbn3WYqR+Iy7EJvTcZ2Tkxs+R5qnimvbU+/HFf5vr3+DvErvTzQ8F0LDOwRgfKzCamDrAAYCyDaVmdiqRTupAWM69q43SAVt6jmsZmsTk2V2YVPytA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WPCFin+KBqWX0/DLdvou3LUlcQ9/2RoWQ1Gp+5oQ6M=;
 b=ULHrPxxjMzUWdACcYaQBsZy6dXDqI8I/LuDUK7lnVTUHGBLmyuIWFvj1VTmyyt++r8YBYomQcn7OSHe9k3eECN4Dpqsr+O2PHMs5c2XXtsAuK+A5NMf8JKkQUPXuvm8uDwxCSSLeIfPqi1HK/gq0CSVyCLb1rg2LXGYRKSqZfa8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3369.namprd12.prod.outlook.com (2603:10b6:5:117::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Thu, 21 Jan 2021 14:55:11 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 14:55:10 +0000
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
To:     Tejun Heo <tj@kernel.org>, Vipin Sharma <vipinsh@google.com>
Cc:     brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org> <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org> <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org> <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
Date:   Thu, 21 Jan 2021 08:55:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YAhc8khTUc2AFDcd@mtj.duckdns.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:806:23::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0076.namprd13.prod.outlook.com (2603:10b6:806:23::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Thu, 21 Jan 2021 14:55:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3a0e1086-246a-4b6c-4459-08d8be1c8ca8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3369:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB33697BB4134ECE038FB77B08ECA19@DM6PR12MB3369.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FXe14SNbtCTWlBCEskncP+Ld5jYA+j9Dh+U3DIdHl2Rc6mhlgExHebKUi7QkFJarqp1Rbvk+Efij1ShPzmNOtTViYQYIY9uB10lqXBl7vXwe7OM7mdlTfro6olDFLkWBkJdTKlM2T+mmNb09RPXpwsV/7Ukp+Csf6NCK3eIcPwB/my4yNI37gIMBQOSGXD6QIDl2aX2BQtMFpggM6p7krFewmYgZ0AZ7dwWKFLulf8Z5XIzcXaYaHHYUCJN8s4crTqqYLj5QlFfQK+VRHi7qyQwAMHeMjxo58pxRX9BGnFj2PuUr8vEZ1jDQb4UfJVi2v/hCFcLJc+FBnzrrmeNflyeIB7hQQrtMGdSQ0GGhcRlrO7xWxbZtaK4ex0m2e2/WG/wzOn43UfDRGukvbiBuTetqsS/QNdC0v+QudOJO221emo1YG0vtY0vgJZajml75k8nGG9wljHiuj/UPyuEzV1D2Ui11255N0lyFTHKmJs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(26005)(316002)(53546011)(6506007)(31686004)(83380400001)(6512007)(8936002)(110136005)(478600001)(4326008)(52116002)(7416002)(16526019)(8676002)(6486002)(2906002)(36756003)(31696002)(86362001)(66476007)(2616005)(956004)(186003)(66946007)(5660300002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YTFOblVZOFo4NWhXYnk1YUY3eXZ6NTZOUzY5Y081OHp2ejAxSVVTdDBEMlNs?=
 =?utf-8?B?RU5saDdEM1h3bGFsbys1ZGdpNmRHeHlZVVluTUtHb0tkQ05RMXBmWWlGR1dH?=
 =?utf-8?B?citoTGdtZlJnRFZMRUNRMSsrY3NTaVR0cWpFSWJySmp1amxXaVZYdm96emJ6?=
 =?utf-8?B?SG9LakVrSlJSNUlxVkFJVXMvcXRSMEZNY0kzWDhPT21kbkVyRlp5L3JQdDNz?=
 =?utf-8?B?N1dPQTB6MmpDUU9xbkpuV0R2VFcxZWVqLy84MHZvWUp5YXcwZzBIaG4zcTc3?=
 =?utf-8?B?M2t4YWs0bWRybzkzQWxvODMrdXZ2MzdHVzNrYjVqMW5vZ21vMmJmMHhlb2FN?=
 =?utf-8?B?SC9CZVlMRVF5aVhSbTdqZFkxZG9jUGphell3UHdIbFBiWFhLWmoxV0IrVTFx?=
 =?utf-8?B?cU5EUTZ6OG44cDBldjJEUi8wQUFLWWhFV21adUY2a041RURZVXEwQ2FYc2dH?=
 =?utf-8?B?eWdmbWxxaGNDSGFkaG1mUWdZL0tIWUlBN1NJbi9XYVNrMGhrS1V5MHZmNWdl?=
 =?utf-8?B?WjhvUzVjUjRHVk9VUzNKVzNWN1VFeVVncElQQ2JNRVpQOXhjZTZBYWloQjZh?=
 =?utf-8?B?RmpYSjJGR0ZwYmVNaC8zTE1wa0Qya1BmS3ViR3hRS1lqeXBDZTF0WTk5WEJo?=
 =?utf-8?B?WS9aaDVaZEsyOW5aZjRCdlVEODVoT1BadFhhZ0FVbVVRZDhvYjVxQzJnS29x?=
 =?utf-8?B?eExlSS93dzlWMUFyalF3SnlxNWZBOGxxVWV3aU5VTlBXMUU3aHNGUDBtM1ls?=
 =?utf-8?B?ZVdXdXZEdVh5ckVOZHRCVnRqV21qbnUwU0FOdXJKdmpuRVBYTi9wVXpaQ2hq?=
 =?utf-8?B?M3ZLSFRqM1dyajlHVnNFcU5pMTdFcVI3RlRZdlFLaVZGOFJFQ3ROcVRjbTVI?=
 =?utf-8?B?UUpBZGQycjBRK09Fb2xDaG90a1NOVkhoZml3S3c3ZlBCUFA3Vk53dmUxTWl1?=
 =?utf-8?B?UDVlNmVsaUV3OUJUM0JjbktZajlya3BtTXFERlV5NTJJVHZWWEtFRzBzbkZT?=
 =?utf-8?B?RHVGdkZ5VEdZMFpTUzkxQnhoZmQ0cXJSL1YxTC9pVi9Vb3poUzE2WHQ2UmJ0?=
 =?utf-8?B?MjJSdmJ3bmx2WndtOS85UGxxM1RiQitCY3BaaUsrTkIvRnNKdHdVdWV1TnJt?=
 =?utf-8?B?Uy84UFlWcDRVUG1TejVjUE5vRWIvR2pCRDBwMklYZ2hFNkVpZ3doQ01SZ0Rv?=
 =?utf-8?B?dUdYaDdpVVo5SkVqcTRhVlQ4eDUxRk9GYjFaRFAvTTJJTXJtMEVkUEg4UHFZ?=
 =?utf-8?B?YVRQUmxWTWc4eVZYMkFwZ28yZnZuSC90SlZieHJJTmFNay9Kak5OdUk0Q2px?=
 =?utf-8?Q?9RDQ/811XKYn4b0fLGw5/vdWZHHJ+NHhel?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0e1086-246a-4b6c-4459-08d8be1c8ca8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 14:55:10.7811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7qmVcyhDe8tw0WFDrz98qU7PHcTHwSMolsKlwU3utHG7wCxlvv8MxkQCQID+gMFmuJyMLzsdKZMgH2DsOusZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3369
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/21 10:40 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 19, 2021 at 11:13:51PM -0800, Vipin Sharma wrote:
>>> Can you please elaborate? I skimmed through the amd manual and it seemed to
>>> say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
>>> case for mixing those two?
>>
>> For example, customers can be given options for which kind of protection they
>> want to choose for their workloads based on factors like data protection
>> requirement, cost, speed, etc.
> 
> So, I'm looking for is a bit more in-depth analysis than that. ie. What's
> the downside of SEV && !SEV-ES and is the disticntion something inherently
> useful?
> 
>> In terms of features SEV-ES is superset of SEV but that doesn't mean SEV
>> ASIDs are superset of SEV ASIDs. SEV ASIDs cannot be used for SEV-ES VMs
>> and similarly SEV-ES ASIDs cannot be used for SEV VMs. Once a system is
>> booted, based on the BIOS settings each type will have their own
>> capacity and that number cannot be changed until the next boot and BIOS
>> changes.
> 
> Here's an excerpt from the AMD's system programming manual, section 15.35.2:
> 
>    On some systems, there is a limitation on which ASID values can be used on
>    SEV guests that are run with SEV-ES disabled. While SEV-ES may be enabled
>    on any valid SEV ASID (as defined by CPUID Fn8000_001F[ECX]), there are
>    restrictions on which ASIDs may be used for SEV guests with SEV- ES
>    disabled. CPUID Fn8000_001F[EDX] indicates the minimum ASID value that
>    must be used for an SEV-enabled, SEV-ES-disabled guest. For example, if
>    CPUID Fn8000_001F[EDX] returns the value 5, then any VMs which use ASIDs
>    1-4 and which enable SEV must also enable SEV-ES.

The hardware will allow any SEV capable ASID to be run as SEV-ES, however, 
the SEV firmware will not allow the activation of an SEV-ES VM to be 
assigned to an ASID greater than or equal to the SEV minimum ASID value. 
The reason for the latter is to prevent an !SEV-ES ASID starting out as an 
SEV-ES guest and then disabling the SEV-ES VMCB bit that is used by VMRUN. 
This would result in the downgrading of the security of the VM without the 
VM realizing it.

As a result, you have a range of ASIDs that can only run SEV-ES VMs and a 
range of ASIDs that can only run SEV VMs.

Thanks,
Tom

> 
>> We are not mixing the two types of ASIDs, they are separate and used
>> separately.
> 
> Maybe in practice, the key management on the BIOS side is implemented in a
> more restricted way but at least the processor manual says differently.
> 
>>> I'm very reluctant to ack vendor specific interfaces for a few reasons but
>>> most importantly because they usually indicate abstraction and/or the
>>> underlying feature not being sufficiently developed and they tend to become
>>> baggages after a while. So, here are my suggestions:
>>
>> My first patch was only for SEV, but soon we got comments that this can
>> be abstracted and used by TDX and SEID for their use cases.
>>
>> I see this patch as providing an abstraction for simple accounting of
>> resources used for creating secure execution contexts. Here, secure
>> execution is achieved through different means. SEID, TDX, and SEV
>> provide security using different features and capabilities. I am not
>> sure if we will reach a point where all three and other vendors will use
>> the same approach and technology for this purpose.
>>
>> Instead of each one coming up with their own resource tracking for their
>> features, this patch is providing a common framework and cgroup for
>> tracking these resources.
> 
> What's implemented is a shared place where similar things can be thrown in
> bu from user's perspective the underlying hardware feature isn't really
> abstracted. It's just exposing whatever hardware knobs there are. If you
> look at any other cgroup controllers, nothing is exposing this level of
> hardware dependent details and I'd really like to keep it that way.
> 
> So, what I'm asking for is more in-depth analysis of the landscape and
> inherent differences among different vendor implementations to see whether
> there can be better approaches or we should just wait and see.
> 
>>> * If there can be a shared abstraction which hopefully makes intuitive
>>>    sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
>>>    something arbitrary to specific vendors.
>>
>> I think we should see these as features provided on a host. Tasks can
>> be executed securely on a host with the guarantees provided by the
>> specific feature (SEV, SEV-ES, TDX, SEID) used by the task.
>>
>> I don't think each H/W vendor can agree to a common set of security
>> guarantees and approach.
> 
> Do TDX and SEID have multiple key types tho?
> 
>>> * If we aren't there yet and vendor-specific interface is a must, attach
>>>    that part to an interface which is already vendor-aware.
>> Sorry, I don't understand this approach. Can you please give more
>> details about it?
> 
> Attaching the interface to kvm side, most likely, instead of exposing the
> feature through cgroup.
> 
> Thanks.
> 
