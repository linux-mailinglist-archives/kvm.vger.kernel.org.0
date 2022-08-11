Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868E559056B
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 19:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbiHKRLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 13:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiHKRLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 13:11:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B37ABF06
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 09:46:17 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BGOPhA018381
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 16:46:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=GV9EY+ATV5Emh/vscwofusEf6mM5F9XKvIMUbFE9WR0=;
 b=annhYAfcZ65PQVGglyxx7v25qsgpMndD1DZa2a2ewA4296as4adv9/PhB4OqJu/flxp2
 oSnqcz59joRp2WA3xkll0JFRnHlyD9o+T2ENrHfJaNoHjliqKv+xdctqOzV9r90wDsn2
 oBuXaOmrTnBMmuIRLCaqVaiwObYEMWqBVi+3l17Vn09vgwF7JEYcvXfmRyQcbWMD1Lkt
 enooWdtZFAJ4J5PuBz0UrVyEg2eMDtrGLT7TUzVX0hYeUaUcgFl/kssa5rhySROfYK01
 sDQdeR0Iy4GVaI6yIqBUGxJ6mSrtAhnrb6sBxkRN0BkSf9g2C44wb8cg7mXzk6gaoxf4 Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw58mgkka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 16:46:16 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27BGjmZP027241
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 16:46:16 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw58mgkjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 16:46:16 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27BGZdWs023627;
        Thu, 11 Aug 2022 16:46:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3huwvfsq39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 16:46:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27BGkRwc34930976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 16:46:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 429A8AE051;
        Thu, 11 Aug 2022 16:46:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FADAAE04D;
        Thu, 11 Aug 2022 16:46:10 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.37.37])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 16:46:10 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220810120822.51ead12d@p-imbrenda>
References: <20220722060043.733796-1-nrb@linux.ibm.com> <20220722060043.733796-4-nrb@linux.ibm.com> <20220810120822.51ead12d@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] s390x: add extint loop test
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Message-ID: <166023636987.24812.9038211846031343249@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Thu, 11 Aug 2022 18:46:09 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 041FoUIHiJdfZAn5T1ep0kGRLiomOZq3
X-Proofpoint-ORIG-GUID: LpI_rScvis6o7KpCaKuCXgU68CwJTBSR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015 phishscore=0
 mlxscore=0 mlxlogscore=891 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-10 12:08:22)
[...]
> > diff --git a/s390x/panic-loop-extint.c b/s390x/panic-loop-extint.c
> > new file mode 100644
> > index 000000000000..d3a3f06d9a34
> > --- /dev/null
> > +++ b/s390x/panic-loop-extint.c
[...]
> > +static void ext_int_handler(void)
> > +{
> > +     /*
> > +      * return to ext_old_psw. This gives us the chance to print the r=
eturn_fail
> > +      * in case something goes wrong.
> > +      */
> > +     asm volatile (
> > +             "lpswe %[ext_old_psw]\n"
> > +             :
> > +             : [ext_old_psw] "Q"(lowcore.ext_old_psw)
> > +             : "memory"
> > +     );
> > +}
>=20
> why should ext_old_psw contain a good PSW? wouldn't it contain the
> PSW at the time of the interrupt? (which in this case is the new PSW)
>=20
> but this should never happen anyway, right?

Well, after your remark, I thought about this a little more and found sever=
al issues with my implementation:

- I enabled the clock comparator subclass mask, but set the CPU timer. The =
test also works with the clock comparator since it also stays pending. Does=
n't really matter which one to use as long as you stay consistent. :-)
- returning to ext_old_psw is not enough, since the CPU timer subclass mask=
 is still enabled and the CPU timer is negative. This means the CPU timer w=
ill fire once we enable external interruptions and hence impede printing th=
e report_fail()
- the whole lpswe is redundant, since the default kvm-unit-test handler alr=
eady does that. I will refactor this to leave the default kut handler in pl=
ace, which is much nicer and safer.

So upcoming version will refactor this test a bit and rely on the default k=
vm-unit-test int handler and the nice new register_ext_cleanup_func().
