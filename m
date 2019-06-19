Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423364BBF5
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 16:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfFSOpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 10:45:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37776 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfFSOpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 10:45:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so9899347pfa.4
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 07:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8fT/vuEA7OU0dJVEYE3r7kPp1EiCp3ty74wiME2Ad6k=;
        b=EvIEznAc2XDTlXpBOjY12Pc2q1rIxcWk6U40JWRUJTQeG8doG5XM7cV9g4/aAvpAbm
         r3Vk1xob0ZSfzJTTT+FaHc9R0h1eLHkawgh+Y2HeR9XjGIs5zVJz5vVbm53lpriaFfb7
         WLyV/uAQNAYVDSY/FjIXmEn/qRI4X4yYKhErVQMtfpicAASkyevJQubb5nypERO8S2Td
         5b/ik5O20WuHwXvtTFgmOoa0CziwFqCIOtcjre2VZ/5fgyUl+9VVN5r0dUvXPdBUWYAX
         74ptz4qqjfqvUzObFkRm/Ek6sICgg7UMvCYbjzj6hCVv3sQaFa6vMFhwyadaNP4W/A/J
         GtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8fT/vuEA7OU0dJVEYE3r7kPp1EiCp3ty74wiME2Ad6k=;
        b=BpJdrGOtjM86K8W2ldcmuH0KvIDcSDwNvcXThh3+pX0qM/WUK27jzCkCfi62a31MYL
         UPjt39MygOKCUWP02EwxsTjsUHmA4U/mH/wy49Xv1FC8DArHn8rxS8ugiDnankx0qJZR
         Zm+8YDbKx593Y423hUSoiYxLKUvjWO1l/51bAEJndf+FJQov3QXxphl0YrZ3x7Iv7p8l
         sat7nCKOdKOCDCUNykeGZr+mzkoYrZzv5OrQbivJ126OMBy8Bpl0PDSQoFLeo7Txtp4H
         rO4GiAEJ0qSwkwe7mVzLDgHT5XiHINyI0ohWjngYZiptGr+4/osr+wcWeHcGob3MIENK
         uaqA==
X-Gm-Message-State: APjAAAWBEVKqdAbEopaM/C97CU4zIY7m0aSIlkHQBc8wKY+FqTPG0K5U
        A4f1xWtnQmdQfDZQsNlc+qXwz8A6o90KNRgrgOKj/A==
X-Google-Smtp-Source: APXvYqxml1AJCp6VXxhzIr0ScKXgidc4P55u7fkRG0uKH1TmixS7V2epvHYKLjz4L0moJR3Tz7zj8BeYkr14oUMqT1c=
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mr11521374pjp.47.1560955513903;
 Wed, 19 Jun 2019 07:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560339705.git.andreyknvl@google.com> <a7a2933bea5fe57e504891b7eec7e9432e5e1c1a.1560339705.git.andreyknvl@google.com>
In-Reply-To: <a7a2933bea5fe57e504891b7eec7e9432e5e1c1a.1560339705.git.andreyknvl@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 19 Jun 2019 16:45:02 +0200
Message-ID: <CAAeHK+xvtqALY9DESF048mR17Po=W++QwWOUOOeSXKgriVTC-w@mail.gmail.com>
Subject: Re: [PATCH v17 03/15] arm64: Introduce prctl() options to control the
 tagged user addresses ABI
To:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        kvm@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 12, 2019 at 1:43 PM Andrey Konovalov <andreyknvl@google.com> wrote:
>
> From: Catalin Marinas <catalin.marinas@arm.com>
>
> It is not desirable to relax the ABI to allow tagged user addresses into
> the kernel indiscriminately. This patch introduces a prctl() interface
> for enabling or disabling the tagged ABI with a global sysctl control
> for preventing applications from enabling the relaxed ABI (meant for
> testing user-space prctl() return error checking without reconfiguring
> the kernel). The ABI properties are inherited by threads of the same
> application and fork()'ed children but cleared on execve().
>
> The PR_SET_TAGGED_ADDR_CTRL will be expanded in the future to handle
> MTE-specific settings like imprecise vs precise exceptions.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Catalin, would you like to do the requested changes to this patch
yourself and send it to me or should I do that?
