Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B556EFF46
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 04:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbjD0CQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 22:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242709AbjD0CQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 22:16:06 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235B344B6
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 19:15:44 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-504e232fe47so14487527a12.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 19:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682561742; x=1685153742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=02EB8lWmRXBMg/YSPs91annKeQmHvtgYDrDPc10O4eo=;
        b=tueVR2BvSg7sc3EnvgmCuorRpTDplKVQgXOZQPd/BGX04Z8PAkSH3rn0a+m5W0lpGi
         dwyk77pFLUILnbJI9PZrrm0rjvpud9WZQ5UgjBmpSM7Uq1I3aLPdJU5BM/lh0XCIgjN5
         dsVBRjIwZUzlM5O3Trbidpa/edNAORa6l1OK3ml2ZwVAUD70iHZ0HvyoJPpS4aP1RbyI
         agxxkhV4TGWb868qLy8OfYqyEYQRV9AWGdyg7QjdbPz/f5GByoYJdISrhX1qxwGF0IE3
         YaEzw+Sg00tEqgbA8Jd1m8C9NsjqNxbXLf+M3r56MVzP6+kQyFZ95uX6UTxMsf00iXmb
         Hw2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682561742; x=1685153742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=02EB8lWmRXBMg/YSPs91annKeQmHvtgYDrDPc10O4eo=;
        b=f3R+70Ws3PJTnSWkg7w8xeToEE6WxW6ngyDYQ9j1Rgia2BvvcC3iIAsb8Xte7lU0me
         Lui12xC1SKqanUOlu5yRERdr1hMgcUEwbSLu95HW6BG7+dO3/hNjVnb6nRd9RzyjdxDd
         9ETmHDVjitWte4T6dpyXwpT/B1WEbLBZgWgJH0YA7VYA2cl3aXeqrDD2M6JoFDaOT+9C
         gHfLpUmSsqT9nBmGILR/gZK8zJkaKfmKYry4CctVMQqhAIUGjzLESWI1vAje7quEN13J
         /3aklnFzT3RjTyfypBUCvZ+w/FVY96xUVAu0IFUSSf3yrC6h/MxNd3uR4usCqMGW2i3D
         QSIQ==
X-Gm-Message-State: AC+VfDwjKskr/UqUZulnEJb8D/C80GNmoHJ9JH2tglXqtZevdoIyzJdJ
        Qob9jdoMBmKwNDs6WIcubObVR0nbfXyQJs9TARo4uA==
X-Google-Smtp-Source: ACHHUZ5RXP7XWa4tSJ3clLjTixGZnD02rJ3RQg2AaLUChumN7wKktDgIWVMKzVu+U1EPZbDpzEj+Yc6ywFvTeJFwLfk=
X-Received: by 2002:a17:907:2cc6:b0:94e:c867:683d with SMTP id
 hg6-20020a1709072cc600b0094ec867683dmr55794ejc.54.1682561741832; Wed, 26 Apr
 2023 19:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <c49aa7b7bbc016b6c8b698ac2ce3b9d866b551f9.1678643052.git.isaku.yamahata@intel.com>
 <20230418190904.1111011-1-vannapurve@google.com> <20230419133841.00001ee8.zhi.wang.linux@gmail.com>
In-Reply-To: <20230419133841.00001ee8.zhi.wang.linux@gmail.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Wed, 26 Apr 2023 19:15:30 -0700
Message-ID: <CAGtprH_-i15UpM-f3p_g-+GgnK87kUbMa1RpvwGDBRr34XzTuQ@mail.gmail.com>
Subject: Re: [PATCH v13 098/113] KVM: TDX: Handle TDX PV map_gpa hypercall
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, dmatlack@google.com,
        erdemaktas@google.com, isaku.yamahata@gmail.com,
        kai.huang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        sagis@google.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 3:38=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.com>=
 wrote:
>
> On Tue, 18 Apr 2023 19:09:04 +0000
> Vishal Annapurve <vannapurve@google.com> wrote:
>
> > > +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
> > > +{
> > > +   struct kvm *kvm =3D vcpu->kvm;
> > > +   gpa_t gpa =3D tdvmcall_a0_read(vcpu);
> > > +   gpa_t size =3D tdvmcall_a1_read(vcpu);
> > > +   gpa_t end =3D gpa + size;
> > > +
> > > +   if (!IS_ALIGNED(gpa, PAGE_SIZE) || !IS_ALIGNED(size, PAGE_SIZE) |=
|
> > > +       end < gpa ||
> > > +       end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
> > > +       kvm_is_private_gpa(kvm, gpa) !=3D kvm_is_private_gpa(kvm, end=
)) {
> > > +           tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPER=
AND);
> > > +           return 1;
> > > +   }
> > > +
> > > +   return tdx_vp_vmcall_to_user(vcpu);
> >
> > This will result into exits to userspace for MMIO regions as well. Does=
 it make
> > sense to only exit to userspace for guest physical memory regions backe=
d by
> > memslots?
> >
> I think this is necessary as when passing a PCI device to a TD, the guest=
 needs to convert a MMIO region from private to shared, which is not backed=
 by memslots.

KVM could internally handle conversion of regions not backed by
private memslots instead of exiting to userspace. This could save time
during guest boot process.

What would be the expectations from userspace for handling mapgpa
operations on MMIO regions? Is it to just convert memory attributes?

> > > +}
> > > +
>
