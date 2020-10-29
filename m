Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7223729EE31
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 15:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgJ2O25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 10:28:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725300AbgJ2O1S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 10:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603981637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fBTdTzXftXjdXEiq+IVzjM1JZMchfhSQf6olbJWSTHo=;
        b=FCzuSAmwJ0jgsjN8iOyWTZkBEASRbh4fKQ5F7Ej19YTGJOhV7Tk+JFkKTRn7UQcC3fGWz/
        NWkCGkef2kPvg9Bj0e2tqKXZ00dQqyqZ/k8HdfmXkM3ok0GZ8cS00mL/d67QrnGByhrnZs
        21LJmRzgFD2YjbckNLZSBuSTKuWdwvA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-H1sufUnaMX-1bgWHGNBfhA-1; Thu, 29 Oct 2020 10:27:14 -0400
X-MC-Unique: H1sufUnaMX-1bgWHGNBfhA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1629E101EBEA;
        Thu, 29 Oct 2020 14:27:13 +0000 (UTC)
Received: from paraplu.localdomain (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEC8819930;
        Thu, 29 Oct 2020 14:27:08 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id 1B8373E047D; Thu, 29 Oct 2020 15:27:07 +0100 (CET)
Date:   Thu, 29 Oct 2020 15:27:07 +0100
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     qemu-devel@nongnu.org, libvir-list@redhat.com, kvm@vger.kernel.org
Subject: Call for Volunteers: Summaries of a few KVMForum-2020 talks for an
 LWN article
Message-ID: <20201029142707.eyjimaffcwkbrwcw@paraplu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, folks

Like last year[1], we're aiming to submit a KVM Forum 2020 "recap"
article for LWN.

This won't be a comprehensive summary of a lot of talks — LWN normally
aims for 1500 words; they say "fewer can sometimes work, and more is
generally OK too".  Given that, the write-up can cover about four
topics, similar to previous year's recap.

So I'm looking for a couple of volunteers.  Meanwhile, I'll write LWN
folks an email to see if they're amenable to this.  If they can't accept
it for some reason, Plan-B is qemu.org blog articles.

- KVM Forum 2020 schedule: https://kvmforum2020.sched.com/  
- And LWN.net's author guidelines: https://lwn.net/op/AuthorGuide.lwn

I volunteer to summarize Janosch Frank's "The Common Challenges of
Secure VMs" talk.

Let me know, on-list or off-list, on what topic you'd like to pick.

PS: Just like it was noted in the last year's call for volunteers, we
    will not ask LWN.net for money.

[1] https://lwn.net/Articles/805097/ -- A recap of KVM Forum 2019
[2] https://lists.gnu.org/archive/html/qemu-devel/2019-09/msg03536.html

-- 
/kashyap

