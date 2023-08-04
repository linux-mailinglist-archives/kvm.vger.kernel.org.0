Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DD676F7E7
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjHDCfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjHDCfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:35:16 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D3B3C28;
        Thu,  3 Aug 2023 19:35:14 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4fbf09a9139so2811016e87.2;
        Thu, 03 Aug 2023 19:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691116512; x=1691721312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFmzyYyD5pmtGspOrpv62IT17bVhF0Aej/4vUIxQMNI=;
        b=nqEluQtalim6pU3AHduMnW/HB0ZR/ioBRx3swj8NMu6LS41B6Drb7sROf3pA84ZjrJ
         2YMFDap8/mItiFhzsoNfFPslCDNO8HKj4ECCOn8vOhuOM98vmbaTiXomMTIfpUGTtVv6
         1lWfNmjvXDnjkotH/IFdA6jc2l8150cA5bdZEs1wYuisrzS+7vID0vu56izXC55eKfbg
         EnzMh6xBFkCcwHQhRNVxLGg8wLS5Fdacw1iav+nkf0Ok98EBuaMEC+4TtgBIzcoAWlbJ
         36LzdrCyTF9rCTu/E+Hfgry6ahPEAv4DUKAHp+XTtBFlHrur8WmmLwtZwox65s31hwb7
         QPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691116512; x=1691721312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFmzyYyD5pmtGspOrpv62IT17bVhF0Aej/4vUIxQMNI=;
        b=KHU4LTM7BaN040eeB2qk/4AUGveFWbt8ms70VlahgUdmedbXUrEmfRE5VbjPKfDGUR
         XRRKWdDC7BWlG6YuRYMTGdQnVBkdZ5M1TSwh8zcJVvDJFLcmJ92j+YbPCMSQ6NEHLDrO
         xccHTMvlTMn6m+fde3JUVSXxqiDIBZ9dQipGht+fScpkbcaiMeI6rHXmCxswbZq0dV8s
         YUJ/PUWF52c5ZwAdLVLa8ruNgxvfjgFfWA20LXyINKPJQZeQFM9NY3CvbhZ4TaI5ZRDe
         HgCqaUbSwvtUgymBqkwSJEUETIxrYVkKCLOP+MZgX5sco2qSRqzKyJZt6rgdgiXdSi7+
         GQbg==
X-Gm-Message-State: AOJu0YwJJssbUwlHLapqIwLAcqOPEcskhDXNr1/ULhJyyl8N7YKCpgkk
        +4OsFdTSVVXPqJlUPEP7VW2LlsP/Vt+oRy3NkXAm4B5h/SbKsg==
X-Google-Smtp-Source: AGHT+IF02uQbZbGOlGsAoanB3UW8i/TOB31Dj6iLcDAp7yA1AS6ha3g1IUHrp1YqkLMlWf/bxo+DlA/GZP7ieEFxsgo=
X-Received: by 2002:a19:9145:0:b0:4fb:7c40:9f97 with SMTP id
 y5-20020a199145000000b004fb7c409f97mr219976lfj.27.1691116512018; Thu, 03 Aug
 2023 19:35:12 -0700 (PDT)
MIME-Version: 1.0
References: <CALcu4rbFrU4go8sBHk3FreP+qjgtZCGcYNpSiEXOLm==qFv7iQ@mail.gmail.com>
 <ZMwSKy09gsa/dL08@google.com>
In-Reply-To: <ZMwSKy09gsa/dL08@google.com>
From:   Yikebaer Aizezi <yikebaer61@gmail.com>
Date:   Fri, 4 Aug 2023 10:35:00 +0800
Message-ID: <CALcu4rZt5i5UD9vGBb-PdUwNN-OOSEa=ykd+bf2=44Okz1aO0g@mail.gmail.com>
Subject: Re: WARNING in kvm_arch_vcpu_ioctl_run
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just patched it, after dropping the sanity check, I rerun the
reproduce program, and the crash was not triggered.
seems like the problem is fixed for now, Thanks

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B48=E6=9C=884=
=E6=97=A5=E5=91=A8=E4=BA=94 04:46=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jul 27, 2023, Yikebaer Aizezi wrote:
> > Hello, I'm sorry for the mistake in my previous email. I forgot to add
> > a subject. This is my second attempt to send the message.
> >
> > When using Healer to fuzz the latest Linux kernel, the following crash
> > was triggered.
> >
> > HEAD commit: fdf0eaf11452d72945af31804e2a1048ee1b574c (tag: v6.5-rc2)
> >
> > git tree: upstream
> >
> > console output:
> > https://drive.google.com/file/d/1FiemC_AWRT-6EGscpQJZNzYhXZty6BVr/view?=
usp=3Ddrive_link
> > kernel config: https://drive.google.com/file/d/1fgPLKOw7QbKzhK6ya5KUyKy=
FhumQgunw/view?usp=3Ddrive_link
> > C reproducer: https://drive.google.com/file/d/1SiLpYTZ7Du39ubgf1k1BIPlu=
9ZvMjiWZ/view?usp=3Ddrive_link
> > Syzlang reproducer:
> > https://drive.google.com/file/d/1eWSmwvNGOlZNU-0-xsKhUgZ4WG2VLZL5/view?=
usp=3Ddrive_link
> > Similar report:
> > https://groups.google.com/g/syzkaller-bugs/c/C2ud-S1Thh0/m/z4iI7l_dAgAJ
> >
> > If you fix this issue, please add the following tag to the commit:
> > Reported-by: Yikebaer Aizezi <yikebaer61@gmail.com>
> >
> > kvm: vcpu 129: requested lapic timer restore with starting count
> > register 0x390=3D4241646265 (4241646265 ns) > initial count (296265111
> > ns). Using initial count to start timer.
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 1977 at arch/x86/kvm/x86.c:11098
> > kvm_arch_vcpu_ioctl_run+0x152f/0x1830 arch/x86/kvm/x86.c:11098
>
> Well that's annoying.  The WARN is a sanity check that KVM doesn't someho=
w put
> the guest into an uninitialized state while emulating the guest's APIC ti=
mer, but
> I completely overlooked the fact that userspace can simply stuff the shou=
ld-be-
> impossible guest state. *sigh*
>
> Sadly, I think the most reasonable thing to do is to simply drop the sani=
ty check :-(
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0145d844283b..e9e262b244b8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11091,12 +11091,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vc=
pu)
>                         r =3D -EINTR;
>                         goto out;
>                 }
> +
>                 /*
> -                * It should be impossible for the hypervisor timer to be=
 in
> -                * use before KVM has ever run the vCPU.
> +                * Don't bother switching APIC timer emulation from the
> +                * hypervisor timer to the software timer, the only way f=
or the
> +                * APIC timer to be active is if userspace stuffed vCPU s=
tate,
> +                * i.e. put the vCPU and into a nonsensical state.  The o=
nly
> +                * transition out of UNINITIALIZED (without more state st=
uffing
> +                * from userspace) is an INIT, which will reset the local=
 APIC
> +                * and thus smother the timer anyways, i.e. APIC timer IR=
Qs
> +                * will be dropped no matter what.
>                  */
> -               WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
> -
>                 kvm_vcpu_srcu_read_unlock(vcpu);
>                 kvm_vcpu_block(vcpu);
>                 kvm_vcpu_srcu_read_lock(vcpu);
>
