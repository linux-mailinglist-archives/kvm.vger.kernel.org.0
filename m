Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA719C8E9
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389811AbgDBSit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:38:49 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:31215
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729033AbgDBSit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 14:38:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHudsKFP3MbupxlXQYxcCHe0DwPrq0PJ7SUrByKsRvmCoJD3vXyZ4r6gCmCAgKcKktZEgdYs8kbKEa/oZkpEBdk6RuKdS2Km0RZXhcFHqstENiOBMApiGD0N1AidfcA9X3AgBkvBnkHowoEe5UQoxWRKnCM3vMtQVqikYvO/5iCJHZK6YnUSbK4QL4ndIIM4CV4DVA7PYEeav0NHwGnJM48s1ZqAaVbMSZihsNaTFE4UNT1JiH9aeIMCUgDESAC453wB3PxVdF8UG4yS8Z6ae5XV0cSrqx89GE+gEyBXzKqX0OqpeYZNc7GgLK9uuCte34T5FLe+bAqo5QUbq/93gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tmrNoqtwyN81thxaJjvBI94rg7PqoblebTUGRGq8MU=;
 b=Jj88aAgntlwDCvDXrL+P69bT1kdopisKcrkl/XTJ2MibGgFIbLWEETBaE1Z0IzWCu1EHKo5bee484RX3Zb0A9TwH+eTjS+YFsn5OQU+Y9NzvMHkC6+SczRsJ1wjbVUNQVB/ugA6W4QRuX5Qw04X3L9l9orZc8V/zo1Z+2CMu2kr9/wLeU4DOElkrBdaoMQ6X0xbaEI98vR3wzkg92ts4QokLQtzhnMpFdle6eJnVkXPll+SxJ/Ep4YZ4QSDqWYlCfQQw24n4dz3KkuBg7z9dn73bzHgEtUTF+jBQr+pSbFTDzUXSKt2xWmtYBPbUnK45RpTwzh1lyvZcZ78Q+7En8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tmrNoqtwyN81thxaJjvBI94rg7PqoblebTUGRGq8MU=;
 b=2JpQ1mI5yUP593pUOfeMqdB4xFo4MrBpjQgZi9DQzz8E37gx+/aTDVp7VGBYb231HB3JiHXH78ol62oMIOoG+1H1TTuemibWZ1vSAfxNDzB6STkY0c4MGdeFyzvNUe5PYvbZzYwLkcX9ZmqI0X3qKBzMKszD1HPnDAiDTcGN338=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Thu, 2 Apr
 2020 18:38:40 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 18:38:40 +0000
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 01/14] KVM: SVM: Add KVM_SEV SEND_START command
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
 <4a614d5f-2a01-7b1e-fc76-413b9618e135@oracle.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <478c4bb3-1727-d80f-dc07-c0f6350b2da5@amd.com>
Date:   Thu, 2 Apr 2020 13:38:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <4a614d5f-2a01-7b1e-fc76-413b9618e135@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: DM6PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:5:60::35) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by DM6PR10CA0022.namprd10.prod.outlook.com (2603:10b6:5:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Thu, 2 Apr 2020 18:38:37 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b242bc3b-d6c1-45d2-58a5-08d7d7351057
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:|SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4575D9F06C9A24CDE7557B13E5C60@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(4326008)(7416002)(8676002)(16526019)(316002)(6486002)(36756003)(110136005)(86362001)(81156014)(8936002)(66574012)(31696002)(186003)(6512007)(81166006)(6666004)(52116002)(53546011)(478600001)(66556008)(26005)(956004)(5660300002)(31686004)(66946007)(2616005)(2906002)(66476007)(6506007)(44832011);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyiQPe4/xj8pQzG2z6LYyG35trVMWCQtjmHLqAA90K7hcJrt53HrUsCe7fM/+7RvUAQPdcT8ZI02XkyClZ2+/wSxzib5qzVLcRDacRLu2x0Ri3Rwyp9GgQLFkqFd8mzixrzsAvxIxaWvRLvs+zV1flgj4UDSpPwnMX+459NMVfl73wvj5S4tGL+doUQyuSbJdLsqy2pIXkxz9WsLvJkRCIxFyv0oAo5nr3jg/+VUC/VWwdk8vmnlaQ4mVEPlww3D/1/cvISQTd3aMnt+3KcgRdQL0hrADQz/MqVuLC1k0nru7ryJoq6jDM1Hiy1f5silWLncSeNuOG2ePBnARMb0p6raMvZuBE4jBS0+k5tuWYIauCDGxbSqoERDy9RXvMo+KG8o2P1goJ+U/Bb05antgoNMQL7B2HNtExBTWyqYRSnaox8HyuDoGmXPOXIsDDTA
X-MS-Exchange-AntiSpam-MessageData: 2rvvTnzSHqSxLbQaUiccXYk6U+jtl0ias3sIK3ArV4NwvVtwhXEtc7q28jzjZ1YVhVzFwaBMrPcfcWBLA9ni3dmNn9Nc65DmSRyBolcSknzl0ejBZyp2cRQCvPlkCZvSljMh1UvhyFA6rXqawoAFsw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b242bc3b-d6c1-45d2-58a5-08d7d7351057
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 18:38:40.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0FC4i4ZC3lIkFHiU6e5/hZxsTEWAWZZhNsmXpo2167FiJV1Yr/2IcSJSdTBJQ9Qewx0IS4Wds75fRQxCFCyKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/2/20 12:51 PM, Krish Sadhukhan wrote:
>
> On 3/29/20 11:19 PM, Ashish Kalra wrote:
>> From: Brijesh Singh <Brijesh.Singh@amd.com>
>>
>> The command is used to create an outgoing SEV guest encryption context.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Reviewed-by: Steve Rutherford <srutherford@google.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
>>   arch/x86/kvm/svm.c                            | 128 ++++++++++++++++++
>>   include/linux/psp-sev.h                       |   8 +-
>>   include/uapi/linux/kvm.h                      |  12 ++
>>   4 files changed, 171 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst
>> b/Documentation/virt/kvm/amd-memory-encryption.rst
>> index c3129b9ba5cb..4fd34fc5c7a7 100644
>> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
>> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
>> @@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
>>                   __u32 trans_len;
>>           };
>>   +10. KVM_SEV_SEND_START
>> +----------------------
>> +
>> +The KVM_SEV_SEND_START command can be used by the hypervisor to
>> create an
>> +outgoing guest encryption context.
> Shouldn't we mention that this command is also used to save the guest
> to the disk ?


No, because this command is not used for saving to the disk.


>> +
>> +Parameters (in): struct kvm_sev_send_start
>> +
>> +Returns: 0 on success, -negative on error
>> +
>> +::
>> +        struct kvm_sev_send_start {
>> +                __u32 policy;                 /* guest policy */
>> +
>> +                __u64 pdh_cert_uaddr;         /* platform
>> Diffie-Hellman certificate */
>> +                __u32 pdh_cert_len;
>> +
>> +                __u64 plat_certs_uadr;        /* platform
>> certificate chain */
>> +                __u32 plat_certs_len;
>> +
>> +                __u64 amd_certs_uaddr;        /* AMD certificate */
>> +                __u32 amd_cert_len;
>> +
>> +                __u64 session_uaddr;          /* Guest session
>> information */
>> +                __u32 session_len;
>> +        };
>> +
>>   References
>>   ==========
>>   diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 50d1ebafe0b3..63d172e974ad 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -7149,6 +7149,131 @@ static int sev_launch_secret(struct kvm *kvm,
>> struct kvm_sev_cmd *argp)
>>       return ret;
>>   }
>>   +/* Userspace wants to query session length. */
>> +static int
>> +__sev_send_start_query_session_length(struct kvm *kvm, struct
>> kvm_sev_cmd *argp,
>
>
> __sev_query_send_start_session_length a better name perhaps ?
>
>> +                      struct kvm_sev_send_start *params)
>> +{
>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +    struct sev_data_send_start *data;
>> +    int ret;
>> +
>> +    data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
>> +    if (data == NULL)
>> +        return -ENOMEM;
>> +
>> +    data->handle = sev->handle;
>> +    ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
>
>
> We are not checking ret here as we are assuming that the command will
> always be successful. Is there any chance that sev->handle can be junk
> and should we have an ASSERT for it ?


Both failure and success of this command need to be propagated to the
userspace. In the case of failure the FW may provide additional
information which also need to be propagated to the userspace hence on
failure we should not be asserting.


>
>> +
>> +    params->session_len = data->session_len;
>> +    if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
>> +                sizeof(struct kvm_sev_send_start)))
>> +        ret = -EFAULT;
>> +
>> +    kfree(data);
>> +    return ret;
>> +}
>> +
>> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>
>
> For readability and ease of cscope searches, isn't it better to append
> "svm" to all these functions ?
>
> It seems svm_sev_enabled() is an example of an appropriate naming style.


I don't have strong opinion to prepend or append "svm" to all these
functions, it can be done outside this series. I personally don't see
any strong reason to append svm at this time. The SEV is applicable to
the SVM file only. There is a pending patch which moves all the SEV
stuff in svm/sev.c.


>
>> +{
>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +    struct sev_data_send_start *data;
>> +    struct kvm_sev_send_start params;
>> +    void *amd_certs, *session_data;
>> +    void *pdh_cert, *plat_certs;
>> +    int ret;
>> +
>> +    if (!sev_guest(kvm))
>> +        return -ENOTTY;
>> +
>> +    if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
>> +                sizeof(struct kvm_sev_send_start)))
>> +        return -EFAULT;
>> +
>> +    /* if session_len is zero, userspace wants to query the session
>> length */
>> +    if (!params.session_len)
>> +        return __sev_send_start_query_session_length(kvm, argp,
>> +                &params);
>> +
>> +    /* some sanity checks */
>> +    if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
>> +        !params.session_uaddr || params.session_len >
>> SEV_FW_BLOB_MAX_SIZE)
>> +        return -EINVAL;
>
>
> What if params.plat_certs_uaddr or params.amd_certs_uaddr is NULL ?
>
>> +
>> +    /* allocate the memory to hold the session data blob */
>> +    session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
>> +    if (!session_data)
>> +        return -ENOMEM;
>> +
>> +    /* copy the certificate blobs from userspace */
>
>
> You haven't added comments for plat_cert and amd_cert. Also, it's much
> more readable if you add block comments like,
>
>         /*
>
>          *  PDH cert
>
>          */
>
>> +    pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
>> +                params.pdh_cert_len);
>> +    if (IS_ERR(pdh_cert)) {
>> +        ret = PTR_ERR(pdh_cert);
>> +        goto e_free_session;
>> +    }
>> +
>> +    plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
>> +                params.plat_certs_len);
>> +    if (IS_ERR(plat_certs)) {
>> +        ret = PTR_ERR(plat_certs);
>> +        goto e_free_pdh;
>> +    }
>> +
>> +    amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
>> +                params.amd_certs_len);
>> +    if (IS_ERR(amd_certs)) {
>> +        ret = PTR_ERR(amd_certs);
>> +        goto e_free_plat_cert;
>> +    }
>> +
>> +    data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
>> +    if (data == NULL) {
>> +        ret = -ENOMEM;
>> +        goto e_free_amd_cert;
>> +    }
>> +
>> +    /* populate the FW SEND_START field with system physical address */
>> +    data->pdh_cert_address = __psp_pa(pdh_cert);
>> +    data->pdh_cert_len = params.pdh_cert_len;
>> +    data->plat_certs_address = __psp_pa(plat_certs);
>> +    data->plat_certs_len = params.plat_certs_len;
>> +    data->amd_certs_address = __psp_pa(amd_certs);
>> +    data->amd_certs_len = params.amd_certs_len;
>> +    data->session_address = __psp_pa(session_data);
>> +    data->session_len = params.session_len;
>> +    data->handle = sev->handle;
>> +
>> +    ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
>> +
>> +    if (ret)
>> +        goto e_free;
>> +
>> +    if (copy_to_user((void __user *)(uintptr_t) params.session_uaddr,
>> +            session_data, params.session_len)) {
>> +        ret = -EFAULT;
>> +        goto e_free;
>> +    }
>> +
>> +    params.policy = data->policy;
>> +    params.session_len = data->session_len;
>> +    if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
>> +                sizeof(struct kvm_sev_send_start)))
>> +        ret = -EFAULT;
>> +
>> +e_free:
>> +    kfree(data);
>> +e_free_amd_cert:
>> +    kfree(amd_certs);
>> +e_free_plat_cert:
>> +    kfree(plat_certs);
>> +e_free_pdh:
>> +    kfree(pdh_cert);
>> +e_free_session:
>> +    kfree(session_data);
>> +    return ret;
>> +}
>> +
>>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>   {
>>       struct kvm_sev_cmd sev_cmd;
>> @@ -7193,6 +7318,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void
>> __user *argp)
>>       case KVM_SEV_LAUNCH_SECRET:
>>           r = sev_launch_secret(kvm, &sev_cmd);
>>           break;
>> +    case KVM_SEV_SEND_START:
>> +        r = sev_send_start(kvm, &sev_cmd);
>> +        break;
>>       default:
>>           r = -EINVAL;
>>           goto out;
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 5167bf2bfc75..9f63b9d48b63 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -323,11 +323,11 @@ struct sev_data_send_start {
>>       u64 pdh_cert_address;            /* In */
>>       u32 pdh_cert_len;            /* In */
>>       u32 reserved1;
>> -    u64 plat_cert_address;            /* In */
>> -    u32 plat_cert_len;            /* In */
>> +    u64 plat_certs_address;            /* In */
>> +    u32 plat_certs_len;            /* In */
>
>
> It seems that the 'platform certificate' and the 'amd_certificate' are
> single entities, meaning only copy is there for the particular
> platform and particular the AMD product. Why are these plural then ?
>
>
>>       u32 reserved2;
>> -    u64 amd_cert_address;            /* In */
>> -    u32 amd_cert_len;            /* In */
>> +    u64 amd_certs_address;            /* In */
>> +    u32 amd_certs_len;            /* In */
>>       u32 reserved3;
>>       u64 session_address;            /* In */
>>       u32 session_len;            /* In/Out */
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 4b95f9a31a2f..17bef4c245e1 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1558,6 +1558,18 @@ struct kvm_sev_dbg {
>>       __u32 len;
>>   };
>>   +struct kvm_sev_send_start {
>> +    __u32 policy;
>> +    __u64 pdh_cert_uaddr;
>> +    __u32 pdh_cert_len;
>> +    __u64 plat_certs_uaddr;
>> +    __u32 plat_certs_len;
>> +    __u64 amd_certs_uaddr;
>> +    __u32 amd_certs_len;
>> +    __u64 session_uaddr;
>> +    __u32 session_len;
>> +};
>> +
>>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU    (1 << 0)
>>   #define KVM_DEV_ASSIGN_PCI_2_3        (1 << 1)
>>   #define KVM_DEV_ASSIGN_MASK_INTX    (1 << 2)
