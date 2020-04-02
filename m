Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F54819C881
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389517AbgDBSES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:04:18 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:18556
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732600AbgDBSES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 14:04:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3V+/koYt5BmHT9shoW4WYjDn6SP5JItM19vdPul71W4+l20VxpPbg5uu5ueELwDsHiBi4pJdIG8/VNU8/KohBt/wOFmQAsqrwaoTrscJ446VXthuti4/ApH/fYHvuBPfa7Acl6UeHNOIEngNvtXsm8ReB5Gtt5SDzZmNG7q70S5ef9P3fvP/nzmE18xN9szTOw5bgsBKkicKLKAup09TvpNGl2/W/Q9zJ1s3/Vczd2ompYhf4QdlUGYg/dA6DwyCBW9KNPPvGLyNxTIMg3FifLvcI8jZgmGOL0NYTSj8bHi/PhAO01XbQLQLJkc9pbzY+Cs80kiq0oLi5PXgZAhKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WipZKBMIooTm44WW+HzZaxbGnqvI4MOCuEeGCW+Gzs=;
 b=cO3txvxzg5dxBd5nauimGLtIiCz4z1+oDbJBzuMwANsv4rovwaefK6mrEyKhC3kGMoEP7VLecShO9x/58Zr5JOOtbhuQkqMUx7Y6XpaWTp76/cewUi5LU8eHLiJio4uGyAXep+58VLJL1yVHEeKRAjz/cu5Td+KNygq/pYA3FyIq7JTfnioM/yYAbCqqUC88kzTiBB2Bl+tdk376XtkoS7T9FKed4uBDR5Ggw+iUaMg+b0lSPhf7WpNBWuEv1nde0Y5UxI9VWpvIwqvx0YR5jw0nZgFGl/+7SCIcYE2FiZevipP7X/8wlNFEyNKZ7ObHBo+icoVtym880CE3ndP4jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WipZKBMIooTm44WW+HzZaxbGnqvI4MOCuEeGCW+Gzs=;
 b=u9zWoYFn9nMY0EZaqgi736hZ+XpY6VfgaeaStTLBkGMqA7ZB0SywhBEoAw+fcBdoMH2h1md6ES1VAaB+xW77gfeNQawPHffJBHxZ1ax1Lh04v+y4KXbyeXLq7E+Qq2UNGtXTta2j9gRLnUNJLkq1WFfNl9lpeapOkd++DehFQfM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4494.namprd12.prod.outlook.com (2603:10b6:806:94::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Thu, 2 Apr
 2020 18:04:12 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 18:04:12 +0000
Cc:     brijesh.singh@amd.com, Ashish Kalra <Ashish.Kalra@amd.com>,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 01/14] KVM: SVM: Add KVM_SEV SEND_START command
To:     Venu Busireddy <venu.busireddy@oracle.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
 <20200402062726.GA647295@vbusired-dt>
 <89a586e4-8074-0d32-f384-a4597975d129@amd.com>
 <20200402163717.GA653926@vbusired-dt>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <8b1b4874-11a8-1422-5ea1-ed665f41ab5c@amd.com>
Date:   Thu, 2 Apr 2020 13:04:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200402163717.GA653926@vbusired-dt>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: DM5PR21CA0012.namprd21.prod.outlook.com
 (2603:10b6:3:ac::22) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by DM5PR21CA0012.namprd21.prod.outlook.com (2603:10b6:3:ac::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.0 via Frontend Transport; Thu, 2 Apr 2020 18:04:09 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ca7a439-c11e-456e-7275-08d7d7303f8e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4494:|SA0PR12MB4494:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44941BC34D58BEE383BC6211E5C60@SA0PR12MB4494.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(4326008)(81156014)(2616005)(8936002)(6666004)(16526019)(6512007)(26005)(31686004)(30864003)(186003)(8676002)(81166006)(956004)(36756003)(31696002)(86362001)(5660300002)(66556008)(66476007)(478600001)(53546011)(2906002)(52116002)(66574012)(316002)(66946007)(6916009)(44832011)(7416002)(6486002)(6506007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Wbvp1xQICHRcI1iPLhYTbykkMgmCQ0SG34B5dzP1Rphl0qN1rRzMB75yC8Q45pQyIW+Pee9UyCqg4phxEXD4aKfJyc9e7qtVMZB72Qma5wLavPZT+QWBgE8nxpCSGYDOHUxkA0p2fveVTGXHyD7HJHi0e81Pz7zGLczs5iCOYeptCRoWH+ysShb4fewBPT8WrDhXAB5GuYA29cbsSSfKfs3hUmgZm69Sa6HTYwbSzwe18zIPZpC9mpfMQ+ufqEG6rQd8XIdNIlbLbaFLoX+1zXqt5QmyoBMyzjf7nAT3HyFhbB0XZFZk/cqbT8+KMar8r8BDabMwe3hLaCOaMsfkPrk9cDi6EMfhj+nfoCLKXZeCVKWx3eZ4y2IPrq/JKejp/1biWcXK7EjPYcZmsdwbP9ZtJMk7PvkQWL+TPhCOebJkVSq4hyYLhzyyb9kXxq2
X-MS-Exchange-AntiSpam-MessageData: tNNhlohARo0hjR+IjrMix0UmlJcQlD0b8cp/MCZ0FvCMmP5VIiUHtls6itsnqTIHz5FBYL1++IifBnPKnbNyPEr5bt2MgRr/OdSqWaEP+2iC99Wk3kJkj7vw67mnJ0QYcSzlSlu2cg48JIALRr+f6w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca7a439-c11e-456e-7275-08d7d7303f8e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 18:04:12.3037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtJhWU/8eYoFRA8QBht9IYtTyq3K9c9/b4p+1PeVm5YXkRJ0EQLDP2TFiIV2Nb7vv/bZwyVbS0ON3B9hso8w3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4494
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/2/20 11:37 AM, Venu Busireddy wrote:
> On 2020-04-02 07:59:54 -0500, Brijesh Singh wrote:
>> Hi Venu,
>>
>> Thanks for the feedback.
>>
>> On 4/2/20 1:27 AM, Venu Busireddy wrote:
>>> On 2020-03-30 06:19:59 +0000, Ashish Kalra wrote:
>>>> From: Brijesh Singh <Brijesh.Singh@amd.com>
>>>>
>>>> The command is used to create an outgoing SEV guest encryption context.
>>>>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Ingo Molnar <mingo@redhat.com>
>>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
>>>> Cc: Joerg Roedel <joro@8bytes.org>
>>>> Cc: Borislav Petkov <bp@suse.de>
>>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>>> Cc: x86@kernel.org
>>>> Cc: kvm@vger.kernel.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Reviewed-by: Steve Rutherford <srutherford@google.com>
>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> ---
>>>>  .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
>>>>  arch/x86/kvm/svm.c                            | 128 ++++++++++++++++++
>>>>  include/linux/psp-sev.h                       |   8 +-
>>>>  include/uapi/linux/kvm.h                      |  12 ++
>>>>  4 files changed, 171 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
>>>> index c3129b9ba5cb..4fd34fc5c7a7 100644
>>>> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
>>>> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
>>>> @@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
>>>>                  __u32 trans_len;
>>>>          };
>>>>  
>>>> +10. KVM_SEV_SEND_START
>>>> +----------------------
>>>> +
>>>> +The KVM_SEV_SEND_START command can be used by the hypervisor to create an
>>>> +outgoing guest encryption context.
>>>> +
>>>> +Parameters (in): struct kvm_sev_send_start
>>>> +
>>>> +Returns: 0 on success, -negative on error
>>>> +
>>>> +::
>>>> +        struct kvm_sev_send_start {
>>>> +                __u32 policy;                 /* guest policy */
>>>> +
>>>> +                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
>>>> +                __u32 pdh_cert_len;
>>>> +
>>>> +                __u64 plat_certs_uadr;        /* platform certificate chain */
>>> Could this please be changed to plat_certs_uaddr, as it is referred to
>>> in the rest of the code?
>>>
>>>> +                __u32 plat_certs_len;
>>>> +
>>>> +                __u64 amd_certs_uaddr;        /* AMD certificate */
>>>> +                __u32 amd_cert_len;
>>> Could this please be changed to amd_certs_len, as it is referred to in
>>> the rest of the code?
>>>
>>>> +
>>>> +                __u64 session_uaddr;          /* Guest session information */
>>>> +                __u32 session_len;
>>>> +        };
>>>> +
>>>>  References
>>>>  ==========
>>>>  
>>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>>> index 50d1ebafe0b3..63d172e974ad 100644
>>>> --- a/arch/x86/kvm/svm.c
>>>> +++ b/arch/x86/kvm/svm.c
>>>> @@ -7149,6 +7149,131 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>  	return ret;
>>>>  }
>>>>  
>>>> +/* Userspace wants to query session length. */
>>>> +static int
>>>> +__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>>> +				      struct kvm_sev_send_start *params)
>>>> +{
>>>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> +	struct sev_data_send_start *data;
>>>> +	int ret;
>>>> +
>>>> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
>>>> +	if (data == NULL)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	data->handle = sev->handle;
>>>> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
>>>> +
>>>> +	params->session_len = data->session_len;
>>>> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
>>>> +				sizeof(struct kvm_sev_send_start)))
>>>> +		ret = -EFAULT;
>>>> +
>>>> +	kfree(data);
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>> +{
>>>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> +	struct sev_data_send_start *data;
>>>> +	struct kvm_sev_send_start params;
>>>> +	void *amd_certs, *session_data;
>>>> +	void *pdh_cert, *plat_certs;
>>>> +	int ret;
>>>> +
>>>> +	if (!sev_guest(kvm))
>>>> +		return -ENOTTY;
>>>> +
>>>> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
>>>> +				sizeof(struct kvm_sev_send_start)))
>>>> +		return -EFAULT;
>>>> +
>>>> +	/* if session_len is zero, userspace wants to query the session length */
>>>> +	if (!params.session_len)
>>>> +		return __sev_send_start_query_session_length(kvm, argp,
>>>> +				&params);
>>>> +
>>>> +	/* some sanity checks */
>>>> +	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
>>>> +	    !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX_SIZE)
>>>> +		return -EINVAL;
>>>> +
>>>> +	/* allocate the memory to hold the session data blob */
>>>> +	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
>>>> +	if (!session_data)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	/* copy the certificate blobs from userspace */
>>>> +	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
>>>> +				params.pdh_cert_len);
>>>> +	if (IS_ERR(pdh_cert)) {
>>>> +		ret = PTR_ERR(pdh_cert);
>>>> +		goto e_free_session;
>>>> +	}
>>>> +
>>>> +	plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
>>>> +				params.plat_certs_len);
>>>> +	if (IS_ERR(plat_certs)) {
>>>> +		ret = PTR_ERR(plat_certs);
>>>> +		goto e_free_pdh;
>>>> +	}
>>>> +
>>>> +	amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
>>>> +				params.amd_certs_len);
>>>> +	if (IS_ERR(amd_certs)) {
>>>> +		ret = PTR_ERR(amd_certs);
>>>> +		goto e_free_plat_cert;
>>>> +	}
>>>> +
>>>> +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
>>>> +	if (data == NULL) {
>>>> +		ret = -ENOMEM;
>>>> +		goto e_free_amd_cert;
>>>> +	}
>>>> +
>>>> +	/* populate the FW SEND_START field with system physical address */
>>>> +	data->pdh_cert_address = __psp_pa(pdh_cert);
>>>> +	data->pdh_cert_len = params.pdh_cert_len;
>>>> +	data->plat_certs_address = __psp_pa(plat_certs);
>>>> +	data->plat_certs_len = params.plat_certs_len;
>>>> +	data->amd_certs_address = __psp_pa(amd_certs);
>>>> +	data->amd_certs_len = params.amd_certs_len;
>>>> +	data->session_address = __psp_pa(session_data);
>>>> +	data->session_len = params.session_len;
>>>> +	data->handle = sev->handle;
>>>> +
>>>> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
>>>> +
>>>> +	if (ret)
>>>> +		goto e_free;
>>>> +
>>>> +	if (copy_to_user((void __user *)(uintptr_t) params.session_uaddr,
>>>> +			session_data, params.session_len)) {
>>>> +		ret = -EFAULT;
>>>> +		goto e_free;
>>>> +	}
>>> To optimize the amount of data being copied to user space, could the
>>> above section of code changed as follows?
>>>
>>> 	params.session_len = data->session_len;
>>> 	if (copy_to_user((void __user *)(uintptr_t) params.session_uaddr,
>>> 			session_data, params.session_len)) {
>>> 		ret = -EFAULT;
>>> 		goto e_free;
>>> 	}
>>
>> We should not be using the data->session_len, it will cause -EFAULT when
>> user has not allocated enough space in the session_uaddr. Lets consider
>> the case where user passes session_len=10 but firmware thinks the
>> session length should be 64. In that case the data->session_len will
>> contains a value of 64 but userspace has allocated space for 10 bytes
>> and copy_to_user() will fail. If we are really concern about the amount
>> of data getting copied to userspace then use min_t(size_t,
>> params.session_len, data->session_len).
> We are allocating a buffer of params.session_len size and passing that
> buffer, and that length via data->session_len, to the firmware. Why would
> the firmware set data->session_len to a larger value, in spite of telling
> it that the buffer is only params.session_len long? I thought that only
> the reverse is possible, that is, the user sets the params.session_len
> to the MAX, but the session data is actually smaller than that size.


The question is, how does a userspace know the session length ? One
method is you can precalculate a value based on your firmware version
and have userspace pass that, or another approach is set
params.session_len = 0 and query it from the FW. The FW spec allow to
query the length, please see the spec. In the qemu patches I choose
second approach. This is because session blob can change from one FW
version to another and I tried to avoid calculating or hardcoding the
length for a one version of the FW. You can certainly choose the first
method. We want to ensure that kernel interface works on the both cases.


> Also, if for whatever reason the firmware sets data->session_len to
> a larger value than what is passed, what is the user space expected
> to do when the call returns? If the user space tries to access
> params.session_len amount of data, it will possibly get a memory access
> violation, because it did not originally allocate that large a buffer.
>
> If we do go with using min_t(size_t, params.session_len,
> data->session_len), then params.session_len should also be set to the
> smaller of the two, right?
>
>>>> +
>>>> +	params.policy = data->policy;
>>>> +	params.session_len = data->session_len;
>>>> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
>>>> +				sizeof(struct kvm_sev_send_start)))
>>>> +		ret = -EFAULT;
>>> Since the only fields that are changed in the kvm_sev_send_start structure
>>> are session_len and policy, why do we need to copy the entire structure
>>> back to the user? Why not just those two values? Please see the changes
>>> proposed to kvm_sev_send_start structure further below to accomplish this.
>> I think we also need to consider the code readability while saving the
>> CPU cycles. This is very small structure. By duplicating into two calls
>> #1 copy params.policy and #2 copy params.session_len we will add more
>> CPU cycle. And, If we get creative and rearrange the structure then code
>> readability is lost because now the copy will depend on how the
>> structure is layout in the memory.
> I was not recommending splitting that call into two. That would certainly
> be more expensive, than copying the entire structure. That is the reason
> why I suggested reordering the members of kvm_sev_send_start. Isn't
> there plenty of code where structures are defined in a way to keep the
> data movement efficient? :-)
>
> Please see my other comment below.
>
>>> 	params.policy = data->policy;
>>> 	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
>>> 			sizeof(params.policy) + sizeof(params.session_len))
>>> 		ret = -EFAULT;
>>>> +
>>>> +e_free:
>>>> +	kfree(data);
>>>> +e_free_amd_cert:
>>>> +	kfree(amd_certs);
>>>> +e_free_plat_cert:
>>>> +	kfree(plat_certs);
>>>> +e_free_pdh:
>>>> +	kfree(pdh_cert);
>>>> +e_free_session:
>>>> +	kfree(session_data);
>>>> +	return ret;
>>>> +}
>>>> +
>>>>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>>  {
>>>>  	struct kvm_sev_cmd sev_cmd;
>>>> @@ -7193,6 +7318,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>>>>  	case KVM_SEV_LAUNCH_SECRET:
>>>>  		r = sev_launch_secret(kvm, &sev_cmd);
>>>>  		break;
>>>> +	case KVM_SEV_SEND_START:
>>>> +		r = sev_send_start(kvm, &sev_cmd);
>>>> +		break;
>>>>  	default:
>>>>  		r = -EINVAL;
>>>>  		goto out;
>>>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>>>> index 5167bf2bfc75..9f63b9d48b63 100644
>>>> --- a/include/linux/psp-sev.h
>>>> +++ b/include/linux/psp-sev.h
>>>> @@ -323,11 +323,11 @@ struct sev_data_send_start {
>>>>  	u64 pdh_cert_address;			/* In */
>>>>  	u32 pdh_cert_len;			/* In */
>>>>  	u32 reserved1;
>>>> -	u64 plat_cert_address;			/* In */
>>>> -	u32 plat_cert_len;			/* In */
>>>> +	u64 plat_certs_address;			/* In */
>>>> +	u32 plat_certs_len;			/* In */
>>>>  	u32 reserved2;
>>>> -	u64 amd_cert_address;			/* In */
>>>> -	u32 amd_cert_len;			/* In */
>>>> +	u64 amd_certs_address;			/* In */
>>>> +	u32 amd_certs_len;			/* In */
>>>>  	u32 reserved3;
>>>>  	u64 session_address;			/* In */
>>>>  	u32 session_len;			/* In/Out */
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index 4b95f9a31a2f..17bef4c245e1 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -1558,6 +1558,18 @@ struct kvm_sev_dbg {
>>>>  	__u32 len;
>>>>  };
>>>>  
>>>> +struct kvm_sev_send_start {
>>>> +	__u32 policy;
>>>> +	__u64 pdh_cert_uaddr;
>>>> +	__u32 pdh_cert_len;
>>>> +	__u64 plat_certs_uaddr;
>>>> +	__u32 plat_certs_len;
>>>> +	__u64 amd_certs_uaddr;
>>>> +	__u32 amd_certs_len;
>>>> +	__u64 session_uaddr;
>>>> +	__u32 session_len;
>>>> +};
>>> Redo this structure as below:
>>>
>>> struct kvm_sev_send_start {
>>> 	__u32 policy;
>>> 	__u32 session_len;
>>> 	__u64 session_uaddr;
>>> 	__u64 pdh_cert_uaddr;
>>> 	__u32 pdh_cert_len;
>>> 	__u64 plat_certs_uaddr;
>>> 	__u32 plat_certs_len;
>>> 	__u64 amd_certs_uaddr;
>>> 	__u32 amd_certs_len;
>>> };
>>>
>>> Or as below, just to make it look better.
>>>
>>> struct kvm_sev_send_start {
>>> 	__u32 policy;
>>> 	__u32 session_len;
>>> 	__u64 session_uaddr;
>>> 	__u32 pdh_cert_len;
>>> 	__u64 pdh_cert_uaddr;
>>> 	__u32 plat_certs_len;
>>> 	__u64 plat_certs_uaddr;
>>> 	__u32 amd_certs_len;
>>> 	__u64 amd_certs_uaddr;
>>> };
>>>
>> Wherever applicable, I tried  best to not divert from the SEV spec
>> structure layout. Anyone who is reading the SEV FW spec  will see a
>> similar structure layout in the KVM/PSP header files. I would prefer to
>> stick to that approach.
> This structure is in uapi, and is anyway different from the
> sev_data_send_start, right? Does it really need to stay close to the
> firmware structure layout? Just because the firmware folks thought of
> a structure layout, that should not prevent our code to be efficient.
>
>>
>>>> +
>>>>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>>>>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>>>>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
>>>> -- 
>>>> 2.17.1
>>>>
