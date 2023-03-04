Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B4B6AA965
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 13:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCDMHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 07:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDMHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 07:07:14 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB691A960;
        Sat,  4 Mar 2023 04:07:13 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id s22so6834334lfi.9;
        Sat, 04 Mar 2023 04:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677931631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YhUNlBpnC7SpjDcF5mqCCGNAI6o9whocfh3JcKsMDz4=;
        b=eKTZe2k6FuT8y98Zp3sKdlzaHCETWA0c5PvPXGUANkMd0Z1bRnjCVWIPyplEFN16F7
         iJYX0P8jwOuBZWwZDdsf3jiHJFhQCecnmB4Fz0ZZUEmPyYwyRaE0xKl680zy0GO9JjDc
         7JPPxmL9Xcjk4BlnkP1dqG3VFAuSluh53xK/4lbnrEVtu774N1P0TM9WWsYBf06/b0WM
         7VJESza6o1j6SNlAS1k55op4ys9PmlSMAqljs/e9XWKcMZDyx4f0H75A4w/L79vNkRA9
         0npvx8O0+eJBu9jnQDn3OsHjd5ej8w93aoRp/uGIUHNnXsPzIlI+TnBIkVhYGj6IZBMU
         Ay/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677931631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YhUNlBpnC7SpjDcF5mqCCGNAI6o9whocfh3JcKsMDz4=;
        b=IbpdsiAqkkWhakMNVazJHdjTWTiirbnKq4LyZSZnn3i6RhMAsVmJrfhpV0PBDvoYpn
         hC3CSXwGhhclamcAaJrkPOD6JE+lsa59vmUNAZCaFJdkkLsfy2+g/E8CrA23yBxF69OW
         zPyEj5Wqek7S8nApnXYZrceCZNXxX+QUL5PYW+sYf8GDLQKhVXdQGxsWjPB35rnuHASY
         e8E2rZ7pFbG3xNqWisIvzajHKDcrePdy+1K7/3N3tqFFzJNoCRoAn7Lmwg7PRojZ5Vy2
         esCkCgUEyUd/HvV1xClCZbrqpjkyI0gGOVOAHPN2zPfKlW3TecjVSzDcjS0SBmv+3N7F
         6ctQ==
X-Gm-Message-State: AO0yUKVixOBnvWAAqQ81TEC9ItwZ7Wg9awMZ05fCxs9pbIIcsqV5BFA4
        sc0iOz77sJ7Pp3TLSYSwfpk=
X-Google-Smtp-Source: AK7set/vVZAWJc8yBBDMO+BZ3k5F2I5H1owWuApGRXUlBzAw5i5xHH41U3p6mN0bAIG6cvO/sX8/sA==
X-Received: by 2002:ac2:5624:0:b0:4db:3890:cb59 with SMTP id b4-20020ac25624000000b004db3890cb59mr1282818lff.1.1677931631114;
        Sat, 04 Mar 2023 04:07:11 -0800 (PST)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id y10-20020ac255aa000000b004db2b54714bsm805531lfg.67.2023.03.04.04.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 04:07:11 -0800 (PST)
Date:   Sat, 4 Mar 2023 14:07:09 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 04/28] arm64: RME: Check for RME support at KVM init
Message-ID: <20230304140709.0000112e@gmail.com>
In-Reply-To: <748a6bcf-ec16-0870-8e33-bc29ab311211@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-5-steven.price@arm.com>
        <20230213174846.00003fad@gmail.com>
        <748a6bcf-ec16-0870-8e33-bc29ab311211@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Feb 2023 15:59:05 +0000
Steven Price <steven.price@arm.com> wrote:

> On 13/02/2023 15:48, Zhi Wang wrote:
> > On Fri, 27 Jan 2023 11:29:08 +0000
> > Steven Price <steven.price@arm.com> wrote:
> > 
> >> Query the RMI version number and check if it is a compatible version. A
> >> static key is also provided to signal that a supported RMM is available.
> >>
> >> Functions are provided to query if a VM or VCPU is a realm (or rec)
> >> which currently will always return false.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_emulate.h | 17 ++++++++++
> >>  arch/arm64/include/asm/kvm_host.h    |  4 +++
> >>  arch/arm64/include/asm/kvm_rme.h     | 22 +++++++++++++
> >>  arch/arm64/include/asm/virt.h        |  1 +
> >>  arch/arm64/kvm/Makefile              |  3 +-
> >>  arch/arm64/kvm/arm.c                 |  8 +++++
> >>  arch/arm64/kvm/rme.c                 | 49 ++++++++++++++++++++++++++++
> >>  7 files changed, 103 insertions(+), 1 deletion(-)
> >>  create mode 100644 arch/arm64/include/asm/kvm_rme.h
> >>  create mode 100644 arch/arm64/kvm/rme.c
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> >> index 9bdba47f7e14..5a2b7229e83f 100644
> >> --- a/arch/arm64/include/asm/kvm_emulate.h
> >> +++ b/arch/arm64/include/asm/kvm_emulate.h
> >> @@ -490,4 +490,21 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
> >>  	return test_bit(feature, vcpu->arch.features);
> >>  }
> >>  
> >> +static inline bool kvm_is_realm(struct kvm *kvm)
> >> +{
> >> +	if (static_branch_unlikely(&kvm_rme_is_available))
> >> +		return kvm->arch.is_realm;
> >> +	return false;
> >> +}
> >> +
> >> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
> >> +{
> >> +	return READ_ONCE(kvm->arch.realm.state);
> >> +}
> >> +
> >> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
> >> +{
> >> +	return false;
> >> +}
> >> +
> >>  #endif /* __ARM64_KVM_EMULATE_H__ */
> >> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >> index 35a159d131b5..04347c3a8c6b 100644
> >> --- a/arch/arm64/include/asm/kvm_host.h
> >> +++ b/arch/arm64/include/asm/kvm_host.h
> >> @@ -26,6 +26,7 @@
> >>  #include <asm/fpsimd.h>
> >>  #include <asm/kvm.h>
> >>  #include <asm/kvm_asm.h>
> >> +#include <asm/kvm_rme.h>
> >>  
> >>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> >>  
> >> @@ -240,6 +241,9 @@ struct kvm_arch {
> >>  	 * the associated pKVM instance in the hypervisor.
> >>  	 */
> >>  	struct kvm_protected_vm pkvm;
> >> +
> >> +	bool is_realm;
> >                ^
> > It would be better to put more comments which really helps on the review.
> 
> Thanks for the feedback - I had thought "is realm" was fairly
> self-documenting, but perhaps I've just spent too much time with this code.
> 
> > I was looking for the user of this memeber to see when it is set. It seems
> > it is not in this patch. It would have been nice to have a quick answer from the
> > comments.
> 
> The usage is in the kvm_is_realm() function which is used in several of
> the later patches as a way to detect this kvm guest is a realm guest.
> 
> I think the main issue is that I've got the patches in the wrong other.
> Patch 7 "arm64: kvm: Allow passing machine type in KVM creation" should
> probably be before this one, then I could add the assignment of is_realm
> into this patch (potentially splitting out the is_realm parts into
> another patch).
> 

I agree the patch order seems a problem here. The name is self-documenting
but if the user of the variable is not in this patch, still needs to jump to
the related patch to confirm if the variable is used as expected. In that
situation, a comment would help to avoid jumping between patches (sometimes
finding the the user of a variable from a patch bundle really slows down
the review progress and eventually you have to open a terminal and check
it in the git tree).

> Thanks,
> 
> Steve
> 

