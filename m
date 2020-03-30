Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746DB198228
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 19:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgC3RWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 13:22:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgC3RWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 13:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=RTo/l3mApqYi+FAC2NhO4jmI7vS3v+umdzjqut0gXrs=; b=epXZGh7AJkvwaCOfIcKqPes0O/
        TZITBPLJ88zQPtBJYZxf/f+N9pIbvNHDFyWCZ0wjXtVdOjKd25Vc73LrepJ+kipztOfwjgUSVaryX
        UG1rbVv8MnGL4HsfqIyw4Vh4iTHJCIU+4PhLMEhCEGoEC7az/TGfhzvfj0bNUpgc97iNQ8YDWnq5b
        PRY3uA5tZ5rVg9ltHXbwyZolCXHdXcxmEXPANZeWq5aCsZrN1iq/sa05mLZwQMRu/PCBFRcpwsB3u
        9nxP4tCR5U9Vp2iowEfYq/89hQp9GeyDH74PDtlQbZc8ZW54JObpESALTg8+N9k+oNVirfOtM2WJ0
        Yp9p0LdA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jIy7E-0005n4-7Q; Mon, 30 Mar 2020 17:22:24 +0000
Subject: Re: linux-next: Tree for Mar 30 (vhost)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20200330204307.669bbb4d@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <347c851a-b9f6-0046-f6c8-1db0b42be213@infradead.org>
Date:   Mon, 30 Mar 2020 10:22:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330204307.669bbb4d@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/20 2:43 AM, Stephen Rothwell wrote:
> Hi all,
> 
> The merge window has opened, so please do not add any material for the
> next release into your linux-next included trees/branches until after
> the merge window closes.
> 
> Changes since 20200327:
> 
> The vhost tree gained a conflict against the kvm-arm tree.
> 

(note: today's linux-next is on 5.6-rc7.)

on x86_64:

# CONFIG_EVENTFD is not set

../drivers/vhost/vhost.c: In function 'vhost_vring_ioctl':
../drivers/vhost/vhost.c:1577:33: error: implicit declaration of function 'eventfd_fget'; did you mean 'eventfd_signal'? [-Werror=implicit-function-declaration]
   eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
                                 ^~~~~~~~~~~~
                                 eventfd_signal
../drivers/vhost/vhost.c:1577:31: warning: pointer/integer type mismatch in conditional expression
   eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
                               ^

-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
