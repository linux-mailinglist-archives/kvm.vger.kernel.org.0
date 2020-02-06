Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F268154F02
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgBFWkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:40:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58316 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726543AbgBFWkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581028847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W562CeQ2Rstu/7oSeTVLCjxMDoc+cA2kZj28QIDXVLU=;
        b=NGGcjWCFYcYH9Aqq6g7Oa4V/ASgJslDZreKKBtZPZlFFQbe7LvNFKSvsFccpFpsjkw5l2H
        9KH73tA+pXIF2Zy1Ni2ZfTe/27+DJVzh2TVoPZDBTYXrEFZ+PegZAWLMKjTjQhwiaRXTey
        J1EdG13sAF2G7b26nOHKZHz43UmzuI8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-hX5TmWvKP6q3RFGmAWv93g-1; Thu, 06 Feb 2020 17:40:46 -0500
X-MC-Unique: hX5TmWvKP6q3RFGmAWv93g-1
Received: by mail-qv1-f69.google.com with SMTP id dr18so6634qvb.14
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 14:40:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W562CeQ2Rstu/7oSeTVLCjxMDoc+cA2kZj28QIDXVLU=;
        b=aX7vWZmQZJIDg3lTC1/yBnjhr0FqEaEcPpX6GDHoJgMfb58kBii5Pz6hk9GQXMuwLW
         zXV/aS/g2NwK2AMZI9fPtMm9rkgGa1sUpM1Wm/m7PLTBg9Dz8jSi4QphrFbrt0/germG
         xcSVYSdp+v14tnThKn/T6z3HCcoJeXbbjolfKShCKyIHe8cgEKKYecz/sEkG3Y/SNdyW
         5ACHNNfe1GTkKHrHuRD6QlMm6BboMpMxhQNinmKFPs4rtAoSximtGMeraWYw02lXW4Ms
         A/xsYmR15QTxzgFNZpl+k44ushHwHbSTnrZ3KMqfgTdl1MFfUxQq+LZA/1js9Cu/zSEf
         HA0A==
X-Gm-Message-State: APjAAAVlWFejlkf/1hxfoa0rGbd2ccbblX+ny3vwsdvb+TIudqlHl7Er
        5vwr87V0qi4q7PkuYd9WZDioQjOVIy9TxsGFTFjUB28N721LnDcxe/404bad0qRE+boWDCJlox4
        qcL4DzSxBkRfm
X-Received: by 2002:a05:620a:7eb:: with SMTP id k11mr2404744qkk.486.1581028845854;
        Thu, 06 Feb 2020 14:40:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqz9H3jQJMccEXzYtFXays9K8+qBHpILOvSuY+IuWN7aXEfE94eIAwglwVCLCFzRPz0MIaA7CA==
X-Received: by 2002:a05:620a:7eb:: with SMTP id k11mr2404727qkk.486.1581028845629;
        Thu, 06 Feb 2020 14:40:45 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id h23sm369207qka.6.2020.02.06.14.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 14:40:44 -0800 (PST)
Date:   Thu, 6 Feb 2020 17:40:42 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, kevin.tian@intel.com, alex.williamson@redhat.com,
        dgilbert@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH 10/14] KVM: selftests: Use a single binary for
 dirty/clear log test
Message-ID: <20200206224042.GK700495@xz-x1>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
 <20200205025842.367575-7-peterx@redhat.com>
 <20200205092852.vjskgirqlnm5ebtv@kamzik.brq.redhat.com>
 <20200205154617.GA378317@xz-x1>
 <20200205171109.2a7ufrhiqowkqz6e@kamzik.brq.redhat.com>
 <20200205173939.GD378317@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205173939.GD378317@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 12:39:39PM -0500, Peter Xu wrote:
> On Wed, Feb 05, 2020 at 06:11:09PM +0100, Andrew Jones wrote:
> > On Wed, Feb 05, 2020 at 10:46:17AM -0500, Peter Xu wrote:
> > > On Wed, Feb 05, 2020 at 10:28:52AM +0100, Andrew Jones wrote:
> > > > On Tue, Feb 04, 2020 at 09:58:38PM -0500, Peter Xu wrote:
> > > > > Remove the clear_dirty_log test, instead merge it into the existing
> > > > > dirty_log_test.  It should be cleaner to use this single binary to do
> > > > > both tests, also it's a preparation for the upcoming dirty ring test.
> > > > > 
> > > > > The default test will still be the dirty_log test.  To run the clear
> > > > > dirty log test, we need to specify "-M clear-log".
> > > > 
> > > > How about keeping most of these changes, which nicely clean up the
> > > > #ifdefs, but also keeping the separate test, which I think is the
> > > > preferred way to organize and execute selftests. We can use argv[0]
> > > > to determine which path to take rather than a command line parameter.
> > > 
> > > Hi, Drew,
> > > 
> > > How about we just create a few selftest links that points to the same
> > > test binary in Makefile?  I'm fine with compiling it for mulitple
> > > binaries too, just in case the makefile trick could be even easier.
> > 
> > I think I prefer the binaries. That way they can be selectively moved
> > and run elsewhere, i.e. each test is a standalone test.
> 
> Sure, will do.

Or... Shall we still keep one binary, but by default run all the
supported logging mode in sequence in a single dirty_log_test?  Say,
run "./dirty_log_test" will run all supported tests one by one; run
"./dirty_log_test -M LOG_MODE" will only run specific mode.

With this patch it's fairly easy to achieve this too.

-- 
Peter Xu

