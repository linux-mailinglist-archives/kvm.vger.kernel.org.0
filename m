Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB8470127A
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240758AbjELXae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240422AbjELXab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:30:31 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDA3211E
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:30:26 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51b8837479fso9885676a12.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683934226; x=1686526226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c/QFGmFTNFWTz/qL0ytwDs6C7o76RN6Kb8g1Op6SXqE=;
        b=RAX2/ENILv9p9Rqr0mBXOdbAaA6rFYqN3VcLYSzz4ai1XaZdS4XCB2rUavinsOjgna
         8zQE0X8GDlMXyD3AQA7jdkhawiti9RiWaBLfZYxb3kY/33dwGN1VJp0uUZnaT1klqqpn
         SmyHP4CB//45m+Yvt93TOjXUvCaUH00QfVfFmcyBXwYrgTUsdLKo9h2k8aDifl2eiA4t
         gV2jMx9z+0Y0YiGUV444TUgvNpYxIcRVyJDierddl7bQe7oFgo34XVVnux5QAwfw+DkZ
         8fR3IqeZ37pMnB0sWM6bhK5nN2+yB6vRbncI/vC0/daBn95hSe12sGv9ph3SEXCVvWeO
         fLQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683934226; x=1686526226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c/QFGmFTNFWTz/qL0ytwDs6C7o76RN6Kb8g1Op6SXqE=;
        b=jHhQKh6FchqYq5N88oz3cjNTF8Nz/2z0/pXid/4BzwaI76tiCaNPWw3tB8YQkGehdg
         Xh+nzYOO2H4qWr+Ty1CGcuemCy2Ct5v9nNypYPdxawRunpsR+5H4lfk/K0kZDUdWA7w+
         CTwKqBreiIv0a4hNvdbIeq+9UhzksPnpCYouJY6frFtfifil8fdeBbtyPY6ZWnl3ErBm
         YmqfPoOPh8DWyyjf7CqT6gI626HbvLteMpFMT8DA97DTAS8G4rm7Xp9x/o2NMLE3nQ+f
         sPknskzye5zcm3Qpg1ogGT+qGYGb3EpQxCx8dN+YIoTBhswdaXQt34Q72dHXlhsMse4J
         S4oQ==
X-Gm-Message-State: AC+VfDxbZAimdFamLTwkRbZRuxXox8byGL5rNo6B6It0k10+KjGfPCih
        zTK50QFRohwwUeV342nYH+5nwTL1WXw=
X-Google-Smtp-Source: ACHHUZ56CHgNKxromyGnk2MJ4PmHsYY+UgcnX3d8oUez/B0nBcLFZiz4BJJ7thMCKQLZxtMzaVMQ3TQM8BM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:151:0:b0:52c:6149:f6be with SMTP id
 78-20020a630151000000b0052c6149f6bemr7423404pgb.4.1683934226402; Fri, 12 May
 2023 16:30:26 -0700 (PDT)
Date:   Fri, 12 May 2023 16:30:25 -0700
In-Reply-To: <ZF7KbsCXBQHnOv7g@google.com>
Mime-Version: 1.0
References: <20230511235917.639770-1-seanjc@google.com> <20230511235917.639770-5-seanjc@google.com>
 <ZF7KbsCXBQHnOv7g@google.com>
Message-ID: <ZF7MES4qEKd8T6OW@google.com>
Subject: Re: [PATCH 4/9] KVM: x86/mmu: Rename MMU_WARN_ON() to KVM_MMU_WARN_ON()
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
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

On Fri, May 12, 2023, David Matlack wrote:
> On Thu, May 11, 2023 at 04:59:12PM -0700, Sean Christopherson wrote:
> > Rename MMU_WARN_ON() to make it super obvious that the assertions are
> > all about KVM's MMU, not the primary MMU.
> 
> I think adding KVM is a step in the right direction but I have 2
> remaining problems with KVM_MMU_WARN_ON():
> 
>  - Reminds me of VM_WARN_ON(), which toggles between WARN_ON() and
>    BUG_ON(), whereas KVM_MMU_WARN_ON() toggles between no-op and
>    WARN_ON().

No, VM_WARN_ON() bounces between WARN_ON() and nop, just like KVM_MMU_WARN_ON().
There's an extra bit of magic that adds a static assert that the code is valid
(which I can/should/will add), but the runtime behavior is a nop.

  #define VM_WARN_ON(cond) (void)WARN_ON(cond)
  #else
  #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)

/*
 * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
 * expression but avoids the generation of any code, even if that expression
 * has side-effects.
 */
#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))

>  - It's not obvious from the name that it's a no-op most of the time.
> 
> Naming is hard so I might just make things worse by trying but...
> 
> How about KVM_MMU_PROVE(condition). That directly pairs it with the new
> CONFIG_KVM_PROVE_MMU(), makes it sufficiently different from
> VM_WARN_ON() and WARN_ON() that readers will not make assumptions about
> what's happening under the hood. Also "PROVE" sounds like a high bar
> which conveys this might not always be enabled.

It inverts the checks though.  Contexting switching between "WARN_ON" and "ASSERT"
is hard enough, I don't want to add a third flavor.

> That also will allow us to convert this to a WARN_ON_ONCE() (my
> suggestion on the other patch) without having to make the name any
> longer.
