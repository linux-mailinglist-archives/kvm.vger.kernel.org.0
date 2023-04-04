Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C4A6D5C12
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 11:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbjDDJiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 05:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbjDDJiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 05:38:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3900519B4;
        Tue,  4 Apr 2023 02:38:21 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349YFRx009231;
        Tue, 4 Apr 2023 09:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=cAwaYRp2qEOB0301yJRxF9mFIGhPAEKQfuhA3o2gO/M=;
 b=VGMYV5SQwLLei6qUTgwzuRNpwVsY2iEEj/gf4fVtRwNmImeLmiy27AIPLF/YRzycdkD3
 O8gbAfSIdGLQL5yup6oCLgWy3HeDgXz6LBm/7+STIbipqaOjPoQAe/adNr3FdqubGIqM
 Mawb3ooMEtPIDDO9Oyulp7BGZvPcmxxqYRoCB7bqXNZjukERCgTfoSgU3mh8zNKVwnh8
 yWukk3UjLyt0WzXgoC0osPkucBcbFDlAEI17dyBXGhXTh19Je/9k3FHRbOKovTDVQo0W
 iodTBvvlMSTtNnMWNvW96C+SIs3eUXvtkIT8LYmKrgc+5WGK27vIMwVGfI52MiA2C98I mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prgf0sj9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:38:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3349Q47c012580;
        Tue, 4 Apr 2023 09:38:20 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prgf0sj8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:38:20 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33431A1T030727;
        Tue, 4 Apr 2023 09:38:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc872d94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 09:38:18 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3349cETc25494074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 09:38:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6958F20043;
        Tue,  4 Apr 2023 09:38:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A97320040;
        Tue,  4 Apr 2023 09:38:14 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.55.238])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 09:38:14 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230404085454.2709061-2-nsg@linux.ibm.com>
References: <20230404085454.2709061-1-nsg@linux.ibm.com> <20230404085454.2709061-2-nsg@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/3] s390x/spec_ex: Use PSW macro
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Message-ID: <168060109401.9920.11276012177072861564@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 04 Apr 2023 11:38:14 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fMMDmBNdjfwr3EmP4LYTLeiUQAfZ3G45
X-Proofpoint-ORIG-GUID: SqTfUUv7C9xAAcTNGKSDvnj-_OTORtpW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_02,2023-04-03_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxscore=0 mlxlogscore=927 priorityscore=1501
 impostorscore=0 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040088
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-04-04 10:54:51)
> Replace explicit psw definition by PSW macro.
> No functional change intended.
>=20
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
