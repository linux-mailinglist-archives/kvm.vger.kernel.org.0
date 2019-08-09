Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DDB87351
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405800AbfHIHnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:43:53 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36012 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHIHnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:43:53 -0400
Received: by mail-ot1-f68.google.com with SMTP id r6so129198174oti.3;
        Fri, 09 Aug 2019 00:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1J962BHFwVMKTVhOM0FCbZ1uXyBj1Z43tq0cNogtjuc=;
        b=OdiBDrwn8CU0xmEZ06Rm9MOTh0cqqifJ1WZ7U5LDP4vtvxTn3nrezBU7z3yE0kM++d
         R+BB3CvM1o72ThdmW9Epkm8cEMTHrb25fc2uDjri/Go7H3FavDEzAwl7nSAKW8w8Xuo+
         h3i4LA2e7gGzbvI1GzvLwRMqUH8PRtkRpJAhyDso6Ow1z4aK+SBr3zezk8N22m/B+vDa
         H0W8/H4iRFk5T3XDEASbJMMe84lJnrnblNHc9deCZJlCAWh1RTOQMgAl5O7Eg7aNGoly
         LM6IHt+aGnxVY3IQDp9+Ktj9xoVqnoswt8DeO+Eq7J8Jghw09NyGE/Oc3WrW/wENMiCb
         tmcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1J962BHFwVMKTVhOM0FCbZ1uXyBj1Z43tq0cNogtjuc=;
        b=n/KLLUiWxsijx9DgTkd86hMhy2wuXS0aoR7gNDpQBBxlCI98TGFps3tQEChEqXZsF5
         5o6SVnM4ur7U1CJtU9GGAfMqL+4Ot6K8iJkErCopwl8TBRuAyV1kBqicMk20vI7OYL/s
         +2KGvB+HrtiAuwfAraV6YV/ltzICXtXThcSL3KxeeFKGg3ZNQkvVgOgoeMghS3IwlDGd
         hgcct2qI+7plkSCOESj5U1EFCbpNP/Jlqg9cHjbV5wV3bCrtvbkCqvw9qpxt2Jpzm1yD
         vY7nhIka7WNVmlWCbPCN38mqak2iDj8g8F36Zn/WyKTxuekiWmc/W7CCoCVKwgC6v3oK
         +K2A==
X-Gm-Message-State: APjAAAWC60tAkkc0N0XqYAOM2aNNHdyQuPklxL+7PhP1GEJUXfeicYek
        eNJgogt2q8ViZc75RMsKl8QqMQ+z0X8aKoblcsI=
X-Google-Smtp-Source: APXvYqwOk0woKAbzWv1Z3nrBmlql3YpqwRKcegFcIcd5d+8QH8OxDjI8hS2f4l/DdL2KtWiTMSlqmKX2nOnEeH2/pMk=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr14993160ote.254.1565336632164;
 Fri, 09 Aug 2019 00:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <1565336051-31793-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1565336051-31793-1-git-send-email-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 9 Aug 2019 15:43:50 +0800
Message-ID: <CANRm+CzkKEk+A5yeF2oPa19=UsAZDeLz8E=p41WAK6uWjUgxEw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add KVM x86 reviewers
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Aug 2019 at 15:36, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> This is probably overdone---KVM x86 has quite a few contributors that
> usually review each other's patches, which is really helpful to me.
> Formalize this by listing them as reviewers.  I am including people
> with various expertise:
>
> - Joerg for SVM (with designated reviewers, it makes more sense to have
> him in the main KVM/x86 stanza)
>
> - Sean for MMU and VMX
>
> - Jim for VMX
>
> - Vitaly for Hyper-V and possibly SVM
>
> - Wanpeng for LAPIC and paravirtualization.
>
> Please ack if you are okay with this arrangement, otherwise speak up.
>
> In other news, Radim is going to leave Red Hat soon.  However, he has
> not been very much involved in upstream KVM development for some time,
> and in the immediate future he is still going to help maintain kvm/queue
> while I am on vacation.  Since not much is going to change, I will let
> him decide whether he wants to keep the maintainer role after he leaves.
>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  MAINTAINERS | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

Acked-by: Wanpeng Li <wanpengli@tencent.com>
