Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F252A166AB1
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 00:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgBTXDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 18:03:14 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35141 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729141AbgBTXDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 18:03:14 -0500
Received: by mail-il1-f195.google.com with SMTP id g12so130994ild.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 15:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JxVlzNJVkCyeMSQKW9npW1RB3SKjuELrNiHYWTlDZDg=;
        b=EsYReQDpvGun4xFsx5A4ahEFsbqsSHgQ5iFq0VbG41xAMq775UfN0JmHV3mEEMptIT
         yOmKqK3Y9aL6QnmrQpqGiOQINGg00W8V9+M74bBx1F4c94K+RHTaLpwBC4fN4M9RBwB9
         lLCtGUEvK/A3JqOLUsR7jNLpegvTu3lXlAF9Bg3jpwuTr2bJ98qv2RZqMTEUYGwXtB9a
         SFmQla2O//M8H7GGj90k1QD6eyKNxjbR20J0KQve5ySKe2zJgCGtxzF6OISytnNZskAj
         rAawV/UwJGm6+ocKOwsCGed+MsWGFrEYOPKfwdXmNxIFSEOEe3UMi0poSWl7y0O9+vh5
         u7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JxVlzNJVkCyeMSQKW9npW1RB3SKjuELrNiHYWTlDZDg=;
        b=GGgA+6o8koFrL8PotlAv2MrcJYinF5xrOIRd7fDrcGF/fI83HIsS8o7c5Jb/gkYexz
         0cXLAC1EOsJNcCfXYeNTRz4/DHuZt9ld13dv2/DsBeVKO4K691P29l+6FYHsxIAXyEvW
         zGiSl1H6RnvGq+Dh9aKm11UP7nuvRNEZnpaSWMwpaL/RpmJ7b0pndsT2f/tnDP+rNwGq
         6YbUhU1M7g+r2dPX8ytoEGLOx1Qu8XuQSMjlHGzG5obSGheLwIz0eQiG1Qntz7wAYg2A
         k0Os4SYeENzIYHfOfuYKkf6/DSNSgDEjq468TpWJjT5QRIQmftUwP97DMQNDdu0iBRWv
         beQw==
X-Gm-Message-State: APjAAAXkygizGW9aZP5KRfZAk0RG31Ggcbp0kzlXsC9SHGhdiRlF3hKY
        11Wzu/fBiSfMOpiHZjaWUoJXEfSKAg3rzhEmwDeGE1OQTWQ=
X-Google-Smtp-Source: APXvYqzMPuAyNzktcWJra0GFFiZ/suQa3sAPE5wWwOYoVSw9+0TKoBSYPnfllb1LgSXfE2iL0PIQJT28OjARNfuHvQc=
X-Received: by 2002:a92:4a0a:: with SMTP id m10mr32718868ilf.84.1582239792221;
 Thu, 20 Feb 2020 15:03:12 -0800 (PST)
MIME-Version: 1.0
References: <20200213213036.207625-1-olvaffe@gmail.com> <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com> <CAPaKu7TDtFwF5czdpke1v7NWKf61kw_jVp-E1qQPqs-qbZYnMw@mail.gmail.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D724@SHSMSX104.ccr.corp.intel.com>
 <CAPaKu7Qa6yzRxB10ufNxu+F5S3_GkwofKCm66aB9H4rdWj8fFQ@mail.gmail.com> <AADFC41AFE54684AB9EE6CBC0274A5D19D78EEA2@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D78EEA2@SHSMSX104.ccr.corp.intel.com>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Thu, 20 Feb 2020 15:02:59 -0800
Message-ID: <CAPaKu7SMn22z0NPCt080fujt+OEt4n-fREyTud6584jySGOFpA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 6:13 PM Tian, Kevin <kevin.tian@intel.com> wrote:
> > > Curious... How is such slot exposed to the guest? A reserved memory
> > > region? Is it static or might be dynamically added?
> > The plan is for virtio-gpu device to reserve a huge memory region in
> > the guest.  Memslots may be added dynamically or statically to back
> > the region.
>
> so the region is marked as E820_RESERVED to prevent guest kernel
> from using it for other purpose and then virtio-gpu device will report
> virtio-gpu driver of the exact location of the region through its own
> interface?
The current plan is that the virtio-gpu device will have a bar for the
region, which is like the vram aperture on real GPUs.  The virtio-gpu
driver manages the region like managing vram.

When the guest userspace allocates from vram, the guest kernel
reserves an unused range from the region and tells the host the
offset.  The host allocates a real GPU buffer, maps the buffer, and
add a memslot with gpa==bar_base+offset (or mremap).  When the guest
userspace mmap, the guest kernel does a io_remap_pfn_range.
