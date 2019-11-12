Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F9BF9CFE
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 23:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKLW1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 17:27:30 -0500
Received: from mail-eopbgr730044.outbound.protection.outlook.com ([40.107.73.44]:8685
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726906AbfKLW13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 17:27:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auC0xmbrwqAGUb17N8V440BIqtScRE6FuyX2wucoIAIWs9GAE9zlu0zeb+NG1UlauczT9PApVIO8gAtFvTO9JR4mFji/hLwXkONvHsenXNXGNR1rFzXfnbHD2rGNaDtgufp4jPerevYhsSX+xvyPTQ/wAFIpNqVkI/MqtuRnIrgvuIGflxx5XvAevahuEOTIpzdcPkHqGx26sFbZQy28FGfurinpNPG4hCAQWqZ+ej6MGjX/LPWRqoWexjk/EEWQ0iyQzojrQWm1PmGuEO12tn0JpsLnlsXPBHZ7i7N436TRR2XoE/SI8nIkExv9n0xREex8obxvd7V8YJSZtIgIsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3en8LjhA7rRRjAvUzhgrqWTqfeLLcFCLAThEK8A6pE=;
 b=YPbH5T5eHMjWvbPhIfU2LIbK/wnzaiyqJ21bhvPtdy++MlARuOaudIdADfbdQAMJcw66GAlG+bHDXDTaqlaTS9JILIQsnnFG/7zWzL+nmdiN+4Xuh8M6LV8hAdBfw1K0/L0CDzuf9j23yDNPJtBF61igNvVS2vijgxxr82gzp7AX03TlkrNzeL1bfHWauzWiR7ShZIg5Iz1gzTq0659pmHBLegMyorYysmicJiDi1GaBDQXqxyPqopcu2mngWCH8Jsv6qU8QBb9O/xGgFOlAEJWjQO6DpbJK5hOnFh+/YIKWSHlJVB4/LioQm40uWzLNyKrZDrgX69mpl8FPmx5oYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3en8LjhA7rRRjAvUzhgrqWTqfeLLcFCLAThEK8A6pE=;
 b=UMFY4LiVeSi1ZDh28e8lzH0dn9VwlJNwJ9FTPXMzxC1R0V8kpAJIsVvLL1od40lQg3Mu547+2AKL0I4SaYjMFdEwkcvDEdRCBL2Arx6Y6j+84iadWMdUn/tnU7RaXYp+xtWVVYym+J1xN57F6+6Limvp36GDjkBHN2wzsG+ivpU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3273.namprd12.prod.outlook.com (20.179.106.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 12 Nov 2019 22:27:25 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9%7]) with mapi id 15.20.2430.023; Tue, 12 Nov 2019
 22:27:25 +0000
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
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <4f509f43-a576-144d-efd4-ab0362f1d667@amd.com>
Date:   Tue, 12 Nov 2019 16:27:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
In-Reply-To: <CAMkAt6pzXrZw1TZgcX-G0wDNZBjf=1bQdErAJTxfzYQ2MJDZvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN6PR15CA0024.namprd15.prod.outlook.com
 (2603:10b6:805:16::37) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2da931ce-3147-46f6-a841-08d767bf7e42
X-MS-TrafficTypeDiagnostic: DM6PR12MB3273:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3273C34557CC02C8CC920E71E5770@DM6PR12MB3273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 021975AE46
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(51914003)(189003)(199004)(4326008)(14454004)(6512007)(6436002)(26005)(99286004)(6246003)(54906003)(11346002)(65806001)(66066001)(25786009)(186003)(36756003)(229853002)(6486002)(14444005)(316002)(65956001)(47776003)(478600001)(58126008)(446003)(3846002)(6116002)(7736002)(305945005)(6916009)(81166006)(81156014)(486006)(31696002)(23676004)(50466002)(86362001)(386003)(2616005)(5660300002)(44832011)(6506007)(7416002)(66556008)(52116002)(53546011)(76176011)(31686004)(2906002)(230700001)(2486003)(8676002)(66476007)(66946007)(476003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3273;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYhJABbFZtn5BP84SP3iy1N4Yb+AQwWJsu6A9ZVrwWRNhCBWSHBrm392yvFLb5eGkK8hU5R5D19PATpcOnZCOF9PVPxJXC9ACfR5v7XnmnzIQXfBtst193D3FUmWVo+SQbw7/r1+FIVrmHwJ28TkXr8S7NXunEw5mY3yOF450SbA7Ghy1ByKpWT22FUtcjX7FeyqRz8QDech80JZrHcUhE7B3TRydG/n2+XzhjfgWJebtLYc0WXyvlzdRWEvpnfMuFPkOQuXmQHw2fMsWAOzmKXVs2gNgb6/3xabbjO9Lquf7jcDJjWNTRPtL5ag+d/SrL/Wm44w3VVsJTNl7r/YY2yKmpMOSYuaPUrKDQ72lxMyMXUjZoF7Z/O3czUOZKaGBG1LW6KHrSNUa8X49fqlOQ4tJZrjKZEteJq+9eN0hHFsI0T5F/hyOOyhHIEfokDO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da931ce-3147-46f6-a841-08d767bf7e42
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2019 22:27:25.3595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A5rkrzIVuXopcD/TZfasG6D4EudKth3BvZEgLFBEfbPnd7fFFYKTjh+nSw/v5cE4manbo5dpIqE6sjdsNkPEnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3273
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/12/19 12:35 PM, Peter Gonda wrote:
> On Wed, Jul 10, 2019 at 1:13 PM Singh, Brijesh <brijesh.singh@amd.com> wrote:
>> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>> +{
>> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +       void *amd_cert = NULL, *session_data = NULL;
>> +       void *pdh_cert = NULL, *plat_cert = NULL;
>> +       struct sev_data_send_start *data = NULL;
>> +       struct kvm_sev_send_start params;
>> +       int ret;
>> +
>> +       if (!sev_guest(kvm))
>> +               return -ENOTTY;
>> +
>> +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
>> +                               sizeof(struct kvm_sev_send_start)))
>> +               return -EFAULT;
>> +
>> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +       if (!data)
>> +               return -ENOMEM;
>> +
>> +       /* userspace wants to query the session length */
>> +       if (!params.session_len)
>> +               goto cmd;
>> +
>> +       if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
>> +           !params.session_uaddr)
>> +               return -EINVAL;
> I think pdh_cert is only required if the guest policy SEV bit is set.
> Can pdh_cert be optional?


We don't cache the policy information in kernel, having said so we can
try caching it during the LAUNCH_START to optimize this case. I have to
check with FW folks but I believe all those fields are required. IIRC,
When I passed NULL then SEND_START failed for me. But I double check it
and update you on this.


>
>> +
>> +       /* copy the certificate blobs from userspace */
>> +       pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr, params.pdh_cert_len);
>> +       if (IS_ERR(pdh_cert)) {
>> +               ret = PTR_ERR(pdh_cert);
>> +               goto e_free;
>> +       }
>> +
>> +       data->pdh_cert_address = __psp_pa(pdh_cert);
>> +       data->pdh_cert_len = params.pdh_cert_len;
>> +
>> +       plat_cert = psp_copy_user_blob(params.plat_cert_uaddr, params.plat_cert_len);
>> +       if (IS_ERR(plat_cert)) {
>> +               ret = PTR_ERR(plat_cert);
>> +               goto e_free_pdh;
>> +       }
> I think plat_cert is also only required if the guest policy SEV bit is
> set. Can plat_cert also be optional?


Same as above, I believe its required.


>
>> +
>> +       data->plat_cert_address = __psp_pa(plat_cert);
>> +       data->plat_cert_len = params.plat_cert_len;
>> +
>> +       amd_cert = psp_copy_user_blob(params.amd_cert_uaddr, params.amd_cert_len);
>> +       if (IS_ERR(amd_cert)) {
>> +               ret = PTR_ERR(amd_cert);
>> +               goto e_free_plat_cert;
>> +       }
> I think amd_cert is also only required if the guest policy SEV bit is
> set. Can amd_cert also be optional?


Same as above, I believe its required. I will double check it.


>> +
>> +       data->amd_cert_address = __psp_pa(amd_cert);
>> +       data->amd_cert_len = params.amd_cert_len;
>> +
>> +       ret = -EINVAL;
>> +       if (params.session_len > SEV_FW_BLOB_MAX_SIZE)
>> +               goto e_free_amd_cert;
>> +
>> +       ret = -ENOMEM;
>> +       session_data = kmalloc(params.session_len, GFP_KERNEL);
>> +       if (!session_data)
>> +               goto e_free_amd_cert;
> This pattern of returning -EINVAL if a length is greater than
> SEV_FW_BLOB_MAX_SIZE and -ENOMEM if kmalloc fails is used at
> sev_launch_measure. And I think in your later patches you do similar,
> did you consider factoring this out into a helper function similar to
> psp_copy_user_blob?


Yes, we could factor out this check into a separate function. Let me see
what I can do in next iteration. thanks for the feedbacks.

-Brijesh

