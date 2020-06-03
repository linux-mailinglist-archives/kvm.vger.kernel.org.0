Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80F61EC997
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 08:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgFCGfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 02:35:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52097 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725883AbgFCGfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 02:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591166102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2vN8Dw/qz4vI/EzjgMHSYDUd1pSEefI0GYoGuUtsDQ=;
        b=agxrwNfj7/mPjkklCLuU28p92rZTzh+MxqERBaaBdRtV/RvprXCHqhppX4xwyv8B04oD4C
        57yyUAOB4NYSQT6+zm6exZicvgQxcUMgjhWvQvTijes558h16ZKeLJGlZLviD64ofS4120
        ts9VTBDNwqxnB9qoxzEvuKLLNlIDV+Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-W_jnw5j7N3ea5lmDvHeALg-1; Wed, 03 Jun 2020 02:35:00 -0400
X-MC-Unique: W_jnw5j7N3ea5lmDvHeALg-1
Received: by mail-wr1-f69.google.com with SMTP id h6so676710wrx.4
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 23:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=B2vN8Dw/qz4vI/EzjgMHSYDUd1pSEefI0GYoGuUtsDQ=;
        b=siPNSWl8glQsjFLmLmSAuk8HcJHArY4CAQBHF4nv81pR7PztGihd2vV776xQu+jvrB
         EGgOItayAkwlR/+4zJohQe301dhr5h0Kpdmp68FuzVfgcX/3NxNe4K9AuKGCpCc6JGy0
         5YW86WFOT1/XG/M+jnnkj8/hrkxGxoB8ETXZEuMdy7oqdNKUmtoUD9avzo+Ln7vPsC/9
         jlbkTLP2rPwg6rBLt0N/kY6D6Gs8BDHZEk/tY+p32DXvgeggsa7xbcmH3tLwEml2LAza
         Ec/1P1/4q6bKAwEaBYyNyp3W4N/DttQ3w3sx75clkAfYy8bLrJ5F5px83+JiJeTx7ht/
         zySA==
X-Gm-Message-State: AOAM5312hdBTzjUEKg+eMvrKoUblccsLfl6ZMTYwuRrgVIeooUd+B0IA
        Szs4j2bCuDZ7/W/OPJ0cks9j36vs2jaa+QeW7ISEMXU/r8FEwy102NJNROk8ceJ9Ot1oBIQwZ0f
        jj6yavBSE8KMm
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr2298373wrw.225.1591166098334;
        Tue, 02 Jun 2020 23:34:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxI/UQ1e2IEFfNgnSn57m0Bfm86YlMkYesjj021UABMgsR+tPWUtN6rPFfKqgucl2vmU6mZTg==
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr2298360wrw.225.1591166098131;
        Tue, 02 Jun 2020 23:34:58 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id z16sm1734703wrm.70.2020.06.02.23.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 23:34:57 -0700 (PDT)
Date:   Wed, 3 Jun 2020 02:34:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com
Subject: Re: [PATCH 4/6] vhost_vdpa: support doorbell mapping via mmap
Message-ID: <20200603023429-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-5-jasowang@redhat.com>
 <202006020308.kLXTHt4n%lkp@intel.com>
 <20200602005007-mutt-send-email-mst@kernel.org>
 <bd7dde11-b726-ee08-4e80-71fb784fa549@redhat.com>
 <20200602093025-mutt-send-email-mst@kernel.org>
 <5db6b413-cb6c-a566-2f2d-ad580d8e165b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5db6b413-cb6c-a566-2f2d-ad580d8e165b@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 03, 2020 at 12:18:44PM +0800, Jason Wang wrote:
> 
> On 2020/6/2 下午9:31, Michael S. Tsirkin wrote:
> > On Tue, Jun 02, 2020 at 02:49:38PM +0800, Jason Wang wrote:
> > > On 2020/6/2 下午12:56, Michael S. Tsirkin wrote:
> > > > On Tue, Jun 02, 2020 at 03:22:49AM +0800, kbuild test robot wrote:
> > > > > Hi Jason,
> > > > > 
> > > > > I love your patch! Yet something to improve:
> > > > > 
> > > > > [auto build test ERROR on vhost/linux-next]
> > > > > [also build test ERROR on linus/master v5.7 next-20200529]
> > > > > [if your patch is applied to the wrong git tree, please drop us a note to help
> > > > > improve the system. BTW, we also suggest to use '--base' option to specify the
> > > > > base tree in git format-patch, please seehttps://stackoverflow.com/a/37406982]
> > > > > 
> > > > > url:https://github.com/0day-ci/linux/commits/Jason-Wang/vDPA-doorbell-mapping/20200531-070834
> > > > > base:https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git  linux-next
> > > > > config: m68k-randconfig-r011-20200601 (attached as .config)
> > > > > compiler: m68k-linux-gcc (GCC) 9.3.0
> > > > > reproduce (this is a W=1 build):
> > > > >           wgethttps://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
> > > > >           chmod +x ~/bin/make.cross
> > > > >           # save the attached .config to linux build tree
> > > > >           COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k
> > > > > 
> > > > > If you fix the issue, kindly add following tag as appropriate
> > > > > Reported-by: kbuild test robot<lkp@intel.com>
> > > > > 
> > > > > All errors (new ones prefixed by >>, old ones prefixed by <<):
> > > > > 
> > > > > drivers/vhost/vdpa.c: In function 'vhost_vdpa_fault':
> > > > > > > drivers/vhost/vdpa.c:754:22: error: implicit declaration of function 'pgprot_noncached' [-Werror=implicit-function-declaration]
> > > > > 754 |  vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > > > > |                      ^~~~~~~~~~~~~~~~
> > > > > > > drivers/vhost/vdpa.c:754:22: error: incompatible types when assigning to type 'pgprot_t' {aka 'struct <anonymous>'} from type 'int'
> > > > > cc1: some warnings being treated as errors
> > > > > 
> > > > > vim +/pgprot_noncached +754 drivers/vhost/vdpa.c
> > > > > 
> > > > >      742	
> > > > >      743	static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
> > > > >      744	{
> > > > >      745		struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
> > > > >      746		struct vdpa_device *vdpa = v->vdpa;
> > > > >      747		const struct vdpa_config_ops *ops = vdpa->config;
> > > > >      748		struct vdpa_notification_area notify;
> > > > >      749		struct vm_area_struct *vma = vmf->vma;
> > > > >      750		u16 index = vma->vm_pgoff;
> > > > >      751	
> > > > >      752		notify = ops->get_vq_notification(vdpa, index);
> > > > >      753	
> > > > >    > 754		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > > > >      755		if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
> > > > >      756				    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
> > > > >      757				    vma->vm_page_prot))
> > > > >      758			return VM_FAULT_SIGBUS;
> > > > >      759	
> > > > >      760		return VM_FAULT_NOPAGE;
> > > > >      761	}
> > > > >      762	
> > > > Yes well, all this remapping clearly has no chance to work
> > > > on systems without CONFIG_MMU.
> > > 
> > > It looks to me mmap can work according to Documentation/nommu-mmap.txt. But
> > > I'm not sure it's worth to bother.
> > > 
> > > Thanks
> > 
> > Well
> > 
> > int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
> >                  unsigned long pfn, unsigned long size, pgprot_t prot)
> > {
> >          if (addr != (pfn << PAGE_SHIFT))
> >                  return -EINVAL;
> > 
> >          vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
> >          return 0;
> > }
> > EXPORT_SYMBOL(remap_pfn_range);
> > 
> > 
> > So things aren't going to work if you have a fixed PFN
> > which is the case of the hardware device.
> 
> 
> Looking at the implementation of some drivers e.g mtd_char. If I read the
> code correctly, we can do this by providing get_unmapped_area method and use
> physical address directly.
> 
> But start form CONFIG_MMU should be fine.  Do you prefer making vhost_vdpa
> depends on CONFIG_MMU or just fail mmap when CONFIG_MMU is not configured?
> 
> Thanks

I'd just not specify the mmap callback at all.

> 
> > 
> > 
> > > > 
> > > > 

