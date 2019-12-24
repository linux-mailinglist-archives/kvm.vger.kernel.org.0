Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D791712A2F6
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 16:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLXPY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 10:24:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbfLXPY2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Dec 2019 10:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577201066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ywK49erekGqxd3CUaRhTxMhJ8oeIv01btWZagZa8bg8=;
        b=a9JLJ+bYduFsApHgR1fk9iRvh6RIqXKjWk5+qIMwaxcFl4iS9cIpOHGeeVvD0aZfmcKC/x
        78p61U6LV5A9us6zY++P8kjEN5FLnjwpFj1h6ZKJZqNsHYhynk8gUdJPM8vu9av5uyQcat
        WWGymKbVsSiOQ3vYKHhS+1TMxTenTEY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-X8kkaLBkMLSy1dsyypkWdw-1; Tue, 24 Dec 2019 10:24:23 -0500
X-MC-Unique: X8kkaLBkMLSy1dsyypkWdw-1
Received: by mail-qt1-f199.google.com with SMTP id y7so13256335qto.8
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2019 07:24:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ywK49erekGqxd3CUaRhTxMhJ8oeIv01btWZagZa8bg8=;
        b=tV9hcWbse3efABdaWQkD4dGpE1fKD0qu0HxlEYKs5Bc75xOi/4gmjrktOigH5syKD6
         q4o4SkT+Za4cvEvfYDPqcazH0FO9OYEUDX1eA/lb0sl38aFGDP6eXFU1uvEKEJdrEntT
         LIIZitZ/G8Y5ccLNJGyaWN4orDY5XWfEgMMoAquFrYVL501V0IDAMW5qLtjochnFmf36
         pgNwGvAlr59kPChZFB+rCOCY8jRxRDoCog4cGKMZcnIqXXgxZB95giKxOA8xeFGEgB52
         8zu8Me+iymq6bJq0a/u0RiIn2fxJieVt7yY//a3ljI+pPkbjOkYMy3ZKfOVZLrThCiXi
         fL9w==
X-Gm-Message-State: APjAAAXHWEhsgcWARqOj0sD/uonZ444H1+Ti7nLw8IJcZcuOuHKxZWb3
        ceaT6/JOhj/S7LEX/K4S5XdHkbEASoQJHB/+ET3aUDgEi7iRYtbgQ10kVsVvuJzJekKAAxrDzW9
        /BzVMA/lV1APb
X-Received: by 2002:a0c:b515:: with SMTP id d21mr29202510qve.106.1577201063041;
        Tue, 24 Dec 2019 07:24:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqxROSsqGDowb78aAglNEiZ33GnO6TB2pNhWXqE4OuKHD3QbdllhHpK3icOUHHcvOCY9uvQPqQ==
X-Received: by 2002:a0c:b515:: with SMTP id d21mr29202468qve.106.1577201062364;
        Tue, 24 Dec 2019 07:24:22 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id n190sm7034896qke.90.2019.12.24.07.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 07:24:21 -0800 (PST)
Date:   Tue, 24 Dec 2019 10:24:20 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RESEND v2 15/17] KVM: selftests: Add dirty ring buffer
 test
Message-ID: <20191224152420.GB17176@xz-x1>
References: <20191221020445.60476-1-peterx@redhat.com>
 <20191221020445.60476-5-peterx@redhat.com>
 <b0dc3d30-7fa5-3896-6905-9b1cb51d8d6c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0dc3d30-7fa5-3896-6905-9b1cb51d8d6c@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 24, 2019 at 02:50:48PM +0800, Jason Wang wrote:
> 
> On 2019/12/21 上午10:04, Peter Xu wrote:
> > Add the initial dirty ring buffer test.
> > 
> > The current test implements the userspace dirty ring collection, by
> > only reaping the dirty ring when the ring is full.
> > 
> > So it's still running asynchronously like this:
> 
> 
> I guess you meant "synchronously" here.

Yes, definitely. :)

-- 
Peter Xu

