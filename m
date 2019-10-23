Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368C8E261B
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 00:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436676AbfJWWG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 18:06:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23828 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731301AbfJWWG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 18:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571868388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EBZdX8XYASZ/hcfjUquvBjt91Cclb0VNS3/vMpZYZLM=;
        b=AJnwTDVsXqnhtGyUbS1aTs1R5KMeO7VGybkdc7tmurlhFBd9M6/c7GYiZ8S0u2pQH4Xup4
        CIGDZjHjL7ri8pwKX8zzGROBIh1dIg7azYirX8Od9YvqvcK7lxDN51PjGqo13QuVbRB2He
        7yNknj7VXbN2VbzGf5nNucSA9wEvM3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-D38nSc7BMIG3e80ECrNc-w-1; Wed, 23 Oct 2019 18:06:24 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10E8F476;
        Wed, 23 Oct 2019 22:06:23 +0000 (UTC)
Received: from treble (ovpn-121-225.rdu2.redhat.com [10.10.121.225])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C114560C57;
        Wed, 23 Oct 2019 22:06:20 +0000 (UTC)
Date:   Wed, 23 Oct 2019 17:06:18 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: Re: [patch V2 07/17] x86/entry/64: Remove redundant interrupt disable
Message-ID: <20191023220618.qsmog2k5oaagj27v@treble>
References: <20191023122705.198339581@linutronix.de>
 <20191023123118.296135499@linutronix.de>
MIME-Version: 1.0
In-Reply-To: <20191023123118.296135499@linutronix.de>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: D38nSc7BMIG3e80ECrNc-w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 23, 2019 at 02:27:12PM +0200, Thomas Gleixner wrote:
> Now that the trap handlers return with interrupts disabled, the
> unconditional disabling of interrupts in the low level entry code can be
> removed along with the trace calls.
>=20
> Add debug checks where appropriate.

This seems a little scary.  Does anybody other than Andy actually run
with CONFIG_DEBUG_ENTRY?  What happens if somebody accidentally leaves
irqs enabled?  How do we know you found all the leaks?

--=20
Josh

