Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F902A3406
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 20:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgKBT0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 14:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgKBT0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 14:26:16 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E3AC061A48
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 11:26:15 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id t11so15412686edj.13
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 11:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDQNhKPGqjVJkXRCCnTVmPBDzTBDoFvxQkjWFChUq7c=;
        b=aMgw8zK7rCA1KVq/MU6bOhsU0tEut11yFI1PHpIrmQ1GvsyRa9VonG09yyX73f6HFX
         HvILR0dwvJqrEQPwXRQSeL3U7QrGrbMngjrUVa87Dl0gNjHxwt63h/kA5UhJa4e9aPmx
         de83lguI6lttJSqM1C9UXADtdbhALyf3QFFwmqKS9RE4j7QL536YGCM34TLz9gabbXcL
         27liIuYANcsTRoln+q4tcxnnRxBRpUhaWSv1/MfeMVEgTZTOkJty4FQZm9fXjZO/bwu3
         H1y+cFvspb6VrYE5RXH/oJC61UtBIo3YJxKJAKjRE6RmwOm2fP/dgV4XRsHhfmh7lzNJ
         BD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDQNhKPGqjVJkXRCCnTVmPBDzTBDoFvxQkjWFChUq7c=;
        b=cmIDuygy4D/YoPXFXB8hDRNEA8uGvU6oVvsdYmTK8B3BhTVTIVpakzxb6JNab+v+Ze
         7K9Al8OXt38SIkq5HR2J8JPGjDPHvdkbJHhguwrhEyk2xffQpXyFUw19KcGmcJOJdV8H
         5hnysRetL4uhuN4z39jj0Xs6YRYVCKTrimYg8v+bwNc92HAR3Oq182PnbU7uAJprpBvH
         wJDe7x41Fcitmz5APN2ZoNptEz5IB4sbsBvUjFYSW3KLImwueerxJ95VKreNnnjaNcOo
         MuNkcg/DCUHE1znXYdhi3nHxzduVzBO6CgmmVVp3PZNr4DoPWK5XL3iMSquhSvNXEPo3
         uRUQ==
X-Gm-Message-State: AOAM533+qe0NxqyGk9rWsgtZVAO608m2JESPe78McVppD7dii6yFdHjU
        pGCPOCMKDqcvjlNI1tcIoHkjGbEvqGUykwP4OMW59w==
X-Google-Smtp-Source: ABdhPJw7aq66qJvui6hJLPrXF7b2G+hIyn689UWesfAkpS5Y1kYqfJinaHs863DkeMqRZOD0NON5Ehn/1jAOw7ApiTY=
X-Received: by 2002:aa7:cc84:: with SMTP id p4mr17722087edt.97.1604345174437;
 Mon, 02 Nov 2020 11:26:14 -0800 (PST)
MIME-Version: 1.0
References: <20201030193045.GM2620339@nvidia.com> <20201030204307.GA683@otc-nc-03>
 <87h7qbkt18.fsf@nanos.tec.linutronix.de> <20201031235359.GA23878@araj-mobl1.jf.intel.com>
 <20201102132036.GX2620339@nvidia.com> <20201102162043.GB20783@otc-nc-03>
 <20201102171909.GF2620339@nvidia.com> <20d7c5fc-91b0-d673-d41a-335d91ca2dce@intel.com>
 <20201102182632.GH2620339@nvidia.com> <CAPcyv4h8O+boTo-MpGRSC8RpjrsvU-P3AU7_kwbrfDkEp8bH1w@mail.gmail.com>
 <20201102185130.GB3600342@nvidia.com>
In-Reply-To: <20201102185130.GB3600342@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 2 Nov 2020 11:26:01 -0800
Message-ID: <CAPcyv4jGrvkwjZG+qiu0VGU9ifj95t0Yi7ripJEtZr+_kVrWog@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dave Jiang <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>, maz@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Yi L Liu <yi.l.liu@intel.com>, Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        kwankhede@nvidia.com, eric.auger@redhat.com,
        Parav Pandit <parav@mellanox.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Mona Hossain <mona.hossain@intel.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 2, 2020 at 10:52 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Mon, Nov 02, 2020 at 10:38:28AM -0800, Dan Williams wrote:
>
> > > I think you will be the first to use the namespace stuff for this, it
> > > seems like a good idea and others should probably do so as well.
> >
> > I was thinking either EXPORT_SYMBOL_NS, or auxiliary bus, because you
> > should be able to export an ops structure with all the necessary
> > callbacks.
>
> 'or'?
>
> Auxiliary bus should not be used with huge arrays of function
> pointers... The module providing the device should export a normal
> linkable function interface. Putting that in a namespace makes a lot
> of sense.

True, probably needs to be a mixture of both.
