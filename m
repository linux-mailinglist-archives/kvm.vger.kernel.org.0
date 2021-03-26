Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E934A328
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 09:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhCZI1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 04:27:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20462 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229892AbhCZI1C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 04:27:02 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q85EiB006617
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 04:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5CoDUOjfewH6ntEBVouF6JbIYRVgEkYHSGIA2JkcwxU=;
 b=QmA0fTc+xkI85ryBkrV5A3O1+M/28mwqioTeZjXStdFQ05jegsD1tIrpabXl4mZQTRcW
 9RNWfU8LQQkaWgt+Djv2w2t8HgHRGW+z4RYpsgiQmD5iU68kow8aEKd1c7Hs2vUljRMA
 C/C0JIFOqbVJLQP1Y3DZIuXNViB9NIePRpRK29cArsdcy8RPCR2IoSBTIPJqphRXgPBy
 B02+QZyR1A7X45UyH7D1fuf0+Yr+CBLqCc/Sqd0sLYvkJI7alYehC6cZTq1VfWg+Pk1g
 5xitYbw9ZLLsEJIlRqxe9zU13NXlE1mlfr4b9q9p9jx+JDPwX/k5VNy+e41bQMVuncvX /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37h74veknb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 04:27:01 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12Q86nWM012810
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 04:27:01 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37h74vekmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 04:27:01 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12Q8HV7W014096;
        Fri, 26 Mar 2021 08:26:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 37h14y07x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 08:26:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12Q8QuiO52363602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 08:26:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CD864C046;
        Fri, 26 Mar 2021 08:26:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BBA44C044;
        Fri, 26 Mar 2021 08:26:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.164.239])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 08:26:56 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: lib: css: disabling a
 subchannel
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <fbd7c533-bc72-42c3-83dc-0b48fce08cb5@linux.ibm.com>
Date:   Fri, 26 Mar 2021 09:26:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: trZyZuJBi3SvXLzwWOVbFssDQBMR9YsH
X-Proofpoint-ORIG-GUID: tsxRZA24zNt1E0cULtP3sXLLStQdPx74
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_02:2021-03-25,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/21 10:39 AM, Pierre Morel wrote:
> Some tests require to disable a subchannel.
> Let's implement the css_disable() function.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 67 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 7e3d261..b0de3a3 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -284,6 +284,7 @@ int css_enumerate(void);
>  #define IO_SCH_ISC      3
>  int css_enable(int schid, int isc);
>  bool css_enabled(int schid);
> +int css_disable(int schid);
>  
>  /* Library functions */
>  int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index efc7057..f5c4f37 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -186,6 +186,73 @@ bool css_enabled(int schid)
>  	}
>  	return true;
>  }
> +
> +/*
> + * css_disable: disable the subchannel
> + * @schid: Subchannel Identifier
> + * Return value:
> + *   On success: 0
> + *   On error the CC of the faulty instruction
> + *      or -1 if the retry count is exceeded.
> + */
> +int css_disable(int schid)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int retry_count = 0;
> +	int cc;
> +
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
> +		return cc;
> +	}
> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		report_info("stsch: sch %08x already disabled", schid);
> +		return 0;
> +	}
> +
> +retry:
> +	/* Update the SCHIB to disable the subchannel */
> +	pmcw->flags &= ~PMCW_ENABLE;
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	cc = msch(schid, &schib);
> +	/*
> +	 * If the subchannel is status pending or if a function is in progress,
> +	 * we consider both cases as errors.
> +	 */
> +	if (cc) {
> +		report_info("msch: sch %08x failed with cc=%d", schid, cc);
> +		return cc;
> +	}
> +
> +	/* Read the SCHIB again to verify the enablement */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with cc=%d",
> +			    schid, cc);
> +		return cc;
> +	}
> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		if (retry_count)
> +			report_info("stsch: sch %08x successfully disabled after %d retries",
> +				    schid, retry_count);
> +		return 0;
> +	}
> +
> +	if (retry_count++ < MAX_ENABLE_RETRIES) {
> +		/* the hardware was not ready, give it some time */
> +		mdelay(10);
> +		goto retry;
> +	}
> +
> +	report_info("msch: modifying sch %08x failed after %d retries. pmcw flags: %04x",
> +		    schid, retry_count, pmcw->flags);
> +	return -1;
> +}
>  /*
>   * css_enable: enable the subchannel with the specified ISC
>   * @schid: Subchannel Identifier
> 

