Return-Path: <kvm+bounces-15913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 278C38B220A
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 597AD1C2259E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 12:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC8B1494DD;
	Thu, 25 Apr 2024 12:56:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4931494C7;
	Thu, 25 Apr 2024 12:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714049760; cv=none; b=OmovTqU7JEYRXXO89yzwGQfbrMzPAfa2urz+/7L8wHVrYLla0F9hM70NfeEoieR71QiiwB9tr3MxUgzvAh6ttncM6EOyyBkkTcSbEzaUumkkdoy7mesBZAzMqSdX9wCyVWCRV6X7i3dmHKXt0o/VoHuIYella8opp/YI6wm7cs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714049760; c=relaxed/simple;
	bh=Tzl6rkHXA7oS8wzOZdFnzW8k/tso7PW4qazbSuRNs0s=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Qy4C0hOT+3pngCOQtqwRUg17/lxIZ2zZdC+psxQ2wSsQ8XGiYObDKC1dJx0IVVoQD5jii2daJMSc0/RO85yU/zDQvDe/dIfeFYkr0QrcOrRE7K+B3b3zt0PlAyTfGBJWqvIH5gSMGMZwdnhgaanZV+3VX7f9GdTlWu0R1wraW4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VQG3g560fz1R5r7;
	Thu, 25 Apr 2024 20:52:47 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id A5DEC140258;
	Thu, 25 Apr 2024 20:55:50 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 20:55:49 +0800
Subject: Re: [PATCH v5 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: kernel test robot <lkp@intel.com>, <alex.williamson@redhat.com>,
	<jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>
CC: <oe-kbuild-all@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20240424085721.12760-5-liulongfang@huawei.com>
 <202404251733.qOuGkmpU-lkp@intel.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <daa4f927-3412-2392-f5ca-e27ad550377c@huawei.com>
Date: Thu, 25 Apr 2024 20:55:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <202404251733.qOuGkmpU-lkp@intel.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/4/25 17:20, kernel test robot wrote:
> Hi Longfang,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on awilliam-vfio/next]
> [also build test ERROR on linus/master v6.9-rc5 next-20240424]
> [cannot apply to awilliam-vfio/for-linus]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Longfang-Liu/hisi_acc_vfio_pci-extract-public-functions-for-container_of/20240424-170806
> base:   https://github.com/awilliam/linux-vfio.git next
> patch link:    https://lore.kernel.org/r/20240424085721.12760-5-liulongfang%40huawei.com
> patch subject: [PATCH v5 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
> config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20240425/202404251733.qOuGkmpU-lkp@intel.com/config)
> compiler: loongarch64-linux-gcc (GCC) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240425/202404251733.qOuGkmpU-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202404251733.qOuGkmpU-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vf_debug_cmd':
>>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:53: error: macro "dev_err" requires 3 arguments, but only 1 given
>     1370 |         dev_err("mailbox cmd channel state is OK!\n");
>          |                                                     ^
>    In file included from include/linux/device.h:15,
>                     from drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:6:
>    include/linux/dev_printk.h:143: note: macro "dev_err" defined here
>      143 | #define dev_err(dev, fmt, ...) \
>          | 
>>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:9: error: 'dev_err' undeclared (first use in this function); did you mean '_dev_err'?
>     1370 |         dev_err("mailbox cmd channel state is OK!\n");
>          |         ^~~~~~~
>          |         _dev_err
>    drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1370:9: note: each undeclared identifier is reported only once for each function it appears in
> 
> 
> vim +/dev_err +1370 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> 
>   1345	
>   1346	static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
>   1347	{
>   1348		struct device *vf_dev = seq->private;
>   1349		struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>   1350		struct vfio_device *vdev = &core_device->vdev;
>   1351		struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>   1352		struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>   1353		u64 value;
>   1354		int ret;
>   1355	
>   1356		mutex_lock(&hisi_acc_vdev->enable_mutex);
>   1357		ret = hisi_acc_vf_debug_check(seq, vdev);
>   1358		if (ret) {
>   1359			mutex_unlock(&hisi_acc_vdev->enable_mutex);
>   1360			return ret;
>   1361		}
>   1362	
>   1363		value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
>   1364		if (value == QM_MB_CMD_NOT_READY) {
>   1365			mutex_unlock(&hisi_acc_vdev->enable_mutex);
>   1366			dev_err(vf_dev, "mailbox cmd channel not ready!\n");
>   1367			return -EINVAL;
>   1368		}
>   1369		mutex_unlock(&hisi_acc_vdev->enable_mutex);
>> 1370		dev_err("mailbox cmd channel state is OK!\n");
>   1371	
>   1372		return 0;
>   1373	}
>   1374	
>

OK,
I'll modify it soon.

Thanks.
Longfang.



