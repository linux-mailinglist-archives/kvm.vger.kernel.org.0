Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2BF300441
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 14:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbhAVNeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 08:34:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44710 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727925AbhAVNeM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 08:34:12 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MDXCw4026658;
        Fri, 22 Jan 2021 08:33:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=l7gJ2nwBPBCSRDFJJZ7/V0jJCvIWO4QnyiU3KVOQ4oQ=;
 b=DFtSCrBidu+FY7Jt1QrTqCgeXlZXyYFBAiKsEfKWuNp02oC+80golTHxewHFmEvKyCfF
 BP7/rcuZUvBFdZuZ27hiRxt3+mcWGLZKEp9wr7aXVrfR7XF1gj7hoR6OgyQzJKAE3wEI
 MMqG/OkUBCbyMkfDQW/PWRyPiIPL58GoupbTAD5cDzU5TuoOcqH9fBlGrClz2z5Q2ezl
 BlnORg3uml3KaOp6Q9NFqJd6VZG0CQtUMgzl0SOQW6cAkUlXHtDCuQw8YnZQ+9L7RVDZ
 jLAK/tQXzenZawLMumoSXfu+8TeZ8FO7OEsk+IBTYc3E75tCcyEtPSIJ44YqPLteEKwn 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367ygpr9v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:33:20 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MDXHvu027654;
        Fri, 22 Jan 2021 08:33:17 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367ygpr9nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:33:17 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MDRc2w017331;
        Fri, 22 Jan 2021 13:33:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 367k12gky4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 13:33:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MDWtLK28180940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 13:32:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E1BAE051;
        Fri, 22 Jan 2021 13:33:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BCDAAE045;
        Fri, 22 Jan 2021 13:33:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.26.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 13:33:01 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 1/3] s390x: pv: implement routine to
 share/unshare memory
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
 <1611322060-1972-2-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <9c488fa9-9b65-ea7f-124e-f9468dc05a54@linux.ibm.com>
Date:   Fri, 22 Jan 2021 14:33:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611322060-1972-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_09:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 2:27 PM, Pierre Morel wrote:
> When communicating with the host we need to share part of
> the memory.
> 
> Let's implement the ultravisor calls for this.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Suggested-by: Janosch Frank <frankja@linux.ibm.com>
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/asm/uv.h | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 39d2dc0..9c49184 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -79,4 +79,43 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>  	return cc;
>  }
>  
> +static inline int share(unsigned long addr, u16 cmd)
> +{
> +	struct uv_cb_share uvcb = {
> +		.header.cmd = cmd,
> +		.header.len = sizeof(uvcb),
> +		.paddr = addr
> +	};
> +	int cc;
> +
> +	cc = uv_call(0, (u64)&uvcb);
> +	if (!cc && uvcb.header.rc == UVC_RC_EXECUTED)
> +		return 0;
> +
> +	report_info("uv_call: cmd %04x cc %d response code: %04x", cc, cmd,
> +		    uvcb.header.rc);
> +	return -1;
> +}
> +
> +/*
> + * Guest 2 request to the Ultravisor to make a page shared with the
> + * hypervisor for IO.
> + *
> + * @addr: Real or absolute address of the page to be shared
> + */
> +static inline int uv_set_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
> +}
> +
> +/*
> + * Guest 2 request to the Ultravisor to make a page unshared.
> + *
> + * @addr: Real or absolute address of the page to be unshared
> + */
> +static inline int uv_remove_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
> +}
> +
>  #endif
> 

