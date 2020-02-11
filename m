Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7CB158FBD
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgBKNW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:22:29 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46228 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgBKNW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:22:28 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j1VUW-0000Dj-SZ; Tue, 11 Feb 2020 14:22:16 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7124D1013B2; Tue, 11 Feb 2020 14:22:16 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v2 3/6] kvm: x86: Emulate split-lock access as a write
In-Reply-To: <95d29a81-62d5-f5b6-0eb6-9d002c0bba23@redhat.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com> <20200203151608.28053-4-xiaoyao.li@intel.com> <95d29a81-62d5-f5b6-0eb6-9d002c0bba23@redhat.com>
Date:   Tue, 11 Feb 2020 14:22:16 +0100
Message-ID: <878sl945tj.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> On 03/02/20 16:16, Xiaoyao Li wrote:
>> A sane guest should never tigger emulation on a split-lock access, but
>> it cannot prevent malicous guest from doing this. So just emulating the
>> access as a write if it's a split-lock access to avoid malicous guest
>> polluting the kernel log.
>
> Saying that anything doing a split lock access is malicious makes little
> sense.

Correct, but we also have to accept, that split lock access can be used
in a malicious way, aka. DoS.

> Split lock detection is essentially a debugging feature, there's a
> reason why the MSR is called "TEST_CTL".  So you don't want to make the

The fact that it ended up in MSR_TEST_CTL does not say anything. That's
where they it ended up to be as it was hastily cobbled together for
whatever reason.

Thanks,

        tglx
