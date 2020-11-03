Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26EB2A40FB
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 10:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgKCJ7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 04:59:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728130AbgKCJ7o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 04:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604397582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Hng8FF8rYKgUR62gX4zrbElssxECvV9gtRRJaSTRys=;
        b=dD8GMgvfZLwU4hyR88WmVmsPXXktdnMZw+I9uhhLFfs8Zj9zNwwxfuwblsdkq34ZOhYksJ
        z7agkuYsMY9pobipFuL14CB5Va+wwxVHpztTWl1gcZai+iGQTBykseLCgKFXoeGHFGJ3kb
        FjO8IWGedD5A+8z3ptJr4eqcz+ox4Pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-ayXy8H-_OKCHGs11E6V6HA-1; Tue, 03 Nov 2020 04:59:40 -0500
X-MC-Unique: ayXy8H-_OKCHGs11E6V6HA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 751B71009E23;
        Tue,  3 Nov 2020 09:59:39 +0000 (UTC)
Received: from paraplu.localdomain (ovpn-115-14.ams2.redhat.com [10.36.115.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEA9D2CFC6;
        Tue,  3 Nov 2020 09:59:35 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id AE19B3E0488; Tue,  3 Nov 2020 10:59:34 +0100 (CET)
Date:   Tue, 3 Nov 2020 10:59:34 +0100
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     qemu-devel@nongnu.org, libvir-list@redhat.com, kvm@vger.kernel.org
Subject: Re: Call for Volunteers: Summaries of a few KVMForum-2020 talks for
 an LWN article
Message-ID: <20201103095934.cqktlrq3zwxfewzj@paraplu>
References: <20201029142707.eyjimaffcwkbrwcw@paraplu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201029142707.eyjimaffcwkbrwcw@paraplu>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 03:27:07PM +0100, Kashyap Chamarthy wrote:
> Hi, folks
> 
> Like last year[1], we're aiming to submit a KVM Forum 2020 "recap"
> article for LWN.
> 
> This won't be a comprehensive summary of a lot of talks — LWN normally
> aims for 1500 words; they say "fewer can sometimes work, and more is
> generally OK too".  Given that, the write-up can cover about four
> topics, similar to previous year's recap.
> 
> So I'm looking for a couple of volunteers.  Meanwhile, I'll write LWN
> folks an email to see if they're amenable to this.  If they can't accept
> it for some reason, Plan-B is qemu.org blog articles.

Hi, it's me again.

LWN said they're open for a summary article and/or a couple of in-depth
talks -- if there are volunteers.  Generally LWN audience prefers fewer
talks that go deeper.

For an in-depth article, I'm more comfortable doing Eric Blake's "NBD
and Bitmaps: Building Blocks of Change Block Tracking" talk, as I'm
somewhat familar with the topic.

Let us know if anyone else wants to do an in-depth article on any of the
other KVM Forum talks.

[...]


-- 
/kashyap

