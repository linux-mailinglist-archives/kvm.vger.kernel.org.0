Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7962614A8EA
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 18:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgA0R2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 12:28:13 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:40979 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgA0R2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 12:28:13 -0500
Received: by mail-ua1-f67.google.com with SMTP id f7so3727008uaa.8
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2020 09:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s3P3TBsc4sOWAtF5ewj8AqN0VmzASpj4qfvh3bEowwI=;
        b=kfiwF+MinrCuEO3Qnq235rAwfGRjUwQbK6IpfVFZ4SRZ0RSO5HVmrLaFjLuIBQwSfW
         F+38sbMilpec9kwriZK6RheZGbAyFbR5pI9inmvu1gMGwMkqWVx/uQHtIvOImJDE3IYK
         suPkXvdZZ2+CqGXFnCB6ayEj3r0etglx6WWcALXjQh47c4z1TQwq+FSJcPuGdAF4P60o
         rxJ8ZP35fMCEwDosk0Tqd5PYU5ePX0qWkBO70e1gxKWihpe/8LcZ0GZB/7+Y4I9FYfvt
         Qkdu5wGHtOjzcwLQah/0jjGH3zfL2iR52JB+FmWs2Z243eMY6sDLmZFzjiimghrP4jIT
         FCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3P3TBsc4sOWAtF5ewj8AqN0VmzASpj4qfvh3bEowwI=;
        b=Fp/18FWC87RNjjTpUWVJ7Ew7OXRZsUg1leUhFnpywS+rxlDxiB/C9UFj1WXEEkU46w
         UhIVg6wamAeqy9ysUxMHwurU6qAbkdjNp5CKKbjbZy8G3tqMN1tk+8VgDDLllJ8DSKVI
         6YNI/32nHPZLbVa4txWFYVC0taA3RZmkJ1SgjuRGYW70bACtHM2J+NU87FBQFp9YpA5a
         J2zoBLJvtmSuS+hB5YDHh2Y2dnejkZRBIv7nBmcRozv38rKR1wqQCekcYtRmiy4DtYwp
         cq7b5RGho3UuPf7Ern9xaZNYSNFi5kFEn7q1kQG9u3Wnuhs9i3BVzd7WxCTJI/ANXhT8
         oT9A==
X-Gm-Message-State: APjAAAW+XJ498lPcNypFg6dUcAkwN8xNAbNpSriaKlpXiTqtCibKxmlg
        RMZUclaki0aCRDydeUmIkZc3z6kp2QY/TyIJMagegw==
X-Google-Smtp-Source: APXvYqy13JW+3DjsIsvxAfdU3Wibc51f21lE/4A5G2QY91lTiOLICQ5URIuVMs3E1SZXtGTpb6iOyBLLgOzGcTK0Cbg=
X-Received: by 2002:ab0:5510:: with SMTP id t16mr10816954uaa.15.1580146092261;
 Mon, 27 Jan 2020 09:28:12 -0800 (PST)
MIME-Version: 1.0
References: <20200123180436.99487-1-bgardon@google.com> <20200123180436.99487-10-bgardon@google.com>
 <92042648-e43a-d996-dc38-aded106b976b@redhat.com> <CANgfPd8jpUykwrOnToXx+zhJOJvnWvxhZPSKhAwST=wwYdtA3A@mail.gmail.com>
 <6812a36c-7de6-c0c9-a2f3-5f9e02db6621@redhat.com>
In-Reply-To: <6812a36c-7de6-c0c9-a2f3-5f9e02db6621@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 27 Jan 2020 09:28:01 -0800
Message-ID: <CANgfPd81ocW0O4nqSnfBwEn_V-ZzY_WJ=TvymCBfy_w5==GxmQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] KVM: selftests: Stop memslot creation in KVM
 internal memslot region
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 25, 2020 at 1:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/01/20 19:41, Ben Gardon wrote:
> > On Fri, Jan 24, 2020 at 12:58 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 23/01/20 19:04, Ben Gardon wrote:
> >>> KVM creates internal memslots covering the region between 3G and 4G in
> >>> the guest physical address space, when the first vCPU is created.
> >>> Mapping this region before creation of the first vCPU causes vCPU
> >>> creation to fail. Prohibit tests from creating such a memslot and fail
> >>> with a helpful warning when they try to.
> >>>
> >>> Signed-off-by: Ben Gardon <bgardon@google.com>
> >>> ---
> >>
> >> The internal memslots are much higher than this (0xfffbc000 and
> >> 0xfee00000).  I'm changing the patch to block 0xfe0000000 and above,
> >> otherwise it breaks vmx_dirty_log_test.
> >
> > Perhaps we're working in different units, but I believe paddrs
> > 0xfffbc000 and 0xfee00000 are between 3GiB and 4GiB.
> > "Proof by Python":
>
> I invoke the "not a native speaker" card.  Rephrasing: there is a large
> part at the beginning of the area between 3GiB and 4GiB that isn't used
> by internal memslot (but is used by vmx_dirty_log_test).

Ah, that makes perfect sense, thank you for clarifying. I think the
3G-4G in my head may have come from the x86 PCI hole or similar. In
any case, reducing the prohibited range to just the range covered by
internal memslots feels like a good change.

> Though I have no excuse for the extra zero, the range to block is
> 0xfe000000 to 0x100000000.
>
> Paolo
>
> >>>> B=1
> >>>> KB=1024*B
> >>>> MB=1024*KB
> >>>> GB=1024*MB
> >>>> hex(3*GB)
> > '0xc0000000'
> >>>> hex(4*GB)
> > '0x100000000'
> >>>> 3*GB == 3<<30
> > True
> >>>> 0xfffbc000 > 3*GB
> > True
> >>>> 0xfffbc000 < 4*GB
> > True
> >>>> 0xfee00000 > 3*GB
> > True
> >>>> 0xfee00000 < 4*GB
> > True
> >
> > Am I missing something?
> >
> > I don't think blocking 0xfe0000000 and above is useful, as there's
> > nothing mapped in that region and AFAIK it's perfectly valid to create
> > memslots there.
> >
> >
> >>
> >> Paolo
> >>
> >
>
