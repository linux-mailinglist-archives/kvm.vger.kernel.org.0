Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9D8623E09
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 09:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiKJIyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 03:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiKJIx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 03:53:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E7DB73;
        Thu, 10 Nov 2022 00:53:58 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA8g8ok030252;
        Thu, 10 Nov 2022 08:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=uz/aImqsgxHCq9BN4+ASQhwVId+s2B0fl/1A02hRKP4=;
 b=h7RmZrUWAkK9Ygc4JCNZWF71Nh8ZgSDlFELUGTwOllt1Xang6a/rS2ZV8HhG8YpbBkXP
 fXwn7SKgpdGxAtzydzl873H1XM4VBVGYcWGFJVxTn/sf4jocTVMEsMXHg+xRvV5e1ILs
 XhXrV3Cv4NYXFpeaOvbe5VTA4ti8ZHaZlboHcSdq83B5iKdRBKX6AGbivsxRo+8dadsB
 lOVVKG19X53IJLyNXeJS1G/J2R99C+SCnCoGfnKbok0v/oe8KCgYI2fcjY2PFgFCBWCI
 jZFJLqDDWhF9QoGAtz8WCYkMGYRlLuEwni2TWXb76u2EOpGLkSNYOAwRBRO2UZ/pwTxT 1w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3krx0yrdk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 08:53:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AA8bIQ3009484;
        Thu, 10 Nov 2022 08:53:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3kngqdewds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 08:53:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AA8rqJo62194024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 08:53:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37FEEAE057;
        Thu, 10 Nov 2022 08:53:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1990AAE056;
        Thu, 10 Nov 2022 08:53:52 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.74.83])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 08:53:52 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221109202157.1050545-3-farman@linux.ibm.com>
References: <20221109202157.1050545-1-farman@linux.ibm.com> <20221109202157.1050545-3-farman@linux.ibm.com>
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
Subject: Re: [PATCH 2/2] vfio/ccw: identify CCW data addresses as physical
Message-ID: <166807043186.13521.16767588635336490628@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 10 Nov 2022 09:53:51 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mV9gJ0PJyAB5R1gRr_J0jeu4slNtQ9oO
X-Proofpoint-ORIG-GUID: mV9gJ0PJyAB5R1gRr_J0jeu4slNtQ9oO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=766 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 spamscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211100064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Eric Farman (2022-11-09 21:21:57)
> The CCW data address created by vfio-ccw is that of an IDAL
> built by this code. Since this address is used by real hardware,
> it should be a physical address rather than a virtual one.
> Let's clarify it as such in the ORB.
>=20
> Similarly, once the I/O has completed the memory for that IDAL
> needs to be released, so convert the CCW data address back to
> a virtual address so that kfree() can process it.
>=20
> Note: this currently doesn't fix a real bug, since virtual
> addresses are identical to physical ones.
>=20
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
