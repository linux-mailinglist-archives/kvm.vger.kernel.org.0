Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD07019CADD
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 22:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbgDBUQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 16:16:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388635AbgDBUQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 16:16:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032KE6Ga183441;
        Thu, 2 Apr 2020 20:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FWYt1UE/Y2lVHUEiElPMUybW1qrGCZQ+MguSEWj3fMA=;
 b=o0eS/w1clb6oJyImtDX2EhX5uScMSqRT/rqBn6DU1x6zm/dXwqvtmK+bcO7hOUxVvRnZ
 l1y7a9rP5ZEjm9VcNZWW+bK/Wu7WRundUsYdNbeY0o2hQNcx7phE0A83rZVs3B8oH8p4
 E0fO9/Cxc6VfvPbf5mH3RrlJakds+ixPlQRjtcNEDGtfu1Wktcmm/XYvAjY+Iry73s1y
 7W5Oa1zpFtXT69HxqgcK6I7S1PVpeCE/izLQ6YOnFseE4xrgVkgdtLd6Ih0jCPVIvyGM
 5hLMjUFSBWkY/Gk7CDWNHeBO0UMp2W9ML7TuRwAnAjOOEnpWXwW/fk/hHG1pQ2q0Lb7T 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 303cevdp3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 20:15:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032KD05B044918;
        Thu, 2 Apr 2020 20:15:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 302g2k7dqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 20:15:55 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032KFrhG013396;
        Thu, 2 Apr 2020 20:15:54 GMT
Received: from localhost.localdomain (/10.159.142.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 13:15:53 -0700
Subject: Re: [PATCH v6 03/14] KVM: SVM: Add KVM_SEV_SEND_FINISH command
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <798316bc964cef34d2760a87de0fb6dc4e5d9af3.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4e9870fc-1cab-2058-b045-822ae5170e51@oracle.com>
Date:   Thu, 2 Apr 2020 13:15:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <798316bc964cef34d2760a87de0fb6dc4e5d9af3.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:20 PM, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> The command is used to finailize the encryption context created with
> KVM_SEV_SEND_START command.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
>   arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
>   2 files changed, 31 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index f46817ef7019..a45dcb5f8687 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -314,6 +314,14 @@ Returns: 0 on success, -negative on error
>                   __u32 trans_len;
>           };
>   
> +12. KVM_SEV_SEND_FINISH
> +------------------------
> +
> +After completion of the migration flow, the KVM_SEV_SEND_FINISH command can be
> +issued by the hypervisor to delete the encryption context.
> +
> +Returns: 0 on success, -negative on error
> +
>   References
>   ==========
>   
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 8561c47cc4f9..71a4cb3b817d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7399,6 +7399,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static int sev_send_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_send_finish *data;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->handle = sev->handle;
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_FINISH, data, &argp->error);
> +
> +	kfree(data);
> +	return ret;
> +}
> +
>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -7449,6 +7469,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_SEND_UPDATE_DATA:
>   		r = sev_send_update_data(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_SEND_FINISH:
> +		r = sev_send_finish(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
