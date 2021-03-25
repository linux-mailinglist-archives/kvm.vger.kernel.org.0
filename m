Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2D6349654
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCYQDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:03:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229953AbhCYQDM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:03:12 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PFYLgk110180
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vPAMDv6p04j7+nVZf3wbnaUKa8axO9u2Fjgy58wQqNo=;
 b=EpfJxfMiCNHIMxlQWizmYfCJB0rK2jQmySNFGQ6+JMRGmJZ/xoJggm/qE9JPDBgv8JV1
 FLi4LilPGRokXs7ciuZXSy4SB0cDLEr9ptYNy5JI8EH9vakb+mKKG47xTC4sdR/Vw6/P
 ptSGT5OIu6+mULTRoGoYb//+uIUzyMc39742OIG2/8DPodDi2BWCRvZ+6e58+7SmXtrN
 oJy/L06xvCkB04htriobQ5eqK7W5nsHfiOMJ8dvK7s4s1sKmBs2oYSjLUGp4DVV7AkXX
 z2on/wHYBHdje50o9IGFEst1uLFZE5t5WNS/dx39kYSBmnhRJ6IbRVuRPkKRvNNPY7V7 YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gvpbad3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:12 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PFZit5124175
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:12 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gvpbad27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:03:12 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PG2OkG018712;
        Thu, 25 Mar 2021 16:03:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 37d9byawcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:03:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PG363E45547796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:03:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83A2B42049;
        Thu, 25 Mar 2021 16:03:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F5704203F;
        Thu, 25 Mar 2021 16:03:06 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:03:06 +0000 (GMT)
Date:   Thu, 25 Mar 2021 15:52:35 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/8] s390x: lib: css: disabling a
 subchannel
Message-ID: <20210325155235.4e0faa40@ibm-vm>
In-Reply-To: <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-2-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 10:39:00 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Some tests require to disable a subchannel.
> Let's implement the css_disable() function.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 67
> +++++++++++++++++++++++++++++++++++++++++++++ 2 files changed, 68
> insertions(+)
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
> +		report_info("stsch: sch %08x failed with cc=%d",
> schid, cc);

KVM unit tests allow up to 120 columns per line, please use them, the
code will be more readable; this applies for all broken lines, not just
in this patch.

> +		return cc;
> +	}
> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		report_info("stsch: sch %08x already disabled",
> schid);
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
> +	 * If the subchannel is status pending or if a function is
> in progress,
> +	 * we consider both cases as errors.
> +	 */
> +	if (cc) {
> +		report_info("msch: sch %08x failed with cc=%d",
> schid, cc);
> +		return cc;
> +	}
> +
> +	/* Read the SCHIB again to verify the enablement */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with
> cc=%d",
> +			    schid, cc);
> +		return cc;
> +	}
> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		if (retry_count)
> +			report_info("stsch: sch %08x successfully
> disabled after %d retries",
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
> +	report_info("msch: modifying sch %08x failed after %d
> retries. pmcw flags: %04x",
> +		    schid, retry_count, pmcw->flags);
> +	return -1;
> +}
>  /*
>   * css_enable: enable the subchannel with the specified ISC
>   * @schid: Subchannel Identifier

