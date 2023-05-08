Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733696FBA36
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbjEHVsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjEHVsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:48:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CF02704
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 14:48:03 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348LaEOc011141;
        Mon, 8 May 2023 21:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nK+zDH6qWFKSuNwiBwzpNOPOltYBb/EDDlWW5dPrsa4=;
 b=mOWGdQFGGyPm30624xzPXXXmFA8syIu+adzF4IHq1ZXGQxABJduaCWX00stTXv/kCJWG
 OSwUKm2Q/Cvz88+CihVbikc+0oDj4dHjOSMy38/5DmJgK3smUqSQfhs3zfWKjIqwzNC1
 Xes7KysLj78BxTixOlS6/SZc46vh1pmQIJW4ovMkg102pvb7k5vfANcTgsZl3ABDEbcn
 mOprJbGKPHo2R2zmEZ7eWT3NCsC7LfK9mq0h+CR0XLXVuN6+I4ofr8zw1YEv9VhfkZpr
 tTVkJ2Om1SiL7Eo3u9q694kzUrtHZfeZ3Z1hXWO+V3RytUhnv5j18WBFnYyAREF0n3pm Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf8wvgnsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 21:47:49 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 348LclQB022244;
        Mon, 8 May 2023 21:47:48 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qf8wvgnr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 21:47:48 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 348Lack0001250;
        Mon, 8 May 2023 21:47:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896r0pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 May 2023 21:47:46 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 348LlesG29819478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 May 2023 21:47:40 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59EB220043;
        Mon,  8 May 2023 21:47:40 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4586720040;
        Mon,  8 May 2023 21:47:39 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.71.193])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  8 May 2023 21:47:39 +0000 (GMT)
Message-ID: <3a79538637fc8e8f226290c9ba833face1784c29.camel@linux.ibm.com>
Subject: Re: [PATCH v20 11/21] qapi/s390x/cpu topology:
 CPU_POLARIZATION_CHANGE qapi event
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 08 May 2023 23:47:38 +0200
In-Reply-To: <20230425161456.21031-12-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
         <20230425161456.21031-12-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: j4x5lCWqxhS2hsMMZqo8CbKUFbu9q7ib
X-Proofpoint-GUID: 6iyhxocahlVgPCIKT28OQ7Mrv1Lv5SSO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_16,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 malwarescore=0 suspectscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305080143
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
> When the guest asks to change the polarization this change
> is forwarded to the upper layer using QAPI.
> The upper layer is supposed to take according decisions concerning
> CPU provisioning.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine-target.json | 33 +++++++++++++++++++++++++++++++++
>  hw/s390x/cpu-topology.c  |  2 ++
>  2 files changed, 35 insertions(+)
>=20
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 3b7a0b77f4..ffde2e9cbd 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -391,3 +391,36 @@
>    'features': [ 'unstable' ],
>    'if': { 'all': [ 'TARGET_S390X' , 'CONFIG_KVM' ] }
>  }
> +
> +##
> +# @CPU_POLARIZATION_CHANGE:
> +#
> +# Emitted when the guest asks to change the polarization.
> +#
> +# @polarization: polarization specified by the guest
> +#
> +# Features:
> +# @unstable: This command may still be modified.
> +#
> +# The guest can tell the host (via the PTF instruction) whether the
> +# CPUs should be provisioned using horizontal or vertical polarization.
> +#
> +# On horizontal polarization the host is expected to provision all vCPUs
> +# equally.
> +# On vertical polarization the host can provision each vCPU differently.
> +# The guest will get information on the details of the provisioning
> +# the next time it uses the STSI(15) instruction.
> +#
> +# Since: 8.1
> +#
> +# Example:
> +#
> +# <- { "event": "CPU_POLARIZATION_CHANGE",
> +#      "data": { "polarization": 0 },

I think you'd be getting "horizontal" instead of 0.

> +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
> +##
> +{ 'event': 'CPU_POLARIZATION_CHANGE',
> +  'data': { 'polarization': 'CpuS390Polarization' },
> +  'features': [ 'unstable' ],
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}
> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> index e5fb976594..e8b140d623 100644
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -17,6 +17,7 @@
>  #include "hw/s390x/s390-virtio-ccw.h"
>  #include "hw/s390x/cpu-topology.h"
>  #include "qapi/qapi-commands-machine-target.h"
> +#include "qapi/qapi-events-machine-target.h"
> =20
>  /*
>   * s390_topology is used to keep the topology information.
> @@ -138,6 +139,7 @@ void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintpt=
r_t ra)
>          } else {
>              s390_topology.vertical_polarization =3D !!fc;
>              s390_cpu_topology_set_changed(true);
> +            qapi_event_send_cpu_polarization_change(fc);

I'm not sure I like the implicit conversation of the function code to the e=
num value.
How about you do qapi_event_send_cpu_polarization_change(s390_topology.pola=
rization);
and rename vertical_polarization and change it's type to the enum.
You can then also do

+    CpuS390Polarization polarization =3D S390_CPU_POLARIZATION_HORIZONTAL;
+    switch (fc) {
+    case S390_CPU_POLARIZATION_VERTICAL:
+        polarization =3D S390_CPU_POLARIZATION_VERTICAL;
+        /* fallthrough */
+    case S390_CPU_POLARIZATION_HORIZONTAL:
+        if (s390_topology.polarization =3D=3D polarization) {

and use the value for the assignment further down, too.
>              setcc(cpu, 0);
>          }
>          break;

