Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC17114B56
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 04:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfLFDKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 22:10:40 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37288 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfLFDKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 22:10:40 -0500
Received: by mail-oi1-f193.google.com with SMTP id x195so4876351oix.4;
        Thu, 05 Dec 2019 19:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2I9BWtfZOL4P/xg0P2ezGpWnMFLsd6sr0G++N9fRRxI=;
        b=GzHq8NpMIji/ZUYeXBB7aIxQR4Mc7udXrEbwBXLusafbAPZ3D7zzDr8w636bC0comQ
         RsHWoQ7rbyjLs46a7OCdFBUkAilc5pjenmzQF7dz7tYfSVOrc5b1pE+WBJBAzm3/i1qB
         uyPxPX3gcp6YsA+UfpCkyQ484LFV6YilI2+0HyeiWflRXskQMasNj+zn3FS/fqyWGlKb
         U4CpR6rXINBbqzozKiVeZfDdFduUdsS31+gXvlLJxoSp4KrsE989XjiV5Myl9x/5RmFP
         aKB9Bf87jfq2dimHpii5yAgDCz7kyF5AZ9+kLxv1R56PEKwmL/q+s9E0hzjnqmpONUec
         aUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2I9BWtfZOL4P/xg0P2ezGpWnMFLsd6sr0G++N9fRRxI=;
        b=da+7KFq0eujRVdaT3gJyEuG1qiMYcv81CR9K6Qaq0Z3za0jfSMHOWksHlcxfSvDSTw
         RQSKQ8j8tkXZ2iT/pTJL1iKLzcDRxz09MBUbMRgJceg4aax9HfXwe064HceOnkwFIclm
         CkcTiAK4ATqsJpQ6hAqlRsEUDPq8p2ckVvOcb60xUjIA1VAi/0TVl60mnnWBfAUKA3lQ
         4jQ8jE7gpclW54QCtTChYq9TvJrPktkLEBl8409pJAXOyXhWp5uXZDeBw9v3UcSPmQHA
         4NxzG4IspA5fxqCkUNGuYEsFzFErKGKCClU00en1eFdqJOSwe0/jVAbcesJus8mUdI3z
         9DtQ==
X-Gm-Message-State: APjAAAURpRrtcKMoXFZ7WjPgli2Zyw08CXrMwmzpVVbyVcN33DtXRKrk
        OSuVIo5hBCJ2G4JnvnmMyLyBzzbsUm33RL6xhCI=
X-Google-Smtp-Source: APXvYqx9zG1sYufPVsO7WozDLyQ35GubaJfMfrnr/QH9wAwzMD5FWPGGVddq6XEwYkOOehhG+VDTOSzclCjamAzTUTo=
X-Received: by 2002:aca:758c:: with SMTP id q134mr10736499oic.33.1575601839698;
 Thu, 05 Dec 2019 19:10:39 -0800 (PST)
MIME-Version: 1.0
References: <833788ce05014084af1e6160fb81e5cd@huawei.com>
In-Reply-To: <833788ce05014084af1e6160fb81e5cd@huawei.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 6 Dec 2019 11:10:32 +0800
Message-ID: <CANRm+CyOxq9S4pjcGzjuTdE+Vp8H+oq3JezihV3CRm8XFXc-ww@mail.gmail.com>
Subject: Re: [PATCH] KVM: vmx: remove unreachable statement in vmx_get_msr_feature()
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Dec 2019 at 09:54, linmiaohe <linmiaohe@huawei.com> wrote:
>
> >
> >I personally just prefer to remove the =E2=80=9Cdefault=E2=80=9D case an=
d change this =E2=80=9Creturn 0;=E2=80=9D to =E2=80=9Creturn 1;=E2=80=9D.
> >But it=E2=80=99s a matter of taste of course.
> >
> Yes. As what " Turnip greens, all have love " said. ^_^

Actually it is a great appreciated to introduce something more useful
instead of tons of cleanups, I saw guys did one cleanup and can incur
several bugs before.

    Wanpeng
