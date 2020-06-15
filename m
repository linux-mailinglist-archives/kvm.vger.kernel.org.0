Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEE01F9391
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgFOJel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:34:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57500 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728815AbgFOJel (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 05:34:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592213679;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=4Elhn4wrtO2ovR5dMkJU9uEDf1eDXOaakbyPO9IWdAA=;
        b=WdtzFO9CwhTAEESiLNnU8gjpaYlHWkvGq2diqhXwhyy3xz9cuiVB+ZoMvYszhmD7GAUxdN
        fuPeRmxzAunfW2OwxcvK+zgfi+kCyAZiBAqksF0W3edkjSeKeampLpTfdiZF2xeVXBxK4v
        DbJ+WA5A3H/Aeed6x6nLY9gWiDEdGIY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-7vZEEnZfNzGUOOrr9UnW5Q-1; Mon, 15 Jun 2020 05:34:36 -0400
X-MC-Unique: 7vZEEnZfNzGUOOrr9UnW5Q-1
Received: by mail-wr1-f71.google.com with SMTP id c14so6759019wrw.11
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 02:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=4Elhn4wrtO2ovR5dMkJU9uEDf1eDXOaakbyPO9IWdAA=;
        b=hXE7CSjk7Ee8W4d8mwSk9qJ93lDjbw9NFLMYTexM+7tb5pfYjCmb3x5iuDCmOqSICX
         t+qNBZ631BwmCI3HKXmv1LEOxxXYlK6fKkHGPWWdlP7q4qOC2YvXokYCmzZMRFz5OAkV
         80gsR2L444I8RXjWvcBNkdJsrnhas4/ti4qTB5inVkCtkm8ZVTYnr3Z+QsI9dpAmxgSZ
         8OjndKXibarAzBgddz5HAz1p/Tf4tY1yb+tpLSvJPjoGu01fmJKX2rKSTdyA9MsuHv8z
         skIL0eZAHW1c9EeJStj1TZHYzuEMlDYdXWw/4VURXiPmDKbAmZQrevHKTTIWUdWQoPNN
         /fUQ==
X-Gm-Message-State: AOAM531xbvzbGDnA73+/iZ+WYPH/rm0k+JdiPnJbm9ZDnZABLLyLnuDD
        eRE8GIKNcqFc6OAo3rEvEQ2tW7lcHdgwVM5s6Ss7bUZA8SpyaC5cxKM681d9POEGPyAMshwiGC3
        Xlmpu6s8wMYxN
X-Received: by 2002:a5d:4a89:: with SMTP id o9mr26902041wrq.267.1592213674726;
        Mon, 15 Jun 2020 02:34:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlQwEtuJ6/6s6fadiHz23evnmnX6dhxzpjz205rdtzVbyaYCQccaL5YpIMr01GpJNwbmyNZQ==
X-Received: by 2002:a5d:4a89:: with SMTP id o9mr26902022wrq.267.1592213674487;
        Mon, 15 Jun 2020 02:34:34 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id y37sm26829970wrd.55.2020.06.15.02.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 02:34:33 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for 2016-06-16
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 15 Jun 2020 11:34:32 +0200
Message-ID: <87wo48n047.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

Please, send any topic that you are interested in covering.
There is already a topic from last call:

Last minute suggestion after recent IRC chat with Alex Benn=C3=A9e and
Thomas Huth:

"Move some of the build/CI infrastructure to GitLab."

Pro/Con?

 - GitLab does not offer s390x/ppc64el =3D> keep Travis for these?

How to coordinate efforts?

What we want to improve? Priorities?

Who can do which task / is motivated.

What has bugged us recently:
- Cross-build images (currently rebuilt all the time on Shippable)

Long term interests:

- Collect quality metrics
  . build time
  . test duration
  . performances
  . binary size
  . runtime memory used

- Collect code coverage

Note, this is orthogonal to the "Gating CI" task Cleber is working on:
https://www.mail-archive.com/qemu-devel@nongnu.org/msg688150.html




At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=3DdG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a=
3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

