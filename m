Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37877244DE
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbjFFNuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbjFFNub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:50:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B0A83;
        Tue,  6 Jun 2023 06:50:30 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356DifJq027703;
        Tue, 6 Jun 2023 13:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uuTXB1/13i8UKUnrmZMw8IqxKocp9zYcPYHvJb6RT6g=;
 b=Q1Bfn9jsqePBTWAcJZS13SIEHaQ0EwxiFSaWAd0u6GbT4/GcZ+q0y4p8LZZ6MyWpD7IZ
 210nIj4B9GXY4WMd+NPAX++kAUTD/SX0tGBSMknqzpoBxHtc3HsMDvKKu5KJjzfafUt7
 z4pbsuaikuPs/GKPYSi7M+zhS8jsaBfrpAATYFZjHZVBF99FB08JdZpYZ6x+fvHsFbQP
 OZxQJQ7ooNWB3++aoSg/18Kw9uSpxq0T1KZvy7XfQTyr6yrLuU75di5kxxNyGhzHm3ae
 eU2lV+5Y2nPYi7huGwkdh59Hug8I/TbC4iaN6Jo98NZ8i3ufDIVIKWlxOuq9GesU6Phx Hg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r25xu85en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 13:50:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3566NghN021520;
        Tue, 6 Jun 2023 13:50:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qyxmyj085-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 13:50:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356DoNI058327308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 13:50:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 112352004B;
        Tue,  6 Jun 2023 13:50:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AA0220043;
        Tue,  6 Jun 2023 13:50:22 +0000 (GMT)
Received: from [9.171.79.116] (unknown [9.171.79.116])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 13:50:22 +0000 (GMT)
Message-ID: <71a88dc7-dc27-937a-5e93-f74512f7a307@linux.ibm.com>
Date:   Tue, 6 Jun 2023 15:50:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 5/6] s390/uv: replace scnprintf with sysfs_emit
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230606113736.2934503-1-seiden@linux.ibm.com>
 <20230606113736.2934503-6-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230606113736.2934503-6-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ARQiWZxJ43WVeMG7h3Ly4uUxgOyh5d8n
X-Proofpoint-ORIG-GUID: ARQiWZxJ43WVeMG7h3Ly4uUxgOyh5d8n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_08,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015 adultscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/23 13:37, Steffen Eiden wrote:
> Replace scnprintf(page, PAGE_SIZE, ...) with the page size aware
> sysfs_emit(buf, ...) which adds some sanity checks.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   arch/s390/kernel/uv.c | 54 +++++++++++++++++++------------------------
>   1 file changed, 24 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index cb2ee06df286..cd3a591edab3 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -460,13 +460,13 @@ EXPORT_SYMBOL_GPL(arch_make_page_accessible);

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

These are still named page

