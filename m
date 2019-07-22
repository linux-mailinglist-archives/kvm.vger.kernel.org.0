Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E533A7068B
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 19:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbfGVRMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 13:12:49 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:42033 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbfGVRMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 13:12:48 -0400
Received: by mail-ua1-f68.google.com with SMTP id a97so15618955uaa.9
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 10:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+/7qP7jvywDgUOnDrqW3s3gPrXQy1DnJ3/b8YOX2Xm0=;
        b=CG+CS0VkW7IV0MTyVH2DoKwvqm9q+2Ohhf4rMaEYTs9M6RQI41CbUnCa0kn2f7DS+w
         zg0AYXKfOZmm3BHsSpXtYDFz7wuslXfO5SdvtSb/KLoKOwwuQfkKa5P2ILbARPSEzu6G
         VZvKc546XGL+WLulGQxbWlhsng9QD4cMwVqfJg9cem68DGSqIXNzs70VjDJECccp6BZY
         kS14+5n9pJXJmx7JBH/Fm0KJk67GpKNZYY4mDy0X95Xou5J9jLuiDBh9MDN99B3bCUzQ
         eacl/MMGcCUSJn0yfIBVNqzT1g6ADYSQNX5x+PaRa3MF5xgl4dWiaQuyvSNxdD5mu962
         SkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+/7qP7jvywDgUOnDrqW3s3gPrXQy1DnJ3/b8YOX2Xm0=;
        b=EV0YluQhGnKw29N3+uY8Z27yjKxFPukHAwBgUYvTBJlB24bBYju9AfDDs+ZN0dvI1B
         f532NGjkN0IqA7JPNy8WPuyyoKriwW7MjrWZBAVQWYL7nQlhmdY6+ydZdDp0l8ZN0lD9
         tYvdr2Tsnpa/85YPEE/VulbXqRQg6cMDxBSDfmFDGNGEBeXfPHwWNExb5Q2HxieLm0li
         QPprqOVzw8EqBuXirsIrVUre0JXMKnGciMqNjpwyV9cFvlsQ4yqFoPicEIsVqYWlM3Ur
         hP3whU+FCImFUZr6U6pxhKr2e3P/uaAOhlx1+RgXfP/vGQ2gK9j3HMkIk4iitMdZjh7z
         4mKw==
X-Gm-Message-State: APjAAAUX+k/ELY/tLKYPePQc+rwtW9GMXGmxpZzTP85Gkq2PXQhPG4s2
        RSbYi0k9wupVziQgZbWVAhhcysVmiJhZks/D2Um3yg==
X-Google-Smtp-Source: APXvYqyCVwQAKobrSpwYTL5J9hPGdkQqBJ2Pj9kKE2dnQpZaKItfGFexxXsFaZqRVZZvMzh4FrAQXXT/hdzxKPIh0dw=
X-Received: by 2002:ab0:2746:: with SMTP id c6mr2180464uap.76.1563815567103;
 Mon, 22 Jul 2019 10:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190710201244.25195-1-brijesh.singh@amd.com> <20190710201244.25195-9-brijesh.singh@amd.com>
 <alpine.DEB.2.21.1907211354220.58367@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.21.1907211354220.58367@chino.kir.corp.google.com>
From:   Cfir Cohen <cfir@google.com>
Date:   Mon, 22 Jul 2019 10:12:35 -0700
Message-ID: <CAEU=KTGRCWQH-XxmH+cwMHiXmq7px+qcNMr_6ByO=WvsOewQpA@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     David Rientjes <rientjes@google.com>
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In addition, it seems that svm_page_enc_status_hc() accepts 'gpa',
'npages', 'enc' directly from the guest, and so these can take
arbitrary values. A very large 'npages' could lead to an int overflow
in 'gfn_end = gfn_start + npages', making gfn_end < gfn_start. This
could an OOB access in the bitmap. Concrete example: gfn_start = 2,
npages = -1, gfn_end = 2+(-1) = 1, sev_resize_page_enc_bitmap
allocates a bitmap for a single page (new_size=1), __bitmap_set access
offset gfn_end - gfn_start = -1.


On Sun, Jul 21, 2019 at 1:57 PM David Rientjes <rientjes@google.com> wrote:
>
> On Wed, 10 Jul 2019, Singh, Brijesh wrote:
>
> > diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
> > index da24c138c8d1..94f0611f4d88 100644
> > --- a/Documentation/virtual/kvm/hypercalls.txt
> > +++ b/Documentation/virtual/kvm/hypercalls.txt
> > @@ -141,3 +141,17 @@ a0 corresponds to the APIC ID in the third argument (a2), bit 1
> >  corresponds to the APIC ID a2+1, and so on.
> >
> >  Returns the number of CPUs to which the IPIs were delivered successfully.
> > +
> > +7. KVM_HC_PAGE_ENC_STATUS
> > +-------------------------
> > +Architecture: x86
> > +Status: active
> > +Purpose: Notify the encryption status changes in guest page table (SEV guest)
> > +
> > +a0: the guest physical address of the start page
> > +a1: the number of pages
> > +a2: encryption attribute
> > +
> > +   Where:
> > +     * 1: Encryption attribute is set
> > +     * 0: Encryption attribute is cleared
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 26d1eb83f72a..b463a81dc176 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1199,6 +1199,8 @@ struct kvm_x86_ops {
> >       uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
> >
> >       bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
> > +     int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
> > +                               unsigned long sz, unsigned long mode);
> >  };
> >
> >  struct kvm_arch_async_pf {
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 3089942f6630..431718309359 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -135,6 +135,8 @@ struct kvm_sev_info {
> >       int fd;                 /* SEV device fd */
> >       unsigned long pages_locked; /* Number of pages locked */
> >       struct list_head regions_list;  /* List of registered regions */
> > +     unsigned long *page_enc_bmap;
> > +     unsigned long page_enc_bmap_size;
> >  };
> >
> >  struct kvm_svm {
> > @@ -1910,6 +1912,8 @@ static void sev_vm_destroy(struct kvm *kvm)
> >
> >       sev_unbind_asid(kvm, sev->handle);
> >       sev_asid_free(kvm);
> > +
> > +     kvfree(sev->page_enc_bmap);
> >  }
> >
> >  static void avic_vm_destroy(struct kvm *kvm)
>
> Adding Cfir who flagged this kvfree().
>
> Other freeing of sev->page_enc_bmap in this patch also set
> sev->page_enc_bmap_size to 0 and neither set sev->page_enc_bmap to NULL
> after freeing it.
>
> For extra safety, is it possible to sev->page_enc_bmap = NULL anytime the
> bitmap is kvfreed?
>
> > @@ -2084,6 +2088,7 @@ static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
> >
> >  static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  {
> > +     struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
> >       struct vcpu_svm *svm = to_svm(vcpu);
> >       u32 dummy;
> >       u32 eax = 1;
> > @@ -2105,6 +2110,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >
> >       if (kvm_vcpu_apicv_active(vcpu) && !init_event)
> >               avic_update_vapic_bar(svm, APIC_DEFAULT_PHYS_BASE);
> > +
> > +     /* reset the page encryption bitmap */
> > +     if (sev_guest(vcpu->kvm)) {
> > +             kvfree(sev->page_enc_bmap);
> > +             sev->page_enc_bmap_size = 0;
> > +     }
> >  }
> >
> >  static int avic_init_vcpu(struct vcpu_svm *svm)
>
> What is protecting sev->page_enc_bmap and sev->page_enc_bmap_size in calls
> to svm_vcpu_reset()?
