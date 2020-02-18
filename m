Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A51B162CDA
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgBRRah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:30:37 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:33597 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBRRah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 12:30:37 -0500
Received: by mail-vk1-f196.google.com with SMTP id i78so5778778vke.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 09:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhFXEWToL9NZFDZTLGFH8pwPABlFQwdocjpplgbX0bU=;
        b=KcxO/cBxZa3ZP0+4kBWOskqmcJcKFLM/PfrzmjdSDJDZOKbN0WmTKpB3gSUnPtTZKq
         BcQ8HkDSUG/kabhqUsuvI2PLFgsbtMkRObMy+3DtsUwX1VewacFkZudi3iycSu1hNQ10
         DhwgqehJEGH/4Yw9uKON4ROXxY5LHR6f3OTAlhMh/OqKNjDoeBDm7GHrZVUT02jRYGt6
         FE3kdNufUQUvCWfj5CG0jYOa2nIabZLsANsTC7+8G9ohdEBC8Xf7sq7BBLwxXU2vmwB4
         BhSFW18yFjDH2lDIDuSFPpTFgWth+/0yIliFge2gtyZOt5Ou6f2XjL8uG7/L6e/scy8C
         YG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhFXEWToL9NZFDZTLGFH8pwPABlFQwdocjpplgbX0bU=;
        b=ZgZGgYj+7O7cshvVhLLqA5q8gJSNtFFZU0djxsLt8CiQyFS9ixfKuGX8RAiGRsYyVp
         mJVGybdm+91NxC03VA3ZNjJFMVs0zcbfNi31nrdRvRokD5RdVFagb3Njv57L1UBXeprB
         n4NQnKzVDnC35UPld4/r36t6t3vHOoJuQ837r/JgA2Ad7Pq3exdVZsCZkvf+rTzqv7jQ
         o4H+Wiga+Zsc/OJ7U1NTnytkbb7AhoT8i5SZLD+OUIDoszJE16u9awMlD7FzazoVXe6B
         1H9PaB/kVh/qLYKpKzx+VLFb2aux+e61bgyj9AMbUmB6zUfvK6ghvu8TSDWHxZFCJrIn
         dovw==
X-Gm-Message-State: APjAAAWGZO0JxpxH/QIpqZqbJ0HEcdADT345Bi64R8hD7r1Gek467oh0
        /pZFvTXg4/h8zHVqE6W5Bvz4w7OwynLMEgncNdezuQ==
X-Google-Smtp-Source: APXvYqycg+gGAQ5XTx8731R3Z2p7ocGvcOB+flHMbYLTmvUJb+djYiPnd4KLU3hdQsQIbzCCPYhwufR0wSsO0O+Q+HQ=
X-Received: by 2002:a05:6122:40b:: with SMTP id e11mr8807485vkd.21.1582047035970;
 Tue, 18 Feb 2020 09:30:35 -0800 (PST)
MIME-Version: 1.0
References: <20200214145920.30792-1-drjones@redhat.com> <20200214145920.30792-3-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-3-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 18 Feb 2020 09:30:25 -0800
Message-ID: <CANgfPd-zr3joOCAmW4a0MO7MjYTowYv5r4wxAMo7ddPhhumssw@mail.gmail.com>
Subject: Re: [PATCH 02/13] fixup! KVM: selftests: Add support for
 vcpu_args_set to aarch64 and s390x
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
> [Fixed array index (num => i) and made some style changes.]
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  .../selftests/kvm/lib/aarch64/processor.c     | 24 ++++---------------
>  1 file changed, 4 insertions(+), 20 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 839a76c96f01..f7dffccea12c 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -334,36 +334,20 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
>         aarch64_vcpu_add_default(vm, vcpuid, NULL, guest_code);
>  }
>
> -/* VM VCPU Args Set
> - *
> - * Input Args:
> - *   vm - Virtual Machine
> - *   vcpuid - VCPU ID
> - *   num - number of arguments
> - *   ... - arguments, each of type uint64_t
> - *
> - * Output Args: None
> - *
> - * Return: None
> - *
> - * Sets the first num function input arguments to the values
> - * given as variable args.  Each of the variable args is expected to
> - * be of type uint64_t. The registers set by this function are r0-r7.
> - */
I'm sad to see this comment go. I realize it might be more verbose
than necessary, but calling out that the args will all be interpreted
as uint_64s and which registers are set feels like useful context to
have here.

>  void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
>  {
>         va_list ap;
>         int i;
>
>         TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
> -                   "  num: %u\n",
> -                   num);
> +                   "  num: %u\n", num);
>
>         va_start(ap, num);
>
> -       for (i = 0; i < num; i++)
> -               set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[num]),
> +       for (i = 0; i < num; i++) {
> +               set_reg(vm, vcpuid, ARM64_CORE_REG(regs.regs[i]),
>                         va_arg(ap, uint64_t));
> +       }
Woops, I should have caught this in the original demand paging test
series, but didn't notice because this function was only ever called
with one argument.
Thank you for fixing this.

>
>         va_end(ap);
>  }
> --
> 2.21.1
>
