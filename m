Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6A266BCA9
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 12:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjAPLSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 06:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjAPLSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 06:18:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8801E65A0
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 03:18:14 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z4-20020a17090a170400b00226d331390cso30738732pjd.5
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 03:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RNN1ClPNvVO87wCLLD4YvArYNLWKloZM5T7TFIiPYjU=;
        b=OZI93jHm7BZvPQAdVWTFAqeVfUzU5ma301K/nl6THOiZE13c9Tveyt9CKeS7RR7vMs
         MpQJCOe11Y5mQNKWCjjHYKTJhxr/4o6/c7Eal6mQou0D+JxADIv1qiqz1176i0K0eECn
         PVQ7lZFUtovocrLjbEPVjB6q2X5xuXDSS3FQ9Ms4JsgolbkTzd3hXW7CzP/LyzpMk+Q4
         vQa9jT7vJG4Vkz8LvRzGFQFeagWfjFhN27fgjOba6qKqgMHaEbF3ULMvBIwmpTODKeHd
         tFMWo7Lvuaa+h7EVIeUErFHN+CypJBkIjRqmQ2fF4F3bgbTMwhw/7tGQSb96IdWAJ3k+
         RkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RNN1ClPNvVO87wCLLD4YvArYNLWKloZM5T7TFIiPYjU=;
        b=qOwgu5f4jrww/QDUVd2Fyb8LsFnjCgW/b8HLSbU0UMjJVJCxQPjd7zpTJiIb2ehtlQ
         6eWffFncd83LZsYx0UR7qLb3oC/sg89dlAxkjYgfUR527z+YVCCYFNLYUb05cxLAXiOm
         7fHCnrFeSL7bEjdA60SJggn9KjrDwZJA5XhaD3ej04irfaM63atdaivt9IaA+IUpKfCp
         SrE11YGGssz7pO/cAqv1za6F9C54/3X/kIUbPegED+wLQxXTuTbE+LSAdW21QjCV9+Ro
         73Bj7DlRjJYzowfxXymsucnVR+SBdxelGmI/1INAPE10dUZxV1q/6lPqkjh9lZw0/+gm
         Li2A==
X-Gm-Message-State: AFqh2kqXsCoWQnVFcqdxAw8xAiMSE6+00sJhuexz1Ww55PBK+zYEZliw
        Xt+KHN8FtaJN8/grAw4K3ETpS2Q746mluUUpPssu5w==
X-Google-Smtp-Source: AMrXdXvZ/BIYOzWlb+J3szAkbalA5MSfs9NhtrpaNJnATQS3XKP2g9Lm1S0uURK+sSjs2Q9h0EFhyKDMyY7DZl8u/h8=
X-Received: by 2002:a17:902:ee51:b0:194:45d0:3b2c with SMTP id
 17-20020a170902ee5100b0019445d03b2cmr793518plo.52.1673867893934; Mon, 16 Jan
 2023 03:18:13 -0800 (PST)
MIME-Version: 1.0
References: <20230109062259.79074-1-akihiko.odaki@daynix.com>
 <481867e4-b019-80de-5369-9a503fa049ac@linaro.org> <fb435604-1638-c4ee-efca-bdbe2a4be98b@daynix.com>
In-Reply-To: <fb435604-1638-c4ee-efca-bdbe2a4be98b@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Mon, 16 Jan 2023 11:18:02 +0000
Message-ID: <CAFEAcA8dT+uvhCspUU9P-ev57UR9r5MDxkinPzwf+TieW_mUYg@mail.gmail.com>
Subject: Re: [PATCH] accel/kvm: Specify default IPA size for arm64
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 14 Jan 2023 at 06:49, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> On 2023/01/14 14:23, Richard Henderson wrote:
> > On 1/8/23 22:22, Akihiko Odaki wrote:
> >> libvirt uses "none" machine type to test KVM availability. Before this
> >> change, QEMU used to pass 0 as machine type when calling KVM_CREATE_VM.
> >>
> >> The kernel documentation says:
> >>> On arm64, the physical address size for a VM (IPA Size limit) is
> >>> limited to 40bits by default. The limit can be configured if the host
> >>> supports the extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
> >>> KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
> >>> identifier, where IPA_Bits is the maximum width of any physical
> >>> address used by the VM. The IPA_Bits is encoded in bits[7-0] of the
> >>> machine type identifier.
> >>>
> >>> e.g, to configure a guest to use 48bit physical address size::
> >>>
> >>>      vm_fd = ioctl(dev_fd, KVM_CREATE_VM, KVM_VM_TYPE_ARM_IPA_SIZE(48));
> >>>
> >>> The requested size (IPA_Bits) must be:
> >>>
> >>>   ==   =========================================================
> >>>    0   Implies default size, 40bits (for backward compatibility)
> >>>    N   Implies N bits, where N is a positive integer such that,
> >>>        32 <= N <= Host_IPA_Limit
> >>>   ==   =========================================================
> >>
> >>> Host_IPA_Limit is the maximum possible value for IPA_Bits on the host
> >>> and is dependent on the CPU capability and the kernel configuration.
> >>> The limit can be retrieved using KVM_CAP_ARM_VM_IPA_SIZE of the
> >>> KVM_CHECK_EXTENSION ioctl() at run-time.
> >>>
> >>> Creation of the VM will fail if the requested IPA size (whether it is
> >>> implicit or explicit) is unsupported on the host.
> >> https://docs.kernel.org/virt/kvm/api.html#kvm-create-vm
> >>
> >> So if Host_IPA_Limit < 40, such KVM_CREATE_VM will fail, and libvirt
> >> incorrectly thinks KVM is not available. This actually happened on M2
> >> MacBook Air.
> >>
> >> Fix this by specifying 32 for IPA_Bits as any arm64 system should
> >> support the value according to the documentation.
> >>
> >> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> >> ---
> >>   accel/kvm/kvm-all.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> >> index e86c33e0e6..776ac7efcc 100644
> >> --- a/accel/kvm/kvm-all.c
> >> +++ b/accel/kvm/kvm-all.c
> >> @@ -2294,7 +2294,11 @@ static int kvm_init(MachineState *ms)
> >>       KVMState *s;
> >>       const KVMCapabilityInfo *missing_cap;
> >>       int ret;
> >> +#ifdef TARGET_AARCH64
> >> +    int type = 32;
> >> +#else
> >>       int type = 0;
> >> +#endif
> >
> > No need for an ifdef.  Down below we have,
> >
> >      if (object_property_find(OBJECT(current_machine), "kvm-type")) {
> >          g_autofree char *kvm_type =
> > object_property_get_str(OBJECT(current_machine),
> >                                                              "kvm-type",
> >                                                              &error_abort);
> >          type = mc->kvm_type(ms, kvm_type);
> >      } else if (mc->kvm_type) {
> >          type = mc->kvm_type(ms, NULL);
> >      }
> >
> > and the aarch64 -M virt machine provides virt_kvm_type as mc->kvm_type.
> >
> > How did you hit this?  Are you trying to implement your own board model?
> >
> > Looking at this, I'm surprised this is a board hook and not a cpu hook.
> > But I suppose the architecture specific 'type' can hide any number of
> > sins.  Anyway, if you are doing your own board model, I suggest
> > arranging to share the virt board hook -- maybe moving it to
> > target/arm/kvm.c in the process?

> I hit this problem when I used libvirt; libvirt uses "none" machine type
> to probe the availability of KVM and "none" machine type does not
> provide kvm_type hook.
>
> As the implementation of "none" machine type is shared among different
> architectures, we cannot remove ifdef by moving it to the hook.
>
> Although implementing the hook for "none" machine type is still
> possible, I  think the default type should provide the lowest common
> denominator and "none" machine type shouldn't try to work around when
> the type is wrong. Otherwise it doesn't make sense to provide the "default".

Yes, the problem is that the 'none' board type is all
architecture-independent code, and so is this kvm_init() code, so
there's no obvious arm-specific place to say "pick the best IPA size
that will work for this host".

Perhaps we should create somewhere in here a target-arch specific
hook: we already have ifdefs in this function for S390X and PPC
(printing some special case error strings if the ioctl fails), so
maybe a hook that does "take the type provided by the machine hook,
if any, sanitize or reject it, do the ioctl call, print arch-specific
help/error messages if relevant" ? Paolo, do you have an opinion?

thanks
-- PMM
