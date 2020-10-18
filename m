Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CF829182B
	for <lists+kvm@lfdr.de>; Sun, 18 Oct 2020 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgJRP7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Oct 2020 11:59:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbgJRP7t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 18 Oct 2020 11:59:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603036787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G1NfFqRvQCLurPJ/4oycBIXRpf/JK9ZrKM1/uUoh0IA=;
        b=Pyf4yAXzQVn2Aj82XmoXSyLYN97mk9UayHMBtuxkEhO2tsJrAtLI8o/4ftXbS1JseST0dR
        MUozCkLLJkcBN2mmXQUtGjfeBWpeek3vqoyUp3WZnuUg1d5frZLAVidmNiV+JJKe9Yvu9f
        dSZolVLhGG7ZO7zxXGEhltq8Rr3yQbw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-oPLis_P-MFiTMo3CRESwCw-1; Sun, 18 Oct 2020 11:59:45 -0400
X-MC-Unique: oPLis_P-MFiTMo3CRESwCw-1
Received: by mail-wr1-f71.google.com with SMTP id 2so6277265wrd.14
        for <kvm@vger.kernel.org>; Sun, 18 Oct 2020 08:59:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G1NfFqRvQCLurPJ/4oycBIXRpf/JK9ZrKM1/uUoh0IA=;
        b=H3y7NC2K+S0opC+BPltRCR5zW8gOYR12pOimYZamkvZJfOMkLpzKYZ8A6sr0L1KuNV
         wpbHrCMeQqTWN6+u3fu3kpesAL/G1gcurknRp3DF09ET97YXd4r2UrqT1NZO81D8af4F
         0c4pVjAS+CjFRmGcAUtWG11XO5zu+HZ8D6Q9EcUxUmZTJDaYc66ki2fpHmNsLcEOWAKa
         /I9WM9GZBddP8yvzflYGVZFdlwG3QGsMHVaD1NB07NAXUIedLNTIkUrfTimuyXAPaIBU
         gjoUQvuXzZw0fSKhE5mYciZXvTEcVxfvo65QQlCuSBLtJnikHu2N7/Crt0bTyPmXNmw2
         024g==
X-Gm-Message-State: AOAM5309TT78yMNk5pxYD9j43qSINZFG6+ax4HcBNXpDcHitqeR1SBCs
        uXMEB6iBGJHnul0l4A0YDIL4mTdkehOBo5pDFIfY3QvpgxIMjfIMZI7CkDVHBhEl7Nbyd5pkcJ+
        Uy8Jg5ODsop4M
X-Received: by 2002:a1c:f719:: with SMTP id v25mr13416577wmh.186.1603036784678;
        Sun, 18 Oct 2020 08:59:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKG4LDYGrfcTeGKXBvhe3OP7bjzV07mWsDR9CnUloQlRE4wGL7GgoXxjxr0ZXIKJ7mRGf5bw==
X-Received: by 2002:a1c:f719:: with SMTP id v25mr13416551wmh.186.1603036784415;
        Sun, 18 Oct 2020 08:59:44 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id a82sm12794262wmc.44.2020.10.18.08.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 08:59:43 -0700 (PDT)
Date:   Sun, 18 Oct 2020 11:59:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>, Willy Tarreau <w@1wt.eu>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, oridgar@gmail.com,
        ghammer@redhat.com, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Message-ID: <20201018115524-mutt-send-email-mst@kernel.org>
References: <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com>
 <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu>
 <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
 <20201017064442.GA14117@1wt.eu>
 <CAG48ez3pXLC+eqAXDCniM0a+5yP2XJODDkZqiUTZUOttCE_LbA@mail.gmail.com>
 <CAHmME9qHGSF8w3DoyCP+ud_N0MAJ5_8zsUWx=rxQB1mFnGcu9w@mail.gmail.com>
 <20201018114625-mutt-send-email-mst@kernel.org>
 <CALCETrXBJZnKXo2QLKVWSgAhSMdwEVHeut6pRw4P92CR_5A-fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXBJZnKXo2QLKVWSgAhSMdwEVHeut6pRw4P92CR_5A-fQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 18, 2020 at 08:54:36AM -0700, Andy Lutomirski wrote:
> On Sun, Oct 18, 2020 at 8:52 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sat, Oct 17, 2020 at 03:24:08PM +0200, Jason A. Donenfeld wrote:
> > > 4c. The guest kernel maintains an array of physical addresses that are
> > > MADV_WIPEONFORK. The hypervisor knows about this array and its
> > > location through whatever protocol, and before resuming a
> > > moved/snapshotted/duplicated VM, it takes the responsibility for
> > > memzeroing this memory. The huge pro here would be that this
> > > eliminates all races, and reduces complexity quite a bit, because the
> > > hypervisor can perfectly synchronize its bringup (and SMP bringup)
> > > with this, and it can even optimize things like on-disk memory
> > > snapshots to simply not write out those pages to disk.
> > >
> > > A 4c-like approach seems like it'd be a lot of bang for the buck -- we
> > > reuse the existing mechanism (MADV_WIPEONFORK), so there's no new
> > > userspace API to deal with, and it'd be race free, and eliminate a lot
> > > of kernel complexity.
> >
> > Clearly this has a chance to break applications, right?
> > If there's an app that uses this as a non-system-calls way
> > to find out whether there was a fork, it will break
> > when wipe triggers without a fork ...
> > For example, imagine:
> >
> > MADV_WIPEONFORK
> > copy secret data to MADV_DONTFORK
> > fork
> >
> >
> > used to work, with this change it gets 0s instead of the secret data.
> >
> >
> > I am also not sure it's wise to expose each guest process
> > to the hypervisor like this. E.g. each process needs a
> > guest physical address of its own then. This is a finite resource.
> >
> >
> > The mmap interface proposed here is somewhat baroque, but it is
> > certainly simple to implement ...
> 
> Wipe of fork/vmgenid/whatever could end up being much more problematic
> than it naively appears -- it could be wiped in the middle of a read.
> Either the API needs to handle this cleanly, or we need something more
> aggressive like signal-on-fork.
> 
> --Andy


Right, it's not on fork, it's actually when process is snapshotted.

If we assume it's CRIU we care about, then I
wonder what's wrong with something like
MADV_CHANGEONPTRACE_SEIZE
and basically say it's X bytes which change the value...


-- 
MST

