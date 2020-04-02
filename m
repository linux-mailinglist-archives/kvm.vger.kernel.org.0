Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1825B19CCDC
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 00:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389851AbgDBW2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 18:28:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388218AbgDBW2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 18:28:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032MRgm1068806;
        Thu, 2 Apr 2020 22:27:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jAtOGQm+gLhgkn3BMXlmRy2Rbyh9TwngF7eP1Ox/CB0=;
 b=qbUNrSMdwH/2gmNSiUVty35iiQCR27OSfSuuvVERn6RySLSWDw4XO4TjaFGrz93S+Xmt
 cLubtrS1gEU/OEp5zPvlE3qK0Tkpmkx4k0WucXIa/HEIfoGxQEoggJ2GnmmlRErz/0UI
 Q+QBnOpXpYeuAcyrHRNiSIJyOP1qlAXM9rZZrrasrVutPgz+Bg4jlu+xu9ka9oA172sX
 tG56Jb0P45DSxlvyTnLB1ljlbPovWBrBmnyjs4wv3kAHJAivPgTOREPp8pC6Z/TnBGDn
 gH8p6chLoQP1/fQMQWWVBr4913XWeMaqAE/Rm/k3dQQbcuFLGaRu24cbNui0q04tIpLA 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yungrrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:27:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032MR8ar037919;
        Thu, 2 Apr 2020 22:27:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 304sjqrp3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:27:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032MReSx003606;
        Thu, 2 Apr 2020 22:27:40 GMT
Received: from localhost.localdomain (/10.159.142.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 15:27:40 -0700
Subject: Re: [PATCH v6 06/14] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0f8a2125c7acb7b38fc51a044a8088e8baa45e3d.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <8694381f-2083-e477-bea1-04fb572519d0@oracle.com>
Date:   Thu, 2 Apr 2020 15:27:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0f8a2125c7acb7b38fc51a044a8088e8baa45e3d.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:21 PM, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> The command finalize the guest receiving process and make the SEV guest
> ready for the execution.
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
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
>   arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
>   2 files changed, 31 insertions(+)
>
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 554aa33a99cc..93cd95d9a6c0 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -375,6 +375,14 @@ Returns: 0 on success, -negative on error
>                   __u32 trans_len;
>           };
>   
> +15. KVM_SEV_RECEIVE_FINISH
> +------------------------
> +
> +After completion of the migration flow, the KVM_SEV_RECEIVE_FINISH command can be
> +issued by the hypervisor to make the guest ready for execution.
> +
> +Returns: 0 on success, -negative on error
> +
>   References
>   ==========
>   
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 5fc5355536d7..7c2721e18b06 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7573,6 +7573,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_receive_finish *data;
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
> +	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, data, &argp->error);
> +
> +	kfree(data);
> +	return ret;
> +}
> +
>   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_sev_cmd sev_cmd;
> @@ -7632,6 +7652,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>   	case KVM_SEV_RECEIVE_UPDATE_DATA:
>   		r = sev_receive_update_data(kvm, &sev_cmd);
>   		break;
> +	case KVM_SEV_RECEIVE_FINISH:
> +		r = sev_receive_finish(kvm, &sev_cmd);
> +		break;
>   	default:
>   		r = -EINVAL;
>   		goto out;
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
