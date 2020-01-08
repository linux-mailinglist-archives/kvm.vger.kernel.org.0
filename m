Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538ED134C40
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgAHT76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 14:59:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29667 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbgAHT76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 14:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578513597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lrH+CvY+umiABT8oEZ0qBtd1gDpx5+wmHlz5SzS8p+g=;
        b=BjWCO7+GsLPfyuBp5F8R1bFOYwX2xyDJTsOtfDRYIdNy8yMguZKcgZEO1KnWAbk/LiiRP4
        k23G0TstLK7i9aDIu5RBHXdHpaGMAuiOdOAEvA1BwnRoHJEqXbz9KCQQPkqB5s5YQTjOa6
        WJFE/EExQDbdJn3S3KzOIM0PFKRkfTs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-pNU3NPKjM5y4hZzjUPpcPw-1; Wed, 08 Jan 2020 14:59:56 -0500
X-MC-Unique: pNU3NPKjM5y4hZzjUPpcPw-1
Received: by mail-qk1-f199.google.com with SMTP id 143so2630277qkg.12
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:59:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lrH+CvY+umiABT8oEZ0qBtd1gDpx5+wmHlz5SzS8p+g=;
        b=dQUWZS4pHzT02HsecsN/ZcZvaa7yTHw54GUu/x3Sidh05ZKFUz6EBsu2urhzeb2hRU
         wm1DM4S13jk0t3sm0rAIrp3gVLjdQp3ixOauJIO/FYFplaficuJOeJHNOO14w224LCBE
         U5Tpuv9olVpNVrNLQzmamDw/VPwSrVN2n3CrD94jQe72stGHXeTsTvk8XU0PAz9zk2eh
         ixAsi1cUsgAN4DDI9sRRmGwjP/Sw98SxkcDt/Urz6R1RgL3z8KZTKCmEycWYvaIMqH/b
         zMGPnqgWtIc33R5X6gegrsqMARwUsAuZix9OpZIr0BJvWTrg2SyNZfJ2aPJ6pV9HX80h
         eg4A==
X-Gm-Message-State: APjAAAWcKJ5p7UT84QqpTHRlGPiiA0wjABf6fSN9dhU+Y9dc5EM5P6Tn
        AoVPb+xaGprbKbQ2r2e4I714zeas5RgSsT6rXvaK98MENk+/cOxdsS8oo/gYEn6KnZFiqoYmupf
        +2piBTa/1uUHd
X-Received: by 2002:ac8:4513:: with SMTP id q19mr5046112qtn.253.1578513595782;
        Wed, 08 Jan 2020 11:59:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqydEHy1yoL7GzWNo5dB4mqtpMIXjcNPaxhKor9S4La4aC0MoUtLA3yz1z9FpFnruD55s/uIjA==
X-Received: by 2002:ac8:4513:: with SMTP id q19mr5046098qtn.253.1578513595594;
        Wed, 08 Jan 2020 11:59:55 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id r44sm2206424qta.26.2020.01.08.11.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 11:59:54 -0800 (PST)
Date:   Wed, 8 Jan 2020 14:59:53 -0500
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
Message-ID: <20200108195953.GG7096@xz-x1>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-9-peterx@redhat.com>
 <20200108155210.GA7096@xz-x1>
 <9f7582b1-cfba-d096-2216-c5b06edc6ca9@redhat.com>
 <20200108190639.GE7096@xz-x1>
 <03e0cc7c-f47b-bdfa-8266-c77dc0627096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <03e0cc7c-f47b-bdfa-8266-c77dc0627096@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 08, 2020 at 08:44:32PM +0100, Paolo Bonzini wrote:
> On 08/01/20 20:06, Peter Xu wrote:
> >> The kvmgt patches were posted, you could just include them in your next
> >> series and clean everything up.  You can get them at
> >> https://patchwork.kernel.org/cover/11316219/.
> > Good to know!
> > 
> > Maybe I'll simply drop all the redundants in the dirty ring series
> > assuming it's there?  Since these patchsets should not overlap with
> > each other (so looks more like an ordering constraints for merging).
> 
> Just include the patches, we'll make sure to get an ACK from Alex.

Sure.  I can even wait for some more days until that consolidates
(just in case we need to change back and forth for this series).

-- 
Peter Xu

