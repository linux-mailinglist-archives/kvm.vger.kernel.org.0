Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7093FBD24
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 21:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhH3TsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 15:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233673AbhH3TsU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 15:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630352846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7p/HFySufX7Ec/ARNQSZMmnEjbwiFtc+l8ArIs16Qfo=;
        b=SngN1sL0nidh1Tprgw5hqvzJZjZbHYLO7fYYInpfRFgGwu2sK/v+5LwOy0hMUM5r6zPJ8c
        3grLxcwegtItbVi/rcIyB4bi6TL9qyPgAMI9kbWXe6sbQexzlygE2XQzD2rX3WxZMXKrxR
        aueuRo9mhRLHOzyihU6PYuxp5AV+R5M=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-GsxXuInlOoW5rJKTA-d87w-1; Mon, 30 Aug 2021 15:47:24 -0400
X-MC-Unique: GsxXuInlOoW5rJKTA-d87w-1
Received: by mail-lf1-f71.google.com with SMTP id q5-20020ac25fc5000000b003d9227d9edcso2490764lfg.2
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 12:47:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7p/HFySufX7Ec/ARNQSZMmnEjbwiFtc+l8ArIs16Qfo=;
        b=jriTSa+QrqxEcserwB6sgub4EHaQ/5/smFTDl+ivw6kHQgA3RC32EDNav9DDuIVSPu
         /LMdTrXFweHKCcGGfb58st/gx/9/rEsuFobo4J5uc1T6eEVX05Ng2dogmRzYpyTHsCHz
         aNi7Z0C6D/kqWtLrqlGMm83/GyOfrxhagRfyHvBbl7FT/cu7J0Fd7F/uE5obZcSZc/Z+
         Q73HYfqP1drUq76dMvm8SscEkD2c03l32RzIgfxo30h0OIFQ1SiqJTyoAAsf9/Wv6VMw
         +S4tkPmuQuiVVuSeo81jAvLQdb/rJfooQCjT1djZb/q5GpDMgZoGgiFihsPZE8EgxC2m
         YMSA==
X-Gm-Message-State: AOAM532u/TeJ3bO+svoGzXVseommq98vK9fvF+OC/TYcFHWDDACtdntq
        4BhNivBoG0Q+XluE6V3ZeNdDb9tyCsUK+gpkECcwoWyOhKrzfJTo8L1LrbbKlBHvIowg4O/78mJ
        j5pSoGqftGJBwl2mQm6mL+NM5YEmt
X-Received: by 2002:a2e:90cf:: with SMTP id o15mr22292320ljg.14.1630352843040;
        Mon, 30 Aug 2021 12:47:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznUIXAUwxaYc1pT3l5/1NatkQ/kD+6GtozwDSBVoxs81xARSWQiNaDWMLcZ+Vo/mr5xhfBG0iSCSHFvF5EYbQ=
X-Received: by 2002:a2e:90cf:: with SMTP id o15mr22292305ljg.14.1630352842833;
 Mon, 30 Aug 2021 12:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210823143028.649818-1-vkuznets@redhat.com> <20210823143028.649818-5-vkuznets@redhat.com>
 <20210823185841.ov7ejn2thwebcwqk@habkost.net> <87mtp7jowv.fsf@vitty.brq.redhat.com>
 <CAOpTY_ot8teH5x5vVS2HvuMx5LSKLPtyen_ZUM1p7ncci4LFbA@mail.gmail.com>
 <87k0kakip9.fsf@vitty.brq.redhat.com> <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
In-Reply-To: <2df0b6d18115fb7f2701587b7937d8ddae38e36a.camel@redhat.com>
From:   Nitesh Lal <nilal@redhat.com>
Date:   Mon, 30 Aug 2021 15:47:10 -0400
Message-ID: <CAFki+L=1UUbNVn21rh34FMk3sajb=6rUpsqSdrK82FyD+UKcTQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: Fix stack-out-of-bounds memory access
 from ioapic_write_indirect()
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 12:08 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Tue, 2021-08-24 at 16:42 +0200, Vitaly Kuznetsov wrote:
> > Eduardo Habkost <ehabkost@redhat.com> writes:
> >
> > > On Tue, Aug 24, 2021 at 3:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > > > Eduardo Habkost <ehabkost@redhat.com> writes:
> > > >
> > > > > On Mon, Aug 23, 2021 at 04:30:28PM +0200, Vitaly Kuznetsov wrote:
> > > > > > KASAN reports the following issue:
> > > > > >
> > > > > >  BUG: KASAN: stack-out-of-bounds in kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> > > > > >  Read of size 8 at addr ffffc9001364f638 by task qemu-kvm/4798
> > > > > >
> > > > > >  CPU: 0 PID: 4798 Comm: qemu-kvm Tainted: G               X --------- ---
> > > > > >  Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RYM0081C 07/13/2020
> > > > > >  Call Trace:
> > > > > >   dump_stack+0xa5/0xe6
> > > > > >   print_address_description.constprop.0+0x18/0x130
> > > > > >   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> > > > > >   __kasan_report.cold+0x7f/0x114
> > > > > >   ? kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> > > > > >   kasan_report+0x38/0x50
> > > > > >   kasan_check_range+0xf5/0x1d0
> > > > > >   kvm_make_vcpus_request_mask+0x174/0x440 [kvm]
> > > > > >   kvm_make_scan_ioapic_request_mask+0x84/0xc0 [kvm]
> > > > > >   ? kvm_arch_exit+0x110/0x110 [kvm]
> > > > > >   ? sched_clock+0x5/0x10
> > > > > >   ioapic_write_indirect+0x59f/0x9e0 [kvm]
> > > > > >   ? static_obj+0xc0/0xc0
> > > > > >   ? __lock_acquired+0x1d2/0x8c0
> > > > > >   ? kvm_ioapic_eoi_inject_work+0x120/0x120 [kvm]
> > > > > >

[...]

>
>
> I also don't like that ioapic_write_indirect calls the kvm_bitmap_or_dest_vcpus twice,
> and second time with 'old_dest_id'
>
> I am not 100%  sure why old_dest_id/old_dest_mode are needed as I don't see anything in the
> function changing them.
> I think only the guest can change them, so maybe the code deals with the guest changing them
> while the code is running from a different vcpu?
>
> The commit that introduced this code is 7ee30bc132c683d06a6d9e360e39e483e3990708
> Nitesh Narayan Lal, maybe you remember something about it?
>

Apologies for the delay in responding, I just got back from my PTO and
still clearing my inbox. Since you have reviewed this patch the only open
question is the above so I will try to answer that. Please let me know
in case I missed anything.

IIRC IOAPIC can be reconfigured while the previous interrupt is pending or
still processing. In this situation, ioapic_handeld_vectors may go out of
sync as it only records the recently passed configuration. Since with this
commit, we stopped generating requests for all vCPUs we need this chunk of
code to keep ioapic_handled_vectors in sync.

Having said that perhaps there could be a better way of handling this (?).

-- 
Thanks
Nitesh

