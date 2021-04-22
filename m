Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B91B367BA6
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhDVIB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhDVIBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 04:01:51 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6EDC06174A;
        Thu, 22 Apr 2021 01:00:24 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id g125so16005479iof.3;
        Thu, 22 Apr 2021 01:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wtfr7O2uONmx0ABungB4kEDY0XFNe5e+ojy+4iH8yEA=;
        b=p8PdxTO6IbO9u7UohErshlbh8icvmz/JDG7y1GqEgk5mFunkPsBVbEJUPRf78Xi2xr
         kSRUtcRVfjbmBxKG0qjsh1/HndZ29CxY5HD9LgYDZpvynQBepAi6pd6zM1ELQsCQQPg/
         VWIbO9mbmcu338Af40wvjIcjKiGSYhoudTq00h3r+mwwNVgyw02UnLBE//yPuxQ6DeIU
         PvhCQFTnqLXragBst0XhiNBKvZYTZ++nQcoicTZ8MMJ4XXJFr6eXNsKDfAoxAQIk+qE2
         S2fv6klbnyzH/XsIGBNYdcUU0vEp8S5guaaWAZS1jDJ+RyeiVvXtD9XfP1bDVA54/3k7
         ke6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wtfr7O2uONmx0ABungB4kEDY0XFNe5e+ojy+4iH8yEA=;
        b=YpKVfdRBtqEbu49p4i+3Fwakk7ax2C47jjtkIRzPCWP9WjuutsDr9WjG4RI/rzWwtG
         azCEhYCWYqlI9Pk0nS0f0A9iNh0weLzccqMeYEGruDUncEv2CP6zHWxdO84VEVVYZS6x
         fK8awCW76tZwl393HWroUB/cu/2HIwKrmgUhXG55YFYFsvHfcGrdrPVnl17UGAXSsUzt
         QNDzhGgyO+StJxCceEKiti6LpWZj55rbEC+3NEFttFf0acn1k8UydKcQGcjdz9m7x+5v
         bEnNrxhw1/su7KVSW1BeckIO+QrI73UyAOkf7TbAjomr/4jqflZoc9iNBOMKEVOqBam8
         SJXg==
X-Gm-Message-State: AOAM531g+wdAPS3QyrE/jlHdMCT3b5R/bV4SZozEvLfjn8F85RnTo5A2
        pdSYebka9Xuy8uh4B7Oye8PYZ4ruDVXMXVk/9dM=
X-Google-Smtp-Source: ABdhPJy1fKaPawu0LnQ0auRQy3Yko2GFa8uyOPy+TR/mQlHmW9sFgOxSaeUrz/hqzwMFlqoFPhsCfX6YuVrosEuiaXY=
X-Received: by 2002:a05:6638:218b:: with SMTP id s11mr2060932jaj.81.1619078424192;
 Thu, 22 Apr 2021 01:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <1603297010-18787-1-git-send-email-sashukla@nvidia.com>
 <8b20dfc0-3b5e-c658-c47d-ebc50d20568d@huawei.com> <2e23aaa7-0c8d-13ba-2eae-9e6ab2adc587@redhat.com>
 <ed8a8b90-8b96-4967-01f5-cd0f536c38d2@huawei.com> <871rb3rgpl.wl-maz@kernel.org>
 <b97415a2-7970-a741-9690-3e4514b4aa7d@redhat.com> <87v98eq0dh.wl-maz@kernel.org>
 <bf782ec1-71da-5a8e-f250-20ed88677b8c@nvidia.com>
In-Reply-To: <bf782ec1-71da-5a8e-f250-20ed88677b8c@nvidia.com>
From:   Santosh Shukla <santosh.shukla1982@gmail.com>
Date:   Thu, 22 Apr 2021 13:30:13 +0530
Message-ID: <CACpj22xhXHMgsZHrL_2AbEzy=zzz=jXz0s6pRb0=zpJUai1ufg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Correctly handle the mmio faulting
To:     "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>
Cc:     Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>,
        Keqian Zhu <zhukeqian1@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        cjia@nvidia.com, linux-arm-kernel@lists.infradead.org,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 1:07 PM Tarun Gupta (SW-GPU)
<targupta@nvidia.com> wrote:
>
>
>
> On 4/22/2021 12:20 PM, Marc Zyngier wrote:
> > External email: Use caution opening links or attachments
> >
> >
> > On Thu, 22 Apr 2021 03:02:00 +0100,
> > Gavin Shan <gshan@redhat.com> wrote:
> >>
> >> Hi Marc,
> >>
> >> On 4/21/21 9:59 PM, Marc Zyngier wrote:
> >>> On Wed, 21 Apr 2021 07:17:44 +0100,
> >>> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> >>>> On 2021/4/21 14:20, Gavin Shan wrote:
> >>>>> On 4/21/21 12:59 PM, Keqian Zhu wrote:
> >>>>>> On 2020/10/22 0:16, Santosh Shukla wrote:
> >>>>>>> The Commit:6d674e28 introduces a notion to detect and handle the
> >>>>>>> device mapping. The commit checks for the VM_PFNMAP flag is set
> >>>>>>> in vma->flags and if set then marks force_pte to true such that
> >>>>>>> if force_pte is true then ignore the THP function check
> >>>>>>> (/transparent_hugepage_adjust()).
> >>>>>>>
> >>>>>>> There could be an issue with the VM_PFNMAP flag setting and checking.
> >>>>>>> For example consider a case where the mdev vendor driver register's
> >>>>>>> the vma_fault handler named vma_mmio_fault(), which maps the
> >>>>>>> host MMIO region in-turn calls remap_pfn_range() and maps
> >>>>>>> the MMIO's vma space. Where, remap_pfn_range implicitly sets
> >>>>>>> the VM_PFNMAP flag into vma->flags.
> >>>>>> Could you give the name of the mdev vendor driver that triggers this issue?
> >>>>>> I failed to find one according to your description. Thanks.
> >>>>>>
> >>>>>
> >>>>> I think it would be fixed in driver side to set VM_PFNMAP in
> >>>>> its mmap() callback (call_mmap()), like vfio PCI driver does.
> >>>>> It means it won't be delayed until page fault is issued and
> >>>>> remap_pfn_range() is called. It's determined from the beginning
> >>>>> that the vma associated the mdev vendor driver is serving as
> >>>>> PFN remapping purpose. So the vma should be populated completely,
> >>>>> including the VM_PFNMAP flag before it becomes visible to user
> >>>>> space.
> >>>
> >>> Why should that be a requirement? Lazy populating of the VMA should be
> >>> perfectly acceptable if the fault can only happen on the CPU side.
> >>>

Right.
Hi keqian,
You can refer to case
http://lkml.iu.edu/hypermail/linux/kernel/2010.3/00952.html

(Sorry Guys, I am not with nvidia, but My quick input.)

> >>
> >> It isn't a requirement and the drivers needn't follow strictly. I checked
> >> several drivers before looking into the patch and found almost all the
> >> drivers have VM_PFNMAP set at mmap() time. In drivers/vfio/vfio-pci.c,
> >> there is a comment as below, but it doesn't reveal too much about why
> >> we can't set VM_PFNMAP at fault time.
> >>
> >> static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> >> {
> >>        :
> >>          /*
> >>           * See remap_pfn_range(), called from vfio_pci_fault() but we can't
> >>           * change vm_flags within the fault handler.  Set them now.
> >>           */
> >>          vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
> >>          vma->vm_ops = &vfio_pci_mmap_ops;
> >>
> >>          return 0;
> >> }
> >>
> >> To set these flags in advance does have advantages. For example,
> >> VM_DONTEXPAND prevents the vma to be merged with another
> >> one. VM_DONTDUMP make this vma isn't eligible for
> >> coredump. Otherwise, the address space, which is associated with the
> >> vma is accessed and unnecessary page faults are triggered on
> >> coredump.  VM_IO and VM_PFNMAP avoids to walk the page frames
> >> associated with the vma since we don't have valid PFN in the
> >> mapping.
> >
> > But PCI clearly isn't the case we are dealing with here, and not
> > everything is VFIO either. I can *today* create a driver that
> > implements a mmap+fault handler, call mmap() on it, pass the result to
> > a memslot, and get to the exact same result Santosh describes.
> >
> > No PCI, no VFIO, just a random driver. We are *required* to handle
> > that.
>
> Agree with Marc here, that kernel should be able to handle it without
> VM_PFNMAP flag set in driver.
>
> For driver reference, you could check the V2 version of this patch that
> got accepted upstream and has details as-to how this can be reproduced
> using vfio-pci: https://www.spinics.net/lists/arm-kernel/msg848491.html
>
> >
> >          M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
> >
