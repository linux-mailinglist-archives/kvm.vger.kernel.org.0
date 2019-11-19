Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE091025E2
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 15:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfKSOHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 09:07:38 -0500
Received: from mail-eopbgr740089.outbound.protection.outlook.com ([40.107.74.89]:53601
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfKSOHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 09:07:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6pdZ2cAbGOzUeTVtdyVCRjVRpqUYVahjpdwY7tBtgbogcgzRMwRV2SGCaLee8i2ZxOKZIrkA5f/PdwGBv98n5bvBLH1iA8ffEIl/1G15HFRQEsrCuzi95t99wSSKC06z9a0k7ksjuFvugFuqo9ukGMX4X9g9X7/ubO2Ed+jwM/U+Ek+LBLJOivagKGs0h2KovHcXUuO1LciSsDtsHjXk3udiXtK07mWGjK4nhXr45fZH6QKTOeDIIgjR9pCMkvSOtzrnu4h9v3zoeeoc2UiOHRaVWh/pTo4Cl0OWAjWOS2HoTnDWZogvbnS3xzYwWGrV+CyHWADuvNCuFMUeGX5rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZEdJXCrGvHDtdw/ckeNFvXFe9dK+0pFHHThOMFHD9M=;
 b=c5Pd7hmPbUxo6+ggZmwFPirBJUccbRgYNc3QYdvDjfOj7SMsnE4FAEttDfNUTv8O5jSiv88Xj2gwXZKpzhzyGZ46clb2qnGSOIPX4ZTgnfz4lUQ2ybivOYHs2HM50Cn0PkNLGlsDfu19+DXzRdvZszj9pmTV7yOcvW6dVRf7JlXfyztVu4m6W2pbBiYr098L+IPljCKCsi6xb89VJoiHuSMnzqVGJC0I7V/aHVuUsVPfu3mQ/R0dzpttdaOBMWTNYXvlO9KqMNqyYv0L9pZD7GNYYmcpVxnSN/cBP2mu5uBff07GfoW8RjGUsAhUS3F1YFu4CQPFJeNPT4hWDAHGyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZEdJXCrGvHDtdw/ckeNFvXFe9dK+0pFHHThOMFHD9M=;
 b=Wr9FxwD6opdt1UmEQTYouGRAoD7EawUr3Ch0q1HwP6CHjbfYbXsRAFcKeFRODR+M0BEfdhSH1XF/JYQZYvRhSDHZADWsBjuZhIiXryOgAoRLJc+hijuBLMXJ+3sVQmcbQOT9wNb2kBdKzajP8ujwf4z8nwQy+ZRm/MUgl/+kYN4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB4267.namprd12.prod.outlook.com (10.141.187.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Tue, 19 Nov 2019 14:06:54 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 14:06:54 +0000
Cc:     brijesh.singh@amd.com, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/11] KVM: SVM: Add KVM_SEV SEND_START command
To:     Peter Gonda <pgonda@google.com>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-2-brijesh.singh@amd.com>
 <CAMkAt6pzXrZw1TZgcX-G0wDNZBjf=1bQdErAJTxfzYQ2MJDZvw@mail.gmail.com>
 <4f509f43-a576-144d-efd4-ab0362f1d667@amd.com>
 <CAMkAt6qfPyqGuNv9gKirote=zj6Vha=9Vu1HSFkxx334s-GV1g@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <a1c99bbc-b30f-53b0-6598-545d05b18e1c@amd.com>
Date:   Tue, 19 Nov 2019 08:06:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CAMkAt6qfPyqGuNv9gKirote=zj6Vha=9Vu1HSFkxx334s-GV1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0130.namprd05.prod.outlook.com
 (2603:10b6:803:42::47) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 095c8699-32f1-4129-7ad7-08d76cf9bb1e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267BC5A1B7728252422BBBEE54C0@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 022649CC2C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(199004)(189003)(31696002)(31686004)(229853002)(50466002)(2906002)(4326008)(86362001)(58126008)(44832011)(6246003)(6486002)(54906003)(230700001)(305945005)(6116002)(3846002)(7736002)(476003)(6436002)(14444005)(6512007)(65956001)(65806001)(486006)(66066001)(47776003)(2616005)(5660300002)(36756003)(53546011)(6666004)(316002)(99286004)(26005)(478600001)(6506007)(7416002)(8936002)(386003)(186003)(14454004)(6916009)(76176011)(52116002)(2486003)(23676004)(11346002)(81156014)(81166006)(66946007)(8676002)(66556008)(66476007)(446003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4267;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pz3qwgrjvmjTX9u5XZk3jZSrfshiYCA/q8RaVLbacdGErq18wPiyGpuxBkF0kSR7yLu7AlYZVOgwaYsC5f/6c+zfn7BpcRUDWY3BZEmu58cHuwG5Hx8KucRBRnLgYQeHFeLxhxbpyggF+wGAuynuJQGMhM87L25ZkJCB3gSnXeFk7Ld3r5UgzuQaeqleuc76cC6w3MJ1uQGxwERDcc+YmNQ5iuaf+zCED54swwEhiE5V+csuR1QUGLEUTQFHRecJEQ2iOhu5ozT4buq71WqPf4pEmC5QW8rUVN16RhhLW5BDJyEQNmuyENYb3IqVf9SOXEH5S/tdQhsOc+ymT10PnryTo1GdI/OgkXw4wejWoV/Mx+qYyHzRso8uie8xilfzwfhd5i0UhXguwN39Rnh10uS1qRct9vOlt5ovjKuFasw41VCKbS0/KG1nlrTWqVTx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 095c8699-32f1-4129-7ad7-08d76cf9bb1e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2019 14:06:54.4933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sg4YdveydHjJ54uEDLK+mXdQlBo86x1KbVqo3CfFbfNOeOBfjK4xSx4GoQMBGPJbANGVlWzZyV3vh93jKRM5cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/14/19 1:27 PM, Peter Gonda wrote:
> On Tue, Nov 12, 2019 at 2:27 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>
>>
>> On 11/12/19 12:35 PM, Peter Gonda wrote:
>>> On Wed, Jul 10, 2019 at 1:13 PM Singh, Brijesh <brijesh.singh@amd.com> wrote:
>>>> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>> +{
>>>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> +       void *amd_cert = NULL, *session_data = NULL;
>>>> +       void *pdh_cert = NULL, *plat_cert = NULL;
>>>> +       struct sev_data_send_start *data = NULL;
>>>> +       struct kvm_sev_send_start params;
>>>> +       int ret;
>>>> +
>>>> +       if (!sev_guest(kvm))
>>>> +               return -ENOTTY;
>>>> +
>>>> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
>>>> +                               sizeof(struct kvm_sev_send_start)))
>>>> +               return -EFAULT;
>>>> +
>>>> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
>>>> +       if (!data)
>>>> +               return -ENOMEM;
>>>> +
>>>> +       /* userspace wants to query the session length */
>>>> +       if (!params.session_len)
>>>> +               goto cmd;
>>>> +
>>>> +       if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
>>>> +           !params.session_uaddr)
>>>> +               return -EINVAL;
>>> I think pdh_cert is only required if the guest policy SEV bit is set.
>>> Can pdh_cert be optional?
>>
>>
>> We don't cache the policy information in kernel, having said so we can
>> try caching it during the LAUNCH_START to optimize this case. I have to
>> check with FW folks but I believe all those fields are required. IIRC,
>> When I passed NULL then SEND_START failed for me. But I double check it
>> and update you on this.
> 
> 
> I must have misinterpreted the this line of the spec:
> "If GCTX.POLICY.SEV is 1, the PDH, PEK, CEK, ASK, and ARK certificates
> are validated."
> I thought that since they were not validated they were not needed.
> 

I have confirmed that these fields are required by the SEND_START
even when GCTX.POLICY.SEV=0. The FW needs us to pass certificate
chain, if POLICY.SEV=1 then FW will validating the chain otherwise
ignore it.
