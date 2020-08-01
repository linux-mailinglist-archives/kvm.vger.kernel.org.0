Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368A32351DF
	for <lists+kvm@lfdr.de>; Sat,  1 Aug 2020 13:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgHAL1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Aug 2020 07:27:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728255AbgHAL1D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 Aug 2020 07:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596281221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d5CXoc1qnZR9W5tfR9Rzuxcqi/CIaEtuBAMVaajeUk0=;
        b=cMyYQrfX8rFI0DIxH+yEIxEGcOAfR8kO4U5cl89BAmQyvMz9DyH691LV6YqpmZpCp9HTQG
        iD0jj68UVupnwAlhjqzcXQ8dtcNpVM9QCkq9yfT47WQ/ISOSFzK45+zUo5+k4ILEWE49XO
        AjEvaSRZ31mJq/RiGUJS0M6Rb5iGpu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-a0-w7Hi-PPOpMlm2C4UXRQ-1; Sat, 01 Aug 2020 07:25:36 -0400
X-MC-Unique: a0-w7Hi-PPOpMlm2C4UXRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E86280183C;
        Sat,  1 Aug 2020 11:25:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 269E91001B0B;
        Sat,  1 Aug 2020 11:25:33 +0000 (UTC)
Date:   Sat, 1 Aug 2020 13:25:31 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        KVM list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: New repo for kvm-unit-tests
Message-ID: <20200801112531.mvw2riitcqoyju3w@kamzik.brq.redhat.com>
References: <7040f939-3f15-e56c-61dd-201ec46b6515@redhat.com>
 <A0556EC0-1975-4DBD-9A9B-3A9B8FE24FC7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A0556EC0-1975-4DBD-9A9B-3A9B8FE24FC7@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 09:07:44AM -0700, Nadav Amit wrote:
> > On Jul 30, 2020, at 3:05 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > kvm-unit-tests now lives at its now home,
> > https://gitlab.com/kvm-unit-tests/kvm-unit-tests.  The kernel.org
> > repository has been retired.
> > 
> > Nothing else changes, we're still living in the 20th century for patch
> > submission and issue tracking.
> > 
> > Thanks Thomas for your work and your persistence!  I must admit it
> > really just works.
> 
> Can you update http://www.linux-kvm.org/page/KVM-unit-tests so when
> someone googles KVM-unit-tests he will get the right repository?
>

Done.

Thanks,
drew 

