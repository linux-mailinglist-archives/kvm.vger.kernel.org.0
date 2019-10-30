Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42314E9986
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 10:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfJ3Jwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 05:52:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49528 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfJ3Jwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 05:52:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hZscaMFd68WRefJPnNBfniqTe1cBPy4JDMz4CwY8NGY=; b=DUWupKwPEmaunrC1ogUx+eZHy
        l2XFgEOn5TTw5Wuvnxoi64xvV6W5/nP/wVHeCUP39qG1J+2z36HELIAkOYU6IlCQPQslBP8NhnnU3
        5RENZlhc/mJznfvOhFk3eTwK2Q6SI0nUxKDzqfdfs807tYZztCxRL/NjRsCwKjpTTcq0caJGj/2tZ
        nQl7kbtAukhAfttOROrGSr4LHf0WbOSOmrPeh1DuVS95pH0c5nSRaS87JSjS/fynG12/WzUV8VKeW
        DgyHRzE/LMTM71Y6qAqnCfmgv4ltTqRzVA3dNlIFoOZJ6c0mZYBKjNl/ade2P5bOH+uC8qfGRPv/k
        efNOfvTCg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPkeF-00072R-TD; Wed, 30 Oct 2019 09:52:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8475B300596;
        Wed, 30 Oct 2019 10:51:13 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A5EB52B4574F3; Wed, 30 Oct 2019 10:52:14 +0100 (CET)
Date:   Wed, 30 Oct 2019 10:52:14 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: Re: [PATCH v1 7/8] KVM: x86: Expose PEBS feature to guest
Message-ID: <20191030095214.GT4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-8-git-send-email-luwei.kang@intel.com>
 <20191029150531.GN4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B45@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E173835B45@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 30, 2019 at 04:07:03AM +0000, Kang, Luwei wrote:
> > > Expose PEBS feature to guest by IA32_MISC_ENABLE[bit12].
> > > IA32_MISC_ENABLE[bit12] is Processor Event Based Sampling (PEBS)
> > > Unavailable (RO) flag:
> > > 1 = PEBS is not supported; 0 = PEBS is supported.
> > 
> > Why does it make sense to expose this on SVM?
> 
> Thanks for the review. This patch won't expose the pebs feature to SVM and return not supported.

AFAICT it exposes/emulates an Intel MSR on AMD, which is just weird.
