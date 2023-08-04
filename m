Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CE376FDB9
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 11:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjHDJqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 05:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjHDJqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 05:46:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E777C49FA;
        Fri,  4 Aug 2023 02:46:11 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3749ckwc014098;
        Fri, 4 Aug 2023 09:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : subject : to : message-id : date; s=pp1;
 bh=LDWA5hEwRFL2483mPODKHUjFwor5SYcTyNogSzzZouU=;
 b=ZOdFyqGVfrniQZsp+V7QQUB/ODDulVzC4vuz5xqrSXaCBjEuzDun0rBl4lWNDZGl8IG0
 3/lV7ww1ZXaXNF4y7w4A21am7RlRepfdaacdCzveXJxcFFcU9A7dBgJw+Y6koQKmJZeH
 LywL1RWjdypCllgfYF2uhbCQmbIydcq0XYc7aIyhkGq2blZcAZWvN+I0rwRuW6Irc44k
 OJ3hPxo6pOulMhJB5vMU0TC3UkTzr/HltT7xHw8ZQ/4Xmozk/b7THYaxSHIeNYp4XK1n
 B2pplhvlewnwWyO7iJEfIpPILu84zi6JXbwQfyu/yeUu/FaWwQJzf89HXJ19AU0Us2os aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s8xq08mt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Aug 2023 09:46:11 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3749d9of017916;
        Fri, 4 Aug 2023 09:46:10 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s8xq08msk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Aug 2023 09:46:10 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3749NLcq027816;
        Fri, 4 Aug 2023 09:46:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s8kp2vg4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Aug 2023 09:46:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3749k6vX35848834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Aug 2023 09:46:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F221120043;
        Fri,  4 Aug 2023 09:46:05 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4EBF2005A;
        Fri,  4 Aug 2023 09:46:05 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.78.151])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  4 Aug 2023 09:46:05 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6f8951e2-9ea6-5bad-9c2c-b27d70d57ffe@redhat.com>
References: <20230510121822.546629-1-nrb@linux.ibm.com> <20230510121822.546629-3-nrb@linux.ibm.com> <6f8951e2-9ea6-5bad-9c2c-b27d70d57ffe@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: s390: add tracepoint in gmap notifier
To:     David Hildenbrand <david@redhat.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
Message-ID: <169114236545.36389.12085901437050856794@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 04 Aug 2023 11:46:05 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p-_cvb9h6aHmSI6vtKeyjDNBrgtnXeUA
X-Proofpoint-GUID: huCehl-ochPLzIKgqWR3e02zZJMak3Z3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-04_08,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 clxscore=1011 adultscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308040083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting David Hildenbrand (2023-07-27 09:41:51)
> On 10.05.23 14:18, Nico Boehr wrote:
> > The gmap notifier is called for changes in table entries with the
> > notifier bit set. To diagnose performance issues, it can be useful to
> > see what causes certain changes in the gmap.
> >=20
> > Hence, add a tracepoint in the gmap notifier.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   arch/s390/kvm/kvm-s390.c   |  2 ++
> >   arch/s390/kvm/trace-s390.h | 23 +++++++++++++++++++++++
> >   2 files changed, 25 insertions(+)
> >=20
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index ded4149e145b..e8476c023b07 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -3982,6 +3982,8 @@ static void kvm_gmap_notifier(struct gmap *gmap, =
unsigned long start,
> >       unsigned long prefix;
> >       unsigned long i;
> >  =20
> > +     trace_kvm_s390_gmap_notifier(start, end, gmap_is_shadow(gmap));
> > +
> >       if (gmap_is_shadow(gmap))
> >               return;
> >       if (start >=3D 1UL << 31)
> > diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
> > index 6f0209d45164..5dabd0b64d6e 100644
> > --- a/arch/s390/kvm/trace-s390.h
> > +++ b/arch/s390/kvm/trace-s390.h
> > @@ -333,6 +333,29 @@ TRACE_EVENT(kvm_s390_airq_suppressed,
> >                     __entry->id, __entry->isc)
> >       );
> >  =20
> > +/*
> > + * Trace point for gmap notifier calls.
> > + */
> > +TRACE_EVENT(kvm_s390_gmap_notifier,
> > +             TP_PROTO(unsigned long start, unsigned long end, unsigned=
 int shadow),
> > +             TP_ARGS(start, end, shadow),
> > +
> > +             TP_STRUCT__entry(
> > +                     __field(unsigned long, start)
> > +                     __field(unsigned long, end)
> > +                     __field(unsigned int, shadow)
> > +                     ),
> > +
> > +             TP_fast_assign(
> > +                     __entry->start =3D start;
> > +                     __entry->end =3D end;
> > +                     __entry->shadow =3D shadow;
> > +                     ),
> > +
> > +             TP_printk("gmap notified (start:0x%lx end:0x%lx shadow:%d=
)",
> > +                     __entry->start, __entry->end, __entry->shadow)
> > +     );
> > +
> >  =20
> >   #endif /* _TRACE_KVMS390_H */
> >  =20
>=20
> In the context of vsie, I'd have thought you'd be tracing=20
> kvm_s390_vsie_gmap_notifier() instead.

Right, I can change that if you / others have a preference for that.
