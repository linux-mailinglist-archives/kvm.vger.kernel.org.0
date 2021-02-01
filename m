Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E1F30A51F
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 11:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhBAKNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 05:13:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13500 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233186AbhBAKME (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 05:12:04 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111A24NG061866;
        Mon, 1 Feb 2021 05:11:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y7pHPch2VKUIkGPQoB5CAwX53AZJq4TYZriHftvBSZQ=;
 b=MREjv/qX2I0b8cbHsumRSa5u2yd6CoTjXcFqbn6ctM5Yk4MP5shliC7ooYFKk5R9USUK
 zrhPw3FtkR8EFBGIog/sEBN9vbgob5GF9reivugpwPt8wtxvu9Yq+YKISHAvVrmOq9Ah
 9pCEVcKMYUELN7cHzDyVEUusrb3j/uboA4UZBiLQXXJ1jt7clzrWCSjhaAi67r62IYLC
 MUwyyXxAEflvoPl7r0HfAJs1Y3s2MQL+aZMIf2bVD+afnNAPRe1CxtoxEuOs6JLRtb85
 4I6QGN8cgNW4DyhhcoqEg+KlsudjHSLgv2nF2LgwU7NOPyP8lEkfkEmHr1RR0amPLz6E aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ef9mrn1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 05:11:22 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111A2MCi062530;
        Mon, 1 Feb 2021 05:11:21 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ef9mrn1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 05:11:21 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111A8UY0020246;
        Mon, 1 Feb 2021 10:11:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 36cxqh9r0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 10:11:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111AB8oo33227194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 10:11:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF8504C046;
        Mon,  1 Feb 2021 10:11:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CFAE4C04E;
        Mon,  1 Feb 2021 10:11:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.68.23])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 10:11:16 +0000 (GMT)
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
 <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/5] s390x: css: simplifications of the
 tests
Message-ID: <4f5ca0b9-378e-431c-33ec-79946bdf21b2@linux.ibm.com>
Date:   Mon, 1 Feb 2021 11:11:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611930869-25745-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_04:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/21 3:34 PM, Pierre Morel wrote:
> In order to ease the writing of tests based on:
> - interrupt
> - enabling a subchannel
> - using multiple I/O on a channel without disabling it
> 
> We do the following simplifications:
> - the I/O interrupt handler is registered on CSS initialization
> - We do not enable again a subchannel in senseid if it is already
>   enabled
> - we add a css_enabled() function to test if a subchannel is enabled
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 37 ++++++++++++++++++++++++----------
>  s390x/css.c         | 49 +++++++++++++++++++++++++--------------------
>  3 files changed, 54 insertions(+), 33 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index bc0530d..f8bfa37 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -278,6 +278,7 @@ int css_enumerate(void);
>  
>  #define IO_SCH_ISC      3
>  int css_enable(int schid, int isc);
> +bool css_enabled(int schid);
>  
>  /* Library functions */
>  int start_ccw1_chain(unsigned int sid, struct ccw1 *ccw);
> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
> index fe05021..f300969 100644
> --- a/lib/s390x/css_lib.c
> +++ b/lib/s390x/css_lib.c
> @@ -118,6 +118,31 @@ out:
>  	return schid;
>  }
>  
> +/*
> + * css_enable: enable the subchannel with the specified ISC

enabled or enable?

I.e. do you test if it is enabled or do you want to enable it.

> + * @schid: Subchannel Identifier
> + * Return value:
> + *   true if the subchannel is enabled
> + *   false otherwise
> + */
> +bool css_enabled(int schid)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +
> +	cc = stsch(schid, &schib);
> +	if (cc) {
> +		report_info("stsch: updating sch %08x failed with cc=%d",
> +			    schid, cc);
> +		return false;
> +	}
> +
> +	if (!(pmcw->flags & PMCW_ENABLE)) {
> +		report_info("stsch: sch %08x not enabled", schid);
> +		return 0;

Please stay with true/false or change the return type to int and use ints.

> +	}
> +	return true;
> +}
>  /*
>   * css_enable: enable the subchannel with the specified ISC
>   * @schid: Subchannel Identifier
> @@ -167,18 +192,8 @@ retry:
>  	/*
>  	 * Read the SCHIB again to verify the enablement
>  	 */
> -	cc = stsch(schid, &schib);
> -	if (cc) {
> -		report_info("stsch: updating sch %08x failed with cc=%d",
> -			    schid, cc);
> -		return cc;
> -	}
> -
> -	if ((pmcw->flags & flags) == flags) {
> -		report_info("stsch: sch %08x successfully modified after %d retries",
> -			    schid, retry_count);
> +	if (css_enabled(schid))
>  		return 0;
> -	}
>  
>  	if (retry_count++ < MAX_ENABLE_RETRIES) {
>  		mdelay(10); /* the hardware was not ready, give it some time */
> diff --git a/s390x/css.c b/s390x/css.c
> index 18dbf01..230f819 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -56,36 +56,27 @@ static void test_enable(void)
>   * - We need the test device as the first recognized
>   *   device by the enumeration.
>   */
> -static void test_sense(void)
> +static bool do_test_sense(void)
>  {
>  	struct ccw1 *ccw;
> +	bool retval = false;
>  	int ret;
>  	int len;
>  
>  	if (!test_device_sid) {
>  		report_skip("No device");
> -		return;
> +		return retval;
>  	}
>  
> -	ret = css_enable(test_device_sid, IO_SCH_ISC);
> -	if (ret) {
> -		report(0, "Could not enable the subchannel: %08x",
> -		       test_device_sid);
> -		return;
> +	if (!css_enabled(test_device_sid)) {
> +		report(0, "enabled subchannel: %08x", test_device_sid);
> +		return retval;
>  	}
>  
> -	ret = register_io_int_func(css_irq_io);
> -	if (ret) {
> -		report(0, "Could not register IRQ handler");
> -		return;
> -	}
> -
> -	lowcore_ptr->io_int_param = 0;
> -
>  	senseid = alloc_io_mem(sizeof(*senseid), 0);
>  	if (!senseid) {
>  		report(0, "Allocation of senseid");
> -		goto error_senseid;
> +		return retval;
>  	}
>  
>  	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
> @@ -129,16 +120,21 @@ static void test_sense(void)
>  	report_info("reserved 0x%02x cu_type 0x%04x cu_model 0x%02x dev_type 0x%04x dev_model 0x%02x",
>  		    senseid->reserved, senseid->cu_type, senseid->cu_model,
>  		    senseid->dev_type, senseid->dev_model);
> +	report_info("cu_type expected 0x%04x got 0x%04x", (uint16_t)cu_type,
> +		    senseid->cu_type);
>  
> -	report(senseid->cu_type == cu_type, "cu_type expected 0x%04x got 0x%04x",
> -	       (uint16_t)cu_type, senseid->cu_type);
> +	retval = senseid->cu_type == cu_type;
>  
>  error:
>  	free_io_mem(ccw, sizeof(*ccw));
>  error_ccw:
>  	free_io_mem(senseid, sizeof(*senseid));
> -error_senseid:
> -	unregister_io_int_func(css_irq_io);
> +	return retval;

Could you return senseid->cu_type == cu_type here?

> +}
> +
> +static void test_sense(void)
> +{
> +	report(do_test_sense(), "Got CU type expected");
>  }
>  
>  static void css_init(void)
> @@ -146,8 +142,17 @@ static void css_init(void)
>  	int ret;
>  
>  	ret = get_chsc_scsc();
> -	if (!ret)
> -		report(1, " ");
> +	if (ret)
> +		return;
> +
> +	ret = register_io_int_func(css_irq_io);
> +	if (ret) {
> +		report(0, "Could not register IRQ handler");
> +		return;
> +	}
> +	lowcore_ptr->io_int_param = 0;
> +
> +	report(1, "CSS initialized");
>  }
>  
>  static struct {
> 

