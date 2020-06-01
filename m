Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2931B1EA118
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgFAJlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 05:41:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33810 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgFAJlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 05:41:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591004482;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=7R4WkhjnWyeLH0UmRJ4/Cy6AU8TkX7D45y5OIgQ9Iqs=;
        b=W78FLHJP4pgzC3xYlKlmz766Sra2q8xZafMngtI1MkYFq01yYzv/V1db7CFgQ0OU+W7XcI
        HunAWKh0eJyQefODm4G6vTIft83tDcM0HXMGisYs4qY6KollzaGPmGQRnhNpZePp9oyrGI
        03KK02F53aqMocc4PhGfjpulavv6Mq0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-66plXBSFOf6ATgAklvKNcg-1; Mon, 01 Jun 2020 05:41:19 -0400
X-MC-Unique: 66plXBSFOf6ATgAklvKNcg-1
Received: by mail-wr1-f72.google.com with SMTP id d6so4670542wrn.1
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 02:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=7R4WkhjnWyeLH0UmRJ4/Cy6AU8TkX7D45y5OIgQ9Iqs=;
        b=d8rYKfLVJDjMlsvN2uIJF8hY/il3LaV26vB9Soq/9Ee5F6ISUT9LM518XeiCYts13h
         5p0XAdGv+iLpqPdjxllKmhkz52PEAl1ZWnYEMHzKq8rdDwyQndksd3oJhOJJ1pk0hmNI
         ThTj8ZrXMmPHVi7tirkTVNbLw6T/JxY90z//3aHnBvd39Ypn2IYtCjs1qxMFgyNZFUJM
         t7Tt72VbX+fKFiwajVkD19USsX5v1rNPO5frhh/udDJ4GnsZDQftVSBHGdDXOv8iOpwR
         YRZrOe8xmjjtcstD3E8KOyHHh8Cu5SYes8Wz9MoeLWJukvdD5abj+rx67ORxQKWuuC6W
         oEHg==
X-Gm-Message-State: AOAM531/xanXt5h2sF0yjnNXr5+8NXCaD79OOxLM71PnWxkzUK+6Fp+R
        3c5b9Mlp5udgpxUIbhRGsyGzD6DNKKbbZqm6Htsoi6mDVfymm60UtUrZYwIDqVkkpJEm/Q9gaBY
        xJ7HRqjjLyH9t
X-Received: by 2002:a1c:4189:: with SMTP id o131mr21627417wma.110.1591004478350;
        Mon, 01 Jun 2020 02:41:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziNYdM6TkUvDrPEzTBfStQSm0MdutJAH9KY3s9OZM/1yICCnZTsfEWrLEkKI4yAzKNPgsN/Q==
X-Received: by 2002:a1c:4189:: with SMTP id o131mr21627407wma.110.1591004478098;
        Mon, 01 Jun 2020 02:41:18 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id f11sm14276205wrj.2.2020.06.01.02.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 02:41:17 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for 2020-06-02
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 01 Jun 2020 11:41:16 +0200
Message-ID: <87d06j6s3n.fsf@secure.mitica>
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

