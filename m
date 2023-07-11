Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661FA74F248
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjGKOcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjGKOcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:32:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C8EF4;
        Tue, 11 Jul 2023 07:31:56 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEVkNw005194;
        Tue, 11 Jul 2023 14:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9ZAVi6KiU/ro/z+p6FjNut0qxPvIL3XbeOtGZatE0Io=;
 b=SZQLnI57GBZIxjTJMUb8Nfoe8TwYYannXVn6Qs4T2T9VetR0+sVdnnPXBQVQfKH7lhFo
 LRqmLH6oGTkQHBE7BzScclxFRiG0PgGS5MTkS5hhfa4kSsg/T4q2dsD1yYI9teTFwjCA
 n7V1RU8x/sIsXEs0baPWXTx/OEAKj9iJgRaOc4k/Yk75Y4/dRwpVIdFt7wbkPisfY4c0
 vuEQmE5QXVdFI+KZ5yAh6zZQu62eIKZwdsZLtLIFwTjIHFCjFX/BROASSND9PkcNtuQE
 wKVgTYhpL2T0KPQgH3OkxV8qx6E3b2kkvx2AnMaR7C+7Bz2CxAScq+6JBISukZqcat1S PA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8wur081-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:31:55 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BAl28h009204;
        Tue, 11 Jul 2023 14:31:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rpye51c8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:31:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEVmNp15794878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:31:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D65420040;
        Tue, 11 Jul 2023 14:31:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8A6220049;
        Tue, 11 Jul 2023 14:31:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:31:47 +0000 (GMT)
Date:   Tue, 11 Jul 2023 16:31:46 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, frankja@linux.ibm.com,
        mhartmay@linux.ibm.com, nsg@linux.ibm.com, borntraeger@de.ibm.com,
        nrb@linux.ibm.com
Subject: Re: [PATCH v2 2/2] KVM: s390: pv: fix index value of replaced ASCE
Message-ID: <20230711163146.557e9d75@p-imbrenda>
In-Reply-To: <dba58cf1-59ed-f1f3-fdbe-59d213f0a7b5@linaro.org>
References: <20230705111937.33472-1-imbrenda@linux.ibm.com>
        <20230705111937.33472-3-imbrenda@linux.ibm.com>
        <dba58cf1-59ed-f1f3-fdbe-59d213f0a7b5@linaro.org>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZBw8A1FRQ1_ZGYCeZHiP55nMwpdpnDNq
X-Proofpoint-ORIG-GUID: ZBw8A1FRQ1_ZGYCeZHiP55nMwpdpnDNq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=971
 impostorscore=0 mlxscore=0 clxscore=1011 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jul 2023 16:12:54 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> wrote:

> On 5/7/23 13:19, Claudio Imbrenda wrote:
> > The index field of the struct page corresponding to a guest ASCE should
> > be 0. When replacing the ASCE in s390_replace_asce(), the index of the
> > new ASCE should also be set to 0.
> >=20
> > Having the wrong index might lead to the wrong addresses being passed
> > around when notifying pte invalidations, and eventually to validity
> > intercepts (VM crash) if the prefix gets unmapped and the notifier gets
> > called with the wrong address. =20
>=20
> Can that also happen in crst_table_alloc()?

no. ->index is only used for gmap page tables (guest mapping), from
the root to pmd tables. the last level (ptes) is shared between guest
mapping and QEMU address space. i.e. the ptes are the ones from QEMU.

the last level of page tables is not expected to have ->index set
(since that one actually belongs to QEMU and not to the guest mapping)

guest page tables (all levels, except ptes) are allocated with
gmap_alloc_table(), which correctly sets ->index

the top level of a guest mapping is allocated in gmap_alloc(), which
also correctly sets ->index to 0.

>=20
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   arch/s390/mm/gmap.c | 1 +
> >   1 file changed, 1 insertion(+) =20
>=20
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

thank you!
=20

