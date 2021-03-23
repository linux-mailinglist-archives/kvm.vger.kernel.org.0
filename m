Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C312634654A
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhCWQf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhCWQfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:35:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BAF9619B4;
        Tue, 23 Mar 2021 16:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616517316;
        bh=RK+Kv0wxjcx5breQamKbj/qd89hf2M+eHtScR6kIrvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bmf7U7KRA1m3gCUVC68jb1cPk4eb0Ce3ElrG1jzdXzWAn5+SG+L5DJs0n8es+H/Lh
         oFcl1isxkQlKrWEv2Im4EifesAsn4zgc9iupKF0PhEqpI8o5oV+QEbnQ98S/y4FZoJ
         hNusdpNZpE+/cIZZKPW2OTOBGC+Us/bvevZUElxI=
Date:   Tue, 23 Mar 2021 17:35:14 +0100
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
Message-ID: <YFoYwq/RadewiE8I@kroah.com>
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

I'll gladly drop this patch if it's not needed in the kernel, thanks for
letting me know.

greg k-h
