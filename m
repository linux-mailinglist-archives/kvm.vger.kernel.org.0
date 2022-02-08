Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B004ACEB9
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 03:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344634AbiBHCOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 21:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbiBHCOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 21:14:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE13CC06109E
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 18:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644286488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FzpbanrXZY9PE1o0RnSJx3xfnliEwEF23zGaJH7xZDI=;
        b=B/eOs1WgKl8yQTUE9TxD95tJA9ydopzIMw7oNbNoy/Ep4IDC1E5l5y2iELgW8/s6TK/WYU
        eZcAdtfJvGBJMqwSv+hwsgALN66ivugX60M/bqviBjUJSKICSNNpig37wIJzWamdgpLUji
        5cYvY3LK87UBlYz6Arx+fN0KQ84qLCk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-ThgRIypkOriTGpsd_DLTlw-1; Mon, 07 Feb 2022 21:14:47 -0500
X-MC-Unique: ThgRIypkOriTGpsd_DLTlw-1
Received: by mail-lj1-f199.google.com with SMTP id bd23-20020a05651c169700b0023bc6f845beso5343149ljb.17
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 18:14:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FzpbanrXZY9PE1o0RnSJx3xfnliEwEF23zGaJH7xZDI=;
        b=XapB318fcnU4hHO1lZAy4VOKH2E4/Bg9UGQelI7m5hNa4KO9zpAA8NkpauNTCpD7we
         srtQVgrRGtCVwF0zFuhzNIS3Rk0yCHwNf/p7RZlCtEwuaz+sEhyMb+uZhGAdOha/2wmU
         Oy0FQjakUbWswtxBEMxuyiGc5r+lhmvn72aqEMvDqIrbo1uC/G3B8JqR3KccKIofQ6Cq
         muIUn39NncDWjJMpa3mJ5gZJnPOUIP46L/aPB7o+IoSdZ0uL2AYB2ExbMR2w66YwT9CB
         p061o60gWscu9DjnaNMbVBXYWleSknWz7dnV2qi/rZ6tXctnes5O/AeuOTb0B0scJcng
         NTVw==
X-Gm-Message-State: AOAM531EdCyyBu14cTxxwYiOxdBmxYk5/f4il/oBbTmE2YLfXV0ge9C+
        w2iXkLCV/20h4w6l6I3aDQJ5jtMbosConpxbOAuF0xahPf8YghhGVIm5Bh3CflfnrrY3LcZytiR
        BJn6sWvMM/qIkYDuvi8zRiDtUNrOk
X-Received: by 2002:a05:6512:3408:: with SMTP id i8mr1491828lfr.17.1644286486327;
        Mon, 07 Feb 2022 18:14:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2S6Av4hiQRTWs3XYWyGzxHic6+nQYtdwnU59heli15NyOGJSnX3n0bDXVBYHUqY/BUxPoIkqbw5yGsh7OC3c=
X-Received: by 2002:a05:6512:3408:: with SMTP id i8mr1491818lfr.17.1644286486102;
 Mon, 07 Feb 2022 18:14:46 -0800 (PST)
MIME-Version: 1.0
References: <20220205081658.562208-1-leobras@redhat.com> <20220205081658.562208-2-leobras@redhat.com>
 <f2b0cac2-2f8a-60e8-616c-73825b3f62a6@redhat.com> <CAJ6HWG7DV-AeWyXxGwMMV61BejcCdpTc=U+4U6eY4gx4hfhP-g@mail.gmail.com>
 <8bf8ba96-94a8-663a-ccbf-ffeab087c370@redhat.com> <CAJ6HWG5sD06=ZMtrcSJ+O3ZH0xVeR7gC8+9o5hq+evXh43Vn_w@mail.gmail.com>
 <2b1d142e-e06c-3f38-32f5-d14de7dca289@redhat.com>
In-Reply-To: <2b1d142e-e06c-3f38-32f5-d14de7dca289@redhat.com>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Mon, 7 Feb 2022 23:14:34 -0300
Message-ID: <CAJ6HWG7rq8jemuaixSSyG_nd=Qr1PAqfGKApz8nUamiLeT5RWA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 7, 2022 at 7:59 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/7/22 23:45, Leonardo Bras Soares Passos wrote:
> > On Mon, Feb 7, 2022 at 6:00 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 2/7/22 21:24, Leonardo Bras Soares Passos wrote:
> >>>> With this patch,
> >>>> we have to reason about the effect of calling KVM_SET_CPUID2 twice calls
> >>>> back to back.  I think an "&=" would be wrong in that case.
> >>>
> >>> So, you suggest something like this ?
> >>>
> >>> vcpu->arch.guest_fpu.fpstate->xfeatures =
> >>>          fpu_user_cfg.default_features & vcpu->arch.guest_supported_xcr0;
> >>>
> >>
> >> Yes, but you need to change user_xfeatures instead of xfeatures.
> >> KVM_GET_XSAVE and KVM_SET_XSAVE will take it into account automatically:
> >>
> >> - KVM_GET_XSAVE: fpu_copy_guest_fpstate_to_uabi -> __copy_xstate_to_uabi_buf
> >>
> >> - KVM_SET_XSAVE: fpu_copy_uabi_to_guest_fpstate ->
> >> copy_uabi_from_kernel_to_xstate -> copy_uabi_to_xstate ->
> >> validate_user_xstate_buffer
> >
> >
> > Ok, I understand how this replaces patch 2/2, so no issue on that.
> >
> > About patch 1/2,  you suggest that instead of fixing what we save in
> > the regs buffer, we fix only what we want to return to the user when
> > they call KVM_GET_XSAVE, is that correct?
>
> Yes, exactly.

Thanks! I will update my patch and send a v2 shortly.

I got really curious while I was debugging this issue:
- Is it ok that the cpu has other features enabled (like PKRU), while
our vcpu does not have them?
- Should guest OS always use the cpuid for checking features available?
- Would it be better if we could have exactly the same fpu features
enabled in the cpu, as we have in the vcpu?
- Why do we xsave with a mask different from what we xrstor ?

>
> Paolo
>

