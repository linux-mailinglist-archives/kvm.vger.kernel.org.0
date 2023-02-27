Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801E96A4209
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 13:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjB0Mvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 07:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0Mvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 07:51:54 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31E113D4B
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 04:51:52 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RAxjjL026690;
        Mon, 27 Feb 2023 12:51:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cduFZsxbHCwIMqUUdtVBrltvaeYrlg4SYyh56QtzuDg=;
 b=rtuaZ5d2EznAa+7KYVz4znyNTYfOn6eTg/102Y/pRg0N2+TZrRHw2/x826N8/V2zNL54
 EEtEAdd1x53yQNUtGQHH4E8mbxxBZwmj+FF1qO5XI2i095NMHQzDh+DkPugiNCzaxOpM
 iy+s5mmHE0HUgdlZD+a/nSFZSg2hDLllZRLjRFmiMDIuI0j20Uq9TsZnTtxj+pXFLVs4
 8oHf0QAMmMaQ+lYuW+p0jLOybyUK3H1b31hQPrwtOYzlYKjVlDMna+QU6rXO38D/n7g5
 n1SczxHoZJbMP6pWfNniIgK4czdYBH1bLeNyJ6E8SIW77xOSYt6VWvXp58N4mFzVnxg0 ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0u8qtpww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 12:51:38 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RBlg62024254;
        Mon, 27 Feb 2023 12:51:38 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0u8qtpq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 12:51:38 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31R4D83f031070;
        Mon, 27 Feb 2023 12:51:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3nybdfsefp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 12:51:23 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31RCpKrZ61800788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 12:51:20 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 118D120043;
        Mon, 27 Feb 2023 12:51:20 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CAD120040;
        Mon, 27 Feb 2023 12:51:19 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.148.35])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Feb 2023 12:51:19 +0000 (GMT)
Message-ID: <d8da6f7d1e3addcb63614f548ed77ac1b8895e63.camel@linux.ibm.com>
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
 monitor command
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 27 Feb 2023 13:51:19 +0100
In-Reply-To: <87v8jnqorg.fsf@pond.sub.org>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
         <20230222142105.84700-9-pmorel@linux.ibm.com>
         <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
         <0a93eb0e-2552-07b7-2067-f46d542126f4@redhat.com>
         <9e1cbbe11ac1429335c288e817a21f19f8f4af87.camel@linux.ibm.com>
         <87v8jnqorg.fsf@pond.sub.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y3-cCLFJ0hg8pXB5Np8e2y6j0ZCyYwR6
X-Proofpoint-GUID: D0OYw_YqB4zz-QV1Jqu5FvBI4kOSlMA_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=618 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302270097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-27 at 13:25 +0100, Markus Armbruster wrote:
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:
>=20
> > On Mon, 2023-02-27 at 08:59 +0100, Thomas Huth wrote:
>=20
> [...]
>=20
> > > I'm not sure whether double inclusion works with the QAPI parser (sin=
ce this=20
> > > might code to be generated twice) ... have you tried?
> >=20
> > I haven't, the documentation says:
> >=20
> > > Include directives
> > > ------------------
> > >=20
> > > Syntax::
> > >=20
> > >     INCLUDE =3D { 'include': STRING }
> > >=20
> > > The QAPI schema definitions can be modularized using the 'include' di=
rective::
> > >=20
> > >  { 'include': 'path/to/file.json' }
> > >=20
> > > The directive is evaluated recursively, and include paths are relativ=
e
> > > to the file using the directive.  Multiple includes of the same file
> > > are idempotent.
> >=20
> > Which is why I thought it should work, but I guess this is a statement =
about
> > including the same file twice in another file and not about including t=
he same
> > file from two files.
>=20
> No, this is intended to say multiple inclusion is fine, regardless where
> the include directives are.
>=20
> An include directive has two effects:
>=20
> 1. If the included file has not been included already, pull in its
>    contents.
>=20
> 2. Insert #include in generated C.  Example: qdev.json includes
>    qom.json.  The generated qapi-*-qdev.h include qapi-types-qom.h.
>=20
>    Including any required modules, as recommended by qapi-code-gen.rst,
>    results in properly self-contained generated headers.

Ok, thanks. Not sure if another phrasing would be better given the intended
meaning is the way I read it initially.

>=20
> > But then, as far as I can tell, the build system only builds qapi-schem=
a.json,
> > which includes all other files, so it could apply.
>=20
> Yes, qapi-schema.json is the main module, which includes all the others.
>=20
> In fact, it includes all the others *directly*.  Why?
>=20
> We generate documentation in source order.  Included material gets
> inserted right at the first inclusion; subsequent inclusions have no
> effect.
>=20
> If we put all first inclusions right into qapi-schema.json, the order of
> things in documentation is visible right there, and won't change just
> because we change inclusions deeper down.
>=20
> Questions?

CpuS390Entitlement would be useful in both machine.json and machine-target.=
json
because query-cpu-fast is defined in machine.json and set-cpu-topology is d=
efined
in machine-target.json.
So then the question is where best to define CpuS390Entitlement.
In machine.json and include machine.json in machine-target.json?
Or define it in another file and include it from both?

Thanks



