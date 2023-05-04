Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854286F6981
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 13:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjEDLFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 07:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjEDLFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 07:05:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDCD11D
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 04:05:39 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344Adb55031054;
        Thu, 4 May 2023 11:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=UroErleK60vpRc1TOxZACROEUFKkYQPb17vzVe0JFHo=;
 b=H5veoE00VHcp5BIEhCRUBH71u5aI/zw+yTm9m1AhfTTQxjVnuJSJDue3m/PEB3B4d0KP
 Z/LtwunYdoGkacYTBnqqIVxLbbuze3K1hPqVWk6JK9GAzsmSm9qQgV0D19Dts0iQRRl3
 qwH2ggkMnypd0pNHw0JRM0/AvDE8gJp62lv3oz5mcJQNVp6xRMD2Bq8ng+w8eI5JfAk9
 d/mwAeDbvbw8pHeuDRt8Nq83PImOO5FYaeIMsuoCfXRGjChpaI+q2saeur6rkrcrCYwV
 XQ2o7sSqYIDzDonLbfevRPN6UJstr5XBaGi3sI5rg5xnWb1lkWcq1103fVRjP+y8q3F5 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qca122nqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 11:03:21 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 344AmRVN005306;
        Thu, 4 May 2023 11:03:21 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qca122npe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 11:03:20 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3444P042018678;
        Thu, 4 May 2023 11:03:18 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6janj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 11:03:18 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 344B3DoE30933324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 May 2023 11:03:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F41A1201F7;
        Thu,  4 May 2023 11:03:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D80D201F6;
        Thu,  4 May 2023 11:03:11 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.36.58])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  4 May 2023 11:03:11 +0000 (GMT)
Message-ID: <ffc6bf647f1d7238f15b9d08ae20683bdb116eb4.camel@linux.ibm.com>
Subject: Re: [PATCH v20 06/21] s390x/cpu topology: interception of PTF
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
Date:   Thu, 04 May 2023 13:03:10 +0200
In-Reply-To: <20230425161456.21031-7-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
         <20230425161456.21031-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZUkmcHyfjvYu_Fyxm4tkvvzezxETm3C_
X-Proofpoint-GUID: t_ESf3W_lMKj1HXLgbYhIq0vdlj-OUkj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_06,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 suspectscore=0
 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
> When the host supports the CPU topology facility, the PTF
> instruction with function code 2 is interpreted by the SIE,
> provided that the userland hypervisor activates the interpretation
> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>=20
> The PTF instructions with function code 0 and 1 are intercepted
> and must be emulated by the userland hypervisor.
>=20
> During RESET all CPU of the configuration are placed in
> horizontal polarity.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

See nit below.
> ---
>  include/hw/s390x/s390-virtio-ccw.h |  6 ++++
>  hw/s390x/cpu-topology.c            | 51 ++++++++++++++++++++++++++++++
>  target/s390x/kvm/kvm.c             | 11 +++++++
>  3 files changed, 68 insertions(+)
>=20
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-v=
irtio-ccw.h
> index 9bba21a916..c1d46e78af 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -30,6 +30,12 @@ struct S390CcwMachineState {
>      uint8_t loadparm[8];
>  };
> =20
> +#define S390_PTF_REASON_NONE (0x00 << 8)
> +#define S390_PTF_REASON_DONE (0x01 << 8)
> +#define S390_PTF_REASON_BUSY (0x02 << 8)
> +#define S390_TOPO_FC_MASK 0xffUL
> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
> +
>  struct S390CcwMachineClass {
>      /*< private >*/
>      MachineClass parent_class;
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index c98439ff7a..3c7bbff4bc 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -96,6 +96,56 @@ static void s390_topology_init(MachineState *ms)
>      QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>  }
> =20
> +/*
> + * s390_handle_ptf:
> + *
> + * @register 1: contains the function code
> + *
> + * Function codes 0 (horizontal) and 1 (vertical) define the CPU
> + * polarization requested by the guest.
> + *
> + * Function code 2 is handling topology changes and is interpreted
> + * by the SIE.
> + */
> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
> +{
> +    CPUS390XState *env =3D &cpu->env;
> +    uint64_t reg =3D env->regs[r1];
> +    int fc =3D reg & S390_TOPO_FC_MASK;
> +
> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
> +        s390_program_interrupt(env, PGM_OPERATION, ra);
> +        return;
> +    }
> +
> +    if (env->psw.mask & PSW_MASK_PSTATE) {
> +        s390_program_interrupt(env, PGM_PRIVILEGED, ra);
> +        return;
> +    }
> +
> +    if (reg & ~S390_TOPO_FC_MASK) {
> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
> +        return;
> +    }
> +
> +    switch (fc) {
> +    case S390_CPU_POLARIZATION_VERTICAL:
> +    case S390_CPU_POLARIZATION_HORIZONTAL:

I'd give this a name.
bool requested_vertical =3D !!fc;

> +        if (s390_topology.vertical_polarization =3D=3D !!fc) {
> +            env->regs[r1] |=3D S390_PTF_REASON_DONE;
> +            setcc(cpu, 2);
> +        } else {
> +            s390_topology.vertical_polarization =3D !!fc;
> +            s390_cpu_topology_set_changed(true);
> +            setcc(cpu, 0);
> +        }
> +        break;
> +    default:
> +        /* Note that fc =3D=3D 2 is interpreted by the SIE */
> +        s390_program_interrupt(env, PGM_SPECIFICATION, ra);
> +    }
> +}
> +

[...]

