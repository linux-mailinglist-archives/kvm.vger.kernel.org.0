Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160C9401ADC
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 14:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbhIFMDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 08:03:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229648AbhIFMDn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 08:03:43 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186BumjL092208;
        Mon, 6 Sep 2021 08:02:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Bjuk2NDJE+6fXhkJSAQxTPZRvmPVUvFZ+XXivWwaByY=;
 b=rDIbK6nRtxrctvyX12DQirogMcS8cdnGD8ztT5JBryAqx99avkOmVTc7+lv82K0DQ8qq
 3Ry82olsgzCKwHj6qI5bzZTRcy4ovVCralJ5HZOEgfwBw/bDp618ll+y5klJoaHNEups
 E3tkjdLTKTJu9gVhDGImRMr/3Yp5/5BUF2IwAtJ4SIYgM5Za5ATtZzmGUASGQbq4UnwO
 8OGhtfK4EIolpRBOjLMQ+/FiNwChprF8IE9Zd4ktAWcLxzj4F7uuWQoIdznzhQmnhKy0
 P3pxx1Q7DhpyowiBH8XExICcTPIXJ+nbk5OZkuII0HHqKyi13x6yJ0SZ2WYC7H4+2JFN vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awjje83n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 08:02:37 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186BvW0Z096218;
        Mon, 6 Sep 2021 08:02:37 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awjje83m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 08:02:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186BvOqD029141;
        Mon, 6 Sep 2021 12:02:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3av0e93h10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 12:02:34 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186C2S2a57606462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 12:02:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8A1F420BC;
        Mon,  6 Sep 2021 12:02:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 611764209E;
        Mon,  6 Sep 2021 12:02:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.215])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Sep 2021 12:02:28 +0000 (GMT)
Date:   Mon, 6 Sep 2021 14:02:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x/skey: Test for ADDRESSING
 exceptions
Message-ID: <20210906140225.4edfdd9a@p-imbrenda>
In-Reply-To: <20210903162537.57178-1-david@redhat.com>
References: <20210903162537.57178-1-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Dj6Obc5eBoX8Jlq7l5ugYr8WD89ImTxW
X-Proofpoint-GUID: aKqjbbrKe0Yc-EwxTKacf4yaWw1Dbksc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_05:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Sep 2021 18:25:37 +0200
David Hildenbrand <david@redhat.com> wrote:

> ... used to be broken in TCG, so let's add a very simple test for SSKE
> and ISKE. In order to test RRBE as well, introduce a helper to call the
> machine instruction.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Maybe consider testing rrbm too, but anyway:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/mem.h | 12 ++++++++++++
>  s390x/skey.c        | 28 ++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> index 40b22b6..845c00c 100644
> --- a/lib/s390x/asm/mem.h
> +++ b/lib/s390x/asm/mem.h
> @@ -50,6 +50,18 @@ static inline unsigned char get_storage_key(void *addr)
>  	return skey;
>  }
>  
> +static inline unsigned char reset_reference_bit(void *addr)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"rrbe	0,%1\n"
> +		"ipm	%0\n"
> +		"srl	%0,28\n"
> +		: "=d" (cc) : "a" (addr) : "cc");
> +	return cc;
> +}
> +
>  #define PFMF_FSC_4K 0
>  #define PFMF_FSC_1M 1
>  #define PFMF_FSC_2G 2
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 2539944..58a5543 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -120,6 +120,33 @@ static void test_priv(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_invalid_address(void)
> +{
> +	void *inv_addr = (void *)-1ull;
> +
> +	report_prefix_push("invalid address");
> +
> +	report_prefix_push("sske");
> +	expect_pgm_int();
> +	set_storage_key(inv_addr, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +	report_prefix_pop();
> +
> +	report_prefix_push("iske");
> +	expect_pgm_int();
> +	get_storage_key(inv_addr);
> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +	report_prefix_pop();
> +
> +	report_prefix_push("rrbe");
> +	expect_pgm_int();
> +	reset_reference_bit(inv_addr);
> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("skey");
> @@ -128,6 +155,7 @@ int main(void)
>  		goto done;
>  	}
>  	test_priv();
> +	test_invalid_address();
>  	test_set();
>  	test_set_mb();
>  	test_chg();

