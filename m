Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C4350B6C0
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 14:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447245AbiDVMHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 08:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447268AbiDVMHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 08:07:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2516856741;
        Fri, 22 Apr 2022 05:03:03 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M9c8i9004872;
        Fri, 22 Apr 2022 12:03:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JWJ+ZPkJO3WhXInMIWV1iLxq2i9MU1/flMmX4do8+lA=;
 b=pHBzxt66H9LneeO3tfSkXZL7zj0lm+E+e2noKqE7NcT+f3XrioYoEBywoADFLEBNKgAX
 9sVKUsdvfbqrKXQnqAGLbyj9vAAExIdUqNEfoS0ENdh9BJgZEzB921M0Jx0LmTf7CmmP
 rRM8exjZrxMCJooK/+Efv1h9bE5k/Lalgz1GbaITUTHatjCoMllsHru/3XLqtKiOTJSY
 OnXNu8kfKRltUPCh1BnmSLbcZFhBcWLahSApDA3c0+DDIHVz+KcjAl7/YhdpLrVegj1/
 PiJwyxfKV/+H+1V0+cpU5jo1fyFEzqu9iPzCDE29Ix8nsoR0sR9zw+N6+dI+7sW07+m+ kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer9enbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:02:59 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23MBdhEF027669;
        Fri, 22 Apr 2022 12:02:55 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer9en32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:02:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23MBqVAL019154;
        Fri, 22 Apr 2022 12:02:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3ffn2j1bah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 12:02:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23MC2FRw40370618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 12:02:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DAD1A4055;
        Fri, 22 Apr 2022 12:02:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21682A404D;
        Fri, 22 Apr 2022 12:02:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 12:02:15 +0000 (GMT)
Date:   Fri, 22 Apr 2022 14:02:13 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 0/4] s390x: add migration test support
Message-ID: <20220422140213.1b70e4cb@p-imbrenda>
In-Reply-To: <20220422105453.2153299-1-nrb@linux.ibm.com>
References: <20220422105453.2153299-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IMg1hVmTjWauuHbNq4fah1V4ZwoszyNk
X-Proofpoint-ORIG-GUID: NayaAUio_nx_YDhL-IzBSaqvc298XO7t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_03,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Apr 2022 12:54:49 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Changelog from v3:
> ---
> - Rename read_buf_end to read_buf_length (Thanks Janosch)
> 
> This series depends on my SIGP store additional status series to have access to
> the guarded-storage and vector related defines
> ("[kvm-unit-tests PATCH v3 0/2] s390x: Add tests for SIGP store adtl status").
> 
> Add migration test support for s390x.

thanks, queued

> 
> arm and powerpc already support basic migration tests.
> 
> If a test is in the migration group, it can print "migrate" on its console. This
> will cause it to be migrated to a new QEMU instance. When migration is finished,
> the test will be able to read a newline from its standard input.
> 
> We need the following pieces for this to work under s390x:
> 
> * read support for the sclp console. This can be very basic, it doesn't even
>   have to read anything useful, we just need to know something happened on
>   the console.
> * s390/run adjustments to call the migration helper script.
> 
> This series adds basic migration tests for s390x, which I plan to extend
> further.
> 
> Nico Boehr (4):
>   lib: s390x: add support for SCLP console read
>   s390x: add support for migration tests
>   s390x: don't run migration tests under PV
>   s390x: add basic migration test
> 
>  lib/s390x/sclp-console.c |  79 ++++++++++++++++--
>  lib/s390x/sclp.h         |   8 ++
>  s390x/Makefile           |   2 +
>  s390x/migration.c        | 172 +++++++++++++++++++++++++++++++++++++++
>  s390x/run                |   7 +-
>  s390x/unittests.cfg      |   5 ++
>  scripts/s390x/func.bash  |   2 +-
>  7 files changed, 267 insertions(+), 8 deletions(-)
>  create mode 100644 s390x/migration.c
> 

