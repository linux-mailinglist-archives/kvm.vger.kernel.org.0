Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE24AEFD7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 18:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436869AbfIJQpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 12:45:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44125 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436798AbfIJQpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 12:45:03 -0400
Received: by mail-io1-f65.google.com with SMTP id j4so39035627iog.11
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 09:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mr84690/VrdKCYVU3wU5jR1qpJ0datczjerVgnYlmfk=;
        b=GZpJWc+ZUyhxk2k8aCpdjdaGVya+IJfeStT6cguwzTa6HonQQDdbl5r8N0TQ5jM9SX
         7j4TntIE9Yj/flKceXzzPFvBK2YZ1W4/8BSubKi2N/6bbRr4JoB8eNvK1xrJ4tS5c/Q2
         t+vNAh7aMnq9JRBvhc7j6pZ0KVVA9yHdP0ULqwW403e8rl1tynYWEQzRBWabAZjURR2A
         TlGj6r6778YJytk3TD1kH382lqCnQ9rdas8+9/iG7I7GELZq9wFatdUWNxELAduZICLO
         KjjdNz7YIDhtldnWeP0XxL3CjEb5/G9j+2nZps1gZ6whpXPZJKIPNfrsCuM+Cs8p2O+t
         rV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mr84690/VrdKCYVU3wU5jR1qpJ0datczjerVgnYlmfk=;
        b=I806NS1vcb2uIMuCavS1R41rCUjGODHHI/+C9QuYrmQZDQdK+5/BQtI6p5RpwkyDC0
         uSFG/J2Y/3gbRIeLiy+5/SjjzYayv6qqk87LgC6U6boApOBcWvgjyVvQmWUlxKxhKP/W
         xmIn88sp3bJNNjSBIsr6ykBZOIDY5gJrHjB9rBCgxUwpFb1wEToJ0GbEMe96iIBNTSWU
         nkcaSTCzanKnvNG/LVkZC0a/NC0+MIe0W0v0WzeyY8nyf/8Umxc6EyqMcHIgjiclHcv2
         rhfBSNuQ2/Kx0SXC+rlr1awLeyJJkiwTFkTC+soc2OYcoaDHOFVE357FkfbmncGczID7
         wnSw==
X-Gm-Message-State: APjAAAXY4Ccvmor9AKfd5pzdoqEtjhaiV7hv5CEXwDsgQm8cKIECEQtm
        9T+/yu3vlc9Qhp7VG0diwsp0i4m97dFvNSWrC259WQ==
X-Google-Smtp-Source: APXvYqwEoV7CN8wybeGCA9C1ekaD7yQl/fbU0PpqzYSeA7DqbK2anfuE8r2MWKkxPM+BIcKo4kQweVeK5IEEw1LY5rU=
X-Received: by 2002:a02:3b21:: with SMTP id c33mr33384112jaa.54.1568133902212;
 Tue, 10 Sep 2019 09:45:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QWteHe8zCdXQVQv+42pMO2k4XvAbj_A=ptRUi9E2AwT2w@mail.gmail.com>
In-Reply-To: <CAGG=3QWteHe8zCdXQVQv+42pMO2k4XvAbj_A=ptRUi9E2AwT2w@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Sep 2019 09:44:51 -0700
Message-ID: <CALMp9eSkn-AqmR3anrDRYqpZ2P+uRe9FD_X=C=GJn-+vdunTEw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: remove memory constraint from "mov" instruction
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 9, 2019 at 2:19 PM Bill Wendling <morbo@google.com> wrote:
>
> The "mov" instruction to get the error code shouldn't move into a memory
> location. Don't allow the compiler to make this decision. Instead
> specify that only a register is appropriate here.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
