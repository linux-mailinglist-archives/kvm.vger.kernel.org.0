Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C053365CA1
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhDTPsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:48:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53222 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232997AbhDTPsu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 11:48:50 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KFiIad006282;
        Tue, 20 Apr 2021 11:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gqw2NnKwGeTXoIR47561+cS/58nFNhbksZGSmlUSIYI=;
 b=kj/I1ihfnZcf033J2FcT91hWJyfgTLKjoL3Ghq5sxerMkd5ZRvD48tgYuAnmU1hVrB7d
 RHbo3BNj1/zINmREaWLa2cx1J+gwy06c4e7d0lHh7+5Ym/4yCXtWtaYSi7JqBpGTnK2n
 Apx9YHqN6MpHM1331o96KW2QdnF94mHMZ45a5X0Y2ds3h3z0cADh06jAg1K11Ob7ED8h
 JO2C14WqXDNQbsUMTH4eZ7Bow8Yf/45Hol3Puo3CdJj3lbjRe1jlDD8mgM9r2BZhRL9F
 Kx69zfydMsXtxgHezUSy/JR3QOeTpHqD1WBm/Vc6E1dpvBgWAAyMzZzbHN4Ww+OVRs1S 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3821v08404-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 11:48:18 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13KFjfrR015092;
        Tue, 20 Apr 2021 11:48:18 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3821v083yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 11:48:18 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13KFmGYp004439;
        Tue, 20 Apr 2021 15:48:16 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 37yqa8htuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 15:48:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13KFmEGn58917326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 15:48:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CCF24C044;
        Tue, 20 Apr 2021 15:48:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2EFC4C040;
        Tue, 20 Apr 2021 15:48:13 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.0.91])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Apr 2021 15:48:13 +0000 (GMT)
Date:   Tue, 20 Apr 2021 15:40:06 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/6] s390x: uv-guest: Add invalid share
 location test
Message-ID: <20210420154006.6ef10fb0@ibm-vm>
In-Reply-To: <20210316091654.1646-2-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
        <20210316091654.1646-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZLSu3Y7M2Sd-6ErWoM2GnYpoZVb95okf
X-Proofpoint-ORIG-GUID: 1j0yr35ngx4JuAaYMDPCKeDR4gkcuSnI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_07:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 09:16:49 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's also test sharing unavailable memory.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/uv-guest.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 99544442..a13669ab 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -15,6 +15,7 @@
>  #include <asm/interrupt.h>
>  #include <asm/facility.h>
>  #include <asm/uv.h>
> +#include <sclp.h>
>  
>  static unsigned long page;
>  
> @@ -99,6 +100,10 @@ static void test_sharing(void)
>  	uvcb.header.len = sizeof(uvcb);
>  	cc = uv_call(0, (u64)&uvcb);
>  	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED,
> "share");
> +	uvcb.paddr = get_ram_size() + PAGE_SIZE;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x101, "invalid memory");
> +	uvcb.paddr = page;
>  	report_prefix_pop();
>  
>  	report_prefix_push("unshare");

