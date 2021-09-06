Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51745401ACC
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 13:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbhIFLy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 07:54:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39510 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241496AbhIFLy4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 07:54:56 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186BYHqd119903;
        Mon, 6 Sep 2021 07:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5xbxFGUZ/pEXUhWtb/NMPzffIemVKgnLwAplZTx8HYs=;
 b=Fc9JR8frtogCy1eeu0gD+X7Yx6u8xK7krblKkbZnCDsqwGTuGwUUzmvlUEkRbmqLhILT
 nZ2g/5noaCfz3ZZzThl/XHuyRockYaJ1gFo9PWynNzVQ3f8ZmBpbUU6HcGrTzp2MEWpx
 mPZNuB7NsIi1aRRFKWMlez/zyyZXRFXaXL+dC8SNGHpp6DZVlOPdv22vkLAsl35R22HR
 /LMI9fPH51/jXR6YwnZHr6WQIR5JKMzUbkUrAFr3Z1se0watuOLzeiYlTMq3EZN7jt/m
 lGqNmYnH6eG5UTlEabpDaFyfvm+PrkZIxjMjSNOFn3vuYJAYbe7pd2+auM2FD1gagRLD PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awhsx8v6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 07:53:51 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186BYlUH123170;
        Mon, 6 Sep 2021 07:53:51 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3awhsx8v5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 07:53:51 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186BlPL1018933;
        Mon, 6 Sep 2021 11:53:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3av0e8tq6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:53:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186Brjus25493990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 11:53:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82459A4065;
        Mon,  6 Sep 2021 11:53:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2330FA4053;
        Mon,  6 Sep 2021 11:53:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.85.19])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Sep 2021 11:53:45 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1] s390x/skey: Test for ADDRESSING
 exceptions
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org
References: <20210903162537.57178-1-david@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <a0dcbbcc-b564-940b-5cba-13027f06e3e6@linux.ibm.com>
Date:   Mon, 6 Sep 2021 13:53:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210903162537.57178-1-david@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8Ji2fDxEL9AtoMC4oyYSkHnDU-NqZvmW
X-Proofpoint-ORIG-GUID: -lF9aZ9TxeM4XQENpoKybRlb-ydaOUuO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_05:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/21 6:25 PM, David Hildenbrand wrote:
> ... used to be broken in TCG, so let's add a very simple test for SSKE
> and ISKE. In order to test RRBE as well, introduce a helper to call the
> machine instruction.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
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
> 

