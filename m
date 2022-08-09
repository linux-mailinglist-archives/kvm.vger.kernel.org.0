Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D4D58D175
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 02:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244740AbiHIAsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 20:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244457AbiHIAst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 20:48:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DC7BA5;
        Mon,  8 Aug 2022 17:48:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso10732277pjl.4;
        Mon, 08 Aug 2022 17:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kc/KcJ1/Sv1U6ib2VY1BnVwQKDPVKyoIb6rAay5qsDk=;
        b=GTQhdKq+HAQSElM2peGsEfvfgGlLkW7iKwWMoibdtUVsogjDZ/uf5Rq1i61eZv+8pf
         McFcn5RG016LhQXNUN4g4C0PHUh/xhADsEQHV8szcP1JPjFNBnfGvsKoTm8nJpd00rM5
         pLh6/j17DYpRPkmbzhShc2XAuQSgl2HPCymWxY4g58kdYzugjBQ2PWmzU5P1xD0uzjeQ
         gNuY4/lwfQrU6nEypTYajrAL/Gu4e30BTESa+lBcc5AHR29HPnI29y9u0lXuPE5pinlt
         bF41znDXlJ/H/oblskhGNhR9UK75YVCQHtw0f/7myHjr8a3wft3FTDmXVdSje1kgOg3n
         M8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kc/KcJ1/Sv1U6ib2VY1BnVwQKDPVKyoIb6rAay5qsDk=;
        b=cQ2M0gZeP614KXLRgA49ZJBbYWAu5zUP/VI6ERs0xa+FHcLE8kuPFO4wIZZAYxDxZE
         xmgjK+m0ev+Ld5CZWmw9gHT55YZ5OZv+/X9MkzSyMl6RrkbzImuaf3F2/JvJQZ10xEat
         fL0vYrdAltTzw1SrqDMmohpb9cb7CJm1+ZYZfWR4B03HPAGfTH5BnB1NRvC1nIQMMYgW
         V5SS+6z5pdMoDAo14V+DNvjOKcbTw1EA+QqUs4tlkGMrtTwUgPRIdSu4oCJNqdwSFF4C
         D69UYT0hhVgXlsfyZYW3cgnWS+/4wCxRfF/22+gGPZsKaHUPU1cPf8jyx4KkuaBX8kmY
         b6hg==
X-Gm-Message-State: ACgBeo2GAkp2wsPHDAI+WFB2+5p5pzZQQC/hRk3Ur4UiCiyTLo+sSSR7
        qp6eKmKi+CpHWFEQ72/UCJk=
X-Google-Smtp-Source: AA6agR4YkiEr2P0xVTrp4gHmVMHYklRXP4SftIM3aBYOHNueBfvuU0tMM+hZQEqZLRpDR0I19wlv5A==
X-Received: by 2002:a17:90b:907:b0:1f7:6b77:dcbc with SMTP id bo7-20020a17090b090700b001f76b77dcbcmr3835112pjb.244.1660006127840;
        Mon, 08 Aug 2022 17:48:47 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id i22-20020a17090a059600b001f516895294sm8651021pji.40.2022.08.08.17.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 17:48:47 -0700 (PDT)
Date:   Mon, 8 Aug 2022 17:48:45 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 041/102] KVM: VMX: Introduce test mode related to EPT
 violation VE
Message-ID: <20220809004845.GC504743@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <cadf3221e3f7b911c810f15cfe300dd5337a966d.1656366338.git.isaku.yamahata@intel.com>
 <52915310c9118a124da2380daf3d753a818de05e.camel@intel.com>
 <20220719144936.GX1379820@ls.amr.corp.intel.com>
 <9945dbf586d8738b7cf0af53bfb760da9eb9e882.camel@intel.com>
 <20220727233955.GC3669189@ls.amr.corp.intel.com>
 <af9e3b06ba9e16df4bfd768dfdd78f2e0277cbe5.camel@intel.com>
 <YuLtj4/pgUZBc6f9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YuLtj4/pgUZBc6f9@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 08:11:59PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Jul 28, 2022, Kai Huang wrote:
> > On Wed, 2022-07-27 at 16:39 -0700, Isaku Yamahata wrote:
> > > On Wed, Jul 20, 2022 at 05:13:08PM +1200,
> > > Kai Huang <kai.huang@intel.com> wrote:
> > > 
> > > > On Tue, 2022-07-19 at 07:49 -0700, Isaku Yamahata wrote:
> > > > > On Fri, Jul 08, 2022 at 02:23:43PM +1200,
> > > > > Kai Huang <kai.huang@intel.com> wrote:
> > > > > 
> > > > > > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > > > 
> > > > > > > To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM programs
> > > > > > > to inject #VE conditionally and set #VE suppress bit in EPT entry.  For VMX
> > > > > > > case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
> > > > > > > defensive (test that VMX case isn't broken), introduce option
> > > > > > > ept_violation_ve_test and when it's set, set error.
> > > > > > 
> > > > > > I don't see why we need this patch.  It may be helpful during your test, but why
> > > > > > do we need this patch for formal submission?
> > > > > > 
> > > > > > And for a normal guest, what prevents one vcpu from sending #VE IPI to another
> > > > > > vcpu?
> > > > > 
> > > > > Paolo suggested it as follows.  Maybe it should be kernel config.
> > > > > (I forgot to add suggested-by. I'll add it)
> > > > > 
> > > > > https://lore.kernel.org/lkml/84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.com/
> > > > > 
> > > > > > 
> > > > 
> > > > OK.  But can we assume a normal guest won't sending #VE IPI?
> > > 
> > > Theoretically nothing prevents that.  I wouldn't way "normal".
> > > Anyway this is off by default.
> > 
> > I don't think whether it is on or off by default matters.
> 
> It matters in the sense that the module param is intended purely for testing, i.e.
> there's zero reason to ever enable it in production.  That changes what is and
> wasn't isn't a reasonable response to an unexpected #VE.
> 
> > If it can happen legitimately in the guest, it doesn't look right to print
> > out something like below:
> > 
> > 	pr_err("VMEXIT due to unexpected #VE.\n");
> 
> Agreed.  In this particular case I think the right approach is to treat an
> unexpected #VE as a fatal KVM bug.  Yes, disabling EPT violation #VEs would likely
> allow the guest to live, but as above the module param should never be enabled in
> production.  And if we get a #VE with the module param disabled, then KVM is truly
> in the weeds and killing the VM is the safe option.
> 
> E.g. something like

Thanks, I finally ended up with the following.

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index ac290a44a693..9277676057a7 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -140,6 +140,11 @@ static inline bool is_nm_fault(u32 intr_info)
 	return is_exception_n(intr_info, NM_VECTOR);
 }
 
+static inline bool is_ve_fault(u32 intr_info)
+{
+	return is_exception_n(intr_info, VE_VECTOR);
+}
+
 /* Undocumented: icebp/int1 */
 static inline bool is_icebp(u32 intr_info)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 881db80ceee9..c3e4c0d17b63 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5047,6 +5047,12 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
 
+	/*
+	 * #VE isn't supposed to happen.  Although vcpu can send
+	 */
+	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
+		return -EIO;
+
 	error_code = 0;
 	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
@@ -5167,14 +5173,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		if (handle_guest_split_lock(kvm_rip_read(vcpu)))
 			return 1;
 		fallthrough;
-	case VE_VECTOR:
 	default:
-		if (ept_violation_ve_test && ex_no == VE_VECTOR) {
-			pr_err("VMEXIT due to unexpected #VE.\n");
-			secondary_exec_controls_clearbit(
-				vmx, SECONDARY_EXEC_EPT_VIOLATION_VE);
-			return 1;
-		}
 		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
 		kvm_run->ex.exception = ex_no;
 		kvm_run->ex.error_code = error_code;



-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
