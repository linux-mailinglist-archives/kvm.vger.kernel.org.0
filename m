Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7F9191DE4
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 01:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgCYAHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 20:07:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46622 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgCYAHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 20:07:34 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGtZq-0008MY-Fr; Wed, 25 Mar 2020 01:07:23 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id F3139100C51; Wed, 25 Mar 2020 01:07:21 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v6 7/8] kvm: vmx: Enable MSR_TEST_CTRL for intel guest
In-Reply-To: <20200324151859.31068-8-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com> <20200324151859.31068-8-xiaoyao.li@intel.com>
Date:   Wed, 25 Mar 2020 01:07:21 +0100
Message-ID: <87h7ydz492.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:

> Subject: Re: [PATCH v6 7/8] kvm: vmx: Enable MSR_TEST_CTRL for intel guest

What the heck is a "intel guest"?

Can you Intel folks please stop to slap Intel (and in your subject line
it's even spelled wrong) at everything whether it makes sense or not?

Thanks,

        tglx
