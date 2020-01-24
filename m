Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777BF148FD8
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 22:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgAXVAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 16:00:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgAXVAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 16:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EzpuHyEK+V1u82omKAA2mOHojjIIggmKMI2AKO+L34E=; b=SPRgKkxdTE1Omjgs2P49vaIjg
        d9tCzwzPutBJIJ+QW5AJbJT76XyeXMhMnsdfZL9oDJ/6iNAQfSgeJrtQy88/twEdD9fnhx9hTaeaA
        M87+j2dGsCi/d3ZpsOAeBHFlNLdDpaNH23MC8E18Hz+n7wskA5aPBZTh041N4QzIYW5mjTWS/MIOT
        Xpl7mEPrD45TPzftYOJ2dXUU1ziFX53jFW/wqA784RWm37M3KOnoNPLsdKXZgeVtlrhg+BrVOA5zZ
        VuyXSxkryEeykzcdRuaj7bTxyqF5dt9w9qtH9b8TGsCw1NJrCxUJPd7KDkdjzk0yhgynve0WdOHWP
        fevgWJv6g==;
Received: from [2601:1c0:6280:3f0::ed68]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv63Z-0006Ug-Hb; Fri, 24 Jan 2020 20:59:57 +0000
Subject: Re: linux-next: Tree for Jan 24 (kvm)
From:   Randy Dunlap <rdunlap@infradead.org>
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
 <38d53302-b700-b162-e766-2e2a461fc569@infradead.org>
Message-ID: <8f6e1118-85ef-6e0d-b023-1277e7d42a1c@infradead.org>
Date:   Fri, 24 Jan 2020 12:59:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <38d53302-b700-b162-e766-2e2a461fc569@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/20 12:51 PM, Randy Dunlap wrote:
> On 1/23/20 10:33 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20200123:
>>
>> The kvm tree gained a conflict against Linus' tree.
>>
> 
> on i386:
> 
> ../arch/x86/kvm/x86.h:363:16: warning: right shift count >= width of type [-Wshift-count-overflow]
> 
> 

Sorry, I missed these 2 warnings:

../arch/x86/kvm/vmx/vmx.c: In function 'vmx_set_msr':
../arch/x86/kvm/vmx/vmx.c:2001:14: warning: '~' on a boolean expression [-Wbool-operation]
   if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
              ^


../arch/x86/kvm/svm.c: In function 'svm_set_msr':
../arch/x86/kvm/svm.c:4289:14: warning: '~' on a boolean expression [-Wbool-operation]
   if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
              ^
../arch/x86/kvm/svm.c:4289:14: note: did you mean to use logical not?
   if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
              ^
              !

-- 
~Randy

