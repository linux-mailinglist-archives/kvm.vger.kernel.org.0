Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2B34C1649
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbiBWPPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241147AbiBWPPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:15:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD262B8B52;
        Wed, 23 Feb 2022 07:14:50 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NEJpHH005576;
        Wed, 23 Feb 2022 15:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Pn5AcjC6ZVxdQykgoeqQzW1l1N5MOUDdOibZNkRteX4=;
 b=GQkc7igA5PL/8QFW4yxAvAEzDa/gWTAGLFR1zxNYHbpZyuvJsGxCldrfysnAvqrgKE83
 vq9OcSd0sINDbt3NtqVI9m2MniGZ9ePp4VqcMEeDAzDY9qywf9T6TkvKvHoRzClbKaTP
 JLZz1MRQlZJ31CkIasokaXgRcymmrWzSE7kfwcepGFyJV47HLaNn4/4joWEhCOnPYCdM
 EOh4YYMRvVL4yLDlPqMEWVHcBAlQ+pshaMzwKOM77Y1L3wIKu9cp3kqmSbPEQ0FcmJrV
 ROyKFoQYiRs4g1efuBG0VRi5mTYwm7WMUGYiHbTxkfQn8U8aPgcMLERLTPQarqwxeKTh Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edmbrcrgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:14:49 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NC87nB017854;
        Wed, 23 Feb 2022 15:14:49 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edmbrcrg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:14:49 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NFCXiE010378;
        Wed, 23 Feb 2022 15:14:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3eaqtjsfgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 15:14:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NFEild54460912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 15:14:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5217442045;
        Wed, 23 Feb 2022 15:14:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 083AA4203F;
        Wed, 23 Feb 2022 15:14:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 15:14:43 +0000 (GMT)
Date:   Wed, 23 Feb 2022 16:14:40 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/8] s390x: Extend instruction
 interception tests
Message-ID: <20220223161440.1eee5eb8@p-imbrenda>
In-Reply-To: <20220223132940.2765217-1-nrb@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VBae9F7m9D1gKJxzME47m1s6XI8ovdga
X-Proofpoint-GUID: K9A3jnaO1D0qMkQKpAC08MU90OxbrApG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_06,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Feb 2022 14:29:32 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> This series extends the instruction interception tests for s390x.

looks good, I'll queue it, thanks

> 
> For most instructions, there is already coverage in existing tests, but they are
> not covering some failure cases, e.g. bad alignment. In this case, the existing
> tests were extended.
> 
> SCK was not under test anywhere yet, hence a new test file was added.
> 
> The EPSW test gets it's own file, too, because it requires a I/O device, more
> details in the respective commit. 
> 
> Changelog from v2:
> ----
> - Don't run the sck test under PV
> - Include commit of the QEMU PMCW fix in the MSCH and STSCH commit messages
> 
> Nico Boehr (8):
>   s390x: Add more tests for MSCH
>   s390x: Add test for PFMF low-address protection
>   s390x: Add sck tests
>   s390x: Add tests for STCRW
>   s390x: Add more tests for SSCH
>   s390x: Add more tests for STSCH
>   s390x: Add tests for TSCH
>   s390x: Add EPSW test
> 
>  lib/s390x/css.h     |  17 +++
>  lib/s390x/css_lib.c |  60 ++++++++++
>  s390x/Makefile      |   2 +
>  s390x/css.c         | 278 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/epsw.c        | 113 ++++++++++++++++++
>  s390x/pfmf.c        |  29 +++++
>  s390x/sck.c         | 134 +++++++++++++++++++++
>  s390x/unittests.cfg |   7 ++
>  8 files changed, 640 insertions(+)
>  create mode 100644 s390x/epsw.c
>  create mode 100644 s390x/sck.c
> 

