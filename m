Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913A01536D7
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgBERjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:39:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33523 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727079AbgBERjp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 12:39:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580924384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0fNPS1hanpsq/w/5iiZBGDmbbH5rMQFQ+Y5O2+vioc0=;
        b=UOXxLPeiGDz3ANKD41afj1gZzMJ+miFKIP8tSnugyDnU7THDrTZ4FMYUPw1IAxrkjGgwrP
        +9SJZn+J+3nVUtL1UcnjGO91u3QrYhGhnH4yw/bRONSTWn6SNNi4KC1Faa6TUK1bVuEf9D
        A0kZ5heiapKCmnyvV/rOKlIIxnApP/g=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-Yt9cbBMVOvut2LPOm6zbZw-1; Wed, 05 Feb 2020 12:39:43 -0500
X-MC-Unique: Yt9cbBMVOvut2LPOm6zbZw-1
Received: by mail-qt1-f198.google.com with SMTP id l25so1856978qtu.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 09:39:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0fNPS1hanpsq/w/5iiZBGDmbbH5rMQFQ+Y5O2+vioc0=;
        b=l1SlwHNqP9xQ6Pj/2pOUnNpC4h59jxEknz4x+FrDS8TFMVlJ9HfxPpkIHSrwXQw+sO
         TIhJRjBySLCeyu1UlnS+o0f7H/IUdAIVqmF+3RsqVP+012rmvQVg7+aiPOLzDqxFIdNG
         mcrXuYWG8EeW58Z6wXd3mPykIrnoOxttTMVK4LjRouX644RLevdeHb4LIB8BGtx38UEH
         ieICeY2nVLGTW/rBi2K3yp0OBsSf8zc69xI++z8laq0OdRpPP6DfiL09AWLdANyZ9d3s
         xcM4zueLCcBm+idmV4A3LXbaKhmrtSLBdqcD6TLWCiZA9FCH/C8Nnz05Spo5W+WelHjj
         D1xg==
X-Gm-Message-State: APjAAAVNR37uTmcm8xOhFJp9Io+2Lpf1gGxHJS8Wto5mhbG25hohwktK
        hJy6WhYhfNOpN7WGlYrM5IhXYIM1gq7nXPbyN/1sKtiu2n38hFDop+y1PozXN4CwXtM8YOqlA9v
        HDnop8YZshXQI
X-Received: by 2002:a37:6446:: with SMTP id y67mr34245787qkb.59.1580924382635;
        Wed, 05 Feb 2020 09:39:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCug0s4yHW7+CpM+1AQhzW0DehWH+eRA2t80BwS6FeOzFDkgUJOm/ll+l+SL20BiLzxHUwpw==
X-Received: by 2002:a37:6446:: with SMTP id y67mr34245762qkb.59.1580924382403;
        Wed, 05 Feb 2020 09:39:42 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id o7sm139946qkd.119.2020.02.05.09.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 09:39:41 -0800 (PST)
Date:   Wed, 5 Feb 2020 12:39:39 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, kevin.tian@intel.com, alex.williamson@redhat.com,
        dgilbert@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH 10/14] KVM: selftests: Use a single binary for
 dirty/clear log test
Message-ID: <20200205173939.GD378317@xz-x1>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
 <20200205025842.367575-7-peterx@redhat.com>
 <20200205092852.vjskgirqlnm5ebtv@kamzik.brq.redhat.com>
 <20200205154617.GA378317@xz-x1>
 <20200205171109.2a7ufrhiqowkqz6e@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205171109.2a7ufrhiqowkqz6e@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 06:11:09PM +0100, Andrew Jones wrote:
> On Wed, Feb 05, 2020 at 10:46:17AM -0500, Peter Xu wrote:
> > On Wed, Feb 05, 2020 at 10:28:52AM +0100, Andrew Jones wrote:
> > > On Tue, Feb 04, 2020 at 09:58:38PM -0500, Peter Xu wrote:
> > > > Remove the clear_dirty_log test, instead merge it into the existing
> > > > dirty_log_test.  It should be cleaner to use this single binary to do
> > > > both tests, also it's a preparation for the upcoming dirty ring test.
> > > > 
> > > > The default test will still be the dirty_log test.  To run the clear
> > > > dirty log test, we need to specify "-M clear-log".
> > > 
> > > How about keeping most of these changes, which nicely clean up the
> > > #ifdefs, but also keeping the separate test, which I think is the
> > > preferred way to organize and execute selftests. We can use argv[0]
> > > to determine which path to take rather than a command line parameter.
> > 
> > Hi, Drew,
> > 
> > How about we just create a few selftest links that points to the same
> > test binary in Makefile?  I'm fine with compiling it for mulitple
> > binaries too, just in case the makefile trick could be even easier.
> 
> I think I prefer the binaries. That way they can be selectively moved
> and run elsewhere, i.e. each test is a standalone test.

Sure, will do.

-- 
Peter Xu

