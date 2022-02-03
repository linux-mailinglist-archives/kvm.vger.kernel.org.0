Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7791B4A8A3E
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352924AbiBCRiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:38:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25226 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233512AbiBCRiI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 12:38:08 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213GQ3DO035093;
        Thu, 3 Feb 2022 17:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y5oNwjkQFbQnnaXlTNvg0dvU37gNHwcBVFdQUug4gEI=;
 b=tQ3h50XWg0cylazpIVNqoHyZkuqmRp+M4yELgXXDK9p6NkK1GnsInBFeXsFZezUHpfhd
 dIxmtsiJHEVFcWfVXaENL2vi8d62ySPcLEPdlqc0iWg9UsFA4pYDQwa9JFEHBd4PJ2SV
 Yvvo+UJ7wgxswphNrjYCwl+dXNWxDvJB4vV4e1MCWIA9l/FUt+HE5oN7An27eJT2pOX7
 hXlJ0AkWvCd+zIEH5f9RkxPWLwgJSN4lAw0fCw164SZcxuZ3VCpeMVGYfE2AG5CSY77g
 6+UpTx9VtvfQG4x10RxXYahwyGIjdR413yuZMpAwol6IpaLkCO2twOK7MUOv9sDcdqkO 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0b6ccc1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:08 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213HSTY6024391;
        Thu, 3 Feb 2022 17:38:07 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0b6ccc15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:07 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213HXDf2023052;
        Thu, 3 Feb 2022 17:38:06 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3dyaetrj5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213HS8sG49021338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 17:28:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A364EA4040;
        Thu,  3 Feb 2022 17:38:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35240A4051;
        Thu,  3 Feb 2022 17:38:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.135])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 17:38:02 +0000 (GMT)
Date:   Thu, 3 Feb 2022 17:31:43 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/4] s390x: uv-guest: remove
 duplicated checks
Message-ID: <20220203173143.57c488e5@p-imbrenda>
In-Reply-To: <20220203091935.2716-4-seiden@linux.ibm.com>
References: <20220203091935.2716-1-seiden@linux.ibm.com>
        <20220203091935.2716-4-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _hdaNqYniNu-Lvjbgmo8zUMnXDUk8d2m
X-Proofpoint-GUID: 7eexMZMUaDSfJNh4xIpJWDlhdXzczr3M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_06,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Feb 2022 09:19:34 +0000
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Removing some tests which are done at other points in the code
> implicitly.

I'm not sure I like all of this

> 
> In lib/s390x/uc.c#setup_uv(void) the rc of the qui result is verified
> using asserts.
> The whole test is fenced by lib/s390x/uc.c#os_is_guest(void) that

do you mean "lib/s390x/uv.c#uv_os_is_guest(void)" ?

> checks if SET and REMOVE SHARED is present.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/uv-guest.c | 22 +++++++---------------
>  1 file changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 44ad2154..97ae4687 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -69,23 +69,15 @@ static void test_query(void)
>  	cc = uv_call(0, (u64)&uvcb);
>  	report(cc == 1 && uvcb.header.rc == UVC_RC_INV_LEN, "length");
>  
> -	uvcb.header.len = sizeof(uvcb);
> -	cc = uv_call(0, (u64)&uvcb);
> -	report((!cc && uvcb.header.rc == UVC_RC_EXECUTED) ||
> -	       (cc == 1 && uvcb.header.rc == 0x100),
> -		"successful query");
> -

ok fair enough, an unsuccessful query would have caused an assert in
the setup code, but I don't think it hurts, and I think it would be
nice to have for completeness.

>  	/*
> -	 * These bits have been introduced with the very first
> -	 * Ultravisor version and are expected to always be available
> -	 * because they are basic building blocks.
> +	 * BIT_UVC_CMD_QUI, BIT_UVC_CMD_SET_SHARED_ACCESS and
> +	 * BIT_UVC_CMD_SET_SHARED_ACCESS are always present as they

I think you meant BIT_UVC_CMD_REMOVE_SHARED_ACCESS here ?

> +	 * have been introduced with the first Ultravisor version.
> +	 * However, we only need to check for QUI as
> +	 * SET/REMOVE SHARED are used to fence this test to be only
> +	 * executed by protected guests.

also, what happens if only one of the two bits is set? (which is very
wrong). In that scenario, I would like this test to fail, not skip.
this means that we can't rely on uv_os_is_guest to decide whether to
skip this test.

>  	 */
> -	report(test_bit_inv(BIT_UVC_CMD_QUI, &uvcb.inst_calls_list[0]),
> -	       "query indicated");
> -	report(test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
> -	       "share indicated");
> -	report(test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, &uvcb.inst_calls_list[0]),
> -	       "unshare indicated");
> +	report(uv_query_test_call(BIT_UVC_CMD_QUI), "query indicated");
>  	report_prefix_pop();
>  }
>  

