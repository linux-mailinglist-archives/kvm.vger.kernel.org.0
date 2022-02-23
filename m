Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A34C17AC
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbiBWPt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiBWPt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:49:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E90B82EE;
        Wed, 23 Feb 2022 07:48:59 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NFUTiR003793;
        Wed, 23 Feb 2022 15:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EUdOFyMpVO6P/Q8nhxdGggneRgFJUKPI+fW9v0RsM7s=;
 b=C22piLZqaEJxG3eoKiZnJmwlMEPFI0OCzPA+VDlL7ZjuqvPjBzHUkCI8IgoQmzdiFypQ
 k1tpmTGN+Ut7WYNUZtWB8gswAu4FMjHiBUB7cmMVfFqUzPAEnroidG8MrBMABbpexIAR
 u8zsqaTYntD1qw30YQcfY2N/tUFG7fx911oEg6EeeLqV6WmjO8FDEmBFSnWh0WS4qcck
 kdkvPSLJKAmWNXApkxuiAMmlznsCGfa7CIylLWlWDRgJJb6pYxraVaJ33qFHvcPygSFG
 2of2npxBUGJYgI1mXzKM4XNr+p6CBG+ouZAkLpbis/LsQgGEyPkIlRiNX/An7zK5ijYG YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edkxfx4uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:48:59 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NFmiUN031017;
        Wed, 23 Feb 2022 15:48:59 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edkxfx4tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:48:58 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NFgXBS026078;
        Wed, 23 Feb 2022 15:48:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3ear699nf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:48:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NFcD6u48431474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 15:38:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DD5211C04A;
        Wed, 23 Feb 2022 15:48:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96B8211C054;
        Wed, 23 Feb 2022 15:48:52 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 15:48:52 +0000 (GMT)
Date:   Wed, 23 Feb 2022 16:37:14 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 2/5] s390x: lib: Add QUI getter
Message-ID: <20220223163714.6114ef4f@p-imbrenda>
In-Reply-To: <20220222145456.9956-3-seiden@linux.ibm.com>
References: <20220222145456.9956-1-seiden@linux.ibm.com>
        <20220222145456.9956-3-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gi9LQnyEVYhdO-iclC_qV3cYsctb-KCG
X-Proofpoint-ORIG-GUID: 9YOsOP3Pf5uxpaxPETRtL3K9vr0B5ITC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_06,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Feb 2022 14:54:53 +0000
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
> already has cached the qui result. Let's add a function to avoid
> unnecessary QUI UVCs.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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

