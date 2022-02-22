Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CEC4BEF88
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 03:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbiBVCgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 21:36:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbiBVCgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 21:36:06 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581D825C5F;
        Mon, 21 Feb 2022 18:35:42 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id w7so18335415ioj.5;
        Mon, 21 Feb 2022 18:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwX/iVI1alQtsPS+zY1FE7ZiDOoWe3bToC+jQ7M1MxQ=;
        b=CPOa7+w+iq9ox2HbHVDsRwFSyoshcqyaH5jQI5vWPCHe1uBnZoUQQlDcPWsBUbfRxM
         jC5DvljspA/9D/JDUEGklidGFwrD4YUj7xYJHRXXFq4gH9+ARFOtzhoJNxpvW/riNeqa
         yuHPMbbwrV9yzSJIYuN/QqSR0D7P35zrFx8f+UPswi6gGsvPLzBSBEAbccD8dY7dR4ls
         YbhF2aUxjczw9LI3sZf2fzJqYYscb3Y7BU8QvdUQjnxTeutKqGAFVeVNwRTN6UL7HIiF
         yoy7akJFThYqVAMttoCoMDRv/KdPlxamta3/eG+pehY/AEL/54WtL/NiITTYKce7dEkH
         HNgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwX/iVI1alQtsPS+zY1FE7ZiDOoWe3bToC+jQ7M1MxQ=;
        b=8MoNWus/03xU6jc0FlxmvGRNk9Y/AqVEVs6DYMfC4JC9WA2wALMgCQy+Gu96en6cdh
         ZojU7zsK3UwWBahiu7Se1B2SWLIF8eO3XIZRxHhi/BfSR+xrKCr3aH10OwGyOGtnEsYz
         9u9/KiRMX4rYVuXxLoPmYyxK8Xw4MncTzB+/9tuKQ8l3N13kpKIBQJRdH06O/yVKGHvk
         esDC4RF3YE7oYF6Eybbrp3mYaAwE4DKGyQuuDFKJtQntnmI6EC8pCJZZy1sEujIG/n7Y
         2A1MjWfZ6yGsgiQ1BCuab/jYD19fBDbk5bP8hwMk41UPmqzgOOK0da61Ar2hYLkdLFGG
         abRg==
X-Gm-Message-State: AOAM533Ze0+tGrRG/opPrM/vRXuc+kXeq5X8WiNSJiqoai64z0+PyQwX
        udfL2xEIOLe43mSbHeYnvB6Tvts7shC06rUXEZA=
X-Google-Smtp-Source: ABdhPJy7aF+ul6GybuD5Sxve+blieBuejk1M8G1JVG62GRLQ/QPZ6FJ+AsE1jXjBYalHL4JFo86QenNCAc5+BZcw19Q=
X-Received: by 2002:a02:b048:0:b0:311:85be:a797 with SMTP id
 q8-20020a02b048000000b0031185bea797mr17100406jah.284.1645497341759; Mon, 21
 Feb 2022 18:35:41 -0800 (PST)
MIME-Version: 1.0
References: <20220218110547.11249-1-flyingpeng@tencent.com> <Yg/DmdjSqNLwWo2d@google.com>
In-Reply-To: <Yg/DmdjSqNLwWo2d@google.com>
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Tue, 22 Feb 2022 10:34:21 +0800
Message-ID: <CAPm50aL5uz3UEz0chiutw3PaPXZgKuaXK6FmXDHZ6Mg2W-TE9g@mail.gmail.com>
Subject: Re: [PATCH] kvm: correct comment description issue
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sat, Feb 19, 2022 at 12:04 AM Sean Christopherson <seanjc@google.com> wrote:
>
> "KVM: VMX:" for the scope.  A more specific shortlog would also be helfpul, stating
> that a comment is being modified doesn't provide any info about what comment.
>
> On Fri, Feb 18, 2022, Peng Hao wrote:
> > loaded_vmcs does not have this field 'vcpu', modify this comment.
>
> It would be helpful to state that loaded_vmcs has 'cpu', not 'vcpu'.  It's hard to
> identify what's being changed.
>
>
> Something like this?
>
>   KVM: VMX: Fix typos above smp_wmb() comment in __loaded_vmcs_clear()
>
>   Fix a comment documenting the memory barrier related to clearing a
>   loaded_vmcs; loaded_vmcs tracks the host CPU the VMCS is loaded on via
>   the field 'cpu', it doesn't have a 'vcpu' field.
>
> With a tweaked shortlog/changelog (doesn't have to be exactly the above),
>
Thanks for the suggestions for these patches, I will send again.

> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> > Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 7dce746c175f..0ffcfe54eea5 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -644,10 +644,10 @@ static void __loaded_vmcs_clear(void *arg)
> >
> >       /*
> >        * Ensure all writes to loaded_vmcs, including deleting it from its
> > -      * current percpu list, complete before setting loaded_vmcs->vcpu to
> > -      * -1, otherwise a different cpu can see vcpu == -1 first and add
> > -      * loaded_vmcs to its percpu list before it's deleted from this cpu's
> > -      * list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> > +      * current percpu list, complete before setting loaded_vmcs->cpu to
> > +      * -1, otherwise a different cpu can see loaded_vmcs->cpu == -1 first
> > +      * and add loaded_vmcs to its percpu list before it's deleted from this
> > +      * cpu's list. Pairs with the smp_rmb() in vmx_vcpu_load_vmcs().
> >        */
> >       smp_wmb();
> >
> > --
> > 2.27.0
> >
