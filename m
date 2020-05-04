Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73D1C3E89
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgEDPcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726908AbgEDPcc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 11:32:32 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D48AC061A0E
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 08:32:32 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f3so12744699ioj.1
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 08:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j3k4J76mztCVzoce8hwVzmWq+8ln8k9qT3WWabJ8nek=;
        b=svxY9VTVOFicEVo5nEaOVB2P8q+neytIaCEiCJH9cRIqKDktUY1CC3jwBEyUorpS0r
         60cjxVxF0ABcIgCpNz4BuFV42PGssgwAnEsTJ+OQuTSTRjDycVw33OMhrMbJ24OA5vmb
         W4ydqae1QMxErlw5hguuZLdfEoilyHEJTxzRrXX+9rDHywu514JFvu9FQIOrVlw7e3Iq
         mC1rUTiCvbG9ZHkrws5alIEhD/UPt48YnN2kGSvI+Rz2lisYHLhU9dn5VvgBKT92nUQ4
         Vwpf93YG3c45Vo5U+6EPJBEA+aSKNHhmHxMVly9Q4iOnTWXH6Z9a0Pkze7L02eWjTT0N
         mP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j3k4J76mztCVzoce8hwVzmWq+8ln8k9qT3WWabJ8nek=;
        b=C+r+ZjswQgqmZL+7jEWTmyPlS/Vq38sevtBwnT37MS++HCNH4p9oiOs3mF8P10fWEI
         OFRtjjSmmHK8JljGawEi9XrgABmbLTuiaAZA93uUZMx7KDJcFvZjURc5+uNbxIEb3/Jk
         kZCxCMg65Hv6G+gKbQkIZqfb+vPzzszrYoxSIVO7fKN95ifFb/rnuMDtJWRdwoPhdbTO
         2cQoAPP88FNP0PTYX81hTmubgRF2HQkXPLtqTEHILdzcpGKMZP1oA0YwuoNSOe5g8vc7
         T+TL4aU4NSYDxmWdge9DrnhdM/yfyBuREnXe3k5hPB14AoSzhUFg5rvzYqT+Ua2dIsPA
         zuRA==
X-Gm-Message-State: AGi0PuauHoUoths+dOWX3PhmwQWcSszcs6xSR95A+qJ7TcSidQAfP2I9
        C7zl8uVkSiOa7EZvRpjT+nZtfUIFXiO+wB5Ascke2BoF
X-Google-Smtp-Source: APiQypLqHuqPaSfQxoApH4PAj5+SBf9cKrdZHPN79VqCY93QaeC2GVQZfvncFSPpCvY7dnO5hiqjq1UMBsDg4IWTsJA=
X-Received: by 2002:a5d:88d3:: with SMTP id i19mr16267830iol.194.1588606351613;
 Mon, 04 May 2020 08:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200503230545.442042-1-ubizjak@gmail.com> <20200504152519.GC16949@linux.intel.com>
In-Reply-To: <20200504152519.GC16949@linux.intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 4 May 2020 17:32:19 +0200
Message-ID: <CAFULd4bWmcrsdfeyc++P9pGhn-MS703yWisKKmr601nAvP86gw@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 4, 2020 at 5:25 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, May 04, 2020 at 01:05:45AM +0200, Uros Bizjak wrote:
> > Improve handle_external_interrupt_irqoff inline assembly in several ways:
> > - use "re" operand constraint instead of "i" and remove
> >   unneeded %c operand modifiers and "$" prefixes
> > - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> > - use $-16 immediate to align %rsp
> > - remove unneeded use of __ASM_SIZE macro
> > - define "ss" named operand only for X86_64
> >
> > The patch introduces no functional changes.
>
> Hmm, for handcoded assembly I would argue that the switch from "i" to "re"
> is a functional change of sorts.  The switch also needs explicit
> justification to explain why it's correct/desirable.  Maybe make it a
> separate patch?

I think this would be a good idea. So, in this patch the first point should read

"- remove unneeded %c operand modifiers and "$" prefixes"

The add-on patch will then explain that PUSH can only handle signed
32bit immediates and change "i" to "re".

Is this what you had in mind?

Thanks,
Uros.
