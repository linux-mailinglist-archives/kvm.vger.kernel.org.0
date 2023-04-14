Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5F46E2052
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 12:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDNKK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 06:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjDNKKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 06:10:21 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FCD9027;
        Fri, 14 Apr 2023 03:10:14 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33E9hRNu030670;
        Fri, 14 Apr 2023 10:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=a/eGFYJ48II82x0BNRLSbikEnQovxSGz3QHFm02jMfY=;
 b=UFF0UK9+Z+eZILdUqDBkPiy3oF+ryh79dQdZBn6PybdOspOkuC+WhGkjd7OwvtC6hvcH
 tdjoGnnGODDqYQ9FdHn6/++ykwONzpYyT0ebjkB8TB90A6fcsO5ePkthY0uOSIq2fr//
 e+8Yucphum8RFgT/o7D6QSXy/jXT0JzByF7CVC3mIJO+IAST7N46kjZ3qdypwdpvi8J0
 Y9gyCqQaQf/bg+w8J0Yx5BOZs5w3XWXYiz7VfBsFyWcqygyrbLLZXG+3KtiDvJSgjk9M
 dvdRO3f0QPSLdbkcn9xcMOblOgXQ6Evb0lYhu3TZZQFgV0QHGLliIDV0xZavZkcxtHnG RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxwq5wy37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 10:10:13 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33E9jGFJ038511;
        Fri, 14 Apr 2023 10:10:12 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxwq5wy2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 10:10:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33DNlGNQ029324;
        Fri, 14 Apr 2023 10:10:10 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pu0m23kk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Apr 2023 10:10:10 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33EAA6rA14352800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 10:10:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DF3620077;
        Fri, 14 Apr 2023 10:10:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C490320073;
        Fri, 14 Apr 2023 10:10:05 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.91.231])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Apr 2023 10:10:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5b2e0a52c79122038cda60661c225e9d108e60ef.camel@linux.ibm.com>
References: <20230327082118.2177-1-nrb@linux.ibm.com> <20230327082118.2177-5-nrb@linux.ibm.com> <cfd83c1d7a74e969e6e3c922bbe5650f8e9adadd.camel@linux.ibm.com> <168137900094.42330.6464555141616427645@t14-nrb> <5b2e0a52c79122038cda60661c225e9d108e60ef.camel@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add a test for SIE without MSO/MSL
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <168146700513.42330.5991739646507426126@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 14 Apr 2023 12:10:05 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hyc2RTgGe_bbvWZPtZzdNRj6B3DB06TL
X-Proofpoint-ORIG-GUID: Q7hyFeTPUzCm4X52DrFPieZd0wIEhRE5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_04,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=979
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-04-13 18:33:50)
[...]
> With a small linker script change the snippet could know it's own length.
> Then you could map just the required number of pages and don't need to ke=
ep those numbers in sync.

Maybe it's because my knowledge about linker scripts is really limited or I
don't get it, but I fail to see the advantage of the additional complexity.

My assumption would be that the number of pages mapped for the guest memory=
 will
never really change. Keeping a define in sync seems more pragmatic than goi=
ng
through linker script magic.
