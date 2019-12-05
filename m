Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77AEB1147A6
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 20:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbfLETbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 14:31:05 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22469 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726589AbfLETbD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 14:31:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575574261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u8Hn6V4xZsuhZskjbMnVwI4YXgtPw6vOPW0xXiTZfTE=;
        b=iId9owsnxbR5m4LlS1zBwSXafbh+S6Lx3/zZ5o5Bmj1HHBGEwtWQAM5M7+oK9L/aZe+3iO
        Ihz3zIEludLPCGNqWKSQrqNGuVBP/1rvx8U0tYhz1oQW8yPpbAbWATTgtCy2DkYer0Gmuo
        8pBvYpbMOlu7sBV/tYT/h0jpMJIP0yw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-9KWFnLSgPHCzTeIbH7WXsA-1; Thu, 05 Dec 2019 14:30:58 -0500
Received: by mail-qt1-f199.google.com with SMTP id h14so3281156qtq.11
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 11:30:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1U5LLMCJYsaS3NRWFAvsUrEB3QRcXFbIGnRHSgYXow0=;
        b=W8Qt5612LkFlImY8uEpZ4HSfh7AyhTyaymSYCDdCerO64/XhlOpGbpa07+f/QFAsjx
         0rbY+t8Qoj5DhoAKxFr+Fpy4VxNpzNYfWvq31BcBVgcp0kada4RdU2hgx4KRmcVTD+l/
         G+1olLz4psSJ5ACWQ7DrgG5Y8ACT7EPdqSIlNTOP570zAec14XH9oc1VTp4jlhH1b4zp
         cZgs0tA2Qid05or+jhW1J5qQy8m++4HGVLUP661KXT0SHApteFbWf+sL+QDqxfg9tntQ
         kaslEYbZpChcyEkLoj0jBqegbUlLwZeemZjjqYGpFvisbgZKxY/n87mXjDXolALktzJW
         xM0g==
X-Gm-Message-State: APjAAAVD7i8qp0op/ogmcUeSHGCS5KRG5UyFd5HpD6eOJxjdMVrYSV3L
        sofkMumSPpULAoMbnIFS2A11edIrRI26zpshjAebwvfBxNFKcloo4wpO5Vsy392/RJpRKx87bul
        Qnh2A5wAeZlE0
X-Received: by 2002:ac8:7698:: with SMTP id g24mr9087561qtr.200.1575574258073;
        Thu, 05 Dec 2019 11:30:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqwkpVoVUz3h5zS5xwC/ju/ihohoRopafm52tKSbPSkxG8tN5YoTguSF+NAKckwaCdGYC1NwIg==
X-Received: by 2002:ac8:7698:: with SMTP id g24mr9087522qtr.200.1575574257677;
        Thu, 05 Dec 2019 11:30:57 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q35sm5665033qta.19.2019.12.05.11.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 11:30:56 -0800 (PST)
Date:   Thu, 5 Dec 2019 14:30:55 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 00/15] KVM: Dirty ring interface
Message-ID: <20191205193055.GA7201@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <b8f28d8c-2486-2d66-04fd-a2674b598cfd@redhat.com>
 <20191202021337.GB18887@xz-x1>
 <b893745e-96c1-d8e4-85ec-9da257d0d44e@redhat.com>
MIME-Version: 1.0
In-Reply-To: <b893745e-96c1-d8e4-85ec-9da257d0d44e@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-MC-Unique: 9KWFnLSgPHCzTeIbH7WXsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 02:59:14PM +0100, Paolo Bonzini wrote:
> On 02/12/19 03:13, Peter Xu wrote:
> >> This is not needed, it will just be a false negative (dirty page that
> >> actually isn't dirty).  The dirty bit will be cleared when userspace
> >> resets the ring buffer; then the instruction will be executed again an=
d
> >> mark the page dirty again.  Since ring full is not a common condition,
> >> it's not a big deal.
> >=20
> > Actually I added this only because it failed one of the unit tests
> > when verifying the dirty bits..  But now after a second thought, I
> > probably agree with you that we can change the userspace too to fix
> > this.
>=20
> I think there is already a similar case in dirty_log_test when a page is
> dirty but we called KVM_GET_DIRTY_LOG just before it got written to.

If you mean the host_bmap_track (in dirty_log_test.c), that should be
a reversed version of this race (that's where the data is written,
while we didn't see the dirty bit set).  But yes I think I can
probably use the same bitmap to fix the test case, because in both
cases what we want to do is to make sure "the dirty bit of this page
should be set in next round".

>=20
> > I think the steps of the failed test case could be simplified into
> > something like this (assuming the QEMU migration context, might be
> > easier to understand):
> >=20
> >   1. page P has data P1
> >   2. vcpu writes to page P, with date P2
> >   3. vmexit (P is still with data P1)
> >   4. mark P as dirty, ring full, user exit
> >   5. collect dirty bit P, migrate P with data P1
> >   6. vcpu run due to some reason, P was written with P2, user exit agai=
n
> >      (because ring is already reaching soft limit)
> >   7. do KVM_RESET_DIRTY_RINGS
>=20
> Migration should only be done after KVM_RESET_DIRTY_RINGS (think of
> KVM_RESET_DIRTY_RINGS as the equivalent of KVM_CLEAR_DIRTY_LOG).

Totally agree for migration.  It's probably just that the test case
needs fixing.

>=20
> >   dirty_log_test-29003 [001] 184503.384328: kvm_entry:            vcpu =
1
> >   dirty_log_test-29003 [001] 184503.384329: kvm_exit:             reaso=
n EPT_VIOLATION rip 0x40359f info 582 0
> >   dirty_log_test-29003 [001] 184503.384329: kvm_page_fault:       addre=
ss 7fc036d000 error_code 582
> >   dirty_log_test-29003 [001] 184503.384331: kvm_entry:            vcpu =
1
> >   dirty_log_test-29003 [001] 184503.384332: kvm_exit: reason EPT_VIOLAT=
ION rip 0x40359f info 582 0
> >   dirty_log_test-29003 [001] 184503.384332: kvm_page_fault:       addre=
ss 7fc036d000 error_code 582
> >   dirty_log_test-29003 [001] 184503.384332: kvm_dirty_ring_push:  ring =
1: dirty 0x37f reset 0x1c0 slot 1 offset 0x37e ret 0 (used 447)
> >   dirty_log_test-29003 [001] 184503.384333: kvm_entry:            vcpu =
1
> >   dirty_log_test-29003 [001] 184503.384334: kvm_exit:             reaso=
n EPT_VIOLATION rip 0x40359f info 582 0
> >   dirty_log_test-29003 [001] 184503.384334: kvm_page_fault:       addre=
ss 7fc036e000 error_code 582
> >   dirty_log_test-29003 [001] 184503.384336: kvm_entry:            vcpu =
1
> >   dirty_log_test-29003 [001] 184503.384336: kvm_exit:             reaso=
n EPT_VIOLATION rip 0x40359f info 582 0
> >   dirty_log_test-29003 [001] 184503.384336: kvm_page_fault:       addre=
ss 7fc036e000 error_code 582
> >   dirty_log_test-29003 [001] 184503.384337: kvm_dirty_ring_push:  ring =
1: dirty 0x380 reset 0x1c0 slot 1 offset 0x37f ret 1 (used 448)
> >   dirty_log_test-29003 [001] 184503.384337: kvm_dirty_ring_exit:  vcpu =
1
> >   dirty_log_test-29003 [001] 184503.384338: kvm_fpu:              unloa=
d
> >   dirty_log_test-29003 [001] 184503.384340: kvm_userspace_exit:   reaso=
n 0x1d (29)
> >   dirty_log_test-29000 [006] 184503.505103: kvm_dirty_ring_reset: ring =
1: dirty 0x380 reset 0x380 (used 0)
> >   dirty_log_test-29003 [001] 184503.505184: kvm_fpu:              load
> >   dirty_log_test-29003 [001] 184503.505187: kvm_entry:            vcpu =
1
> >   dirty_log_test-29003 [001] 184503.505193: kvm_exit:             reaso=
n EPT_VIOLATION rip 0x40359f info 582 0
> >   dirty_log_test-29003 [001] 184503.505194: kvm_page_fault:       addre=
ss 7fc036f000 error_code 582              <-------- [1]
> >   dirty_log_test-29003 [001] 184503.505206: kvm_entry:            vcpu =
1
> >   dirty_log_test-29003 [001] 184503.505207: kvm_exit:             reaso=
n EPT_VIOLATION rip 0x40359f info 582 0
> >   dirty_log_test-29003 [001] 184503.505207: kvm_page_fault:       addre=
ss 7fc036f000 error_code 582
> >   dirty_log_test-29003 [001] 184503.505226: kvm_dirty_ring_push:  ring =
1: dirty 0x381 reset 0x380 slot 1 offset 0x380 ret 0 (used 1)
> >   dirty_log_test-29003 [001] 184503.505226: kvm_entry:            vcpu =
1
> >   dirty_log_test-29003 [001] 184503.505227: kvm_exit:             reaso=
n EPT_VIOLATION rip 0x40359f info 582 0
> >   dirty_log_test-29003 [001] 184503.505228: kvm_page_fault:       addre=
ss 7fc0370000 error_code 582
> >   dirty_log_test-29003 [001] 184503.505231: kvm_entry:            vcpu =
1
> >   ...
> >=20
> > The test was trying to continuously write to pages, from above log
> > starting from 7fc036d000. The reason 0x1d (29) is the new dirty ring
> > full exit reason.
> >=20
> > So far I'm still unsure of two things:
> >=20
> >   1. Why for each page we faulted twice rather than once.  Take the
> >      example of page at 7fc036e000 above, the first fault didn't
> >      trigger the marking dirty path, while only until the 2nd ept
> >      violation did we trigger kvm_dirty_ring_push.
>=20
> Not sure about that.  Try enabling kvmmmu tracepoints too, it will tell
> you more of the path that was taken while processing the EPT violation.

These new tracepoints are extremely useful (which I didn't notice
before).

So here's the final culprit...

void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
{
        ...
=09spin_lock(&kvm->mmu_lock);
=09/* FIXME: we should use a single AND operation, but there is no
=09 * applicable atomic API.
=09 */
=09while (mask) {
=09=09clear_bit_le(offset + __ffs(mask), memslot->dirty_bitmap);
=09=09mask &=3D mask - 1;
=09}

=09kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
=09spin_unlock(&kvm->mmu_lock);
}

The mask is cleared before reaching
kvm_arch_mmu_enable_log_dirty_pt_masked()..

The funny thing is that I did have a few more patches to even skip
allocate the dirty_bitmap when dirty ring is enabled (hence in that
tree I removed this while loop too, so that has no such problem).
However I dropped those patches when I posted the RFC because I don't
think it's mature, and the selftest didn't complain about that
either..  Though, I do plan to redo that in v2 if you don't disagree.
The major question would be whether the dirty_bitmap could still be
for any use if dirty ring is enabled.

>=20
> If your machine has PML, what you're seeing is likely not-present
> violation, not dirty-protect violation.  Try disabling pml and see if
> the trace changes.
>=20
> >   2. Why we didn't get the last page written again after
> >      kvm_userspace_exit (last page was 7fc036e000, and the test failed
> >      because 7fc036e000 detected change however dirty bit unset).  In
> >      this case the first write after KVM_RESET_DIRTY_RINGS is the line
> >      pointed by [1], I thought it should be a rewritten of page
> >      7fc036e000 because when the user exit happens logically the write
> >      should not happen yet and eip should keep.  However at [1] it's
> >      already writting to a new page.
>=20
> IIUC you should get, with PML enabled:
>=20
> - guest writes to page
> - PML marks dirty bit, causes vmexit
> - host copies PML log to ring, causes userspace exit
> - userspace calls KVM_RESET_DIRTY_RINGS
>   - host marks page as clean
> - userspace calls KVM_RUN
>   - guest writes again to page
>=20
> but the page won't be in the ring until after another vmexit happens.
> Therefore, it's okay to reap the pages in the ring asynchronously, but
> there must be a synchronization point in the testcase sooner or later,
> where all CPUs are kicked out of KVM_RUN.  This synchronization point
> corresponds to the migration downtime.

Yep, currently in the test case I used the same signal trick to kick
the vcpu out to make sure PML buffers are flushed during the vmexit,
before the main thread starts to collect dirty bits.

Thanks,

--=20
Peter Xu

