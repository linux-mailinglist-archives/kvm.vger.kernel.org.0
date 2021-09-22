Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0DD414CC2
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 17:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhIVPNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 11:13:08 -0400
Received: from mail-dm6nam11on2074.outbound.protection.outlook.com ([40.107.223.74]:22369
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236164AbhIVPNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 11:13:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLpfQbpTrsLDPi77VoKkZsTgCRFP6wowGS3C6D1HvbM/fknnfbFzvyMWn90/hUeqGgddXEnYQ3BbRx45pKyK4G/YGzLLhA25NTL3GNs47h6SvHfIckL+zRJHJhzdL52MIEQIOHVrw4h6fDZzYpHv6sUo5FewKbx9Kj+3o1rB33UMeMIWMdLfx7WExOpoU5EcPFt4U/9hOKRmnL0Mfg6HcnUUDsXpADBhPcmhyP/nHAiuA6kIMT32dp6x/pxi3CMEsXyoB+VMUHDASYsJznXJuQLgNQ4F00V/a/MTWi9dJnbgWJO6vzypbo1CtHxMlmVrtvcIxIsHwfniep7N6/OoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EIytjfE7uNINKIsO6h+xWr2yzNkecWv+s4Fr0fkBklA=;
 b=NrWKFhfsQgiQnpIjLGFy5wBz6Dxm6nKUoISUf2ZTPDmMic51T3WHetWXSDuqakqV+GZyCioTFXRfrP2PZusSbcOjUCSXA32iMkQ1yEVDtrjHG6BmnAx7fmGKPVQp/T05Hwto0iwE2vOGncaSdoc1Ms3dMGfUwvohMdL1zf5+xHMjDncp2YfdMIdCFyNLfwEqfx/+HXPS0ZkvtJ61pIeaMqFLfyFQQd/DWeYKLiTbpzQs/vVoUiTmyZ+TyfaURNObT1LlDnOTvBddiQSE6nQFDepqNiknrY3U0H3kYbWb5yPH6IezcE5duQusjZWpxd0s/EQ2ynYSJC9pJgFsMwHQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=hisilicon.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIytjfE7uNINKIsO6h+xWr2yzNkecWv+s4Fr0fkBklA=;
 b=V7DCfEvpx/iR9p2UBkVxwpM/cj3LNmmXRgyZw83sotXIJAz+2BHSQjsssHxx2aUtgExDVrlpXTkCBK52svdAXfay9Kz/M4RUEo61Hhq0SDfzkCACS/rntbyj7JsL+7n912aIPx2VTOmOzNs9r2DNV1pQJfuYleHF66yLVEMJw+Cm3QlIfGmBz4/fqt27UAY7DEhex/Lo7ikmMfwxC1bpRvDxt5wmJ7vEirlWsz+SYzC7T8Q1cGXmjmDP6nkDm71aFXXBk9gyzxpXB8Z/TTWKi0xtdKdt75S2QQeFiA02gsb58ds+2Z2wFRtZErhruG5yi+iLEstMOHuDtAX60YbyAQ==
Received: from DM5PR11CA0006.namprd11.prod.outlook.com (2603:10b6:3:115::16)
 by BN9PR12MB5242.namprd12.prod.outlook.com (2603:10b6:408:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 15:11:36 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::e4) by DM5PR11CA0006.outlook.office365.com
 (2603:10b6:3:115::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Wed, 22 Sep 2021 15:11:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 15:11:35 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 08:11:29 -0700
Received: from [172.27.14.84] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 15:11:25 +0000
Subject: Re: [PATCH v3 3/6] hisi_acc_qm: Move PCI device IDs to common header
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-4-shameerali.kolothum.thodi@huawei.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <fd1624d5-4661-75e7-6c28-bfbfd877f889@nvidia.com>
Date:   Wed, 22 Sep 2021 18:11:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210915095037.1149-4-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64df195b-0c5a-4d81-9bc8-08d97ddb44ef
X-MS-TrafficTypeDiagnostic: BN9PR12MB5242:
X-Microsoft-Antispam-PRVS: <BN9PR12MB52424193F94EFADF763312EDDEA29@BN9PR12MB5242.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mkwcWW9/o/FMLd0B7u7OWk94RjeQsmXEaiey2lNTBCljDcf/nbFhGhbikOVBjCgZfwAItkMPm+mzy3NlmyDePp78wmin+mJUmwotBjgpzlTKPnKOZiWgGhDzkm/bvFRE8eswTwXci3aABPmmsO29UemBxyRrlqQKaiFnfxnwxQ3sgLG70IQIVInC+5EqmK0K8eGcsV+87HYRDZcuE4ejYgvrwBVXv31AIIfcwYZv2lyXGULcvQ183vY/3DwhKpdRJZQP6e8aXJOTS9EAqr3Zbhr0AH9kvIEoiNSwy7BJoiVUah6FF7XI7CxazowGCeKzZygDsb4DmzzF0VQ1o/41VHP7IUehr56TFsw4jYfnBgmI9+Zs/WGWxTgJ1iOwD951rqGM+xecw68SVMu5HRxk0FM4SvgEFIVdRiPGzHFNMqOAGufDb1c4VyNVXP4fKFuOehjq7WErmZ6RNkNnCXFJUTF9tqbse99fe0S+TnLJVVvEBH9hHtj5mSDc8VA9i5GOnhVTzFd4NwkvYHq6utCOcKZIX3hay9ZC3ALC2w9lr3f7LEqXDG1dTitXd3v6Olo9FBWavnUTlE4s3ysxwm0Ecv1PicpP7Id+MnmbpF7EzRKQPzJZvxPlrcoXJMaK1duAEisl6yIf6fwKEMRzPPDdjr+NwndZtTiFHFEMYTK7Bg3um7y436tIv+pYlKsPwBpaDE2UummeSTA413DXSD54EL4UorYR6Rbmi9MSzp/o83k=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(16526019)(2906002)(110136005)(86362001)(426003)(7416002)(2616005)(26005)(7636003)(54906003)(336012)(36860700001)(82310400003)(316002)(356005)(31696002)(83380400001)(186003)(47076005)(70586007)(8676002)(8936002)(508600001)(5660300002)(70206006)(4326008)(16576012)(53546011)(31686004)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 15:11:35.6350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64df195b-0c5a-4d81-9bc8-08d97ddb44ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5242
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/15/2021 12:50 PM, Shameer Kolothum wrote:
> Move the PCI Device IDs of HiSilicon ACC devices to
> a common header and use a uniform naming convention.
>
> This will be useful when we introduce the vfio PCI
> HiSilicon ACC live migration driver in subsequent patches.
>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>   drivers/crypto/hisilicon/hpre/hpre_main.c | 12 +++++-------
>   drivers/crypto/hisilicon/sec2/sec_main.c  |  2 --
>   drivers/crypto/hisilicon/zip/zip_main.c   | 11 ++++-------
>   include/linux/hisi_acc_qm.h               |  7 +++++++
>   4 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
> index 65a641396c07..1de67b5baae3 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_main.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
> @@ -68,8 +68,6 @@
>   #define HPRE_REG_RD_INTVRL_US		10
>   #define HPRE_REG_RD_TMOUT_US		1000
>   #define HPRE_DBGFS_VAL_MAX_LEN		20
> -#define HPRE_PCI_DEVICE_ID		0xa258
> -#define HPRE_PCI_VF_DEVICE_ID		0xa259
>   #define HPRE_QM_USR_CFG_MASK		GENMASK(31, 1)
>   #define HPRE_QM_AXI_CFG_MASK		GENMASK(15, 0)
>   #define HPRE_QM_VFG_AX_MASK		GENMASK(7, 0)
> @@ -111,8 +109,8 @@
>   static const char hpre_name[] = "hisi_hpre";
>   static struct dentry *hpre_debugfs_root;
>   static const struct pci_device_id hpre_dev_ids[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_DEVICE_ID) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PCI_VF_DEVICE_ID) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_PF_PCI_DEVICE_ID) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, HPRE_VF_PCI_DEVICE_ID) },
>   	{ 0, }
>   };
>   
> @@ -242,7 +240,7 @@ MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
>   
>   static int pf_q_num_set(const char *val, const struct kernel_param *kp)
>   {
> -	return q_num_set(val, kp, HPRE_PCI_DEVICE_ID);
> +	return q_num_set(val, kp, HPRE_PF_PCI_DEVICE_ID);
>   }
>   
>   static const struct kernel_param_ops hpre_pf_q_num_ops = {
> @@ -921,7 +919,7 @@ static int hpre_debugfs_init(struct hisi_qm *qm)
>   	qm->debug.sqe_mask_len = HPRE_SQE_MASK_LEN;
>   	hisi_qm_debug_init(qm);
>   
> -	if (qm->pdev->device == HPRE_PCI_DEVICE_ID) {
> +	if (qm->pdev->device == HPRE_PF_PCI_DEVICE_ID) {
>   		ret = hpre_ctrl_debug_init(qm);
>   		if (ret)
>   			goto failed_to_create;
> @@ -958,7 +956,7 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>   	qm->sqe_size = HPRE_SQE_SIZE;
>   	qm->dev_name = hpre_name;
>   
> -	qm->fun_type = (pdev->device == HPRE_PCI_DEVICE_ID) ?
> +	qm->fun_type = (pdev->device == HPRE_PF_PCI_DEVICE_ID) ?
>   			QM_HW_PF : QM_HW_VF;
>   	if (qm->fun_type == QM_HW_PF) {
>   		qm->qp_base = HPRE_PF_DEF_Q_BASE;
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 90551bf38b52..890ff6ab18dd 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -20,8 +20,6 @@
>   
>   #define SEC_VF_NUM			63
>   #define SEC_QUEUE_NUM_V1		4096
> -#define SEC_PF_PCI_DEVICE_ID		0xa255
> -#define SEC_VF_PCI_DEVICE_ID		0xa256
>   
>   #define SEC_BD_ERR_CHK_EN0		0xEFFFFFFF
>   #define SEC_BD_ERR_CHK_EN1		0x7ffff7fd
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 7148201ce76e..f35b8fd1ecfe 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -15,9 +15,6 @@
>   #include <linux/uacce.h>
>   #include "zip.h"
>   
> -#define PCI_DEVICE_ID_ZIP_PF		0xa250
> -#define PCI_DEVICE_ID_ZIP_VF		0xa251
> -
>   #define HZIP_QUEUE_NUM_V1		4096
>   
>   #define HZIP_CLOCK_GATE_CTRL		0x301004
> @@ -246,7 +243,7 @@ MODULE_PARM_DESC(uacce_mode, UACCE_MODE_DESC);
>   
>   static int pf_q_num_set(const char *val, const struct kernel_param *kp)
>   {
> -	return q_num_set(val, kp, PCI_DEVICE_ID_ZIP_PF);
> +	return q_num_set(val, kp, ZIP_PF_PCI_DEVICE_ID);
>   }
>   
>   static const struct kernel_param_ops pf_q_num_ops = {
> @@ -268,8 +265,8 @@ module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
>   MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
>   
>   static const struct pci_device_id hisi_zip_dev_ids[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_PF) },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_VF) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, ZIP_PF_PCI_DEVICE_ID) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, ZIP_VF_PCI_DEVICE_ID) },
>   	{ 0, }
>   };
>   MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
> @@ -834,7 +831,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>   	qm->sqe_size = HZIP_SQE_SIZE;
>   	qm->dev_name = hisi_zip_name;
>   
> -	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ?
> +	qm->fun_type = (pdev->device == ZIP_PF_PCI_DEVICE_ID) ?
>   			QM_HW_PF : QM_HW_VF;
>   	if (qm->fun_type == QM_HW_PF) {
>   		qm->qp_base = HZIP_PF_DEF_Q_BASE;
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index 8befb59c6fb3..2d209bf15419 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -9,6 +9,13 @@
>   #include <linux/module.h>
>   #include <linux/pci.h>
>   
> +#define ZIP_PF_PCI_DEVICE_ID		0xa250
> +#define ZIP_VF_PCI_DEVICE_ID		0xa251
> +#define SEC_PF_PCI_DEVICE_ID		0xa255
> +#define SEC_VF_PCI_DEVICE_ID		0xa256
> +#define HPRE_PF_PCI_DEVICE_ID		0xa258
> +#define HPRE_VF_PCI_DEVICE_ID		0xa259
> +

maybe can be added to include/linux/pci_ids.h under the 
PCI_VENDOR_ID_HUAWEI definition ?


>   #define QM_QNUM_V1			4096
>   #define QM_QNUM_V2			1024
>   #define QM_MAX_VFS_NUM_V2		63
