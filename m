Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2AF1AE56D
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 21:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgDQTF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 15:05:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44299 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727775AbgDQTF7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 15:05:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587150358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aexqVQ7wQQYqij2tXK706tjApKpXd1pq/NygCDJJnFw=;
        b=CjH6Xkpp8diOEF+g4dDjcgQWbypn+TixbqYbwxLjeUbSQcKPW51ElkA2UGuqUqkWfqocxp
        +ATSw7hlvPqhayt53nQdO0km7/01dJlrq1YR3KG+67EEk4dsokUBJ9+9OV8FZnh8VNUpZW
        ltovXvMUMonMnrLEvi1tHDfzaFKLff0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-whr1BzM-NMisrO54zjRqBg-1; Fri, 17 Apr 2020 15:05:56 -0400
X-MC-Unique: whr1BzM-NMisrO54zjRqBg-1
Received: by mail-qk1-f198.google.com with SMTP id f11so2903409qkk.16
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 12:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aexqVQ7wQQYqij2tXK706tjApKpXd1pq/NygCDJJnFw=;
        b=mxgzExilapTU2cQHo4WKUMHBWgBGSVx/CP+b1/NaZLL/W6yBh+4Q2KhTPr6tT5jzjD
         hQ4Zy/tPC5ZIU1gMUjsLb/Jvm6NWo7ZJrAy+Y8t9XLzNnYj2Vie3kt93LLRt6GEFrAqO
         Eq1GHmxzG8WwAqBZ898r5b1UDHfShY87IVLXvlIThDAGW4ZmuUHKJQVLRi5X2SaqHKWj
         gjzxnSZ/8Y709XDk9+jLxfD1WDYEvSmHfYzxnRr3153vPKaC54ZRaevceUFvhDI+Ycos
         TQU43OiMFN4a/WrHRaTtl8cnrTzjs3537lhXMvfc5SS1Rss2eKE43w05pw5fZcLSAmV5
         tu2g==
X-Gm-Message-State: AGi0PuZOGW7o0dSqNijrm3a9i7KEguFt8k9LVUyuaCd0GsgCgm9J25Ec
        10SPOdEyxh1JNUEIR83DyxHq7TdAYN1171xQCZo1tCGRstc50LBAyJP/ZQUcfz+KAy+7W3Ln/y8
        ps1YSijVNMrB6
X-Received: by 2002:ac8:6642:: with SMTP id j2mr4466575qtp.311.1587150355608;
        Fri, 17 Apr 2020 12:05:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypJK47cUAW8UhtqP+6vEGJNWgIFR2kpnvCsa+tpq1Wupmn2CfkAR46gEVGsdrfyTnQkPGXbbBw==
X-Received: by 2002:ac8:6642:: with SMTP id j2mr4466545qtp.311.1587150355360;
        Fri, 17 Apr 2020 12:05:55 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id y21sm17199104qka.37.2020.04.17.12.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 12:05:54 -0700 (PDT)
Date:   Fri, 17 Apr 2020 15:05:53 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/3] KVM: x86: move nested-related kvm_x86_ops to a
 separate struct
Message-ID: <20200417190553.GI287932@xz-x1>
References: <20200417164413.71885-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200417164413.71885-1-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 12:44:10PM -0400, Paolo Bonzini wrote:
> While this reintroduces some pointer chasing that was removed in
> afaf0b2f9b80 ("KVM: x86: Copy kvm_x86_ops by value to eliminate layer
> of indirection", 2020-03-31), the cost is small compared to retpolines
> and anyway most of the callbacks are not even remotely on a fastpath.
> In fact, only check_nested_events should be called during normal VM
> runtime.  When static calls are merged into Linux my plan is to use them
> instead of callbacks, and that will finally make things fast again by
> removing the retpolines.

Paolo,

Just out of curiousity: is there an explicit reason to not copy the
whole kvm_x86_nested_ops but use pointers (since after all we just
reworked kvm_x86_ops)?

Thanks,

-- 
Peter Xu

