Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2826D706807
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 14:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjEQMZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 08:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjEQMZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 08:25:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A86E77;
        Wed, 17 May 2023 05:25:09 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HC4LQJ015776;
        Wed, 17 May 2023 12:25:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=kwuc4xgQ5jbk6jMAaRYYOyaqRWsiUv9dbBR16RVmkkU=;
 b=Oc8s1aZ/YKLHLk2XDfdNU45tmmwA9+nk/1r6+yuSFAQtrr9ljneK+1AU2eD3wT5BqUwr
 LLt8mbkue+jLi6cEdY+pF+LeGe0Jxu5eq6iZ87jdlsoo1w+Ip73wHhOGgvJvW81ZbpA2
 QqssVsgCFhSJOYs4wwMWb8kl22GpNvL3Uo95IS5TPHR3AU8doY8aLCdx2l4BHo0Q81Wk
 xCBVtRJG91pkTVrNjIN9m4pTwSw0PEkpJ9gpfz7LdGuBIms4ZTOHyR9MvlkNVOJJMAjl
 NZzACxYmqEeBtcRI0oE1JxoxW6+NJLAJV87m4/cAFtVM9FJsxwKfkvdfWg0+hm40+OQZ pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmwyva4bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:25:09 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34HCEJnj012162;
        Wed, 17 May 2023 12:25:08 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmwyva4ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:25:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34GNOJGM020272;
        Wed, 17 May 2023 12:25:06 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qj1tdt5gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:25:06 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34HCP2j824969802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 12:25:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57D642004D;
        Wed, 17 May 2023 12:25:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 264F720040;
        Wed, 17 May 2023 12:25:02 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.7.234])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 17 May 2023 12:25:01 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230516191724.0b9809ac@p-imbrenda>
References: <20230516130456.256205-1-nrb@linux.ibm.com> <20230516130456.256205-2-nrb@linux.ibm.com> <20230516191724.0b9809ac@p-imbrenda>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/6] s390x: add function to set DAT mode for all interrupts
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168432630149.12463.14017444493360473166@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 17 May 2023 14:25:01 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Zbtix77TbGRuiKeWSTz8BNvgkG7Ula2W
X-Proofpoint-GUID: nisZtMevge1v0yrHC2m_rf81Qov175xx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 mlxlogscore=790 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305170098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-05-16 19:17:24)
[...]
> > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index 3f993a363ae2..1180ec44d72f 100644
> > --- a/lib/s390x/interrupt.c
> > +++ b/lib/s390x/interrupt.c
[...]
> > +void irq_set_dat_mode(bool dat, uint64_t as)
> > +{
[...]
> > +     for (struct psw *irq_psw =3D irq_psws[0]; irq_psw !=3D NULL; irq_=
psw++) {
>=20
> just call it psw, or cur_psw, it's a little confusing otherwise

will do.=20

[...]
> alternatively, you can redefine psw with a bitfield (as you mentioned
> offline):
>=20
> cur_psw->mask.dat =3D dat;
> if (dat)
>         cur_psw->mask.as =3D as;

Yep, I'll go with that.

>=20
> > +             else
> > +                     irq_psw->mask |=3D PSW_MASK_DAT | as << (63 - 16);
>=20
> otherwise here you're ORing stuff to other stuff, if you had 3 and you
> OR 0 you get 3, but you actually want 0

And that's the advantage of the bitfield. :)

>=20
> > +     }
> > +
> > +     mb();
>=20
> what's the purpose of this?

Make sure that the lowcore really has been written, but I think it's quite
useless, since a function is a sequence point, right?
