Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9066EF360
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 13:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbjDZLXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 07:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240108AbjDZLXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 07:23:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247791737;
        Wed, 26 Apr 2023 04:23:03 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QBKulm016375;
        Wed, 26 Apr 2023 11:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=zrLhspNE92i+xZ355NeJcAoz5stMISrGduglnBH3rb8=;
 b=FvbJJ1mIBwE3ENwu0GsXFN/uQrhe14tfh0BmCTpvwD+dIVuevTMJt7rkeQdvOIMzou8K
 mp+67oKjqAPf5Uq9vOyllyewij0um5/PhgoLvGZCaXXrxCK2xy81CYel2ARDwdoekpnT
 ZaaREVbWD19sZ2kXVMrR11bAafnQ9qYkuqZwoHeci9KHpEHThGeil+FQxHaumQ4EN2o/
 lmOOrv2jMmw2oSljZIANP02qU493Zbs54UdUVtHZASbvythDdA6WCW1TCZpIobLK0J+Q
 Nix1Yaz7TF4uF0+a83CFf46txhW2bJ1L9IQ5o6FaBBCY+qzk1VhQAc8dkqUa6xj27xEn Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q730n01nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:23:02 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QBKtGc016349;
        Wed, 26 Apr 2023 11:23:01 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q730n01n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:23:01 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q286xr008237;
        Wed, 26 Apr 2023 11:22:59 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3q47771wr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:22:59 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QBMtge2097830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 11:22:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C07B20040;
        Wed, 26 Apr 2023 11:22:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B4AC2004B;
        Wed, 26 Apr 2023 11:22:55 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 11:22:55 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230421113647.134536-3-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com> <20230421113647.134536-3-frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/7] lib: s390x: uv: Add intercept data check library function
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168250817495.44728.6509550513181442670@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 26 Apr 2023 13:22:54 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5gZv-95ji2pxvoGJlIWUqu5Cr4Q0fcxZ
X-Proofpoint-ORIG-GUID: fs9GrNpJZWYxhw6vS0pA7z9DfEdBNuiW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_04,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxlogscore=926
 adultscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-04-21 13:36:42)
> When working with guests it's essential to check the SIE intercept
> data for the correct values. Fortunately on PV guests these values are
> constants so we can create check functions which test for the
> constants.
>=20
> While we're at it let's make pv-diags.c use this new function.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
