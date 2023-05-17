Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91FD706D6C
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 17:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjEQPzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 11:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjEQPzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 11:55:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB21F9EFE;
        Wed, 17 May 2023 08:54:39 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HFbgL6023794;
        Wed, 17 May 2023 15:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=quH8VXmd5CeU+FpHTIFuwsvOlHKMULhA66/ocioZmV8=;
 b=lWzk+IYQnopVLYQIMKqFo27eMhVvuWeEdHn7/vv0C+KFAZcPu0aP9ap9UISZuZ9HAL/1
 ygV8inde0IqpaGDpmFSM4OJC1w66DnVNxOKGX0RsrXBNxpCIAwsonAkhx2c/nEj/BoEF
 tZDLImmzFG+5L6mPDtWN5MpKx2/4uza0swcoiGT09PHY2aTZkGl46QMvGgKC3wQiDWgp
 tRDqB1YMlLNMeE1i9DkdxGZ9DNzi1wvQZERTbAMuQ2sacShR2Qb+E/N2OKArSsHnVtl7
 3O4/wzi+ijU3PlM1EHisB+RMwN7kd5+QiXWOYne/s9rpcFe8P2Nhcq6puCsuRUW0H85K FQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qn0qd2yhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 15:54:36 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34HE8eJX002923;
        Wed, 17 May 2023 15:54:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qj264svpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 15:54:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34HFsV906554204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 15:54:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1419420043;
        Wed, 17 May 2023 15:54:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7DBE20040;
        Wed, 17 May 2023 15:54:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 17 May 2023 15:54:30 +0000 (GMT)
Date:   Wed, 17 May 2023 17:54:28 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: Re: [PATCH 5/5] s390/uv: Update query for secret-UVCs
Message-ID: <20230517175428.14489c11@p-imbrenda>
In-Reply-To: <20230512093153.206378-6-seiden@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
        <20230512093153.206378-6-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6OG3YAGErBNJIuQl1xdhfzkIriyhcJ7a
X-Proofpoint-GUID: 6OG3YAGErBNJIuQl1xdhfzkIriyhcJ7a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170126
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 May 2023 11:31:53 +0200
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Update the query struct such that secret-UVC related
> information can be parsed.
> Add sysfs files for these new values.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/boot/uv.c        |  4 ++++
>  arch/s390/include/asm/uv.h | 11 ++++++++++-
>  arch/s390/kernel/uv.c      | 40 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index 0a077c0a2056..323b5cae3cf1 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -47,6 +47,10 @@ void uv_query_info(void)
>  		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
>  		uv_info.supp_att_req_hdr_ver = uvcb.supp_att_req_hdr_ver;
>  		uv_info.supp_att_pflags = uvcb.supp_att_pflags;
> +		uv_info.supp_add_secret_req_ver = uvcb.supp_add_secret_req_ver;
> +		uv_info.supp_add_secret_pcf = uvcb.supp_add_secret_pcf;
> +		uv_info.supp_secret_types = uvcb.supp_secret_types;
> +		uv_info.max_secrets = uvcb.max_num_secrets;
>  	}
>  
>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 6180ac8909d5..eb2e11d8123f 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -135,7 +135,12 @@ struct uv_cb_qui {
>  	u64 reservedd8;				/* 0x00d8 */
>  	u64 supp_att_req_hdr_ver;		/* 0x00e0 */
>  	u64 supp_att_pflags;			/* 0x00e8 */
> -	u8 reservedf0[256 - 240];		/* 0x00f0 */
> +	u64 reservedf0;				/* 0x00f0 */
> +	u64 supp_add_secret_req_ver;		/* 0x00f8 */
> +	u64 supp_add_secret_pcf;		/* 0x0100 */
> +	u64 supp_secret_types;			/* 0x0180 */
> +	u16 max_num_secrets;			/* 0x0110 */
> +	u8 reserved112[288 - 274];		/* 0x0112 */

I think it would be more readable and maintainable if you put the
offsets in hex (i.e. reserved112[0x120 - 0x112])

otherwise, something like this:

u16 max_num_secrets;
u16 reserved112[3]
u64 reserved118;

(I know it was not in hex before, it was not necessarily nice as it was)

>  } __packed __aligned(8);
>  
>  /* Initialize Ultravisor */
> @@ -384,6 +389,10 @@ struct uv_info {
>  	unsigned long conf_dump_finalize_len;
>  	unsigned long supp_att_req_hdr_ver;
>  	unsigned long supp_att_pflags;
> +	unsigned long supp_add_secret_req_ver;
> +	unsigned long supp_add_secret_pcf;
> +	unsigned long supp_secret_types;
> +	unsigned short max_secrets;
>  };
>  
>  extern struct uv_info uv_info;
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 9f18a4af9c13..381444511bb7 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -587,6 +587,42 @@ static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
>  static struct kobj_attribute uv_query_supp_att_pflags_attr =
>  	__ATTR(supp_att_pflags, 0444, uv_query_supp_att_pflags, NULL);
>  
> +static ssize_t uv_query_supp_add_secret_req_ver(struct kobject *kobj,
> +						struct kobj_attribute *attr, char *page)
> +{
> +	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_add_secret_req_ver);
> +}
> +
> +static struct kobj_attribute uv_query_supp_add_secret_req_ver_attr =
> +	__ATTR(supp_add_secret_req_ver, 0444, uv_query_supp_add_secret_req_ver, NULL);
> +
> +static ssize_t uv_query_supp_add_secret_pcf(struct kobject *kobj,
> +					    struct kobj_attribute *attr, char *page)
> +{
> +	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_add_secret_pcf);
> +}
> +
> +static struct kobj_attribute uv_query_supp_add_secret_pcf_attr =
> +	__ATTR(supp_add_secret_pcf, 0444, uv_query_supp_add_secret_pcf, NULL);
> +
> +static ssize_t uv_query_supp_secret_types(struct kobject *kobj,
> +					  struct kobj_attribute *attr, char *page)
> +{
> +	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_secret_types);
> +}
> +
> +static struct kobj_attribute uv_query_supp_secret_types_attr =
> +	__ATTR(supp_secret_types, 0444, uv_query_supp_secret_types, NULL);
> +
> +static ssize_t uv_query_max_secrets(struct kobject *kobj,
> +				    struct kobj_attribute *attr, char *page)
> +{
> +	return scnprintf(page, PAGE_SIZE, "%d\n", uv_info.max_secrets);
> +}
> +
> +static struct kobj_attribute uv_query_max_num_secrets_attr =
> +	__ATTR(max_secrets, 0444, uv_query_max_secrets, NULL);
> +
>  static struct attribute *uv_query_attrs[] = {
>  	&uv_query_facilities_attr.attr,
>  	&uv_query_feature_indications_attr.attr,
> @@ -600,6 +636,10 @@ static struct attribute *uv_query_attrs[] = {
>  	&uv_query_dump_cpu_len_attr.attr,
>  	&uv_query_supp_att_req_hdr_ver_attr.attr,
>  	&uv_query_supp_att_pflags_attr.attr,
> +	&uv_query_supp_add_secret_req_ver_attr.attr,
> +	&uv_query_supp_add_secret_pcf_attr.attr,
> +	&uv_query_supp_secret_types_attr.attr,
> +	&uv_query_max_num_secrets_attr.attr,
>  	NULL,
>  };
>  

