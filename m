Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38282ED41F
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 17:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbhAGQPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 11:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbhAGQPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 11:15:33 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E549C0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 08:14:53 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id be12so3786934plb.4
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 08:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W62GPObuSspyqepoTzpoKCHe3nBT3U/1Tl6FDSSq1IE=;
        b=sQBiLrHIuKyGZPYxBGjU9Ad1iuDDL+k+vbgDfgamd2P0mhQkWqRXTp2j+WoWHA7oEx
         WM+Bi1RskpQsx10Xyuy3VJjGQ34+gKj54/wh5fv9CTiC2VKQO0g5NB8i4ON65QNhzMDF
         oQ7ar3UbHWjLl/XFefAuKUOxnmEOrNbz1mxDcHW/2tN93HqC9rl26MVQnVopk76SHk7p
         T1qMbD43Iyt/HbGZM6MLymsBbJwwF9BN9gDWG/iMDYnP1FgxQBhI1BzhUrwxVjmHEwvX
         toUqQu5MO5jvBTGnmEXCwhzOk+uOp7DjhTpUDjnSUsreC4m5oNUIZRuraKWCIP2i9CGj
         ixag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W62GPObuSspyqepoTzpoKCHe3nBT3U/1Tl6FDSSq1IE=;
        b=hsozULhwOE8KiNmhsT30LkQsdggJjlqmsdYtYPYW2mO1Q1y7h/dQJXcSj37TuOEAXQ
         y12k2MdPatXZDvpWYnfyuk2nnjCE3tKESbHOJ9eqaKBUITJUQDzHqH5RovKmt7aPV277
         EBOFDnzpdWGxKV/E4dg2loJJYrE5U/fSgsjT2kFgCJ2txa4ZTFpR04nrU5PGvJyNqF1q
         r84JVAJ3ImUaVekzUqEiPKmJ8/Zks4MGK9lTinFTj5qYBvyAZJoEa1O7yQ2bQkf3PlLG
         ELxrBh4BaY5XHt+yBsJaW2rdaVVr/N08nQ6COOHAoSVo2eiZpHOBKhvWTDKPrf0LH291
         DlFA==
X-Gm-Message-State: AOAM532P+9KcnJzdp796peptpeOyW5xxZQ29fg14sHDaUAsthC7hcEMl
        9cmAWQl33Q/nOXcyZtX+VjMmOQ==
X-Google-Smtp-Source: ABdhPJz51zDspEWiB7pI8+5FJizRvdTQzK6MijqTd2Vxhe8+47XTaaZaNzonGoJMalagg25tjQK61A==
X-Received: by 2002:a17:90a:3d4e:: with SMTP id o14mr9772493pjf.44.1610036092470;
        Thu, 07 Jan 2021 08:14:52 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id u25sm5993150pfn.101.2021.01.07.08.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:14:51 -0800 (PST)
Date:   Thu, 7 Jan 2021 08:14:44 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
Message-ID: <X/czdL6TmbuBdZ/b@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <1772bbf4-54bd-e43f-a71f-d72f9a6a9bad@intel.com>
 <20210107133441.0983ca20f7909186b8ff8fa1@intel.com>
 <d586730e-d02f-8059-0a81-cbfd762deacf@intel.com>
 <20210107145026.a8f593323ab9ae34874250ed@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107145026.a8f593323ab9ae34874250ed@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021, Kai Huang wrote:
> On Wed, 6 Jan 2021 16:48:58 -0800 Dave Hansen wrote:
> > Your series adds some new interfaces, including /dev/sgx_virt_epc.  If
> > the kernel wants to add oversubscription in the future, will old binary
> > application users of /dev/sgx_virt_epc be able to support
> > oversubscription?  Or, would users of /dev/sgx_virt_epc need to change
> > to support oversubscription?
> 
> Oversubscription will be completely done in kernel/kvm, and will be
> transparent to userspace, so it will not impact ABI.

It's not transparent to userpsace, odds are very good that userspace would want
to opt in/out of EPC reclaim for its VMs.  E.g. for cases where it would be
preferable to fail to launch a VM than degrade performance.

That being said, there are no anticipated /dev/sgx_virt_epc ABI changes to
support reclaim, as the ABI changes will be in KVM.  In the KVM oversubscription
POC, I added a KVM ioctl to allow enabling EPC reclaim/oversubscription.  That
ioctl took a fd for a /dev/sgx_virt_epc instance.

The reason for routing through KVM was to solve two dependencies issues:

  - KVM needs a reference to the virt_epc instance to handle SGX_CONFLICT VM-Exits

  - The SGX subsystem needs to be able to translate GPAs to HVAs to retrieve the
    SECS for a page it is reclaiming.  That requires a KVM instance and helper
    function.

Routing the ioctl through KVM allows KVM to hand over a pointer of itself along
with a GPA->HVA helper, and the SGX subsystem in turn can hand back the virt_epc
instance resolved from the fd.

It would be possible to invert the flow, e.g. pass in a KVM fd to a new
/dev/sgx_virt_epc ioctl, but I suspect that would be kludgier, and in any case
it would be a new ioctl and so would not break existing users.
