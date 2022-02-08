Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874DD4ADD36
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381321AbiBHPn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbiBHPnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:43:24 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A64C061576;
        Tue,  8 Feb 2022 07:43:23 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218FDG0H022003;
        Tue, 8 Feb 2022 15:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=+7roFM4sxjNqB5+lcDqg04Ldhv5/yQXM6vCOIZ7c6RU=;
 b=PlQYSDFJbhEigpd2YhjewswJ7cuuwrHYwdAMqJugwWRNNnlRvqyPGoocaK59NPP1eKqq
 gJNlWU1MUKB10w3SmFs3+Y5cNF5LOPlXsUD4gMp+yfNV+PsjtenhAj3gvlrX0IBJiqCt
 pIP15SKkHEVplJNhgKikz1yhabUxsULyzcy/Tj2qemagNAKi9YEJTMikeXAXACO/choi
 bWWPii4YdXX7KkJBuEhCHWvG412nhOLGVaVdAw58sDa5hexDVk54Ortp4cJiugIwUkLs
 HaHTQDApdGPR1LUTRRxsKLQ2+dU4BEK6jSmYeA7Rt6c1GiOiwD2EEwCekcZGvFMHhPL5 ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3tyc0xep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:43:23 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218FQZTi023939;
        Tue, 8 Feb 2022 15:43:22 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e3tyc0xdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:43:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218FcZFH012773;
        Tue, 8 Feb 2022 15:43:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv9fb23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:43:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218FhH9X42074382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 15:43:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E9F0AE055;
        Tue,  8 Feb 2022 15:43:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E983FAE05D;
        Tue,  8 Feb 2022 15:43:16 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.36.227])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 15:43:16 +0000 (GMT)
Message-ID: <be515acc30a69e5cbf2f01828685844b7beb0856.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/4] s390x: stsi: Define vm_is_kvm to
 be used in different tests
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
Date:   Tue, 08 Feb 2022 16:43:16 +0100
In-Reply-To: <62c23e3a-8cc9-2072-6022-cb23dfa08ce7@linux.ibm.com>
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
         <20220208132709.48291-3-pmorel@linux.ibm.com>
         <62c23e3a-8cc9-2072-6022-cb23dfa08ce7@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jZ-hOnyXNeTFFMYouYoWHoWRJENZidTu
X-Proofpoint-ORIG-GUID: 952ep0K_JWaqRoiT3kyrzRYrq9Lwdt6R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=899 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-08 at 16:31 +0100, Janosch Frank wrote:
> > diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
> > new file mode 100644
> > index 00000000..9b40664f
> > --- /dev/null
> > +++ b/lib/s390x/stsi.h
> > @@ -0,0 +1,32 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/*
> > + * Structures used to Store System Information
> > + *
> > + * Copyright IBM Corp. 2022
> > + */
> > +
> > +#ifndef _S390X_STSI_H_
> > +#define _S390X_STSI_H_
> > +
> > +struct sysinfo_3_2_2 {
> 
> Any particular reason why you renamed this?

Stumbled across this as well. I think this makes it consistent with
Linux' arch/s390/include/asm/sysinfo.h.

The PoP, on the other hand, calls it SYSIB, so this at least resolves
the inconsistency between kvm-unit-tests and Linux.
