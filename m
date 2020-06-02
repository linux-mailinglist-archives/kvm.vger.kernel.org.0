Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D599F1EB4C6
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 06:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgFBE5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 00:57:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45776 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgFBE5U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 00:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591073838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gchTFiwviKMDwZXWqMwug6HrHP15DUCH03zQ9j5rpHE=;
        b=dyN5Xb4UbSOVa2hDAB3fwvZycCnQ55MGh7kglNiM9hDYZEnf9x5bUs5Xa/UxVuDtlhKWDV
        jFRtFitcV56SKfrP+2yrAiRkXKP7xuXuN6Hbdk/P5ETNVglfkICE0Ioz62S+w5+Ut8Es4z
        RTHBRQYTIM/lTDZwfJD1AYh4sa+7nUg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-b16GMbkdMTOoOLrdR-Om-w-1; Tue, 02 Jun 2020 00:57:00 -0400
X-MC-Unique: b16GMbkdMTOoOLrdR-Om-w-1
Received: by mail-wr1-f71.google.com with SMTP id h92so859232wrh.23
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 21:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gchTFiwviKMDwZXWqMwug6HrHP15DUCH03zQ9j5rpHE=;
        b=MkjxpaYSN+rjioyTGE2Zp+9jkRqpI9AsdG0weUUW1HO5REkELSTNJqEMKepikKXLrN
         jN7OgeAnra8/Sc7t9qY5O3twb98/kxMkceGGo1pEa3NRGR/rvFzEUeAnTceHlrrQX+G8
         COZ769CxLTwbQiLxwC6nlX1JzrSThbCCoD5yHlRlNrID+43FtkQa8mGp1fAKMsh8XgN0
         7H5xfsHwLht7C7FnKTRivqSJHruRSBTnep6juU+YSO/lquKUOkgkZOOAulzJool218N1
         7BDDRLXnMxiZmkPO/suPWgFFFbERqxZIemVqPxpfDbRha2i79TlKADXqUQKauJOOMASr
         aeEw==
X-Gm-Message-State: AOAM533ejoAtrsHLzq9p5s8edfqtlsWt4aZ39EiJfcTBhFyVYgqNAG3H
        QTeDMdsd4PsPuJ5asiyWXJ9CKJX9qGcjdtX82O8RSir/uxHAmYydc0sRoAxbrgfRQVvgLA0i2y8
        pkAYGc0GVR0+m
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr2320510wmh.8.1591073818233;
        Mon, 01 Jun 2020 21:56:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwezYypzZbKEY1d6YwmBv/8PZj3UfnzO1aXl2q6kGlCaJNGq8F3H+NRcEoRO1KXyF9lWjuqqA==
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr2320484wmh.8.1591073818026;
        Mon, 01 Jun 2020 21:56:58 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id x205sm1900586wmx.21.2020.06.01.21.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 21:56:57 -0700 (PDT)
Date:   Tue, 2 Jun 2020 00:56:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com
Subject: Re: [PATCH 4/6] vhost_vdpa: support doorbell mapping via mmap
Message-ID: <20200602005007-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-5-jasowang@redhat.com>
 <202006020308.kLXTHt4n%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006020308.kLXTHt4n%lkp@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 02, 2020 at 03:22:49AM +0800, kbuild test robot wrote:
> Hi Jason,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on vhost/linux-next]
> [also build test ERROR on linus/master v5.7 next-20200529]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Jason-Wang/vDPA-doorbell-mapping/20200531-070834
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
> config: m68k-randconfig-r011-20200601 (attached as .config)
> compiler: m68k-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=m68k 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> drivers/vhost/vdpa.c: In function 'vhost_vdpa_fault':
> >> drivers/vhost/vdpa.c:754:22: error: implicit declaration of function 'pgprot_noncached' [-Werror=implicit-function-declaration]
> 754 |  vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> |                      ^~~~~~~~~~~~~~~~
> >> drivers/vhost/vdpa.c:754:22: error: incompatible types when assigning to type 'pgprot_t' {aka 'struct <anonymous>'} from type 'int'
> cc1: some warnings being treated as errors
> 
> vim +/pgprot_noncached +754 drivers/vhost/vdpa.c
> 
>    742	
>    743	static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
>    744	{
>    745		struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
>    746		struct vdpa_device *vdpa = v->vdpa;
>    747		const struct vdpa_config_ops *ops = vdpa->config;
>    748		struct vdpa_notification_area notify;
>    749		struct vm_area_struct *vma = vmf->vma;
>    750		u16 index = vma->vm_pgoff;
>    751	
>    752		notify = ops->get_vq_notification(vdpa, index);
>    753	
>  > 754		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>    755		if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
>    756				    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
>    757				    vma->vm_page_prot))
>    758			return VM_FAULT_SIGBUS;
>    759	
>    760		return VM_FAULT_NOPAGE;
>    761	}
>    762	

Yes well, all this remapping clearly has no chance to work
on systems without CONFIG_MMU.



> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


