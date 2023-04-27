Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF29A6F08BC
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 17:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244242AbjD0PvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 11:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244165AbjD0PvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 11:51:06 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE7711B
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 08:51:05 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64115e69e1eso4678623b3a.0
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 08:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682610664; x=1685202664;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/BGmFMzU05ZC8sZHkNJgBYDk4c+irOD6V9U91yPyg9g=;
        b=paDMNiJunl017JsePs93I3EW8GnrmF4BA+oHSO3Osw6zGVWtLuWrBcMRCJQeWgFPpW
         kqUV7h4lT1mAxFALgewPDuVLQjgbEqpxdCX3hOh+gIElgZScbMQiYnMhNWGl/jIaK/Qp
         5RWEi7PZfm2t7ZCOuwGIUAJGkC6FfqWYpOuK/nb1SQpGdKFrPT8QBxKEk3pLf0nFKuA3
         J4LicDbSLsEZh96t9a+zWsVMFTUzKLprFvHc6WQl9lR7Xh6WXEJER2ULFkzozmZ8AVaK
         9Hkh7adpeQlYPe2BMdVEAqYrjm5syMMEk92wdM21XhCS8TDxDjy7ttTlvMnaFErqG1qg
         /rJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682610664; x=1685202664;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/BGmFMzU05ZC8sZHkNJgBYDk4c+irOD6V9U91yPyg9g=;
        b=dQeXj6vjh3oDUCrtnsmTo60bOfS/Y8z5mkPHZwKd2GWDwLvsQ/ZM5LC9IfYapTGYl4
         T7cbmX3nT66TyRELwzVxX0I6zcR5l7K92uedH/T7afaH+UJwp0r4MpE8JalwhUMQfdRc
         T3j1yQAdiN8hJcNMgUajPcQZjXSbLtwLQIRmBqpiwKmHliikJpGVJNgP2cdS494QXfKg
         CBxlbhyzHe3DvLOnhNANZSAeDWVgaTDNVBxUnqJxS6RUiiWCvo99YFqZzTbmjjBBk3vH
         oxvcOCH7MrPvYajmKgncygbtsG3GjHldwxecLRV7ywfLtZ4K4mjOizQyknxJQPKZCys0
         c2Lw==
X-Gm-Message-State: AC+VfDzZV+a7kSBGVXGNRpu3DGIqI6N8P6VyZ0m0jiRWH8hI/ptANA3j
        zQruYGLRl6piPsLDmCPM0m5RxdfDJ9o=
X-Google-Smtp-Source: ACHHUZ59+ZgxJdPJ8IvwnjVNT7f9pMVDASDOgxtt6uXXLATg1aP6+8Xr++R3G4gmwms8I2vSzghonubDKkk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:203:0:b0:528:a60c:c06b with SMTP id
 3-20020a630203000000b00528a60cc06bmr451235pgc.1.1682610664522; Thu, 27 Apr
 2023 08:51:04 -0700 (PDT)
Date:   Thu, 27 Apr 2023 08:51:03 -0700
In-Reply-To: <CAGtprH_-i15UpM-f3p_g-+GgnK87kUbMa1RpvwGDBRr34XzTuQ@mail.gmail.com>
Mime-Version: 1.0
References: <c49aa7b7bbc016b6c8b698ac2ce3b9d866b551f9.1678643052.git.isaku.yamahata@intel.com>
 <20230418190904.1111011-1-vannapurve@google.com> <20230419133841.00001ee8.zhi.wang.linux@gmail.com>
 <CAGtprH_-i15UpM-f3p_g-+GgnK87kUbMa1RpvwGDBRr34XzTuQ@mail.gmail.com>
Message-ID: <ZEqZ5w7EvzUc8Siv@google.com>
Subject: Re: [PATCH v13 098/113] KVM: TDX: Handle TDX PV map_gpa hypercall
From:   Sean Christopherson <seanjc@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com,
        dmatlack@google.com, erdemaktas@google.com,
        isaku.yamahata@gmail.com, kai.huang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, sagis@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023, Vishal Annapurve wrote:
> On Wed, Apr 19, 2023 at 3:38=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.co=
m> wrote:
> >
> > On Tue, 18 Apr 2023 19:09:04 +0000
> > Vishal Annapurve <vannapurve@google.com> wrote:
> >
> > > > +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +   struct kvm *kvm =3D vcpu->kvm;
> > > > +   gpa_t gpa =3D tdvmcall_a0_read(vcpu);
> > > > +   gpa_t size =3D tdvmcall_a1_read(vcpu);
> > > > +   gpa_t end =3D gpa + size;
> > > > +
> > > > +   if (!IS_ALIGNED(gpa, PAGE_SIZE) || !IS_ALIGNED(size, PAGE_SIZE)=
 ||
> > > > +       end < gpa ||
> > > > +       end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
> > > > +       kvm_is_private_gpa(kvm, gpa) !=3D kvm_is_private_gpa(kvm, e=
nd)) {
> > > > +           tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OP=
ERAND);
> > > > +           return 1;
> > > > +   }
> > > > +
> > > > +   return tdx_vp_vmcall_to_user(vcpu);
> > >
> > > This will result into exits to userspace for MMIO regions as well. Do=
es it make
> > > sense to only exit to userspace for guest physical memory regions bac=
ked by
> > > memslots?

No, KVM should exit always, e.g. userspace _could_ choose to create a priva=
te
memslot in response to the guest's request.

> > I think this is necessary as when passing a PCI device to a TD, the gue=
st
> > needs to convert a MMIO region from private to shared, which is not bac=
ked
> > by memslots.

This isn't entirely accurate.  If you're talking about emulated MMIO, then =
there
is no memslot.  But the "passing a PCI device" makes it sound like you're t=
alking
about device passthrough, in which case there is a memslot that points at a=
n actual
MMIO region in the host platform.

In either case, conversions should be unnecessary as MMIO regions should no=
t be
enumerated to the guest as supporting encryption, i.e. the guest should kno=
w from
time zero that those regions are shared.  If we end up with something like =
Hyper-V's
SVSM-based paravisor, then there might be private emulated MMIO, but such a=
 setup
would also come with its own brand of enlightment in the guest.

> KVM could internally handle conversion of regions not backed by

No, KVM should never internally handle conversions, at least not in the ini=
tial
implementation.  And if KVM ever does go down this route, it needs dedicate=
d
support in KVM's uAPI since userspace needs to be kept in the loop, i.e. ne=
eds
to opt-in and be notified of any conversions.
