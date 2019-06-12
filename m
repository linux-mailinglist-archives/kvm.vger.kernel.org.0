Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B693D41A4E
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 04:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408385AbfFLCTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 22:19:31 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44398 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405661AbfFLCTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 22:19:31 -0400
Received: by mail-oi1-f195.google.com with SMTP id e189so10511146oib.11;
        Tue, 11 Jun 2019 19:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wQDTufhWXmTclfVcFNb1jQ6kdGaN6gyHA/mYmZL80sY=;
        b=OkEWnRO7vl1Cn4QB1PZiP8eUmLStmLdSZZsd6x3jAtC+YTPd66WtvIhRvn52nZZswF
         ItyuQ1El0/W5v5RoZZdtLMmyb7Y0S8LxZhPCDmx/cFrenjJq2hRxGw3VrwyB5CG50ZI7
         YnEZGS5hjxqbuzbXimbtWxsWRY4LLkpn5tqWe1Bz6SpYydBMaxDVncSOWkOxaHeO3TDx
         IZA4owuu0/Gd+5YLHzWgFue2PgJLLjscQ2TLKu89E3vNF29aC0tQIY1YRklpzXl6fZVf
         7UYiq5jHvVDgK6DXqTvGhCXPh6EJYTfdfRLsZbaztk8pc3eeUZsfLvJJ9AecXaDFMcq2
         D3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wQDTufhWXmTclfVcFNb1jQ6kdGaN6gyHA/mYmZL80sY=;
        b=ZIdoytIPkoVp/GBnWDEdnQR2epOOwzIrqpXnvVrVbZ7tgOWKAkWi6vXSyQ2qnMX1KW
         sj9urc+jtzpOpjBC9CVknApN5RotQfnP/+6kzbbSQH1YgkAm02SrdpDi9TmldhwcAgpi
         ox7nmuG/9IxIiM9pFH3Yr/Rk6VG3xX8w+Qq1uHf3uUvP1y0nb948sU9FVnRTEbEyNCDY
         IS/FuQh2nWHEZ0M+F8yhSxqGndI9SihaHxi/JgdaCSpeu9M8fhulrtLlPeY70cmYS9HO
         JPHc6SqS6ybbA4Aqjkx5yPugP6MiawTBxWvmYlmev0TtGtqeNUVsvJeWffVsOWJCkcEF
         E80A==
X-Gm-Message-State: APjAAAUuggm6N7LzQV1jSfo1ly9XRbvcS/DERZ9pB0skzoK0G5ENUEne
        D2LQ/O9OO9PgebJfTIpz651iHE2t3s92YPN/R58=
X-Google-Smtp-Source: APXvYqxznTpSOFSgXuguROa+bMFdeyJBBYOGNflyVzIW59pLuKjzNA4upjNYPseua6q5L9J9eqW6qtywuWpd0Dyslr0=
X-Received: by 2002:aca:3305:: with SMTP id z5mr15437298oiz.141.1560305970797;
 Tue, 11 Jun 2019 19:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
 <1558418814-6822-2-git-send-email-wanpengli@tencent.com> <627e4189-3709-1fb2-a9bc-f1a577712fe0@redhat.com>
 <CANRm+CyqH5ojNTcX3zfVjB8rayGHAW0Ex+fiGPnrO7bkmvr_4w@mail.gmail.com> <b30067df-2929-9ce9-221f-0f1a84dd1228@redhat.com>
In-Reply-To: <b30067df-2929-9ce9-221f-0f1a84dd1228@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 12 Jun 2019 10:20:14 +0800
Message-ID: <CANRm+CyuQCrfOQAv0PNgyuL68u2Xn7fXRqZCYE79wBZVDxVXng@mail.gmail.com>
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

Your design heavily depends on read host MSR_CORE_C1_RES for C1
residency msr emulation, however, the host MSR_CORE_C1_RES is
unreadable.
#rdmsr 0x660
rdmsr: CPU 0 cannot read MSR 0x00000660

Refer to turbostat codes,
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/power/x86/turbostat/turbostat.c#n1335
C1 is derivated from other parameters. use_c1_residency_msr is true
just for ATOM platform.

Regards,
Wanpeng Li
