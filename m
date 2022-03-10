Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1134D4872
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 14:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242580AbiCJN46 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Mar 2022 08:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiCJN45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 08:56:57 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E914141FF4;
        Thu, 10 Mar 2022 05:55:52 -0800 (PST)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDrDQ5q6Tz67vZB;
        Thu, 10 Mar 2022 21:55:18 +0800 (CST)
Received: from lhreml717-chm.china.huawei.com (10.201.108.68) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 14:55:49 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml717-chm.china.huawei.com (10.201.108.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 13:55:48 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Thu, 10 Mar 2022 13:55:48 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v8 3/9] hisi_acc_qm: Move VF PCI device IDs to common
 header
Thread-Topic: [PATCH v8 3/9] hisi_acc_qm: Move VF PCI device IDs to common
 header
Thread-Index: AQHYL1K65T0xdQtNbkGb+oampkIrK6y0Oe0AgARyolA=
Date:   Thu, 10 Mar 2022 13:55:48 +0000
Message-ID: <ec2b1e7168714144afcd4bfe5cd39058@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-4-shameerali.kolothum.thodi@huawei.com>
 <20220307105344.171b4621.alex.williamson@redhat.com>
In-Reply-To: <20220307105344.171b4621.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.85.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bjorn,

> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: 07 March 2022 17:54
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> Bjorn Helgaas <bhelgaas@google.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org; jgg@nvidia.com;
> cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v8 3/9] hisi_acc_qm: Move VF PCI device IDs to common
> header
> 
> Hi Bjorn,
> 
> Here's the respin of this patch that adds only the VF device IDs to
> pci_ids.h.  The next patch in the series[1] adds a consumer of these
> IDs as a vfio-pci vendor driver.  Thanks,

Just a gentle ping on this. Also the latest respin is now at v9 and can be
found here.

https://lore.kernel.org/kvm/20220308184902.2242-4-shameerali.kolothum.thodi@huawei.com/

Thanks,
Shameer

> Alex
> 
> [1]https://lore.kernel.org/all/20220303230131.2103-5-shameerali.kolothum.t
> hodi@huawei.com/
> 
> On Thu, 3 Mar 2022 23:01:25 +0000
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > Move the PCI Device IDs of HiSilicon ACC VF devices to a common header
> > and also use a uniform naming convention.
> >
> > This will be useful when we introduce the vfio PCI HiSilicon ACC live
> > migration driver in subsequent patches.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  drivers/crypto/hisilicon/hpre/hpre_main.c | 13 ++++++-------
> >  drivers/crypto/hisilicon/sec2/sec_main.c  | 15 +++++++--------
> >  drivers/crypto/hisilicon/zip/zip_main.c   | 11 +++++------
> >  include/linux/pci_ids.h                   |  3 +++
> >  4 files changed, 21 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c
> b/drivers/crypto/hisilicon/hpre/hpre_main.c
> > index ebfab3e14499..3589d8879b5e 100644
> > --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> > +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> > @@ -68,8 +68,7 @@
> >  #define HPRE_REG_RD_INTVRL_US		10
> >  #define HPRE_REG_RD_TMOUT_US		1000
> >  #define HPRE_DBGFS_VAL_MAX_LEN		20
> > -#define HPRE_PCI_DEVICE_ID		0xa258
> > -#define HPRE_PCI_VF_DEVICE_ID		0xa259
> > +#define PCI_DEVICE_ID_HUAWEI_HPRE_PF	0xa258
> >  #define HPRE_QM_USR_CFG_MASK		GENMASK(31, 1)
> >  #define HPRE_QM_AXI_CFG_MASK		GENMASK(15, 0)
> >  #define HPRE_QM_VFG_AX_MASK		GENMASK(7, 0)
> > @@ -111,8 +110,8 @@
> >  static const char hpre_name[] = "hisi_hpre";
> >  static struct dentry *hpre_debugfs_root;
> >  static const struct pci_device_id hpre_dev_ids[] = {
> > -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_DEVICE_ID) },
> > -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_VF_DEVICE_ID) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_HPRE_PF) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_HPRE_VF) },
> >  	{ 0, }
> >  };
> >
> > @@ -242,7 +241,7 @@ MODULE_PARM_DESC(uacce_mode,
> UACCE_MODE_DESC);
> >
> >  static int pf_q_num_set(const char *val, const struct kernel_param *kp)
> >  {
> > -	return q_num_set(val, kp, HPRE_PCI_DEVICE_ID);
> > +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_HPRE_PF);
> >  }
> >
> >  static const struct kernel_param_ops hpre_pf_q_num_ops = {
> > @@ -921,7 +920,7 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
> >  	qm->debug.sqe_mask_len = HPRE_SQE_MASK_LEN;
> >  	hisi_qm_debug_init(qm);
> >
> > -	if (qm->pdev->device == HPRE_PCI_DEVICE_ID) {
> > +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_PF) {
> >  		ret = hpre_ctrl_debug_init(qm);
> >  		if (ret)
> >  			goto failed_to_create;
> > @@ -958,7 +957,7 @@ static int hpre_qm_init(struct hisi_qm *qm, struct
> pci_dev *pdev)
> >  	qm->sqe_size = HPRE_SQE_SIZE;
> >  	qm->dev_name = hpre_name;
> >
> > -	qm->fun_type = (pdev->device == HPRE_PCI_DEVICE_ID) ?
> > +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_PF) ?
> >  			QM_HW_PF : QM_HW_VF;
> >  	if (qm->fun_type == QM_HW_PF) {
> >  		qm->qp_base = HPRE_PF_DEF_Q_BASE;
> > diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c
> b/drivers/crypto/hisilicon/sec2/sec_main.c
> > index 26d3ab1d308b..311a8747b5bf 100644
> > --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> > +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> > @@ -20,8 +20,7 @@
> >
> >  #define SEC_VF_NUM			63
> >  #define SEC_QUEUE_NUM_V1		4096
> > -#define SEC_PF_PCI_DEVICE_ID		0xa255
> > -#define SEC_VF_PCI_DEVICE_ID		0xa256
> > +#define PCI_DEVICE_ID_HUAWEI_SEC_PF	0xa255
> >
> >  #define SEC_BD_ERR_CHK_EN0		0xEFFFFFFF
> >  #define SEC_BD_ERR_CHK_EN1		0x7ffff7fd
> > @@ -225,7 +224,7 @@ static const struct debugfs_reg32 sec_dfx_regs[] = {
> >
> >  static int sec_pf_q_num_set(const char *val, const struct kernel_param
> *kp)
> >  {
> > -	return q_num_set(val, kp, SEC_PF_PCI_DEVICE_ID);
> > +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_SEC_PF);
> >  }
> >
> >  static const struct kernel_param_ops sec_pf_q_num_ops = {
> > @@ -313,8 +312,8 @@ module_param_cb(uacce_mode,
> &sec_uacce_mode_ops, &uacce_mode, 0444);
> >  MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
> >
> >  static const struct pci_device_id sec_dev_ids[] = {
> > -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, SEC_PF_PCI_DEVICE_ID) },
> > -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, SEC_VF_PCI_DEVICE_ID) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_SEC_PF) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_SEC_VF) },
> >  	{ 0, }
> >  };
> >  MODULE_DEVICE_TABLE(pci, sec_dev_ids);
> > @@ -717,7 +716,7 @@ static int sec_core_debug_init(struct hisi_qm *qm)
> >  	regset->base = qm->io_base;
> >  	regset->dev = dev;
> >
> > -	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID)
> > +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF)
> >  		debugfs_create_file("regs", 0444, tmp_d, regset, &sec_regs_fops);
> >
> >  	for (i = 0; i < ARRAY_SIZE(sec_dfx_labels); i++) {
> > @@ -735,7 +734,7 @@ static int sec_debug_init(struct hisi_qm *qm)
> >  	struct sec_dev *sec = container_of(qm, struct sec_dev, qm);
> >  	int i;
> >
> > -	if (qm->pdev->device == SEC_PF_PCI_DEVICE_ID) {
> > +	if (qm->pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF) {
> >  		for (i = SEC_CLEAR_ENABLE; i < SEC_DEBUG_FILE_NUM; i++) {
> >  			spin_lock_init(&sec->debug.files[i].lock);
> >  			sec->debug.files[i].index = i;
> > @@ -877,7 +876,7 @@ static int sec_qm_init(struct hisi_qm *qm, struct
> pci_dev *pdev)
> >  	qm->sqe_size = SEC_SQE_SIZE;
> >  	qm->dev_name = sec_name;
> >
> > -	qm->fun_type = (pdev->device == SEC_PF_PCI_DEVICE_ID) ?
> > +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_PF) ?
> >  			QM_HW_PF : QM_HW_VF;
> >  	if (qm->fun_type == QM_HW_PF) {
> >  		qm->qp_base = SEC_PF_DEF_Q_BASE;
> > diff --git a/drivers/crypto/hisilicon/zip/zip_main.c
> b/drivers/crypto/hisilicon/zip/zip_main.c
> > index 678f8b58ec42..66decfe07282 100644
> > --- a/drivers/crypto/hisilicon/zip/zip_main.c
> > +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> > @@ -15,8 +15,7 @@
> >  #include <linux/uacce.h>
> >  #include "zip.h"
> >
> > -#define PCI_DEVICE_ID_ZIP_PF		0xa250
> > -#define PCI_DEVICE_ID_ZIP_VF		0xa251
> > +#define PCI_DEVICE_ID_HUAWEI_ZIP_PF	0xa250
> >
> >  #define HZIP_QUEUE_NUM_V1		4096
> >
> > @@ -246,7 +245,7 @@ MODULE_PARM_DESC(uacce_mode,
> UACCE_MODE_DESC);
> >
> >  static int pf_q_num_set(const char *val, const struct kernel_param *kp)
> >  {
> > -	return q_num_set(val, kp, PCI_DEVICE_ID_ZIP_PF);
> > +	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_ZIP_PF);
> >  }
> >
> >  static const struct kernel_param_ops pf_q_num_ops = {
> > @@ -268,8 +267,8 @@ module_param_cb(vfs_num, &vfs_num_ops,
> &vfs_num, 0444);
> >  MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63),
> 0(default)");
> >
> >  static const struct pci_device_id hisi_zip_dev_ids[] = {
> > -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_PF) },
> > -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_VF) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_ZIP_PF) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI,
> PCI_DEVICE_ID_HUAWEI_ZIP_VF) },
> >  	{ 0, }
> >  };
> >  MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
> > @@ -838,7 +837,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct
> pci_dev *pdev)
> >  	qm->sqe_size = HZIP_SQE_SIZE;
> >  	qm->dev_name = hisi_zip_name;
> >
> > -	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ?
> > +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_HUAWEI_ZIP_PF) ?
> >  			QM_HW_PF : QM_HW_VF;
> >  	if (qm->fun_type == QM_HW_PF) {
> >  		qm->qp_base = HZIP_PF_DEF_Q_BASE;
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index aad54c666407..31dee2b65a62 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2529,6 +2529,9 @@
> >  #define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
> >
> >  #define PCI_VENDOR_ID_HUAWEI		0x19e5
> > +#define PCI_DEVICE_ID_HUAWEI_ZIP_VF	0xa251
> > +#define PCI_DEVICE_ID_HUAWEI_SEC_VF	0xa256
> > +#define PCI_DEVICE_ID_HUAWEI_HPRE_VF	0xa259
> >
> >  #define PCI_VENDOR_ID_NETRONOME		0x19ee
> >  #define PCI_DEVICE_ID_NETRONOME_NFP4000	0x4000

