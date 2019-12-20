Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024651280FB
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 17:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfLTQ4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 11:56:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57009 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727362AbfLTQ4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 11:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576861003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IpdkpY65tRP8q7UJ0txP3ogqAmfPMz5QOEyWm9W9H1I=;
        b=AeitFl6hRIY6FzOh93rgKaxMEGqPSLBvwLfHtlrkYWpMzDDZdCk2CP9n9HUfpRcOVkEbsM
        bJ1XnZBK/uDwVkLQl2Zp16TDziV0kHItEUIaBIp8z8t0orFzNKERuU1ZrJD3zn0+KBexg+
        6udI7X5kLBss3z2aOK2lVVAWwHF5WXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-xKmCvYakPP2xar0kbbZ_kw-1; Fri, 20 Dec 2019 11:56:39 -0500
X-MC-Unique: xKmCvYakPP2xar0kbbZ_kw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01EC5800D48;
        Fri, 20 Dec 2019 16:56:37 +0000 (UTC)
Received: from localhost (ovpn-116-10.gru2.redhat.com [10.97.116.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D80D25C1B2;
        Fri, 20 Dec 2019 16:56:28 +0000 (UTC)
Date:   Fri, 20 Dec 2019 13:56:27 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Cleber Rosa <crosa@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        =?iso-8859-1?Q?Herv=E9?= Poussineau <hpoussin@reactos.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org, qemu-block@nongnu.org, qemu-ppc@nongnu.org
Subject: Re: Can we retire Python 2 now?
Message-ID: <20191220165627.GV498046@habkost.net>
References: <8736dfdkph.fsf@dusky.pond.sub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8736dfdkph.fsf@dusky.pond.sub.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 05:29:30PM +0100, Markus Armbruster wrote:
> Python 2 EOL is only a few days away[*].  We made configure bitch about
> it in commit e5abf59eae "Deprecate Python 2 support", 2019-07-01.  Any
> objections to retiring it now, i.e. in 5.0?

Thanks for the reminder!

I'll be honest: even if somebody in this list objects to dropping
Python 2 support, I'm not willing to be maintainer of a Python 2
codebase in 2020.  The only reason for not doing it in 4.1 was
the tests/vm/netbsd breakage we took very long to debug and fix.

I have just submitted this pull request:

  Subject: [PULL 0/2] Require Python >= 3.5 to build QEMU
  https://lore.kernel.org/qemu-devel/20191220165141.2207058-1-ehabkost@redhat.com/

> 
> Cc'ing everyone who appears to be maintaining something that looks like
> a Python script.
> 
> [*] https://pythonclock.org/

-- 
Eduardo

