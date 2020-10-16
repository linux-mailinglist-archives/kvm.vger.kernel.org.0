Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA8C290AEC
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390160AbgJPRkx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 13:40:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389037AbgJPRkx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Oct 2020 13:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602870052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E9We4ofxk90FZ0n2hOtEtGQcXSyyMpe02YENXayxsJo=;
        b=HlEW07iM4x1hXGJVQLbMjBkgdt0fh0Jsuma6er4N0PGtOEMnriUrXVb/tQToOF3K+jKskZ
        6m5l+DHVqNVynQXUerwbLHEbBhu1Pil/t/2MuyCYg2bHeePb/ATNgy24xnETn/sBMkNPcM
        Qn+oMo994MUOGqfzNirI04qXrxci+4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-_UvAG6Z6OcOgZyqL6irZQA-1; Fri, 16 Oct 2020 13:40:50 -0400
X-MC-Unique: _UvAG6Z6OcOgZyqL6irZQA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76415876ECF;
        Fri, 16 Oct 2020 17:40:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD7C073662;
        Fri, 16 Oct 2020 17:40:47 +0000 (UTC)
Date:   Fri, 16 Oct 2020 19:40:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for
 apic test
Message-ID: <20201016174044.eg72aordkchdr5l2@kamzik.brq.redhat.com>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
 <20201015163539.GA27813@linux.intel.com>
 <1b9e716f-fb13-9ea3-0895-0da0f9e9e163@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b9e716f-fb13-9ea3-0895-0da0f9e9e163@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 16, 2020 at 07:02:57PM +0200, Paolo Bonzini wrote:
> On 15/10/20 18:35, Sean Christopherson wrote:
> > The port80 test in particular is an absolute waste of time.
> > 
> 
> True, OTOH it was meant as a benchmark.  I think we can just delete it
> or move it to vmexit.
>

If you want to keep the code, but only run it manually sometimes,
then you can mark the test as nodefault.

Thanks,
drew 

