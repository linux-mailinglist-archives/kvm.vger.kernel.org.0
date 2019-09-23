Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F44BB8C1
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbfIWP5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:57:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387399AbfIWP5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 11:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569254266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqXr66p9BTOC4c6rO49LKpsEXcTiRdNwHlHSpVVSfek=;
        b=FftqNWsNv86/b85gaMrG+n0ospv5RTzlhSpEd4iDDoqPJ8cI+/mFRGQSZm/vK4qCQ2oPpk
        sqZ/r4YNPL01bBQnE1BBI6q4k8lb1032UhKO8CaKp7wCbN38GKOa+qH3RkQ7Epib/ip7HN
        PzFJc+3j74/gTI5kczNG97uEA69vN58=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-VyyE7P39PWa72z0-79CpyA-1; Mon, 23 Sep 2019 11:57:45 -0400
Received: by mail-wr1-f69.google.com with SMTP id a4so5007785wrg.8
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 08:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qmOR/sRaPdaLp7pbdrzsHY8PX3GradHTD4pZ29KBFwE=;
        b=qPphM7kFLTjRxcQaJ3dEkTtlqz9eWXouxW2U/zGDXwVcvTI9OOWeR00yRinxZX1e7g
         evE9QeCptoQeAG2IENCODdRClDVC+e7vsaxGNHW364gmdOb+OVhAR7ooLrTqmB+qya5A
         FgiGB3wGu0G4gudXtUrc7m6vj3nISD3hQDMUlTeMD66qhM/FgsSVi02tejovBLfdO4gA
         hIYTJ+LSYlu6SNuh6D1FUJJE097jnDRaQqCCqwZx5M1h/IwJKk3V6FDZvmZMYs3x2wgt
         EtpoPYpcIIcoDlJgYLwMkyxCcN5fuoZswbweOwHWrpiGd5l8xbVp3zu4TYMLOgrhEwtK
         NQvg==
X-Gm-Message-State: APjAAAWCUtRJrTnhO+CWVWWR96bmguJIdsxEtX0In3k3ZNQsvx1uomc5
        HyWCR/7yvjcXWj/saaKiHvIzqeoX9WSxlcwFiiVwOotTVlgJ8iuUBX10OFmmFt5JwzGHP5mpKdy
        vetvGZLumIsKB
X-Received: by 2002:a7b:c7c5:: with SMTP id z5mr256393wmk.37.1569254263750;
        Mon, 23 Sep 2019 08:57:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwRBJeUP5nWJ6EI3c/i7RuABKPQ/LjlnTfKN9L9IAUgMgSmzPiM3qsG5OOO6GhqwQbSEXMg4w==
X-Received: by 2002:a7b:c7c5:: with SMTP id z5mr256371wmk.37.1569254263396;
        Mon, 23 Sep 2019 08:57:43 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b6a:1220:4519:9c66:87bb:ff1d? ([2a01:e35:8b6a:1220:4519:9c66:87bb:ff1d])
        by smtp.gmail.com with ESMTPSA id n7sm12604644wrt.59.2019.09.23.08.57.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Sep 2019 08:57:42 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH v5 2/2] x86: nvmx: test max atomic switch
 MSRs
From:   Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <20190918222354.184162-2-marcorr@google.com>
Date:   Mon, 23 Sep 2019 17:57:39 +0200
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        sean.j.christopherson@intel.com, krish.sadhukhan@oracle.com
Message-Id: <83A0AF0F-49DA-44FF-8EC0-2E462AA10C65@redhat.com>
References: <20190918222354.184162-1-marcorr@google.com>
 <20190918222354.184162-2-marcorr@google.com>
To:     Marc Orr <marcorr@google.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-MC-Unique: VyyE7P39PWa72z0-79CpyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 19 Sep 2019, at 00:23, Marc Orr <marcorr@google.com> wrote:
>=20
> Excerise nested VMX's atomic MSR switch code (e.g., VM-entry MSR-load

Nit: Exercise

> list) at the maximum number of MSRs supported, as described in the SDM,
> in the appendix chapter titled "MISCELLANEOUS DATA".
>=20
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
> v4 -> v5
> * Replaced local pointer declarations for MSR lists with existing global
>  declarations.
> * Replaced atomic_switch_msr_limit_test_guest() with existing vmcall()
>  funciton.
> * Removed redundant assert_exit_reason(VMX_VMCALL).
>=20
> lib/alloc_page.c  |   5 ++
> lib/alloc_page.h  |   1 +
> x86/unittests.cfg |   2 +-
> x86/vmx_tests.c   | 134 ++++++++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 141 insertions(+), 1 deletion(-)
>=20
> diff --git a/lib/alloc_page.c b/lib/alloc_page.c
> index 97d13395ff08..ed236389537e 100644
> --- a/lib/alloc_page.c
> +++ b/lib/alloc_page.c
> @@ -53,6 +53,11 @@ void free_pages(void *mem, unsigned long size)
> =09spin_unlock(&lock);
> }
>=20
> +void free_pages_by_order(void *mem, unsigned long order)
> +{
> +=09free_pages(mem, 1ul << (order + PAGE_SHIFT));
> +}
> +
> void *alloc_page()
> {
> =09void *p;
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 5cdfec57a0a8..739a91def979 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -14,5 +14,6 @@ void *alloc_page(void);
> void *alloc_pages(unsigned long order);
> void free_page(void *page);
> void free_pages(void *mem, unsigned long size);
> +void free_pages_by_order(void *mem, unsigned long order);
>=20
> #endif
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 694ee3d42f3a..05122cf91ea1 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -227,7 +227,7 @@ extra_params =3D -cpu qemu64,+umip
>=20
> [vmx]
> file =3D vmx.flat
> -extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept=
_access* -vmx_smp* -vmx_vmcs_shadow_test"
> +extra_params =3D -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept=
_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test"
> arch =3D x86_64
> groups =3D vmx
>=20
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index f035f24a771a..cc33ea7b5114 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8570,6 +8570,137 @@ static int invalid_msr_entry_failure(struct vment=
ry_failure *failure)
> =09return VMX_TEST_VMEXIT;
> }
>=20
> +/*
> + * The max number of MSRs in an atomic switch MSR list is:
> + * (111B + 1) * 512 =3D 4096
> + *
> + * Each list entry consumes:
> + * 4-byte MSR index + 4 bytes reserved + 8-byte data =3D 16 bytes
> + *
> + * Allocate 128 kB to cover max_msr_list_size (i.e., 64 kB) and then som=
e.
> + */
> +static const u32 msr_list_page_order =3D 5;
> +
> +static void atomic_switch_msr_limit_test_guest(void)
> +{
> +=09vmcall();
> +}
> +
> +static void populate_msr_list(struct vmx_msr_entry *msr_list,
> +=09=09=09      size_t byte_capacity, int count)
> +{
> +=09int i;
> +
> +=09for (i =3D 0; i < count; i++) {
> +=09=09msr_list[i].index =3D MSR_IA32_TSC;
> +=09=09msr_list[i].reserved =3D 0;
> +=09=09msr_list[i].value =3D 0x1234567890abcdef;
> +=09}
> +
> +=09memset(msr_list + count, 0xff,
> +=09       byte_capacity - count * sizeof(*msr_list));
> +}
> +
> +static int max_msr_list_size(void)
> +{
> +=09u32 vmx_misc =3D rdmsr(MSR_IA32_VMX_MISC);
> +=09u32 factor =3D ((vmx_misc & GENMASK(27, 25)) >> 25) + 1;
> +
> +=09return factor * 512;
> +}
> +
> +static void atomic_switch_msrs_test(int count)
> +{
> +=09struct vmx_msr_entry *vm_enter_load;
> +=09struct vmx_msr_entry *vm_exit_load;
> +=09struct vmx_msr_entry *vm_exit_store;
> +=09int max_allowed =3D max_msr_list_size();
> +=09int byte_capacity =3D 1ul << (msr_list_page_order + PAGE_SHIFT);
> +=09/* KVM signals VM-Abort if an exit MSR list exceeds the max size. */
> +=09int exit_count =3D MIN(count, max_allowed);
> +
> +=09/*
> +=09 * Check for the IA32_TSC MSR,
> +=09 * available with the "TSC flag" and used to populate the MSR lists.
> +=09 */
> +=09if (!(cpuid(1).d & (1 << 4))) {
> +=09=09report_skip(__func__);
> +=09=09return;
> +=09}
> +
> +=09/* Set L2 guest. */
> +=09test_set_guest(atomic_switch_msr_limit_test_guest);
> +
> +=09/* Setup atomic MSR switch lists. */
> +=09vm_enter_load =3D alloc_pages(msr_list_page_order);
> +=09vm_exit_load =3D alloc_pages(msr_list_page_order);
> +=09vm_exit_store =3D alloc_pages(msr_list_page_order);
> +
> +=09vmcs_write(ENTER_MSR_LD_ADDR, (u64)vm_enter_load);
> +=09vmcs_write(EXIT_MSR_LD_ADDR, (u64)vm_exit_load);
> +=09vmcs_write(EXIT_MSR_ST_ADDR, (u64)vm_exit_store);
> +
> +=09/*
> +=09 * VM-Enter should succeed up to the max number of MSRs per list, and
> +=09 * should not consume junk beyond the last entry.
> +=09 */
> +=09populate_msr_list(vm_enter_load, byte_capacity, count);
> +=09populate_msr_list(vm_exit_load, byte_capacity, exit_count);
> +=09populate_msr_list(vm_exit_store, byte_capacity, exit_count);
> +
> +=09vmcs_write(ENT_MSR_LD_CNT, count);
> +=09vmcs_write(EXI_MSR_LD_CNT, exit_count);
> +=09vmcs_write(EXI_MSR_ST_CNT, exit_count);
> +
> +=09if (count <=3D max_allowed) {
> +=09=09enter_guest();
> +=09=09assert_exit_reason(VMX_VMCALL);
> +=09=09skip_exit_vmcall();
> +=09} else {
> +=09=09u32 exit_reason;
> +=09=09u32 exit_reason_want;
> +=09=09u32 exit_qual;
> +
> +=09=09enter_guest_with_invalid_guest_state();
> +
> +=09=09exit_reason =3D vmcs_read(EXI_REASON);
> +=09=09exit_reason_want =3D VMX_FAIL_MSR | VMX_ENTRY_FAILURE;
> +=09=09report("exit_reason, %u, is %u.",
> +=09=09       exit_reason =3D=3D exit_reason_want, exit_reason,
> +=09=09       exit_reason_want);
> +
> +=09=09exit_qual =3D vmcs_read(EXI_QUALIFICATION);
> +=09=09report("exit_qual, %u, is %u.", exit_qual =3D=3D max_allowed + 1,
> +=09=09       exit_qual, max_allowed + 1);
> +
> +=09=09/*
> +=09=09 * Re-enter the guest with valid counts
> +=09=09 * and proceed past the single vmcall instruction.
> +=09=09 */
> +=09=09vmcs_write(ENT_MSR_LD_CNT, 0);
> +=09=09vmcs_write(EXI_MSR_LD_CNT, 0);
> +=09=09vmcs_write(EXI_MSR_ST_CNT, 0);
> +=09=09enter_guest();
> +=09=09skip_exit_vmcall();
> +=09}
> +
> +=09/* Cleanup. */
> +=09enter_guest();
> +=09skip_exit_vmcall();
> +=09free_pages_by_order(vm_enter_load, msr_list_page_order);
> +=09free_pages_by_order(vm_exit_load, msr_list_page_order);
> +=09free_pages_by_order(vm_exit_store, msr_list_page_order);
> +}
> +
> +static void atomic_switch_max_msrs_test(void)
> +{
> +=09atomic_switch_msrs_test(max_msr_list_size());
> +}
> +
> +static void atomic_switch_overflow_msrs_test(void)
> +{
> +=09atomic_switch_msrs_test(max_msr_list_size() + 1);
> +}
>=20
> #define TEST(name) { #name, .v2 =3D name }
>=20
> @@ -8660,5 +8791,8 @@ struct vmx_test vmx_tests[] =3D {
> =09TEST(ept_access_test_paddr_read_execute_ad_enabled),
> =09TEST(ept_access_test_paddr_not_present_page_fault),
> =09TEST(ept_access_test_force_2m_page),
> +=09/* Atomic MSR switch tests. */
> +=09TEST(atomic_switch_max_msrs_test),
> +=09TEST(atomic_switch_overflow_msrs_test),
> =09{ NULL, NULL, NULL, NULL, NULL, {0} },
> };
> --=20
> 2.23.0.237.gc6a4ce50a0-goog
>=20

