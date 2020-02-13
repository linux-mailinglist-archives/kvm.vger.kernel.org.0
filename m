Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33ED815CE01
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 23:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgBMWSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 17:18:53 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38833 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgBMWSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 17:18:53 -0500
Received: by mail-io1-f67.google.com with SMTP id s24so8355368iog.5
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 14:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cgJetIujIpTH3S+W9TWGosMzVWu5sFXVz/DtyknH4BM=;
        b=JV0MoYAV9Ah9y9mX6EMwYfgBuYYaPUY4Vtgdhk8pNUAzi5XfgOtdMRFoJSw5da+g7b
         ScmRhWwnph6Ew2mwFfq+tAVGzATIM90EXhnKIuXiZWmS7hihYQlUOfpUAuK9zxWf62jW
         BZ80VR/ltodBW0LXnRCVlyfCawA+IA4dIDqcxb+qump0199JdLKenSLGK3kWCOk9+zqk
         02kh8AtBuG5Er22Kae0kVN8qdm8p9RaYoaZ1kQyskApQQsh/DpHuCzfOqjFhllrop5YM
         CoyYtJQKtVxc/cdF81c070GpMpJRe7SaM6kS3OLsSCEv1gAWKwWFYIJN03oMO68KBUJx
         lEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cgJetIujIpTH3S+W9TWGosMzVWu5sFXVz/DtyknH4BM=;
        b=EOYbwAOUDcADgoTyk9FvrEzxZARgYlPhzbxtKTD0oXi330KAo3PuMA9I56pWb2g282
         qyttnI6MYEg9YOx6ALZvJ+aO8bUFkWBv4G50A+RufhHEydoifRzyCglkGhF2qGG7r5DV
         opHmZu/yj+u4mYdxX/oZ5fzPwFf6rlvnrFw4Xkcjo3i4/uLc66iDI0PF5p0lGx/R6fUO
         SOcRWXsbSPcFhOraXY4G75RLwdrjZ2u7bR4wtJMRcLt38WnZsM8zWezQdsClPVTXhfGz
         wCXI3jBZN9g6o3zsC87cnb0wwqFjRUbpZGZSmlMlCXDUI0BDXPkqLw0ZGK3+SZEUQoEG
         tU4g==
X-Gm-Message-State: APjAAAVKjZ43V9trzuYXL5rvflWrp8m3g2dvheKtQ95C7/xU89oPpuCa
        WGO5KX5jhIgxLD4329FXa8zZYLumWWrFo/oRyKw=
X-Google-Smtp-Source: APXvYqyJjYPcylq2tJdi+XpmWzTzJo74Hv8POtQ7C61FrOILZGSI/nkmlgldQs/32rRcnnTdMjVQ5SggqocZH2gYXoI=
X-Received: by 2002:a5d:8555:: with SMTP id b21mr23821852ios.200.1581632332393;
 Thu, 13 Feb 2020 14:18:52 -0800 (PST)
MIME-Version: 1.0
References: <20200213213036.207625-1-olvaffe@gmail.com> <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
In-Reply-To: <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Thu, 13 Feb 2020 14:18:41 -0800
Message-ID: <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 1:41 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/02/20 22:30, Chia-I Wu wrote:
> > Hi,
> >
> > Host GPU drivers like to give userspace WC mapping.  When the userspace makes
> > the mapping available to a guest, it also tells the guest to create a WC
> > mapping.  However, even when the guest kernel picks the correct memory type,
> > it gets ignored because of VMX_EPT_IPAT_BIT on Intel.
> >
> > This series adds a new flag to KVM_SET_USER_MEMORY_REGION, which tells the
> > host kernel to honor the guest memory type for the memslot.  An alternative
> > fix is for KVM to unconditionally honor the guest memory type (unless it is
> > MMIO, to avoid MCEs on Intel).  I believe the alternative fix is how things
> > are on ARM, and probably also how things are on AMD.
> >
> > I am new to KVM and HW virtualization technologies.  This series is meant as
> > an RFC.
> >
>
> When we tried to do this in the past, we got machine checks everywhere
> unfortunately due to the same address being mapped with different memory
> types.  Unfortunately I cannot find the entry anymore in bugzilla, but
> this was not fixed as far as I know.
Yeah, I did a bit of history digging here

  https://gitlab.freedesktop.org/virgl/virglrenderer/issues/151#note_372594

The bug you mentioned was probably this one

  https://bugzilla.kernel.org/show_bug.cgi?id=104091

which was caused by

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fd717f11015f673487ffc826e59b2bad69d20fe5

From what I can tell, the commit allowed the guests to create cached
mappings to MMIO regions and caused MCEs.  That is different than what
I need, which is to allow guests to create uncached mappings to system
ram (i.e., !kvm_is_mmio_pfn) when the host userspace also has uncached
mappings.  But it is true that this still allows the userspace & guest
kernel to create conflicting memory types.

Implementation-wise, the current implementation uses
kvm_arch_register_noncoherent_dma.  It essentially treats a memslot
with the new flag as a non-coherent vfio device as far as mmu is
concerned.

>
> Paolo
>
