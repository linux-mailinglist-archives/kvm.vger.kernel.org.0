Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651794D0832
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 21:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbiCGUQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 15:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiCGUQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 15:16:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BBF66ACB;
        Mon,  7 Mar 2022 12:15:21 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227J1jxa017595;
        Mon, 7 Mar 2022 20:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=SBthRdwRxl3kNCG7QVUJ/J9iVXVrxSBN3Lzfo/pFSn0=;
 b=pYIPssCfMeeZd3TKB5u/qB6ODJIGS27/8bQhZG2vHARU8SEQgxNrubCm2TMZzuI7Xos0
 O6CpuV+wFqsP3F6lBFxEqERTe12DGqZ5cNFsZoqgEvAFq0vVySqfYYmkl13A6g23/Yce
 JDrGdhCYcQUl34ICzvJ6vnBnvnF4kEYuBcmqoynUQrKIrnKOqTOH9HiX1fVXX4HIYFoQ
 chG0WO3oq3sWUurPg783O3Szo+mp+9EySF37NscX6a8EWmLsSANYoI2sMqooWlYkaBKp
 QcGi18Zg9MBnXJOeY1SCkF1FgQPIbeSMVEBnpVmBTiFWu0/T6/9JXQcWPuWB8YSFweWr qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ennxykuu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 20:15:20 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227JTJNr013794;
        Mon, 7 Mar 2022 20:15:19 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ennxykuu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 20:15:19 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227Jqare000913;
        Mon, 7 Mar 2022 20:15:19 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3ekyg9875n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 20:15:19 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227KFHMg12452478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 20:15:17 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A47916A04D;
        Mon,  7 Mar 2022 20:15:17 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E00316A047;
        Mon,  7 Mar 2022 20:15:16 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.148.123])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 20:15:16 +0000 (GMT)
Message-ID: <500af9df424ebe51e513e167b6ae39dabb4b1378.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 6/6] lib: s390x: smp: Convert
 remaining smp_sigp to _retry
From:   Eric Farman <farman@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 07 Mar 2022 15:15:16 -0500
In-Reply-To: <4d7026348507cd51188f0fc6300e7052d99b3747.camel@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-7-farman@linux.ibm.com>
         <1aa3b683-061d-465a-89fa-2c748719564d@linux.ibm.com>
         <4d7026348507cd51188f0fc6300e7052d99b3747.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HWjhUmLLSE8iF5MaO-3wVPvQHOIcxVUa
X-Proofpoint-ORIG-GUID: 2blM-Pe8_2HWPUNVSsC3Y-nj5Ff0rM1t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_10,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203070108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-07 at 15:42 +0100, Nico Boehr wrote:
> On Fri, 2022-03-04 at 11:56 +0100, Janosch Frank wrote:
> > On 3/3/22 22:04, Eric Farman wrote:
> > > A SIGP SENSE is used to determine if a CPU is stopped or
> > > operating,
> > > and thus has a vested interest in ensuring it received a CC0 or
> > > CC1,
> > > instead of a CC2 (BUSY). But, any order could receive a CC2
> > > response,
> > > and is probably ill-equipped to respond to it.
> > 
> > sigp sense running status doesn't return a cc2, only sigp sense
> > does
> > afaik.
> > Looking at the KVM implementation tells me that it's not doing more
> > than 
> > looking at the R bit in the sblk.
> 
> From the POP I read _all_ orders may indeed return CC=2: case 1 under
> "Conditions precluding Interpretation of the Order Code".
> 
> That being said, there are a few more users of smp_sigp (no retry) in
> smp.c (the test, not the lib). 
> 
> Does it make sense to fix them aswell?

I thought it made sense to do the lib, since other places expect those
things to "just work."

But for the tests themselves, I struggle to convince myself with one
path over another. The only way KVM returns a CC2 is because of a
concurrent STOP/RESTART, which isn't a possibility because of the
waiting the lib itself does when invoking the STOP/RESTART. So should
the tests be looking for an unexpected CC2? Or just loop when they
occur? If the latter, shouldn't the lib itself do that?

I'm happy to make changes, I just can't decide which it should be. Any
opinions?

Eric

