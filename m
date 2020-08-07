Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6323E98D
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHGIsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:48:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35086 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgHGIsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:48:30 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596790107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MBF7RuxtgMye0FeTHS4/I2QgvfUn5rqfABUW3RbrEFA=;
        b=U9oLfO4Fm3GXtP9BGZ1UlYHmiESlcNyJleCppysP/SHrBFitqdd0yWg5QWy6rVoVQHZYBx
        SwZYMagWZTS18JVVzhhb8jtFjuE0vhrpwiE1LKhh1SDn2dqIdOkvLEY4HoO9MbWCpLtmN8
        /y8VkMj+kWOwMyHVOmAj/BSPK7PcgZ3pGxvTyzdjWLWgQBmeNvw4zxK6diPigqWiut2kMn
        tPVOed3oAlGL29ApZ2fsPZMPgarDxRy1Xovohoab6Dro/s+X4bJel+7AzG767hGGNeOweY
        MCwDc2D1qLXzcFnau+d7gYDQAUZOAEfWyhz16VP3x5uCDmC3/RpU1SqXnT5Pxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596790107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MBF7RuxtgMye0FeTHS4/I2QgvfUn5rqfABUW3RbrEFA=;
        b=45PXI7tN0bIu6GaA71iC+tzQwVOKfU7CU4tMg5Aau4ktHfZWtUjjvlZGw8aPKO2mKPNek9
        Sxjhsd+t5bh6REDA==
To:     "Dey\, Megha" <megha.dey@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <78a0cdd6-ba05-e153-b25e-2c0fe8c1e7b9@intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com> <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com> <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com> <96a1eb5ccc724790b5404a642583919d@intel.com> <20200805221548.GK19097@mellanox.com> <70465fd3a7ae428a82e19f98daa779e8@intel.com> <20200805225330.GL19097@mellanox.com> <630e6a4dc17b49aba32675377f5a50e0@intel.com> <20200806001927.GM19097@mellanox.com> <c6a1c065ab9b46bbaf9f5713462085a5@intel.com> <87tuxfhf9u.fsf@nanos.tec.linutronix.de> <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com> <87h7tfh6fc.fsf@nanos.tec.linutronix.de> <78a0cdd6-ba05-e153-b25e-2c0fe8c1e7b9@intel.com>
Date:   Fri, 07 Aug 2020 10:48:26 +0200
Message-ID: <87364yhmed.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Megha,

"Dey, Megha" <megha.dey@intel.com> writes:
> On 8/6/2020 1:21 PM, Thomas Gleixner wrote:
>> If you expect or know that there are other devices coming up with IMS
>> integrated then most of that code can be made a common library. But for
>> this to make sense, you really want to make sure that these other
>> devices do not require yet another horrible layer of indirection.
>
> Yes Thomas, for now this may look odd since there is only one device
> using this IRQ domain. But there will be other devices following suit,
> hence I have added all the IRQ chip/domain bits in a separate file in
> drivers/irqchip in the next version of patches. I'll submit the
> patches shortly and it will be great if I can get more feedback on it.

Again. The common domain makes only sense if it provides actual
functionality and resource management at the domain level. The IMS slot
management CANNOT happen at the common domain level simply because IMS
is strictly per device. So your "common" domain is just a shim layer
which pretends to be common and requires warts at the side to do the IMS
management at the device level.

Let's see what you came up with this time :)

>> A side note: I just read back on the specification and stumbled over
>> the following gem:
>>
>>   "IMS may also optionally support per-message masking and pending bit
>>    status, similar to the per-vector mask and pending bit array in the
>>    PCI Express MSI-X capability."
>>
>> Optionally? Please tell the hardware folks to make this mandatory. We
>> have enough pain with non maskable MSI interrupts already so introducing
>> yet another non maskable interrupt trainwreck is not an option.
>>
>> It's more than a decade now that I tell HW people not to repeat the
>> non-maskable MSI failure, but obviously they still think that
>> non-maskable interrupts are a brilliant idea. I know that HW folks
>> believe that everything they omit can be fixed in software, but they
>> have to finally understand that this particular issue _cannot_ be fixed
>> at all.
>
> hmm, I asked the hardware folks and they have informed me that all IMS
> devices will support per vector masking/pending bit. This will be
> updated in the next SIOV spec which will be published soon.

I seriously hope so...

Thanks,

        tglx
