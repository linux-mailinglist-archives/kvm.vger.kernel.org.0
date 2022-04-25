Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C808E50E1FD
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 15:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiDYNjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 09:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242129AbiDYNjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 09:39:16 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2069.outbound.protection.outlook.com [40.107.101.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6E3DECA
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 06:36:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4XMmCtq91nFI1abZWXvMmlGtN0GJexbz72t2a4DDIqescEDjcD0Yf/adL82YkdyVHdyXrKh5lB5kVGmR0XAjJ8vw6pm9hLNC1zunztmZjqP6QJC1qkZTNP66lrHZGSEP9ApXaXNor2qm1sThf49enSFdFJsK1LfSAPJ9q/rsT278IK6OqRat2ZWQSwGOVA4+6Af0wveFHhkMuEw5Tms0GgpSl/zPmlrouqGseE44dkCLvDTEsOIl+/BA4sy7aHRqoXteEaqbMzaDhpElDC4j9BoSALpXGCCuvx3RApxsw24/WygrwDBbk2iJzUnycy7k/pTA3wX/0dI6wV9jCHBQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYWK8rx8RAlb4fO93rc2x1ZmnM+UNGHCvAG3NxKRslY=;
 b=GJwRTcjFYSYDfKT5X13FlAmW6W31JHZQRjlqw/w4P2KvXmvMOZcM6xa/p829GX+kSCd8eA/lO+UMwXSW9ShUmP6p2u5GUwx/RsSB8FDYrCG8B2Z3uKl0RK7qg6OEK0tuNZlDbWS043dFRLK0Um5EpV02Zl5/BgHMCXurHFvDWlGqmJRzbg1IcgarM0A5bqaEfFxjUPEeIkdf1KcZ6fFlODesP31O3iWBv4l2XS9BVecTRYc+yu9lEg5EW1yMA4YGVoxuaLwWcijdjpTDJOzez75N9bW7t8K520878tEDmE9LuYEPrYhr2eggvTGBPuQFGlKLUPObeYCglsydBmdN/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYWK8rx8RAlb4fO93rc2x1ZmnM+UNGHCvAG3NxKRslY=;
 b=kBXdCl7TLrFTvYL1nZGQ0451Y05SO9/r9YSfbAADQfzn1gDGKF44XCRvPG5pMmfhl/dNxkzxP/ndkL/u9f8y0qnv+ZsS/TN6Xtv1iJQwbs472XUj7m211OTJ7LjwvSZ0o/zhjsOxeJigjW1U6QVI6u3HCSlMQUXqvja0nwM1CJ3hfNAf/kM0bS160gaz5IYrc5oIwo0AvZfUo/L+ferOcwFOFv3Frx338IZKboWHO7cdgTUZAvY6JKMcs8he6s9gCIZQQyXOGbd9xoj/4JKYfR2VkVPH6SzMUXaX6K9TqIXBP2uzYJDYht/wHEvtW1l5YM/ZzTNmYxU27Sg7aFVvdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB6072.namprd12.prod.outlook.com (2603:10b6:8:9c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Mon, 25 Apr
 2022 13:36:10 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 13:36:10 +0000
Date:   Mon, 25 Apr 2022 10:36:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, chao.p.peng@intel.com, kvm@vger.kernel.org,
        Laine Stump <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        jasowang@redhat.com, cohuck@redhat.com, thuth@redhat.com,
        peterx@redhat.com, qemu-devel@nongnu.org, pasic@linux.ibm.com,
        eric.auger@redhat.com, yi.y.sun@intel.com, nicolinc@nvidia.com,
        kevin.tian@intel.com, eric.auger.pro@gmail.com,
        david@gibson.dropbear.id.au
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220425133609.GA2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220422160943.6ff4f330.alex.williamson@redhat.com>
 <YmZzhohO81z1PVKS@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YmZzhohO81z1PVKS@redhat.com>
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d766c9f8-44f7-42fc-0521-08da26c08ef8
X-MS-TrafficTypeDiagnostic: DS7PR12MB6072:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6072E14DD719C63273A80B80C2F89@DS7PR12MB6072.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQmtIb8iOaZl9oMMJLPe8SKhGDrNBgFETgZePLmVfZEWJtUApz+kM0lm1oae9GHIt5LukAso8soKfxwjasyQ73QpbzDHehm0duaw4JOXGwh6Lt54FRgytzLNlHDzIWFJUmoJUNJf6v9ejoEcfMzrxwBXt2FAjNca37Ib4rzk9XACEM6ZCoQ051py1TLQWpd2fgZps+5SZ8mj6AgdQ3nz1VCD5C8ZjhZcLgt24ZsD4dLkQ3adcaUPu8wSxbTpv42VThGLvy59J1VQDKrNyZOZAD4neMXswAyuF1QN7GGswEssnLxrvcskY3vI2+3KJdom4ztRHDAEN5Mxi7XlehJE+gh/yZ1pV3keEJEgc7lOva4pnJMbsYuqDJRes+d2ucLogOgXRPyuYMO76zIuGSnm9yXfHpjFM/Sc+EZFiv1mkSlkfFKYY/9Go52ttDB5Wd0lZMe54kRYmHDKUjWReY0CLDS2wnEtP7O+mTE/XJO4Rf7uFcbazFliLMxU+9IltlG7ujdIPEdpkT82nbh1ELoWma6E7G5UgMdDml8Dn7h+v+mh+X0jxzHWuP9NFwIo1p20qAZsj41ht1cZv9sEIZI17wM/5MFPIO/P5EI+40idF+ifVxoEfb+vaDhgBack4gtESYUvXOTTKU9OR3IT5Dz/bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(6506007)(8676002)(6486002)(508600001)(54906003)(316002)(186003)(86362001)(4744005)(2906002)(33656002)(2616005)(83380400001)(66946007)(66476007)(6916009)(4326008)(6512007)(1076003)(26005)(7416002)(8936002)(5660300002)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUdYaG5KLys1TEJteldnRk1FU2VvdDVYYlNVeEZaNGRrM0RrQ1lDRStEb1BZ?=
 =?utf-8?B?SDV6cGFic2E2MERIMWNBVXBERWdZRjBiam5YcS9kenNocGU1dklMdWM0R2t4?=
 =?utf-8?B?VDhGVVZVYUhJUmU0TnVHSE5YQUlQMDZGdnhZRUJwQU1UUWhUTmhFcmMwaHRQ?=
 =?utf-8?B?dk1uMDkzRDNvWE5jN3g3bTdZRHpteXhNM29PSjQ2ZFI2akV1dzhhbW4wRFdX?=
 =?utf-8?B?aGIxZkZHdW53Ukk4NzZHUDFySEt2MVVQZ3VoN3dUSGdIYk9hckU0WXIrME5L?=
 =?utf-8?B?RXI3U2ZwSWRhRzN6R2ErWml0eXc5d1FSR09aVzJod2RYcWRTalpLc1ozYjVv?=
 =?utf-8?B?UVlTVFlzMUhiby9CbDA4aHk4aG1YQ3dTMXVtTnhqeEhFMVErdVlzdytGb1JK?=
 =?utf-8?B?dFA5aVhDeE9oelQ2TWY4MEFxRzFLMEtuSlRRa2g5d1lsQVdLRWRFVkpHc1l0?=
 =?utf-8?B?dHZmVTBUVVNhcFBMWDJLcXNyNHBCUzh0NlZTcUR2blRkMTIzSFc0NS9SWlpo?=
 =?utf-8?B?MEpmdzQ0a2NWRUwvOGg5UGE4dGpSNm1WSHlwSndXQVdCQUtMN2hMM2IwSEdZ?=
 =?utf-8?B?V1VaQ1FmZk9sMm1LL0w5cWRkVGkvN1hkTlpXbksveVIyWTlUNExPTUlpOTNR?=
 =?utf-8?B?MnliQllpOXpaaFNxY3N0My9TbllOelc3QTU5ZEcxKzJKOFFrMzR6Q0dkVG1t?=
 =?utf-8?B?UmQ0MVlKRHF0bEN1ZGJGVmJhblRpQ2VReE9vSnI1QUJBNi80RzB2L1diNXh6?=
 =?utf-8?B?U0RxK0dBVGVnT1QwZUZ5YlplQyt2Ry94TWR2aTJGN2hRM2E1TXArUkhCUCts?=
 =?utf-8?B?Wk9LdXc0SEt4WHBXWEIwSW42cnN6NHdKQVZJTkNCdVRReWpFNCtLSXFrZXVa?=
 =?utf-8?B?dVV1cHBjZk5yOWs5ZWp4SjNVNktabVhMSS8vM01yVHg2UldZVmVhU21iNnda?=
 =?utf-8?B?VjlEM0RTbExNcXRFN0FQV25zejhVUDJxaWVRb1JzOFMxSXlEWUM1RzU5UUh4?=
 =?utf-8?B?QkpqVFEyRkFJVTIzTFAvYVRFa2kvRFRwRXFuakpPZi90bUNMaWdsZHFiaWxa?=
 =?utf-8?B?ZmZianNVMGlSODVVdzRGREpxSUgyVk1Ic0RIWlBmbkNHdjI5RTFmWnp2bVRn?=
 =?utf-8?B?ejVGSkE4eEtnQWJNNDlOL2lKR2ZMV3R0dmszL3AwbTRsNGlibmJnVHBZSktv?=
 =?utf-8?B?cVBhZTBGYWtTS005aGx1MDJmdXpjYVRLZm5XcXdTalUwN3orWnlyaDNUSGNv?=
 =?utf-8?B?VzEweGdhU2wyM3o2aWtyN0FFU1FJRHFTTjRSYjNVbnJNMjE2c3F6OUdCa21O?=
 =?utf-8?B?V0diN3JSelgweGdKWlQvaUh1YzdwYWhkU2ZlZkRPQmlKTTRjYUh3eWlRMjVK?=
 =?utf-8?B?bHladExGVFQ2L0FNdkdxbU1rRTEyY3lCNmZzWURTWUpkd0tDU0FydEJmRXNO?=
 =?utf-8?B?Y1h0ODU1dUx4MDRKV1VhZ1RIc3ZjMHJtRVU4UnorVGdhR0oxY2VxNTVGcm1C?=
 =?utf-8?B?SFpaT21iQUhYUGE3TXRUZmFNVDFEVnZjWmszQ1JFRVRDUWh5MjluNFdZU0Fp?=
 =?utf-8?B?dVEwNXI2bmVtdWJYRTYzT25aazdkT0dLNFJrQVNBWlc2c1JpUG9jcUdpeVFF?=
 =?utf-8?B?R2U3aGd6K244c2Mya2I4NEtBK0Q2Vy9GS3JBMFZJOWE4VlpnekcvR3JFNXFH?=
 =?utf-8?B?ZDFoRXVHR1N0UVR2cXp0RGM1MWxWSmU4WUFMU2ZDZ2lTaEdLUGhncGplTmVi?=
 =?utf-8?B?Z1QycU5VY1pPMnRUQ2Rxb0luYU5seDVQaWJZWGJ6SUREaThLcVZoLy9jTHBV?=
 =?utf-8?B?MWFjcEJKRE1JRGJFNnhuS0NHUG1zcW83bVVuc0o3SFBMMU5qeXg5QWd3N2NB?=
 =?utf-8?B?a1RGanJKRnJVdzFNWDkxdDlnSWlPalQxb09Jd0puZ1k2dnBocjFrejh4eHcw?=
 =?utf-8?B?cnVPTndnMDh1MlZvUFZTVlJpQkowazRJOVF6S2FzbWtqRXp4UlFMUjBRSHRV?=
 =?utf-8?B?b1JSVzVEdFdyZ3F6Z2FUalptd0J3bVM0MVpRR0FQU3ZjYjBjNXozL28vRDk3?=
 =?utf-8?B?V25XSnhLQjVjRUxQSTlRdGN2eDBQZjJnTnV1cFRHWGdTNVJFM1hGYm9VNks0?=
 =?utf-8?B?aEZGSjVoSm5IdUxCL2hCTU91YmRBbDE1TThMc0VrWjJpM2N2bkVPQ1VRM3Fr?=
 =?utf-8?B?Rm13REFnQ0ZDKytBaCtBR01uTGptYkQ4aktpTFQwUnZ1bW5MWFFHWGd5eVZx?=
 =?utf-8?B?NmJVY0RONlljMGJQb2gwU3lwT21aK04yRlI2T1k0TkRnblFuY0Fzb1BkTFoy?=
 =?utf-8?B?UXVYZ1BIdzg4M1kyS0preWdXdHI5L296QXpicmFlUy83UXNad095dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d766c9f8-44f7-42fc-0521-08da26c08ef8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 13:36:10.3699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YP2CYEFVW10XdabtZK/56WM9wMmwqoPbzcYXRM0lrvv/gMZgh6beDaTCwtOCJfQv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6072
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 25, 2022 at 11:10:14AM +0100, Daniel P. Berrangé wrote:

> > However, with iommufd there's no reason that QEMU ever needs more than
> > a single instance of /dev/iommufd and we're using per device vfio file
> > descriptors, so it seems like a good time to revisit this.
> 
> I assume access to '/dev/iommufd' gives the process somewhat elevated
> privileges, such that you don't want to unconditionally give QEMU
> access to this device ?

I doesn't give much, at worst it allows userspace to allocate kernel
memory and pin pages which can be already be done through all sorts of
other interfaces qemu already has access to..

Jason
