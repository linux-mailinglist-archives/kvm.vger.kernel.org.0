Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0881F1C490A
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 23:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgEDVYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 17:24:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgEDVYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 17:24:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LNlpG004033;
        Mon, 4 May 2020 21:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=v8bZfrKUd3qwtF/Kh9/wL9ZXJjJGiI1UmvKJcW7vQvQ=;
 b=WV8XvfPoJT80Y2r/XvMnN9ypfZsMl1/qn0YsbgCDEMWUYCg8ei6cVBsKA/fzUfEhTkSp
 wDfEyrmi/Le5+xghN92yuFIXJKXSUUXL6GgmDHb3x+5n4o+Lnl2RztaKTNQ2s52yDgzg
 p/2Lf0ef+95w+ajWmaH4xKAM0zK4w9oSOu4OBcaOW5excCEHxAr4PILxR/d9Td5UHNPA
 mNSddvjDdA6QLcJ6oDEn96nvG9ewBfdj1kTe5LmNHsp0xwM8WlX6qDCIoTkCnJ9bLHIu
 7ihOhT/HwG9ZjedXlufoh4tdz7j4s+Ut0VlSHzgn8XAQtyUxbA5DHOCeHGj2JkUZH4qX Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09r1g09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:23:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044LGgCp168945;
        Mon, 4 May 2020 21:21:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30sjdrev8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 21:21:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044LLhsI021293;
        Mon, 4 May 2020 21:21:43 GMT
Received: from vbusired-dt (/10.39.235.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 14:21:42 -0700
Date:   Mon, 4 May 2020 16:21:41 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v7 03/18] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Message-ID: <20200504212141.GA1699981@vbusired-dt>
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <c0cd07661be8c0ce6f395a386401289a0f362765.1588234824.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0cd07661be8c0ce6f395a386401289a0f362765.1588234824.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040167
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-30 08:41:08 +0000, Ashish Kalra wrote:
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
>  .../virt/kvm/amd-memory-encryption.rst        |  8 +++++++
>  arch/x86/kvm/svm/sev.c                        | 23 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index f46817ef7019..a45dcb5f8687 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -314,6 +314,14 @@ Returns: 0 on success, -negative on error

As I commented in the v6 patches
(see https://lore.kernel.org/kvm/20200402181710.GA655710@vbusired-dt/),
there are multiple occurrences of the word "-negative" in
amd-memory-encryption.rst. Can these be changed to either "negative" or
"less than 0"?


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
> index 0c92c16505ab..81d661706d31 100644
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
