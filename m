Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7413A57A25B
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbiGSOto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239875AbiGSOtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:49:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AE364E7;
        Tue, 19 Jul 2022 07:49:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q41-20020a17090a1b2c00b001f2043c727aso1702363pjq.1;
        Tue, 19 Jul 2022 07:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qVI7xqi0qd82P0/Dg/s1Y+IXZYKdIlg2LZekq43656M=;
        b=jTnZrRbrjTJ4WHsCVCHP+tZw3nqW+FiAG54FxUzegoA3oTQQJOkjezXaQkiW6IkiQ0
         8GmyzGW5mWxzGJCdFW41B3f1D/SUVjFby8U2kbtF7Nmk7XL1ufyysAl6kPKkomO1QP9+
         G9eK0KhoViLx8BFOiVKhzjR8UpMlTx6KAQDvMeXPrtvGsGyvbaQnwrvr76UJ4jacCWng
         jofdFRTjZ4CuJc+j5dGmdJCjl/ozF0/TShC2ww4BaEmVbB9BCCRfy6pE5Od82Ndm4a+9
         rirARcIqCMa43HExwfAjRX0zZFXrRBThcyhi+o4Y43vkitaKQCoBX17paiCMsghbFuzp
         +MKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qVI7xqi0qd82P0/Dg/s1Y+IXZYKdIlg2LZekq43656M=;
        b=z9LXCowwSVgGAec2TQ+q+8MDt5hiEYre+yYb/wrSjt+zLiPvsREuUwKj36p6ClVLYe
         RDMmtOX815lQPB3B9BY5Zx9NNpnen70A7N7MDkNZww71EqucJWutVI8LOF3zkNDINc2R
         iboefG377kiAs8V7/cqnAEb8J1Aa0I4IzL5Y73XSMUWmA3G1OhQ65+QudG1Dc7nRbH8e
         DO3MhOMYatMgP30oMyBeq8c+HdKgIkKt8kMPyGj9xpFVdzdb9+6W/yRV5K5XH9Jg3R3H
         vcK5hSbJ+eZtYQDUsk4D63bTZ+jiglCeYPZxgdjw040pZrqCq25ep4b6SoNunLkEoPO9
         rH1w==
X-Gm-Message-State: AJIora9FfRwRINuaJiexyIhrrHJ21WriggNdCqHUz7rr6z/WwuQ2JH1D
        KPyXkkoUSzggkmwXh4BbSvU+A9Jmd6E=
X-Google-Smtp-Source: AGRyM1uMHCaESv284Sj3AXmnsYmKHbswE7j3Ox3f+eIggixI1cyWjfyAsyIk568jIE5d7tCPdtlX6A==
X-Received: by 2002:a17:902:c641:b0:16b:dd82:c04 with SMTP id s1-20020a170902c64100b0016bdd820c04mr33836780pls.144.1658242178454;
        Tue, 19 Jul 2022 07:49:38 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id t187-20020a625fc4000000b0052ab8a92496sm11155978pfb.168.2022.07.19.07.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:49:37 -0700 (PDT)
Date:   Tue, 19 Jul 2022 07:49:36 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 041/102] KVM: VMX: Introduce test mode related to EPT
 violation VE
Message-ID: <20220719144936.GX1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <cadf3221e3f7b911c810f15cfe300dd5337a966d.1656366338.git.isaku.yamahata@intel.com>
 <52915310c9118a124da2380daf3d753a818de05e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52915310c9118a124da2380daf3d753a818de05e.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022 at 02:23:43PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM programs
> > to inject #VE conditionally and set #VE suppress bit in EPT entry.  For VMX
> > case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
> > defensive (test that VMX case isn't broken), introduce option
> > ept_violation_ve_test and when it's set, set error.
> 
> I don't see why we need this patch.  It may be helpful during your test, but why
> do we need this patch for formal submission?
> 
> And for a normal guest, what prevents one vcpu from sending #VE IPI to another
> vcpu?

Paolo suggested it as follows.  Maybe it should be kernel config.
(I forgot to add suggested-by. I'll add it)

https://lore.kernel.org/lkml/84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.com/

> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > + if (enable_ept) {
> > +  const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
> >     kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> > -          cpu_has_vmx_ept_execute_only());
> > +          cpu_has_vmx_ept_execute_only(), init_value);
> > +  kvm_mmu_set_spte_init_value(init_value);
> > + }
> 
> I think kvm-intel.ko should use VMX_EPT_SUPPRESS_VE_BIT unconditionally 
> as the init value.  The bit is ignored anyway if the "EPT-violation #VE" 
> execution control is 0.  Otherwise looks good, but I have a couple more 
> crazy ideas:
> 
> 1) there could even be a test mode where KVM enables the execution 
> control, traps #VE in the exception bitmap, and shouts loudly if it gets 
> a #VE.  That might avoid hard-to-find bugs due to forgetting about 
> VMX_EPT_SUPPRESS_VE_BIT.
> 
> 2) or even, perhaps the init_value for the TDP MMU could set bit 63 
> _unconditionally_, because KVM always sets the NX bit on AMD hardware. 
> That would remove the whole infrastructure to keep shadow_init_value, 
> because it would be constant 0 in mmu.c and constant BIT(63) in tdp_mmu.c.
> 
> Sean, what do you think?
> 
> Paolo
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
