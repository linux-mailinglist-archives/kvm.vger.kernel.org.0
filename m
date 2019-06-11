Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955633CA1B
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 13:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389710AbfFKLe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 07:34:28 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46584 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389558AbfFKLe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 07:34:27 -0400
Received: by mail-oi1-f194.google.com with SMTP id 203so8651213oid.13;
        Tue, 11 Jun 2019 04:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x5rmiwyCLeKaoHJp17aHdkTJjyA6YPZC/WRbR5vMjpI=;
        b=e87CA4x8A1PKtNjG2k6Scdr0xbId162DU6jQSXDhYLhWRm4Iqar9QhKyUwHijKDAPa
         hAGpLYC2nBmYPzQAcLOtJJOitEd0IL/QiUD0/yZXIXdbg4X4hAAiMZdjjn8/dVPWZ2c8
         3WvbMz8mdVQM0cj28sYVqPjUP0EdCA+AKQMV7PkL06zgSWyR5llbr0jmRou8JUuBrSto
         gKGKS5UMF0Jaq/WT95feuerGdwNv+z5cDR1SHY7IO+2XKj0AoJ9VnhQZP/IQIankG28p
         b9RmzdHEZAh3SjcEEmaO/murUhY7oYhyuMmT1eOUSBaqal/akF3K7HV9fBfhxuhrFw+X
         l5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x5rmiwyCLeKaoHJp17aHdkTJjyA6YPZC/WRbR5vMjpI=;
        b=KbL9f8vrvCAS5HSVnnMWicIDwL0TSJKTopDbVQr/9Y7LIrqUFjKbphDxvK/BaD+STQ
         6KOs2+864D4A6Ki6dHFwY3uZw5cBv+QnPx+9DzCNdZntXiUc6lr/9NenLeqmx9UyUIGu
         +cWgzeCaY/VkX0qMitWXHNspTwVCH7myob17EuQZynrCOUFUSHFxAYCvk1ZJL8AT/2IZ
         ReOCZdI5rh4cO/mijCuWwPudVwx0KzTz3avE5Oz3FW3Y8NlaR1s3EnWcE4Gav1DDf7dZ
         ZCOcPApK1zMGigyJbGFwSLyDqjZs3rNLHQtGMN+jIjZAyPEJbOMR9ZYihpQzizC6c0Yt
         5ceg==
X-Gm-Message-State: APjAAAXC6tye56qXqujLzfwU+QuOGL5N3aRjsat0ugK1R6RifTvEqqq1
        1sw+A5WAcmWaFJzLj1zfVUD1TL3YZCBtd4oUZ9s=
X-Google-Smtp-Source: APXvYqxti6kF49QbOqX5rYkaYjy9reVlZ+JZCnE9g2R9uYNvjXjUgNkqe5qb1ON4m0HKHX8Vy++ZkYYPCd0+zxB09I4=
X-Received: by 2002:aca:544b:: with SMTP id i72mr15419354oib.174.1560252867275;
 Tue, 11 Jun 2019 04:34:27 -0700 (PDT)
MIME-Version: 1.0
References: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
 <1558418814-6822-2-git-send-email-wanpengli@tencent.com> <627e4189-3709-1fb2-a9bc-f1a577712fe0@redhat.com>
 <CANRm+CyqH5ojNTcX3zfVjB8rayGHAW0Ex+fiGPnrO7bkmvr_4w@mail.gmail.com> <b30067df-2929-9ce9-221f-0f1a84dd1228@redhat.com>
In-Reply-To: <b30067df-2929-9ce9-221f-0f1a84dd1228@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 19:35:11 +0800
Message-ID: <CANRm+Cy+BVHeXjfSPhPz=n7_Qg8oQEC8DdcpCzEV5v4qYXgJGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: X86: Provide a capability to disable cstate
 msr read intercepts
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 at 19:09, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/06/19 09:38, Wanpeng Li wrote:
> > MSR_CORE_C1_RES is unreadable except for ATOM platform, so I think we
> > can avoid the complex logic to handle C1 now. :)
>
> I disagree.  Linux uses it on all platforms is available, and virtual
> machines that don't pass mwait through _only_ have C1, so it would be
> less useful to have deep C-state residency MSRs and not C1 residency.
>
> But turbostat can get the information from sysfs, so what are these MSRs
> used for?

The sysfs is not accurate, the time which is accumulated in the
function cpuidle_enter_state() is the expected cstate we hope to enter
instead of the real cstate we finally enter. For example, we found
several SKX/CLX models can't enter deeper cstates in non-root mode,
Intel hardware team has been working on this according to our report
recently. The bare-metal cstate residency msrs don't increase in
non-root mode, however, the time under
/sys/devices/system/cpu/cpux/cpuidle/statex/ increase gradually in the
guest.

Regards,
Wanpeng Li
