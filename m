Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A5A13AB10
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 14:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgANN3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 08:29:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40621 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725994AbgANN3H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 08:29:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579008545;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=rJbcImH5i0e70GI2sx/dpdxprKBxk63V9AGRCyBHgxk=;
        b=Werx+sL+GVbqgWb8qqmawG683eOksWcknd4oHExTc//vU2BCPJ3yRn9OP85o+7At4xmenc
        4wyP2UlE1+wjWz+uLdve64ErJkD+1xFrXqqNSHmXcPDumfAKo5kv8QElE9mysAUx2vu6lo
        NFf2AMppixiToxU+GofeXAe/kcmM5Ag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-xZq5XLksPlS1kPDnfvC-nQ-1; Tue, 14 Jan 2020 08:29:04 -0500
X-MC-Unique: xZq5XLksPlS1kPDnfvC-nQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51230802B85;
        Tue, 14 Jan 2020 13:29:03 +0000 (UTC)
Received: from redhat.com (unknown [10.36.118.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5889F19C5B;
        Tue, 14 Jan 2020 13:29:00 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: KVM call for agenda for 2020-01-14
In-Reply-To: <87k163qwwh.fsf@trasno.org> (Juan Quintela's message of "Tue, 07
        Jan 2020 13:22:06 +0100")
References: <87k163qwwh.fsf@trasno.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 14 Jan 2020 14:28:58 +0100
Message-ID: <87wo9ucgkl.fsf@secure.laptop>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan Quintela <quintela@redhat.com> wrote:
> Hi
>
> Please, send any topic that you are interested in covering.
>
> We have already one topic for this call already:
>
> * Multi-process QEMU and muser

Hi folks

Remember that today is a call in 30 minutes.

Thanks, Juan.

>
> By popular demand, a google calendar public entry with it
>
>   https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
>
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
>
> If you need phone number details,  contact me privately
>
> Thanks, Juan.

