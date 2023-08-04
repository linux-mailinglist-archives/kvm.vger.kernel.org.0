Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31B977082D
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 20:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjHDSvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 14:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjHDSvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 14:51:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07678BA
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 11:51:03 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5847479b559so27229457b3.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 11:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691175062; x=1691779862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3eYV/qmJG0sbl9kIxGw8mmbJssqpCy9LZDQ3FKzw738=;
        b=4kMAPIpux47Jcny+xxQrRGxkMWsor4im2oxpFpZ5h9Q0f27sBmQtM1qjf38AFRC1Sf
         EdPHWn+NzrAuOj7Ter5/rIoFXRaPf0F7VEwAV0nH/wCfrIt/mZ4LwAvBABxinBeEVM3r
         MVPNzIdUxdOu8KypAFX88utne4PE1XeBvApfxLsut9cFST/a/oUQKDP23JlAj/CHuSId
         2FPfYj5MIB/gbA3udHzvID3Z4vGs04Qn2FwB7zBlix4kNtHTDQ6MQc4Akw8RphZtj6E0
         0zvkV3BgvjvpeJbW2SKST9RYJLMxB272WegYWamoqfn2fmEQrCrAEMJoM+A288JVklHr
         Pb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691175062; x=1691779862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3eYV/qmJG0sbl9kIxGw8mmbJssqpCy9LZDQ3FKzw738=;
        b=BJGUYv7s42tBojMH/o7iANT76bRinbyoaO2+4fZs5SWrI7YrTt+5r8+nAP7o7GSzb1
         xDZUKMMvqFAJFF+FSciHK7/uxyZgEaqYsPSkwWq8Clk6CT1vYMiQRQXLfy8cQB5shLZ/
         INse1XDtfcov+pwaE5d4/T+skAdTGs3lNLBPN2s7l4QMjkKfRtzTGwrEQG1gHEBBOvJU
         Ck05WFer0G3tkJPvBmS4d/ZXhQ4kjryGYNTi2HhqgXbTJlI+dFyr7tQW3KAFk5TPYD6N
         TPwNjfeTmk28QoMBc9g2BtflLTbQM57FNzWWqa2bmPEhmeox1wDg90tJngR0tZEwuN58
         YUfg==
X-Gm-Message-State: AOJu0YytixPG7Q5eSoCaGZa4Qh29qOpqpa2Fwg91FqS/UHXj+Xf2F8hi
        pfPjqFsdMNg49FkQWiYN4ONfh8mfRSY=
X-Google-Smtp-Source: AGHT+IG2ogQ4UZ2l1pR1BDYTAuM4fhmO/gs+XQevZwvMssrlEVB3GWqq/Tn+v9B0sfGxv8QxcwFGu+NonWY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a4a9:0:b0:d31:b7c5:5170 with SMTP id
 g38-20020a25a4a9000000b00d31b7c55170mr10928ybi.12.1691175062337; Fri, 04 Aug
 2023 11:51:02 -0700 (PDT)
Date:   Fri, 4 Aug 2023 11:51:00 -0700
In-Reply-To: <ZMyR5Ztfjd9EMgIR@chao-email>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com> <ZMuDyzxqtIpeoy34@chao-email>
 <83d767df-c9ef-1bee-40c0-2360598aafa8@intel.com> <ZMyR5Ztfjd9EMgIR@chao-email>
Message-ID: <ZM1IlPrWz/R6D0O5@google.com>
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as to-be-saved
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Weijiang Yang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023, Chao Gao wrote:
> On Fri, Aug 04, 2023 at 11:13:36AM +0800, Yang, Weijiang wrote:
> >> > @@ -7214,6 +7217,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
> >> > 		if (!kvm_caps.supported_xss)
> >> > 			return;
> >> > 		break;
> >> > +	case MSR_IA32_U_CET:
> >> > +	case MSR_IA32_S_CET:
> >> > +	case MSR_KVM_GUEST_SSP:
> >> > +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> >> > +		if (!kvm_is_cet_supported())
> >> shall we consider the case where IBT is supported while SS isn't
> >> (e.g., in L1 guest)?
> >Yes, but userspace should be able to access SHSTK MSRs even only IBT is exposed to guest so
> >far as KVM can support SHSTK MSRs.
> 
> Why should userspace be allowed to access SHSTK MSRs in this case? L1 may not
> even enumerate SHSTK (qemu removes -shstk explicitly but keeps IBT), how KVM in
> L1 can allow its userspace to do that?

+1.  And specifically, this isn't about SHSTK being exposed to the guest, it's about
SHSTK being _supported by KVM_.  This is all about KVM telling userspace what MSRs
are valid and/or need to be saved+restored.  If KVM doesn't support a feature,
then the MSRs are invalid and there is no reason for userspace to save+restore
the MSRs on live migration.

> >> > +static inline bool kvm_is_cet_supported(void)
> >> > +{
> >> > +	return (kvm_caps.supported_xss & CET_XSTATE_MASK) == CET_XSTATE_MASK;
> >> why not just check if SHSTK or IBT is supported explicitly, i.e.,
> >> 
> >> 	return kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> >> 	       kvm_cpu_cap_has(X86_FEATURE_IBT);
> >> 
> >> this is straightforward. And strictly speaking, the support of a feature and
> >> the support of managing a feature's state via XSAVE(S) are two different things.x
> >I think using exiting check implies two things:
> >1. Platform/KVM can support CET features.
> >2. CET user mode MSRs are backed by host thus are guaranteed to be valid.
> >i.e., the purpose is to check guest CET dependencies instead of features' availability.
> 
> When KVM claims a feature is supported, it should ensure all its dependencies are
> met. that's, KVM's support of a feature also imples all dependencies are met.
> Function-wise, the two approaches have no difference. I just think checking
> KVM's support of SHSTK/IBT is more clear because the function name is
> kvm_is_cet_supported() rather than e.g., kvm_is_cet_state_managed_by_xsave().

+1, one of the big reasons kvm_cpu_cap_has() came about was being KVM had a giant
mess of one-off helpers.
