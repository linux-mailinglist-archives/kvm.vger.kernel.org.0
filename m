Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA71283EE
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfLTViJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:38:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727505AbfLTViJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 16:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576877887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DgH/TocIdbrujZ/WjTBKFFzHicEM2iW/+AB7POG9On8=;
        b=KXdg4XI9TdqMgyII9MPgBfrgPHfOYwTO/vhsdd+1OOKbl1cIeu8I7xHYusbOp3ErlPEJsz
        u2WkbYZC3PVs/Jr9s3+XXaL+n2kU2GuQcex0AXeE2qX2xjcjpwNudh8OF7MfliYXm+WBRO
        coUTe0stk37GWP26BAXGkfWZKcrPloE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-M4z1GvSaNZmqBPpVpOO0Rg-1; Fri, 20 Dec 2019 16:38:06 -0500
X-MC-Unique: M4z1GvSaNZmqBPpVpOO0Rg-1
Received: by mail-qt1-f197.google.com with SMTP id l25so6885344qtu.0
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:38:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DgH/TocIdbrujZ/WjTBKFFzHicEM2iW/+AB7POG9On8=;
        b=pyoeXOv9McvWe9CYONnty636l+kEG6sS1PawyTU9fYyuLS2WH8/jT+zNsQpP3IHxfF
         sBYU9RDqJHuGEmuK/VMV/8TE1jAe/l0WCanPe8z3vHdUjb8L7cybkBY+nTa+j9prMbrz
         j8t0qG5axq79stf7CrW7abTPF4egeYnfqiAeByATMoeAt5I4O8de64sd6dScPsTZUClX
         N9G+XAp/7Aat5k+LSShVVey1HVIx6/CvHVBECWbxW6LFd+Sq5hrK42iWfvFP/DMsth0o
         wWvEjBWd3N94KvLwp0Qe24dCykT3dR7Zwu2mTnI5msmlF6k0qmvOaLeK17pzoBTgMOCz
         AcgQ==
X-Gm-Message-State: APjAAAU2B7JMyfcI8w6O1TVp0YjZSZOmcq+ozMwCrw/WZH40+w+jxxdD
        toM90/fbnIFzGr22FJY3xj6J5V3Iiz0fiId8tORGzTC+aon4ul+b1yKNiwaSQ/sGW4r7SJ55qmp
        /AHyxiEeJayiG
X-Received: by 2002:ae9:d887:: with SMTP id u129mr9801515qkf.357.1576877886089;
        Fri, 20 Dec 2019 13:38:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqxeshcS8kRdmw06LPZnDTlyOsMQ3kMcPeJ2cQ7Zp4KmJbxpzBkgpKY/e1utdzrBp+XlaW8hkQ==
X-Received: by 2002:ae9:d887:: with SMTP id u129mr9801498qkf.357.1576877885812;
        Fri, 20 Dec 2019 13:38:05 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id l85sm3208162qke.103.2019.12.20.13.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:38:05 -0800 (PST)
Date:   Fri, 20 Dec 2019 16:38:03 -0500
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: Re: [PATCH v2 00/17] KVM: Dirty ring interface
Message-ID: <20191220213803.GA51391@xz-x1>
References: <20191220211634.51231-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191220211634.51231-1-peterx@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If you see three identical half-posted series which only contains
patches 00-09... I am very sorry for ruining your inbox...  I think my
mail server is not happy to continue sending the rest of the patches,
and I'll get this during sending the patch 10:

4.3.0 Temporary System Problem.  Try again later (10). d25sm3385231qtq.11 - gsmtp

So far I don't see what's wrong with patch 10, either.

I'll try to fix it up before I send 4th time (or anyone knows please
hint me)... Please ignore the previous three in-complete versions.

-- 
Peter Xu

