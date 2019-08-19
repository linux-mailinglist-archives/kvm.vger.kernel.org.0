Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1BE92501
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 15:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfHSNac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 09:30:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47241 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727642AbfHSNac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 09:30:32 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hzhjt-0004ZC-Hq; Mon, 19 Aug 2019 15:30:25 +0200
Date:   Mon, 19 Aug 2019 15:30:24 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     lantianyu1986@gmail.com
cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, michael.h.kelley@microsoft.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH V3 1/3] x86/Hyper-V: Fix definition of struct
 hv_vp_assist_page
In-Reply-To: <20190819131737.26942-2-Tianyu.Lan@microsoft.com>
Message-ID: <alpine.DEB.2.21.1908191520110.2147@nanos.tec.linutronix.de>
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com> <20190819131737.26942-2-Tianyu.Lan@microsoft.com>
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
> The struct hv_vp_assist_page was defined incorrectly.
> The "vtl_control" should be u64[3], "nested_enlightenments

s/The /The member/

> _control" should be a u64 and there is 7 reserved bytes

s/is/are/

> following "enlighten_vmentry". This patch is to fix it.

git grep 'This patch' Documentation/process/

Thanks,

	tglx
