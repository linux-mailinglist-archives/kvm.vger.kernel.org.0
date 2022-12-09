Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E5A6487DA
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 18:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLIRiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 12:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiLIRiE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 12:38:04 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439C02FBDB;
        Fri,  9 Dec 2022 09:38:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKIqPBsjI/O9qXdqsTx9ibVGx8LozkR4youdLSUYwyrZsCjPIgWlSGryA/wIq+6Tlbzv/rQHYDYwgSvOB3kxYxstE0/nDm6QeoRNu5X54rl8eogN2ZkHoz6dEY/BKq/8HSP0PdUA+fAZ/58pdfnXgCUcsM7g674aSKSw/qTNHT3o+A0mJhwxhIhovO516eL/DPMDs/7VrL/kks407pp5SK9U4kgchyxdoeoEOS+bnS/0rHqduS+L4wSyAcugxdqEjgKww851PL5nLj4sWmOAROiHymO4spKUQdvwUqvCyOzcVrw0ZeFxRPfokUmVh/++L7eZt5YfwYr3XyA5w8VB8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xl3TTXO9a/FFnp/xDKi2sEa6P20P49qu5v2asYDVDak=;
 b=CU061mx18Vbw4bMeZUIe+jDogZlaxnxt07R7kyd+LRTRCoCLkzv5eIVAuCF7hMPuOLGZv8kpbqIk4zYgF/wcxeLPobaGu6cxziERUqrB/FDJlNiiXshb+rcci4AVDVZ/jCK6KqH6CZKVgG2gzF2A3WRV5aTp0fpcEQn3wjkti1KbR7j+Wf87efijNlkDyiWCUsyPz/U+9Zr4RrSrFKkhzNdV/zOMHU6+h/6XByBHb+RrbZU27CdNIVbQ2FdTjq1VrLMoXsj4/qHUPPkE3ETa9I+iM6SWZQ7T8k2bvQXSLpQ+0m9nRnvupWUgASIPQEKenVjx1kf0zxWgRtDq33Wlcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xl3TTXO9a/FFnp/xDKi2sEa6P20P49qu5v2asYDVDak=;
 b=JyHwEAK28Tl+FpKGruy1SVms3iukHLRd6c7y+ogeqEHa31emF6KuGkGsVpbfi7ApW0FLf1iXZ2ZDCm/oU5ywwjZypRn3jItYAfhTW2l1eNwUG9hxtS1tit/kAbwrVSija/lkFrnOXhKOHPrAEwCO+v5C4LZR+nwTwaaJICoXkYDWog0oBmle8bAqgTMTqybX2rAkPUEiPGI7QB+9h9bvymbz80BdVJcYA33DaA5wjXnODKSgqEMBbvE8Gr+Cl3uBf+nNHmT6qbY1ZYjk8+3dhHpfqrxXdDggBiuk/j93th3cUnPqibGqETCr5TZQ2Rt7uEEE+mijJSn81NR8/4TFeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6352.namprd12.prod.outlook.com (2603:10b6:8:a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 9 Dec
 2022 17:38:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 17:38:01 +0000
Date:   Fri, 9 Dec 2022 13:38:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 4/9] iommufd: Convert to
 msi_device_has_secure_msi()
Message-ID: <Y5NyeFyMhlDxHkCW@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <BN9PR11MB5276522F9FA4D4A486C5F60A8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y5NKlf4btF9xUXXZ@nvidia.com>
 <5e7dbc83-a853-dc45-5016-c53f1be8aaf8@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7dbc83-a853-dc45-5016-c53f1be8aaf8@arm.com>
X-ClientProxiedBy: BL1PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: c756c3f5-579e-41f0-2003-08dada0c1e3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12h7w9jU+I4NNqK4C+3RAhW/gk4j5fmNlvecsgMGby+dVQ5yDRiM+wc/wQ53VOYwTmNDzIyNiSEnhzw63AA/KE/zyZp5HCW7V/N6fUUXUpCFQwGSoweu74HcuU9OClKARujhGEnunCJWPoFFdRbNf2+z2hxeAOqoac1/q5FmdQLPEkMOcbTuT9/lCE5cwC3JnpKR8clCJkJ83yaNCIPBmsc/YE8PH7K7pBCE39D7Sg5f2jQk4igtaH97f35Sue2U7amv9NBTYyBLmDqFseDu3truahPLiNqJPWh3YOMnYCwIepJldxVgVp5nr6Hpu0DnBLnlyau4O34n0sOfZnQffVmr78ilnuyv4+n1qR0wY0JAsxMutdQLZuc6/w0S8C+mi+uTyFdYtUw3IiHPApib+xTaa83KMBpB0TJYH+6PR0psZIIIxLQQPua88asitKUZVeR05wNXJA3Ie0fuNz+JUWw/MNCVtXBewJ0tmpuc5iJt+/HAqlDu8NVgkgrBQ+N63u+0AkMRO/KtJxNXUZ0l69OtgAhgmU/ZV3myhtSoYq0O9V5T4MfRh6PoRiLX9njHEYkdJbGsJyV0sNTE8KxYnD0mL0AiGbt8dKPH2bZ5bdR9dN7RwJ2wsSTeEs5r/Vwm8cvtW56msF4QSiQJozNzFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199015)(6506007)(26005)(316002)(36756003)(54906003)(6916009)(8936002)(6512007)(66556008)(7416002)(2906002)(66946007)(4326008)(83380400001)(5660300002)(86362001)(8676002)(66476007)(186003)(41300700001)(2616005)(38100700002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p7xPIW5UB2BN3PWguo0epACkFfJcqUCnEJQH4Q7NIlTm8r3cyRFAj+qCJdAw?=
 =?us-ascii?Q?wJbMiLB5eaRU6NUpX/yPDYgCE8uR/q2gg9rffc+eoQmlASvcgU3U2Q/pCEYL?=
 =?us-ascii?Q?XVvozgCwIdDravaGxk4TdSognpju6LGsFnC75LPB9LKxhaOfMtQMbqh+HUZA?=
 =?us-ascii?Q?WLoqoaN39w8xvcaUhzcr1/hZwP6YHPasOXAOYCRW2fHOxJ8wSGn5XxuyE+bM?=
 =?us-ascii?Q?0zc+0QYh/YzRzIFFSZh8X3OZwHlFE16FniSj6bTGd9w1kJT2iQMOAm1iEaWz?=
 =?us-ascii?Q?eYRN8Xcb7qbaimXAlNykzFQf3mlvXhVhnengzw0GEfVLYoRE7FijohmbBumD?=
 =?us-ascii?Q?8v9pDnj+kuz9P4W2RMPYOqChADKiIbx7J/3eMKa9ctxAulBsWD82wwJDKhvc?=
 =?us-ascii?Q?zzEmyPK168y+xE8Bpvv7AgD1DYMbsAggMYdLTt8qsWkolocod+Pxw7yRqhiy?=
 =?us-ascii?Q?8Q4pSKIvb5PFFBaXBl8JJAv75wt/L6YIfGeAE+qAPVWHbqQ+yn9zFK1IA3/H?=
 =?us-ascii?Q?cHEpBwupj1MUO6MpxveZ9V9zwE4UbA2oORGPe1waHHBQwtxZGGzMWiHi0A8d?=
 =?us-ascii?Q?5FOaVVuxVMVO6e9MlQKfyLd8bIXitahx5E06xGNhmay4KdBy4oFKXKUy2Dnp?=
 =?us-ascii?Q?OpEfWDXn0B25QuqhCwBFsrdukRYxbgYsb0n8JfirFOK1DYvmOLpZGOYq9dU6?=
 =?us-ascii?Q?SsiMvOPHQ5nSDUpccck+FAf8jbPvmnP8hHpbN69sgEr+5CDOVHGuLpc/xwez?=
 =?us-ascii?Q?/8zkL2oaVOqvppps1JbOjttRUhOeyKy7VzrFRWV+wmg3qJk6LlknJt5TWrAZ?=
 =?us-ascii?Q?bHPKuzepHe32Gb8fIZ0xgbqYYw/ysxFmNZ/eEHcg7oFnevlveipj027GhSI1?=
 =?us-ascii?Q?ysWx45lIJN0Ql6l2lsqv5Km8PCJcFoynmihx/zqjtC2LpXNKBfTi4Uc/clKK?=
 =?us-ascii?Q?5vaE0GyUS2l0g4USh0yGgqXpoZvQMinPbiYIKqU79HB3AEzi/HSU7aNQDjaj?=
 =?us-ascii?Q?cHOjZ8/n18cBOjzgaL9DmrUfGPzwboOIrqvNkG6Rrc4IB8Xy8iWwa8xZQfZx?=
 =?us-ascii?Q?WuYKmU33w6930U56wczCH9IcpJjpbzCDF5DrORGPvapzkrGTDv0w3EN6m5OX?=
 =?us-ascii?Q?kfgTJ1vQzGZaCYAtQ4Bj5Co8FAWx8iZHMPVnzhWMz2vW6NACApQpwy3dqXQQ?=
 =?us-ascii?Q?C3B5PpsS6UklG4U+E2zDxQTFDli51BPQeUQs7mSrWyWZZjnwnV5sQtJIcbvU?=
 =?us-ascii?Q?S/uiXGGQcd7UWNErrweA1iSeY9msTdkyNwPwyvYuJ+Om6hZvj20MLkH+RX3E?=
 =?us-ascii?Q?lXniRdB4YvPHjCoM2CNtHmrdF+E2ICd+hfh/Tp2YKt1vACz7/WzuEO3SeJIO?=
 =?us-ascii?Q?S86KeqBCo4s1yijMKrfZfSObDbBZvCedANoUCX8i3HviMMwFFhEqliaapwuf?=
 =?us-ascii?Q?XiwkZ/wEAzmRgoAtBYOsADi1cJLeUD+Cg/4AajXCjl1FDo1vOfEXbfRl3vxN?=
 =?us-ascii?Q?KlGKSyRkpHPmk8k/fEQXAo6Aycnr9FiwOU/eAdFayFiyHmOboHU0CBiap4ZB?=
 =?us-ascii?Q?sQnT4t2r/kmwXROBHuQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c756c3f5-579e-41f0-2003-08dada0c1e3e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:38:01.0230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYONvcVWnXkzHKVnQJLDLTum4o8g55i2U29VOVxgHIF3ZWrcSm7zPX1MpnSX0L22
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6352
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 04:44:06PM +0000, Robin Murphy wrote:

> Isn't the problem with this that it's super-early, and a device's MSI domain
> may not actually be resolved until someone starts requesting MSIs for it?
> Maybe Thomas' ongoing per-device stuff changes that, but I'm not
> sure :/

Yes, this looks correct, OK, so I will do Kevin's thought

Thanks!

> Furthermore, even if the system does have a topology with multiple
> heterogeneous MSI controllers reachable by devices behind the same
> IOMMU,

Sure, but this doesn't exist and my thinking was to put a big red flag
here in case someone actually wants to try to do it - most likely it
is a bug not a real thing

I re-did things to use this new function, iommufd and vfio just
trivially call it

+/**
+ * iommu_group_has_isolated_msi() - Compute msi_device_has_isolated_msi()
+ *       for a group
+ * @group: Group to query
+ *
+ * IOMMU groups should not have differing values of
+ * msi_device_has_isolated_msi() for devices in a group. However nothing
+ * directly prevents this, so ensure mistakes don't result in isolation failures
+ * by checking that all the devices are the same.
+ */
+bool iommu_group_has_isolated_msi(struct iommu_group *group)
+{
+	struct group_device *group_dev;
+	bool ret = true;
+
+	mutex_lock(&group->mutex);
+	list_for_each_entry(group_dev, &group->devices, list)
+		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
+		       device_iommu_capable(group_dev->dev,
+					    IOMMU_CAP_INTR_REMAP);
+	mutex_unlock(&group->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_group_has_isolated_msi);
