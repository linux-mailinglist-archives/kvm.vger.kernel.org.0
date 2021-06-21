Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20D83AF992
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 01:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhFUXlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 19:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhFUXlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 19:41:16 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975C3C06175F
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 16:39:01 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id u13so13617982lfk.2
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 16:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKCX3YjuqUNoE4+roGGfm8o2np78e+Xfu61B4cA+uJI=;
        b=QFcnGtA3VrPeLLWUQicj9F1i0h1b/5RybgGRdCxbzFL8QhdCFvqX8VwhHYX5q3Pqkr
         5doeAmEDeGxRt76VeDSVeTUadqoTA9u5/6KTlXOqcOXjJSNpNfPijSSqRT/k13mRT82w
         BkMfCbkNJslkTjpro+DkmBk3PjS4Hn6PXERxRUa93acO7MAGSIQkTHpMNoCVbbitEC/G
         3z40+VkdiWaBHfrDy1AVZ8PQ02ycaq32fh4zmxddeYVhD6TbyPzafSla/8UwQq8SJUic
         P+LJtxgksTY14V5S67BoAcB1O0z9RiIOsr1CYCnuSPJgiazaQKBcf7ytjA/ktHEpP3jT
         SeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LKCX3YjuqUNoE4+roGGfm8o2np78e+Xfu61B4cA+uJI=;
        b=Y/IEOLr85qk3hJIQFqAMAZbXe9dXGIOW8bMJlTQNCb4SazSFnTVc46rpTYm8H4HLSh
         zJOBXapQDwicoTpuMRBbPgAksGQ7w3tNzhE9zYVzWjXUl/PZLkEU8E/f5xkB35Zl6aST
         XQ+efunVMt8aWzFf35VpC3YF6lQEXHXq84jpjMYYueICYAs/Bh+mDsaISkSx1Pwgw9Ni
         nHs9eNfWk/ToBxM5aQi7fR0tBnltfzwhuEqoICFzINqwKLkzSJOMQivLjwgGNO+N2tUO
         z8t75F3QbUN/R3q5dFI7wM6Q5m6dKGu9w0n2gT7b6T9tSXnMGyxCHKxP58ZFW3H+TBR/
         j+2g==
X-Gm-Message-State: AOAM531xwUoDoQvB7s64QlOpFLiCcoaxCPbA/mv3tJ9RX+uzI4FKTsJa
        qSJez+iLGIi8mfPRoJBD9Oe39r5uYtgTv2iJ38s0G1c0ChY=
X-Google-Smtp-Source: ABdhPJyDQGI0gLkASAQSuSpsPjVvNlP9W768H8z16TiAXAgKg2wBct7k8/lWvgPo4urmgneuo0U07ygTChCL7ubyJYY=
X-Received: by 2002:a05:6512:33c4:: with SMTP id d4mr592219lfg.536.1624318739777;
 Mon, 21 Jun 2021 16:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210618222709.1858088-1-jingzhangos@google.com>
 <20210618222709.1858088-3-jingzhangos@google.com> <0cde024e-a234-9a10-5157-d17ba423939e@redhat.com>
 <CAAdAUtiL6DwJDWLLmUqct6B6n7Zaa2DyPhpwKZKb=cpRH+8+vQ@mail.gmail.com>
 <aa1d0bd9-55cf-161a-5af9-f5abde807353@redhat.com> <CAAdAUti1MreOnAXtA+jBEaq+AixmqvBEByi9G4EgDpfu63spHA@mail.gmail.com>
 <c639c557-0e16-6938-2da5-46400ee2dd14@redhat.com>
In-Reply-To: <c639c557-0e16-6938-2da5-46400ee2dd14@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 21 Jun 2021 18:38:49 -0500
Message-ID: <CAAdAUtgXAedsXf_1Mjp+mBNkZkHg9feirMpUYQFrYhQ=8vVFcg@mail.gmail.com>
Subject: Re: [PATCH v12 2/7] KVM: stats: Add fd-based API to read binary stats data
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021 at 6:35 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/06/21 00:58, Jing Zhang wrote:
> >> Pass it as an argument?
> > The num_desc can only be initialized in the same file that defines the
> > descriptor array.
> > Looks like we have to have a global variable to save that. The
> > solution would be similar
> > to have a statically defined header for each arch.
> > So, keep the header structure for each arch?
>
> Oh, sorry.  I missed that there's only one call to kvm_stats_read and
> it's in common code.  The remaining comments are small enough that I can
> apply them myself.  Thanks!
>
> Paolo
>
Cool! Thanks, Paolo.

Jing
