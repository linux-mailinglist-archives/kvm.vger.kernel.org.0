Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C7E4B8DCD
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 17:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbiBPQXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 11:23:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiBPQXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 11:23:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1D320BCFE;
        Wed, 16 Feb 2022 08:23:04 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GGA5GZ012323;
        Wed, 16 Feb 2022 16:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hGygGfyBZQzZARePJKDSLYnI6/62xJHqBNUbgyKANO0=;
 b=NpcKNj54knmv3Q5MF4nttEklExUtM0QnFXSfFbH5fLroMiw0N1L7Xa8MLBKzbA6+xhQ6
 1A8V5M87+X3b1Tfo3x3mtxwXzFS1xpSvWBWB8iweUnRh03hK72itY3iUFxMEbeHOIznG
 2Td6sv6OHHJzOk0G9CrzEyOZMv0aIC8BNEwe+rtBpzHIGFiAjTGQdp6oFWqTi/59eQbg
 9tTXXKOPFhxVhGmjWZycA6pFuATn9SUX0YqIsTUBOLn7Yzfvnxk+4oePTb8kPoJrb301
 V9f49DqQaHsVmTi8wL7XIpuMFT/EZujLouFH1tVpnV5z0mnMUfpCFGODtIFQce3j7Uk1 ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e944t8q6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 16:21:34 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21GGB0gQ015426;
        Wed, 16 Feb 2022 16:21:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e944t8q61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 16:21:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21GGCjBB022708;
        Wed, 16 Feb 2022 16:21:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3e64haaj7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Feb 2022 16:21:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21GGLLhJ38535620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 16:21:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F295DA4062;
        Wed, 16 Feb 2022 16:21:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00B50A4069;
        Wed, 16 Feb 2022 16:21:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Feb 2022 16:21:18 +0000 (GMT)
Date:   Wed, 16 Feb 2022 17:21:17 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v4 2/6] Partially revert "KVM: Pass kvm_init()'s opaque
 param to additional arch funcs"
Message-ID: <20220216172117.194e5309@p-imbrenda>
In-Reply-To: <20220216031528.92558-3-chao.gao@intel.com>
References: <20220216031528.92558-1-chao.gao@intel.com>
        <20220216031528.92558-3-chao.gao@intel.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3fTH7-ZleMRtuhzk036tkK96NWkQJCFz
X-Proofpoint-ORIG-GUID: dWyQhtdRuToKG8BmT7g8zOnlfvrlm7Bk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_07,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Feb 2022 11:15:17 +0800
Chao Gao <chao.gao@intel.com> wrote:

> This partially reverts commit b99040853738 ("KVM: Pass kvm_init()'s opaque
> param to additional arch funcs") remove opaque from
> kvm_arch_check_processor_compat because no one uses this opaque now.
> Address conflicts for ARM (due to file movement) and manually handle RISC-V
> which comes after the commit.
> 
> And changes about kvm_arch_hardware_setup() in original commit are still
> needed so they are not reverted.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

for KVM s390:

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/arm64/kvm/arm.c       |  2 +-
>  arch/mips/kvm/mips.c       |  2 +-
>  arch/powerpc/kvm/powerpc.c |  2 +-
>  arch/riscv/kvm/main.c      |  2 +-
>  arch/s390/kvm/kvm-s390.c   |  2 +-
>  arch/x86/kvm/x86.c         |  2 +-
>  include/linux/kvm_host.h   |  2 +-
>  virt/kvm/kvm_main.c        | 16 +++-------------
>  8 files changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ecc5958e27fe..0165cf3aac3a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -73,7 +73,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	return 0;
>  }
>  
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return 0;
>  }
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..092d09fb6a7e 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -140,7 +140,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	return 0;
>  }
>  
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return 0;
>  }
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 2ad0ccd202d5..30c817f3fa0c 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -423,7 +423,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	return 0;
>  }
>  
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return kvmppc_core_check_processor_compat();
>  }
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 2e5ca43c8c49..992877e78393 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -20,7 +20,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  	return -EINVAL;
>  }
>  
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return 0;
>  }
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 577f1ead6a51..0053b81c6b02 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -252,7 +252,7 @@ int kvm_arch_hardware_enable(void)
>  	return 0;
>  }
>  
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b484ed61f37..ffb88f0b7265 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11509,7 +11509,7 @@ void kvm_arch_hardware_unsetup(void)
>  	static_call(kvm_x86_hardware_unsetup)();
>  }
>  
> -int kvm_arch_check_processor_compat(void *opaque)
> +int kvm_arch_check_processor_compat(void)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..2ad78e729bf7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1413,7 +1413,7 @@ int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
>  int kvm_arch_hardware_setup(void *opaque);
>  void kvm_arch_hardware_unsetup(void);
> -int kvm_arch_check_processor_compat(void *opaque);
> +int kvm_arch_check_processor_compat(void);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 83c57bcc6eb6..ee47d33d69e1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5643,22 +5643,14 @@ void kvm_unregister_perf_callbacks(void)
>  }
>  #endif
>  
> -struct kvm_cpu_compat_check {
> -	void *opaque;
> -	int *ret;
> -};
> -
> -static void check_processor_compat(void *data)
> +static void check_processor_compat(void *rtn)
>  {
> -	struct kvm_cpu_compat_check *c = data;
> -
> -	*c->ret = kvm_arch_check_processor_compat(c->opaque);
> +	*(int *)rtn = kvm_arch_check_processor_compat();
>  }
>  
>  int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  		  struct module *module)
>  {
> -	struct kvm_cpu_compat_check c;
>  	int r;
>  	int cpu;
>  
> @@ -5686,10 +5678,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	if (r < 0)
>  		goto out_free_1;
>  
> -	c.ret = &r;
> -	c.opaque = opaque;
>  	for_each_online_cpu(cpu) {
> -		smp_call_function_single(cpu, check_processor_compat, &c, 1);
> +		smp_call_function_single(cpu, check_processor_compat, &r, 1);
>  		if (r < 0)
>  			goto out_free_2;
>  	}

