Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F7B623E85
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 10:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiKJJY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 04:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiKJJY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 04:24:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E3EC748;
        Thu, 10 Nov 2022 01:24:54 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA7bhrG029325;
        Thu, 10 Nov 2022 09:24:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=pWjGFFtI++Ys+ZIOuCBsoSj5xz20C7XwzIK4ULMxdEM=;
 b=LU6Q7BoVTg2NQprvDAtBQmvGsOyg71zbZTb5fVyiKrTJyMc6ebGeomYiRRLT0wLG3Dz8
 BjTnxvnzlv+jMk3qYxgbRAtymXHe7aCU1gqcH0G7Y/wQRH2HR4Qpm6bQRJl9Kn0/wDqX
 7gLUCzVhpflg0SBLQ5OHrYEqXHLaV9pf2QvONggAlU2UMrgfpc+Kg6wIPJf4VaIxkbDA
 xiLgUz7a8dNDsOgemNodwCpjLyq+NQoN7x7hU/OsmrorOVP7dk7dBuuqObQZSvGg74jA
 JMg2GROu8TN4JqRXhje+NqSz9nFSpEIT6yxL3d4Gvt6M4rXzUkbawA/YQJfUgIuUeI8V EA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3krvscb8nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 09:24:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AA9K7kX027193;
        Thu, 10 Nov 2022 09:24:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3kngncf0fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 09:24:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AA9OmlP5374692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 09:24:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7454F42042;
        Thu, 10 Nov 2022 09:24:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5756842049;
        Thu, 10 Nov 2022 09:24:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.74.83])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 09:24:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221109202157.1050545-2-farman@linux.ibm.com>
References: <20221109202157.1050545-1-farman@linux.ibm.com> <20221109202157.1050545-2-farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: [PATCH 1/2] vfio-ccw: sort out physical vs virtual pointers usage
Message-ID: <166807228813.13521.7185648742806016994@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 10 Nov 2022 10:24:48 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pX3vy9WejOLps5cInkMNAxb2U2xafznk
X-Proofpoint-ORIG-GUID: pX3vy9WejOLps5cInkMNAxb2U2xafznk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=711
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Eric Farman (2022-11-09 21:21:56)
> From: Alexander Gordeev <agordeev@linux.ibm.com>
>=20
> The ORB is a construct that is sent to the real hardware,
> so should contain a physical address in its interrupt
> parameter field. Let's clarify that.

Maybe I don't get it, but I think the commit description is inaccurate. The=
 PoP
says (p. 15-25):

> Bits 0-31 of word 0 are
> preserved unmodified in the subchannel until
> replaced by a subsequent START SUBCHANNEL or
> MODIFY SUBCHANNEL instruction. These bits are
> placed in word 1 of the interruption code when an I/O
> interruption occurs and when an interruption request
> is cleared by the execution of TEST PENDING
> INTERRUPTION.

So the hardware actually doesn't care what kind of address this is. Rather,=
 the
CIO driver expects the intparam to be a physical address - probably so it f=
its
32 bits -, see do_cio_interrupt.
