Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA0674D010
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 10:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjGJIgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 04:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjGJIgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 04:36:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB119E7;
        Mon, 10 Jul 2023 01:36:11 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36A8MSpK003218;
        Mon, 10 Jul 2023 08:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : cc : from : subject : to : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=OGk035gccT+nSWeAb3ekbTNXTzWpWREGtFI8LSRnFvE=;
 b=j5DdnkPkO42rt5/r3G5InifUBzQf50CQ4WjzUge1J9a2PciSiQiAb5zA28pYWLOOHy5H
 5w2cuy4/ZNstETx0BFj2MWxK9a6BmovyhtmuZfdtMQi3Yu+t2dWkpfxBnNysagux9GbB
 bSpNx6zYE/h+jXivl5FhESUWaxnC7GAZbvNUsxWTep7pA09PDjW2JOesy9KCJseGNkaD
 qM/lOdl4J+Kr0mhaTEkZQPS4vWMxXwD3+aRyv2dfkuWv6omQxJGzB0ZMJtrah/PhPvBa
 Xzqi54FaKbaScBWusQvkFxOnoZ3HC28h6VkhKolrjN4shx1MNHHQsR2Y633CPShdEoa+ Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rreds8b6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 08:36:11 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36A8N9xv007640;
        Mon, 10 Jul 2023 08:36:10 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rreds8b4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 08:36:10 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36A5T8ED000554;
        Mon, 10 Jul 2023 08:36:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e14mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 08:36:07 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36A8a4Pg46400142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 08:36:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F24820040;
        Mon, 10 Jul 2023 08:36:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03B0320043;
        Mon, 10 Jul 2023 08:36:04 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.26.118])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jul 2023 08:36:03 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <ffc48a06-52b2-fc65-e12d-58603d13b3e6@redhat.com>
References: <20230627082155.6375-1-pmorel@linux.ibm.com> <20230627082155.6375-3-pmorel@linux.ibm.com> <ffc48a06-52b2-fc65-e12d-58603d13b3e6@redhat.com>
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v10 2/2] s390x: topology: Checking Configuration Topology Information
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org
Message-ID: <168897816265.42553.541677592228445286@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 10 Jul 2023 10:36:02 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XGxUI3sv8Ra_UkBSk1Hw3lTKbTiQYLA2
X-Proofpoint-GUID: LaHI2rOhqvC7jnF0ikwpc-34suP_vyQi
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_05,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=998 clxscore=1015
 impostorscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100077
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-06 12:48:50)
[...]
> Does this patch series depend on some other patches that are not upstream=
=20
> yet? I just tried to run the test, but I'm only getting:
>=20
>   lib/s390x/sclp.c:122: assert failed: read_info
>=20
> Any ideas what could be wrong?

Yep, as you guessed this depends on:
Fixing infinite loop on SCLP READ SCP INFO error
https://lore.kernel.org/all/20230601164537.31769-1-pmorel@linux.ibm.com/
