Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CAE1280AA
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 17:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfLTQ3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 11:29:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51168 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726808AbfLTQ3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 11:29:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576859384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9KQWkC7u/r+Ge5VWofWspVvn0pZbHgMnzh1SQlJF00Q=;
        b=DcsG9QHC0OQcFMdZaSv6e/ZJZVl+FJjAxkqmSHBp6GFMLS7yl+SIllBtr2/i4jnZiyuzJC
        m997gjeU806VRjNeLU56X1Nf8ik3ZE9uvNbylGHABWKgjlMkZjfra0Y+gSBG1yRe/KnF1Y
        S1oiiTEgvwT1r59MrMJGsnRO52ElhYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-hE7-EDYzNRCJM6c_jMrbGA-1; Fri, 20 Dec 2019 11:29:42 -0500
X-MC-Unique: hE7-EDYzNRCJM6c_jMrbGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38C95800D4E;
        Fri, 20 Dec 2019 16:29:40 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-116-42.ams2.redhat.com [10.36.116.42])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 315626FDCF;
        Fri, 20 Dec 2019 16:29:32 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 5DEA411386A7; Fri, 20 Dec 2019 17:29:30 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        =?utf-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Fam Zheng <fam@euphon.net>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        =?utf-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org, qemu-block@nongnu.org, qemu-ppc@nongnu.org
Subject: Can we retire Python 2 now?
Date:   Fri, 20 Dec 2019 17:29:30 +0100
Message-ID: <8736dfdkph.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Python 2 EOL is only a few days away[*].  We made configure bitch about
it in commit e5abf59eae "Deprecate Python 2 support", 2019-07-01.  Any
objections to retiring it now, i.e. in 5.0?

Cc'ing everyone who appears to be maintaining something that looks like
a Python script.

[*] https://pythonclock.org/

