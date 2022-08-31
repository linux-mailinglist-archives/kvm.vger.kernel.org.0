Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C05A7791
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 09:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiHaHgJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 31 Aug 2022 03:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiHaHgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 03:36:07 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFC5A98C8;
        Wed, 31 Aug 2022 00:36:05 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MHbYs4Xj8z688fw;
        Wed, 31 Aug 2022 15:35:29 +0800 (CST)
Received: from lhrpeml500002.china.huawei.com (7.191.160.78) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 09:36:03 +0200
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500002.china.huawei.com (7.191.160.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 31 Aug 2022 08:36:02 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.024;
 Wed, 31 Aug 2022 08:36:02 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Kevin Tian <kevin.tian@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Peter Oberparleiter" <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Yishai Hadas" <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Yi Liu <yi.l.liu@intel.com>
Subject: RE: [PATCH 04/15] vfio/hisi_acc: Use the new device life cycle
 helpers
Thread-Topic: [PATCH 04/15] vfio/hisi_acc: Use the new device life cycle
 helpers
Thread-Index: AQHYufp2da3qAvP1z0GEpuKhp3q5ba3Io6tw
Date:   Wed, 31 Aug 2022 07:36:02 +0000
Message-ID: <fcbcc84a6c1148fa943576522cb906ce@huawei.com>
References: <20220827171037.30297-1-kevin.tian@intel.com>
 <20220827171037.30297-5-kevin.tian@intel.com>
In-Reply-To: <20220827171037.30297-5-kevin.tian@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.195.245.177]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Kevin Tian [mailto:kevin.tian@intel.com]
> Sent: 27 August 2022 18:10
> To: Zhenyu Wang <zhenyuw@linux.intel.com>; Zhi Wang
> <zhi.a.wang@intel.com>; Jani Nikula <jani.nikula@linux.intel.com>; Joonas
> Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> <rodrigo.vivi@intel.com>; Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>;
> David Airlie <airlied@linux.ie>; Daniel Vetter <daniel@ffwll.ch>; Eric Farman
> <farman@linux.ibm.com>; Matthew Rosato <mjrosato@linux.ibm.com>;
> Halil Pasic <pasic@linux.ibm.com>; Vineeth Vijayan
> <vneethv@linux.ibm.com>; Peter Oberparleiter <oberpar@linux.ibm.com>;
> Heiko Carstens <hca@linux.ibm.com>; Vasily Gorbik <gor@linux.ibm.com>;
> Alexander Gordeev <agordeev@linux.ibm.com>; Christian Borntraeger
> <borntraeger@linux.ibm.com>; Sven Schnelle <svens@linux.ibm.com>; Tony
> Krowiak <akrowiak@linux.ibm.com>; Jason Herne <jjherne@linux.ibm.com>;
> Harald Freudenberger <freude@linux.ibm.com>; Diana Craciun
> <diana.craciun@oss.nxp.com>; Alex Williamson
> <alex.williamson@redhat.com>; Cornelia Huck <cohuck@redhat.com>;
> liulongfang <liulongfang@huawei.com>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Jason Gunthorpe
> <jgg@ziepe.ca>; Yishai Hadas <yishaih@nvidia.com>; Kevin Tian
> <kevin.tian@intel.com>; Eric Auger <eric.auger@redhat.com>; Kirti
> Wankhede <kwankhede@nvidia.com>; Leon Romanovsky <leon@kernel.org>;
> Abhishek Sahu <abhsahu@nvidia.com>; intel-gvt-dev@lists.freedesktop.org;
> intel-gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org;
> linux-kernel@vger.kernel.org; linux-s390@vger.kernel.org;
> kvm@vger.kernel.org
> Cc: Yi Liu <yi.l.liu@intel.com>
> Subject: [PATCH 04/15] vfio/hisi_acc: Use the new device life cycle helpers
> 
> From: Yi Liu <yi.l.liu@intel.com>
> 
> Tidy up @probe so all migration specific initialization logic is moved
> to migration specific @init callback.
> 
> Remove vfio_pci_core_{un}init_device() given no user now.

This looks fine to me and the probe() is indeed much cleaner now.

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer
 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 80 +++++++++----------
>  drivers/vfio/pci/vfio_pci_core.c              | 30 -------
>  include/linux/vfio_pci_core.h                 |  4 -
>  3 files changed, 37 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index ea762e28c1cc..f06f9a799128 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1213,8 +1213,28 @@ static const struct vfio_migration_ops
> hisi_acc_vfio_pci_migrn_state_ops = {
>  	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
>  };
> 
> +int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> container_of(core_vdev,
> +			struct hisi_acc_vf_core_device, core_device.vdev);
> +	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
> +	struct hisi_qm *pf_qm = hisi_acc_get_pf_qm(pdev);
> +
> +	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
> +	hisi_acc_vdev->pf_qm = pf_qm;
> +	hisi_acc_vdev->vf_dev = pdev;
> +	mutex_init(&hisi_acc_vdev->state_mutex);
> +
> +	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY;
> +	core_vdev->mig_ops = &hisi_acc_vfio_pci_migrn_state_ops;
> +
> +	return vfio_pci_core_init_dev(core_vdev);
> +}
> +
>  static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>  	.name = "hisi-acc-vfio-pci-migration",
> +	.init = hisi_acc_vfio_pci_migrn_init_dev,
> +	.release = vfio_pci_core_release_dev,
>  	.open_device = hisi_acc_vfio_pci_open_device,
>  	.close_device = hisi_acc_vfio_pci_close_device,
>  	.ioctl = hisi_acc_vfio_pci_ioctl,
> @@ -1228,6 +1248,8 @@ static const struct vfio_device_ops
> hisi_acc_vfio_pci_migrn_ops = {
> 
>  static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.name = "hisi-acc-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
>  	.open_device = hisi_acc_vfio_pci_open_device,
>  	.close_device = vfio_pci_core_close_device,
>  	.ioctl = vfio_pci_core_ioctl,
> @@ -1239,63 +1261,36 @@ static const struct vfio_device_ops
> hisi_acc_vfio_pci_ops = {
>  	.match = vfio_pci_core_match,
>  };
> 
> -static int
> -hisi_acc_vfio_pci_migrn_init(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> -			     struct pci_dev *pdev, struct hisi_qm *pf_qm)
> -{
> -	int vf_id;
> -
> -	vf_id = pci_iov_vf_id(pdev);
> -	if (vf_id < 0)
> -		return vf_id;
> -
> -	hisi_acc_vdev->vf_id = vf_id + 1;
> -	hisi_acc_vdev->core_device.vdev.migration_flags =
> -					VFIO_MIGRATION_STOP_COPY;
> -	hisi_acc_vdev->pf_qm = pf_qm;
> -	hisi_acc_vdev->vf_dev = pdev;
> -	mutex_init(&hisi_acc_vdev->state_mutex);
> -
> -	return 0;
> -}
> -
>  static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev;
> +	const struct vfio_device_ops *ops = &hisi_acc_vfio_pci_ops;
>  	struct hisi_qm *pf_qm;
> +	int vf_id;
>  	int ret;
> 
> -	hisi_acc_vdev = kzalloc(sizeof(*hisi_acc_vdev), GFP_KERNEL);
> -	if (!hisi_acc_vdev)
> -		return -ENOMEM;
> -
>  	pf_qm = hisi_acc_get_pf_qm(pdev);
>  	if (pf_qm && pf_qm->ver >= QM_HW_V3) {
> -		ret = hisi_acc_vfio_pci_migrn_init(hisi_acc_vdev, pdev, pf_qm);
> -		if (!ret) {
> -			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
> -						  &hisi_acc_vfio_pci_migrn_ops);
> -			hisi_acc_vdev->core_device.vdev.mig_ops =
> -					&hisi_acc_vfio_pci_migrn_state_ops;
> -		} else {
> +		vf_id = pci_iov_vf_id(pdev);
> +		if (vf_id >= 0)
> +			ops = &hisi_acc_vfio_pci_migrn_ops;
> +		else
>  			pci_warn(pdev, "migration support failed, continue with
> generic interface\n");
> -			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
> -						  &hisi_acc_vfio_pci_ops);
> -		}
> -	} else {
> -		vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
> -					  &hisi_acc_vfio_pci_ops);
>  	}
> 
> +	hisi_acc_vdev = vfio_alloc_device(hisi_acc_vf_core_device,
> +					  core_device.vdev, &pdev->dev, ops);
> +	if (IS_ERR(hisi_acc_vdev))
> +		return PTR_ERR(hisi_acc_vdev);
> +
>  	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
> -		goto out_free;
> +		goto out_put_vdev;
>  	return 0;
> 
> -out_free:
> -	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
> -	kfree(hisi_acc_vdev);
> +out_put_vdev:
> +	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>  	return ret;
>  }
> 
> @@ -1304,8 +1299,7 @@ static void hisi_acc_vfio_pci_remove(struct
> pci_dev *pdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> hssi_acc_drvdata(pdev);
> 
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> -	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
> -	kfree(hisi_acc_vdev);
> +	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>  }
> 
>  static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 708b61d1b364..f29d780e327e 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1860,36 +1860,6 @@ void vfio_pci_core_release_dev(struct
> vfio_device *core_vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_release_dev);
> 
> -void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
> -			       struct pci_dev *pdev,
> -			       const struct vfio_device_ops *vfio_pci_ops)
> -{
> -	vfio_init_group_dev(&vdev->vdev, &pdev->dev, vfio_pci_ops);
> -	vdev->pdev = pdev;
> -	vdev->irq_type = VFIO_PCI_NUM_IRQS;
> -	mutex_init(&vdev->igate);
> -	spin_lock_init(&vdev->irqlock);
> -	mutex_init(&vdev->ioeventfds_lock);
> -	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> -	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> -	mutex_init(&vdev->vma_lock);
> -	INIT_LIST_HEAD(&vdev->vma_list);
> -	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> -	init_rwsem(&vdev->memory_lock);
> -}
> -EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
> -
> -void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
> -{
> -	mutex_destroy(&vdev->igate);
> -	mutex_destroy(&vdev->ioeventfds_lock);
> -	mutex_destroy(&vdev->vma_lock);
> -	vfio_uninit_group_dev(&vdev->vdev);
> -	kfree(vdev->region);
> -	kfree(vdev->pm_save);
> -}
> -EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
> -
>  int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 98c8c66e2400..9f10ff34b2ba 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -230,13 +230,9 @@ static inline void vfio_pci_zdev_close_device(struct
> vfio_pci_core_device *vdev)
>  void vfio_pci_core_set_params(bool nointxmask, bool is_disable_vga,
>  			      bool is_disable_idle_d3);
>  void vfio_pci_core_close_device(struct vfio_device *core_vdev);
> -void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
> -			       struct pci_dev *pdev,
> -			       const struct vfio_device_ops *vfio_pci_ops);
>  int vfio_pci_core_init_dev(struct vfio_device *core_vdev);
>  void vfio_pci_core_release_dev(struct vfio_device *core_vdev);
>  int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
> -void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
>  extern const struct pci_error_handlers vfio_pci_core_err_handlers;
>  int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
> --
> 2.21.3

