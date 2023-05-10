Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFAB6FD85F
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 09:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbjEJHhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 03:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235765AbjEJHhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 03:37:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578E110D;
        Wed, 10 May 2023 00:37:05 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A7b4gV010729;
        Wed, 10 May 2023 07:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : from : cc : message-id : date; s=pp1;
 bh=VinL25yhB+0mcUxzrX4pOewXvielqH2Fz0eWxx+Mq5c=;
 b=b4ejDkA4VxK0jgNzHTzJp6NHBo/h4K1fNO57BfbyMRBnoKK91CMiatt+bQUD+Qz9DCma
 pErsI2UZHABa02LTUK/5DmbYg3lDxkSX4+ZIF//VuizBwZwhpxv05R2qhoa8G/6VOYJx
 m3Mj/AQ36lG6bFc+fGw1fgcsuBAhGJGdgpFMLTPuBXa+ggenRbWuRLf5q7xH9sd4Atln
 il9pxptf4HjB+4JzBJUMdkDUF9ZJwRjO4RQnYqHRC9dJsx9GVkqLjuQ1r3ePeTtjelDJ
 Qgxt9sSTFJ6nXqCEkbgofuiXWYFRZsQ0uN60VFuJsbaiiGRwaAQzzUrzopmvUAwK8PPX Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg6s8rdej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:37:04 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34A7K4VC014664;
        Wed, 10 May 2023 07:37:03 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg6s8rc3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:37:03 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A3GxRV017028;
        Wed, 10 May 2023 07:32:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896rvw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:32:36 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34A7WXlf65012102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 07:32:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4360520040;
        Wed, 10 May 2023 07:32:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B6220043;
        Wed, 10 May 2023 07:32:33 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.76.41])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 07:32:33 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230502115931.86280-7-frankja@linux.ibm.com>
References: <20230502115931.86280-1-frankja@linux.ibm.com> <20230502115931.86280-7-frankja@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 6/7] s390x: pv: Add IPL reset tests
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Message-ID: <168370395264.357872.2965402314069250128@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 10 May 2023 09:32:32 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: snsgWStzZO9vyi35Q0metlEq69evc-OO
X-Proofpoint-ORIG-GUID: V6x9_h08JKxn3o9pGV7vAGbShxotcOWJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305100059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 13:59:30)
> The diag308 requires extensive cooperation between the hypervisor and
> the Ultravisor so the Ultravisor can make sure all necessary reset
> steps have been done.
>=20
> Let's check if we get the correct validity errors.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
