Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E6F148FCC
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 21:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgAXUvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 15:51:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40434 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgAXUvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 15:51:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FwREgydDWTl0lQurue8lUof7m5LIZcaBwElWWmm89gA=; b=b/0DNAeAJS+nDvbt3wDRcnA32
        1H4DWcGQTha7XXhJ5+Zhu0O4ywluj7AcsEMQ1NUcriBNyvblnE2dwPumIFCDERk+3/e2K9cDbZErv
        8cW4p7QGjG7rFKaTjHEDJJnR5CSkOGhhHXQauVQKHBRpwI9W86o6U1og2zdT1KLVxf6ZxZgcvfsHe
        W/7/j7xgm6QhXHRn8088MUZv+KfTcwMVE4oPra1YJ6VWQWl/2EAUoZT8H8sWiYbp+JXJ/OS2x+P4+
        SPffvg8Ml15waloWyfFuoeJBdO7R0d0PemoHSF+jlSFhwMTj40Os/GI9cqZsCZFMaMlvvw4LzzcoF
        Xa4gwsicA==;
Received: from [2601:1c0:6280:3f0::ed68]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv5vS-0004HL-5n; Fri, 24 Jan 2020 20:51:34 +0000
Subject: Re: linux-next: Tree for Jan 24 (kvm)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM <kvm@vger.kernel.org>
References: <20200124173302.2c3228b2@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <38d53302-b700-b162-e766-2e2a461fc569@infradead.org>
Date:   Fri, 24 Jan 2020 12:51:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200124173302.2c3228b2@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/23/20 10:33 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200123:
> 
> The kvm tree gained a conflict against Linus' tree.
> 

on i386:

../arch/x86/kvm/x86.h:363:16: warning: right shift count >= width of type [-Wshift-count-overflow]


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
