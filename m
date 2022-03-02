Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F594CA466
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 13:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241664AbiCBMFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 07:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241654AbiCBMFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 07:05:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAA2C0859;
        Wed,  2 Mar 2022 04:04:35 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222AmZ1P030482;
        Wed, 2 Mar 2022 12:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=z9fe190s1qkXAGsfrW5hd2J4IOPs4KGtV6W8Vk+Z2Ko=;
 b=Zno2vR0UoobysUIDz9V1Do7pRCiWqFa6itQOQenOiPuKQPOxvgjg7StUapp0bf6KwGnG
 SePzX+TaJT+t3ejBjre18hMwRzAo8CU9qJeQ3ttIaAO16OWS85vS16fgJhIemKxb3hJY
 n9KPsrCzaXxWMsnxRn5xAWywyaKeIWcaA2hrIrJKjbeON3jfZ8QFozKrjG/K/MJZUMuv
 iX8pSkhN+I0rgjS1tY1KlFKZagye7w4VM9lZmb8HYdnRAMbiwzDMAXbGCk5REmKTOJxl
 HWFPspCbl2RmnoXKMxpjL2wU0WJSvkr/AQuBaBwmyT5lG/rDl9y2UJwwCXgzEpD+bQBl rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ej75etmch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 12:04:34 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222AwfSV031328;
        Wed, 2 Mar 2022 12:04:34 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ej75etmbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 12:04:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222C0hQS012230;
        Wed, 2 Mar 2022 12:04:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3efbu9em9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 12:04:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222C4SxI39125470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 12:04:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25E50A4051;
        Wed,  2 Mar 2022 12:04:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB926A405B;
        Wed,  2 Mar 2022 12:04:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.37])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Mar 2022 12:04:27 +0000 (GMT)
Date:   Wed, 2 Mar 2022 13:04:25 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH 3/9] KVM: s390: pv: Add query interface
Message-ID: <20220302130425.0bfa0c2e@p-imbrenda>
In-Reply-To: <20220223092007.3163-4-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
        <20220223092007.3163-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hQYdcWAfJyly36UsBAbUrpt27Eqvm096
X-Proofpoint-GUID: 1tNg1ZjNwcqCdPW77qx9rfvpYr1A3q6D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_06,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Feb 2022 09:20:01 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Some of the query information is already available via sysfs but
> having a IOCTL makes the information easier to retrieve.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 47 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h | 23 ++++++++++++++++++++
>  2 files changed, 70 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index faa85397b6fb..837f898ad2ff 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2217,6 +2217,34 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	return r;
>  }
>  
> +static int kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
> +{
> +	u32 len;
> +
> +	switch (info->header.id) {
> +	case KVM_PV_INFO_VM: {
> +		len =  sizeof(info->header) + sizeof(info->vm);
> +
> +		if (info->header.len < len)
> +			return -EINVAL;

so if userspace gives a smaller buffer, we fail?
this means that if the struct grows in the future, existing software
will break?

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
> +		return 0;
> +	}
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  {
>  	int r = 0;
> @@ -2353,6 +2381,25 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  			     cmd->rc, cmd->rrc);
>  		break;
>  	}
> +	case KVM_PV_INFO: {
> +		struct kvm_s390_pv_info info = {};
> +
> +		if (copy_from_user(&info, argp, sizeof(info.header)))
> +			return -EFAULT;
> +
> +		if (info.header.len < sizeof(info.header))
> +			return -EINVAL;
> +
> +		r = kvm_s390_handle_pv_info(&info);
> +		if (r)
> +			return r;
> +
> +		r = copy_to_user(argp, &info, sizeof(info));
> +
> +		if (r)
> +			return -EFAULT;
> +		return 0;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dbc550bbd9fa..96fceb204a92 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1642,6 +1642,28 @@ struct kvm_s390_pv_unp {
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
> +	__u32 len;
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
> @@ -1650,6 +1672,7 @@ enum pv_cmd_id {
>  	KVM_PV_VERIFY,
>  	KVM_PV_PREP_RESET,
>  	KVM_PV_UNSHARE_ALL,
> +	KVM_PV_INFO,
>  };
>  
>  struct kvm_pv_cmd {

