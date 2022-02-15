Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEED84B6B8E
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 12:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiBOLzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 06:55:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiBOLzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 06:55:09 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E40A251D
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 03:54:56 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FANPLr002113
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Odd/YjMmo5SvJbqcu8FHs6K6EZ2NGmXuOi2no4ed6Nc=;
 b=I2AzArM2eJbsV+2DHQyRvVpLNadB6/P3ey0J5QGx4kpgTMtJIRsDdHh2oGa/LJMBaVpw
 xWMaAi1QEtnCCuOJbDGkV5ur+diIDfg4SJ/jbG4Y7Tja/4e5LgWI2U3oDxGuOMNDRcXS
 fZaz8w31SeHbprhtnxajZ+xl+8X0hruZ21LKryFOajHGOmRiB5RYnKwRM4TTw8EbL8QD
 wAoq+JMc/lS/EJmRTC8RTv8aYwRAXM12GpfBqLjrt+SHDPy+6ivQ+qoIq3b3r6WZcVJ4
 7xrKEFCFDfzou4XOgDzuV5tUsIaldm98tnYB1PHMPrh4PrkPebO+TZ9S4GLtfscqR1ax Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8acpj5k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:54:56 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FBsEFh029382
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 11:54:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8acpj5jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:54:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FBqSGI013295;
        Tue, 15 Feb 2022 11:54:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645jpssc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:54:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FBslxi43909426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:54:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5A61AE045;
        Tue, 15 Feb 2022 11:54:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58D8DAE053;
        Tue, 15 Feb 2022 11:54:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 11:54:47 +0000 (GMT)
Date:   Tue, 15 Feb 2022 12:54:45 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/6] lib: s390x: smp: refactor smp
 functions to accept indexes
Message-ID: <20220215125445.25003724@p-imbrenda>
In-Reply-To: <eab9527a-a64d-dade-116c-ab725c4667d8@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
        <20220204130855.39520-3-imbrenda@linux.ibm.com>
        <698c33f2-7549-3420-ce97-d15c86b4dc02@linux.ibm.com>
        <20220215122342.62efd8b8@p-imbrenda>
        <eab9527a-a64d-dade-116c-ab725c4667d8@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o4-UrxGUlywtTjED1I9Hc2oSMAvkiElG
X-Proofpoint-GUID: tO0jz4Cy8m9JssO096FHr66mV6QcJi7k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Feb 2022 12:43:15 +0100
Steffen Eiden <seiden@linux.ibm.com> wrote:

> On 2/15/22 12:23, Claudio Imbrenda wrote:
> > On Tue, 15 Feb 2022 12:09:53 +0100
> > Steffen Eiden <seiden@linux.ibm.com> wrote:
> > 
> > [...]
> >   
> >> What about using the smp wrapper 'smp_sigp(idx, SIGP_RESTART, 0, NULL)'
> >> here as well?  
> > 
> > [...]
> >   
> >> With my nits fixed:  
> > 
> > maybe I should add a comment explaining why I did not use the smp_
> > variants.
> > 
> > the reason is that the smp_ variants check the validity of the CPU
> > index. but in those places, we have already checked (directly or
> > indirectly) that the index is valid, so I save one useless check.  
> > > on the other hand, I don't know if it makes sense to optimize for that,  
> > since it's not a hot path, and one extra check will not kill the
> > performance.
> >  
> I would prefer the use of the smp_ variant. The extra assert won't 
> clutter the output and the code is more consistent.
> However, a short comment is also fine for me if you prefer that.

I guess I'll use the smp_ variant and add a few lines in the patch
description to explain that we're doing some extra checks, but the code
is more readable

> 
> >>
> >> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>  
> >   

