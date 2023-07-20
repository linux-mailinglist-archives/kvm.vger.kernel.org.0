Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D06A75AA0B
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 10:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjGTI5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 04:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjGTIqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 04:46:10 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3CC2699
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 01:46:08 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51bece5d935so713974a12.1
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 01:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689842767; x=1690447567;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CGTq1P2Y1uV5uSC7wiZItX+X++ASwHV6iVLZSdmwnAU=;
        b=RS4HzSE4/FIoMyzpUm80pmAn2GSXlRLLoeUf57pBtFgGv4q4kDgLx1OtMrUNEdUhnE
         bzLcxg2U2Ctq4kg3qrL0HgtvN/VcmP9tmqLsWELnZRsqaCtGyGi2COmNCCUQJnOjj8ly
         wfLKk5czs1Vc05VG+dorbFvr0ki1c6ruj3MKTS32+eV7DvLtK2v99cIW+uTGyvXVp/+5
         GkQ72jNqB6mAoYddJ5HvKkOVA2yYIKBi+qXN6Nh7T+xOifxRcaTzmehJrZuow3W1UqAx
         DcqRo5fMWFwH3ataAI8usmWQStdI3v8chmQwGJRIj6V6qILOLvuI1T+EvgWXgBsO84gG
         JKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689842767; x=1690447567;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CGTq1P2Y1uV5uSC7wiZItX+X++ASwHV6iVLZSdmwnAU=;
        b=TCW7EfHb0+Brf+hUcgiSmlMUrr0D4M4ayyizsjUcbLo5wivYcp3wbc1svnfuCkV8D3
         azidlFKlzIOLxg8Vt+FwDfn6Zx2XUrX+68B3M46QSe0Ugs29y95SSZUKkToBjcQWZ9St
         /IYDUENG4oSBv+u+5YDd+MNwDfQl+ksmSXpVyMpqxpHnvA/kow8r5N4x8oa1BL6s9gzL
         DG069eLLkgg9DSsNRKd/LoArNM7pdFkJt7tk2+dHh3rUhQu+L3x3o/REENJsepAINkNt
         qPN1HIk1X0JjJ2Qug4O6hLrR+D5Cg5q0h9TRIiQgPvvwe+BUq+cAWcqAPSUkyfsvjUbJ
         vXwA==
X-Gm-Message-State: ABy/qLbpxgPhZHIesXjq7TXmfF1c3Fh4eMV41PIdlN95uZBNGJ3YdDqI
        aOHjo7lR+pDbSgJqWOYX/X4KY/DFVEHVv53iPkzG+A==
X-Google-Smtp-Source: APBJJlEwjaJAfevuHpcWv5n4Qts4yAws1XHwYpL9Za6Uz1R9lQQKUF5EpkqWj05aonOiLrl52X29phf4ttm+xlHS3FI=
X-Received: by 2002:a05:6402:6d6:b0:51d:9682:e30c with SMTP id
 n22-20020a05640206d600b0051d9682e30cmr1708622edy.5.1689842767305; Thu, 20 Jul
 2023 01:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230720072903.21390-1-akihiko.odaki@daynix.com>
In-Reply-To: <20230720072903.21390-1-akihiko.odaki@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 20 Jul 2023 09:45:56 +0100
Message-ID: <CAFEAcA9BiXWweNEbMY1Xkso1B5-o3_85eW3QprQjerzM5nAo8g@mail.gmail.com>
Subject: Re: [PATCH RESEND] accel/kvm: Specify default IPA size for arm64
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jul 2023 at 08:29, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> libvirt uses "none" machine type to test KVM availability. Before this
> change, QEMU used to pass 0 as machine type when calling KVM_CREATE_VM.
>
> The kernel documentation says:
> > On arm64, the physical address size for a VM (IPA Size limit) is
> > limited to 40bits by default. The limit can be configured if the host
> > supports the extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
> > KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
> > identifier, where IPA_Bits is the maximum width of any physical
> > address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
> > machine type identifier.
> >
> > e.g, to configure a guest to use 48bit physical address size::
> >
> >     vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
> >
> > The requested size (IPA_Bits) must be:
> >
> >  ==   =========================================================
> >   0   Implies default size, 40bits (for backward compatibility)
> >   N   Implies N bits, where N is a positive integer such that,
> >       32 <= N <= Host_IPA_Limit
> >  ==   =========================================================
>
> > Host_IPA_Limit is the maximum possible value for IPA_Bits on the host
> > and is dependent on the CPU capability and the kernel configuration.
> > The limit can be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the
> > KVM_CHECK_EXTENSION ioctl() at run-time.
> >
> > Creation of the VM will fail if the requested IPA size (whether it is
> > implicit or explicit) is unsupported on the host.
> https://docs.kernel.org/virt/kvm/api.html#kvm-create-vm
>
> So if Host_IPA_Limit < 40, such KVM_CREATE_VM will fail, and libvirt
> incorrectly thinks KVM is not available. This actually happened on M2
> MacBook Air.
>
> Fix this by specifying 32 for IPA_Bits as any arm64 system should
> support the value according to the documentation.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
> Resending due to inactivity.
>
>  accel/kvm/kvm-all.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 373d876c05..3bd362e346 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2458,7 +2458,11 @@ static int kvm_init(MachineState *ms)
>      KVMState *s;
>      const KVMCapabilityInfo *missing_cap;
>      int ret;
> +#ifdef TARGET_AARCH64
> +    int type = 32;
> +#else
>      int type = 0;
> +#endif
>      uint64_t dirty_log_manual_caps;
>
>      qemu_mutex_init(&kml_slots_lock);
> --
> 2.41.0

I think this was discussed in review the last time around on
this patch (which is why it wasn't applied), but I don't think
we should do this with a target ifdef in a common file. We should
have some kind of target hook for targets to specify what they need
to do here.

thanks
-- PMM
