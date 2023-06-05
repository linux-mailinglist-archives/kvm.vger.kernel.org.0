Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E1D72286E
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbjFEOK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbjFEOKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:10:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3AB1991;
        Mon,  5 Jun 2023 07:09:14 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355E8vRH012291;
        Mon, 5 Jun 2023 14:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6u+liUSvDBY+5lMgkcI56mqdM/C6fRklXDnjVEcYhcI=;
 b=JWBx2ih86sIUOCWz9C4WvpntHeQFsTcfsP5lNyyHnxSWaDigWJbH9Jm/9pds0SQfj9xs
 UsM3rK2vh3BK4/iDqWiL1e+bEReFWzDfDSx3zzDXqLhkMVP+wIWH5VuwHrQzvwkgE8AR
 gLj8EMA8Pz50HZMGnd+8czkt17qhcjWPlZXgOnRKdw20E3+q0ZqZ3cKIiKY4jjAUMdDj
 x7PmOaX1U/kMqS4ouN6MhATSzVG4sibVrthVQNV4B6GZCfn0eWToRw7mspnRveDww+d3
 lErgCHFHOd4k3jAOQjXi/P90zsWYUW1x97URPsPKVXrOewVkrT5qTlZssmX0OFkXJJnG dA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1h0n8973-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 14:09:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3554gbHi001935;
        Mon, 5 Jun 2023 14:04:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qyxg2hcx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 14:04:00 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355E3vui20513534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 14:03:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76AD12004E;
        Mon,  5 Jun 2023 14:03:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E847720040;
        Mon,  5 Jun 2023 14:03:56 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 14:03:56 +0000 (GMT)
Message-ID: <3eab8065-41e7-94b8-a6da-18222f711fa0@linux.ibm.com>
Date:   Mon, 5 Jun 2023 16:03:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 6/6] s390/uv: Update query for secret-UVCs
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
 <20230519093708.810957-7-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230519093708.810957-7-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PQHJ-krbWCCqJH5qRE1uL2f82fV0DpjP
X-Proofpoint-ORIG-GUID: PQHJ-krbWCCqJH5qRE1uL2f82fV0DpjP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_28,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050123
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
> Update the query struct such that secret-UVC related
> information can be parsed.
> Add sysfs files for these new values.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

You should add a bit of information about the fields.
Not a large amount but having no info doesn't help anyone without access 
to our design documents.

> ---

[...]

>   extern struct uv_info uv_info;
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index d5b5d7e83c17..c0a1bfb01135 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -571,6 +571,42 @@ static ssize_t uv_query_supp_att_pflags(struct kobject *kobj,
>   static struct kobj_attribute uv_query_supp_att_pflags_attr =
>   	__ATTR(supp_att_pflags, 0444, uv_query_supp_att_pflags, NULL);
>   
> +static ssize_t uv_query_supp_add_secret_req_ver(struct kobject *kobj,
> +						struct kobj_attribute *attr, char *page)

s/page/buf/ for the whole lot.

> +{
> +	return sysfs_emit(page, "%lx\n", uv_info.supp_add_secret_req_ver);
> +}
> +
> +static struct kobj_attribute uv_query_supp_add_secret_req_ver_attr =
> +	__ATTR(supp_add_secret_req_ver, 0444, uv_query_supp_add_secret_req_ver, NULL);
> +
> +static ssize_t uv_query_supp_add_secret_pcf(struct kobject *kobj,
> +					    struct kobj_attribute *attr, char *page)
> +{
> +	return sysfs_emit(page, "%lx\n", uv_info.supp_add_secret_pcf);
> +}
> +
> +static struct kobj_attribute uv_query_supp_add_secret_pcf_attr =
> +	__ATTR(supp_add_secret_pcf, 0444, uv_query_supp_add_secret_pcf, NULL);
> +
> +static ssize_t uv_query_supp_secret_types(struct kobject *kobj,
> +					  struct kobj_attribute *attr, char *page)
> +{
> +	return sysfs_emit(page, "%lx\n", uv_info.supp_secret_types);
> +}
> +
> +static struct kobj_attribute uv_query_supp_secret_types_attr =
> +	__ATTR(supp_secret_types, 0444, uv_query_supp_secret_types, NULL);
> +

> +static ssize_t uv_query_max_secrets(struct kobject *kobj,
> +				    struct kobj_attribute *attr, char *page)
> +{
> +	return sysfs_emit(page, "%d\n", uv_info.max_secrets);
> +}

uv_query_max_secrets
but then
uv_query_max_num_secrets_attr

To num or not to num. That's the question

> +
> +static struct kobj_attribute uv_query_max_num_secrets_attr =
> +	__ATTR(max_secrets, 0444, uv_query_max_secrets, NULL);

And here the num is gone again.

> +
>   static struct attribute *uv_query_attrs[] = {
>   	&uv_query_facilities_attr.attr,
>   	&uv_query_feature_indications_attr.attr,
> @@ -584,6 +620,10 @@ static struct attribute *uv_query_attrs[] = {
>   	&uv_query_dump_cpu_len_attr.attr,
>   	&uv_query_supp_att_req_hdr_ver_attr.attr,
>   	&uv_query_supp_att_pflags_attr.attr,
> +	&uv_query_supp_add_secret_req_ver_attr.attr,
> +	&uv_query_supp_add_secret_pcf_attr.attr,
> +	&uv_query_supp_secret_types_attr.attr,
> +	&uv_query_max_num_secrets_attr.attr,
>   	NULL,
>   };
>   

