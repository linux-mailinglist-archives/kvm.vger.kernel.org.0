Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B213B5502
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 20:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfIQSMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 14:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbfIQSMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 14:12:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46A4421670;
        Tue, 17 Sep 2019 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568743962;
        bh=SJCn4cJq7Wgo0gWUlVrukjk4zj7o7R/x/W9PXvxAsdQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mx4Iq4xJTDPnGb8X5KOx/lQBPW/vgIn2k3VolXNtdqV8ft3CKioXFN0fD0P86JMCG
         fs5XuYfKuQ3et9ZvJ01aGBz9b3xsYBZz/M9TKHTzyuSG9P+9QgwpV+lUsHTSumHfp6
         Xym92imRa7rXm1PD28Vj/JG2S6SIHnlDkcio1b6I=
Date:   Tue, 17 Sep 2019 20:12:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yi Wang <wang.yi59@zte.com.cn>, rkrcmar@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: Re: [PATCH] kvm: x86: Use DEFINE_DEBUGFS_ATTRIBUTE for debugfs files
Message-ID: <20190917181240.GA1572563@kroah.com>
References: <1563780839-14739-1-git-send-email-wang.yi59@zte.com.cn>
 <31eec57f-2bc8-0ea0-e5fb-6b21ce902aae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31eec57f-2bc8-0ea0-e5fb-6b21ce902aae@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 07:18:33PM +0200, Paolo Bonzini wrote:
> On 22/07/19 09:33, Yi Wang wrote:
> > We got these coccinelle warning:
> > ./arch/x86/kvm/debugfs.c:23:0-23: WARNING: vcpu_timer_advance_ns_fops
> > should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > ./arch/x86/kvm/debugfs.c:32:0-23: WARNING: vcpu_tsc_offset_fops should
> > be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > ./arch/x86/kvm/debugfs.c:41:0-23: WARNING: vcpu_tsc_scaling_fops should
> > be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > ./arch/x86/kvm/debugfs.c:49:0-23: WARNING: vcpu_tsc_scaling_frac_fops
> > should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > 
> > Use DEFINE_DEBUGFS_ATTRIBUTE() rather than DEFINE_SIMPLE_ATTRIBUTE()
> > to fix this.
> > 
> > Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> 
> It sucks though that you have to use a function with "unsafe" in the name.

I agree, why make this change?

> Greg, is the patch doing the right thing?

I can't tell.  What coccinelle script generated this patch?

thanks,

greg k-h
