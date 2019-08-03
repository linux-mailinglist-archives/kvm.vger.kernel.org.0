Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A186F80517
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 09:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfHCHln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 03:41:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40824 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfHCHln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 03:41:43 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htofT-0001g9-Sd; Sat, 03 Aug 2019 09:41:32 +0200
Date:   Sat, 3 Aug 2019 09:41:30 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Greg KH <gregkh@linuxfoundation.org>,
        Radim Krm <rkrcmar@redhat.com>, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: remove kvm_arch_has_vcpu_debugfs()
In-Reply-To: <6ddc98b6-67d9-1ea4-77d8-dcaf0b5a94cc@redhat.com>
Message-ID: <alpine.DEB.2.21.1908030939530.4029@nanos.tec.linutronix.de>
References: <20190731185556.GA703@kroah.com> <6ddc98b6-67d9-1ea4-77d8-dcaf0b5a94cc@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 3 Aug 2019, Paolo Bonzini wrote:
> On 31/07/19 20:55, Greg KH wrote:
> > There is no need for this function as all arches have to implement
> > kvm_arch_create_vcpu_debugfs() no matter what, so just remove this call
> > as it is pointless.
> 
> Let's remove kvm_arch_arch_create_vcpu_debugfs too for non-x86 arches.

Can't we remove _all_ that virt muck? That would solve a lot more problems
in one go.

/me ducks
