Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C72519C8A0
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388381AbgDBSRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:17:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbgDBSRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 14:17:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032I9cZD150233;
        Thu, 2 Apr 2020 18:17:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=qWI5T/N7iP2w4FARfmbmB5Xd+vJTWKb7aE+P85B2lzk=;
 b=S6mH9uUICCcIkTsz52Ldr2OvROziVylaQhyM3AzENR09IOZ4pmGrX1PCl0ZMsKL+eUrI
 UqPYZ9FFiVvHbWW8vi/UwRUYOc8Yov1EZxpyFx1oqnYtRUHzt8hOvGWX0UJMg27gz5M6
 To3vbMhttsY2uIx6IA797QhRuVxaP9DR1E7bkXhFV0h3Drv6XTIx3hp5HOW9YBeeLNea
 OKNCg7gE4BNpyeXtauupY98ZZCudBopcbjUTmpHk9EcXCri7x37YWB0qo+QNbGSOS4EX
 PBOebfp0RtrpBkqar03d1bNlKmeffds4eB+rY+UbSe5+ECOXaigxEumbp3yRtKQ1e4x8 UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yunfpc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 18:17:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032ID8SM017175;
        Thu, 2 Apr 2020 18:17:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 304sjq6eb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 18:17:15 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032IHEb9013046;
        Thu, 2 Apr 2020 18:17:15 GMT
Received: from vbusired-dt (/10.154.166.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 11:17:14 -0700
Date:   Thu, 2 Apr 2020 13:17:10 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 03/14] KVM: SVM: Add KVM_SEV_SEND_FINISH command
Message-ID: <20200402181710.GA655710@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <798316bc964cef34d2760a87de0fb6dc4e5d9af3.1585548051.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <798316bc964cef34d2760a87de0fb6dc4e5d9af3.1585548051.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020139
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-30 06:20:49 +0000, Ashish Kalra wrote:
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
>  arch/x86/kvm/svm.c                            | 23 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index f46817ef7019..a45dcb5f8687 100644
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

Didn't notice this earlier. I would suggest changing all occurrences of
"-negative" to either "negative" or "less than 0" in this file.

> +
>  References
>  ==========
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 8561c47cc4f9..71a4cb3b817d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7399,6 +7399,26 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
>  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_sev_cmd sev_cmd;
> @@ -7449,6 +7469,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
