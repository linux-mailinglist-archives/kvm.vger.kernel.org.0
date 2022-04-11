Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2CA4FBBE8
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 14:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346005AbiDKMV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 08:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344477AbiDKMVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 08:21:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20B1E8A;
        Mon, 11 Apr 2022 05:19:39 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BBfuBv018049;
        Mon, 11 Apr 2022 12:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=yDxlmd7UIOOFeStWH/QrKtJO7Vdyvf2HmyGQ8EID2DM=;
 b=aiJk3l5ZmPTirZ8RocJchAp22D+xG2f4jlH70eDjX3PsUfhXMkDIfwVaOJjxwO7EodhM
 Abta+Q2uQ3dQI4Pe9qv5bfxeVz34TUIebP9iZjPUzVgaVeIRpPHw3IyFlBfM2DwiZeRO
 GWAegX9NTBezp3ZEEK7mqJrmVotdPimVFQ3mvB5v0WTSJoo2qEdcyronomI6IN0+i8Qx
 NN4LC6ADzhvsQ5LJXmS9KTwZ1taEQsgKQeXRKI7qlN+Ju/ROdF+9QwAwvLeeu5bmJ/Jt
 L0zJjjpcsJrCxHUGPU9c3k2FHJ/CTT/ZIWiYMz55yeXaolHTGBKtQHuF7Z9iMigrIPht vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fckp9gscx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:19:38 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BCJVdi013617;
        Mon, 11 Apr 2022 12:19:38 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fckp9gsc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:19:38 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BCDuQp019554;
        Mon, 11 Apr 2022 12:19:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3fb1s8jeq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:19:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BC75dA41419212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 12:07:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F3E0AE045;
        Mon, 11 Apr 2022 12:19:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E6C3AE051;
        Mon, 11 Apr 2022 12:19:31 +0000 (GMT)
Received: from osiris (unknown [9.145.53.187])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Apr 2022 12:19:31 +0000 (GMT)
Date:   Mon, 11 Apr 2022 14:19:30 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 14/21] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
Message-ID: <YlQc0ulxVq+k1Fub@osiris>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-15-mjrosato@linux.ibm.com>
 <9a551f04c3878ecb3a26fed6aff2834fbfe41f18.camel@linux.ibm.com>
 <20220408124824.GZ64706@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408124824.GZ64706@ziepe.ca>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ABeQX7qIg87YUZcNUIAY2g2m6xCZajlP
X-Proofpoint-ORIG-GUID: fWkjUHE0-u7AtZx08cBhYQJTb9xSIviu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 clxscore=1011 mlxlogscore=681 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 09:48:24AM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 05, 2022 at 03:39:19PM +0200, Niklas Schnelle wrote:
> > On Mon, 2022-04-04 at 13:43 -0400, Matthew Rosato wrote:
> > > +	struct zpci_fib fib = {};
> > 
> > Hmm this one uses '{}' as initializer while all current callers of
> > zpci_mod_fc() use '{0}'. As far as I know the empty braces are a GNU
> > extension so should work for the kernel but for consistency I'd go with
> > '{0}' or possibly '{.foo = bar, ...}' where that is more readable.
> > There too uninitialized fields will be set to 0. Unless of course there
> > is a conflicting KVM convention that I don't know about.
> 
> {} is not a GNU extension, it is the preferred way to write it.
> 
> The standard has a weird distinction between {} and {0} that results
> in different behavior.

Whoever cares: details are described in "6.7.8 Initialization" within
the C standard.
