Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017464D67F0
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350861AbiCKRqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbiCKRqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:46:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401BF1255B0;
        Fri, 11 Mar 2022 09:45:28 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BGxuW5022881;
        Fri, 11 Mar 2022 17:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3b2nibAMws2b1GIL9mmeddUm1EzPhK+sGyUZg4lEX7U=;
 b=JpCJXWy2y+trFAUXkCrzXzwHB95v/oi1iEw3ZzOD8QaBgYIt0CpiybES9MhtIJq3gkao
 QSveo59kmKQvMXUuSIaJ2zRAV1s4Vh8PGVAtcM1XxQeFqdt//uHfXu/LCFmeLDO2WrlO
 FYotecC3NlEXLIPVaTamN5o9CyTIKFHUdsiz4Fj/6nTFqSl+rTWeCwTxtAdwTVyfrAzS
 nbynxH8xHQfY8y5efV6fay4Lp7FU10u2FWjXC44vAnmAESKbIVfG+U9zvcMGaC/Oxvcl
 9ahYGEeRzfh7LNbKmryNovgdP+Q9ycNEbPu1ORFn7aTrULuaz6HvPxlagoeTwG8GM+eb hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqfxgrwxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:27 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BHVcKT003095;
        Fri, 11 Mar 2022 17:45:27 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eqfxgrwx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:27 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHhLg9025386;
        Fri, 11 Mar 2022 17:45:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3enpk30tkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHjLZt45416924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:45:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8824F11C05C;
        Fri, 11 Mar 2022 17:45:21 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E08F11C052;
        Fri, 11 Mar 2022 17:45:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Mar 2022 17:45:21 +0000 (GMT)
Date:   Fri, 11 Mar 2022 18:40:59 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v2 3/9] KVM: s390: pv: Add query interface
Message-ID: <20220311184059.25161d62@p-imbrenda>
In-Reply-To: <20220310103112.2156-4-frankja@linux.ibm.com>
References: <20220310103112.2156-1-frankja@linux.ibm.com>
        <20220310103112.2156-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -nwyTGhTXzmRw9pb6N_LBI7pLiwLctlc
X-Proofpoint-ORIG-GUID: zEfkuybDUUGkGWrMW-800YOb3AhhTgqW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_07,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Mar 2022 10:31:06 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Some of the query information is already available via sysfs but
> having a IOCTL makes the information easier to retrieve.

if I understand correctly, this will be forward-compatible but not
backwards compatible.

you return the amount of bytes written into the buffer, but only if the
buffer was already big enough.

a newer userspace will work with an older kernel, but an older
userspace will not work with a newer kernel.

a solution would be to return the size of the struct, so userspace can
know how much of the buffer was written (if it was bigger than the
struct), or that there are unwritten bits (if the buffer was smaller).

and even if the buffer was too small, write back as much of it as
possible to userspace.

this way, an older userspace will get the information it expects.


I am also not a big fan of writing the size in the input struct (I think
returning it would be cleaner), but I do not have a strong opinion

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 76 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h | 25 +++++++++++++
>  2 files changed, 101 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 020356653d1a..67e1e445681f 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2224,6 +2224,42 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	return r;
>  }
>  
> +/*
> + * Here we provide user space with a direct interface to query UV
> + * related data like UV maxima and available features as well as
> + * feature specific data.
> + *
> + * To facilitate future extension of the data structures we'll try to
> + * write data up to the maximum requested length.
> + */
> +static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
> +{
> +	ssize_t len;
> +
> +	switch (info->header.id) {
> +	case KVM_PV_INFO_VM: {
> +		len =  sizeof(info->header) + sizeof(info->vm);
> +
> +		if (info->header.len_max < len)
> +			return -EINVAL;
> +
> +		memcpy(info->vm.inst_calls_list,
> +		       uv_info.inst_calls_list,
> +		       sizeof(uv_info.inst_calls_list));
> +
> +		/* It's max cpuidm not max cpus so it's off by one */
> +		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
> +		info->vm.max_guests = uv_info.max_num_sec_conf;
> +		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
> +		info->vm.feature_indication = uv_info.uv_feature_indications;
> +
> +		return len;
> +	}
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  {
>  	int r = 0;
> @@ -2360,6 +2396,46 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  			     cmd->rc, cmd->rrc);
>  		break;
>  	}
> +	case KVM_PV_INFO: {
> +		struct kvm_s390_pv_info info = {};
> +		ssize_t data_len;
> +
> +		/*
> +		 * No need to check the VM protection here.
> +		 *
> +		 * Maybe user space wants to query some of the data
> +		 * when the VM is still unprotected. If we see the
> +		 * need to fence a new data command we can still
> +		 * return an error in the info handler.
> +		 */
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&info, argp, sizeof(info.header)))
> +			break;
> +
> +		r = -EINVAL;
> +		if (info.header.len_max < sizeof(info.header))
> +			break;
> +
> +		data_len = kvm_s390_handle_pv_info(&info);
> +		if (data_len < 0) {
> +			r = data_len;
> +			break;
> +		}
> +		/*
> +		 * If a data command struct is extended (multiple
> +		 * times) this can be used to determine how much of it
> +		 * is valid.
> +		 */
> +		info.header.len_written = data_len;
> +
> +		r = -EFAULT;
> +		if (copy_to_user(argp, &info, data_len))
> +			break;
> +
> +		r = 0;
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a02bbf8fd0f6..21f19863c417 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1643,6 +1643,30 @@ struct kvm_s390_pv_unp {
>  	__u64 tweak;
>  };
>  
> +enum pv_cmd_info_id {
> +	KVM_PV_INFO_VM,
> +};
> +
> +struct kvm_s390_pv_info_vm {
> +	__u64 inst_calls_list[4];
> +	__u64 max_cpus;
> +	__u64 max_guests;
> +	__u64 max_guest_addr;
> +	__u64 feature_indication;
> +};
> +
> +struct kvm_s390_pv_info_header {
> +	__u32 id;
> +	__u32 len_max;
> +	__u32 len_written;
> +	__u32 reserved;
> +};
> +
> +struct kvm_s390_pv_info {
> +	struct kvm_s390_pv_info_header header;
> +	struct kvm_s390_pv_info_vm vm;
> +};
> +
>  enum pv_cmd_id {
>  	KVM_PV_ENABLE,
>  	KVM_PV_DISABLE,
> @@ -1651,6 +1675,7 @@ enum pv_cmd_id {
>  	KVM_PV_VERIFY,
>  	KVM_PV_PREP_RESET,
>  	KVM_PV_UNSHARE_ALL,
> +	KVM_PV_INFO,
>  };
>  
>  struct kvm_pv_cmd {

