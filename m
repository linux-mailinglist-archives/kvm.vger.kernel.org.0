Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB53395953
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhEaK6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:58:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbhEaK6a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 06:58:30 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VAc9oV025974;
        Mon, 31 May 2021 06:56:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7F4sVf+WjHm/yEk4Yr4xsOrOI6YhurDHkX6iVWPj3KU=;
 b=rF/zMuRXci1K6l+AR32Z3N3PXfUNXi5W3fw58jHYY87iihyk2wYBcbIJjtsmqCapKhBt
 r/MzBe3emJTqUJIzizp6McY+m4RRYPRtleQwymCaqqfcs8SNtmf36CVBk9MIYYUnv52f
 jlCFBvu8KrwFyelImOYr726da4w995BmEumQUilH08LfjPSiRUOI4MMP1ewIkBrrkwaY
 cQfzlqc34Op8vEpY4uZaYxM00nx56XxGlaYuvyVWJp0wRhJ6cX6J5kZJMaue1i3JgfTe
 Kj1C8VQI3ua/BXxuZFuvTPZxCIDkoI96qSo9buUKwyX3bpZTkJ2Ucm2wsrWbzKFQ7d6S 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38vwdvsjph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 06:56:44 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14VAcDOR026317;
        Mon, 31 May 2021 06:56:44 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38vwdvsjns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 06:56:43 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14VAq8YN026024;
        Mon, 31 May 2021 10:56:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38ud888yh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 10:56:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14VAudd134537900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 May 2021 10:56:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B248A4053;
        Mon, 31 May 2021 10:56:39 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16568A4040;
        Mon, 31 May 2021 10:56:39 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.6.60])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 May 2021 10:56:39 +0000 (GMT)
Date:   Mon, 31 May 2021 12:56:37 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: selftest: Fix report output
Message-ID: <20210531125637.0f6f2477@ibm-vm>
In-Reply-To: <20210531105003.44737-1-frankja@linux.ibm.com>
References: <20210531105003.44737-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0VBjlstndrPMxpDuqMzDBD2ypSEOd-2k
X-Proofpoint-ORIG-GUID: UoImdYwGHRyqmG7pGoIBibdsxDG8FKoT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_07:2021-05-31,2021-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0
 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105310075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 31 May 2021 10:50:03 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> To make our TAP parser (and me) happy we don't want to have to reports
> with exactly the same wording.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/selftest.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index b2fe2e7b..c2ca9896 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -47,12 +47,19 @@ static void test_malloc(void)
>  	*tmp2 = 123456789;
>  	mb();
>  
> -	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got
> vaddr");
> -	report(*tmp == 123456789, "malloc: access works");
> +	report_prefix_push("malloc");
> +	report_prefix_push("ptr_0");
> +	report((uintptr_t)tmp & 0xf000000000000000ul, "allocated
> memory");
> +	report(*tmp == 123456789, "wrote allocated memory");
> +	report_prefix_pop();
> +
> +	report_prefix_push("ptr_1");
>  	report((uintptr_t)tmp2 & 0xf000000000000000ul,
> -	       "malloc: got 2nd vaddr");
> -	report((*tmp2 == 123456789), "malloc: access works");
> -	report(tmp != tmp2, "malloc: addresses differ");
> +	       "allocated memory");
> +	report((*tmp2 == 123456789), "wrote allocated memory");
> +	report_prefix_pop();
> +
> +	report(tmp != tmp2, "allocated memory addresses differ");
>  
>  	expect_pgm_int();
>  	configure_dat(0);
> @@ -62,6 +69,7 @@ static void test_malloc(void)
>  
>  	free(tmp);
>  	free(tmp2);
> +	report_prefix_pop();
>  }
>  
>  int main(int argc, char**argv)

