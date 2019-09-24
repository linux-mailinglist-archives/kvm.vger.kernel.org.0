Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1B1BC9F9
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 16:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395504AbfIXORU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 10:17:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43920 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2394680AbfIXORT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Sep 2019 10:17:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569334637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ufjQPEsFm1xeguZRHsC9ByLLmAwWcgBv4sT0YNt9UKk=;
        b=SHeT27AplZN+4gFJDtZfH50AXRrTU0n6UVXHExPh4Nrma23RzK12aueclNfCQEa5BbkWgz
        rSFe8VD9KA73xQiMjrEeDQyklnGctnOBgjsv1vUPA6o+6thEIlLPze1UwvBk6BPR28jbgq
        eZYQOgCnH+tF79MKFz3yZLL0mi6u7Qw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-kVSAQtOxPaC0l9RgyblwsA-1; Tue, 24 Sep 2019 10:17:15 -0400
Received: by mail-wr1-f69.google.com with SMTP id w8so638969wrm.3
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 07:17:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f7BWlWtqSdXGaQO+du21j+jMJq+N4Dnqgspn3thOEzk=;
        b=Q1A5+oi13TWtvZbXv+6okp4DAXCOGzWNxuG+h0ojragWWcNaFKyi+72/Zx+sK+dLZh
         YG0bZNNNZdXI6PwS2QPWof/AwLRbDLWkVx2aiVVcx5KKssmhTzeYXXJoaL1LqSvEarfD
         y1hgIVNaNAqDfGi3IWgjmxdznvRTupT3HOEbLOKetuwvTDFly2W/BrwNlq7hvdfKBAZK
         D0pes3iPTeDDX9Tt3tXyxqPIRmbTrW5oHulLOJny97QHi3MJjGRaEqpm07g4842s1gr4
         5DCaChIJD3l/msHDYg+pzSezHdYuY8cLSkrHnwg9uak2UHPAvEHmXpuKUYEAF/XpOdz5
         glpg==
X-Gm-Message-State: APjAAAUmRR9aYZfB0uiuPSPvbQZoK4DIMkNLI9rhOfqJuTZp0sptmkRs
        EQqIbBziTVDPZfkES5DQApx87Kpt12UXP5eaG/IXkdLZl7aTWmX2HOf9Hl4yvDaBLN9aM76vS48
        Sp10asy2k+Jz/
X-Received: by 2002:a5d:680d:: with SMTP id w13mr2484827wru.282.1569334634411;
        Tue, 24 Sep 2019 07:17:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzddOK1kGg6+1DpeeqtXWPpUqKRUo47l/oChnbBCNBvnu24MyBy18otAWtT4eRN33u3NJR1HA==
X-Received: by 2002:a5d:680d:: with SMTP id w13mr2484794wru.282.1569334634083;
        Tue, 24 Sep 2019 07:17:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id y14sm2839135wrd.84.2019.09.24.07.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 07:17:13 -0700 (PDT)
Subject: Re: [PATCH v3] kvm: nvmx: limit atomic switch MSRs
To:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com
References: <20190917185057.224221-1-marcorr@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <72cbee37-c66b-7a02-2b95-7ed829aee5c2@redhat.com>
Date:   Tue, 24 Sep 2019 16:17:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917185057.224221-1-marcorr@google.com>
Content-Language: en-US
X-MC-Unique: kVSAQtOxPaC0l9RgyblwsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/19 20:50, Marc Orr wrote:
> Allowing an unlimited number of MSRs to be specified via the VMX
> load/store MSR lists (e.g., vm-entry MSR load list) is bad for two
> reasons. First, a guest can specify an unreasonable number of MSRs,
> forcing KVM to process all of them in software. Second, the SDM bounds
> the number of MSRs allowed to be packed into the atomic switch MSR lists.
> Quoting the "Miscellaneous Data" section in the "VMX Capability
> Reporting Facility" appendix:
>=20
> "Bits 27:25 is used to compute the recommended maximum number of MSRs
> that should appear in the VM-exit MSR-store list, the VM-exit MSR-load
> list, or the VM-entry MSR-load list. Specifically, if the value bits
> 27:25 of IA32_VMX_MISC is N, then 512 * (N + 1) is the recommended
> maximum number of MSRs to be included in each list. If the limit is
> exceeded, undefined processor behavior may result (including a machine
> check during the VMX transition)."
>=20
> Because KVM needs to protect itself and can't model "undefined processor
> behavior", arbitrarily force a VM-entry to fail due to MSR loading when
> the MSR load list is too large. Similarly, trigger an abort during a VM
> exit that encounters an MSR load list or MSR store list that is too large=
.
>=20
> The MSR list size is intentionally not pre-checked so as to maintain
> compatibility with hardware inasmuch as possible.
>=20
> Test these new checks with the kvm-unit-test "x86: nvmx: test max atomic
> switch MSRs".
>=20
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
> v2 -> v3
> * Updated commit message.
> * Removed superflous function declaration.
> * Expanded in-line comment.
>=20
>  arch/x86/include/asm/vmx.h |  1 +
>  arch/x86/kvm/vmx/nested.c  | 44 ++++++++++++++++++++++++++++----------
>  2 files changed, 34 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index a39136b0d509..a1f6ed187ccd 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -110,6 +110,7 @@
>  #define VMX_MISC_SAVE_EFER_LMA=09=09=090x00000020
>  #define VMX_MISC_ACTIVITY_HLT=09=09=090x00000040
>  #define VMX_MISC_ZERO_LEN_INS=09=09=090x40000000
> +#define VMX_MISC_MSR_LIST_MULTIPLIER=09=09512
> =20
>  /* VMFUNC functions */
>  #define VMX_VMFUNC_EPTP_SWITCHING               0x00000001
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ced9fba32598..0e29882bb45f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -190,6 +190,16 @@ static void nested_vmx_abort(struct kvm_vcpu *vcpu, =
u32 indicator)
>  =09pr_debug_ratelimited("kvm: nested vmx abort, indicator %d\n", indicat=
or);
>  }
> =20
> +static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> +{
> +=09return fixed_bits_valid(control, low, high);
> +}
> +
> +static inline u64 vmx_control_msr(u32 low, u32 high)
> +{
> +=09return low | ((u64)high << 32);
> +}
> +
>  static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>  {
>  =09secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
> @@ -856,18 +866,36 @@ static int nested_vmx_store_msr_check(struct kvm_vc=
pu *vcpu,
>  =09return 0;
>  }
> =20
> +static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
> +{
> +=09struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> +=09u64 vmx_misc =3D vmx_control_msr(vmx->nested.msrs.misc_low,
> +=09=09=09=09       vmx->nested.msrs.misc_high);
> +
> +=09return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTIPLIE=
R;
> +}
> +
>  /*
>   * Load guest's/host's msr at nested entry/exit.
>   * return 0 for success, entry index for failure.
> + *
> + * One of the failure modes for MSR load/store is when a list exceeds th=
e
> + * virtual hardware's capacity. To maintain compatibility with hardware =
inasmuch
> + * as possible, process all valid entries before failing rather than pre=
check
> + * for a capacity violation.
>   */
>  static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count=
)
>  {
>  =09u32 i;
>  =09struct vmx_msr_entry e;
>  =09struct msr_data msr;
> +=09u32 max_msr_list_size =3D nested_vmx_max_atomic_switch_msrs(vcpu);
> =20
>  =09msr.host_initiated =3D false;
>  =09for (i =3D 0; i < count; i++) {
> +=09=09if (unlikely(i >=3D max_msr_list_size))
> +=09=09=09goto fail;
> +
>  =09=09if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
>  =09=09=09=09=09&e, sizeof(e))) {
>  =09=09=09pr_debug_ratelimited(
> @@ -899,9 +927,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcp=
u, u64 gpa, u32 count)
>  {
>  =09u32 i;
>  =09struct vmx_msr_entry e;
> +=09u32 max_msr_list_size =3D nested_vmx_max_atomic_switch_msrs(vcpu);
> =20
>  =09for (i =3D 0; i < count; i++) {
>  =09=09struct msr_data msr_info;
> +
> +=09=09if (unlikely(i >=3D max_msr_list_size))
> +=09=09=09return -EINVAL;
> +
>  =09=09if (kvm_vcpu_read_guest(vcpu,
>  =09=09=09=09=09gpa + i * sizeof(e),
>  =09=09=09=09=09&e, 2 * sizeof(u32))) {
> @@ -1009,17 +1042,6 @@ static u16 nested_get_vpid02(struct kvm_vcpu *vcpu=
)
>  =09return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
>  }
> =20
> -
> -static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> -{
> -=09return fixed_bits_valid(control, low, high);
> -}
> -
> -static inline u64 vmx_control_msr(u32 low, u32 high)
> -{
> -=09return low | ((u64)high << 32);
> -}
> -
>  static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>  {
>  =09superset &=3D mask;
>=20

Queued, thanks.

Paolo

