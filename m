Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299A34ADBD
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfFRWQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:16:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53420 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRWQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:16:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMEWqs094651;
        Tue, 18 Jun 2019 22:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=PPaVNLQ5HhtYa4566gsYIin60iKIFZgMTljCf2GP7TE=;
 b=iIVcuIC2byZGUSnk9BeoWytdJMisK9CbIV9fxtweIx7f3qKL6EOzU9wZdkEkLy1ALBTo
 nNzmRGeGx5B84xZ83R/nJB1m96t4kqi33OH1FhyvSRHXEZlYxcbWdS7/O9+syhWs4T5q
 rhhRQEBygXNhr/a8/TtvBFIcxVNqfiyiZnt6lyi0ZHUrJLZxoFKVG/vGS4BkCcppliJr
 l+Of5rTFPCW9ElNH95zFVBsl4zkcsFhT954q3Rp+/JQgXpr+bEFvHRYMNfplVQT/ZkTO
 w/D0PE67JELtEzKaf10eDC94spCYDCTv4HB52mUV/R9UiwIEZ6zfsqbItRj5hMpFKfyw ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t780983pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:16:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IMFd2M011167;
        Tue, 18 Jun 2019 22:16:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t77ymree0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:16:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IMG01V018651;
        Tue, 18 Jun 2019 22:16:00 GMT
Received: from [10.141.197.71] (/10.141.197.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 15:16:00 -0700
Subject: Re: [Qemu-devel] [QEMU PATCH v3 1/9] KVM: Introduce
 kvm_arch_destroy_vcpu()
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        dgilbert@redhat.com, pbonzini@redhat.com, rth@twiddle.net,
        jmattson@google.com
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-2-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <69d1badb-7507-c504-21e3-26805332483b@oracle.com>
Date:   Tue, 18 Jun 2019 15:15:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617175658.135869-2-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/2019 10:56 AM, Liran Alon wrote:
> Simiar to how kvm_init_vcpu() calls kvm_arch_init_vcpu() to perform
> arch-dependent initialisation, introduce kvm_arch_destroy_vcpu()
> to be called from kvm_destroy_vcpu() to perform arch-dependent
> destruction.
>
> This was added because some architectures (Such as i386)
> currently do not free memory that it have allocated in
> kvm_arch_init_vcpu().
>
> Suggested-by: Maran Wilson <maran.wilson@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   accel/kvm/kvm-all.c  |  5 +++++
>   include/sysemu/kvm.h |  1 +
>   target/arm/kvm32.c   |  5 +++++
>   target/arm/kvm64.c   |  5 +++++
>   target/i386/kvm.c    | 12 ++++++++++++
>   target/mips/kvm.c    |  5 +++++
>   target/ppc/kvm.c     |  5 +++++
>   target/s390x/kvm.c   | 10 ++++++++++
>   8 files changed, 48 insertions(+)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 524c4ddfbd0f..59a3aa3a40da 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -292,6 +292,11 @@ int kvm_destroy_vcpu(CPUState *cpu)
>   
>       DPRINTF("kvm_destroy_vcpu\n");
>   
> +    ret = kvm_arch_destroy_vcpu(cpu);
> +    if (ret < 0) {
> +        goto err;
> +    }
> +
>       mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0);
>       if (mmap_size < 0) {
>           ret = mmap_size;
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index a6d1cd190fed..64f55e519df7 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -371,6 +371,7 @@ int kvm_arch_put_registers(CPUState *cpu, int level);
>   int kvm_arch_init(MachineState *ms, KVMState *s);
>   
>   int kvm_arch_init_vcpu(CPUState *cpu);
> +int kvm_arch_destroy_vcpu(CPUState *cpu);
>   
>   bool kvm_vcpu_id_is_valid(int vcpu_id);
>   
> diff --git a/target/arm/kvm32.c b/target/arm/kvm32.c
> index 4e54e372a668..51f78f722b18 100644
> --- a/target/arm/kvm32.c
> +++ b/target/arm/kvm32.c
> @@ -240,6 +240,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       return kvm_arm_init_cpreg_list(cpu);
>   }
>   
> +int kvm_arch_destroy_vcpu(CPUState *cs)
> +{
> +	return 0;
> +}
> +
>   typedef struct Reg {
>       uint64_t id;
>       int offset;
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 998d21f399f4..22d19c9aec6f 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -654,6 +654,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       return kvm_arm_init_cpreg_list(cpu);
>   }
>   
> +int kvm_arch_destroy_vcpu(CPUState *cs)
> +{
> +    return 0;
> +}
> +
>   bool kvm_arm_reg_syncs_via_cpreg_list(uint64_t regidx)
>   {
>       /* Return true if the regidx is a register we should synchronize
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 3b29ce5c0d08..29889aa6b001 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1349,6 +1349,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       return r;
>   }
>   
> +int kvm_arch_destroy_vcpu(CPUState *cs)
> +{
> +    X86CPU *cpu = X86_CPU(cs);
> +
> +    if (cpu->kvm_msr_buf) {
> +        g_free(cpu->kvm_msr_buf);
> +        cpu->kvm_msr_buf = NULL;
> +    }
> +
> +    return 0;
> +}
> +
>   void kvm_arch_reset_vcpu(X86CPU *cpu)
>   {
>       CPUX86State *env = &cpu->env;
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index 8e72850962e1..938f8f144b74 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -91,6 +91,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       return ret;
>   }
>   
> +int kvm_arch_destroy_vcpu(CPUState *cs)
> +{
> +    return 0;
> +}
> +
>   void kvm_mips_reset_vcpu(MIPSCPU *cpu)
>   {
>       CPUMIPSState *env = &cpu->env;
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 3bf0a46c3352..1967ccc51791 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -521,6 +521,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       return ret;
>   }
>   
> +int kvm_arch_destroy_vcpu(CPUState *cs)
> +{
> +    return 0;
> +}
> +
>   static void kvm_sw_tlb_put(PowerPCCPU *cpu)
>   {
>       CPUPPCState *env = &cpu->env;
> diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
> index e5e2b691f253..c2747c31649b 100644
> --- a/target/s390x/kvm.c
> +++ b/target/s390x/kvm.c
> @@ -368,6 +368,16 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       return 0;
>   }
>   
> +int kvm_arch_destroy_vcpu(CPUState *cs)
> +{
> +    S390CPU *cpu = S390_CPU(cs);
> +
> +    g_free(cpu->irqstate);
> +    cpu->irqstate = NULL;
> +
> +    return 0;
> +}
> +
>   void kvm_s390_reset_vcpu(S390CPU *cpu)
>   {
>       CPUState *cs = CPU(cpu);

Reviewed-by: Maran Wilson <maran.wilson@oracle.com>

Thanks,
-Maran
