Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9407379118C
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 08:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243007AbjIDGlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 02:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347117AbjIDGlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 02:41:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3FA106;
        Sun,  3 Sep 2023 23:41:00 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3846cGQU028469;
        Mon, 4 Sep 2023 06:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : cc : to : subject : from : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=FfVRcwlRJcoMS36uxppnXHoRJjYjGRzxm90M5y9htoQ=;
 b=NefFCvDop1hOjIlk8xUn8yZDnaXdwHE9TZcnumvBhB7NC2E5w8LgyIedkVjyGppOFCP+
 BV6XB78rhIpm8hD9phTXi51JsKCU1IayZLW6Bja0EXHz5QWSOYCDtNJSmiBiXK/FxnrH
 AZgZvJbehVB4GLqUxbEWw7uDYeDORd88cnyE5Ry/BM37l7LmzVeZho1MqrlzIi0LaVqr
 Q44kCGDB/vUL0cFtCzdmEqjlmCMh5NYhSHXopFeeOl//lFhv5a1hwNoRhr3UHIe5Uvx5
 1eOcp8EjsPLqfX7sE/0fcvZODG+ZCnTjfhPNIbI363FvG++jEHf3mnj2MzjSFOQw4ub9 kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw87nabq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 06:40:58 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3846cire029737;
        Mon, 4 Sep 2023 06:40:58 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw87nabpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 06:40:58 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3844Ppmn021459;
        Mon, 4 Sep 2023 06:40:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3svfry0mh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 06:40:56 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3846erbN20579056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 06:40:53 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EBC120043;
        Mon,  4 Sep 2023 06:40:53 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48D4320040;
        Mon,  4 Sep 2023 06:40:53 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.12.249])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 06:40:53 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <981405ed-060f-de0b-8125-29099ba8791a@redhat.com>
References: <20230809091717.1549-1-nrb@linux.ibm.com> <981405ed-060f-de0b-8125-29099ba8791a@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1] s390x: explicitly mark stack as not executable
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169380965283.97137.623872032086698797@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 04 Sep 2023 08:40:52 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kOnGeAwRR8z-kP7euWzERHmAlyvNVzfQ
X-Proofpoint-ORIG-GUID: UM3Rc0pqDTTlEYYccLKJiVXuh5HGUdjQ
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_03,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1011
 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309040058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-08-13 11:50:00)
> On 09/08/2023 11.17, Nico Boehr wrote:
> > With somewhat recent GCC versions, we get this warning on s390x:
> >=20
> >    /usr/bin/ld: warning: s390x/cpu.o: missing .note.GNU-stack section i=
mplies executable stack
> >    /usr/bin/ld: NOTE: This behaviour is deprecated and will be removed =
in a future version of the linker
> >=20
> > We don't really care whether stack is executable or not since we set it
> > up ourselves and we're running DAT off mostly anyways.
> >=20
> > Silence the warning by explicitly marking the stack as not executable.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   s390x/Makefile | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 706be7920406..afa47ccbeb93 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -79,7 +79,7 @@ CFLAGS +=3D -O2
> >   CFLAGS +=3D -march=3DzEC12
> >   CFLAGS +=3D -mbackchain
> >   CFLAGS +=3D -fno-delete-null-pointer-checks
> > -LDFLAGS +=3D -nostdlib -Wl,--build-id=3Dnone
> > +LDFLAGS +=3D -nostdlib -Wl,--build-id=3Dnone -z noexecstack
>=20
> I already did a similar patch some weeks ago:
>=20
>   https://lore.kernel.org/kvm/20230623125416.481755-1-thuth@redhat.com/
>=20
> ... we need it for x86, too, so I guess I should go ahead and commit it -=
=20
> and ask Sean to respin his conflicting series.

Thanks!
