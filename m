Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F54AEFE2
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 18:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436928AbfIJQrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 12:47:09 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46066 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436758AbfIJQrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 12:47:08 -0400
Received: by mail-io1-f68.google.com with SMTP id f12so38979079iog.12
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 09:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bhj2dAEL14tgQBLU9bi11A5Ag1I88PDnkCjV+QOpGLc=;
        b=jAFoo3ISAPrf8rORvsc/tqLx4v7f9EkZmjtjIzLBgcPSeOETxgVNYWFOhdtZUHIwhT
         GaL3yvz5XaRhkOeirk5kMgQecQeP0meJU2ElIrYzq2wn4RntUvMFAb59tPKIFTnHQOPt
         6WdHT6Skh8YRCQXUq3EOrcdiSTCi2MxEbb45QIorFQ1FTOU6Ar1WIgXFcwYHdEaqr3Cr
         II0Wx+FoTNtm3IxkUYpGA5XHQBIuBFiRa9Lv9VpTBhMUdC7lfxdmexLlBdZBHDwRGz25
         DjxE7CEYXKvfwsMSTUdRvGgG8XP/tvIZmjmLXh/MU3fJVjnCzWn3nrhMNgTdubmt8luJ
         UGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bhj2dAEL14tgQBLU9bi11A5Ag1I88PDnkCjV+QOpGLc=;
        b=pUwxkwEd1uPJ6tc1JZFrWXm+lkXgkCAx1OfziOdt369W7b4pDBXlj+gGiXHW36cP7Z
         5mPq4e78fpZZBXeZtT9iT88wN76QFBuE0O9/2uGJz2o4DUJDj9oVWmxt/A6S49yuayj4
         fwr1Tb2yyJpU2n6wWU2b2nJSptwb0aEOJtErxKWYaigtXH+H4I4uZwKiRz31VN7MD957
         QJQYPCnOw1OwdOqqDefTNRoJ8tPg8Nht8l6VUhMQI2IKmMDyYYr5fQ2uCC6GvW3N1Zrn
         q4lx5irYR9qiQp8zQWgZuhzTEQ+Ose5Ea1VzwAXDIUB160eph8pc1g1Nr/3GaL2CwWoR
         V3ng==
X-Gm-Message-State: APjAAAWew8sKdWjpaA/4Mu46SHWF/QBR/Pc7DRqN2rCXrRbgVbSGYRBR
        lI9il9uuHuyC16QDqsCWbil5aps7vkuG7u8F6m1iiA==
X-Google-Smtp-Source: APXvYqzeuy5jFKRj3Kg8yhi/YCnmkt0zpaZoKi+xgm/5Z9s0QwrO+T8K+n64Dw99w9Oj0jTCIv2MDSqUQ1deE3KC9hA=
X-Received: by 2002:a5d:8e15:: with SMTP id e21mr475603iod.296.1568134027405;
 Tue, 10 Sep 2019 09:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QUHwHsVtrc3UYhhbkBX5WOp4Am=beFnn7yyxh6ykTe_Fw@mail.gmail.com>
In-Reply-To: <CAGG=3QUHwHsVtrc3UYhhbkBX5WOp4Am=beFnn7yyxh6ykTe_Fw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Sep 2019 09:46:56 -0700
Message-ID: <CALMp9eQ98NM_E_TjprZOX7dmxGZGB=6tpUpntficfhYJm8i-qw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: debug: use a constraint that doesn't
 allow a memory operand
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 9, 2019 at 2:00 PM Bill Wendling <morbo@google.com> wrote:
>
> The "lea" instruction cannot load the effective address into a memory
> location. The "g" constraint allows a compiler to use a memory location.
> A compiler that uses a register destination does so only because one is
> available. Use a general register constraint to make sure it always uses
> a register.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
