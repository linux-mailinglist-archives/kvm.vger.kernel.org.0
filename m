Return-Path: <kvm+bounces-40056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B04EA4E8FC
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:33:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71D073BDB97
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 17:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDEE280A3A;
	Tue,  4 Mar 2025 16:42:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from beeline2.cc.itu.edu.tr (beeline2.cc.itu.edu.tr [160.75.25.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3D01EDA3E
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=160.75.25.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741106549; cv=pass; b=Pt79uQE4mGcFpSsL5Lcp8KMjX5hPJXiPva0vK4ouORDOFZP+8VwOfgpTy6DI54ujrqA2YaNSf82tTC2p2F2ds3KHS+4MAYgoJX61jUewMdOw6CS9tTmTAUuGksHXs620syRQqm2cQbLD1v8eVOOK3ZtwhqgWtqS8/Mos90sCBHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741106549; c=relaxed/simple;
	bh=TzWdC4VbbSXc7GXe6UPz5yxsG4/JL1T6TrtZwMCpPZg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pyYmZIpMhiHnwzzFHVXVDZUi7ps3tHnropfc4MUSGjtyN3AUAWWGtqw+ildt1M+fUz6ytPBkI8Jk1uhmQh+k9K5Xc1xdAQLSMDtr2hLujHodkLi0OCcMcDsjh2aCFvoDr/6TRhpfgXWQndZxCCakC2583vLtI47wRau4rYQLqpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=none smtp.mailfrom=cc.itu.edu.tr; arc=none smtp.client-ip=45.249.212.189; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=pass smtp.client-ip=160.75.25.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cc.itu.edu.tr
Received: from lesvatest1.cc.itu.edu.tr (lesvatest1.cc.itu.edu.tr [10.146.128.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by beeline2.cc.itu.edu.tr (Postfix) with ESMTPS id C06F140D1EF4
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:42:23 +0300 (+03)
X-Envelope-From: <root@cc.itu.edu.tr>
Received: from lesva1.cc.itu.edu.tr (unknown [160.75.70.79])
	by lesvatest1.cc.itu.edu.tr (Postfix) with ESMTP id 4Z6hJc4ptNzG3y0
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 19:41:04 +0300 (+03)
Received: by le1 (Postfix, from userid 0)
	id 68DD04272F; Tue,  4 Mar 2025 19:40:52 +0300 (+03)
X-Envelope-From: <linux-kernel+bounces-541550-bozkiru=itu.edu.tr@vger.kernel.org>
Received: from fgw2.itu.edu.tr (fgw2.itu.edu.tr [160.75.25.104])
	by le2 (Postfix) with ESMTP id E81A6428A3
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 14:22:46 +0300 (+03)
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by fgw2.itu.edu.tr (Postfix) with SMTP id 9BB7C2DCE1
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 14:22:46 +0300 (+03)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5DDC167AED
	for <bozkiru@itu.edu.tr>; Mon,  3 Mar 2025 11:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83BE1F4722;
	Mon,  3 Mar 2025 11:15:05 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8A51F427D;
	Mon,  3 Mar 2025 11:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741000503; cv=none; b=g99fy8u3z76fdlxd8kINiECjXBof0guHjGzW6OrO0H75CipszlaWEGaWN8EvFH66IrmtMVBc2cL/Gq6F2t9dzjkW9yAaQ5o7fmT8eS4tLrzmR1kKQyLzsfi9NOrhCKXI4pqEEzVm5+rHOJuRKnqCaoTLLd+F9eVA3EjVs54VCsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741000503; c=relaxed/simple;
	bh=TzWdC4VbbSXc7GXe6UPz5yxsG4/JL1T6TrtZwMCpPZg=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NuAgz5BXNlKuqdQ6PlBWOxB2qZ/srAD81fxcrj6cXx3kdhmBkyrG37z0nuY2e2kVkdsZNHFvT2iVqzWrFZTkcfOHO7sXVMtpwLq1vvTRyRydehTttUqwoLP1j3j5qNs0IPNY/91gfVIxbDJzU7gUvk8q+vdRBIyanFbk+xmNC1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Z5x346Knyz9wDM;
	Mon,  3 Mar 2025 19:11:44 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id EBCF51402C8;
	Mon,  3 Mar 2025 19:14:51 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemg500006.china.huawei.com (7.202.181.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Mar 2025 19:14:51 +0800
Subject: Re: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
To: kernel test robot <lkp@intel.com>, <alex.williamson@redhat.com>,
	<jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>
CC: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>
References: <20250225062757.19692-2-liulongfang@huawei.com>
 <202502281952.Z9JQ8jcK-lkp@intel.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <b8478e63-206a-8273-f8a2-af05e17b1d39@huawei.com>
Date: Mon, 3 Mar 2025 19:14:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <202502281952.Z9JQ8jcK-lkp@intel.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500006.china.huawei.com (7.202.181.43)
X-ITU-Libra-ESVA-Information: Please contact Istanbul Teknik Universitesi for more information
X-ITU-Libra-ESVA-ID: 4Z6hJc4ptNzG3y0
X-ITU-Libra-ESVA: No virus found
X-ITU-Libra-ESVA-From: root@cc.itu.edu.tr
X-ITU-Libra-ESVA-Watermark: 1741711265.53414@NPVTefEsuHQ8nm2e2tsFmg
X-ITU-MailScanner-SpamCheck: not spam

On 2025/2/28 19:55, kernel test robot wrote:
> Hi Longfang,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on awilliam-vfio/next]
> [also build test ERROR on awilliam-vfio/for-linus linus/master v6.14-rc4 next-20250227]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Longfang-Liu/hisi_acc_vfio_pci-fix-XQE-dma-address-error/20250225-143347
> base:   https://github.com/awilliam/linux-vfio.git next
> patch link:    https://lore.kernel.org/r/20250225062757.19692-2-liulongfang%40huawei.com
> patch subject: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
> config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20250228/202502281952.Z9JQ8jcK-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250228/202502281952.Z9JQ8jcK-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202502281952.Z9JQ8jcK-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:9:
>    In file included from include/linux/hisi_acc_qm.h:10:
>    In file included from include/linux/pci.h:1644:
>    In file included from include/linux/dmapool.h:14:
>    In file included from include/linux/scatterlist.h:8:
>    In file included from include/linux/mm.h:2224:
>    include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
>      504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~ ^
>      505 |                            item];
>          |                            ~~~~
>    include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
>      511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~ ^
>      512 |                            NR_VM_NUMA_EVENT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
>      524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~ ^
>      525 |                            NR_VM_NUMA_EVENT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:448:23: error: use of undeclared identifier 'ACC_DRV_MAR'
>      448 |         vf_data->major_ver = ACC_DRV_MAR;
>          |                              ^
>>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:449:23: error: use of undeclared identifier 'ACC_DRV_MIN'
>      449 |         vf_data->minor_ver = ACC_DRV_MIN;
>          |                              ^
>    3 warnings and 2 errors generated.
> 
> 
> vim +/ACC_DRV_MAR +448 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> 
>    438	
>    439	static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
>    440					struct acc_vf_data *vf_data)
>    441	{
>    442		struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
>    443		struct device *dev = &pf_qm->pdev->dev;
>    444		int vf_id = hisi_acc_vdev->vf_id;
>    445		int ret;
>    446	
>    447		vf_data->acc_magic = ACC_DEV_MAGIC_V2;
>  > 448		vf_data->major_ver = ACC_DRV_MAR;
>  > 449		vf_data->minor_ver = ACC_DRV_MIN;
>    450		/* Save device id */
>    451		vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
>    452	
>    453		/* VF qp num save from PF */
>    454		ret = pf_qm_get_qp_num(pf_qm, vf_id, &vf_data->qp_base);
>    455		if (ret <= 0) {
>    456			dev_err(dev, "failed to get vft qp nums!\n");
>    457			return -EINVAL;
>    458		}
>    459	
>    460		vf_data->qp_num = ret;
>    461	
>    462		/* VF isolation state save from PF */
>    463		ret = qm_read_regs(pf_qm, QM_QUE_ISO_CFG_V, &vf_data->que_iso_cfg, 1);
>    464		if (ret) {
>    465			dev_err(dev, "failed to read QM_QUE_ISO_CFG_V!\n");
>    466			return ret;
>    467		}
>    468	
>    469		return 0;
>    470	}
>    471	
> 

Thank you for your test, I will fix it in the next version.

Thanks.
Longfang.


