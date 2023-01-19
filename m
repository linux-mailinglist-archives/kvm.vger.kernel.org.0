Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC4D67471B
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjASXVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjASXVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:21:03 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EFF38024
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:20:26 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so7393731pjg.4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2hfaQxi9cFOV7vzi506y1iP58o1zwbZebSpOexl7T0=;
        b=SaeJmlkBkZZgNofiVArOtL70JfeQV6oYKFgXSlR0ACjI4+TKUfUc3uSFgUSt1JOwLT
         mmEdzpzahxFByGob55f2NOBSwan+7yzbv+kDlVCCMZae91rj+QZCKfTcWxBS8FWmaUrb
         khgdNh646eYRLU6GgE6l4IZcK8m2FH1zbl7Gg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2hfaQxi9cFOV7vzi506y1iP58o1zwbZebSpOexl7T0=;
        b=v/AMpSa0yIONHi4IwSCEIAOF788Au3C0SAaPcZ66a64luA1Yx4Bs5/sLSqRhj31L94
         Eoi2R/uOGmD22Gk/GH5Io2PwQtlI0UdpU7v3Tr7/stuEYeJBzCgEwp+W+KsL6kkn0MtA
         sZDhce2zghnvbDF8NZ7df0XZWvu14c3cFw4pDJWgZCP9qsqXNTcm7ME2iYXH7eiX8pYe
         w/qJ8TiWB4FtSKkMJm9TnFcARjxh3bDJbmC7RiW/zUJKkhyBJubgLoz66PFp+GYzzGdy
         WSO6LXXjzwoHo3Gww42UuCI8LoEySshxV9/ft6zzD/hFcqFxHAYJbio/GQ6Cr6zdK+9D
         qEbg==
X-Gm-Message-State: AFqh2kryjATb4SXCKQUYmJkvslRPYMU166sqs0EfwMpFHgQMcrGu6S0L
        A0ZlryNzm+aXA7ds+BFzHkI66g==
X-Google-Smtp-Source: AMrXdXvM9LlT41/krWx7wqjPwEmZuSGoStb7t0B53XpaKhzzk9O2QC3U2ioFx0FKZa+FRtgVo4KOJg==
X-Received: by 2002:a17:902:da8d:b0:194:7a42:2d33 with SMTP id j13-20020a170902da8d00b001947a422d33mr17343030plx.28.1674170426410;
        Thu, 19 Jan 2023 15:20:26 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d8-20020a170903230800b00189ac5a2340sm25604620plh.124.2023.01.19.15.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 15:20:25 -0800 (PST)
Date:   Thu, 19 Jan 2023 15:20:24 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Replace 0-length arrays with flexible arrays
Message-ID: <202301191518.3DB46101E9@keescook>
References: <20230118195905.gonna.693-kees@kernel.org>
 <167409066308.2374724.17477861672467900544.b4-ty@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167409066308.2374724.17477861672467900544.b4-ty@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 08:48:52PM +0000, Sean Christopherson wrote:
> On Wed, 18 Jan 2023 11:59:09 -0800, Kees Cook wrote:
> > Zero-length arrays are deprecated[1]. Replace struct kvm_nested_state's
> > "data" union 0-length arrays with flexible arrays. (How are the
> > sizes of these arrays verified?) Detected with GCC 13, using
> > -fstrict-flex-arrays=3:
> > 
> > arch/x86/kvm/svm/nested.c: In function 'svm_get_nested_state':
> > arch/x86/kvm/svm/nested.c:1536:17: error: array subscript 0 is outside array bounds of 'struct kvm_svm_nested_state_data[0]' [-Werror=array-bounds=]
> >  1536 |                 &user_kvm_nested_state->data.svm[0];
> >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from include/uapi/linux/kvm.h:15,
> >                  from include/linux/kvm_host.h:40,
> >                  from arch/x86/kvm/svm/nested.c:18:
> > arch/x86/include/uapi/asm/kvm.h:511:50: note: while referencing 'svm'
> >   511 |                 struct kvm_svm_nested_state_data svm[0];
> >       |                                                  ^~~
> > 
> > [...]
> 
> Applied to kvm-x86 misc, thanks!  Based on the linux-next complaint, I assume
> you (temporarily?) applied this to your tree as well.  Holler if I've confused
> you :-)

Thanks! I've removed it from my tree.

-- 
Kees Cook
