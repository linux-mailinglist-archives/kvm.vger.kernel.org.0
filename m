Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA587422E46
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 18:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhJEQsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 12:48:22 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:33069 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbhJEQsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 12:48:20 -0400
Received: from [192.168.100.1] ([82.142.3.114]) by mrelayeu.kundenserver.de
 (mreue011 [213.165.67.103]) with ESMTPSA (Nemesis) id
 1Mgvan-1mzSpO3vO1-00hNKP; Tue, 05 Oct 2021 18:46:00 +0200
Subject: Re: [PATCH v3] target/i386: Include 'hw/i386/apic.h' locally
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        qemu-trivial@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>, haxm-team@intel.com,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210929163124.2523413-1-f4bug@amsat.org>
 <20211005105745-mutt-send-email-mst@kernel.org>
From:   Laurent Vivier <laurent@vivier.eu>
Message-ID: <fb4d7f19-8bb5-781d-4a41-9641625a2019@vivier.eu>
Date:   Tue, 5 Oct 2021 18:45:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211005105745-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Fh7x502ZHzeM5nANZSLh8iW+6H7qUav5X6hW2rcbV6n2x/xBD2n
 fJ0VhgdKzknLRvH9nRbWiDlENyC5aBF5LClx0+BxGkStOTk4p14lMWqllfm7nH7ENV4vlCM
 t21kN0/JGSSUrLRygLUhe4iuMHSM0V6L39PaVWIGpowwD/U1r2xswHNsZwZw1PsQGsG36mM
 q9VILcqmahY11V2EVabPQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gWfMJSm8NhA=:l8/Y6fPeHQhKTXxfljGzfy
 kfXtEKKsKERmRbhadleijE6MViu+Vb8h/NKiiuspdHiTdaS8MgATrnjDrmp1vnO/R73NOS8fM
 iwPoDrdeYYmxtcfgmRwsF9SywvRbiSAcBEvyl5LG3CYB7Y00txc0Zmllwy0FGTElTnB/58VfM
 4QfsO4ObTp6RqxrrhQK1azbM6Ww0bXT0m/5i/ToP0olqxsqSbZ7cCcFWcO6fb6Nav2C6mz6sc
 GACG+U9oxj8WJOu2u7EGDgpBSfNqOAcAhyWitrm2JCZP2+7YdUoIk2ZsLdkVLzdtZ3N6RCeEF
 y5mkcub5jzfb4Rl58pz/FLC6OY3BcqfGEIXNYsy/V1F/3AgjgS8jLIlk/ycrM0Tfvm118AL11
 rV8W7BVIdwtPsDDdGBLic5i8fCO2KiILWCzPHhvw1lEXqWKzOsFoTidR2ps+TPBgz1nYLPAUH
 Akjhaj+ayoPpotWCUkO+MqfBz3WAMFcyiNe0r+8WBP1udntczc6hcpvsmF/aHSFu5ruQjnb0X
 tam6iOcpB4/p8rdOWOWDmSblT3gbNcaZlJMT1oiyZLUrLwdwss4zSaJl9xqE63X7X3roqFXfw
 xM6+jZ1Cxqyl48B/Hkl0OpT9VbCfnYN2WJztcx4Z5a04H0ahJFbJb4pf/LarWCYsR7t4GscOC
 xO9G/pjAVO+xuywbbqNFZLxNwwya3ZT4Ol74Rv3w0UhdL9MkeD2Ev6zZll3nKq0zw1LEdmcPN
 MgFmWZewAf5RQCzruI4DasNqB0Ag7jzZoCsk2A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 05/10/2021 à 16:57, Michael S. Tsirkin a écrit :
> On Wed, Sep 29, 2021 at 06:31:24PM +0200, Philippe Mathieu-Daudé wrote:
>> Instead of including a sysemu-specific header in "cpu.h"
>> (which is shared with user-mode emulations), include it
>> locally when required.
>>
>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> which tree? trivial I guess?

Yes, but for me the patch was not correct because there is no need to update target/i386/cpu-dump.c
But perhaps I misunderstood the answer from Philippe?

Thanks
Laurent

> 
>> ---
>>  target/i386/cpu.h                    | 4 ----
>>  hw/i386/kvmvapic.c                   | 1 +
>>  hw/i386/x86.c                        | 1 +
>>  target/i386/cpu-dump.c               | 1 +
>>  target/i386/cpu-sysemu.c             | 1 +
>>  target/i386/cpu.c                    | 1 +
>>  target/i386/gdbstub.c                | 4 ++++
>>  target/i386/hax/hax-all.c            | 1 +
>>  target/i386/helper.c                 | 1 +
>>  target/i386/hvf/hvf.c                | 1 +
>>  target/i386/hvf/x86_emu.c            | 1 +
>>  target/i386/nvmm/nvmm-all.c          | 1 +
>>  target/i386/tcg/sysemu/misc_helper.c | 1 +
>>  target/i386/tcg/sysemu/seg_helper.c  | 1 +
>>  target/i386/whpx/whpx-all.c          | 1 +
>>  15 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index c2954c71ea0..4411718bb7a 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -2045,10 +2045,6 @@ typedef X86CPU ArchCPU;
>>  #include "exec/cpu-all.h"
>>  #include "svm.h"
>>  
>> -#if !defined(CONFIG_USER_ONLY)
>> -#include "hw/i386/apic.h"
>> -#endif
>> -
>>  static inline void cpu_get_tb_cpu_state(CPUX86State *env, target_ulong *pc,
>>                                          target_ulong *cs_base, uint32_t *flags)
>>  {
>> diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
>> index 43f8a8f679e..7333818bdd1 100644
>> --- a/hw/i386/kvmvapic.c
>> +++ b/hw/i386/kvmvapic.c
>> @@ -16,6 +16,7 @@
>>  #include "sysemu/hw_accel.h"
>>  #include "sysemu/kvm.h"
>>  #include "sysemu/runstate.h"
>> +#include "hw/i386/apic.h"
>>  #include "hw/i386/apic_internal.h"
>>  #include "hw/sysbus.h"
>>  #include "hw/boards.h"
>> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
>> index 00448ed55aa..e0218f8791f 100644
>> --- a/hw/i386/x86.c
>> +++ b/hw/i386/x86.c
>> @@ -43,6 +43,7 @@
>>  #include "target/i386/cpu.h"
>>  #include "hw/i386/topology.h"
>>  #include "hw/i386/fw_cfg.h"
>> +#include "hw/i386/apic.h"
>>  #include "hw/intc/i8259.h"
>>  #include "hw/rtc/mc146818rtc.h"
>>  
>> diff --git a/target/i386/cpu-dump.c b/target/i386/cpu-dump.c
>> index 02b635a52cf..0158fd2bf28 100644
>> --- a/target/i386/cpu-dump.c
>> +++ b/target/i386/cpu-dump.c
>> @@ -22,6 +22,7 @@
>>  #include "qemu/qemu-print.h"
>>  #ifndef CONFIG_USER_ONLY
>>  #include "hw/i386/apic_internal.h"
>> +#include "hw/i386/apic.h"
>>  #endif
>>  
>>  /***********************************************************/
>> diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
>> index 37b7c562f53..4e8a6973d08 100644
>> --- a/target/i386/cpu-sysemu.c
>> +++ b/target/i386/cpu-sysemu.c
>> @@ -30,6 +30,7 @@
>>  #include "hw/qdev-properties.h"
>>  
>>  #include "exec/address-spaces.h"
>> +#include "hw/i386/apic.h"
>>  #include "hw/i386/apic_internal.h"
>>  
>>  #include "cpu-internal.h"
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 6b029f1bdf1..52422cbf21b 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -33,6 +33,7 @@
>>  #include "standard-headers/asm-x86/kvm_para.h"
>>  #include "hw/qdev-properties.h"
>>  #include "hw/i386/topology.h"
>> +#include "hw/i386/apic.h"
>>  #ifndef CONFIG_USER_ONLY
>>  #include "exec/address-spaces.h"
>>  #include "hw/boards.h"
>> diff --git a/target/i386/gdbstub.c b/target/i386/gdbstub.c
>> index 098a2ad15a9..5438229c1a9 100644
>> --- a/target/i386/gdbstub.c
>> +++ b/target/i386/gdbstub.c
>> @@ -21,6 +21,10 @@
>>  #include "cpu.h"
>>  #include "exec/gdbstub.h"
>>  
>> +#ifndef CONFIG_USER_ONLY
>> +#include "hw/i386/apic.h"
>> +#endif
>> +
>>  #ifdef TARGET_X86_64
>>  static const int gpr_map[16] = {
>>      R_EAX, R_EBX, R_ECX, R_EDX, R_ESI, R_EDI, R_EBP, R_ESP,
>> diff --git a/target/i386/hax/hax-all.c b/target/i386/hax/hax-all.c
>> index bf65ed6fa92..cd89e3233a9 100644
>> --- a/target/i386/hax/hax-all.c
>> +++ b/target/i386/hax/hax-all.c
>> @@ -32,6 +32,7 @@
>>  #include "sysemu/reset.h"
>>  #include "sysemu/runstate.h"
>>  #include "hw/boards.h"
>> +#include "hw/i386/apic.h"
>>  
>>  #include "hax-accel-ops.h"
>>  
>> diff --git a/target/i386/helper.c b/target/i386/helper.c
>> index 533b29cb91b..874beda98ae 100644
>> --- a/target/i386/helper.c
>> +++ b/target/i386/helper.c
>> @@ -26,6 +26,7 @@
>>  #ifndef CONFIG_USER_ONLY
>>  #include "sysemu/hw_accel.h"
>>  #include "monitor/monitor.h"
>> +#include "hw/i386/apic.h"
>>  #endif
>>  
>>  void cpu_sync_bndcs_hflags(CPUX86State *env)
>> diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
>> index 4ba6e82fab3..50058a24f2a 100644
>> --- a/target/i386/hvf/hvf.c
>> +++ b/target/i386/hvf/hvf.c
>> @@ -70,6 +70,7 @@
>>  #include <sys/sysctl.h>
>>  
>>  #include "hw/i386/apic_internal.h"
>> +#include "hw/i386/apic.h"
>>  #include "qemu/main-loop.h"
>>  #include "qemu/accel.h"
>>  #include "target/i386/cpu.h"
>> diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
>> index 7c8203b21fb..fb3e88959d4 100644
>> --- a/target/i386/hvf/x86_emu.c
>> +++ b/target/i386/hvf/x86_emu.c
>> @@ -45,6 +45,7 @@
>>  #include "x86_flags.h"
>>  #include "vmcs.h"
>>  #include "vmx.h"
>> +#include "hw/i386/apic.h"
>>  
>>  void hvf_handle_io(struct CPUState *cpu, uint16_t port, void *data,
>>                     int direction, int size, uint32_t count);
>> diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
>> index a488b00e909..944bdb49663 100644
>> --- a/target/i386/nvmm/nvmm-all.c
>> +++ b/target/i386/nvmm/nvmm-all.c
>> @@ -22,6 +22,7 @@
>>  #include "qemu/queue.h"
>>  #include "migration/blocker.h"
>>  #include "strings.h"
>> +#include "hw/i386/apic.h"
>>  
>>  #include "nvmm-accel-ops.h"
>>  
>> diff --git a/target/i386/tcg/sysemu/misc_helper.c b/target/i386/tcg/sysemu/misc_helper.c
>> index 9ccaa054c4c..b1d3096e9c9 100644
>> --- a/target/i386/tcg/sysemu/misc_helper.c
>> +++ b/target/i386/tcg/sysemu/misc_helper.c
>> @@ -24,6 +24,7 @@
>>  #include "exec/cpu_ldst.h"
>>  #include "exec/address-spaces.h"
>>  #include "tcg/helper-tcg.h"
>> +#include "hw/i386/apic.h"
>>  
>>  void helper_outb(CPUX86State *env, uint32_t port, uint32_t data)
>>  {
>> diff --git a/target/i386/tcg/sysemu/seg_helper.c b/target/i386/tcg/sysemu/seg_helper.c
>> index bf3444c26b0..34f2c65d47f 100644
>> --- a/target/i386/tcg/sysemu/seg_helper.c
>> +++ b/target/i386/tcg/sysemu/seg_helper.c
>> @@ -24,6 +24,7 @@
>>  #include "exec/cpu_ldst.h"
>>  #include "tcg/helper-tcg.h"
>>  #include "../seg_helper.h"
>> +#include "hw/i386/apic.h"
>>  
>>  #ifdef TARGET_X86_64
>>  void helper_syscall(CPUX86State *env, int next_eip_addend)
>> diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
>> index 3e925b9da70..9ab844fd05d 100644
>> --- a/target/i386/whpx/whpx-all.c
>> +++ b/target/i386/whpx/whpx-all.c
>> @@ -20,6 +20,7 @@
>>  #include "qemu/main-loop.h"
>>  #include "hw/boards.h"
>>  #include "hw/i386/ioapic.h"
>> +#include "hw/i386/apic.h"
>>  #include "hw/i386/apic_internal.h"
>>  #include "qemu/error-report.h"
>>  #include "qapi/error.h"
>> -- 
>> 2.31.1
> 
> 

