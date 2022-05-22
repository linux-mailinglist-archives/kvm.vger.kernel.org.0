Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFF25303B5
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 17:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243275AbiEVPDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 11:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiEVPDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 11:03:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ACD33A2D
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 08:03:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5uU07HeHRt0ig4b18Gb5121fmMEBUQdmWGM56r6ooY36oy5sXNu2oSYKTzI4pkyW8e2MTs81RTm7RHbdokzUlLiHdnxZUFASrrRsKUiqBUHlvGa8qC1+nk5tyZ3U8vU+W1u701/lMplZpYxExEnLgymrncbE1YaqQqKbB0YEifeVyMG0eHvHAiuTMC5EdaO7k6mg7/hviPBAmUpgXg4JyDumBV7S0ix4Z0NIUvcU9DhNVxJm5HErnIl0s8/xYlX9LV7ha/LFNO46/WfwQ+OX1sIvNhtvW3uof+1DLhakdas6Kyf5m/uI1/vJlWkxpW7IRsIoB9WpsBuSrxXLGbMFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30CrIsBPqjQJm9DNLpoihTy9XvUCQzE7htKBnZh5jv0=;
 b=iMS+cj3OOT99uS/WtPnurC6Jil9heqJVCEGyZrQ53iZ4dX0eii/ByHCpqjqT/kUxjY/gDPwL+5kUxJBCW9t26kRZ4RjrJdNaT5hDrLnWlOjt7Tp0vOPH/HHG6yFCf+y9qaQtdmN5MC+U+dKTs2Md1lOMJJSNPgKHWsN6+rzlTio7b+1C+69WVmXQZlEfsYEl+0S37WPP/iekuqy5VSbdvSRpKdF+V6ItYcCYrSNGW4xE3QtL5C8r/bQPL5Fj2kgAo9GDXm5JGO14a+xUAxgFCwo1KLxR0eyfJjtOaNysHrK/OJb/oCpVi1FRcIJcfBHfowb+ycMEpZDoE5svtUkQ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30CrIsBPqjQJm9DNLpoihTy9XvUCQzE7htKBnZh5jv0=;
 b=lwOBuLFyWSMRzuAQMYkp8lcjXxR6xGnVSol09PDNeHC+mRusrCF1aRNNsIJeFjK0BdwtqHabhiYCApDzmHPiAuzfK9N4cR/ScjXytKI+p7tLFT6K3c6tB/xXFphh/g/ou20dAD8z02fJTNxu/urYzYB9cyQ84ORU1mPHwb5kVYDpzJ5oJUVS8Jr1i4zdOMDs1snuwPmSyinnii+uuK7qJbLk5H7viMSop/NWneFwoqpYeLWJNOTEm1clx+XdVGCzueQQNpxWDRFFyZdwYitakBSA4siI52Z8Rak4OBZlPjXv7rWeC3bkMUwgzIXZsaqjChCCexKmcs6PBYuxC/NVhw==
Received: from DM6PR06CA0085.namprd06.prod.outlook.com (2603:10b6:5:336::18)
 by MN2PR12MB4094.namprd12.prod.outlook.com (2603:10b6:208:15f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Sun, 22 May
 2022 15:03:40 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:336:cafe::bb) by DM6PR06CA0085.outlook.office365.com
 (2603:10b6:5:336::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.21 via Frontend
 Transport; Sun, 22 May 2022 15:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Sun, 22 May 2022 15:03:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 22 May
 2022 15:03:38 +0000
Received: from [172.27.11.185] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 22 May
 2022 08:03:34 -0700
Message-ID: <668458c4-2596-fe79-aa40-add3147cacba@nvidia.com>
Date:   Sun, 22 May 2022 18:03:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] vfio: Split migration ops from main device ops
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     <kbuild-all@lists.01.org>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <kevin.tian@intel.com>, <liulongfang@huawei.com>
References: <20220522094756.219881-1-yishaih@nvidia.com>
 <202205222209.5JkbCwDa-lkp@intel.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <202205222209.5JkbCwDa-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1848c6ad-49bb-45f7-f2c8-08da3c044130
X-MS-TrafficTypeDiagnostic: MN2PR12MB4094:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB40940F634081560591D11B4EC3D59@MN2PR12MB4094.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H6Ddsk1GjPpR1HseqhpddyGwPJp1LO5GCLkQQ8cZHkVenCZgCsQBki+8u4RsshXeDChlqS5SayRtpOgcOrY+zyMgXizlz0jRKD76bprAINpnDiR1Fdrxk/PPJVs+2OVj3rTopFqXclMGQL3tRoWFy1Ml+8wIfOi+1H0f1jhH8JaG9WTS47gzXpS8TBdirE2j4uVuw4zOqpY2Yv4aEnUZT5gknzFLns9jzwNzj0JPMWPwNs6fiOzyqo3HTSIMHzRJ6ZiO1UrWrY9qnfxT9bIehys4nzP0EuALw/3MIu6zquwj/6PdZmKgyXzR6TaKHwx2vJmoWyvAFPz+t++JQUXfUGf3S5GIwQlOfK4QRFV2FKEkepUrLfBaAhyElUxGoZ4A87l8iub00zyJbIQLW03Tbr3H6MfhQAp+OQW+RTHKGakKKK4YrYblWHyn4tFEkhp0BJdioM33NfN/LUSmfKVE8wnIarQY4M94u1M0G6weNKT+bErIm8z/ewqD7laG2m+zfbAqBvHA1pDQSoTl6YKVqvBFDQCB1UzDbZUaEuAMWHciShP/qTQbYJyQOJmC/PKrfTojbcs+s8sVc+hXxbIm4X4IjM0OwSSyTeMCj1bZAwKKfxu5JlE8hnr+uie6Xx3thzMJqKA/t8THWK2SK7kqay7A5R2Jslmh1gWPP50WSj8IcgTT78v4AtMNDSVKYZwEEPjjehT0ood2EL/eGo2pJTgibPG2uw8nR/RFeny3DGuzA4PN3ZmZE0UYu57NIILjajS07qYpn70k44EA+kwOFubsZiW1gX5KsGGibSG1MtDUdpW9pPUDCHY/weKjBipS+XvNm6OlgvJmLkCiHFp372z36Horn4IgOBfaD5A+CRCPm3w718FRg4vaUmB/MqbosPCdVZPNyp46sP6otNsWUg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(5660300002)(966005)(110136005)(4326008)(2906002)(508600001)(8936002)(356005)(31696002)(86362001)(81166007)(40460700003)(82310400005)(16526019)(186003)(426003)(47076005)(336012)(83380400001)(54906003)(53546011)(2616005)(26005)(36860700001)(70586007)(70206006)(8676002)(316002)(16576012)(36756003)(31686004)(21314003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 15:03:39.6515
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1848c6ad-49bb-45f7-f2c8-08da3c044130
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4094
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Alex,
This patch requires some extra handling in hisi driver to fix and 
encapsulate the migration specific handling in a single function per op, 
which at the end will call the matching vfio_pci_core_xxx function.
This won't fit to current kernel cycle as the merge window is almost 
here, however your feedback on the below approach would be appreciated.

Shameerali,
Can you please review the below and send me some matching code in your 
driver ? I may put as part of V1, unless that you prefer that I'll do.

Thanks,
Yishai


On 22/05/2022 17:21, kernel test robot wrote:
> Hi Yishai,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on awilliam-vfio/next]
> [cannot apply to v5.18-rc7]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/vfio-Split-migration-ops-from-main-device-ops/20220522-174959
> base:   https://github.com/awilliam/linux-vfio.git next
> config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20220522/202205222209.5JkbCwDa-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/f9fa522b20c805dbbb0907b0f90b2b7f1d260218
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Yishai-Hadas/vfio-Split-migration-ops-from-main-device-ops/20220522-174959
>          git checkout f9fa522b20c805dbbb0907b0f90b2b7f1d260218
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vfio_pci_open_device':
>>> drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1188:27: error: 'const struct vfio_device_ops' has no member named 'migration_set_state'
>      1188 |         if (core_vdev->ops->migration_set_state) {
>           |                           ^~
>     At top level:
>     drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1201:13: warning: 'hisi_acc_vfio_pci_close_device' defined but not used [-Wunused-function]
>      1201 | static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>           |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1138:13: warning: 'hisi_acc_vfio_pci_ioctl' defined but not used [-Wunused-function]
>      1138 | static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>           |             ^~~~~~~~~~~~~~~~~~~~~~~
>     drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1124:16: warning: 'hisi_acc_vfio_pci_read' defined but not used [-Wunused-function]
>      1124 | static ssize_t hisi_acc_vfio_pci_read(struct vfio_device *core_vdev,
>           |                ^~~~~~~~~~~~~~~~~~~~~~
>     drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1110:16: warning: 'hisi_acc_vfio_pci_write' defined but not used [-Wunused-function]
>      1110 | static ssize_t hisi_acc_vfio_pci_write(struct vfio_device *core_vdev,
>           |                ^~~~~~~~~~~~~~~~~~~~~~~
>     drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1086:12: warning: 'hisi_acc_vfio_pci_mmap' defined but not used [-Wunused-function]
>      1086 | static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
>           |            ^~~~~~~~~~~~~~~~~~~~~~
>
>
> vim +1188 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
>
> 6abdce51af1a21 Shameer Kolothum 2022-03-08  1176
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1177  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1178  {
> b0eed085903e77 Longfang Liu     2022-03-08  1179  	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
> b0eed085903e77 Longfang Liu     2022-03-08  1180  			struct hisi_acc_vf_core_device, core_device.vdev);
> b0eed085903e77 Longfang Liu     2022-03-08  1181  	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1182  	int ret;
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1183
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1184  	ret = vfio_pci_core_enable(vdev);
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1185  	if (ret)
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1186  		return ret;
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1187
> b0eed085903e77 Longfang Liu     2022-03-08 @1188  	if (core_vdev->ops->migration_set_state) {
> b0eed085903e77 Longfang Liu     2022-03-08  1189  		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
> b0eed085903e77 Longfang Liu     2022-03-08  1190  		if (ret) {
> b0eed085903e77 Longfang Liu     2022-03-08  1191  			vfio_pci_core_disable(vdev);
> b0eed085903e77 Longfang Liu     2022-03-08  1192  			return ret;
> b0eed085903e77 Longfang Liu     2022-03-08  1193  		}
> b0eed085903e77 Longfang Liu     2022-03-08  1194  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> b0eed085903e77 Longfang Liu     2022-03-08  1195  	}
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1196
> b0eed085903e77 Longfang Liu     2022-03-08  1197  	vfio_pci_core_finish_enable(vdev);
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1198  	return 0;
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1199  }
> ee3a5b2359e0e5 Shameer Kolothum 2022-03-08  1200
>

