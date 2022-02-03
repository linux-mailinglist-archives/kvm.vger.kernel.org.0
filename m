Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7E4A8A43
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352470AbiBCRiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:38:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1352937AbiBCRiN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 12:38:13 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213Gck6t016692;
        Thu, 3 Feb 2022 17:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uEu9DXS4QvKCKEuyPVdnyixIy9/9CQ4XL53GaPDhsPs=;
 b=CUQLy/1V751hubsi6rvc0QczQG5ZeYN2ajlWgkZ9VsKGM7LcaAUIgJzgZAJeE2u0yp5a
 scJnbBwgb1syc/bqNllDmuxAykbQrI7tlnVLuAFn3WGVrP/lF4g8+TivQ1OOGeAuLfSe
 E0m9p+XlSL66Lss2qYt/9M85jXY4+VzG9uM52Nl6p4yYakGc0pN7q7Oa80nHO/qs8ezB
 4EKn0PVCS+57fUUstCc14iTZlwrCV9etEHHWGuQEVoVC0gFP2FKam+5qBaIUFaYnLSX6
 yVi+0C5nqGRrXv1NNOO21HnrpbpYd+bqKaCQFZ7aSUDLXFQpFmWkAK9p7UK/7LfR+EOl rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dywrrtk7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:12 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213HXcu9028136;
        Thu, 3 Feb 2022 17:38:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dywrrtk6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213HX21G020380;
        Thu, 3 Feb 2022 17:38:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3dvvuk0mh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213Hc7X843974968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 17:38:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F00A8A405E;
        Thu,  3 Feb 2022 17:38:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BB72A405D;
        Thu,  3 Feb 2022 17:38:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.135])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 17:38:06 +0000 (GMT)
Date:   Thu, 3 Feb 2022 17:12:55 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: lib: Add QUI getter
Message-ID: <20220203171255.5fce1244@p-imbrenda>
In-Reply-To: <20220203091935.2716-3-seiden@linux.ibm.com>
References: <20220203091935.2716-1-seiden@linux.ibm.com>
        <20220203091935.2716-3-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WmTRFpO5YufwV8mIw1BfwVpeehyVh407
X-Proofpoint-GUID: vfi_VpNyeI6XA61K_rHt-V6vwySqLi3s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_06,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1011 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Feb 2022 09:19:33 +0000
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
> already has cached the qui result. Let's add a function to avoid
> unnecessary QUI UVCs.

I'm not against this approach, but I wonder if it's not easier to just
make the QUI buffer public?

> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  lib/s390x/uv.c | 8 ++++++++
>  lib/s390x/uv.h | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index 6fe11dff..602cbbfc 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -47,6 +47,14 @@ bool uv_query_test_call(unsigned int nr)
>  	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
>  }
>  
> +const struct uv_cb_qui *uv_get_query_data(void)
> +{
> +	/* Query needs to be called first */
> +	assert(uvcb_qui.header.rc);
> +
> +	return &uvcb_qui;
> +}
> +
>  int uv_setup(void)
>  {
>  	if (!test_facility(158))
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> index 8175d9c6..44264861 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -8,6 +8,7 @@
>  bool uv_os_is_guest(void);
>  bool uv_os_is_host(void);
>  bool uv_query_test_call(unsigned int nr);
> +const struct uv_cb_qui *uv_get_query_data(void);
>  void uv_init(void);
>  int uv_setup(void);
>  void uv_create_guest(struct vm *vm);

