Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4715877C0
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiHBHX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiHBHXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:23:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51883D13A
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:23:53 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2727Kx3g013529
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:23:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=1wqfdxOedA2+aoZ327yxXWYfd/O8FsqIMjUM0v5B+Fk=;
 b=m3Gpj4XPReBIeISBNyoND1qycQ4vRsFFfmrguRP4ocu/SueEL88DoQTMR11hw7p5johT
 E/mpgk/wxt6MwngmIQF4M3Nl3F6RV0P11Ka79xo5EZnl07PKiJ+STMyCPJ+30WNF/bMf
 nrPUyWlbZJrLbVcsAOKAPeivN0oStnERM5TkGk1Bp9TfWPRdOOEyIPjOCLF/PQILEApn
 ny/YnDQUDRYwONljw5OKYZEwdCHMMk88qBDDaq1kBCVjgAIS0uwAXMZAO4BiR9/rfQzp
 Lk4pgSBkCybGRI4IBj7N4dLfEb7hUV1kStbhiFMbytiEUiIoSKjOc0YP6ijAYKT9yQ8W lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpyf4r2cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 07:23:52 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2727M4bE016595
        for <kvm@vger.kernel.org>; Tue, 2 Aug 2022 07:23:51 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hpyf4r2c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:23:51 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2727LaBr028529;
        Tue, 2 Aug 2022 07:23:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3hmv98tej7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:23:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2727NkLA23855596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Aug 2022 07:23:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B17D311C04C;
        Tue,  2 Aug 2022 07:23:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 963B711C04A;
        Tue,  2 Aug 2022 07:23:46 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.89.124])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Aug 2022 07:23:46 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220729082633.277240-5-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com> <20220729082633.277240-5-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 4/6] lib: s390x: sie: Improve validity handling and make it vm specific
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165942502640.253051.3127986017528310393@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 02 Aug 2022 09:23:46 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qE8RsTN3vrfVKVVCdlFTZFdxmehqJoRO
X-Proofpoint-GUID: xdLgHgZq1vfAwdHFnKyuWEupBiGV0a5L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_03,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=888 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208020033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2022-07-29 10:26:31)
> The current library doesn't support running multiple vms at once as it
> stores the validity once and not per vm. Let's move the validity
> handling into the vm and introduce a new function to retrieve the vir.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

One tiny suggestion below.

[...]
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 00aff713..c3a53ad6 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -15,19 +15,21 @@
>  #include <libcflat.h>
>  #include <alloc_page.h>
> =20
> -static bool validity_expected;
> -static uint16_t vir;           /* Validity interception reason */
> -
> -void sie_expect_validity(void)
> +void sie_expect_validity(struct vm *vm)
>  {
> -       validity_expected =3D true;
> -       vir =3D 0;
> +       vm->validity_expected =3D true;
>  }
> =20
> -void sie_check_validity(uint16_t vir_exp)
> +uint16_t sie_get_validity(struct vm *vm)
>  {
> +       return vm->sblk->ipb >> 16;
> +}

Since one should only call this function when we had a validity, maybe add:

assert (vm->sblk->icptcode =3D=3D ICPT_VALIDITY);
