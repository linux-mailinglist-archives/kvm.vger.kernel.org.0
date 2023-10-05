Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7DC7BA6BB
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjJEQlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjJEQj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:39:56 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B651536A6
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 09:23:02 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-4063bfc6c03so105895e9.0
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 09:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696522981; x=1697127781; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzyAiWhvPRkAaSX04taWxyRaF35/7oPd53VXghDgNwg=;
        b=GVagLX8V3wo4J8tN9/raqI5+A44kv2gtYr/noRXWFtzp0Juowt0R+n+xThn+7cu65h
         Cr/GYr1Xb8J60TX4ZLhtQmxaFOpZDkRAAShAV9L1SUxZTe8goRQy/YmjFBBJ9eXtDVoS
         OTWIFCTqE0odBSHEzQS4uG0RXNCducYzGqQRe78mcMhBVDNii/RdWa9StUH7f3prWfnA
         Flu2Hke6yWaYOPA7PMPt03G+KS4FHC9cnB351khpoybUe3HQKDlYkiTCRX078G3U8AQ5
         CmO+9Ojr5mVYlrXq5EsX3Ia6zTljK9kB679RokhD1DyYD9Va34Wd/exOZQjP3VIrpn0D
         IOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696522981; x=1697127781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzyAiWhvPRkAaSX04taWxyRaF35/7oPd53VXghDgNwg=;
        b=bx2HnPSNpMHC2ytO2TQci540Zqz1sgas05oED6rFYXrEX5M4Qn3+ldY1eWYtwCZfRa
         e9EMWIyXX95Ike4VLlQ0GSGq+ifa2NyXLCjcA//fcqTovRl892oY3AHveooGQ+8DOrNB
         b5bA+SjgTxVcbp2xUfIR85h/Ws7DE/5FZy9mBX6Dnj0M7xqJpEcqCkTthQRCpmcjGxcg
         SjJ3F0YPrP5wZNjzN3BUyycrtTpWPrHVrTS90aOPv5+MjrCd6BglpshHnSsp2IG0p68h
         nutysvi/0bBU5nhErlL5sWchrABJN+hN/OT4Zr77IxdKIWpFFyOp6N7lP7cT9QboTbbi
         qbDw==
X-Gm-Message-State: AOJu0YzoUAUokxso+MgBKUPku+8O1ga1eq2dfKzcI+8T6fZhVGF3aDj1
        obwJZzsmlqbzpi89isRK1muaBSAXPAF0WoF25/YpIA==
X-Google-Smtp-Source: AGHT+IFNO9qGrQUgXzJ/X1z/NsSmH5wKOMIFOjmbUOxeOunMIpw7ug3LlS+y1sx2UukRlZboK4+RxhX2g+VL0uIbgWg=
X-Received: by 2002:a05:600c:3414:b0:3f4:fb7:48d4 with SMTP id
 y20-20020a05600c341400b003f40fb748d4mr66710wmp.3.1696522981030; Thu, 05 Oct
 2023 09:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20231004002038.907778-1-jmattson@google.com> <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com> <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local>
In-Reply-To: <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Oct 2023 09:22:44 -0700
Message-ID: <CALMp9eT2qHSig-ptP461GbLSfg86aCRjoxzK9Q7dc6yXSpPn7A@mail.gmail.com>
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's FsGsKernelGsBaseNonSerializing
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 4, 2023 at 12:59=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Tue, Oct 03, 2023 at 07:44:51PM -0700, Jim Mattson wrote:
> > The business of declaring breaking changes to the architectural
> > specification in a CPUID bit has never made much sense to me.
>
> How else should they be expressed then?
>
> In some flaky PDF which changes URLs whenever the new corporate CMS gets
> installed?
>
> Or we should do f/m/s matching which doesn't make any sense for VMs?
>
> When you think about it, CPUID is the best thing we have.

Every time a new defeature bit is introduced, it breaks existing
hypervisors, because no one can predict ahead of time that these bits
have to be passed through.

I wonder if we could convince x86 CPU vendors to put all defeature
bits under a single leaf, so that we can just set the entire leaf to
all 1's in KVM_GET_SUPPORTED_CPUID.
