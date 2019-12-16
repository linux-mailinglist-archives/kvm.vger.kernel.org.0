Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6471203D0
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 12:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfLPLYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 06:24:42 -0500
Received: from isilmar-4.linta.de ([136.243.71.142]:49676 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfLPLYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 06:24:00 -0500
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from light.dominikbrodowski.net (brodo.linta [10.1.0.102])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 165DF200A62;
        Mon, 16 Dec 2019 11:23:58 +0000 (UTC)
Received: by light.dominikbrodowski.net (Postfix, from userid 1000)
        id 7AEA020BC9; Mon, 16 Dec 2019 11:53:38 +0100 (CET)
Date:   Mon, 16 Dec 2019 11:53:38 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mainline-5.5.0-rc1: do_mount_root+0x6c/0x10d - kernel crash
 while mounting rootfs
Message-ID: <20191216105338.GA163642@light.dominikbrodowski.net>
References: <CA+G9fYuO7vMjsqkyXHZSU-pKEk0L0t9kQTfnd5xopVADyGwprw@mail.gmail.com>
 <CAK8P3a38ZhQcA0Vj-EtNzmH7+iuoOhPrQUzN-avxJn9iU2K5=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a38ZhQcA0Vj-EtNzmH7+iuoOhPrQUzN-avxJn9iU2K5=Q@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 11:22:04AM +0100, Arnd Bergmann wrote:
> On Mon, Dec 16, 2019 at 10:15 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > The following kernel crash reported on qemu_x86_64 boot running
> > 5.5.0-rc1 mainline kernel.
> 
> I looked for too long at v5.5-rc1 completely puzzled by how you got to this
> object code before realizing that this is a git snapshot between -rc1 and -rc2.
> 
> The code in question was changed by a recent series from Dominik Brodowski,
> the main difference being commit cccaa5e33525 ("init: use do_mount() instead
> of ksys_mount()").
> 
> It looks like the NULL-check in ksys_mount()/copy_mount_options() is missing
> from the new mount_block_root, so it passes a NULL pointer into strncpy().
> 
> Something like this should fix it (not tested):

This equivalent patch by Linus already got some testing:

https://lore.kernel.org/lkml/CAHk-=wh8VLe3AEKhz=1bzSO=1fv4EM71EhufxuC=Gp=+bLhXoA@mail.gmail.com/

Thanks,
	Dominik
