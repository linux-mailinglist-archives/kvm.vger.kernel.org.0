Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F3F4ADB88
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 15:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378408AbiBHOtz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 8 Feb 2022 09:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiBHOtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 09:49:53 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB48C061576;
        Tue,  8 Feb 2022 06:49:52 -0800 (PST)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtQmS54Rhz6801q;
        Tue,  8 Feb 2022 22:45:44 +0800 (CST)
Received: from lhreml717-chm.china.huawei.com (10.201.108.68) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 15:49:49 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml717-chm.china.huawei.com (10.201.108.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 14:49:49 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Tue, 8 Feb 2022 14:49:48 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [RFC v4 6/8] crypto: hisilicon/qm: Add helper to retrieve the PF
 qm data
Thread-Topic: [RFC v4 6/8] crypto: hisilicon/qm: Add helper to retrieve the PF
 qm data
Thread-Index: AQHYHPDtLJcNOLWDh0OuZhX3BN5rGayJtYqAgAAE/IA=
Date:   Tue, 8 Feb 2022 14:49:48 +0000
Message-ID: <05460d58380b435fb629d2e04a83a1aa@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
 <20220208133425.1096-7-shameerali.kolothum.thodi@huawei.com>
 <20220208142525.GE4160@nvidia.com>
In-Reply-To: <20220208142525.GE4160@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
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



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 08 February 2022 14:25
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [RFC v4 6/8] crypto: hisilicon/qm: Add helper to retrieve the PF
> qm data
> 
> On Tue, Feb 08, 2022 at 01:34:23PM +0000, Shameer Kolothum wrote:
> 
> > +struct hisi_qm *hisi_qm_get_pf_qm(struct pci_dev *pdev)
> > +{
> > +	struct hisi_qm	*pf_qm;
> > +	struct pci_driver *(*fn)(void) = NULL;
> > +
> > +	if (!pdev->is_virtfn)
> > +		return NULL;
> > +
> > +	switch (pdev->device) {
> > +	case PCI_DEVICE_ID_HUAWEI_SEC_VF:
> > +		fn = symbol_get(hisi_sec_get_pf_driver);
> > +		break;
> > +	case PCI_DEVICE_ID_HUAWEI_HPRE_VF:
> > +		fn = symbol_get(hisi_hpre_get_pf_driver);
> > +		break;
> > +	case PCI_DEVICE_ID_HUAWEI_ZIP_VF:
> > +		fn = symbol_get(hisi_zip_get_pf_driver);
> > +		break;
> > +	default:
> > +		return NULL;
> > +	}
> > +
> > +	if (!fn)
> > +		return NULL;
> > +
> > +	pf_qm = pci_iov_get_pf_drvdata(pdev, fn());
> > +
> > +	if (pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_VF)
> > +		symbol_put(hisi_sec_get_pf_driver);
> > +	else if (pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_VF)
> > +		symbol_put(hisi_hpre_get_pf_driver);
> > +	else
> > +		symbol_put(hisi_zip_get_pf_driver);
> > +
> > +	return !IS_ERR(pf_qm) ? pf_qm : NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(hisi_qm_get_pf_qm);
> 
> Why put this in this driver, why not in the vfio driver? And why use
> symbol_get ?

QM driver provides a generic common interface for all HiSilicon ACC
drivers. So thought of placing it here. And symbol_get/put is used
to avoid having dependency of all the ACC drivers being built along
with the vfio driver. Is there a better way to retrieve the struct pci_driver *
associated with each ACC PF driver? Please let me know.

Thanks,
Shameer
