Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A953C7DE4
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 07:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhGNFZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 01:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbhGNFZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 01:25:31 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B922C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 22:22:40 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 141so1574452ljj.2
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 22:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nm8cNY4RzDr9m47lomPKCIO5cyQCB456mTwOJ1bIX3k=;
        b=ejTRkMZJBLibJcF6ks4Crtx+CzygwpSdiVtJy6OLbKQ6E3yJ1iqpMScgww4vIX2Dz0
         HNalAAIzDjG5AUJny/d7XGgoBf8WL92hhD/e27k85X8yPCL2WQ1l5ZhZlJAvoHPCUFUB
         SMM7b4yt+r8hWCSYWNY/2prs3jHntI4VSg53RNJ49+FBZ3nN5aM7Z1ENGiQQzEL+jdOo
         710apJDwQWHt4qDfdZoexZ613LUBBxR2yUi+N+noKG/RkIK30ni80aGGL5i8C9Zx1c/y
         6nvVBoDNoo8RZe4g9weiPr5MBVTFFG6/qcZm+K65Ese6S/xLGRhUGm6O7ebWGxctgJ7w
         S1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nm8cNY4RzDr9m47lomPKCIO5cyQCB456mTwOJ1bIX3k=;
        b=ddB7k7o9ODUOJL8tBTarwmAyzU3jkr6dVUEp2c2BCVWZS9tdH6YD+bV5AnzgvtxVe1
         wIp0sDVmQVQExEQ0VNd53D8iAq9ADRBU61lZlA77OA/94VFhDZbbgWIOzcxSeW1gJdTT
         nrqn9x5o8XbYBejlf31mP8IRE/jyqeEKFMIp8Zgd7I81EsbRUGLZwR+vmfuhZfSlp8EX
         R3o7FOQoOtTQVnfvNerQsMnkDYvOZA3u6ea4CPhPNuUfO8NM6zn6GYxt0bFLHYsLbM74
         PtQhqITbW8QGUdRTGaUTYfTzgwz+na0uS/VSm1N7VDd8M3zNJHgdVW/AAdIAWsjYQeKc
         7xHg==
X-Gm-Message-State: AOAM530ZftORbtjdG31vXcMhLcyf9Xen4LhLvNFfYZVoN/6cS/6py5gt
        5kbxPNp6vkpDAvawAqkMGSnWkZEnhMUCcPbaw2U=
X-Google-Smtp-Source: ABdhPJzPF9D0u4w9EYV5W1SHFFcG15UqfAEDTAsWzEVpp0cnJ1/tCpmAahGulINkIwSvoWpS6wlhQ6g5Wvdd1h4LBYA=
X-Received: by 2002:a2e:bc17:: with SMTP id b23mr7486870ljf.209.1626240158647;
 Tue, 13 Jul 2021 22:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
 <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
 <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com> <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
In-Reply-To: <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Wed, 14 Jul 2021 00:22:37 -0500
Message-ID: <CA+-xGqPh+m2Q3pMoKaMFiJ_sZPPE0XafcT4LqUYT3niJAkxU0g@mail.gmail.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Maxim,

Thanks for your reply!

> For same VM, I don't think it is feasable.
>
> For multiple VMs make some use NPT/EPT and some don't,
> this should be possible to implement.
>
> Why do you need it?
>

I am just curious about it :).


Best,
Harry
