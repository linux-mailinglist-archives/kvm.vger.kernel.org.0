Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8364C316072
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 08:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhBJH4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 02:56:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233271AbhBJH41 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 02:56:27 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11A7hJoa108681;
        Wed, 10 Feb 2021 02:55:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=12vEkleT3F+acHBxWwv7FyM5r7eOtkAGiNDLHRw2roQ=;
 b=QUF6C3FPdPbeSWUt6vc0g6qg/cicigXQSrAwLdlSR5repN7iDURGCIRRUGDQWdIP5wRl
 1kY4/1SpPoi6qJWnKKkRMiNN++uVf0yvUkHE6bfXoaYrAu0c70rsk7cg/iiFlAfX80qW
 +7L9O/jd/h6p6yi7XYdxO56kST37QZm19C7l1/COSxULsInexJhj1kZLaLxauOTF0Qrm
 BggyFl+ZagpqfEyDgqDUTpRaiRBhiPgysKEhCjp7/CBbWvaTH7eaqNv2v+0riV4Ocm7C
 wVa0Baq2Y8UX8hZLQzzx3VJWGbd+ex7BLZe4yu0lhCzRYw2g45I2Jlmu/ea3licefgNY kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mbbh88dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 02:55:46 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11A7hvoB110403;
        Wed, 10 Feb 2021 02:55:46 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mbbh88cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 02:55:45 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11A7qfxL025829;
        Wed, 10 Feb 2021 07:55:42 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36m1m2rmw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 07:55:42 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11A7tUUl31457596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 07:55:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46EC3A4040;
        Wed, 10 Feb 2021 07:55:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0DB8A4051;
        Wed, 10 Feb 2021 07:55:39 +0000 (GMT)
Received: from [9.145.24.226] (unknown [9.145.24.226])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 07:55:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] Fix the length in the stsi check for the
 VM name
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20210209155705.67601-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <b94af086-5b38-8848-d2ed-65a035380bba@linux.ibm.com>
Date:   Wed, 10 Feb 2021 08:55:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209155705.67601-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_02:2021-02-09,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/21 4:57 PM, Thomas Huth wrote:
> sizeof(somepointer) results in the size of the pointer, i.e. 8 on a
> 64-bit system, so the
> 
>  memcmp(data->ext_names[0], vm_name_ext, sizeof(vm_name_ext))
> 
> only compared the first 8 characters of the VM name here. Switch
> to a proper array to get the sizeof() right.


Reviewed-by: Janosch Frank <frankja@linux.ibm.com>


> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  s390x/stsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 4109b8d..87d4804 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -106,7 +106,7 @@ static void test_3_2_2(void)
>  				 0x00, 0x03 };
>  	/* EBCDIC for "KVM/" */
>  	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
> -	const char *vm_name_ext = "kvm-unit-test";
> +	const char vm_name_ext[] = "kvm-unit-test";
>  	struct stsi_322 *data = (void *)pagebuf;
>  
>  	report_prefix_push("3.2.2");
> 

