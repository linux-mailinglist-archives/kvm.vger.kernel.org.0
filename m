Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52EA3BF6A4
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 09:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhGHIB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 04:01:59 -0400
Received: from 8bytes.org ([81.169.241.247]:33152 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229851AbhGHIB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 04:01:59 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 17F73312; Thu,  8 Jul 2021 09:59:15 +0200 (CEST)
Date:   Thu, 8 Jul 2021 09:59:07 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     pbonzini@redhat.com
Cc:     Lenny Szubowicz <lszubowi@redhat.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86/kvmclock: Stop kvmclocks for hibernate restore
Message-ID: <YOawSzWrNtUIlSuE@8bytes.org>
References: <20210326024143.279941-1-lszubowi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326024143.279941-1-lszubowi@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Thu, Mar 25, 2021 at 10:41:43PM -0400, Lenny Szubowicz wrote:
> Reported-by: Xiaoyi Chen <cxiaoyi@amazon.com>
> Tested-by: Mohamed Aboubakr <mabouba@amazon.com>
> Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
> ---
>  arch/x86/kernel/kvmclock.c | 40 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)

What is the status of this patch? Are there any objections?

Regards,

	Joerg
