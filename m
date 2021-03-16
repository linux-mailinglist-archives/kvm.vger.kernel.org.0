Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBE133D484
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 14:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhCPNC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 09:02:56 -0400
Received: from mail-bn8nam08on2068.outbound.protection.outlook.com ([40.107.100.68]:25402
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233062AbhCPNCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 09:02:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haZMBt+Om3cRKWbO+MtMcfUJteGKBaRAIoRZlAjhxwzBM89MM4jTqytZZEySEsXRW6nXtL7FZXHNYT5/DUGzYuJcthNXy2oueRC9SJQfv3Fq5eI0orm8QP+Xe9b4/MbQIAntnGQiTaX2PgrqBrNt2WizKi/Ta7h6NyYlFFT8SsrQxFQtc+NatcAEpXLnluH742S9WUf3uHbiuYwec5VSDm/I9Tm6SU0HWl+xpTtFEqAn3/N4o1ak6ZcvwICBatnDqPnQevQZ2bMK5PkhU6eOyPqXNvdrXBgD7tnEH7tgZZOxLuLGzWNtyzmXeHd4af8Le2/SOMunMAjFPnk2F1R+FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evkZhndtiwxXcpYvfWNbqGu+URcPMDnHh6qsxC9+jls=;
 b=VD4QhjlpJSK0SxuchIqThR9D8GKl3Ca7j6Pnx5S8KTkm0h1uSNL7m9yKudCvphDqNdcycVeX6zlwdxceCEUOgmv1CRyYHQpfvfKlNwbASqBHeRPrELkYxUvX4rOMhfuved9yxh9ImIn90Rto/pQyd5sBoYMqhbYxujrvd3ivkALKpW/Tv57JMFMGjfdxZOTbukwHJruEh8fUOL7JMKZEIUTizqsW0H73oFUl9hL7Wu5VFHYuLCoGIZI7A4dJPzeuan1YQ295zXSOw14rUwPr5JKDbbV2sQ4KP/BA9g2eFDQj4gs0Qayv4iuHvwgziUmN9MU5yx7pS23b6aktgYwSGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evkZhndtiwxXcpYvfWNbqGu+URcPMDnHh6qsxC9+jls=;
 b=SI/KGfWX50fe/AKfdhQPl5fL1ZrX0acOXFgqMaiHCEhKm2i3sh1WFcnwrruafatZ+LulTTdf9juoYDJHv4ViJCWeFod8C4+I5cPkvJ4RY0Gp9dzWbQOzLqWUSjzWXsi5u9tei2lyoR6uSxJh0CC72XITWvU/Mmoa2Gq2JyxiZPceJDxlF1XtJxTfc7TN/uDAnvJ8UosiTcnmBLyl0sNmalrecw3v3Z29xlZi7OxNJEzTW0+jWvgRPhu4CpkDVE/vx76dmVX2jnOs7r3uy8EtvmRBqNxwpwXkKzaTZ1VLq/vUDfA29/UxL+VC3HoWRu74zO9eWh4i8zZlSIGBDj53Bg==
Received: from BN9PR03CA0638.namprd03.prod.outlook.com (2603:10b6:408:13b::13)
 by BY5PR12MB4966.namprd12.prod.outlook.com (2603:10b6:a03:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 13:02:47 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::80) by BN9PR03CA0638.outlook.office365.com
 (2603:10b6:408:13b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 13:02:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 13:02:47 +0000
Received: from [172.27.13.197] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 13:02:43 +0000
Subject: Re: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <22954556-633c-004b-4512-262206c9bd3a@nvidia.com>
Date:   Tue, 16 Mar 2021 15:02:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 078e3ba7-269b-4a37-3b2e-08d8e87bcc0f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4966:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4966B8641FFC31C915BF2771DE6B9@BY5PR12MB4966.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eDRu+6ZEPyb8UaQ29sb9euDyHCtxa8v9cdr+PW16uIY+mdJTZTPh1+3AOxoqEpp/EcXTLJLMhnz4HsUIohGvzhltOfvlljjx7m8WHbI689e+D2b6tXfqBbrVu+MvCPqOOfm3hdyeIK6rmGAQJVL8QrU3FItOwGPPQAiCmdfGCp2G6kvuOGCmI7yNQl54SCJGz8pevgumOh+d5Ct947LEXPomIKtOtBK+GSCqtRG0WERbTtxikJ/8r5hGRJv9MlWYUdU2F8qobQuWp2JpOeXTu7WxQlEjMwERKqtPFWQfzAGUc0Xkf52pQx93yJ+ItHpjUUDgoRUNqGQbFV9KzKXqYpGIiJNOer95iKL8E8goHn9jUOmN1QVCyrR/juUn1iDlR5U8JkBgwnj9KAsQq0PSlA/WNWEwuKB18zaddtyJQwwZCvDVM20tRrzEThpEg5hyLKnLVvB/FLrQN37REErHmTILHZx6GGeiBVaTFETeOQhCx63mcNkHJFxYIf4Ueg0auoxVznk9jMOumn3/5CyNTlOOZ/J+ZYCJn9l4UwtGq6W3M3JRCThy76YbwPPwt5vUUxjMka8spMcpsN6DyZbFQGrjjfT7KAKgSxLOOEUg0i87eL0Di6YVfcbziPbSAssCalX1bS3A6aCvt1jZr0bgclFkebTXmEVXM+9p5z4x5sbe2RVogBOt9kQsOjstEiXEoYfHZyNA1ALMFhyOjn2xb6IJ6vbeyhc7YmMAvmD7YmE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(36840700001)(82740400003)(36860700001)(53546011)(186003)(83380400001)(47076005)(16526019)(36906005)(2616005)(86362001)(7636003)(2906002)(356005)(82310400003)(107886003)(31686004)(478600001)(336012)(5660300002)(316002)(16576012)(70586007)(31696002)(26005)(8936002)(8676002)(36756003)(54906003)(4326008)(70206006)(110136005)(426003)(34020700004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 13:02:47.2628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 078e3ba7-269b-4a37-3b2e-08d8e87bcc0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4966
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/13/2021 2:55 AM, Jason Gunthorpe wrote:
> vfio_pci_probe() is quite complicated, with optional VF and VGA sub
> components. Move these into clear init/uninit functions and have a linear
> flow in probe/remove.
>
> This fixes a few little buglets:
>   - vfio_pci_remove() is in the wrong order, vga_client_register() removes
>     a notifier and is after kfree(vdev), but the notifier refers to vdev,
>     so it can use after free in a race.
>   - vga_client_register() can fail but was ignored
>
> Organize things so destruction order is the reverse of creation order.
>
> Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/pci/vfio_pci.c | 116 +++++++++++++++++++++++-------------
>   1 file changed, 74 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578c2..f95b58376156a0 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1922,6 +1922,68 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
>   	return 0;
>   }
>   
> +static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int ret;
> +
> +	if (!pdev->is_physfn)
> +		return 0;
> +
> +	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> +	if (!vdev->vf_token)
> +		return -ENOMEM;
> +
> +	mutex_init(&vdev->vf_token->lock);
> +	uuid_gen(&vdev->vf_token->uuid);
> +
> +	vdev->nb.notifier_call = vfio_pci_bus_notifier;
> +	ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
> +	if (ret) {
> +		kfree(vdev->vf_token);

you can consider "mutex_destroy(&vdev->vf_token->lock);" like you use in 
the uninit function.

I know it's not in the orig code and only for code symmetry.

otherwise looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
> +{
> +	if (!vdev->vf_token)
> +		return;
> +
> +	bus_unregister_notifier(&pci_bus_type, &vdev->nb);
> +	WARN_ON(vdev->vf_token->users);
> +	mutex_destroy(&vdev->vf_token->lock);
> +	kfree(vdev->vf_token);
> +}




