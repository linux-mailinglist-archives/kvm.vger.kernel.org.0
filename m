Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CE06FAFE6
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 14:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbjEHMZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 08:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbjEHMZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 08:25:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E7335DAB;
        Mon,  8 May 2023 05:25:34 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348CMNwW002009;
        Mon, 8 May 2023 12:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=uA54PaQAN5ekMzE0AQ2nt9KgYoJKqsoKarWhe35nKm0=;
 b=Eg7p12mfvpxFWonXFSX3XvfljnDnp+rtEJzGibygALTafGuBdYE9aogj8hMala9XCd0+
 6JUPv0nfh369U+siUyrI2Jh0QR/Y7sep5oM0s8WrjejQ+/BkzWF9nL5hVRAyI7xGGeeF
 HGV8IXmfHdKF1XD6m2oXKknGfeKqXcAg0i2yX0XqywKai1YhDvy7bRQSsrxqBEnDg150
 wipEfP5TIlqPu2tbtUK0tCxuqY5wx/Gx9g7D+/Y/EakiBiA71e57VizuTak/HCT0CZva
 xMso0lQFWKz4lWi+OT8P3M1hupJwlJRlgx0065FlYMBHdqqwLPhQ26SKF8arxhhEIO8C 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf11a81qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 12:25:33 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 348CNVAt005701;
        Mon, 8 May 2023 12:25:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf11a81qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 12:25:32 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3483oFcu004445;
        Mon, 8 May 2023 12:25:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qdeh6h3jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 12:25:31 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348CPRfv9765466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 12:25:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1FBB2004F;
        Mon,  8 May 2023 12:25:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4148F20040;
        Mon,  8 May 2023 12:25:27 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.71.193])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  8 May 2023 12:25:27 +0000 (GMT)
Message-ID: <3e3cc7dc5a77040f379e90162f76e285839f083f.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] lib: s390x: mmu: fix conflicting
 types for get_dat_entry
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Mon, 08 May 2023 14:25:26 +0200
In-Reply-To: <20230508102426.130768-1-nrb@linux.ibm.com>
References: <20230508102426.130768-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QxiknfpdZ01fYYYHh2YrULvQowPfrFSd
X-Proofpoint-GUID: dzAbeehNkIHiC7lPf2NOl3UdoQT-hchX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305080082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-05-08 at 12:24 +0200, Nico Boehr wrote:
> This causes compilation to fail with GCC 13:
>=20
> gcc -std=3Dgnu99 -ffreestanding -I/kut/lib -I/kut/lib/s390x -Ilib -O2 -ma=
rch=3DzEC12 -mbackchain -fno-delete-null-pointer-checks -g -MMD -MF lib/s39=
0x/.mmu.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-bo=
dy -Wuninitialized -Wignored-qualifiers -Wno-missing-braces -Werror  -fomit=
-frame-pointer  -fno-stack-protector    -Wno-frame-address   -fno-pic  -no-=
pie  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wo=
ld-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototyp=
es -I/kut/lib -I/kut/lib/s390x -Ilib  -c -o lib/s390x/mmu.o lib/s390x/mmu.c
> lib/s390x/mmu.c:132:7: error: conflicting types for =E2=80=98get_dat_entr=
y=E2=80=99 due to enum/integer mismatch; have =E2=80=98void *(pgd_t *, void=
 *, enum pgt_level)=E2=80=99 [-Werror=3Denum-int-mismatch]
>   132 | void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level l=
evel)
>       |       ^~~~~~~~~~~~~
> In file included from lib/s390x/mmu.c:16:
> lib/s390x/mmu.h:96:7: note: previous declaration of =E2=80=98get_dat_entr=
y=E2=80=99 with type =E2=80=98void *(pgd_t *, void *, unsigned int)=E2=80=
=99
>    96 | void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int lev=
el);
>       |       ^~~~~~~~~~~~~
>=20
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  lib/s390x/mmu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> index 15f88e4f424e..dadc2e600f9a 100644
> --- a/lib/s390x/mmu.h
> +++ b/lib/s390x/mmu.h
> @@ -93,6 +93,6 @@ static inline void unprotect_page(void *vaddr, unsigned=
 long prot)
>  	unprotect_dat_entry(vaddr, prot, pgtable_level_pte);
>  }
>=20
> -void *get_dat_entry(pgd_t *pgtable, void *vaddr, unsigned int level);
> +void *get_dat_entry(pgd_t *pgtable, void *vaddr, enum pgt_level level);
>=20
>  #endif /* _ASMS390X_MMU_H_ */

