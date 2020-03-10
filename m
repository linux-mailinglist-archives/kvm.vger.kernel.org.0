Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9BE17F61D
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 12:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJLUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 07:20:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21184 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725937AbgCJLUn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 07:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583839242;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=arw5L5YsoJ87khZVMFIrLcsKvVPIlQcfxYIOv80kSBg=;
        b=d66rXwRpXBzA5RPScNFObQshSHgIyJljAfwA02V352ZH8eGxpBQ/f5BNCfGgSAY3vyhhOX
        SVRvX01U2g7b37JZiJBYuyXhN919LyzLwqbtdeaIXKyElFKHAoDnGAO5oRlPCANpe7AImr
        aIQquNKQ9YLGWUuQp6YlJQ7yvE3uaII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-jfRFySz4PDiWwTidYnC3Bg-1; Tue, 10 Mar 2020 07:20:40 -0400
X-MC-Unique: jfRFySz4PDiWwTidYnC3Bg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2EAA18FF686;
        Tue, 10 Mar 2020 11:20:39 +0000 (UTC)
Received: from redhat.com (ovpn-116-72.ams2.redhat.com [10.36.116.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4652360BF3;
        Tue, 10 Mar 2020 11:20:39 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call today 2020-03-10
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 10 Mar 2020 12:20:33 +0100
Message-ID: <87a74ozcam.fsf@secure.laptop>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Today is a call becasue there are topics, in case you missed.
Notice that this call is in USA time, so if you are not there, it is
inside possiblity that it is one hour sooner that you are used to. See
the calendar.

 * Clarify the feedback on the latest revision of multi-process QEMU
   patches concerning:
   - Command-line: It's not clear what's the preferred approach to pass
     command-line parameters for the remote process. We are wondering if
     it's OK to accept the command-line parameters for the remote as a
     single string, or if it should be on multiple lines?
   - Refactoring migration related code: We realize that some of the
     modules we have built into the remote process (such as block and
     migration) compile more code than is required by the remote process.
     Ideally, we could refactor them to utilize just the pieces of code
     needed. However, this problem of refactoring has a larger scope.
     Could this be addressed in later projects?



 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

