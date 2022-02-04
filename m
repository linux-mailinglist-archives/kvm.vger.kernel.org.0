Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCD34A98F8
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 13:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358545AbiBDML5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 07:11:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241756AbiBDML4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 07:11:56 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214C2j3M010501
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 12:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ptvSZFzAhg7Vb2fXMkHMhceILqgLpcsdBmgWQet0CbI=;
 b=qbLPKTONS7ep+Kv6nSD7O/5vAXtcXvwukWaR2v+/NHg4lyLlC9IzeiFJ1G3aJHwOUhNh
 H0bDnjtVq/o6Gblpw+g9AUnuEaXNOtpNgUJqvxUM4kQUUZKOgoJxVtYWwZKfgy2Zjyhf
 odEbkRoZBZEKA6Z9IvB1fPVwyzngf3oZZNsPBB2wqXOVsW7afGyIGy24El77HI2fnY2U
 j8gikc5jcrMqYEXty36cTzsoELx43FMLFLjL/toCEAVGB/htsBYWsBCJXS/ZefPg4x2H
 xWRRrAz8QRoriJaK92qesKkew19EmUj+9DQYJnAaZbVnLW0Q6QJfE7vabsGRMsgBu1Db vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e109ev6qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 12:11:56 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214BvjSc029323
        for <kvm@vger.kernel.org>; Fri, 4 Feb 2022 12:11:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e109ev6q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 12:11:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214CBaFY016162;
        Fri, 4 Feb 2022 12:11:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3e0r10cdgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 12:11:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214CBp7D47579448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 12:11:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6A0FA405E;
        Fri,  4 Feb 2022 12:11:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3727AA4055;
        Fri,  4 Feb 2022 12:11:51 +0000 (GMT)
Received: from [9.145.158.84] (unknown [9.145.158.84])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 12:11:51 +0000 (GMT)
Message-ID: <435a0312-5b6c-a6a6-12a8-f3a7cc5c61e4@linux.ibm.com>
Date:   Fri, 4 Feb 2022 13:11:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: firq: fix running in PV
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com
References: <20220203161834.52472-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220203161834.52472-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IJFZHpAjoDpSvVGP5qRk0NH9zu4ZnuKp
X-Proofpoint-ORIG-GUID: CFgOm62GG21Pq4s5x_a_QPIWnMbFlol1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_04,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 17:18, Claudio Imbrenda wrote:
> If using the qemu CPU type, Protected Virtualization is not available,
> and the test will fail to start when run in PV. If specifying the host
> CPU type, the test will fail to start with TCG because the host CPU
> type requires KVM. In both cases the test will show up as failed.
> 
> This patch adds a copy of the firq test definitions for KVM, using the
> host CPU type, and specifying that KVM is to be used. The existing
> firq tests are then fixed by specifying that TCG is to be used.
> 
> When running the tests normally, both variants will be run. If an
> accelerator is specified explicitly when running the tests, only one
> variant will run and the other will be skipped (and not fail).
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 8b98745d ("s390x: firq: floating interrupt test")
> ---

That would indeed explain what went wrong :)
Acked-by: Janosch Frank <frankja@linux.ibm.com>

>   s390x/unittests.cfg | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 054560c2..1600e714 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -113,12 +113,26 @@ file = mvpg-sie.elf
>   [spec_ex-sie]
>   file = spec_ex-sie.elf
>   
> -[firq-linear-cpu-ids]
> +[firq-linear-cpu-ids-kvm]
> +file = firq.elf
> +timeout = 20
> +extra_params = -smp 1,maxcpus=3 -device host-s390x-cpu,core-id=1 -device host-s390x-cpu,core-id=2
> +accel = kvm
> +
> +[firq-nonlinear-cpu-ids-kvm]
> +file = firq.elf
> +timeout = 20
> +extra_params = -smp 1,maxcpus=3 -device host-s390x-cpu,core-id=2 -device host-s390x-cpu,core-id=1
> +accel = kvm
> +
> +[firq-linear-cpu-ids-tcg]
>   file = firq.elf
>   timeout = 20
>   extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=1 -device qemu-s390x-cpu,core-id=2
> +accel = tcg
>   
> -[firq-nonlinear-cpu-ids]
> +[firq-nonlinear-cpu-ids-tcg]
>   file = firq.elf
>   timeout = 20
>   extra_params = -smp 1,maxcpus=3 -cpu qemu -device qemu-s390x-cpu,core-id=2 -device qemu-s390x-cpu,core-id=1
> +accel = tcg
> 

