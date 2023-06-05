Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10857227F4
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbjFENzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjFENzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:55:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24F0E5;
        Mon,  5 Jun 2023 06:55:41 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355D9SnI025450;
        Mon, 5 Jun 2023 13:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uk/Ph7nyQQjzXgnz5FCxkok2A043KfR/00Z42hy/kLU=;
 b=JeRvxbc//zM0YdYkU0ScxMD9Ijnz8Dq9wWRafIEzFy5rsrOlIFUwIRjQL7xW7EujMkPe
 /P4pDCMXxF2jMXDwrHitLl6fDoJDX4bDFFbsUwU6kKJqaLHKd29a91QekHwA9nPinZUA
 sUiYaJiS94wYF7cUf8nt+EoXD4fiNZb0aNgAV21yHcqT0cZCQkW4IdwxOaFRySL4QUqb
 g+VfyTRReqppxa6pO5vjgKABLeZgAGQ6CHGnI1GmEz34Yr1uoTOXqGOaP7hz1gyPmRPl
 uDhtNW37iNrgbXOujB+HlsZ/81DXKPMqSpXId/V1EMFFScurhRyIBzjDunNFEKnnbKyK Cw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1f9vk022-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 13:55:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3553pLUI000328;
        Mon, 5 Jun 2023 13:55:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qyxmyhd4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 13:55:38 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355DtZD263832516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 13:55:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6908720040;
        Mon,  5 Jun 2023 13:55:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBA4220043;
        Mon,  5 Jun 2023 13:55:34 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 13:55:34 +0000 (GMT)
Message-ID: <2fca9573-5989-d61e-52ec-552f4e176971@linux.ibm.com>
Date:   Mon, 5 Jun 2023 15:55:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230519093708.810957-1-seiden@linux.ibm.com>
 <20230519093708.810957-6-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 5/6] s390/uv: replace scnprintf with sysfs_emit
In-Reply-To: <20230519093708.810957-6-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i3wboSr1suuijq0IkIwwm39ULCQWE8DZ
X-Proofpoint-ORIG-GUID: i3wboSr1suuijq0IkIwwm39ULCQWE8DZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_28,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050118
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/23 11:37, Steffen Eiden wrote:
> Replace scnprintf(page, PAGE_SIZE, ...) with the page size aware
> sysfs_emit(page, ...) which adds some sanity checks.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   arch/s390/kernel/uv.c | 36 +++++++++++++++---------------------
>   1 file changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index cb2ee06df286..d5b5d7e83c17 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -462,11 +462,11 @@ EXPORT_SYMBOL_GPL(arch_make_page_accessible);
>   static ssize_t uv_query_facilities(struct kobject *kobj,
>   				   struct kobj_attribute *attr, char *page)

The last argument is called buf so let's also change that over to make 
all of the functions look the same.

>   {
> -	return scnprintf(page, PAGE_SIZE, "%lx\n%lx\n%lx\n%lx\n",
> -			uv_info.inst_calls_list[0],
> -			uv_info.inst_calls_list[1],
> -			uv_info.inst_calls_list[2],
> -			uv_info.inst_calls_list[3]);
> +	return sysfs_emit(page, "%lx\n%lx\n%lx\n%lx\n",
> +			  uv_info.inst_calls_list[0],
> +			  uv_info.inst_calls_list[1],
> +			  uv_info.inst_calls_list[2],
> +			  uv_info.inst_calls_list[3]);
>   }
>   
>   static struct kobj_attribute uv_query_facilities_attr =
> @@ -493,8 +493,7 @@ static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
>   static ssize_t uv_query_dump_cpu_len(struct kobject *kobj,
>   				     struct kobj_attribute *attr, char *page)
>   {
> -	return scnprintf(page, PAGE_SIZE, "%lx\n",
> -			uv_info.guest_cpu_stor_len);
> +	return sysfs_emit(page, "%lx\n", uv_info.guest_cpu_stor_len);
>   }
>   
>   static struct kobj_attribute uv_query_dump_cpu_len_attr =
> @@ -503,8 +502,7 @@ static struct kobj_attribute uv_query_dump_cpu_len_attr =
>   static ssize_t uv_query_dump_storage_state_len(struct kobject *kobj,
>   					       struct kobj_attribute *attr, char *page)
>   {
> -	return scnprintf(page, PAGE_SIZE, "%lx\n",
> -			uv_info.conf_dump_storage_state_len);
> +	return sysfs_emit(page, "%lx\n", uv_info.conf_dump_storage_state_len);
>   }
>   
>   static struct kobj_attribute uv_query_dump_storage_state_len_attr =
> @@ -513,8 +511,7 @@ static struct kobj_attribute uv_query_dump_storage_state_len_attr =
>   static ssize_t uv_query_dump_finalize_len(struct kobject *kobj,
>   					  struct kobj_attribute *attr, char *page)
>   {
> -	return scnprintf(page, PAGE_SIZE, "%lx\n",
> -			uv_info.conf_dump_finalize_len);
> +	return sysfs_emit(page, "%lx\n", uv_info.conf_dump_finalize_len);
>   }
>   
>   static struct kobj_attribute uv_query_dump_finalize_len_attr =
> @@ -532,8 +529,7 @@ static struct kobj_attribute uv_query_feature_indications_attr =
>   static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
>   				       struct kobj_attribute *attr, char *page)
>   {
> -	return scnprintf(page, PAGE_SIZE, "%d\n",
> -			uv_info.max_guest_cpu_id + 1);
> +	return sysfs_emit(page, "%d\n", uv_info.max_guest_cpu_id + 1);
>   }
>   
>   static struct kobj_attribute uv_query_max_guest_cpus_attr =
> @@ -542,8 +538,7 @@ static struct kobj_attribute uv_query_max_guest_cpus_attr =
>   static ssize_t uv_query_max_guest_vms(struct kobject *kobj,
>   				      struct kobj_attribute *attr, char *page)
>   {
> -	return scnprintf(page, PAGE_SIZE, "%d\n",
> -			uv_info.max_num_sec_conf);
> +	return sysfs_emit(page, "%d\n", uv_info.max_num_sec_conf);
>   }
>   
>   static struct kobj_attribute uv_query_max_guest_vms_attr =
> @@ -552,8 +547,7 @@ static struct kobj_attribute uv_query_max_guest_vms_attr =
>   static ssize_t uv_query_max_guest_addr(struct kobject *kobj,
>   				       struct kobj_attribute *attr, char *page)
>   {
> -	return scnprintf(page, PAGE_SIZE, "%lx\n",
> -			uv_info.max_sec_stor_addr);
> +	return sysfs_emit(page, "%lx\n", uv_info.max_sec_stor_addr);
>   }
>   
>   static struct kobj_attribute uv_query_max_guest_addr_attr =
> @@ -562,7 +556,7 @@ static struct kobj_attribute uv_query_max_guest_addr_attr =
>   static ssize_t uv_query_supp_att_req_hdr_ver(struct kobject *kobj,
>   					     struct kobj_attribute *attr, char *page)
>   {
> -	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_att_req_hdr_ver);
> +	return sysfs_emit(page, "%lx\n", uv_info.supp_att_req_hdr_ver);
>   }
>   
>   static struct kobj_attribute uv_query_supp_att_req_hdr_ver_attr =
> @@ -571,7 +565,7 @@ static struct kobj_attribute uv_query_supp_att_req_hdr_ver_attr =
>   static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
>   					struct kobj_attribute *attr, char *page)
>   {
> -	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_att_pflags);
> +	return sysfs_emit(page, "%lx\n", uv_info.supp_att_pflags);
>   }
>   
>   static struct kobj_attribute uv_query_supp_att_pflags_attr =
> @@ -605,7 +599,7 @@ static ssize_t uv_is_prot_virt_guest(struct kobject *kobj,
>   #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>   	val = prot_virt_guest;
>   #endif
> -	return scnprintf(page, PAGE_SIZE, "%d\n", val);
> +	return sysfs_emit(page, "%d\n", val);
>   }
>   
>   static ssize_t uv_is_prot_virt_host(struct kobject *kobj,
> @@ -617,7 +611,7 @@ static ssize_t uv_is_prot_virt_host(struct kobject *kobj,
>   	val = prot_virt_host;
>   #endif
>   
> -	return scnprintf(page, PAGE_SIZE, "%d\n", val);
> +	return sysfs_emit(page, "%d\n", val);
>   }
>   
>   static struct kobj_attribute uv_prot_virt_guest =

