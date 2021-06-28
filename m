Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4113B67F3
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 19:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhF1Rwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 13:52:31 -0400
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:17089
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232586AbhF1Rw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 13:52:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgAhWMxTH7JSRImavUA1DoCTeeOTIy4TgQrtYRbcB0S+xBFkW4OeH7THVyxbLjjE3dwrqPswwQFLGpKXvUiuxffd4bvUujJbfASmPe3bwOFZ0j8bYGzQrpIRvx4J0SadpkOYxwxV1pTsD9Fp2m/jySLQ4Z87BAIaUfdiv1POsSNlCBoxJ1r65RWhc/49t3hKxHm3kwMTuP/uiSNAmvzOVBva5XojueB2f5ZcHk1aZ1xRxpoZSGhBf2S+ERsjcbs0pYKj8KhQOk6o97zdnChm6czxSDYaZEYFWFL4Iz1XcLZ7nAQSVPNtG8jZxru+R0rUk/Eq4bdGqI4W4pCZPiYReg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nekbzmKwJ3Bk6NSu17oV6TU+d5YRaSpebmDh3r8i3/c=;
 b=L4fqxTzXem8EqO3yFwTPeBYmKGfAl+870XpM90U8gTuQfTq3rZXNyM/ThPc9GSYpfwhmE4Ye/p/PMPKt6fVZG8Olva+AOCYTDs8eyharL6oUa5biHLHhXYHG/DLKd2CvQXVq6HlJr8kmIvnKBsK7qMks9qPrTAZdYRQh+/XHqE1iCa2FXjP9gm4DWI152a4WsA1uzHfA2cIfsAoJXD0iC0NHvCAbsjYuuLL5Ks2KMg0Gpt8Da5awvKWfoNfIgaZEdLOT6wnicetY9nZ20Yphkxcfmyekp78q12PZ6D7El0D6cWgXjREIPZKyU6jZlp2XSzfapvEnJqKQeWltZ2Baxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nekbzmKwJ3Bk6NSu17oV6TU+d5YRaSpebmDh3r8i3/c=;
 b=SbwKWLwkzxdYJU+kqENv8JHbL265OoChMR3CPoQd4oZcw+3dv7MgBPdjJt7fLqrblaN02fU+9EZYoY510twoBFuoE/fzdG4g52gkBLcDP6lQMXskaxCHTE4+zJPviKxCGyMrEA/UxOqwdELQehwC5cBtDtKcIbxXbF3C6WdkiS56NUFjtyERJa5b3nRmpug4Xql99Qx8H3sTunif+GQkPTp4+iV9vKlg+pEWnGy95YBHhf4BMf2s6UDn/yTfk9kMVZ/0hjk6GlJ3oCXX6hMuKprCNt8z5tEKQgHdgV4M/F/sopwJmhtRBX1RavvBa/V7XpLncmNb86+eyLSvyZYX3A==
Received: from BN0PR03CA0028.namprd03.prod.outlook.com (2603:10b6:408:e6::33)
 by DM5PR1201MB2488.namprd12.prod.outlook.com (2603:10b6:3:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.22; Mon, 28 Jun
 2021 17:50:01 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::dc) by BN0PR03CA0028.outlook.office365.com
 (2603:10b6:408:e6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Mon, 28 Jun 2021 17:50:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4264.18 via Frontend Transport; Mon, 28 Jun 2021 17:50:00 +0000
Received: from [10.40.101.220] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 28 Jun
 2021 17:49:57 +0000
Subject: Re: [PATCH] vfio/mtty: Enforce available_instances
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>
References: <162465624894.3338367.12935940647049917981.stgit@omen>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <ee949a98-6998-2032-eb17-00ef8b8d911c@nvidia.com>
Date:   Mon, 28 Jun 2021 23:19:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162465624894.3338367.12935940647049917981.stgit@omen>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a1f68ae-1d32-4b0b-474b-08d93a5d26e8
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2488:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB248864C43E2A829AFAEEFE4EDC039@DM5PR1201MB2488.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 013SONLqPig+vShhFQyZeR82+VYVOfnnzBC46r0d1dOym4QqK6Kdfip/d+CUb01y5bzn7a528gqu1gsQ+REgm8KX9njhNybGnQyIjUhOIaXVQx5felUSzxkdoc93fV+NusdsCMMax8F6WxdeBT66zM8/vOo23+dyYqrPPDHLSPO4QYAEvhKb13GmHUP8v1aeQGRUstiZamTDArC4WqiJrOvNWoya2M7U7saUWHKC6COwMx0tf2z7lJNeobD5oD7THt2h75E/NLGg0OTl44E6VwrMKSsVu59pksXyAbdyyfIPtVhaTLlBAYkjw+rWxcn5kViYKDsDVSe7wVxr8PgI3uL6nXLt4XbSQKGi6pht7xPnJbg3QX/hD4hCptTo3Z0cmPXfbKrdMsRCq/XpBrT68x/yEjyLKRDIzyp9gazBenTJ14gDHpRDalCwVpNBCHcdMJljecziX6VWkepB1DDOIzE4Ukl2pxxpVwqaiavQJcGZOlzoBnmLxSVoijBeA0tn7C80H+5RDhhvxGU6EOulMOgou2cCfbmrCxIX/msAIILjVqlGeQbxtNvfYCMg+AtS9333Xu/ZHjh4Sg+m8ve26ZiOWr/yQX1twJPatTHT1s3N0Sh8BJDAFq670WTB6j8aCKm1elvkLg99H7e8RuEIkeWVqH06otp7mcimOAye4ymJMFiXodzIUtRs5GA5GeVRCvQH1LdFeE1ZqobIgBiYX0s1i7h4j8Q7EL2qm0uwLpH74w6cRzDC6WhtSNYh4I4KThwHjUAPkWEWtCNx9CBwFQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(46966006)(36840700001)(7636003)(356005)(478600001)(6916009)(31686004)(36756003)(6666004)(336012)(4326008)(70586007)(54906003)(26005)(83380400001)(426003)(316002)(2616005)(70206006)(47076005)(86362001)(8676002)(82740400003)(2906002)(5660300002)(16576012)(36860700001)(53546011)(107886003)(186003)(31696002)(16526019)(8936002)(82310400003)(131093003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 17:50:00.6993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1f68ae-1d32-4b0b-474b-08d93a5d26e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2488
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/26/2021 2:56 AM, Alex Williamson wrote:
> The sample mtty mdev driver doesn't actually enforce the number of
> device instances it claims are available.  Implement this properly.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Applies to vfio next branch + Jason's atomic conversion
> 


Does this need to be on top of Jason's patch?
Patch to use mdev_used_ports is reverted here, can it be changed from 
mdev_devices_list to mdev_avail_ports atomic variable?

Change here to use atomic variable looks good to me.

Reviewed by: Kirti Wankhede <kwankhede@nvidia.com>



>   samples/vfio-mdev/mtty.c |   22 ++++++++++++++++------
>   1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index ffbaf07a17ea..8b26fecc4afe 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -144,7 +144,7 @@ struct mdev_state {
>   	int nr_ports;
>   };
>   
> -static atomic_t mdev_used_ports;
> +static atomic_t mdev_avail_ports = ATOMIC_INIT(MAX_MTTYS);
>   
>   static const struct file_operations vd_fops = {
>   	.owner          = THIS_MODULE,
> @@ -707,11 +707,20 @@ static int mtty_probe(struct mdev_device *mdev)
>   {
>   	struct mdev_state *mdev_state;
>   	int nr_ports = mdev_get_type_group_id(mdev) + 1;
> +	int avail_ports = atomic_read(&mdev_avail_ports);
>   	int ret;
>   
> +	do {
> +		if (avail_ports < nr_ports)
> +			return -ENOSPC;
> +	} while (!atomic_try_cmpxchg(&mdev_avail_ports,
> +				     &avail_ports, avail_ports - nr_ports));
> +
>   	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
> -	if (mdev_state == NULL)
> +	if (mdev_state == NULL) {
> +		atomic_add(nr_ports, &mdev_avail_ports);
>   		return -ENOMEM;
> +	}
>   
>   	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
>   
> @@ -724,6 +733,7 @@ static int mtty_probe(struct mdev_device *mdev)
>   
>   	if (mdev_state->vconfig == NULL) {
>   		kfree(mdev_state);
> +		atomic_add(nr_ports, &mdev_avail_ports);
>   		return -ENOMEM;
>   	}
>   
> @@ -735,9 +745,9 @@ static int mtty_probe(struct mdev_device *mdev)
>   	ret = vfio_register_group_dev(&mdev_state->vdev);
>   	if (ret) {
>   		kfree(mdev_state);
> +		atomic_add(nr_ports, &mdev_avail_ports);
>   		return ret;
>   	}
> -	atomic_add(mdev_state->nr_ports, &mdev_used_ports);
>   
>   	dev_set_drvdata(&mdev->dev, mdev_state);
>   	return 0;
> @@ -746,12 +756,13 @@ static int mtty_probe(struct mdev_device *mdev)
>   static void mtty_remove(struct mdev_device *mdev)
>   {
>   	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
> +	int nr_ports = mdev_state->nr_ports;
>   
> -	atomic_sub(mdev_state->nr_ports, &mdev_used_ports);
>   	vfio_unregister_group_dev(&mdev_state->vdev);
>   
>   	kfree(mdev_state->vconfig);
>   	kfree(mdev_state);
> +	atomic_add(nr_ports, &mdev_avail_ports);
>   }
>   
>   static int mtty_reset(struct mdev_state *mdev_state)
> @@ -1271,8 +1282,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   {
>   	unsigned int ports = mtype_get_type_group_id(mtype) + 1;
>   
> -	return sprintf(buf, "%d\n",
> -		       (MAX_MTTYS - atomic_read(&mdev_used_ports)) / ports);
> +	return sprintf(buf, "%d\n", atomic_read(&mdev_avail_ports) / ports);
>   }
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
> 
> 
