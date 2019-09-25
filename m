Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D469BD60C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 03:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403799AbfIYBS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 21:18:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40390 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390869AbfIYBS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 21:18:59 -0400
Received: by mail-wm1-f65.google.com with SMTP id b24so2295839wmj.5
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 18:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJah0kkG4miUt6Utvlp0eUqUN+b3DRc6TFSZSF0amYg=;
        b=gCXhZtDPKTcEo4P8RvCXBNhFdeDvW+0r6JBfLr1UEQ8fcpVeND3qzLpHcXrWsxHyxS
         YkJuw5IgwW0XtcQbtBbwGhzhg7saHRpKeda5OazvxYA+AhVvom2pjm1qjV7QqWtuVk46
         BByR0CRDm55BGmyAJXphPYMb/HnXLlaIuxp9c2PAqGvjkNKVriVOyxEGY7S/Iga7bkXz
         3Z44lP8CDhNosg6bUuOyv+imaxt1wn1h0mW5WF/ubFzZVCek2wENsJWEmLcXUSg/whMu
         sgAIEJTFKAJIyJCSHdU4i3nckBp/+f+Mr5BvLYfSAN8ItjicuQnFasC+n1E6xf3Y5Dl6
         lUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJah0kkG4miUt6Utvlp0eUqUN+b3DRc6TFSZSF0amYg=;
        b=OdbsrB1OKEh/Xkilv3AFipbF/+jruFcZKHZGV2pdA6HZsbPa70AQVYtiRSw06du7xp
         x18Cads+wyVmwPYz8IsUhwQ+AT9KXojivl563HJcegsCnV+8ilhjV/FZsB0RyaeTtwzS
         PDQf6Sdhku0UI2TyKZz/LiCjDwuWqz2AYh52B2GK2EhpUAFreCpdAix9qWMu0himCwRF
         Ci0WZZRJCEurO7UF47zh1+BrL6o5T6LxjmoxqGm+Lg4VRkxlVMWBhRxAOoqcceNlHS3P
         cn4348T1l7B0cHf8n40L1XKn0uDTfO/MEfXyE8Vc+K8ItDRxZunbUFXwlWsyJWXd9+bM
         9iOQ==
X-Gm-Message-State: APjAAAVcsOBQTgAT0c7CznnYwT3ysG4WUQPsDvob7xNDEa/s5Df+dGZZ
        ncs3+IHFQfpPoCvQw3ALV73DMFg+x3KeyUNXcy+OnA==
X-Google-Smtp-Source: APXvYqwVw0eF8Z2YJIukw8PJVG1tpY385Hh1kl+7dlMk28Atl0kMNMx/H5GkeaXFe6a9rwAuJXzRJ+62qYax/qh5kv4=
X-Received: by 2002:a7b:c40c:: with SMTP id k12mr4145207wmi.151.1569374336964;
 Tue, 24 Sep 2019 18:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190920222945.235480-1-marcorr@google.com> <20190920222945.235480-2-marcorr@google.com>
 <20190923200848.GK18195@linux.intel.com>
In-Reply-To: <20190923200848.GK18195@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 24 Sep 2019 18:18:45 -0700
Message-ID: <CAA03e5FN+qE=FmNqhXD1Qb5c-h-=mFtaO+SiHbxSnOs6sF4z4A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v6 2/2] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 1:08 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 20, 2019 at 03:29:45PM -0700, Marc Orr wrote:
> > +             u32 exit_reason;
> > +             u32 exit_reason_want;
> > +             u32 exit_qual;
> > +
> > +             enter_guest_with_invalid_guest_state();
> > +
> > +             exit_reason = vmcs_read(EXI_REASON);
> > +             exit_reason_want = VMX_FAIL_MSR | VMX_ENTRY_FAILURE;
> > +             report("exit_reason, %u, is %u.",
> > +                    exit_reason == exit_reason_want, exit_reason,
> > +                    exit_reason_want);
> > +
> > +             exit_qual = vmcs_read(EXI_QUALIFICATION);
> > +             report("exit_qual, %u, is %u.", exit_qual == max_allowed + 1,
> > +                    exit_qual, max_allowed + 1);
>
> I'd stick with the more standard "val %u, expected %u" verbiage.  E.g.:
>
>         exit_reason, 34, is 35
>
> versus
>
>         exit_reason 34, expected 35
>
> The "is" part makes it sound like the value in the VMCS *is* 35.

Done.
