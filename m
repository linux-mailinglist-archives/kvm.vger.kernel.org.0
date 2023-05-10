Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DAF6FD850
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 09:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235987AbjEJHfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 03:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbjEJHef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 03:34:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5E410DD;
        Wed, 10 May 2023 00:34:02 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A7VjwP015229;
        Wed, 10 May 2023 07:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : from : cc : message-id : date; s=pp1;
 bh=6jFad5hWN0Wn+R4Jw4RZMo/Tsq+LEjebgEiIs16ITq0=;
 b=kHh+5zDCpRaxPbs+u9g5K8Fe5xeaGZNj52DC2JN5S2ASqY7At0TdiM3S82CeC8NTDbtL
 zq8kEwYmdIuC6Me2tcX00MaAFPkQ++22buYkEQ5PUOMaf2NM2Uvj4NMgoodbpl2YzmS3
 Q/v8PLTyRiAYHvhifEwVwnGrSYicWrLHhbdtDZ0QuhWtCn5tBEmahD6CB2cOOf1fsry/
 o1IlkAP5zhPyS275Gm0JrSkAZ9s5bVLYdS5wh26FvTr2mWBQq6sieSnvG4nV4EqnKVkR
 vNrn07Rvj8bZPC50oXoG41CeQzzh1WQtYbXt5zOUXIZySjIaAc/qGfQY7q3e/TviB6Vy Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg6y582gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:33:33 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34A7W3gT016356;
        Wed, 10 May 2023 07:33:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg6y582fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:33:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A1nGS2008486;
        Wed, 10 May 2023 07:33:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896rvwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:33:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34A7XRKS43581778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 07:33:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7344320043;
        Wed, 10 May 2023 07:33:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5705D20040;
        Wed, 10 May 2023 07:33:27 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.76.41])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 07:33:27 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230502115931.86280-8-frankja@linux.ibm.com>
References: <20230502115931.86280-1-frankja@linux.ibm.com> <20230502115931.86280-8-frankja@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 7/7] s390x: pv-diags: Add the test to unittests.conf
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Message-ID: <168370400705.357872.3246421391161728078@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 10 May 2023 09:33:27 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _G7Wrer7xYLINGDomwB0SZwy1IH6DYgv
X-Proofpoint-GUID: M7D3gqsxNG1xUrUJ0H7LCOm-LeA3e7hM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 13:59:31)
> Better to have it run into a skip than to not run it at all.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
