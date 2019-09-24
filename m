Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3556BC93B
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441132AbfIXNyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:54:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31430 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438668AbfIXNyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569333242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ufnCoXgSEf18vQ6ZLM9J5QGmZ6hgLhAjBp8FSDIQZGY=;
        b=PErJffyBiHMykQVA1my3LDbmf8VDr49gsBzeCtAy4Bbc3IQi2WwZf+uNZwfufDr6tXaYKu
        6qs0+l3oDR6hTebUmIvSaXNxvLwCg10IYT/CinjCq/qct+NfGqwOHQBV3QqQenIWvTBREm
        BiPEHBhutFyJAv7h39u5EVADrtk+V0E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-zh-pHM3hNqOli4KFFiVCYg-1; Tue, 24 Sep 2019 09:53:58 -0400
Received: by mail-wm1-f72.google.com with SMTP id m6so55570wmf.2
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HdjEWSAdSqLdpZHgeal5aDiDgkL8NSPVXQjey9rwTGI=;
        b=gPtYyHtq9xkR8VXNUER/AcZ2iw8Mj43QTRB86Qo+GOhx88Rf1fSaguuE3djxZ9QaOv
         Hd6v7FAHhTvxayjKksCAVXk+KIWimfCEYmuWdmHMGSDQtEVKqIZd25u1gUhIsZRM5Tbj
         POvMxuHZyNYTucrxklQMTwbzM0lky9mhpLeZSdXNQtaWDHegXO4E99qX9CTqJGsZVUH6
         x6GUyuw3nyoKpFnMzXCbk5uw9XamhbcaUVr6mQvIC9Qd3OBka23XfXdE/KpiA2ivYk2r
         CfSMNd+E94wgVPt7oNjGuRBjRsX5n8W9s2xmhR9OrgWRWl4x3/cf1Fr7OsAsS4e1Gfyb
         +A8w==
X-Gm-Message-State: APjAAAUfDSImYbZeFbTgNR2Upg2wgNoCaA5KMv8ELEhdStBPkACqFP5T
        3HujBjRynmjXv0MJW3Fm2+POOYIhXdVLcssDdNJc+cSw+OaKv2GnvugqaHm1UKTe9AGWEmKKpTS
        EiWO8Fl5vLKIO
X-Received: by 2002:adf:fc05:: with SMTP id i5mr2515391wrr.134.1569333237492;
        Tue, 24 Sep 2019 06:53:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyw7tGIPqhh/sT5PSYxepjOc1Dj6miwQjJV6KfGw+x9NCUV2/O1oT++yJaNGPMN6GHP5+l1Jg==
X-Received: by 2002:adf:fc05:: with SMTP id i5mr2515362wrr.134.1569333237166;
        Tue, 24 Sep 2019 06:53:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id j26sm3850101wrd.2.2019.09.24.06.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 06:53:56 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: nvmx: limit atomic switch MSRs
To:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com
References: <20190914003940.203636-1-marcorr@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9395ca0c-c4a7-8f9e-149c-da1ef7a775b3@redhat.com>
Date:   Tue, 24 Sep 2019 15:53:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190914003940.203636-1-marcorr@google.com>
Content-Language: en-US
X-MC-Unique: zh-pHM3hNqOli4KFFiVCYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/19 02:39, Marc Orr wrote:
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
> Thus, force a VM-entry to fail due to MSR loading when the MSR load
> list is too large. Similarly, trigger an abort during a VM exit that
> encounters an MSR load list or MSR store list that is too large.
>=20
> Test these new checks with the kvm-unit-test "x86: nvmx: test max atomic
> switch MSRs".
>=20
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
> v1 -> v2
> * Updated description to distinguish the relevant appendix.
> * Renamed VMX_MISC_MSR_LIST_INCREMENT to VMX_MISC_MSR_LIST_MULTIPLIER.
> * Moved vmx_control_msr() and vmx_control_verify() up in the source.
> * Modified nested_vmx_store_msr() to fail lazily, like
>   nested_vmx_load_msr().
>=20
>  arch/x86/include/asm/vmx.h |  1 +
>  arch/x86/kvm/vmx/nested.c  | 41 ++++++++++++++++++++++++++++----------
>  2 files changed, 31 insertions(+), 11 deletions(-)
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
> index ced9fba32598..bca0167b8bdd 100644
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
> @@ -856,6 +866,17 @@ static int nested_vmx_store_msr_check(struct kvm_vcp=
u *vcpu,
>  =09return 0;
>  }
> =20
> +static u64 vmx_control_msr(u32 low, u32 high);
> +
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
> @@ -865,9 +886,13 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu=
, u64 gpa, u32 count)
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
> @@ -899,9 +924,14 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcp=
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
> @@ -1009,17 +1039,6 @@ static u16 nested_get_vpid02(struct kvm_vcpu *vcpu=
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

Can you please resubmit?

Thanks,

Paolo

