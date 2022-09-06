Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911F95ADF40
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 07:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiIFF6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 01:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiIFF6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 01:58:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1776B177
        for <kvm@vger.kernel.org>; Mon,  5 Sep 2022 22:58:12 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2864RS5s010297;
        Tue, 6 Sep 2022 05:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=x8bT+iRNWOKoFk5GRto+QTB5F19l+E+Eeb7i8WQ7+wM=;
 b=TEwqzupOjr3OEq/ZeW6h1Aevs4q01a6xvw+jHjJ7av7XgCu+rRWfrdh6f4+uyaAocoPX
 G0TgBodIiQrg34Aa7tTstXHgYLFWRxv2mKGog18LtUSviCtWEWvGF+2SiGmrz4nEo7K3
 +qrfL0HEMHwYE2YJxyxumqweU4xXIwSa2mtOwsFOn52xuQhCoCWYMhRjRfbkYlQ3abNR
 80jrk6R8qHluSXLdiAcERI1BlkJk/cDEenul4RVY2+HxKTYnw2o188PejCQ8EJorlhCl
 H4+dkWYkaxEUWPBd9G9kAiiojCRRQMVxl/+iS1jy7y9JZAREthHCplwQtXNI02/79f+x hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdy6s2bqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 05:58:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2865RKZE033771;
        Tue, 6 Sep 2022 05:58:06 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jdy6s2bpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 05:58:06 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2865qiFP029630;
        Tue, 6 Sep 2022 05:58:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3jbx6htdvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 05:58:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2865w1Eg35521000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Sep 2022 05:58:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23DB7AE04D;
        Tue,  6 Sep 2022 05:58:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F134DAE045;
        Tue,  6 Sep 2022 05:58:00 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.22.126])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Sep 2022 05:58:00 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220902075531.188916-3-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com> <20220902075531.188916-3-pmorel@linux.ibm.com>
Subject: Re: [PATCH v9 02/10] s390x/cpu topology: core_id sets s390x CPU topology
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, frankja@linux.ibm.com
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166244388074.53359.17766769465682688178@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 06 Sep 2022 07:58:00 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dsZngDqZwNsWv2W0YP08WgfIH7vLR79a
X-Proofpoint-ORIG-GUID: vKaFRTcCAEBS-yYK1j7a30SCGAMkJqnu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_02,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209060025
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2022-09-02 09:55:23)
[...]
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> new file mode 100644
> index 0000000000..a6ca006ec5
> --- /dev/null
> +++ b/hw/s390x/cpu-topology.c
[...]
> +void s390_topology_new_cpu(int core_id)
> +{
[...]
> +    socket_id =3D core_id / topo->cores;

The comment below is essential for understanding all of this. Move it befor=
e this line.

> +
> +    bit =3D core_id;
> +    origin =3D bit / 64;
> +    bit %=3D 64;
> +    bit =3D 63 - bit;
> +
> +    /*
> +     * At the core level, each CPU is represented by a bit in a 64bit
> +     * unsigned long. Set on plug and clear on unplug of a CPU.

cleared                                  ^

[...]
> +     * In that case the origin field, representing the offset of the fir=
st CPU
> +     * in the CPU container allows to represent up to the maximal number=
 of
> +     * CPU inside several CPU containers inside the socket container.

How about:
"In that case the origin variable represents the offset of the first CPU in=
 the
CPU container. More than 64 CPUs per socket are represented in several CPU
containers inside the socket container."

> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index b5ca154e2f..15cefd104b 100644
[...]
> @@ -247,6 +248,12 @@ static void ccw_init(MachineState *machine)
>      /* init memory + setup max page size. Required for the CPU model */
>      s390_memory_init(machine->ram);
> =20
> +    /* Adding the topology must be done before CPU intialization*/

space                                                              ^
