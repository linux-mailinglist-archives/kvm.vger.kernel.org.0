Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CA6643CC5
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 06:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiLFFuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 00:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiLFFuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 00:50:11 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8170818E33
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 21:50:10 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id m18so2083257eji.5
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 21:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c6IAX5g6ledgAGKMBe/QiPZH1nxVzHQk9dCLqZzUwt0=;
        b=PhSiFZVKOV80QGWnFhG4fhkEk4eKKXZ7LDW1qO7BVRMCpBAo3CUlllTeAr+MmTGicX
         4HQjpCRJjRNTNL3aVGFIUjAY/PpSqxk/u4MJcEt/UM5eBjjVz1BBsDbAr2EMOpbkC/On
         RczpIwbU6WsLJZFHDaiw7EpIfBhz/IPIry3hsVkdS5fi/TRjuf3Jsk6tBlG3phZ3540y
         NZz2kIUBpk0VdPzoNyOnYb0GEfvBxktphGqEVpqXY2Glrfn6tuydvP6jF0BQba1LWmZu
         RHiHrLMXk50dqwFEK4LQSr8bpd/2BcIblKvq2W6NpzvOVqQoiJPKz7HkrLUhMWoK7hpu
         4eVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6IAX5g6ledgAGKMBe/QiPZH1nxVzHQk9dCLqZzUwt0=;
        b=1eZQGDeybi+yvWNUlaoQ5wo6ORB1yspIPnYUBKzDHF0St77geb6FXMzUo/s7RfRQXz
         GTTmSWkoioarSQtW0SPHVn0NR4Yp4bHhEdOfH96ibs74KSgiriObt58PkfcRd5e31MRp
         rL8xqejZldl49OZpABeOByAMKFdgzJggkmgGM7gXU/NqjeRNlwc7GnQ6tJAugQKSq/dL
         kNLIaYRiY8xOOLryx0XG1qxiZsisayADlcxKqxvnaQymC8wCbYOidStvFQySfNAp12qi
         kmem013mpGcCOfjspEXxxSXoL4V6NKP2iPYQr/h6MTgRsdc0O1tswygT3pJ1bPZhxAHB
         SQrw==
X-Gm-Message-State: ANoB5pkj7l/SOZcnhw1LQSZ6ymptLQ2oo9bBkLhaD0crBxNy9Y7LBNs/
        VcafJ6XtAEgvDMfpFMslPp/E4g==
X-Google-Smtp-Source: AA0mqf42zHplnnTX3EhWv3vS1EQcNMrEq3dkE0SS95uGttl1Xz5Njr7HJyTo75V4/pgIPyTnxhnnXg==
X-Received: by 2002:a17:906:6bd4:b0:7c0:e23e:bbd6 with SMTP id t20-20020a1709066bd400b007c0e23ebbd6mr8906329ejs.551.1670305809017;
        Mon, 05 Dec 2022 21:50:09 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id og40-20020a1709071de800b007c0d6b34d54sm3609973ejc.129.2022.12.05.21.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 21:50:08 -0800 (PST)
Date:   Tue, 6 Dec 2022 06:50:07 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Message-ID: <20221206055007.cvc4zfworla3fwwr@kamzik>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-2-jszhang@kernel.org>
 <20221205145710.xzb4prrc44gv7mwm@kamzik>
 <Y44fY5tCC1hHDfcw@xhacker>
 <Y44hL3l8Uqg+JgWI@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y44hL3l8Uqg+JgWI@xhacker>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 12:49:51AM +0800, Jisheng Zhang wrote:
> On Tue, Dec 06, 2022 at 12:42:16AM +0800, Jisheng Zhang wrote:
> > On Mon, Dec 05, 2022 at 03:57:10PM +0100, Andrew Jones wrote:
> > > On Mon, Dec 05, 2022 at 01:46:20AM +0800, Jisheng Zhang wrote:
> > > > Alternatives live in a different section, so offsets used by jal
> > > > instruction will point to wrong locations after the patch got applied.
> > > > 
> > > > Similar to arm64, adjust the location to consider that offset.
> > > > 
> > > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > > ---
> > > >  arch/riscv/include/asm/alternative.h |  2 ++
> > > >  arch/riscv/kernel/alternative.c      | 38 ++++++++++++++++++++++++++++
> > > >  arch/riscv/kernel/cpufeature.c       |  3 +++
> > > >  3 files changed, 43 insertions(+)
> > > > 
> > > > diff --git a/arch/riscv/include/asm/alternative.h b/arch/riscv/include/asm/alternative.h
> > > > index c58ec3cc4bc3..33eae9541684 100644
> > > > --- a/arch/riscv/include/asm/alternative.h
> > > > +++ b/arch/riscv/include/asm/alternative.h
> > > > @@ -29,6 +29,8 @@ void apply_module_alternatives(void *start, size_t length);
> > > >  
> > > >  void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int len,
> > > >  				      int patch_offset);
> > > > +void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> > > > +			       int patch_offset);
> > > >  
> > > >  struct alt_entry {
> > > >  	void *old_ptr;		 /* address of original instruciton or data  */
> > > > diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
> > > > index 292cc42dc3be..9d88375624b5 100644
> > > > --- a/arch/riscv/kernel/alternative.c
> > > > +++ b/arch/riscv/kernel/alternative.c
> > > > @@ -125,6 +125,44 @@ void riscv_alternative_fix_auipc_jalr(void *alt_ptr, unsigned int len,
> > > >  	}
> > > >  }
> > > >  
> > > > +#define to_jal_imm(value)						\
> > > > +	(((value & (RV_J_IMM_10_1_MASK << RV_J_IMM_10_1_OFF)) << RV_I_IMM_11_0_OPOFF) | \
> > >                                                                  ^ RV_J_IMM_10_1_OPOFF
> > > 
> > > > +	 ((value & (RV_J_IMM_11_MASK << RV_J_IMM_11_OFF)) << RV_J_IMM_11_OPOFF) | \
> > > > +	 ((value & (RV_J_IMM_19_12_OPOFF << RV_J_IMM_19_12_OFF)) << RV_J_IMM_19_12_OPOFF) | \
> > > > +	 ((value & (1 << RV_J_IMM_SIGN_OFF)) << RV_J_IMM_SIGN_OPOFF))
> > 
> > Hi all,
> > 
> > I believe there's bug in the to_jal_imm() macro implementation, the
> > correct one should be like this:
> > 
> > #define to_jal_imm(value)                                               \
> >         ((RV_X(value, RV_J_IMM_10_1_OFF, RV_J_IMM_10_1_MASK) << RV_J_IMM_10_1_OPOFF) | \
> >         (RV_X(value, RV_J_IMM_11_OFF, RV_J_IMM_11_MASK) << RV_J_IMM_11_OPOFF) | \
> >         (RV_X(value, RV_J_IMM_19_12_OFF, RV_J_IMM_19_12_MASK) << RV_J_IMM_19_12_OPOFF) | \
> >         (RV_X(value, RV_J_IMM_SIGN_OFF, 1) << RV_J_IMM_SIGN_OPOFF))
> 
> And I just tested to_jal_imm() vs RV_EXTRACT_JTYPE_IMM(), they match perfectly.
> E.g:
> RV_EXTRACT_JTYPE_IMM(to_jal_imm(imm)) == imm is alway true when imm is a jal
> valid offset.

I think we should define deposit() functions for each type, as well as the
extract() functions, (and I'd prefer we use static inlines to macros to
get some type checking). See [1] for my proposal.

[1] https://lore.kernel.org/all/20221205145323.l2dro6dt7muumqpn@kamzik/

Thanks,
drew

> 
> > 
> > Will fix it in next version.
> > 
> > Thanks
> > > 
> > > Should put () around value
> > > 
> > > > +
> > > > +void riscv_alternative_fix_jal(void *alt_ptr, unsigned int len,
> > > > +			       int patch_offset)
> > > > +{
> > > > +	int num_instr = len / sizeof(u32);
> > > > +	unsigned int call;
> > > > +	int i;
> > > > +	int imm;
> > > > +
> > > > +	for (i = 0; i < num_instr; i++) {
> > > > +		u32 inst = riscv_instruction_at(alt_ptr, i);
> > > > +
> > > > +		if (!riscv_insn_is_jal(inst))
> > > > +			continue;
> > > > +
> > > > +		/* get and adjust new target address */
> > > > +		imm = RV_EXTRACT_JTYPE_IMM(inst);
> > > > +		imm -= patch_offset;
> > > > +
> > > > +		/* pick the original jal */
> > > > +		call = inst;
> > > > +
> > > > +		/* drop the old IMMs, all jal imm bits sit at 31:12 */
> > > > +		call &= ~GENMASK(31, 12);
> > > 
> > > It'd be nice if this had a define.
> > > 
> > > > +
> > > > +		/* add the adapted IMMs */
> > > > +		call |= to_jal_imm(imm);
> > > > +
> > > > +		/* patch the call place again */
> > > > +		patch_text_nosync(alt_ptr + i * sizeof(u32), &call, 4);
> > > > +	}
> > > > +}
> > > > +
> > > >  /*
> > > >   * This is called very early in the boot process (directly after we run
> > > >   * a feature detect on the boot CPU). No need to worry about other CPUs
> > > > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > > > index ba62a4ff5ccd..c743f0adc794 100644
> > > > --- a/arch/riscv/kernel/cpufeature.c
> > > > +++ b/arch/riscv/kernel/cpufeature.c
> > > > @@ -324,6 +324,9 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
> > > >  			riscv_alternative_fix_auipc_jalr(alt->old_ptr,
> > > >  							 alt->alt_len,
> > > >  							 alt->old_ptr - alt->alt_ptr);
> > > > +			riscv_alternative_fix_jal(alt->old_ptr,
> > > > +						  alt->alt_len,
> > > > +						  alt->old_ptr - alt->alt_ptr);
> > > >  		}
> > > >  	}
> > > >  }
> > > > -- 
> > > > 2.37.2
> > > >
> > > 
> > > Thanks,
> > > drew
