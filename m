Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13E6525176
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356046AbiELPmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 11:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355808AbiELPmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 11:42:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8498C3FDA4;
        Thu, 12 May 2022 08:42:13 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CFTKEP039982;
        Thu, 12 May 2022 15:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lEvxKJ/T+mNUNUYmKOdxNmxrgeqXiJKfyNLgeKEEQFs=;
 b=lomlNPNoe1wMJOZNQBZ7z0Sp8RgGbIVjzaSXVJfC/gQ5WzX7qX6jpNLI06puy2c77Gfw
 32u4h1s/Q5GJvOXd2gOpRPLUfNypdR5mjIA3imA1fK2j/cKIo8KxgxUxpDPBKqvgTzf2
 arKMHSdLN73QOOn6zlZ2J3xg+EXSeCQ3Ug5yfsur3qZ8rNtAl6bN+OkrRljGejB6JhW1
 XHTORv/l9pt+VNkFMcmXPIGvzUW/ymJp4QKIagwqSQbI26Qu7BfoxyQi7c1qMlHvwVTz
 Xp6/91nqI2M08TTCbo/0FR4/I8CkjsLwmaaBg/h6WWt16tHH0hW4RgRRaP7rs+gPjdZ0 Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g14x2g99n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:42:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24CFVoEK011400;
        Thu, 12 May 2022 15:42:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g14x2g98n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:42:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24CFOk9V031131;
        Thu, 12 May 2022 15:42:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd8y989-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 15:42:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24CFfiNt29950424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 15:41:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A723A4051;
        Thu, 12 May 2022 15:42:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBECFA404D;
        Thu, 12 May 2022 15:42:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.145])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 May 2022 15:42:05 +0000 (GMT)
Date:   Thu, 12 May 2022 17:23:50 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib: s390x: introduce
 check_pgm_int_code_xfail()
Message-ID: <20220512172350.44bc96f2@p-imbrenda>
In-Reply-To: <20220512140107.1432019-2-nrb@linux.ibm.com>
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
        <20220512140107.1432019-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: abcK-2f7-k0HvtMfB913JzUkMEViuNZD
X-Proofpoint-ORIG-GUID: 7Wx7XblZ3PnBJmjNmho07wb0KPXNITaa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_12,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205120075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 May 2022 16:01:06 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Right now, it is not very convenient to have expected failures when checking for
> program interrupts. Let's introduce check_pgm_int_code_xfail() with an API
> similar to report_xfail() to make the programmer's life easier.
> 
> With this, we can express check_pgm_int_code() as a special case of
> check_pgm_int_code_xfail() with xfail = false.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/interrupt.h | 1 +
>  lib/s390x/interrupt.c     | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> index d9ab0bd781c9..88731da9e341 100644
> --- a/lib/s390x/asm/interrupt.h
> +++ b/lib/s390x/asm/interrupt.h
> @@ -46,6 +46,7 @@ void handle_svc_int(void);
>  void expect_pgm_int(void);
>  void expect_ext_int(void);
>  uint16_t clear_pgm_int(void);
> +void check_pgm_int_code_xfail(bool xfail, uint16_t code);
>  void check_pgm_int_code(uint16_t code);

... here ^ (see below)

>  
>  /* Activate low-address protection */
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 27d3b767210f..b61f7d588550 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -47,14 +47,19 @@ uint16_t clear_pgm_int(void)
>  	return code;
>  }
>  
> -void check_pgm_int_code(uint16_t code)
> +void check_pgm_int_code_xfail(bool xfail, uint16_t code)
>  {
>  	mb();
> -	report(code == lc->pgm_int_code,
> +	report_xfail(xfail, code == lc->pgm_int_code,
>  	       "Program interrupt: expected(%d) == received(%d)", code,
>  	       lc->pgm_int_code);
>  }
>  
> +void check_pgm_int_code(uint16_t code)
> +{
> +	check_pgm_int_code_xfail(false, code);
> +}
> +

... maybe at this point make it a macroid (static inline function)
directly in the .h ?

>  void register_pgm_cleanup_func(void (*f)(void))
>  {
>  	pgm_cleanup_func = f;

