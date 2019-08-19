Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B04924F4
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 15:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfHSN2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 09:28:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47221 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbfHSN2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 09:28:00 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hzhhQ-0004Vx-MT; Mon, 19 Aug 2019 15:27:52 +0200
Date:   Mon, 19 Aug 2019 15:27:51 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     lantianyu1986@gmail.com
cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH V3 2/3] KVM/Hyper-V: Add new KVM cap
 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
In-Reply-To: <20190819131737.26942-3-Tianyu.Lan@microsoft.com>
Message-ID: <alpine.DEB.2.21.1908191522390.2147@nanos.tec.linutronix.de>
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com> <20190819131737.26942-3-Tianyu.Lan@microsoft.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 19 Aug 2019, lantianyu1986@gmail.com wrote:

> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> This patch adds

Same git grep command as before

>  new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH and let

baseball cap? Please do not use weird acronyms. This is text and there is
not limitation on characters.

> user space to enable direct tlb flush function when only Hyper-V
> hypervsior capability is exposed to VM.

Sorry, but I'm not understanding this sentence.

> This patch also adds

Once more

> enable_direct_tlbflush callback in the struct kvm_x86_ops and
> platforms may use it to implement direct tlb flush support.

Please tell in the changelog WHY you are doing things not what. The what is
obviously in the patch.

So you want to explain what you are trying to achieve and why it is
useful. Then you can add a short note about what you are adding, but not at
the level of detail which is available from the diff itself.

Thanks,

	tglx
