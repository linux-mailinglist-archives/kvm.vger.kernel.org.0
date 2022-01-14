Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF9548E90C
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 12:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbiANLUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 06:20:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231167AbiANLUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 06:20:01 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EAu0BC017577;
        Fri, 14 Jan 2022 11:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nCvw7xkNn3wQzbWnjNpj3QLkPizsx5Vx3Suu7CL9nBA=;
 b=G+kdQ1kWKhoCibNnZrqhQ4T7mlggEFazBHTMjyf5sFemiSu5Dp4AtikVxMPyIH+1tpSA
 FacNQ6s0qKjAnSG6YJqT2LR2HiQzCBbpcTYlWyQQIRfMZY9XoqLNSTaKoTnp5PjqDW/l
 J6inybYSwJKDtVAbBTmE7FL1kE6425Ye0E0blvF0uaIMpuSs9FR9fgte/3c98yLgJKr8
 GyWUvdlhhj5MCAOE1ACbtVyaZ74FvjkjsUhBf7cvKWhTyWS9DEgx6MoYAIEwxh1J1411
 fd34a6TgfQ0y28/4oZbzE+miVhkTgFNzQeg6T8jb/xl6hegLFbGnDqzHyI7aq77xWmtf JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk7ux0cw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:20:00 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EAvhsh021532;
        Fri, 14 Jan 2022 11:19:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk7ux0cvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:19:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EBCxFP012759;
        Fri, 14 Jan 2022 11:19:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3df28adgr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 11:19:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EBAlwF47907082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 11:10:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A9034C040;
        Fri, 14 Jan 2022 11:19:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26C6D4C052;
        Fri, 14 Jan 2022 11:19:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.156])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 11:19:54 +0000 (GMT)
Date:   Fri, 14 Jan 2022 11:41:49 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: css: Skip if we're not run by
 qemu
Message-ID: <20220114114149.3a24406a@p-imbrenda>
In-Reply-To: <20220114100245.8643-3-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
        <20220114100245.8643-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sF4p2zOqIv-7FaduQnoslQ2AxiqVQ610
X-Proofpoint-ORIG-GUID: gP0joOBW57-2tK8XAMVdTq5KhhbO9YQh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_03,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 spamscore=0 mlxscore=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201140074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jan 2022 10:02:42 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> There's no guarantee that we even find a device at the address we're
> testing for if we're not running under QEMU.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/css.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 881206ba..c24119b4 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -15,6 +15,7 @@
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
>  #include <alloc_page.h>
> +#include <vm.h>
>  
>  #include <malloc_io.h>
>  #include <css.h>
> @@ -350,6 +351,12 @@ int main(int argc, char *argv[])
>  {
>  	int i;
>  
> +	/* There's no guarantee where our devices are without qemu */
> +	if (!vm_is_kvm() && !vm_is_tcg()) {
> +		report_skip("Not running under QEMU");
> +		goto done;
> +	}
> +
>  	report_prefix_push("Channel Subsystem");
>  	enable_io_isc(0x80 >> IO_SCH_ISC);
>  	for (i = 0; tests[i].name; i++) {
> @@ -357,7 +364,8 @@ int main(int argc, char *argv[])
>  		tests[i].func();
>  		report_prefix_pop();
>  	}
> -	report_prefix_pop();
>  
> +done:
> +	report_prefix_pop();
>  	return report_summary();
>  }

