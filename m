Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985BE30DC1E
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhBCOCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbhBCOBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 09:01:15 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41FEC0613D6
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 06:00:34 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id e15so13284108lft.13
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 06:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=fLQZEjeTPuypx7HQGPrDOBJQe4gkG920pRzfTXlQATw=;
        b=X7Y0sJBeHotlK0Uw1aVosGmcRQw4jfWP0J+9twVI6fN+0xc2jlplK/vwrVq4voqhPE
         3uegjz+9kUuVrSTsVlaDQx6P82z0k9q3x1CBSpFkTuGTcPDoy6a/zL0bVNPZVdoq9vat
         5Ly2OYqrG1/8gTJYCIDstsR2eiceNRvAxY92dkoRjnKDLBRQ+QNussN26Cau48feJRJH
         6gMpJ1facNYafN3gDr83Lk5pELb7KMa79XfCZC236XExyEwDFPglzLI88AdH8wIdQPM/
         bml10K2nWPRm+E4pmMwK33ZhuFoFptY9ygjPB7uKd1ySc/cculMBkT16oZXsYYfYnwbB
         SrYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fLQZEjeTPuypx7HQGPrDOBJQe4gkG920pRzfTXlQATw=;
        b=XPx2TocSbaSRDNWPKuAg/3djsTWFGn2cRf/5ZVFLUAf7qkNeIQcMwqinaBCyOge1aX
         VCam49GcBa4fNS45oZRX0o9tib9WFD3r/LwMKPvr2izWTf25V6x15rch9itpNhw4VJM/
         oqnNS9LeMvizDJ7+vK8zC6HvP/wpWlGGpoF8Um8KW1+xHFN3yGscOIWNE9E0wbQ+ddSi
         gauAb1viKOCdfq6FE0mgUjr0eaXg5Y6vV2zU8vKOFx01q+IY9ky+B/CeSDiVcyrTutK8
         c9sKn+C4PmzloHFpGcWd8J1UxONAYmz5frI6GHCr24EwRTclaimM/p1zU8jMIo0Lou9k
         cqQg==
X-Gm-Message-State: AOAM531reGJuzSgSPTtl/gxxD9MkT4pf7LL73i9nIcAgLC0SKkNzJBmS
        KsDq2bOp7fuzIBPmAw4OA5I=
X-Google-Smtp-Source: ABdhPJxS6sG1ncmYhnzmrOk9gmlIZaF2tuCUA9V6CjUC+9eDQKAmJ7kgMgVkCiGfwNmseqaTi5gEZA==
X-Received: by 2002:ac2:44da:: with SMTP id d26mr1837801lfm.306.1612360832984;
        Wed, 03 Feb 2021 06:00:32 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id y7sm252683lfy.39.2021.02.03.06.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:00:32 -0800 (PST)
Message-ID: <43561304f4c05ddb052d7c587708343534774191.camel@gmail.com>
Subject: Re: [RFC v2 2/4] KVM: x86: add support for ioregionfd signal
 handling
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Date:   Wed, 03 Feb 2021 06:00:20 -0800
In-Reply-To: <20210130165859.GC98016@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
         <aa049c6e5bade3565c5ffa820bbbb67bd5d1bf4b.1611850291.git.eafanasova@gmail.com>
         <20210130165859.GC98016@stefanha-x1.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2021-01-30 at 16:58 +0000, Stefan Hajnoczi wrote:
> On Thu, Jan 28, 2021 at 09:32:21PM +0300, Elena Afanasova wrote:
> > The vCPU thread may receive a signal during ioregionfd
> > communication,
> > ioctl(KVM_RUN) needs to return to userspace and then ioctl(KVM_RUN)
> > must resume ioregionfd.
> > 
> > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > ---
> > Changes in v2:
> >   - add support for x86 signal handling
> >   - changes after code review
> > 
> >  arch/x86/kvm/x86.c            | 196
> > +++++++++++++++++++++++++++++++---
> >  include/linux/kvm_host.h      |  13 +++
> >  include/uapi/linux/ioregion.h |  32 ++++++
> >  virt/kvm/ioregion.c           | 177 +++++++++++++++++++++++++++++-
> >  virt/kvm/kvm_main.c           |  16 ++-
> >  5 files changed, 415 insertions(+), 19 deletions(-)
> >  create mode 100644 include/uapi/linux/ioregion.h
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ddb28f5ca252..a04516b531da 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5799,19 +5799,33 @@ static int vcpu_mmio_write(struct kvm_vcpu
> > *vcpu, gpa_t addr, int len,
> >  {
> >  	int handled = 0;
> >  	int n;
> > +	int ret = 0;
> > +	bool is_apic;
> >  
> >  	do {
> >  		n = min(len, 8);
> > -		if (!(lapic_in_kernel(vcpu) &&
> > -		      !kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev,
> > addr, n, v))
> > -		    && kvm_io_bus_write(vcpu, KVM_MMIO_BUS, addr, n,
> > v))
> > -			break;
> > +		is_apic = lapic_in_kernel(vcpu) &&
> > +			  !kvm_iodevice_write(vcpu, &vcpu->arch.apic-
> > >dev,
> > +					      addr, n, v);
> > +		if (!is_apic) {
> > +			ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
> > +					       addr, n, v);
> > +			if (ret)
> > +				break;
> > +		}
> >  		handled += n;
> >  		addr += n;
> >  		len -= n;
> >  		v += n;
> >  	} while (len);
> >  
> > +#ifdef CONFIG_KVM_IOREGION
> > +	if (ret == -EINTR) {
> > +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> > +		++vcpu->stat.signal_exits;
> > +	}
> > +#endif
> > +
> >  	return handled;
> >  }
> 
> There is a special case for crossing page boundaries:
> 1. ioregion in the first 4 bytes (page 1) but not the second 4 bytes
> (page 2).
> 2. ioregion in the second 4 bytes (page 2) but not the first 4 bytes
> (page 1).
> 3. The first 4 bytes (page 1) in one ioregion and the second 4 bytes
> (page 2) in another ioregion.
> 4. The first 4 bytes (page 1) in one ioregion and the second 4 bytes
> (page 2) in the same ioregion.
> 
> Cases 3 and 4 are tricky. If I'm reading the code correctly we try
> ioregion accesses twice, even if the first one returns -EINTR?
> 
Yes, in the case of crossing a page boundary
emulator_read_write_onepage() will be called twice. This case isn’t
supported in the current code. Also I think that synchronization code
for vcpu_mmio_write/read() is wrong. Probably
kvm_io_bus_prepare/finish() should be called for every
kvm_io_bus_read/write(). I'll try to fix that.

> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 7cd667dddba9..5cfdecfca6db 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -318,6 +318,19 @@ struct kvm_vcpu {
> >  #endif
> >  	bool preempted;
> >  	bool ready;
> > +#ifdef CONFIG_KVM_IOREGION
> > +	bool ioregion_interrupted;
> 
> Can this field move into ioregion_ctx?
> 
Yes

> > +	struct {
> > +		struct kvm_io_device *dev;
> > +		int pio;
> > +		void *val;
> > +		u8 state;
> > +		u64 addr;
> > +		int len;
> > +		u64 data;
> > +		bool in;
> > +	} ioregion_ctx;
> 
> This struct can be reordered to remove holes between fields.
> 
Ok, will do

> > +#endif
> >  	struct kvm_vcpu_arch arch;
> >  };
> >  
> > diff --git a/include/uapi/linux/ioregion.h
> > b/include/uapi/linux/ioregion.h
> > new file mode 100644
> > index 000000000000..7898c01f84a1
> > --- /dev/null
> > +++ b/include/uapi/linux/ioregion.h
> > @@ -0,0 +1,32 @@
> > +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> 
> To encourage people to implement the wire protocol even beyond the
> Linux
> syscall environment (e.g. in other hypervisors and VMMs) you could
> make
> the license more permissive:
> 
>   /* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) 
> OR BSD-3-Clause) */
> 
> Several other <linux/*.h> files do this so that the header can be
> used
> outside Linux without license concerns.
> 
> Here is the BSD 3-Clause license:
> https://opensource.org/licenses/BSD-3-Clause
> 
> > +#ifndef _UAPI_LINUX_IOREGION_H
> > +#define _UAPI_LINUX_IOREGION_H
> 
> Please add the wire protocol specification/documentation into this
> file.
> That way this header file will serve as a comprehensive reference for
> the protocol and changes to the header will also update the
> documentation.
> 
> (The ioctl KVM_SET_IOREGIONFD parts belong in
> Documentation/virt/kvm/api.rst but the wire protocol should be in
> this
> header file instead.)
> 
Ok

> > +
> > +/* Wire protocol */
> > +struct ioregionfd_cmd {
> > +	__u32 info;
> > +	__u32 padding;
> > +	__u64 user_data;
> > +	__u64 offset;
> > +	__u64 data;
> > +};
> > +
> > +struct ioregionfd_resp {
> > +	__u64 data;
> > +	__u8 pad[24];
> > +};
> > +
> > +#define IOREGIONFD_CMD_READ    0
> > +#define IOREGIONFD_CMD_WRITE   1
> > +
> > +#define IOREGIONFD_SIZE_8BIT   0
> > +#define IOREGIONFD_SIZE_16BIT  1
> > +#define IOREGIONFD_SIZE_32BIT  2
> > +#define IOREGIONFD_SIZE_64BIT  3
> 
> It's possible that larger read/write operations will be needed in the
> future. For example, the PCI Express bus supports much larger
> transactions than just 64 bits.
> 
> You don't need to address this right now but I wanted to mention it.
> 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 88b92fc3da51..df387857f51f 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4193,6 +4193,7 @@ static int __kvm_io_bus_write(struct kvm_vcpu
> > *vcpu, struct kvm_io_bus *bus,
> >  			      struct kvm_io_range *range, const void
> > *val)
> >  {
> >  	int idx;
> > +	int ret = 0;
> >  
> >  	idx = kvm_io_bus_get_first_dev(bus, range->addr, range->len);
> >  	if (idx < 0)
> > @@ -4200,9 +4201,12 @@ static int __kvm_io_bus_write(struct
> > kvm_vcpu *vcpu, struct kvm_io_bus *bus,
> >  
> >  	while (idx < bus->dev_count &&
> >  		kvm_io_bus_cmp(range, &bus->range[idx]) == 0) {
> > -		if (!kvm_iodevice_write(vcpu, bus->range[idx].dev,
> > range->addr,
> > -					range->len, val))
> > +		ret = kvm_iodevice_write(vcpu, bus->range[idx].dev,
> > range->addr,
> > +					 range->len, val);
> > +		if (!ret)
> >  			return idx;
> > +		if (ret < 0 && ret != -EOPNOTSUPP)
> > +			return ret;
> 
> I audited all kvm_io_bus_read/write() callers to check that it's safe
> to
> add error return values besides -EOPNOTSUPP. Extending the meaning of
> the return value is fine but any arches that want to support
> ioregionfd
> need to explicitly handle -EINTR return values now. Only x86 does
> after
> this patch.

