Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D391C642D
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 00:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgEEWvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 18:51:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgEEWvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 18:51:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045MnI6G098056;
        Tue, 5 May 2020 22:51:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=XGDjKTGSNe5944Iga4irJ5tXqXpy64d2pGEDwm2UX08=;
 b=Lve8JeNENcrCnjFxaTo9gH5MmkFHM28dsoh0oV+FzWG8/kiOKUdIWgvzetkaTXYPwVnW
 siRkgLlJIF8YTwFh3GUS60ic93UxS2rStj536ABrnPXaI3at4y/gfmH3l67SjeqOFSwg
 JglBNP+ihvzcvZJu+hBfJ+wRQ2VkzZzE7kizp7e2qZmIpOKmaPYTALFcsRuedtCFt3P7
 DTc9qS5xH5CnqP26UxfFFmFmkGvixb51nFSg2gVpdlw1XnB2sqNBvEbu/1iS6zz+hid9
 P06PxV3Eqlkcaw7TaJez+LxLgARinNLttQ3dUv4hDPaSGUTqq9uUiBym2UNB5Dm0C/e5 gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tmfej8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 22:51:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045MliHE098246;
        Tue, 5 May 2020 22:51:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r65wn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 22:51:04 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045Mp28D009762;
        Tue, 5 May 2020 22:51:03 GMT
Received: from vbusired-dt (/10.154.183.230)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 15:51:02 -0700
Date:   Tue, 5 May 2020 17:51:03 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v8 03/18] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Message-ID: <20200505225103.GB1721674@vbusired-dt>
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <3ad971e9977700140d9092259d5326caab986f1f.1588711355.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ad971e9977700140d9092259d5326caab986f1f.1588711355.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=1
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-05 21:15:11 +0000, Ashish Kalra wrote:
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

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
>  arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index d0dfa5b54e4f..93884ec8918e 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -314,6 +314,14 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>  
> +12. KVM_SEV_SEND_FINISH
> +------------------------
> +
> +After completion of the migration flow, the KVM_SEV_SEND_FINISH command can be
> +issued by the hypervisor to delete the encryption context.
> +
> +Returns: 0 on success, -negative on error
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7031b660f64d..4d3031c9fdcf 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1153,6 +1153,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
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
>  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -1203,6 +1223,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SEND_UPDATE_DATA:
>  		r = sev_send_update_data(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SEND_FINISH:
> +		r = sev_send_finish(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> -- 
> 2.17.1
> 
