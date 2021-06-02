Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76F839950E
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhFBVC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 17:02:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbhFBVCz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 17:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622667671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p7sg/IMBwTD2xBJjdgJTtT61hdFxda4nZcANb5K1ByQ=;
        b=F6r81dDTxXSGZjqaYnJfQbZUlF4xoF71reBcn5HcHbR0vYVpi1gxkq2ijbSzd/1UFuQPRw
        QzMgEKrm++tt9LmRUx1ChI3+IpGKAyi0MjO1KiVu5xtv3MJR4WKyZvOjvOSQ66C+6F/BJ8
        8MljGmCpzkAK7sqyoAksHtyzryZWTKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-4sAFZaa2MSiDWdsKFz2jPQ-1; Wed, 02 Jun 2021 17:01:08 -0400
X-MC-Unique: 4sAFZaa2MSiDWdsKFz2jPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0512D1883526;
        Wed,  2 Jun 2021 21:01:07 +0000 (UTC)
Received: from localhost (ovpn-119-154.rdu2.redhat.com [10.10.119.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A390119714;
        Wed,  2 Jun 2021 21:01:06 +0000 (UTC)
Date:   Wed, 2 Jun 2021 17:01:06 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Eric Blake <eblake@redhat.com>
Cc:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH v8] qapi: introduce 'query-kvm-cpuid' action
Message-ID: <20210602210106.aahfqxu7cvxr5otx@habkost.net>
References: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com>
 <20210602205102.icdqspki66rwvc3n@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210602205102.icdqspki66rwvc3n@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 03:51:02PM -0500, Eric Blake wrote:
> On Mon, May 31, 2021 at 03:38:06PM +0300, Valeriy Vdovin wrote:
[...]
> > +##
> > +# @CpuidEntry:
> > +#
> > +# A single entry of a CPUID response.
> > +#
> > +# One entry holds full set of information (leaf) returned to the guest in response
> > +# to it calling a CPUID instruction with eax, ecx used as the agruments to that
> 
> arguments
> 
> > +# instruction. ecx is an optional argument as not all of the leaves support it.
> 
> Is there a default value of ecx for when it is not provided by the
> user but needed by the leaf?  Or is it an error if ecx is omitted in
> that case?  Similarly, is it an error if ecx is provided but not
> needed?

What does "not provided by the user" mean here?  This is not
describing the input to a QMP command, but the input to the CPUID
instruction.

-- 
Eduardo

