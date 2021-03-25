Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD820348709
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 03:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhCYCoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 22:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhCYCns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 22:43:48 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1D1C06174A
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 19:43:46 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id o19so504618qvu.0
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 19:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=KPgNseh8yYhheSsYQuED4Rz4kqyVes0PKuxx8Zc5Pzk=;
        b=BdIRT1S5lkykj3PvB/gG74m7dcanhvDfxsY84m9i/OkWLHWNw6KkyuuSD1aE/8W0nn
         hnAXpKxLL2vzXDs6ek8vgALNt0Xj2b+Zh52/nTXHCKdl+jUPO8X67v40EPD2WSyallrs
         BKUvrT+pexeE2vRqu+JPiUZT1Aha1NBgQqQDsezN8OVmrplKEzfFId0XzsOsXy7cu84d
         Fifq1EhNAZyhoCgUH6qCNUmfXXJYhxuPpYBHwd7lJ6f0teYtEcmCOp//h18PWoSXGpu+
         eYlTvIPFjjWXxFXBBEdfZ5z2zx2mXgAR7FSgGEP0M2/Eu2rXAEe6AfxFlMOe9NFZFCus
         3s4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=KPgNseh8yYhheSsYQuED4Rz4kqyVes0PKuxx8Zc5Pzk=;
        b=NEbjl/tizA5wR52uIvdlIWprGAAWMRswjYTD6JUxRMIGV5kOqDxvZtqeVzHodDsEaP
         1Fk5gMzvia6IWlyRsUUGVcYnhI2/UNtwIqS1P8d8jeEMT4QTt2rBNOzkOXR5cO54QAQl
         59fIrXJZlLETYg4gUi/D/RQ/of81mBvXRrsOwxwl00/aV3oLol8hKME2UMOdoNauoguX
         2s9+o1feYXQVaXsVtugtRf3I/Q/vhD4KSDajaN0CSk6ROt0OmBJgm5wnkXCi4tKLBH0b
         mzxLVCY/Tuau8c0NBih8qvQ8o+jnRzNNOh9Fp5OkeOIeGG5XoLaReayJaZT8PZj1QSVs
         PNHg==
X-Gm-Message-State: AOAM531j675oexAVWVmIAWLwEx3iaajVYuITOmdZ7HWVXA/+SveDNGJf
        Rfuk4wn8Np9vhumG3QF4Eqt/Cg==
X-Google-Smtp-Source: ABdhPJwcyeXHhO8Q3sUImkphN8YEfHa9SN9UJo5Q0zYpmr3RNeLZ8JXaXB7Mf8ncQ4rzefPHRXy05w==
X-Received: by 2002:ad4:584d:: with SMTP id de13mr6421434qvb.17.1616640225605;
        Wed, 24 Mar 2021 19:43:45 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id b1sm3243761qkk.117.2021.03.24.19.43.43
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 24 Mar 2021 19:43:45 -0700 (PDT)
Date:   Wed, 24 Mar 2021 19:43:29 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Borislav Petkov <bp@alien8.de>
cc:     Hugh Dickins <hughd@google.com>, Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
In-Reply-To: <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
Message-ID: <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
References: <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com> <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com> <20210311200755.GE5829@zn.tnic> <20210311203206.GF5829@zn.tnic> <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com> <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com> <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com> <20210311235215.GI5829@zn.tnic> <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com> <20210324212139.GN5010@zn.tnic> <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Mar 2021, Hugh Dickins wrote:
> On Wed, 24 Mar 2021, Borislav Petkov wrote:
> 
> > Ok,
> > 
> > some more experimenting Babu and I did lead us to:
> > 
> > ---
> > diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> > index f5ca15622dc9..259aa4889cad 100644
> > --- a/arch/x86/include/asm/tlbflush.h
> > +++ b/arch/x86/include/asm/tlbflush.h
> > @@ -250,6 +250,9 @@ static inline void __native_flush_tlb_single(unsigned long addr)
> >  	 */
> >  	if (kaiser_enabled)
> >  		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
> > +	else
> > +		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
> > +
> >  	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
> >  }
> > 
> > applied on the guest kernel which fixes the issue. And let me add Hugh
> > who did that PCID stuff at the time. So lemme summarize for Hugh and to
> > ask him nicely to sanity-check me. :-)
> 
> Just a brief interim note to assure you that I'm paying attention,
> but wow, it's a long time since I gave any thought down here!
> Trying to page it all back in...
> 
> I see no harm in your workaround if it works, but it's not as if
> this is a previously untried path: so I'm suspicious how an issue
> here with Globals could have gone unnoticed for so long, and need
> to understand it better.

Right, after looking into it more, I completely agree with you:
the Kaiser series (in both 4.4-stable and 4.9-stable) was simply
wrong to lose that invlpg - fine in the kaiser case when we don't
enable Globals at all, but plain wrong in the !kaiser_enabled case.
One way or another, we have somehow got away with it for three years.

I do agree with Paolo that the PCID_ASID_KERN flush would be better
moved under the "if (kaiser_enabled)" now. (And if this were ongoing
development, I'd want to rewrite the function altogether: but no,
these old stable trees are not the place for that.)

Boris, may I leave both -stable fixes to you?
Let me know if you'd prefer me to clean up my mess.

Thanks a lot for tracking this down,
Hugh

> > 
> > Basically, you have an AMD host which supports PCID and INVPCID and you
> > boot on it a 4.9 guest. It explodes like the panic below.
> > 
> > What fixes it is this:
> > 
> > diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> > index f5ca15622dc9..259aa4889cad 100644
> > --- a/arch/x86/include/asm/tlbflush.h
> > +++ b/arch/x86/include/asm/tlbflush.h
> > @@ -250,6 +250,9 @@ static inline void __native_flush_tlb_single(unsigned long addr)
> >  	 */
> >  	if (kaiser_enabled)
> >  		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
> > +	else
> > +		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
> > +
> >  	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
> >  }
> > 
> > ---
> > 
> > and the reason why it does, IMHO, is because on AMD, kaiser_enabled is
> > false because AMD is not affected by Meltdown, which means, there's no
> > user/kernel pagetables split.
> > 
> > And that also means, you have global TLB entries which means that if you
> > look at that __native_flush_tlb_single() function, it needs to flush
> > global TLB entries on CPUs with X86_FEATURE_INVPCID_SINGLE by doing an
> > INVLPG in the kaiser_enabled=0 case. Errgo, the above hunk.
> > 
> > But I might be completely off here thus this note...
> > 
> > Thoughts?
> > 
> > Thx.
> > 
> > 
> > [    1.235726] ------------[ cut here ]------------
> > [    1.237515] kernel BUG at /build/linux-dqnRSc/linux-4.9.228/arch/x86/kernel/alternative.c:709!
> > [    1.240926] invalid opcode: 0000 [#1] SMP
> > [    1.243301] Modules linked in:
> > [    1.244585] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.9.0-13-amd64 #1 Debian 4.9.228-1
> > [    1.247657] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > [    1.251249] task: ffff909363e94040 task.stack: ffffa41bc0194000
> > [    1.253519] RIP: 0010:[<ffffffff8fa2e40c>]  [<ffffffff8fa2e40c>] text_poke+0x18c/0x240
> > [    1.256593] RSP: 0018:ffffa41bc0197d90  EFLAGS: 00010096
> > [    1.258657] RAX: 000000000000000f RBX: 0000000001020800 RCX: 00000000feda3203
> > [    1.261388] RDX: 00000000178bfbff RSI: 0000000000000000 RDI: ffffffffff57a000
> > [    1.264168] RBP: ffffffff8fbd3eca R08: 0000000000000000 R09: 0000000000000003
> > [    1.266983] R10: 0000000000000003 R11: 0000000000000112 R12: 0000000000000001
> > [    1.269702] R13: ffffa41bc0197dcf R14: 0000000000000286 R15: ffffed1c40407500
> > [    1.272572] FS:  0000000000000000(0000) GS:ffff909366300000(0000) knlGS:0000000000000000
> > [    1.275791] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [    1.278032] CR2: 0000000000000000 CR3: 0000000010c08000 CR4: 00000000003606f0
> > [    1.280815] Stack:
> > [    1.281630]  ffffffff8fbd3eca 0000000000000005 ffffa41bc0197e03 ffffffff8fbd3ecb
> > [    1.284660]  0000000000000000 0000000000000000 ffffffff8fa2e835 ccffffff8fad4326
> > [    1.287729]  1ccd0231874d55d3 ffffffff8fbd3eca ffffa41bc0197e03 ffffffff90203844
> > [    1.290852] Call Trace:
> > [    1.291782]  [<ffffffff8fbd3eca>] ? swap_entry_free+0x12a/0x300
> > [    1.294900]  [<ffffffff8fbd3ecb>] ? swap_entry_free+0x12b/0x300
> > [    1.297267]  [<ffffffff8fa2e835>] ? text_poke_bp+0x55/0xe0
> > [    1.299473]  [<ffffffff8fbd3eca>] ? swap_entry_free+0x12a/0x300
> > [    1.301896]  [<ffffffff8fa2b64c>] ? arch_jump_label_transform+0x9c/0x120
> > [    1.304557]  [<ffffffff9073e81f>] ? set_debug_rodata+0xc/0xc
> > [    1.306790]  [<ffffffff8fb81d92>] ? __jump_label_update+0x72/0x80
> > [    1.309255]  [<ffffffff8fb8206f>] ? static_key_slow_inc+0x8f/0xa0
> > [    1.311680]  [<ffffffff8fbd7a57>] ? frontswap_register_ops+0x107/0x1d0
> > [    1.314281]  [<ffffffff9077078c>] ? init_zswap+0x282/0x3f6
> > [    1.316547]  [<ffffffff9077050a>] ? init_frontswap+0x8c/0x8c
> > [    1.318784]  [<ffffffff8fa0223e>] ? do_one_initcall+0x4e/0x180
> > [    1.321067]  [<ffffffff9073e81f>] ? set_debug_rodata+0xc/0xc
> > [    1.323366]  [<ffffffff9073f08d>] ? kernel_init_freeable+0x16b/0x1ec
> > [    1.325873]  [<ffffffff90011d50>] ? rest_init+0x80/0x80
> > [    1.327989]  [<ffffffff90011d5a>] ? kernel_init+0xa/0x100
> > [    1.330092]  [<ffffffff9001f424>] ? ret_from_fork+0x44/0x70
> > [    1.332311] Code: 00 0f a2 4d 85 e4 74 4a 0f b6 45 00 41 38 45 00 75 19 31 c0 83 c0 01 48 63 d0 49 39 d4 76 33 41 0f b6 4c 15 00 38 4c 15 00 74 e9 <0f> 0b 48 89 ef e8 da d6 19 00 48 8d bd 00 10 00 00 48 89 c3 e8 
> > [    1.342818] RIP  [<ffffffff8fa2e40c>] text_poke+0x18c/0x240
> > [    1.345859]  RSP <ffffa41bc0197d90>
> > [    1.347285] ---[ end trace 0a1c5ab5eb16de89 ]---
> > [    1.349169] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> > [    1.349169] 
> > [    1.352885] Kernel Offset: 0xea00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > [    1.357039] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> > [    1.357039] 
> > 
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > https://people.kernel.org/tglx/notes-about-netiquette
