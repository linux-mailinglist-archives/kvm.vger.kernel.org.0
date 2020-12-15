Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E102DACBE
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 13:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgLOMJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 07:09:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728774AbgLOMJV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 07:09:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608034074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BzXtDCDlYHbQNJovTzQ9kflzxmawaoKDBnuvKnmCtN4=;
        b=BWN5yzsJtk+0q2ixRKOV7TXvhf6Z7ptPPmuqdCHaeN2Dqar4zJL+Muu+9RblFg9O3aUfPz
        eyo08IU2Er8IAzbHhmmVqV27Q5lLgyvbdLy/WnmX1KAblPbRC8hiAsCZ5ng1kvb2dvirdS
        sqt6p3i2THL8nOFBHsrJ2QGlXNyb8iI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-2LIpxYBzMZKy2v2z4fkg1g-1; Tue, 15 Dec 2020 07:07:53 -0500
X-MC-Unique: 2LIpxYBzMZKy2v2z4fkg1g-1
Received: by mail-ed1-f69.google.com with SMTP id i15so9887185edx.9
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 04:07:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BzXtDCDlYHbQNJovTzQ9kflzxmawaoKDBnuvKnmCtN4=;
        b=MWfaKY6kv4DJ1FopVIcQpH0gxAIXmz2v7/N+UDo8lAY6YKEKG6enfXEA8/3rD9C5RU
         YDpVEC1e8T9j90cNpa6qlRi/IhthEkUX94+BElIO8WSPl5LbIvUu/2F6yuR75n07kLt7
         /CrO60xTINnt6N7O7GUD7C7nhoWvdBLJc/EDr1kfFfPDCdr5+2wumDP8usfLSG6z34yS
         3ptFFvdIMcpritmE03AvTkHcJnMHa8Xe0Wyx0FPX/Wqto6D9uC3ro/Sapem+UFSV60Dn
         Sc2yj3xmALe0Kp8kv1e1oVnO2JxtnAHfwzdJIxmhgsFyr7t8vh3WQ1bwylJKGSqsiixv
         wt7w==
X-Gm-Message-State: AOAM531i4NMsGxtmJVBYkL/bnyNS0pefaySgdWtLImHg6hqfs9i0Y9cm
        E5q6C7C6lemlLWNTTPXQRQPZm13KXG8tEETRVgPiKyJr7EWgw8j+P2EzKFkbkOYQKVbt7lGKq/l
        /oKnZT2mSPbk5
X-Received: by 2002:a17:906:3ad5:: with SMTP id z21mr26043427ejd.35.1608034071916;
        Tue, 15 Dec 2020 04:07:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrSXXazpKZHwSCq348+Lb/3OBbvQHzrgliw5IyboW9ZO8QwIi3WC5ngKarU2aCwT1HnBRp+g==
X-Received: by 2002:a17:906:3ad5:: with SMTP id z21mr26043407ejd.35.1608034071756;
        Tue, 15 Dec 2020 04:07:51 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u23sm1231830ejy.87.2020.12.15.04.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 04:07:51 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 01/17] KVM: Fix arguments to kvm_{un,}map_gfn()
In-Reply-To: <3E601C94-B52B-43AF-9D13-FD8CB24DED20@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-2-dwmw2@infradead.org>
 <87ft48w0or.fsf@vitty.brq.redhat.com>
 <6E8FD19B-7ABD-4BF1-84C5-26EDD327F01D@infradead.org>
 <87a6ugvzek.fsf@vitty.brq.redhat.com>
 <3E601C94-B52B-43AF-9D13-FD8CB24DED20@infradead.org>
Date:   Tue, 15 Dec 2020 13:07:50 +0100
Message-ID: <87tusnuvah.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

> On 14 December 2020 21:41:23 GMT, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>>Your change is correct but I'm not sure that it's entirely clear that
>>kvm_map_gfn() implicitly uses 'as_id=0' and I don't even see a comment
>>about the fact :-(
>
> Isn't that true of all the kvm_read_guest and kvm_write_guest
> functions and indeed of kvm_memslots() itself?

Yes, sadly. Multiple address spaces support was added to KVM as a
generic feature but the only use-case for it at this moment is SMM on
x86 which is 'special', i.e. currently there's only one user for 
kvm_map_gfn()/kvm_unmap_gfn() which is steal time accounting and it's
not easy to come up with a use-case when this PV feature needs to be
used from SMM. On the other hand, if we try using multiple address
spaces in KVM for e.g. emulating something like Hyper-V VSM, it becomes
unclear which address space id needs to be used even for steal
time. To be entirely correct, we probably need to remember as_id which
was active when steal time was enabled and stick to it later when we
want to update the data. If we do that, kvm_map_gfn() will lose its only
user.

All the above doesn't make your patch incorrect of course, I just used
it to express my observation that we seem to be using as_id=0 blindly
and the API we have contributes to that.

-- 
Vitaly

