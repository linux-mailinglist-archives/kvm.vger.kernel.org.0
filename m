Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A7D709B48
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 17:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjESPZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 11:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjESPZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 11:25:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A5513E
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 08:25:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba83fed50a6so7903099276.0
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 08:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684509944; x=1687101944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dbzcRfBB1+pEw+dXK/ywmbABJqPTnI7COLwP4+XGTiE=;
        b=M3gF+aFF+EuvIl3aiW4+m2GPqPGE/GKqEaqZyg7fetawJ1hsrC0xXhqTUTLId3n38j
         tV3MHoO6dEiDtpIcBg0Wes3VfAA6gyS0Ga/E11OcFfuqlIYVp1sr6JTuDc9vYOWQTlkG
         W0OtAlxTZk9pNDkf7sFhkyoq7EuT/wQtzIjrQoSiaO5UfKXQjqfHy2O0Zx8NfzDTqC5D
         uKcdHCtVZXrWBhBNvJBpZqG5c1TO+tBaNG7Zc9fo6yqOD36iFlWhPx6kFuTLJ6anm1Gw
         4QvXmzXmhTr4wxsSVdeTVt5xyWWzXkcpgC0lHWZ2WB6yk/l6xeTrSqE0dKwrcEHpY1z9
         2Sdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684509944; x=1687101944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dbzcRfBB1+pEw+dXK/ywmbABJqPTnI7COLwP4+XGTiE=;
        b=WfAUbjbvDc/dhrEX+28S7VXH4uTUh+wWhbicrNy/CZQc7SdqneV9SzoW/gI0q31qUq
         V7FCo31L5Hy5iRZ8AZh+ipYSIVg/Yw1HLeVKb01bfQyiL7AOT6gxBLWczEKWt6906liO
         dEpClRUlnc8ZWxI6U70pibq/mwKHx9fHJKgPtErEC174VA12mtInIWo3wowQzq/OL/Wh
         95cu3VAE6Wa/d9p2gsAXPTYrz+ZySK18VysCBtVTwYpLNV7wbv8sNgFxd8TVZm3Fh/c7
         SEiqZ33LXkgFsCZ3uQSM13gtmn82EuPKRyUaF96iNh2EWSQ7dmZ06sApimA5OxniqGfS
         S21g==
X-Gm-Message-State: AC+VfDwDdf7y5no1GQrB2A8nZIYr+ITceGXDsI2fwObQPGmYgq9KYyyi
        d9OIrQyglqoaV/Xo4Cq2ATcz8CPBjeg=
X-Google-Smtp-Source: ACHHUZ4sYH32KFSFG/TNGCwZDQnCcJdqVO78Ci8X3cPbl1fYiWlg5mUkIpbwy+R3E2qp/NvSRWE0KPQBolE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:689:0:b0:ba8:3401:a466 with SMTP id
 131-20020a250689000000b00ba83401a466mr890153ybg.6.1684509944314; Fri, 19 May
 2023 08:25:44 -0700 (PDT)
Date:   Fri, 19 May 2023 08:25:42 -0700
In-Reply-To: <ZGc1/lwk5BAdRyOi@chao-email>
Mime-Version: 1.0
References: <20230506030435.80262-1-chao.gao@intel.com> <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com> <ZGc1/lwk5BAdRyOi@chao-email>
Message-ID: <ZGeU9sYTPxqNGSqI@google.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     pawan.kumar.gupta@linux.intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023, Chao Gao wrote:
> +Pawan, could you share your thoughts on questions about FB_CLEAR?
> 
> On Thu, May 18, 2023 at 10:33:15AM -0700, Sean Christopherson wrote:
> >I do like snapshotting and then updating the value, even though there's likely no
> >meaningful performance benefit, as that would provide a place to document that
> >the "supported" value is dynamic.  Though the fact that it's dynamic is arguably a bug
> >in its own right, e.g. if userspace isn't careful, a VM can have vCPUs with different
> >values for ARCH_CAPABILITIES.  But fixing that is probably a fool's errand.  So
> 
> I am not sure if fixing it is fool. There would be some other problem:

Heh, "fool's errand" is an idiom that means doing something has almost no chance
of succeeding, not that doing something is foolish.  I 100% agree that there's
value in presenting a consistent model to the guest, but there are conflicting
requirements in play.  To present a consistent model, KVM essentially needs to
disallow changing the module param after VMs/vCPUs have been created, but that
would prevent userspace from toggling the param while VMs are running, e.g. in
response to a new vulnerability.

The only feasible idea I can think of is to disallow *disabling* the mitigation
while VMs/vCPUs are active.  But then that prevents turning the L1D flush mitigation
back off if some other mitigation is deployed, e.g. via livepatch, policy update,
etc.

That's why I said trying to fix the knob is probably a fool's errand.  AFAICT,
there's no straightforward solution that makes everybody happy.  :-/
