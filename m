Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0DA5AE24A
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 10:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbiIFIRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 04:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiIFIRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 04:17:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783145508C
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 01:17:45 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2867oim5016985;
        Tue, 6 Sep 2022 08:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=fp9OOmG/9g1zZazjh+DBY2mTkvbgTxVNcbCt45GosbE=;
 b=UxNySvs4i8muhlfiJwWThyMJK8YNAhMKlTa0K1s5Z0VUbPN32quS4RcsdntG07sIGDbs
 6nthWrG+m0H4cU1w1xQycUycB+macUBKvnxIUtzfEzemy6dW9t3yXhnvuoM0jHszP0a8
 NHVYLT0EATERSPdTmnd1LlShbp14EuFHMeXnSDYL49O8CTv9bTEvy7StIrwCwyerAN2N
 jlZG7DLZoMZsTFBL3ktjyV7pO1m7fLWlyilH7xA5m+fz9gs+9oq+zzC+upPx2QoKCsMB
 2x89TCbcD/P305MmE9bj1xM4Vpr4uqQpwh4sS3mPM7Kf/6qP8LDr8Orb+nW41526lIRP Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3je26391gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 08:17:40 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2867pLil021694;
        Tue, 6 Sep 2022 08:17:39 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3je26391ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 08:17:39 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28686Reo007340;
        Tue, 6 Sep 2022 08:17:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3jbxj8thcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 08:17:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2868E52q42074542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Sep 2022 08:14:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E764C040;
        Tue,  6 Sep 2022 08:17:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89B3B4C044;
        Tue,  6 Sep 2022 08:17:33 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.15.101])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Sep 2022 08:17:33 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220902075531.188916-4-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com> <20220902075531.188916-4-pmorel@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH v9 03/10] s390x/cpu topology: reporting the CPU topology to the guest
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Message-ID: <166245225333.5995.17109067416462484247@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 06 Sep 2022 10:17:33 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pyauRzQdMDn5utUGf5ASDiIQkyhlKK4_
X-Proofpoint-ORIG-GUID: RC5Qufek0YMiQaf02On3fTcpQQsKBniP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_03,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209060038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2022-09-02 09:55:24)
> The guest can use the STSI instruction to get a buffer filled
> with the CPU topology description.
>=20
> Let us implement the STSI instruction for the basis CPU topology
> level, level 2.

I like this. It is so much simpler. Thanks.

[...]
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index a6ca006ec5..e2fd5c7e44 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -76,9 +76,11 @@ void s390_topology_new_cpu(int core_id)
>       * in the CPU container allows to represent up to the maximal number=
 of
>       * CPU inside several CPU containers inside the socket container.
>       */
> +    qemu_mutex_lock(&topo->topo_mutex);

You access topo->cores above. Do you need the mutex for that? I guess not s=
ince
it can't change at runtime (right?), so maybe it is worth documenting what =
the
topo_mutex actually protects or you just take the mutex at the start of the
function.

[...]
> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c
> new file mode 100644
> index 0000000000..56865dafc6
> --- /dev/null
> +++ b/target/s390x/cpu_topology.c
[...]
> +static char *fill_tle_cpu(char *p, uint64_t mask, int origin)
> +{
> +    SysIBTl_cpu *tle =3D (SysIBTl_cpu *)p;
> +
> +    tle->nl =3D 0;
> +    tle->dedicated =3D 1;
> +    tle->polarity =3D S390_TOPOLOGY_POLARITY_H;
> +    tle->type =3D S390_TOPOLOGY_CPU_TYPE;
> +    tle->origin =3D origin * 64;

origin would also need a byte order conversion.

> +    tle->mask =3D be64_to_cpu(mask);

cpu_to_be64()

[...]
> +static char *s390_top_set_level2(S390Topology *topo, char *p)
> +{
> +    int i, origin;
> +
> +    for (i =3D 0; i < topo->sockets; i++) {
> +        if (!topo->socket[i].active_count) {
> +            continue;
> +        }
> +        p =3D fill_container(p, 1, i);
> +        for (origin =3D 0; origin < S390_TOPOLOGY_MAX_ORIGIN; origin++) {
> +            uint64_t mask =3D 0L;
> +
> +            mask =3D be64_to_cpu(topo->tle[i].mask[origin]);

Don't you already do the endianness conversion in fill_tle_cpu()?

[...]
> +void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, uint8_t ar)
> +{
> +    SysIB_151x *sysib;
> +    int len =3D sizeof(*sysib);
> +
> +    if (s390_is_pv() || sel2 < 2 || sel2 > S390_TOPOLOGY_MAX_MNEST) {
> +        setcc(cpu, 3);
> +        return;
> +    }
> +
> +    sysib =3D g_malloc0(TARGET_PAGE_SIZE);
> +
> +    len +=3D setup_stsi(sysib, sel2);
> +    if (len > TARGET_PAGE_SIZE) {
> +        setcc(cpu, 3);
> +        goto out_free;
> +    }

Maybe I don't get it, but isn't it kind of late for this check? You would
already have written beyond the end of the buffer at this point in time...

> +
> +    sysib->length =3D be16_to_cpu(len);

cpu_to_be16()
