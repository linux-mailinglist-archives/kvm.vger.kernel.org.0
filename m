Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC913346FA
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 19:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhCJSkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 13:40:41 -0500
Received: from mail-mw2nam08on2051.outbound.protection.outlook.com ([40.107.101.51]:45440
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233250AbhCJSkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 13:40:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExEBygMgQaY8vs0q9Xbq+tzXjTt0nUJq/hLu0KB1XN3g1NpttjYdXqiiTm3Z87Ngm+ktTQxJiKP0C2EsF30c556V5U3H0yZibxilwJO9OGM3svqy01om4Scot1HJEitYKzAxXCXzP7aaAll8MLBTdyF2Cqdq8X+LQuWwrMLzZq2afn+tGI8CC8Gfzq6BJw3YSbBrwHilVW7/2QMSdiEmCU2zb+NxnwB3Kkor37KIX3IhHztFJt6YhN7PX1HkTZtNaMC2M5ekau4XzUlDQ0WgIK0fa/WeEm7PjocbpJ7zxamxchz/E4ywVujF+Gse9yNnJgjzU9C2xhS9lpAjhzNiEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7C7w+XxO2DopMgquN2wSLs1qQ2d24B8PrXfyqjJ+7Bk=;
 b=FepGCX9bm6SYUUAH2s3l9TQ7P00IaUgkOd82BfqEmtnpf5iPrU/1Tp2tia4H1zOaHu4Mee6afRCgkO4jz/srUIXGrM3SZQkYxlc0q+ok9qI25MkXV+oe+pB0gVD9arh2EsXlQJYk2+8Wx0GuaHSNbwFJHS/a4XgNpMApDc7X95pnASELcBK+nBsV0gOWppgvVrEEb+jdes7ddLY2hcA9YtbBiVykYaPIgm0Ss/HsoaAUndjx7SyfXOEp1J/6pzJoYIa5+XDUlmU2hkGPdaAoFSw/ZNA0QFmryht89R4XtSZzFar+MmvQmYk8HD6UduLaJrvzNjKikn2vu+R+K7PeEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7C7w+XxO2DopMgquN2wSLs1qQ2d24B8PrXfyqjJ+7Bk=;
 b=FkAe8lnbOtA0ua9WYRtNtTzuv4pcq9hKP9EDhn4c6/uSd4O5AH3AAfrhuL4yZnv8hJFhXVUV49ati8LgbrQuRVHiaDtX2qOKyzm1cV0a50EovCg297MMPKoSAmhyOv7J6/UE75qDqHoQjhSL7Q2DS/msZPOczOrnQLC5LoD8N84O+Lf7x8pcRQT5SXSDes03yKsSl7KU4KcecwU/0qytikCNbYh0pEY9PDea0hN3eWsomgE+IzA3oVTZiqgabrGxdq03dlzYnhQSZZHOKB6NUYeQKC2Y7ym3eE7+smgIIOOl2a1VbLr+g7l936jNvbVdS59D2SfNoSfsk66WNoeeBA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1659.namprd12.prod.outlook.com (2603:10b6:4:11::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 18:40:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 18:40:14 +0000
Date:   Wed, 10 Mar 2021 14:40:11 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210310184011.GA2356281@nvidia.com>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
 <20210310181446.GZ2356281@nvidia.com>
 <20210310113406.6f029fcf@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310113406.6f029fcf@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0104.namprd13.prod.outlook.com (2603:10b6:208:2b9::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.23 via Frontend Transport; Wed, 10 Mar 2021 18:40:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lK3kh-00AqVr-Mg; Wed, 10 Mar 2021 14:40:11 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cc0c7f0-e389-4396-c400-08d8e3f3f0e6
X-MS-TrafficTypeDiagnostic: DM5PR12MB1659:
X-Microsoft-Antispam-PRVS: <DM5PR12MB16597BCC813E6F68D2587895C2919@DM5PR12MB1659.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VkPMPLg8VJwIOUTw/SMGjkV/E7AHugPPzwlFNfuTYO0WMhiqzzQ8GCAexnWw6yd947fEMdCHqqT+c0qLLD4Z7fF9paqxP5AVVHCVvB/PP6+OByp/DDJqTwOJcKF8TzVg+VknzCSLhKZujwqkHODI4nd3fcrknsMriwAcD77eAq1gCdTAU7fQBCRrPz1WfTFq2yoC1UnKfz7GkaqCfRqtuLrDpwztQnU+t5CakxKqK4w/O8VGTTWdczEvcizWtwm7CdexxLFOtTs7fYpM2/Yojr4uXaM+PAAvnfwpCl0m2laSUsPKFEzXbBgVa6BT2fXOFlTUTw90ex2ktWONQyR1NVXP0BZhhy28N01rDtfhnEa3KDpaOqwz5BAXDkVysW5CcXKqD909elUaVrgCNi6hU50Bk5VZYXDhtPi/JL6kcNtihTytKv++GDL2QDxSh7CBJf3bvdUgxWQwt+o7o64+7Yj/KTqc09+lM8oOs0WXn0J3vEXm8TfhCyRaCWO6Ltj9B5bEF5kmqAHqDzaPQadQZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(478600001)(4326008)(86362001)(5660300002)(1076003)(4744005)(33656002)(6916009)(8676002)(426003)(2906002)(8936002)(316002)(26005)(2616005)(186003)(36756003)(9746002)(9786002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?306x1TcXVIRkvEBurhN/uf7VsyhmiKyab9RpXbUQc3zwl6Tk2JO+yWVAc+V7?=
 =?us-ascii?Q?KE6E4CQlyVB1vj3d34pBOAwzbHCqCPZej+ubE6zwNBOVCt6PAaJtVo7LI2Za?=
 =?us-ascii?Q?7Zz/sD1eFyXMGDpeQ11/fOZ9CQCrEbZ7W1Lf/yLiZ/4/ElKfiv6kAcZXSNyJ?=
 =?us-ascii?Q?bLi9hul9NucHGoiU2YEZG3zenG8zyuROPsiHFc4VQwgjWYMDkf/qsJNO7Df2?=
 =?us-ascii?Q?HMGEougbqZ4YDOAH5qqPUtpk8ZQbBzwZ6UVZnLsMICoqEVWVDeR/63njpVaP?=
 =?us-ascii?Q?XXCJlNjPbEDqJPqAB02izi29bbLet+asAEkjE8P5rpu6sfQMnyRFNbY2wagC?=
 =?us-ascii?Q?44CrdabMCAokI52iWqtJ1Ce68N0ki9ZKpEhpe8WhF1gtAPT82HYLn8WiX2tH?=
 =?us-ascii?Q?WqY0lHcZUTJ7ikRdpZceRARFNc5HRGqGCgE1q3SO52kmB/6NbX1EL1BcDXfu?=
 =?us-ascii?Q?Ge8Ac8O0dUXm1VHKJk2t63YV8iF4yNBPN3agbPXBwP6IzARzyRZwrMNEP3wb?=
 =?us-ascii?Q?v9N+MUi4ONUSK3se8MWowOmmMG6OYE5qJkQSEe9j0YVJIKXhqJ/PI/dIMFFm?=
 =?us-ascii?Q?ozSbZPBbhbxbz0rq1asN/d5yU5G4Tp2sJ7gs9Xc+bNHH5OwUNjhctfuP/4o5?=
 =?us-ascii?Q?48Vie85qRobX2kj1Pp2jA+8qmFU/uU1GHNrBNMgt1T16oCvdHiWI0jGRnUPc?=
 =?us-ascii?Q?2Kcl0BAHS/kr3wwEBn0F8UbZOYyUjS6pL8kOUEjnV1foRrKZQphz8oirC77e?=
 =?us-ascii?Q?ntB57Hw0hmMloPmUsp7Xkc6WPnqO+lvVt7Q7rseEbd5ejLuh/Zs6oDLLUPQL?=
 =?us-ascii?Q?J6IqQ1DMuVUVZeCBi6hT8SBeo/2a0iOH+1TbXdnjW0XgzV9HWsj6YWRh/6qz?=
 =?us-ascii?Q?uhgyR/0N/HTSN+6puK5GzI8v4RvH9hJyLyqtYjoHXvF7pcUkgHIxZgas/7Sy?=
 =?us-ascii?Q?+9EQGLP49+E5R8CWAm5k5MEMQO9S9ENArJjv3YHEaXbZbL1p3TxW4o8T17o8?=
 =?us-ascii?Q?ly15SXsJgXmW7wOK1R1m0uixectSHGGTtvsZwRU94T/WYB+eBbx0hQf1L5SW?=
 =?us-ascii?Q?LJSBnHnqXl7y0oxWs3EuC03hNdBA9KET72wzDeMRGAnAYZMpz3YbserXd/cy?=
 =?us-ascii?Q?CkHK4BTvznHIYYl+gGDtgURj/Enfz6oPAE1kZ7P5g4FMVyyMTv2k9yCct6mU?=
 =?us-ascii?Q?odej3U4IpD56ZE/wINu1n+i2efahnOIjl6U9WBCi5vQ+V0aPRMgotoRQLmwO?=
 =?us-ascii?Q?wumgSiaih+27fW614+Nns+2vihlhaac+JLlal9YcaR3MmP+FUAZtj910JylH?=
 =?us-ascii?Q?zx1RIXueBPlU7HzBzNw7kESkPUeFZdY1RibwcQb9NJpcFg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc0c7f0-e389-4396-c400-08d8e3f3f0e6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 18:40:13.9074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8MUTXaFqCvtXqLvxWb3sp0ApvmXFTRX4C+EisDCgYXYSo5Vu2vt7aMgEw8yx+wxj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1659
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 11:34:06AM -0700, Alex Williamson wrote:

> > I think after the address_space changes this should try to stick with
> > a normal io_rmap_pfn_range() done outside the fault handler.
> 
> I assume you're suggesting calling io_remap_pfn_range() when device
> memory is enabled,

Yes, I think I saw Peter thinking along these lines too

Then fault just always causes SIGBUS if it gets called

Jason
