Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1F86E8D7C
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 11:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjDTJFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 05:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbjDTJFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 05:05:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FB5196
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 01:59:47 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33K8dmEA008907;
        Thu, 20 Apr 2023 08:59:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=C9uPDkS3qLXWdRPc0ywPWUWphUcD+k6Ch6zxE42+GV0=;
 b=NcysluuvV2sDixU3pUXThAHwgrG0CL/jAX083sIPB1ZqXUVQDnqn+ja/ckLxf+HvuKf7
 6kJaf01TrQOoBXVl6+70oM7/Pql+ZEEWt7x2ei/obQ76IaqjlRmBsZtwux1T5Nz/a/q3
 aiHhgAJPYFslvtmvCWa0lUblNRpGMF1X9E6GUvESumoOx2jsNwNhzGL9sujVG5pju4XL
 K4wnoLvxpA7Q8rR0NMqRSgqwedJ6wsnyK8hPmoozFxLkFoZpo3mlGjdn2JUIVsN8Tlr1
 0gbtAHvlEUZgo4CHtIE7jGtLjNy9jnh0TEFIBSBhpvjEoAR7VNhG8CGbG7bty22+OERj Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q322wrnh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 08:59:35 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33K8eUKx010907;
        Thu, 20 Apr 2023 08:59:35 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q322wrnf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 08:59:35 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33K807tM005597;
        Thu, 20 Apr 2023 08:59:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pyk6fk96q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 08:59:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33K8xQcX28312152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 08:59:26 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C600F20043;
        Thu, 20 Apr 2023 08:59:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E77A20040;
        Thu, 20 Apr 2023 08:59:26 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.175.78])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 20 Apr 2023 08:59:26 +0000 (GMT)
Message-ID: <66d9ba0e9904f035326aca609a767976b94547cf.camel@linux.ibm.com>
Subject: Re: [PATCH v19 02/21] s390x/cpu topology: add topology entries on
 CPU hotplug
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Thu, 20 Apr 2023 10:59:26 +0200
In-Reply-To: <20230403162905.17703-3-pmorel@linux.ibm.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
         <20230403162905.17703-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WhTnQtoCc89E71UnRkdBg0Bcr09WE2AE
X-Proofpoint-GUID: amg6WlS4piykc8JxT8D43IiGEUCiQJa5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_05,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 impostorscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304200064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
> The topology information are attributes of the CPU and are
> specified during the CPU device creation.
>=20
> On hot plug we:
> - calculate the default values for the topology for drawers,
>   books and sockets in the case they are not specified.
> - verify the CPU attributes
> - check that we have still room on the desired socket
>=20
> The possibility to insert a CPU in a mask is dependent on the
> number of cores allowed in a socket, a book or a drawer, the
> checking is done during the hot plug of the CPU to have an
> immediate answer.
>=20
> If the complete topology is not specified, the core is added
> in the physical topology based on its core ID and it gets
> defaults values for the modifier attributes.
>=20
> This way, starting QEMU without specifying the topology can
> still get some advantage of the CPU topology.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  MAINTAINERS                        |   1 +
>  include/hw/s390x/cpu-topology.h    |  44 +++++
>  include/hw/s390x/s390-virtio-ccw.h |   1 +
>  hw/s390x/cpu-topology.c            | 282 +++++++++++++++++++++++++++++
>  hw/s390x/s390-virtio-ccw.c         |  22 ++-
>  hw/s390x/meson.build               |   1 +
>  6 files changed, 349 insertions(+), 2 deletions(-)
>  create mode 100644 hw/s390x/cpu-topology.c

[...]

>  #endif
> diff --git a/include/hw/s390x/s390-virtio-ccw.h b/include/hw/s390x/s390-v=
irtio-ccw.h
> index 9bba21a916..ea10a6c6e1 100644
> --- a/include/hw/s390x/s390-virtio-ccw.h
> +++ b/include/hw/s390x/s390-virtio-ccw.h
> @@ -28,6 +28,7 @@ struct S390CcwMachineState {
>      bool dea_key_wrap;
>      bool pv;
>      uint8_t loadparm[8];
> +    bool vertical_polarization;

Why is this here and not in s390_topology?
This splits up the topology state somewhat.
I don't quite recall, did you use to have s390_topology in S390CcwMachineSt=
ate at some point?
I think putting everything in S390CcwMachineState might make sense too.

>  };
> =20
>  struct S390CcwMachineClass {
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..96da67bd7e
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c

[...]

> +/**
> + * s390_topology_cpu_default:
> + * @cpu: pointer to a S390CPU
> + * @errp: Error pointer
> + *
> + * Setup the default topology if no attributes are already set.
> + * Passing a CPU with some, but not all, attributes set is considered
> + * an error.
> + *
> + * The function calculates the (drawer_id, book_id, socket_id)
> + * topology by filling the cores starting from the first socket
> + * (0, 0, 0) up to the last (smp->drawers, smp->books, smp->sockets).
> + *
> + * CPU type and dedication have defaults values set in the
> + * s390x_cpu_properties, entitlement must be adjust depending on the
> + * dedication.
> + */
> +static void s390_topology_cpu_default(S390CPU *cpu, Error **errp)
> +{
> +    CpuTopology *smp =3D s390_topology.smp;
> +    CPUS390XState *env =3D &cpu->env;
> +
> +    /* All geometry topology attributes must be set or all unset */
> +    if ((env->socket_id < 0 || env->book_id < 0 || env->drawer_id < 0) &=
&
> +        (env->socket_id >=3D 0 || env->book_id >=3D 0 || env->drawer_id =
>=3D 0)) {
> +        error_setg(errp,
> +                   "Please define all or none of the topology geometry a=
ttributes");
> +        return;
> +    }
> +
> +    /* Check if one of the geometry topology is unset */
> +    if (env->socket_id < 0) {
> +        /* Calculate default geometry topology attributes */
> +        env->socket_id =3D s390_std_socket(env->core_id, smp);
> +        env->book_id =3D s390_std_book(env->core_id, smp);
> +        env->drawer_id =3D s390_std_drawer(env->core_id, smp);
> +    }
> +
> +    /*
> +     * Even the user can specify the entitlement as horizontal on the
> +     * command line, qemu will only use env->entitlement during vertical
> +     * polarization.
> +     * Medium entitlement is chosen as the default entitlement when the =
CPU
> +     * is not dedicated.
> +     * A dedicated CPU always receives a high entitlement.
> +     */
> +    if (env->entitlement >=3D S390_CPU_ENTITLEMENT__MAX ||
> +        env->entitlement =3D=3D S390_CPU_ENTITLEMENT_HORIZONTAL) {
> +        if (env->dedicated) {
> +            env->entitlement =3D S390_CPU_ENTITLEMENT_HIGH;
> +        } else {
> +            env->entitlement =3D S390_CPU_ENTITLEMENT_MEDIUM;
> +        }
> +    }

As you know, in my opinion there should be not possibility for the user
to set the entitlement to horizontal and dedicated && !=3D HIGH should be
rejected as an error.
If you do this, you can delete this.

> +}
> +
> +/**
> + * s390_topology_check:
> + * @socket_id: socket to check
> + * @book_id: book to check
> + * @drawer_id: drawer to check
> + * @entitlement: entitlement to check
> + * @dedicated: dedication to check
> + * @errp: Error pointer
> + *
> + * The function checks if the topology
> + * attributes fits inside the system topology.

fitS

The function checks the validity of the provided topology arguments,
namely that they're in bounds and non contradictory.

> + */
> +static void s390_topology_check(uint16_t socket_id, uint16_t book_id,

I'd prefer if you stick to one id type. There defined as int32_t in env,
here you use uint16_t and below int.

In env, you want a signed type with sufficient range, int16_t should suffic=
e there,
but bigger is also fine.
You don't want the user to pass a negative id, so by using an unsigned type=
 you
can avoid this without extra code.
But IMO there should be one point where a type conversion occurs.

> +                                uint16_t drawer_id, uint16_t entitlement=
,
> +                                bool dedicated, Error **errp)
> +{
> +    CpuTopology *smp =3D s390_topology.smp;
> +    ERRP_GUARD();
> +
> +    if (socket_id >=3D smp->sockets) {
> +        error_setg(errp, "Unavailable socket: %d", socket_id);
> +        return;
> +    }
> +    if (book_id >=3D smp->books) {
> +        error_setg(errp, "Unavailable book: %d", book_id);
> +        return;
> +    }
> +    if (drawer_id >=3D smp->drawers) {
> +        error_setg(errp, "Unavailable drawer: %d", drawer_id);
> +        return;
> +    }
> +    if (entitlement >=3D S390_CPU_ENTITLEMENT__MAX) {
> +        error_setg(errp, "Unknown entitlement: %d", entitlement);
> +        return;
> +    }

I think you can delete this, too, there is no way that entitlement is > MAX=
.

> +    if (dedicated && (entitlement =3D=3D S390_CPU_ENTITLEMENT_LOW ||
> +                      entitlement =3D=3D S390_CPU_ENTITLEMENT_MEDIUM)) {

Without HORIZONTAL you can do !=3D HIGH and save one line, but that is
cosmetic only.

> +        error_setg(errp, "A dedicated cpu implies high entitlement");
> +        return;
> +    }
> +}

[...]
