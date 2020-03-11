Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52000182122
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 19:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbgCKSr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 14:47:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35216 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730893AbgCKSr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 14:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583952446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Irye0rFaDzdP42Inlr4cQrTj7L1YCDCLX9nYEZrBcr8=;
        b=Z6srpiWz1hNEhd/IZy29bOTbnmqI3yUQW/sm4feQZbNLVtE6msKlbscRSsCy/keM98mpGd
        AexHA/Ku2OjT4Iv+dBKNU8J1hsjLvLetluu+5TiB+ls5J/edt5R3mDALwy6widq71kgT6O
        rwF2Go94E1xLis8KiWkdJE72IO9s4g8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-5e2e3V1UMgaulAWdT5wBzA-1; Wed, 11 Mar 2020 14:47:22 -0400
X-MC-Unique: 5e2e3V1UMgaulAWdT5wBzA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55719107ACC4;
        Wed, 11 Mar 2020 18:47:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-206-80.brq.redhat.com [10.40.206.80])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3E5E92D34;
        Wed, 11 Mar 2020 18:47:07 +0000 (UTC)
Date:   Wed, 11 Mar 2020 19:47:03 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v6 10/14] KVM: selftests: Use a single binary for
 dirty/clear log test
Message-ID: <20200311184703.gbjncvlusef44tqk@kamzik.brq.redhat.com>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309222519.345601-1-peterx@redhat.com>
 <20200310081002.unxq6kwlevmr6m3b@kamzik.brq.redhat.com>
 <20200311174324.GH479302@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311174324.GH479302@xz-x1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 11, 2020 at 01:43:24PM -0400, Peter Xu wrote:
> > >  
> > > +	if (!log_mode_supported()) {
> > > +		fprintf(stderr, "Log mode '%s' not supported, skip\n",
> > > +			log_modes[host_log_mode].name);
> > 
> > I think kvm selftests needs a skip_test() function that outputs a more
> > consistent test skip message. It seems we mostly do
> 
> Yep, I can introduce one.

I already did. Right after suggesting it.

https://www.spinics.net/lists/kvm/msg209545.html

Thanks,
drew

