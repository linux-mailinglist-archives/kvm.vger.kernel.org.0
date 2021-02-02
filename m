Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B128530C256
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 15:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhBBOre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 09:47:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231787AbhBBOfi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 09:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612276451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pWynqGmsBPMo2csT8/XD1/efepqrc/Xop2AsNdNMfV8=;
        b=Fem1xK+5Q/CP+MVOoifpu/8tzY9RQYf9CqMHZZrJSpPIw8dy/ojetmcdGsAHjJgV1cLL42
        0ZEAPwBaRRmDZ6GRFXy3Gt5mAPJhLMXbYe4GW8H/0oVo6bvmytV3+dLGLr7LiF2NcUVmQ1
        MxGQKJ79Rpn0OiZtLkIfuZyYHb2+nEM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-5JMikcQwMp6GqxZiGC6OjA-1; Tue, 02 Feb 2021 09:34:09 -0500
X-MC-Unique: 5JMikcQwMp6GqxZiGC6OjA-1
Received: by mail-wr1-f72.google.com with SMTP id z9so12635881wro.11
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 06:34:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pWynqGmsBPMo2csT8/XD1/efepqrc/Xop2AsNdNMfV8=;
        b=jr5s0P5qM1yDs6rrKzRikc+64c+djTouyxrVqJP8V9E3uncJ4cXDYuzDs85rFjgRjJ
         xOA8RujUnPtVwYV9yR/gTzj2+fGLZQQYnipBuPeTfSxzTKQqGXoK/Ds478lPY2Nmlhl8
         8aJCT6f/K0B6XA2N2ZOAcjifT5jtLhXBCr4zJN1BobDtEtcVUjTP6mH93MbV2bPVKd8B
         C3iN7ai4ZSitivOnrx30eo0Tj//3fnFtWpBMAgrJHxHytVYi41gsW4oGnBdk6noV4p7W
         JoAoiKSubB2ip/Z9RKleAUUZQ6IndTO097+YSmqJ9I39829x67AUkmrApeOE6EdVlCxC
         FO7Q==
X-Gm-Message-State: AOAM5335EAOu/6U7zUVYUlXd7DKEAXoMdLk59f26jF4laNzl4yN1vKkT
        +X9sTeCWXE2rmH2qkxOaCTzy5y5vCObhAlwM+CJmgS9EcfuCKvpHiCgg4F+JGWbGCcFAAA/lsxH
        vvTCNt11JCzvA
X-Received: by 2002:a5d:4806:: with SMTP id l6mr24622852wrq.389.1612276448249;
        Tue, 02 Feb 2021 06:34:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx1hCDA2xSSHkNj2aRCVD2MGe1J566UOUcjjiLZk0lXEd3kct9S6G5KO9A8n4axv2y33eEesA==
X-Received: by 2002:a5d:4806:: with SMTP id l6mr24622831wrq.389.1612276448024;
        Tue, 02 Feb 2021 06:34:08 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id q9sm3873912wme.18.2021.02.02.06.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 06:34:05 -0800 (PST)
Date:   Tue, 2 Feb 2021 09:34:00 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Graf <graf@amazon.de>
Cc:     "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "areber@redhat.com" <areber@redhat.com>,
        "ovzxemul@gmail.com" <ovzxemul@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>
Subject: Re: [PATCH v4 0/2] System Generation ID driver and VMGENID backend
Message-ID: <20210202093337-mutt-send-email-mst@kernel.org>
References: <1610453760-13812-1-git-send-email-acatan@amazon.com>
 <20210112074658-mutt-send-email-mst@kernel.org>
 <9952EF0C-CD1D-4EDB-BAB8-21F72C0BF90D@amazon.com>
 <20210127074549-mutt-send-email-mst@kernel.org>
 <7bcd1cf3-d055-db46-95ea-5c023df2f184@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bcd1cf3-d055-db46-95ea-5c023df2f184@amazon.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 28, 2021 at 01:58:12PM +0100, Alexander Graf wrote:
> Hey Michael!
> 
> On 27.01.21 13:47, Michael S. Tsirkin wrote:
> > 
> > On Thu, Jan 21, 2021 at 10:28:16AM +0000, Catangiu, Adrian Costin wrote:
> > > On 12/01/2021, 14:49, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > 
> > >      On Tue, Jan 12, 2021 at 02:15:58PM +0200, Adrian Catangiu wrote:
> > >      > The first patch in the set implements a device driver which exposes a
> > >      > read-only device /dev/sysgenid to userspace, which contains a
> > >      > monotonically increasing u32 generation counter. Libraries and
> > >      > applications are expected to open() the device, and then call read()
> > >      > which blocks until the SysGenId changes. Following an update, read()
> > >      > calls no longer block until the application acknowledges the new
> > >      > SysGenId by write()ing it back to the device. Non-blocking read() calls
> > >      > return EAGAIN when there is no new SysGenId available. Alternatively,
> > >      > libraries can mmap() the device to get a single shared page which
> > >      > contains the latest SysGenId at offset 0.
> > > 
> > >      Looking at some specifications, the gen ID might actually be located
> > >      at an arbitrary address. How about instead of hard-coding the offset,
> > >      we expose it e.g. in sysfs?
> > > 
> > > The functionality is split between SysGenID which exposes an internal u32
> > > counter to userspace, and an (optional) VmGenID backend which drives
> > > SysGenID generation changes based on hw vmgenid updates.
> > > 
> > > The hw UUID you're referring to (vmgenid) is not mmap-ed to userspace or
> > > otherwise exposed to userspace. It is only used internally by the vmgenid
> > > driver to find out about VM generation changes and drive the more generic
> > > SysGenID.
> > > 
> > > The SysGenID u32 monotonic increasing counter is the one that is mmaped to
> > > userspace, but it is a software counter. I don't see any value in using a dynamic
> > > offset in the mmaped page. Offset 0 is fast and easy and most importantly it is
> > > static so no need to dynamically calculate or find it at runtime.
> > 
> > Well you are burning a whole page on it, using an offset the page
> > can be shared with other functionality.
> 
> Currently, the SysGenID lives is one page owned by Linux that we share out
> to multiple user space clients. So yes, we burn a single page of the system
> here.
> 
> If we put more data in that same page, what data would you put there? Random
> other bits from other subsystems? At that point, we'd be reinventing vdso
> all over again, no? Probably with the same problems.
> 
> Which gets me to the second alternative: Reuse VDSO. The problem there is
> that the VDSO is an extremely architecture specific mechanism. Any new
> architecture we'd want to support would need multiple layers of changes in
> multiple layers of both kernel and libc. I'd like to avoid that if we can
> :).
> 
> So that leaves us with either wasting a page per system or not having an
> mmap() interface in the first place.
> 
> The reason we have the mmap() interface is that it's be easier to consume
> for libraries, that are not hooked into the main event loop.
> 
> So, uh, what are you suggesting? :)

I'd drop mmap at this point. I haven't seen a way to use it
that isn't racy.

> 
> Alex
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 

