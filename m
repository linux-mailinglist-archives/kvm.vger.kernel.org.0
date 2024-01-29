Return-Path: <kvm+bounces-7299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D237883FC2F
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 03:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63524B21FC3
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 02:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3EEDFBE5;
	Mon, 29 Jan 2024 02:25:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A34EEAE5;
	Mon, 29 Jan 2024 02:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706495129; cv=none; b=MRWXWzJcXZRYjYIIIQkeYiKMWJeg+jSlmubKUD2nx9HfMtAhYeI55xjmTf86Ser5PK4n1/lJhX6t3CjQGMECbBP2g8jjqvuFk2x9OSDkhA++jiVHHf0CXFrcEeJemKjHbEvyDE450SPkSTGgWJaglDKCjvd64YBE14ja4zLhJ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706495129; c=relaxed/simple;
	bh=NQc3Y2ZYg20HsTJImz149KgJw3YKh2F1FJZjTB/UiV4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AEPgNEZW6E+SvQbZC+t/e4KA/7uc/cpSdNrYkMGb9BH5LM/mMspSleBx6rEQl/O054x/0jkvAmc5XuX3FUvhxChnu7K8SYjqdo0hUGozCWbxe4eQH0q23I8rAd4cD4Jf6PkASdzK/PWhQ/PvArB1JWgEj7VEnB2O997gpTubBTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4TNXDT1H31z1Q8Y1;
	Mon, 29 Jan 2024 10:24:09 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id EAFF91404F7;
	Mon, 29 Jan 2024 10:25:17 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 10:25:17 +0800
Subject: Re: [PATCH 1/3] hisi_acc_vfio_pci: extract public functions for
 container_of
To: Zhi Wang <zhi.wang.linux@gmail.com>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>
References: <20240125081031.48707-1-liulongfang@huawei.com>
 <20240125081031.48707-2-liulongfang@huawei.com>
 <20240125234813.00005f5d.zhi.wang.linux@gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <7e2c917e-f7a8-1f36-c644-8057764d668c@huawei.com>
Date: Mon, 29 Jan 2024 10:25:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240125234813.00005f5d.zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On 2024/1/26 5:48, Zhi Wang wrote:
> On Thu, 25 Jan 2024 16:10:29 +0800
> Longfang Liu <liulongfang@huawei.com> wrote:
> 
>> In the current driver, vdev is obtained from struct
>> hisi_acc_vf_core_device through the container_of function.
>> This method is used in many places in the driver. In order to
>> reduce this repetitive operation, I extracted a public function
>> to replace it.
>>
> It is better to use the passive voice in the patch comment.

OK,

Thanks,
Longfang.
>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>> ---
>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 21
>> ++++++++++--------- 1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c index
>> f4b38a243aa7..5f6e01571a7b 100644 ---
>> a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c +++
>> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c @@ -641,6 +641,12 @@
>> static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
>> *hisi_acc_vde } }
>>  
>> +static struct hisi_acc_vf_core_device *hisi_acc_get_vf_dev(struct
>> vfio_device *vdev) +{
>> +	return container_of(vdev, struct hisi_acc_vf_core_device,
>> +			    core_device.vdev);
>> +}
>> +
>>  /*
>>   * This function is called in all state_mutex unlock cases to
>>   * handle a 'deferred_reset' if exists.
>> @@ -1064,8 +1070,7 @@ static struct file *
>>  hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
>>  				   enum vfio_device_mig_state
>> new_state) {
>> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> container_of(vdev,
>> -			struct hisi_acc_vf_core_device,
>> core_device.vdev);
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev); enum vfio_device_mig_state next_state;
>>  	struct file *res = NULL;
>>  	int ret;
>> @@ -1106,8 +1111,7 @@ static int
>>  hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>>  				   enum vfio_device_mig_state
>> *curr_state) {
>> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> container_of(vdev,
>> -			struct hisi_acc_vf_core_device,
>> core_device.vdev);
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(vdev); 
>>  	mutex_lock(&hisi_acc_vdev->state_mutex);
>>  	*curr_state = hisi_acc_vdev->mig_state;
>> @@ -1323,8 +1327,7 @@ static long hisi_acc_vfio_pci_ioctl(struct
>> vfio_device *core_vdev, unsigned int 
>>  static int hisi_acc_vfio_pci_open_device(struct vfio_device
>> *core_vdev) {
>> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> container_of(core_vdev,
>> -			struct hisi_acc_vf_core_device,
>> core_device.vdev);
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(core_vdev); struct vfio_pci_core_device *vdev =
>> &hisi_acc_vdev->core_device; int ret;
>>  
>> @@ -1347,8 +1350,7 @@ static int hisi_acc_vfio_pci_open_device(struct
>> vfio_device *core_vdev) 
>>  static void hisi_acc_vfio_pci_close_device(struct vfio_device
>> *core_vdev) {
>> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> container_of(core_vdev,
>> -			struct hisi_acc_vf_core_device,
>> core_device.vdev);
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(core_vdev); struct hisi_qm *vf_qm =
>> &hisi_acc_vdev->vf_qm; 
>>  	iounmap(vf_qm->io_base);
>> @@ -1363,8 +1365,7 @@ static const struct vfio_migration_ops
>> hisi_acc_vfio_pci_migrn_state_ops = { 
>>  static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device
>> *core_vdev) {
>> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> container_of(core_vdev,
>> -			struct hisi_acc_vf_core_device,
>> core_device.vdev);
>> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
>> hisi_acc_get_vf_dev(core_vdev); struct pci_dev *pdev =
>> to_pci_dev(core_vdev->dev); struct hisi_qm *pf_qm =
>> hisi_acc_get_pf_qm(pdev); 
> 
> .
> 

