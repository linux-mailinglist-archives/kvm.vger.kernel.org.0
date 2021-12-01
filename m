Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88B9465696
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 20:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245485AbhLATlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 14:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbhLATlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 14:41:01 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4830FC061574;
        Wed,  1 Dec 2021 11:37:39 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 71so24691639pgb.4;
        Wed, 01 Dec 2021 11:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2pQR4NmCSaxcgp6K9YVXVHlggEsM7Bp75xK/vJqmsa0=;
        b=JGtt7aFtGVaGBNVoM5LP+n2i55DPMQv3JN/bKvjlOrjjtGEOzhdDHL7Pb8h9mu/7Cu
         mkLhCxVGFlwTIc5DEvc9HpCIAuf8zIYygEuqrBz0RcD8bBViQeYNFQlqBaTdJCmBCJbN
         o+74+3yf5GO3Xiu5EO/NLLu5bZdkWg+gnMVWC3pH+VfngCEA9d4A9qvfW1/fbWVgDBVs
         7VF7aTuntdE0b3uiULHKWH3NN6m56r2r6dzdp8OjZGXtZrxveuDmuuRDMyYgXvm/iBB5
         iDVdirUqPy1mzh8jgk+qK2Bfy8shbOZVULsvjG48jHLQqp3IP8Jagd9GwmFUEZAQajoe
         w47A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2pQR4NmCSaxcgp6K9YVXVHlggEsM7Bp75xK/vJqmsa0=;
        b=OKngJl7o7JG37ueuQ+JNn+L/QXVFwcIFQSOo9hmww9jFl1YlJBVSxCqzsKmWeAx9Go
         1XDMcaqgMTkrY2CR9ier9tnM7ubumEZHbHZRQmkDbXniW5R2aLiaxnP2DOMm46wujlXt
         S9ygratm21kyRu0dh21xliV7YUSK8WFrjmKFZ1twthWk/iYd7Ung90m1jDkOLRZL71et
         277Q4Pi8KY3cmqB5rl8XkUwGZFLFHinPLA7O+QXMVTqP2ZFGbECNyiy4QCk1FmeIZn7X
         NcTcRkYuJHLbnSpMf3t2hdZdN8UIhaIPbzUcnxhHYCce1cLgWMz6Kk7hkdGNi5ierfOA
         8+2w==
X-Gm-Message-State: AOAM533k0LKMGTXnys8PlHdpdDuSyNcG5LMSoIzkM5Dvhi0EFgD8C9PW
        OzJ2+/aU6mlNCi5TwcQtKrA=
X-Google-Smtp-Source: ABdhPJxHXcCwmQKA5iVtujrmdj750ZdrGnnPFT9YbWf3XHCcFPS3qqtpS5+jKg2Bip0m4SVWlJOXEA==
X-Received: by 2002:a63:904a:: with SMTP id a71mr6278803pge.528.1638387458755;
        Wed, 01 Dec 2021 11:37:38 -0800 (PST)
Received: from localhost ([2601:647:4600:a5:6f71:8916:71a8:8af8])
        by smtp.gmail.com with ESMTPSA id e4sm418588pgi.21.2021.12.01.11.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 11:37:38 -0800 (PST)
Date:   Wed, 1 Dec 2021 11:37:37 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 14/59] KVM: x86: Add vm_type to differentiate
 legacy VMs from protected VMs
Message-ID: <20211201193737.GB1166703@private.email.ne.jp>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <60a163e818b9101dce94973a2b44662ba3d53f97.1637799475.git.isaku.yamahata@intel.com>
 <87tug0jbno.ffs@tglx>
 <YaUPZj4ja5FY7Fvh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaUPZj4ja5FY7Fvh@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 05:35:34PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Nov 25, 2021, Thomas Gleixner wrote:
> > On Wed, Nov 24 2021 at 16:19, isaku yamahata wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > >
> > > Add a capability to effectively allow userspace to query what VM types
> > > are supported by KVM.
> > 
> > I really don't see why this has to be named legacy. There are enough
> > reasonable use cases which are perfectly fine using the non-encrypted
> > muck. Just because there is a new hyped feature does not make anything
> > else legacy.
> 
> Yeah, this was brought up in the past.  The current proposal is to use
> KVM_X86_DEFAULT_VM[1], though at one point the plan was to use a generic
> KVM_VM_TYPE_DEFAULT for all architectures[2], not sure what happened to that idea.
> 
> [1] https://lore.kernel.org/all/YY6aqVkHNEfEp990@google.com/
> [2] https://lore.kernel.org/all/YQsjQ5aJokV1HZ8N@google.com/

Currently <feature>_{unsupported, disallowed} are added and the check is
 sprinkled and warn in the corresponding low level tdx code.  It helped to
 detect dubious behavior of guest or qemu.

The other approach is to silently ignore them (SMI, INIT, IRQ etc) without
such check.  The pros is, the code would be simpler and it's what SEV does today.
the cons is, it would bes hard to track down such cases and the user would
be confused.  For example, when user requests reset/SMI, it's silently ignored.
The some check would still be needed.
Any thoughts?

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
