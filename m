Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774275F5535
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 15:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJENSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 09:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJENS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 09:18:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4C72F2
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 06:18:28 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295D7vb4016392
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 13:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=HHCiryTH+0qfp1B3iLf3bYNGgc+78pxygnCqwoKsHtg=;
 b=edf8ueCIrUJ1rtkGor81ITPC3n62UZQ60it+H2Eq+di3NC4Sp1AhZgAXztw/YCwU1T7W
 xvgCKsjsnKQ2RnxV+i63xoUNl7opi+7Ax4FFaYPnfJY24V0xGICpHrE3SZVhtsCtIrQY
 yNMNc/FXjSXKxDdJs8AMvm8v7BeP/hTL0uy/8CgD+gjS89qDgx70bIcbx9EwGvfB85S0
 Vg8/MfKs2XItJytit/guJKUPkrXEbr3fStXQ0mFNS9x/Kc9ObF3VUpz1Cn5zHDaVrYCE
 LAKBP1NYkUTOSarnQgowf2QETd4IGVR0+ia1bRgCO1sKlQPGyKL4+oaCEdB05i+71b9k Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0hc0t3jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 13:18:27 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 295CfH2l006291
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 13:18:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0hc0t3j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 13:18:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295D6BEQ003415;
        Wed, 5 Oct 2022 13:18:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3jxd695k8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 13:18:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295DIMmI27722388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 13:18:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 898624C044;
        Wed,  5 Oct 2022 13:18:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FDE44C040;
        Wed,  5 Oct 2022 13:18:22 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 13:18:22 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <f7b8977e-7cf3-f422-77fa-808d9049ffeb@redhat.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com> <20220512093523.36132-3-imbrenda@linux.ibm.com> <f7b8977e-7cf3-f422-77fa-808d9049ffeb@redhat.com>
Subject: Re: [kvm-unit-tests GIT PULL 02/28] s390x: add test for SIGP STORE_ADTL_STATUS order
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166497590219.75085.13496829953913366119@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 05 Oct 2022 15:18:22 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jx_6lKY2SzcMwJAPTyF2bQbAYBbuzCei
X-Proofpoint-ORIG-GUID: NXbfg6Kw1epqEqaIx0Gm-zpbpd289xOL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Thomas,

Quoting Thomas Huth (2022-09-20 17:53:28)
> On 12/05/2022 11.34, Claudio Imbrenda wrote:
> [...]
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index 743013b2..256c7169 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -146,3 +146,28 @@ extra_params =3D -device virtio-net-ccw
> >  =20
> >   [tprot]
> >   file =3D tprot.elf
> > +
> > +[adtl-status-kvm]
> > +file =3D adtl-status.elf
> > +smp =3D 2
> > +accel =3D kvm
> > +extra_params =3D -cpu host,gs=3Don,vx=3Don
>=20
> FWIW, on my z13 LPAR, I now see a warning:
>=20
> SKIP adtl-status-kvm (qemu-kvm: can't apply global host-s390x-cpu.gs=3Don=
:=20
> Feature 'gs' is not available for CPU model 'z13.2', it was introduced wi=
th=20
> later models.)
>=20
> Could we silence that somehow?

instead of a SKIP, what would you expect to see in this case? Or do you mea=
n the message inside the parenthesis?

Nico
