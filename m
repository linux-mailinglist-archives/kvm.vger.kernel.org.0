Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B6A676CF8
	for <lists+kvm@lfdr.de>; Sun, 22 Jan 2023 13:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjAVMps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Jan 2023 07:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjAVMpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Jan 2023 07:45:46 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CAB1C307;
        Sun, 22 Jan 2023 04:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1674391445; bh=MFKhMi2BhxsrpqMpxw0VXiU1BWJhxo7YrbKNiW+SpFw=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=EBG7qFRmu5j5WcOY2/MzVHj3RZafsuvig6pLG53dgcETSJcLYX1dKVXEOy2LYihO0
         2LJiM33JM030Va+zu7FovnBzwc4qItT5LoAPy05Z7pIQjYa8v5zGgeK38bpbklvDI2
         m1FpoQkN6xKOaOf4SPj+UlUrvdqGul8ClUo1OeZM7Sqzz4WpJECvXfYIWfDEXT/Kr1
         PIgOWAR7y3yeLE8kzj3n8Ci85zuonpbeW2geldJwfKU8DQ377Wr8n5qcs2BwkNC1fc
         kPOzq2E4VDbAo4eocdN5OKUqe63KF3yZJaGvfB6JOsGHhcPaqCBa77hoIJw1qNcp4N
         mIpZLACGxrJzQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([134.147.69.133]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0X8o-1oWISn2iwe-00wUlR; Sun, 22
 Jan 2023 13:44:05 +0100
Date:   Sun, 22 Jan 2023 13:43:48 +0100
From:   Tom Dohrmann <erbse.13@gmx.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com
Subject: Re: [PATCH RFC v7 06/64] KVM: x86: Add platform hooks for private
 memory invalidations
Message-ID: <Y80vhKwQyw8hS/22@notebook>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-7-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221214194056.161492-7-michael.roth@amd.com>
X-Provags-ID: V03:K1:29H+BJxSNIZwlmVoZef3buXOySN2V+Tv3MGKW3XCGaLwqmfvQjI
 dFJD9Y2Vi00avGbFrReuJszz9sNgLJSYUP8TBRcVJnaE+lx2lcXX1NWQKu0PQTWGpunh4n8
 Y4AjwSwgYSEZW4D8TUxV1fn/xx06zalp4cWjISnjzwxo8rpsKiuG83hRnK9NoFEV6UHAXzB
 LqHfz2fxJ8KfhpxRmsGSQ==
UI-OutboundReport: notjunk:1;M01:P0:JhdxfLbvoM8=;CxBfe3mWXBdyCI8zvOOB9TUfVey
 IFyW/9DUe5mRJuOKYQm54ZnbHcVIdivMPM1R3fdJ9LRDmY/KGRENCqiU53hcgDsyFB38ECawd
 bJeY9Kt0+WaEXgQ77nMORSO7+pYvWKEcla7kzhxSTM+ni4Td7lCplw/DzjYqBMyJv97kfX/Qj
 Y+y5PN7t753l9hkoDm0Q5qM/CTfijIa0JPnENap6qIqIAjBG4RhWw6wRyUTTmVkJW2V+2xOBC
 PHaCXPlZ/qq7WZ3JexlI6Psnt1jCARwkcghISP5rS/+E6PKgKrGNYNoyXN9F/a5r8e76MljOO
 UQmwi9LRjWKK8YZeWAYLC9FRqvgJ52IlYbQjoC30yYZeenW7OQmXSGTU5BBxGYMK8Xq+pE08j
 O91u432qO9oCFDVtFImf0Ru9Dtsf8XWcXP7VnN21j7Yjv36TThHBGaCoahCfPc0gc70Xbbf4X
 +ei2dec7aPNONnZE8OQj5GtfPwJ1ne+UAjDjZRyvBTy6rZFn1LnHpHTG3HSQO/evAGUhDEcP0
 3zJW73ngbCJNntr6qB0BTvZFsGLSJ+FQGWSEFg+loZ8AKWdItJGHka9GIHHMCz6T6NlnvFxzH
 JLV+2acDB9zNH0212FrV7zZjxZWsih5lotFRLYXTNvyyEhJRQsr2z3X6dNEFxbTNhjcBCNobU
 otXwgL+Q4W/9awB81LqdqCbsQMQPRkzisFHRKQFsIh9mScmwR+3Il4G54awRxOFEBIIok+/ah
 Qns4FIGdD2ZxTvZqlhpfaX/5JtbZlcbFV3LP26wCMsZPO9ivY8qslvTa3W1ZcHgVVUWShsjaS
 6s2A0as4Gex8Huvt+65XM7ilGQ3Hpf/8dbSkEuAclqfheJvrMtv4prj+zYfx9F9ClecQKCCV7
 r0K5GhNW+kuW5j9z2rI5z6iHkQZVHrqXRtwuUA5681U30jP18vbCE9fOUdHtd/vf3ASSvTVo0
 dtlhue/Mx0WlWmofFPIqQfPx1jI=
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:39:58PM -0600, Michael Roth wrote:
> In some cases, like with SEV-SNP, guest memory needs to be updated in a
> platform-specific manner before it can be safely freed back to the host.
> Add hooks to wire up handling of this sort to the invalidation notifiers
> for restricted memory.
>=20
> Also issue invalidations of all allocated pages during notifier
> unregistration so that the pages are not left in an unusable state when
> they eventually get freed back to the host upon FD release.
>=20
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/mmu/mmu.c             |  5 +++++
>  include/linux/kvm_host.h           |  2 ++
>  mm/restrictedmem.c                 | 16 ++++++++++++++++
>  virt/kvm/kvm_main.c                |  5 +++++
>  6 files changed, 30 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 52f94a0ba5e9..c71df44b0f02 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -134,6 +134,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reaso=
ns);
>  KVM_X86_OP_OPTIONAL_RET0(private_mem_enabled);
>  KVM_X86_OP_OPTIONAL_RET0(fault_is_private);
>  KVM_X86_OP_OPTIONAL_RET0(update_mem_attr)
> +KVM_X86_OP_OPTIONAL(invalidate_restricted_mem)
> =20
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 13802389f0f9..9ef8d73455d9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1639,6 +1639,7 @@ struct kvm_x86_ops {
>  	int (*fault_is_private)(struct kvm *kvm, gpa_t gpa, u64 error_code, boo=
l *private_fault);
>  	int (*update_mem_attr)(struct kvm_memory_slot *slot, unsigned int attr,
>  			       gfn_t start, gfn_t end);
> +	void (*invalidate_restricted_mem)(struct kvm_memory_slot *slot, gfn_t s=
tart, gfn_t end);
> =20
>  	bool (*has_wbinvd_exit)(void);
> =20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a0c41d391547..2713632e5061 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7183,3 +7183,8 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
>  		kvm_update_lpage_private_shared_mixed(kvm, slot, attrs,
>  						      start, end);
>  }
> +
> +void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, gf=
n_t start, gfn_t end)
> +{
> +	static_call_cond(kvm_x86_invalidate_restricted_mem)(slot, start, end);
> +}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f032d878e034..f72a2e0b8699 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2327,6 +2327,7 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
>  				    struct kvm_memory_slot *slot,
>  				    unsigned long attrs,
>  				    gfn_t start, gfn_t end);
> +
>  #else
>  static inline void kvm_arch_set_memory_attributes(struct kvm *kvm,
>  						  struct kvm_memory_slot *slot,
> @@ -2366,6 +2367,7 @@ static inline int kvm_restricted_mem_get_pfn(struct=
 kvm_memory_slot *slot,
>  }
> =20
>  void kvm_arch_memory_mce(struct kvm *kvm);
> +void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, gf=
n_t start, gfn_t end);
>  #endif /* CONFIG_HAVE_KVM_RESTRICTED_MEM */
> =20
>  #endif
> diff --git a/mm/restrictedmem.c b/mm/restrictedmem.c
> index 56953c204e5c..74fa2cfb8618 100644
> --- a/mm/restrictedmem.c
> +++ b/mm/restrictedmem.c
> @@ -54,6 +54,11 @@ static int restrictedmem_release(struct inode *inode, =
struct file *file)
>  {
>  	struct restrictedmem_data *data =3D inode->i_mapping->private_data;
> =20
> +	pr_debug("%s: releasing memfd, invalidating page offsets 0x0-0x%llx\n",
> +		 __func__, inode->i_size >> PAGE_SHIFT);
> +	restrictedmem_invalidate_start(data, 0, inode->i_size >> PAGE_SHIFT);
> +	restrictedmem_invalidate_end(data, 0, inode->i_size >> PAGE_SHIFT);
> +
>  	fput(data->memfd);
>  	kfree(data);
>  	return 0;
> @@ -258,6 +263,17 @@ void restrictedmem_unregister_notifier(struct file *=
file,
>  				       struct restrictedmem_notifier *notifier)
>  {
>  	struct restrictedmem_data *data =3D file->f_mapping->private_data;
> +	struct inode *inode =3D file_inode(data->memfd);
> +
> +	/* TODO: this will issue notifications to all registered notifiers,
> +	 * but it's only the one being unregistered that needs to process
> +	 * invalidations for any ranges still allocated at this point in
> +	 * time. For now this relies on KVM currently being the only notifier.
> +	 */
> +	pr_debug("%s: unregistering notifier, invalidating page offsets 0x0-0x%=
llx\n",
> +		 __func__, inode->i_size >> PAGE_SHIFT);
> +	restrictedmem_invalidate_start(data, 0, inode->i_size >> PAGE_SHIFT);
> +	restrictedmem_invalidate_end(data, 0, inode->i_size >> PAGE_SHIFT);
> =20
>  	mutex_lock(&data->lock);
>  	list_del(&notifier->list);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d2d829d23442..d2daa049e94a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -974,6 +974,9 @@ static void kvm_restrictedmem_invalidate_begin(struct=
 restrictedmem_notifier *no
>  					  &gfn_start, &gfn_end))
>  		return;
> =20
> +	pr_debug("%s: start: 0x%lx, end: 0x%lx, roffset: 0x%llx, gfn_start: 0x%=
llx, gfn_end: 0x%llx\n",
> +		 __func__, start, end, slot->restricted_offset, gfn_start, gfn_end);
> +
>  	gfn_range.start =3D gfn_start;
>  	gfn_range.end =3D gfn_end;
>  	gfn_range.slot =3D slot;
> @@ -988,6 +991,8 @@ static void kvm_restrictedmem_invalidate_begin(struct=
 restrictedmem_notifier *no
>  	if (kvm_unmap_gfn_range(kvm, &gfn_range))
>  		kvm_flush_remote_tlbs(kvm);
> =20
> +	kvm_arch_invalidate_restricted_mem(slot, gfn_start, gfn_end);

Calling kvm_arch_invalidate_restricted_mem while the KVM MMU lock is taken
causes problems, because taking said lock disables preemption. Within=20
kvm_arch_invalidate_restricted_mem a few calls down, eventually
vm_unmap_aliases is called which tries to lock a mutex, which shouldn't hap=
pen
with preemption disabled. This causes a "scheduling while atomic" bug:

[  152.846596] BUG: scheduling while atomic: enarx/8302/0x00000002
[  152.846599] Modules linked in: nf_conntrack_netlink(E) xfrm_user(E) xfrm=
_algo(E) xt_addrtype(E) br_netfilter(E) xt_CHECKSUM(E) xt_MASQUERADE(E) xt_=
conntrack(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_tcpudp(E) nft_compat(E) nft=
_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E)=
 nf_tables(E) libcrc32c(E) nfnetlink(E) bridge(E) stp(E) llc(E) bonding(E) =
intel_rapl_msr(E) intel_rapl_common(E) amd64_edac(E) edac_mce_amd(E) kvm_am=
d(E) tun(E) ipmi_ssif(E) rfkill(E) overlay(E) ghash_clmulni_intel(E) sha512=
_ssse3(E) sha512_generic(E) aesni_intel(E) libaes(E) crypto_simd(E) cryptd(=
E) rapl(E) wmi_bmof(E) binfmt_misc(E) kvm(E) irqbypass(E) nls_ascii(E) nls_=
cp437(E) vfat(E) fat(E) snd_usb_audio(E) snd_usbmidi_lib(E) snd_hwdep(E) mc=
(E) snd_pcm(E) snd_seq_midi(E) snd_seq_midi_event(E) snd_rawmidi(E) snd_seq=
(E) ast(E) snd_seq_device(E) drm_vram_helper(E) drm_ttm_helper(E) snd_timer=
(E) ttm(E) joydev(E) snd(E) ccp(E) drm_kms_helper(E) soundcore(E) sg(E) i2c=
_algo_bit(E) rng_core(E)
[  152.846629]  k10temp(E) evdev(E) acpi_ipmi(E) ipmi_si(E) ipmi_devintf(E)=
 ipmi_msghandler(E) acpi_cpufreq(E) button(E) squashfs(E) loop(E) sch_fq_co=
del(E) msr(E) parport_pc(E) ppdev(E) lp(E) ramoops(E) parport(E) reed_solom=
on(E) fuse(E) drm(E) efi_pstore(E) configfs(E) efivarfs(E) ip_tables(E) x_t=
ables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) mbcache(E) jbd2(E) r=
ndis_host(E) cdc_ether(E) usbnet(E) mii(E) hid_generic(E) usbhid(E) hid(E) =
sd_mod(E) t10_pi(E) crc64_rocksoft(E) crc64(E) crc_t10dif(E) crct10dif_gene=
ric(E) crct10dif_pclmul(E) crct10dif_common(E) crc32_pclmul(E) crc32c_intel=
(E) ahci(E) libahci(E) xhci_pci(E) libata(E) bnxt_en(E) xhci_hcd(E) scsi_mo=
d(E) ptp(E) scsi_common(E) pps_core(E) usbcore(E) i2c_piix4(E) usb_common(E=
) wmi(E)
[  152.846657] Preemption disabled at:
[  152.846657] [<ffffffffc146a09a>] kvm_restrictedmem_invalidate_begin+0xba=
/0x1c0 [kvm]
[  152.846688] CPU: 108 PID: 8302 Comm: enarx Tainted: G        W   E      =
6.1.0-rc4+ #30
[  152.846690] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.4 0=
4/14/2022
[  152.846691] Call Trace:
[  152.846692]  <TASK>
[  152.846694]  dump_stack_lvl+0x49/0x63
[  152.846695]  ? kvm_restrictedmem_invalidate_begin+0xba/0x1c0 [kvm]
[  152.846723]  dump_stack+0x10/0x16
[  152.846725]  __schedule_bug.cold+0x81/0x92
[  152.846727]  __schedule+0x809/0xa00
[  152.846729]  ? asm_sysvec_call_function+0x1b/0x20
[  152.846731]  schedule+0x6b/0xf0
[  152.846733]  schedule_preempt_disabled+0x18/0x30
[  152.846735]  __mutex_lock.constprop.0+0x723/0x750
[  152.846738]  ? smp_call_function_many_cond+0xc1/0x2e0
[  152.846740]  __mutex_lock_slowpath+0x13/0x20
[  152.846742]  mutex_lock+0x49/0x60
[  152.846744]  _vm_unmap_aliases+0x10e/0x160
[  152.846746]  vm_unmap_aliases+0x19/0x20
[  152.846748]  change_page_attr_set_clr+0xb7/0x1c0
[  152.846751]  set_memory_p+0x29/0x30
[  152.846753]  rmpupdate+0xd5/0x110
[  152.846756]  rmp_make_shared+0xb7/0xc0
[  152.846758]  snp_make_page_shared.constprop.0+0x4c/0x90 [kvm_amd]
[  152.846765]  sev_invalidate_private_range+0x156/0x330 [kvm_amd]
[  152.846770]  ? kvm_unmap_gfn_range+0xef/0x100 [kvm]
[  152.846801]  kvm_arch_invalidate_restricted_mem+0xe/0x20 [kvm]
[  152.846829]  kvm_restrictedmem_invalidate_begin+0x106/0x1c0 [kvm]
[  152.846856]  restrictedmem_unregister_notifier+0x74/0x150
[  152.846859]  kvm_free_memslot+0x6b/0x80 [kvm]
[  152.846885]  kvm_free_memslots.part.0+0x47/0x70 [kvm]
[  152.846911]  kvm_destroy_vm+0x222/0x320 [kvm]
[  152.846937]  kvm_put_kvm+0x2a/0x50 [kvm]
[  152.846964]  kvm_vm_release+0x22/0x30 [kvm]
[  152.846990]  __fput+0xa8/0x280
[  152.846992]  ____fput+0xe/0x20
[  152.846994]  task_work_run+0x61/0xb0
[  152.846996]  do_exit+0x362/0xb30
[  152.846998]  ? tomoyo_path_number_perm+0x6f/0x200
[  152.847001]  do_group_exit+0x38/0xa0
[  152.847003]  get_signal+0x999/0x9c0
[  152.847005]  arch_do_signal_or_restart+0x37/0x7e0
[  152.847008]  ? __might_fault+0x26/0x30
[  152.847010]  ? __rseq_handle_notify_resume+0xd5/0x4f0
[  152.847013]  exit_to_user_mode_prepare+0xd3/0x170
[  152.847016]  syscall_exit_to_user_mode+0x26/0x50
[  152.847019]  do_syscall_64+0x48/0x90
[  152.847020]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  152.847022] RIP: 0033:0x7fa345f1aaff
[  152.847023] Code: Unable to access opcode bytes at 0x7fa345f1aad5.
[  152.847024] RSP: 002b:00007fff99d6c050 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  152.847026] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00007fa345f=
1aaff
[  152.847027] RDX: 00007fff99d6c188 RSI: 00000000c008aeba RDI: 00000000000=
00006
[  152.847028] RBP: 00007fff99576000 R08: 0000000000000000 R09: 00000000000=
00000
[  152.847029] R10: 0000000001680000 R11: 0000000000000246 R12: 00007fff99d=
752c0
[  152.847030] R13: 00007fff99d75270 R14: 0000000000000000 R15: 00007fff995=
77000
[  152.847032]  </TASK>

This bug can be triggered by destroying multiple SNP VMs at the same time.

> +
>  	KVM_MMU_UNLOCK(kvm);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
> --=20
> 2.25.1
>=20
>=20

Regards, Tom
