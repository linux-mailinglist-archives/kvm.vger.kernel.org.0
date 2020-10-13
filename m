Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9543728D0FB
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 17:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgJMPHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 11:07:47 -0400
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:62945
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbgJMPHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 11:07:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B557FQO8/8wrXN1yrm/Z33kN4r9Evk5UWqf28lluHGKoYOQKKVieMpxjDmqOJ8pW/sD07wXFgkhdYiRjo4W3N082g0F0ZJ1v1WsaPyt8q51btBwk7vTPi2nYZbKL2KAaHYq3+m3rk2nwkVSrOHiaJd33IEl9w9dFBmTV+qpC6NLXHLoSvz6ATWYzPBe7HOXmhzO9PbRSPMnJ/Tm6wHNVxURTsN4uw0Uf82gSZg6UkSWgVDsR+fXtq5UdXFvSOOVEnNvHGqSOJmZsvCPFOhXJ6nfs8aXH4sSDGfOOgbJX3CBu+n89Y2bhb8sGXJtBhyWAW2pLQzbSxC4hvzq4IVPYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHIDLBO5MIuVRhA64iJX/gqB2ki+4GG4C8cYHIWkuGI=;
 b=K/xAQJLPG3a+FGNhk2Q+QipuFyq803ecfs8dCloHGSgHcumdcP0R++i8F+42BY6WAKrYK2E71+pAPKr3mXmVnGCFeh1UDoKKCDwM0y+Mddnb/Xs3NsVT1XIHY+SMRq8F074MTC4ObyyYSJ4VtF7KjNcH+zx4uLJePJBhVKbaMeWW6leDW1lVqZ37f9y1P8RayUCNtv09Ox5wj2tBWXaDMMT0e40zUb3g0cs3GC9SJxMvAraVYjpFyaz3jew+ZgescrmCoQx5XrgWp1s+kei3qZDwolmWRo2JLrk7wxB/6vyX+9a0o+I1Ee+tr9c+PTb7yPLkxTh3q4QRIGfGxF4LZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHIDLBO5MIuVRhA64iJX/gqB2ki+4GG4C8cYHIWkuGI=;
 b=df1v7LDOlZPKjhoAV0laxAMnFCT2uAdLVxDen4ZNbkJS996vbbCyWWMmhInS9ymNjXyCCXnMzGCt+n1VSzNqaZqoKUohOHcgZecsW7VCrv6vDgOFzu0QtRt3S7wNtn7jL6fn/gVnrym+9SO9NbPZJT/31HPE8CnILE5Gf+Y6q0g=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR0402MB3950.eurprd04.prod.outlook.com
 (2603:10a6:803:24::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 13 Oct
 2020 15:07:43 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f%11]) with mapi id 15.20.3455.030; Tue, 13 Oct
 2020 15:07:43 +0000
Subject: Re: [vfio:next 19/27] drivers/vfio/fsl-mc/vfio_fsl_mc.c:189:36:
 error: 'FSL_MC_REGION_CACHEABLE' undeclared
To:     Alex Williamson <alex.williamson@redhat.com>,
        kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>
References: <202010130507.H3A1OKjq-lkp@intel.com>
 <20201012162157.532edd5f@w520.home>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <5d644323-9580-c39e-0a06-347ba91e97cf@oss.nxp.com>
Date:   Tue, 13 Oct 2020 18:07:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
In-Reply-To: <20201012162157.532edd5f@w520.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.27.189.94]
X-ClientProxiedBy: AM3PR07CA0081.eurprd07.prod.outlook.com
 (2603:10a6:207:6::15) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM3PR07CA0081.eurprd07.prod.outlook.com (2603:10a6:207:6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11 via Frontend Transport; Tue, 13 Oct 2020 15:07:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80291fb5-2e75-4427-c761-08d86f89bbed
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3950:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3950BDFC80F4D3026BA52D28BE040@VI1PR0402MB3950.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: myn/nmtG4lCU/Y1Kgbp9IVir5umJkNxaaXu/UssjpMjnrXEjUhNzZEYJ08oDidz6EoppWo7tOFgA7lF94m3z+qoeLXtW6CcCJfS14+peiL6TIkzoa8JeIZZesu1axCxdsoAS/puIAtyL7vMDlVs4SK90KW6uF7GWt+u5Qmf7ma5ERl0hCRD/9RqUN5HJmHwCmr+HWiP7c6wFhGDV4KPKycN1aJCU2yUdbMpAkmfQ9OgPQZ6BXBuNyD09kcJy0RhUOssucVdz9Indtvs9c56yDiXLNK6yGyeRookWWQmSaAgAj9dx1ubDcCcVihbFQJw3w2emJlA3Za8dzpprK+cJlvaB8YPw0sRQU7cBtIUJphOH95W7XfurIW6yCADrzSG2lMLMSmL8JTuGI/29Aw+nIoTmUZWh56BhVoaFVc/Ho1XT9FpQ/5pG7sFQqBeWZZgUTkUfReER+56mW2jo6KikFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(396003)(136003)(376002)(31686004)(966005)(316002)(186003)(2906002)(478600001)(26005)(66476007)(31696002)(16576012)(54906003)(110136005)(66946007)(86362001)(66556008)(52116002)(83380400001)(83080400001)(8676002)(6666004)(956004)(2616005)(16526019)(8936002)(53546011)(6486002)(4326008)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p+jPAKbOrtB5p3q3NbmO6dc3wF9qK9don77HZ0Ofgap6oWpbVHZ9vFWVlRHWa5s7Y72t3W/Day0cOM87QxJ8Yjs33i4laq4MWy5f8HKEwR3VB/wRr3GMCJa68spsQElW/e7t0ssObxV/d++WuCZr5q4QImWaP3dUUNOpyr8aKY/DPG6dsmVm34FMotHA/SKh3Mg48bzrkKgdmHHcSBRLrpMdk8mn9OSThvN6aqG/TAWL0xjha7mDET4lYcSshfpc13bthDftwTXPp3IoEcWkCLlGEYgZKgqsZt0E7fL23BGMUTo3gYdeoOw5CPDn74rAJN6/t7d14Vpt5iDRw35JL0Fz1Np+vKRTJE28BaPgjlb82NsSlkRzqBhu7BV+evlnT6NCceUhuVb09sLs1XyA/6RB2Yv73D5vjfAH5n7Nev5QmDQLxzwRlialfLzYrk3JPeX2gIevnSEoBAbvsr22r4Xc3iJd7w+UIfhSsHPtllTpPMD758/Kt14iqOwkf7pvPX+kBOC411blFeDQSv9BQPe/UPjp+s0miGSlhnIiqwzkW812aPOonm8yGVkT8B9qyzvrX8epfu/npuOO2mRIQ85AL9f+c6IsyGBndAr4jzPJqlnBagnpF1SeeNZC3kGP17Um5HvYtMP9dPslkJYdzA==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80291fb5-2e75-4427-c761-08d86f89bbed
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 15:07:42.9739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 22RgFp3o+Pae1wQG/6Zw44x03cnimvjLmy3/dvRiFS6olvTqxmBF9gfmUdKg/tJ/wNnZjpTbVEO45239Ls3Hmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3950
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I was surprised as well that vfio_fsl_mc is compiled on X86, but it 
seems that at the time when the FSL_MC_BUS was upstreamed it was a 
request to have it compilable on multiple platforms (just not to brake 
builds).

The errors bellow are caused by the missing FSL_MC_BUS patches, however 
I have tried myself to compile the i386 build and I did encounter an 
issue with 32 bit platforms. I have sent a fix for it.

Diana


On 10/13/2020 1:21 AM, Alex Williamson wrote:
> 
> While I'm a little surprise to see an i386 build pulling in
> vfio_fsl_mc, I see that CONFIG_FSL_MC_BUS does enable compile testing
> on various other archs.  I assume therefore that this is just the lack
> of the necessary fsl-bus series to enable the vfio_fsl_mc driver.
> Both should be present in the next linux-next tree and I'm aware to
> send my pull request after GregKH's to get the ordering of these
> correct in mainline.  Please let me know if there are any other
> concerns from anyone.  Thanks,
> 
> Alex
> 
> 
> On Tue, 13 Oct 2020 05:59:09 +0800
> kernel test robot <lkp@intel.com> wrote:
> 
>> tree:   https://github.com/awilliam/linux-vfio.git next
>> head:   2099363255f123f6c9abcfa8531bbec65a8f1820
>> commit: 67247289688d49a610a956c23c4ff032f0281845 [19/27] vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions
>> config: i386-allyesconfig (attached as .config)
>> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
>> reproduce (this is a W=1 build):
>>          # https://github.com/awilliam/linux-vfio/commit/67247289688d49a610a956c23c4ff032f0281845
>>          git remote add vfio https://github.com/awilliam/linux-vfio.git
>>          git fetch --no-tags vfio next
>>          git checkout 67247289688d49a610a956c23c4ff032f0281845
>>          # save the attached .config to linux build tree
>>          make W=1 ARCH=i386
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c: In function 'vfio_fsl_mc_mmap_mmio':
>>>> drivers/vfio/fsl-mc/vfio_fsl_mc.c:189:36: error: 'FSL_MC_REGION_CACHEABLE' undeclared (first use in this function)
>>       189 |  region_cacheable = (region.type & FSL_MC_REGION_CACHEABLE) &&
>>           |                                    ^~~~~~~~~~~~~~~~~~~~~~~
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c:189:36: note: each undeclared identifier is reported only once for each function it appears in
>>>> drivers/vfio/fsl-mc/vfio_fsl_mc.c:190:22: error: 'FSL_MC_REGION_SHAREABLE' undeclared (first use in this function)
>>       190 |       (region.type & FSL_MC_REGION_SHAREABLE);
>>           |                      ^~~~~~~~~~~~~~~~~~~~~~~
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c: In function 'vfio_fsl_mc_bus_notifier':
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c:256:9: error: 'struct fsl_mc_device' has no member named 'driver_override'
>>       256 |   mc_dev->driver_override = kasprintf(GFP_KERNEL, "%s",
>>           |         ^~
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c:258:14: error: 'struct fsl_mc_device' has no member named 'driver_override'
>>       258 |   if (!mc_dev->driver_override)
>>           |              ^~
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c: In function 'vfio_fsl_mc_init_device':
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c:295:8: error: implicit declaration of function 'dprc_setup' [-Werror=implicit-function-declaration]
>>       295 |  ret = dprc_setup(mc_dev);
>>           |        ^~~~~~~~~~
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c:301:8: error: implicit declaration of function 'dprc_scan_container' [-Werror=implicit-function-declaration]
>>       301 |  ret = dprc_scan_container(mc_dev, false);
>>           |        ^~~~~~~~~~~~~~~~~~~
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c:310:2: error: implicit declaration of function 'dprc_remove_devices' [-Werror=implicit-function-declaration]
>>       310 |  dprc_remove_devices(mc_dev, NULL, 0);
>>           |  ^~~~~~~~~~~~~~~~~~~
>>     drivers/vfio/fsl-mc/vfio_fsl_mc.c:311:2: error: implicit declaration of function 'dprc_cleanup' [-Werror=implicit-function-declaration]
>>       311 |  dprc_cleanup(mc_dev);
>>           |  ^~~~~~~~~~~~
>>     cc1: some warnings being treated as errors
>>
>> vim +/FSL_MC_REGION_CACHEABLE +189 drivers/vfio/fsl-mc/vfio_fsl_mc.c
>>
>>     174	
>>     175	static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
>>     176					 struct vm_area_struct *vma)
>>     177	{
>>     178		u64 size = vma->vm_end - vma->vm_start;
>>     179		u64 pgoff, base;
>>     180		u8 region_cacheable;
>>     181	
>>     182		pgoff = vma->vm_pgoff &
>>     183			((1U << (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>>     184		base = pgoff << PAGE_SHIFT;
>>     185	
>>     186		if (region.size < PAGE_SIZE || base + size > region.size)
>>     187			return -EINVAL;
>>     188	
>>   > 189		region_cacheable = (region.type & FSL_MC_REGION_CACHEABLE) &&
>>   > 190				   (region.type & FSL_MC_REGION_SHAREABLE);
>>     191		if (!region_cacheable)
>>     192			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>>     193	
>>     194		vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
>>     195	
>>     196		return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>>     197				       size, vma->vm_page_prot);
>>     198	}
>>     199	
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

