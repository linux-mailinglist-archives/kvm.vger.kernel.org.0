Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B380A5FB8F4
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 19:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJKRJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 13:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJKRJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 13:09:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF3FA9261
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 10:09:26 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BG7rGq020614
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xf2AJZiOBs2tGjqI+BEsZqHE8buStgYdFjvThunenEw=;
 b=bW90M9AYvcdieMQXYojKIywp+fWnnvvvn6jdFXpAp5currudbVoYMlPxh53aXWRXaXYN
 UbtSCqdOMy3cfXURHRkCuobVk4ZnE96CIrV5SwjKTJ17GH+Q8pAQPrui6WZH+tTcVqsI
 NRImxJahjU/qbsnjt/0cE172QfIDnzTFVUTUV+X37RlAGatEISY8zdvdk8MrjRwlnNHx
 RXVEt1RdauaSqSxWJ3f4ABTiNt/0vqOg1KwEoChdF5LwppUNkCYCAQrFN4mlX/mWtXvo
 BXwqmtxix+wL52T1iaJOgmvapjumXuOZqZIqe+Brc4W6HAUknliIHsqtMHbrMTvJDmkt Rg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5bfwa9dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:09:25 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BH4v9Y006133
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:09:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3k30u94rjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 17:09:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BH9Kco61079830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 17:09:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC75C5204F;
        Tue, 11 Oct 2022 17:09:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 78AB45204E;
        Tue, 11 Oct 2022 17:09:20 +0000 (GMT)
Date:   Tue, 11 Oct 2022 19:09:18 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 0/2] s390x: Add migration test for
 guest TOD clock
Message-ID: <20221011190918.182d3001@p-imbrenda>
In-Reply-To: <20221011170024.972135-1-nrb@linux.ibm.com>
References: <20221011170024.972135-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bH8uuIXkE4vuugxNgyq7jxwJFB57tdwd
X-Proofpoint-ORIG-GUID: bH8uuIXkE4vuugxNgyq7jxwJFB57tdwd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210110098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Oct 2022 19:00:22 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> v2->v3:
> ---
> - check the clock is really set after setting (thanks Claudio)
> - remove unneeded memory clobber (thanks Claudio)
> - add comment to explain what we're testing (thanks Christian)
> 
> v1->v2:
> ---
> - remove unneeded include
> - advance clock by 10 minutes instead of 1 minute (thanks Claudio)
> - express get_clock_us() using stck() (thanks Claudio)
> 
> The guest TOD clock should not go backwards on migration. Add a test to
> verify that.
> 
> To reduce code duplication, move some of the time-related defined
> from the sck test to the library.
> 

thanks, picked

> Nico Boehr (2):
>   lib/s390x: move TOD clock related functions to library
>   s390x: add migration TOD clock test
> 
>  lib/s390x/asm/time.h  | 50 ++++++++++++++++++++++++++++++++++++++-
>  s390x/Makefile        |  1 +
>  s390x/migration-sck.c | 54 +++++++++++++++++++++++++++++++++++++++++++
>  s390x/sck.c           | 32 -------------------------
>  s390x/unittests.cfg   |  4 ++++
>  5 files changed, 108 insertions(+), 33 deletions(-)
>  create mode 100644 s390x/migration-sck.c
> 

