Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921977534F7
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 10:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbjGNIVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 04:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbjGNIVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 04:21:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C9E10D4;
        Fri, 14 Jul 2023 01:21:47 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36E7qOVe016502;
        Fri, 14 Jul 2023 08:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=68sOOzTQz4q63VF8oVBEKPZIAftGIqsB6o5hSX8bnL0=;
 b=DSzaFyPuAADGj0DdcOEv/MhF7kwZPx4lMaXWihaBn8I4GXFVfzoNztOD3rMt+N3R6d3e
 zPWuO3IAihaXwXTn2KlL685CguiPYYmbsi1LpcAN8nkEjfUbZiq0ebY1xNmUWBn8HnG8
 6LwEhpOdpA9a9UX8vMnwJvzor72mBT8Gyo98mLSCtw7uz6H7GdUneqnqPn8CaFJWglAP
 MgbLFrZNA0HbIU/36dujQyIYSmF+IaDu2sWgEKLCDwQCOt28m5cxB38+cT0HYrWggb48
 wJTqa5cBZA9vjo8w/hulZ7lns9eCvlFA6OQheHrSNKVqNByBCjKWUHspvTogfVZnfYG8 CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru2bwgkgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 08:21:46 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36E8D4xO014343;
        Fri, 14 Jul 2023 08:21:46 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ru2bwgkft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 08:21:46 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36E4h1eA031651;
        Fri, 14 Jul 2023 08:21:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3rtq50r6kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jul 2023 08:21:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36E8Lcxh590350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 08:21:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B79162004D;
        Fri, 14 Jul 2023 08:21:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E5A62004B;
        Fri, 14 Jul 2023 08:21:38 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.42.10])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jul 2023 08:21:38 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <cedb8a69-c801-daee-52ed-b38b84deabd1@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com> <20230712114149.1291580-4-nrb@linux.ibm.com> <3dbe3094-b796-6b78-a97f-130a82780421@redhat.com> <20230713101707.1d1da214@p-imbrenda> <cedb8a69-c801-daee-52ed-b38b84deabd1@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5 3/6] s390x: sie: switch to home space mode before entering SIE
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Message-ID: <168932289824.12187.4321177108836954492@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 14 Jul 2023 10:21:38 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: E-3uF9tqvJZrTUzL03pMNpIjg7RNYZEw
X-Proofpoint-GUID: yFmm8Lw3bKa1J4-FwDTW-equk3Zvqck2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_04,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-07-13 10:21:12)
> On 13/07/2023 10.17, Claudio Imbrenda wrote:
> > On Thu, 13 Jul 2023 09:28:19 +0200
> > Thomas Huth <thuth@redhat.com> wrote:
> >=20
> > [...]
> >=20
> >>> +   irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
> >>> +   psw_mask_clear_bits(PSW_MASK_HOME);
> >>> +
> >>> +   /* restore the old CR 13 */
> >>> +   lctlg(13, old_cr13);
> >>
> >> Wouldn't it be better to always switch to HOME address mode directly i=
n our
> >> startup code already (where we enable DAT)? Switching back and forth e=
very
> >> time we enter SIE looks confusing to me ... or is there a reason why we
> >> should continue to run in primary address mode by default and only swi=
tch to
> >> home mode here?
> >=20
> > the existing tests are written with the assumption that they are
> > running in primary mode.
> >=20
> > switching back and forth might be confusing, but avoids having to
> > fix all the tests
>=20
> Which tests are breaking? And why? And how much effort would it be to fix=
 them?

Since you're not the first asking this, I took the time and
moved^Whacked everything to home space mode:

- all SIE-related tests time out, even when we load CR1 properly before SIE
  entry. Most likely just an oversight and fixable.
- the skey test encounters an unexpected PGM int with a weird backtrace
  where I couldn't easily figure out what goes wrong
- edat test fails with a similar looking backtrace

All in all, it is probably fixable, but additional effort.

I think explicitly switching the address space mode gives us additional
flexibility, since sie() doesn't need to make assumptions about which addre=
ss
space we're running in. It currently does, but that's fixable - in contrast=
 to
when we don't switch.
