Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D2E23C704
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 09:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgHEHfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 03:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgHEHfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 03:35:40 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F35C06174A
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 00:35:40 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id kq25so32342367ejb.3
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 00:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=37y5rUKhu0jpnEUDKpCx4KGZtn1fERr8MCrbljhNVSU=;
        b=plvOlgjuWtB/0cSDvYuoxcQizdObfz2j5fPDg9RRE98kRmuv75mZPzixlxKGsE/vxl
         R1aR3BwyGM/zPCWWeYplrNK0kxJFo0Zjoy5M2TsNmYkZds5TY1rdEpd9ToTvyzAloRgD
         w0ub1dLH54ce/lqia6c4ko/0wiLd/fRqE8FE1oTSGuDycj3YGShwnwBEDv+f/ki+/sSY
         WbUBnJ5mtb0IBXbwlEOFkwfcLGQkEFLOy68e959DFGjZ9XJ/naiiMUHB9E5d4BPundMQ
         8PQGJUA8kTKB5UEAo2+frvjLL7kDnA4AaK665ShZpV8jwJ2VAx/prIv6sRBfe9++2J5g
         nJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=37y5rUKhu0jpnEUDKpCx4KGZtn1fERr8MCrbljhNVSU=;
        b=BIaxjHKLMz+yP7S8ljOqEap8omOIUEdNwQPJ1urfsQnzB0iGrT1FhZN0zPZSkJz5b7
         9RU3gPaiXgQZbl9llzsn5s6q1Od7VsqpAe004C+F1OsSy+AuL+NRCd0x9xWHvJQPfZL+
         e+9vgIrjTtFj8itDF58mKhX6f880n5Te/hLosNodzO00egzY1WNdAhafN60s06gsWddR
         UyTgC8GgbOIL6ssUiXoJPQ1+PmiQf6vZac3FV62q4YH6VPdo5+LR8uwXFBIfpxH3epzU
         2ean3P1ShA+ihBHO5r+l0DSN/5/zWGgoFR4FP9DTbxDbq6os46JgHeRImHMf8sUp+KN3
         Uteg==
X-Gm-Message-State: AOAM533TUAkxYFkP5jYP2rk4O+T2m1kaOndR281k+/aLZDBeM5hotSRw
        +RkAn6FylvC8laO0RYSQofo3VOjpItu85uRUo2snQA==
X-Google-Smtp-Source: ABdhPJyNHRykW4G8roUg1AB6bhuXOJiMYm2C6e4ns2nnzfWDIJZJCTkz/+HcdjZGQoyhsexRUHSgSRAb9OWCKDfmrQw=
X-Received: by 2002:a17:906:aed4:: with SMTP id me20mr1992074ejb.141.1596612938875;
 Wed, 05 Aug 2020 00:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200717125238.1103096-1-arilou@gmail.com>
In-Reply-To: <20200717125238.1103096-1-arilou@gmail.com>
From:   Jon Doron <arilou@gmail.com>
Date:   Wed, 5 Aug 2020 10:35:27 +0300
Message-ID: <CAP7QCoju_-pgUJZAoHoFgrSb_H8LeBQNxzrf66iNxoxGGv7grA@mail.gmail.com>
Subject: Re: [PATCH v1 0/1] Synic default SCONTROL MSR needs to be enabled
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Kagan <rvkagan@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping, can this patch please be queued to 5.9?

Thanks,
-- Jon.

On Fri, Jul 17, 2020 at 3:52 PM Jon Doron <arilou@gmail.com> wrote:
>
> Based on an analysis of the HyperV firmwares (Gen1 and Gen2) it seems
> like the SCONTROL is not being set to the ENABLED state as like we have
> thought.
>
> Also from a test done by Vitaly Kuznetsov, running a nested HyperV it
> was concluded that the first access to the SCONTROL MSR with a read
> resulted with the value of 0x1, aka HV_SYNIC_CONTROL_ENABLE.
>
> It's important to note that this diverges from the value states in the
> HyperV TLFS of 0.
>
> Jon Doron (1):
>   x86/kvm/hyper-v: Synic default SCONTROL MSR needs to be enabled
>
>  arch/x86/kvm/hyperv.c | 1 +
>  1 file changed, 1 insertion(+)
>
> --
> 2.24.1
>
