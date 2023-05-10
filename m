Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F706FDC69
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 13:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbjEJLPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 07:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbjEJLPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 07:15:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FFD65BF;
        Wed, 10 May 2023 04:14:52 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ABAL3a021026;
        Wed, 10 May 2023 11:14:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=DEpQHimDu/K42FR/4TP1blNicignuD+2tsKH4uZTBgo=;
 b=Myz5WyX2ojywI+bpFai7mwXV6T2mPTF9CHoh/Z5fArkTaZ72pkPm/P0xg5EXjcoLKGtW
 ZdrAbjL05933TaFEucWN7PgUgq7t5efiZ8gR+Yta+CTiM/D22XKyT3FqlX4lcis9fHjC
 F5UIjCruOGfTNcwbBqaTxEFnh1PfUUPqIHHgQooAH82g8P0lQ/IiquGRufKRgwbuA3NF
 HXVjgQSfF16nONjUmHPg9Y4NOQqZNPYRnT9cP/dch31FwdLrM75Ohjp1cnadoa4VA46q
 cx0VfKT0qosJypjsr8irG1WeIbGE1k16wyr7TigMHXov8RNiTqgS22j5Dnud0/yx7+4T tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qga22rdd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:14:31 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34ABELwU005912;
        Wed, 10 May 2023 11:14:31 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qga22rdcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:14:31 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A9Fqpx024133;
        Wed, 10 May 2023 11:14:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qf7mhgtym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:14:29 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34ABEP6B32834290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 11:14:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 508152004E;
        Wed, 10 May 2023 11:14:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 271CF20040;
        Wed, 10 May 2023 11:14:25 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.202])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 11:14:25 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <3b5cce0a-b344-be8a-7432-704fe9e84d8f@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com> <20230502130732.147210-2-frankja@linux.ibm.com> <168370871258.331309.6187452257634029708@t14-nrb> <3b5cce0a-b344-be8a-7432-704fe9e84d8f@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/9] s390x: uv-host: Fix UV init test memory allocation
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168371726485.331309.16697585752187307781@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 10 May 2023 13:14:24 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ofHfEoOa1CawkyRj8bkhL_HQRphH8UKV
X-Proofpoint-ORIG-GUID: SDVYktNlRZNNaYR1QbAncOrypgHLkQvx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-10 11:03:54)
> On 5/10/23 10:51, Nico Boehr wrote:
> > Quoting Janosch Frank (2023-05-02 15:07:24)
> >> The init memory has to be above 2G and 1M aligned but we're currently
> >> aligning on 2G which means the allocations need a lot of unused
> >> memory.
> >=20
> > I know I already gave my R-b here, but...
> >=20
> >> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> >> index 33e6eec6..9dfaebd7 100644
> >> --- a/s390x/uv-host.c
> >> +++ b/s390x/uv-host.c
> >> @@ -500,14 +500,17 @@ static void test_config_create(void)
> >>   static void test_init(void)
> >>   {
> >>          int rc;
> >> -       uint64_t mem;
> >> +       uint64_t tmp;
> >>  =20
> >> -       /* Donated storage needs to be over 2GB */
> >> -       mem =3D (uint64_t)memalign_pages_flags(SZ_1M, uvcb_qui.uv_base=
_stor_len, AREA_NORMAL);
> >=20
> > ...maybe out of coffee, but can you point me to the place where we're a=
ligning
> > to 2G here? I only see alignment to 1M and your change only seems to re=
name
> > mem to tmp:
> >=20
> >> +       /*
> >> +        * Donated storage needs to be over 2GB, AREA_NORMAL does that
> >> +        * on s390x.
> >> +        */
>=20
> This comment explains it :)
> Its a re-name of mem to tmp and an extension of this comment so it makes =

> more sense.

Alright, thanks. I guess coffee level too low.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
