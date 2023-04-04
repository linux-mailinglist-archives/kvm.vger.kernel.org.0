Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF076D5F59
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjDDLnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbjDDLna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:43:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D07E3A8B;
        Tue,  4 Apr 2023 04:43:23 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349rVUv011097;
        Tue, 4 Apr 2023 11:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=roMPf5OL4gaP5725IIAqaBn0Al14V6yndN4UkgXcdCs=;
 b=Z7k2rCt9Xd6aEjx6QSbrq4C/e3syb7K0pqb1O9+N2ogRKpubtihN22lN+1fhcksebynS
 HnRnEU5XKhJDc/hktgZ2ErIQfmqOU+j+PWyYsiQ8GYTm27WdWahxkXn48tyAW0eeLTba
 8M7t6ZJIuyqv88VGWcOc39t8sW7sStOhKZm29niUBDeSho7QxNH4lFy/DUZZ05Ncugk3
 SLIkTU5mC8jItcUK4TMlfR+ktVklOGsMKqRhmk3Ev2791HiqPv1UzSFxSMdsiqGvbnLE
 go5jE9cxKfWuBx6kUrcmlJRmffB1jPb7qt9l7lcS+YIwkoI33vELo5ixVMV3WO4QUtT7 mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs5xpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:43:22 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334BHNft031069;
        Tue, 4 Apr 2023 11:43:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pr3gs5xpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:43:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341n3tw024634;
        Tue, 4 Apr 2023 11:43:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg2fvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:43:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BhH9I14746218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:43:17 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08F7A20049;
        Tue,  4 Apr 2023 11:43:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D99D720043;
        Tue,  4 Apr 2023 11:43:16 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:43:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230404102437.174404-1-thuth@redhat.com>
References: <20230404102437.174404-1-thuth@redhat.com>
Cc:     linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x: Use the right constraints in intercept.c
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168060859657.37806.1305962304917629188@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 04 Apr 2023 13:43:16 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gzzpo7LU_2ahm0HmEywDGlINcEZDPn6R
X-Proofpoint-ORIG-GUID: UHo7X3sGY3EjqDq2nx0lf3YxyeNjY2PE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 mlxlogscore=790 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-04-04 12:24:37)
> stpx, spx, stap and stidp use addressing via "base register", i.e.
> if register 0 is used, the base address will be 0, independent from
> the value of the register. Thus we must not use the "r" constraint
> here to avoid register 0. This fixes test failures when compiling
> with Clang instead of GCC, since Clang apparently prefers to use
> register 0 in some cases where GCC never uses register 0.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
