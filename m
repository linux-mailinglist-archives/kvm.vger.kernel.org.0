Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB0C17FFD0
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgCJOJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:09:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22764 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbgCJOJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 10:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583849367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=byWQY42UbKEvCBp8MZXn5MOeNLyHCCWS7iASAAIHrRc=;
        b=HheXlu1SVyi3nfmcJWM7USg9CMbR7wXPqNuSBv+Jsm0QeZNoVLyjYWyhfca4yI39Qr2OCY
        nsRWLKsYAD009t2bClX0PKQjlTTq3Xlt8kK9iPMmHBAUR3XLhdB+2/wWzdCcU33Ja25GWl
        fbuaYPnHe7zYGZdrserRPrcLBlnicNg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-ZgsY2IRLPsiyJwP5lmG3wA-1; Tue, 10 Mar 2020 10:09:26 -0400
X-MC-Unique: ZgsY2IRLPsiyJwP5lmG3wA-1
Received: by mail-qk1-f197.google.com with SMTP id m6so6425430qkm.2
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 07:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=byWQY42UbKEvCBp8MZXn5MOeNLyHCCWS7iASAAIHrRc=;
        b=STAjaTdGFNEHUhZxafeZq69dru2MemgbVdZzObq2q05tmUJAFdlHu2KnZtDSaSKhHw
         /lw9wY+epU3VPYY0yz++Kfzo4k7kU7rzNHXx2ypUd0NFxIpgoI+RskU6VNak6SSl5L6e
         RJBq8clPgpvY+F6EKFZrtREJYbdDCXCDLdMVrlXR5Y6+9w9IPhWXTRUa2jHydMLJm6+d
         qXjL1aaXJnyGroaIAtKGSkKaH78/4Dnxr1Z/oQj7/P8PDAaxy4kmQo+5gtHhkf6150cG
         l82Skybv2WZLIqIE0eznPo0VnX4QLAX7uTuhX+I92C1NbUBcRKvcxZrWn09u1HpB4NNQ
         EwNg==
X-Gm-Message-State: ANhLgQ0Il70f0CVZXrTeuQZTYBiAsSQCLFx8U1AO1PBfl0tZtqxAYoNW
        afyYTDpx8j7u1oLWVy2sIUm6TwiJDLNP4sp8CTVT0NPIwrjhS0zh5t2fzrOZ9rTCHlgOXYKMgdn
        KVl6Ow2fzQlts
X-Received: by 2002:a05:6214:1749:: with SMTP id dc9mr19418546qvb.236.1583849365650;
        Tue, 10 Mar 2020 07:09:25 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuselEllZdFmXTm+ij76DcuB/hAvX4mBLfQIVzSXmReeE0fULDXOqySrnGv9L/lJyNuHicsAw==
X-Received: by 2002:a05:6214:1749:: with SMTP id dc9mr19418482qvb.236.1583849365206;
        Tue, 10 Mar 2020 07:09:25 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id k25sm361047qtm.94.2020.03.10.07.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 07:09:24 -0700 (PDT)
Date:   Tue, 10 Mar 2020 10:09:21 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v5 05/14] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200310140921.GD326977@xz-x1>
References: <20200304174947.69595-6-peterx@redhat.com>
 <202003061911.MfG74mgX%lkp@intel.com>
 <20200309213554.GF4206@xz-x1>
 <20200310022931-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200310022931-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 02:31:55AM -0400, Michael S. Tsirkin wrote:
> On Mon, Mar 09, 2020 at 05:35:54PM -0400, Peter Xu wrote:
> > I'll probably also
> > move KVM_DIRTY_LOG_PAGE_OFFSET==0 definition to uapi/linux/kvm.h.
> 
> 
> IMHO KVM_DIRTY_LOG_PAGE_OFFSET is kind of pointless anyway - 
> we won't be able to move data around just by changing the
> uapi value since userspace isn't
> recompiled when kernel changes ...

Yes I think we can even drop this KVM_DIRTY_LOG_PAGE_OFFSET==0
definition.  IMHO it's only a matter of whether we would like to
directly reference this value in the common code (e.g., for kernel
virt/kvm_main.c) or we want quite a few of this instead:

#ifdef KVM_DIRTY_LOG_PAGE_OFFSET
..
#endif

I slightly prefer to not use lots of "#ifdef"s so I chose to make sure
it's defined.  However I've no strong opinion on this either. So I'm
open to change that if anyone insists with some reasons.

Thanks,

-- 
Peter Xu

