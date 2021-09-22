Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB6F414548
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhIVJha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:37:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20736 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234436AbhIVJh0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:37:26 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M70TH2022247;
        Wed, 22 Sep 2021 05:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1gCiJz2Dg4uiCUhfZ4ZZ/gcnGa/NxFcJXNdXDhNlYc8=;
 b=gP93EJMocc3fgUHCfsl93EPpmtXxw/uN75mtRc4jwfeTo/ZwaHzUwFuW+OBWJPWYcZ6b
 vgh5w0VSwkPVhARXqncNrV/Rk75T8QxoiYSaf1cghzQaVOXCTy0tVVGMPSfmMro9cMBo
 jq8OZJEXVBd4LS9E5AH/DqKPhmhUqRNa6M0R+E88ytleV0p5J7sYIIgeSNqO5MoQePrH
 OimR1klCH3qUPkPqX1rcYW1kVsYOUs9M46+ePmuhjEFI3wJ8JZ/WX8KZGWoVDbB62Se+
 TllQnUJBoFEo2o5Fp+INMr3gELqoKPEv3CfI5CRXRVsm3pWa8WAbKK4JhlLMKTvIg1RY /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yqjk5uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:55 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M8thiU030084;
        Wed, 22 Sep 2021 05:35:55 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yqjk5uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:55 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M9Vt00008536;
        Wed, 22 Sep 2021 09:35:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3b7q6rmkut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:35:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M9UxIK57540906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 09:30:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B029AE053;
        Wed, 22 Sep 2021 09:35:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A656AE051;
        Wed, 22 Sep 2021 09:35:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 09:35:48 +0000 (GMT)
Date:   Wed, 22 Sep 2021 11:19:09 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 4/9] lib: s390x: uv: Fix share return
 value and print
Message-ID: <20210922111909.53fbaba1@p-imbrenda>
In-Reply-To: <20210922071811.1913-5-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
        <20210922071811.1913-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ERPuR-9duaOhJxxNONJsFFCGokgMAcfX
X-Proofpoint-ORIG-GUID: vgYOh2hC606sE0wE-QkfeOeHOCWO1NMF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109200000 definitions=main-2109220066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 07:18:06 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's only return 0/1 for success/failure respectively.
> If needed we can later add rc/rrc pointers so we can check for the
> reasons of cc==1 cases like we do in the kernel.
> 
> As share might also be used in snippets it's best not to use prints to
> avoid linking problems so lets remove the report_info().
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/uv.h | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index ec10d1c4..2f099553 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -219,15 +219,8 @@ static inline int share(unsigned long addr, u16 cmd)
>  		.header.len = sizeof(uvcb),
>  		.paddr = addr
>  	};
> -	int cc;
>  
> -	cc = uv_call(0, (u64)&uvcb);
> -	if (!cc && uvcb.header.rc == UVC_RC_EXECUTED)
> -		return 0;
> -
> -	report_info("uv_call: cmd %04x cc %d response code: %04x", cc, cmd,
> -		    uvcb.header.rc);
> -	return -1;
> +	return uv_call(0, (u64)&uvcb);
>  }
>  
>  /*

