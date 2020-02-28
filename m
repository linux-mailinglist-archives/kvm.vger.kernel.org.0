Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE7D173F92
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 19:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgB1S1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 13:27:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29653 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725877AbgB1S1m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Feb 2020 13:27:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582914461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mgCjytFydL/uH15zVn61kPfjhPIXAOWGcEvln1LjerY=;
        b=QVAWSRIeAs+U8n52zir4wnyRXU6pcI0U4oOhd1JpTcHN6B1tiWw6Ek70QlWmC4P9VbcuNx
        /oXIapXdmeB3xO3w048Du2AhI9sJtFWAykNcL//3BNSUVazn1B9trxa4s5tcMlAuASh6Q9
        L3hVCZo24fd0mVyvRLn02d+Eg6KAvms=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-H0W_0kuHPXmW-WnRQDReTA-1; Fri, 28 Feb 2020 13:27:39 -0500
X-MC-Unique: H0W_0kuHPXmW-WnRQDReTA-1
Received: by mail-qv1-f69.google.com with SMTP id l1so3284907qvu.13
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 10:27:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mgCjytFydL/uH15zVn61kPfjhPIXAOWGcEvln1LjerY=;
        b=hz8JSADaW31olVfpQHSEpY6yymSd5A6MeVV2zxfsaKqnFCsdy0TylbFEJYcZE0/jVS
         aH3zrva+/pkah4ULnf/JRd+uDygRS9tga46oicnBRhnjXXdM9SEhIm/j9lmsZFsIEO1R
         0hhFOHWzVjUlUXEqDc58Ejx8vtjiBgep5kuyc+7vCY/4WpOZPK2+S7CA0MYNiDGZ46FK
         A9p0OKyZtoyM1chzI02JtOPs5YqIahxZNI1fVaaMqnJEpCtBa+UO8ezCENGB7UeV1qjG
         KRPut6PMgQ5TXAom42/pzCmdZChDZV4CZT4ptK/jtgsIAgLBNXdjnhC3FSnDQy6jmAqH
         PAkw==
X-Gm-Message-State: APjAAAVLw6HIeHP5CkmLF5DQns10iMgnhsStWCx9jfk+jmdnUqwRLee0
        skO9GKB95V2GQIOXZaluLhmeyb6JwICPg/1ZfIpPaexr0j3R/NveJE7uy9ZZVZ29fykIVEvX1z3
        rJh4o+KqpQBL2
X-Received: by 2002:ac8:42de:: with SMTP id g30mr5355460qtm.195.1582914458704;
        Fri, 28 Feb 2020 10:27:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqxT1SKWdoUl2bnRQilz4wBtvIO/ikHK6qptKHrZBRPXEEKC5/BRZuiTYAm9dsQDLd+i9VpVDA==
X-Received: by 2002:ac8:42de:: with SMTP id g30mr5355443qtm.195.1582914458494;
        Fri, 28 Feb 2020 10:27:38 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id f13sm1030834qkm.42.2020.02.28.10.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:27:37 -0800 (PST)
Date:   Fri, 28 Feb 2020 13:27:36 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, jianjay.zhou@huawei.com
Subject: Re: [PATCH] KVM: Remove unecessary asm/kvm_host.h includes
Message-ID: <20200228182736.GU180973@xz-x1>
References: <20200226155558.175021-1-peterx@redhat.com>
 <20200228180503.GH2329@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200228180503.GH2329@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 28, 2020 at 10:05:03AM -0800, Sean Christopherson wrote:
> s/unecessary/unnecessary
> 
> On Wed, Feb 26, 2020 at 10:55:58AM -0500, Peter Xu wrote:
> > linux/kvm_host.h and asm/kvm_host.h have a dependency in that the asm
> > header should be included first, then we can define arch-specific
> > macros in asm/ header and use "#ifndef" in linux/ header to define the
> > generic value of the macro.  One example is KVM_MAX_VCPU_ID.
> > 
> > Now in many C files we've got both the headers included, and
> > linux/kvm_host.h is included even earlier.  It's working only because
> > in linux/kvm_host.h we also included asm/kvm_host.h anyway so the
> > explicit inclusion of asm/kvm_host.h in the C files are meaningless.
> 
> I'd prefer to word this much more strongly, i.e. there is no "should"
> about it, including asm/kvm_host.h in linux/kvm_host.h is deliberate, 
> it's not serendipitous.
> 
> ```
> Remove includes of asm/kvm_host.h from files that already include
> linux/kvm_host.h to make it more obvious that there is no ordering issue
> between the two headers.  linux/kvm_host.h includes asm/kvm_host.h to
> pick up architecture specific settings, and this will never change, i.e.
> including asm/kvm_host.h after linux/kvm_host.h may seem problematic,
> but in practice is simply redundant.
> ```
> 
> As for the change itself, I'm indifferent.

Sure, I'll fix up these and repost.  Thanks,

-- 
Peter Xu

