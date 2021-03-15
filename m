Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEDC33B05C
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 11:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCOKuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 06:50:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48120 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230039AbhCOKuM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 06:50:12 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12FAXqAY104764
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:50:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=G507uCpQp+UPzbJqt6sM/j6kSeYNZ9KuW3PExZT+3do=;
 b=N5t3kjLZUVEf6koiPqW4xlZwqAL7BcAa/7IP1TaL4poaOox8oQ7yjNwBm2/cgSdlsyjp
 2+jXI2MyZLHvDVrfh/n5bBfWKcY0QdafM60I/5SVOXu2X1zTNUPZAm4Oq2Zjc27gy+nG
 bujUOtV6GZQXEO1TbwPxaoYb2XXtDN7EPO14OksUVmuyn2dfr3QbjBsMbOazHtfAARpN
 ppQ7sc8+jWK6xFluvx8b1PnYbmzf8w1Dx6f9+iY73XKBOl7e5CeWMOgjU2pn1CzpNqU6
 ICegSqILaC4+ZObShx8Yi5HVMyb98s498YOVYsnxcAosMBtpMb5dUpRsbjThgh7RMVl4 ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 379yj1sx90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:50:11 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12FAbdjD118436
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 06:50:11 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 379yj1sx7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 06:50:10 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12FAmgqR017137;
        Mon, 15 Mar 2021 10:50:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 378mnh8wt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Mar 2021 10:50:09 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12FAo6JR38076812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Mar 2021 10:50:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3ED67A405E;
        Mon, 15 Mar 2021 10:50:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3984A4051;
        Mon, 15 Mar 2021 10:50:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.14.133])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Mar 2021 10:50:05 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 3/6] s390x: css: extending the
 subchannel modifying functions
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
 <1615545714-13747-4-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <e24ced70-5008-e432-95f5-c5862beb9741@linux.ibm.com>
Date:   Mon, 15 Mar 2021 11:50:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1615545714-13747-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_03:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103150072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/12/21 11:41 AM, Pierre Morel wrote:
> To enable or disable measurement we will need specific
> modifications on the subchannel.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/css.h     |   9 +++-
>  lib/s390x/css_lib.c | 100 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 108 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index b9e4c08..7dddb42 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -82,6 +82,8 @@ struct pmcw {
>  	uint32_t intparm;
>  #define PMCW_DNV	0x0001
>  #define PMCW_ENABLE	0x0080
> +#define PMCW_MBUE	0x0010
> +#define PMCW_DCTME	0x0008
>  #define PMCW_ISC_MASK	0x3800
>  #define PMCW_ISC_SHIFT	11
>  	uint16_t flags;
> @@ -94,6 +96,7 @@ struct pmcw {
>  	uint8_t  pom;
>  	uint8_t  pam;
>  	uint8_t  chpid[8];
> +#define PMCW_MBF1	0x0004
>  	uint32_t flags2;
>  };
>  #define PMCW_CHANNEL_TYPE(pmcw) (pmcw->flags2 >> 21)
> @@ -101,7 +104,8 @@ struct pmcw {
>  struct schib {
>  	struct pmcw pmcw;
>  	struct scsw scsw;
> -	uint8_t  md[12];
> +	uint64_t mbo;
> +	uint8_t  md[4];
>  } __attribute__ ((aligned(4)));
>  
>  struct irb {
> @@ -355,4 +359,7 @@ bool chsc(void *p, uint16_t code, uint16_t len);
>  #define css_test_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
>  #define css_test_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
>  
> +bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
> +bool css_disable_mb(int schid);
> +
>  #endif
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index a97d61e..8f09383 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -248,6 +248,106 @@ retry:
>  	return -1;
>  }
>  
> +/*
> + * schib_update_mb: update the subchannel Measurement Block
> + * @schid: Subchannel Identifier
> + * @mb   : 64bit address of the measurement block
> + * @mbi : the measurement block offset
> + * @flags : PMCW_MBUE to enable measurement block update
> + *	    PMCW_DCTME to enable device connect time
> + *	    0 to disable measurement
> + * @format1: set if format 1 is to be used
> + */
> +static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
> +			    uint16_t flags, bool format1)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +
> +	/* Read the SCHIB for this subchannel */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: sch %08x failed with cc=%d", schid, cc);
> +		return false;
> +	}
> +
> +	/* Update the SCHIB to enable the measurement block */
> +	if (flags) {
> +		pmcw->flags |= flags;
> +
> +		if (format1)
> +			pmcw->flags2 |= PMCW_MBF1;
> +		else
> +			pmcw->flags2 &= ~PMCW_MBF1;
> +
> +		pmcw->mbi = mbi;
> +		schib.mbo = mb & ~0x3f;
> +	} else {
> +		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
> +	}
> +
> +	/* Tell the CSS we want to modify the subchannel */
> +	cc = msch(schid, &schib);
> +	if (cc) {
> +		/*
> +		 * If the subchannel is status pending or
> +		 * if a function is in progress,
> +		 * we consider both cases as errors.
> +		 */
> +		report_info("msch: sch %08x failed with cc=%d", schid, cc);
> +		return false;
> +	}
> +
> +	/*
> +	 * Read the SCHIB again
> +	 */
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with cc=%d",
> +			    schid, cc);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * css_enable_mb: enable the subchannel Measurement Block
> + * @schid: Subchannel Identifier
> + * @mb   : 64bit address of the measurement block
> + * @format1: set if format 1 is to be used
> + * @mbi : the measurement block offset
> + * @flags : PMCW_MBUE to enable measurement block update
> + *	    PMCW_DCTME to enable device connect time
> + */
> +bool css_enable_mb(int schid, uint64_t mb, uint16_t mbi, uint16_t flags,
> +		   bool format1)
> +{
> +	int retry_count = MAX_ENABLE_RETRIES;
> +	struct pmcw *pmcw = &schib.pmcw;
> +
> +	while (retry_count-- &&
> +	       !schib_update_mb(schid, mb, mbi, flags, format1))
> +		mdelay(10); /* the hardware was not ready, give it some time */
> +
> +	return schib.mbo == mb && pmcw->mbi == mbi;
> +}
> +
> +/*
> + * css_disable_mb: disable the subchannel Measurement Block
> + * @schid: Subchannel Identifier
> + */
> +bool css_disable_mb(int schid)
> +{
> +	int retry_count = MAX_ENABLE_RETRIES;
> +
> +	while (retry_count-- &&
> +	       !schib_update_mb(schid, 0, 0, 0, 0))
> +		mdelay(10); /* the hardware was not ready, give it some time */
> +
> +	return retry_count > 0;
> +}
> +
>  static struct irb irb;
>  
>  void css_irq_io(void)
> 

