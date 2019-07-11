Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6946865E23
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfGKREt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 13:04:49 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45579 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGKREs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 13:04:48 -0400
Received: by mail-ed1-f66.google.com with SMTP id x19so587734eda.12
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKtFz5m3SJUoyJfannzFhRIi22aRe40IcnDLShyAIms=;
        b=Xq/mB+cljDpLj6RZErA+YWYh1tWZ0TFRNucp2cHzuiS2f1eND6fu+H2y045styTbIQ
         fEoozXGqxKJKa5WX2kcEOXu2M3EP4FduHJAFh1I93u6CxwVCJEAi12pZVflzW6KTLwRj
         Qs8x8zvsQxqW0il6sR9EBgUvAlY1JJhQbbs2nvH/PWwbFTRfrVR1iJklMeQFGu467CMm
         /mDjhB25cexBd5RbE23MesURCjRRpLf/czUryrZqZB7b4ndKDkRu4vgvvWsb9mCANWRJ
         usWAwGxjpqz3fzvuckYa/HDH/8A4RLcgCS4Mk1ZjSHFtw/GyicdVAs9HklwJOM6O/5RK
         jIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKtFz5m3SJUoyJfannzFhRIi22aRe40IcnDLShyAIms=;
        b=gSuCgZfHTBufMg1upruBeECcrz1U7+uHJJNOpYXz53BwsrBmsVO9kupeay7IZzOdYt
         CUC1swSsvDfR3M9qr6HPiQHH3h2s9Gs6qxlOrPYl44Hrqa258hlH6PznV2IicFLXTxpQ
         veA51U5ARE1zY0DGKXDBFRVhLVvLG7uqBaUl7SZMWDEtIhAc4/vn0mJDBAixX1K0XspB
         5UU8ZJvkaYYsNCwKD5zJJvJIdj/N4KlZaLPBwCPoda6QuGL8x6IsC/5Un97sPco5Jrg7
         tGmkn6BrOiBb3hpB11hsZez5MmtDTdbtMYTE551+OdX/XCBi7dHicQBeqFj96H+yYlC0
         ahGw==
X-Gm-Message-State: APjAAAVn4IaiC6JgJ2qzvaYUHyp5DZ1gzasVx44FQyS1LQtm8hzm2Sy2
        9Kf0/kI+3VKqrcAWlw9+l6xU4oAG9BHd/oQnxd6F0A==
X-Google-Smtp-Source: APXvYqxYzE6AJdtimx3a2ee2fT+IYR4+blay3RGcsdDJWNPR7KKVyMnhBzG7emI231/T9nrCuC3b9cIey5cO58MJDd4=
X-Received: by 2002:a50:a511:: with SMTP id y17mr4619439edb.259.1562864687272;
 Thu, 11 Jul 2019 10:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
 <21fd772c-2267-2122-c878-f80185d8ca86@redhat.com>
In-Reply-To: <21fd772c-2267-2122-c878-f80185d8ca86@redhat.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Thu, 11 Jul 2019 10:04:36 -0700
Message-ID: <CAOyeoRVrXjdywi-00ZafkVtEb_x6f5ZEmdMqq6v67XMedv_LKQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: PMU Event Filter
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wei Wang <wei.w.wang@intel.com>, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for your help. The "type"->"action" change and constant
renaming sound good to me.

On Thu, Jul 11, 2019 at 4:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/07/19 03:25, Eric Hankland wrote:
> > - Add a VM ioctl that can control which events the guest can monitor.
>
> ... and finally:
>
> - the patch whitespace is damaged
>
> - the filter is leaked when the VM is destroyed
>
> - kmalloc(GFP_KERNEL_ACCOUNT) is preferrable to vmalloc because it
> accounts memory to the VM correctly.
>
> Since this is your first submission, I have fixed up everything.
>
> Paolo
