Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50823E0961
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 22:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbhHDUaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 16:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239715AbhHDUaU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 16:30:20 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE5FC061799
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 13:30:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso5246470pjf.4
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 13:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ay2VkZp1QSgjgUuaKlnv5Qoem62OrDMpCDFTC9mEKKs=;
        b=h7uefQRXljacHpvf0siGwYGLJf0aZg9wL7lcZZD8SAP8NjZ/OatK0tjPjxlwXe7IMK
         7xlwDJ96zOb5RrRMABauPXT1M/okb7U1zyItTZ4Qvh9n+DzioYOhUbOveIWEqhahz1oF
         WzK7+e+VBfH+31jV+jd76JPm2uM3+y24jwTti6Hs+LAhbLSlPQd7EbC3/aCstk6R19Xw
         q1IMZV8pNKwyIHlKt/fr0tSbGMYktdvBSycYWVNIAENTj39hF5VkmONe29adwj35Zezd
         NG070KRGEFXwBno8lVsOlGDUqHcxynthQu6Y/1kZxqPcG2jQwGHUu5XEr8J79OHlbOqt
         Px1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ay2VkZp1QSgjgUuaKlnv5Qoem62OrDMpCDFTC9mEKKs=;
        b=AG78BBrESbrY1f5s8QIklvWsMN86iYCNnsP1LOJyliqCCiTIOl4sc0uNRrSsjRjOOy
         gEyzfHxjH9rQFmMbHWyq2u/8Of3qGIQZDMkzMEniINUyfBcsN5IkrSii23dtbjKj5a5v
         WO+43/wL0hI2jpD3YHeqXnNuvNlEMZaAFkB5KiBEZBK60P7m40hrUnyOdLw0T6CmTLm9
         O3mu1/goOJ8T5nQjZwEWUbZ/wT+CX7O2Z6TyF1EdUApNp/adFtMMJMu0KFEt9x94wL0U
         w8xg1MCXTzYjDEcoOF7lgfdCbJmXZlid3vW4FAyEdQekT+1fGNhkrZA7eWca+iqJ/WMB
         hFZg==
X-Gm-Message-State: AOAM5303JJRSVvQ4ofG5H7M4SpxLfwFeQ4EiLzlkwXQs2btj6L6SA7Nb
        e3h5A0RU/xqRYzBSNl3xW/P6U0T0N1daMOBijNXlEQ==
X-Google-Smtp-Source: ABdhPJy/uPKrEp0nPLVvxOUcb/sdhHBtDi1SSscb0nok7vJYVZmxgN45gHrXgDwd/ykefzZ6jcQJRES2Sk1Ld1I48jc=
X-Received: by 2002:a17:90a:1208:: with SMTP id f8mr11602671pja.73.1628109005619;
 Wed, 04 Aug 2021 13:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210726183816.1343022-1-erdemaktas@google.com>
 <20210726183816.1343022-2-erdemaktas@google.com> <e1651746-aa46-31e7-e1c0-99f3faaf1586@intel.com>
 <ede70f11e713ee0140c0e684c3d46b3aa1176e5e.camel@redhat.com>
 <42a812a9-7f17-2a26-d289-1f921408a469@intel.com> <c82a3abe00d387985ac806c8ff062cc29e192bbd.camel@redhat.com>
In-Reply-To: <c82a3abe00d387985ac806c8ff062cc29e192bbd.camel@redhat.com>
From:   Erdem Aktas <erdemaktas@google.com>
Date:   Wed, 4 Aug 2021 13:29:54 -0700
Message-ID: <CAAYXXYx_CFKBhFjqfz_wyh6bPPbWpTPCDfGmmLGqiugvfqA3Dg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] KVM: selftests: Add support for creating
 non-default type VMs
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, linux-kselftest@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Sagi Shahar <sagis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Shier <pshier@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Like Xu <like.xu@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you all for all that great feedback! I will include them in my v2.

On Wed, Aug 4, 2021 at 7:46 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> > > > Can we pass KVM_X86_LEGACY_VM (whatever name when it's upstreamed)
> > > > instead of 0?
> > >
I was originally thinking of doing this but Sean has suggested that we
should use 0 to make it  arch-agnostic for creating default VMs.
+Sean Christopherson : What do you think?

>
> KVM_X86_NORMAL_VM is a very good name IMHO as well.
> Thanks!

Sounds good to me.

> For example:
>
> struct vm_options {
>         enum vm_guest_mode mode;
>         uint64_t phy_pages;
>         int perm;
>         int type;
> };
>
> struct kvm_vm *vm_create(const struct vm_options *options)
> {
>         ...
> }
>

I liked this idea, I will see if I can include it in my v2.

Thank you so much again.
-Erdem
