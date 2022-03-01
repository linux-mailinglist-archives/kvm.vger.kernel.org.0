Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B694C9361
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiCASi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiCASiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:38:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7CA36E07;
        Tue,  1 Mar 2022 10:38:14 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221IDaoF032078;
        Tue, 1 Mar 2022 18:38:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5Z2rrVnuxaOz3qT8BxmyfNFjABtM0f2TCtxs4nFec0E=;
 b=J+PJ/9ePSerHMTbPle4VLtFXHG0msQj56s4sEtqlLavvynfU/4Bi51ieh59sLXvUN32N
 NhDvpYBbFPLYLvRb9p3rNSKuc39Fj5N4jQVvLTrVHd4LPDsuvH0yOnrMNNIEuVkdQGcg
 Yi8nwbupGvTgDuTRhYCMIQGPry/2elD3gXBWtH3ecqVzDk2iS8TBLAcXMIDAYLzgdeXG
 Ld8PYqgvmmV2f8qhATy90VfJuv0WpnhGP00A7wLhcZSux7PaUIMqrcSwFS55tW3F1oc8
 2Lve82G5tkg5VpS5fCwfIe1UQW/X7VpRdN1BsMaX9ocMJCpXcNbneWzzfGzrPlsp7Q9n VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehrk38gqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:13 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 221Iaw1d005262;
        Tue, 1 Mar 2022 18:38:13 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ehrk38gpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 221IRTql000992;
        Tue, 1 Mar 2022 18:38:11 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3egbj17kr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Mar 2022 18:38:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 221Ic2xi51184054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Mar 2022 18:38:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 989894C050;
        Tue,  1 Mar 2022 18:38:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EDB34C044;
        Tue,  1 Mar 2022 18:38:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.37])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Mar 2022 18:38:02 +0000 (GMT)
Date:   Tue, 1 Mar 2022 18:22:05 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH 1/9] s390x: Add SE hdr query information
Message-ID: <20220301182205.345e001a@p-imbrenda>
In-Reply-To: <20220223092007.3163-2-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
        <20220223092007.3163-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sxzzM-kYxYDdA0CtV1w8TRjGdmb1wIqW
X-Proofpoint-GUID: wFI3_G6_EPkRvbdqV3TsQ2065Oc9FCiF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-01_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

On Wed, 23 Feb 2022 09:19:59 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> We have information about the supported se header version and pcf bits
> so let's expose it via the sysfs files.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/boot/uv.c        |  2 ++
>  arch/s390/include/asm/uv.h |  7 ++++++-
>  arch/s390/kernel/uv.c      | 20 ++++++++++++++++++++
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index e6be155ab2e5..b100b57cf15d 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -41,6 +41,8 @@ void uv_query_info(void)
>  		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
>  		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_id;
>  		uv_info.uv_feature_indications = uvcb.uv_feature_indications;
> +		uv_info.supp_se_hdr_ver = uvcb.supp_se_hdr_versions;
> +		uv_info.supp_se_hdr_pcf = uvcb.supp_se_hdr_pcf;
>  	}
>  
>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 86218382d29c..7d6c78b61bf2 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -107,7 +107,10 @@ struct uv_cb_qui {
>  	u8  reserved88[158 - 136];		/* 0x0088 */
>  	u16 max_guest_cpu_id;			/* 0x009e */
>  	u64 uv_feature_indications;		/* 0x00a0 */
> -	u8  reserveda8[200 - 168];		/* 0x00a8 */
> +	u64 reserveda8;				/* 0x00a8 */
> +	u64 supp_se_hdr_versions;		/* 0x00b0 */
> +	u64 supp_se_hdr_pcf;			/* 0x00b8 */
> +	u64 reservedc0;				/* 0x00c0 */
>  } __packed __aligned(8);
>  
>  /* Initialize Ultravisor */
> @@ -285,6 +288,8 @@ struct uv_info {
>  	unsigned int max_num_sec_conf;
>  	unsigned short max_guest_cpu_id;
>  	unsigned long uv_feature_indications;
> +	unsigned long supp_se_hdr_ver;
> +	unsigned long supp_se_hdr_pcf;
>  };
>  
>  extern struct uv_info uv_info;
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index a5425075dd25..852840384e75 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -392,6 +392,24 @@ static ssize_t uv_query_facilities(struct kobject *kobj,
>  static struct kobj_attribute uv_query_facilities_attr =
>  	__ATTR(facilities, 0444, uv_query_facilities, NULL);
>  
> +static ssize_t uv_query_supp_se_hdr_ver(struct kobject *kobj,
> +					struct kobj_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%lx\n", uv_info.supp_se_hdr_ver);
> +}
> +
> +static struct kobj_attribute uv_query_supp_se_hdr_ver_attr =
> +	__ATTR(supp_se_hdr_ver, 0444, uv_query_supp_se_hdr_ver, NULL);
> +
> +static ssize_t uv_query_supp_se_hdr_pcf(struct kobject *kobj,
> +					struct kobj_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%lx\n", uv_info.supp_se_hdr_pcf);
> +}
> +
> +static struct kobj_attribute uv_query_supp_se_hdr_pcf_attr =
> +	__ATTR(supp_se_hdr_pcf, 0444, uv_query_supp_se_hdr_pcf, NULL);
> +
>  static ssize_t uv_query_feature_indications(struct kobject *kobj,
>  					    struct kobj_attribute *attr, char *buf)
>  {
> @@ -437,6 +455,8 @@ static struct attribute *uv_query_attrs[] = {
>  	&uv_query_max_guest_cpus_attr.attr,
>  	&uv_query_max_guest_vms_attr.attr,
>  	&uv_query_max_guest_addr_attr.attr,
> +	&uv_query_supp_se_hdr_ver_attr.attr,
> +	&uv_query_supp_se_hdr_pcf_attr.attr,
>  	NULL,
>  };
>  

