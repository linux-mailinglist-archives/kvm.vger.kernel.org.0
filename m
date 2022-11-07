Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB506620272
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 23:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiKGWmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 17:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiKGWmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 17:42:51 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B0C2AC5D
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 14:42:49 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-13b23e29e36so14370408fac.8
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 14:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vsChQ3Tg7BF0NokFjc4G7r9sJNrOBJh9/tEuPiQJZ4U=;
        b=OXhUPL/kJdt9DnBObe1Id8rcIBkiCprGnHElQF9Iy72vdVdarJzoUqRkqUVcPc7uag
         3KFtCnuZdO3NjW9xDDeXQzRQl6OLXUXK5LXiB6hiuFGItYJiR17DTewS2jdhjqnqD+g1
         8i7zh7bAUKWVq+/WpnzdNJSqMX94gYuoLAAXBGMCNFGmzw/RWpiD6eGSEQDDtr3pf+Vl
         VkWVvSvyNra/fAtqrtLDLtOm5du81bi0bVzLElJByceuBY6/aN3S5ipPTbnzdGxV5nWt
         ecIRbD2AlUVWIt51t/NEpt+Lw9Nap4WU64BAusqpScSDeYr6V+47+CEj/iA6AJlznbxc
         tedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vsChQ3Tg7BF0NokFjc4G7r9sJNrOBJh9/tEuPiQJZ4U=;
        b=Y1wfxil+QTvEuxAyM8J7HfKyulIa8FnoqfH/TZ0TId/kEMUIhycfYAAkZh3OLT8ULD
         XHkuFJ2h/hw9BABRcxosgQ7AMZQ2T57Wja1g+syHZo3zFlDEclJb5HqQ1s+pCcUWlwZS
         AKcnyVOk81NoPcDHBOiUiDTetAvPROG2F4k7Hkug113e12qtcXw1+jlAWRJjU2OXLpLw
         X7/PTO65vYeaJyT3o/dXPT8sY6uIFHBTa51THWij4b00J++Q8+VYiT3Pufz9lAL3HD4W
         8c6tcZQ5kLbeq3bSZ23915jbCtySDd/wnglwgaydJ8jGz3+uIywiWW/mm5dAR8WE+tax
         gjJQ==
X-Gm-Message-State: ACrzQf1Umx+dnu+9p7ZGHhsd5hO41+pMuBjyz8zyZKsEyPAfuAsfiZD1
        /CeysOWs4QOqbcT/kYEqAaQgO4osYqsC+JaGgGF1aw==
X-Google-Smtp-Source: AMsMyM4NZpvJWbLRxOFQy/+nu4rp8cnP13s67kptg+Q4wXsrGI82n8mTDZ2xnlRFJOFpPkW6r4TUq2IwT1YnDuw0EGo=
X-Received: by 2002:a05:6871:8a3:b0:13b:18ef:e8df with SMTP id
 r35-20020a05687108a300b0013b18efe8dfmr30681436oaq.181.1667860968566; Mon, 07
 Nov 2022 14:42:48 -0800 (PST)
MIME-Version: 1.0
References: <20221104213651.141057-1-kim.phillips@amd.com> <20221104213651.141057-4-kim.phillips@amd.com>
 <CALMp9eSpKGCYK_1r3o326ui5RVoH73_RR5-LR2Div9Jm5zvk6A@mail.gmail.com> <f25152d2-7045-94f4-d5dc-69b609c0be6a@amd.com>
In-Reply-To: <f25152d2-7045-94f4-d5dc-69b609c0be6a@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 7 Nov 2022 14:42:37 -0800
Message-ID: <CALMp9eQF7iPXCNkafmaGHY5Dzg+opt0xp+Y8ceML8RTxFyCo7A@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86/speculation: Support Automatic IBRS under virtualization
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 7, 2022 at 2:29 PM Kim Phillips <kim.phillips@amd.com> wrote:
>
> On 11/4/22 5:00 PM, Jim Mattson wrote:
> > On Fri, Nov 4, 2022 at 2:38 PM Kim Phillips <kim.phillips@amd.com> wrote:
> >>
> >> VM Guests may want to use Auto IBRS, so propagate the CPUID to them.
> >>
> >> Co-developed-by: Babu Moger <Babu.Moger@amd.com>
> >> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> >
> > The APM says that, under AutoIBRS, CPL0 processes "have IBRS
> > protection." I'm taking this to mean only that indirect branches in
> > CPL0 are not subject to steering from a less privileged predictor
> > mode. This would imply that indirect branches executed at CPL0 in L1
> > could potentially be subject to steering by code running at CPL0 in
> > L2, since L1 and L2 share hardware predictor modes.
>
> That's true for AMD processors that don't support Same Mode IBRS, also
> documented in the APM.
>
> Processors that support AutoIBRS also support Same Mode IBRS (see
> CPUID Fn8000_0008_EBX[IbrsSameMode] (bit 19)).
>
> > Fortunately, there is an IBPB when switching VMCBs in svm_vcpu_load().
> > But it might be worth noting that this is necessary for AutoIBRS to
> > work (unless it actually isn't).
>
> It is needed, but not for kernel/CPL0 code, rather to protect one
> guest's user-space code from another's.

The question is whether it's necessary when switching between L1 and
L2 on the same vCPU of the same VM.

On the Intel side, this was (erroneously) optimized away in commit
5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and
vmcs02").
