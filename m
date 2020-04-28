Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2F1BCF0B
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 23:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgD1VoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 17:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgD1VoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 17:44:17 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BD4C03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:44:17 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w6so468866ilg.1
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 14:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qwL+4WZ+0ScRQq3VXJ2lINm0eOX2xPWaP7a0ucBzFCA=;
        b=d7VojKRrrM2EbO15GOh1OhChn7gSyFoTXBrRcOc33vyUBYppKZsM5J90YUoUIGIm6D
         kJl+gdgZdxLSvXBoBJL8gWJtDQdUDSLmr5Lx088oqp+gCg0xyM1hqhXzkH2hs0DkdFJL
         IEs6ffv+z09tOT6TZ/kUbg1buaBZgAmOPP605bXMrH+zkfy4eU/fijkjz1DEOM07JoWr
         lymrrJaD2xwwvFXttNIX3YuSZsXZM+EE9wZsNEl6MuszpQTWxcXgTs83YLdPEg0JP/DK
         9rcKunzihHcggaPr2OalahIwvaFR5CvA+wOOGGpphObaMV0oFzqYtJSs/ewkHKGshQ84
         tHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qwL+4WZ+0ScRQq3VXJ2lINm0eOX2xPWaP7a0ucBzFCA=;
        b=rLGgIHXmUvBbn0crW919VLT6j/bbwePaQ5nl7JgKs7ob3jJTIF8ARyf7wPAXRgBbuN
         AdLCJMQBKKWbRNldL3Y4+kVSHI4Ll1VPYmvptp1DpAuBeAaEoKUcg/0WoQgqK2Qb3C/y
         CQoTCfkf3prFKmgAe6oocmoZhTsCE4lq8EnfYfl6qQgYkg5QuLQeYfqKxKDf/Y/X8CB2
         tdNNZYuUBtbh1iyJChvFyaOVeb5szfQgoYgAW3A1qmUw6fJCQ6OXMBSXYsNkleaNo1Cu
         v4NiYrDblLjp++rERyRZTRwo2zF12ZRa8Gta3M4HPNTVD5RbogiB1AvkLhHYq5Y+T3CS
         fTXQ==
X-Gm-Message-State: AGi0PuY/8stspcCrqjZMzVpjyFg8e2xPHB9DQ/snjlXtWUmpIOOlCi92
        En9718d80190nKrQiFmxQSZ3Yn1XrqdcWSsMVYruJw==
X-Google-Smtp-Source: APiQypKaShkz7WAR98Qp49F/fWDSJZqW2ISiUOp3Ex60HLT/a92+dt8VDos6q83aPip6tyDKdLHAZncMUbfE9aGu6gw=
X-Received: by 2002:a92:d8ca:: with SMTP id l10mr28461593ilo.118.1588110256438;
 Tue, 28 Apr 2020 14:44:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-6-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-6-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 14:44:05 -0700
Message-ID: <CALMp9eRZFZhEQOjLGy7LdYGdp23NJOewr49X+XJ3my05v+OZtw@mail.gmail.com>
Subject: Re: [PATCH 05/13] KVM: nVMX: Move nested_exit_on_nmi() to nested.h
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Expose nested_exit_on_nmi() for use by vmx_nmi_allowed() in a future
> patch.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
