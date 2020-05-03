Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7907A1C2FFA
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgECWYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729151AbgECWYC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 18:24:02 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D81C061A0E
        for <kvm@vger.kernel.org>; Sun,  3 May 2020 15:24:02 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id w4so10398268ioc.6
        for <kvm@vger.kernel.org>; Sun, 03 May 2020 15:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kjaSVCWXurVJtg233ElhdEe+o6ijOGusR4DCcn0i4Tg=;
        b=jbtKkOsNhdv5foRwo8Axs4qDl3pLL811ljPwvHLPlPUhaJBh6B0YkydokOAyI66A+W
         ynBkUFEZso2fYz9nB6jB7bl9OTGe4zaDXxLq2TWGJpuxnJXzwW2+oJkh6KI6M7t6BUOV
         lX+Xo9ULvfmL1QqIW1YMtxuCOKtQzoysQhMWd8rnPOD7GhrCVOFPZF5MIVI2BHdJ22IW
         +8a5aizFV3Qp/G06xIWWf0r5FP4mD9u7OpmRJJ8c8Tcf3/hQH6g/eWwVO037m8xuC79h
         VDUrQ3jim0l1VtznPODiR+uSRNeEsE82G2ysxhkNUq2rWyUAI+QkYzw9ekcpOSuBE+/4
         qBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kjaSVCWXurVJtg233ElhdEe+o6ijOGusR4DCcn0i4Tg=;
        b=nPQqRlOD/C3R0THBY1s4p1lYtiTXDj2sCiRGsD26BeyCe7JFAd/gcsFKbNud+4x425
         br033wicQ4c7PFJrTz1Mp4e5jivqEjvp1CzKhyf+rY5G0CJzpVS5vYwaqPpcJsVVb4AL
         3bjdjsQoX8D12sRCITfeCiURrIR8+ugA125kdVDWB4plImvtVN8rKeybV80asM3Rlyxc
         G2/G+/e4/2orVaDGUpbchqOefIIr5H1wIxcrf5o3Vz4LSglHQUt8whoMTz2g9+58V3eK
         uIZKQZlyAc+Mfi2QrjhfM25qJCszB1F2k+gpcdrnOMUHBmtWa9jIuD0fIJ0S/f173SjN
         glkQ==
X-Gm-Message-State: AGi0PuY5HVWc5WxaCkdP/wBCNaBusn0hU95Up5bg9tqs9LRFdLTjo1j+
        vTgFQwtt6S1SFWiswRp3PDEdhiIk1Mb1IeQp4Ea9ZCjl
X-Google-Smtp-Source: APiQypIr/PLbmyP/9gx7xurE/XWgtnJwn+10ZxfYpsmFhu2fE+/JvL2ljtgPgWtSFVQgIQiAaGhI9Z/QwZGPvXph2Sw=
X-Received: by 2002:a5d:8f02:: with SMTP id f2mr13252146iof.55.1588544641863;
 Sun, 03 May 2020 15:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200426115255.305060-1-ubizjak@gmail.com> <fcf019d2-0481-5d10-76fa-4d86e8b8c4e6@redhat.com>
In-Reply-To: <fcf019d2-0481-5d10-76fa-4d86e8b8c4e6@redhat.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Mon, 4 May 2020 00:23:50 +0200
Message-ID: <CAFULd4aa56=bCrYx0-d3cwHt6C7b3GSenfkuuroV19ZZ880whw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: VMX: Improve handle_external_interrupt_irqoff
 inline assembly
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 3:48 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 26/04/20 13:52, Uros Bizjak wrote:
> > Improve handle_external_interrupt_irqoff inline assembly in several ways:
> > - use "n" operand constraint instead of "i" and remove
> >   unneeded %c operand modifiers and "$" prefixes
> > - use %rsp instead of _ASM_SP, since we are in CONFIG_X86_64 part
> > - use $-16 immediate to align %rsp
> > - remove unneeded use of __ASM_SIZE macro
> > - define "ss" named operand only for X86_64
> >
> > The patch introduces no functional changes.
>
> I think I agree with all of these, so the patch is okay!  Thanks,

Actually, after some more thinking, neither "i", and neither "n" is
correct for x86_64 as far as push is concerned. The correct constraint
is "e", but in case the value doesn't fit this constraint, we have to
allow "r" and eventually "m". Let's use "rme", which allows everything
the insn is able to handle, and leave to the compiler to use the
optimal one. GCC uses this constraint internally, and it also fits
32bit targets.

V3 patch is in the works.

Uros.
