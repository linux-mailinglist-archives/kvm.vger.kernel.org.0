Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF7A134B3C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 20:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgAHTGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 14:06:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35431 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727328AbgAHTGr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 14:06:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578510406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aIsPQkefvKbs8Mx+H3weFs4lkNWqI+3u39gZ7NmRyAU=;
        b=g7Qm/9bs2LNOvUWwM2fDwBfZMkkax0plohFI3lTxaVkqJDAtesRTQr9UpEo47O6+C1LUJK
        tPq/iVulWRCYwksLMc4+a61l2m92R7SKuzOvjKe47R7vTu2kmdNC6qSH+/Vrzk7cu0y2fS
        Oe7xblV/oEd2YsoMy1f21cKL6s8HVN8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-Q6nrZXvWO-O-JqhaMQCNvg-1; Wed, 08 Jan 2020 14:06:41 -0500
X-MC-Unique: Q6nrZXvWO-O-JqhaMQCNvg-1
Received: by mail-qv1-f70.google.com with SMTP id g15so2546741qvk.11
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:06:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aIsPQkefvKbs8Mx+H3weFs4lkNWqI+3u39gZ7NmRyAU=;
        b=bJdQYuTZ3MHDo2dVl1Z8FIrknbDt1LqOaFUvKE3fqv3OzfyCxNy1j0jURMSlJqzZ87
         gn46h+rHQAIBJt8lbFEv//T7OpnN0wwY6hP4mblFxxc2/6M8X971JqBLRPa9Pmq4znel
         BsSgDu/MwqYJkJ2tfM1pXePvH5746XmVDzKM4pTLjrRlx+yICFVPrT3AU65bVsbTcK9R
         IcVxZ+XnZhZ+zWKfYE1CXRcGnu5GznC2Vp093xXkSAqm99sZYIlJSjZNRw7t4DUVGAeE
         71LrPMPNx7bd1bOjZSBv4b62lIzqMDOgV6ILioj192pUkWl0pWH8S0QNbkOmK/s+dB1Z
         mZ/Q==
X-Gm-Message-State: APjAAAUqg7W+D/macU7eSyZBZO1eGPY4aOGom7iPNGY/7x6fm54IPakv
        GUxgdEvMddduJAlHygMvEc+Vr6rDv3lNfoHqlXiP+YSfQ1ifi1MX1SJFm43nNuFPNqtwJftcFY4
        Rnp67kkZVG5Ms
X-Received: by 2002:ac8:2c7d:: with SMTP id e58mr4971742qta.196.1578510401489;
        Wed, 08 Jan 2020 11:06:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQzt09Rs7mLLYG5FgB+AsfdPFCtd6ICoe8Ea8YxVYAtfHSxrWhnYkBa0bOXlLt5LtDkKxP0g==
X-Received: by 2002:ac8:2c7d:: with SMTP id e58mr4971717qta.196.1578510401266;
        Wed, 08 Jan 2020 11:06:41 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id 65sm2020756qtf.95.2020.01.08.11.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 11:06:40 -0800 (PST)
Date:   Wed, 8 Jan 2020 14:06:39 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH RESEND v2 08/17] KVM: X86: Implement ring-based dirty
 memory tracking
Message-ID: <20200108190639.GE7096@xz-x1>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-9-peterx@redhat.com>
 <20200108155210.GA7096@xz-x1>
 <9f7582b1-cfba-d096-2216-c5b06edc6ca9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9f7582b1-cfba-d096-2216-c5b06edc6ca9@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 08, 2020 at 06:41:06PM +0100, Paolo Bonzini wrote:
> On 08/01/20 16:52, Peter Xu wrote:
> > here, which is still a bit tricky to makeup the kvmgt issue.
> > 
> > Now we still have the waitqueue but it'll only be used for
> > no-vcpu-context dirtyings, so:
> > 
> > - For no-vcpu-context: thread could wait in the waitqueue if it makes
> >   vcpu0's ring soft-full (note, previously it was hard-full, so here
> >   we make it easier to wait so we make sure )
> > 
> > - For with-vcpu-context: we should never wait, guaranteed by the fact
> >   that KVM_RUN will return now if soft-full for that vcpu ring, and
> >   above waitqueue will make sure even vcpu0's waitqueue won't be
> >   filled up by kvmgt
> > 
> > Again this is still a workaround for kvmgt and I think it should not
> > be needed after the refactoring.  It's just a way to not depend on
> > that work so this should work even with current kvmgt.
> 
> The kvmgt patches were posted, you could just include them in your next
> series and clean everything up.  You can get them at
> https://patchwork.kernel.org/cover/11316219/.

Good to know!

Maybe I'll simply drop all the redundants in the dirty ring series
assuming it's there?  Since these patchsets should not overlap with
each other (so looks more like an ordering constraints for merging).

Thanks,

-- 
Peter Xu

