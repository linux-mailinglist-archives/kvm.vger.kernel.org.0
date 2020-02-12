Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E9E15B038
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 19:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgBLSyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 13:54:06 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46502 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbgBLSyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 13:54:05 -0500
Received: by mail-lf1-f66.google.com with SMTP id z26so2328948lfg.13
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 10:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XOSZhIPmTiYpkSLY4moOIVyEjS918RWzM6qDX6XR91k=;
        b=MoT1DNRhdzigKA5c1i9hMlF17+RjZiB01pnephKyvwGUPJIs6VcAlwEKstziybjxM1
         z+UxuOPU8JIZnnz6Ckd+afAIevrdOPks12BwsCco/phTBbXPq432S/itPUBYO3hP9Mln
         3kihLTHPnFUYbiWWHaAgWErVzneXWJfReE4a4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XOSZhIPmTiYpkSLY4moOIVyEjS918RWzM6qDX6XR91k=;
        b=HC+sW8ikJYma4C/6t6IO7OAz9Gsc4fdf5Jn7jCl2JpQk4BaSoJcNNZHgEmI9c0TACG
         UPw7cR3yTAOARbxKGGAAnuLoZTvdcdvGhXZ1QFrG3C1F7mKj/VklArxZHle3sb9NTJke
         +Ii6GRfd5IMCNeFYK2gvFCA6wEIrPh/O8eSIFOmkFQAXiKvJ1hfFG87OX3/EW6Di+Vo9
         wi030L+NjmxfhASIO0g8gbwl6n8y3SvwMnR3dxHVE1QOcMxgUA3YTCDC/HTCrHLF8WJh
         FYqVi3Bo6tOJQhYCFmYnsS9c3SllZiYwEg48RYodaYTxbcgpazDUkjue1et14sq93IZF
         efhQ==
X-Gm-Message-State: APjAAAW4trYoevogPxQ0IUIh/cmxPp9wbu3Cp23eAEVI07sOYu+3Q9Dg
        DriC7s6ziPUakUhBSRD7NpVjyU2wcmo=
X-Google-Smtp-Source: APXvYqyerVfxGy1OVM7tNyHWBjHtI5ppv7+bRURRIRVX6vUH9m1/K8s+2zFVIS1SSBBQx55OwdtNcg==
X-Received: by 2002:ac2:4214:: with SMTP id y20mr7389013lfh.214.1581533643041;
        Wed, 12 Feb 2020 10:54:03 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id r23sm18931ljk.35.2020.02.12.10.54.02
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 10:54:02 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id n25so2387173lfl.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 10:54:02 -0800 (PST)
X-Received: by 2002:a05:6512:78:: with SMTP id i24mr7551507lfo.10.1581533641799;
 Wed, 12 Feb 2020 10:54:01 -0800 (PST)
MIME-Version: 1.0
References: <20200212164714.7733-1-pbonzini@redhat.com>
In-Reply-To: <20200212164714.7733-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 12 Feb 2020 10:53:46 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh6KEgPz_7TFqSgg3T29SrCBU+h64t=BWyCKwJOrk3RLQ@mail.gmail.com>
Message-ID: <CAHk-=wh6KEgPz_7TFqSgg3T29SrCBU+h64t=BWyCKwJOrk3RLQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc2
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, rkrcmar@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 8:47 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> A mix of cleanups and bugfixes, some of them slightly more invasive than usual
> but still not worth waiting for 5.7.

What? No.

> Oliver Upton (4):
>       KVM: nVMX: Emulate MTF when performing instruction emulation

This was committed today, and it's complete and utter garbage:

   CommitDate: 7 hours ago

It doesn't even compile. Just in the patch itself - so this is not a
merge issue, I see this:

          int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
  ..
  @@ -1599,6 +1599,40 @@ static int skip_emulated_instruction(struct
kvm_vcpu *vcpu)
  ..
  +static void vmx_skip_emulated_instruction(struct kvm_vcpu *vcpu)
  +       return skip_emulated_instruction(vcpu);
  ..
  -       .skip_emulated_instruction = skip_emulated_instruction,
  +       .skip_emulated_instruction = vmx_skip_emulated_instruction,

ie note how that vmx_skip_emulated_instruction() is a void function,
and then you have

         return skip_emulated_instruction(vcpu);

in it, and you assign that garbage to ".skip_emulated_instruction"
which is supposed to be returning 'int'.

So this clearly never even got a _whiff_ of build-testing. The thing
is completely broken.

Stop sending me garbage.

You're now on my shit-list, which means that I want to see only (a)
pure fixes and (b) well-tested such. Nothing else will be pulled.

                    Linus
