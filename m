Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731D140013D
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 16:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349382AbhICO35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 10:29:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33076 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232812AbhICO34 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 10:29:56 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 183E3i5U088954;
        Fri, 3 Sep 2021 10:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=4Oxv1YL44c0LlpLj7WGBe+IWuuPb9AUMeaMAL8IRp5w=;
 b=nL7zq4gP1kFbnp7fu5XFWMpF/p4gRLR/FfIC+qrniY7f/zwrG0FcIbYnrYoWn1TR0V4s
 JhDjbRnmiURQDDCxLB4Yu0NDTmyE3K5PiGQEGmnq2/vqyFkkcHIFjXYnAUembYCABduw
 xyR3OCc0hyElmZjqXzYaeZAIcdwSIBbKA2RAfSkQ8DqLLiUP8FE3ZmSyMQ1nx6mURo3Z
 TftdKZ8N78eFuLH0YaL2qRlhnGukmZqCG7mipLIC/ilpwxfif9GIjp5ke5tNGXmmawHn
 69osPhAV8iLTkM+M9Ju6qPctGt3g9vBgfNf+PxfkoKX/4Ah+KX11/SqbTeZbAiaOIT+v 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3audm441cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 10:28:46 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 183E3qT6089720;
        Fri, 3 Sep 2021 10:28:45 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3audm441c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 10:28:45 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 183ECpld029274;
        Fri, 3 Sep 2021 14:28:45 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 3au6pjqsuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Sep 2021 14:28:45 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 183ESi4J18612948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Sep 2021 14:28:44 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10218C6062;
        Fri,  3 Sep 2021 14:28:44 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FC8CC605F;
        Fri,  3 Sep 2021 14:28:43 +0000 (GMT)
Received: from localhost (unknown [9.211.32.78])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Fri,  3 Sep 2021 14:28:42 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH kernel] KVM: PPC: Book3S: Merge powerpc's debugfs entry
 content into generic entry
In-Reply-To: <20210903052257.2348036-1-aik@ozlabs.ru>
References: <20210903052257.2348036-1-aik@ozlabs.ru>
Date:   Fri, 03 Sep 2021 11:28:41 -0300
Message-ID: <87v93hens6.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2VXsMFf1U_aBGmOz8Tmuq8PRhImPoOOr
X-Proofpoint-GUID: ufHLN5Lu48IB9JtOWR1HPAJ4cmH5x0x4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_05:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 adultscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:

> At the moment the generic KVM code creates an "%pid-%fd" entry per a KVM
> instance; and the PPC HV KVM creates its own at "vm%pid".
>
> The rproblems with the PPC entries are:
> 1. they do not allow multiple VMs in the same process (which is extremely
> rare case mostly used by syzkaller fuzzer);
> 2. prone to race bugs like the generic KVM code had fixed in
> commit 85cd39af14f4 ("KVM: Do not leak memory for duplicate debugfs
> directories").
>
> This defines kvm_arch_create_kvm_debugfs() similar to one for vcpus.

I think kvm_arch_create_vm_debugfs is a bit mode accurate?
                        ^
> This defines 2 hooks in kvmppc_ops for allowing specific KVM
> implementations to add necessary entries.
>
> This makes use of already existing kvm_arch_create_vcpu_debugfs.
>
> This removes no more used debugfs_dir pointers from PPC kvm_arch structs.
>
> Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

...

> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index c8f12b056968..325b388c725a 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2771,19 +2771,14 @@ static const struct file_operations debugfs_timings_ops = {
>  };
>  
>  /* Create a debugfs directory for the vcpu */
> -static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
> +static void kvmppc_arch_create_vcpu_debugfs_hv(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)

This could lose the 'arch' since it is already inside our code and
accessed only via ops. I see that we already have a
kvmppc_create_vcpu_debugfs that's used for some BookE processor, this
would make:

kvmppc_create_vcpu_debugfs
kvmppc_create_vcpu_debugfs_hv
kvmppc_create_vcpu_debugfs_pr (possibly)

which perhaps is more consistent.

>  {
> -	char buf[16];
> -	struct kvm *kvm = vcpu->kvm;
> -
> -	snprintf(buf, sizeof(buf), "vcpu%u", id);
> -	vcpu->arch.debugfs_dir = debugfs_create_dir(buf, kvm->arch.debugfs_dir);
> -	debugfs_create_file("timings", 0444, vcpu->arch.debugfs_dir, vcpu,
> +	debugfs_create_file("timings", 0444, debugfs_dentry, vcpu,
>  			    &debugfs_timings_ops);
>  }
>  
>  #else /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
> -static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
> +static void kvmppc_arch_create_vcpu_debugfs_hv(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
>  {
>  }
>  #endif /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
