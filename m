Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CA169620
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 17:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731708AbfGOOK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 10:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388922AbfGOOKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 10:10:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96B5F30C257C;
        Mon, 15 Jul 2019 14:10:50 +0000 (UTC)
Received: from redhat.com (ovpn-117-250.ams2.redhat.com [10.36.117.250])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EEDC1001B02;
        Mon, 15 Jul 2019 14:10:50 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PULL 00/19] Migration patches
In-Reply-To: <CAFEAcA_9tVQht7bp9_yrFEhQ74ye6LBNjEYK_nftCWsKMrOohw@mail.gmail.com>
        (Peter Maydell's message of "Mon, 15 Jul 2019 14:48:42 +0100")
References: <20190712143207.4214-1-quintela@redhat.com>
        <CAFEAcA-ydNS072OH7CyGNq2+sESgonW-8QSJdNYJq6zW-rYjUQ@mail.gmail.com>
        <CAFEAcA9ncjtGdc8CZOJBDBRtzEU8oL7YicVg5PtyiiO2O4z51w@mail.gmail.com>
        <87zhlf76pk.fsf@trasno.org>
        <CAFEAcA_9tVQht7bp9_yrFEhQ74ye6LBNjEYK_nftCWsKMrOohw@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 15 Jul 2019 16:10:44 +0200
Message-ID: <87pnmb75i3.fsf@trasno.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 15 Jul 2019 14:10:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Maydell <peter.maydell@linaro.org> wrote:
> On Mon, 15 Jul 2019 at 14:44, Juan Quintela <quintela@redhat.com> wrote:
>>
>> Peter Maydell <peter.maydell@linaro.org> wrote:
>> > On Fri, 12 Jul 2019 at 17:33, Peter Maydell <peter.maydell@linaro.org> wrote:
>> >> Still fails on aarch32 host, I'm afraid:
>>
>> Hi
>>
>> dropping the multifd test patch from now.  For "some" reason, having a
>> packed struct and 32bits is getting ugly, not sure yet _why_.
>
> IMHO 'packed' structs are usually a bad idea. They have a bunch
> of behaviours you may not be expecting (for instance they're
> also not naturally aligned, and arrays of them won't be the
> size you expect).

I can't get everything happy O:-)
For the multifd initial packet, I used to have that I wrote the fields
by hand.  Then danp asked that I used a packed struct, and converted the
values inside it.  So ..... Imposible to have everybody happy.

Anyways, the struct is packed, both sides are i386 32bits, and it should
be exactly the same, but it appears that there is where your valgrind
problems appear.  Still investigating _where_ the problem is.  What is
even weirder is that there is no error at all on 64bits.

Thanks, Juan.

PS.  BTW, did you launched by hand the guests with valgrind, or there is
     a trick that I am missing for launching a qtest with valgrind?
