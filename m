Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6078318CF5D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 14:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCTNtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 09:49:07 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44535 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 09:49:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id j4so6774058qkc.11
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 06:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ewQDrvDESYit4C6Vpw5jk5bgzVrd54SxmO7+61oxXLc=;
        b=hJvijhtz67EYbXj+8pZl5mqJHti5hChKX0uiQ82rNt0h25SgpnaDgZrmJMTASX5MLQ
         pUbsH8t27tuXsVCmzWkzc5Zhe/DVEX9kUOjp/DZnzYyPDYrIpzEUymU7BdLj0dZdY4rx
         2FW4psuMWCRlINDo4jYdIybueYYoLpR2rro2A7UBduDDdNaY8SuXhQP3ayehYOJM3wIM
         DuUoyxy1ugMyXuiqbDTlf7u/R4udtYuASmEvtem0eH2QT+F/S5ESzCHw1Hp77kTPUKK1
         Q/QTc55S4IFfsQx4pD08zBkzmT1xgRo/nIqBGiLAtBb9SUYjNb3SmSt0xUUOTj4RSf53
         slBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ewQDrvDESYit4C6Vpw5jk5bgzVrd54SxmO7+61oxXLc=;
        b=sDpyg7aoyJh15zzfKRNR2wY9VM6JlAIGQ+GUdV6hQSxkM1qfVujZsXNVaHhzziRje8
         +etJxx3S9NFRSDPmv+Wyu1S4Ua8rNaFxrM01mdN4A0GErNnpZeZNsIOpWORyt1bMcf90
         JAw6m5ibWs9SYon+dEBaONivFR42NZQWQh3GZ4Ck1qjLpEARwIKqGr0jhrJetPrHzZwx
         yg+83kox9kSAFR/viOq+ij/UWldzcGChtgXiHKhnD3EVs8BStop/eUoGLTAeqFAq6W8K
         8/Ga6LK0NwLV2GBggOnokEzHP72DCFZAqjBMn208Mewd2INDVHNoSj9e8XWu9CGTENwg
         ZAsA==
X-Gm-Message-State: ANhLgQ1u+tWBsdEnfVv0vA6ejJpNoqchS/Rmqsfh98T0wU7t1l0N6EiR
        zM9n2DZX3CRgAFNRXrs4ZSF1hA==
X-Google-Smtp-Source: ADFU+vuRq6xWkd9PrC4ISkC4UL5EWNotAmo6s0U10Pxse8U04lZI9AfM2oGugRut8qhP/It1s55mfA==
X-Received: by 2002:a37:7245:: with SMTP id n66mr8432883qkc.202.1584712145154;
        Fri, 20 Mar 2020 06:49:05 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id p9sm4283575qtu.3.2020.03.20.06.49.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Mar 2020 06:49:04 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: slab-out-of-bounds due to "KVM: Dynamically size memslot array
 based on number of used slots"
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <20200320043403.GH11305@linux.intel.com>
Date:   Fri, 20 Mar 2020 09:49:03 -0400
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5FF6AF4E-EB99-4111-BBB2-FE09FFBEF5C4@lca.pw>
References: <8922D835-ED2A-4C48-840A-F568E20B5A7C@lca.pw>
 <20200320043403.GH11305@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Mar 20, 2020, at 12:34 AM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Thu, Mar 19, 2020 at 11:59:23PM -0400, Qian Cai wrote:
>> Reverted the linux-next commit 36947254e5f98 (=E2=80=9CKVM: =
Dynamically size memslot array based on number of used slots=E2=80=9D)
>> fixed illegal slab object redzone accesses.
>>=20
>> [6727.939776][ T1818] BUG: KASAN: slab-out-of-bounds in =
gfn_to_hva+0xc1/0x2b0 [kvm]
>> search_memslots at include/linux/kvm_host.h:1035
>=20
> Drat.  I'm guessing lru_slot is out of range after a memslot is =
deleted.
> This should fix the issue, though it may not be the most proper fix, =
e.g.
> it might be better to reset lru_slot when deleting a memslot.  I'll =
try and
> reproduce tomorrow, unless you can confirm this does the trick.

It works fine.

>=20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e9a7d3476a12..b8f5d3b2fe5c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1021,6 +1021,12 @@ search_memslots(struct kvm_memslots *slots, =
gfn_t gfn)
>        int slot =3D atomic_read(&slots->lru_slot);
>        struct kvm_memory_slot *memslots =3D slots->memslots;
>=20
> +       if (!slots->used_slots)
> +               return NULL;
> +
> +       if (slot >=3D slots->used_slots)
> +               slot =3D 0;
> +
>        if (gfn >=3D memslots[slot].base_gfn &&
>            gfn < memslots[slot].base_gfn + memslots[slot].npages)
>                return &memslots[slot];
>=20
>=20
>=20
>> (inlined by) __gfn_to_memslot at include/linux/kvm_host.h:1060
>> (inlined by) gfn_to_memslot at virt/kvm/kvm_main.c:1594
>> (inlined by) gfn_to_hva at virt/kvm/kvm_main.c:1674
>> [ 6727.975376][ T1818] Read of size 8 at addr ffff8885351c4c10 by =
task qemu-system-x86/1818
>> [ 6728.012769][ T1818]=20
>> [ 6728.022690][ T1818] CPU: 11 PID: 1818 Comm: qemu-system-x86 Not =
tainted 5.6.0-rc6-next-20200319+ #5
>> [ 6728.069063][ T1818] Hardware name: HP Synergy 480 Gen9/Synergy 480 =
Gen9 Compute Module, BIOS I37 10/21/2019
>> [ 6728.117009][ T1818] Call Trace:
>> [ 6728.131504][ T1818]  dump_stack+0xa1/0xea
>> [ 6728.149757][ T1818]  =
print_address_description.constprop.0+0x33/0x270
>> [ 6728.179315][ T1818]  __kasan_report.cold+0x78/0xd0
>> [ 6728.201386][ T1818]  ? =
kvm_mmu_notifier_invalidate_range_start+0x50/0x150 [kvm]
>> [ 6728.235146][ T1818]  ? gfn_to_hva+0xc1/0x2b0 [kvm]
>> [ 6728.256942][ T1818]  kasan_report+0x41/0x60
>> [ 6728.276172][ T1818]  ? gfn_to_hva+0xc1/0x2b0 [kvm]
>> [ 6728.298089][ T1818]  __asan_load8+0x86/0xa0
>> [ 6728.317366][ T1818]  gfn_to_hva+0xc1/0x2b0 [kvm]
>> [ 6728.338687][ T1818]  =
kvm_arch_mmu_notifier_invalidate_range+0x21/0x50 [kvm]
>> [ 6728.370595][ T1818]  =
kvm_mmu_notifier_invalidate_range_start+0xfd/0x150 [kvm]
>> [ 6728.402904][ T1818]  mn_hlist_invalidate_range_start+0x109/0x2b0
>> [ 6728.430526][ T1818]  ? kvm_flush_remote_tlbs+0x170/0x170 [kvm]
>> [ 6728.457312][ T1818]  =
__mmu_notifier_invalidate_range_start+0x74/0x80
>> [ 6728.486687][ T1818]  wp_page_copy+0xd9f/0x12e0
>> [ 6728.506872][ T1818]  ? __lock_release+0x14d/0x2b0
>> [ 6728.528484][ T1818]  ? follow_pfn+0x160/0x160
>> [ 6728.548555][ T1818]  ? __kasan_check_read+0x11/0x20
>> [ 6728.573773][ T1818]  ? check_chain_key+0x1d3/0x2c0
>> [ 6728.599226][ T1818]  ? __kasan_check_read+0x11/0x20
>> [ 6728.622648][ T1818]  ? do_raw_spin_unlock+0x98/0xf0
>> [ 6728.644878][ T1818]  do_wp_page+0x37d/0xac0
>> [ 6728.664110][ T1818]  ? wp_page_shared+0x4e0/0x4e0
>> [ 6728.685702][ T1818]  handle_pte_fault+0x3b0/0x3e0
>> [ 6728.707315][ T1818]  __handle_mm_fault+0x5e7/0xaf0
>> [ 6728.729495][ T1818]  ? apply_to_existing_page_range+0x20/0x20
>> [ 6728.755780][ T1818]  handle_mm_fault+0x10b/0x320
>> [ 6728.776840][ T1818]  do_user_addr_fault+0x22c/0x5a0
>> [ 6728.799089][ T1818]  do_page_fault+0x9d/0x421
>> [ 6728.818910][ T1818]  page_fault+0x34/0x40
>> [ 6728.837424][ T1818] RIP: 0033:0x55cc277d6cc4
>> [ 6728.856867][ T1818] Code: 00 00 00 53 48 89 f3 48 83 ec 08 e8 a6 =
37 e1 ff 48 8b 15 27 a8 70 00 48 89 68 10 48 89 58 18 48 c7 00 00 00 00 =
00 48 89 50 08 <48> 89 02 48 89 05 0a a8 70 00 48 83 c4 08 5b 5d c3 66 =
66 2e 0f 1f
>> [ 6728.946881][ T1818] RSP: 002b:00007ffe79363de0 EFLAGS: 00010206
>> [ 6728.973883][ T1818] RAX: 000055cc29963830 RBX: 0000000000000000 =
RCX: 0000000000000030
>> [ 6729.009698][ T1818] RDX: 000055cc27ee14d0 RSI: 0000000000000020 =
RDI: 000055cc29963830
>> [ 6729.045698][ T1818] RBP: 000055cc277534b0 R08: 000055cc29963830 =
R09: 00007fc044602a40
>> [ 6729.084027][ T1818] R10: 000055cc29963880 R11: 0000000000000000 =
R12: 0000000000000001
>> [ 6729.125556][ T1818] R13: 000055cc29965180 R14: 0000000000000001 =
R15: 0000000000000001
>> [ 6729.160970][ T1818]=20
>> [ 6729.170932][ T1818] Allocated by task 1818:
>> [ 6729.190130][ T1818]  save_stack+0x23/0x50
>> [ 6729.208517][ T1818]  __kasan_kmalloc.constprop.0+0xcf/0xe0
>> [ 6729.233816][ T1818]  kasan_kmalloc+0x9/0x10
>> [ 6729.252852][ T1818]  __kmalloc_node+0x1c3/0x410
>> [ 6729.273517][ T1818]  kvmalloc_node+0x7b/0x90
>> [ 6729.293002][ T1818]  kvm_create_vm+0x264/0x810 [kvm]
>> kvmalloc at include/linux/mm.h:759
>> (inlined by) kvzalloc at include/linux/mm.h:767
>> (inlined by) kvm_alloc_memslots at virt/kvm/kvm_main.c:562
>> (inlined by) kvm_create_vm at virt/kvm/kvm_main.c:697
>> [ 6729.315774][ T1818]  kvm_dev_ioctl_create_vm+0x14/0xf0 [kvm]
>> [ 6729.341840][ T1818]  kvm_dev_ioctl+0x6b/0x90 [kvm]
>> [ 6729.363821][ T1818]  ksys_ioctl+0xa3/0xc0
>> [ 6729.382166][ T1818]  __x64_sys_ioctl+0x43/0x4c
>> [ 6729.403174][ T1818]  do_syscall_64+0x69/0xf4
>> [ 6729.423242][ T1818]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>> [ 6729.449985][ T1818]=20
>> [ 6729.459896][ T1818] Freed by task 0:
>> [ 6729.476312][ T1818] (stack is not available)
>> [ 6729.495726][ T1818]=20
>> [ 6729.505710][ T1818] The buggy address belongs to the object at =
ffff8885351c4800
>> [ 6729.505710][ T1818]  which belongs to the cache =
kmalloc-2k(976:session-c1.scope) of size 2048
>> [ 6729.579319][ T1818] The buggy address is located 1040 bytes inside =
of
>> [ 6729.579319][ T1818]  2048-byte region [ffff8885351c4800, =
ffff8885351c5000)
>> [ 6729.647086][ T1818] The buggy address belongs to the page:
>> [ 6729.671752][ T1818] page:ffffea0014d47100 refcount:1 mapcount:0 =
mapping:00000000b234685e index:0x0 head:ffffea0014d47100 order:1 =
compound_mapcount:0
>> [ 6729.734134][ T1818] flags: 0x5fffe000010200(slab|head)
>> [ 6729.757725][ T1818] raw: 005fffe000010200 ffffea0019590308 =
ffffea0013df5508 ffff888f05490ac0
>> [ 6729.796528][ T1818] raw: 0000000000000000 0000000000010001 =
00000001ffffffff 0000000000000000
>> [ 6729.835200][ T1818] page dumped because: kasan: bad access =
detected
>> [ 6729.864026][ T1818] page_owner tracks the page as allocated
>> [ 6729.889565][ T1818] page last allocated via order 1, migratetype =
Unmovable, gfp_mask =
0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP)
>> [ 6729.948959][ T1818]  prep_new_page+0x23e/0x270
>> [ 6729.969540][ T1818]  get_page_from_freelist+0x4f7/0x580
>> [ 6729.993824][ T1818]  __alloc_pages_nodemask+0x2de/0x780
>> [ 6730.017658][ T1818]  alloc_pages_current+0x9e/0x170
>> [ 6730.039922][ T1818]  alloc_slab_page+0x321/0x580
>> [ 6730.061106][ T1818]  allocate_slab+0x7f/0x3c0
>> [ 6730.081229][ T1818]  new_slab+0x4a/0x70
>> [ 6730.100073][ T1818]  ___slab_alloc+0x294/0x380
>> [ 6730.122658][ T1818]  __kmalloc_node+0x227/0x410
>> [ 6730.146452][ T1818]  kvmalloc_node+0x7b/0x90
>> [ 6730.166644][ T1818]  kvm_create_vm+0x264/0x810 [kvm]
>> [ 6730.189396][ T1818]  kvm_dev_ioctl_create_vm+0x14/0xf0 [kvm]
>> [ 6730.215647][ T1818]  kvm_dev_ioctl+0x6b/0x90 [kvm]
>> [ 6730.237526][ T1818]  ksys_ioctl+0xa3/0xc0
>> [ 6730.255755][ T1818]  __x64_sys_ioctl+0x43/0x4c
>> [ 6730.276150][ T1818]  do_syscall_64+0x69/0xf4
>> [ 6730.295871][ T1818] page last free stack trace:
>> [ 6730.316511][ T1818]  __free_pages_ok+0x678/0x760
>> [ 6730.337440][ T1818]  __free_pages+0xa2/0xe0
>> [ 6730.356259][ T1818]  free_pages+0x53/0x70
>> [ 6730.374572][ T1818]  stack_depot_save+0x9f/0x213
>> [ 6730.395761][ T1818]  save_stack+0x42/0x50
>> [ 6730.414042][ T1818]  __kasan_kmalloc.constprop.0+0xcf/0xe0
>> [ 6730.439088][ T1818]  kasan_slab_alloc+0xe/0x10
>> [ 6730.459349][ T1818]  kmem_cache_alloc+0x136/0x470
>> [ 6730.481158][ T1818]  mem_pool_alloc+0x38/0x170
>> [ 6730.501470][ T1818]  create_object.isra.0+0x27/0x430
>> [ 6730.524151][ T1818]  kmemleak_alloc_percpu+0xbb/0x150
>> [ 6730.547342][ T1818]  pcpu_alloc+0x537/0xad0
>> [ 6730.566651][ T1818]  __alloc_percpu+0x15/0x20
>> [ 6730.588291][ T1818]  init_srcu_struct_fields+0x208/0x220
>> [ 6730.612543][ T1818]  __init_srcu_struct+0x5c/0x70
>> [ 6730.636590][ T1818]  kvm_create_vm+0x20d/0x810 [kvm]
>> [ 6730.662421][ T1818]=20
>> [ 6730.672838][ T1818] Memory state around the buggy address:
>> [ 6730.697743][ T1818]  ffff8885351c4b00: 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00
>> [ 6730.734279][ T1818]  ffff8885351c4b80: 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00
>> [ 6730.770594][ T1818] >ffff8885351c4c00: 00 00 fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc
>> [ 6730.806845][ T1818]                          ^
>> [ 6730.827097][ T1818]  ffff8885351c4c80: fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc
>> [ 6730.863311][ T1818]  ffff8885351c4d00: fc fc fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc
>> [ 6730.899350][ T1818] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [ 6730.935728][ T1818] Disabling lock debugging due to kernel taint

