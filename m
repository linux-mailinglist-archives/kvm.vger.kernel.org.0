Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5685B01E8
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 12:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiIGK12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 06:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIGK10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 06:27:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B56F6C121
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 03:27:25 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287AA150036854;
        Wed, 7 Sep 2022 10:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=AOywXLq0iV7yfhYsspll1FkavWSQyPFawC/Jx/IEmjg=;
 b=jtadHzgKBvEhhgK17dKhEdbtI11mDpBtDFFo/9RcoC+dh5pDKobgBFMU1U1hPip7c1TF
 N2pcRxI2WEsWxmcKXG2nGRlv/GOI5dTNTnekrNW/wZPbm+87jXwqfVQ0WEytLkt0iP1L
 23M0A9qxX6VZk8cuL7p+10I+auIHcIScfjXZb6luSrfJc5ZK4ebI3cKYWwb8yoYm2fDY
 8yFvhMXvzgLwJUUV4A5IK+qBPKjT8gVxae3SW6btsnKUsn/b1cf6lTlTUSBhLFW92i7g
 3CVirbSaCd4A2L7eMV62V472lNFHuK1x3lnPdP2CdAViPOJN8jKWXrQoggSg1CKLPyBh Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jerxa0yh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 10:27:02 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 287AARvX037688;
        Wed, 7 Sep 2022 10:27:01 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jerxa0yfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 10:27:01 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 287A8BHq029610;
        Wed, 7 Sep 2022 10:26:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3jbxj8uppn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 10:26:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 287AQtvO34275726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Sep 2022 10:26:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A62455204F;
        Wed,  7 Sep 2022 10:26:55 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.17.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ED70C5204E;
        Wed,  7 Sep 2022 10:26:54 +0000 (GMT)
Message-ID: <683c1c82673c065a9ab679fd019774365677a619.camel@linux.ibm.com>
Subject: Re: [PATCH v9 03/10] s390x/cpu topology: reporting the CPU topology
 to the guest
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Date:   Wed, 07 Sep 2022 12:26:54 +0200
In-Reply-To: <20220902075531.188916-4-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
         <20220902075531.188916-4-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NdBMiToyhY4YACryg00SJ-V7e6J57KBt
X-Proofpoint-GUID: WT3cDc3cDfr1Vzklvpf33ahPNvW4Rq4a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_06,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
> The guest can use the STSI instruction to get a buffer filled
> with the CPU topology description.
> 
> Let us implement the STSI instruction for the basis CPU topology
> level, level 2.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/cpu-topology.c         |   4 ++
>  include/hw/s390x/cpu-topology.h |   5 ++
>  target/s390x/cpu.h              |  49 +++++++++++++++
>  target/s390x/cpu_topology.c     | 108 ++++++++++++++++++++++++++++++++
>  target/s390x/kvm/kvm.c          |   6 +-
>  target/s390x/meson.build        |   1 +
>  6 files changed, 172 insertions(+), 1 deletion(-)
>  create mode 100644 target/s390x/cpu_topology.c
> 
[...]

> diff --git a/target/s390x/cpu_topology.c b/target/s390x/cpu_topology.c

[...]

> +static char *fill_tle_cpu(char *p, uint64_t mask, int origin)
> +{
> +    SysIBTl_cpu *tle = (SysIBTl_cpu *)p;
> +
> +    tle->nl = 0;
> +    tle->dedicated = 1;
> +    tle->polarity = S390_TOPOLOGY_POLARITY_H;
> +    tle->type = S390_TOPOLOGY_CPU_TYPE;
> +    tle->origin = origin * 64;

origin is a multibyte field too, so needs a conversion too.

> +    tle->mask = be64_to_cpu(mask);
> +    return p + sizeof(*tle);
> +}
> +
[...]
