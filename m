Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B925E6D69F3
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbjDDRNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 13:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbjDDRM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 13:12:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796BD106
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 10:12:49 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334GuUAc005162;
        Tue, 4 Apr 2023 17:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=DGU1sGBtrtSibyAD33kn/ZmkpHCjHHgGco09r2O2E1w=;
 b=DTJOmLp2K6vKUZmY6W6yKhW+SRw9Ycc8LSueocSzWP6fejrLBdnccODpf4pqQjvIHm5N
 py7Y6AyyY4w/5ifRdzZ8Q9jbf8BfBTQWl381YWo3C5bRA39Lb2U4sb+AmImaYgy/t65o
 5TtyqZl5wTMqMxacD51mBK30hKRbfshD7bMnO8v/tZGWlqr3sgQNPQMXbWeunaQOKEcc
 q3SqW3VJJabDjW1N4I030jgS2uJnjhW7S1sBQz078bTej2w4Bbv9l5EmCoJAju3LqORm
 qJMjMbL/59ZnBJaLA55W1CnGJ/B8g/dIYnicgdZghcBAqS7dmLgq9ubhRzwGFV3BzfXt bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prpwb23f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 17:12:46 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334H9ZfC031359;
        Tue, 4 Apr 2023 17:12:46 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prpwb23dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 17:12:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 333NQ6Hu016838;
        Tue, 4 Apr 2023 17:12:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc872nsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 17:12:43 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334HCeML47251794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 17:12:40 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77C1620049;
        Tue,  4 Apr 2023 17:12:40 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5717B20040;
        Tue,  4 Apr 2023 17:12:40 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.33.218])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 17:12:40 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <bf0f892e-7b7d-5806-b038-8392144da644@redhat.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com> <20230404113639.37544-12-nrb@linux.ibm.com> <65075e9f-0d32-fc63-0200-3a3ec0c9bf63@redhat.com> <06fd3ebc7770d1327be90cee10d12251cca76dd3.camel@linux.ibm.com> <bf0f892e-7b7d-5806-b038-8392144da644@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests GIT PULL v2 11/14] s390x: Add tests for execute-type instructions
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, andrew.jones@linux.dev,
        pbonzini@redhat.com
Message-ID: <168062836004.37806.6096327013940193626@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 04 Apr 2023 19:12:40 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2TOyB9HSdc0BvU_q9prV4-VDSX4bKMZN
X-Proofpoint-ORIG-GUID: VpR0pRFxbmvQyDssibxWPI_oNryZL8r9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_08,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040158
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-04-04 17:05:02)
[...]
> >> FWIW, this is failing with Clang 15 for me:
> >>
> >> s390x/ex.c:81:4: error: expected absolute expression
> >>                   "       .if (1b - 0b) !=3D (3b - 2b)\n"
> >>                    ^
> >> <inline asm>:12:6: note: instantiated into assembly here
> >>           .if (1b - 0b) !=3D (3b - 2b)
> >=20
> > Seems gcc is smarter here than clang.
>=20
> Yeah, the assembler from clang is quite a bit behind on s390x ... in the =

> past I was only able to compile the k-u-t with Clang when using the=20
> "-no-integrated-as" option ... but at least in the most recent version it=
=20
> seems to have caught up now enough to be very close to compile it with th=
e=20
> built-in assembler, so it would be great to get this problem here fixed=20
> somehow, too...

Bringing up another option: Can we maybe guard this section from Clang so w=
e still have the assertion when compiling with GCC?
