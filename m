Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34420112A78
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 12:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfLDLsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 06:48:16 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727445AbfLDLsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 06:48:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575460095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ru1w/3i87+6yK0K8Zw9Vb8mKFm7ZL/YPQVkw38K/w8=;
        b=MCSXzAlIkIg5LVhyOZ2fKicwM3VJyLHdEnjX6923jjauAEJ1DJnDY8YjcIQpowheLDUIds
        D+e42V1B3atCdO7F4b14oTav4c3j8t6kSKvZAMz8H40j9sctjA2nszaUH34qvDEbNz9nM6
        5bLuDVAkkyq5txHBdpTizS8wZbhOj8w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-u9UOp_ogMV2o_vzL45PSCA-1; Wed, 04 Dec 2019 06:48:14 -0500
Received: by mail-wr1-f71.google.com with SMTP id d8so3505968wrq.12
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 03:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yo8O4qhDq4s6vN4xKwzp+XSNE/hjyBXZmuZIE5p/kL4=;
        b=pSvCXOvVexow2Ev2+wSdpMyV/kZ8Y0+ndGpoJ74ND7IaGDwUsahxUYALk5mR73YP50
         NZ7nmxx/nkvmFWDzG6ulc7cDE/msgjAY0M+V8dho/eyxXGGnz0butLDrsr37grVdPtaJ
         ogpkAW0PUhj7XIclMBq4TfimNbR+WZL/XJbaEeuTtils5E72EjlR43Ik+kQmbgcRWtqT
         MgOqtmPxVeEAzw5DfIgZZF9oloARdRSeM1vKeuo0Sej/hek/WOe0bFGEotoQRp4GcBqF
         9x4Y77PS4Jt01YTQkfEnloxlaIzVZPiiRIEPMhJktJ7f8sixV+UNgm6xLYwtREniSLSp
         rgWQ==
X-Gm-Message-State: APjAAAW15jZB4Zru122g08kM9MIKpQE3mpO+1Wne3/lEQwX4JTsF+GpC
        xbFrCuhfoAxItwJM4XIX1478bbPmbFHPJJwAZPs1ECb2Dp25xV2RTXZy9oPT4VKT0whrq/wka+n
        W40IOF/g73Cgc
X-Received: by 2002:a1c:7203:: with SMTP id n3mr20817517wmc.119.1575460093126;
        Wed, 04 Dec 2019 03:48:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqz54ZSn2hV8i1a04qwrryT4btmaVa3U3mVoFOkAV1Geq7MQHonby5C/R3UivKbhYSCO93WBzg==
X-Received: by 2002:a1c:7203:: with SMTP id n3mr20817494wmc.119.1575460092784;
        Wed, 04 Dec 2019 03:48:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id k7sm6243487wmi.19.2019.12.04.03.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 03:48:12 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9ba397bf-802a-bfcb-d8b2-7d3361cbb74b@redhat.com>
Date:   Wed, 4 Dec 2019 12:48:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191202204356.250357-1-aaronlewis@google.com>
Content-Language: en-US
X-MC-Unique: u9UOp_ogMV2o_vzL45PSCA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/19 21:43, Aaron Lewis wrote:
> Verify that the difference between a guest RDTSC instruction and the
> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
> MSR-store list is less than 750 cycles, 99.9% of the time.
>=20
> 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest observable L2=
 TSC=E2=80=9D)
>=20
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  x86/vmx.h       |  1 +
>  x86/vmx_tests.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 94 insertions(+)
>=20
> diff --git a/x86/vmx.h b/x86/vmx.h
> index 8496be7..21ba953 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -420,6 +420,7 @@ enum Ctrl1 {
>  =09CPU_SHADOW_VMCS=09=09=3D 1ul << 14,
>  =09CPU_RDSEED=09=09=3D 1ul << 16,
>  =09CPU_PML                 =3D 1ul << 17,
> +=09CPU_USE_TSC_SCALING=09=3D 1ul << 25,
>  };
> =20
>  enum Intr_type {
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 1d8932f..6ceaf9a 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8790,7 +8790,99 @@ static void vmx_vmcs_shadow_test(void)
>  =09enter_guest();
>  }
> =20
> +/*
> + * This test monitors the difference between a guest RDTSC instruction
> + * and the IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12
> + * VM-exit MSR-store list when taking a VM-exit on the instruction
> + * following RDTSC.
> + */
> +#define RDTSC_DIFF_ITERS 100000
> +#define RDTSC_DIFF_FAILS 100
> +#define HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD 750
> +
> +/*
> + * Set 'use TSC offsetting' and set the guest offset to the
> + * inverse of the host's current TSC value, so that the guest starts run=
ning
> + * with an effective TSC value of 0.
> + */
> +static void reset_guest_tsc_to_zero(void)
> +{
> +=09TEST_ASSERT_MSG(ctrl_cpu_rev[0].clr & CPU_USE_TSC_OFFSET,
> +=09=09=09"Expected support for 'use TSC offsetting'");
> +
> +=09vmcs_set_bits(CPU_EXEC_CTRL0, CPU_USE_TSC_OFFSET);
> +=09vmcs_write(TSC_OFFSET, -rdtsc());
> +}
> +
> +static void rdtsc_vmexit_diff_test_guest(void)
> +{
> +=09int i;
> +
> +=09for (i =3D 0; i < RDTSC_DIFF_ITERS; i++)
> +=09=09/* Ensure rdtsc is the last instruction before the vmcall. */
> +=09=09asm volatile("rdtsc; vmcall" : : : "eax", "edx");
> +}
> =20
> +/*
> + * This function only considers the "use TSC offsetting" VM-execution
> + * control.  It does not handle "use TSC scaling" (because the latter
> + * isn't available to the host today.)
> + */
> +static unsigned long long host_time_to_guest_time(unsigned long long t)
> +{
> +=09TEST_ASSERT(!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
> +=09=09    !(vmcs_read(CPU_EXEC_CTRL1) & CPU_USE_TSC_SCALING));
> +
> +=09if (vmcs_read(CPU_EXEC_CTRL0) & CPU_USE_TSC_OFFSET)
> +=09=09t +=3D vmcs_read(TSC_OFFSET);
> +
> +=09return t;
> +}
> +
> +static unsigned long long rdtsc_vmexit_diff_test_iteration(void)
> +{
> +=09unsigned long long guest_tsc, host_to_guest_tsc;
> +
> +=09enter_guest();
> +=09skip_exit_vmcall();
> +=09guest_tsc =3D (u32) regs.rax + (regs.rdx << 32);
> +=09host_to_guest_tsc =3D host_time_to_guest_time(exit_msr_store[0].value=
);
> +
> +=09return host_to_guest_tsc - guest_tsc;
> +}
> +
> +static void rdtsc_vmexit_diff_test(void)
> +{
> +=09int fail =3D 0;
> +=09int i;
> +
> +=09test_set_guest(rdtsc_vmexit_diff_test_guest);
> +
> +=09reset_guest_tsc_to_zero();
> +
> +=09/*
> +=09 * Set up the VMCS12 VM-exit MSR-store list to store just one
> +=09 * MSR: IA32_TIME_STAMP_COUNTER. Note that the value stored is
> +=09 * in the host time domain (i.e., it is not adjusted according
> +=09 * to the TSC multiplier and TSC offset fields in the VMCS12,
> +=09 * as a guest RDTSC would be.)
> +=09 */
> +=09exit_msr_store =3D alloc_page();
> +=09exit_msr_store[0].index =3D MSR_IA32_TSC;
> +=09vmcs_write(EXI_MSR_ST_CNT, 1);
> +=09vmcs_write(EXIT_MSR_ST_ADDR, virt_to_phys(exit_msr_store));
> +
> +=09for (i =3D 0; i < RDTSC_DIFF_ITERS; i++) {
> +=09=09if (rdtsc_vmexit_diff_test_iteration() >=3D
> +=09=09    HOST_CAPTURED_GUEST_TSC_DIFF_THRESHOLD)
> +=09=09=09fail++;
> +=09}
> +
> +=09enter_guest();
> +
> +=09report("RDTSC to VM-exit delta too high in %d of %d iterations",
> +=09       fail < RDTSC_DIFF_FAILS, fail, RDTSC_DIFF_ITERS);
> +}
> =20
>  static int invalid_msr_init(struct vmcs *vmcs)
>  {
> @@ -9056,5 +9148,6 @@ struct vmx_test vmx_tests[] =3D {
>  =09/* Atomic MSR switch tests. */
>  =09TEST(atomic_switch_max_msrs_test),
>  =09TEST(atomic_switch_overflow_msrs_test),
> +=09TEST(rdtsc_vmexit_diff_test),
>  =09{ NULL, NULL, NULL, NULL, NULL, {0} },
>  };
>=20

Applied, thanks.

Paolo

