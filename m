Return-Path: <kvm+bounces-3939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B29F780AB8A
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32E281F2134C
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501B346B9F;
	Fri,  8 Dec 2023 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N683CX5t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807CB10EB;
	Fri,  8 Dec 2023 10:02:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ae6yRQSEr/3LSOvgFFu/1tqgGL9OzL9cehVHi44qEvlP9Jl+hlCupnBV+LU6mBwWpjj6fYvSK/OnFdb8nQUoNNHDDR8/CdsZaCyAkH7cb/0EQD/IyYbHOqi5oM8m10A7mOvUB90Iz9wwbli5XR9Z1cWEkM+dEpOJALijCbleOlRKHCTLUXTCnaXExOCiVWddTtI/5aMf2rOCDmonsUA52t5gRCEVitqOKcUvqJUTwT+NioKi3ZTsi47l/DyH5gKTr6cX6EDLosAn1AnjHaSSqc6AHksfj2ZOg/8qx18t4I4r6jHrufMcM3+QRZRzHXbQ3wFSPc+bEYqMI+lDuCJTrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jAclD6xjTtRh5V9kUqs+VW64cGIEs2gGRgOeEJKwgcs=;
 b=KVFSKtdIHzjTskYcdGgE8GfeVzBBCPPfRYwjjLxapHQ++Vj/TgWny8mptRDxBB3amXgEA+XWt306c7LfZTDMunANQZtyuVAwUeTGN/vwZgJYg85g80w3e7RJWm8YTkGN663VN0Y9devuTcq7cuZ64wA5PAikjljJjsrQveR3Q/AJzsf+rlLXcWj5hUwyCEjcM2s7sZGWx/IZHvox8WSxx1J6/HAhdushncMtsgFLuADBn/lKSWoY3evymKAlesuO35xPhi0kSZUl2V7WOlMd98ofNRU5ryH4ulB9IeZ2dZNziX6u77x24nXQUb3Nhw+PIkosuz92OiXI3J1wBpLSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAclD6xjTtRh5V9kUqs+VW64cGIEs2gGRgOeEJKwgcs=;
 b=N683CX5tRkEaeCARe/2aSXFs3BvSVsMwUU7Tn+0Cxw8wRU+HKrkkN1dBOjgBe7XPKx5GIpznKNfG51IiQXLaUa3yZq8JzicOMoIZ1vJG1CboWnjvA47IdD4ogzD9crF6jawT3Al9aFFBARnyYlQAhQ3h3P9InMRT/75Bm0pi4iYhjrzv7H+/w6HZM5gSfkDe908iR2bMLKhtWa8vsPGbJ0QrDARVvCh1TVl+bM/AvlrvUc+xXC5+LxiDi0Oh/SZWrvZUNK/pmZwF3v+Gd8L/dD+eHoq+6HWmKT9njXONqQYD2DD83ug8r08xltFQMUoUCmfk131An2uwypwX/kDOyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5184.namprd12.prod.outlook.com (2603:10b6:5:397::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 18:01:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.038; Fri, 8 Dec 2023
 18:01:58 +0000
Date: Fri, 8 Dec 2023 14:01:57 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jim Harris <jim.harris@samsung.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Message-ID: <20231208180157.GR2692119@nvidia.com>
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
 <ZXJI5+f8bUelVXqu@ubuntu>
 <20231207162148.2631fa58.alex.williamson@redhat.com>
 <20231207234810.GN2692119@nvidia.com>
 <ZXNUqoLgKLZLDluH@bgt-140510-bm01.eng.stellus.in>
 <20231208174109.GQ2692119@nvidia.com>
 <ZXNZdXgw0xwGtn4g@bgt-140510-bm01.eng.stellus.in>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXNZdXgw0xwGtn4g@bgt-140510-bm01.eng.stellus.in>
X-ClientProxiedBy: MN2PR15CA0065.namprd15.prod.outlook.com
 (2603:10b6:208:237::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 177c4c85-5c35-4eeb-1c54-08dbf817c54d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d58ndK/unpGZrTbvHbO26u2TmmhlbfixZvNEeQ6uZYqSqszH98CvKsALs/WVnFgmeGskWtUuW6cZ4a6ZRl7dCVrQph+C/4qJNKfic7OHRuK9oOGNU6py8QOdARGVeFL2ZOsWtLxvXwiAg1WqzUM1oPukWF8bOL39m0jtw5KEQF+viMtiEaMrq26RBmr8DaXkl28SG30/fR7xquAN2WnV9AXI+QjTsSg14PHhWN1MkC6pcuAquQUkIB7SBbHnzj4ga4F0MiE90aw+H2U++QnHSvmZXX9+CWrAvZSpHC0HG9JfVLG8oT2CMO5PJMGJz6XKSA4jYFzmk4FzYRTH2pjSUqnioz5tphvuqq8tdlbn6SvJCrBbg7sWM3zBbt0xgaFtY7xX/2TDBEkFjsVd6uRnERLJPoYpjSkODSArUzsX5M8leIKu7HX5ZEP17sjdoDtgHz9ORVbT2ajvG31bkpLt21RvrHfxbywUbDA0551JbE5TGb7ab7JNPzMz/lhvVUwA4tWKmYiuMnHEbiXP0A7LG1iLAgiUN+6ymAHFLKMYtpcRVLjdGN0ZT5I8EBfc1Vpr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(39860400002)(366004)(346002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(6506007)(26005)(6512007)(2616005)(107886003)(1076003)(83380400001)(41300700001)(4326008)(8676002)(8936002)(2906002)(5660300002)(478600001)(6916009)(66476007)(66946007)(66556008)(316002)(54906003)(6486002)(38100700002)(33656002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5GfI44ASdVTDbtZsmRAcIC/EncZ8K+SkPy5SJpyPAyGXiQYjv8Joy0HUBw/u?=
 =?us-ascii?Q?L1/8Ff7vJ1tEk7ggO4DG/yeL6sQAs3aLcNrPMqI0bielDRVAU9DeooD5m6qp?=
 =?us-ascii?Q?fi+fLNtmS1kWpPhNKp3xvB+sCQl777BiKREsYNzXLX5FcrixD4ms0EMgmOe2?=
 =?us-ascii?Q?QKqMvtbuR/uMFN16c0qApCIrrcAzUHk2NXXo0gHSqlAORoQRV69mGWRmp5Zx?=
 =?us-ascii?Q?+Tevr62z0LbOwgOyULlTJ82EPUnSRYBNKa0Mq02vzw9LkSGcSbb98d9NqbZS?=
 =?us-ascii?Q?YaxS38d+fNDbU9gPmkEXPzEdXvHg4QaWC58HhG4O2fqN9hCZeSAcSkNuvXsF?=
 =?us-ascii?Q?EuMY0CUMaSBmKRt7snvG/Ebs9eR5nzwwRIplwcbkWPLFlthfrCfZ0yEKisYG?=
 =?us-ascii?Q?dkTBlBkg9Khp4hF4Croc7fB1+yizmY4MXCKq/QBaEonMfdJ1HWdD/O2DaJ0L?=
 =?us-ascii?Q?UYadOZoSRVh0MKV9ZsHSRk04Vh4MRotJBLqaQ9iYOnA9oBkO1+wFBl5yw/9F?=
 =?us-ascii?Q?iIPxM+pC7QZaT1P8aDh6/7xgOOtezYFfxFCcMIj/Bxk6M2q4Ndtg41vIZ4Wr?=
 =?us-ascii?Q?ZdoTt26tH2s8gFnZKAJKxKt0y4jLm2QsXP9QBq0AAKcCf2cmqTuF75aqeXEC?=
 =?us-ascii?Q?4MZfjdEBXFSRRL+IRP/AWhK+8bWrY2xu8zZjPZWTgJzD/pDxxBDvlPnoe8ql?=
 =?us-ascii?Q?exVZUqtFiBuUmBWIbpeN2Jw9414sqZBzY1eygoiUPUoAUpHKjmHN+79RfsFP?=
 =?us-ascii?Q?xhuSKIVFpo6jb0v1B2QFUnE4aWqWs9fOKkBEvtwuNF84ZIAoPrmenqQFFbsv?=
 =?us-ascii?Q?O/580KzAiz+3rMRcOmzntoSroU/SFXNH89hzTzV2BUMdiy3FJDhfmbIRZQxg?=
 =?us-ascii?Q?TQ041sYBVjsvKBGCXpmOAboA9uQGIQculiW6SaWaVfz1Ka9wf99sxJQMQ4hd?=
 =?us-ascii?Q?hJUPAgYDxhmVRvqWOoEWcpO9qygegCuS9uVYYnveD3s+UvdLlah4y0r9fqmA?=
 =?us-ascii?Q?P0q5CO33VQP7LRcDFg7d9fAfpUMNAMbWB9dynVSyHqNjMdejx2/jgp3qoSY+?=
 =?us-ascii?Q?QC73fi9OC14Jw/jYouUKEjiX/W9wLjbu4SNboSQRBs8Vb+a0Xd712UhyBQHD?=
 =?us-ascii?Q?ZIMuuaa61ALabp+UfJWqCgvDqVsywkF11r5FWrJV+S4JHXSwvQBUSbdeF6S5?=
 =?us-ascii?Q?TS+PmzFHRg/2DDW8ndexqxtfEpQau3oSHANecnW+5dlpv9n9hE10mXOGoFkh?=
 =?us-ascii?Q?jiJFwj0IQxoP08HMqwFj0dekMS4XnbbM8L2haJbYN8q+3PyeGDiMqZB53xzk?=
 =?us-ascii?Q?x2dFHVAoj/GFTpIuOvkUlAcn8o0lKOoy8XeNxRnUyr1EH3lfngjPE5GYhPul?=
 =?us-ascii?Q?rVJVBkhkRSuOy7sK5CEnJCRYy3MLj7Arj5VgHtgeMQp3UpEH58gnSThg36+m?=
 =?us-ascii?Q?Btw/tiasvCqXsU31PuNFp18OGf3UIIm6SN5D+FfvbJMp0ZwmRJ45ZrCAe1js?=
 =?us-ascii?Q?fte+nmLnHVHqIt+tRZPEAcepbwbkb/DJxJNMvSw0qMm00EyuLpp0loH/9VB0?=
 =?us-ascii?Q?o3gSqViOncO5osBq62EMvIpxfkZvM5ApVpIMIXO9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 177c4c85-5c35-4eeb-1c54-08dbf817c54d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 18:01:58.2872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n2Lq43o9U1C+f3NdwDImiUN8ZmoeqFRN6gCgSpzmCZ/PeRKWADVX9XOGVb6VfroE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5184

On Fri, Dec 08, 2023 at 05:59:17PM +0000, Jim Harris wrote:
> On Fri, Dec 08, 2023 at 01:41:09PM -0400, Jason Gunthorpe wrote:
> > On Fri, Dec 08, 2023 at 05:38:51PM +0000, Jim Harris wrote:
> > > On Thu, Dec 07, 2023 at 07:48:10PM -0400, Jason Gunthorpe wrote:
> > > > 
> > > > The mechanism of waiting in remove for userspace is inherently flawed,
> > > > it can never work fully correctly. :( I've hit this many times.
> > > > 
> > > > Upon remove VFIO should immediately remove itself and leave behind a
> > > > non-functional file descriptor. Userspace should catch up eventually
> > > > and see it is toast.
> > > 
> > > One nice aspect of the current design is that vfio will leave the BARs
> > > mapped until userspace releases the vfio handle. It avoids some rather
> > > nasty hacks for handling SIGBUS errors in the fast path (i.e. writing
> > > NVMe doorbells) where we cannot try to check for device removal on
> > > every MMIO write. Would your proposal immediately yank the BARs, without
> > > waiting for userspace to respond? This is mostly for my curiosity - SPDK
> > > already has these hacks implemented, so I don't think it would be
> > > affected by this kind of change in behavior.
> > 
> > What we did in RDMA was map a dummy page to the BARs so the sigbus was
> > avoided. But in that case RDMA knows the BAR memory is used only for
> > doorbell write so this is a reasonable thing to do.
> 
> Yeah, this is exactly what SPDK (and DPDK) does today.

To be clear, I mean we did it in the kernel.

When the device driver is removed we zap all the VMAs and install a
fault handler that installs the dummy page instead of SIGBUS

The application doesn't do anything, and this is how SPDK already will
be supporting device hot unplug of the RDMA drivers.

Jason

