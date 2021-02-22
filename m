Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BC9321377
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 10:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhBVJxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 04:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhBVJxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 04:53:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CA8864E2F;
        Mon, 22 Feb 2021 09:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613987588;
        bh=BBG3yknKL0hoGSOg1hNme7zrwWCbVtcVbJuDn0H9qRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2va3FjJtSZQupCjTYVzMxAyUZVVUbxhp9YPh7MLb2J8qpkpWPJQkQsuAXiQgnH5CW
         Y5PLKhfUqtCh3HifYAoGZ5ytxKRb7Wch2FiOaymmYibhqwjnJQjGZyPk4u2oZHrHeP
         QivH9UJCqqPRIVf9GwsBgmnDCZ9JQ/cBjnUJGlW4=
Date:   Mon, 22 Feb 2021 10:53:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Catangiu <acatan@amazon.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, graf@amazon.com, rdunlap@infradead.org,
        arnd@arndb.de, ebiederm@xmission.com, rppt@kernel.org,
        0x7f454c46@gmail.com, borntraeger@de.ibm.com, Jason@zx2c4.com,
        jannh@google.com, w@1wt.eu, colmmacc@amazon.com, luto@kernel.org,
        tytso@mit.edu, ebiggers@kernel.org, dwmw@amazon.co.uk,
        bonzini@gnu.org, sblbir@amazon.com, raduweis@amazon.com,
        corbet@lwn.net, mst@redhat.com, mhocko@kernel.org,
        rafael@kernel.org, pavel@ucw.cz, mpe@ellerman.id.au,
        areber@redhat.com, ovzxemul@gmail.com, avagin@gmail.com,
        ptikhomirov@virtuozzo.com, gil@azul.com, asmehra@redhat.com,
        dgunigun@redhat.com, vijaysun@ca.ibm.com, oridgar@gmail.com,
        ghammer@redhat.com
Subject: Re: [PATCH v6 1/2] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <YDN/AvsplZ7R8OTR@kroah.com>
References: <1613986886-29493-1-git-send-email-acatan@amazon.com>
 <1613986886-29493-2-git-send-email-acatan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613986886-29493-2-git-send-email-acatan@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 11:41:25AM +0200, Adrian Catangiu wrote:
> The driver also generates a `SYSGENID=%u` uevent containing the new
> system generation counter/id value every time it changes. Unlike the
> filesystem interface, the uevent has no synchronization guarantees
> therefore it should not be used by any sensitive system components.

No, please no.  It is not ok to start sending random uevents all the
time to userspace for individual drivers like this.  Especially for a
misc device.

As you say "has no synchromization guarantees", then why use it at all?

Please drop it.

thanks,

greg k-h
