Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E46F1A49B1
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 20:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDJSIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 14:08:52 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38161 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgDJSIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 14:08:52 -0400
Received: by mail-lj1-f194.google.com with SMTP id v16so2751036ljg.5
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 11:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sUhp16JyAXiuVZD+Xq/KGWGIHPf1KuPIByY5iiC9qGE=;
        b=Pjv35RyZcGbHR85jkyImo8PhzNnoQxCpYkhbz/5VLfr3tEhXbbX4nCBArGbuQn/wND
         68oXi9ipS2kWbdyuH3pLf0icGWoY3j7e5cE6ZKk03+HyMlC7yH7KFOul/6SHJ6rbs6/W
         Mmuht38PoZGLUlN4WbvW+EtCcgzPJWzG5UvgChsgVu0yhv6DMObr/HYof09zISDqxy9l
         fzUXmQ021l8t3MCmOlRFdpX+KJy2r/UhVOIMtvIEmE3FzHUViBOg3cYlKiylQIaOCM6H
         G5ekC0rS07AXo5GLApal76t/Z3YuPnhN4rdGX7qlbOAvhWVMHE/vJpg0XISjjUhBW1Cq
         pFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sUhp16JyAXiuVZD+Xq/KGWGIHPf1KuPIByY5iiC9qGE=;
        b=RMIdkMAKfLt/tN3VhtpZPyCJKHh45CosXLt8TAkSVJvGR8xIEVrI1qtyYfwxIeM67t
         2jCh9ErAM1mGeqW6/ZtDJx5/4DBUxqFdXaqDDwJq591UFnl8zqfVyMqZrsWwpaN8D91S
         Ue9EJWfodC4H8JYpLV5ZOKbTSkz2a9V1CwUFoBEcgFu81YnKjgyDBRCK2ZEVlk0nGJcj
         e8o4q+Sti9H+bvP7WHtE5M6rdlsjrCXoM/WlhwyGAXc2OHwPRDJBBjgZM7p3wquT8ixK
         iOncN5Fv2x4mDjUZqZ/eDE3tn67djsZ3t0CxEs30YHGrxTAxlP1Wrh3vYz4JVeg40lI8
         Yuow==
X-Gm-Message-State: AGi0PuZ/upAADNLOm+OBijHR6kpYw/COM40Ir5a0EPNfc9CisfmT3hHG
        hT3TlCWhCjh73QTem0Tbjmcj85+FLjxJbImoubpAUw==
X-Google-Smtp-Source: APiQypKHvfgserAeoFRk1o+7Z0zZDqBZMYE0tshy0+mimORB23QPIz7B0BzVxSMN11AkHDyEb5QjhoUrzNf5YKQJeSo=
X-Received: by 2002:a05:651c:c7:: with SMTP id 7mr3628374ljr.124.1586542127789;
 Fri, 10 Apr 2020 11:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585548051.git.ashish.kalra@amd.com> <4d4fbe2b9acda82c04834682900acf782182ec23.1585548051.git.ashish.kalra@amd.com>
 <CABayD+eOCpTGjvxwhtP85j98BKvCxtG8QDBYSC0E08GnaA12jw@mail.gmail.com>
 <20200408014852.GA27608@ashkalra_ubuntu_server> <CABayD+eaeLZ++Hh8RC=5gWehgJs+tN3Ad39Nx7bF4foEido7jw@mail.gmail.com>
 <20200410012344.GA19168@ashkalra_ubuntu_server>
In-Reply-To: <20200410012344.GA19168@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 10 Apr 2020 11:08:11 -0700
Message-ID: <CABayD+f1kcyX9BWMAm2aCCrNGxMc4Ks1pqLPG+-FWiZh3UK09Q@mail.gmail.com>
Subject: Re: [PATCH v6 11/14] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 9, 2020 at 6:23 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> Hello Steve,
>
> On Thu, Apr 09, 2020 at 05:06:21PM -0700, Steve Rutherford wrote:
> > On Tue, Apr 7, 2020 at 6:49 PM Ashish Kalra <ashish.kalra@amd.com> wrot=
e:
> > >
> > > Hello Steve,
> > >
> > > On Tue, Apr 07, 2020 at 05:26:33PM -0700, Steve Rutherford wrote:
> > > > On Sun, Mar 29, 2020 at 11:23 PM Ashish Kalra <Ashish.Kalra@amd.com=
> wrote:
> > > > >
> > > > > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > > > >
> > > > > The ioctl can be used to set page encryption bitmap for an
> > > > > incoming guest.
> > > > >
> > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > Cc: Ingo Molnar <mingo@redhat.com>
> > > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> > > > > Cc: Joerg Roedel <joro@8bytes.org>
> > > > > Cc: Borislav Petkov <bp@suse.de>
> > > > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > > > Cc: x86@kernel.org
> > > > > Cc: kvm@vger.kernel.org
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > > ---
> > > > >  Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++
> > > > >  arch/x86/include/asm/kvm_host.h |  2 ++
> > > > >  arch/x86/kvm/svm.c              | 42 +++++++++++++++++++++++++++=
++++++
> > > > >  arch/x86/kvm/x86.c              | 12 ++++++++++
> > > > >  include/uapi/linux/kvm.h        |  1 +
> > > > >  5 files changed, 79 insertions(+)
> > > > >
> > > > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/=
kvm/api.rst
> > > > > index 8ad800ebb54f..4d1004a154f6 100644
> > > > > --- a/Documentation/virt/kvm/api.rst
> > > > > +++ b/Documentation/virt/kvm/api.rst
> > > > > @@ -4675,6 +4675,28 @@ or shared. The bitmap can be used during t=
he guest migration, if the page
> > > > >  is private then userspace need to use SEV migration commands to =
transmit
> > > > >  the page.
> > > > >
> > > > > +4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
> > > > > +---------------------------------------
> > > > > +
> > > > > +:Capability: basic
> > > > > +:Architectures: x86
> > > > > +:Type: vm ioctl
> > > > > +:Parameters: struct kvm_page_enc_bitmap (in/out)
> > > > > +:Returns: 0 on success, -1 on error
> > > > > +
> > > > > +/* for KVM_SET_PAGE_ENC_BITMAP */
> > > > > +struct kvm_page_enc_bitmap {
> > > > > +       __u64 start_gfn;
> > > > > +       __u64 num_pages;
> > > > > +       union {
> > > > > +               void __user *enc_bitmap; /* one bit per page */
> > > > > +               __u64 padding2;
> > > > > +       };
> > > > > +};
> > > > > +
> > > > > +During the guest live migration the outgoing guest exports its p=
age encryption
> > > > > +bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the pag=
e encryption
> > > > > +bitmap for an incoming guest.
> > > > >
> > > > >  5. The kvm_run structure
> > > > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/a=
sm/kvm_host.h
> > > > > index 27e43e3ec9d8..d30f770aaaea 100644
> > > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > > @@ -1271,6 +1271,8 @@ struct kvm_x86_ops {
> > > > >                                   unsigned long sz, unsigned long=
 mode);
> > > > >         int (*get_page_enc_bitmap)(struct kvm *kvm,
> > > > >                                 struct kvm_page_enc_bitmap *bmap)=
;
> > > > > +       int (*set_page_enc_bitmap)(struct kvm *kvm,
> > > > > +                               struct kvm_page_enc_bitmap *bmap)=
;
> > > > >  };
> > > > >
> > > > >  struct kvm_arch_async_pf {
> > > > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > > > index bae783cd396a..313343a43045 100644
> > > > > --- a/arch/x86/kvm/svm.c
> > > > > +++ b/arch/x86/kvm/svm.c
> > > > > @@ -7756,6 +7756,47 @@ static int svm_get_page_enc_bitmap(struct =
kvm *kvm,
> > > > >         return ret;
> > > > >  }
> > > > >
> > > > > +static int svm_set_page_enc_bitmap(struct kvm *kvm,
> > > > > +                                  struct kvm_page_enc_bitmap *bm=
ap)
> > > > > +{
> > > > > +       struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> > > > > +       unsigned long gfn_start, gfn_end;
> > > > > +       unsigned long *bitmap;
> > > > > +       unsigned long sz, i;
> > > > > +       int ret;
> > > > > +
> > > > > +       if (!sev_guest(kvm))
> > > > > +               return -ENOTTY;
> > > > > +
> > > > > +       gfn_start =3D bmap->start_gfn;
> > > > > +       gfn_end =3D gfn_start + bmap->num_pages;
> > > > > +
> > > > > +       sz =3D ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
> > > > > +       bitmap =3D kmalloc(sz, GFP_KERNEL);
> > > > > +       if (!bitmap)
> > > > > +               return -ENOMEM;
> > > > > +
> > > > > +       ret =3D -EFAULT;
> > > > > +       if (copy_from_user(bitmap, bmap->enc_bitmap, sz))
> > > > > +               goto out;
> > > > > +
> > > > > +       mutex_lock(&kvm->lock);
> > > > > +       ret =3D sev_resize_page_enc_bitmap(kvm, gfn_end);
> > > > I realize now that usermode could use this for initializing the
> > > > minimum size of the enc bitmap, which probably solves my issue from
> > > > the other thread.
> > > > > +       if (ret)
> > > > > +               goto unlock;
> > > > > +
> > > > > +       i =3D gfn_start;
> > > > > +       for_each_clear_bit_from(i, bitmap, (gfn_end - gfn_start))
> > > > > +               clear_bit(i + gfn_start, sev->page_enc_bmap);
> > > > This API seems a bit strange, since it can only clear bits. I would
> > > > expect "set" to force the values to match the values passed down,
> > > > instead of only ensuring that cleared bits in the input are also
> > > > cleared in the kernel.
> > > >
> > >
> > > The sev_resize_page_enc_bitmap() will allocate a new bitmap and
> > > set it to all 0xFF's, therefore, the code here simply clears the bits
> > > in the bitmap as per the cleared bits in the input.
> >
> > If I'm not mistaken, resize only reinitializes the newly extended part
> > of the buffer, and copies the old values for the rest.
> > With the API you proposed you could probably reimplement a normal set
> > call by calling get, then reset, and then set, but this feels
> > cumbersome.
> >
>
> As i mentioned earlier, the set api is basically meant for the incoming
> VM, the resize will initialize the incoming VM's bitmap to all 0xFF's
> and as there won't be any bitmap allocated initially on the incoming VM,
> therefore, the bitmap copy will not do anything and the clear_bit later
> will clear the incoming VM's bits as per the input.

The documentation does not make that super clear. A typical set call
in the KVM API let's you go to any state, not just a subset of states.
Yes, this works in the common case of migrating a VM to a particular
target, once. I find the behavior of the current API surprising. I
prefer APIs that are unsurprising. If I were to not have read the
code, it would be very easy for me to have assumed it worked like a
normal set call. You could rename the ioctl something like
"CLEAR_BITS", but a set based API is more common.

Thanks,
Steve
