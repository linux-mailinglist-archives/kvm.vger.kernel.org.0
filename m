Return-Path: <kvm+bounces-31228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 091F49C168D
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 07:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2814281D10
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 06:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BAA1D0E07;
	Fri,  8 Nov 2024 06:41:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E75219DF64;
	Fri,  8 Nov 2024 06:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731048077; cv=none; b=oDCDcrmrxrq+czk13TQwHYBxqAa+cjSBFcJl6r308TEh65m3v33esjlNHgnEZpCdSxq66rH7yrcB/KnRddoTlCukr6tKLX0B+ug7AY9iGBluEOxHDIOY4ZysAOoB1+JySqbC7TJWwWFAJibmYeo+U0AgVLUxD8qcrJOy8ju3nsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731048077; c=relaxed/simple;
	bh=X6Icc+67DuCUmKMYq/cuASU63sS9vB6deAZuEHyPLeY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gXdhwDHG6Ln4qT7l6I2wNPnW8XjBqF7WAW7wItPz39XrVzv1yMuvNzQkunzDcoBEwk3BZfrdmdoM65l3pkSgYTztqnjQQ/8eXnolJ2wrcDaqPEbkU7f5NbpCvGSMQjHuhxEvuzREQ4Q1tDTXryZ3T3OmoIgivBgYXpvqQR8bMm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Xl8NT7036z1JCG5;
	Fri,  8 Nov 2024 14:36:25 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 1AF7A1A016C;
	Fri,  8 Nov 2024 14:41:04 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 8 Nov 2024 14:41:03 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 8 Nov 2024 14:41:03 +0800
Subject: Re: [PATCH v13 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
To: kernel test robot <lkp@intel.com>, <alex.williamson@redhat.com>,
	<jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>
CC: <oe-kbuild-all@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20241106100343.21593-4-liulongfang@huawei.com>
 <202411070027.p1xVCxxs-lkp@intel.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <79ae7e16-5131-b517-96fd-0d477fdbf3b5@huawei.com>
Date: Fri, 8 Nov 2024 14:41:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <202411070027.p1xVCxxs-lkp@intel.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/11/7 0:50, kernel test robot wrote:
> Hi Longfang,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on awilliam-vfio/next]
> [also build test ERROR on awilliam-vfio/for-linus linus/master v6.12-rc6 next-20241106]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Longfang-Liu/hisi_acc_vfio_pci-extract-public-functions-for-container_of/20241106-182913
> base:   https://github.com/awilliam/linux-vfio.git next
> patch link:    https://lore.kernel.org/r/20241106100343.21593-4-liulongfang%40huawei.com
> patch subject: [PATCH v13 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
> config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20241107/202411070027.p1xVCxxs-lkp@intel.com/config)
> compiler: loongarch64-linux-gcc (GCC) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241107/202411070027.p1xVCxxs-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202411070027.p1xVCxxs-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vf_dev_read':
>>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1397:9: error: too many arguments to function 'seq_puts'
>     1397 |         seq_puts(seq,
>          |         ^~~~~~~~
>    In file included from include/linux/debugfs.h:16,
>                     from include/linux/hisi_acc_qm.h:7,
>                     from drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:9:
>    include/linux/seq_file.h:122:29: note: declared here
>      122 | static __always_inline void seq_puts(struct seq_file *m, const char *s)
>          |                             ^~~~~~~~
>    drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vf_migf_read':
>    drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1429:9: error: too many arguments to function 'seq_puts'
>     1429 |         seq_puts(seq, "migrate data length: %lu\n", debug_migf->total_length);
>          |         ^~~~~~~~
>    include/linux/seq_file.h:122:29: note: declared here
>      122 | static __always_inline void seq_puts(struct seq_file *m, const char *s)
>          |                             ^~~~~~~~
> 
> 
> vim +/seq_puts +1397 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> 
>   1364	
>   1365	static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
>   1366	{
>   1367		struct device *vf_dev = seq->private;
>   1368		struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
>   1369		struct vfio_device *vdev = &core_device->vdev;
>   1370		struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
>   1371		size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
>   1372		struct acc_vf_data *vf_data;
>   1373		int ret;
>   1374	
>   1375		mutex_lock(&hisi_acc_vdev->open_mutex);
>   1376		ret = hisi_acc_vf_debug_check(seq, vdev);
>   1377		if (ret) {
>   1378			mutex_unlock(&hisi_acc_vdev->open_mutex);
>   1379			return ret;
>   1380		}
>   1381	
>   1382		mutex_lock(&hisi_acc_vdev->state_mutex);
>   1383		vf_data = kzalloc(sizeof(*vf_data), GFP_KERNEL);
>   1384		if (!vf_data) {
>   1385			ret = -ENOMEM;
>   1386			goto mutex_release;
>   1387		}
>   1388	
>   1389		vf_data->vf_qm_state = hisi_acc_vdev->vf_qm_state;
>   1390		ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
>   1391		if (ret)
>   1392			goto migf_err;
>   1393	
>   1394		seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
>   1395			     (const void *)vf_data, vf_data_sz, false);
>   1396	
>> 1397		seq_puts(seq,
>   1398			 "guest driver load: %u\n"
>   1399			 "data size: %lu\n",
>   1400			 hisi_acc_vdev->vf_qm_state,
>   1401			 sizeof(struct acc_vf_data));
>   1402	
>   1403	migf_err:
>   1404		kfree(vf_data);
>   1405	mutex_release:
>   1406		mutex_unlock(&hisi_acc_vdev->state_mutex);
>   1407		mutex_unlock(&hisi_acc_vdev->open_mutex);
>   1408	
>   1409		return ret;
>   1410	}
>   1411	
> 
OK, I will fix it using seq_printf() in the next version

Thanks,
Longfang.

