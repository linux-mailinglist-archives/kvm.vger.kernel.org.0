Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31699162D3F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgBRRnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:43:47 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:32804 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgBRRnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 12:43:46 -0500
Received: by mail-vs1-f67.google.com with SMTP id n27so13607608vsa.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 09:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQIAlNmI7W08fGBLJ8a40XEubTfALPEjkVY3EPcK8i8=;
        b=DBfeV+EPVF/OdPS4dmt6SMMWf/n+EVSILQlmkKqg7nNiDRjDl1cBSjpb7bUzC8qWYJ
         FWf8TzDYgjd1MUuH5Z9gCOPqjBYKRU/zmgWP/MKscmJQ7qywh/0RjOtkONkiU/wLfZf1
         edvN60ooEzjeZJZ6NI1Cv6RSMMdqOrC159s4gp6cse2ZtUYlZcDLsXr+KhoJVqGXTxd9
         i/ObzqU4HRVHBd6TUzc6hUL+4Y6xwVuvjXkJKE92CeF6oAGic1XDhwu8aNeAMrlSErIb
         ie4wUZAGSHGdBJPcYEyALvrrGB9GgpqJZfbknu/GofgLFa757y9vcIPfpBLpapE4F47J
         nBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQIAlNmI7W08fGBLJ8a40XEubTfALPEjkVY3EPcK8i8=;
        b=N1QQvGW9nQfbfrGJxJJIhUjB9vObZRkOputjlXjYlQagVkAq/IhwVbON7yMw9521Yn
         jHvYrhs0aS5RRXQdFEXMJR0qTjQWZZ9pDMfeugzFjE5E2RNjfOZ32wRTJ0ghVIYe//Nq
         m/MApP5vww46HVaubxZ2PdXCv/RHTA8EEdjcRlJPLSMPFDOZ/hKMAtVCdggAq0SGA00D
         ah90EEx2k+Vf6IG0F5344bnDcnVPUQw0wDNnFx7VAxRcHEo4EtGrKDIvXZhpmhRolZyy
         Yco4YpSjMm6mhHpXlIIrCq2XbEgQujmldDiTOUx4+tgF36/sCBhnRaqAjxL3x+xR6oEg
         ZAzQ==
X-Gm-Message-State: APjAAAWLf4nG3Ldx48v7eJMRNOgbNlCgpMvfSpu+iqK0II9ui8npO5sj
        whQuRESgdpKRXQMGhDyusgzceIMdhGuqks/eppOPqp/cRKw=
X-Google-Smtp-Source: APXvYqyZXSRbWJANMCLyt9XUg/xPmmzVI53d1TOFcfw0kYT/8c1T5C/R88IBY+Tp1wrUWiRvSORFvWe/+JU1zW7Rppg=
X-Received: by 2002:a67:f683:: with SMTP id n3mr11461516vso.117.1582047825398;
 Tue, 18 Feb 2020 09:43:45 -0800 (PST)
MIME-Version: 1.0
References: <20200214145920.30792-1-drjones@redhat.com> <20200214145920.30792-5-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-5-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 18 Feb 2020 09:43:34 -0800
Message-ID: <CANgfPd8BfWy=hRcM2or5sokNkJ4xSng2_CWwocA8E_C0Mvg29Q@mail.gmail.com>
Subject: Re: [PATCH 04/13] fixup! KVM: selftests: Add memory size parameter to
 the demand paging test
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 6:59 AM Andrew Jones <drjones@redhat.com> wrote:
>
> [Rewrote parse_size() to simplify and provide user more flexibility as
>  to how sizes are input. Also fixed size overflow assert.]
> Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Ben Gardon <bgardon@google.com>

Great cleanup and fix, thank you.
> ---
>  tools/testing/selftests/kvm/lib/test_util.c | 76 +++++++++------------
>  1 file changed, 33 insertions(+), 43 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 706e0f963a44..cbd7f51b07a1 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -4,58 +4,48 @@
>   *
>   * Copyright (C) 2020, Google LLC.
>   */
> -
> -#include "test_util.h"
> -
> +#include <stdlib.h>
>  #include <ctype.h>
> +#include <limits.h>
> +#include "test_util.h"
>
>  /*
>   * Parses "[0-9]+[kmgt]?".
>   */
>  size_t parse_size(const char *size)
>  {
> -       size_t len = strlen(size);
> -       size_t i;
> -       size_t scale_shift = 0;
>         size_t base;
> -
> -       TEST_ASSERT(len > 0, "Need at least 1 digit in '%s'", size);
> -
> -       /* Find the first letter in the string, indicating scale. */
> -       for (i = 0; i < len; i++) {
> -               if (!isdigit(size[i])) {
> -                       TEST_ASSERT(i > 0, "Need at least 1 digit in '%s'",
> -                                   size);
> -                       TEST_ASSERT(i == len - 1,
> -                                   "Expected letter at the end in '%s'.",
> -                                   size);
> -                       switch (tolower(size[i])) {
> -                       case 't':
> -                               scale_shift = 40;
> -                               break;
> -                       case 'g':
> -                               scale_shift = 30;
> -                               break;
> -                       case 'm':
> -                               scale_shift = 20;
> -                               break;
> -                       case 'k':
> -                               scale_shift = 10;
> -                               break;
> -                       default:
> -                               TEST_ASSERT(false, "Unknown size letter %c",
> -                                           size[i]);
> -                       }
> -               }
> +       char *scale;
> +       int shift = 0;
> +
> +       TEST_ASSERT(size && isdigit(size[0]), "Need at least one digit in '%s'", size);
> +
> +       base = strtoull(size, &scale, 0);
> +
> +       TEST_ASSERT(base != ULLONG_MAX, "Overflow parsing size!");
> +
> +       switch (tolower(*scale)) {
> +       case 't':
> +               shift = 40;
> +               break;
> +       case 'g':
> +               shift = 30;
> +               break;
> +       case 'm':
> +               shift = 20;
> +               break;
> +       case 'k':
> +               shift = 10;
> +               break;
> +       case 'b':
> +       case '\0':
> +               shift = 0;
> +               break;
> +       default:
> +               TEST_ASSERT(false, "Unknown size letter %c", *scale);
>         }
>
> -       TEST_ASSERT(scale_shift < 8 * sizeof(size_t),
> -                   "Overflow parsing scale!");
> -
> -       base = atoi(size);
> -
> -       TEST_ASSERT(!(base & ~((1 << (sizeof(size_t) - scale_shift)) - 1)),
> -              "Overflow parsing size!");
> +       TEST_ASSERT((base << shift) >> shift == base, "Overflow scaling size!");
>
> -       return base << scale_shift;
> +       return base << shift;
>  }
> --
> 2.21.1
>
