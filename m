Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FA452A085
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345287AbiEQLhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbiEQLhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:37:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7B43BBFA;
        Tue, 17 May 2022 04:37:19 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBJxb2009359;
        Tue, 17 May 2022 11:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=obiR7f94tPROTd8GEeFOVBqsDJn15EA+GiqA1stUSyk=;
 b=Ggs8F9lNDvVWx4uV0VgzUJB4gbKQJ1CXCz3oYXGGe1okORCoyPoTfA1EqRcAtun5lHuK
 47I5TIYNiTCmIuJ3RGXj9TOq5USju4uaGGe6OcinHlcPnLHbYM7LpqlDz234d6dwIFoW
 xpBSa7CnkRrycpwp+D3vSeYoaYoxdkcJHu/Ym/hJtkqNathUfGQwjsfxDwmRqcIMhini
 KSSWMquwtt+9dFAoIWfchTO3U1KPGy3sIBeKCRWxdj4XhkoOLI/J+uUm3g3HsitxvlIL
 leyCNl7xTrgvPCS7+eHf/nV2nBmQqX80J6SNiQcE9wvooOq2b5IZIKXTtqwBC3NhDly4 Rw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4ar78a7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:37:18 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBINHd025618;
        Tue, 17 May 2022 11:37:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429c4ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:37:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBNL7w51708308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:23:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 909AAA405F;
        Tue, 17 May 2022 11:37:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F762A4054;
        Tue, 17 May 2022 11:37:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:37:11 +0000 (GMT)
Date:   Tue, 17 May 2022 12:59:32 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v5 03/10] KVM: s390: pv: Add query interface
Message-ID: <20220517125932.4f9bc067@p-imbrenda>
In-Reply-To: <20220516090817.1110090-4-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
        <20220516090817.1110090-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XnpeaN7_SAFPem8djzX5cj8q3ms8oXf1
X-Proofpoint-GUID: XnpeaN7_SAFPem8djzX5cj8q3ms8oXf1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 09:08:10 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Some of the query information is already available via sysfs but
> having a IOCTL makes the information easier to retrieve.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 76 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h | 25 +++++++++++++
>  2 files changed, 101 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 76ad6408cb2c..5859f243d287 100644
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
> +	ssize_t len_min;
> +
> +	switch (info->header.id) {
> +	case KVM_PV_INFO_VM: {
> +		len_min =  sizeof(info->header) + sizeof(info->vm);
> +
> +		if (info->header.len_max < len_min)
> +			return -EINVAL;
> +
> +		memcpy(info->vm.inst_calls_list,
> +		       uv_info.inst_calls_list,
> +		       sizeof(uv_info.inst_calls_list));
> +
> +		/* It's max cpuid not max cpus, so it's off by one */
> +		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
> +		info->vm.max_guests = uv_info.max_num_sec_conf;
> +		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
> +		info->vm.feature_indication = uv_info.uv_feature_indications;
> +
> +		return len_min;
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
> index 6a184d260c7f..8ac9de7d1386 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1653,6 +1653,30 @@ struct kvm_s390_pv_unp {
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
> @@ -1661,6 +1685,7 @@ enum pv_cmd_id {
>  	KVM_PV_VERIFY,
>  	KVM_PV_PREP_RESET,
>  	KVM_PV_UNSHARE_ALL,
> +	KVM_PV_INFO,
>  };
>  
>  struct kvm_pv_cmd {

