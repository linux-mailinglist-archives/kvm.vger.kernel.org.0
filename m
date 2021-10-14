Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1148342D9D8
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 15:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhJNNMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 09:12:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6926 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230010AbhJNNMx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 09:12:53 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ED9Gka021652;
        Thu, 14 Oct 2021 09:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WThqPwMP2OLhr33ez5Gp6Jyfx+8H4EiSb+D3oodMMf4=;
 b=rTaPoERli98kn3TRxuQ4AihNbZxJQ4zSb3mRqw6hNZjHLKN1ecmVEki7M9iq0JKxZU/e
 zm4OpS1IUGF1ZeU8nP9pmRhssIuOLn2ORGvlN2M9H0NUvqedwaI3ya9VtXBfSxRIPXjd
 3uDTebB0i+DHkRTLKz4dQuD5aS3N/zuFWKyu9K2OL7LfksainLIW+W5532WK8qG+N2nt
 8ouChVv0BHn5qO5kXM4a77DKAvXSS5JqO5NVVcnJ4AcGw4YbIJlEqSrtqglysjgcQYxb
 uuo5hy7xwyLWdGgYeBQe01jKNtWSKKjSm9ape4aeVMkpi5FLhT667AND2mgNqIn8N2OV qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnpf49rr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 09:10:48 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ECqJlj040792;
        Thu, 14 Oct 2021 09:10:48 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnpf49rpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 09:10:47 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ED1WCV029176;
        Thu, 14 Oct 2021 13:10:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2qa5et1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 13:10:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19EDAg2147317416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 13:10:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41E4F42049;
        Thu, 14 Oct 2021 13:10:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F346F4203F;
        Thu, 14 Oct 2021 13:10:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.174])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 13:10:41 +0000 (GMT)
Date:   Thu, 14 Oct 2021 15:10:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] lib: s390x: Fix copyright message
Message-ID: <20211014151014.583ad407@p-imbrenda>
In-Reply-To: <20211014125107.2877-4-frankja@linux.ibm.com>
References: <20211014125107.2877-1-frankja@linux.ibm.com>
        <20211014125107.2877-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rpW2vVlXDmNFnTyZ9WnB35ioK5Yndm0n
X-Proofpoint-ORIG-GUID: 56hkh3IJcviI4E3RN62yUIgIqVzBeTio
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_07,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110140084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Oct 2021 12:51:07 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The comma makes no sense, so let's remove it.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/css.h  | 2 +-
>  lib/s390x/sclp.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index d644971f..0db8a281 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -2,7 +2,7 @@
>  /*
>   * CSS definitions
>   *
> - * Copyright IBM, Corp. 2020
> + * Copyright IBM Corp. 2020
>   * Author: Pierre Morel <pmorel@linux.ibm.com>
>   */
>  
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 28e526e2..61e9cf51 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -6,7 +6,7 @@
>   * Copyright (c) 2013 Alexander Graf <agraf@suse.de>
>   *
>   * and based on the file include/hw/s390x/sclp.h from QEMU
> - * Copyright IBM, Corp. 2012
> + * Copyright IBM Corp. 2012
>   * Author: Christian Borntraeger <borntraeger@de.ibm.com>
>   */
>  

