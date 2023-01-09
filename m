Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789286620F8
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 10:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbjAIJHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 04:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbjAIJHM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 04:07:12 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2749E1789B;
        Mon,  9 Jan 2023 01:00:41 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3098bdoJ005561;
        Mon, 9 Jan 2023 09:00:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=kWKjTvhS9KYzxLfRReqoD5xbarAEvv//YlouuFgVhdg=;
 b=Y0u86/EbDW8NMc0C/ZLtZvelhW5oOvHPh/MGsANgh2OUwnrKdZ9bYgEIrtPFpOWorLcB
 HVC8v7YJ9ThI6YNL/0R2M3uaLlT9DK4fq1lfo3k+kD36KAWCoCp2GROTDYcFxL2iNSU4
 09plNV08Wq4WtC20R3RKllFZx9ANKrGIZdbwfv4hRh2Vf+PHn77GeNw/u+S0SxSTfJ06
 BD5KfjkRAfb4ZR4UkEQK/Ep7zqJUkXTQaQsB6u/bMF4E0iP3yztSTqwvHhoRCpswx+pe
 Mea5aJMi+Em5JPqwC5NrOTOnX1DdZ7gNBR1Xw9E2j3x+cMR5L0qpIhmD3aXFHpezbbSe IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjgdg3xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 09:00:40 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3098TGwZ005928;
        Mon, 9 Jan 2023 09:00:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjgdg3wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 09:00:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3098dsSq012475;
        Mon, 9 Jan 2023 09:00:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3my00fjp6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 09:00:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30990YTH42533236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Jan 2023 09:00:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4641120049;
        Mon,  9 Jan 2023 09:00:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB8FA2004E;
        Mon,  9 Jan 2023 09:00:33 +0000 (GMT)
Received: from [9.171.86.101] (unknown [9.171.86.101])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Jan 2023 09:00:33 +0000 (GMT)
Message-ID: <feef1e28585841b7acd1d5d635df72500407b37e.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] vfio/type1: Respect IOMMU reserved regions in
 vfio_test_domain_fgsp()
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Christian =?ISO-8859-1?Q?Borntr=E4ger?= 
        <borntraeger@linux.ibm.com>
Date:   Mon, 09 Jan 2023 10:00:33 +0100
In-Reply-To: <20230106102450.2e6c70bb.alex.williamson@redhat.com>
References: <20230104154202.1152198-1-schnelle@linux.ibm.com>
         <20230104154202.1152198-2-schnelle@linux.ibm.com>
         <20230106102450.2e6c70bb.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4k2lCLvDsnPO0O_j1z66aJDYIvHhKSlq
X-Proofpoint-ORIG-GUID: JzuMjJXOXmNA9KctjNID_a-ipWmT-wda
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_03,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-01-06 at 10:24 -0700, Alex Williamson wrote:
> On Wed,  4 Jan 2023 16:42:02 +0100
> Niklas Schnelle <schnelle@linux.ibm.com> wrote:
>=20
> > Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain
> > aperture shrinking") the s390 IOMMU driver uses reserved regions for th=
e
>=20
> Are you asking for this in v6.2?  Seems like the above was introduced
> in v6.2 and I can't tell if this is sufficiently prevalent that we need
> a fix in the same release.

If possible yes I'd hope for this to go into v6.2 so we don't break ISM
pass-through. Support for ISM pass-through has only been available
since v6.0 where Matt added the interpretation support but it is one of
the most useful pass-through uses at the moment since the ISM device
uses long lived DMA mappings and as such is pretty much unaffected by
the performance impact of our virtualized IOMMUs. Together with SMD-D
this allows high performance communication of VMs with other VMs or
LPARs. Now we don't have this problem in distribution kernels that have
Matt's patches as backports but lack my newer IOMMU changes and few if
any of our customers run upstream but still of course I'd prefer not to
have known broken upstream releases.

Thanks,
Niklas
