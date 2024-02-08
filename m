Return-Path: <kvm+bounces-8335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D5B84E083
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AFD5283C17
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 12:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE9171B50;
	Thu,  8 Feb 2024 12:17:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC736F531;
	Thu,  8 Feb 2024 12:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707394633; cv=none; b=OVQ1dLJQufVIXnVXfj8zQ3KKiYIrQ8QvXXcXx9MVJQoj3lwd0H0waICMllvWjx3+mYKl9E4v/oqIdT3AKDpqXkbzDO41lvnG/7+OEQICkojFBsh+5zpphXO4jGsmCHL5S9KOBqU8KkKlgnqLTIOIXdXcpYKwgmaYPY83+DIjwfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707394633; c=relaxed/simple;
	bh=C3oeOp8YfXOo+Se1+KX0XOTodIUTKD+pwKq8Jp1htbs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QnURWdj80XqUo0f18BFOP74vWAgFVuwBgPYd0gLSL/geH9/pq5UOKC0F8sYhgrz+V8JTnTfY0kX8omx6C7skfXmz3ad9HFWrKfmsqinowLd/otnbdWRniYDpWuOauyVNZHECbsJ0I3SzwTIepVFQMc+UOuj1mETVBVqkBJ4G9yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TVwr856YPz6K61b;
	Thu,  8 Feb 2024 20:13:44 +0800 (CST)
Received: from lhrpeml100003.china.huawei.com (unknown [7.191.160.210])
	by mail.maildlp.com (Postfix) with ESMTPS id 36FEA140DDE;
	Thu,  8 Feb 2024 20:17:06 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100003.china.huawei.com (7.191.160.210) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 12:17:05 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Thu, 8 Feb 2024 12:17:05 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Xin Zeng <xin.zeng@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "qat-linux@intel.com"
	<qat-linux@intel.com>, Yahui Cao <yahui.cao@intel.com>
Subject: RE: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaVSVEutyP1jeOpU6xob8qplt1VrEANOvA
Date: Thu, 8 Feb 2024 12:17:05 +0000
Message-ID: <972cc8a41a8549d19ed897ee7335f9e0@huawei.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
In-Reply-To: <20240201153337.4033490-11-xin.zeng@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



> -----Original Message-----
> From: Xin Zeng <xin.zeng@intel.com>
> Sent: Thursday, February 1, 2024 3:34 PM
> To: herbert@gondor.apana.org.au; alex.williamson@redhat.com;
> jgg@nvidia.com; yishaih@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kevin.tian@intel.com
> Cc: linux-crypto@vger.kernel.org; kvm@vger.kernel.org; qat-
> linux@intel.com; Xin Zeng <xin.zeng@intel.com>; Yahui Cao
> <yahui.cao@intel.com>
> Subject: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF dev=
ices
>=20
> Add vfio pci driver for Intel QAT VF devices.
>=20
> This driver uses vfio_pci_core to register to the VFIO subsystem. It
> acts as a vfio agent and interacts with the QAT PF driver to implement
> VF live migration.
>=20
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  MAINTAINERS                         |   8 +
>  drivers/vfio/pci/Kconfig            |   2 +
>  drivers/vfio/pci/Makefile           |   2 +
>  drivers/vfio/pci/intel/qat/Kconfig  |  13 +
>  drivers/vfio/pci/intel/qat/Makefile |   4 +
>  drivers/vfio/pci/intel/qat/main.c   | 572 ++++++++++++++++++++++++++++
>  6 files changed, 601 insertions(+)
>  create mode 100644 drivers/vfio/pci/intel/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/intel/qat/Makefile
>  create mode 100644 drivers/vfio/pci/intel/qat/main.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8d1052fa6a69..c1d3e4cb3892 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23095,6 +23095,14 @@ S:	Maintained
>  F:
> 	Documentation/networking/device_drivers/ethernet/amd/pds_vfio_
> pci.rst
>  F:	drivers/vfio/pci/pds/
>=20
> +VFIO QAT PCI DRIVER
> +M:	Xin Zeng <xin.zeng@intel.com>
> +M:	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> +L:	kvm@vger.kernel.org
> +L:	qat-linux@intel.com
> +S:	Supported
> +F:	drivers/vfio/pci/intel/qat/
> +
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  L:	kvm@vger.kernel.org
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 18c397df566d..329d25c53274 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -67,4 +67,6 @@ source "drivers/vfio/pci/pds/Kconfig"
>=20
>  source "drivers/vfio/pci/virtio/Kconfig"
>=20
> +source "drivers/vfio/pci/intel/qat/Kconfig"
> +
>  endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 046139a4eca5..a87b6b43ce1c 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -15,3 +15,5 @@ obj-$(CONFIG_HISI_ACC_VFIO_PCI) +=3D hisilicon/
>  obj-$(CONFIG_PDS_VFIO_PCI) +=3D pds/
>=20
>  obj-$(CONFIG_VIRTIO_VFIO_PCI) +=3D virtio/
> +
> +obj-$(CONFIG_QAT_VFIO_PCI) +=3D intel/qat/
> diff --git a/drivers/vfio/pci/intel/qat/Kconfig
> b/drivers/vfio/pci/intel/qat/Kconfig
> new file mode 100644
> index 000000000000..71b28ac0bf6a
> --- /dev/null
> +++ b/drivers/vfio/pci/intel/qat/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config QAT_VFIO_PCI
> +	tristate "VFIO support for QAT VF PCI devices"
> +	select VFIO_PCI_CORE
> +	depends on CRYPTO_DEV_QAT
> +	depends on CRYPTO_DEV_QAT_4XXX
> +	help
> +	  This provides migration support for Intel(R) QAT Virtual Function
> +	  using the VFIO framework.
> +
> +	  To compile this as a module, choose M here: the module
> +	  will be called qat_vfio_pci. If you don't know what to do here,
> +	  say N.
> diff --git a/drivers/vfio/pci/intel/qat/Makefile
> b/drivers/vfio/pci/intel/qat/Makefile
> new file mode 100644
> index 000000000000..9289ae4c51bf
> --- /dev/null
> +++ b/drivers/vfio/pci/intel/qat/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_QAT_VFIO_PCI) +=3D qat_vfio_pci.o
> +qat_vfio_pci-y :=3D main.o
> +
> diff --git a/drivers/vfio/pci/intel/qat/main.c
> b/drivers/vfio/pci/intel/qat/main.c
> new file mode 100644
> index 000000000000..85d0ed701397
> --- /dev/null
> +++ b/drivers/vfio/pci/intel/qat/main.c
> @@ -0,0 +1,572 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2024 Intel Corporation */
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/container_of.h>
> +#include <linux/device.h>
> +#include <linux/file.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>
> +#include <linux/sizes.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/qat/qat_mig_dev.h>
> +
> +struct qat_vf_migration_file {
> +	struct file *filp;
> +	/* protects migration region context */
> +	struct mutex lock;
> +	bool disabled;
> +	struct qat_mig_dev *mdev;
> +};
> +
> +struct qat_vf_core_device {
> +	struct vfio_pci_core_device core_device;
> +	struct qat_mig_dev *mdev;
> +	/* protects migration state */
> +	struct mutex state_mutex;
> +	enum vfio_device_mig_state mig_state;
> +	/* protects reset down flow */
> +	spinlock_t reset_lock;
> +	bool deferred_reset;
> +	struct qat_vf_migration_file *resuming_migf;
> +	struct qat_vf_migration_file *saving_migf;
> +};
> +
> +static int qat_vf_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D
> +		container_of(core_vdev, struct qat_vf_core_device,
> +			     core_device.vdev);
> +	struct vfio_pci_core_device *vdev =3D &qat_vdev->core_device;
> +	int ret;
> +
> +	ret =3D vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D qat_vdev->mdev->ops->open(qat_vdev->mdev);
> +	if (ret) {
> +		vfio_pci_core_disable(vdev);
> +		return ret;
> +	}
> +	qat_vdev->mig_state =3D VFIO_DEVICE_STATE_RUNNING;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	return 0;
> +}
> +
> +static void qat_vf_disable_fd(struct qat_vf_migration_file *migf)
> +{
> +	mutex_lock(&migf->lock);
> +	migf->disabled =3D true;
> +	migf->filp->f_pos =3D 0;
> +	mutex_unlock(&migf->lock);
> +}
> +
> +static void qat_vf_disable_fds(struct qat_vf_core_device *qat_vdev)
> +{
> +	if (qat_vdev->resuming_migf) {
> +		qat_vf_disable_fd(qat_vdev->resuming_migf);
> +		fput(qat_vdev->resuming_migf->filp);
> +		qat_vdev->resuming_migf =3D NULL;
> +	}
> +
> +	if (qat_vdev->saving_migf) {
> +		qat_vf_disable_fd(qat_vdev->saving_migf);
> +		fput(qat_vdev->saving_migf->filp);
> +		qat_vdev->saving_migf =3D NULL;
> +	}
> +}
> +
> +static void qat_vf_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D container_of(core_vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +
> +	qat_vdev->mdev->ops->close(qat_vdev->mdev);
> +	qat_vf_disable_fds(qat_vdev);
> +	vfio_pci_core_close_device(core_vdev);
> +}
> +
> +static ssize_t qat_vf_save_read(struct file *filp, char __user *buf,
> +				size_t len, loff_t *pos)
> +{
> +	struct qat_vf_migration_file *migf =3D filp->private_data;
> +	ssize_t done =3D 0;
> +	loff_t *offs;
> +	int ret;
> +
> +	if (pos)
> +		return -ESPIPE;
> +	offs =3D &filp->f_pos;
> +
> +	mutex_lock(&migf->lock);
> +	if (*offs > migf->mdev->state_size || *offs < 0) {
> +		done =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	if (migf->disabled) {
> +		done =3D -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	len =3D min_t(size_t, migf->mdev->state_size - *offs, len);
> +	if (len) {
> +		ret =3D copy_to_user(buf, migf->mdev->state + *offs, len);
> +		if (ret) {
> +			done =3D -EFAULT;
> +			goto out_unlock;
> +		}
> +		*offs +=3D len;
> +		done =3D len;
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&migf->lock);
> +	return done;
> +}
> +
> +static int qat_vf_release_file(struct inode *inode, struct file *filp)
> +{
> +	struct qat_vf_migration_file *migf =3D filp->private_data;
> +
> +	qat_vf_disable_fd(migf);
> +	mutex_destroy(&migf->lock);
> +	kfree(migf);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations qat_vf_save_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.read =3D qat_vf_save_read,
> +	.release =3D qat_vf_release_file,
> +	.llseek =3D no_llseek,
> +};
> +
> +static struct qat_vf_migration_file *
> +qat_vf_save_device_data(struct qat_vf_core_device *qat_vdev)
> +{
> +	struct qat_vf_migration_file *migf;
> +	int ret;
> +
> +	migf =3D kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp =3D anon_inode_getfile("qat_vf_mig", &qat_vf_save_fops,
> migf, O_RDONLY);
> +	ret =3D PTR_ERR_OR_ZERO(migf->filp);
> +	if (ret) {
> +		kfree(migf);
> +		return ERR_PTR(ret);
> +	}
> +
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +
> +	ret =3D qat_vdev->mdev->ops->save_state(qat_vdev->mdev);
> +	if (ret) {
> +		fput(migf->filp);
> +		kfree(migf);

Probably don't need that kfree(migf) here as fput() -->  qat_vf_release_fil=
e () will do that.

> +		return ERR_PTR(ret);
> +	}
> +
> +	migf->mdev =3D qat_vdev->mdev;
> +
> +	return migf;
> +}
> +
> +static ssize_t qat_vf_resume_write(struct file *filp, const char __user =
*buf,
> +				   size_t len, loff_t *pos)
> +{
> +	struct qat_vf_migration_file *migf =3D filp->private_data;
> +	loff_t end, *offs;
> +	ssize_t done =3D 0;
> +	int ret;
> +
> +	if (pos)
> +		return -ESPIPE;
> +	offs =3D &filp->f_pos;
> +
> +	if (*offs < 0 ||
> +	    check_add_overflow((loff_t)len, *offs, &end))
> +		return -EOVERFLOW;
> +
> +	if (end > migf->mdev->state_size)
> +		return -ENOMEM;
> +
> +	mutex_lock(&migf->lock);
> +	if (migf->disabled) {
> +		done =3D -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	ret =3D copy_from_user(migf->mdev->state + *offs, buf, len);
> +	if (ret) {
> +		done =3D -EFAULT;
> +		goto out_unlock;
> +	}
> +	*offs +=3D len;
> +	done =3D len;
> +
> +out_unlock:
> +	mutex_unlock(&migf->lock);
> +	return done;
> +}
> +
> +static const struct file_operations qat_vf_resume_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.write =3D qat_vf_resume_write,
> +	.release =3D qat_vf_release_file,
> +	.llseek =3D no_llseek,
> +};
> +
> +static struct qat_vf_migration_file *
> +qat_vf_resume_device_data(struct qat_vf_core_device *qat_vdev)
> +{
> +	struct qat_vf_migration_file *migf;
> +	int ret;
> +
> +	migf =3D kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp =3D anon_inode_getfile("qat_vf_mig", &qat_vf_resume_fops,
> migf, O_WRONLY);
> +	ret =3D PTR_ERR_OR_ZERO(migf->filp);
> +	if (ret) {
> +		kfree(migf);
> +		return ERR_PTR(ret);
> +	}
> +
> +	migf->mdev =3D qat_vdev->mdev;
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +
> +	return migf;
> +}
> +
> +static int qat_vf_load_device_data(struct qat_vf_core_device *qat_vdev)
> +{
> +	return qat_vdev->mdev->ops->load_state(qat_vdev->mdev);
> +}
> +
> +static struct file *qat_vf_pci_step_device_state(struct qat_vf_core_devi=
ce
> *qat_vdev, u32 new)
> +{
> +	u32 cur =3D qat_vdev->mig_state;
> +	int ret;
> +
> +	if ((cur =3D=3D VFIO_DEVICE_STATE_RUNNING && new =3D=3D
> VFIO_DEVICE_STATE_RUNNING_P2P)) {
> +		ret =3D qat_vdev->mdev->ops->suspend(qat_vdev->mdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +		return NULL;
> +	}
> +
> +	if ((cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P && new =3D=3D
> VFIO_DEVICE_STATE_STOP) ||
> +	    (cur =3D=3D VFIO_DEVICE_STATE_STOP && new =3D=3D
> VFIO_DEVICE_STATE_RUNNING_P2P))
> +		return NULL;
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_STOP && new =3D=3D
> VFIO_DEVICE_STATE_STOP_COPY) {
> +		struct qat_vf_migration_file *migf;
> +
> +		migf =3D qat_vf_save_device_data(qat_vdev);
> +		if (IS_ERR(migf))
> +			return ERR_CAST(migf);
> +		get_file(migf->filp);
> +		qat_vdev->saving_migf =3D migf;
> +		return migf->filp;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_STOP_COPY && new =3D=3D
> VFIO_DEVICE_STATE_STOP) {
> +		qat_vf_disable_fds(qat_vdev);
> +		return NULL;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_STOP && new =3D=3D
> VFIO_DEVICE_STATE_RESUMING) {
> +		struct qat_vf_migration_file *migf;
> +
> +		migf =3D qat_vf_resume_device_data(qat_vdev);
> +		if (IS_ERR(migf))
> +			return ERR_CAST(migf);
> +		get_file(migf->filp);
> +		qat_vdev->resuming_migf =3D migf;
> +		return migf->filp;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RESUMING && new =3D=3D
> VFIO_DEVICE_STATE_STOP) {
> +		ret =3D qat_vf_load_device_data(qat_vdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +
> +		qat_vf_disable_fds(qat_vdev);
> +		return NULL;
> +	}
> +
> +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P && new =3D=3D
> VFIO_DEVICE_STATE_RUNNING) {
> +		qat_vdev->mdev->ops->resume(qat_vdev->mdev);
> +		return NULL;
> +	}
> +
> +	/* vfio_mig_get_next_state() does not use arcs other than the above
> */
> +	WARN_ON(true);
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static void qat_vf_state_mutex_unlock(struct qat_vf_core_device
> *qat_vdev)
> +{
> +again:
> +	spin_lock(&qat_vdev->reset_lock);
> +	if (qat_vdev->deferred_reset) {
> +		qat_vdev->deferred_reset =3D false;
> +		spin_unlock(&qat_vdev->reset_lock);
> +		qat_vdev->mig_state =3D VFIO_DEVICE_STATE_RUNNING;
> +		qat_vf_disable_fds(qat_vdev);
> +		goto again;
> +	}
> +	mutex_unlock(&qat_vdev->state_mutex);
> +	spin_unlock(&qat_vdev->reset_lock);
> +}
> +
> +static struct file *qat_vf_pci_set_device_state(struct vfio_device *vdev=
,
> +						enum vfio_device_mig_state
> new_state)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D container_of(vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +	enum vfio_device_mig_state next_state;
> +	struct file *res =3D NULL;
> +	int ret;
> +
> +	mutex_lock(&qat_vdev->state_mutex);
> +	while (new_state !=3D qat_vdev->mig_state) {
> +		ret =3D vfio_mig_get_next_state(vdev, qat_vdev->mig_state,
> +					      new_state, &next_state);
> +		if (ret) {
> +			res =3D ERR_PTR(ret);
> +			break;
> +		}
> +		res =3D qat_vf_pci_step_device_state(qat_vdev, next_state);
> +		if (IS_ERR(res))
> +			break;
> +		qat_vdev->mig_state =3D next_state;
> +		if (WARN_ON(res && new_state !=3D qat_vdev->mig_state)) {
> +			fput(res);
> +			res =3D ERR_PTR(-EINVAL);
> +			break;
> +		}
> +	}
> +	qat_vf_state_mutex_unlock(qat_vdev);
> +
> +	return res;
> +}
> +
> +static int qat_vf_pci_get_device_state(struct vfio_device *vdev,
> +				       enum vfio_device_mig_state *curr_state)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D container_of(vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +
> +	mutex_lock(&qat_vdev->state_mutex);
> +	*curr_state =3D qat_vdev->mig_state;
> +	qat_vf_state_mutex_unlock(qat_vdev);
> +
> +	return 0;
> +}
> +
> +static int qat_vf_pci_get_data_size(struct vfio_device *vdev,
> +				    unsigned long *stop_copy_length)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D container_of(vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +
> +	*stop_copy_length =3D qat_vdev->mdev->state_size;

Do we need a lock here or this is not changing?

> +	return 0;
> +}
> +
> +static const struct vfio_migration_ops qat_vf_pci_mig_ops =3D {
> +	.migration_set_state =3D qat_vf_pci_set_device_state,
> +	.migration_get_state =3D qat_vf_pci_get_device_state,
> +	.migration_get_data_size =3D qat_vf_pci_get_data_size,
> +};
> +
> +static void qat_vf_pci_release_dev(struct vfio_device *core_vdev)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D container_of(core_vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +
> +	qat_vdev->mdev->ops->cleanup(qat_vdev->mdev);
> +	qat_vfmig_destroy(qat_vdev->mdev);
> +	mutex_destroy(&qat_vdev->state_mutex);
> +	vfio_pci_core_release_dev(core_vdev);
> +}
> +
> +static int qat_vf_pci_init_dev(struct vfio_device *core_vdev)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D container_of(core_vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +	struct qat_migdev_ops *ops;
> +	struct qat_mig_dev *mdev;
> +	struct pci_dev *parent;
> +	int ret, vf_id;
> +
> +	core_vdev->migration_flags =3D VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_P2P;
> +	core_vdev->mig_ops =3D &qat_vf_pci_mig_ops;
> +
> +	ret =3D vfio_pci_core_init_dev(core_vdev);
> +	if (ret)
> +		return ret;
> +
> +	mutex_init(&qat_vdev->state_mutex);
> +	spin_lock_init(&qat_vdev->reset_lock);
> +
> +	parent =3D qat_vdev->core_device.pdev->physfn;

Can we use pci_physfn() here?

> +	vf_id =3D pci_iov_vf_id(qat_vdev->core_device.pdev);
> +	if (!parent || vf_id < 0) {

Also if the pci_iov_vf_id() return success I don't think you need to=20
check for parent and can use directly below.

> +		ret =3D -ENODEV;
> +		goto err_rel;
> +	}
> +
> +	mdev =3D qat_vfmig_create(parent, vf_id);
> +	if (IS_ERR(mdev)) {
> +		ret =3D PTR_ERR(mdev);
> +		goto err_rel;
> +	}
> +
> +	ops =3D mdev->ops;
> +	if (!ops || !ops->init || !ops->cleanup ||
> +	    !ops->open || !ops->close ||
> +	    !ops->save_state || !ops->load_state ||
> +	    !ops->suspend || !ops->resume) {
> +		ret =3D -EIO;
> +		dev_err(&parent->dev, "Incomplete device migration ops
> structure!");
> +		goto err_destroy;
> +	}

If all these ops are a must why cant we move the check inside the qat_vfmig=
_create()?
Or rather call them explicitly as suggested by Jason.

Thanks,
Shameer

> +	ret =3D ops->init(mdev);
> +	if (ret)
> +		goto err_destroy;
> +
> +	qat_vdev->mdev =3D mdev;
> +
> +	return 0;
> +
> +err_destroy:
> +	qat_vfmig_destroy(mdev);
> +err_rel:
> +	vfio_pci_core_release_dev(core_vdev);
> +	return ret;
> +}
> +
> +static const struct vfio_device_ops qat_vf_pci_ops =3D {
> +	.name =3D "qat-vf-vfio-pci",
> +	.init =3D qat_vf_pci_init_dev,
> +	.release =3D qat_vf_pci_release_dev,
> +	.open_device =3D qat_vf_pci_open_device,
> +	.close_device =3D qat_vf_pci_close_device,
> +	.ioctl =3D vfio_pci_core_ioctl,
> +	.read =3D vfio_pci_core_read,
> +	.write =3D vfio_pci_core_write,
> +	.mmap =3D vfio_pci_core_mmap,
> +	.request =3D vfio_pci_core_request,
> +	.match =3D vfio_pci_core_match,
> +	.bind_iommufd =3D vfio_iommufd_physical_bind,
> +	.unbind_iommufd =3D vfio_iommufd_physical_unbind,
> +	.attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas =3D vfio_iommufd_physical_detach_ioas,
> +};
> +
> +static struct qat_vf_core_device *qat_vf_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device =3D pci_get_drvdata(pdev);
> +
> +	return container_of(core_device, struct qat_vf_core_device,
> core_device);
> +}
> +
> +static void qat_vf_pci_aer_reset_done(struct pci_dev *pdev)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D qat_vf_drvdata(pdev);
> +
> +	if (!qat_vdev->core_device.vdev.mig_ops)
> +		return;
> +
> +	/*
> +	 * As the higher VFIO layers are holding locks across reset and using
> +	 * those same locks with the mm_lock we need to prevent ABBA
> deadlock
> +	 * with the state_mutex and mm_lock.
> +	 * In case the state_mutex was taken already we defer the cleanup
> work
> +	 * to the unlock flow of the other running context.
> +	 */
> +	spin_lock(&qat_vdev->reset_lock);
> +	qat_vdev->deferred_reset =3D true;
> +	if (!mutex_trylock(&qat_vdev->state_mutex)) {
> +		spin_unlock(&qat_vdev->reset_lock);
> +		return;
> +	}
> +	spin_unlock(&qat_vdev->reset_lock);
> +	qat_vf_state_mutex_unlock(qat_vdev);
> +}
> +
> +static int
> +qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *=
id)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct qat_vf_core_device *qat_vdev;
> +	int ret;
> +
> +	qat_vdev =3D vfio_alloc_device(qat_vf_core_device, core_device.vdev,
> dev, &qat_vf_pci_ops);
> +	if (IS_ERR(qat_vdev))
> +		return PTR_ERR(qat_vdev);
> +
> +	pci_set_drvdata(pdev, &qat_vdev->core_device);
> +	ret =3D vfio_pci_core_register_device(&qat_vdev->core_device);
> +	if (ret)
> +		goto out_put_device;
> +
> +	return 0;
> +
> +out_put_device:
> +	vfio_put_device(&qat_vdev->core_device.vdev);
> +	return ret;
> +}
> +
> +static void qat_vf_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct qat_vf_core_device *qat_vdev =3D qat_vf_drvdata(pdev);
> +
> +	vfio_pci_core_unregister_device(&qat_vdev->core_device);
> +	vfio_put_device(&qat_vdev->core_device.vdev);
> +}
> +
> +static const struct pci_device_id qat_vf_vfio_pci_table[] =3D {
> +	/* Intel QAT GEN4 4xxx VF device */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL,
> 0x4941) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL,
> 0x4943) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL,
> 0x4945) },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
> +
> +static const struct pci_error_handlers qat_vf_err_handlers =3D {
> +	.reset_done =3D qat_vf_pci_aer_reset_done,
> +	.error_detected =3D vfio_pci_core_aer_err_detected,
> +};
> +
> +static struct pci_driver qat_vf_vfio_pci_driver =3D {
> +	.name =3D "qat_vfio_pci",
> +	.id_table =3D qat_vf_vfio_pci_table,
> +	.probe =3D qat_vf_vfio_pci_probe,
> +	.remove =3D qat_vf_vfio_pci_remove,
> +	.err_handler =3D &qat_vf_err_handlers,
> +	.driver_managed_dma =3D true,
> +};
> +module_pci_driver(qat_vf_vfio_pci_driver)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration
> support for Intel(R) QAT GEN4 device family");
> +MODULE_IMPORT_NS(CRYPTO_QAT);
> --
> 2.18.2


