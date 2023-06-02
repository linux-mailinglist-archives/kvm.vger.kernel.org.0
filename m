Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF03471FC2C
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbjFBIfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 04:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbjFBIfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 04:35:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCE41A6;
        Fri,  2 Jun 2023 01:35:14 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3528YoSd001284;
        Fri, 2 Jun 2023 08:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : subject : to : message-id : date; s=pp1;
 bh=AYlE2ckZicrwBeBSD44mRTjRNZki4J+kBfs6/x22210=;
 b=n6pukZujTxQdBXU4ysvmp8MXKYOiXCjhNyag6vCrLPoipvcZTupHiXKrfo6o64MIMNfY
 eB+zw3FdDogCVoci4ngdpn8MPvT+4cp2TYb3aG8sbV877o6fF0QNxTdmcZ/2useSNgZl
 ry6BmFYZfFHC1Cwln2iYdVXei+r+UDFYA5o0BKv/nBpHw7W30a2dgBTj25Hp/C5p9TGQ
 lXjay/s7yK7VTommamJOgZbhIjLl/ASBewNrQZUU28fVe9fmCXn2ldixs+sjLC+E2iEe
 NhAcf1fkxFeXkR430b2bOdInxe1ZsuKXEUZjkKAQZkkPeNZnBR4lmqU2eK+WN9Qn/sLE 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qycr40fck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:35:13 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3528FlYP022181;
        Fri, 2 Jun 2023 08:35:13 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qycr40fc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:35:13 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3522YF0u007493;
        Fri, 2 Jun 2023 08:35:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qu9g5ae3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Jun 2023 08:35:11 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3528Z7vZ41878182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Jun 2023 08:35:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E3372004E;
        Fri,  2 Jun 2023 08:35:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EBC72004B;
        Fri,  2 Jun 2023 08:35:07 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.63.101])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  2 Jun 2023 08:35:07 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
References: <20230519112236.14332-1-pmorel@linux.ibm.com> <20230519112236.14332-3-pmorel@linux.ibm.com> <fa415627-bfff-cc18-af94-cf55632973d5@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v9 2/2] s390x: topology: Checking Configuration Topology Information
To:     Janosch Frank <frankja@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Message-ID: <168569490681.252746.1049350277526238686@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 02 Jun 2023 10:35:06 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L5P8PDPzIgca-HuPcu9iNsIVz1-9jS4h
X-Proofpoint-GUID: -H_X6gApacl4643mvnoHiodojJ0rFaFd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_05,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2306020061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-06-01 11:38:37)
[...]
> >   [topology]
> >   file =3D topology.elf
> > +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, orig=
in)
> > +# 1 CPU on socket 2
> > +extra_params =3D -smp 1,drawers=3D3,books=3D3,sockets=3D4,cores=3D4,ma=
xcpus=3D144 -cpu z14,ctop=3Don -device z14-s390x-cpu,core-id=3D1,entitlemen=
t=3Dlow -device z14-s390x-cpu,core-id=3D2,dedicated=3Don -device z14-s390x-=
cpu,core-id=3D10 -device z14-s390x-cpu,core-id=3D20 -device z14-s390x-cpu,c=
ore-id=3D130,socket-id=3D0,book-id=3D0,drawer-id=3D0 -append '-drawers 3 -b=
ooks 3 -sockets 4 -cores 4'
> > +
> > +[topology-2]
> > +file =3D topology.elf
> > +extra_params =3D -smp 1,drawers=3D2,books=3D2,sockets=3D2,cores=3D30,m=
axcpus=3D240  -append '-drawers 2 -books 2 -sockets 2 -cores 30' -cpu z14,c=
top=3Don -device z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core=
-id=3D2,entitlement=3Dlow -device z14-s390x-cpu,drawer-id=3D1,book-id=3D0,s=
ocket-id=3D0,core-id=3D3,entitlement=3Dmedium -device z14-s390x-cpu,drawer-=
id=3D1,book-id=3D0,socket-id=3D0,core-id=3D4,entitlement=3Dhigh -device z14=
-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D5,entitlement=
=3Dhigh,dedicated=3Don -device z14-s390x-cpu,drawer-id=3D1,book-id=3D0,sock=
et-id=3D0,core-id=3D65,entitlement=3Dlow -device z14-s390x-cpu,drawer-id=3D=
1,book-id=3D0,socket-id=3D0,core-id=3D66,entitlement=3Dmedium -device z14-s=
390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D67,entitlement=
=3Dhigh -device z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-=
id=3D68,entitlement=3Dhigh,dedicated=3Don
>=20
> Pardon my ignorance but I see z14 in there, will this work if we run on=20
> a z13?

It causes a skip, I reproduced this on a z14 by changing to z15:
SKIP topology (qemu-system-s390x: unable to find CPU model 'z15')

If we can make this more generic so the tests run on older machines it woul=
d be
good, but if we can't it wouldn't break (i.e. FAIL) on older machines.

> Also, will this work/fail gracefully if the test is run with a quemu=20
> that doesn't know about topology or will it crash?

Just tried on my box, skips with:
SKIP topology (qemu-system-s390x: Parameter 'smp.books' is unexpected)

So I think we're good here.
