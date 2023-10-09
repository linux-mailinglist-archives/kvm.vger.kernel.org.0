Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CF97BEAE5
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 21:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378490AbjJITwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 15:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378488AbjJITwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 15:52:35 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D29A4
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 12:52:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a23fed55d7so78320567b3.2
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 12:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696881152; x=1697485952; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yNj1pprsRAKwETqq5Ekq2GPnFYfA7vwnbMFCvxBPbc0=;
        b=1sbG001vaerjQQ/CZsG0w33uTE7wrlhr/E0yGWhKqegVgD2TnWeEdn2qapOH+XuFa6
         t36RH+nI9dtQSMt8JCvh3HGd6YxiLVMx8XCus80CvJL/8U60DoHx8D8d1w8uDhxDFUNl
         sEl4jYVl429eWrYSahmXo/kTzR7RDkri0eoRRASZ42BM3rmztYUsrn4GgZbemgWwDf70
         wCmJu1SAUOQRM7JzMdrftBEKb4SzwMzm6S8c6SgGXHwDhXOU6AWBUfm/XdqfUEV2sRaU
         PQ00duczqjjxCpj4wzJ6ISV80Q/zHVd4AiCWdLJPps2W/9bcT2LAaPVFyLYHRddPimQ8
         BU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696881152; x=1697485952;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yNj1pprsRAKwETqq5Ekq2GPnFYfA7vwnbMFCvxBPbc0=;
        b=VnCw32c9OIj1uqdMtbPL/gDpBe/hOKy/6hOFhM3NXOLzYXmdOPa0nKTO7VryravzNC
         e12SbmgX0qFIrLjUqwHnjQ+UcGrhhf8vI7J0fFLWj+Z7O+8syE3Ybk0yii+y/3CBx4qo
         dLTAZAwjgj6X89ur1taZTlIXwyqj7TTGgYx212XFJqFN0ACsIczoPvpMUYl8KQSUijao
         lKTipgWNnjf6PkFnZrDWdsmOED/enwNaROVTYsB975gt8Ao45YAFb7xixsawftuGsS4N
         wObCYIyF0feGadG6DQUw7OOw0+rAwugmS6mv4VYji+XlF1Tk4y+ATO3+I5U+GCMx+rz8
         piBA==
X-Gm-Message-State: AOJu0YxD2WNsh+a1xzz9orwN1QWlxsHg5dj6uf0Uva0TcRcI0Gniw4n3
        goAZO6OPAvmcIn+vtsBB/pL5yQKnw+Y=
X-Google-Smtp-Source: AGHT+IHRpOvdov34HiTmmE1Yu2fxzpAk3cUCxPQBKUgx1kHzcRi7yR+du7TFlfF3MJl6qAY9vFHc+wgMWkA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c746:0:b0:59f:77f6:6d12 with SMTP id
 i6-20020a81c746000000b0059f77f66d12mr308643ywl.0.1696881152581; Mon, 09 Oct
 2023 12:52:32 -0700 (PDT)
Date:   Mon, 9 Oct 2023 12:52:31 -0700
In-Reply-To: <553e3a0f-156b-e5d2-037b-2d9acaf52329@gmail.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065006.20201-1-yan.y.zhao@intel.com>
 <553e3a0f-156b-e5d2-037b-2d9acaf52329@gmail.com>
Message-ID: <ZSRZ_y64UPXBG6lA@google.com>
Subject: Re: [PATCH v4 01/12] KVM: x86/mmu: helpers to return if KVM honors
 guest MTRRs
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com,
        chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 07, 2023, Like Xu wrote:
> On 14/7/2023 2:50=E2=80=AFpm, Yan Zhao wrote:
> > Added helpers to check if KVM honors guest MTRRs.
> > The inner helper __kvm_mmu_honors_guest_mtrrs() is also provided to
> > outside callers for the purpose of checking if guest MTRRs were honored
> > before stopping non-coherent DMA.
> >=20
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >   arch/x86/kvm/mmu.h     |  7 +++++++
> >   arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
> >   2 files changed, 22 insertions(+)
> >=20
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 92d5a1924fc1..38bd449226f6 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -235,6 +235,13 @@ static inline u8 permission_fault(struct kvm_vcpu =
*vcpu, struct kvm_mmu *mmu,
> >   	return -(u32)fault & errcode;
> >   }
> > +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncohe=
rent_dma);
> > +
> > +static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
> > +{
> > +	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent_dma=
(kvm));
> > +}
> > +
> >   void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_en=
d);
> >   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1e5db621241f..b4f89f015c37 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4516,6 +4516,21 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcp=
u *vcpu,
> >   }
> >   #endif
> > +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncohe=
rent_dma)
>=20
> According to the motivation provided in the comment, the function will no
> longer need to be passed the parameter "struct kvm *kvm" but will rely on
> the global parameters (plus vm_has_noncoherent_dma), removing "*kvm" ?

Yeah, I'll fixup the commit to drop @kvm from the inner helper.  Thanks!
