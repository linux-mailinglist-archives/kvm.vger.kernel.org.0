Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BA55F5606
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 16:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJEOA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 10:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiJEOAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 10:00:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7626DADE
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 07:00:52 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295Dfdhn006009
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 14:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=bLhRXTevQoIzZqZQfd/bvaToXEEUafuUd9NGgQs3dOA=;
 b=gNkna40ryY2Ms4LlsiOZYLoQ5XtFjvLT9Z3Fw9r+piOusHsylqRuzZejM/s0yzEDFi7W
 jDe0iFH8X/rRBn36KWcHJNH/RL7rojWoRep1uc3jPKoh+PxGQTmSJGWPIH9R1T6nQImb
 pfiifAk9VlxnjDoyCUY+r+pyIW/jmWue7GSCsQ+QHavGxYLSY9awdKqhV04JSMqlis9B
 sBVXd0P7sAO4JazjIXb6ltOFQmRM7Xh7xBLLrUM7uoNqIpNcnfrDhdP6HBbNmrihcbhF
 pUAeMMI++1lFgjpjIq6TohcKkoTw2ZkxdSzJhVD2FSflhDVPSdsxO0JEuF1y0tJOIpTC lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0hc0ub9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 14:00:51 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 295Dgr4d010175
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 14:00:51 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0hc0ub8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:00:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295Dq5xe029688;
        Wed, 5 Oct 2022 14:00:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3jxctj5ng9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Oct 2022 14:00:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295E1Gni45023642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 14:01:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B080A4054;
        Wed,  5 Oct 2022 14:00:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 391F9A405B;
        Wed,  5 Oct 2022 14:00:46 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 14:00:46 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9314c772-c2d0-2b3a-dc8c-b4294f830938@redhat.com>
References: <20220512093523.36132-1-imbrenda@linux.ibm.com> <20220512093523.36132-3-imbrenda@linux.ibm.com> <f7b8977e-7cf3-f422-77fa-808d9049ffeb@redhat.com> <166497590219.75085.13496829953913366119@t14-nrb> <9314c772-c2d0-2b3a-dc8c-b4294f830938@redhat.com>
Subject: Re: [kvm-unit-tests GIT PULL 02/28] s390x: add test for SIGP STORE_ADTL_STATUS order
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166497844603.75085.4841041058892563374@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 05 Oct 2022 16:00:46 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3wEidgtWwSQEmIUMKom5VktQkZBkustc
X-Proofpoint-ORIG-GUID: 45BcHCPf-hBEGEs8O9HAUunQYxfxIXjP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_03,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-10-05 15:25:03)
> On 05/10/2022 15.18, Nico Boehr wrote:
> > Hi Thomas,
> >=20
> > Quoting Thomas Huth (2022-09-20 17:53:28)
> >> On 12/05/2022 11.34, Claudio Imbrenda wrote:
> >> [...]
> >>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> >>> index 743013b2..256c7169 100644
> >>> --- a/s390x/unittests.cfg
> >>> +++ b/s390x/unittests.cfg
> >>> @@ -146,3 +146,28 @@ extra_params =3D -device virtio-net-ccw
> >>>   =20
> >>>    [tprot]
> >>>    file =3D tprot.elf
> >>> +
> >>> +[adtl-status-kvm]
> >>> +file =3D adtl-status.elf
> >>> +smp =3D 2
> >>> +accel =3D kvm
> >>> +extra_params =3D -cpu host,gs=3Don,vx=3Don
> >>
> >> FWIW, on my z13 LPAR, I now see a warning:
> >>
> >> SKIP adtl-status-kvm (qemu-kvm: can't apply global host-s390x-cpu.gs=
=3Don:
> >> Feature 'gs' is not available for CPU model 'z13.2', it was introduced=
 with
> >> later models.)
> >>
> >> Could we silence that somehow?
> >=20
> > instead of a SKIP, what would you expect to see in this case? Or do you=
 mean the message inside the parenthesis?
>=20
> I meant the message inside the parenthesis ... but thinking about it twic=
e,=20
> it's maybe even useful to have it here ... so I'm also fine if we keep it=
.=20
> ... it's just a little bit long ...

We could have

cpu =3D host

in unittest.cfg for adtl-status-kvm.

But this would mean if the host doesn't support vector or gs, we would just=
 see

PASS adtl-status-kvm

with some skipped tests. So, to me, it feels like the current solution is b=
etter even if the error message is ugly and long.
