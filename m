Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7253F2AADA0
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 22:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgKHVSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 16:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHVSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 16:18:15 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E4BC0613CF;
        Sun,  8 Nov 2020 13:18:15 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604870291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WLr6jSvCYWuNA0ltbN0LGAoOd+LlXioZ9NtNTF1g6Q8=;
        b=LsVEhYlyqxlkC9Fj/a5ogNdP4GBaq7NgJaRBgD+F8LKyL/eUXB24hoEoRXxcfp8yJH3xl+
        y3kgvoAUAxmMAj0o4uNN1bf3dP7NsTBzZx6+wAtqkOLf9GFxZj8q0tlgnWOvA85AgZUOSF
        eBNeYPr5/SO45fI74YNQvKurKx45i2EuqOm+epEl6Wn2x50RCuc0tyv23+v1TkAkO/mImM
        Q+lIILRqqC7gFlcrAj7wP9JNtc9BQY3A/+eoaQmE+6IqoLDdfGXVT9WnI+QjtccfSvK1qa
        xVbwYJezU4UwPGLFtICxpvq0CccXhvP/H/837ckI3XbCMjvMpLrRC/DxYGashw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604870291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WLr6jSvCYWuNA0ltbN0LGAoOd+LlXioZ9NtNTF1g6Q8=;
        b=iXtAMBL5+7mmU80vLPpJBjYUaK92bfGd8UDxruSkd6KVFY2LsbxjTWXRf7eNk6v11hLS3c
        sZs/oIqKTY4RRuAg==
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>
Cc:     "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "jing.lin\@intel.com" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201106131415.GT2620339@nvidia.com>
References: <20201030224534.GN2620339@nvidia.com> <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com> <20201102132158.GA3352700@nvidia.com> <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com> <20201103124351.GM2620339@nvidia.com> <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104124017.GW2620339@nvidia.com> <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201106131415.GT2620339@nvidia.com>
Date:   Sun, 08 Nov 2020 22:18:11 +0100
Message-ID: <87k0uvk0oc.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 06 2020 at 09:14, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2020 at 09:48:34AM +0000, Tian, Kevin wrote:
> For instance you could put a "disable IMS" flag in the ACPI tables, in
> the config space of the emuulated root port, or any other areas that
> clearly belong to the platform.
>
> The OS logic would be
>  - If no IMS information found then use IMS (Bare metal)
>  - If the IMS disable flag is found then
>    - If (future) hypercall available and the OS knows how to use it
>      then use IMS
>    - If no hypercall found, or no OS knowledge, fail IMS

That does not work because an older hypervisor would not have that
disable flag and the guest kernel would assume to be on bare metal (if
no other indicators are there).

Thanks

        tglx
