Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB2511F2C
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiD0PRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 11:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiD0PRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 11:17:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A66381A2;
        Wed, 27 Apr 2022 08:14:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jROTHk3exkjwbgqOpCAVjSyFKwS+VBaqXcG9nFLtVkuLgVCNXkD+CDh/YpJTFs6BDnQs6Wq0pqn9b7ITtTtuqxXluyekQBCpMTd7NaTQkK5B8GQbn/4suyFt0ZNPdUy53EAKVjRFarq0XxOPo1l9eJpmSE9pKoZs3r6ou+d8lkrBSYjIAROKO31E9yoiKMDD6kpfIDBJ3/Jc7TbHMRQ8iWCD7qWIMjfgVqUa3WiTLOJH/5FlY/xAbdMPODvHGkXI8vo2lAniRf1ABZk5qrRaEuBVEjmKxoxKjzjRgp9Y28zmX8hrfumU0mtdjcnrfhnh1Wn4Tn8LFmhZLdVPuMUo2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+wayqI8cT3E9XrzUjIeXL7SQy9Yx4IGRtqU8ZF+DPU=;
 b=ieNcLi15sT4XdCMgZOh9+V35XgkJH5Rwbf+sH36/yfIe67pxim0NwdyjRX0fiNpnDNbLbv7hD7Zhxy95YF7G1fnjpw6c7zVWPE0xync9VeVKyq2knxuuMJOYMfpFXXV2cIj/v67tT8Vd6jnU+fPXmL9fHMA/lMrSgBbEiigXi6Um5USrUSlQ8Gdaz0d4P8cMWMoi0M6gLdfb33EyS+rylxA5b+QXIgkqMv8MOYHjPkHp9H1b8e+FAAZBlHqtnP1iZPPOfSpf2NQ0w8cpjxWYTYiosV48tu6YH/CEj8RDM6eyv6lLatHHAkg0yoL7FtDTWi+Lsvzo75yLORTA4l0KYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+wayqI8cT3E9XrzUjIeXL7SQy9Yx4IGRtqU8ZF+DPU=;
 b=n6gvV3RhsahodS+sD8ZiSt+UmDX5NUl6Ty1V3jkFf9f+59AuR50YWsxCSXSYy733dBC/Y8Fj7V1j5WT7bFR3oDzHLjxKpOF2ARHQEeQ6rpLfAy+pCIPOcVMDoQDoHgX2Tr4B1alZK2N5AolQA0Z3aVtG8xFtQ3abpW4Q1u56gHaKhRqrZy5U71s7Lx8JjQfIMFdUOVn2iO1ULeAymFEF2uINx+ypUIWMxc096/DZb677Hob/V0hjVMA6h6hZCLH+dQ8L5VXwfBDz1xqLlFO5guE+2Q0B+9WysRXfZEjeEUkhicJujeAyyfKy1YrU3kLXBpbgrj/1zWNtkPBiMxmdjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5077.namprd12.prod.outlook.com (2603:10b6:208:310::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 27 Apr
 2022 15:14:01 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 15:14:01 +0000
Date:   Wed, 27 Apr 2022 12:14:00 -0300
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
Subject: Re: [PATCH v6 15/21] KVM: s390: pci: add routines to start/stop
 interpretive execution
Message-ID: <20220427151400.GY2125828@nvidia.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-16-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426200842.98655-16-mjrosato@linux.ibm.com>
X-ClientProxiedBy: MN2PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:208:23d::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3afe478-331a-47fd-d379-08da28608f5e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5077:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB507738D027B6DDA60781CC84C2FA9@BL1PR12MB5077.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FM5ZB/w1INyfcQvZtocQXkn1n3oDaH3A0+84z/UGbD7JYHOKbWs6M4zGopRSrRn6OYURRrYnhH6q8uOp84YlVZEL0RmJMoHEoEBv5PI0afeid832+bmKLjq7Yfwws9aZsbXMZsK1N7Gs1lj7o/Gzo8HKmrDjatvuVedDEFnV4XTK3JB1cTq2/NiwI0Eg0KXKES7qjAPs6GyNFyAdpW8DKfR6bjUDM3Ox8BO93+VjMhjzwlzhMmUp2j30hB1FQxkadFOQCiRTEBsvlDsaV2yM98P8PrwnYH5o2nIVlCwtMPyUoQf+8SkMQxcrLMWQEU4lmidL78MBhU7ayi8Vuv65oLowZCASqXPx68Dss1WGuXM7sMTsaU4fhSp3KCco4hUE25qMXOcHcdEBoRDQF1jeod3Hn27VC1moRVn19tVQGC0Cwj41jRhowhqWUXUYJjEaFF4mRVxCQzDqd3MzzQ9x1SnLbGtTC+Q/QfoQK+j9nwH4nkt/AERPePjZvW1HZlazTtlWX31892Y4RT7/KDA2kw2mMkeG4DP6CqZtxIMx4prZ882FOkiMCLxP4fs0nX5NFSUVHd73JFLgQDy5VvXwSoaxXONxMzaMh8iVlzD5xiB0LLAAErGa8GgrCdv+LG4maSG4Vnd+huiRKKvOG3GdJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(8676002)(5660300002)(2906002)(508600001)(4326008)(6486002)(66476007)(2616005)(186003)(83380400001)(1076003)(38100700002)(8936002)(6506007)(86362001)(26005)(66946007)(33656002)(6916009)(66556008)(36756003)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HY1yu7bEu5xdA6izINQN5+R0jgiJXFDb0l4iS2/LB4QHAvyGtp8GC8pm4XXI?=
 =?us-ascii?Q?MLEGgetHk7QKVTOj+zSSl1fIowiQuDMIWNfj0bvwYdae97ItRAOsdpVyNjXA?=
 =?us-ascii?Q?Mhxfmctcb5iBqEBTxhnp72F1Ntd04G7umGbqBiXmpx0AR0gMA6KDLZqwRhBw?=
 =?us-ascii?Q?L8ipCUHmcfFuD5gf5HDeGXwkiQy+21qqvE9XqyIDFJ7O0ziySUeV/tzOspGG?=
 =?us-ascii?Q?v/W2ak1EgLAZQr6zkODnqXqh9vSiLENrELR/N23GfAT86wRNKOI040IaDkZ9?=
 =?us-ascii?Q?8cvgA6OLQNSs8lbplo7NwWADxdUTGg5WDjNvPUzXpvMd9ZgxNl9jyo4frSWz?=
 =?us-ascii?Q?e6BKFtHw7HfDq73b9Bl7QM3pAX96RkqhRh+wOsPV21BqDHZPMIEjZOfzhcJ9?=
 =?us-ascii?Q?unJqGXswlMFWqKzlTf1Ix1V2I5gS4Te7RtGkGJMKyH2qIZMWTDvqBoumVcFf?=
 =?us-ascii?Q?ure3WsGr8JwuTCnAP0DRbJ7vZjVt6+tZXQOOhgPcBGswQGypFFDSxL9FhAVg?=
 =?us-ascii?Q?5EbmSZ/2EY1nZo7gFCZqrhDsRiqCg74w3NtHTjnQvWqKGAYICRpwAmh3Oodv?=
 =?us-ascii?Q?TDcRf36R7m/nsE+DhwlocSF/f3LhFbp4w1iw955wOUqYSM6PVKXXzoVJ+UOW?=
 =?us-ascii?Q?RSpvcGyd+fLHBNe9nK7Gb+DfmVyl7cNSAUT4gK+7YIGti5CjaPMEKksFD7O4?=
 =?us-ascii?Q?6bY48E5o4uIduZR19hl6n1uIALf1YRfM51tA1+RAWuqGVKI2ItY5+cAcKALs?=
 =?us-ascii?Q?0dQ/lhomShoIMElKDA4KfAK3vq+Jn0CQvEOz1pUqSchU2zdhNPhGHH9Ekiwr?=
 =?us-ascii?Q?LEE4dvh0yD1O+vvANXQLfYLS80Cv2Oz2dxakwOLen9WqrO9sanCvWhRqPpnz?=
 =?us-ascii?Q?msUC7PR1IJXpNMLYoIjuoun3ZbltiTnIWd7Jrm7C9LkfOP6whqHk27xhAMey?=
 =?us-ascii?Q?bG6azAcMRtJe1T4T4U/5ZlKiPCVsQUkXCrP8BkVAl8ZEWj4RjubwQsKBgE9p?=
 =?us-ascii?Q?2qGXN2DeMKx5lSoRJ/Rqc6suTs27v1MC8HWzTs5tSLhZNsoPybCUtLS8r6gx?=
 =?us-ascii?Q?IBZWjxXIEB2/mNL2N36EGWKGNv327a+2UG0QtlpjKxkPOpfvdAVz2HDqrkBA?=
 =?us-ascii?Q?WQsWWfgRyZIp26QDAQeKC8yf4omZ86HhuYagwt4SxaemjyzS3ikWuilB2ZJF?=
 =?us-ascii?Q?5Fn5V10Woz//RkxxnTE+jHMOXF32serh665SVAaXl5jV9kfDimC9if2+D0wm?=
 =?us-ascii?Q?WWJtFeD+WnlYrLPxWTF/S8vEQ64TTpvhHMqvxciACTAnRAxSFgctvYXwSpPT?=
 =?us-ascii?Q?hq8HBaPn+NVKJw3d9B1X8aLgZUVfuffCugr8pIrg2rmiOTT4PxX9RtEsaYxO?=
 =?us-ascii?Q?AD5Md2gkr0dKGDfwgyJciPfyjUGbvdNZ6a/QxGfPWvw1rUiQkOiUSjcNVP17?=
 =?us-ascii?Q?KzLAxZyJXRCXdE4V6cU5cld/eyRhFfTUzyfMLl6h3x4cLcsixMHw/1pYItzG?=
 =?us-ascii?Q?ZE0FXSL5jd374saFv94tTM+h6qhoAdtUGV6m/D8SI39ceEblV1zL3lmTgDQO?=
 =?us-ascii?Q?UysXNAzG+yaR77SjNDRG2LjWP6ygT8+edaXAwW6Gwelzy6lxK5kv2ULrGoPh?=
 =?us-ascii?Q?cMjKfhVU5jBibpY/Fqe2MmYfmuXjAO5qw4u5BOYECG2vHPU1JVyesCHWm65Y?=
 =?us-ascii?Q?5lKKH1dpNrCE0+TA4uab75JSN8HxLyRa3AXtJlvPcWaytyyvK003M9ET+9Hj?=
 =?us-ascii?Q?4FL7NJTlcw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3afe478-331a-47fd-d379-08da28608f5e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 15:14:01.6017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WkObWjOcs8sXpi6DnpO8wz5RAs2cQWT+f9do+/boBCDMKi3Cxz7qmjMjBv6MtCS/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5077
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 04:08:36PM -0400, Matthew Rosato wrote:

> +int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
> +{
> +	if (!zdev)
> +		return 0;
> +
> +	/*
> +	 * Register device with this KVM (or remove the KVM association if 0).
> +	 * If interpetation facilities are available, enable them and let
> +	 * userspace indicate whether or not they will be used (specify SHM bit
> +	 * to disable).
> +	 */
> +	if (kvm)
> +		return register_kvm(zdev, kvm);
> +	else
> +		return unregister_kvm(zdev);
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);

I think it is cleaner to expose both the register/unregister APIs and
not multiplex them like this

> +void kvm_s390_pci_clear_list(struct kvm *kvm)
> +{
> +	struct kvm_zdev *tmp, *kzdev;
> +	LIST_HEAD(remove);
> +
> +	spin_lock(&kvm->arch.kzdev_list_lock);
> +	list_for_each_entry_safe(kzdev, tmp, &kvm->arch.kzdev_list, entry)
> +		list_move_tail(&kzdev->entry, &remove);
> +	spin_unlock(&kvm->arch.kzdev_list_lock);
> +
> +	list_for_each_entry_safe(kzdev, tmp, &remove, entry)
> +		unregister_kvm(kzdev->zdev);

Hum, I wonder if this is a mistake in kvm:

static void kvm_destroy_vm(struct kvm *kvm)
{
[..]
	kvm_arch_destroy_vm(kvm);
	kvm_destroy_devices(kvm);

kvm_destroy_devices() triggers the VFIO notifier with NULL. Indeed for
correctness I would expect the VFIO users to have been notified to
release the kvm before the kvm object becomes partially destroyed?

Maybe you should investigate re-ordering this at the KVM side and just
WARN_ON(!list_empty) in the arch code?

(vfio has this odd usage model where it should use the kvm pointer
without taking a ref on it so long as the unregister hasn't been
called)

If you keep it like this then the locking in register/unregister looks
not broad enough and has to cover the zdev->kzdev also.

Overall I think it is OK designed like this, aside from the ugly
symbol_get in vfio which I hope you can resolve.

Jason
