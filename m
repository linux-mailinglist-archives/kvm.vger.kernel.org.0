Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9992552B1CE
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 07:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiERFR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 01:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiERFRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 01:17:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91C510E7;
        Tue, 17 May 2022 22:17:52 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24I4j0W2018298;
        Wed, 18 May 2022 05:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=E+TOzA6JE76The1urlRXQVo7xH47jKgVyhKAX9yD9yc=;
 b=bVvO/upv1VQsM4EVJvE9+GWKm+edwJrXZnQ0nZ2xZ7pkfVNo+ev19YP5IAlSmmR0Yc3k
 Vfv6kvzvWekzAWDTsRHbUS0qPm5cm7/LTiU/vY+O3Zmy3N7t0tA6RGDW2la/4chgMaa9
 8yWcCKjiBCX5mnu6j7KXRKpZgkBqpAHYydGvitmXQ3/spwPY5jzJtXHSTbNo43YEL7Oc
 s5IjyTBMovgvO9r62Ra3B4DiVMal8RkhZ81dRiPaICTcI9VImES15a6OtTzj4Yc1NRBP
 RYguqVjvpNL9fOgH9iKnhTUC2v/knvLdT50ANoixrKEZWc8AlYdafCMC1BgpBxtxAT6D uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4t200es4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 05:17:51 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24I5Hpdg035836;
        Wed, 18 May 2022 05:17:51 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4t200erp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 05:17:51 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24I58L2V014699;
        Wed, 18 May 2022 05:17:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429d56u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 05:17:49 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24I53sF952298236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 05:03:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F2FF4C044;
        Wed, 18 May 2022 05:17:46 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9F1B4C046;
        Wed, 18 May 2022 05:17:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.7.154])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 May 2022 05:17:45 +0000 (GMT)
Date:   Wed, 18 May 2022 07:17:43 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Ignore gcc 12 warnings for low
 addresses
Message-ID: <20220518071743.0e279d74@p-imbrenda>
In-Reply-To: <15aee36c-de22-5f2a-d32b-b74cddebfc1c@redhat.com>
References: <20220516144332.3785876-1-scgl@linux.ibm.com>
        <20220517140206.6a58760f@p-imbrenda>
        <15aee36c-de22-5f2a-d32b-b74cddebfc1c@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qU_a09KGAnZzzP-tLDfEXfPdmQrIJGKc
X-Proofpoint-ORIG-GUID: mltoKNmN-e1cxV1xDu6qXnGLsii2LtRS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_01,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 18:09:54 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 17/05/2022 14.02, Claudio Imbrenda wrote:
> > On Mon, 16 May 2022 16:43:32 +0200
> > Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> >   
> >> gcc 12 warns if a memory operand to inline asm points to memory in the
> >> first 4k bytes. However, in our case, these operands are fine, either
> >> because we actually want to use that memory, or expect and handle the
> >> resulting exception.
> >> Therefore, silence the warning.  
> > 
> > I really dislike this  
> 
> I agree the pragmas are ugly. But maybe we should mimic what the kernel
> is doing here?
> 
> $ git show 8b202ee218395
> commit 8b202ee218395319aec1ef44f72043e1fbaccdd6
> Author: Sven Schnelle <svens@linux.ibm.com>
> Date:   Mon Apr 25 14:17:42 2022 +0200
> 
>      s390: disable -Warray-bounds
>      
>      gcc-12 shows a lot of array bound warnings on s390. This is caused
>      by the S390_lowcore macro which uses a hardcoded address of 0.
>      
>      Wrapping that with absolute_pointer() works, but gcc no longer knows
>      that a 12 bit displacement is sufficient to access lowcore. So it
>      emits instructions like 'lghi %r1,0; l %rx,xxx(%r1)' instead of a
>      single load/store instruction. As s390 stores variables often
>      read/written in lowcore, this is considered problematic. Therefore
>      disable -Warray-bounds on s390 for gcc-12 for the time being, until
>      there is a better solution.
> 
> ... so we should maybe disable it in the Makefile, too, until the
> kernel folks found a nicer solution?

it's a bit extreme, but if it's good enough for the kernel, it's good
enough for us

> 
>   Thomas
> 

