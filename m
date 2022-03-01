Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D024C9365
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiCASjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbiCASjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:39:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2892A140E9;
        Tue,  1 Mar 2022 10:38:18 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221Hg2LV022700;
        Tue, 1 Mar 2022 18:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=KRIwFg5h2/6kEuj9nH6J71XfFCdbOn9+OrwCcsCsPy8=;
 b=pejjt+GeEcODUwvahaglrCKG2m5jA1VURs3WZXsEzeoxKgCDwhr1iv855RxhMeq0bn4Q
 joFxjYTaaWdhVh8lX+5wpYDhKIvxRiPQ/Kl+xL3F/htwM8hdKN2u5ZLt2kNCGGLSiToy
 5nu7wbiLiCEDxSBL5zKw1eb7u4ea1kKPTzqYZx5mI35tM2Mi+LxNOySCg8xyRyQDKrjg
 GTHWtwK2KJvY4tTZUuSGVTCkzFokUXayYcZu8/i8449yRf1A+UqIi7D+Bs9rQaZP6EuG
 20eePGFzHAsPR+NblDIIPM9mOu1Utoz+JvnjlU62FsHcn3w9h+/3cqB2bCPRjIExDN8s bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehr421ac7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:18 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 221I6npa011252;
        Tue, 1 Mar 2022 18:38:17 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehr421aba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:17 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 221IS0Km017592;
        Tue, 1 Mar 2022 18:38:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3efbu8u9n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 221Ic9Zh52035890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Mar 2022 18:38:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7119B4C046;
        Tue,  1 Mar 2022 18:38:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 165DD4C044;
        Tue,  1 Mar 2022 18:38:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.37])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Mar 2022 18:38:09 +0000 (GMT)
Date:   Tue, 1 Mar 2022 18:34:42 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH 5/9] KVM: s390: pv: Add query dump information
Message-ID: <20220301183442.323fb7c3@p-imbrenda>
In-Reply-To: <20220223092007.3163-6-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
        <20220223092007.3163-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oGknhqPtBteCGRCwKTEFvRYUnhe2zPif
X-Proofpoint-GUID: 7yaYlF955nfkkAGPOFtICNBwdvnoNlp6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-01_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203010093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Feb 2022 09:20:03 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The dump API requires userspace to provide buffers into which we will
> store data. The dump information added in this patch tells userspace
> how big those buffers need to be.

isn't this information already exported in sysfs?

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 11 +++++++++++
>  include/uapi/linux/kvm.h | 12 +++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 837f898ad2ff..8de53803c1ca 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2240,6 +2240,17 @@ static int kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
>  
>  		return 0;
>  	}
> +	case KVM_PV_INFO_DUMP: {
> +		len =  sizeof(info->header) + sizeof(info->dump);
> +
> +		if (info->header.len < len)
> +			return -EINVAL;
> +
> +		info->dump.dump_cpu_buffer_len = uv_info.guest_cpu_stor_len;
> +		info->dump.dump_config_mem_buffer_per_1m = uv_info.conf_dump_storage_state_len;
> +		info->dump.dump_config_finalize_len = uv_info.conf_dump_finalize_len;
> +		return 0;
> +	}
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 96fceb204a92..d58cd5a40e62 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1644,6 +1644,13 @@ struct kvm_s390_pv_unp {
>  
>  enum pv_cmd_info_id {
>  	KVM_PV_INFO_VM,
> +	KVM_PV_INFO_DUMP,
> +};
> +
> +struct kvm_s390_pv_info_dump {
> +	__u64 dump_cpu_buffer_len;
> +	__u64 dump_config_mem_buffer_per_1m;
> +	__u64 dump_config_finalize_len;
>  };
>  
>  struct kvm_s390_pv_info_vm {
> @@ -1661,7 +1668,10 @@ struct kvm_s390_pv_info_header {
>  
>  struct kvm_s390_pv_info {
>  	struct kvm_s390_pv_info_header header;
> -	struct kvm_s390_pv_info_vm vm;
> +	union {
> +		struct kvm_s390_pv_info_dump dump;
> +		struct kvm_s390_pv_info_vm vm;
> +	};
>  };
>  
>  enum pv_cmd_id {

