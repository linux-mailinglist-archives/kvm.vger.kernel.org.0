Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769BC7E0C7
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 19:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbfHARLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 13:11:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45312 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfHARLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 13:11:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so34424826pfq.12
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2019 10:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=S5pAcAWsPPL0MV2KKFJY33gKzjahDxo4hJJq/wxTMVc=;
        b=VlByBvhvRL+XmaFAU3VB8OborKi+m09XsvzhG9WU/pWtCUbQQ+E5NH79qqWsZa00LZ
         jJ4RJmrvEmR7zeeOgNkLeNf89Gt4rmY0tRsf6KccJxr98X/AqTQQo1vlpeoMtphmSGnm
         NK1ZKbZH+c8wowIfHC6do4T6UHziLYOJxIHNfTAwiYnxBVhBziQbkAL24FMnFp1R8MP1
         KmcRY3F2+2C8iZBkCXD6A8J/RQ8CEUdesFlMRC9BP4rL1x/XU/xmBK/JL8irNrAhSspO
         PSQ/0rzQj6VCfUWIZg1/DpoDJ7lV3NjnflJOyfWShiGixzr1Wy5TaQZbJHel9xjdroVx
         gcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=S5pAcAWsPPL0MV2KKFJY33gKzjahDxo4hJJq/wxTMVc=;
        b=mXafpVb18RrP/XEdVujRLbEp0U/drc90EFm0QfvAHBtGNovPaXLE7S9eCBwWgPOg0I
         /GxFia7ksoVCOB1HOg4G24Bjj2pJnOGeAgU0QOiQOqZRZUEs/S44yGIQ/yfiVWQOaQtO
         PRDOvZsvOjJBDNdUIgRQ/3oOqfbiTbqQF3/elUfKxjoxyrFnl7sxDW0LMjahaojh0wDR
         x+GMxFa0lO+0ciWxm+NJg5a0O4TEKcipZ+fvXxeRDWoGrzquW5q2OjKLV6e63zjkRbkz
         C1eC77fj7jynYDfiASbJNB7Buq2yMRedb8qRiio3X1EiiyEiqepxftW7klMkT/7ikeKM
         /kuw==
X-Gm-Message-State: APjAAAWrdu/guNxvHfyKSlrKj1Eaxrygnfd4qAMTf57aPwBJSQumx7Pl
        knDlXZA+N0Fll8UfBJZ9LIJU4g==
X-Google-Smtp-Source: APXvYqykClrbWkVs37QIGRuxgTaiZdW7Mkeb95+2ryFaT6ZIRFtDjFKWRRz+f2vMZYg2i7+zRfgqDA==
X-Received: by 2002:a63:d315:: with SMTP id b21mr97212834pgg.326.1564679489621;
        Thu, 01 Aug 2019 10:11:29 -0700 (PDT)
Received: from ?IPv6:2600:1010:b05c:1777:5b8:a455:199a:e2a8? ([2600:1010:b05c:1777:5b8:a455:199a:e2a8])
        by smtp.gmail.com with ESMTPSA id r27sm79185309pgn.25.2019.08.01.10.11.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 10:11:28 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [patch 1/5] tracehook: Provide TIF_NOTIFY_RESUME handling for KVM
Date:   Thu, 1 Aug 2019 10:02:38 -0700
Message-Id: <05C28F0C-5D8C-4A77-8D1B-FAC91DCF1115@amacapital.net>
References: <20190801143250.370326052@linutronix.de> <20190801143657.785902257@linutronix.de> <20190801144814.GC31398@hirez.programming.kicks-ass.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
In-Reply-To: <20190801144814.GC31398@hirez.programming.kicks-ass.net>
To:     Peter Zijlstra <peterz@infradead.org>
X-Mailer: iPhone Mail (16F203)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Aug 1, 2019, at 7:48 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Thu, Aug 01, 2019 at 04:32:51PM +0200, Thomas Gleixner wrote:
>> +#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
>> +/**
>> + * tracehook_handle_notify_resume - Notify resume handling for virt
>> + *
>> + * Called with interrupts and preemption enabled from VMENTER/EXIT.
>> + */
>> +void tracehook_handle_notify_resume(void)
>> +{
>> +    local_irq_disable();
>> +    while (test_and_clear_thread_flag(TIF_NOTIFY_RESUME)) {
>> +        local_irq_enable();
>> +        tracehook_notify_resume(NULL);
>> +        local_irq_disable();
>> +    }
>> +    local_irq_enable();
> 
> I'm confused by the IRQ state swizzling here, what is it doing?

Me too. Also, why is a loop needed?

> 
>> +}
>> +EXPORT_SYMBOL_GPL(tracehook_handle_notify_resume);
>> +#endif
>> 
>> 
