Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6F7365C97
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhDTPsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:48:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232504AbhDTPsl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 11:48:41 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KFXoZV031113;
        Tue, 20 Apr 2021 11:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ID8hqtNM5urKGq7airRyqzvQZfoKIc1wjvm33vSFXfo=;
 b=LFByTvjlRvRsoMB1QKo8goe/ryN4VB+dcfqC89dzVp+5kTGNSYyFCqeGfiaXEtgvW5t9
 Mgh79N9iuK/axeyezXdKupyWMgJMOXSG2DT9X6jePUCq5iMExBHukJ0evkUp7rKLsqtY
 P+3xn4bh42qBOxf03Ke6Yyam7PYptmGRxtXOilBeE434EqUc0VFmQ34FFHGGxYdhz/Nh
 0yat+ukSbvRKfMuL/6E8c3QPGIBrxbeuOdP7tjwNuXom2T/FDA+TvTDzzwbA2zipwrtZ
 zDdx+oGhvRNUAjUQTS+X9VzhnflGB0yZTT92APcTd/SyIlpJYUkpYa16eFnLNviBLm05 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 381w1atb00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 11:48:09 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13KFXrTY031501;
        Tue, 20 Apr 2021 11:48:08 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 381w1atay0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 11:48:08 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13KFSO7m010259;
        Tue, 20 Apr 2021 15:48:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 37ypxh90au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 15:48:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13KFm4G825559542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 15:48:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63B994C044;
        Tue, 20 Apr 2021 15:48:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 151CE4C046;
        Tue, 20 Apr 2021 15:48:04 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.91])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Apr 2021 15:48:04 +0000 (GMT)
Date:   Tue, 20 Apr 2021 16:15:27 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/6] s390x: uv: Add UV lib
Message-ID: <20210420161527.615fb8f6@ibm-vm>
In-Reply-To: <20210316091654.1646-4-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
        <20210316091654.1646-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LNTWebNE6stWhryOMaB7_HQleBDwvL2r
X-Proofpoint-ORIG-GUID: _qLi2qraESggoXCyhMEzMKFXPv1VPuvb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_07:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 09:16:51 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's add a UV library to make checking the UV feature bit easier.
> In the future this library file can take care of handling UV
> initialization and UV guest creation.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

but see some comments below

> ---
>  lib/s390x/asm/uv.h |  4 ++--
>  lib/s390x/io.c     |  2 ++
>  lib/s390x/uv.c     | 48
> ++++++++++++++++++++++++++++++++++++++++++++++ lib/s390x/uv.h     |
> 10 ++++++++++ s390x/Makefile     |  1 +
>  5 files changed, 63 insertions(+), 2 deletions(-)
>  create mode 100644 lib/s390x/uv.c
>  create mode 100644 lib/s390x/uv.h
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 11f70a9f..b22cbaa8 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -9,8 +9,8 @@
>   * This code is free software; you can redistribute it and/or modify
> it
>   * under the terms of the GNU General Public License version 2.
>   */
> -#ifndef UV_H
> -#define UV_H
> +#ifndef ASM_S390X_UV_H
> +#define ASM_S390X_UV_H
>  
>  #define UVC_RC_EXECUTED		0x0001
>  #define UVC_RC_INV_CMD		0x0002
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index ef9f59e3..a4f1b113 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -14,6 +14,7 @@
>  #include <asm/facility.h>
>  #include <asm/sigp.h>
>  #include "sclp.h"
> +#include "uv.h"
>  #include "smp.h"
>  
>  extern char ipl_args[];
> @@ -38,6 +39,7 @@ void setup(void)
>  	sclp_facilities_setup();
>  	sclp_console_setup();
>  	sclp_memory_setup();
> +	uv_setup();
>  	smp_setup();
>  }
>  
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> new file mode 100644
> index 00000000..a84a85fc
> --- /dev/null
> +++ b/lib/s390x/uv.c
> @@ -0,0 +1,48 @@
> +#include <libcflat.h>
> +#include <bitops.h>
> +#include <alloc.h>
> +#include <alloc_page.h>
> +#include <asm/page.h>
> +#include <asm/arch_def.h>
> +
> +#include <asm/facility.h>
> +#include <asm/uv.h>
> +#include <uv.h>
> +
> +static struct uv_cb_qui uvcb_qui = {
> +	.header.cmd = UVC_CMD_QUI,
> +	.header.len = sizeof(uvcb_qui),
> +};
> +
> +bool uv_os_is_guest(void)
> +{
> +	return uv_query_test_feature(BIT_UVC_CMD_SET_SHARED_ACCESS)
> +		&&
> uv_query_test_feature(BIT_UVC_CMD_REMOVE_SHARED_ACCESS); +}
> +
> +bool uv_os_is_host(void)
> +{
> +	return uv_query_test_feature(BIT_UVC_CMD_INIT_UV);
> +}
> +
> +bool uv_query_test_feature(int nr)
> +{
> +	/* Query needs to be called first */
> +	if (!uvcb_qui.header.rc)
> +		return false;

why not an assert?

> +
> +	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
> +}
> +
> +int uv_setup(void)
> +{
> +	int cc;
> +
> +	if (!test_facility(158))
> +		return 0;
> +
> +	cc = uv_call(0, (u64)&uvcb_qui);
> +	assert(cc == 0);
> +
> +	return cc == 0;

sooo... return 1?

> +}
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> new file mode 100644
> index 00000000..159bf8e5
> --- /dev/null
> +++ b/lib/s390x/uv.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef UV_H
> +#define UV_H
> +
> +bool uv_os_is_guest(void);
> +bool uv_os_is_host(void);
> +bool uv_query_test_feature(int nr);
> +int uv_setup(void);
> +
> +#endif /* UV_H */
> diff --git a/s390x/Makefile b/s390x/Makefile
> index b92de9c5..bbf177fa 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -67,6 +67,7 @@ cflatobjs += lib/s390x/vm.o
>  cflatobjs += lib/s390x/css_dump.o
>  cflatobjs += lib/s390x/css_lib.o
>  cflatobjs += lib/s390x/malloc_io.o
> +cflatobjs += lib/s390x/uv.o
>  
>  OBJDIRS += lib/s390x
>  

