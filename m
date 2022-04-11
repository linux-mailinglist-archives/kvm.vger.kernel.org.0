Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542CB4FBE57
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346948AbiDKOIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 10:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346922AbiDKOIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 10:08:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC603299B;
        Mon, 11 Apr 2022 07:05:56 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BDCDTO007735;
        Mon, 11 Apr 2022 14:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QflFRNbJ85d3PHgxQXbyj1YhbE8+j4XZcSBSeBaTIT0=;
 b=XgyqQmJx9/2rokN0LtTDOEnSM0hHBmmK66zN/jnTYLljuNave6YJyzhNyfxBXqzZNmv2
 uF6f5wtI+HXazZZmAPrQcREhe5aX/eCf8sZJGgMzTppQmLpmY680adgs53ItIv6HwNTw
 OOe48SIvJJigwR13+IsJWGuGopvNz+Wn85Mkf8aNNOys3ypMRsn17+9OYTVtQfWJfTRs
 sGnwwzJsk/sFq1yeBaYxwRmHi7r6KU/U/4xsijwTTL3Fam96iQJp/Rigivccb9B4B/OI
 pvo089mKe0DjVWIdks+0FVi0cRZ3q54djNeHE/Umayy5LyuQjSOwovQAkjJV4F6NNl2v XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcn0c17gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 14:05:55 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BDEVvF018336;
        Mon, 11 Apr 2022 14:05:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcn0c17fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 14:05:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BE3qYf010096;
        Mon, 11 Apr 2022 14:05:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3fb1s8u8kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 14:05:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BE5nYr43909614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 14:05:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACBD1A405B;
        Mon, 11 Apr 2022 14:05:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51FA5A405F;
        Mon, 11 Apr 2022 14:05:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.140])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 14:05:49 +0000 (GMT)
Date:   Mon, 11 Apr 2022 16:05:46 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: add test for SIGP
 STORE_ADTL_STATUS order
Message-ID: <20220411160546.746204c2@p-imbrenda>
In-Reply-To: <243cc4903700b39072a20636f2433d43320fe4c2.camel@linux.ibm.com>
References: <20220401123321.1714489-1-nrb@linux.ibm.com>
        <20220401123321.1714489-3-nrb@linux.ibm.com>
        <20220406153107.0b071dcc@p-imbrenda>
        <243cc4903700b39072a20636f2433d43320fe4c2.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ILZgtFjTWqopU4nnpyuEBBOkHfRHL6Tk
X-Proofpoint-ORIG-GUID: Cl9JY7oHSIf-cyXNiiSCFNtGrGIhF0rA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Apr 2022 15:23:17 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Wed, 2022-04-06 at 15:31 +0200, Claudio Imbrenda wrote:
> > > diff --git a/s390x/adtl-status.c b/s390x/adtl-status.c
> > > new file mode 100644
> > > index 000000000000..c3ecdbc35a9d
> > >  =20
> [...]
> > > +static void restart_write_vector(void)
> > > +{
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint8_t *vec_reg;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* vlm handles at most 16 =
registers at a time */
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint8_t *vec_reg_16_31 =3D=
 &expected_vec_contents[16][0];
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint64_t cr0, cr0_mask =3D=
 ~(1ULL << CTL0_VECTOR); =20
> >=20
> > cr0_mask can be const, and you can use ~BIT_ULL(CTL0_VECTOR) =20
>=20
> I don't think so, since ng in the inline ASM will store its result
> there.

oops, right

>=20
> BIT_ULL is much better, thanks. I tend to forget about that.
>=20
> >  =20
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int one =3D 1; =20
> >=20
> > one can also be const, although I wonder if this can just become an
> > constant in the asm statement =20
>=20
> Yes, right, thanks. Should work with mvhi.
>=20

