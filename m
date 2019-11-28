Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC810C69F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 11:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfK1K0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 05:26:22 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40647 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfK1K0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 05:26:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so5804119wrn.7
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 02:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:references:user-agent:to:cc:subject:message-id:in-reply-to
         :date:mime-version;
        bh=1lrGqkcV4iI5jLnp5kfouAF45I2tY7vDK/UTEfM693U=;
        b=ox3QWsFuo0rZEljuaqZ8m34VBCi2AhJdU9geUBCvfRPwNscgPCnf6oIfi1y4SjzTvl
         6/htuEaUyRkiE6PfrJpf7QI7QP9XLDiHv9dvCSJiV1y1ZDMO3AaMJ/MSEr2nxXnbV/vw
         QfNqn/4aNm/VtpvGa1VzM9MEGZC9KXS6Q0+/ntSGlc8mhsHBUVOswCnw41cKNs3PhD+2
         NZYoaBUvIc1gOTg1Ti0XVzVRD8/4hnn7P7bcJEwT53WAP2gLECsNrZf7+4RYo0wnB3E9
         E8tYEXvaylO89Zemww15ead7lb5JtQGghXF++Cr5vvC6s1EEhgznrcpOjB8CJ3FzQhSS
         WYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:user-agent:to:cc:subject
         :message-id:in-reply-to:date:mime-version;
        bh=1lrGqkcV4iI5jLnp5kfouAF45I2tY7vDK/UTEfM693U=;
        b=RggmysuLECdp+2VwT0XTGM6KtmeORnIZ3GkZP6KLw5Fz+87Eoiq6yBzVLckV+2v7ZR
         n0dKQsa2ZqMmIabKgaScn5KD9+nIUbhq0YpWKgD5ZyO9NmYN0A/WlNFYz7p2LnF8tMDI
         iaZNmDUHcYxPW6Sp6M/wFUVaskQ06egy2jJ0Cu62Ynep94q+Dgguk2luUEIwto8e0qK2
         lCSQ43Ie9uOFt6dHmCvYh4bkoZit/GXhepQula3cTf9e05qegVGln2YQ0RcT1YFTiq39
         9sA0Ba4vkejm7QPEWSXXn7BVFAla2WgRezBVpY7sXSBHUJtP6i2164w6F0Pb3SWk+MZW
         b6RA==
X-Gm-Message-State: APjAAAXFUri++DCqQjNCys2atQqLcN+h9YWAUOlsfj1cJikQxZTUozlO
        6Vr1MlygUAC4wrR2C1yn8kU=
X-Google-Smtp-Source: APXvYqw5aYA+kaOf7eZUd7bWXlIyuLocoGbM/hty5IkP6V9CCoX6ojPtPfpPbvioEtaXP/Go7TPVdQ==
X-Received: by 2002:adf:e591:: with SMTP id l17mr6587399wrm.139.1574936778136;
        Thu, 28 Nov 2019 02:26:18 -0800 (PST)
Received: from crazypad.dinechin.lan ([2a01:e0a:466:71c0:493:4df5:b9c4:eed5])
        by smtp.gmail.com with ESMTPSA id q3sm890141wrn.33.2019.11.28.02.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 02:26:16 -0800 (PST)
From:   Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
References: <1573044429-7390-1-git-send-email-nitesh@redhat.com> <1573044429-7390-3-git-send-email-nitesh@redhat.com>
User-agent: mu4e 1.3.2; emacs 26.2
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com
Subject: Re: [kvm-unit-tests Patch v1 2/2] x86: ioapic: Test physical and logical destination mode
Message-ID: <7hblsw8fji.fsf@crazypad.dinechin.lan>
In-reply-to: <1573044429-7390-3-git-send-email-nitesh@redhat.com>
Date:   Thu, 28 Nov 2019 11:25:46 +0100
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Nitesh Narayan Lal writes:

> This patch tests the physical destination mode by sending an
> interrupt to one of the vcpus and logical destination mode by
> sending an interrupt to more than one vcpus.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  x86/ioapic.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index c32dabd..31aec03 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -405,12 +405,73 @@ static void test_ioapic_self_reconfigure(void)
>  	report("Reconfigure self", g_isr_84 == 1 && e.remote_irr == 0);
>  }
>
> +static volatile int g_isr_85;
> +
> +static void ioapic_isr_85(isr_regs_t *regs)
> +{
> +	++g_isr_85;
> +	set_irq_line(0x0e, 0);
> +	eoi();
> +}
> +
> +static void test_ioapic_physical_destination_mode(void)
> +{
> +	ioapic_redir_entry_t e = {
> +		.vector = 0x85,
> +		.delivery_mode = 0,
> +		.dest_mode = 0,
> +		.dest_id = 0x1,
> +		.trig_mode = TRIGGER_LEVEL,
> +	};
> +	handle_irq(0x85, ioapic_isr_85);
> +	ioapic_write_redir(0xe, e);
> +	set_irq_line(0x0e, 1);
> +	do {
> +		pause();
> +	} while(g_isr_85 != 1);

Does this loop (and the next one) end up running forever if the test
fails? Would it be worth adding some timeout to detect failure?

> +	report("ioapic physical destination mode", g_isr_85 == 1);
> +}
> +
> +static volatile int g_isr_86;
> +
> +static void ioapic_isr_86(isr_regs_t *regs)
> +{
> +	++g_isr_86;
> +	set_irq_line(0x0e, 0);
> +	eoi();
> +}
> +
> +static void test_ioapic_logical_destination_mode(void)
> +{
> +	/* Number of vcpus which are configured/set in dest_id */
> +	int nr_vcpus = 3;
> +	ioapic_redir_entry_t e = {
> +		.vector = 0x86,
> +		.delivery_mode = 0,
> +		.dest_mode = 1,
> +		.dest_id = 0xd,
> +		.trig_mode = TRIGGER_LEVEL,
> +	};
> +	handle_irq(0x86, ioapic_isr_86);
> +	ioapic_write_redir(0xe, e);
> +	set_irq_line(0x0e, 1);
> +	do {
> +		pause();
> +	} while(g_isr_86 < nr_vcpus);
> +	report("ioapic logical destination mode", g_isr_86 == nr_vcpus);
> +}
> +
> +static void update_cr3(void *cr3)
> +{
> +	write_cr3((ulong)cr3);
> +}
>
>  int main(void)
>  {
>  	setup_vm();
>  	smp_init();
>
> +	on_cpus(update_cr3, (void *)read_cr3());
>  	mask_pic_interrupts();
>
>  	if (enable_x2apic())
> @@ -448,7 +509,11 @@ int main(void)
>  		test_ioapic_edge_tmr_smp(true);
>
>  		test_ioapic_self_reconfigure();
> +		test_ioapic_physical_destination_mode();
>  	}
>
> +	if (cpu_count() > 3)
> +		test_ioapic_logical_destination_mode();
> +
>  	return report_summary();
>  }


--
Cheers,
Christophe de Dinechin (IRC c3d)
