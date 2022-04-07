Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478E64F7BF9
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 11:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242810AbiDGJp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 05:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243879AbiDGJpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 05:45:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A531204AAB;
        Thu,  7 Apr 2022 02:43:22 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2378qit3029534;
        Thu, 7 Apr 2022 09:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6z9ef0XR7hdfRjUB49Rx1IMadYwQeDsK2hOE0CLkIkA=;
 b=D9ZfmzyyWoI+0vEVRmaI7dWegTQPwKBux7wUwAZAVPmu2QTc9zDABb3Y+EJZ8Sb6kaJ6
 x9ILXmtM2eEzdm9VIkvIwUmF6hcxj/oUGbgwgq7GtMsyOrjyNYHqTNVDpWkRN5nY+OA2
 GuLzgx/64+W9Geht740h2f8Rti9b50WZm64FporIZ9SQCt2FgRhQChCaMWxhJKK7T78Y
 bzGjl4L276lkGrbof+SKEuHR30IgKQqKtPv9kwh9LJd6ZvwNYahYUiuCGb9sGOfjIAN0
 RKq8568oS0Fqc8lUwryE/8l7dLAj8y6tXhLIohrvsfp3WGqJ8om4LffWvOM4eptbSqMx HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9vtx0wpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:22 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2379hL2h021372;
        Thu, 7 Apr 2022 09:43:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9vtx0wp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2379RFWO022023;
        Thu, 7 Apr 2022 09:43:19 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3f6e491jau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:19 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2379hGJe44105990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 09:43:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A25A011C05E;
        Thu,  7 Apr 2022 09:43:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 368DD11C052;
        Thu,  7 Apr 2022 09:43:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.20])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 09:43:16 +0000 (GMT)
Date:   Thu, 7 Apr 2022 11:39:36 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/9] lib: s390x: hardware: Add
 host_is_qemu() function
Message-ID: <20220407113936.5103c68d@p-imbrenda>
In-Reply-To: <20220407084421.2811-2-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
        <20220407084421.2811-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: leKyAogAM2a9NS8NbzG97PwfyGt1lNvr
X-Proofpoint-GUID: ZN25wrVlvWQx0QNDHiXA7kkKO1bxkq_S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  7 Apr 2022 08:44:13 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> In the future we'll likely need to check if we're hosted on QEMU so
> let's make this as easy as possible by providing a dedicated function.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/hardware.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
> index 01eeb261..86fe873c 100644
> --- a/lib/s390x/hardware.h
> +++ b/lib/s390x/hardware.h
> @@ -45,6 +45,11 @@ static inline bool host_is_lpar(void)
>  	return detect_host() == HOST_IS_LPAR;
>  }
>  
> +static inline bool host_is_qemu(void)
> +{
> +	return host_is_tcg() || host_is_kvm();
> +}
> +
>  static inline bool machine_is_z15(void)
>  {
>  	uint16_t machine = get_machine_id();

