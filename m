Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24AA68C5DC
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 19:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBFSeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 13:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBFSeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 13:34:36 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A71872A5
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 10:34:35 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316IMfgD018628;
        Mon, 6 Feb 2023 18:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=V2BUMysRWry5OmZWAazqJVGtCEEJCqfJhPvmrmyKr5g=;
 b=N8ymEuorfD44mHkXVU1412mxDumP4a5VglM5YbZodw6LwdHTEy4qZ/7IeQAFX+iHf/i2
 SdH1ntL4+UMSsLj2no3XCdcMg4QM0opUMrp9KVZ5H1YyZ/IjDIabmpJd4H8pB/zdoIGa
 qxRUzMpl0wSdK+7njT+ZF6ac6dpgLk/xs0YfI64NuD63nDXdYFuoS83lrfQ1kZIIgOgt
 xWkkkzs4yq9X//UtuZk5GUTaEMNk8JW4i1YJxA0dHrFzAlpMlLSaf1cEYXB73FSRfm6a
 RRJ+g7ybBO9hsiWt+Jxr2GOv1RwdwAD9WxWaW0bjBS/BPkyiRt3/enqBZfLj3EW/mVtd 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk6s9r6dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 18:34:20 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316IPTs5027865;
        Mon, 6 Feb 2023 18:34:19 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk6s9r6cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 18:34:19 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316EZoIB015786;
        Mon, 6 Feb 2023 18:34:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3nhf06hwy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 18:34:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316IYDkE47120690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 18:34:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4BF42004B;
        Mon,  6 Feb 2023 18:34:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7273F20040;
        Mon,  6 Feb 2023 18:34:13 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.200.84])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 18:34:13 +0000 (GMT)
Message-ID: <5c15ccde659a9849ab3529e08f5e1278508406c8.camel@linux.ibm.com>
Subject: Re: [PATCH v15 06/11] s390x/cpu topology: interception of PTF
 instruction
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 06 Feb 2023 19:34:13 +0100
In-Reply-To: <20230201132051.126868-7-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -bj9-gTe9b6R0y8PC7psV-7Ao8_mRTYv
X-Proofpoint-ORIG-GUID: eJPREZIP80n3NckFAeHJKr8axvnQVCQy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_07,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 clxscore=1015 bulkscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060161
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> When the host supports the CPU topology facility, the PTF
> instruction with function code 2 is interpreted by the SIE,
> provided that the userland hypervizor activates the interpretation
> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>=20
> The PTF instructions with function code 0 and 1 are intercepted
> and must be emulated by the userland hypervizor.
>=20
> During RESET all CPU of the configuration are placed in
> horizontal polarity.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  include/hw/s390x/s390-virtio-ccw.h |   6 ++
>  target/s390x/cpu.h                 |   1 +
>  hw/s390x/cpu-topology.c            | 103 +++++++++++++++++++++++++++++
>  target/s390x/cpu-sysemu.c          |  14 ++++
>  target/s390x/kvm/kvm.c             |  11 +++
>  5 files changed, 135 insertions(+)
>=20
[...]

> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index cf63f3dd01..1028bf4476 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -85,16 +85,104 @@ static void s390_topology_init(MachineState *ms)
>      QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>  }
> =20
> +/**
> + * s390_topology_set_cpus_polarity:
> + * @polarity: polarity requested by the caller
> + *
> + * Set all CPU entitlement according to polarity and
> + * dedication.
> + * Default vertical entitlement is POLARITY_VERTICAL_MEDIUM as
> + * it does not require host modification of the CPU provisioning
> + * until the host decide to modify individual CPU provisioning
> + * using QAPI interface.
> + * However a dedicated vCPU will have a POLARITY_VERTICAL_HIGH
> + * entitlement.
> + */
> +static void s390_topology_set_cpus_polarity(int polarity)

Since you set the entitlement field I'd prefer _set_cpus_entitlement or sim=
ilar.

> +{
> +    CPUState *cs;
> +
> +    CPU_FOREACH(cs) {
> +        if (polarity =3D=3D POLARITY_HORIZONTAL) {
> +            S390_CPU(cs)->env.entitlement =3D 0;
> +        } else if (S390_CPU(cs)->env.dedicated) {
> +            S390_CPU(cs)->env.entitlement =3D POLARITY_VERTICAL_HIGH;
> +        } else {
> +            S390_CPU(cs)->env.entitlement =3D POLARITY_VERTICAL_MEDIUM;
> +        }
> +    }
> +}
> +
[...]
> =20
>  /**
> @@ -137,6 +225,21 @@ static void s390_topology_cpu_default(S390CPU *cpu, =
Error **errp)
>                            (smp->books * smp->sockets * smp->cores)) %
>                           smp->drawers;
>      }

Why are the changes below in this patch?

> +
> +    /*
> +     * Machine polarity is set inside the global s390_topology structure=
.
> +     * In the case the polarity is set as horizontal set the entitlement
> +     * to POLARITY_VERTICAL_MEDIUM which is the better equivalent when
> +     * machine polarity is set to vertical or POLARITY_VERTICAL_HIGH if
> +     * the vCPU is dedicated.
> +     */
> +    if (s390_topology.polarity && !env->entitlement) {

It'd be more readable if you compared against enum values by name.

I don't see why you check s390_topology.polarity. If it is horizontal
then the value of the entitlement doesn't matter at all, so you can set it
to whatever.
All you want to do is enforce dedicated -> VERTICAL_HIGH, right?
So why don't you just add=20

+    if (cpu->env.dedicated && cpu->env.entitlement !=3D POLARITY_VERTICAL_=
HIGH) {
+        error_setg(errp, "A dedicated cpu implies high entitlement");
+        return;
+    }

to s390_topology_check?

> +        if (env->dedicated) {
> +            env->entitlement =3D POLARITY_VERTICAL_HIGH;
> +        } else {
> +            env->entitlement =3D POLARITY_VERTICAL_MEDIUM;
> +        }

If it is horizontal, then setting the entitlement is pointless as it will b=
e
reset to medium on PTF.
So the current polarization is vertical and a cpu is being hotplugged,
but setting the entitlement of the cpu being added is also pointless, becau=
se
it's determined by the dedication. That seems weird.

> +    }
>  }
> =20

[...]
