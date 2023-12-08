Return-Path: <kvm+bounces-3937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08A2E80AB03
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:41:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0AC01F21330
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB123B790;
	Fri,  8 Dec 2023 17:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IoxQvypF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76C593;
	Fri,  8 Dec 2023 09:41:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyHSsxxOji/KqUPG7/0+QWCrzv6WlYZmCTypf4t4i62xQOfh76wFFS9SjSgUVqLB6P3JvJpLaemL8JdY68fhK8+tIPxEPJUb8jCRXCVqTRgtNcF4VAPCrLdRz+8MntuLiMmFVWqBtDgnYtQdJkQa34yJCghR0ZjanDXyLRZ7oLpg0ndLrecmFveJMCmhHy19cZsGjw1UsxiwQQNTZBEZq4pT2O2SDG+bZQ5diJksFjsD4KRfO2aDx26PonsPDMsFj9vbWpl2wf11Uv4vV76kfr3Uqr+OLnSP7dk3nP04EnVggom11sPbwNfyKusut3gUayfUmZx+JfRQBxfKTwziOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynR3Axx4rdky0/WysfQRBlEzEVOpeEkfr1HuPGbA4Lo=;
 b=TkEqy8v3KUof3J6GxJK9S+D7ES9Z1IuwoNNv5lmeayplnL41ZUddPVXZboXAZ1v6VhERNju4iy/70v1IiNkcDE6lzCrrQ0Ydbz3RV1XE9UlvhlnS3K8up2hQwx5FvzEk7aczaelIGowOzQrNE6MyMbxbJcIjh2fSF36Mxb8r8AUkF1BOxQnz82tUByTzpyW6BapNMlM3sxxGj+dSGpMXJz7t2bpY/q5yv9fkXVsibyvp1V2hYII6asz10tI/2mLK+UzbUqNKYpIq27drqf1l5wZ5dklAZZbECEd1+jDMMGPBqpfjDroTg7c2mnyMJMZL8+K2MjV5U9/d8cT8zf1ePA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynR3Axx4rdky0/WysfQRBlEzEVOpeEkfr1HuPGbA4Lo=;
 b=IoxQvypFhdFRxty0zwhkPlCmeyn6lEzP0Kpo96UXz/D8gwMS4pYhFHrM/Jcy3OznjfHNKg7gCxACrkJUEbSCqs/ubX3idtT7XTJBI8wTNumWzUSMUAWU7sb/Z5i90AYqm6lnfh0LdixV11XAtTAWm8wHvBHlj/vHfhNmCq+bRjEbVeLH0uI1Wyl6OSg52bZ7owAYlL2kZEgdH3uUOJSC7Ya1tYDnpjpPEJOathM3KAj0uTz4HeRxWCkNZgSPkhwQ/lf5qAmUJxT64FAC5T3T1/IvrEP5Z2GfNBkjCCWNy1kXtWKH/S2iFihig1AAwhnPqYhbvyDthWnny/a/D5k0gA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4933.namprd12.prod.outlook.com (2603:10b6:a03:1d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Fri, 8 Dec
 2023 17:41:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.038; Fri, 8 Dec 2023
 17:41:12 +0000
Date: Fri, 8 Dec 2023 13:41:09 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jim Harris <jim.harris@samsung.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Message-ID: <20231208174109.GQ2692119@nvidia.com>
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
 <ZXJI5+f8bUelVXqu@ubuntu>
 <20231207162148.2631fa58.alex.williamson@redhat.com>
 <20231207234810.GN2692119@nvidia.com>
 <ZXNUqoLgKLZLDluH@bgt-140510-bm01.eng.stellus.in>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXNUqoLgKLZLDluH@bgt-140510-bm01.eng.stellus.in>
X-ClientProxiedBy: BL1PR13CA0394.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4933:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f581f73-f94f-4625-ed7a-08dbf814dda4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TSbNOjWYYWd1+YA2Y7EizFTJ2w3MfiXU6qR+tUN88qYjfS7mX229kL5fsB9i41rY+Z+BQdXWksd99Wp1lot5EzihhDRrA3nVNbFYkMtJdB8RgMo5nI+cWCFbi7o+oAu3EMkXf/Y3PkhdJlW2pZJ/fyklqPpczV5oBfxXt5lBEtnVOuzRUWe3VA98wku9GVetkuFjQ+/VLgaGn2kPpYotlBqyY6N8Q1dAStE39VaZr9R/H8PzT7VHvjSQIL3ENvN3fFBMn5T6nSiBfSvehZ1RXics3FmcVYevDI6KCczh3vc9VRqzzXsLxiskOWaPE3uRJh3iqtwehSCPZ5EGh72MX+CNTMMOwGodJMSHrTs3oKNYEtXEajwe9s2nq4+DkE1ID1LfhJY6WoHLZ3cQBKYEIsLJa/+ViYFHJjlIXtHt1O/tOjD4ZQEdkw34YMWaVA6J9zz1Mylx/df47kOp5MCQIkuAJ76bz41fqV/NbIYTpC6TU983CNTfvcClWCBT7YThdOGkIbTr2lKYX+0Ujtfa7u+jLLFIXmfWWUMxJdOr/YxBK6U3FsRFAr8d5C3l0H3o
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(376002)(396003)(39860400002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(26005)(107886003)(6666004)(1076003)(6506007)(2616005)(38100700002)(83380400001)(41300700001)(6512007)(66946007)(54906003)(66556008)(316002)(66476007)(6486002)(6916009)(478600001)(86362001)(2906002)(5660300002)(4326008)(8936002)(8676002)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K5rS01EooY5a26OgW02sPfKxtIsCVG70HGwPrBGYhcPAWUZh0fBLoHPMoeEr?=
 =?us-ascii?Q?R6p+OhcnNB+iO55dvUWGD4byBlAqvuFoUqgGsQZnq4NFaBjkl+ORZp0BYg/V?=
 =?us-ascii?Q?0zWQNoDr0aV29oUKq/KFP0zv+ZPTTmBgq2YespVHkwBxFfK1ZYEufkFxOIRv?=
 =?us-ascii?Q?yXJBB7tiFtCsGlfLDf+vMrj//PnXtowQ9tIsNVixFvO63XX4bfQJ91qUYiCb?=
 =?us-ascii?Q?S8V+jEfxvmmiaZjswwudZMk7Q82Lwr/X9JfirpjbsnV7TNfjgobx3K4o9kkB?=
 =?us-ascii?Q?hPPHRKdqW1pdsaNwOuyXl6HTlbpO2lfrBSfEmeAjUBGzZgFWNFwj2UvbvAHl?=
 =?us-ascii?Q?tl1Q7NtVjX0qaFupcyNfVjP27BWKCv/oyp1jxy99yZC+VsO8n5CDLOaJoEV0?=
 =?us-ascii?Q?Xuxl+lcKEYBfhyW6F/zQ5nJRfZ/zK/R5CyrY/4u3+SdFlYmfLK+9YiUK5vBQ?=
 =?us-ascii?Q?+RPAb2I5toOGHBiRnAeumnIbH8yZW8BqW379uK0jQE0nFITMQkLa2L9hkhFO?=
 =?us-ascii?Q?v3Fe2SMXLxneyTmJk6DgT3dFyUguQ9BNL7FkGkV3TMLNg4CfbxXJ92KVsRb9?=
 =?us-ascii?Q?ONGIr3xH9MK7luW7BtQn0EnOhOpdPHft+sGd4hrWNUpdxewO71GdUlj8wR+M?=
 =?us-ascii?Q?8bU37Xp5jprZRYY+OEztZLbj44qgmysHvrpS0iXN7Eazc2q2545A8+AwLLtu?=
 =?us-ascii?Q?6tUOoeIL7La8JCeJ2R5ck1xKhBrsq1VOSvcHwn8Ojegi/+Qlb6LG/o1AcIyT?=
 =?us-ascii?Q?8gcqN28H1Q+R6/54ad699I90qerWvSmvJe0R7Z4QTP1acBMPvTWrTBkfAI62?=
 =?us-ascii?Q?0vnJOQeFBchveRv3jN6gwEBPpXxhB6nvex1bsUScO0plLqwqObbGxmESVYmx?=
 =?us-ascii?Q?F0RY5sA0Q4xRF91ECxIBgpJDl6sysjblw5uY8cCJLrdwm9BTbsRitTPLJZcr?=
 =?us-ascii?Q?iK64PX0zXGid+AeIocNv1weMVyeAP0RqNV24cficJAXqMKjsWTcF1qfeBGE1?=
 =?us-ascii?Q?mvpvoOJ0yYrLwSWP3QoQ+leKGytEeuIEfiQWoHW/ZipvwQyJoqEAdonwugL4?=
 =?us-ascii?Q?YCK17r07QlhX88xfW8xCQ0fyKFr8sQqxk3HH0pZgaRZee5/XsTzQZEcsyeTL?=
 =?us-ascii?Q?K+E0Tagyix9GRr66ZAUxOrcpxjwgUikwQbJ/ngUCtEnzgJ5jpogGB9WYEi1W?=
 =?us-ascii?Q?MOEtpwC+EdB8FG/31dD0/Wh4QyCikUiLCqCgYKVHFw7R6Ly7XJhTU+D07WZ0?=
 =?us-ascii?Q?6ifSK6IW5jAVxVguwQCy7YgOOXLunSIY5Ak40T7TyX7RroS5OI3snLU8TCNR?=
 =?us-ascii?Q?xojALyh7tXRVjNIao7XfTBXthUHMlmD41DDoik6vbC0dc/ThouM7Nb0bDmNm?=
 =?us-ascii?Q?7AiQdYcYy1BMl6JfSmnLO69CvqAh/h43GQLx43ANN/4N7ahayNTlx9GUsuvf?=
 =?us-ascii?Q?lKersdIePxMXFOH/J0RBJxkr/ODz1raYUgGMoq8GMjen5cKqT03PK7NdvJIU?=
 =?us-ascii?Q?hCkXP63TFFKh2CXJGYvlZAVm18XFdGNtJFQ+XNLnJvlIkFsQ7LUx1BvxeTph?=
 =?us-ascii?Q?4T9sdZ+hDNqGF1q7/Tt+PKrpK2g7HRvKRJlH5QA5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f581f73-f94f-4625-ed7a-08dbf814dda4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 17:41:10.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eErKAf8wUnuq/N8wdKz3oPjmqGacDJErz5IIJ99Tv5FynbLxD3buAbu49GxN7QXQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4933

On Fri, Dec 08, 2023 at 05:38:51PM +0000, Jim Harris wrote:
> On Thu, Dec 07, 2023 at 07:48:10PM -0400, Jason Gunthorpe wrote:
> > 
> > The mechanism of waiting in remove for userspace is inherently flawed,
> > it can never work fully correctly. :( I've hit this many times.
> > 
> > Upon remove VFIO should immediately remove itself and leave behind a
> > non-functional file descriptor. Userspace should catch up eventually
> > and see it is toast.
> 
> One nice aspect of the current design is that vfio will leave the BARs
> mapped until userspace releases the vfio handle. It avoids some rather
> nasty hacks for handling SIGBUS errors in the fast path (i.e. writing
> NVMe doorbells) where we cannot try to check for device removal on
> every MMIO write. Would your proposal immediately yank the BARs, without
> waiting for userspace to respond? This is mostly for my curiosity - SPDK
> already has these hacks implemented, so I don't think it would be
> affected by this kind of change in behavior.

What we did in RDMA was map a dummy page to the BARs so the sigbus was
avoided. But in that case RDMA knows the BAR memory is used only for
doorbell write so this is a reasonable thing to do.

Jason


