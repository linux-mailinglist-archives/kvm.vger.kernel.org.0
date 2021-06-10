Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F066E3A2C6A
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhFJNGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:06:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230453AbhFJNGO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 09:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623330258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5hD4Pe0huNw0SFcYR08aVLvC2nmpzAq+LEJ0WpnDAtI=;
        b=NMkiMq8FEoQWCnR6sFi8oiz/Bf9u8/pfQoXo1dRcgkHbi7uqElzcewYOU4OD5KeaD8Grda
        iA5kC+b256g5JQeMo0zsABIGa/wgOCrdJO0bQDJf0ucI6yy0iADvKNSiaPmT/If8+smXDN
        gTyLkZ/0QgUBhFflYq4VgYAw8pkvy1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-SVD3zjkSNqGdc53u2XtP3Q-1; Thu, 10 Jun 2021 09:04:16 -0400
X-MC-Unique: SVD3zjkSNqGdc53u2XtP3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 735E88030A0;
        Thu, 10 Jun 2021 13:04:15 +0000 (UTC)
Received: from localhost (ovpn-113-107.ams2.redhat.com [10.36.113.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D13A35C1C5;
        Thu, 10 Jun 2021 13:04:09 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/7] unify header guards
In-Reply-To: <162332742682.173232.8556399043091141939.b4-ty@redhat.com>
Organization: Red Hat GmbH
References: <20210609143712.60933-1-cohuck@redhat.com>
 <162332742682.173232.8556399043091141939.b4-ty@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 10 Jun 2021 15:04:08 +0200
Message-ID: <87r1h9zx9z.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10 2021, Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Wed, 9 Jun 2021 16:37:05 +0200, Cornelia Huck wrote:
>> This is an extension of "s390x: unify header guards" to the rest
>> of kvm-unit-tests. I tried to choose a pattern that minimizes the
>> changes; most of them are for s390x and x86.
>> 
>> v1->v2:
>> - change the patterns and document them
>> - change other architectures and architecture-independent code as well
>> 
>> [...]
>
> Applied, thanks!
>
> [1/7] README.md: add guideline for header guards format
>       commit: 844669a9631d78a54b47f6667c9a2750b65d101c
> [2/7] lib: unify header guards
>       commit: 9f0ae3012430ed7072d04247fb674125c616a6b4
> [3/7] asm-generic: unify header guards
>       commit: 951e6299b30016bf04a343973296c4274e87f0e2
> [4/7] arm: unify header guards
>       commit: 16f52ec9a4763e62e35453497e4f077031abcbfb
> [5/7] powerpc: unify header guards
>       commit: 040ee6d9aee563b2b1f28e810c5e36fbbcc17bd9
> [6/7] s390x: unify header guards
>       commit: eb5a1bbab00619256b76177e7a88cfe05834b026
> [7/7] x86: unify header guards
>       commit: c865f654ffe4c5955038aaf74f702ba62f3eb014

Oh, that was quick :)

I'll do some further (small) updates on top, then.

