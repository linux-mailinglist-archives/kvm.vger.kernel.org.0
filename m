Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B05F71F71E
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 02:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjFBA05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 20:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjFBA04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 20:26:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531BDE7
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 17:26:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bad475920a8so6255105276.1
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 17:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685665614; x=1688257614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y38QyZ2+OO+G6/wRDJ/cj6gRY/Ta6idClmfzzAT8WBo=;
        b=n+nOWFq8J3K8Nm/V1IVouabEMcA5NcQhTbDe1F6aFZyFxx2K25RM+S0wzBbQKVNbjs
         huRPaQnuBGZTGC4pEmKMxjn27Os81oukMMZ7J+zgiNeu9yvUhpjf2UHYaIbaQJ3kEYfZ
         8l8B1luaF3tl2ekZMvmb7k21EQ0a/n0qZjPF0Zn7Z+1kHZjAKgsmyk5EnKEdpK7WKxx/
         Z/MlIiHCgXtA+XX+4JWsFzLAOqk3KOtv69vLUyMkcLG3lVzH5UA4c/j6URmgYHZyokew
         ocpiUlmQJ9ncVUY1PibT9sJYp3Fa2du24S5xYjXRXjymxdYzlcuWu4RgcdFkDHP5WNFx
         r0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685665614; x=1688257614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y38QyZ2+OO+G6/wRDJ/cj6gRY/Ta6idClmfzzAT8WBo=;
        b=DeUIrkNz0yBRB1LrP1MvIfhTV2QZPHvxFgwHMozispwDYzM3pkO9TTLnLJDiO7XiUJ
         Y8QcZtEO9RtdCuhDRttqy7kWXe9OIOngQ6PLst0EFVDivBVY3iheeGOpsQHXdz21xEVv
         KpzYbb1wqrBJEXT0pTQMrivvMB84ClgoZJuDPPGjR2WZbG7HP8vjI79+/NmNRqj/KEOI
         /QNJRwTuAmCgsmhAziwFRrNpHDHx7FlYM5cK2ifmOtVbx8C2nksiI5hzzmwJEjP72hNG
         a1wi21kBgAOfjretqHsBu96YwBh5n2lRLpfg/YNmjYDMpmX83dTGz4R3nRlj+Xw9XoYr
         zlrw==
X-Gm-Message-State: AC+VfDzbk7es7D98pt/pfF4Ij6n7HhUmVYg8ictqCx2G2W4G8pqP3I09
        dgQGTUgbS6UBWpuIk7sM16Lh6XDg+8k=
X-Google-Smtp-Source: ACHHUZ4XR1o2lAYMvL1BdCFrgFE/MOy5l6xoAv863keciO+66dLqsSAFq13rsNESy8HsW9ONiMDT+AZhP0g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6d56:0:b0:bb1:d903:eae9 with SMTP id
 i83-20020a256d56000000b00bb1d903eae9mr860460ybc.2.1685665614622; Thu, 01 Jun
 2023 17:26:54 -0700 (PDT)
Date:   Thu, 1 Jun 2023 17:26:52 -0700
In-Reply-To: <814baa0c-1eaa-4503-129f-059917365e80@rbox.co>
Mime-Version: 1.0
References: <20230525183347.2562472-1-mhal@rbox.co> <20230525183347.2562472-4-mhal@rbox.co>
 <ZHFDcUcgvRXB/w/g@google.com> <814baa0c-1eaa-4503-129f-059917365e80@rbox.co>
Message-ID: <ZHk3TGyB2Vze4+Ou@google.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Add test for race in kvm_recalculate_apic_map()
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 28, 2023, Michal Luczaj wrote:
> On 5/27/23 01:40, Sean Christopherson wrote:
> > All of these open coded ioctl() calls is unnecessary.  Ditto for the fancy
> > stuffing, which through trial and error I discovered is done to avoid having
> > vCPUs with aliased xAPIC IDs, which would cause KVM to bail before triggering
> > the bug.  It's much easier to just create the max number of vCPUs and enable
> > x2APIC on all of them.
> > ...
> 
> Yup, this looks way better, thanks.
> (FWIW, the #defines were deliberately named to match enum lapic_mode.)

I figured as much, but I find enum lapic_mode to be rather odd, and if that thing
ever gets cleaned up I'd prefer not to have to go fixup selftests too.

> In somewhat related news, I've hit kvm_recalculate_logical_map()'s
> WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic))):

...

> diff --git a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_warn.c b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_warn.c
> new file mode 100644
> index 000000000000..2845e1d9b865
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_warn.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * recalc_apic_map_warn
> + *
> + * Test for hitting WARN_ON_ONCE() in kvm_recalculate_logical_map().
> + */
> +
> +#include "processor.h"
> +#include "kvm_util.h"
> +#include "apic.h"
> +
> +#define	LAPIC_X2APIC	(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)
> +
> +int main(void)
> +{
> +	struct kvm_lapic_state lapic = {};
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, NULL); /* vcpu_id = 0 */
> +	vcpu_set_msr(vcpu, MSR_IA32_APICBASE, LAPIC_X2APIC);
> +
> +	*(u32 *)(lapic.regs + APIC_ID) = 1 << 24; /* != vcpu_id */
> +	*(u32 *)(lapic.regs + APIC_SPIV) = APIC_SPIV_APIC_ENABLED;
> +	vcpu_ioctl(vcpu, KVM_SET_LAPIC, &lapic);

Blech.  There's a semi-known backdoor that lets userspace modify the x2APIC ID
and thus the LDR.  Sort of.  KVM doesn't actually honor the modified ID except
for guest RDMSR, e.g. KVM will never deliver interrupts to the unexpected ID.

I'll send a patch (plus this test) to close that loophole, the odds of breaking
an existing setup are basically nil, and it would be very nice to make the x2APIC
ID (and LDR) fully readonly.
