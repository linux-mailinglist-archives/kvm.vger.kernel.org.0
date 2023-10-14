Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769F27C91B8
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 02:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjJNAMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 20:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjJNAMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 20:12:30 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD58BC0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 17:12:28 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a81a80097fso20790697b3.3
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 17:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697242348; x=1697847148; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vNBT/XxJh51aLo8zCinPuHFiBU/MXizwbuFmtSl9v9s=;
        b=PS684/UgZGtmf4lO3PdoxGUkXnB+0fpkAQw2dmFORGuGwbsjEyAERfv5NhlHaxi0H3
         Iag5vZa8zSgDA7ZcyhFnjMNamAHgXl07MksV+5UxQR0CafWh1aWXkovTknE1rega7cg1
         96uUcUpiOyf1W3iVCyOzBbaDwarmLOLZZtWcovxQj9ii/k+HI9Rrz0dc71W5mM0AY+c1
         kBeBugnYOOZcthL/RUpnSGxhUz7ZvUBW9ySdg5pVc5EaEPHcnQrj+5sOGONEGqbCT7ie
         88xUjj393MyYLsVHdMLscK9tXm/dzYqQEsbjWWF9am5CKh9oo95W8UDq9A2m+dPBSwML
         7oCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697242348; x=1697847148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNBT/XxJh51aLo8zCinPuHFiBU/MXizwbuFmtSl9v9s=;
        b=gjNrmkfQZfliSS79zHuea6rR0/pkEjIWYXO+n/k/F5RGPwDbWDVGetgLSsLteqJkUv
         e+6BpHNHMDVcvrKWz36rq38oxdNTtwcgnH785jmQ2QYPnHGLudz+Hoc6ZlXmZX9Gz92w
         BM++9Fa66oQzcf0euxGfkw44zw/peMWPG347nLwy3KwMCUVgFKameke5SlgKGf2NQkg+
         Zdjr3ik4WkRGdMrRLwBXatzeDOn8eZ3oSsWLH5lhTf9RsXEn/M8UMjAXIwI89DblINtp
         g9TtcLZph5MW4FXmKafmAUg4P7stT7fPpuyD0nH7rKKuyj5vHNAjESiX1jWS34d7W4Uv
         6O1Q==
X-Gm-Message-State: AOJu0YzkZfleMSb7+YutjfQyttIBfHQKyctFVMC7+oIe4qJiMlTqC+5r
        NdWZ/NGrZi8Zau1B5DnttXK/3D9jNxc=
X-Google-Smtp-Source: AGHT+IFMhtYqzA7z1kLmqh2MvMe9xABe7yML4yE5nu4ExVyCqhTvqUmCdtBEGpoJznG90pa3WgK6VSCz49o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce07:0:b0:d9a:ca58:b32c with SMTP id
 x7-20020a25ce07000000b00d9aca58b32cmr137296ybe.1.1697242347981; Fri, 13 Oct
 2023 17:12:27 -0700 (PDT)
Date:   Fri, 13 Oct 2023 17:12:26 -0700
In-Reply-To: <7fba6d8fc3de0bcb86bf629a4f5b0217552fe999.camel@infradead.org>
Mime-Version: 1.0
References: <b46ee4de968733a69117458e9f8f9d2a6682376f.camel@infradead.org>
 <ZSXdYcMUds-DrHAd@google.com> <7fba6d8fc3de0bcb86bf629a4f5b0217552fe999.camel@infradead.org>
Message-ID: <ZSnc6lfAlNCMfTxS@google.com>
Subject: Re: [RFC] KVM: x86: Don't wipe TDP MMU when guest sets %cr4
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, Bartosz Szczepanek <bsz@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
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

On Wed, Oct 11, 2023, David Woodhouse wrote:
> On Tue, 2023-10-10 at 16:25 -0700, Sean Christopherson wrote:
> > On Tue, Oct 10, 2023, David Woodhouse wrote:
> But I'm confused here. Even if I don't go as far as actually making
> CR4.SMEP a guest-owned bit, and KVM still ends up handling it in
> kvm_post_load_cr4()... why does KVM need to completely unload and
> reinit the MMU? Would it not be sufficient just to refresh the role
> bits, much like __kvm_mmu_refresh_passthrough_bits() does for CR0.WP?

Maybe?  It largely hasn't happened simply because no one (yet) cares enough about
the performance of other bits to force the issue.
 
> (And what about flushing the hardware TLB, as Jim mentioned. I guess if
> it's guest-owned we trust the CPU to do that, and if it's trapped then
> KVM is required to do so)?

TBH, I forgot that clearing SMEP architecturally requires a TLB flush for the current
PCID on Intel.  I *think* it's actually fine so long as TDP is enabled.  Ah, yes,
it's fine.  Well, either that or kvm_invalidate_pcid() is buggy :-)

Relying on the CPU to flush the hardware TLBs is definitely ok, I was just trying
to think if there were any KVM artifacts that would need to be flushed/invalidated.
I can't think of any, e.g. KVM already disable GVA-based MMIO caching when TDP is
enabled, L1 is responsible for its virtual TLB if L1 is shadowing legacy paging for
L2, and if L1 is using EPT, i.e. KVM is shadowing L1 EPT and thus has a virtual TLB
for L2, then the PCID is irrelevant (doesn't affect EPT translations).
