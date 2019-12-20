Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8162F128280
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 19:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfLTS5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 13:57:16 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727390AbfLTS5P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 13:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576868234;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=cFh8F4XAF89lvEmScuXu4am01Qq5Q9wcAjX2EcomoIw=;
        b=EHIZU6bxM6uhB29by1nM4+n4xLi8YIkncyrfRJJ/uBH8SwiZC6jSUNR7/KCgWnYAGXO1FB
        Xt3E8+8taTyzAhQd5Bm7BCZSH93EYbEl15mxkPwtKM5KR8Im55NglTsJlXHHyMp/wy6kF1
        omCsMqLE2raSpIF+QJuwDVNenognUrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-sj1FOLOxMNmaPaLAlpUiSA-1; Fri, 20 Dec 2019 13:57:12 -0500
X-MC-Unique: sj1FOLOxMNmaPaLAlpUiSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1A1918B5F6A;
        Fri, 20 Dec 2019 18:57:09 +0000 (UTC)
Received: from redhat.com (ovpn-116-65.ams2.redhat.com [10.36.116.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E3615649A5;
        Fri, 20 Dec 2019 18:57:00 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        =?utf-8?Q?Herv=C3=A9?= Poussineau <hpoussin@reactos.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org, qemu-block@nongnu.org, qemu-ppc@nongnu.org
Subject: Re: Can we retire Python 2 now?
In-Reply-To: <8736dfdkph.fsf@dusky.pond.sub.org> (Markus Armbruster's message
        of "Fri, 20 Dec 2019 17:29:30 +0100")
References: <8736dfdkph.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 20 Dec 2019 19:56:58 +0100
Message-ID: <877e2qakqt.fsf@trasno.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Markus Armbruster <armbru@redhat.com> wrote:
> Python 2 EOL is only a few days away[*].  We made configure bitch about
> it in commit e5abf59eae "Deprecate Python 2 support", 2019-07-01.  Any
> objections to retiring it now, i.e. in 5.0?
>
> Cc'ing everyone who appears to be maintaining something that looks like
> a Python script.
>
> [*] https://pythonclock.org/

I am pretty sure that I am not a python maintaainer at all.

But anyways, python3 is only at python3.7.
python3.0 debuted at 2008, so ...

Acked-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>

And anything else that you can think that endorses the change.

Later, Juan.

