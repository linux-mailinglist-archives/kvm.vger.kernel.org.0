Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E231B9B9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 17:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbfEMPQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 11:16:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56202 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfEMPQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 11:16:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bYuqnNx8h6Iw6jTM353AK1PTjYrbJH6v8Q1fEGBhMmc=; b=eL3QpXJRQjwXezlHRxfCBxm8e
        Kc0EnqgYz91km3dBTclXTRds68PSLigiCzchSr4QK7JAmBnZBEThmffHXoSPR3XcYY98+gWsAfb7B
        mVu231w+Kk7wKcEDyhIvIZwAl5JUwsQ5DoGIggNvPnlR84ITHS7vZxyFaFoZV4NmvCrxYruTH/WyL
        YhcBvIYRTrAC5P39CLL7HXC6Vq2TCbZVcgm4ZWdjcyAaIVsRCF0hnYiDpaXdTQ8WAPenSAHTiChs7
        qYS9xx6BwvqnqKRzs/ZdifIKkAgPBD1itn4DTe/691rEVSvUK1HR8eVTeI1ph1XacQSWx4AZ72U8D
        IQ4NvMS6Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQCgB-00082o-SH; Mon, 13 May 2019 15:15:52 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A89E92029F877; Mon, 13 May 2019 17:15:50 +0200 (CEST)
Date:   Mon, 13 May 2019 17:15:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com
Subject: Re: [RFC KVM 01/27] kernel: Export memory-management symbols
 required for KVM address space isolation
Message-ID: <20190513151550.GZ2589@hirez.programming.kicks-ass.net>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-2-git-send-email-alexandre.chartre@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557758315-12667-2-git-send-email-alexandre.chartre@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 04:38:09PM +0200, Alexandre Chartre wrote:
> From: Liran Alon <liran.alon@oracle.com>
> 
> Export symbols needed to create, manage, populate and switch
> a mm from a kernel module (kvm in this case).
> 
> This is a hacky way for now to start.
> This should be changed to some suitable memory-management API.

This should not be exported at all, ever, end of story.

Modules do not get to play with address spaces like that.
