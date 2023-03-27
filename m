Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6CE6CB0BE
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 23:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjC0VfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 17:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjC0VfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 17:35:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6A52127
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 14:35:19 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RKNZNx019894;
        Mon, 27 Mar 2023 21:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ygjuCDfMBzN83WsDvMuV1p401zsu7g50W4bhL1f9eL0=;
 b=LU5OfcS0cSunADCYbj4XFzGSKw1Tdq/cYGTKIkcz3KZGN0kOTMrZiVmpJwKeMHSNC6L8
 XA/r1SFuFPN8PPNoqWSlmby2DvM93eAHWoUm5XfxTjWso3CIK8SSjnoTFiFz2/6rQLZp
 Pq7OoSmuD9TQpBnAUXXHlhRk7qKdo0q3cRbH9YypNbsFHsV59BKQnw1adfGvDDPEI6xj
 bVjfkvVhj6KMA9QNBdkLMvE34qregcknQeJzWDVmgrZEXzuUlNjXsNpjTMc9W8+9JId0
 3EngsgTawPbupoqFWvvylNSA1FfOrK+rI8w0s+9HKwlSOr9SxWSaXnSD/9E+dJPibWPw xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pkj511csb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 21:35:04 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32RLAM1b013438;
        Mon, 27 Mar 2023 21:35:03 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pkj511crr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 21:35:03 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32REH6DR013249;
        Mon, 27 Mar 2023 21:35:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3phrk6jrwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 21:35:01 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32RLYvNd24183448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 21:34:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 567912004B;
        Mon, 27 Mar 2023 21:34:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8CC920043;
        Mon, 27 Mar 2023 21:34:56 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.133.130])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 27 Mar 2023 21:34:56 +0000 (GMT)
Message-ID: <1facc09195ef25a5f7ecf9c3bcc016fa1b313628.camel@linux.ibm.com>
Subject: Re: [PATCH v18 01/17] s390x/cpu topology: add s390 specifics to CPU
 topology
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 27 Mar 2023 23:34:56 +0200
In-Reply-To: <20230315143502.135750-2-pmorel@linux.ibm.com>
References: <20230315143502.135750-1-pmorel@linux.ibm.com>
         <20230315143502.135750-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8H8F8nAlaMlOw-FNy_v9as0T1ngtokcf
X-Proofpoint-ORIG-GUID: D8FYimo5zlbcmxJa7s749RV-NkLNitwe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270175
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-03-15 at 15:34 +0100, Pierre Morel wrote:
> S390 adds two new SMP levels, drawers and books to the CPU
> topology.
> The S390 CPU have specific topology features like dedication
> and entitlement to give to the guest indications on the host
> vCPUs scheduling and help the guest take the best decisions
> on the scheduling of threads on the vCPUs.
>=20
> Let us provide the SMP properties with books and drawers levels
> and S390 CPU with dedication and entitlement,
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  qapi/machine-common.json        | 22 +++++++++++++++
>  qapi/machine-target.json        | 12 +++++++++
>  qapi/machine.json               | 17 +++++++++---
>  include/hw/boards.h             | 10 ++++++-
>  include/hw/s390x/cpu-topology.h | 15 +++++++++++
>  target/s390x/cpu.h              |  6 +++++
>  hw/core/machine-smp.c           | 48 ++++++++++++++++++++++++++++-----
>  hw/core/machine.c               |  4 +++
>  hw/s390x/s390-virtio-ccw.c      |  2 ++
>  softmmu/vl.c                    |  6 +++++
>  target/s390x/cpu.c              |  7 +++++
>  qapi/meson.build                |  1 +
>  qemu-options.hx                 |  7 +++--
>  13 files changed, 144 insertions(+), 13 deletions(-)
>  create mode 100644 qapi/machine-common.json
>  create mode 100644 include/hw/s390x/cpu-topology.h
>=20
[...]
>=20
> diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> index c3dab007da..b8233df5a9 100644
> --- a/hw/core/machine-smp.c
> +++ b/hw/core/machine-smp.c
> @@ -31,6 +31,14 @@ static char *cpu_hierarchy_to_string(MachineState *ms)
>      MachineClass *mc =3D MACHINE_GET_CLASS(ms);
>      GString *s =3D g_string_new(NULL);
> =20
> +    if (mc->smp_props.drawers_supported) {
> +        g_string_append_printf(s, " * drawers (%u)", ms->smp.drawers);
> +    }
> +
> +    if (mc->smp_props.books_supported) {
> +        g_string_append_printf(s, " * books (%u)", ms->smp.books);
> +    }
> +
>      g_string_append_printf(s, "sockets (%u)", ms->smp.sockets);

The output of this doesn't look great.
How about:

static char *cpu_hierarchy_to_string(MachineState *ms)
{
    MachineClass *mc =3D MACHINE_GET_CLASS(ms);
    GString *s =3D g_string_new(NULL);
    const char *multiply =3D " * ", *prefix =3D "";

    if (mc->smp_props.drawers_supported) {
        g_string_append_printf(s, "drawers (%u)", ms->smp.drawers);
        prefix =3D multiply;
    }

    if (mc->smp_props.books_supported) {
        g_string_append_printf(s, "%sbooks (%u)", prefix, ms->smp.books);
        prefix =3D multiply;
    }

    g_string_append_printf(s, "%ssockets (%u)", prefix, ms->smp.sockets);

    if (mc->smp_props.dies_supported) {
        g_string_append_printf(s, " * dies (%u)", ms->smp.dies);
    }

    if (mc->smp_props.clusters_supported) {
        g_string_append_printf(s, " * clusters (%u)", ms->smp.clusters);
    }

    g_string_append_printf(s, " * cores (%u)", ms->smp.cores);
    g_string_append_printf(s, " * threads (%u)", ms->smp.threads);

    return g_string_free(s, false);
}


[...]
