Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935DC2413AA
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 01:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgHJXRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 19:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgHJXRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 19:17:19 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E015DC061756
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 16:17:18 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id j16so2248607ooc.7
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 16:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oDXx5xJz1b+wcw5C/YeihMWCNkvCnSl6ZWGflH/Camk=;
        b=G2WMPWEnEgkIw8rUO76xQAEFBkE1B8TahPRJXZpA0yt9brxalzEaXGQ0isAPxwO9iL
         Ema06xXbSyN/MsFCpcnyGBHNYrNTGO1SboHfjBYbaONgXoSEEwOY/SgM9HYLrh4HY2E1
         8jsIMI1TPmSvy9HKsJ943JNmid7GT/yJzmPFS2P1+eHAumMNv/8wkuFlnpm29MFVDWwg
         0BoGzPjEhxhaXjom8490dHZSWwUed5trgNt+x3AnoG2BhoTl1sLhBBNYTP8LqSQ3AnDT
         j9kkK8Maa1QKY4Yq7H6nYdZNSxzNHWzlff3jrlK4Td/TXQ9hWuCg9t/RJjw95nZD4EAY
         8EQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDXx5xJz1b+wcw5C/YeihMWCNkvCnSl6ZWGflH/Camk=;
        b=lQZXxA+jqwR7xEiQHYJRMfzEQ/ojChSDVyawBAehdg5d9Q59QjHSXgi+q1b7IbqfJP
         KqYRm8OYR0YKjnRYzungTEF2KYT3WkFHDzQIR7PKQnM0rtVvVU3NxeQ2oZZ+XUOVEeL1
         fHe7M6RRUzdxt9LP5QXuYJUqDbAXDj0GDSnCZgEnd9VBX79S4+i1QOES677CE/4Z1jrq
         8UooHyKPn5iFsMHvy/6yfG/8vtfErQuxWjOv5HrCA9uzFuUoNjdK8QyBtgxEe5rG0rb3
         wmcAiXJ+ghgMvzq32b1IWWiNyMXe1LppByPMcHKwKoMWbTqBMLPWXaX1xz87M9Y5+4ja
         rVJw==
X-Gm-Message-State: AOAM532CcmXWmWDshbjSpcicXTUWwjuRxDjCtO16Ra4CI1U2zlv0MCAQ
        0NKj4ksNtH6NBVBzzvfZFO7SY3T95j0kTnv0gk7htA==
X-Google-Smtp-Source: ABdhPJzvzcF7MszhID1v28AVOZi5aWdqtP6b/SmecyE0nDYFxNGBZOHaye1qL2jOOIvYdQSFoNObyXBOJTJ89w+wQyE=
X-Received: by 2002:a4a:3015:: with SMTP id q21mr2815185oof.55.1597101437923;
 Mon, 10 Aug 2020 16:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200807084841.7112-1-chenyi.qiang@intel.com> <20200807084841.7112-2-chenyi.qiang@intel.com>
In-Reply-To: <20200807084841.7112-2-chenyi.qiang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Aug 2020 16:17:06 -0700
Message-ID: <CALMp9eSse8jkSC2B=7s7jbtQ1gnOgZokuhDgeu3-E93pi+g+Xg@mail.gmail.com>
Subject: Re: [RFC 1/7] KVM: VMX: Introduce PKS VMCS fields
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 1:46 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
> PKS(Protection Keys for Supervisor Pages) is a feature that extends the
> Protection Key architecture to support thread-specific permission
> restrictions on supervisor pages.
>
> A new PKS MSR(PKRS) is defined in kernel to support PKS, which holds a
> set of permissions associated with each protection domian.
>
> Two VMCS fields {HOST,GUEST}_IA32_PKRS are introduced in
> {host,guest}-state area to store the value of PKRS.
>
> Every VM exit saves PKRS into guest-state area.
> If VM_EXIT_LOAD_IA32_PKRS = 1, VM exit loads PKRS from the host-state
> area.
> If VM_ENTRY_LOAD_IA32_PKRS = 1, VM entry loads PKRS from the guest-state
> area.
>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
