Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A6D4C9367
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiCASjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbiCASjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:39:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BCC41631;
        Tue,  1 Mar 2022 10:38:20 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221HDjsj022291;
        Tue, 1 Mar 2022 18:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pUCwGuFG1s5Pr5FDmSuka0uiRwifxsO1RWySdcEUhoo=;
 b=Uaee6Zmlg6iP8CDziWwpZpMs5BOljhVdf8+giyOaJDdteAP65U/MzxaKHSstQ19UgrxS
 v3vX3xVE3W8gIbARLKVzcJAePndaE0io5F/hBk+q5faTa7Rim2StKLzLJZpyHeNwEApT
 DAKrg0gZOlBPwtNvZDUmNdym740JDGTcBt0Vs4XRhCe04RLdycPm0mQMzagYHoX/DAQv
 PzSX69lmEs11b28oJYB8jUXy+opq0XkQRSEMDvxwh5JGpupSIEw1wwYqw79wYu4F+8vF
 wRKFjsNufU0okaybkDanHlZtMc7j3bFqIyjzn4VASEJwKFIkd1T/n1xI8GScS7cSF8+7 CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehqq1hyvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:19 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 221HdShK016974;
        Tue, 1 Mar 2022 18:38:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehqq1hyu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 221IRjfn001034;
        Tue, 1 Mar 2022 18:38:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3egbj17kr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 221Ic7ki13631882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Mar 2022 18:38:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73C904C044;
        Tue,  1 Mar 2022 18:38:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 273744C04A;
        Tue,  1 Mar 2022 18:38:07 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.37])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Mar 2022 18:38:07 +0000 (GMT)
Date:   Tue, 1 Mar 2022 18:24:05 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH 2/9] s390: uv: Add dump fields to query
Message-ID: <20220301182405.31932135@p-imbrenda>
In-Reply-To: <20220223092007.3163-3-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
        <20220223092007.3163-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dgxFm9DAp79-3ldwM9E4ct525rEQoM-H
X-Proofpoint-ORIG-GUID: H6u6Rbe7gl8mJb_xUX93Z2hIUksjObcL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-01_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 phishscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

On Wed, 23 Feb 2022 09:20:00 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The new dump feature requires us to know how much memory is needed for
> the "dump storage state" and "dump finalize" ultravisor call. These
> values are reported via the UV query call.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

I would squash this into the previous patch, though

> ---
>  arch/s390/boot/uv.c        |  2 ++
>  arch/s390/include/asm/uv.h |  5 +++++
>  arch/s390/kernel/uv.c      | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index b100b57cf15d..67c737c1e580 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -43,6 +43,8 @@ void uv_query_info(void)
>  		uv_info.uv_feature_indications = uvcb.uv_feature_indications;
>  		uv_info.supp_se_hdr_ver = uvcb.supp_se_hdr_versions;
>  		uv_info.supp_se_hdr_pcf = uvcb.supp_se_hdr_pcf;
> +		uv_info.conf_dump_storage_state_len = uvcb.conf_dump_storage_state_len;
> +		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
>  	}
>  
>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 7d6c78b61bf2..b79e516d4424 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -111,6 +111,9 @@ struct uv_cb_qui {
>  	u64 supp_se_hdr_versions;		/* 0x00b0 */
>  	u64 supp_se_hdr_pcf;			/* 0x00b8 */
>  	u64 reservedc0;				/* 0x00c0 */
> +	u64 conf_dump_storage_state_len;	/* 0x00c8 */
> +	u64 conf_dump_finalize_len;		/* 0x00d0 */
> +	u8  reservedd8[256 - 216];		/* 0x00d8 */
>  } __packed __aligned(8);
>  
>  /* Initialize Ultravisor */
> @@ -290,6 +293,8 @@ struct uv_info {
>  	unsigned long uv_feature_indications;
>  	unsigned long supp_se_hdr_ver;
>  	unsigned long supp_se_hdr_pcf;
> +	unsigned long conf_dump_storage_state_len;
> +	unsigned long conf_dump_finalize_len;
>  };
>  
>  extern struct uv_info uv_info;
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 852840384e75..84fe33b6af4d 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -410,6 +410,36 @@ static ssize_t uv_query_supp_se_hdr_pcf(struct kobject *kobj,
>  static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
>  	__ATTR(supp_se_hdr_pcf, 0444, uv_query_supp_se_hdr_pcf, NULL);
>  
> +static ssize_t uv_query_dump_cpu_len(struct kobject *kobj,
> +				     struct kobj_attribute *attr, char *page)
> +{
> +	return scnprintf(page, PAGE_SIZE, "%lx\n",
> +			uv_info.guest_cpu_stor_len);
> +}
> +
> +static struct kobj_attribute uv_query_dump_cpu_len_attr =
> +	__ATTR(uv_query_dump_cpu_len, 0444, uv_query_dump_cpu_len, NULL);
> +
> +static ssize_t uv_query_dump_storage_state_len(struct kobject *kobj,
> +					       struct kobj_attribute *attr, char *page)
> +{
> +	return scnprintf(page, PAGE_SIZE, "%lx\n",
> +			uv_info.conf_dump_storage_state_len);
> +}
> +
> +static struct kobj_attribute uv_query_dump_storage_state_len_attr =
> +	__ATTR(dump_storage_state_len, 0444, uv_query_dump_storage_state_len, NULL);
> +
> +static ssize_t uv_query_dump_finalize_len(struct kobject *kobj,
> +					  struct kobj_attribute *attr, char *page)
> +{
> +	return scnprintf(page, PAGE_SIZE, "%lx\n",
> +			uv_info.conf_dump_finalize_len);
> +}
> +
> +static struct kobj_attribute uv_query_dump_finalize_len_attr =
> +	__ATTR(dump_finalize_len, 0444, uv_query_dump_finalize_len, NULL);
> +
>  static ssize_t uv_query_feature_indications(struct kobject *kobj,
>  					    struct kobj_attribute *attr, char *buf)
>  {
> @@ -457,6 +487,9 @@ static struct attribute *uv_query_attrs[] = {
>  	&uv_query_max_guest_addr_attr.attr,
>  	&uv_query_supp_se_hdr_ver_attr.attr,
>  	&uv_query_supp_se_hdr_pcf_attr.attr,
> +	&uv_query_dump_storage_state_len_attr.attr,
> +	&uv_query_dump_finalize_len_attr.attr,
> +	&uv_query_dump_cpu_len_attr.attr,
>  	NULL,
>  };
>  

