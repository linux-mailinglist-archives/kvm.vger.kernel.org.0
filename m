Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5646D349651
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhCYQDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:03:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229900AbhCYQDM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:03:12 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PG2xpe075609
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=I4nSDr10ewjmwUcjc19emy9l4K9jPHKXZwsB0+xFQU8=;
 b=HREyrvYFgjOGC+KM89/fwikqMSRXtQHpiQ2JzmVbZKNmuM3qJIfVsL9zidfQ71D4ExL4
 u8PV6BE/tvjtpFU7Zadb2GVxDHHwpqdlWy6VjYfdMJgARhUnNA0vb3k1lG5hgt7WhR2s
 u1JH5aYIAFF4r5yYHRrMlNF9BZES4GK0tVq0h72fQwuLONlryiCxwht/IiRiwqrHpt7Q
 gXw3ktplrileGS0BK/TxN/EG/PyWxGSmqMKhtMXlODi6JhSFk0wHupmAZyQlJjBHbx24
 2zUtwTJV9WzdTIKz227t30ounzzlQX/xWzElGUSJnGFoDsOLNkqLWs6W+o0G3ESRIocy 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gvncae37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:11 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PG3BUQ077074
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:11 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gvncae0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:03:11 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PFvosM011371;
        Thu, 25 Mar 2021 16:03:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 37d99xjwpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:03:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PG35CS26411404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:03:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0B5142041;
        Thu, 25 Mar 2021 16:03:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9140F4203F;
        Thu, 25 Mar 2021 16:03:04 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:03:04 +0000 (GMT)
Date:   Thu, 25 Mar 2021 16:40:38 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: lib: css: add SCSW ctrl
 expectations to check I/O completion
Message-ID: <20210325164038.62d939f1@ibm-vm>
In-Reply-To: <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0 clxscore=1015
 adultscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 10:39:04 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> When checking for an I/O completion may need to check the cause of
> the interrupt depending on the test case.
> 
> Let's provide the tests the possibility to check if the last
> valid IRQ received is for the function expected after executing
> an instruction or sequence of instructions and if all ctrl flags
> of the SCSW are set as expected.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  4 ++--
>  lib/s390x/css_lib.c | 21 ++++++++++++++++-----
>  s390x/css.c         |  4 ++--
>  3 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 5d1e1f0..1603781 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -316,8 +316,8 @@ void css_irq_io(void);
>  int css_residual_count(unsigned int schid);
>  
>  void enable_io_isc(uint8_t isc);
> -int wait_and_check_io_completion(int schid);
> -int check_io_completion(int schid);
> +int wait_and_check_io_completion(int schid, uint32_t ctrl);
> +int check_io_completion(int schid, uint32_t ctrl);
>  
>  /*
>   * CHSC definitions
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index 1e5c409..55e70e6 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -488,21 +488,25 @@ struct ccw1 *ccw_alloc(int code, void *data,
> int count, unsigned char flags) 
>  /* wait_and_check_io_completion:
>   * @schid: the subchannel ID
> + * @ctrl : expected SCSW control flags
>   */
> -int wait_and_check_io_completion(int schid)
> +int wait_and_check_io_completion(int schid, uint32_t ctrl)
>  {
>  	wait_for_interrupt(PSW_MASK_IO);
> -	return check_io_completion(schid);
> +	return check_io_completion(schid, ctrl);
>  }
>  
>  /* check_io_completion:
>   * @schid: the subchannel ID
> + * @ctrl : expected SCSW control flags
>   *
> - * Makes the most common check to validate a successful I/O
> - * completion.
> + * If the ctrl parameter is not null check the IRB SCSW ctrl

I would say "not zero" instead of null, since it's an integer and not a
pointer.

with that fixed:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> + * against the ctrl parameter.
> + * Otherwise, makes the most common check to validate a successful
> + * I/O completion.
>   * Only report failures.
>   */
> -int check_io_completion(int schid)
> +int check_io_completion(int schid, uint32_t ctrl)
>  {
>  	int ret = 0;
>  
> @@ -515,6 +519,13 @@ int check_io_completion(int schid)
>  		goto end;
>  	}
>  
> +	if (ctrl && (ctrl ^ irb.scsw.ctrl)) {
> +		report_info("%08x : %s", schid,
> dump_scsw_flags(irb.scsw.ctrl));
> +		report_info("expected : %s", dump_scsw_flags(ctrl));
> +		ret = -1;
> +		goto end;
> +	}
> +
>  	/* Verify that device status is valid */
>  	if (!(irb.scsw.ctrl & SCSW_SC_PENDING)) {
>  		report(0, "No status pending after interrupt. Subch
> Ctrl: %08x", diff --git a/s390x/css.c b/s390x/css.c
> index 16723f6..57dc340 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -95,7 +95,7 @@ static void test_sense(void)
>  		goto error;
>  	}
>  
> -	if (wait_and_check_io_completion(test_device_sid) < 0)
> +	if (wait_and_check_io_completion(test_device_sid, 0) < 0)
>  		goto error;
>  
>  	/* Test transfer completion */
> @@ -138,7 +138,7 @@ static void sense_id(void)
>  {
>  	assert(!start_ccw1_chain(test_device_sid, ccw));
>  
> -	assert(wait_and_check_io_completion(test_device_sid) >= 0);
> +	assert(wait_and_check_io_completion(test_device_sid, 0) >=
> 0); }
>  
>  static void css_init(void)

