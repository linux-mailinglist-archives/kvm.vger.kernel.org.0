Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71627E8B4C
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 15:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389755AbfJ2O42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 10:56:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41156 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJ2O42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 10:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=itujIrcjgeHcRCRmt2i/Dn9p5NDbz46nO37Gz+uhz+w=; b=2NV5ZpXwawqB+4I1yuLgiH+lq
        a+OLyTYIdqCnGK5rjFSfgccN0T8UoE9rorE6fX8ga6YFFcYa34I83UY3LJGLAXyKxK9QtYrTkI55Y
        FfZ6PEBqaHRCpX96Mp7s+H7SpP/yQp+v9DoG+3mtguky7SdErIgf39p0BJyLM6KSWGtr+EfUc09Hg
        GdDwc05VJ3+roqDlMkhNApINBBRUxpzzd35VH6WCS2k3OsHpPzFH39EE613sYpyB4J6vvU1dBir5o
        +4xDOAgetYl3oxj8KdVVDOgrXhUFTKC3YWf8zKBWXn7TUGmOA1kGLau1lyLFFzlsnTfvWj/KEqQEC
        fECWx8ZZg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPSuZ-0004kf-Mo; Tue, 29 Oct 2019 14:55:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CCF73306B4A;
        Tue, 29 Oct 2019 15:54:52 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9487C2B43836E; Tue, 29 Oct 2019 15:55:53 +0100 (CET)
Date:   Tue, 29 Oct 2019 15:55:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org
Subject: Re: [PATCH v1 4/8] KVM: x86: Aviod clear the PEBS counter when PEBS
 enabled in guest
Message-ID: <20191029145553.GL4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-5-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572217877-26484-5-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 27, 2019 at 07:11:13PM -0400, Luwei Kang wrote:
> This patch introduce a parameter that avoid clear the PEBS event
> counter while running in the guest. The performance counter which
> use for PEBS event can be enabled through VM-entry when PEBS is
> enabled in guest by PEBS output to Intel PT.

Please write coherent Changelogs. I have no clue what you're trying to
say.

Also, maybe this attrocious coding style is accepted in KVM, but I'm not
having it. Pretty much all your linebreaks and subsequent indenting is
against style.
