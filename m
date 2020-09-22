Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4402744C6
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgIVOzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgIVOzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 10:55:05 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501BBC061755;
        Tue, 22 Sep 2020 07:55:05 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id u21so23373072eja.2;
        Tue, 22 Sep 2020 07:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gl5ZXaZZ9fFMo8zIy0Ez6Sy7ZC3ZaHBolK1ZtfIsQ1M=;
        b=MITmrFgBfmfYhmnGnMZGY2k0h3KBiqya6FX1qg6lLXkJHFeon70tFYOkIBYQuX/ek0
         SDdzhd4zicKnUgjB/Pj7uKYWvrf8GP8Jy+IiBTbFZy2t+aW4WaadmFqHhtUGf1Pz/1XU
         QLsUjySBl5TgDiVlbkzww0qA2NZZtWHMhNNn8eWcc7XgkvIqxxk4ZogpWTOzgbbTHaya
         kEDsIAaLE9dtmaFpmdYtmXx2l8AtkZ9RyIrl5qw2BXW1bqckbNPEyvE7193IYZO0yzBA
         xFRRdI63czmhG9GIq7jNRMZ5szFLHkCQR6DyNoAlqo/ddw4N63Mi3daas2BWohMWMKKy
         a0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gl5ZXaZZ9fFMo8zIy0Ez6Sy7ZC3ZaHBolK1ZtfIsQ1M=;
        b=SYvHMfdrQxE9Ns/jsz2uvkH/heYrGGvyzezQkDQ7dv8RJQ3lj5+UTvVcOHCaWVuMKt
         XDENd/ZvZD/BnfxdOuQi6OnK/FGkucTKCv3S03AFQpn2nKQWNBHQYnpHOyhczft+yX9x
         hL4WR76AdmlmludPzTqdo2n6/1q6IsJM5oggA35TlHC3j/Dk45RsJyLfOtYn1Tbb6jsc
         DkaVZ330j+nDcDzcLpnBeXF+tNUcaSzcX+2TZV4nPNrdv7sPansRCtTD0gsEXDgW/nJ8
         2d3aXKjnLxyRymI1PsBRDY6n6LilIdUc6xqqorjFleZSmwXvB+Fu4PoVt4AVHr9+3IyO
         MCVw==
X-Gm-Message-State: AOAM530mJx5LIJXjJRyrPKH7NAY8dTN7Nq2AJzuP6VOiUdFS1ktImh8l
        X/n2oj+sN/7bjBrv5ZM+dEpQZLYUkMOa8CFJmA==
X-Google-Smtp-Source: ABdhPJz5+TK8TkZ1Q9qcax0p9/fBtRJTu3E2QxTRf+03Q3SU5LceAUYh/1HKxXDiVDlMJY9ngdRSbJMQzs7JQnUf/dk=
X-Received: by 2002:a17:906:7e42:: with SMTP id z2mr5323385ejr.206.1600786504001;
 Tue, 22 Sep 2020 07:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <1600066548-4343-1-git-send-email-wanpengli@tencent.com>
 <b39b1599-9e1e-8ef6-1b97-a4910d9c3784@oracle.com> <91baab6a-3007-655a-5c59-6425473d2e33@redhat.com>
In-Reply-To: <91baab6a-3007-655a-5c59-6425473d2e33@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Tue, 22 Sep 2020 22:54:52 +0800
Message-ID: <CAB5KdOaV81ro=F8BiuFfR_OWrY1+AJ4QngSOXOZt7vH_bXPR5A@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Analyze is_guest_mode() in svm_vcpu_run()
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/9/22 21:43, Paolo Bonzini wrote:
> On 14/09/20 22:43, Krish Sadhukhan wrote:
>>>
>>
>> Not related to your changes, but should we get rid of the variable
>> 'exit_fastpath' and just do,
>>
>>          return svm_exit_handler_fastpath(vcpu);
>>
>> It seems the variable isn't used anywhere else and svm_vcpu_run()
>> doesn't return from anywhere else either.
>
> Yes (also because vmx will do the same once we can push
> EXIT_FASTPATH_REENTER_GUEST handling up to vcpu_enter_guest)...

Hi, Paolo

I have sent a patch to do this,

https://lore.kernel.org/kvm/20200915113033.61817-1-lihaiwei.kernel@gmail.com/

Thanks.

     Haiwei
