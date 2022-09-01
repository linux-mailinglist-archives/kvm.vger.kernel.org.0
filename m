Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7BC5A9E00
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiIARaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiIARaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:30:06 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4761C93F;
        Thu,  1 Sep 2022 10:30:05 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id j1so13973767qvv.8;
        Thu, 01 Sep 2022 10:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=GkylslPFTMwq6t+BAI0pQVTra1XCe56WX0A+ZZ/Atbc=;
        b=LzdynfRMZ3UCQSxfNo+QaeNjQBRMXMKTv3w1Xpls6L96wEjSZDzINf6+1/nbK3TchF
         bved2M/tiQlbgAdftqMo2ldcW8F9HbAwjw3ukdU98JJ6sZuJj9z5+/SZr4dKpjdkZb+5
         BkXqIqAFezeONC1kxzGmWIXYzpPXqqA5TnlDAwktXXlQl6HN1fpKpBuF9vxKwRwLdVRo
         HdhNJ+e5zc1vdWbRayn2Pqxz7VHo1d7a4d0H9lDr3q7QXhpVN3iVdWD1L6+ceMDBCjqL
         /LNh0Q0BbHXMZbV6m81k80YhsKWo3kr+4ejzCqFn/5Osufgjmh9OG8zI1cruOxJ9GQnc
         TkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=GkylslPFTMwq6t+BAI0pQVTra1XCe56WX0A+ZZ/Atbc=;
        b=ivj4+9cDUVdVIeYe0fXbyM2+MKXhUO7pq7Ska58gbKWk5zjorGI5XOR+6fBdWz1BjZ
         y/XmmFylsHCSx7Q+zwG4/TMv2tAkCFj+82UZFpwMk/Drko2OpRBjo0HmgHfoifqkey5V
         bXE1x3QWPUTG7HXkZsCB8Koy4zcK2aXsYDpXYYdExBvV0lXbJFTWGoX0hxDfGfx8MEEs
         SCiNs4nkqTHbKkQCVXgJXwzXkxze2QvD4jlm49hRDmgdGJFrK8ScSxobalPpKytbIou8
         2ar/BErTVislX1bFJGFK0/dopR5xxhGSphUuh9lOegfKdif9Yybd7xRu2T3AjN0cZ5QD
         lgnw==
X-Gm-Message-State: ACgBeo3dVgpxtQimuiHOmdsrNkDn8PQVxnB6BzY9kYWSQ5K6W0Y5VmJt
        IGNJJzdqgY7Gj1VTCWZ8PJeVVfJr+usPq6zj1cm2Dc+V
X-Google-Smtp-Source: AA6agR7BRXQTg7UnbGniLx1eXXjWX4hwKgyIIHfJBm2RvJ/EqRdPvJZ3he6VGda0JXz3CGLXSJqv9tctSQ8dCYaILQI=
X-Received: by 2002:a0c:e30b:0:b0:498:f13a:8eb1 with SMTP id
 s11-20020a0ce30b000000b00498f13a8eb1mr25796051qvl.125.1662053404255; Thu, 01
 Sep 2022 10:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220817144045.3206-1-ubizjak@gmail.com> <YxDSTU+pWBdZgs/Q@google.com>
In-Reply-To: <YxDSTU+pWBdZgs/Q@google.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 1 Sep 2022 19:29:53 +0200
Message-ID: <CAFULd4aQvHczwv1rZz6QJ6wEfjd0ORB_3rQdmP-PtfasNxe3rw@mail.gmail.com>
Subject: Re: [PATCH] KVM/VMX: Do not declare vmread_error asmlinkage
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 1, 2022 at 5:40 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Aug 17, 2022, Uros Bizjak wrote:
> > There is no need to declare vmread_error asmlinkage, its arguments
> > can be passed via registers for both, 32-bit and 64-bit targets.
> > Function argument registers are considered call-clobbered registers,
> > they are saved in the trampoline just before the function call and
> > restored afterwards.
> >
> > Note that asmlinkage and __attribute__((regparm(0))) have no effect
> > on 64-bit targets. The trampoline is called from the assembler glue
> > code that implements its own stack-passing function calling convention,
> > so the attribute on the trampoline declaration does not change anything
> > for 64-bit as well as 32-bit targets. We can declare it asmlinkage for
> > documentation purposes.
>
> ...
>
> > diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> > index 5cfc49ddb1b4..550a89394d9f 100644
> > --- a/arch/x86/kvm/vmx/vmx_ops.h
> > +++ b/arch/x86/kvm/vmx/vmx_ops.h
> > @@ -10,9 +10,9 @@
> >  #include "vmcs.h"
> >  #include "../x86.h"
> >
> > -asmlinkage void vmread_error(unsigned long field, bool fault);
> > -__attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
> > -                                                      bool fault);
> > +void vmread_error(unsigned long field, bool fault);
> > +asmlinkage void vmread_error_trampoline(unsigned long field,
> > +                                     bool fault);
> >  void vmwrite_error(unsigned long field, unsigned long value);
> >  void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
> >  void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
>
> If it's ok with you, I'll split this into two patches.  One to drop asmlinkage
> from vmread_error(), and one to convert the open coded regparm to asmlinkage.

Sure, please go ahead.

Thanks,
Uros.
