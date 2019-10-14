Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A08D6A12
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbfJNT0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:26:06 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:40272 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730590AbfJNT0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:26:06 -0400
Received: by mail-vk1-f195.google.com with SMTP id d126so3783076vkf.7
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 12:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C/s6KdZNibn5V0uyFbOyMDyxwZ7eifvVTCft+jIYQak=;
        b=TwaCZChePz534KDVZjY4hqulYkI3QHU0NMd/IK5LaMCLbku9J20Up6hKz8bVMn6poK
         k92wePHx/OD70CoXrJpbJvjUHieJmCWyP9lbNg38yMy1hSzf3YtOslXQISD83UrqmLJw
         8cpx3xFJeQJbU6Kooe1yH67W3nUzUmJZw2F9ILCAKO/8vV8GRSbZbdiJayj3l+fhXGdx
         KbMCJELgfVpGJsUIP1WCn0525sm7Vbx/yLoiFYMq+QDlQW1qs/P+Ma/8OKtYYdfruRu8
         oTio9jXI+SVjWuwv0QXaLPjS23TM7U0y5uqEBe7U+Ca09gzRmyiE457Sp1cWkA3nJ9jT
         9tUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/s6KdZNibn5V0uyFbOyMDyxwZ7eifvVTCft+jIYQak=;
        b=B++WoNNUi9UvNdqCw+65/YAtKQBzAMSHSGVZrXnL7fzte16+GLs39Xf16pmN1B8b2i
         ZrNUeBJjwwJ0rzWuEWBmEWnCItJQ7apHaAVqYZPkDyJ2AAX3Jmy6PHJgMDzur1xWycZ8
         yw8lhuv0TfjnX8ZAF3gy9yyHgHVBFGODzwq8+iXrP2kv24F8JSrsZEaSFpj1wnb2yi6Z
         1/OU2AIa9MiN219oWrZZpNoxpwiNKdg9LwJAFptqrM6OwBno279p9xI7A3MmwmyxU7oT
         azRSEWP3+PCyr+3HvZhE74M3tUnxjR8Xu8saqyNrZYUcsdGl281d4UBgNpPnLW5ozm3T
         GGkg==
X-Gm-Message-State: APjAAAVjDbmu3I2xfKpSRibKBdqcdnr2dZ3QctHm6EyQo14WMSq4cxOr
        CKhhb0gDNgYGhWWyNZmGogg0syjxRt6uOLGL4eKFjoM=
X-Google-Smtp-Source: APXvYqxWb7kGfCqwxYwM/yGKWXtdQc3wUma/zt1ZVO9gDp7hsklgnONnueizt0cpKEUZ0u/9BTJhPXQBsFrdwZ4dR8o=
X-Received: by 2002:ac5:cdb8:: with SMTP id l24mr5944595vka.96.1571081164478;
 Mon, 14 Oct 2019 12:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com> <20191014192431.137719-1-morbo@google.com>
In-Reply-To: <20191014192431.137719-1-morbo@google.com>
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 14 Oct 2019 12:25:53 -0700
Message-ID: <CAGG=3QVuCrD83TcfeaqJFCTgvx36V4gc-VuCoaMDOgB4EhH0EA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] Patches for clang compilation
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Crap! I used what I thought were the correct command line arguments
for "git send-email", but it didn't add the "v2" bit. My apologies.
All of these patches should be v2 for the originals.

On Mon, Oct 14, 2019 at 12:24 PM Bill Wendling <morbo@google.com> wrote:
>
> These four patches fix compilation issues that clang's encountering.
>
> I ran the tests and there are no regressions with gcc.
>
> Bill Wendling (4):
>   x86: emulator: use "SSE2" for the target
>   pci: cast the masks to the appropriate size
>   Makefile: use "-Werror" in cc-option
>   Makefile: add "cxx-option" for C++ builds
>
>  Makefile       | 23 +++++++++++++++--------
>  lib/pci.c      |  3 ++-
>  x86/emulator.c |  2 +-
>  3 files changed, 18 insertions(+), 10 deletions(-)
>
> --
> 2.23.0.700.g56cf767bdb-goog
>
