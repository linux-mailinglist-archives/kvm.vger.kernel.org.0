Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB6854A070
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 22:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347970AbiFMUzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 16:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348817AbiFMUyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 16:54:33 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0DA198
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 13:25:23 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id j20so7432047ljg.8
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 13:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LaTe/6iPj2QTHouEpD5zb7ljK8wpLSNpMXH7C0NUTKA=;
        b=ZwuPD5EJlcIywyGh4GvJtKb3+m3z4Qx4UHoZ4R/YmhCe4yl8vejVnq/stA3tK6Z1dy
         nmNdK/31+zNXpVyafyAN5WYLuok4MAEGLHad407VFZeqcWxfWoFH4Sxw7krPwFdwcsSr
         5Ne36lY9ZZiKrJMhuC2FpfqJYliUh2GP1WPe6WUSZPcETYh1IQFVu2uhx6p8tWkmBLYd
         hi4Qpm6+VeYBIdrumq2YSgcMjjrUk3RBsdcK7qs1XBiI5S0XDrgk7T6PM7+uTsw34/yx
         NslYTqhOId/R3IGVV6oXHi3l1zcV2Vw/2IJhKzmsKC6+IFYn1VhekyISSqnchXNjToM1
         /jKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LaTe/6iPj2QTHouEpD5zb7ljK8wpLSNpMXH7C0NUTKA=;
        b=rnOanXFonz7J5LTcrB9iIsaVHO9MncxNy3ULYq4/drk254H84XyPz3TbuMJaNL/ScT
         RoXWNrf/eMYtDMnbglTVXtXcca33GOxjfIH4pZz3m3YfNcLUkftqUIpQ9w55Q7lyyofb
         BROvb2DZrXjm7pQNyXfviRZ5r+WbP2U7XxM7B2bF1au/8/KT+O6FHZ1F6fsZqr1lCPyY
         RVum7Fp3+2xaxTJQmvHvtXQfmP3yCj1f+WdPZxocInQ+tAgzk+28d98SZcslA1ecwtG5
         6cULcwU6XrUOUKu1ccM9BsFrIO6e83oOxGyyTt4eHc3udrS9C8Jakv5pWbTedHWR2+oZ
         F52w==
X-Gm-Message-State: AJIora+X0IEf+X/x2qz08lCI7P7zKjtY/ZNWc+7s6jxc3s6KzvdcL8i7
        W+ivxWLFB2ta7GCeZuQeFeTXXGkVlGfoREG4u2RHcoXCzL8=
X-Google-Smtp-Source: AGRyM1vzXctcH1IsQEGx45qeulZiXg/66GyHJ8gE/oFSuhJE1Nwt/PiNdIf2029by3xWkgEWYZS9aK/dae/PyFKsLlw=
X-Received: by 2002:a2e:97d0:0:b0:255:7c1c:f3ba with SMTP id
 m16-20020a2e97d0000000b002557c1cf3bamr651536ljj.49.1655151921364; Mon, 13 Jun
 2022 13:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220613145022.183105-1-kyle.meyer@hpe.com>
In-Reply-To: <20220613145022.183105-1-kyle.meyer@hpe.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 13 Jun 2022 13:24:55 -0700
Message-ID: <CALzav=eWPiii4_zmYifdi_pSS6nUvMEchwQcvD+W2CfOR+-s8Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048
To:     Kyle Meyer <kyle.meyer@hpe.com>
Cc:     kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, russ.anderson@hpe.com,
        payton@hpe.com, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022 at 11:35 AM Kyle Meyer <kyle.meyer@hpe.com> wrote:
>
> Increase KVM_MAX_VCPUS to 2048 so we can run larger virtual machines.

Does the host machine have 2048 CPUs (or more) as well in your usecase?

I'm wondering if it makes sense to start configuring KVM_MAX_VCPUS
based on NR_CPUS. That way KVM can scale up on large machines without
using more memory on small machines.

e.g.

/* Provide backwards compatibility. */
#if NR_CPUS < 1024
  #define KVM_MAX_VCPUS 1024
#else
  #define KVM_MAX_VCPUS NR_CPUS
#endif

The only downside I can see for this approach is if you are trying to
kick the tires a new large VM on a smaller host because the new "large
host" hardware hasn't landed yet.

>
> Notable changes:
>
> * KVM_CAP_MAX_VCPUS will return 2048.
> * KVM_MAX_VCPU_IDS will increase from 4096 to 8192.
> * KVM_HV_MAX_SPARSE_VCPU_SET_BITS will increase from 16 to 32.
>
> * CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX will now be 2048.
>
> * struct kvm will increase from 40336 B to 40464 B.
> * struct kvm_arch will increase from 34488 B to 34616 B.
> * struct kvm_ioapic will increase from 5240 B to 9848 B.
>
> * vcpu_mask in kvm_hv_flush_tlb will increase from 128 B to 256 B.
> * vcpu_mask in kvm_hv_send_ipi will increase from 128 B to 256 B.
> * vcpu_bitmap in ioapic_write_indirect will increase from 128 B to 256 B.
> * vp_bitmap in sparse_set_to_vcpu_mask will increase from 128 B to 256 B.
> * sparse_banks in kvm_hv_flush_tlb will increase from 128 B to 256 B.
> * sparse_banks in kvm_hv_send_ipi will increase from 128 B to 256 B.
>
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3a240a64ac68..58653c63899f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -38,7 +38,7 @@
>
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>
> -#define KVM_MAX_VCPUS 1024
> +#define KVM_MAX_VCPUS 2048
>
>  /*
>   * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
> --
> 2.26.2
>
