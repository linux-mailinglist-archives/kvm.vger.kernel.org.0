Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E03F75383C
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 12:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjGNKc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 06:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbjGNKcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 06:32:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4EF113;
        Fri, 14 Jul 2023 03:32:53 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EAWdgt024470;
        Fri, 14 Jul 2023 10:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=KfmCAIwEZrnvZLgrQFNGQ29O8MtEuiAR33Mt4Ca/9wM=;
 b=eGdc8SlzT/i+uvAEm0Wovv2K1CsQttjFsHt9PhqcechfUWJbfFU5+bBQrlhUPba+TAeF
 2xTdZXYWZXuxZsBm25Wi92vssc7EN9kOvJy0TCdZOc63DlnWZ6EB2v3gVWi1gxOobDZ0
 Zo2264nXatUynLUEfVFTUTChPgi0f6u1gaE6u11J2pzFA6j8HfV06qxWZ5n8er/bg8t0
 oguhBdghc2ISIA9DIj/W/OkBEA4vmEGRu4qlv1PqZhf+As+NBu+S/oOOvcLEdbp3qRBy
 7Z7grPj7XahmmWq9QfwfxqerV45QGuPAYvN+9wJqiBjBqXUBRBdeELUMIbGrGjp7XVPi Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru4fr0bbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:32:52 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36EAHabW010805;
        Fri, 14 Jul 2023 10:32:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru4fr0amt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:32:48 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36E4bSB9027002;
        Fri, 14 Jul 2023 10:32:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rtq50r83p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 10:32:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36EAVvg023265934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 10:31:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D3F920067;
        Fri, 14 Jul 2023 10:31:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5214420043;
        Fri, 14 Jul 2023 10:31:56 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.42.10])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jul 2023 10:31:56 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <773a739d-c1a3-af32-424b-7d29878fccf5@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-4-nrb@linux.ibm.com> <3dbe3094-b796-6b78-a97f-130a82780421@redhat.com> <20230713101707.1d1da214@p-imbrenda> <cedb8a69-c801-daee-52ed-b38b84deabd1@redhat.com> <168932289824.12187.4321177108836954492@t14-nrb> <773a739d-c1a3-af32-424b-7d29878fccf5@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 3/6] s390x: sie: switch to home space mode before entering SIE
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Message-ID: <168933071496.12187.10655662946419362243@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 14 Jul 2023 12:31:54 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MEaOehj8ijAJwN7A4X_aSarWjyms0l5J
X-Proofpoint-ORIG-GUID: mqNmxRDqxw8KoV7_OfROYo9gHehsPtSv
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

Quoting Thomas Huth (2023-07-14 10:30:33)
> On 14/07/2023 10.21, Nico Boehr wrote:
> > Quoting Thomas Huth (2023-07-13 10:21:12)
> >> On 13/07/2023 10.17, Claudio Imbrenda wrote:
> >>> On Thu, 13 Jul 2023 09:28:19 +0200
> >>> Thomas Huth <thuth@redhat.com> wrote:
> >>>
> >>> [...]
> >>>
> >>>>> +   irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
> >>>>> +   psw_mask_clear_bits(PSW_MASK_HOME);
> >>>>> +
> >>>>> +   /* restore the old CR 13 */
> >>>>> +   lctlg(13, old_cr13);
> >>>>
> >>>> Wouldn't it be better to always switch to HOME address mode directly=
 in our
> >>>> startup code already (where we enable DAT)? Switching back and forth=
 every
> >>>> time we enter SIE looks confusing to me ... or is there a reason why=
 we
> >>>> should continue to run in primary address mode by default and only s=
witch to
> >>>> home mode here?
> >>>
> >>> the existing tests are written with the assumption that they are
> >>> running in primary mode.
> >>>
> >>> switching back and forth might be confusing, but avoids having to
> >>> fix all the tests
> >>
> >> Which tests are breaking? And why? And how much effort would it be to =
fix them?
> >=20
> > Since you're not the first asking this, I took the time and
> > moved^Whacked everything to home space mode:
> >=20
> > - all SIE-related tests time out, even when we load CR1 properly before=
 SIE
> >    entry. Most likely just an oversight and fixable.
> > - the skey test encounters an unexpected PGM int with a weird backtrace
> >    where I couldn't easily figure out what goes wrong
> > - edat test fails with a similar looking backtrace
> >=20
> > All in all, it is probably fixable, but additional effort.
> >=20
> > I think explicitly switching the address space mode gives us additional
> > flexibility, since sie() doesn't need to make assumptions about which a=
ddress
> > space we're running in.
>=20
> Ok, thanks for checking. Then let's go with this patch here for now, but =

> maybe you could add a more detailed comment in the source code that talks=
=20
> about the reasons for switching each time instead of only once during sta=
rtup?

OK, how about this?

* Set up home address space to match primary space. Instead of running
* in home space all the time, we switch every time in sie() because:
* - tests that depend on running in primary space mode don't need to be
*   touched
* - it avoids regressions in tests
* - switching every time makes it easier to extend this in the future,
*   for example to allow tests to run in whatever space they want
