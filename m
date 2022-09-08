Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0905B1612
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 09:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiIHH5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 03:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiIHH5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 03:57:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC34D5D118
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 00:57:30 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2887ffwf013607;
        Thu, 8 Sep 2022 07:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=J8L9gHcDkd6LQwaIkxKgGJ38M076wkjUmMd1fLdU0Mw=;
 b=TvxaGQ+kw8rsbgHy1efRon9dYDOQlJFQiG1HdTcb2rpnqLSoNtfvBxgmKg/Zgb+f+KyP
 xDOPVsj5XFbsNN0wftTi2/lYZNzwW2SKauABy1lGusopMgmgqO4LyMOXGaSbztnAOWZb
 wSEtSfrkFIhy22FUoRFP7voBrZJQKH0i9gkK9/+cgk9zcBZYL1XEgBZu/DLZSsbEVqTe
 9oWPavJykcOor6OKqXATnTPkmJzbQk3zL3+z/j8/EfPl1KzKTMOPaQyjHTqA6QcrS8gK
 +ZM41IHhqsmpDlUYrKvmTJz5k0RevJAR6LldhlX4aMbL61VRkr38n+hnEaax9xwgzCFx ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jfc7s8ect-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 07:57:25 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2887fj3v013882;
        Thu, 8 Sep 2022 07:57:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jfc7s8ebt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 07:57:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2887oBtA016285;
        Thu, 8 Sep 2022 07:57:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3jbxj8x7wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 07:57:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2887vJa915860136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Sep 2022 07:57:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C6EB5204F;
        Thu,  8 Sep 2022 07:57:19 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.30.57])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 97CCB5204E;
        Thu,  8 Sep 2022 07:57:18 +0000 (GMT)
Message-ID: <2ced62d89af99358d3d6d8d89e2faf8b115e8509.camel@linux.ibm.com>
Subject: Re: [PATCH v9 06/10] s390x/cpu_topology: resetting the
 Topology-Change-Report
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Date:   Thu, 08 Sep 2022 09:57:18 +0200
In-Reply-To: <20220902075531.188916-7-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
         <20220902075531.188916-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TAfwWp2o5Q5sBZJDs8avJ1fIsTUH5Sit
X-Proofpoint-ORIG-GUID: OPhZ3uOnEu05BJ2VHZkx3T9pCe2aoiJv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_04,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209080026
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
> During a subsystem reset the Topology-Change-Report is cleared
> by the machine.
> Let's ask KVM to clear the Modified Topology Change Report (MTCR)
>  bit of the SCA in the case of a subsystem reset.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/cpu-topology.c      | 12 ++++++++++++
>  hw/s390x/s390-virtio-ccw.c   |  1 +
>  target/s390x/cpu-sysemu.c    |  7 +++++++
>  target/s390x/cpu.h           |  1 +
>  target/s390x/kvm/kvm.c       | 23 +++++++++++++++++++++++
>  target/s390x/kvm/kvm_s390x.h |  1 +
>  6 files changed, 45 insertions(+)

[...]

> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index f96630440b..9c994d27d5 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -2585,3 +2585,26 @@ int kvm_s390_get_zpci_op(void)
>  {
>      return cap_zpci_op;
>  }
> +
> +int kvm_s390_topology_set_mtcr(uint64_t attr)
> +{
> +    struct kvm_device_attr attribute = {
> +        .group = KVM_S390_VM_CPU_TOPOLOGY,
> +        .attr  = attr,
> +    };
> +    int ret;
> +
> +    if (!s390_has_feat(S390_FEAT_CONFIGURATION_TOPOLOGY)) {
> +        return -EFAULT;

Why EFAULT?
The return value is just ignored when resetting, isn't it?
I wonder if it would be better not to.
Is it necessary because you're detecting the feature after you've
already created the S390Topology instance?
And you're doing that because that's just the order in which QEMU does
things? So the machine class is inited before the cpu model?
I wonder if there is a nice way to create the S390Topology only if the
feature is selected.

Anyway:
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

> +    }
> +    if (!kvm_vm_check_attr(kvm_state, KVM_S390_VM_CPU_TOPOLOGY, attr)) {
> +        return -ENOENT;
> +    }
> +
> +    ret = kvm_vm_ioctl(kvm_state, KVM_SET_DEVICE_ATTR, &attribute);
> +    if (ret) {
> +        error_report("Failed to set cpu topology attribute %lu: %s",
> +                     attr, strerror(-ret));
> +    }
> +    return ret;
> +}
> 
[...]

