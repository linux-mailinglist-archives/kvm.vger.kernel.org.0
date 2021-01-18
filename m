Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16BE2F9D2D
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389242AbhARKsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 05:48:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33221 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389619AbhARK2j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 05:28:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610965632;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dK1pllbttz9UTn7bxMjY34vsHeiPV+rmtvknraDAfqk=;
        b=K/bSdUKkViPajtLmWdyJt806ffcwIfSAEk6C+W5RBtjmYVElBD9Vau8h1spUV8w1iuaLQE
        I0UGjY4hZtlJZiTkZShbscPh+UGvc7JMm7oNX9TqAenTh+DIE5oMASWRa10lCbfsYJgF1y
        Z1GHVxiOeKQWtdX/6zja2o/RUzMnvT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-rtrqrU7KM9mAYAxSt5CvWQ-1; Mon, 18 Jan 2021 05:27:10 -0500
X-MC-Unique: rtrqrU7KM9mAYAxSt5CvWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4CAE10054FF;
        Mon, 18 Jan 2021 10:27:08 +0000 (UTC)
Received: from redhat.com (ovpn-116-34.ams2.redhat.com [10.36.116.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B658071C99;
        Mon, 18 Jan 2021 10:27:01 +0000 (UTC)
Date:   Mon, 18 Jan 2021 10:26:58 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org,
        kvm@vger.kernel.org,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-devel@nongnu.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
Message-ID: <20210118102658.GD1789637@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-10-jiaxun.yang@flygoat.com>
 <20210118101159.GC1789637@redhat.com>
 <94f9255b-59eb-3e1f-0691-c24751d04700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94f9255b-59eb-3e1f-0691-c24751d04700@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 11:22:47AM +0100, Thomas Huth wrote:
> On 18/01/2021 11.11, Daniel P. Berrangé wrote:
> > On Mon, Jan 18, 2021 at 02:38:08PM +0800, Jiaxun Yang wrote:
> > > We only run build test and check-acceptance as their are too many
> > > failures in checks due to minor string mismatch.
> > 
> > Can you give real examples of what's broken here, as that sounds
> > rather suspicious, and I'm not convinced it should be ignored.
> 
> I haven't tried, but I guess it's the "check-block" iotests that are likely
> failing with a different libc, since they do string comparison on the
> textual output of the tests. If that's the case, it would maybe be still ok
> to run "check-qtest" and "check-union" on Alpine instead of the whole
> "check" test suite.

Perhaps errno strings are different due to libc hitting block tests. I
would expect this to be explained in the commit message though with
example, so we have a clear record of why we needed to disable this.

It might indicate a need to change our test suite to be more robust
in this area, because that would also suggest the tests might fail
on  non-Linux.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

