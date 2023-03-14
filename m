Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713186B9A26
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 16:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjCNPpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 11:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjCNPpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 11:45:20 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B25EB32A1;
        Tue, 14 Mar 2023 08:44:42 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id f18so20612526lfa.3;
        Tue, 14 Mar 2023 08:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678808678; x=1681400678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgTpDdjkEtDwUyqMsKfKimgkpTko/+U4mjHsdeCCyAw=;
        b=jn+4fsbltc9iHB3Pg5GN3DIZTz8zMRzUeKeAIzOiTyYvXPUn/3asS8Ueyq6cSIzv7b
         KfOshWG4YecYkTM5ULwjC66WFhoMkDdpEsW4UewwGMGhucUoNikdZIvciTL/i9szXTHL
         FaSQuKBvVTEdjgSN5O6bAMSKQAoFg5wFR7nLwLZaGgpQ03j2Xwo8SL9alAhePo7gOL2n
         gpbcyWjJKAS45cJ/PMATN1DElGUDwNAQsfI9nSwIb+Z5CNVqPov6+NDgMeku5Ypt6UEC
         AGzG6Fg35jFPB1Wjjd8Bq8F4T8S93tyGqnVoDw03OQJy9gifmcrNyqbXz9WIeArpE2BA
         /p/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808678; x=1681400678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgTpDdjkEtDwUyqMsKfKimgkpTko/+U4mjHsdeCCyAw=;
        b=DtyeXw8GuykBCw3lVMx6mDFx4Lcy13UDiMwf/sTLDNpu9I14CZcDUdLurT/alQ1hyj
         +192wFW5eEMBkcHa0ie9jWQMBAklKMzTWhha0iKntfwOLxzldqkr/6KVrV4sv34ne36R
         JBOT5tVGBOjJXNvnidGyuYjHCXtCjbtdusL9vPWpkPQZDlDIZMVUeOPYX9NI8PZIWQtg
         OSNfQygvizeHTn5dLIrTdMfICVW2u8NFqx/N3Qq7U2Hoi9rrI9rEk16f0MotQfbahNNl
         iMeHz+sngFzxAVWiflVqy7aNAly+OqMQFLgkJCYkLdakrurFhij2Tm4zldXUZBrmIYR2
         ZvkQ==
X-Gm-Message-State: AO0yUKW0yQ0Tcr7hvAnusuUrJ2Sgg2BZeYXL2fAiABmBjfw3+D4NPRrA
        Ibu/QVIiUj/2c/PeuOIULoXRxlwjF2k=
X-Google-Smtp-Source: AK7set9Y1zV5rLAEEvjenaYbvtewXbHCXiE3dOYMiaGQa6T/jHn8v6l35bVSLf5V1f4SsCB9xAyJDg==
X-Received: by 2002:ac2:5239:0:b0:4db:3467:f2ff with SMTP id i25-20020ac25239000000b004db3467f2ffmr62296lfl.5.1678808678111;
        Tue, 14 Mar 2023 08:44:38 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id w16-20020ac25990000000b004cb1de3f487sm443117lfn.104.2023.03.14.08.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:44:38 -0700 (PDT)
Date:   Tue, 14 Mar 2023 17:44:36 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 15/28] KVM: arm64: Handle realm MMIO emulation
Message-ID: <20230314174436.0000584d@gmail.com>
In-Reply-To: <e0354676-e8cf-6ea0-3229-a55d90259f8e@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-16-steven.price@arm.com>
        <20230306173751.000026d4@gmail.com>
        <e0354676-e8cf-6ea0-3229-a55d90259f8e@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Mar 2023 15:47:14 +0000
Steven Price <steven.price@arm.com> wrote:

> On 06/03/2023 15:37, Zhi Wang wrote:
> > On Fri, 27 Jan 2023 11:29:19 +0000
> > Steven Price <steven.price@arm.com> wrote:
> >   
> >> MMIO emulation for a realm cannot be done directly with the VM's
> >> registers as they are protected from the host. However the RMM interface
> >> provides a structure member for providing the read/written value and  
> > 
> > More details would be better for helping the review. I can only see the
> > emulated mmio value from the device model (kvmtool or kvm_io_bus) is put into
> > the GPRS[0] of the RecEntry object. But the rest of the flow is missing.  
> 
> The commit message is out of date (sorry about that). A previous version
> of the spec had a dedicated member for the read/write value, but this
> was changed to just use GPRS[0] as you've spotted. I'll update the text.
> 
> > I guess RMM copies the value in the RecEntry.GPRS[0] to the target GPR in the
> > guest context in RMI_REC_ENTER when seeing RMI_EMULATED_MMIO. This is for
> > the guest MMIO read path.  
> 
> Yes, when entering the guest after an (emulatable) read data abort the
> value in GPRS[0] is loaded from the RecEntry structure into the
> appropriate register for the guest.
> 
> > How about the MMIO write path? I don't see where the RecExit.GPRS[0] is loaded
> > to a varible and returned to the userspace.  
> 

-----
> The RMM will populate GPRS[0] with the written value in this case (even
> if another register was actually used in the instruction). We then
> transfer that to the usual VCPU structure so that the normal fault
> handling logic works.
> 
-----

Are these in this patch or another patch?

> >> we can transfer this to the appropriate VCPU's register entry and then
> >> depend on the generic MMIO handling code in KVM.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >>  arch/arm64/kvm/mmio.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> >> index 3dd38a151d2a..c4879fa3a8d3 100644
> >> --- a/arch/arm64/kvm/mmio.c
> >> +++ b/arch/arm64/kvm/mmio.c
> >> @@ -6,6 +6,7 @@
> >>  
> >>  #include <linux/kvm_host.h>
> >>  #include <asm/kvm_emulate.h>
> >> +#include <asm/rmi_smc.h>
> >>  #include <trace/events/kvm.h>
> >>  
> >>  #include "trace.h"
> >> @@ -109,6 +110,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
> >>  			       &data);
> >>  		data = vcpu_data_host_to_guest(vcpu, data, len);
> >>  		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
> >> +
> >> +		if (vcpu_is_rec(vcpu))
> >> +			vcpu->arch.rec.run->entry.gprs[0] = data;  
> > 
> > I think the guest context is maintained by RMM (while KVM can only touch
> > Rec{Entry, Exit} object) so that guest context in the legacy VHE mode is
> > unused.
> > 
> > If yes, I guess here is should be:
> > 
> > if (unlikely(vcpu_is_rec(vcpu)))
> > 	vcpu->arch.rec.run->entry.gprs[0] = data;
> > else
> > 	vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);  
> 
> Correct. Although there's no harm in updating with vcpu_set_reg(). But
> I'll make the change because it's clearer.
> 
> >>  	}
> >>  
> >>  	/*
> >> @@ -179,6 +183,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
> >>  	run->mmio.len		= len;
> >>  	vcpu->mmio_needed	= 1;
> >>  
> >> +	if (vcpu_is_rec(vcpu))
> >> +		vcpu->arch.rec.run->entry.flags |= RMI_EMULATED_MMIO;
> >> +  
> > 
> > Wouldn't it be better to set this in the kvm_handle_mmio_return where the MMIO
> > read emulation has been surely successful?  
> 
> Yes, that makes sense - I'll move this.
> 
> Thanks,
> 
> Steve
> 
> >>  	if (!ret) {
> >>  		/* We handled the access successfully in the kernel. */
> >>  		if (!is_write)  
> >   
> 

