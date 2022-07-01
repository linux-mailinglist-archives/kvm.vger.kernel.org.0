Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03212562D9A
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 10:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiGAIRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 04:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbiGAIR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 04:17:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613E270AF2
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 01:17:26 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2618GR1s004902
        for <kvm@vger.kernel.org>; Fri, 1 Jul 2022 08:17:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=pNP/FrFO3XWJI0GhpQflluLdbr2PfubcaRnkaLoiA58=;
 b=gccgeJ/YD5XZg/8y8h6vDjxalfoWljbSGiOoYdLaiabDVjmCPfHkXCiO2THxGwg+LccZ
 Xo3aNVdZJyUVczkxfs0KcnmJoZsTNRsrWDjTrV6rVlEs/75N8CL5GpZ7lobzWPhIoCyX
 y23cDZpx0z8dJaWfzN8i6hpSMI92e54ExgGfbLRlmmmPuDeJOChj7NDy8yn8jA5eC7ie
 MjmV8prLnwr+sCp+hljCxrchi3OSq4HChTQyQSfsXrnx7I1PyoJbvLhsY68D6xE42iCd
 1xl2wogMsB7QChfOuawBREWnLNVIcf6+9+IWa/UNVho7lA4NFxRCCQ3gpNOOrci6314R yQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1w8wr0g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 08:17:25 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26186HZu027350
        for <kvm@vger.kernel.org>; Fri, 1 Jul 2022 08:17:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3gwt08y14d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 08:17:23 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2618HROf24248604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 08:17:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE5D9A4040;
        Fri,  1 Jul 2022 08:17:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3439A4053;
        Fri,  1 Jul 2022 08:17:19 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.42.232])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Jul 2022 08:17:19 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <069be6f0-2f3a-3fea-3eca-d42f99e98220@redhat.com>
References: <20220630113059.229221-1-nrb@linux.ibm.com> <20220630113059.229221-4-nrb@linux.ibm.com> <069be6f0-2f3a-3fea-3eca-d42f99e98220@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v1 3/3] s390x: add pgm spec interrupt loop test
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
To:     kvm@vger.kernel.org
Message-ID: <165666343873.83789.4449236370360446232@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 01 Jul 2022 10:17:18 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rGQAFnZJqgd_c6gVm4Dxh7thE5J3MPfo
X-Proofpoint-ORIG-GUID: rGQAFnZJqgd_c6gVm4Dxh7thE5J3MPfo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_05,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 mlxlogscore=292 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207010028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-06-30 19:25:57)
> On 30/06/2022 13.30, Nico Boehr wrote:
> > An invalid PSW causes a program interrupt. When an invalid PSW is
> > introduced in the pgm_new_psw, an interrupt loop occurs as soon as a
> > program interrupt is caused.
> >=20
> > QEMU should detect that and panick the guest, hence add a test for it.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> ....
> > +int main(void)
> > +{
> > +     report_prefix_push("pgmint-loop");
> > +
> > +     lowcore.pgm_new_psw.addr =3D (uint64_t) pgm_int_handler;
> > +     /* bit 12 set is invalid */
> > +     lowcore.pgm_new_psw.mask =3D extract_psw_mask() | BIT(63 - 12);
>=20
> Basically patch looks fine to me ... just an idea for an extension (but t=
hat=20
> could also be done later):
>=20
> Looking at the is_valid_psw() function in the Linux kernel sources, there=
=20
> are a couple of additional condition that could cause a PGM interrupt loo=
p=20
> ... you could maybe check them here, too, e.g. by adding a "extra_params =
=3D=20
> -append '...'" in the unittests.cfg file to select the indiviual tests vi=
a=20
> argv[] ?

It is a good idea, I have it on my TODO and will address it in a upcoming p=
atchset.
