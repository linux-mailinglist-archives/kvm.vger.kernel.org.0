Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D7E42BC23
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 11:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbhJMJxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 05:53:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20378 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235811AbhJMJxm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 05:53:42 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D9ihfO024150;
        Wed, 13 Oct 2021 05:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+oG/8O+ugu5JTXXvVXXOgkY3pIiMCq+tFTKQSSsHBIU=;
 b=eHIgLOCjmPfuSTs8/bEQhKaTZyd3yZxQ5iHUSDf6R6YqmtK7FRi6TIrNvtL034i/xY+Q
 H516LxPjKf10pJPNQG1cDhPD4TKu3++svjnztj+zyq1W+SaY0NuDqfunqZeOnWKRejIR
 eulg/hit4OutljK8n9feBp107M/jCoySiVFomGzN2MzUW3E1VMRxycIXKKurSE8EzZKZ
 glarZo4FgyKba2G2nBUiBegvQp6xWEkKLezmHDceWvPTODp8pL4BK+25Mj1lK+ZhW7Dx
 SZPTWlBRjrjW/w+XAXzFDSv0WCihCu8U5+6JwmQR501uqr5iCkbcunxWDEOgQ9dyooYk 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnqmp6y78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 05:51:39 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19D9TgRK011210;
        Wed, 13 Oct 2021 05:51:38 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnqmp6y6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 05:51:38 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19D9lvMD016226;
        Wed, 13 Oct 2021 09:51:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bjhf5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 09:51:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19D9jpha61407616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 09:45:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 924844C05C;
        Wed, 13 Oct 2021 09:51:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 461FB4C058;
        Wed, 13 Oct 2021 09:51:28 +0000 (GMT)
Received: from [9.145.94.172] (unknown [9.145.94.172])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 09:51:28 +0000 (GMT)
Message-ID: <4bb5ae96-2a01-c151-c1d9-9efedd2960f0@linux.ibm.com>
Date:   Wed, 13 Oct 2021 11:51:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH] s390x/snippets: Define all things that are
 needed to link the libc
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
References: <20211008092649.959956-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211008092649.959956-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yHSCv12_KVM3O7A5EoHcnJAwMmtT9LIZ
X-Proofpoint-ORIG-GUID: 5YNktcl0yN-qDKVDj2AEeo6sPKglNr2T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_03,2021-10-13_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110130064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/21 11:26, Thomas Huth wrote:
> In the long run, we want to use parts of the libc like memset() etc.,
> too. However, to be able to link it correctly, we have to provide
> some stub functions like puts() and exit() to avoid that too much
> other stuff from the lib folder gets pulled into the binaries, which
> we cannot provide in the snippets (like the sclp support).
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Thanks, picked!

> ---
>   s390x/Makefile            |  2 +-
>   s390x/snippets/c/cstart.S | 11 +++++++++++
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ef8041a..b2a7c1f 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -80,7 +80,7 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
>   FLATLIBS = $(libcflat)
>   
>   SNIPPET_DIR = $(TEST_DIR)/snippets
> -snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
> +snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o lib/auxinfo.o
>   
>   # perquisites (=guests) for the snippet hosts.
>   # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> index a175480..1862703 100644
> --- a/s390x/snippets/c/cstart.S
> +++ b/s390x/snippets/c/cstart.S
> @@ -20,6 +20,17 @@ start:
>   	lghi	%r15, 0x4000 - 160
>   	sam64
>   	brasl	%r14, main
> +	/*
> +	 * If main() returns, we stop the CPU with the code below. We also
> +	 * route some functions that are required by the libc (but not usable
> +	 * from snippets) to the CPU stop code below, so that snippets can
> +	 * still be linked against the libc code (to use non-related functions
> +	 * like memset() etc.)
> +	 */
> +.global puts
> +.global exit
> +puts:
> +exit:
>   	/* For now let's only use cpu 0 in snippets so this will always work. */
>   	xgr	%r0, %r0
>   	sigp    %r2, %r0, SIGP_STOP
> 

