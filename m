Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6AE3B16E3
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 11:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFWJdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 05:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230138AbhFWJc7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 05:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624440642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kAxjtAMgAgnQc3g+VJW6cHqmyhoDwUFxxzEOFIhyLsg=;
        b=eA+x8zHSbuASvyEngVxHmODSmEwpHzNsJmobHcN9H7EXyKUi/nqiFDwTH9EFRHLEt7DTP4
        0sDrQu6soQgD6Lnt73cGBjLX+FGJCPOXMOyEtNGkF6ZHbywD50Jrd7SFDETczwGCBNhQEC
        Wf3DyfUaj9u2dhT6YRo/o3eS/oiyics=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-pOP5RYI6NWGGf7tuvIJtUQ-1; Wed, 23 Jun 2021 05:30:38 -0400
X-MC-Unique: pOP5RYI6NWGGf7tuvIJtUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58985100CF6E;
        Wed, 23 Jun 2021 09:30:35 +0000 (UTC)
Received: from localhost (ovpn-113-66.ams2.redhat.com [10.36.113.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 884CF5D6D7;
        Wed, 23 Jun 2021 09:30:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>, bhelgaas@google.com,
        alex.williamson@redhat.com, jgg@ziepe.ca, kevin.tian@intel.com,
        eric.auger@redhat.com, giovanni.cabiddu@intel.com,
        mjrosato@linux.ibm.com, jannh@google.com, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, schnelle@linux.ibm.com
Cc:     minchan@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, mcgrof@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] PCI: Export pci_dev_trylock() and pci_dev_unlock()
In-Reply-To: <20210623022824.308041-2-mcgrof@kernel.org>
Organization: Red Hat GmbH
References: <20210623022824.308041-1-mcgrof@kernel.org>
 <20210623022824.308041-2-mcgrof@kernel.org>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 23 Jun 2021 11:30:25 +0200
Message-ID: <87sg19lyha.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22 2021, Luis Chamberlain <mcgrof@kernel.org> wrote:

> Other places in the kernel use this form, and so just
> provide a common path for it.
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/pci/pci.c   | 6 ++++--
>  include/linux/pci.h | 3 +++
>  2 files changed, 7 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

