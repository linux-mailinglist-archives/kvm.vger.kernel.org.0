Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E58F5AD709
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 18:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiIEQBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 12:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbiIEQBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 12:01:53 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60066.outbound.protection.outlook.com [40.107.6.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6F730F7F;
        Mon,  5 Sep 2022 09:01:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBYjZ7vxCDK5Z36Qa0ml4lPP/SlwXAZh3sfH9Muhv6P/aVxKraeZnx9hRGIcoaYoPj/jmc7pw92lCTWiW4YcN8Juz1KupYmN30PQ90MvsuvGIvURBTAS8KDz8t2Uen66vRNyVch9/Y+n3EKiEZCScNlTQL41b6cx9nDYiQDp8pY+w3mAQHktHTkGFG46VB/WysG1y8GFi3ER8JQU7IuqmwHrWUBjb7Z/jKuy49heRY2EFQSst+EOP2PfMYnfOo6STLE/y7PCVawfQV/d94MIB6uwU5VdspGXpJTDWMDeGmorMYwmbXjvQL8SKM3QYEUbIoH4CxsuM3rUAmqbKbawyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XT/YbnhNgQO/93+o/OaxTNyZ2HLVBxgX8NmZLKO+OO0=;
 b=SA6znB+ZWKt7LPdYygZf2je4e4ZMfRIEOAsvxUAcTn7hz9jQfCwQkJ0mTc92k801MgLHsdvh19Hdj3/k+FN14Hr5mWwiHqNe6Qx3Eyj+gA1CVhxnpwRW45KcLoEky0KLF41PzHK6+cBYAmb0cd7iZnlleNevINCTcZkMclzgwBXogHQsixNjA6TP1Xuognj9Hey2comHQcOoppMy0s5AlqSRFbeLnZfWdAmKG//uoHY3BTrXFpH/2py6uOWWjSyMBH45ggBqvickVzKWZRMK4HHZUegz9AG9FNPd1UzwbH0UGI8xZX9FFhdlUTKOhgvkA5PPKVgTrFPwyT970jlntg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XT/YbnhNgQO/93+o/OaxTNyZ2HLVBxgX8NmZLKO+OO0=;
 b=I8hvjMb6q2YOGZbu+alfuM06owttnxyiFc4MuRWNNqVdigQBeO2LF7U7axQP4dDy8DUS0N5qYXJ20EA4QZVA8qzWQBYL+JzBsbZWwQB2S79PWpkM1kebjrfNAKpw3mv9Ta6wCeYT6niSxhjZtLVOjet/R6B8gTe7PzHcBqtWtSo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com (2603:10a6:803:d::26)
 by HE1PR04MB3258.eurprd04.prod.outlook.com (2603:10a6:7:25::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 16:01:39 +0000
Received: from VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::247c:645d:3f4e:d907]) by VI1PR0402MB3503.eurprd04.prod.outlook.com
 ([fe80::247c:645d:3f4e:d907%6]) with mapi id 15.20.5588.016; Mon, 5 Sep 2022
 16:01:39 +0000
Message-ID: <30b52449-7024-8911-6373-fb2167247880@oss.nxp.com>
Date:   Mon, 5 Sep 2022 19:01:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v3] vfio/fsl-mc: Fix a typo in a message
Content-Language: en-CA
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org
References: <a7c1394346725b7435792628c8d4c06a0a745e0b.1662134821.git.christophe.jaillet@wanadoo.fr>
From:   Diana Madalina Craciun <diana.craciun@oss.nxp.com>
In-Reply-To: <a7c1394346725b7435792628c8d4c06a0a745e0b.1662134821.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::13) To VI1PR0402MB3503.eurprd04.prod.outlook.com
 (2603:10a6:803:d::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dba4f371-f057-41ea-1676-08da8f57eae3
X-MS-TrafficTypeDiagnostic: HE1PR04MB3258:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pl3PXIzpynDKGQwjoQY5dlbxb8/9cwC1szKSNLk4giwQN7avxf3Ketwk1i9aEAYv5pUNMHjcsmI+qbCiIXavJz7a5QOXxkL/QcTKIdmvGypRJ9ewNoBy233vJdTAss0Mjg/NPrtF+tjCnODO50Jg00XxzDajWGwStfGlf6HvzehIP1KFdJ5AYetyz6M/yDFgYt0HKGc/9mnoaYk68RD8rdrakcOyJ4d9x5y1eSkHb1I62BCUe+eFF1sojTKnurnu/v9z6kSWIbjzh/cwmbLi98X/95xbhaPeYOA16TWGdemFokkiDcJz7+r3I2n41jiPER5BZ0yvLJQbu5AYD4kvt4XNVGD1ze8aWfM3nAhvjCOq9Yob/QwRHDdNE05cSJIhQlOUMOQ7K8Er8s09++rSeA9AYTWOQdkbG1Zhq0Yy8KvNabWO3TLx+aZuXqp1InbkqRw/y3tmJ89t1MelJinEqXWdVw9lBinXJ3C90SbjSdQYVuX3ZENWLAEfWmjSC7RQz79gPhxAncIWA7iij5q7xyl/INvDZznVq8HE03HSbVW20AenpPPbCLkcXjK4yqI5sJocNZ5opUaBkuFBU1nlijXylh/myMYylnYTsRMJJx2MJZfOPxHK5oAgY2Vxl9b1SY5A14sLbt1d4OVBmIzhX9UBjilCNnFvKjN+XsZTSgcIgbvi5ni2Nh3wLNInURuuKg2ebyMVLhUy0A04vnJ1l55JpSPPZyFe/fc61I0yZz7ZaFmSg10Box8pnK1XEgIhjbntwGqWZNYSckrPSI9VQfCXO9NUXd1kKYho6QWfXGc2S+lgV52m/c5VA2wbDboVE8E9h+rLlYhHeB/v4X4Qh2Pm8TqB/9zQ6r0xwtlZA7AG92phY5crPc80Bat/oSgqrWyq6slH0a/5bn5EUMXFnpCE10CDjxX0ZofDazpCZ2LGD/A8aTsELtu5+4M43reX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3503.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(31696002)(6512007)(86362001)(26005)(966005)(53546011)(478600001)(38100700002)(6666004)(41300700001)(6506007)(52116002)(6486002)(2616005)(38350700002)(83380400001)(186003)(2906002)(31686004)(15650500001)(316002)(110136005)(4326008)(8676002)(66946007)(66556008)(66476007)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDZ2VTA3Q3ZJZjBjVnhLcUFmQTNXQWNncStTK0NlZlBPblJjRlYxL256dUN0?=
 =?utf-8?B?ckloNXAydVJaQmhBQVAzMmZScDhXUFRsME5rL2VQZjZwSXM2Z0VkbUlGV2RZ?=
 =?utf-8?B?Q1RUSFB5SUtBVDhEajNKdTVIdGN4VTBOMnovaGlEejNrSGlTY2J4c0NGK0V4?=
 =?utf-8?B?QmI5ZmIzZEtSWTdUMWZhQVMveEsrZ0ZIQ1pjVUxJbHRlcFp5SlRGR21oaUw2?=
 =?utf-8?B?SENDTEswKysrNldsQ0lENXA2bVVvQUpOc1ZCRnJ3VzhlTStFajJKN0ZvMjdx?=
 =?utf-8?B?OUhWNWlmcU9DY252MXdEZzlYRkZYRFhxcmQyeWVxY2l6anNXWVFqWTd5Qk43?=
 =?utf-8?B?cXJ6OVZNODJWdGFYLzBpU1lENXA0aExIdFdqTDJQQUpyaGc3UmU5algzbklo?=
 =?utf-8?B?eittVHE2eEl1TG5DMko0dDVnN1RVRXdEUmdoSWNKbUlMbXJndVkxa2p6amxD?=
 =?utf-8?B?WkY4bklNb0pzTkpiU2E0eFJBYmZkaDN0RjRvZmpQQk5TL0oyRmtzV3VTelNW?=
 =?utf-8?B?MlVMdVFYZXpHR1l0T1NtWk9Pa2RLNEhBMFlUemUzZktMVGtLTU05aXM0Tllj?=
 =?utf-8?B?TnFYQU5CYmttbEMzOHo2c2ZBTi9zNVpNTGFyQkIvY0IwUWtpMFJXeHBvU2du?=
 =?utf-8?B?dEt6UDEvS0Q1RGxZWlJvQThya2N6eUhFcXZUQmZaOUdHZUFtUEhvZFJlejU1?=
 =?utf-8?B?dHZnR3FCVElkQW9YUDlyNm5UVGRCM0hyc2FXRy9JQmp2dXlhT0wvc1M3OTRl?=
 =?utf-8?B?Nkl5R2Y3RnJkT2FtbG9VZWRTOHpEKzlBYkVyV1VRM2RQT3FSZHBnbEE5NGJj?=
 =?utf-8?B?RjlUbGJjVmxJNEVock1weXhMUkhmSUJRUmc5U2VxcmFiSEcyV0g0T3NrVmM4?=
 =?utf-8?B?N01LYzBhTzhPaUc4WjFYQWNLRzJ1K0YwQkx3b25lMHduVFA0bEQ2LytiY1dn?=
 =?utf-8?B?V1dYRTVZV3BVNkdEM3kydTFGOFl2NzkxaVYvOUJhaEdTMFhsTzVDSVFiaktu?=
 =?utf-8?B?Nkt2Q2phV3d5enF1MVdrUFFZWThhbVNOVlJUWU9lVi85TGZlYlJ0UlFOTGtp?=
 =?utf-8?B?NTQ4SzVoL2Nzc3VnQ3Z4UlRGa2FMViszSGFiNnFjR0tmcnJqMC9kMzZ4bUVD?=
 =?utf-8?B?WklaQWQ1YVJRWk8xVTRmcnJsaGF2enFCM2hoUVNsdjUrdG82UmdpSkkvckhT?=
 =?utf-8?B?ejh5K212V1pyQm9wM0hSSytzcnRhTk5jUC93SitXSWhDRzd6TjVkTTQwaDRa?=
 =?utf-8?B?c084WHVyanM5dWhMWkcraGtqTktiRmlZOXdkSjVCY1YyVlJVdlFXNS9odit4?=
 =?utf-8?B?SjNQa2ZuS05KMWxSTzMxdmtmV3E2SCtBYTdIcWU5TzgzNkpvM3A4QVE2RXQz?=
 =?utf-8?B?QmlKWm0vZ0o5bVg3cW9FYjRUYXFPd2MzUWI1Zk9zazc0VE9meFl6WnRLV1hx?=
 =?utf-8?B?WGx5SFRoTXZMMlJqRXp5V1Y4Q095QWlqSDdHMjZhNVhMcDBDM0N6cU5weWg5?=
 =?utf-8?B?dG40NjhUNGl1WVhhWGZCQkFIcGEvSndpM3BnWFBET0dXaHg4R0krUC9wVzNG?=
 =?utf-8?B?TFlsUlNmbkRZajg2YXI3dGlXRWRhYitYMW5mSWt0Y0hVMFpLbzJENFZHbkVo?=
 =?utf-8?B?MVh4WWJlRTJqekF1M3R5VzRsalYzM0s3NnR2S1dNM1lLdTVMWDU4WmxVUzdG?=
 =?utf-8?B?aHMwd29TZ2RaTWo5ZmFrbzhPYkkxZmdld2RoNHpiWTNnSTVMWU5sVzkySGxN?=
 =?utf-8?B?YnRsVHNtSlJLZXdwZDhtLzhFa3p5VmhsY0ZJdGVseHJPR2pNMVRlNlNnRnNM?=
 =?utf-8?B?UVN6dnJMd2RaU3FINVhiN3ZsbnEyZ1h1b1lWQk05enY4UVpxMjh1aDhDSUw2?=
 =?utf-8?B?eEk4YktHcGVPWUhQRERCUjNXVGJjMksyNFI0Y00wTDRJdFc5ZG92YU1CMUpj?=
 =?utf-8?B?VVBVYjdrM2VVRm5hTGV4M042K25FbkxKa0NVZUR5UVpoU1IwVFBORGduY0lV?=
 =?utf-8?B?ckJ1anB0eVV2b2J5bHR1aEQxMHhXSDhIRW1XQTlpdG10SUZQejRueC82NXdr?=
 =?utf-8?B?K2M3aTNGVEE4QWR6VXZYS2dZRTJpT3dIVnBEY0V1OFVFNStiRnVHRVpoaGF2?=
 =?utf-8?B?RVBXMzlWbHNiek05cWZBY0lxVDlDRjBHa3lzdXBVb3VBTmRvd1FlekpZS1h3?=
 =?utf-8?B?dWc9PQ==?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba4f371-f057-41ea-1676-08da8f57eae3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3503.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:01:39.5773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPNuCMx+to7oniCxZm4BE2kmP1HE0Fp/97cllh3ZuE5slIgMRoMaensbW4mrK/78ycFnyboAK09SpZHQGtio5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3258
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Diana Craciun <diana.craciun@oss.nxp.com>

On 9/2/2022 7:07 PM, Christophe JAILLET wrote:
> L and S are swapped in the message.
> s/VFIO_FLS_MC/VFIO_FSL_MC/
>
> Also use 'ret' instead of 'WARN_ON(ret)' to avoid a duplicated message.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Changes in v3:
>    * Remove WARN_ON() and WARN() and only keep dev_warn()   [Diana Madalina Craciun <diana.craciun@oss.nxp.com>]
>
> Changes in v2:
>    * s/comment/message/ in the subject   [Cornelia Huck <cohuck@redhat.com>]
>    * use WARN instead of WARN_ON+dev_warn   [Jason Gunthorpe <jgg@ziepe.ca>]
>    https://lore.kernel.org/all/3d2aa8434393ee8d2aa23a620e59ce1059c9d7ad.1660663440.git.christophe.jaillet@wanadoo.fr/
>
> v1:
>    https://lore.kernel.org/all/2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo
> ---
>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 3feff729f3ce..42b344bd7cd5 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -108,9 +108,9 @@ static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
>   	/* reset the device before cleaning up the interrupts */
>   	ret = vfio_fsl_mc_reset_device(vdev);
>   
> -	if (WARN_ON(ret))
> +	if (ret)
>   		dev_warn(&mc_cont->dev,
> -			 "VFIO_FLS_MC: reset device has failed (%d)\n", ret);
> +			 "VFIO_FSL_MC: reset device has failed (%d)\n", ret);
>   
>   	vfio_fsl_mc_irqs_cleanup(vdev);
>   

