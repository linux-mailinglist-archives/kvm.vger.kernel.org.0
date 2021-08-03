Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A303DF593
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 21:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhHCT0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 15:26:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238920AbhHCT0Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 15:26:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628018764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AuezItg9seEgfMKYB1g/Rctit7PAPDnaoS+2H0jfLOQ=;
        b=JyQbWiWA/ShnqQS9193SwxTv8XnGyg0v85aSUjbImuoSD663ZStghkRreCNY3sHo9ZR4oj
        jY3XMS83Sckg1g8asCpqJlU76X0qmENsQZhdLKr16rNUerKGLlAJfh7FZqVnHrSpiacSQq
        qm1BaLxL0nQdAS5iOVvS+Pqj8ClEZ6c=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-G11JtJpfNb2E5JaGu-ahSw-1; Tue, 03 Aug 2021 15:26:01 -0400
X-MC-Unique: G11JtJpfNb2E5JaGu-ahSw-1
Received: by mail-qv1-f71.google.com with SMTP id y10-20020a0cd98a0000b029032ca50bbea1so18532113qvj.12
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 12:26:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AuezItg9seEgfMKYB1g/Rctit7PAPDnaoS+2H0jfLOQ=;
        b=HjBZfu3jgEUGkBI3V/Bqt7r9N6ICY0WWxEIsrzcKQciChbZivsNBbuMPZOCQQh7vZv
         XxU3OiKpJs+bWktp1T2hC+a/1OPtQ7YOjjDheoNSMDzIppIzmXDa0vrWJJwi5CnLn2PB
         rJWR5GnO4GCcIWx7mo+Q2zxVaul6iixTjZwTSHMKeO2WKOh5dnE6sGMCWhYSTtdZeDgC
         hGl4UNQ7zcTCK3eh22ajCCdNzG4Sa/9IS7gdy6fPNFqLKT67E2Apv4NZK8KHb1AhwVhP
         30zroe9trvyYvMVYXvGxtUaTgtsVbDm61Q0kiOgD+WPRdfAI0BEYaczWolF4F6HRRfqB
         shdw==
X-Gm-Message-State: AOAM533oVsalSUTMuSSejo2g7ki6ci75Fd4HzIdMB72ROBs5kXua8HNN
        wi3noUM+LtSfxOEjDOSD2ash/Su5ggHtTQOUH2Tw+B7cNirIqIP53ztuon2HTGjkscl4KoeI5A8
        4tC+v5lJtmxQJ
X-Received: by 2002:ae9:ebd5:: with SMTP id b204mr21648674qkg.183.1628018760671;
        Tue, 03 Aug 2021 12:26:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYeoQDv54NHjaIqbGDtNPTql9N7o1wDb61oHzcCt7l9lNHoPyLztEafRgQaLSDv9++2pNkrw==
X-Received: by 2002:ae9:ebd5:: with SMTP id b204mr21648661qkg.183.1628018760445;
        Tue, 03 Aug 2021 12:26:00 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id i62sm8509567qke.110.2021.08.03.12.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 12:25:59 -0700 (PDT)
Date:   Tue, 3 Aug 2021 15:25:58 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/7] KVM: Allow to have arch-specific per-vm debugfs
 files
Message-ID: <YQmYRmidtS1XAydf@t490s>
References: <20210730220455.26054-1-peterx@redhat.com>
 <20210730220455.26054-2-peterx@redhat.com>
 <YQklR580FbVSiVz6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YQklR580FbVSiVz6@kroah.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021 at 01:15:19PM +0200, Greg KH wrote:
> > +/*
> > + * Called after per-vm debugfs created.  When called kvm->debugfs_dentry should
> > + * be setup already, so we can create arch-specific debugfs entries under it.
> > + * Cleanup should be automatic done in kvm_destroy_vm_debugfs() recursively, so
> > + * a per-arch destroy interface is not needed.
> > + */
> > +int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
> 
> This should be a void function, nothing should matter if creating
> debugfs files succeeds or not.
> 
> As proof, your one implementation always returned 0 :)

Right. :)

But we do have code that prepares for a failure on debugfs creations, please
have a look at kvm_create_vm_debugfs().  So I kept that for per-arch hook.

The existing x86 one should not fail, but it's a hope that we can convert some
other arch's existing debugfs code into per-arch hook like what we did with x86
here.  I didn't check again (please refer to the cover letter; we do have some
of those), but it's still easier to still allow per-arch hook to fail the vm
creation just like what we have for kvm_create_vm_debugfs().

PS: It makes sense to me to fail vm creation if 99% of those debugfs creation
failures are about -ENOMEM; e.g. early failure sounds better than failing right
after VM booted.

Meanwhile, I never expected to receive comments from you; thanks for having a
look!

-- 
Peter Xu

