Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FA26A3B2E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 07:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjB0GOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 01:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB0GOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 01:14:31 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2983B454;
        Sun, 26 Feb 2023 22:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=nChsjqTXDjOmpasI3qEeCMoG1+xVGlKv9S7OF1Tscto=; b=gzq04UxvATspaIjdxtMrDvJAR4
        W35FJx+B4RBTBBpbIZPpLk3URCZhCiBjnxYfIoRjUXWbD8J6/cg3LHC+4ifSS62Htq2FzGV+Qfjr4
        cWhaG8vHJ3KC+waUBhD5poEGuHQkVyA+eqgG4/PWPG1PfQ2rl1qpbr5zypNYORBwcdU9upOYT2vQl
        UqVlkKsUa01DP7+dKpuGwcVVpvOtiy9f5dmz7U5uMcbdBQ+rGmOFRtu9jJ4DgPfeoXilAjVKotJuO
        /SiiXgfEAK1+krVUF8E/RqlruCLz0r/ULu8s2Hl9Uf9Sk4WdKU/GfGbkdYYYQgZNVr3OcGYN79BqY
        2XIjbJFQ==;
Received: from [172.31.31.185] (helo=[127.0.0.1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pWWlG-00EA72-2O;
        Mon, 27 Feb 2023 06:13:22 +0000
Date:   Mon, 27 Feb 2023 06:13:22 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Usama Arif <usama.arif@bytedance.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        tglx@linutronix.de, kim.phillips@amd.com, brgerst@gmail.com
CC:     piotrgorski@cachyos.org, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [External] Re: [PATCH v12 00/11] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <819d8fa2-b73e-e32f-5442-452aa2c0d752@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com> <5650744.DvuYhMxLoT@natalenko.name> <819d8fa2-b73e-e32f-5442-452aa2c0d752@bytedance.com>
Message-ID: <EB27C1C4-7246-4557-A6B3-EBBC9E8FC69F@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26 February 2023 20:59:17 GMT, Usama Arif <usama=2Earif@bytedance=2Ecom=
> wrote:
>
>
>On 26/02/2023 18:31, Oleksandr Natalenko wrote:
>> Hello=2E
>>=20
>> On ned=C4=9Ble 26=2E =C3=BAnora 2023 12:07:51 CET Usama Arif wrote:
>>> The main code change over v11 is the build error fix by Brian Gerst an=
d
>>> acquiring tr_lock in trampoline_64=2ES whenever the stack is setup=2E
>>>=20
>>> The git history is also rewritten to move the commits that removed
>>> initial_stack, early_gdt_descr and initial_gs earlier in the patchset=
=2E
>>>=20
>>> Thanks,
>>> Usama
>>>=20
>>> Changes across versions:
>>> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing mo=
re
>>> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>>>      in preparation for more parallelisation=2E
>>> v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
>>>      avoid scribbling on initial_gs in common_cpu_up(), and to allow a=
ll
>>>      24 bits of the physical X2APIC ID to be used=2E That patch still =
needs
>>>      a Signed-off-by from its original author, who once claimed not to
>>>      remember writing it at all=2E But now we've fixed it, hopefully h=
e'll
>>>      admit it now :)
>>> v5: rebase to v6=2E1 and remeasure performance, disable parallel bring=
up
>>>      for AMD CPUs=2E
>>> v6: rebase to v6=2E2-rc6, disabled parallel boot on amd as a cpu bug a=
nd
>>>      reused timer calibration for secondary CPUs=2E
>>> v7: [David Woodhouse] iterate over all possible CPUs to find any exist=
ing
>>>      cluster mask in alloc_clustermask=2E (patch 1/9)
>>>      Keep parallel AMD support enabled in AMD, using APIC ID in CPUID =
leaf
>>>      0x0B (for x2APIC mode) or CPUID leaf 0x01 where 8 bits are suffic=
ient=2E
>>>      Included sanity checks for APIC id from 0x0B=2E (patch 6/9)
>>>      Removed patch for reusing timer calibration for secondary CPUs=2E
>>>      commit message and code improvements=2E
>>> v8: Fix CPU0 hotplug by setting up the initial_gs, initial_stack and
>>>      early_gdt_descr=2E
>>>      Drop trampoline lock and bail if APIC ID not found in find_cpunr=
=2E
>>>      Code comments improved and debug prints added=2E
>>> v9: Drop patch to avoid repeated saves of MTRR at boot time=2E
>>>      rebased and retested at v6=2E2-rc8=2E
>>>      added kernel doc for no_parallel_bringup and made do_parallel_bri=
ngup
>>>      __ro_after_init=2E
>>> v10: Fixed suspend/resume not working with parallel smpboot=2E
>>>       rebased and retested to 6=2E2=2E
>>>       fixed checkpatch errors=2E
>>> v11: Added patches from Brian Gerst to remove the global variables ini=
tial_gs,
>>>       initial_stack, and early_gdt_descr from the 64-bit boot code
>>>       (https://lore=2Ekernel=2Eorg/all/20230222221301=2E245890-1-brger=
st@gmail=2Ecom/)=2E
>>> v12: Fixed compilation errors, acquire tr_lock for every stack setup i=
n
>>>       trampoline_64=2ES=2E
>>>       Rearranged commits for a cleaner git history=2E
>>>=20
>>> Brian Gerst (3):
>>>    x86/smpboot: Remove initial_stack on 64-bit
>>>    x86/smpboot: Remove early_gdt_descr on 64-bit
>>>    x86/smpboot: Remove initial_gs
>>>=20
>>> David Woodhouse (8):
>>>    x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
>>>    cpu/hotplug: Move idle_thread_get() to <linux/smpboot=2Eh>
>>>    cpu/hotplug: Add dynamic parallel bringup states before
>>>      CPUHP_BRINGUP_CPU
>>>    x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>>>    x86/smpboot: Split up native_cpu_up into separate phases and docume=
nt
>>>      them
>>>    x86/smpboot: Support parallel startup of secondary CPUs
>>>    x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>>>    x86/smpboot: Serialize topology updates for secondary bringup
>>>=20
>>>   =2E=2E=2E/admin-guide/kernel-parameters=2Etxt         |   3 +
>>>   arch/x86/include/asm/processor=2Eh              |   6 +-
>>>   arch/x86/include/asm/realmode=2Eh               |   4 +-
>>>   arch/x86/include/asm/smp=2Eh                    |  15 +-
>>>   arch/x86/include/asm/topology=2Eh               |   2 -
>>>   arch/x86/kernel/acpi/sleep=2Ec                  |  15 +-
>>>   arch/x86/kernel/apic/apic=2Ec                   |   2 +-
>>>   arch/x86/kernel/apic/x2apic_cluster=2Ec         | 126 ++++---
>>>   arch/x86/kernel/asm-offsets=2Ec                 |   1 +
>>>   arch/x86/kernel/cpu/common=2Ec                  |   6 +-
>>>   arch/x86/kernel/head_64=2ES                     | 129 +++++--
>>>   arch/x86/kernel/smpboot=2Ec                     | 350 +++++++++++++-=
----
>>>   arch/x86/realmode/init=2Ec                      |   3 +
>>>   arch/x86/realmode/rm/trampoline_64=2ES          |  27 +-
>>>   arch/x86/xen/smp_pv=2Ec                         |   4 +-
>>>   arch/x86/xen/xen-head=2ES                       |   2 +-
>>>   include/linux/cpuhotplug=2Eh                    |   2 +
>>>   include/linux/smpboot=2Eh                       |   7 +
>>>   kernel/cpu=2Ec                                  |  31 +-
>>>   kernel/smpboot=2Eh                              |   2 -
>>>   20 files changed, 537 insertions(+), 200 deletions(-)
>>=20
>> With `CONFIG_FORCE_NR_CPUS=3Dy` this results in:
>>=20
>> ```
>> ld: vmlinux=2Eo: in function `secondary_startup_64_no_verify':
>> (=2Ehead=2Etext+0x10c): undefined reference to `nr_cpu_ids'
>> ```
>>=20
>> That's because in `arch/x86/kernel/head_64=2ES` `secondary_startup_64_n=
o_verify()` refers to `nr_cpu_ids` under `#ifdef CONFIG_SMP`, but this symb=
ol is available under the following conditions:
>>=20
>> ```
>> 38 #if (NR_CPUS =3D=3D 1) || defined(CONFIG_FORCE_NR_CPUS)
>> 39 #define nr_cpu_ids ((unsigned int)NR_CPUS)
>> 40 #else
>> 41 extern unsigned int nr_cpu_ids;
>> 42 #endif
>>=20
>> 1090 #if (NR_CPUS > 1) && !defined(CONFIG_FORCE_NR_CPUS)
>> 1091 /* Setup number of possible processor ids */
>> 1092 unsigned int nr_cpu_ids __read_mostly =3D NR_CPUS;
>> 1093 EXPORT_SYMBOL(nr_cpu_ids);
>> 1094 #endif
>> ```
>>=20
>> So having `CONFIG_SMP=3Dy` and, for instance, `CONFIG_NR_CPUS=3D320`, i=
t is possible to compile out `EXPORT_SYMBOL(nr_cpu_ids);` if `CONFIG_FORCE_=
NR_CPUS=3Dy` is set=2E
>>=20
>
>I think something like below diff should work in all scenarios?

I'd've changed the asm side to use the constant limit=2E
