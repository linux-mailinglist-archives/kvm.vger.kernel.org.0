Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BBA324E36
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 11:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbhBYKas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 05:30:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234545AbhBYK1I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 05:27:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614248734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yWxDArvB83pZrvTNML2Xy5EfIF6keWM/VhTIz+RBTIY=;
        b=YnGRTXkaXP7V4h9V1pPVRKLe+ELyKIx19Q5GCK0VAgw89D6iezAOa+IusY1JW3qPp1u7Sl
        uclRkhCIDqhUGgkV4VmKBYp3kkarOoZk7wxXqx805KiKwyjUvX7Nf++jTivZGAmBzK2XJi
        XJFPOfmRA5FOBa7gtzAgvRqCeBFXS2o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-DWApXjkNPyqEaGPU-BGt9g-1; Thu, 25 Feb 2021 05:25:32 -0500
X-MC-Unique: DWApXjkNPyqEaGPU-BGt9g-1
Received: by mail-ej1-f69.google.com with SMTP id gb19so2240961ejc.11
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 02:25:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yWxDArvB83pZrvTNML2Xy5EfIF6keWM/VhTIz+RBTIY=;
        b=HX3m3mpSsNhzSF2NE/D62JvLOWNY9rp8526OPf2WFEmhaWbvGy/Y1YO+kx9BIU79kz
         4rX54hXFIFYYOvpi6JZkcAyFGQ0bOJ605Kl4Abyd06azxEtKOZWx7RbvUC7zcmHL4djS
         enjolZL5XxxckapO6y1NwomrVCdx/zHWRHXzhmsSGg0HXfByQZQNXTW/M4T4SN/GJo8J
         D6u0G3VdE6+cZnHcHVAH4miQjjjEbW2uCa4SmuVCRkm5AfIj5v3hqawspVw99LmwvfZ/
         hGIuB28U+/BqtT57IrIFZXHIhNnYj5f/PZQwFUF1Avh7riMj0MVxoVF6EHstqJR6lCAZ
         0opQ==
X-Gm-Message-State: AOAM530s3pOoP3E6c3fe9vk1/uROAVF+fjqt2wrMU0I1jff5xMe+fSrg
        bl7JaQDT2ATAfTndJpBbPwLpxGyWbRFADEzOR0k7+UPtYh7Sy2SA3GNij2GYAPgF9g1/kfIpsMa
        AnpoUJfGgo63d
X-Received: by 2002:a17:906:5902:: with SMTP id h2mr1917033ejq.137.1614248731028;
        Thu, 25 Feb 2021 02:25:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznZd3RCcXQXlxT+k6mWpSWIP4CYvJpWEweMYTHN2i3d3TB82nGax1izZPvp46a20smNO/vew==
X-Received: by 2002:a17:906:5902:: with SMTP id h2mr1917017ejq.137.1614248730808;
        Thu, 25 Feb 2021 02:25:30 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k27sm2804997eje.67.2021.02.25.02.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 02:25:30 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: Optimized clocksource with AMD AVIC enabled for Windows guest
In-Reply-To: <DM6PR12MB3500EE1617B84D62784AC681CA869@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
 <878s85pl4o.fsf@vitty.brq.redhat.com>
 <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
 <87zh0knhqb.fsf@vitty.brq.redhat.com>
 <721b7075-6931-80f1-7b28-fc723ad14c13@redhat.com>
 <87wnvnop1p.fsf@vitty.brq.redhat.com>
 <87tuqroo7g.fsf@vitty.brq.redhat.com>
 <DM6PR12MB350095499FBD665AA7D969A2CAB29@DM6PR12MB3500.namprd12.prod.outlook.com>
 <DM6PR12MB3500EE1617B84D62784AC681CA869@DM6PR12MB3500.namprd12.prod.outlook.com>
Date:   Thu, 25 Feb 2021 11:25:29 +0100
Message-ID: <87ft1kwijq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kechen Lu <kechenl@nvidia.com> writes:

> Hi Vitaly and Paolo,
>
> Sorry for the delay in response, finally got chance to access a machine with AVIC, and was able to test out the patch and reconfirm through some benchmarks and tests again today:) 
>  
> In summary, this patch works well and resolves the issues on clocksource caused high port I/O vmexits. With AVIC=1 && stimer/synic=1, 
>  
> 1.	CPU intensive workload CPU-z shows SingleThread score 15% improvement 382.1=> 441.7,    
>  
> 2.	disk I/O intensive workload Passmark Disk Test gives 4% improvement 12706=> 13265,              
>  
> 3.	Vmexits pattern of 30s record while running cpu workload Geekbench in guest showing dramatic 90.7% decrease on port IO vmexits, so as the HLT and NPF vmexits, when we get stimer benefit plus AVIC. Details as below:       
>  
> AVIC=1 && stimer/synic=0 && vapic=0:
>  
>              VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time
>  
>                   io     344654    68.29%     1.10%      0.67us   2132.72us      7.01us ( +-   0.19% )
>                  hlt     114046    22.60%    98.85%      0.42us  16666.32us   1903.26us ( +-   0.66% )
> avic_incomplete_ipi      19679     3.90%     0.03%      0.38us     22.67us      3.66us ( +-   0.71% )
>                  npf       8186     1.62%     0.01%      0.37us    235.76us      1.46us ( +-   4.20% )
>             ........                      
>
>  
> AVIC=1 && stimer/synic=1 && vapic=0:
>  
>              VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time
>  
>                   io      31995    38.61%     0.10%      2.79us     65.83us      6.70us ( +-   0.35% )
>                  hlt      22915    27.65%    99.88%      0.42us  15959.14us   9535.38us ( +-   0.50% )
> avic_incomplete_ipi       8271     9.98%     0.01%      0.39us     79.03us      3.58us ( +-   1.23% )
>                  npf       1232     1.49%     0.00%      0.36us    100.25us      2.58us ( +-   6.98% )
> 	..........                                                                                                                                           
>
> While testing, I also found out hv-vapic should be disabled as well to
> make AVIC fully functional, otherwise it shows high vmexits due to MSR
> writes which seems to be due to  increased access to HV_X64_MSR_EOI
> and HV_X64_MSR_ICR. This makes sense to me, since AVIC conflicts with
> PV EOI/ICR accesses. So far I think AVIC=1 && hv-vapic=0 &&
> stimer/synic=1 combination gives us the best performance. However,
> AVIC=1 && hv-vapic=0 && stimer/synic=1 is really unstable, and
> sometimes would lead to boot. Wanted to understand if instabilities
> with APICv/AVIC is a known bug/issue in upstream? Attached the
> reproducible kernel warning in the bottom.

Now it's my turn to apologize for the delayed reply :-)

I think it's our fault,

BIT(3) in HYPERV_CPUID_ENLIGHTMENT_INFO is

HV_X64_APIC_ACCESS_RECOMMENDED
which can be deciphered as 

"Recommend using MSRs for accessing APIC registers EOI, ICR and TPR
rather than their memory-mapped counterparts"

And we shouldn't be setting it with AVIC. The following hack is supposed
to help:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c8f2592ccc99..66ee85a83e9a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -145,6 +145,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
                                           vcpu->arch.ia32_misc_enable_msr &
                                           MSR_IA32_MISC_ENABLE_MWAIT);
        }
+
+       /* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be merged! */
+       best = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
+       if (best) {
+               best->eax &= ~HV_X64_APIC_ACCESS_RECOMMENDED;
+               best->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
+       }
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);

(we'll need to find a proper way to set these settings in QEMU).
 
Could you give it a spin? ("AVIC=1 && hv-vapic=1 && stimer/synic=1" configuration)

>  
> In all, AVIC=1 && hv-vapic=1 && stimer/synic=1 could work stably now and still produce great benefits on vmexits optimization. Thanks all you folks help so much, hope the patch in kernel and bit expose patch in QEMU could get into upstream soon along with fixing the instabilities.
>  
> Best Regards,
> Kechen
>
> ---------------------------------------------------------------------------------------
> [ 7962.437584] ------------[ cut here ]------------
> [ 7962.437586] Invalid IPI target: index=2, vcpu=0, icr=0x4000000:0x82f
> [ 7962.437603] WARNING: CPU: 4 PID: 7109 at arch/x86/kvm/svm/avic.c:349 avic_incomplete_ipi_interception+0x1ff/0x240 [kvm_amd]
> [ 7962.437604] Modules linked in: kvm_amd ccp kvm msr nf_tables nfnetlink bridge stp llc amd64_edac_mod edac_mce_amd nls_iso8859_1 amd_energy crct10dif_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper snd_hda_codec_hdmi rapl snd_hda_intel snd_intel_dspcfg wmi_bmof snd_hda_codec snd_usb_audio snd_hda_core snd_usbmidi_lib snd_hwdep snd_seq_midi snd_seq_midi_event snd_rawmidi efi_pstore joydev mc input_leds snd_seq snd_pcm snd_seq_device snd_timer snd soundcore k10temp mac_hid sch_fq_codel lm92 parport_pc ppdev lp parport ip_tables x_tables autofs4 iavf hid_generic usbhid hid nvme crc32_pclmul i40e ahci nvme_core xhci_pci libahci xhci_pci_renesas i2c_piix4 atlantic macsec wmi [last unloaded: ccp]
> [ 7962.437630] CPU: 4 PID: 7109 Comm: CPU 0/KVM Tainted: P        W  OE     5.8.0-41-generic #46
> [ 7962.437633] RIP: 0010:avic_incomplete_ipi_interception+0x1ff/0x240 [kvm_amd]

No, this is not somthing I'm aware of. Do you know if it reproduces on
the latest upstream?

> [ 7962.437635] Code: 9a 00 00 00 0f 85 2b ff ff ff 41 8b 56 24 8b 4d c8 45 89 e0 44 89 ee 48 c7 c7 a8 34 50 c0 c6 05 b2 9a 00 00 01 e8 d6 cc 3a fb <0f> 0b e9 04 ff ff ff 48 8b 5d c0 8b 55 c8 be 10 03 00 00 48 89 df
> [ 7962.437636] RSP: 0018:ffffa7894f9bfcc0 EFLAGS: 00010282
> [ 7962.437637] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff99347f118cd8
> [ 7962.437637] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff99347f118cd0
> [ 7962.437638] RBP: ffffa7894f9bfd18 R08: 0000000000000004 R09: 0000000000000831
> [ 7962.437638] R10: 0000000000000000 R11: 0000000000000001 R12: 040000000000082f
> [ 7962.437639] R13: 0000000000000002 R14: ffff993345653448 R15: 0000000000000002
> [ 7962.437640] FS:  0000000000000000(0053) GS:ffff99347f100000(002b) knlGS:fffff80470728000
> [ 7962.437640] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7962.437641] CR2: ffff8006ace2b000 CR3: 0000000febd88000 CR4: 0000000000340ee0
> [ 7962.437641] Call Trace:
> [ 7962.437646]  handle_exit+0x134/0x420 [kvm_amd]
> [ 7962.437661]  ? kvm_set_cr8+0x22/0x40 [kvm]
> [ 7962.437674]  vcpu_enter_guest+0x862/0xd90 [kvm]
> [ 7962.437687]  vcpu_run+0x76/0x240 [kvm]
> [ 7962.437699]  kvm_arch_vcpu_ioctl_run+0x9f/0x2b0 [kvm]
> [ 7962.437711]  kvm_vcpu_ioctl+0x247/0x600 [kvm]
> [ 7962.437714]  ksys_ioctl+0x8e/0xc0
> [ 7962.437715]  __x64_sys_ioctl+0x1a/0x20
> [ 7962.437717]  do_syscall_64+0x49/0xc0
> [ 7962.437719]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 7962.437720] RIP: 0033:0x7f4c09b1131b
> [ 7962.437721] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1d 3b 0d 00 f7 d8 64 89 01 48
> [ 7962.437721] RSP: 002b:00007f4bedffa4a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [ 7962.437722] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007f4c09b1131b
> [ 7962.437723] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000015
> [ 7962.437723] RBP: 0000563c35a94990 R08: 0000563c33b95a30 R09: 0000000000000004
> [ 7962.437724] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [ 7962.437724] R13: 0000563c34196d00 R14: 0000000000000000 R15: 00007f4bedffb640
> [ 7962.437726] ---[ end trace 7f0f339c3a001d7b ]---
>

-- 
Vitaly

