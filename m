Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E0A718207
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 15:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbjEaNgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjEaNgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 09:36:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE19DC0;
        Wed, 31 May 2023 06:36:49 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VDGd8D027853;
        Wed, 31 May 2023 13:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=278oxwc42MF8qvWbiVtT1x5VRhiFGPiUPLXlAgzrKZc=;
 b=egetVAZUdsaRryLRYABCUmNnxNs+HJF8n768iGoqYj07bgwgA4TxZuAurfEqyLX4bhn0
 YUS/UvPjGdkYc88k4GahKUXJxqYLwHDziWXWOuP6Ys0tnBeAb2bYX3rLu/ok3MdtgfN4
 n2fmbQz6W1gJUrKEl+61rETjYhXKiZ0uvw4Kub6CrfCz6km8hq9uDe4kUXv5D8+v2cGN
 rRPC6KzORoXGPhz8O4055QPjTWIefUfy/avVYC+ZALLvXK2p/SDjpXeIuRtVqzjvArwM
 u06ob50Fkk+xI+JIqFWbrH1SAQX2tbSWRv76bn7P75IjUPF4PJGZLorDbGNnZrtC3Cky vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx4y3mr0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 13:36:48 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VD9Ou0002474;
        Wed, 31 May 2023 13:36:47 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx4y3mqye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 13:36:47 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34VCa1DT022759;
        Wed, 31 May 2023 13:36:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qu94e9pg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 13:36:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VDafLr44826996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 13:36:41 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E11720043;
        Wed, 31 May 2023 13:36:41 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72E6E20040;
        Wed, 31 May 2023 13:36:41 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.88.234])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 13:36:41 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230421113647.134536-2-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com> <20230421113647.134536-2-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/7] lib: s390x: uv: Introduce UV validity function
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168554020111.164254.15682688367711474887@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 31 May 2023 15:36:41 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tt-dtTb-yfu0E_X8KubpkcbHq-KuNLO2
X-Proofpoint-ORIG-GUID: 8dodWGppsalfE-y2dms1X2kRB5XwBMdd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_08,2023-05-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-04-21 13:36:41)
> PV related validities are in the 0x20** range but the last byte might
> be implementation specific, so everytime we check for a UV validity we
> need to mask the last byte.
>=20
> Let's add a function that checks for a UV validity and returns a
> boolean.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/uv.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> index 5fe29bda..78b979b7 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -35,4 +35,11 @@ static inline void uv_setup_asces(void)
>         lctlg(13, asce);
>  }
> =20
> +static inline bool uv_validity_check(struct vm *vm)
> +{
> +       uint16_t vir =3D sie_get_validity(vm);
> +
> +       return vm->sblk->icptcode =3D=3D ICPT_VALIDITY && (vir & 0xff00) =
=3D=3D 0x2000;
> +}
> +

I noticed a small issue with this. If no intercept occurs, we sie_get_valid=
ity()
will be called which will assert() when there's none.

Please consider the following fixup (broken whitespace ahead):

 static inline bool uv_validity_check(struct vm *vm)
 {
-       uint16_t vir =3D sie_get_validity(vm);
+       uint16_t vir;

-       return vm->sblk->icptcode =3D=3D ICPT_VALIDITY && (vir & 0xff00) =
=3D=3D 0x2000;
+       /* must not use sie_get_validity() when there's no validity */
+       if (vm->sblk->icptcode !=3D ICPT_VALIDITY)
+               return false;
+       vir =3D sie_get_validity(vm);
+
+       return (vir & 0xff00) =3D=3D 0x2000;
 }

