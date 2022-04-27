Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBF55119EB
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 16:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiD0OH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 10:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236817AbiD0OHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 10:07:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE54F49F3C;
        Wed, 27 Apr 2022 07:04:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkPup6EzLRaxXvm9iCwACLlNUOJUZVQgm2h8UHW+Oo/bEWeGQMLBZKcEGIHO/ll9QJnxUznOsFvmTo31HdQGV2IfR5plfmpFN1FBqTi6ePlXMeCIrk91Xd3ZJ3wdKl4QxdSZKzpi5bH11QOTquNtmscs52zh2F+LyGn8SJnecAGAi44evK/PQ5yaqo4C+yJAfOxV029QeiZVm1YuqPJobDRzPUNXzTvWQsrO0iq2cP2gSXAsLkxshPx5PjeU3thMi3AIhvxPr4V5JxzQnqrfGE1yViO8hEZgap15eUm6Omt1Od+40sM8awXydiFpBaNeu8U8DmL2tpn3i/+d2yCbzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOgcx4a9oXkoYntP12BfQ3X6+7t7XYyNmex6/Vx0HUw=;
 b=LdTBEruiHTzwmB11CEyxduJimQC0abd2Vd9yw61fVDhRf8Au/XIsrSFF2Pm8RoYYmVx72LlDjlRYxXyG0iEqED5REF+9H+pZ7tevcYtGu0QP5kbzMQWYdnkpqkK1fbE8Xc3M7ESViFivZ/W8af0qJ1/Rqm5KyyOi+COa0c6fww4aSAzdwI7v8jgaibJHzQFJDpsKFfK2h+k9kSsnA4bJRrK26CF0cev4bRODVazjsyvtYH6OGfQd2VCuUgiDd6WM8DSZ0EXyucQOgR3+VjgeJoJprkNsLorr3DjREOJQwyncN4KfN+V71SXvQaG/GP5TbTKCi1/hCehzvPhbMu114Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOgcx4a9oXkoYntP12BfQ3X6+7t7XYyNmex6/Vx0HUw=;
 b=FdUs5HEPKE5HMbRaEV5HEkIHQS6NwzQF/QfxpmcL+AV1tWnG3PfIznBOj0y4/z6Uu8Xjx1t9dGV2pjNksqyotKli2dyk6VW6nRNOJdPZHGcxVkxsrP7Xul5ePLDRe696ojMwbgQspHmVNXzDFmMyDWZFXm/wBpvft6/L9X4J7b77O0Sejarpi41rxJEt/eGzxIGADJqQ6QzyfoqBq7yOkGhvSdBMa1LDa6kqF2fNDL7Cbswm9782gJPmwLgG6DgqpSOKAKGYmP5d6qHshfH1AspVOL1flem1DHHhJ+hfc2UgoBSFEKKWXJhSqpuvgqLQHQGXRl+pgVKqgFvjEmHM7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3728.namprd12.prod.outlook.com (2603:10b6:208:167::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 27 Apr
 2022 14:04:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 14:04:12 +0000
Date:   Wed, 27 Apr 2022 11:04:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 16/21] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220427140410.GX2125828@nvidia.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-17-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426200842.98655-17-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BL0PR1501CA0033.namprd15.prod.outlook.com
 (2603:10b6:207:17::46) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 505dafd7-d316-448b-8802-08da2856ce5c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3728:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3728D46821AAF5FCF8383642C2FA9@MN2PR12MB3728.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lSgGXmr/9EtqD0Nf6fx9+BBsyXVrXHUnWN9d4KbHNbXfeEnE6C5O5GGstGZqR/STpYAVZBuwE9Rj2YdEuTGFzXyY9Ziw3ns4lSIwieMLH5QyGoOpDp1FQysJAn/TeB+Wcs1Ad4GwggizrAnXEfZzVxxXyf4jo/GO5d+jyS2aZHrm8+GG5TdZ6gHBVEb/RJmCZ6766dHzoMyOKRoc31FIhOYGZB/PFxK7xE6QPwzWg8NsgnnheuSXorPcPoCGasdUGfk9x/BRKJXvOJF1bZBC3AFgZHKym3OOlaZxw4oWxQt4DWwM8fJGtBweXu0LnbFYEE7AzFdaxduR+S3ccG4rUuVXYn8kC+CJ7Hjp2zh/erxVfvbb4uwg/22GWW3ntbC+0MjI2rb6rHiwqpt1tnaWe4Znt7JFIwsPLz7ISCGzgwZYW0asn/OoNsswwYcz5d814VSvBIoMGc65KQ03S5a8RgNvhYXVSVd8F46PvzPczHrJi4aCirPr8UfvyWKjMIZwlLlQiiSEiJe3c3QVPTwCvq+5UhiveInzRYM81akNJ6L8SSVqTD0u41cftsMEuHBGehc+Js2nrNiWPLwpnvJE2uvllK2xQBU9n3/njxzKH1NZlVn9i1YRfO8vQov7IJb1dbpXJxO0tIwFVnNQPqFXPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(186003)(1076003)(508600001)(86362001)(4744005)(7416002)(36756003)(5660300002)(8936002)(33656002)(2906002)(26005)(66476007)(4326008)(2616005)(6916009)(6512007)(8676002)(66946007)(66556008)(316002)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L6qgz2jmcKSxmzQgj41HZKGbOV90psXvEfj0Om74ctEr9eF6230O8S2PO1Ox?=
 =?us-ascii?Q?rfCXX3jFRgok1BgFkBInk+QmaFvip7UQZCrOKRN/Nq5RoE+3+TLgtcUEesd2?=
 =?us-ascii?Q?IlEFKX4u7r3ly/XYGgaAmkvF51CvgUb0OqG+qVLMPzgXRS6cKsj3YV4k8Q9H?=
 =?us-ascii?Q?SW4J2PB+SCI/utlyE5vksWHW0abdPEa7Fne8QiQNOIdO5yg/r7mH/IoeHD1H?=
 =?us-ascii?Q?fWXtCjRApXNfrYWrLLrEnCv2x0G4NODqyTmqaIInu0kAQXZXd1iWHDnkC+6V?=
 =?us-ascii?Q?fEudAJzkmZG/LdP/KZWFFw1Ma/hGZv7Zgs3iPRg31lOzeAP8fLiihM5QMQOd?=
 =?us-ascii?Q?UaAMDFwbkBVeD/sUOiKVEPvq8QbJkZn0sw8mBp1+Thb6EM15U9B3Kjo3DSdZ?=
 =?us-ascii?Q?oEhvvI7TQ6kZuaU0uLI1KlgFFDmoHPBlas9v0jh4dcGybKHeoS8W0XRP7i9x?=
 =?us-ascii?Q?zzRybdoiq+/ma+AQWE2xRNIPlACC1JkVy3R4dBbkAs2EKE4xWda2vB8arEeA?=
 =?us-ascii?Q?NwtM+M/8Kk+QZkGpgLMKW9asYfKrGTWTaoGN3XUXnlgxlbTgnvOW3Y9zXTi1?=
 =?us-ascii?Q?50+dVOPE97s9+AdcqQh58MtLwpAl22a85HazyWJib/3wiC8A31GqlmJrR230?=
 =?us-ascii?Q?59ibX3ibNwFgojA+lsNXt1+CbO/cUajDW+cdhPjzWUsT2dj61TXWLaRCp6tI?=
 =?us-ascii?Q?Chw5IoU1igdZonRAVgJUtQLKC27ddi+mfwQf7raTA4cb8JFNzimoVvk67P3L?=
 =?us-ascii?Q?I6AM5FQRavNnV6RRXySU4C3qugLBk27itgRVQtfPZEJEFCSScFvSlc7QTwqv?=
 =?us-ascii?Q?Gd2DSBZY8fyOTUkLFx935iAYNNOGeuWnC2sPZrqvQFe+XIABB81C2fYygsED?=
 =?us-ascii?Q?5LFr/YVUeieGmtShhGIOc4uJnfjOWC6666S9pptvi26gkJu1Kxzo9yk3msfX?=
 =?us-ascii?Q?KDqnRl6L59gjEj6Hkn8SDkFGwUFlzBFebJDmJFApF+Dzo2eKJqsw4iNUv9Ue?=
 =?us-ascii?Q?tZjOtdsRGxa5huzeWbTLohrcrWxJf89Ex2tD+baDnxtsNs+GA8sLnwvChWw4?=
 =?us-ascii?Q?o+Sb3dktLTgTVkhA5/NdWwqPd7Facsw3wZbXOmH/iesaBcui6dTaPLAcg5YW?=
 =?us-ascii?Q?vMt62shuz1elO5AuEFSCRlPSTWuwDKOUBW7VdhGVRSGc/S91M8gvZqpsV1yF?=
 =?us-ascii?Q?pbi0ZZLQTGS0dShu2JWNrAZIB5wers2fc0KE9C2G6XbjHqw3UTrDow21hX8c?=
 =?us-ascii?Q?YhqBchsBwHVaoQoFRx4BJO20CVNhB84lfDvk/XDFQcFw/Z28XPTOFGUUAwXG?=
 =?us-ascii?Q?eduhd0rTXmUGX4aWKIkc0M3FbDg1zU4Q0Xtev5huGzJMWJn4+n2dMpJ7dSJ/?=
 =?us-ascii?Q?aYzzRysnIo4LQg+AoWYztfI1XHelqa8tqEaEFPiLUutDktTiVabmZpizLfJo?=
 =?us-ascii?Q?rRIdRUNXnZcT4j0nAJRMChB7trLxfN407frwnit90ZPzG0XSxrxi72X2hgBx?=
 =?us-ascii?Q?suy72XhJ2VNylWzPji8CcO88lf+ujDxzHHMCr/4OHUwfoqAdpVjZObfRxRxR?=
 =?us-ascii?Q?0XFZ/c+Ve/rnIBbTUn0ozUMAFzaonzWVWoVsWhc4nxeptU4ZJ5+whzPJA0i/?=
 =?us-ascii?Q?9rmXppiAfisTZvFXC1HVauICZJtUaOnDRuK6+XZyr5j3Cr9CpugTBmAOwrKs?=
 =?us-ascii?Q?PoR3rirAYZzvasIO6M0ftoBjmVohcQbVBO2rSnVOphUlod5Uhhwwf+2CSjv6?=
 =?us-ascii?Q?nk3Rgzq+7Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505dafd7-d316-448b-8802-08da2856ce5c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 14:04:12.2690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HiGgoAPoWyId0kfiep94wpP3bUV0x/SfgWABIuO/aD59p+vUZHj//MSCRXhG11UO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3728
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 04:08:37PM -0400, Matthew Rosato wrote:

> +static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
> +					unsigned long action, void *data)
> +{
> +	struct zpci_dev *zdev = container_of(nb, struct zpci_dev, nb);
> +	int (*fn)(struct zpci_dev *zdev, struct kvm *kvm);
> +	int rc = NOTIFY_OK;
> +
> +	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
> +		if (!zdev)
> +			return NOTIFY_DONE;
> +
> +		fn = symbol_get(kvm_s390_pci_register_kvm);
> +		if (!fn)
> +			return NOTIFY_DONE;
> +
> +		if (fn(zdev, (struct kvm *)data))
> +			rc = NOTIFY_BAD;
> +
> +		symbol_put(kvm_s390_pci_register_kvm);

Is it possible this function can be in statically linked arch code?

Or, actually, is zPCI useful anyhow without kvm ie can you just have a
direct dependency here?

Jason
