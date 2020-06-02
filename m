Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39561EBD1B
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 15:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgFBNbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 09:31:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60194 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgFBNbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 09:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591104693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b3UuSFOoTLf1u64HrlCpEbdeT2AgnRILXvuyVUe6Wag=;
        b=O/lPGxAVqryrY1cddeIh0gQ8Z25S7Po10omjMl7m+K4LDC9iTF5wZVGz13BUk/dDf2kal1
        9h1yycWV8HSnmUzX/gP0vvLPWSpIx45RCxdom4zGwksmr8SQv3Jq+S5TMfCwOFr/ou7eXQ
        qVVM96LYAdEzdwuzL7vDYnJLUFwZNOc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-XlBEyJINO4mJuPoI3P1Ftw-1; Tue, 02 Jun 2020 09:31:22 -0400
X-MC-Unique: XlBEyJINO4mJuPoI3P1Ftw-1
Received: by mail-wr1-f72.google.com with SMTP id l1so1399725wrc.8
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 06:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b3UuSFOoTLf1u64HrlCpEbdeT2AgnRILXvuyVUe6Wag=;
        b=bZ4J18VKA+2Gb+46qZfTOKsd3YgCG/z1/LRTrwuDvBCUgDR6fg8rDBDlwSP0uHmeLb
         C9rea8ngt9wJPJkg8sWIomjCloIybdVkwP4Hy6hN2pdK5IsWx3iMO4LHxwaQP9DwQ2PO
         b5OdWTbcLmJhglo0HLcFvZnXX1Yaa4b3tOnvYqsfbEDi5591vjHlz3CZHuVTr5Los9v+
         426u6EG6uvhW+7gtGWTWzCzB4V6IaPC/f6urYJLOgmZymssfkek8qGPpEc7nmMcpb+CY
         TSCTtww2fYN0RLUXl5VFMlr10nAsUWeRyGYnyaXF+vI0GEP8VEsrs3gazk1hckUwK24I
         3ejA==
X-Gm-Message-State: AOAM532SwVSavCsDblVGRe/RNrJrizWDxflYb2MAytj5M9nNVGZBVY6V
        AdEgfV4onOztLTVQrj2bcYPimn7qzvY4s6fKtDYZTgdgQuZRN166aWHVVPLIvJa2rsZ8sZNTbHc
        uOs5Zq6O7VVMw
X-Received: by 2002:adf:ecce:: with SMTP id s14mr14789310wro.154.1591104680988;
        Tue, 02 Jun 2020 06:31:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhzCp7N+xdkukbytg74zX2M6EFznyG8/VyZ15EbaVCa6fcCkeslvcsieleP04VZHHIBXLV0w==
X-Received: by 2002:adf:ecce:: with SMTP id s14mr14789293wro.154.1591104680670;
        Tue, 02 Jun 2020 06:31:20 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id n204sm3972286wma.5.2020.06.02.06.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:31:19 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:31:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com
Subject: Re: [PATCH 4/6] vhost_vdpa: support doorbell mapping via mmap
Message-ID: <20200602093025-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-5-jasowang@redhat.com>
 <202006020308.kLXTHt4n%lkp@intel.com>
 <20200602005007-mutt-send-email-mst@kernel.org>
 <bd7dde11-b726-ee08-4e80-71fb784fa549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd7dde11-b726-ee08-4e80-71fb784fa549@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 02, 2020 at 02:49:38PM +0800, Jason Wang wrote:
> 
> On 2020/6/2 下午12:56, Michael S. Tsirkin wrote:
> > On Tue, Jun 02, 2020 at 03:22:49AM +0800, kbuild test robot wrote:
> > > Hi Jason,
> > > 
> > > I love your patch! Yet something to improve:
> > > 
> > > [auto build test ERROR on vhost/linux-next]
> > > [also build test ERROR on linus/master v5.7 next-20200529]
> > > [if your patch is applied to the wrong git tree, please drop us a note to help
> > > improve the system. BTW, we also suggest to use '--base' option to specify the
> > > base tree in git format-patch, please seehttps://stackoverflow.com/a/37406982]
> > > 
> > > url:https://github.com/0day-ci/linux/commits/Jason-Wang/vDPA-doorbell-mapping/20200531-070834
> > > base:https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git  linux-next
> > > config: m68k-randconfig-r011-20200601 (attached as .config)
> > > compiler: m68k-linux-gcc (GCC) 9.3.0
> > > reproduce (this is a W=1 build):
> > >          wgethttps://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross  -O ~/bin/make.cross
> > >          chmod +x ~/bin/make.cross
> > >          # save the attached .config to linux build tree
> > >          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k
> > > 
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kbuild test robot<lkp@intel.com>
> > > 
> > > All errors (new ones prefixed by >>, old ones prefixed by <<):
> > > 
> > > drivers/vhost/vdpa.c: In function 'vhost_vdpa_fault':
> > > > > drivers/vhost/vdpa.c:754:22: error: implicit declaration of function 'pgprot_noncached' [-Werror=implicit-function-declaration]
> > > 754 |  vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > > |                      ^~~~~~~~~~~~~~~~
> > > > > drivers/vhost/vdpa.c:754:22: error: incompatible types when assigning to type 'pgprot_t' {aka 'struct <anonymous>'} from type 'int'
> > > cc1: some warnings being treated as errors
> > > 
> > > vim +/pgprot_noncached +754 drivers/vhost/vdpa.c
> > > 
> > >     742	
> > >     743	static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
> > >     744	{
> > >     745		struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
> > >     746		struct vdpa_device *vdpa = v->vdpa;
> > >     747		const struct vdpa_config_ops *ops = vdpa->config;
> > >     748		struct vdpa_notification_area notify;
> > >     749		struct vm_area_struct *vma = vmf->vma;
> > >     750		u16 index = vma->vm_pgoff;
> > >     751	
> > >     752		notify = ops->get_vq_notification(vdpa, index);
> > >     753	
> > >   > 754		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > >     755		if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
> > >     756				    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
> > >     757				    vma->vm_page_prot))
> > >     758			return VM_FAULT_SIGBUS;
> > >     759	
> > >     760		return VM_FAULT_NOPAGE;
> > >     761	}
> > >     762	
> > Yes well, all this remapping clearly has no chance to work
> > on systems without CONFIG_MMU.
> 
> 
> It looks to me mmap can work according to Documentation/nommu-mmap.txt. But
> I'm not sure it's worth to bother.
> 
> Thanks


Well

int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
                unsigned long pfn, unsigned long size, pgprot_t prot)
{
        if (addr != (pfn << PAGE_SHIFT))
                return -EINVAL;

        vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
        return 0;
}
EXPORT_SYMBOL(remap_pfn_range);


So things aren't going to work if you have a fixed PFN
which is the case of the hardware device.


> 
> > 
> > 
> > 

