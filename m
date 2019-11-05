Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2237F0681
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfKET7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:59:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40684 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKET7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:59:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id f3so683762wmc.5
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wYiiTK8+8X//EoRaX/jA9TQ7WcxpYaPKRs+Wl0gwfyM=;
        b=VX4B8D98QoTArfCr8KqBFl4OXb5K5lXOf1gtbPYcIyVE/bp2Y2lOQZ57RnRN02zV7M
         KkNd3XwrdM1KJNZWxFxbGr/9B150oW+mLLcFLL75c4qzc+bLIsBnRrhfKI/7AA4APi9p
         5I7PV3mbidCYxiU8FT0cwCyoYANSnn9PnZthYPGwKm5sOUhkb2ajgAJJVQTxBNBozI0v
         GXQ0I7Vi59qRPLTc2Wt7RldhuLjDU6LJIbLgOtOMe/d6QwYTcQC/qmcRlWCmk9YWUJuu
         XF6P2+lA7ECP4OQKH7kRzjLwM6PeE1rsA/YNH2avIMzLg9q0ID9WFwc60P0Fsq5pSA0t
         NApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wYiiTK8+8X//EoRaX/jA9TQ7WcxpYaPKRs+Wl0gwfyM=;
        b=QrYYHA9AWhuTHrXwAyd5VPb6mqzvzf/O9k9I5HvyWHyj+K7W3Ptua100ddsN8U/cv2
         qICDLLqxinRW1tzdOacy1EXlvtk25uM0DgJ3jIWxOBFwFmoyB2tD2VVGBwxq9sqswV6J
         4tmzX8osvhs7LtIRk1CBKAq4I45CakmZxp4ZWPCMN2Ixus3RMVdWKEULIUaa17ckpMT2
         yAVCsFVgL4oSoURpDSeXnMztKDCkjHgZyqZ+TboTeEaWrU2BTs1WZ0pwq65amkhvIUqz
         +jnr5kJ/A/FnYxS1Y2wTacmV4nhvCo0JAjQsgkffBAp7ylFrkG30q2sYixnRStblvCKD
         YwRw==
X-Gm-Message-State: APjAAAWviaf9AKaBHpYQN9oV6T7BZX+Hcgj3lxkKpJOONU7efGjHDCf9
        FeEx8R6Izh2DqcD7mB/NcrATKRl92iZQmAFW48/y102G
X-Google-Smtp-Source: APXvYqy+XrNKtKI0uOcQ43hs9nP1Nbtayr3OaRvsBQoOo4KYv5haQRnGQ3Mpfmn07g6cT4FXlzK1YIsmY6td7y0MTdM=
X-Received: by 2002:a05:600c:21d9:: with SMTP id x25mr710399wmj.50.1572983979789;
 Tue, 05 Nov 2019 11:59:39 -0800 (PST)
MIME-Version: 1.0
References: <20191024195431.183667-1-jmattson@google.com> <895ce968-7f70-000b-0510-c9040125f93a@redhat.com>
 <CAL1xVq00-EwHfiZgsFLm3GuAdbDajCBxuKxm7xTbKKUaf0wzPQ@mail.gmail.com>
In-Reply-To: <CAL1xVq00-EwHfiZgsFLm3GuAdbDajCBxuKxm7xTbKKUaf0wzPQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 Nov 2019 11:59:28 -0800
Message-ID: <CALMp9eQ3-njTpV1oDMGTEdPs12X1DWon7rHRyCefzxHhpnyeVg@mail.gmail.com>
Subject: Re: [PATCH v2] kvm: x86: Add cr3 to struct kvm_debug_exit_arch
To:     Ken Hofsass <hofsass@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 10:07 AM Ken Hofsass <hofsass@google.com> wrote:
>
> On Thu, Oct 24, 2019 at 3:18 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On 24/10/19 21:54, Jim Mattson wrote:
> > > From: Ken Hofsass <hofsass@google.com>
> > >
> > > A userspace agent can use cr3 to quickly determine whether a
> > > KVM_EXIT_DEBUG is associated with a guest process of interest.
> > >
> > > KVM_CAP_DEBUG_EVENT_PDBR indicates support for the extension.
> > >
> > > Signed-off-by: Ken Hofsass <hofsass@google.com>
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > Cc: Peter Shier <pshier@google.com>
> > > ---
> > > v1 -> v2: Changed KVM_CAP_DEBUG_EVENT_PG_BASE_ADDR to KVM_CAP_DEBUG_EVENT_PDBR
> > >           Set debug.arch.cr3 in kvm_vcpu_do_singlestep and
> > >                               kvm_vcpu_check_breakpoint
> > >           Added svm support
> >
> > Perhaps you have already considered using KVM_CAP_SYNC_REGS instead,
> > since Google contributed it in the first place, but anyway...  would it
> > be enough for userspace to request KVM_SYNC_X86_SREGS when it enables
> > breakpoints or singlestep?
>
> Hi Paolo, from a functional perspective, using KVM_SYNC_X86_SREGS is
> totally reasonable. But it currently introduces a non-trivial amount
> of overhead because it affects all exits.
>
> This change is a targeted optimization for use in instrumentation
> scenarios. Specifically where debug breakpoint exits are a small
> percentage of total exits and only a small percentage of the debug
> exits are from processes of interest.
>
> thanks,
> Ken

Another possibility would be to add flags to KVM_SET_GET_DEBUG that
request a SYNC_REGS on a breakpoint or single step.
