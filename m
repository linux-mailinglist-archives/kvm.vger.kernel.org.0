Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712E451DDF1
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357151AbiEFQ4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 12:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351249AbiEFQ4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 12:56:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337C166AE6;
        Fri,  6 May 2022 09:52:39 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246FinHc021543;
        Fri, 6 May 2022 16:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=rGZKeNCWZ1jgBVfDJ/7VZ42b/PwgcbX24NOemlPpQn0=;
 b=MI2ts6S3u4wDzwVD7kgu/ZJBwneLN3t0UkOo+2qHKg815HnABBXFSstBIQmApB14OuZ2
 QkHrqVox+AGo+d3nbFqBcDCKkcbFQrvlLOFyLD12K5/EXExT2kahTWv+gS4CJLuyXcRl
 MwBpadg8Aezrshpz0bdhsn7RVHVQ5NNAGnJnLtTSxciV40fEagb0bZ+uN/quq95Wrxow
 8O6mOQbTC/k7L/tKV5jBLeknToU6Dv031g0oS+SXjeiXRW7z6/B8vxw1zreNAnkdVdL6
 UpfZcmzx0GEe4zf2up7fioxtvXGBTOr5Xy5+WIIP3h0TtNycsasu63jyURneiuGV1HTD vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw6kbh8tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:52:38 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246GjcbO022243;
        Fri, 6 May 2022 16:52:37 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw6kbh8t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:52:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246Goo8K011664;
        Fri, 6 May 2022 16:52:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3fvg611jr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:52:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246Gd79h53150030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 16:39:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A33B1A405B;
        Fri,  6 May 2022 16:52:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34A5BA4054;
        Fri,  6 May 2022 16:52:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 16:52:32 +0000 (GMT)
Date:   Fri, 6 May 2022 17:31:21 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/3] s390x: Fix sclp facility bit numbers
Message-ID: <20220506173121.667ef671@p-imbrenda>
In-Reply-To: <20220505124656.1954092-2-scgl@linux.ibm.com>
References: <20220505124656.1954092-1-scgl@linux.ibm.com>
        <20220505124656.1954092-2-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aK-GtrXTsJl9CsLYuf1rd8H1-3mgsN6K
X-Proofpoint-ORIG-GUID: dwpv7E4t8_jYu4_eIIiq059qMvcGoJXv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_06,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 May 2022 14:46:54 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> sclp_feat_check takes care of adjusting the bit numbering such that they
> can be defined as they are in the documentation.

this means we had it wrong all along and we somehow never noticed

ooops!

anyway:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> 
> Fixes: 4dd649c8 ("lib: s390x: sclp: Extend feature probing")
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/sclp.h | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index fead007a..4ce2209f 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -134,13 +134,15 @@ struct sclp_facilities {
>  };
>  
>  /* bit number within a certain byte */
> -#define SCLP_FEAT_85_BIT_GSLS		7
> -#define SCLP_FEAT_98_BIT_KSS		0
> -#define SCLP_FEAT_116_BIT_64BSCAO	7
> -#define SCLP_FEAT_116_BIT_CMMA		6
> -#define SCLP_FEAT_116_BIT_ESCA		3
> -#define SCLP_FEAT_117_BIT_PFMFI		6
> -#define SCLP_FEAT_117_BIT_IBS		5
> +#define SCLP_FEAT_80_BIT_SOP		2
> +#define SCLP_FEAT_85_BIT_GSLS		0
> +#define SCLP_FEAT_85_BIT_ESOP		6
> +#define SCLP_FEAT_98_BIT_KSS		7
> +#define SCLP_FEAT_116_BIT_64BSCAO	0
> +#define SCLP_FEAT_116_BIT_CMMA		1
> +#define SCLP_FEAT_116_BIT_ESCA		4
> +#define SCLP_FEAT_117_BIT_PFMFI		1
> +#define SCLP_FEAT_117_BIT_IBS		2
>  
>  typedef struct ReadInfo {
>  	SCCBHeader h;

