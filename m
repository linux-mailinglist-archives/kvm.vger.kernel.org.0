Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A186CBF85
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbjC1MpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjC1MpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:45:04 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF963A3;
        Tue, 28 Mar 2023 05:44:30 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SCE5pC000384;
        Tue, 28 Mar 2023 12:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=KbXwsz91G9gmSWFR3b5pgN+IxfFfDDnowfmvfYznASs=;
 b=czAZ311rykF+0jhqkPJZfPk5PBW7rZJjao06KZQBGu0njvrVN9UqHZCElOuR+KFLlVpq
 9dhj6Yj4iZd6lRQT4UMkMntxAVfg1+mE/Osi9c3g+fb7ZiJN4J8mOQR7NAbK8tobGkPx
 LzfvaIhGiRjjOMc0jPiAw1MMjQBxqFTAqEj8dsKeSCJ+iizm9eIq8lU5qh4yiYbYOtJ5
 uQfsgOhRelWa0AApMSvE8oYMca+O8XPq0SE7lzE3SHdxlFIRF1MaF9CXUe9+bYHfSWFV
 pSuk9ywkHbSGBi+j+VCSltjCMMKdBRjBfrjsm8oNH97P4C6+zB1p5SZYDIWJZb0J239y CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm02ert1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 12:44:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SCbHPr027610;
        Tue, 28 Mar 2023 12:44:29 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm02ert1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 12:44:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32RIYhib031880;
        Tue, 28 Mar 2023 12:44:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3phrk6bd4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 12:44:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SCiORr25363144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 12:44:24 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A9442004B;
        Tue, 28 Mar 2023 12:44:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE8E02004D;
        Tue, 28 Mar 2023 12:44:23 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.15.139])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Mar 2023 12:44:23 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <3dcfb02a-84db-1298-1b88-810b52c12818@linux.ibm.com>
References: <20230320085642.12251-1-pmorel@linux.ibm.com> <20230320085642.12251-3-pmorel@linux.ibm.com> <167965555147.41638.10047922188597254104@t14-nrb> <eed972f5-7d94-4db3-c496-60f7d37db0f3@linux.ibm.com> <167998471655.28355.8845167343467425829@t14-nrb> <3dcfb02a-84db-1298-1b88-810b52c12818@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v7 2/2] s390x: topology: Checking Configuration Topology Information
Message-ID: <168000746363.28355.1842312853535506881@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 28 Mar 2023 14:44:23 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iNb5fXtDNxGTRd7qf_rXi_TjXBv1XecI
X-Proofpoint-ORIG-GUID: 4Hq_GVG3DhrtHxVC1Bxj0rStLyKvm4Ct
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 adultscore=0 bulkscore=0 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=845
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280100
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-03-28 13:37:59)
>=20
> On 3/28/23 08:25, Nico Boehr wrote:
> > Quoting Pierre Morel (2023-03-27 14:38:35)
> >>> [...]
>=20
>=20
> [...]
>=20
>=20
> >> If a topology level always exist physically and if it is not specified
> >> on the QEMU command line it is implicitly unique.
> > What do you mean by 'implicitly unique'?
>=20
> I mean that if the topology level is not explicitly specified on the=20
> command line, it exists a single entity of this topology level.

OK, makes sense! Thanks!
