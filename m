Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1319B5A95D8
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 13:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiIALiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 07:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbiIALiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 07:38:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA46B139D60
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 04:38:00 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281BHiC4009467
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 11:38:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : from : cc : message-id : date; s=pp1;
 bh=o7lrsfxQHIYVm97THchRzxII+7pokNlbs9+xOcTJwSk=;
 b=C5TS2xy6jJFUPeU2DZMseXv2VGl0ma1D5c1F71ksjEFoWmML79ZgdrbndoYnnozKenDw
 RyFVmgQPFVj6QRqBm0/HL9ILy2VlXaceXBgoLaqwvs9jS5INVmD/yjRf6E1IMSJsYBLs
 zqGvkmQRwWpOe7QtPoGD9AqQXSx60N1IS3jt8feuuUK1PblTnRId+NtGYTuhGMnJ/iNW
 h4UnCIkVOJksb8ayiZW7VnKjvCEUMoYfxWK973QCNJfZrYO6MADfXWSaR9lLCDGK7LIZ
 0LV8J9+T++ih87dKZhd5Bb3ImWtrLvwy2FF6PFkVsCRXHrqto186llKdZGBAyvLSZY2F 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jaur3gkqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 11:37:59 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 281BIKbZ013269
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 11:37:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jaur3gkpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 11:37:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 281Ba2M9008092;
        Thu, 1 Sep 2022 11:37:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3j7aw96pbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 11:37:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 281BbsOX42467630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Sep 2022 11:37:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A5BFA4054;
        Thu,  1 Sep 2022 11:37:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C220A405B;
        Thu,  1 Sep 2022 11:37:54 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Sep 2022 11:37:54 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <47fe3036-3566-0118-ac0c-86f4a0d1c838@redhat.com>
References: <20220830115623.515981-1-nrb@linux.ibm.com> <20220830115623.515981-3-nrb@linux.ibm.com> <47fe3036-3566-0118-ac0c-86f4a0d1c838@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add exittime tests
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
Message-ID: <166203227401.25136.16046934415525346231@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 01 Sep 2022 13:37:54 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z3qlbDnXlGd-Z5kJx0N3rowFcBVyEubd
X-Proofpoint-ORIG-GUID: yGMtW1dYcbjvFSv9dF7RRjEqcHa6oSY8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_08,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 adultscore=0 mlxscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-08-30 14:52:14)
> > diff --git a/s390x/exittime.c b/s390x/exittime.c
> > new file mode 100644
[...]
> > +static void test_nop(long ignore)
> > +{
> > +     asm volatile("nop" : : : "memory");
> > +}
>=20
> What's the purpose of testing "nop"? ... it does not trap to the=20
> hypervisor... ? Is it just for reference? Then a comment might be helpful=
 here.

Yes, the idea is to have some reference for a non-trapping instruction. Add=
ed a comment.

[...]
> > +static void test_diag44(long ignore)
> > +{
> > +     asm volatile("diag 0,0,0x44" : : : );
>=20
> Drop the " : : : " please.

OK

> > +static void test_stnsm(long ignore)
> > +{
> > +     int out;
> > +
> > +     asm volatile(
> > +             "stnsm %[out],0xff"
> > +             : [out] "=3DQ" (out)
> > +             :
> > +             : "memory"
>=20
> I don't think you need the "memory" clobber here, do you?

Uhm, yes, right. Good thing we have reviews. :-)

[...]
> > +static void test_stpx(long ignore)
> > +{
> > +     unsigned int prefix;
> > +
> > +     asm volatile(
> > +             "stpx %[prefix]"
> > +             : [prefix] "=3DS" (prefix)
>=20
> STPX seems to have only a short displacement, so it should have "=3DQ" in=
stead=20
> of "=3DS" ?

Yes, right, fixed. Also the memory clobber is unneeded. I think I will do t=
hrough all the clobbers and constraint once more, seems like I messed up a =
bit there.

[...]
> > +struct test {
> > +     char name[100];
>=20
> "const char *name" instead of using an array here, please. Otherwise this=
=20
> wastes a lot of space in the binary.

Makes sense, thanks.
