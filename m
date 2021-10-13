Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349E842C123
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 15:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhJMNSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 09:18:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229535AbhJMNSJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 09:18:09 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DCXuIf024131;
        Wed, 13 Oct 2021 09:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GcTzPEjVthaOBkN0QWAtOMQZHkKyYA4Y7FpIYjFqGFU=;
 b=jOwElk5XGlVtsDwhfFKHnaWlc+y+E8+qpevz1Wh5QxLbboSG7qO62VXVwuxAvxPrRwvb
 070dZ/6iYDTQkWtkXUQSBedP1AmvOEYxM39DWxpIaxn7BYJYG5b3nBJpdnSFzmpopEBf
 WCTrEOekufDT49C0jF+gVFAD1oiFLq7+Z1/1o9PhSDgCXQHEJBghIc/ju5gYsW307UIp
 VwkAc/CEwTfYbupsoqyUXzWjhOPelScYAMoqDep8kG1WxPVf6IO5CdJkDXb8vmrC4lT6
 RE1s9UjrnWGQUSxIN83WPeESK3/FanOMRNr3zuTZ4c6oIe89Aj2McMCnt8bAvNnrETCt Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnqmpbada-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 09:16:06 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19DCwjEx012016;
        Wed, 13 Oct 2021 09:16:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnqmpbacj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 09:16:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DDDR6A020712;
        Wed, 13 Oct 2021 13:16:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2q9u3a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 13:16:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DDADVc55443910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 13:10:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65FFFA4080;
        Wed, 13 Oct 2021 13:15:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 847D7A4072;
        Wed, 13 Oct 2021 13:15:44 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.37.114])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 13:15:43 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] lib: s390x: snippet.h: Add a few
 constants that will make our life easier
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
References: <20211013102722.17160-1-frankja@linux.ibm.com>
 <20211013102722.17160-3-frankja@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <9a59c435-f717-784f-48c0-13ff9c3f0251@linux.vnet.ibm.com>
Date:   Wed, 13 Oct 2021 15:15:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013102722.17160-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 64S-Y0YAg9Gxy5Cdg0T4tn7Ggf7_GObk
X-Proofpoint-ORIG-GUID: BGcHWSIBD7ATqZ04AtZufOzGbMW9UEBs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_05,2021-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110130088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/13/21 12:27 PM, Janosch Frank wrote:
> The variable names for the snippet objects are of gigantic length so
> let's define a few macros to make them easier to read.
> 
> Also add a standard PSW which should be used to start the snippet.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/snippet.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  s390x/mvpg-sie.c    | 13 ++++++-------
>  2 files changed, 46 insertions(+), 7 deletions(-)
>  create mode 100644 lib/s390x/snippet.h
> 
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> new file mode 100644
> index 00000000..9ead4fe3
> --- /dev/null
> +++ b/lib/s390x/snippet.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet definitions
> + *
> + * Copyright IBM, Corp. 2021
                   ^
That comma should not be there.
> + * Author: Janosch Frank <frankja@linux.ibm.com>
> + */
> +
[...]

