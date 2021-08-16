Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7793C3ED9A5
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhHPPOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:14:34 -0400
Received: from mail-bn8nam12on2050.outbound.protection.outlook.com ([40.107.237.50]:30624
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232417AbhHPPOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 11:14:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEc6CMetKnyy1iAvvdkVX9xe3R9SYvxs22c5ycEDfQZMwwKX6VCaM6P8DJIyilc31j8Fy9JrsdYnnxoHJ3DS8/B2KA+kRFHyjSMjLfUWl5XgfuR4CFSLlr5xc9lMTs1RTvmTnLOV/xslK5KFrCPKFZH40Jt2C93ExjgqC3KBEdDzXgVwxGDM9UZRw0r7Uu0wzFmPzCseVkoAbcqdQuqX9NhJ2AURGVE/m/mLb7H0DI2xtu1ZuNH420pv/jIpl49gUAxB0Rd4rmsjq/eqY+7KB26X73FaLRkdFi/4gTSTJY53cjpYSnpcpv2Ab1nfVVSLr+tZHB2JF7do8HDeZxxsKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObL6VSAuE0VpCsq5nn31CPAM1b40jVbINMFkxMNp98Q=;
 b=IDYXQc5RSGUTGgwsLaq1ujBCWcuiRgNMc+hcT0SVLvXTWvoremUORuwTLmovtOhdCpE9EuI4zj5oa/IG1H4ghEHuOkPuhBwOIydCIkEkyLH/AADjC+P/oO6P8WQryTCgnR2Gog07UiP5+QeGQWPjQpfhxyga8ZMeimAl7Bgy0aGhEnNmYUQFXyZa4Qv7lJywdQIrXfkXvoFqsPQw4jTAjHQkeG0+ezDB71RKog6blZjeqZfOqNOpUTxPELmg5g19lzU7Y1Rk496DHdrvBw+p559n9g+XsiNXviHB5RQqxZWuUk3orWRgpzdjtbFM34/eum+ESFBLmwCFCNOeRx2YMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObL6VSAuE0VpCsq5nn31CPAM1b40jVbINMFkxMNp98Q=;
 b=Nbcx9N1DEYqzVOnPk730+Fz4NOrHCi4cUsq3GD1oS1O+7MubJskpQbRtQOLFdOJMttnTAAWGTGt4HaXvsrKjQiVrLdo9Czwo5kIoikBuVzOqQejoqiKWbIyW3gMuGCjmz6A/F1M+GMmoGj8WCe0u4zEsBzOfP3uRKHcdtBo5B7o=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2509.namprd12.prod.outlook.com (2603:10b6:802:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Mon, 16 Aug
 2021 15:13:57 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 15:13:56 +0000
Date:   Mon, 16 Aug 2021 15:13:49 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <20210816151349.GA29903@ashkalra_ubuntu_server>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <20210816144413.GA29881@ashkalra_ubuntu_server>
 <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN1PR12CA0077.namprd12.prod.outlook.com
 (2603:10b6:802:20::48) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN1PR12CA0077.namprd12.prod.outlook.com (2603:10b6:802:20::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Mon, 16 Aug 2021 15:13:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80b8d732-78ab-4a97-844a-08d960c87782
X-MS-TrafficTypeDiagnostic: SN1PR12MB2509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2509E00945C01E36B0956F618EFD9@SN1PR12MB2509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1pJnzSOt7pmY3fZcmoPKQjqOPWGIKfD4yptTGehbbFekMrO8HH9JVuyWgLSHSG2B4bzKHavVvyWEUOAGsvz1UF1OZYEU4ukhgrLMmVq1cHolVvw4t8N1waOPknRh7VTNYALn7rv/zttRFzHLmRsBcV/qhQapDqEXPiSPPTNv7UN6LII41Z/51H5zw7wE6BGTtriAmkzSeIjdicwCAzAgSU9/Y7P10XsrBfWU+cZB5m0CJR78bGgIQhDbY9YtAUllaQjnLfFVDm8isq2Oce1P3h9sHNxjcmfcleZqH82cD+jhKymS3O+UxQH1+ZdKvSna56u+R5XmFR4kHfAAUAVoJRJ2XoYFIIIdoHyT+60HTvpnDtxjuJg4NUR7nXNKq2R2TeVvOhX4v0i86zaju/wwwQRNWiq2AFbuOP9hbEw4agtt6/5RerJHDzpkZJ+dY/AAs6rlQae7hxgqG2h4oMzqT6i8TEh8D0sL1xLA5Cg1XX6ZeW/wxLz9EmoiXCKRAscKgg3+WQ42uu122Wi1+fqgtsTjlNqyoZc1m9TxgoN//YBZII3BkwbB4PZtCQmCM9EJ0UyiFBkV1m+a44WICJ4ba/0MYqsBMEOgL3lSG0Tb7frRs19XzPv5x5d8EClLhdoTODtxtmBNTRwVdcp/kj2RjOHYdvIgu+q7cvshBeV/d9Q7tc+XP57Qw8XcVoLrekLklOUQvi4DP84YzYQXi7yoAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(8936002)(86362001)(4326008)(44832011)(55016002)(33716001)(66476007)(26005)(8676002)(66556008)(83380400001)(186003)(1076003)(7416002)(508600001)(316002)(52116002)(5660300002)(2906002)(38100700002)(38350700002)(956004)(9686003)(33656002)(53546011)(6666004)(6916009)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NZVyKgenEyXzCUq85+qL1CisEop/xONL+ybYlP2YRQ2GHNqbMK3pV36NUQHN?=
 =?us-ascii?Q?6n9lUhTl/FsTabEQuVsi/K4DK/hNbo3KCg7VBz+3N15fiddx9XNIAadCy2HC?=
 =?us-ascii?Q?P2H4Fz56URKbX19qhq0T33McAgH/N07phe451gkPaM5kiJynEnI1lyrK3ely?=
 =?us-ascii?Q?DlLraspKMaBMwCtXr7V9R3PWSeJE4aKKXZKhuk96Yi48wKZeIXdxFi4SxOgl?=
 =?us-ascii?Q?+I04Cu5/BKU5JGm+1cw9JRmbv0atMk7M36m1x6JRiI3sizPE+XloTgbgE2NQ?=
 =?us-ascii?Q?F7D+f6sk+JQ4/dVzbiXgw71BWHJqWTJFO5vy4iRt5+eRKKR4k83+rU9Uc6wq?=
 =?us-ascii?Q?CNYTIwdwSIROjH959coSUEq6QuSHhvQ5w7ogMHegskgvlhGxvnIrVmtWbUW3?=
 =?us-ascii?Q?i0kticG1r/QuaH0wsdnDq73E3Lk527bLI7XIV3/71OeYslMkv2quhXhSzt+/?=
 =?us-ascii?Q?wOlaATe+EDrrN2E8mosEKOo6Lj2hNBKpGPIIw5DasvuYxmjd4qT9JmqovINw?=
 =?us-ascii?Q?3j66HoOAg/FvmnSmY6OYPAlOwnHHGZbYgd0cNF4xpCJX5bfc6jaz8w27nNSS?=
 =?us-ascii?Q?L5bjJlaW/tFWmAZqdArtAHnr8LB/P1a7DSD5Yv6ENFCH4lmlERqodSXCUiTK?=
 =?us-ascii?Q?hdpXP+1Ls/HHrhe7piOZdFBU93fzAJCZt4h0C7VjLpq+ZJfZ9Jj0iwTO5iyE?=
 =?us-ascii?Q?sHM7O5wSFi02HIiR4j6+8mHE1d/RZSm0I/7W/AwMqUOeiA/QMCYXu1cABrD5?=
 =?us-ascii?Q?RvZ+pudNRONxEWaRaTUzES3VAUcsRcw+aY9SMFD7x+sdOpZHkrNbjVPyb8pv?=
 =?us-ascii?Q?mXqIITS0yweGgBUQq2DQYRUUXTzZ8lxzdBPz2hRMM24Wyyk4tetdcn6gBuPg?=
 =?us-ascii?Q?BmdwOLwnSz2xjJq7R7BJDFY9c/0jrtb7od/tutXcTedW5wMvP+DYpYRjghPD?=
 =?us-ascii?Q?5rPm7Y7rKE3NJXaFfBuGWn2GV5XcHCDjb6ZeNSNMXnPcimiMYJPVXId24XiX?=
 =?us-ascii?Q?EvRABjHPoBwzkKDjyAKixZ4pFqBOi7T1WsLlH6BJe5C+lPs2A4hDZY5iUU1E?=
 =?us-ascii?Q?piYKxoGpXzs3DytzNKlyGS8LaC17u5ETfEuPCKtkxCyzt54JI94yN5wMFxsH?=
 =?us-ascii?Q?f5gnmYs7BgzMXK5vlzhBqsK42DMOOQ/4+NL4mePzh8GTHJnH7uMkxKt3Ki1r?=
 =?us-ascii?Q?RS/F2mY0haFpqeit7kccOUhH5rSyQV3L46NLdqLr9ww/fE4v/QzWy4gTUgPu?=
 =?us-ascii?Q?lzSNUE8ayQOJLVLcPVpIy9Gbx2nwJSN57S8nTi8BfmMzw7EVR/Wp8dogfhRf?=
 =?us-ascii?Q?rY5I02tTi216quRpVRPSYW98?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b8d732-78ab-4a97-844a-08d960c87782
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 15:13:56.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8h7Pbqljw7fPn2rn37V60tB45XsitZ1wIMFVsUj3vafx5Fu9wf+1nVQCLiz35xgoBLkgIUqk2NQxcdBx36B6rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Mon, Aug 16, 2021 at 04:58:02PM +0200, Paolo Bonzini wrote:
> On 16/08/21 16:44, Ashish Kalra wrote:
> > I think that once the mirror VM starts booting and running the UEFI
> > code, it might be only during the PEI or DXE phase where it will
> > start actually running the MH code, so mirror VM probably still need
> > to handles KVM_EXIT_IO when SEC phase does I/O, I can see PIC
> > accesses and Debug Agent initialization stuff in SEC startup code.
> 
> That may be a design of the migration helper code that you were working
> with, but it's not necessary.
> 
Actually my comments are about a more generic MH code.

> The migration helper can be just some code that the guest "donates" to
> the host.  The entry point need not be the usual 0xfffffff0; it can be
> booted directly in 64-bit mode with a CR3 and EIP that the guest
> provides to the guest---for example with a UEFI GUIDed structure.

Yes, this is consistent with the MH code we are currently testing, it
boots directly into 64-bit mode. This is what Tobin's response is also
pointing out to.

Thanks,
Ashish
> 
> In fact, the migration helper can run even before the guest has booted
> and while the guest is paused, so I don't think that it is possible to
> make use of any device emulation code in it.
> 
> Paolo
> 
