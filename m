Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FE368DFFB
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 19:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjBGS1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 13:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbjBGS1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 13:27:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B15A212C
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 10:27:02 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317IM5e6014324;
        Tue, 7 Feb 2023 18:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=i5ZwglltKooHE545vpLaGJivhtTA77r6XIo90eaEM0E=;
 b=ax1t5DOeTUS0WEs+ikcv5EoCu84XmG8yHKFJpjeKHVpyxPtnoiKnu0+mbe8Aw7t6EnzL
 UMmZ7Y15r/JasaVRwIUyFlsFfQ0kKYl5Lt0wVXeQm9iy+W0/BYbPKzMmGSsgxfrURpRP
 bcjaWQUXbPvKWXIbUHEazDBzHDMsr2gRi2GZfRxuFx2zwbA1zpDkzL2+95LFs6vqDclp
 t+XvIojrbcyAMzjq41BOOSVaFhFhb4Z/bpG/VI+QnIu2Knqj8u/wGOPWuxQtsKWs2VX2
 Z7iDRv2ynHfjQYS0NRHJROVLHobF/FSarmW0oLc4uBv/P6MNvSpaeMgoOtpSvMIxKvLE Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkuuwg5k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 18:26:55 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 317IMTw4015223;
        Tue, 7 Feb 2023 18:26:55 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkuuwg5ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 18:26:55 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316L8DxL011173;
        Tue, 7 Feb 2023 18:26:53 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3nhf06ts3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 18:26:53 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 317IQnxW42336764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 18:26:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 594E220043;
        Tue,  7 Feb 2023 18:26:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9A1320040;
        Tue,  7 Feb 2023 18:26:48 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.183.69])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 18:26:48 +0000 (GMT)
Message-ID: <4cbe99ff13f1f8e917481e6d85daf2957dad8247.camel@linux.ibm.com>
Subject: Re: [PATCH v15 09/11] machine: adding s390 topology to
 query-cpu-fast
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 07 Feb 2023 19:26:48 +0100
In-Reply-To: <20230201132051.126868-10-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _dTUiQi2U9s7o9uz4AFes06V8xWLxMe0
X-Proofpoint-ORIG-GUID: CTqFWo1HHUJP5Qz-KdaUWdtkwqxHYT6B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_10,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070156
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> S390x provides two more topology containers above the sockets,
> books and drawers.
>=20
> Let's add these CPU attributes to the QAPI command query-cpu-fast.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine.json          | 13 ++++++++++---
>  hw/core/machine-qmp-cmds.c |  2 ++
>  2 files changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 3036117059..e36c39e258 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -53,11 +53,18 @@
>  #
>  # Additional information about a virtual S390 CPU
>  #
> -# @cpu-state: the virtual CPU's state
> +# @cpu-state: the virtual CPU's state (since 2.12)
> +# @dedicated: the virtual CPU's dedication (since 8.0)
> +# @polarity: the virtual CPU's polarity (since 8.0)
>  #
>  # Since: 2.12
>  ##
> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
> +{ 'struct': 'CpuInfoS390',
> +    'data': { 'cpu-state': 'CpuS390State',
> +              'dedicated': 'bool',
> +              'polarity': 'int'
> +    }
> +}
> =20
>  ##
>  # @CpuInfoFast:
> @@ -70,7 +77,7 @@
>  #
>  # @thread-id: ID of the underlying host thread
>  #
> -# @props: properties describing to which node/socket/core/thread
> +# @props: properties describing to which node/drawer/book/socket/core/th=
read
>  #         virtual CPU belongs to, provided if supported by board
>  #
>  # @target: the QEMU system emulation target, which determines which
> diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
> index 80d5e59651..e6d93cf2a0 100644
> --- a/hw/core/machine-qmp-cmds.c
> +++ b/hw/core/machine-qmp-cmds.c
> @@ -30,6 +30,8 @@ static void cpustate_to_cpuinfo_s390(CpuInfoS390 *info,=
 const CPUState *cpu)
>      CPUS390XState *env =3D &s390_cpu->env;
> =20
>      info->cpu_state =3D env->cpu_state;
> +    info->dedicated =3D env->dedicated;
> +    info->polarity =3D env->entitlement;

Might want to do s/polarity/entitlement on the whole patch to make this mor=
e coherent.
Reviewed-by: Nina Schoetterl-Glausch if you fix the issues in Thomas' first=
 reply.

>  #else
>      abort();
>  #endif

