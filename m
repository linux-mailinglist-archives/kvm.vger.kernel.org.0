Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDA8751D5E
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjGMJgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjGMJf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:35:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6502102;
        Thu, 13 Jul 2023 02:35:58 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36D9LudS008444;
        Thu, 13 Jul 2023 09:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=ZuiknXMhRqm6mQZsM0miHbXVCzBQBkfQoEZk99Sh9DE=;
 b=o3JFAhSrZHlXTLskpcqKwSh1NyN5fONlmrDsRAU+sgprwBart9ePzRO20Do7e6iUdvLJ
 ezsdpNjL1GlqTr/hmqJwwCTf2tUmsfCtiivdQ6hOpdxQ509MYtl13UMXn3Ly3QF6Yl2M
 BAVpuUrPmO+ELaESH+0CEN5TxUpwBRHvsi3LVYrKAmZTC5FT/7Rc39h5dXGqMp6z1e2E
 1/SD6DGAFL1PqbBI5V+xBxoiekGUjPuiOmtwgZ1Nl67SihZdXPBr2179D3vu9lQm6Xdf
 W7O4PKdH9IEuXXoS3Rwz2CMa1JK4Dd2C8lVtcLy4uH2BPF1UstuS3GsVDM8um7SXzvtj FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtejtra0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 09:35:57 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36D9Xfpa013753;
        Thu, 13 Jul 2023 09:35:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtejtr9yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 09:35:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36D0CLbc026596;
        Thu, 13 Jul 2023 09:35:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye5b5vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 09:35:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36D9ZpsT12059276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 09:35:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E60320043;
        Thu, 13 Jul 2023 09:35:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FE2D20040;
        Thu, 13 Jul 2023 09:35:51 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.40.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jul 2023 09:35:51 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230713102013.586c737a@p-imbrenda>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-2-nrb@linux.ibm.com> <20230713102013.586c737a@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 1/6] lib: s390x: introduce bitfield for PSW mask
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Message-ID: <168924095095.12187.6900762606380666745@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 13 Jul 2023 11:35:50 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ck6daEabN1xyQoNdso1X6153JKstvkUK
X-Proofpoint-ORIG-GUID: xDaviCL3ZPVW9-mpcbsm1H0ZE08gaeJC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=953
 suspectscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-07-13 10:20:13)
[...]
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index bb26e008cc68..53279572a9ee 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -37,12 +37,36 @@ struct stack_frame_int {
> >  };
> > =20
> >  struct psw {
> > -     uint64_t        mask;
> > +     union {
> > +             uint64_t        mask;
> > +             struct {
> > +                     uint8_t reserved00:1;
> > +                     uint8_t per:1;
> > +                     uint8_t reserved02:3;
> > +                     uint8_t dat:1;
> > +                     uint8_t io:1;
> > +                     uint8_t ext:1;
> > +                     uint8_t key:4;
> > +                     uint8_t reserved12:1;
> > +                     uint8_t mchk:1;
> > +                     uint8_t wait:1;
> > +                     uint8_t pstate:1;
> > +                     uint8_t as:2;
> > +                     uint8_t cc:2;
> > +                     uint8_t prg_mask:4;
> > +                     uint8_t reserved24:7;
> > +                     uint8_t ea:1;
> > +                     uint8_t ba:1;
> > +                     uint32_t reserved33:31;
>=20
> since you will need to respin this anyway:
>=20
> can you use uint64_t everywhere in the bitfield? it would look more
> consistent and it would avoid some potential pitfalls of using
> bitfields. In our case we're lucky because all fields are properly
> aligned, but using uint64_t makes it easier to understand.

I will do that for consistency, I'd be interested to understand what pitfal=
ls
you're talking about and how uint64_t avoids them, since we have a few bitf=
ields
in the codebase.
