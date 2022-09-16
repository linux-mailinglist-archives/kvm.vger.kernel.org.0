Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAF95BA3BB
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 03:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiIPBKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 21:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiIPBKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 21:10:37 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6371150076;
        Thu, 15 Sep 2022 18:10:35 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j12so19711281pfi.11;
        Thu, 15 Sep 2022 18:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date;
        bh=hr/gJPcU5hvQZ/MKgVwi2KwSsJ/0TzKkNDXlKjCB2Yw=;
        b=hq/LIZNAoz+v9v5PWfa/0aKD/JB/tXkKxHIojwHn30BdKNQ5Be3G0BaUU/zSYBJeE9
         ZLRcqcxf0IDv61ZhN3/kOqcYUToLQAGW/EjhSW4TrFFz9Bqw+yJyw6+Y21pYn3ywkugA
         JniDjX5JcG8m+H85hzbd3loI476IGJYE6L2/G3cL1NfdXgiVnH9OkTHI/WNBlcsCgoy5
         g9uCl3lHdNcq9lab3lKR95Gy8j5E77OSw8jBZYVJGKBEcNBuiYVGD3iTUzbt+3PGUA5n
         JN6BFkpeFxXKeqmd35cSdKJ5epc1LwvYjnXD/rPy7wE+YH+9cFaQxJc+tbgJ5HWLDqSc
         5Zhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date;
        bh=hr/gJPcU5hvQZ/MKgVwi2KwSsJ/0TzKkNDXlKjCB2Yw=;
        b=cCBmv2qfxgMP+orlpGYYEHbuJotF8OBPH0PqmNWszLLoIUZKYllO7wHjhb9Kd3uat8
         BZ9wStvUXe53K23PSTG6kGRc863Q9UXhqP2rrSEMaNAMvcyZ1NFeMy9WJ1eyl/12S94o
         yn3jAQxDrYBzoXFHjgrdZHKHMEhvDmBIpu++oxkH+XJqV8zUMxlQjpG3rLKgnhfnPNjd
         SeRN1ZgPRVdFZZTPBDKMA/BwQT7aeAWW6iOk1lvj9u7V2/79cUHfhN9B9bYb6MjdxsUA
         7MaludLurT4XdU6KrcXUlOyZzjeZdFF/qb4XpxsduSNx6/Na1rPRJ+uSLXQre7yJT2QD
         54Xg==
X-Gm-Message-State: ACrzQf13poYiRjnG39LLMcHrxtxWS+J9RATB2lRib5bv9C7HGfr2gqvD
        82seE5OLJ1u0qimy+8jdNRWYv0/HMkA=
X-Google-Smtp-Source: AMsMyM5HLVuDEFZ7yFGWlTXtrR5ixkZIR3wBKnru30CnmTKTvOjZydafHw2K7xojMyDBGaMDjl15+A==
X-Received: by 2002:a05:6a00:1342:b0:545:4d30:eecb with SMTP id k2-20020a056a00134200b005454d30eecbmr2511913pfu.69.1663290634936;
        Thu, 15 Sep 2022 18:10:34 -0700 (PDT)
Received: from localhost ([118.210.107.131])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902f68600b00176b3d7db49sm13769119plg.0.2022.09.15.18.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 18:10:33 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 16 Sep 2022 11:10:25 +1000
Message-Id: <CMXFBGZGQCQR.2FRWNY2JHBVL9@bobo>
Cc:     <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>,
        "Fabiano Rosas" <farosas@linux.ibm.com>, <x86@kernel.org>,
        <linux-mips@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        <kvm-riscv@lists.infradead.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        <linux-riscv@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH kernel] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE platform
 dependent
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Alexey Kardashevskiy" <aik@ozlabs.ru>, <kvm-ppc@vger.kernel.org>
X-Mailer: aerc 0.11.0
References: <20220504074807.3616813-1-aik@ozlabs.ru>
 <0d4bb0fa-10c6-3f5a-34c8-293144b3fdbb@ozlabs.ru>
 <59dfb450-5a91-f27b-6edf-0adfa89729b7@ozlabs.ru>
In-Reply-To: <59dfb450-5a91-f27b-6edf-0adfa89729b7@ozlabs.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems okay to me, it probably better go through the KVM tree though.

Acked-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

On Tue Sep 13, 2022 at 10:50 PM AEST, Alexey Kardashevskiy wrote:
> Ping? It's been a while and probably got lost :-/
>
> On 18/05/2022 16:27, Alexey Kardashevskiy wrote:
> >=20
> >=20
> > On 5/4/22 17:48, Alexey Kardashevskiy wrote:
> >> When introduced, IRQFD resampling worked on POWER8 with XICS. However
> >> KVM on POWER9 has never implemented it - the compatibility mode code
> >> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
> >> XIVE mode does not handle INTx in KVM at all.
> >>
> >> This moved the capability support advertising to platforms and stops
> >> advertising it on XIVE, i.e. POWER9 and later.
> >>
> >> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> ---
> >>
> >>
> >> Or I could move this one together with KVM_CAP_IRQFD. Thoughts?
> >=20
> >=20
> > Ping?
> >=20
> >>
> >> ---
> >> =C2=A0 arch/arm64/kvm/arm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 3 ++=
+
> >> =C2=A0 arch/mips/kvm/mips.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 3 ++=
+
> >> =C2=A0 arch/powerpc/kvm/powerpc.c | 6 ++++++
> >> =C2=A0 arch/riscv/kvm/vm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
 3 +++
> >> =C2=A0 arch/s390/kvm/kvm-s390.c=C2=A0=C2=A0 | 3 +++
> >> =C2=A0 arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 3 +++
> >> =C2=A0 virt/kvm/kvm_main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
 1 -
> >> =C2=A0 7 files changed, 21 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> >> index 523bc934fe2f..092f0614bae3 100644
> >> --- a/arch/arm64/kvm/arm.c
> >> +++ b/arch/arm64/kvm/arm.c
> >> @@ -210,6 +210,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
=20
> >> long ext)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_SET_GUEST_DEBUG:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_VCPU_ATTRIBUTES:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_PTP_KVM:
> >> +#ifdef CONFIG_HAVE_KVM_IRQFD
> >> +=C2=A0=C2=A0=C2=A0 case KVM_CAP_IRQFD_RESAMPLE:
> >> +#endif
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D 1;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_SET_GUEST_DEBUG2:
> >> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> >> index a25e0b73ee70..0f3de470a73e 100644
> >> --- a/arch/mips/kvm/mips.c
> >> +++ b/arch/mips/kvm/mips.c
> >> @@ -1071,6 +1071,9 @@ int kvm_vm_ioctl_check_extension(struct kvm=20
> >> *kvm, long ext)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_READONLY_MEM:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_SYNC_MMU:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_IMMEDIATE_EXIT:
> >> +#ifdef CONFIG_HAVE_KVM_IRQFD
> >> +=C2=A0=C2=A0=C2=A0 case KVM_CAP_IRQFD_RESAMPLE:
> >> +#endif
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D 1;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_NR_VCPUS:
> >> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> >> index 875c30c12db0..87698ffef3be 100644
> >> --- a/arch/powerpc/kvm/powerpc.c
> >> +++ b/arch/powerpc/kvm/powerpc.c
> >> @@ -591,6 +591,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
=20
> >> long ext)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> =C2=A0 #endif
> >> +#ifdef CONFIG_HAVE_KVM_IRQFD
> >> +=C2=A0=C2=A0=C2=A0 case KVM_CAP_IRQFD_RESAMPLE:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D !xive_enabled();
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> +#endif
> >> +
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_PPC_ALLOC_HTAB:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D hv_enable=
d;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> >> index c768f75279ef..b58579b386bb 100644
> >> --- a/arch/riscv/kvm/vm.c
> >> +++ b/arch/riscv/kvm/vm.c
> >> @@ -63,6 +63,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=20
> >> long ext)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_READONLY_MEM:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_MP_STATE:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_IMMEDIATE_EXIT:
> >> +#ifdef CONFIG_HAVE_KVM_IRQFD
> >> +=C2=A0=C2=A0=C2=A0 case KVM_CAP_IRQFD_RESAMPLE:
> >> +#endif
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D 1;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_NR_VCPUS:
> >> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> >> index 156d1c25a3c1..85e093fc8d13 100644
> >> --- a/arch/s390/kvm/kvm-s390.c
> >> +++ b/arch/s390/kvm/kvm-s390.c
> >> @@ -564,6 +564,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
=20
> >> long ext)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_SET_GUEST_DEBUG:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_S390_DIAG318:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_S390_MEM_OP_EXTENSION:
> >> +#ifdef CONFIG_HAVE_KVM_IRQFD
> >> +=C2=A0=C2=A0=C2=A0 case KVM_CAP_IRQFD_RESAMPLE:
> >> +#endif
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D 1;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_SET_GUEST_DEBUG2:
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index 0c0ca599a353..a0a7b769483d 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -4273,6 +4273,9 @@ int kvm_vm_ioctl_check_extension(struct kvm=20
> >> *kvm, long ext)
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_SYS_ATTRIBUTES:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_VAPIC:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_ENABLE_CAP:
> >> +#ifdef CONFIG_HAVE_KVM_IRQFD
> >> +=C2=A0=C2=A0=C2=A0 case KVM_CAP_IRQFD_RESAMPLE:
> >> +#endif
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r =3D 1;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_EXIT_HYPERCALL:
> >> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >> index 70e05af5ebea..885e72e668a5 100644
> >> --- a/virt/kvm/kvm_main.c
> >> +++ b/virt/kvm/kvm_main.c
> >> @@ -4293,7 +4293,6 @@ static long=20
> >> kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> >> =C2=A0 #endif
> >> =C2=A0 #ifdef CONFIG_HAVE_KVM_IRQFD
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_IRQFD:
> >> -=C2=A0=C2=A0=C2=A0 case KVM_CAP_IRQFD_RESAMPLE:
> >> =C2=A0 #endif
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_IOEVENTFD_ANY_LENGTH:
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_CAP_CHECK_EXTENSION_VM:
> >=20
>
> --=20
> Alexey

