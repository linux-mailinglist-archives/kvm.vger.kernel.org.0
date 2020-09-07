Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356FA25F8EE
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 12:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgIGKzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 06:55:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25041 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728978AbgIGKzJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 06:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599476108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XxU1S7tecDzxojavOnKNu2h0OsxG26TYByhyWLemS08=;
        b=QHVQIx6QB3HbfkzFdrFcsBh2fsyHsBy1YRyqCHBDYZQSM5pF8sAFLwSskcDkqluc4s6lxF
        vyt7i/i5tSbOEB1kSwPhAJNC9uXoqcu3a3BzC5YBWKPBz3u2fmLcx75CzWsJZvZgUbtbqQ
        pFRTB9tybq+lEd7fdGgUcqYnHIGeEOk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-XfzPs71VOZei6VyITwVdjQ-1; Mon, 07 Sep 2020 06:55:04 -0400
X-MC-Unique: XfzPs71VOZei6VyITwVdjQ-1
Received: by mail-wr1-f70.google.com with SMTP id i10so5569257wrq.5
        for <kvm@vger.kernel.org>; Mon, 07 Sep 2020 03:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XxU1S7tecDzxojavOnKNu2h0OsxG26TYByhyWLemS08=;
        b=AgdcIJA1SlG8YpTOcp5BW+6R+3r0dDTRXva0770ZiiEsV1lZTvZWAPcbhf5JlCIsvp
         MV82m+npyTKnnbIvtV+XJcGo9rWKnnZByIH0MDqwnVfXT/o+e1gAMKvIIg7ZoladYvvB
         yIV0jdpxp5dPvPOWnAD1dtLOb9ZCxr+WoDjfk50vu+FWG482HQ2UGQtyXj3yPEoDjOkt
         iJWll/8GURzwa1n4B7CKF/73HopZMloUDA43HqyLUFf41E8UOo0HJvXt9eAx726A4+zg
         jX9mndMta2HorKOSCSPfVY8E6UpHHf7++rlUJG8T0Ev+6b6LIfmau486P6GmsHSZtlTT
         wsEQ==
X-Gm-Message-State: AOAM533yOzdI+XfMQLjHGaM+Ft5aHwt0lg/GJNGMNa2EdGYInXg30o1K
        ymLYqDW+ZBO1qOqQl9FSmBOH0u4zsW4eOzNe78QIUUC3U2vRiX5rewtHudJF4hOyGAu2mjeFolR
        Bm6mC+Obr+zwa
X-Received: by 2002:adf:aad1:: with SMTP id i17mr22313669wrc.360.1599476103237;
        Mon, 07 Sep 2020 03:55:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRh0RVoTS4wJEq9bwtw/yeNnBGFMwCjz5azYwSDHlZjIXpjb8+Wk1Eb30YO74MsYVr48RyJQ==
X-Received: by 2002:adf:aad1:: with SMTP id i17mr22313654wrc.360.1599476103044;
        Mon, 07 Sep 2020 03:55:03 -0700 (PDT)
Received: from redhat.com ([192.117.173.58])
        by smtp.gmail.com with ESMTPSA id z7sm19710582wrw.93.2020.09.07.03.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:55:02 -0700 (PDT)
Date:   Mon, 7 Sep 2020 06:54:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200907065313-mutt-send-email-mst@kernel.org>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904061210.GA22435@sjchrist-ice>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 03, 2020 at 11:12:12PM -0700, Sean Christopherson wrote:
> On Wed, Sep 02, 2020 at 10:59:20AM +0200, Vitaly Kuznetsov wrote:
> > Peter Xu <peterx@redhat.com> writes:
> > > My whole point was more about trying to understand the problem behind.
> > > Providing a fast path for reading pci holes seems to be reasonable as is,
> > > however it's just that I'm confused on why there're so many reads on the pci
> > > holes after all.  Another important question is I'm wondering how this series
> > > will finally help the use case of microvm.  I'm not sure I get the whole point
> > > of it, but... if microvm is the major use case of this, it would be good to
> > > provide some quick numbers on those if possible.
> > >
> > > For example, IIUC microvm uses qboot (as a better alternative than seabios) for
> > > fast boot, and qboot has:
> > >
> > > https://github.com/bonzini/qboot/blob/master/pci.c#L20
> > >
> > > I'm kind of curious whether qboot will still be used when this series is used
> > > with microvm VMs?  Since those are still at least PIO based.
> > 
> > I'm afraid there is no 'grand plan' for everything at this moment :-(
> > For traditional VMs 0.04 sec per boot is negligible and definitely not
> > worth adding a feature, memory requirements are also very
> > different. When it comes to microvm-style usage things change.
> > 
> > '8193' PCI hole accesses I mention in the PATCH0 blurb are just from
> > Linux as I was doing direct kernel boot, we can't get better than that
> > (if PCI is in the game of course). Firmware (qboot, seabios,...) can
> > only add more. I *think* the plan is to eventually switch them all to
> > MMCFG, at least for KVM guests, by default but we need something to put
> > to the advertisement. 
> 
> I see a similar ~8k PCI hole reads with a -kernel boot w/ OVMF.  All but 60
> of those are from pcibios_fixup_peer_bridges(), and all are from the kernel.
> My understanding is that pcibios_fixup_peer_bridges() is useful if and only
> if there multiple root buses.  And AFAICT, when running under QEMU, the only
> way for there to be multiple buses in is if there is an explicit bridge
> created ("pxb" or "pxb-pcie").  Based on the cover letter from those[*], the
> main reason for creating a bridge is to handle pinned CPUs on a NUMA system
> with pass-through devices.  That use case seems highly unlikely to cross
> paths with micro VMs, i.e. micro VMs will only ever have a single bus.

My position is it's not all black and white, workloads do not
cleanly partition to these that care about boot speed and those
that don't. So IMHO we care about boot speed with pcie even if
microvm does not use it at the moment.


> Unless I'm mistaken, microvm doesn't even support PCI, does it?
> 
> If all of the above is true, this can be handled by adding "pci=lastbus=0"
> as a guest kernel param to override its scanning of buses.  And couldn't
> that be done by QEMU's microvm_fix_kernel_cmdline() to make it transparent
> to the end user?
> 
> [*] https://www.redhat.com/archives/libvir-list/2016-March/msg01213.html

