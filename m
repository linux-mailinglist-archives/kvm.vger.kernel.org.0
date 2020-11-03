Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A592A4C56
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 18:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgKCRJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 12:09:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726581AbgKCRJi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 12:09:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604423377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g3WM6WOWWdPWlWqVHR8hbDwWZdRpJOZp8hnY3aBFqtU=;
        b=jFwdwZfw216RgqNfP3928ytZ7Y56xw/o8fWRTp66aH1/Kk5CGAr6NAbYgqcL708oSaEoVp
        WR3uMddsxpyn5hZ3sIVAsVNl4xPye6ahCcBMvMzBYy2Nr0OpdbKcQX+MD98Bur0s5WQd2l
        oWAD4vB4sjzJ41XFEOf8EmLAKex3H+c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-67wdqUcrPYGHwkmTMMeX1Q-1; Tue, 03 Nov 2020 12:09:33 -0500
X-MC-Unique: 67wdqUcrPYGHwkmTMMeX1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED50318C9F40;
        Tue,  3 Nov 2020 17:09:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 069EB5B4A1;
        Tue,  3 Nov 2020 17:09:29 +0000 (UTC)
Date:   Tue, 3 Nov 2020 18:09:27 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 0/2] arm: MMU extentions to enable litmus7
Message-ID: <20201103170927.a4lxfu66ot2ez2kv@kamzik.brq.redhat.com>
References: <20201102115311.103750-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102115311.103750-1-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 11:53:09AM +0000, Nikos Nikoleris wrote:
> Hi all,
> 
> litmus7 [1][2], a tool that we develop and use to test the memory
> model on hardware, is building on kvm-unit-tests to encapsulate full
> system tests and control address translation. This series extends the
> kvm-unit-tests arm MMU API and adds two memory attributes to MAIR_EL1
> to make them available to the litmus tests.
> 
> [1]: http://diy.inria.fr/doc/litmus.html
> [2]: https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/expanding-memory-model-tools-system-level-architecture

Hi Nikos,

I'm glad to see this application of kvm-unit-tests. It'd be nice to
extract some of the overview and howto from the blog [2] into a
markdown file that we can add to the kvm-unit-tests repository.

Thanks,
drew

