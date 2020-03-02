Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720471760A2
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 18:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgCBRBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 12:01:43 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:33775 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgCBRBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 12:01:41 -0500
Received: by mail-il1-f195.google.com with SMTP id r4so153861iln.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 09:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qxBd2/UPs5vf4LaxUj5TjDTWVmNZ1aU9EeZ4ieRPNr0=;
        b=vRxxEZHP+PcGuqWY+XHCm6VavLlu2hAfuoiI+iQedKrK7r1wdvYqIJljxbhdgYvyY9
         DCqy+lZCJdDxI9h+Uk+JYi1Nlceqz94RVdcbdcrvbKfCuN9ZrEGzXZ9JxZ4JB4Iwh63L
         3vsaWFiF7k+8i0nJCGrU6w+TjAqwKSOE60vDaNM1FJdZDgWX+jWkiNunAjwRzh8F7g0q
         oFFt27a4qbZbUoHpkCZBwMDjVdKzUcVl37nOju2Ou6/OzSskvFPHie07cLsvxlcEDuBt
         0q1WftFL6RFvB6SDj5Cg1cQsMkm9eLUlTKCOqbUWGy12kVGwD0E1/CqNwQzEg9ic1Xr7
         /yYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qxBd2/UPs5vf4LaxUj5TjDTWVmNZ1aU9EeZ4ieRPNr0=;
        b=ZCkMy/pwzPvPxZrotSfWK9f5MrINqJBgsjPerqURAjWGeM1mxPtw8o6UQapAqMXWtA
         vkZfj6mOOMgidLP1hYIMIIn8rlfUNdKfE8dQXqjGHvyhGCIhmpDACXE+qGnLe600IqWc
         zGrCT2U95pV4635n6PEVU6OUy81QWEbCGEr4nniCGhrF1FTIeQ+UUV8cpPxdiYfywIsf
         QgwpP9h5qsW7K2dweajQe689j2OJ0ax7YcTnPVU7O9/0roP57M/cqqVbEjXZ6mrbjROm
         ZaxDkNhI7F7oIKK/07x7A/dC9BgrPAMqvQv3hFVRqR0zjyQTsP2R9EIDlDKHodZm0jg/
         CT6g==
X-Gm-Message-State: ANhLgQ0UtuGotge1uw6mqqPAYSBScpsiEPcM1n1094Gzi/FbojQr9tgc
        BmOp7r1EJhDLCwfGIZHbfQr9ISJUi2DAz3dR3n0iPA==
X-Google-Smtp-Source: ADFU+vseY6BhGkCHYlyct7BltEijotjEZ5gYChfY0KqvAR4ZvWW7s81Gs54Im4NcVW30zcggWbg7iXYFPhswML/2lP4=
X-Received: by 2002:a92:8547:: with SMTP id f68mr616024ilh.26.1583168498999;
 Mon, 02 Mar 2020 09:01:38 -0800 (PST)
MIME-Version: 1.0
References: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
In-Reply-To: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Mar 2020 09:01:27 -0800
Message-ID: <CALMp9eSaZ557-GaQUVXW6-ZrMkz8jxOC1S6QPk-EVNJ-f2pT5w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 7:20 PM linmiaohe <linmiaohe@huawei.com> wrote:
>
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> When kvm_vcpu_ioctl_get_cpuid2() fails, we set cpuid->nent to the value of
> vcpu->arch.cpuid_nent. But this is in vain as cpuid->nent is not copied to
> userspace by copy_to_user() from call site. Also cpuid->nent is not updated
> to indicate how many entries were retrieved on success case. So this ioctl
> is straight up broken. And in fact, it's not used anywhere. So it should be
> deprecated.

I don't know how you can make the assertion that this ioctl is not
used anywhere. For instance, I see a use of it in Google's code base.
