Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3185E3FEF3B
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 16:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbhIBOPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 10:15:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233793AbhIBOPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 10:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630592041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wE6+/Vrhwq4T1/jtKU4o2cvBNu2Pj3FE7J1tJqRcmHM=;
        b=WzVqADd4z3sGt1FccDAtnX7RSLj1s2exW1S5TsYb07bV7fWzex8nUFQmpXruQkYujCR/Vy
        POg8E02Hxm5uFCRk52XUFCX5OFEsAgENrbfARAttVoF0loc/cf+QLGN4NP+Ik+05EtGD2K
        yZOLRZilxhpBtNV0khjp6Cp0/fbzXiw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-xJaUgKB9OyumB0lynFCkag-1; Thu, 02 Sep 2021 10:12:41 -0400
X-MC-Unique: xJaUgKB9OyumB0lynFCkag-1
Received: by mail-wm1-f69.google.com with SMTP id b126-20020a1c8084000000b002f152a868a2so737541wmd.1
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 07:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wE6+/Vrhwq4T1/jtKU4o2cvBNu2Pj3FE7J1tJqRcmHM=;
        b=iBY08mmVWsUfPSmhO3mcBMwsqQHhv1nOry1N7ahIbwuld5yC/JE+aC+jQD4LfFC4dY
         aY6CDlLG8cyakMYEo/H+GN4kmkXYoYt9er67u/LJ3vCKD8lg/SqJJ9BHGqHNA2i3m4xu
         d8vGA/RiOZ9qZSnaq3M6+LyMr/9XiHBaKwSlpMlrNv1GVCRYfjieuNF+VC09XMWd/NlM
         T7yG+aJpc/VcdacD4XlAmRMYV0H3I2IBHsJx6iOdGqjWepHnWYDqngUKjOQ06bKvWLRd
         GEHE7xpCNtYq7sbDn4Gp9Q8v2j2kFDIcW3t6i3VFu58NB7jRDqAnoBctUEDCHq95ZZ93
         gRkg==
X-Gm-Message-State: AOAM532hf2DyvRFyMKKTILtI99s4+raxGNNSLA0qq/lvLq7Xa4RYVzkK
        RmlgUa+CXxf8LZ0YbVBawGxXWdbgrJ0PQ5BzSn/gPYGouboEYBegHeS1bK1j04pxsbpA7ta1X3x
        skh0CD02uuPvo
X-Received: by 2002:a1c:2684:: with SMTP id m126mr3450480wmm.65.1630591960561;
        Thu, 02 Sep 2021 07:12:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtXz3TEVH3IBGGj1EQWgvfH/dex7qONnxSgYAC6xWL5W99QDZGCYHswtmsZBxRRw6IB0pnsg==
X-Received: by 2002:a1c:2684:: with SMTP id m126mr3450340wmm.65.1630591959082;
        Thu, 02 Sep 2021 07:12:39 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id v62sm1775380wme.21.2021.09.02.07.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 07:12:38 -0700 (PDT)
Date:   Thu, 2 Sep 2021 16:12:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 04/12] KVM: arm64: selftests: Add basic support for
 arch_timers
Message-ID: <20210902141237.vdp7z2gohdh732qs@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-5-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-5-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:04PM +0000, Raghavendra Rao Ananta wrote:
> Add a minimalistic library support to access the virtual timers,
> that can be used for simple timing functionalities, such as
> introducing delays in the guest.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../kvm/include/aarch64/arch_timer.h          | 142 ++++++++++++++++++
>  1 file changed, 142 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> new file mode 100644
> index 000000000000..9df5b63abc47
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
> @@ -0,0 +1,142 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ARM Generic Timer specific interface
> + */
> +
> +#ifndef SELFTEST_KVM_ARCH_TIMER_H
> +#define SELFTEST_KVM_ARCH_TIMER_H
> +
> +#include "processor.h"
> +
> +enum arch_timer {
> +	VIRTUAL,
> +	PHYSICAL,
> +};
> +
> +#define CTL_ENABLE	(1 << 0)
> +#define CTL_IMASK	(1 << 1)
> +#define CTL_ISTATUS	(1 << 2)
> +
> +#define msec_to_cycles(msec)	\
> +	(timer_get_cntfrq() * (uint64_t)(msec) / 1000)
> +
> +#define usec_to_cycles(usec)	\
> +	(timer_get_cntfrq() * (uint64_t)(usec) / 1000000)
> +
> +#define cycles_to_usec(cycles) \
> +	((uint64_t)(cycles) * 1000000 / timer_get_cntfrq())
> +
> +static inline uint32_t timer_get_cntfrq(void)
> +{
> +	return read_sysreg(cntfrq_el0);
> +}
> +
> +static inline uint64_t timer_get_cntct(enum arch_timer timer)
> +{
> +	isb();
> +
> +	switch (timer) {
> +	case VIRTUAL:
> +		return read_sysreg(cntvct_el0);
> +	case PHYSICAL:
> +		return read_sysreg(cntpct_el0);
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}
> +
> +static inline void timer_set_cval(enum arch_timer timer, uint64_t cval)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		write_sysreg(cntv_cval_el0, cval);
> +		break;
> +	case PHYSICAL:
> +		write_sysreg(cntp_cval_el0, cval);

Huh, looks like we managed to merge a backwards write_sysreg into kvm
selftests. write_sysreg in the kernel and kvm-unit-tests is (value, reg).
We should post a patch fixing that before adding more calls to it.

> +		break;
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	isb();
> +}
> +
> +static inline uint64_t timer_get_cval(enum arch_timer timer)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		return read_sysreg(cntv_cval_el0);
> +	case PHYSICAL:
> +		return read_sysreg(cntp_cval_el0);
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}
> +
> +static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		write_sysreg(cntv_tval_el0, tval);
> +		break;
> +	case PHYSICAL:
> +		write_sysreg(cntp_tval_el0, tval);
> +		break;
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	isb();
> +}
> +
> +static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		write_sysreg(cntv_ctl_el0, ctl);
> +		break;
> +	case PHYSICAL:
> +		write_sysreg(cntp_ctl_el0, ctl);
> +		break;
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	isb();
> +}
> +
> +static inline uint32_t timer_get_ctl(enum arch_timer timer)
> +{
> +	switch (timer) {
> +	case VIRTUAL:
> +		return read_sysreg(cntv_ctl_el0);
> +	case PHYSICAL:
> +		return read_sysreg(cntp_ctl_el0);
> +	default:
> +		GUEST_ASSERT_1(0, timer);
> +	}
> +
> +	/* We should not reach here */
> +	return 0;
> +}

I'll have to look at the test code that uses the above functions, but I
wonder if it wouldn't be better to define two test functions, one for
vtimer and one for ptimer where the sysreg accesses are direct, rather
than all these switched wrappers.

> +
> +static inline void timer_set_next_cval_ms(enum arch_timer timer, uint32_t msec)
> +{
> +	uint64_t now_ct = timer_get_cntct(timer);
> +	uint64_t next_ct = now_ct + msec_to_cycles(msec);
> +
> +	timer_set_cval(timer, next_ct);
> +}
> +
> +static inline void timer_set_next_tval_ms(enum arch_timer timer, uint32_t msec)
> +{
> +	timer_set_tval(timer, msec_to_cycles(msec));
> +}

I'll also look at how these wrappers are used, since open coding them may
be OK.

Thanks,
drew

> +
> +#endif /* SELFTEST_KVM_ARCH_TIMER_H */
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

