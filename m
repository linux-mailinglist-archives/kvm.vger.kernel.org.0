Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF50068F614
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 18:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjBHRvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 12:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjBHRvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 12:51:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6068420B
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 09:51:12 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318HhdMs005634;
        Wed, 8 Feb 2023 17:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=GrHltpw+BT00KudILjFritgU3wdo7D9eda0PZiXvqVM=;
 b=beuSyMf/nTBCa1acYaVMZ3/h1e3BxbZrp1eBjVrax3Iol21JJpd9/HZw8gbdZYnMPsdo
 MqkhiiXIPNTI8MnQYjZZb4R023CXMtUZf6ZlyTS1PcYm9P0NXUufEAmoXEpunY07uEUY
 v34W7l3NaThAZ4o+DCoNvOM/ahfJrafauHrFK4hVQZwQjkdjFzZCyYW1rmkFX9ecmg6G
 QviwvHDV0BvfHU0mWhcckXgY//hIT81AB0sWEV4bx+f3TlTD5M8JeD2eRyMFCBxH1ksC
 kMZhgcEjoYj57g/N4dplIdfDhE8rjsQdQJ//mMROMEBltKWs24PzZXsAk6Zy2ng3oY5v FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmgct062r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 17:50:57 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 318HoviR000578;
        Wed, 8 Feb 2023 17:50:57 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmgct0622-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 17:50:57 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3184VTGk020984;
        Wed, 8 Feb 2023 17:50:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfn7n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Feb 2023 17:50:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 318HopcM49807678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Feb 2023 17:50:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C7D02004D;
        Wed,  8 Feb 2023 17:50:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A2BB20040;
        Wed,  8 Feb 2023 17:50:51 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.183.35])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  8 Feb 2023 17:50:51 +0000 (GMT)
Message-ID: <776aa71584e93d552871f966e9c89cb062e2af6c.camel@linux.ibm.com>
Subject: Re: [PATCH v15 01/11] s390x/cpu topology: adding s390 specificities
 to CPU topology
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Wed, 08 Feb 2023 18:50:50 +0100
In-Reply-To: <20230201132051.126868-2-pmorel@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zeloUZyxrdicSmEM5AnekSUUtljQQZXS
X-Proofpoint-ORIG-GUID: 55OEyBnDjTuND8CEAgJ4TGqeH_u2EcA9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302080153
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> S390 adds two new SMP levels, drawers and books to the CPU
> topology.
> The S390 CPU have specific toplogy features like dedication
> and polarity to give to the guest indications on the host
> vCPUs scheduling and help the guest take the best decisions
> on the scheduling of threads on the vCPUs.
>=20
> Let us provide the SMP properties with books and drawers levels
> and S390 CPU with dedication and polarity,
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine.json               | 14 ++++++++--
>  include/hw/boards.h             | 10 ++++++-
>  include/hw/s390x/cpu-topology.h | 24 +++++++++++++++++
>  target/s390x/cpu.h              |  5 ++++
>  hw/core/machine-smp.c           | 48 ++++++++++++++++++++++++++++-----
>  hw/core/machine.c               |  4 +++
>  hw/s390x/s390-virtio-ccw.c      |  2 ++
>  softmmu/vl.c                    |  6 +++++
>  target/s390x/cpu.c              |  7 +++++
>  qemu-options.hx                 |  7 +++--
>  10 files changed, 115 insertions(+), 12 deletions(-)
>  create mode 100644 include/hw/s390x/cpu-topology.h
>=20
[...]
>=20
> diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topol=
ogy.h
> new file mode 100644
> index 0000000000..7a84b30a21
> --- /dev/null
> +++ b/include/hw/s390x/cpu-topology.h
> @@ -0,0 +1,24 @@
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (a=
t
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +#ifndef HW_S390X_CPU_TOPOLOGY_H
> +#define HW_S390X_CPU_TOPOLOGY_H
> +
> +#define S390_TOPOLOGY_CPU_IFL   0x03
> +
> +enum s390_topology_polarity {
> +    POLARITY_HORIZONTAL,
> +    POLARITY_VERTICAL,
> +    POLARITY_VERTICAL_LOW =3D 1,
> +    POLARITY_VERTICAL_MEDIUM,
> +    POLARITY_VERTICAL_HIGH,
> +    POLARITY_MAX,
> +};

IMO you should define the polarization and entitlement enums as
qapi enums.
The polarization is passed as data in the qapi event when the polarization
changes.
And the entitlement is passed to qemu when modifying the topology.


[...]
