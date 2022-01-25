Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9A149AFAC
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 10:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453532AbiAYJP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 04:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455703AbiAYJGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:06:05 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEBCC06118F
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 00:50:48 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n32so9961747pfv.11
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 00:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WpVbBkGVuYAEOTubZPIVkilPzINucv+qEAj8FIbI7Eo=;
        b=SjqcvJfmWT0LsSwKjLl8/oGty8JaGm5hpMzu76P1PSvKSeC9LqJG+1wXghK/zmBdJX
         qhqwfdMVbkhpp3zA35nVfS4kBFUNsAeaF9OLoms0rPTVihXNZKAGiLblSjNID0iRGLOu
         ytMuyivulEfCH1MZ4wjmwzCAnOxox/TD94/7b6Sftqf3Bn48N9DlXmy3IWLsin5tQSIq
         VtJ7el8ULiGNPnyDl0IKBo6tYoNRIyhv1yw6ijkaoDgrZzI6OD8e+mn7jCGXQGHpa2p5
         XRkWVVakd/2VqTlXPbq1KDIhMSH/iap/cCibF76qi4XJQF8oRpUZFPm4udqyVfmob0tT
         33KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WpVbBkGVuYAEOTubZPIVkilPzINucv+qEAj8FIbI7Eo=;
        b=ZkYwur1dbTwx7eXCrX4Zk1grP9LIE1dpgiDhQ+EOSsKthXsGp+oxq48bUMT0c6wxd9
         E+Wbz4b+OQ9mZk7MOsT3E+A5UrC+0PTJ5QvzveA9SiYBbKBidRiG4IsFYefWWhv0cp2s
         YAlhfe85mALNcsneFkKAMVauEVQryV1B6X4sp4PvdyyPHEEhjKm7o+607VRTZVhhUAz5
         jsAR7vMwAoM2OZNKnI60ORROZGkqy8F4MxghcVpKEnjXGPQKSFmUxITXuAg0QjwM+5Vj
         TMzG19Opj8Gvp8MASP93mZ4ul+Z/tFK7B4lEXKxtL5oqmva0rMAQLNzltNCC44s3b4vU
         oWow==
X-Gm-Message-State: AOAM5322/qOjaJuMv9Ci0eWUDBNyvDtDogCWJulnQ6kOtpn18PQ9fdRA
        6982KRoA+6fcV+uHYEzv45mXdmXgKtROqbSXvUGTxQ==
X-Google-Smtp-Source: ABdhPJwqX8GsZEMUBsU+KrzF/fAqCLjp+zS06T9nv57NrxBtnCsMNA5eiRqCSmPTIbg7/wLyDlXtIiURagwkkqHNiS8=
X-Received: by 2002:a63:e805:: with SMTP id s5mr14747932pgh.369.1643100647835;
 Tue, 25 Jan 2022 00:50:47 -0800 (PST)
MIME-Version: 1.0
References: <20220123195337.509882-1-ayushranjan@google.com>
 <45a6395e-63f3-12b2-e6d1-52ccf00272e7@redhat.com> <Ye7cNMZku7jlRHa+@google.com>
In-Reply-To: <Ye7cNMZku7jlRHa+@google.com>
From:   Ayush Ranjan <ayushranjan@google.com>
Date:   Tue, 25 Jan 2022 00:50:12 -0800
Message-ID: <CALqkrRWD53MsHUYTDQ9+BiSD27uYUGNtU6pPeD3yiUwtJy2_jA@mail.gmail.com>
Subject: Re: [PATCH] gvisor: add some missing definitions to vmx.h
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Andrei Vagin <avagin@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Abandoning this patch in favor of the more complete series of work quoted above.

On Mon, Jan 24, 2022 at 9:04 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jan 24, 2022, Paolo Bonzini wrote:
> > On 1/23/22 20:53, Ayush Ranjan wrote:
> > > From: Michael Davidson <md@google.com>
> > >
> > > gvisor needs definitions for some additional secondary exec controls.
> > >
> > > Tested: builds
> > > Signed-off-by: Ayush Ranjan <ayushranjan@google.com>
> > > Signed-off-by: Michael Davidson <md@google.com>
> >
> > Incorrect order of the Signed-off-by header (author goes first, submitter
> > goes last).
> >
> > > ---
> > >   arch/x86/include/asm/vmx.h | 1 +
> > >   1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > > index c77ad687cdf7..df40dc568eb9 100644
> > > --- a/arch/x86/include/asm/vmx.h
> > > +++ b/arch/x86/include/asm/vmx.h
> > > @@ -67,6 +67,7 @@
> > >   #define SECONDARY_EXEC_ENCLS_EXITING              VMCS_CONTROL_BIT(ENCLS_EXITING)
> > >   #define SECONDARY_EXEC_RDSEED_EXITING             VMCS_CONTROL_BIT(RDSEED_EXITING)
> > >   #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
> > > +#define SECONDARY_EXEC_EPT_VE                      VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
> > >   #define SECONDARY_EXEC_PT_CONCEAL_VMX             VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
> > >   #define SECONDARY_EXEC_XSAVES                     VMCS_CONTROL_BIT(XSAVES)
> > >   #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC        VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
> >
> > I'm not sure why gvisor would care about an internal Linux header. gvisor
> > should only use arch/x86/include/uapi headers.
>
> It's Google-internal kernel crud, this patch should not be merged.  Though with a
> bit of patience, an equivalent patch will come with TDX support.  If we do merge
> something before TDX, I'd strongly prefer to take that "complete" version with a
> rewritten changelog.
>
> [*] https://lore.kernel.org/all/e519d6ae1e75a4bea494bb3940e1272e935ead18.1625186503.git.isaku.yamahata@intel.com
