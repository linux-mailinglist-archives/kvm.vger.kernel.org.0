Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8FE6C00F
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 19:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfGQRGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 13:06:12 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42791 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQRGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 13:06:12 -0400
Received: by mail-ed1-f67.google.com with SMTP id v15so26663246eds.9
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2019 10:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqRiai2NJzbl478864ihbvO7mDzvRYyxi6L9Xd1nSoU=;
        b=cn7NkKA3TYW3chAN01hNTYlkhLMoS+Ytj/wl7TOUnm0KlG4EzrMhSN+wmKSYYDdlP2
         OHyF4Wscjc9VDQ4bhVgnlogOhmb46AXO6/20COw46KcwqlNjvWDLMyNquJyETvoUKeTn
         ebyvnnaUmuJaq4DzQjIhvShc0JDB152VD2JWWjJbwMg8V+dk7LIMLR/S0FW9KyzOy9nJ
         DDOpV4fpD13s56kSSfsuNzGf5K0CMm/l9FryY8bx3WlTuGNeb97xBTUdoPvpqZK9XP64
         YOEDAqynD0o1ohPufEjS6XeqNT1+njqoFnDgFsIG5n4z/Uv9Hr4D4r3y8OQ0L2YiD52A
         ORnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqRiai2NJzbl478864ihbvO7mDzvRYyxi6L9Xd1nSoU=;
        b=X7gRbQQOyHivbdGNdByoNRKuW+5rweTSVzG4Whh/y0KoxXB+EZxlnbiy8kAqkyS5wf
         i2jF/Iu46PlNUmetYvXEWC+x8zufVoWOOeolitEiIyiBxCO6LhKVVRUsAfaPYiH08jG1
         ua0429aFTyLkgOdnsTeluKuWlozXXP1921/A0Frcrp569MvnXkwNiCUQ6qzql65qEWBm
         s6FGeM2HZH5IkzJhBo7hIq9NVKXqpT6R9dUAXFxJK1UKAVdsiAFSvGhw+r62Of51FTDQ
         wh1r+mCeHDAav6rxZJOf5w9ZjaF1qs+UIZNt+hAP8ptzUQIIj9Oiozb7ljM5QKcLk50L
         gaaA==
X-Gm-Message-State: APjAAAXwXeYv8j+LH9iAK0nuduA66UZHMyhYaJIINUL14lpE1P7r8BER
        oBS9613g7C1j0ayBq/eEtCeP5AGlbN5TmCknubvZ3w==
X-Google-Smtp-Source: APXvYqyuPkk92abvhI53/TOM/mm3ikjhWvXpFz620iJmZad75QkfN5sxOkoYTqcfXhuFY7+wJL5g9tLZdEPlmUSUpgU=
X-Received: by 2002:a50:f4d8:: with SMTP id v24mr36359671edm.166.1563383170245;
 Wed, 17 Jul 2019 10:06:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
 <5D27FE26.1050002@intel.com> <CAOyeoRV5=6pR7=sFZ+gU68L4rORjRaYDLxQrZb1enaWO=d_zpA@mail.gmail.com>
 <5D2D8FB4.3020505@intel.com> <5580889b-e357-e7bc-88e6-d68c4a23dd64@redhat.com>
In-Reply-To: <5580889b-e357-e7bc-88e6-d68c4a23dd64@redhat.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Wed, 17 Jul 2019 10:05:58 -0700
Message-ID: <CAOyeoRUOqMmG6KkGXUMeK2gz8CmN=TiiuqhtVcM-kekPoHb4wA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: PMU Event Filter
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wei Wang <wei.w.wang@intel.com>, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Let's just implement the bitmap of fixed counters (it's okay to follow
> the same action as gp counters), and add it to struct
> kvm_pmu_event_filter.  While at it, we can add a bunch of padding u32s
> and a flags field that can come in handy later (it would fail the ioctl
> if nonzero).
>
> Wei, Eric, who's going to do it? :)

I'm happy to do it - I'll send out a v3.

Eric
