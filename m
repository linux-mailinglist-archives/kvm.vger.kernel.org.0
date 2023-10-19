Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3E57CF5D3
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 12:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345336AbjJSKvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 06:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbjJSKvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 06:51:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BD618F
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 03:51:03 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JAjE7B014932;
        Thu, 19 Oct 2023 10:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=AUDwkUYuvTDQtfc9fT/M2WzR9daZ6u0+HJ35LnhhjeY=;
 b=Dek36EqrXhw4S3SubgqJ4avjeS2UBZCbLrvnwegBEIY4Y1+ixig2Xb7kvM2PxXa7kX7V
 QY2a6ZIWEDO+YZLVuws8wr+QuM9y+KQlllTHEAgGeDtXezNM7OVwXUtAuCd/B70LmJpS
 lC44ZGDGuFm8ECDd7cYe8YWNuzbsX3M2RikgFGxgPqGRxftEUiHECXhnx3qWQQy9Yomu
 pjtZZEk+GpLODMytqKWOtCZcnY1bnQ4zZjydG007E0yNmLP/e4WinGVJRs1JCsfY4BUk
 W4uDIr371IHR47SVBwyMXq43ykjYN3GivEtP/+JPLSasfahihlnzrJabcvXUFBgZJtiA Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu2yn035g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 10:50:56 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39JAlf3m024818;
        Thu, 19 Oct 2023 10:50:56 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu2yn034x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 10:50:56 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39JAiedP012876;
        Thu, 19 Oct 2023 10:50:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tr5pyrdqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 10:50:55 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39JAoqU524380002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 10:50:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E5072004E;
        Thu, 19 Oct 2023 10:50:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7AB320043;
        Thu, 19 Oct 2023 10:50:51 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.84])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Oct 2023 10:50:51 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231011085635.1996346-9-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com> <20231011085635.1996346-9-nsg@linux.ibm.com>
To:     Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 8/9] scripts: Implement multiline strings for extra_params
Message-ID: <169771265170.80077.4366013508884229494@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 19 Oct 2023 12:50:51 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BUOTmwckPlm7a6l6hMa4Y7_T1GITYzQd
X-Proofpoint-ORIG-GUID: E99EkqjW6B_acjX75rO8cm5eVMVZ1SpQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_08,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 malwarescore=0 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:31)
> Implement a rudimentary form only.
> extra_params can get long when passing a lot of arguments to qemu.
> Multiline strings help with readability of the .cfg file.
> Multiline strings begin and end with """, which must occur on separate
> lines.
>=20
> For example:
> extra_params =3D """-cpu max,ctop=3Don -smp cpus=3D1,cores=3D16,maxcpus=
=3D128 \
> -append '-drawers 2 -books 2 -sockets 2 -cores 16' \
> -device max-s390x-cpu,core-id=3D31,drawer-id=3D0,book-id=3D0,socket-id=3D=
0"""
>=20
> The command string built with extra_params is eval'ed by the runtime
> script, so the newlines need to be escaped with \.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>=20
>=20
> This could certainly be done differently, suggestions welcome.

I honestly do not have a better idea. If someone has, please bring it up!

[...]
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 7b983f7d..738e64af 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -36,6 +36,17 @@ function for_each_unittest()
>                         kernel=3D$TEST_DIR/${BASH_REMATCH[1]}
>                 elif [[ $line =3D~ ^smp\ *=3D\ *(.*)$ ]]; then
>                         smp=3D${BASH_REMATCH[1]}
> +               elif [[ $line =3D~ ^extra_params\ *=3D\ *'"""'(.*)$ ]]; t=
hen
> +                       opts=3D${BASH_REMATCH[1]}$'\n'
> +                       while read -r -u $fd; do

I was actually unaware that read saves into REPLY by default and went
looking for the REPLY variable to no avail. Can we make this more explicit
like so:

while read -r -u $fd LINE; do

and replace REPLY with LINE below?

> +                               opts=3D${opts%\\$'\n'}

So we strip the \ at the end of the line, but if it's not there we preserve
the line break? Is there a reason to do it this way? Why do we need the \
at all, as far as I can see """ terminates the multi line string, so what's
the purpose?

Did you test this in standalone mode?
