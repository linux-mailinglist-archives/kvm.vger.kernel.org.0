Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E76234725B
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 08:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhCXHWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 03:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235833AbhCXHWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 03:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D19BB619FA;
        Wed, 24 Mar 2021 07:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616570564;
        bh=A0pGJbn75arVdOD9b5IBCTpV/4uLDqxrD6Da79sVFnc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R4Rq5zuB3Z/Vfseh37K/cZNtdG7CkZTTjV8tzbmwqVjNNCZREy9jMM4hL57gfji30
         9W96veE+jEaie8zu2sgf1c44Mcp8hTlaH/wdq1HNKXnBRhWu8667lhEwcBEVM1ejAL
         C8BNQEfeKQP0mO4Cgy2lM758ALTtzS6UPKd/vd+8=
Date:   Wed, 24 Mar 2021 08:22:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Catangiu, Adrian Costin" <acatan@amazon.com>
Cc:     "Graf (AWS), Alexander" <graf@amazon.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "areber@redhat.com" <areber@redhat.com>,
        "ovzxemul@gmail.com" <ovzxemul@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>
Subject: Re: [PATCH v8] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <YFrowKgcnozZyxKC@kroah.com>
References: <1615213083-29869-1-git-send-email-acatan@amazon.com>
 <YEY2b1QU5RxozL0r@kroah.com>
 <a61c976f-b362-bb60-50a5-04073360e702@amazon.com>
 <YFnlZQZOasOwxUDn@kroah.com>
 <E6E517FF-A37C-427C-B16F-066A965B8F42@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E6E517FF-A37C-427C-B16F-066A965B8F42@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 04:10:27PM +0000, Catangiu, Adrian Costin wrote:
> Hi Greg,
> 
> After your previous reply on this thread we started considering to provide this interface and framework/functionality through a userspace service instead of a kernel interface.
> The latest iteration on this evolving patch-set doesn’t have strong reasons for living in the kernel anymore - the only objectively strong advantage would be easier driving of ecosystem integration; but I am not sure that's a good enough reason to create a new kernel interface.
> 
> I am now looking into adding this through Systemd. Either as a pluggable service or maybe even a systemd builtin offering.
> 
> What are your thoughts on it?

Now dropped from my char-misc-testing branch.  If you all decide you
want this as a kernel driver, please resubmit it.

Also next time, you might give me a heads-up that you don't want a patch
merged...

thanks,

greg k-h
