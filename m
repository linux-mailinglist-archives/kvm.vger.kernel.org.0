Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52AFA1499
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 11:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfH2JWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 05:22:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfH2JWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 05:22:40 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F792307D91F;
        Thu, 29 Aug 2019 09:22:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B484B1001B05;
        Thu, 29 Aug 2019 09:22:36 +0000 (UTC)
Date:   Thu, 29 Aug 2019 11:22:33 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Remove duplicate guest mode handling
Message-ID: <20190829092233.si7kuqu6436ttiaz@kamzik.brq.redhat.com>
References: <20190827131015.21691-1-peterx@redhat.com>
 <20190827131015.21691-5-peterx@redhat.com>
 <20190828114613.a2rvpip45c3ywdnj@kamzik.brq.redhat.com>
 <20190829020935.GG8729@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829020935.GG8729@xz-x1>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 29 Aug 2019 09:22:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 10:09:35AM +0800, Peter Xu wrote:
> On Wed, Aug 28, 2019 at 01:46:13PM +0200, Andrew Jones wrote:
> 
> [...]
> 
> > > +unsigned int vm_get_page_size(struct kvm_vm *vm)
> > > +{
> > > +	return vm->page_size;
> > > +}
> > > +
> > > +unsigned int vm_get_page_shift(struct kvm_vm *vm)
> > > +{
> > > +	return vm->page_shift;
> > > +}
> > 
> > We could get by with just one of the above two, but whatever
> 
> Right... and imho if we export kvm_vm struct we don't even any
> helpers. :) But I didn't touch that.

yeah, I'm starting to wonder if there's much value in keeping the vm and
vcpu structures private. I've already had a couple cases where I wanted
to write a quick+dirty test that needed the vcpu_fd, so I cheated and
included the internal header to get to it.

Thanks,
drew

> 
> > > +
> > > +unsigned int vm_get_max_gfn(struct kvm_vm *vm)
> > > +{
> > > +	return vm->max_gfn;
> > > +}
> > > -- 
> > > 2.21.0
> > >
> > 
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> Thanks!
> 
> -- 
> Peter Xu
