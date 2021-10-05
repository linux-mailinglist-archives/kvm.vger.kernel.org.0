Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB91F422762
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhJENKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:10:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233365AbhJENKi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:10:38 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195D2YWs015076;
        Tue, 5 Oct 2021 09:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0cSgTjVyv6tdhQk1BtAF/4xpZYYLqoXHRra4hgJ0sy8=;
 b=nn/zraNTPagQKyUc1zBDpvyWZibUEpK4wpHAMz8ko8yQRpnqA2/TY8wJe97XTb2uaTTy
 oyhzepW7Zv/d6I76Tgx8AkYX05DdbEUdpMocbD9D691RzhK1XRxtDkjz/kaXnhNeGlFw
 Tj0DMXCDRQaJrrbcEVyksPOyF74Ntz9TnaK9SH8YNhtJSH7ABiTWkUqXCrnDYO0olwum
 FOMBsVL/83PHSyDRd/+xrMfJQ6waOuR5tAOgMUwJD53hJDsQ0xOt8rNbCYvrQKN6RSBP
 ZVuDj8VE680/GAUoE76yLnG+IUmZ6WyQs3Y6ivuCZyQKF8AqGtZOmanc06/vnX/kVh8j Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgq7tg85g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:08:47 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195D2iuk016353;
        Tue, 5 Oct 2021 09:08:47 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgq7tg84k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:08:47 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195D6wcf002831;
        Tue, 5 Oct 2021 13:08:44 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3bef29gexf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:08:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195D8daj46006548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:08:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED02AA4053;
        Tue,  5 Oct 2021 13:08:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61706A4055;
        Tue,  5 Oct 2021 13:08:38 +0000 (GMT)
Received: from [9.145.45.132] (unknown [9.145.45.132])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 13:08:38 +0000 (GMT)
Message-ID: <3724d415-0434-b0ca-0701-6eea509ec6b5@linux.ibm.com>
Date:   Tue, 5 Oct 2021 15:08:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 01/14] KVM: s390: pv: add macros for UVC CC values
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20210920132502.36111-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rs5EcQhP-8CFkWzg4xcS0-ptZ4qV_5XC
X-Proofpoint-GUID: EaOK_0jS70yFO-I1xdu6OVKavYg4_l8C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_01,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/21 15:24, Claudio Imbrenda wrote:
> Add macros to describe the 4 possible CC values returned by the UVC
> instruction.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/include/asm/uv.h | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 12c5f006c136..b35add51b967 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -18,6 +18,11 @@
>   #include <asm/page.h>
>   #include <asm/gmap.h>
>   
> +#define UVC_CC_OK	0
> +#define UVC_CC_ERROR	1
> +#define UVC_CC_BUSY	2
> +#define UVC_CC_PARTIAL	3
> +
>   #define UVC_RC_EXECUTED		0x0001
>   #define UVC_RC_INV_CMD		0x0002
>   #define UVC_RC_INV_STATE	0x0003
> 

