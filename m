Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563552967E9
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 02:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373764AbgJWA1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 20:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368640AbgJWA1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 20:27:36 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC69EC0613CE;
        Thu, 22 Oct 2020 17:27:34 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id w7so832384oow.7;
        Thu, 22 Oct 2020 17:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aQvNC1AmdgK5p6sZekOtJZt51bCkVEXa3LYTnENoFbQ=;
        b=j/oembIxbDWcajp2t7dd3nEwj4jRNjOYac/qtsl5+J98FasO733144KtnXcNV4hkD1
         6oFSy0P3LS+70WQ+SDVB8+lncYVi5K9DixOD83J/+Mrpafj4MRuGjKd0MZOhQdTIDjtM
         Pakpcx020jNkzcPPteQP8VWd0dZDfhelPxcNKjWcAA04SAhMIQv5FRLzeVVveoYbxbFQ
         sb0N9xUWsXKRabZWVpTP/Ri9DHYGu7EBlgq9cEeRBSs9Wiv5VQ8v4z+kSl8eOJHXgdL5
         xBuW2yu3cY0TNrp6VmLurE+8Z/sAPihymJXmRvr0NiqqRU4fF6OU1hvtnoKY5CTtRCBg
         w/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aQvNC1AmdgK5p6sZekOtJZt51bCkVEXa3LYTnENoFbQ=;
        b=Zz/PWExoMV5fBYO917Cd2OUwYHcs9t5GhBpfzRo4hqVPtod3ZQ5o72ZnYR/FbkG1aA
         6yROqnm8nfO5GwafyAsG8wBgGSTMYlXJ7F9RRsrDrh+zz6A35+I7YBRi/cpcro6/ViJL
         iGUh2eZ7LTuP/zpOeqIfvqUO9fmQKbuNCC5RDsRAC6z6oja7c+g83yCeHJkvCXcktqh+
         8HToQFebRwrhVXLxsbG5PAbKujC1G6cK5mivxIRiIAmu+WyuApZXO3yLMpHSwvq8dnHn
         FDXkCZE02Yq6s1xVjW7iBQVKI/kzzE/KikLraYYALgVPNvIEmT35T7yapj/UXlOIqGcF
         I0vg==
X-Gm-Message-State: AOAM533dYDIe1qHPuC9z2ia1T99v+v7AKA/aJ3rD3rlK6qkLDG3p9gsY
        G6/LC3rWmsToMa/8xOlzwZfPBJnO/DWtrB8YzGk=
X-Google-Smtp-Source: ABdhPJxRLlSCqeLv9Lsgex1OW0di1q8rB15SfjyqpDEqTmQstsheD9F7BziiTHPf8oAeJ2qkczHJDTYAGWydv8UCWo0=
X-Received: by 2002:a4a:c54:: with SMTP id n20mr3791479ooe.66.1603412853740;
 Thu, 22 Oct 2020 17:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com> <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
In-Reply-To: <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 23 Oct 2020 08:27:21 +0800
Message-ID: <CANRm+CxDBHnz1crs8_Lkb6-KRHCSwjk6bEMz3n2FwDs2ypbhQw@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 at 21:02, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/10/20 03:34, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Per KVM_GET_SUPPORTED_CPUID ioctl documentation:
> >
> > This ioctl returns x86 cpuid features which are supported by both the
> > hardware and kvm in its default configuration.
> >
> > A well-behaved userspace should not set the bit if it is not supported.
> >
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> It's common for userspace to copy all supported CPUID bits to
> KVM_SET_CPUID2, I don't think this is the right behavior for
> KVM_HINTS_REALTIME.
>
> (But maybe this was discussed already; if so, please point me to the
> previous discussion).

The discussion is here. :) https://www.spinics.net/lists/kvm/msg227265.html

    Wanpeng
