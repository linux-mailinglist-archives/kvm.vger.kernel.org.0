Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D271FC100
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 23:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgFPV27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 17:28:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbgFPV26 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 17:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592342937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rRh+bsO5ya1vyuXRzWMbWmQBQBQw6GO67hQ8ugA1dfs=;
        b=AT3o9UtGJ+vZ0+xTRjWFFlNC0UjkryVU9wLZXbKRCAX/qf7WOooVxMgCP31KAbJzvgXU7g
        9BGYuzono5444tWZ2UEaofNaTVjDteeDcs/eadebYRpQ6p2GrFsEnyNyLALFFn0ZsE6T5/
        WkxW8SUJ31RFDFNuVLBxz5OVMlesoc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-mlueeNVfP4uJI35iJJhv_Q-1; Tue, 16 Jun 2020 17:28:55 -0400
X-MC-Unique: mlueeNVfP4uJI35iJJhv_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B122080F5E4;
        Tue, 16 Jun 2020 21:28:54 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5FAB5C1BD;
        Tue, 16 Jun 2020 21:28:53 +0000 (UTC)
Date:   Tue, 16 Jun 2020 15:28:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: vfio: refcount_t: underflow; use-after-free.
Message-ID: <20200616152853.1f6239f4@x1.home>
In-Reply-To: <20200616085052.sahrunsesjyjeyf2@beryllium.lan>
References: <20200616085052.sahrunsesjyjeyf2@beryllium.lan>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Jun 2020 10:50:52 +0200
Daniel Wagner <dwagner@suse.de> wrote:

> Hi,
> 
> I'm getting the warning below when starting a KVM the second time with an
> Emulex PCI card 'passthroughed' into a KVM. I'm terminating the session
> via 'ctrl-a x', not sure if this is relevant.
> 
> This is with 5.8-rc1. IIRC, older version didn't have this problem.

Thanks for the report, it's a new regression.  I've just posted a fix
for it.  Thanks,

Alex

