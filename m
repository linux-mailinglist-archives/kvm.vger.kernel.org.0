Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D39201E3C
	for <lists+kvm@lfdr.de>; Sat, 20 Jun 2020 00:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgFSWw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 18:52:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729822AbgFSWw5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 18:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592607175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w6bylLJixqz3s8BXyWddFU9FNbd2DZqPgXkXfHXbAtk=;
        b=fmC1JmeftmmT1vFQ8bnLYEqOUGx9y0PX7RbISEJ+uGFVR4WIUbOrwcLILiQb0pnyB32Orc
        D9VjNN9Gi90TBhzElvn8IooT19/TYA/645SfY40wCIAXE3p7eBvY7avKV9Q0uLxtB6Eucr
        zZ5qrI+1QoDtP8coATksS/IpTDsfaKc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-7TKA1cZOPhGJl80-FjJ9mg-1; Fri, 19 Jun 2020 18:52:54 -0400
X-MC-Unique: 7TKA1cZOPhGJl80-FjJ9mg-1
Received: by mail-wr1-f69.google.com with SMTP id o25so3403590wro.16
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 15:52:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w6bylLJixqz3s8BXyWddFU9FNbd2DZqPgXkXfHXbAtk=;
        b=c+51QPdG5C0YEHtyICgu3V3ANFqP2GfmQCWdqjelLe+ZJyw1rDiJAdKkVpFTxfPIem
         dPL8mhzMEDEGTnN7L/Cb2o9I7G9gbb70IgcJ71hq0Y3mu/pBSCCvRdxlTE9298vcg35s
         B6BNwzDxB82hnhLlP5G8qIAafdvNymNJjmYfM52p9b4xXyBQvWKUsmi/+UybdlmOuYmh
         Vqz9zQ+R2p2M28iiOZYipHAHl4zhDkSGBvFnxpMl+VDq3TUZFgbGGK6k47jO3L1bJ9Kh
         DySCNNTJLsrp1RlVTjZCEkbZj4ma/qjgIyhXe9nyAZyghdRnXfBL/ouK3s0bWiNZN5Z1
         tA8Q==
X-Gm-Message-State: AOAM531BNh+pqyrnny1bGepIMcBufwirZmwh6oeZjMSQNaevXxfHJu2R
        x162kpJwBg076L0U+YzYPT4ewyv/oLXCm+CgZBrjY5BTUfEW7drr4AJOz85ibJ0oIumRpruNw/y
        o1zLk+aX7HmP9
X-Received: by 2002:a05:6000:10c3:: with SMTP id b3mr6741413wrx.53.1592607172906;
        Fri, 19 Jun 2020 15:52:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweCmZ3aEUYUFaiG/NLXLcWjLHYDejdz0Qrw3uOVbYYRqYp1q9vAdc6zh6O4aaf/z5FVf2jeg==
X-Received: by 2002:a05:6000:10c3:: with SMTP id b3mr6741399wrx.53.1592607172638;
        Fri, 19 Jun 2020 15:52:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id o18sm8426146wme.19.2020.06.19.15.52.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 15:52:52 -0700 (PDT)
Subject: Re: [PATCH 0/3] Pin the hrtimer used for VMX-preemption timer
 emulation
To:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <20200508203643.85477-1-jmattson@google.com>
 <CALMp9eRS3FT9QSjTYihBZaZjzMVRx1bYrRaY+jsiOqthyMyv6Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2f428d1-c42c-a0b1-cf15-971017cd85e9@redhat.com>
Date:   Sat, 20 Jun 2020 00:52:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRS3FT9QSjTYihBZaZjzMVRx1bYrRaY+jsiOqthyMyv6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/20 20:49, Jim Mattson wrote:
> On Fri, May 8, 2020 at 1:36 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> I'm still not entirely convinced that the Linux hrtimer can be used to
>> accurately emulate the VMX-preemption timer...
> 
> It can't, for several reasons:
> 
> 1) The conversion between wall-clock time and TSC frequency, based on
> tsc_khz, isn't precise enough.
> 2) The base clock for the hrtimer, CLOCK_MONOTONIC, can be slewed,
> whereas the TSC cannot.
> 3) The VMX-preemption timer is suspended during MWAIT; the hrtimer is not.
> 
> Is there any reason that VMX-preemption timer emulation shouldn't just
> be a second client of the hv_timer, along with lapic timer emulation?

I don't think so, you'd just need logic to multiplex it.

Paolo

