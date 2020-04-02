Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49ADF19CCD4
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389809AbgDBWZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 18:25:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49122 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgDBWZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 18:25:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032M9wGp140607;
        Thu, 2 Apr 2020 22:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=vG7MC2PNgxon4CeEkpAfEDnqjImA+hC2tBGaFp2oSTA=;
 b=uWogSPw74NKyE5+4Al78711YJ5745W2SKqzk/T2WMuszmZoSSu+XkSHWZJmxFsPwXHSW
 6JQlNMcsaph5FmmhogFrzPk49IzRV499vExfSjEo5g+G86Zd/JjaMS4KwBh8JL6OCM8L
 EeeaYItz00GPQ+Oznwghdfn+cCdRzH/aimedrGPrV9ohsE1jy/opGzbAdQvJLCXSKMR4
 qOi/r9pZ/7R+7hSyomioaSR9+FZ9fYSXoSRX2H2ALbyV1PLkbcxFPB24e/82BFNXx8YX
 c9AQCKwWZpNCaj6Phf5r+kiz3/ULb0jPdY5Cog/OZVYWBj/YfpLXQJDfFkfcB9vXe2fl /Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 303yungrht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:25:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032M8HxX048377;
        Thu, 2 Apr 2020 22:25:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 302ga3864b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:25:04 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 032MP2cJ009676;
        Thu, 2 Apr 2020 22:25:02 GMT
Received: from vbusired-dt (/10.154.166.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 15:25:01 -0700
Date:   Thu, 2 Apr 2020 17:24:57 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 06/14] KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
Message-ID: <20200402222457.GA659325@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0f8a2125c7acb7b38fc51a044a8088e8baa45e3d.1585548051.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f8a2125c7acb7b38fc51a044a8088e8baa45e3d.1585548051.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020164
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-30 06:21:36 +0000, Ashish Kalra wrote:
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
>  .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
>  arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 554aa33a99cc..93cd95d9a6c0 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -375,6 +375,14 @@ Returns: 0 on success, -negative on error
>                  __u32 trans_len;
>          };
>  
> +15. KVM_SEV_RECEIVE_FINISH
> +------------------------
> +
> +After completion of the migration flow, the KVM_SEV_RECEIVE_FINISH command can be
> +issued by the hypervisor to make the guest ready for execution.
> +
> +Returns: 0 on success, -negative on error
> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 5fc5355536d7..7c2721e18b06 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7573,6 +7573,26 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_data_receive_finish *data;
> +	int ret;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;

Noticed this in earlier patches too. Is -ENOTTY the best return value?
Aren't one of -ENXIO, or -ENODEV, or -EINVAL a better choice? What is
the rationale for using -ENOTTY?

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
>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -7632,6 +7652,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_RECEIVE_UPDATE_DATA:
>  		r = sev_receive_update_data(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_RECEIVE_FINISH:
> +		r = sev_receive_finish(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> -- 
> 2.17.1
> 
