Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40010153482
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBEPqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:46:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60624 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726748AbgBEPqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580917583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FENJb9w+KXU/1rciBA47jt6l+2Cs5jKyIe0GXYrVUug=;
        b=gHsL8/TpufKFaX5Fk3pp/bx1jbBfhlBCUznoiiA/l/h+3ttGo2fsZ3eERcNjxG7f+Jik8B
        vrCZ0mLAeP/ftiZAhQHJ5Af0Xh+b4eV7E5ji7ShFlZjC/5BgkRodD9DZuYUccQYJ1pvQ4E
        xkSAi6BKMVBu8LncEGAo+mjDuy49A6w=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-0hhoOYxEOwKsnbgDGd_Ghg-1; Wed, 05 Feb 2020 10:46:21 -0500
X-MC-Unique: 0hhoOYxEOwKsnbgDGd_Ghg-1
Received: by mail-qv1-f72.google.com with SMTP id k2so1694202qvu.22
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FENJb9w+KXU/1rciBA47jt6l+2Cs5jKyIe0GXYrVUug=;
        b=bsZyU731ZNU5X58LQ4SMIalPdZVzcd/G75V6anLFcqphcTIwsd5FHiONeYGurXnS4i
         uxAmqW5eKc0Y+gSwq2uhrBIVtwv5BtoMzbO9Bh0Z1jxHDd72gaCzD04sWoYTJxU0tIoQ
         +Fz6wYtgpGmTS4M12gFXqqq/uyV8iMO00N7XbX7twSL7L/n6vFi/UX25qzrUG0FfB13b
         1YnWY9e/ohF+SjQKc+oTr9UHIlJhroy2PMu0HY7gNz8zfTx2GzZ5gP3pZ8gQPcPAwkT7
         RLMFmdjEOmf3g3emuOnNS66t5rn9ecYXYTL7PfmJos0FRzRWMCyepow/R7RK8aulE03Y
         8GJg==
X-Gm-Message-State: APjAAAWrGKl2ZwZro6Is4rq/yL20QyrOyDjpNzWNe8r50XXHHxDsHRyC
        RXfzUSr45wfdgwe6c6lADeuMp0kMMB0/vxNkstNPcVdj3yCdJbXX7eDk4Misc5tbc7loFLJOcwi
        xi7lPzb83ALKh
X-Received: by 2002:ac8:2ffa:: with SMTP id m55mr34039439qta.189.1580917581050;
        Wed, 05 Feb 2020 07:46:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqzx4Pfhud7vNCt+/3W0RLYr4p1bUCrbt1Ji+vkPYYmsGcIGHC/CXq7YNni1H+s1Bh96VdATBw==
X-Received: by 2002:ac8:2ffa:: with SMTP id m55mr34039412qta.189.1580917580750;
        Wed, 05 Feb 2020 07:46:20 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id k5sm995810qkk.117.2020.02.05.07.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 07:46:19 -0800 (PST)
Date:   Wed, 5 Feb 2020 10:46:17 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, kevin.tian@intel.com, alex.williamson@redhat.com,
        dgilbert@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH 10/14] KVM: selftests: Use a single binary for
 dirty/clear log test
Message-ID: <20200205154617.GA378317@xz-x1>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
 <20200205025842.367575-7-peterx@redhat.com>
 <20200205092852.vjskgirqlnm5ebtv@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205092852.vjskgirqlnm5ebtv@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 10:28:52AM +0100, Andrew Jones wrote:
> On Tue, Feb 04, 2020 at 09:58:38PM -0500, Peter Xu wrote:
> > Remove the clear_dirty_log test, instead merge it into the existing
> > dirty_log_test.  It should be cleaner to use this single binary to do
> > both tests, also it's a preparation for the upcoming dirty ring test.
> > 
> > The default test will still be the dirty_log test.  To run the clear
> > dirty log test, we need to specify "-M clear-log".
> 
> How about keeping most of these changes, which nicely clean up the
> #ifdefs, but also keeping the separate test, which I think is the
> preferred way to organize and execute selftests. We can use argv[0]
> to determine which path to take rather than a command line parameter.

Hi, Drew,

How about we just create a few selftest links that points to the same
test binary in Makefile?  I'm fine with compiling it for mulitple
binaries too, just in case the makefile trick could be even easier.

Thanks,

-- 
Peter Xu

