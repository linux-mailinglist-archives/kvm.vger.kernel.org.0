Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0051C51FEF8
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 16:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbiEIOEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 10:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbiEIOEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 10:04:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A08825A79F;
        Mon,  9 May 2022 07:00:23 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249Dcd39009750;
        Mon, 9 May 2022 14:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3aQb3DbCYypFL1Qd2gt7OBFKN9CMK6Ca7xmRcubhGtQ=;
 b=MinCKW3ZvYrHDTEg5RKiOY/SCWbY4dTSfRArB8qm2bK5XFgbu8bMsuhOkj3Aj/WbSgob
 /ZlklPI/gtRiUdOlSOaWpoM58yPK4ufEnJSQDXkFZ3jMmSNSnyY3KNBCfnGVw1KbobQg
 isQgLu26eL/isAco25ZOfrF7fuWQwic6nqyI4Ks7OYdhWTZ8pncMotm0AXrTtl47zHRp
 tbVZHSsCxWDJAOKkVavSybk6Zz9aitBgAP9dBewweTBwQGLAZlib110exWiEskKAwjvA
 mb3yQtTXMJ2w2oe9ikX/H+fCTcaCoCovaVhALt2rrPEnTGeykARGNl/Khm2R9GhG9GuL kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy13s48cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:00:22 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 249Dd62k011444;
        Mon, 9 May 2022 14:00:21 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy13s48c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:00:21 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249Dl2Gr015169;
        Mon, 9 May 2022 14:00:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fwgd8tn5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 14:00:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249E02S527328886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 14:00:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E66C442041;
        Mon,  9 May 2022 14:00:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C97542049;
        Mon,  9 May 2022 14:00:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 May 2022 14:00:16 +0000 (GMT)
Date:   Mon, 9 May 2022 16:00:09 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 0/2] s390x: add migration test for CMM
Message-ID: <20220509160009.3d90cbe4@p-imbrenda>
In-Reply-To: <20220509120805.437660-1-nrb@linux.ibm.com>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _QuDtNhYh8QFHjXRG_KWl6DC8fMRht_s
X-Proofpoint-GUID: QxpMkmbm42-2jgz1Jfyhf6M38hzB-TKP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_03,2022-05-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 May 2022 14:08:03 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Upon migration, we expect the CMM page states to be preserved. Add a test which
> checks for that.
> 
> The new test gets a new file so the existing cmm test can still run when the
> prerequisites for running migration tests aren't given (netcat). Therefore, move

I wonder if we are going to have more of these "split" tests.

is there a way to make sure migration prerequisites are always present?
or rewrite things so that we don't need them?

> some definitions to a common header to be able to re-use them.
> 
> Nico Boehr (2):
>   lib: s390x: add header for CMM related defines
>   s390x: add cmm migration test
> 
>  lib/s390x/asm/cmm.h   | 50 +++++++++++++++++++++++++++
>  s390x/Makefile        |  1 +
>  s390x/cmm-migration.c | 78 +++++++++++++++++++++++++++++++++++++++++++
>  s390x/cmm.c           | 25 ++------------
>  s390x/unittests.cfg   |  4 +++
>  5 files changed, 136 insertions(+), 22 deletions(-)
>  create mode 100644 lib/s390x/asm/cmm.h
>  create mode 100644 s390x/cmm-migration.c
> 

