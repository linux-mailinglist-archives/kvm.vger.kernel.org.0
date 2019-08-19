Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A367924FD
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 15:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfHSN37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 09:29:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47232 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbfHSN37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 09:29:59 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hzhjN-0004Xv-Oe; Mon, 19 Aug 2019 15:29:53 +0200
Date:   Mon, 19 Aug 2019 15:29:53 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     lantianyu1986@gmail.com
cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        michael.h.kelley@microsoft.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: Re: [PATCH V3 3/3] KVM/Hyper-V/VMX: Add direct tlb flush support
In-Reply-To: <20190819131737.26942-4-Tianyu.Lan@microsoft.com>
Message-ID: <alpine.DEB.2.21.1908191528050.2147@nanos.tec.linutronix.de>
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com> <20190819131737.26942-4-Tianyu.Lan@microsoft.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 19 Aug 2019, lantianyu1986@gmail.com wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> 
> This patch is to enable Hyper-V direct tlb flush function
> for vmx.

Groan. This sentence is not any different from the subject line.

Thanks,

	tglx
