Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A935153589
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 17:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgBEQqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 11:46:30 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727330AbgBEQq3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 11:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580921188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M7hFAEYpi25OZAJ3FpIbfqeOjel9eL1CL20O4yOxrIg=;
        b=eC6umjaOAuSLHKW/0T05I9/ZlD4Qr/5KrqK4m+e8ttU929LazmbtfFnv8g8QyUszZ/PS7v
        XJ90n8sBSZ94odsghmcpsHYQ+265cbTor2DRM49xGqIbhcCzpJc+5MGvJ42MlAfMRRqwg6
        MM20iGBVT0+z28d1q4tIE9ORW+0P6yQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-rSCeN5YANqiClBwDJnSnJg-1; Wed, 05 Feb 2020 11:46:22 -0500
X-MC-Unique: rSCeN5YANqiClBwDJnSnJg-1
Received: by mail-qv1-f70.google.com with SMTP id e10so1816426qvq.18
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 08:46:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M7hFAEYpi25OZAJ3FpIbfqeOjel9eL1CL20O4yOxrIg=;
        b=MUd8KojTo90Lj1I4ql8Ab4rbdMEEagvgiPMZt1d/l37eGn9oSVszQKXy9AGu3JyMwM
         FbWsoI2jpFUl9RhcJ7SKHNSUBUoodQyBptBoa5HVzifnJaTMCZgCQKQqayOc08qiYeTb
         sAuk0uBYNCD5xDBmo1pM2SB5AJbdIJYVI2NrCTg/V7SOUlWhhcZ5yUWIcMAiXn+NZnbz
         I+dqkxcXOQCy8q6LAzgUXmhfcMAIc7gJA9ug7BpprFo1KJlvoeFJ4d2Al2T3Iqjgjkj3
         np4kDfeAi3iCWFM0wr3S8nxy10vYxoZ9URqKKHsQa9e6J9R3EhomW/knNHr+6nAuP9NA
         TEVg==
X-Gm-Message-State: APjAAAVPyxFCKUsxvYYdJpPOXPvPEOMmhcE6uQmmOH78fgLjaGDhSzse
        Zn1+u+aujzQOFGXBTpdjOO//seCsOpACcKFjEP4Tc3ikMWzIUnJoCR+riaIH2yC/ln02isy09NR
        tzw5ZcI2tM3Is
X-Received: by 2002:ad4:498d:: with SMTP id t13mr31655719qvx.58.1580921182150;
        Wed, 05 Feb 2020 08:46:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqwxzevODXBhDfMMTQorefgWoeFyo9tbv71If2hqARRkA5O2BGwW+pwMmPwOC5DMC/NssdMI3g==
X-Received: by 2002:ad4:498d:: with SMTP id t13mr31655694qvx.58.1580921181856;
        Wed, 05 Feb 2020 08:46:21 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id q5sm91326qkf.14.2020.02.05.08.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 08:46:21 -0800 (PST)
Date:   Wed, 5 Feb 2020 11:46:19 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/3] kvm: mmu: Replace unsigned with unsigned int for PTE
 access
Message-ID: <20200205164619.GC378317@xz-x1>
References: <20200203230911.39755-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200203230911.39755-1-bgardon@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 03, 2020 at 03:09:09PM -0800, Ben Gardon wrote:
> There are several functions which pass an access permission mask for
> SPTEs as an unsigned. This works, but checkpatch complains about it.
> Switch the occurrences of unsigned to unsigned int to satisfy checkpatch.
> 
> No functional change expected.
> 
> Tested by running kvm-unit-tests on an Intel Haswell machine. This
> commit introduced no new failures.
> 
> This commit can be viewed in Gerrit at:
> 	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2358
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

