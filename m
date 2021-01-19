Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC6A2FC588
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 01:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbhATASP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 19:18:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3164 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392172AbhASNqq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 08:46:46 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JDA3jh056532;
        Tue, 19 Jan 2021 08:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ET6sLnP+eJhqvkmcsRzmxETAVCUxIheSvgW3gOmrth4=;
 b=g1NZg/akGdKOW3552smjVc/TaElmonUL+GWJbUf3xTnyi0HT7cLsWpReL0QyiP0TPws6
 O3hHji/pWuvCapaoYGeucFpbyH88+jLb8hLoz5OxyAGICxNvM1zs9mLYNIQ4LKSOVV2E
 GO382NHnAinSDNPvVSPOB7uBRy+vIedP8IrDzU6cG/Wy0jDJsFZPuAFiAt9QJ2Zb9ed2
 gAwDprUVbmpQtPM+X5Lz5f5ZpUg3bIdp72schIbVeVacj35L8ZfQndTQU6pm0hwQPaP4
 OeR/YrN+EzlpEIq65KNo8aT1ubGnfqS6G89B+icbL2JHyMUsL0tVNIavgViR/AC8dv0N 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365ypcrm2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 08:12:13 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JDBtfd068086;
        Tue, 19 Jan 2021 08:12:12 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365ypcrm1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 08:12:12 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JCv16X002704;
        Tue, 19 Jan 2021 13:12:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 363qs89ke8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 13:12:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JDC6UQ39321954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 13:12:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D562AA404D;
        Tue, 19 Jan 2021 13:12:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5080CA4053;
        Tue, 19 Jan 2021 13:12:06 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.4.167])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 13:12:06 +0000 (GMT)
Date:   Tue, 19 Jan 2021 14:11:33 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: Re: [PATCH 1/2] s390: uv: Fix sysfs max number of VCPUs reporting
Message-ID: <20210119141133.186273c1@ibm-vm>
In-Reply-To: <20210119100402.84734-2-frankja@linux.ibm.com>
References: <20210119100402.84734-1-frankja@linux.ibm.com>
        <20210119100402.84734-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_04:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101190077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 05:04:01 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> The number reported by the query is N-1 and I think people reading the
> sysfs file would expect N instead. For users creating VMs there's no
> actual difference because KVM's limit is currently below the UV's
> limit.
> 
> The naming of the field is a bit misleading. Number in this context is
> used like ID and starts at 0. The query field denotes the maximum
> number that can be put into the VCPU number field in the "create
> secure CPU" UV call.

once you address Christian's comments:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: a0f60f8431999 ("s390/protvirt: Add sysfs firmware interface
> for Ultravisor information") Cc: stable@vger.kernel.org
> ---
>  arch/s390/boot/uv.c        | 2 +-
>  arch/s390/include/asm/uv.h | 4 ++--
>  arch/s390/kernel/uv.c      | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index a15c033f53ca..afb721082989 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -35,7 +35,7 @@ void uv_query_info(void)
>  		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
>  		uv_info.max_sec_stor_addr =
> ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE); uv_info.max_num_sec_conf
> = uvcb.max_num_sec_conf;
> -		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
> +		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_num;
>  	}
>  
>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 0325fc0469b7..c484c95ea142 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -96,7 +96,7 @@ struct uv_cb_qui {
>  	u32 max_num_sec_conf;
>  	u64 max_guest_stor_addr;
>  	u8  reserved88[158 - 136];
> -	u16 max_guest_cpus;
> +	u16 max_guest_cpu_num;
>  	u8  reserveda0[200 - 160];
>  } __packed __aligned(8);
>  
> @@ -273,7 +273,7 @@ struct uv_info {
>  	unsigned long guest_cpu_stor_len;
>  	unsigned long max_sec_stor_addr;
>  	unsigned int max_num_sec_conf;
> -	unsigned short max_guest_cpus;
> +	unsigned short max_guest_cpu_id;
>  };
>  
>  extern struct uv_info uv_info;
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 883bfed9f5c2..b2d2ad153067 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -368,7 +368,7 @@ static ssize_t uv_query_max_guest_cpus(struct
> kobject *kobj, struct kobj_attribute *attr, char *page)
>  {
>  	return scnprintf(page, PAGE_SIZE, "%d\n",
> -			uv_info.max_guest_cpus);
> +			uv_info.max_guest_cpu_id + 1);
>  }
>  
>  static struct kobj_attribute uv_query_max_guest_cpus_attr =

