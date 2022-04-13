Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2E44FF260
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 10:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiDMIpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 04:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiDMIp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 04:45:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECA34EA25;
        Wed, 13 Apr 2022 01:43:09 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23D7UiFQ022745;
        Wed, 13 Apr 2022 08:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+ynYSt7fhnh9Jemh2uoB5LHRICHtdQIhMtbWjO3umhg=;
 b=rePP4AxPrrpb/0R1DlhNpgtZCW3Fd8vKnXZMksgOUDi6TgEI1c3opPOtF7GB2vzxldty
 q6a9B50x7gDQtqH7jeeqQWzydNCTnifwJI91Glf6vJc2MeEWWx30Zzp0TTbU1ygLg771
 nCm1GQTE6HW/O36yRB0dGOVHT8o0Y4AjEglLFML/BcR+frW8ugPk3GgpYR2UXwU95GLl
 QoI2wbArN2ElSv1zcCxjsnAHzJ3xZUqya5DOetSRvJVqy4Om+GTAmXEbTHlgJHxR0Nbr
 CXsD8xLOP2S43cHGG0BZY4iPYq74rZx5vzNThking5zU1JgVIinRSiLAIcLHFS8UyvGu LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdpjhdg6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 08:43:08 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23D8Y7P9011011;
        Wed, 13 Apr 2022 08:43:07 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fdpjhdg6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 08:43:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23D8Y8X5007897;
        Wed, 13 Apr 2022 08:43:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3fb1s8xd2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 08:43:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23D8UVfs44106114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Apr 2022 08:30:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62A2BAE053;
        Wed, 13 Apr 2022 08:43:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 164A0AE051;
        Wed, 13 Apr 2022 08:43:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Apr 2022 08:43:02 +0000 (GMT)
Date:   Wed, 13 Apr 2022 10:42:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add selftest for migration
Message-ID: <20220413104259.21553d56@p-imbrenda>
In-Reply-To: <627b95549636e5fb4bae5ba792298eee0a689b13.camel@linux.ibm.com>
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
        <20220411100750.2868587-5-nrb@linux.ibm.com>
        <20220411144944.690d19f5@p-imbrenda>
        <627b95549636e5fb4bae5ba792298eee0a689b13.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XvftImeOoHoZEsN4dccCWOM-4SmCk31D
X-Proofpoint-ORIG-GUID: iXDMrxN2z59rvjIKIaRo-spx5MfJ-uer
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_08,2022-04-12_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=867 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204130048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Apr 2022 13:49:21 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Mon, 2022-04-11 at 14:49 +0200, Claudio Imbrenda wrote:
> [...]
> > > diff --git a/s390x/selftest-migration.c b/s390x/selftest-
> > > migration.c =20
> [...]
> > > +int main(void)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* don't say migrate here =
otherwise we will migrate right
> > > away */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_push("selfte=
st migration");
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* ask migrate_cmd to migr=
ate (it listens for 'migrate') */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0puts("Please migrate me\n"=
);
> > > +
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* wait for migration to f=
inish, we will read a newline */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(void)getchar(); =20
> >=20
> > how hard would it be to actually check that you got the newline? =20
>=20
> It would be simple. I decided for ignoring what we actually read
> because that's what ARM and PPC do.

oh, then it's fine as it is

>=20
> But I am also OK checking we really read a newline. What would you
> suggest to do if we read something that's not a newline? Read again
> until we actually do get a newline?

I was more thinking that it's a failure, but see the comment above
