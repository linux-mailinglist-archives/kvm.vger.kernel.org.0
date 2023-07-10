Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D141874D1A6
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 11:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjGJJeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 05:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjGJJeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 05:34:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70801709;
        Mon, 10 Jul 2023 02:33:22 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36A8r24Y011468;
        Mon, 10 Jul 2023 09:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=n+gNm5CCZa1i/5LPuGfEcIyZbPri36sS610dE7kyS0g=;
 b=noCOc0Kuh3uqPgyzHgSYjQtLDA7q/K8bOhndnqxY3BoiScQI224WrOLN4Bigb5F8at6A
 7UM1lQfNP3APsFpaFocWsMUxEKGh95l3H1onJSmA1DdIsHlNYamsmDjzmtGEAINtuhHq
 2W0Df+NNu1DkVavvXkXdeLx/bu6UHX2YrucC++lvSGivosKkPGnHv2QjWNrnU2F5lmfR
 svk4u1ySyAkCyeffxkUooyzkY4yn2OjqUpJ6d2SRcdGms6H6g0ghTRLnzlJDlJ0Hkfr1
 ND8wJmhg3YGx36ER+StBAPQXZBAg9KfyFORFUNnYTurGjRjgtlP7c/T3UpS65uHRqgZc Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rrev2h1yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 09:33:21 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36A9RvLH014969;
        Mon, 10 Jul 2023 09:33:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rrev2h1xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 09:33:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36A4oQFo031029;
        Mon, 10 Jul 2023 09:33:19 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rpye5953p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 09:33:19 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36A9XFZt10551852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 09:33:15 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C550220043;
        Mon, 10 Jul 2023 09:33:15 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C5FB20040;
        Mon, 10 Jul 2023 09:33:15 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.28.83])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jul 2023 09:33:15 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230707145410.1679-3-frankja@linux.ibm.com>
References: <20230707145410.1679-1-frankja@linux.ibm.com> <20230707145410.1679-3-frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] lib: s390x: sclp: Add line mode input handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168898159418.42553.16145415333685309101@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 10 Jul 2023 11:33:14 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9yHM1deWIYxzH7iDMZfcPIk0q5j8EwCZ
X-Proofpoint-GUID: 2_cwJE3cvJGhsYLjhZwAnAq1ObLd7mn3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_07,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307100082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-07-07 16:54:10)
> Time to add line-mode input so we can use input handling under LPAR if
> there's no access to a ASCII console.
>=20
> Line-mode IO is pretty wild and the documentation could be improved a
> lot. Hence I've copied the input parsing functions from the s390-tools
> zipl code.

ZIPL is MIT and the copyright notice is not reproduced here.

NACK.

Please preserve the copyright notice or copy from a GPL-licensed project.
