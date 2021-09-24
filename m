Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E46E416C13
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 08:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244262AbhIXGtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 02:49:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244211AbhIXGtL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 02:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632466057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j2KQr45baQYJYr6dUnfIDkxfbuPODwumfELuFXI+bXM=;
        b=JFr2AYqUFNoTFJzP3tyfjsxVBA68DricjWCc825kiZSSkBkuv/c3qesHCbu43s5LcWTydP
        A+pyl1SuISfvcmPwMAcE0vmmAkq2s/bxvez+wpU8aTgc2R20M8Khw8XJk6tflJW2c4eMJP
        h2Yu5VTfSOnU/BLT1meetIMGCGUwPqk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-eg0-k4SyN1KQIbqSXjSnow-1; Fri, 24 Sep 2021 02:47:36 -0400
X-MC-Unique: eg0-k4SyN1KQIbqSXjSnow-1
Received: by mail-ed1-f69.google.com with SMTP id o23-20020a509b17000000b003d739e2931dso9268658edi.4
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 23:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j2KQr45baQYJYr6dUnfIDkxfbuPODwumfELuFXI+bXM=;
        b=CUkOlkR2kX59FhtIP4xkMqxjfwm06wwkc6rpHu4zMEH/u0lAGYfD/Qy7KNHGT763Qo
         KHuh0t5Tpot/veserNbG7k86tRcfG1GbzAVDBXamQW0VNmg6eJl+/+Dm/q75RkUtP20z
         dCDPn19epD0X/uo2l9+teLZTT7XQtjR49D6MObZfo+goZD6var7HkdkWQp64dbeYQSqL
         SVYH9qL4HC40OLCBs9/Dc0NfTy+kTXJTjIWJdVNRYRqkuc2o0phJyh09p3W8I/PtLLme
         9IhpcUaFa093LxwcLvPv8Mj6Agn4HYNHovk6BmEoI6X7P6dpY0dhuFgGZA8s1QLI56iN
         d4gA==
X-Gm-Message-State: AOAM531KMEPgOpsG6BLO4ew1oWoaI87nY1epNVfy/i0uVjCSSnJ+P9d/
        EI/c9uyAkvk4vpISYHHnAk3oQkXefFqiy6S6pJDSEAlf3sZChz1W9m7hT86/zu1tbmYP60c4IYQ
        91IvMWZlmSiZJ
X-Received: by 2002:aa7:d459:: with SMTP id q25mr3275073edr.62.1632466055084;
        Thu, 23 Sep 2021 23:47:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaN40OP+imxKFV5YmCeh+GS/xyWgZCQsY0YIEujkDc+8xVH6Bjx9zUITPQQ59lKIzSrEPQTw==
X-Received: by 2002:aa7:d459:: with SMTP id q25mr3275065edr.62.1632466054928;
        Thu, 23 Sep 2021 23:47:34 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id z3sm4374149eju.34.2021.09.23.23.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 23:47:34 -0700 (PDT)
Date:   Fri, 24 Sep 2021 08:47:32 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] selftests: KVM: Call ucall_init when setting up in
 rseq_test
Message-ID: <20210924064732.xqv2xjya3pxgmwr2@gator.home>
References: <20210923220033.4172362-1-oupton@google.com>
 <YU0XIoeYpfm1Oy0j@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YU0XIoeYpfm1Oy0j@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 12:09:06AM +0000, Sean Christopherson wrote:
> On Thu, Sep 23, 2021, Oliver Upton wrote:
> > While x86 does not require any additional setup to use the ucall
> > infrastructure, arm64 needs to set up the MMIO address used to signal a
> > ucall to userspace. rseq_test does not initialize the MMIO address,
> > resulting in the test spinning indefinitely.
> > 
> > Fix the issue by calling ucall_init() during setup.
> > 
> > Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  tools/testing/selftests/kvm/rseq_test.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > index 060538bd405a..c5e0dd664a7b 100644
> > --- a/tools/testing/selftests/kvm/rseq_test.c
> > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > @@ -180,6 +180,7 @@ int main(int argc, char *argv[])
> >  	 * CPU affinity.
> >  	 */
> >  	vm = vm_create_default(VCPU_ID, 0, guest_code);
> > +	ucall_init(vm, NULL);
> 
> Any reason not to do this automatically in vm_create()?  There is 0% chance I'm
> going to remember to add this next time I write a common selftest, arm64 is the
> oddball here.
>

Yes, please. But, it'll take more than just adding a ucall_init(vm, NULL)
call to vm_create. We should also modify aarch64's ucall_init to allow
a *new* explicit mapping to be made. It already allows an explicit mapping
when arg != NULL, but we'll need to unmap the default mapping first, now.
The reason is that a unit test may not be happy with the automatically
selected address (that hasn't happened yet, but...) and want to set its
own.

Thanks,
drew

