Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7484E2B65
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 16:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349753AbiCUPDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 11:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiCUPCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 11:02:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC16F48E6F;
        Mon, 21 Mar 2022 08:01:22 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LDPq4n030972;
        Mon, 21 Mar 2022 15:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eWGFjfM04lUHhpEjyIx0WC1TO8A1LYQm5YMjm3YKlKg=;
 b=Zm0rPRzQn9HLdxXz57xSukn8TXdkOh0J2lhjkrH4+B9p2X5EAYOpK0GN9juc8ITV8Cdv
 sKD+E8sAFlSPxeuyuYOilEhZqHH7q5w4laAvVV3HTqPJHll3zXUxiYau/p8EAGjCLbMY
 nLH9vCr3ja0/dFfb3CH47EfMScrDrOW5kuYHuJKX3hY6z1d+2vml0OSn2+9XkYpqzIn0
 LoOgoDw3MFbnOlA0hSG9f1q1IXP8q2+jVwrtHWKDK9fz48FOMnVkdVBREuWab+1FcokR
 VyOtL161TkE7yk/2bbOAcpf8+LqeELpj7eQSc0UT7P+NSH9xGififEiH828Yd0QPv0rr Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exr0dw6gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 15:01:22 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LE1RwK012687;
        Mon, 21 Mar 2022 15:01:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exr0dw6fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 15:01:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LErHrh009086;
        Mon, 21 Mar 2022 15:01:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ew6t93m9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 15:01:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LEnbud44564788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 14:49:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62662AE045;
        Mon, 21 Mar 2022 15:01:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9B91AE051;
        Mon, 21 Mar 2022 15:01:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.232])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 15:01:15 +0000 (GMT)
Date:   Mon, 21 Mar 2022 16:01:13 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 0/9] s390x: Further extend instruction
 interception tests
Message-ID: <20220321160113.142a7f02@p-imbrenda>
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NNz5xOd83qxuMG2dyGCHNSOmHdS80p_-
X-Proofpoint-ORIG-GUID: ii9px1RspyuymPUs0BpjnLrwx_W7Aja0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_06,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 spamscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=904 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203210093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Mar 2022 11:18:55 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Further extend the instruction interception tests for s390x. This series focuses
> on SIGP, STSI and TPROT instructions.
> 
> Some instructions such as STSI already had some coverage and the existing tests
> were extended to increase coverage.
> 
> The SIGP instruction has coverage, but not for all orders. Orders
> STORE_ADTL_STATUS, SET_PREFIX and CONDITIONAL_EMERGENCY didn't
> have coverage before and new tests are added. For EMERGENCY_SIGNAL, the existing
> test is extended to cover an invalid CPU address. Additionally, new tests are
> added for quite a few invalid arguments to SIGP.
> 
> TPROT was used in skrf tests, but only for storage keys, so add tests for the
> other uses as well.

I like how this series turned out.

once the fourth patch is ironed out, I think this would be ready for
queuing

> 
> Nico Boehr (9):
>   s390x: smp: add tests for several invalid SIGP orders
>   s390x: smp: stop already stopped CPU
>   s390x: gs: move to new header file
>   s390x: smp: add test for SIGP_STORE_ADTL_STATUS order
>   s390x: smp: add tests for SET_PREFIX
>   s390x: smp: add test for EMERGENCY_SIGNAL with invalid CPU address
>   s390x: smp: add tests for CONDITIONAL EMERGENCY
>   s390x: add TPROT tests
>   s390x: stsi: check zero and ignored bits in r0 and r1
> 
>  lib/s390x/gs.h      |  80 ++++++++
>  s390x/Makefile      |   1 +
>  s390x/gs.c          |  65 +------
>  s390x/smp.c         | 437 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/stsi.c        |  42 ++++-
>  s390x/tprot.c       | 108 +++++++++++
>  s390x/unittests.cfg |   9 +
>  7 files changed, 668 insertions(+), 74 deletions(-)
>  create mode 100644 lib/s390x/gs.h
>  create mode 100644 s390x/tprot.c
> 

