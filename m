Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2373E2068
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 03:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhHFBEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 21:04:36 -0400
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:53089
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229707AbhHFBEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 21:04:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IquIkg+K+nJOb5tXOeKRTbkJ+YdHxEwYjNcsRbbgL8CUgkvZ4NNRg+uA05estcMGx2MeFhYOL5cf3LjKSFaPCdKvdgrOBeJXAWs6ZRUfk4V+7nxtCQinWVOpL4tKXuGFtPX/W+D7wY3VfbMlvEIOaZYM+HBJeiNaBEAGrndlKfdkqDHxaPJ8TBS26TgDf2t0iN5WR1LM0utGsHTbNcriAG2LUAEAPPGVCrqhRbGiknXttzlhS/Th0aP8OLyE/oliar+jT0Nmooy5Hk7Y6qauT4gKrt/Ea2eQ/tknSX6v9RsI3Fpo7+nbua9TKzM0nsy7ygEl2RwFoPFDStDMOqzC2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPUHQIN+80TMnOVUB94YfjwEf8S7WgnjFfDVu5SJ4RA=;
 b=OWWJ7slBRDfdCKXJWRUqai8KSL8nFLF2eE6nSuqiXAt/6BIb1mt5FulQ3rQmmL07S6wZgyluy4tRrovlTMDCEbBXgGKCbqY4oHk8HpTOoVGVPH/SJp2hOX1bSFoQORBRMgWiv93doEHs8bjC1KIbuoV4wnuW48aa+B4Q3WzwRWD8JITH8qKuVLwDvCcHiKbU+3ciibnw2D/SPf8C1HumgOPMssiXj6zH+SKcAP8sqhiyAz7TNPBfz4eSfnFM2sQMGtXUmwpctGdYSYfvNiOqMLuHH9jmSftgCWKBXtscaRLRQLBu9WbjWJyJp6vVAeOSNlCG+/lqufBgATp0xrUFHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPUHQIN+80TMnOVUB94YfjwEf8S7WgnjFfDVu5SJ4RA=;
 b=mSXCQYfd4Ruk7InuxQIiIMezIoMq1hCjtbVQ0VCG2NxpjCj8MILZiKJM0uYtj/hItioNje+sJvsdy3qO0I7DMjlDi82sNk25w4xGvD4FcQAZsCa1rKy0q2l0Hp7p8369797WSaIFybuawV1R2PUeRV6t+zv80DRWtnqpq3LGSyu05sBxmu77eqDq/ZWgZ0yd7IX9L6+Wf9FRJv2SWrXqNDbKGgcn20nrf6A8bVoRgp7IGxFTPk6qtdsREUl8T+zlFsGjJ3TM/3vJE3ZFpEZ/QuQyD10I7rm6QZuYzDrb7mPNp/rltEq73Xe6GrI4su1fK3cT4eS19jUGHAbv09zMJg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5269.namprd12.prod.outlook.com (2603:10b6:208:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 01:04:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 01:04:19 +0000
Date:   Thu, 5 Aug 2021 22:04:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <20210806010418.GF1672295@nvidia.com>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162818325518.1511194.1243290800645603609.stgit@omen>
X-ClientProxiedBy: BL1PR13CA0287.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0287.namprd13.prod.outlook.com (2603:10b6:208:2bc::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Fri, 6 Aug 2021 01:04:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mBoHa-00Dnmx-HT; Thu, 05 Aug 2021 22:04:18 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2d3fe44-152f-45b4-2353-08d958761ecc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5269:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5269CBC4217E48F6E9B9CA15C2F39@BL1PR12MB5269.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /tloDyscEtLJcEc24pnOqu/V//IZVubO/jhfMXBHtHmk1Nud9r0wrVtOwMr5W8Nb+DbEwcynQPiiiMVOGJWZp55UKbPe4S0bxmdALW3xgP/ILZTI6WQwsIzfpZXY22A/MYERFI5UELH8ZNt7HpVO0jBcW4r+QyNyryAsb1gOfyH1nxdbO1EobiTtAK6X9PtCP8+uDNmFvzBVeETxpxIeIUK+HE1Z0qQ6fZzR1FC/7Gq3VxdQEaQGIkk0orNpHPWycqCzYNy4Dq0XN/zdvkUt+5Q1m32tvPxNK+1A9/mdkWJ98ff3uQkW5Dq/kyh4UcjR7OMvBaOPZnWAienzPYkm2W4d8q7TYsrHhQxKQSlvlXCQuvm7hiLDFw6PZAms+/xQx2FZxZqRYeSiyAyBpC+qVum3EMZsmDlMr3CkBbuLaViTT6t7N53uAE6IClsuHy58CJsS8l34Ba7CcTInYOo44jz/HTijqyKYhCNyDkV+dfRaivyFI/cGRj545WZMQLfFSRjaqvpbGMEv9xbMkPHu79B/m9QeipUKm6JaHdzcb5N8pDJLaRrUz2lnyfYBeS8gFn1Ml9XJKCBshId8fa7e58uC1F/U3POJxn7QK+9ADwthbPcQT9KqN0HqyHuwsgfNfi8GSfO8T+ktWFOt7WZg1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(26005)(186003)(66946007)(36756003)(8676002)(2616005)(4326008)(316002)(5660300002)(66476007)(66556008)(83380400001)(86362001)(4744005)(33656002)(9786002)(6916009)(2906002)(9746002)(1076003)(8936002)(426003)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3dmbakg6iFW6+yUKCcIY0WpMDlyW80uiOwpq0PJLvAIMgWgR1hRmJmlEEIOf?=
 =?us-ascii?Q?0YXjE6Tv5t6OkUsw5CDEGRrmGU92qXtTzd+RV5to7S25Lhm/ZIwIIfCPslFo?=
 =?us-ascii?Q?0I/DQ634+T/a09/udzlcO7nlOYV1/1fB2m9onXOrFoNkCa1IsIeuZqWl1Mt4?=
 =?us-ascii?Q?3IPIWEzuM4Tm8yDfqxVb4knt0815hQcEsZqHrb1HTyLRA6aQq+VE7gQwQwGN?=
 =?us-ascii?Q?D+zpxMsIj1gnpzygJGYgR5FPIuTI1571k4uWPx5dWRP/JJ/CJc3QU870xdkm?=
 =?us-ascii?Q?MBzc4oHjHDxLg4TH/pg8DP5aPNJrCUMc3ASeO1xycQckYbSRJVEi2kOJl/hq?=
 =?us-ascii?Q?gS+nuxCFVw9uTyOcscJRFxlbPIir4cah6sQHxt4yxg3+EJNn1h/lWX4EoBRa?=
 =?us-ascii?Q?d7D8ValmfkTLsP76HNS+TcFcYIEFvtW5Er4DPmKFrQ0eEFBX7xKOtb4SJEwJ?=
 =?us-ascii?Q?OFjuCQj+tNn7XSOGlhnglMrRmANA89LD6iDK1mHDxjwd+IPNVDWKgOKq1sLw?=
 =?us-ascii?Q?S0Nyy9EVCUUyGKVWEgM0/TlMQOsf56e3PcAfVzjQoHzAfUurRTK2uVNwC+Qz?=
 =?us-ascii?Q?wICJDHV2VBbXWbzL7pH3pRlOjQYRfJ5774dU/Xnekz4Z4k5o+7Iyso69TsgS?=
 =?us-ascii?Q?Mha9cN06d7qWvd3CWiZS+qoLxlcFIKu9HY1DlZpDA3Jb3qUXvLK9NUJTu2Jb?=
 =?us-ascii?Q?dzrSp4wCiro2slGS8MXfdVKQe037TJp3iZPH9yC0tPtEmPEUzRA2pdLzXhGZ?=
 =?us-ascii?Q?u8RAGcSMsAffR2fQSouhuskRf2b4QAksyfP602BThi1tGG+j8mptfNNME/yk?=
 =?us-ascii?Q?aVbRSggD6au9Hs6mJLPpgoUcDBy09WyEUJwF0r1T6LgzVv/0EHB4W0gR9ZXz?=
 =?us-ascii?Q?oto0dAIn1qJi62/Z+XsyXeMeu1tUK2OKgVup9WuxcJzfvI5DPoYwbNnJjMeA?=
 =?us-ascii?Q?RoT21bWwvzdaXz07zVAkIqig36WsrwWdRyg2JUa5oXdlunJfk6BlKeaa/ncs?=
 =?us-ascii?Q?lqx1dDxaXFxWNp5o3gugFRMSoUdNhgUpdYKjuEl5qMlaNhgL93GZNBWO684n?=
 =?us-ascii?Q?yXLMKlyhVnuCzaQWO4JTLH6EnQnemr96J2PLuK/sODWj1ZV27nPCr1vSf0fM?=
 =?us-ascii?Q?aOBHy85KPuEjZH0LdKkdPYPIArboP267jUvRuDoLmWEZiTJdwJOoPZFuM9KJ?=
 =?us-ascii?Q?8yDoxIIvila6a/RXN6m1V9dxu9HL13ls4OHA0Q+3Cci91lEpDGuW63Cq8ZwT?=
 =?us-ascii?Q?Gr5QpLlAX9sQbiog1dnLJcPRDBpopwcBsqgqRQwdbUj86y7xapd9Uo33poa9?=
 =?us-ascii?Q?wOH9j6WCWeAd2jAYr81RKbIC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d3fe44-152f-45b4-2353-08d958761ecc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 01:04:19.9061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVUePZFdu0lY1hA5zCFCjY+wwcXGaCURwdHLfKQNbJtFIvG0JDFKsLbXPzAu6fkc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5269
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 11:07:35AM -0600, Alex Williamson wrote:
> @@ -2281,15 +2143,13 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
>  
>  	vdev = container_of(device, struct vfio_pci_device, vdev);
>  
> -	/*
> -	 * Locking multiple devices is prone to deadlock, runaway and
> -	 * unwind if we hit contention.
> -	 */
> -	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
> +	if (!down_write_trylock(&vdev->memory_lock)) {
>  		vfio_device_put(device);
>  		return -EBUSY;
>  	}

Now that this is simplified so much, I wonder if we can drop the
memory_lock and just use the dev_set->lock?

That avoids the whole down_write_trylock thing and makes it much more
understandable?

Jason
