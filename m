Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27CF3A2AA3
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 13:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFJLtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 07:49:52 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:59360
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230117AbhFJLtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 07:49:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWxBLm3hkS/FtYGXJOlq3v9YD+YXsxbQu2yFlKDGDsf6PI9K4vImTMGg7O0m1U5h36RMppfn0h6duh4v6lFkwccdSmL3JalD4+58BZH+7XW19QtJPiy0ZMzL6lgsu43OxEyTpeYFPVLBdxNoaq+c4VGSNJVpsPL3R6e+mGB4OYMTiHCnBqQGxuEVzjWotPoTfJ/TBHX+van5hVHubfzWHsA2cuxNrfj3s8+C9f+0owiLC8lxkVOqlS7dHpIpOK7ehFNBNjnkS9FMUmGlBOVhTCh8Q65oZkeRYB1OG3UFG7gdjyXeAwiefIIzXg40tHBD/cNEtyBvXsNj52fpm3iKgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcFNTVy8G63q5bzrF+zipcuBFltMQ5vgtmlB7b9r33Q=;
 b=II1Ht3fh4c41orGHdnDcB7nPm3kUsdiE7I9CmgZLtwAE9e8Lvvod0EgIzRbnmF8OkOCantmAXtjAVTudxuCyJGcVN7xq07MB/+PVgmr3fFuPxQXCQNqtLWKKNuibTLapAicvqCrDcOUSkNZ0BM6/ZBsSFqwfHi5KFyyP3D/m1ROtS5nWhc7ijQ6QD43agX/82LenFtucMs8Q4R0Lsn7m03JI/6RfRrR2GJ9IVA2Q5sGa0IRNFL9zbO1d4TQmsOwDHffsI74bVtHHEdrsbUDRW3hE17mQxwgmYfLB53Iwht2/ZpW0oxO+LlrXhWdj/pOrI3ClETXtTBz8WcCRehN3Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcFNTVy8G63q5bzrF+zipcuBFltMQ5vgtmlB7b9r33Q=;
 b=iX2i+UA3wMQ+3lIa+V7HI0GNja1TLUeMed3t3FYZ61DhUYItFZIq896kuN6QUfD7VG1RIZ0Jqcf87pPjkQW1pxCtLk6ROhZ/H9lDSqczo/d3j6Qh12XuM8oMRdW2zrHM/wxvg2hDjxmPcfflqRSGdf2uKvL2LsiHIGhNEXNRT2MbOD+tCaRcQqshIvtdoEsCk8FEVCVrbVqow/orKdhnBjfwlDcHxWrWslL80z0H3tAKnNWa8XjW+eP3s5uO5fyUb6yp2gbGeR1QFiXhNAr7GvM4owf78ALHfmq/qBL4LCCCy7JsSkQwjSL4A34h0d0N4R1q7mgFTqCAn2OZ15aRYw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 10 Jun
 2021 11:47:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Thu, 10 Jun 2021
 11:47:52 +0000
Date:   Thu, 10 Jun 2021 08:47:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210610114751.GK1002214@nvidia.com>
References: <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
 <c84787ec-9d8f-3198-e800-fe0dc8eb53c7@redhat.com>
 <20210608132039.GG1002214@nvidia.com>
 <f4d70f28-4bd6-5315-d7c7-0a509e4f1d1d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4d70f28-4bd6-5315-d7c7-0a509e4f1d1d@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR15CA0045.namprd15.prod.outlook.com
 (2603:10b6:208:237::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR15CA0045.namprd15.prod.outlook.com (2603:10b6:208:237::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 11:47:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lrJA7-0052MM-FQ; Thu, 10 Jun 2021 08:47:51 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 320ff649-ed44-41ce-72de-08d92c05943b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5223A2C70C7C74481FD9B7A7C2359@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: McUxgUMsQdlI6Mt4C+DIsm1i4layK4bPiArZxvXLzUjY4UJXXxXoq/vX+CruW5QWA48N4z0rFJC0vmikCK/ozohUrMgtMlOF5vKUyGrMW7zkuPwrcWvADWvB5nJj4pm0niqhIX26IGpZxcKdixhVcF9w/npvQVrvNgSV+Dg+2KRFi4jlkdYrkNIBSJRBmR8vO5ASyJUzlBmJtQa/xpnqt1GTyH0jXuU73LKebagm+xUuH66GzL8sGgbBes3mEYf81+3qolC6D9MF+l7UWw0ZmhccveV0yeRdjNe0VbqaFX3kMFKjx6uEq14UGaoH0Zsb38gAGWueCNnLsgnWqn6XtQFaf2WDkYBrdoFvTXSi/gogjvYqzRKwNACMQnC2/4eZjGpY4wL/DTb4hz95pwqPr2fX3mCG/lL+inhPRuGpdnnLxpbAZHwDJ2970kKjuKh6kXmdpe/CLZIArZjW+M4N7RbwyWQSJYAG7OX4wGgMSwW+ui+0qu1tnbQTM4UUGRfak7hQcM1EPnN1V2fkGpTKzp4RroC5k5ui1cLnC1ALF4gB3SbF7s6Ytc0UluTcBndKUfh6X15x4GW4rLolQF4MVqtIeXpbpD0EOmZgjNuxqYk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(426003)(8676002)(478600001)(1076003)(86362001)(7416002)(316002)(54906003)(8936002)(66556008)(5660300002)(66476007)(6916009)(186003)(66946007)(2906002)(26005)(33656002)(38100700002)(9786002)(36756003)(9746002)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkpsK2MxOTlZUGtlUEk2eERESlZzdm1KbXdOZXNYeUllZFVLWHc5K055TGNX?=
 =?utf-8?B?enhBV1I5a0JKT3Z0aE52U29ENno1cUpzZys1ajhUQmVkUm1hTHZiaFFIdXB3?=
 =?utf-8?B?OWxHR3paYWh3cGsrVzRndUw0MjZMTS9ZdDJDTGxMVmpNOUw1bi9YMnZKckVL?=
 =?utf-8?B?cGxjbi9wTXlOenNpMmNzdmNYMG1UVm9TUGlXRXJNZkxCYVAxbFF1NVNFNTFW?=
 =?utf-8?B?TS83TG9HK0o1Wi8yRGdKWmptRjNuTEU1NVo5RThVNTBrMWVBTmhkYzJVcFhE?=
 =?utf-8?B?RGUyTXBFN3Awci9lWlZLT2NCRUdUdDBueVdkT1ROTzFnWUFVWGVJa3JzOHVQ?=
 =?utf-8?B?Myt2U0Q5cTh0NVRUSjh5eWIrQTdmUDhKa1VxMFE3WDRLK2d4cFhwQm5tamFr?=
 =?utf-8?B?enFKbVlyWUtsSzVWenRpWVZ2eVdYMXE5VSsyU1NjbGdiTmtvQTZPV0tyKzhX?=
 =?utf-8?B?SGpSY1ZvcCtHeWh2T1JaMFFESEdTaU5iRnhTQmxEbjV1LzYxd2FyaW56SVFR?=
 =?utf-8?B?eEtnWWxEeTc3WjlWalBVMmdLRDIraFV5d21tOFBjS2NkSUhMbGtCMzFXcUU0?=
 =?utf-8?B?TmhzQWNtU0o2TzlUaTQ3Yld6MVZ4Vk1GS2pXTEtPTjRRMXVXUGFISkU3clNZ?=
 =?utf-8?B?WEp3TFlXKzdlUStTRkNZOTRxSkU1VTdSL0tiTnR4Yy9EZHEwZzVlZ3d5d2Vs?=
 =?utf-8?B?bWx5K1Eyd014YUF0QTRSbVZOczNMazkrdG5uVHBMZDVkYzFvazBESFFZUHl3?=
 =?utf-8?B?ZG1hZ3NZUUhUTnFKTzgwSTZjWE9iT0xEQm54WUFMMTZDUk9hMFVkZHlCQ2ts?=
 =?utf-8?B?bW5UNW9Gbm95QjJWOW54cldEcSs3QW13QjIxOFF4a0FRYjdRM0NpSG1LSytw?=
 =?utf-8?B?dlFYMGNrOFJnQjRnYTkxT3U0dXhNTWdCdUNqRVJKV0pjdVNMOFcyWkxaMDVu?=
 =?utf-8?B?cktBUmN4WENpYTdCTUZndFN2YjBlY21BdDNHWlplMnVxVXpkN0VpaFlwREhL?=
 =?utf-8?B?WE90YkQ4Z3Zzd1NwV1FtKzg3YWpnK21wRWpFR2pGdVFXRkVYQ3Z6cklwNXJV?=
 =?utf-8?B?R01UMTYwRjdKeGRjUDRDM1dPVklZZjhZVlFTN3RRcDlEWWlNbzB2Q25sV1hx?=
 =?utf-8?B?OGdYVm9mcy9aR3AydjVDcFlZbloyaTlqVUQ0Y24vamRjd29aeFpObmkxUVY4?=
 =?utf-8?B?dFczVTVQeDlucmlzN0sxU3NHZGlXWUNGVGJha0Ewa2tESktNSGVpK3N6ZEZ6?=
 =?utf-8?B?UktEektoaFo1eUxLVU5mVTY0cFEwUWo5RytNdUNxTG1naGxVQ2xib21sNW1n?=
 =?utf-8?B?U2FoOUgzcVhmNnFXRjVyazQyWDlVTSsxQWw0MWNlNC9ZUmQ3WHh1SGdJc2JV?=
 =?utf-8?B?ckRVeFE5R0o2cmY0TnAvR0lTZUdmaVlkYzhNa3dMZFhyUkgrOXJxdStXT1hF?=
 =?utf-8?B?MW15UGFaYlp4R3ljNjM0Z1M4VnRLV2tSOEMyOGpxM0Q4U25nMzBUVTJHc0NU?=
 =?utf-8?B?Z0g0RXpmTXNhZytsNitmcEg4bVZwQ2s5dE55ajJxVWRjMnJ6QWdTdGl0RHBF?=
 =?utf-8?B?R0NITzJpaWMwSlhseDBKQzlwWmZZM2NtbGN0OWZaT3krclc2MzFlcHpWUGNG?=
 =?utf-8?B?czBuM0o1UWVvbmNRT2pRcjJVWENJSEVtVUZlZTR2VUlZelFseUVHYmNUb1J0?=
 =?utf-8?B?R0crYzBTNGk4QVBZV1BRZFdDcHRwaDZLYWJidDJmSlN0ZlN6NTFpaFJUZnUv?=
 =?utf-8?Q?wTM2DrTXy8neoWA6/C+hEWOZLMKZ3XaIHiSBXdL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320ff649-ed44-41ce-72de-08d92c05943b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 11:47:52.4631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfg71pXjfJmazsSWgslkuLiqEDy6AFcAEclbM/PZp3d7OYl0feIIiBTojRgZiRCY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021 at 10:00:01AM +0800, Jason Wang wrote:
> 
> 在 2021/6/8 下午9:20, Jason Gunthorpe 写道:
> > On Tue, Jun 08, 2021 at 09:10:42AM +0800, Jason Wang wrote:
> > 
> > > Well, this sounds like a re-invention of io_uring which has already worked
> > > for multifds.
> > How so? io_uring is about sending work to the kernel, not getting
> > structued events back?
> 
> 
> Actually it can. Userspace can poll multiple fds via preparing multiple sqes
> with IORING_OP_ADD flag.

Poll is only a part of what is needed here, the main issue is
transfering the PRI events to userspace quickly.

> This means another ring and we need introduce ioctl() to add or remove
> ioasids from the poll. And it still need a kind of fallback like a list if
> the ring is full.

The max size of the ring should be determinable based on the PRI
concurrance of each device and the number of devices sharing the ring

In any event, I'm not entirely convinced eliding the PRI user/kernel
copy is the main issue here.. If we want this to be low latency I
think it ends up with some kernel driver component assisting the
vIOMMU emulation and avoiding the round trip to userspace

Jason
