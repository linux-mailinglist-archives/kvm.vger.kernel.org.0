Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB27F753856
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 12:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbjGNKi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 06:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjGNKiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 06:38:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526D32D7D;
        Fri, 14 Jul 2023 03:38:24 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EAHSh1010104;
        Fri, 14 Jul 2023 10:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : to : from : subject : cc : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=LajM4P5A0DOhdziBmFQaFKciN+d6kmgj8f8tmCkg9so=;
 b=FKXjPCakPZsidhCfWVB6GaLilfjJl9481pOQ8EVaN0d3YwlnkM+IXeyR0JGWluQl8v7o
 JI0A74aNF19XUbBjECV/+A55hi1WJXu5GVSFlHJLm6D2tj2H6jZWTSI7MU31DgGy3k/F
 xHWR6uxVigUmPDaoA25tIzxfBiPTr7N8b+unuqEyAYt0qqe3nZIEJ2JGOtvWflthAd6K
 +ZAriW0X8zXqi3dKDqFcZog/8tt/AUcqU9NIO2pNbeIu+I4OqP8nwtbcHfeCVEGFXGl1
 AiIMcdscjcnUbpM6va8Ku0I+gBE+HCyEjhyyEfF9lmAx/b+GuAycEo4gevcqgi560Ryd fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru4fr0ka6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:38:23 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36EALGDP020456;
        Fri, 14 Jul 2023 10:38:22 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru4fr0k9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:38:22 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36E2rPkQ028717;
        Fri, 14 Jul 2023 10:38:20 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3rtpxb88ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:38:20 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36EAcHUA17171062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 10:38:17 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EED0920043;
        Fri, 14 Jul 2023 10:38:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6919E20040;
        Fri, 14 Jul 2023 10:38:16 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.42.10])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jul 2023 10:38:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <ccb5001a-f904-aa97-e0ef-278723b39378@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-3-nrb@linux.ibm.com> <9b2cdc37-0b93-ff00-d077-397b8c0c2950@redhat.com> <168926224829.12187.2957278869966216471@t14-nrb> <ccb5001a-f904-aa97-e0ef-278723b39378@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 2/6] s390x: add function to set DAT mode for all interrupts
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <168933109528.12187.1434851106202466169@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 14 Jul 2023 12:38:15 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3RnfEBE1q4kMku4NUusHR6tNhVx0gUB5
X-Proofpoint-ORIG-GUID: zAP_by2F3_y_ug5haZsLVUMocFwJ-2at
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_05,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0
 clxscore=1015 suspectscore=0 mlxscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-14 08:44:10)
> On 13/07/2023 17.30, Nico Boehr wrote:
> > Quoting Thomas Huth (2023-07-13 09:17:28)
> >> On 12/07/2023 13.41, Nico Boehr wrote:
> >>> When toggling DAT or switch address space modes, it is likely that
> >>> interrupts should be handled in the same DAT or address space mode.
> >>>
> >>> Add a function which toggles DAT and address space mode for all
> >>> interruptions, except restart interrupts.
> >>>
> >>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> >>> ---
> >>>    lib/s390x/asm/interrupt.h |  4 ++++
> >>>    lib/s390x/interrupt.c     | 36 ++++++++++++++++++++++++++++++++++++
> >>>    lib/s390x/mmu.c           |  5 +++--
> >>>    3 files changed, 43 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> >>> index 35c1145f0349..55759002dce2 100644
> >>> --- a/lib/s390x/asm/interrupt.h
> >>> +++ b/lib/s390x/asm/interrupt.h
> >>> @@ -83,6 +83,10 @@ void expect_ext_int(void);
> >>>    uint16_t clear_pgm_int(void);
> >>>    void check_pgm_int_code(uint16_t code);
> >>>=20=20=20=20
> >>> +#define IRQ_DAT_ON   true
> >>> +#define IRQ_DAT_OFF  false
> >>
> >> Just a matter of taste, but IMHO having defines like this for just usi=
ng
> >> them as boolean parameter to one function is a little bit overkill alr=
eady.
> >> I'd rather rename the "bool dat" below into "bool use_dat" and then use
> >> "true" and "false" directly as a parameter for that function instead.
> >> Anyway, just my 0.02 \u20ac.
> >=20
> > The point of having these defines was to convey the meaning of the para=
meter to my reader.
> >=20
> > When I read
> >=20
> >      irq_set_dat_mode(true, AS_HOME);
> >=20
> > it's less clear to me that the first parameter toggles the DAT mode com=
pared to this:
> >=20
> >      irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);
> >=20
> > That being said, here it's pretty clear from the function name what the=
 first parameter is, so what's the preferred opinion?
>=20
> I see your point, but if it is clear from the function name like it is in=
=20
> this case, I'd go with "true" and "false" directly, without the indirecti=
on=20
> via #define.

OK, will do.

> ...
> >>> + * Since enabling DAT needs initalized CRs and the restart new PSW i=
s often used
> >>
> >> s/initalized/initialized/
> >=20
> > Argh, thanks.
> >=20
> > *reprioritizes task to look for a spell checker*
>=20
> codespell (https://github.com/codespell-project/codespell) is your friend!

Thanks!
