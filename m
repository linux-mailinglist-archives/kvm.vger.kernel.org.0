Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3F6375D2D
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 00:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhEFWak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 18:30:40 -0400
Received: from mail-dm6nam11on2063.outbound.protection.outlook.com ([40.107.223.63]:56328
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230149AbhEFWak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 18:30:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAmFk0IZ7zfIbJ90PUTmJloB6lInWLPgaslloZXbqgIFCtkOIbmuOlqF+BQ1p7Piplhp8ohcl5y9c3qgJio2c2qAbxBDGjBdtmzUvesId5thlMV4s8QWmcwyZBK7e2auLLDwlicKfMTdHUc/aQCYL2JYm5eUKqVS15gSP+tgOQzxo1zkImCDrRMtB/kudndT8t7HI8qqv7T1AZ63aQHVLtXx218BBykTVGsLnkkLu0okdaXS6lX4emFP+2PjHNQ2mfQ0iuEzipHlEM+88LEDXYzMe2ZWZI9dnSbOO1hxafeK78a3H3Mx58WJvN2lgUCQk9SvipwWT/UKt7+ZN7crtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMrvukK6E7jFzhoFLWshvRrSuRVYTbtqZA0Lt1KhCX0=;
 b=IGesqID3kcCkYxPolWcuZcdL610LgJ9rNDJiBoUartiFnjgUlFElTaYjYco3ac5GE3+u0X4aeGdF68inAds1zlc6d90t5gyE2m1oR3QuyARjEcfkDu8DX/PYq3JzKLJf8aTmziNFFk3nrpmC/ySU8VN/5tdY3KSxNbZ+8IkCVx+qZwV8XkyC7XSEysY34/FRcrO7qeIq+jiDmPa2Ipr8ZBgL4a6Zr9fMYL+ktBAHMc1RNIRgkoDzGmUh515VDTU2ZzDz4jeeuwAlZgS45P3PK/Zh6CEmyRlxuSMCzuEotC43iWqyPKdBYKsnXa3NJrFxWtwOMA5ah1VqIyg5qHbgsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMrvukK6E7jFzhoFLWshvRrSuRVYTbtqZA0Lt1KhCX0=;
 b=eaHU574C1qAmqJArL94yKXCNwc40j/3X8YW5gYuYI59caGnYWLa40EWjnD8bHl1LNNZKQNpJo0cgvMeZG7Kcjh1W8GVtFqCKaZrMFDWI/aaukm9zdtYwAvL0884U5prcR28qI/9nBF7FV8gTWGD2MqG1HLVEAaAtN/2V4zQTjbw=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2831.namprd12.prod.outlook.com (2603:10b6:805:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 22:29:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 22:29:39 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 21/37] KVM: SVM: Add KVM_SNP_INIT command
To:     Peter Gonda <pgonda@google.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-22-brijesh.singh@amd.com>
 <CAMkAt6pF-AS7NJsAMhnezuvo9tcTQhhq_e-eKDatjzbKBAHp0Q@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <264694c0-93ea-f491-0bce-642b94b92292@amd.com>
Date:   Thu, 6 May 2021 17:29:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CAMkAt6pF-AS7NJsAMhnezuvo9tcTQhhq_e-eKDatjzbKBAHp0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.11 via Frontend Transport; Thu, 6 May 2021 22:29:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddd01482-ad37-48ff-5d3e-08d910de6f8f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2831:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2831981722D1D1C7A44DEBE5E5589@SN6PR12MB2831.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKsf9ajMarPEDgSl1ukJYjvHrNLSX6ezj+8JsWwDf77Irk7/3zENwHv+Mqj2Szcl5y+1o86fwbDQdMb5yLjSJwE1cJsfJPdSgCJc7pN+5QA+KLhawM94MBDxLfsVhRDMZWihndgM+72WyJiWFyprs0zcMRQ1s+r3njBCEOGRw1hJGdEBum5poVLCYLqZ+KhtPNgCobcvqV9cMGlqy+B4ZZKgytNZUPy37TcqbdhAS8rAb9oSp6/WWT5s+9Im4Tw1vLkzOBLHjuxtuiA6zPBCqEinNTBwAbCieo3K5aeOjg7+knC5ERw7an14jXSmtxHlEkIBmhxg9LlWS5X0PZi3LVsAmIccrkKgAJU6fTZW8rQbqw9C9jyoYH/gxvNrKFRz0LVHIvcadg0lbV0d/UUNaznVmD9Q4Ad4k7gVxU1AU4V+/jqC1+g7OVmrra+efQ7nxUfvCNvaybgS4wOV6tMC+QcUPZFbbAGX3mxF8EVdZ1F8MyJ2V8qTjcNMt8IbqzhUEblRsz1OFt/bx1InRfiSMfhG5tyWKZDdBSCIvX0THN5Vugc6OzhHf0/BlkwGEavsAz7W9zv9MOWbJfmeSqinvZ1RzsLTwc50BmLGGTcxIVZYZuoDoQvhyrQ2QmmHN+mv6yxyN4AqHDlS2SBejm31UvXOiqQTKr05U7ue8LZdX4e7f4BxJyy0EwXky8OGzavdeelF0GzsTFl3K8gHyFGeXre6DJZH8LaWMJNSySwii0w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(86362001)(16526019)(6486002)(31696002)(66556008)(38100700002)(956004)(6512007)(6506007)(38350700002)(83380400001)(54906003)(52116002)(5660300002)(66946007)(8676002)(31686004)(66476007)(2616005)(8936002)(478600001)(53546011)(44832011)(186003)(36756003)(4326008)(6916009)(26005)(7416002)(316002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MmgzeTl2YnVYd0hCUnRaN3BBbytUQS9VZzdKRm0zYXY0VXpQSXZSVk5sK2NH?=
 =?utf-8?B?d051cHJhMU5Xb1dqMnc2ZFlMZFg1dkRJb09IV2tCL0dQd2tic1g4VEM5WDRV?=
 =?utf-8?B?L1c1d3RqWXhIQlY3Ni9mQWJZb3k4TGVBVmxVRlVkN04vOCtFNmJJdThmUkJX?=
 =?utf-8?B?U2dqeDZjNGZYMFFLV0k4SEVEdTZMMnBHbEthMXFMQkhrTlhOZnF1ZE55a25N?=
 =?utf-8?B?K1U3d3doK0lnUlF5bUxxVHJsbmNVZlVKZmFTYVA4ajZ5enFtSk0vL2FwcWdH?=
 =?utf-8?B?RkxUZENPancrb0NwNnRQdmJjcTVzaEZRSi9ab2JLUFBiTmF3VkNnVGZxbHlL?=
 =?utf-8?B?TllHMlJRbEVjMzQ2MUIrY1BKclN0Yis0Vlp5eE9mOXdZL1Rya0I1K2FsRmpD?=
 =?utf-8?B?WFllcHNnKzZkR2h4OHNWcHlqZS9VcmxNR2hFVllxVll3NXQwQWNjL0FXZ1E1?=
 =?utf-8?B?V3lZL2UyaGozMFdqTldGWXpqMzc1NkFmMUpDUVVoZ2dqRDJHS2liVTJDYkk5?=
 =?utf-8?B?YWRxOWVmOUtCUTJmczlXTWJJVjYxUHNUQkpDZW1sRzZlK3hjeFdlbmxPWU5t?=
 =?utf-8?B?a2I4MElZZWRVY3FDYnRuVHdUZ0NCb2lkb29Md0ZKTjhnOVY2d21UNHdGWUhI?=
 =?utf-8?B?UEdwTzFacmhFNlRicVYya2JtTkdkSitFeUwwNGJsaTNhR2Rzb2RGSGRha2RY?=
 =?utf-8?B?VzhFa3dCYmtCU1FlS0hJWlNnZkRGb1VES1U1QS84cW4vOGdMNWlPR2dyU1VW?=
 =?utf-8?B?TGs4RldvYUd5RUJXQmZoczl6cENLZVlMQUFBb3ZnN1ZQOEhzdmpWWFBoYkVZ?=
 =?utf-8?B?UkRrc0c1OWJrTUZNY28yYzJ5Ly9jbUJGZzB6VjNjYTBNUVBxdW1valkreDY5?=
 =?utf-8?B?a3VGN3pKN0FLUkdtZFNWT3lNaTVIR205bHl0UW10b1FuV01FRXJHYkZSdWdo?=
 =?utf-8?B?ak0xMk9kdHl3OFJFS0p6aHVPL0VGREhzaEJzbUpnb2VETURPWDViL2pEM1cr?=
 =?utf-8?B?SGJzd1dPOXZkcGxWMjIyYVp2R3dQTWhJMzNKMVMzVnJVcUdYV05lcmZtbDUy?=
 =?utf-8?B?bHQ3dW04QXNkbDdGTE5ocEVQc0hWanhyMlQxR1UrNTJ3YkNyM05NN1VGQjYw?=
 =?utf-8?B?b00vTnJwMktkNmxXTC9oTGE2ZTg3WEU5b2FXQmZsL2c3TDRCTEJSYTdvbHlk?=
 =?utf-8?B?RVhQT0FzRkgyNWNtTGRrUGN3cUh4ck9NZks5bUh2YXRhaEpKTm44VHdmNStj?=
 =?utf-8?B?M04zVVZCZGpDU0hvVDZoTGZacmRrSXZCYmVqd1VDUnUzMVA2NURyV3Jva1I1?=
 =?utf-8?B?UjhyNGdKMThvUjFzTWg0bXREa2Z2OENpS080QmErTjZYVmVsd3o0dFF1MUI0?=
 =?utf-8?B?eFR0S2liUnhPZlA4Z1gxWnFmS29rajg4TmE4eitHT2ZuKytVaXI5eE9zd1Nw?=
 =?utf-8?B?cWI4QmZEYWcyWDlCOXB1RThSMXJ1Uk85c3I4LzRXdHZJanNjWnM3c0pxRzRE?=
 =?utf-8?B?R1NIbUVEUjVjNzJ0aXExeFNKZ1BnYlZYK3hOZFpDSW5DR2wvSDVZT1gyaVZS?=
 =?utf-8?B?YkpMei9nZU5HL3JFS2t5QjF4c1p2MkdGZFpXL1drR0FpU3NTY2xEa2J5eTBW?=
 =?utf-8?B?b1hxMHNxbFFMV0pUY2swK1lUVDdNTDBhRmhWOGVEZWRpZGxLbkl3aXB6U01U?=
 =?utf-8?B?OE9zMDBSbnU5TW5MaHA1dDFYVld5M2VSOTFkYzJmOHZ5ZW1MbTBjOGpKTHQ1?=
 =?utf-8?Q?+AJRa3OTRriwJNI8FXQILXIOlGLLB7irwQa/wpn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd01482-ad37-48ff-5d3e-08d910de6f8f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 22:29:39.4623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W00j06goEt7pkvTv7nnhF2fD4+UjZ7wszvZfq4LcB+yJyBnNIwFANlLZMT991PYOzUWcY1KriKfgWPgxLq2QIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2831
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/6/21 3:25 PM, Peter Gonda wrote:
> On Fri, Apr 30, 2021 at 6:44 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>> The KVM_SNP_INIT command is used by the hypervisor to initialize the
>> SEV-SNP platform context. In a typical workflow, this command should be the
>> first command issued. When creating SEV-SNP guest, the VMM must use this
>> command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c   | 18 ++++++++++++++++--
>>  include/uapi/linux/kvm.h |  3 +++
>>  2 files changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 200d227f9232..ea74dd9e03d3 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -230,8 +230,9 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>>
>>  static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  {
>> +       bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
>>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> -       bool es_active = argp->id == KVM_SEV_ES_INIT;
>> +       bool snp_active = argp->id == KVM_SEV_SNP_INIT;
>>         int asid, ret;
>>
>>         if (kvm->created_vcpus)
>> @@ -242,12 +243,16 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>                 return ret;
>>
>>         sev->es_active = es_active;
>> +       sev->snp_active = snp_active;
>>         asid = sev_asid_new(sev);
>>         if (asid < 0)
>>                 goto e_no_asid;
>>         sev->asid = asid;
>>
>> -       ret = sev_platform_init(&argp->error);
>> +       if (snp_active)
>> +               ret = sev_snp_init(&argp->error);
>> +       else
>> +               ret = sev_platform_init(&argp->error);
>>         if (ret)
>>                 goto e_free;
>>
>> @@ -583,6 +588,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>>         save->pkru = svm->vcpu.arch.pkru;
>>         save->xss  = svm->vcpu.arch.ia32_xss;
>>
>> +       if (sev_snp_guest(svm->vcpu.kvm))
>> +               save->sev_features |= SVM_SEV_FEATURES_SNP_ACTIVE;
>> +
>>         /*
>>          * SEV-ES will use a VMSA that is pointed to by the VMCB, not
>>          * the traditional VMSA that is part of the VMCB. Copy the
>> @@ -1525,6 +1533,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>         }
>>
>>         switch (sev_cmd.id) {
>> +       case KVM_SEV_SNP_INIT:
>> +               if (!sev_snp_enabled) {
>> +                       r = -ENOTTY;
>> +                       goto out;
>> +               }
>> +               fallthrough;
>>         case KVM_SEV_ES_INIT:
>>                 if (!sev_es_enabled) {
>>                         r = -ENOTTY;
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 3fd9a7e9d90c..aaa2d62f09b5 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1678,6 +1678,9 @@ enum sev_cmd_id {
>>         /* Guest Migration Extension */
>>         KVM_SEV_SEND_CANCEL,
>>
>> +       /* SNP specific commands */
>> +       KVM_SEV_SNP_INIT,
>> +
> Do you want to reserve some more enum values for SEV in case
> additional functionality is added, or is this very unlikely?

Good idea, I will reserve some enum.


