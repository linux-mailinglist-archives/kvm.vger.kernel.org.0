Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B466B64E5B4
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 02:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiLPBj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 20:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPBjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 20:39:55 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C894A599;
        Thu, 15 Dec 2022 17:39:54 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id l10so845849plb.8;
        Thu, 15 Dec 2022 17:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OyWCEG84EfTZ8sdkpfdaYdIxBgn/nHaAx/ubQJe/TZs=;
        b=OnFFO6Bs90VpSTxxt1Sb+4uqsVeG2hjJ/bdNr/StD1VZe9PdfQ+ISuW9L6QUwrhpsH
         9YyhDONBhZEEveXan80kEt65EOD7q53Q6aNnyM0JQoMNhTb+eKHWNlhb6Zr2j8Xf9Yhz
         F67CKDy/E/HYpsDmRxsVulsXnJr8TrRPhxRv8kvgN8nGNN+7vDTBTRW2n81GZmPfd2Kg
         B+OOJ1NQIb3jxkgJ51mPZAr8mvwL+aRSO1oXmtZHM2cU6xBfTgqikimtjpYAAEEPemy/
         xD2cq0egRpxpQfibhr1R5DpJtkq2dQkfYX+FzJl0ei4ztC5+k0Seab9g4v4VMzyjn3LB
         WMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyWCEG84EfTZ8sdkpfdaYdIxBgn/nHaAx/ubQJe/TZs=;
        b=Byp8poL4THJvRzbzCFVuNAcCs3i9wPS87Z/r68DrqiIIiyIU2T2GCOGOy31WYKM9mW
         naD4u3SGaXeHrFi+tV2iRSW6V07ve+sBoiRp07th+ZY+7WOg9tvLYkgBZCRNSiVB2tss
         sLGZOQKh5ovoAIsFGpbdFFLEQQDDLZy/jXkbB9G5IpQSyaQvAN9Nzco5Y7UqOwRc7C+q
         nWP2ksi5g4vi6YYfVS8PmbNx4Bpbn6ZZGl6l8rACrHmPf7zyTx1Jpocq1Y4aOKFs3QfB
         CQsN0rH7HC6IKLDHgNFs0vmJojOtQXtvoPwzpfEVjPkbGvtYTz6baQ0/D06nht7r4P1C
         LrIg==
X-Gm-Message-State: ANoB5pnJ9ag0sR8XuFzIG3TwDBSWV43VzG1Uky48Ak1l98HjYdeXtV2J
        W/+DV3WPHkzfJzBPLvvJav5l3CK9/ak=
X-Google-Smtp-Source: AA0mqf4vH1FvCCQEGUJZgcn36IbjKotJMv6DFw4VoUqh/BmWe7yIsKmWmto+Gk2nOLw+2gwIN9//AQ==
X-Received: by 2002:a17:902:c40f:b0:189:ea22:6d6a with SMTP id k15-20020a170902c40f00b00189ea226d6amr47863293plk.60.1671154794066;
        Thu, 15 Dec 2022 17:39:54 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id z4-20020a1709027e8400b0017d97d13b18sm293693pla.65.2022.12.15.17.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 17:39:53 -0800 (PST)
Date:   Thu, 15 Dec 2022 17:39:52 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 098/108] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Message-ID: <20221216013952.GC527635@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <1cacbda18e3c7dcccd92a7390b0ca7f4ba073f85.1667110240.git.isaku.yamahata@intel.com>
 <d163d23d64447bc576c9931f4d5e4da0cb87a081.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d163d23d64447bc576c9931f4d5e4da0cb87a081.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 11:22:02AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:23 -0700, isaku.yamahata@intel.com wrote:
> > +bool tdx_is_emulated_msr(u32 index, bool write)
> > +{
> > +	switch (index) {
> > +	case MSR_IA32_UCODE_REV:
> > +	case MSR_IA32_ARCH_CAPABILITIES:
> > +	case MSR_IA32_POWER_CTL:
> > +	case MSR_MTRRcap:
> > +	case 0x200 ... 0x26f:
> > +		/* IA32_MTRR_PHYS{BASE, MASK}, IA32_MTRR_FIX*_* */
> > +	case MSR_IA32_CR_PAT:
> > +	case MSR_MTRRdefType:
> > +	case MSR_IA32_TSC_DEADLINE:
> > +	case MSR_IA32_MISC_ENABLE:
> > +	case MSR_KVM_STEAL_TIME:
> > +	case MSR_KVM_POLL_CONTROL:
> 
> To me putting KVM para-virt MSRs and hardware MSRs together isn't good idea. 
> You can introduce separate helpers for them.

Makes sense. updated as follows.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ee8d395af849..b4132167e2bb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1606,6 +1606,17 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
        *error_code = 0;
 }
 
+static bool tdx_is_emulated_kvm_msr(u32 index, bool write)
+{
+       switch (index) {
+       case MSR_KVM_STEAL_TIME:
+       case MSR_KVM_POLL_CONTROL:
+               return true;
+       default:
+               return false;
+       }
+}
+
 bool tdx_is_emulated_msr(u32 index, bool write)
 {
        switch (index) {
@@ -1619,8 +1630,6 @@ bool tdx_is_emulated_msr(u32 index, bool write)
        case MSR_MTRRdefType:
        case MSR_IA32_TSC_DEADLINE:
        case MSR_IA32_MISC_ENABLE:
-       case MSR_KVM_STEAL_TIME:
-       case MSR_KVM_POLL_CONTROL:
        case MSR_PLATFORM_INFO:
        case MSR_MISC_FEATURES_ENABLES:
        case MSR_IA32_MCG_CAP:
@@ -1650,6 +1659,9 @@ bool tdx_is_emulated_msr(u32 index, bool write)
        case MSR_IA32_APICBASE:
        case MSR_EFER:
                return !write;
+       case 0x4b564d00 ... 0x4b564dff:
+               /* KVM custom MSRs */
+               return tdx_is_emulated_kvm_msr(index, write);
        default:
                return false;
        }
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
