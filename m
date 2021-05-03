Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B69E3715AA
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhECNHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 09:07:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233361AbhECNHF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 09:07:05 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 143D3YSZ192409
        for <kvm@vger.kernel.org>; Mon, 3 May 2021 09:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rrIk52V1n8GSvUUjRpicxUy5sSXnScr576WqXKv8En0=;
 b=SH1Lg4xNBs2ufM+y3ykKGgfwcxmA25rbHE9W42hp+LNTctECXLhPC5BAqaCJeGqBKiYi
 AeS0jdqhJ5MNwv0ML41wkhcyQhDAPQ4LceGIYfeBZhi8Isd7NlKas6AYOIwiKvpah57r
 1uiCRzSrbetAQNHJs0E51pcbQuWsns8K/N5nxOcJ75tgV5wdbcjaCcqua8WmoKLF36li
 dDnhYX5N9Km5IgnP6xSenNuiK8kuzsJ6iaJDITvM+AQBSKyxQxDIIf9c6KF17hgdDAvY
 VIB91VJXCc2risOyQEWNpNxCYj3DgCdDxcZmoFsAPC02MwVznpS5oj2gN8t/qpRZTU80 DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ahg18jmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 09:06:12 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 143D3r3O001142
        for <kvm@vger.kernel.org>; Mon, 3 May 2021 09:06:11 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ahg18jkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 May 2021 09:06:11 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 143D4YAW019167;
        Mon, 3 May 2021 13:06:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 388xm8gd4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 May 2021 13:06:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 143D5f8K29032896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 May 2021 13:05:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED99452069;
        Mon,  3 May 2021 13:06:06 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.12.83])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A972452057;
        Mon,  3 May 2021 13:06:06 +0000 (GMT)
Date:   Mon, 3 May 2021 15:06:05 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix vector stfle checks
Message-ID: <20210503150605.624311e2@ibm-vm>
In-Reply-To: <20210503124713.68975-1-frankja@linux.ibm.com>
References: <20210503124713.68975-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zzzwVFDGfJ49HMm01sn97J6nyAfwrfwm
X-Proofpoint-ORIG-GUID: n7PBqAkmKsiiLzKpXQjPwZEnHtfIs2CT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-03_07:2021-05-03,2021-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105030089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 May 2021 12:47:13 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> 134 is for bcd
> 135 is for the vector enhancements
> 
> Not the other way around...
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/vector.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/vector.c b/s390x/vector.c
> index d1b6a571..b052de55 100644
> --- a/s390x/vector.c
> +++ b/s390x/vector.c
> @@ -53,7 +53,7 @@ static void test_add(void)
>  /* z14 vector extension test */
>  static void test_ext1_nand(void)
>  {
> -	bool has_vext = test_facility(134);
> +	bool has_vext = test_facility(135);
>  	static struct prm {
>  		__uint128_t a,b,c;
>  	} prm __attribute__((aligned(16)));
> @@ -79,7 +79,7 @@ static void test_ext1_nand(void)
>  /* z14 bcd extension test */
>  static void test_bcd_add(void)
>  {
> -	bool has_bcd = test_facility(135);
> +	bool has_bcd = test_facility(134);
>  	static struct prm {
>  		__uint128_t a,b,c;
>  	} prm __attribute__((aligned(16)));

