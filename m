Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507914BA6E3
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 18:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243659AbiBQRRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 12:17:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243645AbiBQRRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 12:17:46 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9075178383;
        Thu, 17 Feb 2022 09:17:30 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HGGrAt003469;
        Thu, 17 Feb 2022 17:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Qxz0J4QCA6eNo6kquHEm8yB4dNzQPLzloNtL2uOeJ5M=;
 b=AjINcr6khqnQQzCmJrR9kQ6MjTsYIfpAzr8FF245nsqe99WPI50+GniGtiJfi3hYlfmc
 bz1iXr/rJvpCR/ACtjq68mYIqURxor6wI/CI9xhuPEPoau6bM+XzXwtqblcXZOX6AVeI
 hXFeEvYyBjMvsXTf0ylz+Y4NUuCqyHfBfoC+oTyMd6a8nh8su5wPVQfnT02XBcfszbhn
 qN3QDqqIx4WtjqZzRXihkW1Ur0yAkFadBo51DNaG9KKw8iMyqODST4sNSGVzc47bgUEB
 j8TmIZ50fCUDX8Z6J7ZefI/hfXzXMd1Eb9/Znxu4zsxzIsNSFi8s+OCaYylXSJBpInQx bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9srchjy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 17:17:29 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HGlOlA023566;
        Thu, 17 Feb 2022 17:17:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9srchjxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 17:17:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HHDUY8017724;
        Thu, 17 Feb 2022 17:17:26 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645kcs6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 17:17:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HHHNBV45679074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 17:17:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 800D911C058;
        Thu, 17 Feb 2022 17:17:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 047F411C04C;
        Thu, 17 Feb 2022 17:17:23 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.39.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 17:17:22 +0000 (GMT)
Message-ID: <f0bf737abf480d6d16af6e5335bb195061f3d076.camel@linux.ibm.com>
Subject: Re: [PATCH v7 1/1] s390x: KVM: guest support for topology function
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com
Date:   Thu, 17 Feb 2022 18:17:22 +0100
In-Reply-To: <20220217095923.114489-2-pmorel@linux.ibm.com>
References: <20220217095923.114489-1-pmorel@linux.ibm.com>
         <20220217095923.114489-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9umTdp9cN2hw7OnVg_QrGqtZjtULIZjm
X-Proofpoint-GUID: 6wb6VG9BZsk6lNyzV_ZBY-1J54bjUaL4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_06,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 clxscore=1011 phishscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 10:59 +0100, Pierre Morel wrote:
[...]
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 2296b1ff1e02..af7ea8488fa2 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
[...]
>  
> -void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +/**
> + * kvm_s390_vcpu_set_mtcr
> + * @vcp: the virtual CPU
> + *
> + * Is only relevant if the topology facility is present.
> + *
> + * Updates the Multiprocessor Topology-Change-Report to signal
> + * the guest with a topology change.
> + */
> +static void kvm_s390_vcpu_set_mtcr(struct kvm_vcpu *vcpu)
>  {
> +       struct esca_block *esca = vcpu->kvm->arch.sca;

utility is at the same offset for the bsca and the esca, still
wondering whether it is a good idea to assume esca here... 

[...]
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 098831e815e6..af04ffbfd587 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -503,4 +503,29 @@ void kvm_s390_vcpu_crypto_reset_all(struct kvm
> *kvm);
>   */
>  extern unsigned int diag9c_forwarding_hz;
>  
> +#define S390_KVM_TOPOLOGY_NEW_CPU -1
> +/**
> + * kvm_s390_topology_changed
> + * @vcpu: the virtual CPU
> + *
> + * If the topology facility is present, checks if the CPU toplogy
> + * viewed by the guest changed due to load balancing or CPU hotplug.
> + */
> +static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
> +{
> +       if (!test_kvm_facility(vcpu->kvm, 11))
> +               return false;
> +
> +       /* A new vCPU has been hotplugged */
> +       if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
> +               return true;
> +
> +       /* The real CPU backing up the vCPU moved to another socket
> */
> +       if (topology_physical_package_id(vcpu->cpu) !=
> +           topology_physical_package_id(vcpu->arch.prev_cpu))
> +               return true;

Why is it OK to look just at the physical package ID here? What if the
vcpu for example moves to a different book, which has a core with the
same physical package ID?
