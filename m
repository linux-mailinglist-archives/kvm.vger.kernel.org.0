Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8033EE8AE
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbhHQIjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:39:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239123AbhHQIjE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 04:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629189510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eDWfLkSlN5DDr5opaCR8xv3o2o1Sobcn9RZQwO1xe0w=;
        b=CIpKWt5kmNqxNa4Dfdk9EVZbCKtf5jWn6joj6UxeIvmXcTlw6Co02xMvo5+41+wuj3pd3J
        xj9+ruWBmqOXKrKlkDxMRpqMyd4aUclhOJgk+AwfgwHjW8joEDHPUgbSPMn4spbW/PzaD+
        arGl8Q8Ejri24O18f184czTUStyuFNc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-2A8L1LjQM3GOyBAVuSwj5Q-1; Tue, 17 Aug 2021 04:38:29 -0400
X-MC-Unique: 2A8L1LjQM3GOyBAVuSwj5Q-1
Received: by mail-wm1-f69.google.com with SMTP id l19-20020a05600c4f13b029025b036c91c6so4781424wmq.2
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:38:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eDWfLkSlN5DDr5opaCR8xv3o2o1Sobcn9RZQwO1xe0w=;
        b=lOjdvzHpEssz0hnkEEXYeR4rkA/U0Qeo17/vhrbexasmXYhi9TAUMRn4R3QXL0E3FD
         TruelZlAXmGfmOFsZrAocgdtRo/MbVSgucWw5FcZ2pEaoMcXu6bRwvuVfpodump5UgMy
         8HLIt5L8QC0xFIPiiYW4AuHy5J5SakVr26/55dzku/yXQ/j07247KcCA+DgrKw0xHcOI
         1Eeoad3l/CJoLnlPNy9b9IE1S3MWgX7l+qYMkdv9QOyH+Y/hQ4H8LobJzoW7vu+Khy0x
         fr4TAec6ArHvOlLdPMcRRdhXikIwHiDQfM0FTn5aGpFRjqMsT9K9GZc4O+EKctG+Xftt
         ZggA==
X-Gm-Message-State: AOAM533RR4ww0P9AEqLYZS5aVitvmM/9tQDfyWjmQxVjmXo/Vi8BqoVT
        YLqufqpbqQP8R7OznJ8g7BkKJ1J7iLS3Kh099ZuGkot4MWjTCFgAA5W02HE8q+erDpulZS8ZEyE
        3Cn7firEsSYpk
X-Received: by 2002:a1c:4d13:: with SMTP id o19mr2122149wmh.183.1629189508527;
        Tue, 17 Aug 2021 01:38:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+YpRik/WyLFBLP4xcBgcpRcSDNfmkGkGXHwJ7qRlbex/gulPHUcjqsHpYHd2a0ODIBd3tbQ==
X-Received: by 2002:a1c:4d13:: with SMTP id o19mr2122136wmh.183.1629189508377;
        Tue, 17 Aug 2021 01:38:28 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id p6sm1614133wrw.50.2021.08.17.01.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 01:38:26 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:38:24 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, qemu-devel@nongnu.org,
        pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YRt1gHThNWvRzUF8@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Steve Rutherford (srutherford@google.com) wrote:
> On Mon, Aug 16, 2021 at 6:37 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > This is an RFC series for Mirror VM support that are
> > essentially secondary VMs sharing the encryption context
> > (ASID) with a primary VM. The patch-set creates a new
> > VM and shares the primary VM's encryption context
> > with it using the KVM_CAP_VM_COPY_ENC_CONTEXT_FROM capability.
> > The mirror VM uses a separate pair of VM + vCPU file
> > descriptors and also uses a simplified KVM run loop,
> > for example, it does not support any interrupt vmexit's. etc.
> > Currently the mirror VM shares the address space of the
> > primary VM.
> Sharing an address space is incompatible with post-copy migration via
> UFFD on the target side. I'll be honest and say I'm not deeply
> familiar with QEMU's implementation of post-copy, but I imagine there
> must be a mapping of guest memory that doesn't fault: on the target
> side (or on both sides), the migration helper will need to have it's
> view of guest memory go through that mapping, or a similar mapping.

Ignoring SEV, our postcopy currently has a single mapping which is
guarded by UFFD. There is no 'no-fault' mapping.  We use the uffd ioctl
to 'place' a page into that space when we receive it.
But yes, I guess that can't work with SEV; as you say; if the helper
has to do the write, it'll have to do it into a shadow that it can write
to, even though the rest of th e guest must UF on access.

> Separately, I'm a little weary of leaving the migration helper mapped
> into the shared address space as writable. Since the migration threads
> will be executing guest-owned code, the guest could use these threads
> to do whatever it pleases (including getting free cycles)a

Agreed.

> . The
> migration helper's code needs to be trusted by both the host and the
> guest. 


> Making it non-writable, sourced by the host, and attested by
> the hardware would mitigate these concerns.

Some people worry about having the host supply the guest firmware,
because they worry they'll be railroaded into using something they
don't actually trust, and if there aim of using SEV etc is to avoid
trusting the cloud owner, that breaks that.

So for them, I think they want the migration helper to be trusted by the
guest and tolerated by the host.

> The host could also try to
> monitor for malicious use of migration threads, but that would be
> pretty finicky.  The host could competitively schedule the migration
> helper vCPUs with the guest vCPUs, but I'd imagine that wouldn't be
> the best for guest performance.

The CPU usage has to go somewhere.

Dave

> 
> --Steve
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

