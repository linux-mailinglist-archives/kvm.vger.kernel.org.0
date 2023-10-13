Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1B47C7B24
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 03:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjJMB1f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 21:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjJMB1e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 21:27:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FCDC0
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 18:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697160452; x=1728696452;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Pkxu3lHKXHppDC6UTKZQ6L2XSnik3nsFIj40OFrTQiw=;
  b=XeXzRDmNPxUDKmdmcq1QGn0tG0fqF5eeH9IYQQRWiCKYnqwStBw1lPCH
   dqHTm1YV0EC4g7k3MkORSxv/uPL/SAo8g7LGH2shdIBsSDsDISaGBDWZD
   XlO5aY72sa5da8ivjwg6y+dJLsFCEM/tSCtbfDEdvrgAe9sc65eio6E/c
   0KepldHXAM/33srbNFaa1x+MLI7Z39Z5wd5QIrGgLn/JK5UicH1JQQev8
   Y6HFe0cjpvcD9cpQuxgqAQVEhC5tPGwnFdb8CXVtrJyACgQSl5K2+GfPE
   iJy+E97tTAKyFAtJT0NC+sBVKDU8N/TcVGKoytiQ8ba4QcSyNOgHSU2xx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="416130972"
X-IronPort-AV: E=Sophos;i="6.03,219,1694761200"; 
   d="scan'208";a="416130972"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2023 18:27:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="731142488"
X-IronPort-AV: E=Sophos;i="6.03,219,1694761200"; 
   d="scan'208";a="731142488"
Received: from lkp-server02.sh.intel.com (HELO f64821696465) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 12 Oct 2023 18:27:30 -0700
Received: from kbuild by f64821696465 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qr6xb-0004Av-1A;
        Fri, 13 Oct 2023 01:27:27 +0000
Date:   Fri, 13 Oct 2023 09:27:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org
Subject: [awilliam-vfio:mtty-migration 18/18]
 samples/vfio-mdev/mtty.c:865:45: warning: format '%ld' expects argument of
 type 'long int', but argument 5 has type 'size_t' {aka 'unsigned int'}
Message-ID: <202310130943.T1WbEi5W-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://github.com/awilliam/linux-vfio.git mtty-migration
head:   4734b1d16af9a2b7ffbbbbb5f2571f4b11ea1105
commit: 4734b1d16af9a2b7ffbbbbb5f2571f4b11ea1105 [18/18] vfio/mtty: Enable migration support
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20231013/202310130943.T1WbEi5W-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231013/202310130943.T1WbEi5W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310130943.T1WbEi5W-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/printk.h:564,
                    from include/asm-generic/bug.h:22,
                    from arch/m68k/include/asm/bug.h:32,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/m68k/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from arch/m68k/include/asm/irqflags.h:6,
                    from include/linux/irqflags.h:17,
                    from arch/m68k/include/asm/atomic.h:6,
                    from include/linux/atomic.h:7,
                    from include/linux/mm_types_task.h:13,
                    from include/linux/mm_types.h:5,
                    from include/linux/buildid.h:5,
                    from include/linux/module.h:14,
                    from samples/vfio-mdev/mtty.c:14:
   samples/vfio-mdev/mtty.c: In function 'mtty_save_read':
>> samples/vfio-mdev/mtty.c:865:45: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
     865 |         dev_dbg(migf->mdev_state->vdev.dev, "%s ask %ld\n", __func__, len);
         |                                             ^~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in definition of macro '__dynamic_func_call_cls'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:273:9: note: in expansion of macro '_dynamic_func_call'
     273 |         _dynamic_func_call(fmt, __dynamic_dev_dbg,              \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   samples/vfio-mdev/mtty.c:865:9: note: in expansion of macro 'dev_dbg'
     865 |         dev_dbg(migf->mdev_state->vdev.dev, "%s ask %ld\n", __func__, len);
         |         ^~~~~~~
   samples/vfio-mdev/mtty.c:865:55: note: format string is defined here
     865 |         dev_dbg(migf->mdev_state->vdev.dev, "%s ask %ld\n", __func__, len);
         |                                                     ~~^
         |                                                       |
         |                                                       long int
         |                                                     %d
>> samples/vfio-mdev/mtty.c:887:45: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'ssize_t' {aka 'int'} [-Wformat=]
     887 |         dev_dbg(migf->mdev_state->vdev.dev, "%s read %ld\n", __func__, ret);
         |                                             ^~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in definition of macro '__dynamic_func_call_cls'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:273:9: note: in expansion of macro '_dynamic_func_call'
     273 |         _dynamic_func_call(fmt, __dynamic_dev_dbg,              \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   samples/vfio-mdev/mtty.c:887:9: note: in expansion of macro 'dev_dbg'
     887 |         dev_dbg(migf->mdev_state->vdev.dev, "%s read %ld\n", __func__, ret);
         |         ^~~~~~~
   samples/vfio-mdev/mtty.c:887:56: note: format string is defined here
     887 |         dev_dbg(migf->mdev_state->vdev.dev, "%s read %ld\n", __func__, ret);
         |                                                      ~~^
         |                                                        |
         |                                                        long int
         |                                                      %d
   samples/vfio-mdev/mtty.c: In function 'mtty_save_device_data':
   samples/vfio-mdev/mtty.c:938:39: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'ssize_t' {aka 'int'} [-Wformat=]
     938 |         dev_dbg(mdev_state->vdev.dev, "%s filled header to %ld\n",
         |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in definition of macro '__dynamic_func_call_cls'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:273:9: note: in expansion of macro '_dynamic_func_call'
     273 |         _dynamic_func_call(fmt, __dynamic_dev_dbg,              \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   samples/vfio-mdev/mtty.c:938:9: note: in expansion of macro 'dev_dbg'
     938 |         dev_dbg(mdev_state->vdev.dev, "%s filled header to %ld\n",
         |         ^~~~~~~
   samples/vfio-mdev/mtty.c:938:62: note: format string is defined here
     938 |         dev_dbg(mdev_state->vdev.dev, "%s filled header to %ld\n",
         |                                                            ~~^
         |                                                              |
         |                                                              long int
         |                                                            %d
   samples/vfio-mdev/mtty.c:953:47: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'ssize_t' {aka 'int'} [-Wformat=]
     953 |                 dev_dbg(mdev_state->vdev.dev, "%s filled to %ld\n",
         |                                               ^~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in definition of macro '__dynamic_func_call_cls'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:273:9: note: in expansion of macro '_dynamic_func_call'
     273 |         _dynamic_func_call(fmt, __dynamic_dev_dbg,              \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   samples/vfio-mdev/mtty.c:953:17: note: in expansion of macro 'dev_dbg'
     953 |                 dev_dbg(mdev_state->vdev.dev, "%s filled to %ld\n",
         |                 ^~~~~~~
   samples/vfio-mdev/mtty.c:953:63: note: format string is defined here
     953 |                 dev_dbg(mdev_state->vdev.dev, "%s filled to %ld\n",
         |                                                             ~~^
         |                                                               |
         |                                                               long int
         |                                                             %d
   samples/vfio-mdev/mtty.c: In function 'mtty_resume_write':
   samples/vfio-mdev/mtty.c:996:45: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
     996 |         dev_dbg(migf->mdev_state->vdev.dev, "%s received %ld, total %ld\n",
         |                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in definition of macro '__dynamic_func_call_cls'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:273:9: note: in expansion of macro '_dynamic_func_call'
     273 |         _dynamic_func_call(fmt, __dynamic_dev_dbg,              \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   samples/vfio-mdev/mtty.c:996:9: note: in expansion of macro 'dev_dbg'
     996 |         dev_dbg(migf->mdev_state->vdev.dev, "%s received %ld, total %ld\n",
         |         ^~~~~~~
   samples/vfio-mdev/mtty.c:996:60: note: format string is defined here
     996 |         dev_dbg(migf->mdev_state->vdev.dev, "%s received %ld, total %ld\n",
         |                                                          ~~^
         |                                                            |
         |                                                            long int
         |                                                          %d
   samples/vfio-mdev/mtty.c:996:45: warning: format '%ld' expects argument of type 'long int', but argument 6 has type 'ssize_t' {aka 'int'} [-Wformat=]
     996 |         dev_dbg(migf->mdev_state->vdev.dev, "%s received %ld, total %ld\n",
         |                                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in definition of macro '__dynamic_func_call_cls'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:273:9: note: in expansion of macro '_dynamic_func_call'
     273 |         _dynamic_func_call(fmt, __dynamic_dev_dbg,              \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   samples/vfio-mdev/mtty.c:996:9: note: in expansion of macro 'dev_dbg'
     996 |         dev_dbg(migf->mdev_state->vdev.dev, "%s received %ld, total %ld\n",
         |         ^~~~~~~
   samples/vfio-mdev/mtty.c:996:71: note: format string is defined here
     996 |         dev_dbg(migf->mdev_state->vdev.dev, "%s received %ld, total %ld\n",
         |                                                                     ~~^
         |                                                                       |
         |                                                                       long int
         |                                                                     %d
   samples/vfio-mdev/mtty.c: In function 'mtty_load_state':
>> samples/vfio-mdev/mtty.c:1063:47: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Wformat=]
    1063 |                 dev_dbg(mdev_state->vdev.dev, "%s expected %ld, got %ld\n",
         |                                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in definition of macro '__dynamic_func_call_cls'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:273:9: note: in expansion of macro '_dynamic_func_call'
     273 |         _dynamic_func_call(fmt, __dynamic_dev_dbg,              \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   samples/vfio-mdev/mtty.c:1063:17: note: in expansion of macro 'dev_dbg'
    1063 |                 dev_dbg(mdev_state->vdev.dev, "%s expected %ld, got %ld\n",
         |                 ^~~~~~~
   samples/vfio-mdev/mtty.c:1063:62: note: format string is defined here
    1063 |                 dev_dbg(mdev_state->vdev.dev, "%s expected %ld, got %ld\n",
         |                                                            ~~^
         |                                                              |
         |                                                              long int
         |                                                            %d
   samples/vfio-mdev/mtty.c:1063:47: warning: format '%ld' expects argument of type 'long int', but argument 6 has type 'ssize_t' {aka 'int'} [-Wformat=]
    1063 |                 dev_dbg(mdev_state->vdev.dev, "%s expected %ld, got %ld\n",
         |                                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in definition of macro '__dynamic_func_call_cls'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:273:9: note: in expansion of macro '_dynamic_func_call'
     273 |         _dynamic_func_call(fmt, __dynamic_dev_dbg,              \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:9: note: in expansion of macro 'dynamic_dev_dbg'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~
   include/linux/dev_printk.h:155:30: note: in expansion of macro 'dev_fmt'
     155 |         dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                              ^~~~~~~
   samples/vfio-mdev/mtty.c:1063:17: note: in expansion of macro 'dev_dbg'
    1063 |                 dev_dbg(mdev_state->vdev.dev, "%s expected %ld, got %ld\n",
         |                 ^~~~~~~
   samples/vfio-mdev/mtty.c:1063:71: note: format string is defined here
    1063 |                 dev_dbg(mdev_state->vdev.dev, "%s expected %ld, got %ld\n",
         |                                                                     ~~^
         |                                                                       |
         |                                                                       long int
         |                                                                     %d


vim +865 samples/vfio-mdev/mtty.c

   851	
   852	static ssize_t mtty_save_read(struct file *filp, char __user *buf,
   853				      size_t len, loff_t *pos)
   854	{
   855		struct mtty_migration_file *migf = filp->private_data;
   856		ssize_t ret = 0;
   857	
   858		if (pos)
   859			return -ESPIPE;
   860	
   861		pos = &filp->f_pos;
   862	
   863		mutex_lock(&migf->lock);
   864	
 > 865		dev_dbg(migf->mdev_state->vdev.dev, "%s ask %ld\n", __func__, len);
   866	
   867		if (migf->disabled) {
   868			ret = -ENODEV;
   869			goto out_unlock;
   870		}
   871	
   872		if (*pos > migf->filled_size) {
   873			ret = -EINVAL;
   874			goto out_unlock;
   875		}
   876	
   877		len = min_t(size_t, migf->filled_size - *pos, len);
   878		if (len) {
   879			if (copy_to_user(buf, (void *)&migf->data + *pos, len)) {
   880				ret = -EFAULT;
   881				goto out_unlock;
   882			}
   883			*pos += len;
   884			ret = len;
   885		}
   886	out_unlock:
 > 887		dev_dbg(migf->mdev_state->vdev.dev, "%s read %ld\n", __func__, ret);
   888		mutex_unlock(&migf->lock);
   889		return ret;
   890	}
   891	
   892	static const struct file_operations mtty_save_fops = {
   893		.owner = THIS_MODULE,
   894		.read = mtty_save_read,
   895		.unlocked_ioctl = mtty_precopy_ioctl,
   896		.compat_ioctl = compat_ptr_ioctl,
   897		.release = mtty_release_migf,
   898		.llseek = no_llseek,
   899	};
   900	
   901	static struct mtty_migration_file *
   902	mtty_save_device_data(struct mdev_state *mdev_state,
   903			      enum vfio_device_mig_state state)
   904	{
   905		struct mtty_migration_file *migf = mdev_state->saving_migf;
   906		struct mtty_migration_file *ret = NULL;
   907	
   908		if (migf) {
   909			if (state == VFIO_DEVICE_STATE_STOP_COPY)
   910				goto fill_data;
   911			return ret;
   912		}
   913	
   914		migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
   915		if (!migf)
   916			return ERR_PTR(-ENOMEM);
   917	
   918		migf->filp = anon_inode_getfile("mtty_mig", &mtty_save_fops,
   919						migf, O_RDONLY);
   920		if (IS_ERR(migf->filp)) {
   921			int rc = PTR_ERR(migf->filp);
   922	
   923			kfree(migf);
   924			return ERR_PTR(rc);
   925		}
   926	
   927		stream_open(migf->filp->f_inode, migf->filp);
   928		mutex_init(&migf->lock);
   929		migf->mdev_state = mdev_state;
   930	
   931		migf->data.magic = MTTY_MAGIC;
   932		migf->data.major_ver = MTTY_MAJOR_VER;
   933		migf->data.minor_ver = MTTY_MINOR_VER;
   934		migf->data.nr_ports = mdev_state->nr_ports;
   935	
   936		migf->filled_size = offsetof(struct mtty_data, ports);
   937	
   938		dev_dbg(mdev_state->vdev.dev, "%s filled header to %ld\n",
   939			__func__, migf->filled_size);
   940	
   941		ret = mdev_state->saving_migf = migf;
   942	
   943	fill_data:
   944		if (state == VFIO_DEVICE_STATE_STOP_COPY) {
   945			int i;
   946	
   947			mutex_lock(&migf->lock);
   948			for (i = 0; i < mdev_state->nr_ports; i++) {
   949				memcpy(&migf->data.ports[i],
   950				       &mdev_state->s[i], sizeof(struct serial_port));
   951				migf->filled_size += sizeof(struct serial_port);
   952			}
   953			dev_dbg(mdev_state->vdev.dev, "%s filled to %ld\n",
   954				__func__, migf->filled_size);
   955			mutex_unlock(&migf->lock);
   956		}
   957	
   958		return ret;
   959	}
   960	
   961	static ssize_t mtty_resume_write(struct file *filp, const char __user *buf,
   962					 size_t len, loff_t *pos)
   963	{
   964		struct mtty_migration_file *migf = filp->private_data;
   965		loff_t requested_length;
   966		ssize_t ret = 0;
   967	
   968		if (pos)
   969			return -ESPIPE;
   970	
   971		pos = &filp->f_pos;
   972	
   973		if (*pos < 0 ||
   974		    check_add_overflow((loff_t)len, *pos, &requested_length))
   975			return -EINVAL;
   976	
   977		if (requested_length > sizeof(struct mtty_data))
   978			return -ENOMEM;
   979	
   980		mutex_lock(&migf->lock);
   981	
   982		if (migf->disabled) {
   983			ret = -ENODEV;
   984			goto out_unlock;
   985		}
   986	
   987		if (copy_from_user((void *)&migf->data + *pos, buf, len)) {
   988			ret = -EFAULT;
   989			goto out_unlock;
   990		}
   991	
   992		*pos += len;
   993		ret = len;
   994		migf->filled_size += len;
   995	
   996		dev_dbg(migf->mdev_state->vdev.dev, "%s received %ld, total %ld\n",
   997			__func__, len, migf->filled_size);
   998	
   999		if (migf->filled_size >= offsetof(struct mtty_data, ports)) {
  1000			struct mdev_state *mdev_state = migf->mdev_state;
  1001	
  1002			if (migf->data.magic != MTTY_MAGIC || migf->data.flags ||
  1003			    migf->data.major_ver != MTTY_MAJOR_VER ||
  1004			    migf->data.minor_ver != MTTY_MINOR_VER ||
  1005			    migf->data.nr_ports != mdev_state->nr_ports) {
  1006				dev_dbg(migf->mdev_state->vdev.dev,
  1007					"%s failed validation\n", __func__);
  1008				ret = -EFAULT;
  1009			} else {
  1010				dev_dbg(migf->mdev_state->vdev.dev,
  1011					"%s header validated\n", __func__);
  1012			}
  1013		}
  1014	
  1015	out_unlock:
  1016		mutex_unlock(&migf->lock);
  1017		return ret;
  1018	}
  1019	
  1020	static const struct file_operations mtty_resume_fops = {
  1021		.owner = THIS_MODULE,
  1022		.write = mtty_resume_write,
  1023		.release = mtty_release_migf,
  1024		.llseek = no_llseek,
  1025	};
  1026	
  1027	static struct mtty_migration_file *
  1028	mtty_resume_device_data(struct mdev_state *mdev_state)
  1029	{
  1030		struct mtty_migration_file *migf;
  1031		int ret;
  1032	
  1033		migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
  1034		if (!migf)
  1035			return ERR_PTR(-ENOMEM);
  1036	
  1037		migf->filp = anon_inode_getfile("mtty_mig", &mtty_resume_fops,
  1038						migf, O_WRONLY);
  1039		if (IS_ERR(migf->filp)) {
  1040			ret = PTR_ERR(migf->filp);
  1041			kfree(migf);
  1042			return ERR_PTR(ret);
  1043		}
  1044	
  1045		stream_open(migf->filp->f_inode, migf->filp);
  1046		mutex_init(&migf->lock);
  1047		migf->mdev_state = mdev_state;
  1048	
  1049		mdev_state->resuming_migf = migf;
  1050	
  1051		return migf;
  1052	}
  1053	
  1054	static int mtty_load_state(struct mdev_state *mdev_state)
  1055	{
  1056		struct mtty_migration_file *migf = mdev_state->resuming_migf;
  1057		int i;
  1058	
  1059		mutex_lock(&migf->lock);
  1060		/* magic and version already tested by resume write fn */
  1061		if (migf->filled_size < offsetof(struct mtty_data, ports) +
  1062				(mdev_state->nr_ports * sizeof(struct serial_port))) {
> 1063			dev_dbg(mdev_state->vdev.dev, "%s expected %ld, got %ld\n",
  1064				__func__, offsetof(struct mtty_data, ports) +
  1065				(mdev_state->nr_ports * sizeof(struct serial_port)),
  1066				migf->filled_size);
  1067			mutex_unlock(&migf->lock);
  1068			return -EINVAL;
  1069		}
  1070	
  1071		for (i = 0; i < mdev_state->nr_ports; i++)
  1072			memcpy(&mdev_state->s[i],
  1073			       &migf->data.ports[i], sizeof(struct serial_port));
  1074	
  1075		mutex_unlock(&migf->lock);
  1076		return 0;
  1077	}
  1078	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
