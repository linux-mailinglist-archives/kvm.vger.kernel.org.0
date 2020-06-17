Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705441FCE94
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 15:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgFQNgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 09:36:22 -0400
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:60120
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726950AbgFQNgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 09:36:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPL8mAcAQ7cSsifOQ13LEk45DAXBT6uoBWHgxGdeyTAZI7f4OVS49GqxB+3yRHRYGZs49AyeXZPd9ECkZ8rUMW+lj8unyaHqdzv8nIj8uttaTDcKiGk6GukMclCAAitlIADxT2SNlIncggzqXCdCJO8G7pRfopijroUdSGKQ5ZBMRYCrD7VeCw+aYdnC7ESlifbBT3N21Xn4L2GJ6WPdU3rBWNCFjYDyo4hbyjvOLG9EGVouiBOxFwipVDxBmDt9ozN8LuskZ8puOnvQsoIAxfzVGWF19asuVpTrulgEHdQcOekvZ/rgrYWJtta2nqLoEScgUxlzxYBoqrrDbqRR4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvHOs6iuja798yywxyx+tvZTrQ8+Kgs0RIgmoXbd+Zo=;
 b=GbNXN3sY916HAgrsd9Snko2x1bYD7+oE1UgODrfpEJlNCXkfwVlWTT/VLejUpmEEz0k1F0MTx4Zoq6L0kf67IUzGNIIs2YRE268BukIhyGDYfKZFzZ2dtWSKh+0jNtNu+z3oGl/zS+XGK7lc89WcPw++Rrw+PFQT9n09rGNk43omb0xGlPCj6JE4Dvt4H9LaRB+Y6e0sl1zimNBOf70h+YfNJoeVwQj+Qku+ZS/JjKVsxFMrMyAwIHtgdWEhuTtfF/qDga6lLfMbxoKrQYjF3+tyC/L4+iNheS+mf7dfN9bTraM9y9nrX2DbQi5ollZrAikeMrqQg66KGc6RAdycUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvHOs6iuja798yywxyx+tvZTrQ8+Kgs0RIgmoXbd+Zo=;
 b=JgwRwmG0a/IJ/l7gfekW60g6VexVwwmxxEpl70nnazjleL9GNPR3GRVT1jKLRJcyhbPbnOIIC790yWGkiB+8IEjnPR3NaDJgi8oA2imHB0rtSyVreyHX862Bv0al3ne3/REFk/4OQmlbh0Id/Pi1V3uWSoYAaYsbEYf8yCC5A4I=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Wed, 17 Jun 2020 13:36:14 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3088.028; Wed, 17 Jun
 2020 13:36:14 +0000
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1592390637-17441-1-git-send-email-pmorel@linux.ibm.com>
 <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e5204218-6e93-8713-6056-2a62531c310e@amd.com>
Date:   Wed, 17 Jun 2020 08:36:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:5:100::46) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR03CA0069.namprd03.prod.outlook.com (2603:10b6:5:100::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 13:36:13 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ecbc5f07-08de-415b-f7a8-08d812c367b0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4516:
X-Microsoft-Antispam-PRVS: <DM6PR12MB45167209AF9FF9B2346E2FF0EC9A0@DM6PR12MB4516.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8oA24Xgjp0RGJEfHidVkhV0shJFIR9/m9XKiXkssR3hZQPg73Qh2t4shVtWeddGVu5iRsaeOUI3o/L0P9gctm8t8IUuf8Fq5kd1RZe3gD7ULV+NsrbsXmxbCEKGMN6WLUNxZFKbChVknXNHpP0MsnfNecWTS0Sr51iW/k1dDF1eyGs27v3NschuVv3CfbTe1ROaiZQIrodFPfsNa8+q++cWcdhQuuygSmOoC5hguadBwJfErrGprIa3XZ8WATR9fAISNfi1+UZQvNpyypcF8rGDXjNnEe75NaKmN2Nkwt/shD82a5WTngR4cUjtpLzdZ5IG+C8LqFJs0TB0Y67Vz+b1Uj2CJ5tbg2p/ScD+3NidXIJbLbqhyZelfVA0cadDz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(16526019)(8676002)(31686004)(186003)(8936002)(6486002)(36756003)(478600001)(5660300002)(66946007)(83380400001)(2906002)(86362001)(66556008)(31696002)(16576012)(316002)(26005)(52116002)(53546011)(7416002)(4326008)(2616005)(66476007)(956004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z747mUaH5GDSh9T85IHL67w/rg/LsoCnSx/KZpvvJ9XsCXSO/QQAw9KJxa9ExLHIGsC0pOFBwT0SPyuTOWiGObCZSVbS+s4kQ+BtmceFxB/zvd2sSCECWMOMhMTBORugmK/NXPiH5MjvbmZ/U7DV+9Z/hyIRpkfR6K7q/fYm371Ujafmu87VuaGTxXrG6JhqrIEh/LWsZwr5c761E8OiIkSgYn31aB1KE55yBVwsu5ar3d/ypR2Q0VKapeZqspNO9wZ9F8X5pbxLs68R82AYKTYNKIJEXG0QZRjn7S5Qsf4Twzx8hSHDrW/E3oAafE7tyMGrejigfox64GnjnboRkBAxNwVvjT8r3etr0W0pQ++NoFOwm1e7cXJXVqmzaJiWoGwf2SqELto9fDkPOLnZ107NcNitFBcd8yIleelmmBh4JCPatW3iz5gcJ27jUriRpB4YwBs+Rp6PhK/MP/RTRffYld9g9HjYMJJ+saF+n0s=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecbc5f07-08de-415b-f7a8-08d812c367b0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 13:36:14.2727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpGH2vcxwGGPFwfZT13zVQocIFvCXt7+aX9VTKdZ3DBv6DNfCb0llzSiJDQ4Cbqw0lEpGj+9xhGO8p75loA/NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4516
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/17/20 5:43 AM, Pierre Morel wrote:
> An architecture protecting the guest memory against unauthorized host
> access may want to enforce VIRTIO I/O device protection through the
> use of VIRTIO_F_IOMMU_PLATFORM.
> 
> Let's give a chance to the architecture to accept or not devices
> without VIRTIO_F_IOMMU_PLATFORM.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/mm/init.c     |  6 ++++++
>  drivers/virtio/virtio.c | 22 ++++++++++++++++++++++
>  include/linux/virtio.h  |  2 ++
>  3 files changed, 30 insertions(+)
> 
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 6dc7c3b60ef6..215070c03226 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -45,6 +45,7 @@
>  #include <asm/kasan.h>
>  #include <asm/dma-mapping.h>
>  #include <asm/uv.h>
> +#include <linux/virtio.h>
>  
>  pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>  
> @@ -161,6 +162,11 @@ bool force_dma_unencrypted(struct device *dev)
>  	return is_prot_virt_guest();
>  }
>  
> +int arch_needs_virtio_iommu_platform(struct virtio_device *dev)
> +{
> +	return is_prot_virt_guest();
> +}
> +
>  /* protected virtualization */
>  static void pv_init(void)
>  {
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index a977e32a88f2..aa8e01104f86 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -167,6 +167,21 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>  }
>  EXPORT_SYMBOL_GPL(virtio_add_status);
>  
> +/*
> + * arch_needs_virtio_iommu_platform - provide arch specific hook when finalizing
> + *				      features for VIRTIO device dev
> + * @dev: the VIRTIO device being added
> + *
> + * Permits the platform to provide architecture specific functionality when
> + * devices features are finalized. This is the default implementation.
> + * Architecture implementations can override this.
> + */
> +
> +int __weak arch_needs_virtio_iommu_platform(struct virtio_device *dev)
> +{
> +	return 0;
> +}
> +
>  int virtio_finalize_features(struct virtio_device *dev)
>  {
>  	int ret = dev->config->finalize_features(dev);
> @@ -179,6 +194,13 @@ int virtio_finalize_features(struct virtio_device *dev)
>  	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>  		return 0;
>  
> +	if (arch_needs_virtio_iommu_platform(dev) &&
> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {

Just a style nit, but the "!virtio..." should be directly under the
"arch_...", not tabbed out.

Thanks,
Tom

> +		dev_warn(&dev->dev,
> +			 "virtio: device must provide VIRTIO_F_IOMMU_PLATFORM\n");
> +		return -ENODEV;
> +	}
> +
>  	virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
>  	status = dev->config->get_status(dev);
>  	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index a493eac08393..e8526ae3463e 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -195,4 +195,6 @@ void unregister_virtio_driver(struct virtio_driver *drv);
>  #define module_virtio_driver(__virtio_driver) \
>  	module_driver(__virtio_driver, register_virtio_driver, \
>  			unregister_virtio_driver)
> +
> +int arch_needs_virtio_iommu_platform(struct virtio_device *dev);
>  #endif /* _LINUX_VIRTIO_H */
> 
