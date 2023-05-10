Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110DC6FD823
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 09:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbjEJH2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 03:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbjEJH2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 03:28:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FFA7A9F;
        Wed, 10 May 2023 00:28:23 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34A7R1Th009075;
        Wed, 10 May 2023 07:28:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : from : cc : message-id : date; s=pp1;
 bh=vUs6GH35kOTGMUVNWUotMvkghE0PAl+iGLd+6B1X0S0=;
 b=dLuezzGg6n8ISQFWMH+E+ucTY3H03+qPeGlKspNpYTSzZd1EpjVtl1oG8hioHv61Rlno
 Ouq1TFwuVtt19LTdPz4s03qN+I6eAznLrKHEC0a2pekAwaUCBthGibbyDPdfkVgVgYEY
 zuiOiAPK+7Pr2RGS+RAtJBz90v7W88mbHjCapWdUz06zZ2Zm623mtDa7YaW7HRSGLrh2
 6Ge+QYooJSJzllgYddK09SU4m1s22vL8VwfYGbdBJ/0KAhx99T46iPW28w4fLp9MUPtP
 PcHmH+mQxjFxKdZNAZOfixlXroh1skbE1XEYaCNpWrKTFdbV8wJC7wV5U51pyeO5P5BT ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg5693037-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:28:22 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34A7DEmP016735;
        Wed, 10 May 2023 07:28:21 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg569302e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:28:21 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A3xxLV002095;
        Wed, 10 May 2023 07:28:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qf7mhgqq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 07:28:19 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34A7SFoh33489270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 07:28:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 135D82004D;
        Wed, 10 May 2023 07:28:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC2172004E;
        Wed, 10 May 2023 07:28:14 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.76.41])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 07:28:14 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230502115931.86280-6-frankja@linux.ibm.com>
References: <20230502115931.86280-1-frankja@linux.ibm.com> <20230502115931.86280-6-frankja@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 5/7] s390x: pv: Add sie entry intercept and validity test
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Message-ID: <168370369446.357872.12935361214141873283@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 10 May 2023 09:28:14 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YUYRo6gGD1eUQXgLwxcmxl8cgwjaFqwc
X-Proofpoint-GUID: TH7aZ63r-u66cLB-MSTM1tTo7AOQT8N6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 13:59:29)
[...]
> diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
> new file mode 100644
> index 00000000..f8e9d137
> --- /dev/null
> +++ b/s390x/pv-icptcode.c
[...]
> +static void test_validity_timing(void)
> +{
> +       extern const char SNIPPET_NAME_START(asm, pv_icpt_vir_timing)[];
> +       extern const char SNIPPET_NAME_END(asm, pv_icpt_vir_timing)[];
> +       extern const char SNIPPET_HDR_START(asm, pv_icpt_vir_timing)[];
> +       extern const char SNIPPET_HDR_END(asm, pv_icpt_vir_timing)[];
> +       int size_hdr =3D SNIPPET_HDR_LEN(asm, pv_icpt_vir_timing);
> +       int size_gbin =3D SNIPPET_LEN(asm, pv_icpt_vir_timing);
> +       uint64_t time_exit, time_entry;
> +
> +       report_prefix_push("manipulated cpu time");
> +       snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_icpt_vir_timing),
> +                       SNIPPET_HDR_START(asm, pv_icpt_vir_timing),
> +                       size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +       sie(&vm);
> +       report(pv_icptdata_check_diag(&vm, 0x44), "stp done");

s/stp/spt/

> +       stck(&time_exit);
> +       mb();
> +
> +       /* Cpu timer counts down so adding a ms should lead to a validity=
 */
> +       vm.sblk->cputm +=3D S390_CLOCK_SHIFT_US * 1000;
> +       sie_expect_validity(&vm);
> +       sie(&vm);
> +       report(uv_validity_check(&vm), "validity entry cput > exit cput");
> +       vm.sblk->cputm -=3D S390_CLOCK_SHIFT_US;

Did you mean S390_CLOCK_SHIFT_US * 1000 here? if so, maybe you want to back=
up cputm and restore it here so your intention is clear.

[...]
> +static void run_icpt_122_tests(unsigned long lc_off)
> +{
> +       uv_export(vm.sblk->mso + lc_off);
> +       sie(&vm);
> +       report(vm.sblk->icptcode =3D=3D ICPT_PV_PREF, "Intercept 112 for =
page 0");
> +       uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
> +
> +       uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);

You are likely missing a sie(&vm) here.
