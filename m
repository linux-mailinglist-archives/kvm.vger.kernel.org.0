Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B8998794
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 01:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbfHUXCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 19:02:03 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35347 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730339AbfHUXCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 19:02:02 -0400
Received: by mail-io1-f68.google.com with SMTP id i22so8085586ioh.2
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 16:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=axv1TR5Z104aBOHyWcWWY1GpjEGEg2RCX6x0P6YWyPw=;
        b=RQujUxJDBHLGw7WJJQqZRoOhao1UMfYivTBtAHRlVxjUC3psYtg+9bCB9hrVuTX7G0
         eVKK/I64J9cMaNVLhwUZqtJMKOxjWLKGTDXKjwLHNuCbhFJ94N8T5tcM1PvjLr4Ofuzi
         uFxXUMSQ6YomM17KLSxMv657pEsnFpN/aa9rUcYpWLyxkDqyWNk1fpzC3zlrT+eh8gq0
         OSxP7uAZ3La6wVGB6l1leZaAi91yIwHgstjxoHY2qS+aioziskwoU33BA+vTAQ/3criS
         HGBySzp+VkZSr7m9p+w/oFKwKT//bh3r+J1z56LaSyUier3P5lGdcV2jvEoX3sbAuFjX
         Sh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=axv1TR5Z104aBOHyWcWWY1GpjEGEg2RCX6x0P6YWyPw=;
        b=nEdvc9gccp0EZekVdSM6ComouDENsw+H2/A6HISldI5UmffHNYqipfz2EaQeOhg5FB
         v5MdyAKXAGZOl5tmvibaunJArNbcO/a+uR6akcSbO3ylenuChSfrh08WThG/MXguOLtK
         e/KEIISqvKdx1bUvTebTf/Dj8yBok8psOsbEnyAeQmm3SGw9zjy1OwbhicJ2vnWWZ7yr
         RAhqkw3WTr8LyrRlOfSHaaYxCe/NVvdjrH5m+WuK5j1B7sSACtn+WCkoltNeorYcMp8i
         NZYLBvsqLocQomyICxgwe5nC7hWorfEqzlUEIjriPRRtnKvc16tIhXjnWUuzrSlCqMVa
         3COQ==
X-Gm-Message-State: APjAAAXDZSxmymbz2u1YTHwpxq0GgdaxySSnW04KSkVAZjL3+ONotXWl
        BNw6E2uc9Idi5SF9cBt7WKR9mWdboQHR6h94akSv8Mi8H7RIuA==
X-Google-Smtp-Source: APXvYqzwE82iA+K0Hj9gL+a3PJfnmWYHyUJXVBk4yQKi6o/c7q5cWLZEWLrPuyb8hMBwQjOpQpbFfyyI5DfZZ6onBU4=
X-Received: by 2002:a6b:6a15:: with SMTP id x21mr8796055iog.40.1566428521608;
 Wed, 21 Aug 2019 16:02:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
 <20190819214650.41991-2-nikita.leshchenko@oracle.com> <20190819221101.GF1916@linux.intel.com>
 <CALMp9eR4zO=BOZKzDowkVSR7O9Y2aqBXEvwepv6j85z4wvSyxA@mail.gmail.com> <20190821222218.GL29345@linux.intel.com>
In-Reply-To: <20190821222218.GL29345@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Aug 2019 16:01:49 -0700
Message-ID: <CALMp9eTT9AoytCKN8FmcKhfrsn4Pz=r8yDFe=_CEobpeOG6J6A@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always indicate HLT activity support in
 VMX_MISC MSR
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nikita Leshenko <nikita.leshchenko@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 21, 2019 at 3:22 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Aug 21, 2019 at 01:59:20PM -0700, Jim Mattson wrote:
> > On Mon, Aug 19, 2019 at 3:11 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Tue, Aug 20, 2019 at 12:46:49AM +0300, Nikita Leshenko wrote:
> > > > Before this commit, userspace could disable the GUEST_ACTIVITY_HLT bit in
> > > > VMX_MISC yet KVM would happily accept GUEST_ACTIVITY_HLT activity state in
> > > > VMCS12. We can fix it by either failing VM entries with HLT activity state when
> > > > it's not supported or by disallowing clearing this bit.
> > > >
> > > > The latter is preferable. If we go with the former, to disable
> > > > GUEST_ACTIVITY_HLT userspace also has to make CPU_BASED_HLT_EXITING a "must be
> > > > 1" control, otherwise KVM will be presenting a bogus model to L1.
> > > >
> > > > Don't fail writes that disable GUEST_ACTIVITY_HLT to maintain backwards
> > > > compatibility.
> > >
> > > Paolo, do we actually need to maintain backwards compatibility in this
> > > case?  This seems like a good candidate for "fix the bug and see who yells".
> >
> > Google's userspace clears bit 6. Please don't fail that write!
>
> Booooo.
>

Supporting activity state HLT is on our list of things to do, but I'm
not convinced that kvm actually handles it properly yet. For
instance...

What happens if L1 launches L2 into activity state HLT with a
zero-valued VMX preemption timer? (Maybe this is fixed now?)
What happens if "monitor trap flag" is set and "HLT exiting" is clear
in the vmcs12, and immediately on VM-entry, L2 executes HLT? (Yes,
this is a special case of MTF being broken when L0 emulates an L2
instruction.)

I'm sure there are other interesting scenarios that haven't been validated.
