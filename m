Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931995465A0
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 13:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349292AbiFJLeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 07:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346659AbiFJLeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 07:34:15 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43516EB35
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 04:34:13 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m125-20020a1ca383000000b0039c63fe5f64so943397wme.0
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 04:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+rY4WAh4Z/g9RXMWfmzOnjp3/fpy58yyzKY2ezEUe3w=;
        b=yasOb4+fOBN2YPRJwEDj2ZaIucLc/JDD+7cGR9k6PM9bNfEB0cvmA4tAUtoFsDA8Zs
         DDWXbli5ew/mEHSoaWk/1xOaLVU+ov72PkdQ1AJedEzd7dP5pZAEbW6HY1D47pJbpypC
         lIvxWbC1Emfpf1qGogjgXCu9ZmbPSVpOCsnQxM2dUaSMEpy3BbVogWKTCJWryMgtgaFF
         9Dy+1Q9alroZnlrtcBvRjYQbiyONu/7RGZXaN9NmwqqklwfRT7LCls2ahhjG+aN3s2AC
         L+Al38pEQY5sIBvwW1KNpU3W48rykfFz6Iq1VfefpMJcXhxO6uxtFs7svFzZHz128lV7
         aJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+rY4WAh4Z/g9RXMWfmzOnjp3/fpy58yyzKY2ezEUe3w=;
        b=ZB1TVRog9/8ZwPTVExlcpnQ8rEqs7yyLtOE4nSRRrDwO4PQqFOKiZJoGk3lTmRRhTN
         kbCKD0hmy40Qv+nDdg+5DVXJAyBnrbZPwKqLz0KEqunSHodL99sJmghH9N+TKKdnVQL2
         Hp3/zBx7Sr+yAehloqf+BJyWvW/yyIim0FoFRwqyy8JdD4JeMKj04d5W6T3Wze6mc1U0
         rpFN1e+fxylM7CYVoEbAkiB+H8qX7Htu0GbNNqvkCnaTFQaF2/gOBYKWgzAPeTcFBANb
         pJrfQMEeYZdjUozKfe2NvLGfWdAMtyIsVghCRW0tyB4boL3p5fBXgdtz1XGSX+V8KMes
         vSZw==
X-Gm-Message-State: AOAM5326bF3HfV7MBEg+gpZeBWC9OZtPo76cXFYyNKfE1hFjaX838V5h
        cImnjc5NwiB0VuzlhxL8rqzxri7f3hs19dzyaK7ggwddng8EHg==
X-Google-Smtp-Source: ABdhPJzsylhjboW+YxML3OizLCPVAQ/+/Io022u1dtE5+iGWeWdxRjb7eJs0BUYmo+3ob/154dyzX8CeYr8R/rBhXxM=
X-Received: by 2002:a7b:c10d:0:b0:39c:4a17:1e90 with SMTP id
 w13-20020a7bc10d000000b0039c4a171e90mr8159903wmi.108.1654860852260; Fri, 10
 Jun 2022 04:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com> <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
 <CAAhSdy0_50KshS1rAcOjtFBUu=R7a0uXYa76vNibD_n7s=q6XA@mail.gmail.com>
 <CAAhSdy1N9vwX1aXkdVEvO=MLV7TEWKMB2jxpNNfzT2LUQ-Q01A@mail.gmail.com>
 <YqIKYOtQTvrGpmPV@google.com> <YqKRrK7SwO0lz/6e@google.com>
In-Reply-To: <YqKRrK7SwO0lz/6e@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 10 Jun 2022 17:03:57 +0530
Message-ID: <CAAhSdy1-2JAWk=2cj+=NuQxqE-T0NNe-o3kYT=114qiHCWq=Dg@mail.gmail.com>
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        KVM General <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 10, 2022 at 6:04 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jun 09, 2022, Sean Christopherson wrote:
> > On Thu, Jun 09, 2022, Anup Patel wrote:
> > > On Wed, Jun 8, 2022 at 9:26 PM Anup Patel <anup@brainfault.org> wrote:
> > > >
> > > > On Tue, Jun 7, 2022 at 8:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > > >
> > > > > Marc, Christian, Anup, can you please give this a go?
> > > >
> > > > Sure, I will try this series.
> > >
> > > I tried to apply this series on top of kvm/next and kvm/queue but
> > > I always get conflicts. It seems this series is dependent on other
> > > in-flight patches.
> >
> > Hrm, that's odd, it's based directly on kvm/queue, commit 55371f1d0c01 ("KVM: ...).
>
> Duh, Paolo updated kvm/queue.  Where's Captain Obvious when you need him...
>
> > > Is there a branch somewhere in a public repo ?
> >
> > https://github.com/sean-jc/linux/tree/x86/selftests_overhaul
>
> I pushed a new version that's based on the current kvm/queue, commit 5e9402ac128b.
> arm and x86 look good (though I've yet to test on AMD).
>

I have tested this for KVM RISC-V and it works fine.

Tested-by: Anup Patel <anup@brainfault.org>

Regards,
Anup
