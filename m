Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A04244D4FD
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 11:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhKKKbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 05:31:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230256AbhKKKbE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 05:31:04 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AB9gtrw023313
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:28:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6SzCUU6/N8Jem2kJwNuzEC0cL0I0SCkUqD0sL5fpth8=;
 b=p5Z/grAgIBD8Mxu8pSX8dLVwGrPNLFxEqlb2UgnxrGGD2WSPR7M1fan8vmLuRo3wfve2
 Luw0S02bkDEI2lndRE9mmKRF32sjuXQ/aiu+zfTtpSzkVQ4eRpf/kT3xOSOfNvzvSxjT
 rbtPYuMwTpBFT+SniCOe4bgMonaL/Q15m28U+hBP6wYPIxFHQ4sCt23kTuoppQrlVyKS
 Ut5ucBFYRs3UYzt7Xxb0z2O64zZzGJ5Yp7QZsLBPHSFFhoH1RgpvnFiTsKJ0jZsZ4BaT
 q5tZS9tfyRG7LyVH4X0LmbVRn3Gh8OZNRqYVp5OTivqTdkkAzG/AfE8rZuAyBV55m2tf zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c90sp9a9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:28:15 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AB9tsgn008601
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 10:28:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c90sp9a99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 10:28:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABAItWn010350;
        Thu, 11 Nov 2021 10:28:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3c5hbav733-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 10:28:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABALPnC57803184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 10:21:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2734B4C05A;
        Thu, 11 Nov 2021 10:28:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B94F84C04A;
        Thu, 11 Nov 2021 10:28:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.147])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 10:28:08 +0000 (GMT)
Date:   Thu, 11 Nov 2021 11:28:06 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] s390x: fixing I/O memory allocation
Message-ID: <20211111112806.50e4d22a@p-imbrenda>
In-Reply-To: <31f51c84-c7f9-8251-39a8-3ff38496ae5e@redhat.com>
References: <20211111100153.86088-1-pmorel@linux.ibm.com>
        <31f51c84-c7f9-8251-39a8-3ff38496ae5e@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uBZ34QwttqG5w1ZuQoQZVUIFpW-JjNuJ
X-Proofpoint-ORIG-GUID: l4XpGsUUrw6TuKsEgzYPHbUIOt-2P-91
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_03,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Nov 2021 11:14:53 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 11.11.21 11:01, Pierre Morel wrote:
> > The allocator allocate pages it follows the size must be rounded
> > to pages before the allocation.
> > 
> > Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"
> >   
> 
> What's the symptom of this? A failing test? Or is this just a pro-activ fix?

if size < PAGE_SIZE then we would allocate 0, and in general we are
rounding down instead of up, which is obviously wrong.

