Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1F166A4E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 23:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgBTWYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 17:24:11 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42414 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgBTWYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 17:24:10 -0500
Received: by mail-io1-f68.google.com with SMTP id z1so188589iom.9
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 14:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tsmcUsdlHKDCw+VMlkQEni+reRDwiML4gVNPgDLEcIc=;
        b=YTgATJsIaaWc3wzV72PET63d49kA2ZpVIRFcnPSAp+4y5BP5SXpT0Ov0c8fTU+o8o7
         rUPRDxG/KyzGlSf2MUSxZ/PJ0Pw8OFM1yr5gCyj7Bnwz0sIaK1YerMAZ6+NtFvhOSh6C
         3SFIsbFbF0u5iLxRggv1s5FJ8f/GeZh/ZEKgQRSn53aOksyVfo5ms4QHejunntIr4l/a
         6hBzlJGfvfRHCv8NRMaLT6wjX753nnO91xAOnaw8uptTEjlIv4xP6D+UQbzbqQx1tjfh
         QK7upsQTI3zQMVJBrsenpeFa4QsOazjuo/pklumENIkXSAS9qkW79ZYdOEikdbAJlvRs
         CH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tsmcUsdlHKDCw+VMlkQEni+reRDwiML4gVNPgDLEcIc=;
        b=Uv61aoUSLHpULOgetmBPEQC1fENcfpQfQh0HHoj/ob9mdNKkic33p02BL9MVdNhJ+3
         Z9D3VbypRP9hS6Qc9AIBv+RvCOk+mfoF48zEjZCwD96N4awB30wf8R7dnI+pZ8D7chcb
         I5PSiDR//7D4b/X189glG5sj/AlP1er52ZtcdvBMBE1UgBR1tmuBRX6+FdzvMkBkZQ5K
         G/ILVQcmNPxxzDfs8uxnpNA2HmPy48re9dpAd292w5MNDElPRp/j3eBpT9RT5HJg6w+A
         ZXNd6KoUKvW5SlDxXHcbG/pc7zcorBtEwCKHhl2dFbQJFA6du4uMRAWwVesVoOURPAYx
         dUkg==
X-Gm-Message-State: APjAAAVgiLch8VMtvaowcc18/NGC49PT98ZZwnczQ9oGJ7oM4PoDqwgI
        JBcJmzOmy8OMrG12UUAtHj3FNFV99tNE00tm88Y=
X-Google-Smtp-Source: APXvYqyUbRTNVwg05BeiCaPkZCozjLSPUT452+epOUvICtRc8VU4uC01VSD9I8LdpJYpdG/8h2/rGc4xdkpa3waEIgY=
X-Received: by 2002:a02:c856:: with SMTP id r22mr27413243jao.67.1582237447925;
 Thu, 20 Feb 2020 14:24:07 -0800 (PST)
MIME-Version: 1.0
References: <20200213213036.207625-1-olvaffe@gmail.com> <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com> <20200214195229.GF20690@linux.intel.com>
 <CAPaKu7Q4gehyhEgG_Nw=tiZiTh+7A8-uuXq1w4he6knp6NWErQ@mail.gmail.com>
 <CALMp9eRwTxdqxAcobZ7sYbD=F8Kga=jR3kaz-OEYdA9fV0AoKQ@mail.gmail.com>
 <20200214220341.GJ20690@linux.intel.com> <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D6F4@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7RyTbuTPf0Tp=0DAD80G-RySLrON8OQsHJzhAYDh7zHuA@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78EE65@SHSMSX104.ccr.corp.intel.com> <AADFC41AFE54684AB9EE6CBC0274A5D19D78EF58@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D78EF58@SHSMSX104.ccr.corp.intel.com>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Thu, 20 Feb 2020 14:23:51 -0800
Message-ID: <CAPaKu7RFY3nar9hmAdx6RYdZFPK3Cdg1O3cS+OvsEOT=yupyrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 6:38 PM Tian, Kevin <kevin.tian@intel.com> wrote:
>
> > From: Tian, Kevin
> > Sent: Thursday, February 20, 2020 10:05 AM
> >
> > > From: Chia-I Wu <olvaffe@gmail.com>
> > > Sent: Thursday, February 20, 2020 3:37 AM
> > >
> > > On Wed, Feb 19, 2020 at 1:52 AM Tian, Kevin <kevin.tian@intel.com> wrote:
> > > >
> > > > > From: Paolo Bonzini
> > > > > Sent: Wednesday, February 19, 2020 12:29 AM
> > > > >
> > > > > On 14/02/20 23:03, Sean Christopherson wrote:
> > > > > >> On Fri, Feb 14, 2020 at 1:47 PM Chia-I Wu <olvaffe@gmail.com>
> > wrote:
> > > > > >>> AFAICT, it is currently allowed on ARM (verified) and AMD (not
> > > > > >>> verified, but svm_get_mt_mask returns 0 which supposedly means
> > > the
> > > > > NPT
> > > > > >>> does not restrict what the guest PAT can do).  This diff would do the
> > > > > >>> trick for Intel without needing any uapi change:
> > > > > >> I would be concerned about Intel CPU errata such as SKX40 and
> > SKX59.
> > > > > > The part KVM cares about, #MC, is already addressed by forcing UC
> > for
> > > > > MMIO.
> > > > > > The data corruption issue is on the guest kernel to correctly use WC
> > > > > > and/or non-temporal writes.
> > > > >
> > > > > What about coherency across live migration?  The userspace process
> > > would
> > > > > use cached accesses, and also a WBINVD could potentially corrupt guest
> > > > > memory.
> > > > >
> > > >
> > > > In such case the userspace process possibly should conservatively use
> > > > UC mapping, as if for MMIO regions on a passthrough device. However
> > > > there remains a problem. the definition of KVM_MEM_DMA implies
> > > > favoring guest setting, which could be whatever type in concept. Then
> > > > assuming UC is also problematic. I'm not sure whether inventing another
> > > > interface to query effective memory type from KVM is a good idea. There
> > > > is no guarantee that the guest will use same type for every page in the
> > > > same slot, then such interface might be messy. Alternatively, maybe
> > > > we could just have an interface for KVM userspace to force memory type
> > > > for a given slot, if it is mainly used in para-virtualized scenarios (e.g.
> > > > virtio-gpu) where the guest is enlightened to use a forced type (e.g. WC)?
> > > KVM forcing the memory type for a given slot should work too.  But the
> > > ignore-guest-pat bit seems to be Intel-specific.  We will need to
> > > define how the second-level page attributes combine with the guest
> > > page attributes somehow.
> >
> > oh, I'm not aware of that difference. without an ipat-equivalent
> > capability, I'm not sure how to forcing random type here. If you look at
> > table 11-7 in Intel SDM, none of MTRR (EPT) memory type can lead to
> > consistent effective type when combining with random PAT value. So
> >  it is definitely a dead end.
> >
> > >
> > > KVM should in theory be able to tell that the userspace region is
> > > mapped with a certain memory type and can force the same memory type
> > > onto the guest.  The userspace does not need to be involved.  But that
> > > sounds very slow?  This may be a dumb question, but would it help to
> > > add KVM_SET_DMA_BUF and let KVM negotiate the memory type with the
> > > in-kernel GPU drivers?
> > >
> > >
> >
> > KVM_SET_DMA_BUF looks more reasonable. But I guess we don't need
> > KVM to be aware of such negotiation. We can continue your original
> > proposal to have KVM simply favor guest memory type (maybe still call
> > KVM_MEM_DMA). On the other hand, Qemu should just mmap on the
> > fd handle of the dmabuf passed from the virtio-gpu device backend,  e.g.
> > to conduct migration. That way the mmap request is finally served by
> > DRM and underlying GPU drivers, with proper type enforced automatically.
> >
>
> Thinking more possibly we don't need introduce new interface to KVM.
> As long as Qemu uses dmabuf interface to mmap the specific region,
> KVM can simply check memory type in host page table given hva of a
> memslot. If the type is UC or WC, it implies that userspace wants a
> non-coherent mapping which should be reflected in the guest side too.
> In such case, KVM can go to non-cohenrent DMA path and favor guest
> memory type automatically.
Sorry, I mixed two things together.

Userspace access to dmabuf mmap must be guarded by
DMA_BUF_SYNC_{START,END} ioctls.  It is possible that the GPU driver
always picks a WB mapping and let the ioctls flush/invalidate CPU
caches.  We actually want the guest memory type to match vkMapMemory's
memory type, which can be different from dmabuf mmap's memory type.
It is not enough for KVM to inspect the hva's memory type.

KVM_SET_DMA_BUF, if supported, is a signal to KVM that the guest
memory type should be honored (or forced if there is a new op in
dma_buf_ops that tells KVM which memory type to force).  KVM_MEM_DMA
flag in this RFC sends the same signal.  Unless KVM_SET_DMA_BUF gives
the userspace other features such as setting unlimited number of
dmabufs to subregions of a memslot, it is not very useful.

If uapi change is to be avoided, it is the easiest that guest memory
type is always honored unless it causes #MC (i.e.,is_mmio==true).


>
> Thanks
> Kevin
