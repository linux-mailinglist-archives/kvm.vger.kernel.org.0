Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BE4242B15
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 16:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHLONS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 10:13:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35695 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726680AbgHLONQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 10:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597241595;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=ejPUyBMvOUu6yQ6VpXxEzbEE4aCxr9FAJUwFr7TKkTBoFzOZa8MNq5oTEXlED3Oku/Xf/8
        ++tFKrBIAged0CELQomN4dLk5NTm+5KfcHoApscWyRExNcC2e3DVxtzPguIvBgi8qd3eZv
        EiBJ8bKGDw58LCsc/TE1JC8ZxRfqLag=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-8gmVyy6vNXmnnMEaKUz15Q-1; Wed, 12 Aug 2020 10:13:12 -0400
X-MC-Unique: 8gmVyy6vNXmnnMEaKUz15Q-1
Received: by mail-wr1-f72.google.com with SMTP id e12so957229wra.13
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 07:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=rcYl8BvY1zEkd8TKhkfbvuUs7K0ZAfE6gVThiF4c+WXtQ5fak2EzQyNUHmRWHcu/v4
         HjpQJrvVQDaZjSujxMeE6u6L3D21nK3vSDngKh4yBGNKQCqOB1kJRGV9Z0JqLRErRxcR
         G2EUCZa02vSCZ76TdlPLFIodZYGwMAy3Bj66R2Jv6PnaAuKvHCKGF5mfeCRJVKpcuIHJ
         1Mk7hR4eqcrv967xbgHVGNBclpT8zDwWP/MKArBlhc2J+xe+JzbBN3ERn14yFbRzTyUm
         kiYSXzRftWvaVMIzP7p5FELjY4oA2FIRMmYGkXNCEaEMJwLcydOR4aIRp2cT3gerxWJb
         82Lg==
X-Gm-Message-State: AOAM5301snUFCYsr7JvgK7dxhGujEhbTagCgvJRr/7J9pMEweVORsn1z
        uTRC5PjRvur1Ygx+wWuevxr/08S0zsfEvKE8QK421OdhHRuQfeW2KRcJEtoVQt2aTYk+R3fNqNq
        TdjVYxe7w6zGI
X-Received: by 2002:a5d:6443:: with SMTP id d3mr33595783wrw.322.1597241591399;
        Wed, 12 Aug 2020 07:13:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwM3Nw8PFJ56wDkk5yBDHwzNrgBoZFZKvPFgaQnLLLxkgAZ87/sAULBDo/5hzhNGKdklJ2/7A==
X-Received: by 2002:a5d:6443:: with SMTP id d3mr33595761wrw.322.1597241591130;
        Wed, 12 Aug 2020 07:13:11 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id i4sm4387217wrw.26.2020.08.12.07.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 07:13:10 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for agenda for 2020-08-25
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Wed, 12 Aug 2020 16:13:09 +0200
Message-ID: <87v9ho7y16.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

