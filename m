Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E659A129F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 09:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfH2H3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 03:29:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfH2H3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 03:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dc2Z2UKK8fKuTLf/li8BqTmSenbTjt/gCC0UkBjn7Xs=; b=MULGiP11SFMllSzI/CjtnvesA
        w8JiIv+qEMdapiaD0fthWONhOJzHeJ0Yz4wcjoadeuaD5ztgqDhVAp3kNQiPpGBlP0MGIxN3Wpl1W
        BKHuOABfbFUaj4UpV8KoOocWjIRIGcFfdLq9UTzj6rTW/341d75TDcX+/RKOzNfxcpnEL5O9m3rNd
        NgEaec2Hz2Opphxr1zW5PptXjrMuh4XSVF+AS/h2ZJjuFl/HhLkCDv/kIiohkKQiN9nbpgeI/xymw
        nzbugkSOt8QQEovo98+vMN9YGozRuv4jv7v1jXOOfYMFqp+FdOiigFImfqs1GShTgTOMM2fE8EIU1
        n5M3UEgXQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3ErY-0002Ef-Kz; Thu, 29 Aug 2019 07:28:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 555F33070F4;
        Thu, 29 Aug 2019 09:28:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 40C0320CC3FD4; Thu, 29 Aug 2019 09:28:53 +0200 (CEST)
Date:   Thu, 29 Aug 2019 09:28:53 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 0/9] PEBS enabling in KVM guest
Message-ID: <20190829072853.GK2369@hirez.programming.kicks-ass.net>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 01:34:00PM +0800, Luwei Kang wrote:
> Intel new hardware introduces some Precise Event-Based Sampling (PEBS)
> extensions that output the PEBS record to Intel PT stream instead of
> DS area. The PEBS record will be packaged in a specific format when
> outputing to Intel PT.
> 
> This patch set will enable PEBS functionality in KVM Guest by PEBS
> output to Intel PT. The native driver as [1] (still under review).
> 
> [1] https://www.spinics.net/lists/kernel/msg3215354.html

Please use:

  https://lkml.kernel.org/r/$MSGID

then I don't have to touch a browser but can find the email in my MUA.
