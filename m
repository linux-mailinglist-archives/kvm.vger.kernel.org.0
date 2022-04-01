Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8454EE5C0
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 03:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243813AbiDABih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 21:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237909AbiDABig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 21:38:36 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3879F25664A;
        Thu, 31 Mar 2022 18:36:48 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2e6650cde1bso16938467b3.12;
        Thu, 31 Mar 2022 18:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u6x01OZCawLHPZ1FUaBYZ0o7IOp3zWuTpMYfW841yjE=;
        b=QjQirwuCkvewHV7TQxirxIwWPMCkWvQHovcw2h2AuW0vjezZFM+OwOhsIefY82l0Hl
         jjAMqon7jpb0w4z8JOTNZ0Ro68h2xlvZiHr03ylZQ61exIzfuRE8odcHeJmqjG55qd2f
         hXCulZTI9YsTDLiWU2ONQX4Cwvxy1Hhvq3j1XDYPBxhTf0ullITVrJP4DeRVKNChGuIr
         rYPk4X/7JAbEVTNq90F5rVO1mDyI0VdZbPoYUU/5BQcSjCSbyqNa4AEXFWh1dvIAJPXy
         f1/oacOuQGM9qXhhPwcslKeGX8YEDFMyNdNffKZV3IVhlIF+9fw1vBVpw+P9rDjgbq8n
         +Z5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u6x01OZCawLHPZ1FUaBYZ0o7IOp3zWuTpMYfW841yjE=;
        b=W9ZF6YzI7OyGaSv8TzyVDRZIoruByYne7NPv+LjdWsj4uat1rb0FQ35jnwv3YB1O+t
         bRjqLVoKEUgXV9yiXWFo28G8HWM3aOKnJpbzp+FIOej2KNcVVExsRGv6uvcu+iQSfifw
         4GsdYcFfcYiJdVzCJrkav47wUGJgOYoOJuRaLjVqFqQVbQvewkq6wGpsqLRHyZmCfLK9
         GVGqW6G4/YASfgTDXG78OJ+LR1v56Wz+l0nzOIbjJLtdRC24a4bOeCqIhOMiaioA+9Vn
         sty623PeXiYfLHADRl32Yp1qTSZ04N5DuRH1CAaWWkr1po0s+m3wRnxv6MjQOvNJuyEQ
         COuQ==
X-Gm-Message-State: AOAM533DJ35s71JwPFiWwzlaS06NhqEI4s8umYMxE4nDvjIXLTBX0VlV
        Xi6V9e9/fS6XJPFT3TLubi+dtlzUXfWiR8KCdG4Z6mjD
X-Google-Smtp-Source: ABdhPJyjfRa3lzqzSM583hEzjxFMmlXHMIzyEkOZ62HPuFJxBtM66x4Ylan/ZVN2HXhSx2pjvg7U03eprxdQBnksazA=
X-Received: by 2002:a05:690c:85:b0:2ea:2e9e:fcdf with SMTP id
 be5-20020a05690c008500b002ea2e9efcdfmr8193295ywb.284.1648777007556; Thu, 31
 Mar 2022 18:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
 <1648216709-44755-3-git-send-email-wanpengli@tencent.com> <YkOembt1lvTEJrx0@google.com>
 <CANRm+Cy66YAyRp0JJuoyp3k-D9HSZbYF3hYO3Vjxz5w1Rz-P3g@mail.gmail.com> <YkYkiLRo+p2T/HQx@google.com>
In-Reply-To: <YkYkiLRo+p2T/HQx@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 1 Apr 2022 09:36:36 +0800
Message-ID: <CANRm+Czk-JYx5TsB=AvjssFS9PEvgSjk0=hKu8yo1U3ECNfOhQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/5] KVM: X86: Add guest interrupt disable state support
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Apr 2022 at 06:00, Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 30, 2022, Wanpeng Li wrote:
> > On Wed, 30 Mar 2022 at 08:04, Sean Christopherson <seanjc@google.com> wrote:
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 50f011a7445a..8e05cbfa9827 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -861,6 +861,7 @@ struct kvm_vcpu_arch {
> > > >               bool preempt_count_enabled;
> > > >               struct gfn_to_hva_cache preempt_count_cache;
> > > >       } pv_pc;
> > > > +     bool irq_disabled;
> > >
> > > This is going to at best be confusing, and at worst lead to bugs  The flag is
> > > valid if and only if the vCPU is not loaded.  I don't have a clever answer, but
> > > this needs to have some form of guard to (a) clarify when it's valid and (b) actively
> > > prevent misuse.
> >
> > How about renaming it to last_guest_irq_disabled and comments as /*
> > Guest irq disabled state, valid iff the vCPU is not loaded */
>
> What about usurping vcpu->run->if_flag?  Userspace could manipulate the data, but
> that should be fine since the data is already guest-controlled.

We should at least update vcpu->run->if_flag during vcpu scheduled for
the purpose of this patch, I think it looks strange for
vcpu->run->if_flag.

    Wanpeng
