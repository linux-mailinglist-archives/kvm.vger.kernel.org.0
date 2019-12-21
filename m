Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28444128695
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLUCLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:11:11 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29912 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726462AbfLUCLK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 21:11:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576894268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ms7ZM3YmtvF2wzYl19JuRjEHViRq+4SWhLPmVosAqLs=;
        b=H4767h8pOUiblRHgdYB79WgvoLbx/mvqks1FbFVPdCsJZq9Sz5826c/sagpnc8Zkrd1bw/
        CWGO8IOPLTcPRp99ts1eIdyGWjnBPpaboetl9XYHKzOwt0+lXgT02Oughnn8w1o6ZJlPrp
        1LhM2OIPNwjBx7T1qEhMVW7o8DtcDkI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329--5Hk5RWyMjWUfPx0s2DLVg-1; Fri, 20 Dec 2019 21:11:07 -0500
X-MC-Unique: -5Hk5RWyMjWUfPx0s2DLVg-1
Received: by mail-qk1-f197.google.com with SMTP id 65so3191514qkl.23
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 18:11:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ms7ZM3YmtvF2wzYl19JuRjEHViRq+4SWhLPmVosAqLs=;
        b=aXdkA2wmEZIAduwpFopKeMt/yb5EryF7TWZ50d33JDY9EvPNeG+K0GlVOPt7p/5GD0
         jx4l3NXpKqG7ttGpz8qElC/3UZBjRIi2Kg08dbzHLI8Ib07Jl8K9eJ5JxDiWkRIFkV+q
         CrkPOsb2ceNKwhAMMPKN5ZygM4QZk4a/bUg2F9HjTtF7fbCQ+abrNKN1s5VLKRibzltA
         4/SgIpwXpPBRIpClTm0xodwAKgefVKKwjmTOQBM1AccEniFpvPjcdb6YvxfHo+oN4+IZ
         FOoMw7DzJ6nM8TihzfrHEyWyGXeEmZ1mm+9bKyRqIFd7Ecyk3zJjNDvb8LvjYG6rNsJv
         uekg==
X-Gm-Message-State: APjAAAXt3Vi6fxXR9WAEsqg2C9xewVyiiXKNA/f5oVRiXOvg2Tx7WBLx
        gprkgWTyHC39D0kgh86ub2VJDfYhsmss3wAUVVHsvRk6I0IOAE1Dzw6rVqLvmaPN0iw7umLMwTx
        du5ZSOP88lnDE
X-Received: by 2002:ac8:460a:: with SMTP id p10mr13726111qtn.98.1576894267342;
        Fri, 20 Dec 2019 18:11:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqzIQ2ze+nInYWvxAbBHNFji24kDf074ME1rfeNCFt0Tp3IQF5g4xn3qTCSfad+ysEPdCVNd1w==
X-Received: by 2002:ac8:460a:: with SMTP id p10mr13726102qtn.98.1576894267155;
        Fri, 20 Dec 2019 18:11:07 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id v5sm3799321qth.70.2019.12.20.18.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 18:11:06 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:11:04 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: Re: [PATCH v2 00/17] KVM: Dirty ring interface
Message-ID: <20191221021104.GA59330@xz-x1>
References: <20191220211634.51231-1-peterx@redhat.com>
 <20191220213803.GA51391@xz-x1>
 <20191220214354.GE20453@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191220214354.GE20453@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 01:43:54PM -0800, Sean Christopherson wrote:
> On Fri, Dec 20, 2019 at 04:38:03PM -0500, Peter Xu wrote:
> > If you see three identical half-posted series which only contains
> > patches 00-09... I am very sorry for ruining your inbox...  I think my
> > mail server is not happy to continue sending the rest of the patches,
> > and I'll get this during sending the patch 10:
> > 
> > 4.3.0 Temporary System Problem.  Try again later (10). d25sm3385231qtq.11 - gsmtp
> > 
> > So far I don't see what's wrong with patch 10, either.
> > 
> > I'll try to fix it up before I send 4th time (or anyone knows please
> > hint me)... Please ignore the previous three in-complete versions.
> 
> Please add RESEND in the subject when resending an idential patch (set),
> it gives recipients a heads up that the two (or four :-)) sets are the
> same, e.g. previous versions can be ignored if he/she received both the
> original and RESEND version(s).
> 
>   [PATCH RESEND v2 00/17] KVM: Dirty ring interface

Thanks Sean, new version sent.  Just in case if anyone read the old
versions: they have exactly the same content with the RESEND series.
I still resent the first 10 emails just to make things simple.

-- 
Peter Xu

