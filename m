Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3FE4ACC39
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 23:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244867AbiBGWpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 17:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244883AbiBGWpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 17:45:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3198C043181
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 14:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644273936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q/wrQ+osy4G0NVymDBiDXHWgi4vpZ0kJJPM2q4QWu1k=;
        b=dFbk8ZW9LiUqHEQLDY4zsGuU0revPLXGgbv0jrb+5VQiCp3W2K1hOqKk8gYxx9AOgWHL+k
        ZPnR/RGtr8uf8vfCLaEXVUCYcpG+NhqruqJYc17zLx89Ut6I59wtodcPuJgNwFw0v6ee0C
        bgQPi5TdlMyY6m8drqmoFG5rf1FZY9w=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-9pn4VGw-PaO0BoqDU2QOxw-1; Mon, 07 Feb 2022 17:45:35 -0500
X-MC-Unique: 9pn4VGw-PaO0BoqDU2QOxw-1
Received: by mail-lj1-f199.google.com with SMTP id k22-20020a2e8896000000b0023f97d5d855so5113025lji.12
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 14:45:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q/wrQ+osy4G0NVymDBiDXHWgi4vpZ0kJJPM2q4QWu1k=;
        b=akP9vnzlBhe5IgAYjAHJxKsilaNejdHmnubJdQWJLTxJgdpfnrOfXftt6ev72HenmZ
         MClIiefj2N50J5dAcj4Katg1Tui9ODEsc1FimtizaooG4kA8tYX0rF4iI8rWrh6Xh8cQ
         Qu19txvvYQeLDyTz8wWhNlFqR3uZkc7+/SOuAN6TOp20pDow9s3v0j1L6fW1ngmKtlwG
         k0LVKscAhj6jTVBKnle87IlYL196q/S0kStw1UsZpL2EB1RoHyJaXH/x7xebVl1PmiB9
         acpiW4BxR6u3bkltkhSnuaQR66A4eg1B9mlDXJnwqsgsc/GEP8oebocfZtnj09Fj630l
         QIeg==
X-Gm-Message-State: AOAM530J+IlYsP/AFfRX6r6WkfnboNdbbrGOJdsHwMS/mI2H6fiOK7u/
        gqBKec5YssIOVr1Zvaj3GERL/+zvb/eyVqA8OihWQRE+ow3ktL9wZDNjon8lbd0cmEiw587k1bt
        Sf+CVzgJSPfO16bKcOCXQVmieYwfW
X-Received: by 2002:a2e:a5c9:: with SMTP id n9mr1046851ljp.434.1644273934322;
        Mon, 07 Feb 2022 14:45:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVkc0ayHC7DxmygvPan9/xdOTQhtbIeMz7lBPggMKIPvy0NWKl22rhHwOENNlmkVy1lgqfxjGC3IJa4QbmvkU=
X-Received: by 2002:a2e:a5c9:: with SMTP id n9mr1046836ljp.434.1644273934167;
 Mon, 07 Feb 2022 14:45:34 -0800 (PST)
MIME-Version: 1.0
References: <20220205081658.562208-1-leobras@redhat.com> <20220205081658.562208-2-leobras@redhat.com>
 <f2b0cac2-2f8a-60e8-616c-73825b3f62a6@redhat.com> <CAJ6HWG7DV-AeWyXxGwMMV61BejcCdpTc=U+4U6eY4gx4hfhP-g@mail.gmail.com>
 <8bf8ba96-94a8-663a-ccbf-ffeab087c370@redhat.com>
In-Reply-To: <8bf8ba96-94a8-663a-ccbf-ffeab087c370@redhat.com>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Mon, 7 Feb 2022 19:45:23 -0300
Message-ID: <CAJ6HWG5sD06=ZMtrcSJ+O3ZH0xVeR7gC8+9o5hq+evXh43Vn_w@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] x86/kvm/fpu: Mask guest fpstate->xfeatures with guest_supported_xcr0
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 7, 2022 at 6:00 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/7/22 21:24, Leonardo Bras Soares Passos wrote:
> >> With this patch,
> >> we have to reason about the effect of calling KVM_SET_CPUID2 twice calls
> >> back to back.  I think an "&=" would be wrong in that case.
> >
> > So, you suggest something like this ?
> >
> > vcpu->arch.guest_fpu.fpstate->xfeatures =
> >         fpu_user_cfg.default_features & vcpu->arch.guest_supported_xcr0;
> >
>
> Yes, but you need to change user_xfeatures instead of xfeatures.
> KVM_GET_XSAVE and KVM_SET_XSAVE will take it into account automatically:
>
> - KVM_GET_XSAVE: fpu_copy_guest_fpstate_to_uabi -> __copy_xstate_to_uabi_buf
>
> - KVM_SET_XSAVE: fpu_copy_uabi_to_guest_fpstate ->
> copy_uabi_from_kernel_to_xstate -> copy_uabi_to_xstate ->
> validate_user_xstate_buffer


Ok, I understand how this replaces patch 2/2, so no issue on that.

About patch 1/2,  you suggest that instead of fixing what we save in
the regs buffer, we fix only what we want to return to the user when
they call KVM_GET_XSAVE, is that correct?



>
> Paolo
>

