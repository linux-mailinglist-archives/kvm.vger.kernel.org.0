Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B697CC4C2
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343860AbjJQN3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343794AbjJQN33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:29:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35B5EA;
        Tue, 17 Oct 2023 06:29:27 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HDRKGA026063;
        Tue, 17 Oct 2023 13:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=/G50PTyPk1sf3k/tPQcbY3p7/yzoDDZIrTqn/r9khvw=;
 b=tFCjOkShtjeUY2UeKNtPRXwd9m4ZGO5DeWhPhPCPQKGaBdEQmwcauQqm/sVI7eAabuLV
 PPPHbbUiGmZhoPQr1il3P5GFNxluJcym1Hlpas6UrzMsVI4d0oXixE7I1seOm+6B1OQr
 dgLdcMdtW6VR8prxDZmeepHbO+MHfPvRezhyk2iXV8bg4m7051NCHkHZIxsVhFAYdRB0
 s1fh4aHE7EFy/dyDFOCGi2BmYIG8cPqxuCGs4Op8jdP5bwlpR5R0wq/5ptAT0u8GS/HN
 ZYvUVfzKSn+imeIi72JBsXTiG06uCupEHUudJlSuXV1Sy6huu/BL4bkheaK0uZC66B5E 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tsu5t04p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 13:29:21 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39HDSRPY000949;
        Tue, 17 Oct 2023 13:29:21 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tsu5t04m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 13:29:21 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39HBeBuQ020150;
        Tue, 17 Oct 2023 13:29:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tr6an13a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 13:29:19 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39HDTG7x4653644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 13:29:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A45E320049;
        Tue, 17 Oct 2023 13:29:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 793EB20040;
        Tue, 17 Oct 2023 13:29:16 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.66.53])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Oct 2023 13:29:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231011085635.1996346-8-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com> <20231011085635.1996346-8-nsg@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 7/9] s390x: topology: Rewrite topology list test
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Shaoqin Huang <shahuang@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169754935612.81646.10599656708946436495@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 17 Oct 2023 15:29:16 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mndcA9zcLWf0GgQNGfietp5PyIZ4Cy3M
X-Proofpoint-GUID: 4quASyOogIKsToOYCaSofu4tHkb6RH8M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_02,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310170114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:30)
> Rewrite recursion with separate functions for checking containers,
> containers containing CPUs and CPUs.
> This improves comprehension and allows for more tests.
> We now also test for ordering of CPU TLEs and number of child entries.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
[...]
> diff --git a/s390x/topology.c b/s390x/topology.c
> index c1f6520f..9838434c 100644
> --- a/s390x/topology.c
> +++ b/s390x/topology.c
[...]
> +static union topology_container *check_child_cpus(struct sysinfo_15_1_x =
*info,
> +                                                 union topology_containe=
r *cont,
> +                                                 union topology_cpu *chi=
ld,
> +                                                 int *cpus_in_masks)
> +{
> +       void *last =3D ((void *)info) + info->length;
> +       union topology_cpu *prev_cpu =3D NULL;
> +       int cpus =3D 0;

I know __builtin_popcountl returns int, but maybe it makes sense to make
this and cpus_in_masks an unsigned type?

> +       for (; (void *)child < last && child->nl =3D=3D 0; child++) {

Personal preference, I prefer simply iterating over a counter, but its up
to you.
