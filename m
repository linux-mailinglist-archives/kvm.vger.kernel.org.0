Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D404B293717
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 10:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392154AbgJTIto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 04:49:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389465AbgJTIto (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 04:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603183782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Yge5XZ1kJndyKXSjT5PcbgRRLsIiYT+p8n0M0YIBn0=;
        b=YdSkL+yeEui5fc7w1jdqFmEHDR3Yk9bXSi38DUf+kAWWKW/zEw4PohaT2cURhhf5NTFAyr
        UdD9CdGkTzYtRDdPS69rCWlx0eOSiT9jkd6ffG0TSULEWmuwPlsTRHyyLBWcSx1UhhHnNn
        q/6kBUt/WxsQhrbAjeaO+XAGqUxmQ00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-mhpnnwHqORaUZej_zqSmyg-1; Tue, 20 Oct 2020 04:49:40 -0400
X-MC-Unique: mhpnnwHqORaUZej_zqSmyg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1FDA1009E2E;
        Tue, 20 Oct 2020 08:49:39 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.101])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 468F610023A5;
        Tue, 20 Oct 2020 08:49:38 +0000 (UTC)
Date:   Tue, 20 Oct 2020 10:49:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for
 apic test
Message-ID: <20201020084935.ltaitsuz45fr3wnm@kamzik.brq.redhat.com>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
 <20201015163539.GA27813@linux.intel.com>
 <1b9e716f-fb13-9ea3-0895-0da0f9e9e163@redhat.com>
 <20201016174044.eg72aordkchdr5l2@kamzik.brq.redhat.com>
 <1e37df99-2d5c-be4c-4f42-1534f6164982@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e37df99-2d5c-be4c-4f42-1534f6164982@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 07:53:49AM +0200, Thomas Huth wrote:
> On 16/10/2020 19.40, Andrew Jones wrote:
> > On Fri, Oct 16, 2020 at 07:02:57PM +0200, Paolo Bonzini wrote:
> >> On 15/10/20 18:35, Sean Christopherson wrote:
> >>> The port80 test in particular is an absolute waste of time.
> >>>
> >>
> >> True, OTOH it was meant as a benchmark.  I think we can just delete it
> >> or move it to vmexit.
> >>
> > 
> > If you want to keep the code, but only run it manually sometimes,
> > then you can mark the test as nodefault.
> 
> Please let's avoid that. Code that does not get run by default tends to
> bitrot. I suggest to decrease the amount of loops by default, and if
> somebody still wants to run this as a kind of benchmark, maybe the amount of
> loops could be made configurable? (i.e. so that you could control it via an
> argv[] parameter?)
>

I think both make sense. Making the number of loops variable is a good
idea in order to keep the test running in CI in a reasonable amount of
time (the timeout can also be adjusted by the CI runner, of course). Also,
marking the test as nodefault makes sense if nobody really cares about
the output unless they're specifically doing some benchmarking. Nothing
stops travis or other CI from running nodefault tests, they just have to
be explicitly requested.

Thanks,
drew 

