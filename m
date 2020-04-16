Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E291AC663
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgDPOit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409657AbgDPOC1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 10:02:27 -0400
Received: from mail-oo1-xc42.google.com (mail-yw1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7BEC061A0C
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 07:02:27 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id x17so669985ooa.3
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 07:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bK7H8mZBC1M9jaa+zdop9zDdD2J3ilKiMpcnXRm9/wc=;
        b=S75OjJEUYpb6Z8Ok91mLrz3lPxofemMNkAQA1i3r6UhQPpDgwDrlfyGb/w8paViyEC
         rQZ0Y39Y1slvIdhcQTdZSJL1qwTFYQRRrjpkU8AjNAcAj1ncnYW9ndpkOVmqMKLRjE0g
         AWuGETJV2o92M9d8JNUDAjw1xnE0JRg1jV4awo8ocR3quYZus/2zojs8IYyEqXToEWwW
         NvKRf8jYYN7Y3M8mkS//cwpUH34XwsEiHhXEGb4O3YLXd9qp8tdGiInT74KWH25l+bax
         xtv701IBjfmMe9ma7ZFjukFwgas2g34GXpaxLXBPwkkY61L5/GraJPoZO+PacRZnvxko
         a9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bK7H8mZBC1M9jaa+zdop9zDdD2J3ilKiMpcnXRm9/wc=;
        b=ta0lEtvD0h+JUk/BqdoEKpo3o7Ay4/HIclWwkCdp2tmyZn3WT4bF/yq8FXlbZQHRl3
         CURfWrKsOaDnL6kv4nvPrxK+eKf2qz3LB6J8N0v3Hx8DnV69WWskF4O9sIqxuN0ZIcZ5
         OChz6+zfrPzK5K3J8MCScEmcl9ksW9cCKVl80dShm/h46khzZ63nAPjaM9c65ImmYi/u
         kBqZ/HsBQ94umoapnGn889dMXSTP0eS9BxkdYMfUCu22tL6yN0Frn3RMQE35EvRwP5V7
         H9lXyiMHYzf90nN7/PsMrx5TuqyEgXEXkhyvBmpAw9PGYLqs0zW7S8iw/sEAoQauQOVd
         peug==
X-Gm-Message-State: AGi0PubAmFoER+kewXINNcivkSefRxuEgP7/JxDv2sis2ucPa56Bp4KC
        6CSb6bUXrcjybdYSOez1UoDq/NxjQ89puSimSaC38A==
X-Google-Smtp-Source: APiQypJUJwn9q949J4jXdUe6aFPBX8YziM8R4GhLsgRIYP8spb1sUXkLRxFdfswJKyD7fWYk3R9w9fp+kZdyZVRdRGQ=
X-Received: by 2002:a4a:890b:: with SMTP id f11mr26704869ooi.85.1587045746654;
 Thu, 16 Apr 2020 07:02:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200410114639.32844-1-gengdongjiu@huawei.com> <5e9863af.1c69fb81.dbe22.5caaSMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <5e9863af.1c69fb81.dbe22.5caaSMTPIN_ADDED_BROKEN@mx.google.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 16 Apr 2020 15:02:14 +0100
Message-ID: <CAFEAcA_-fcGUKoo955jeHzNDDVTKCsgvH6QGqUWu0efAyth1rg@mail.gmail.com>
Subject: Re: [PATCH v25 00/10] Add ARMv8 RAS virtualization support in QEMU
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     imammedo <imammedo@redhat.com>, mst <mst@redhat.com>,
        "xiaoguangrong.eric" <xiaoguangrong.eric@gmail.com>,
        "shannon.zhaosl" <shannon.zhaosl@gmail.com>, fam <fam@euphon.net>,
        rth <rth@twiddle.net>, Eduardo Habkost <ehabkost@redhat.com>,
        mtosatti <mtosatti@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        qemu-arm <qemu-arm@nongnu.org>, pbonzini <pbonzini@redhat.com>,
        "zhengxiang (A)" <zhengxiang9@huawei.com>,
        Linuxarm <linuxarm@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Apr 2020 at 14:54, gengdongjiu <gengdongjiu@huawei.com> wrote:
>
> ping....

Hi; this is on my to-review queue, but so are 25 other patchsets.
(I've built up a bit of a backlog due to concentrating on work
for the 5.0 release while we're in the freeze period.) I will
get to it eventually if nobody else does first...

thanks
-- PMM
