Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C035E152852
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 10:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgBEJ3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 04:29:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21714 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728232AbgBEJ3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 04:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580894950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kkP4//IuPPg9P86aHqbJ1cQxFMGQZiWvx5fm2FBuVJg=;
        b=Dd6uq1pOjEnBC5VVYhcE0I7V08HWaP0wIIgnGe4rk0PL8o8UXvHsqe9U7R93bxKttJVujg
        IKoDo2Inxc0J36j31NlykXUVxF058g/TQ7o66N1ePPWQAFaXlvXulu2BwQ98ZGn2uFTdQs
        tSMeHBcSJX7jcxwx7GZDqsZwTmJdj50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-Q1XqffiAM0-PYz7TOEpDzg-1; Wed, 05 Feb 2020 04:29:08 -0500
X-MC-Unique: Q1XqffiAM0-PYz7TOEpDzg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 589F38018B1;
        Wed,  5 Feb 2020 09:29:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68D1C87B1B;
        Wed,  5 Feb 2020 09:28:54 +0000 (UTC)
Date:   Wed, 5 Feb 2020 10:28:52 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, kevin.tian@intel.com, alex.williamson@redhat.com,
        dgilbert@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH 10/14] KVM: selftests: Use a single binary for
 dirty/clear log test
Message-ID: <20200205092852.vjskgirqlnm5ebtv@kamzik.brq.redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
 <20200205025842.367575-7-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205025842.367575-7-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 04, 2020 at 09:58:38PM -0500, Peter Xu wrote:
> Remove the clear_dirty_log test, instead merge it into the existing
> dirty_log_test.  It should be cleaner to use this single binary to do
> both tests, also it's a preparation for the upcoming dirty ring test.
> 
> The default test will still be the dirty_log test.  To run the clear
> dirty log test, we need to specify "-M clear-log".

How about keeping most of these changes, which nicely clean up the
#ifdefs, but also keeping the separate test, which I think is the
preferred way to organize and execute selftests. We can use argv[0]
to determine which path to take rather than a command line parameter.

Thanks,
drew

