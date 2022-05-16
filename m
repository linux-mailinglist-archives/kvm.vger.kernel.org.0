Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E1E527FD0
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 10:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241796AbiEPIh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 04:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238562AbiEPIh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 04:37:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04965E0B1;
        Mon, 16 May 2022 01:37:54 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G5prom034894;
        Mon, 16 May 2022 08:37:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/WFldQY47xtP9mdd9eNlQrzE0SUcOZLQILC4gROquFM=;
 b=ni0zT9V09fdOxaOnzIA07quBOz/g+DdKaXlcVvzhfD38F0BY1IRaJhCOLv/gBfYhzZIO
 zOX5ejeHYQEmFIuiXhkFZYx37YFfp+tggATCr8CWGI39pgM4cKs1EaQVol8zTRy+Udto
 rIg9kajppUFsaQhsdMWLRT9QUD+nuyyVmKqgdchAhoO3xCuB8H/fPelge9CnI0z7OUCY
 ub210DhdJi6rFnoImMvi+2G4o0TKYES5feLPh0UsvGq8PR7kdOvkFxGfk30VJFdBMNn7
 MerXjSEkgMw1iFQlAngfwmz4WDqgaC6lNOmnmoox2r+7oIPGjSFQQ19OSAH55MeJOQGz 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3gudjyqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:37:53 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G8Qkf8027858;
        Mon, 16 May 2022 08:37:53 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3gudjyqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:37:53 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G8bpse013613;
        Mon, 16 May 2022 08:37:51 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428ssp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:37:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G8bIKF23593286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 08:37:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B1974C046;
        Mon, 16 May 2022 08:37:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE7924C044;
        Mon, 16 May 2022 08:37:47 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.122])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 08:37:47 +0000 (GMT)
Message-ID: <86d8269b1ebab3aeb0fb1c569d4a32d2f5b69f02.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/6] s390x: uv-host: Add uninitialized UV
 tests
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Date:   Mon, 16 May 2022 10:37:47 +0200
In-Reply-To: <20220513095017.16301-3-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
         <20220513095017.16301-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Kus2ErU0Tzd-e7cFLPLxC59SAoznOi3q
X-Proofpoint-ORIG-GUID: ks9PLwxI2I-VxklsrK4RX0W6P_zMTOlF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 impostorscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-05-13 at 09:50 +0000, Janosch Frank wrote:
> Let's also test for rc 0x3
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
if you fix the nit below.

> ---
> =C2=A0s390x/uv-host.c | 78
> +++++++++++++++++++++++++++++++++++++++++++++++--
> =C2=A01 file changed, 76 insertions(+), 2 deletions(-)
>=20
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 0f0b18a1..f846fc42 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -83,6 +83,24 @@ static void test_priv(void)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_pop();
> =C2=A0}
> =C2=A0
> +static void test_uv_uninitialized(void)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct uv_cb_header uvcb =3D {=
};
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int i;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0report_prefix_push("uninitiali=
zed");
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* i =3D 1 to skip over initia=
lize */

Just say

if (cmds[i].cmd =3D=3D UVC_CMD_INIT_UV)
  continue;

inside the loop.

