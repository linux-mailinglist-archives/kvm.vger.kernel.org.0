Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D387241921
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 11:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgHKJxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 05:53:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56888 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgHKJxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 05:53:35 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597139612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=34NxuTHuuaxlTrp0QBpYwXdJxhoYhWgkXsT79ACXhBI=;
        b=yXFv45j/NkN12I89hPKrRRt3y6IsbXp2z30BW9LR1+SIMEFThp1pdeaQ4LM9L9tiAa69no
        OxF24BGPWPyOplVt5AYdHm0lzBQPC7WqiZBg7GprfATjSKTVoHqu7aZNMhwmN8VMuE7VzF
        PU4DBYxA9+atj4AOLidlBQ71941w/45ny6a9eL9yMvPKZHRm08ocVrwOr4tN6lc2EbCfi2
        dFobLLI83Tl6TLwvgx01ezVcJ6H2SRevkfo3LB4VAsKYpsUY5bPf3nqv2pfT6ZqSxqVVCZ
        MUc+cyl80tzreWSxW2glFKK9WZ4rsz6Zwwl0yY+5FvSLfHBKxEcOyFg3+KRE+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597139612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=34NxuTHuuaxlTrp0QBpYwXdJxhoYhWgkXsT79ACXhBI=;
        b=neMWOMBKOlsGBQxKGobT2vLvpDelklSE+tFhByonXtY94FggYvZ0ZvmMgZA35XKqEp1WwM
        Hbwv0AiwaKv3KDAA==
To:     "Dey\, Megha" <megha.dey@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Lin\, Jing" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "Hansen\, Dave" <dave.hansen@intel.com>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <87ft8uxjga.fsf@nanos>
References: <87h7tcgbs2.fsf@nanos.tec.linutronix.de> <87ft8uxjga.fsf@nanos>
Date:   Tue, 11 Aug 2020 11:53:31 +0200
Message-ID: <87d03x5x0k.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

CC+: XEN folks

> Thomas Gleixner <tglx@linutronix.de> writes:
>> The infrastructure itself is not more than a thin wrapper around the
>> existing msi domain infrastructure and might even share code with
>> platform-msi.
>
> And the annoying fact that you need XEN support which opens another can
> of worms...

which needs some real cleanup first.

x86 still does not associate the irq domain to devices at device
discovery time, i.e. the device::msi_domain pointer is never populated.

So to support this new fangled device MSI stuff we'd need yet more
x86/xen specific arch_*msi_irqs() indirection and hackery, which is not
going to happen.

The right thing to do is to convert XEN MSI support over to proper irq
domains. This allows to populate device::msi_domain which makes a lot of
things simpler and also more consistent.

Thanks,

        tglx
