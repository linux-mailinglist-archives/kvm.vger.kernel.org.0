Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C4927703B
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgIXLsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 07:48:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbgIXLsS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 07:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600948097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eUnojTPDBYsn0EDBVIcCzWuO+UV0uq77LDnCi7RHHTU=;
        b=LD4otdlOUXOm/CUdqgdiAAflJH4EbqkIO9U9/ryHdKgBZkmIfnbNzs1NljuZlaLEZFAi9q
        9CQPXR4jrdHWnft6l5xnj8NDVFkmD4pdFf2hJbKIB9vimPuvYdUkA7ttVOQd44OJh+COvT
        eHXuXzYe+C+HUNV6NR6meqghjH7thOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-Sa4jtv0DMTm4HpS8VftJKA-1; Thu, 24 Sep 2020 07:48:15 -0400
X-MC-Unique: Sa4jtv0DMTm4HpS8VftJKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E630802EA4;
        Thu, 24 Sep 2020 11:48:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.158])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11C5955786;
        Thu, 24 Sep 2020 11:48:12 +0000 (UTC)
Date:   Thu, 24 Sep 2020 13:48:09 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] README: Reflect missing --getopt in
 configure
Message-ID: <20200924114809.3xndwpqgrbnzzmdh@kamzik.brq.redhat.com>
References: <20200924100613.71136-1-r.bolshakov@yadro.com>
 <43d1571b-8cf6-3304-b4df-650a65528843@redhat.com>
 <20200924103054.GA69137@SPB-NB-133.local>
 <7e0b838b-2a6d-b370-e031-8d804c23b822@redhat.com>
 <20200924104836.GB69137@SPB-NB-133.local>
 <b515b803-daec-5a1f-9d65-07c2f209f763@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b515b803-daec-5a1f-9d65-07c2f209f763@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 24, 2020 at 12:52:16PM +0200, Paolo Bonzini wrote:
> On 24/09/20 12:48, Roman Bolshakov wrote:
> > Unfortunately it has no effect (and I wouldn't want to do that to avoid
> > issues with other scripts/software that implicitly depend on native
> > utilities):
> > 
> > $ brew link --force gnu-getopt
> > Warning: Refusing to link macOS provided/shadowed software: gnu-getopt
> > If you need to have gnu-getopt first in your PATH run:
> >   echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc
> > 
> > So if it's possible I'd still prefer to add an option to specify
> > --getopt in configure. I can resend a patch for that.
> 
> No, I'm not going to accept that.  It's just Apple's stupidity.  I have
> applied your patch, rewriting the harness in another language would
> probably be a good idea though.
>

I also feel like we've outgrown Bash, especially when we implement
things like migration tests. We have had requests to keep it Bash
though in order to continue running in resource constrained environments.
I think we can have both. We could rewrite the harness is a different
language and then compile/generate standalone tests (as we already do
to some extent). The standalone tests need to be compiled/generated in
such a way that they can run in resource constrained environments.
Finally, with standalone tests the only test runner you need is

 for t in `ls tests`; do
   tests/$t
 done

which can be written in the minimal scripting language of your choice.

Thanks,
drew

