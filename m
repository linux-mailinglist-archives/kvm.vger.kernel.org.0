Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D332A44B2
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 13:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgKCMBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 07:01:55 -0500
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:56422
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727109AbgKCMBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 07:01:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYJnw8fcO5yGhbs8iA7xhVD1QqeEDNjGVmo3ImeyWIIcMpOg+eiHxIE8IJ8yKDWcJ13dmpuPBUEcxtIgs3KZAu2D3ikvKNhX/PFVLfNx3bz65WauReE7jnEsYBJr4+jnd1oIm8uJTDmCZC15nBgKxxTA1ACi76NGEBFW9+3QNoqdKJuFxNv6V+Bm33SziTq0AJe06qFYt07/DtefMw9DlA8ZWXIDi5ahIJtmZh7gKPGapH/zI/k3wX6ihq6lQ8QoRuQJoGl6NkHuORKsmKApWAPb0zNhx5cNCqbWLJ6SLXotWZkjmUJVzJkNmJwX/43aB0Fhj7b3FjRowxSaXrtUMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riRiFTgSoZBf5G5SE1EX4mxx2HgnFPS1ZnyIQ46rqy8=;
 b=gADHwImxjbASupcZQwVXKtViU6P9i08q3+5L2KRx8NW2NRew+q9QCbbcdAlGmkQJp8QzHN46y7l9ZO6KuIUHGuJcJJ4YKhwGyxeuWBrJERtrk63c9L/Prf1V8CncNF5wsrOkGmKi7l3Fw8tgilLkFvbo7i34a5nQAnhiWyzuT7iWaQMqFJRPD6ll5b8xE5Ntu55CS3udQ/ZuPO1iHdaZNK/u++sFzGV6cgDKlzSnGv/CRef1YyufP7SZ/kdYeCixA4Uh/2UYgS/OsHASE3v9UR897sIMMmdUk74YGAxdJ9WYekzihdIo6lVolaoubsiZ8jDFnu4ASpGETsBf6PeLDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=riRiFTgSoZBf5G5SE1EX4mxx2HgnFPS1ZnyIQ46rqy8=;
 b=AC8s32ZXoyGRllfbKx9Q6mo8qsY+lrGYa9mU8D34lb2ZLdBrW+v4HoCHePdvVD+AKwjCYbMh9cUJUMcYYmvPHOapkriyRaAJVwljDh5xkcCNCz5zVpHFETWCRqadgT7Q/iatNdW0HDPMc3LCiO13VnJNogh3lJK4HhvPJvEq8JY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR04MB2975.eurprd04.prod.outlook.com
 (2603:10a6:802:9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 12:01:46 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f%11]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 12:01:46 +0000
Subject: Re: [PATCH 1/2] vfio/fsl-mc: return -EFAULT if copy_to_user() fails
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20201023113450.GH282278@mwanda>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <2f735366-f155-9a1c-e177-be840ea22c7b@oss.nxp.com>
Date:   Tue, 3 Nov 2020 14:01:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101
 Thunderbird/83.0
In-Reply-To: <20201023113450.GH282278@mwanda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [86.121.79.46]
X-ClientProxiedBy: AM3PR07CA0094.eurprd07.prod.outlook.com
 (2603:10a6:207:6::28) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (86.121.79.46) by AM3PR07CA0094.eurprd07.prod.outlook.com (2603:10a6:207:6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.10 via Frontend Transport; Tue, 3 Nov 2020 12:01:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e0beb0c-e05b-4b43-e256-08d87ff03c9f
X-MS-TrafficTypeDiagnostic: VI1PR04MB2975:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB29759A71426DEC22E7AEDA5CBE110@VI1PR04MB2975.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yD3PqAHjkhzM8AnMPLZmEJzxlGn+Uw5VkCIti88NNKGDbu+jqDT8dsbwqVvb3o2AEldeL42C4UV/WQbpRDYkT9cKZsya9u2TQPabdzCIulgeRDW3yVwKxyETZeWCJCpDHGG6/1flik9WsAcsEy76LlfkOHCUCJlOlITdH1eDIAVaJHeKe1R4TB0AZiDm++rVjpeuhCzGWNmVujiJkWs5qDWMYs60b8NCoBXK1jXaAugxABIvajP9A+akuc1kToNEWydlko9OSBba99s+BGXC42Bz/kwmI7A5LWEraYsDgPsppIBUnDXvmtbYfF9CKomhOAJyXg/UF5/wuo89kCzfa2c1omkJWTS3b3hsmfobExCLr8zq48zX0cxAyvJYY24s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(6666004)(83380400001)(8676002)(316002)(16576012)(8936002)(16526019)(186003)(26005)(53546011)(54906003)(956004)(52116002)(31696002)(2906002)(6486002)(6916009)(2616005)(5660300002)(478600001)(66476007)(4326008)(31686004)(86362001)(66946007)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BbRTzi5gyTMnr6LTaLmJZnf3UmGM9+EwZkpQ/oWy5x7MZeTK/XNCW+US8ZmKMktQeopJygqyrVvs6cpxGaPcg36bbsgSxG2OX9TvCRiqba1LlZuFKR0YXXdrNzP2JowCvHFNOOPS/9E/Jsbgr4c94Ls/tMQ/YBJlAytW6nI8PsMgzZ7MOlDfrrlah9lyfp4Q2b56yv/ans3TQlx4UY1fyyT6BhLKrEmiTe++PmqyKxWUBOGcNhrYwU10Hlz3e1chefDsOtazb3FwfIBvzEE8LRYMYKnuEpyMOIf6VMIWlB29FmhVaEmmSQkDFOV8xdBXmdEIDuap6s7o6XfSwSwggngt/ff8TBO7BZYfeXtwtaOulg+q43MQNx/8CBGbKYvHsLHdAQ8IX0KVyzwrk0s/TP7H3af1qrsA8PbfpY+WGPJRX7CXl5oo43zZs5Fl3GTMoDVmOKSPJr/gX5g6+SpjMgdEvydT7vIi+FkJafz+lztU8qL/vJ9m+0ztvwKtNJemlqU9X+TRla1n/nTsQ2HlG7uaeiIV73laaOAVc4CezMJxB+It5iPmMLDg+lOAWULy6GWczTb5XJoB2tDtdIrNUiegZRM7rDNHPLadseaUsV/4O4zOIsLvV09lpDAl/XNh13wsmVZwFEQgVnTA4ceOgg==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0beb0c-e05b-4b43-e256-08d87ff03c9f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 12:01:46.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LB9966wS4OuPDtId5WVAVLZsnvOJJBQMRkVBcNCtc3BlQE+8bYx9sMm4CBWQuAHaPBI9noXiUIadkQU0PzwHlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2975
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acked-by: Diana Craciun <diana.craciun@oss.nxp.com>

On 10/23/2020 2:34 PM, Dan Carpenter wrote:
> The copy_to_user() function returns the number of bytes remaining to be
> copied, but this code should return -EFAULT.
> 
> Fixes: df747bcd5b21 ("vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 0113a980f974..21f22e3da11f 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -248,7 +248,9 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>   		info.size = vdev->regions[info.index].size;
>   		info.flags = vdev->regions[info.index].flags;
>   
> -		return copy_to_user((void __user *)arg, &info, minsz);
> +		if (copy_to_user((void __user *)arg, &info, minsz))
> +			return -EFAULT;
> +		return 0;
>   	}
>   	case VFIO_DEVICE_GET_IRQ_INFO:
>   	{
> @@ -267,7 +269,9 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>   		info.flags = VFIO_IRQ_INFO_EVENTFD;
>   		info.count = 1;
>   
> -		return copy_to_user((void __user *)arg, &info, minsz);
> +		if (copy_to_user((void __user *)arg, &info, minsz))
> +			return -EFAULT;
> +		return 0;
>   	}
>   	case VFIO_DEVICE_SET_IRQS:
>   	{
> 

