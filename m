Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D146B2E0
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 02:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387781AbfGQAaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 20:30:14 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39785 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfGQAaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 20:30:14 -0400
Received: by mail-ot1-f67.google.com with SMTP id r21so17067007otq.6;
        Tue, 16 Jul 2019 17:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MCQzjwUfSJg8bVO8ghpSoCJiKJHXzfZqPvw/ahHwNPw=;
        b=r8RkSqE+qR7LaYol52hD5Dvfbz30XMK7h8IO7ZYcUatnZjYqDyYB9knIneCuG34u0u
         Q+tnanwGyUBGo30K0/kfsaOThbM8D2oERf9Gb+h5rZ9M7LhehsO4yPxSRVWJRxgtxGnN
         h9N6G/3dfhWNIHvqwdM+VgQKZHBGB4DP1LC1uU5DbGDm0V+X7xegwK7R9uLvsOtQVprn
         Ew1cclbTrx528p9yWGPAZoZrH/vJOphp9OMpEES0kZFY6b1eO2GKJkjDkpsGor/B5L/L
         1XNdnHmga/qB1T/PZbAMMfT7gLKrShkpzMj5CL7/a99AI1lDIXBGuedjDN5tA7BXRNK5
         S5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MCQzjwUfSJg8bVO8ghpSoCJiKJHXzfZqPvw/ahHwNPw=;
        b=sk2tuUJtJzF3qKgzLw4IU8bikJUALF4dCKQnsn9wQF3VtA2vg6tbsTZgiZh0bWorvd
         ifaRhsO+Nr5lm6wqgSzalsgYOXBUYFtiNzRGqfLbqMjpvxLS3rFMdOmfqGHrzTVmvy2n
         XpuEzJRR0em3eMvhnkw7W3a2h8aE4/exq3xMl29hV2/rTedg26YStwTp3kL06fr9+OO2
         YA22HUwP3mmXnPIfE3LWE+AaoBi25lkphzCXgUhiotU6iFdyCwU85SgIzPSbp+tX2a+p
         jqlqIRwN5gJvZM76grvuWp1xqB44sOLcrcRuoZi8itGmf/8Whi5R8Yal4mJiD6Zjo2ou
         HZog==
X-Gm-Message-State: APjAAAUpAJBgRTdDpuAcCwEFXJyxsw1gkV2efuWntW40x/JTJqWeQbBG
        82IrDW8iea95JzuSbg5pL10vJYzvbC8kitVuQNoJEEz8
X-Google-Smtp-Source: APXvYqwQuNZFZzhUZbkicKvWjEpcwSqJAVFAEJ9MRYLTYpXpNAERa2KheVR2ATM+eFC1fFJ24NlNJK8RLN6Zt/a/5BY=
X-Received: by 2002:a9d:2c47:: with SMTP id f65mr27751467otb.185.1563323413251;
 Tue, 16 Jul 2019 17:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
 <TY2PR02MB41600B4C6B9FF4A9F8CD957880F30@TY2PR02MB4160.apcprd02.prod.outlook.com>
 <0e05bac0-af49-996a-c5fd-f6c61782ae4f@redhat.com>
In-Reply-To: <0e05bac0-af49-996a-c5fd-f6c61782ae4f@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 17 Jul 2019 08:30:07 +0800
Message-ID: <CANRm+Cwi33d5LCNu0JTRkf1W5dSVUOOfqo+QGYe=pd0i=vRXzw@mail.gmail.com>
Subject: Re: [PATCH v7 0/2] KVM: LAPIC: Implement Exitless Timer
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpeng.li@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 at 22:05, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/07/19 15:50, Wanpeng Li wrote:
> > kindly ping=EF=BC=8C
>
> Sorry, I need more time to review this.  It's basically the only
> remaining item for the 5.3 merge window, even though it won't be part of
> the first pull request to Linus.

Thank you! Hope finally we will not miss it. :)

Regards,
Wanpeng Li
