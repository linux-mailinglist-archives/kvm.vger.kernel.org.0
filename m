Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3542C478981
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 12:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbhLQLJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 06:09:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233227AbhLQLJO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 06:09:14 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH95Lng013878;
        Fri, 17 Dec 2021 11:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Gg1C/fPWioF91+fjlcSqLA0NjbNmCkZdO9spNHgcZ8s=;
 b=r0vl/J7vCFdRjw04Gg7z3AEwU7NSQhGlU2JcXECA4l72I9bcJn4p4YDQsjyr4qCTyLXl
 cDAW4C4nlTwW6g+gG90LyoV833NMl98/NelT+b1374D6enI+ewHknhv1wjms5d+eELpk
 s6MC3UtOxThKUFweHvUIV4X8YOL08n5myL1+h6zLolEX6C/KLtoelnphi9YgQ6Vj8rbu
 ZtAXC9aBIUQDuNzxownz+s/iLNFe0EiRaJVfOMSDSWDgP1F6f9HjlQWDztxFEKyoyqDa
 Kjj/HDL5WZvUH1KEYrTHD8sdBcMupymbDMVbRmh2i9CPm5EjmKUzilRNe08Au48O74rt yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cynfx5299-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 11:09:14 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHAcoBh003115;
        Fri, 17 Dec 2021 11:09:14 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cynfx528q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 11:09:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHB92wG019168;
        Fri, 17 Dec 2021 11:09:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cy78erkwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 11:09:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHB8JXv35455352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 11:08:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6973BA40B4;
        Fri, 17 Dec 2021 11:08:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18FF5A40A0;
        Fri, 17 Dec 2021 11:08:19 +0000 (GMT)
Received: from osiris (unknown [9.145.1.195])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 17 Dec 2021 11:08:19 +0000 (GMT)
Date:   Fri, 17 Dec 2021 12:08:17 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com
Subject: Re: [PATCH kvm-unit-tests 2/2] s390x: diag288: Improve readability
Message-ID: <YbxvoacUvh8+2zQ/@osiris>
References: <20211217103137.1293092-1-nrb@linux.ibm.com>
 <20211217103137.1293092-3-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217103137.1293092-3-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T2SxnrM40apqhutlQm1QKFfNjvj5b-C-
X-Proofpoint-ORIG-GUID: GQUHcg5pfltLfJeF7mG33efJdWttbQka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_04,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=784 malwarescore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112170064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17, 2021 at 11:31:37AM +0100, Nico Boehr wrote:
> Use a more descriptive name instead of the magic number 424 (address of
> restart new PSW in the lowcore).
> 
> In addition, add a comment to make it more obvious what the ASM snippet
> does.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/diag288.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/diag288.c b/s390x/diag288.c
> index da7b06c365bf..a2c263e38338 100644
> --- a/s390x/diag288.c
> +++ b/s390x/diag288.c
> @@ -94,12 +94,15 @@ static void test_bite(void)
>  	/* Arm watchdog */
>  	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
>  	diag288(CODE_INIT, 15, ACTION_RESTART);
> +	/* Wait for restart interruption */
>  	asm volatile("		larl	0, 1f\n"
> -		     "		stg	0, 424\n"
> +		     "		stg	0, %[restart_new_psw]\n"
>  		     "0:	nop\n"
>  		     "		j	0b\n"
>  		     "1:"
> -		     : : : "0");
> +		     :
> +		     : [restart_new_psw] "T" (lc->restart_new_psw.addr)

Even though it was wrong and missing before: this is an output not an input
parameter. Also, older compilers might fail if only the "T" constraint is
given (see gcc commit 3e4be43f69da ("S/390: Memory constraint cleanup")).
Which means: "=RT" would be correct. To be on the safe side, and to avoid
that gcc optimizes any potential prior C code away, I'd recommend to use
"+RT" in this case.

Also there is an ordering problem here: starting the time bomb before the
restart psw has been setup is racy. It is unlikely that this fails, but
still...

Correct would be to setup the restart psw, and then start the time
bomb. This would also allow to shorten the runtime of this test case to
1 second, instead of the 15 seconds it is running now.

It was all like that before, I know. Just some comments ;)
