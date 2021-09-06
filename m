Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C40402093
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 22:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243706AbhIFT6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 15:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241578AbhIFT6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 15:58:02 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A38C061757
        for <kvm@vger.kernel.org>; Mon,  6 Sep 2021 12:56:57 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id q70so15379057ybg.11
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 12:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xaieRye1AeYugSPI36l1iJTAUqlrY3yw60sYt+VY7So=;
        b=owYtIrdgFhnYEPiIVu/2YoEohn98+TOeR5b0yYti2jQJ+RZHA63ZsQZ/i6EFbNK/Z9
         9y9hvVi2vcnXI0cQYKqV1mswbRtNK591SG/xL4Vb1vFIjBASEvkwLe/ARbUxh6k4hGqk
         FROLqendx80BAH9hzh3PHgzivzrOC6OEThNKXT6ddElJ4EWfXl1csEq6QCKXOl/Hrb3i
         YBmezf4cdA3hKb/Zu8674ri5ex4QfV/13vaOI3oSmab5kL4y35C7ksMNNrBhueM84E6A
         XA1UyX0iwhI3dCok61ccpxBSeKW6nL+cYiWlSkBdNSlzvPHDNYBzuxNgSXlba+l67UcQ
         7rYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xaieRye1AeYugSPI36l1iJTAUqlrY3yw60sYt+VY7So=;
        b=S+dDvXvxmxRibUUXXivNszttpcHTJs7ora0P5QWrwLd/8nQnKMVEW60fzz+Vm4OuGy
         Ir5N9LA3GpCbVxE0zGlub3Xiw/dxEhVXCv20dgS1llXgtwwkT7EsQ1Av6TN+GvJnFBjT
         ReVq/V0yKIVTSwitJeCmsjehgaonIY9IlJ8eNJDAKau6uwuJ/3+fcn0YmUn4qT/4mUqn
         tANjsw/HohhCI6F5Kjmolxj1hEpfs8c7gjMjc+0qZM02bArQQ5hn2DzbWZZrnA9lGnIK
         ksyKnL4jANE7y6GtCeWPuuDPh2xXwzDwNltL5/V4M8YkFl4b3XpVbkauxrhKnN8Fr15b
         W2Bg==
X-Gm-Message-State: AOAM532VqF3PljzTIUStUgHkSa052wz4kNMMfvCO/wkTt8Ww3Vp5FGvd
        7/8ZzEipoO9xKUxUqKW61p+RjVFr229RGrlby8TyKw==
X-Google-Smtp-Source: ABdhPJzRQzl8K/3M0uB4Gy1BOL0qXo4S9LDLwtYnf3xODXKZOoKSyv75E1AQ/hr3Ilb3wXtUqAVXg0Ct688vpTSKZSw=
X-Received: by 2002:a25:500c:: with SMTP id e12mr18963036ybb.30.1630958216940;
 Mon, 06 Sep 2021 12:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210829182641.2505220-1-mizhang@google.com> <20210829182641.2505220-2-mizhang@google.com>
 <YS5e4PGxu7tjiEBI@google.com>
In-Reply-To: <YS5e4PGxu7tjiEBI@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 6 Sep 2021 12:56:46 -0700
Message-ID: <CAL715WJBMe8tPX=Tch_v=LiGNjPZpCqQVZKM=8GtzaJ_6Q1bXg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] selftests: KVM: align guest physical memory base
 address to 1GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 1gb may not be appropriate for all architectures and we don't want to _just_
> test 1gb aligned memslots.  The alignment should be tied to the backing store,
> even if the test is hardcoded to use THP, that way the alignment logic works
> without modification if the backing store is changed.

Agree on that.
>
> I had a patch[1] that did this, let me go resurrect that series.  My series got
> put on the backburner in favor of Yanan's series[2] which did a much better
> job of identifying/handling the host virtual address alignment, but IIRC my
> approach for handling GPA was correct.
>
> [1] https://lore.kernel.org/kvm/20210210230625.550939-6-seanjc@google.com/
> [2] https://lkml.kernel.org/r/20210330080856.14940-1-wangyanan55@huawei.com
>

Thanks for the info. I will use patch [1] instead of mine in the next version.

Regards.
-Mingwei
