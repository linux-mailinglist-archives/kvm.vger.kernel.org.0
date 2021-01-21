Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143F12FF50B
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 20:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbhAUSrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 13:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAUS0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 13:26:00 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ABDC06174A
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 10:24:18 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id m22so3881360lfg.5
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 10:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kT/jExCrQmlhS85/qwzQJgbWzMqvqpcCTkvXgEptUG4=;
        b=bH0VznfIsQ+53sOEpPItnkMslaFtto7zkJqYtSK8dEnE1P5oyzOwX+quCBIi5V/l/a
         /Zxna95v/etRMMJDlQPQ1lI0XfLCtHu6slW10ESbCfE4WZ9ll9NMIVhj2ulYiabv5v6N
         VdI89cJuNFVhlqWIQurxruiimqk6+ENKuvncXTPxCqKw13E6uDi6pAXLSme72QupHrre
         gaGE10dzbnEVIPzqC16Xz9MO9wMJD4CNfW/oc1JjGF6kZoxyzdiRwn4/L5XFzSj4+g62
         TG3NbJaFntj8O22F14tuvI+pYHVXOp29ZVWcSnICs+AiO8MEA6LHcYkoKIh81XnlPHN4
         wGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kT/jExCrQmlhS85/qwzQJgbWzMqvqpcCTkvXgEptUG4=;
        b=REvaCeSs9nSq6OGtkM6BUJpGADvM0jjKmJ0hAtFMfQUpOaIsPYdyxnkUDtgaMJoIlZ
         RVURw4TyCBYmvbmDs2kXotDrrIFCr1wxdXuLyIqXvFbvAPZHvflA+hm0TpmwpD9EYMQS
         8+tHZuEr5zPYVdrcNXpylQ8usg5fcCgyBbbjSQMICWlk6gxnTvhOoWpDeDdgsHfPEN4m
         R5aREgEQ9Jpr1pcVYy8P4XxT/MP4BKMXLUZhTzTWDh/zTmQI41J8s97McQU4xz39Ldcu
         proWnCrrYL3CsFaynO41qTHFu+TiqrZ34byuFIFCrAcI4vUoU9Q9kpNwhbNE+jVN/lgf
         H6Hw==
X-Gm-Message-State: AOAM530ODJbK/h0rRZzTk2kyqz8PJtEo2uWy3yE2j29o4pCWwmsaov+m
        XlpO2CN8hAqD2+dh0sa58csJl11ed0AgEonE/QxFfCoxzOZAtg==
X-Google-Smtp-Source: ABdhPJzaN8Vfr0eonmzuRkTZF95ajcdlbTxd+/xM47v4Dma4GXzA1E7zphsUaKnEmZ0P4ra4I1I2tC36gBXwhj6zhi8=
X-Received: by 2002:a19:c309:: with SMTP id t9mr252946lff.46.1611253456657;
 Thu, 21 Jan 2021 10:24:16 -0800 (PST)
MIME-Version: 1.0
References: <20210121111808.619347-1-imbrenda@linux.ibm.com>
In-Reply-To: <20210121111808.619347-1-imbrenda@linux.ibm.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 21 Jan 2021 10:23:50 -0800
Message-ID: <CALzav=cDeL++8qdY2dJsbTmh+2z0hiAOeYk=NUqttEmKiPMvKw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/2] Fix smap and pku tests for new allocator
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        cohuck@redhat.com, Laurent Vivier <lvivier@redhat.com>,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com,
        seanjc@google.com, chenyi.qiang@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 3:18 AM Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>
> The recent fixes to the page allocator broke the SMAP test.
>
> The reason is that the test blindly took a chunk of memory and used it,
> hoping that the page allocator would not touch it.
>
> Unfortunately the memory area affected is exactly where the new
> allocator puts the metadata information for the 16M-4G memory area.
>
> This causes the SMAP test to fail.
>
> The solution is to reserve the memory properly using the reserve_pages
> function. To make things simpler, the memory area reserved is now
> 8M-16M instead of 16M-32M.
>
> This issue was not found immediately, because the SMAP test needs
> non-default qemu parameters in order not to be skipped.
>
> I tested the patch and it seems to work.
>
> While fixing the SMAP test, I also noticed that the PKU test was doing
> the same thing, so I went ahead and fixed that test too in the same
> way. Unfortunately I do not have the right hardware and therefore I
> cannot test it.
>
>
>
> I would really appreciate if someone who has the right hardware could
> test the PKU test and see if it works.

Thanks for identifying the PKU test as well. I can confirm it is also failing.

I tested out your patches on supported hardware and both the smap and
pku tests passed.

chenyi.qiang@intel.com: FYI your in-progress PKS test looks like it
will need the same fix.



>
>
>
>
> Claudio Imbrenda (2):
>   x86: smap: fix the test to work with new allocator
>   x86: pku: fix the test to work with new allocator
>
>  x86/pku.c  | 5 ++++-
>  x86/smap.c | 9 ++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> --
> 2.26.2
>
