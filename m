Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD742FF12D
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 17:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbhAUPu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387576AbhAUPss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 10:48:48 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D75C06174A;
        Thu, 21 Jan 2021 07:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BFnJgdsd/PRHlQDrSzf4Zz4cuDl+ehMHQo/Dg2SAZhs=; b=vmKiOWKT7FScXEh2kIQGBSn4+m
        CLWRqsGRf/3WRIRhJU9OtsGocypOnPDhp29PFP0AeLVtuVCrGqIGddfPAu197lvmxca3XPwY+2M1a
        +/++AKRS/psoriko+9CbEINmghQ8bPT4O2W8OEJICidzb8C2KqQeolPVfdUFHX6BbL1PRt6hY/Sdy
        Aia0GsZKhfzkqx+Ik+NBEy9Gc02gWB8yv06pz7Bu+VLkL5ENDXblSL6VWvEMgXnIucA9kDv7GQRR7
        LzMUZxqMQfF89hCLPC7zbW+P9R20OsFbY+5n+k8fgUCnumZZD/x8w8Q8nYJFTk3REJPbj16IiFmwY
        xDIw0/aw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l2cBS-0002IH-Sg; Thu, 21 Jan 2021 15:47:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 169513007CD;
        Thu, 21 Jan 2021 16:47:40 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F2E31200D6EE0; Thu, 21 Jan 2021 16:47:39 +0100 (CET)
Date:   Thu, 21 Jan 2021 16:47:39 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: vmx: Assign boolean values to a bool variable
Message-ID: <YAmiG3FLMYKwF0jV@hirez.programming.kicks-ass.net>
References: <1611218906-71903-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611218906-71903-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 21, 2021 at 04:48:26PM +0800, Jiapeng Zhong wrote:
> Fix the following coccicheck warnings:
> 
> ./arch/x86/kvm/vmx/vmx.c:6798:1-27: WARNING: Assignment of 0/1
> to bool variable.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>

Your robot is running old scripts; please see commit:

  2b076054e524 ("remove boolinit.cocci")
