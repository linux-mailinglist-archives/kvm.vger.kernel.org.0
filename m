Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3282F368507
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbhDVQkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:40:23 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:61792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236236AbhDVQkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 12:40:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjbQrbHM24+FQE2bpTd1GA2bIOxSnsI3YeN0c7zQsNnserBxl1sAyUCV6m5INgzxF4mfeG887WiXEcF6dt0PvrsIcYVnPWJ5nqezDgQ9UZ6q9x85lSRnHV/a7yX8XZkTkuTFNd4KpQ4cgha1PHTiA0nxQWHz5/hZTozP4bKfGS0YNLC0jPl2astlFlAyyre5wqw6eHTQGBjMO0ZSo2P7+O4pN04DMDGBXyY+9sm+mIaiB4DUHDASrXU8v6d1TUi58Dxj7PB95PvARL6QbNTvprSxOo2h7yU+HOgLNUC9nXHM8Q0UAJvls1x1kRgzxUT5sIf5gahe09hYZrr5v4Igwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8wo+Q7FxKV3AavXBxa670YdcVRdUTUmTcDBBHS75Co=;
 b=nbnb+L2dwEEcGTj4CFTzGD9jhPdwv7tdBSkZEOK+npZdMKij4eX+waZ/3c/TyA/iuMIXUUs4u8dNNg32jzex9LsR4szJIaht/baY0711CmE2vWLnR/9TL0uhTqM72ZOjFcFlGjZ5ubF9+fOMPEL18bEZZ9siHlNPOZ5NgJAXg8saIOgVNj88uLRn4TWPruzg/+4U0k2++nZt+9ddVCEYswZJfUMHXI3VWZGrkGi01c4ZB+OCUZ3CbdQbowLtNR7COsqFsSwY/FhecoWHpljYxML2b0nbtwOKM1iCIznR0SAOEvK0LlxsLgfXa56qPq60rrRm+14dL1uodKDPitpyZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8wo+Q7FxKV3AavXBxa670YdcVRdUTUmTcDBBHS75Co=;
 b=XgC97j05+9PNNoN7gOjfAN10OGTCk82sqfYKuk9BRQ7zBvNH4wSKeL3NORJeiUN/+KOnRc+NUiNJ7DnfZg3nACzDD9//OHN5z+b38jGDBUmLPFDxcIKd0EblhDYzSiqEoS3P5KMXThNLKcFF+S4pfrSsO5YP0yMSawMD84gRaBY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 16:39:45 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.023; Thu, 22 Apr 2021
 16:39:45 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        Ashish.Kalra@amd.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 0/4] Fix htmldocs warning seen after SEV migration patch merge
Date:   Thu, 22 Apr 2021 11:38:32 -0500
Message-Id: <20210422163836.27117-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0059.prod.exchangelabs.com (2603:10b6:800::27) To
 SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN2PR01CA0059.prod.exchangelabs.com (2603:10b6:800::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 16:39:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee7ed65c-1100-41b0-9ed4-08d905ad3c83
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495DC5A875D7D7AB7023626E5469@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:131;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jikdWISlHb7QLTcUDAqHcOT7x3aGngWE+MYmEHYNi/zhfWoaUgqm329QxcfS7tBeEHOU+/FwH5yY1Iuxenv/5AcoFkkXRSDHkiau6QtUX8zomQo3/woKvExkdbzmTMT2YNqJHgcZVCrymECNgnKkERWpAEIOwvCMELvHWTQol+RcopfuxxRP4bB6lN4eHv3r+QsyrVy6i/S+m6OHG8q4CTChAM3bLbyzy6IiWyKOmCt5I8w6vJvmfoKH5jNDz3SwVGivczQIlbQ3G0KfA542vAQGYLoO9qXMEarkeSrsRkSwP1OGikc/LCVPBU9TRa/niKsg6odQD5ATuAWLlkOe7x6rryVbBsI8thjWj4W/fhNKmhqA8AGriRBJ7U7icl5zcYuWy8C+SkUzx5QnNArfRHr8IjeahkufmQ6X28DhbFGiQSTTPoxZAT2tYjbhf6/NHegs6PMN5I3BznF9paHz2PCJNiBXofuUlLEgUE5lNzNBZmN+gNah9+BUtC3zcdryp2eHktlm/b5svNmXHDZ9gLoSEvhPjZxzPBwUtOTbhyFGgt3eIAcpTpc4Tmq73vS1I2u0BrQhoGZ8qO1HKrK2+3lWwmJ5sbSyzwSR6KbBVKl83XZlTyKp1VZB4Fo+FIeNdAzvUgesiLIog1kgOWfoGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39850400004)(26005)(8676002)(66476007)(6486002)(956004)(1076003)(16526019)(2616005)(36756003)(478600001)(4326008)(5660300002)(186003)(83380400001)(316002)(44832011)(38100700002)(38350700002)(6666004)(7696005)(66556008)(2906002)(86362001)(66946007)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bVn4rv95Y2fQFmJ1GtnczoACTD0rsggbY/3fY5XdJ1nQ2JbKGnlM646CY+hu?=
 =?us-ascii?Q?3hEPkJ65Y+xdImTtQSlEE4T/gHTaYmGHiwf0lehRI8NoD/Do7g6yls5kJaX8?=
 =?us-ascii?Q?UdubCyPRsH+z1n6mxMxsY3dpJTqyUjtX8jnbATM69I1bwzd3/mMCqzd07a+L?=
 =?us-ascii?Q?MZS1KoRbk7Jq+dgZcSP/T0GtkoZhV6Xy6/XjJ37ZnJB4T3NUDwQOqwUfXBI6?=
 =?us-ascii?Q?hR95eCU+lXEnwl0IGgA1J/8tNQtIDV1sFxdHX3Xt04PhXPccHxMXzEES8Uxx?=
 =?us-ascii?Q?kDKZuqJ5hb+eCvYD39Kxplm4aeVC+CIKVRLgyD1gHwx3MmHzCQTuOlTsoZfz?=
 =?us-ascii?Q?xM/2nio5Zt+wDK7ntMp75qofP7+HxfvnAoS5Mdn9TYk7JwjWdStRjrF7q0fh?=
 =?us-ascii?Q?AnDQsy1V8TNw7fIHwmBCysuXs9PTX5l/lyAG0mMfYdSwjrN+TS4ydL5SgjdP?=
 =?us-ascii?Q?ewhFMjDlHv1IAJoNe/leScYAjMUKATetJ7IP4RzafIyv+PPop011T7i768P0?=
 =?us-ascii?Q?J6Ts8LRD0eCNQ0WhGJAJbx+n8JzaAXLetbALN2ooeBeSEdczocpKow4VVqon?=
 =?us-ascii?Q?1eIUF0TTI7b2IPSa1GlaGaWDWkyX1vYVF2lLEswPOpsiFBr3XqlQs5iQHtp0?=
 =?us-ascii?Q?TaFXj1j0C+Zyv2QUK/NictWPAZDS4OvL6a1AjbHr2cwK7yIzDCttdEBy7/4o?=
 =?us-ascii?Q?5jrfwKk7tq7bbaLqJ4WPPnqwXTAZ05BNZKiwmS/zhAbYFNbmwgGrhAJwg7vx?=
 =?us-ascii?Q?ScgjMdjnDy5AcqTXyrBPTCOPFF5X0gxqSflRquoFTrr+q5DRrzfT/EZna7Hg?=
 =?us-ascii?Q?7cZ2NZTdiQJdWrZkpCaK2gsQAhMRcrfwwxEpsfYFRKk/+eQnGRg3FQh2J0jK?=
 =?us-ascii?Q?CfWO+pn0vvxog/C483eZJ7ZQYUVTKl/DXs7TpLbxKnvLj4eN3p+/XibX4eUQ?=
 =?us-ascii?Q?2peScguQHYnaj/Rrk85XXLfxUdihpGr8pOaGiCYmWRRoff2easAuMxO+A1t+?=
 =?us-ascii?Q?OAwnDHMV/iyHOuGjCc/62S2ufY4WCTt7bE/EU28GoZxvn7LQ+q0joN2Epdy0?=
 =?us-ascii?Q?FOrjYSDGNiIAmWg0ILFx8lYQ16XAvlkjewE+X8Uope1y5i9QN5JLD+PxKn0A?=
 =?us-ascii?Q?r9vj5v4FOpIfxasBYFs/+mGnpe70hKfG2iSmVrLGuqJABoy9W66wbNkwJ5Mi?=
 =?us-ascii?Q?kWlmuxs8hnSYd+5NrwKgwUZYYSpSh4a/uuW8crw6j9Kwiq4Zf5oDt4th+HXF?=
 =?us-ascii?Q?MV+ipzph0uy6kt+ctMu+THno4G2pNGi5lAazIrwIa15g7iPmGJgzhNVQBVzB?=
 =?us-ascii?Q?9LyMfC11WkDhSX8Ytu2RyOzR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee7ed65c-1100-41b0-9ed4-08d905ad3c83
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:39:45.3714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8/37xCfNec6AVig44sofAaKOWzIG84pSilRIRK5sY5r4shY7jTMuz6fSMwpoVlMcY7eYdceRGA0S3wrOIu+bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The make htmldocs reports the following warnings on kvm/next.

Documentation/virt/kvm/amd-memory-encryption.rst:308: WARNING: Inline emphasis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:310: WARNING: Inline emphasis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:313: WARNING: Inline emphasis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:316: WARNING: Inline emphasis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:319: WARNING: Inline emphasis start-string without end-string.
Documentation/virt/kvm/amd-memory-encryption.rst:321: WARNING: Definition list ends without a blank line; unexpected unindent.
Documentation/virt/kvm/amd-memory-encryption.rst:369: WARNING: Title underline too short.

15. KVM_SEV_RECEIVE_START
------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:369: WARNING: Title underline too short.

15. KVM_SEV_RECEIVE_START
------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:398: WARNING: Title underline too short.

16. KVM_SEV_RECEIVE_UPDATE_DATA
----------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:398: WARNING: Title underline too short.

16. KVM_SEV_RECEIVE_UPDATE_DATA
----------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:422: WARNING: Title underline too short.

17. KVM_SEV_RECEIVE_FINISH
------------------------
Documentation/virt/kvm/amd-memory-encryption.rst:422: WARNING: Title underline too short.

17. KVM_SEV_RECEIVE_FINISH
------------------------

Brijesh Singh (4):
  docs: kvm: fix underline too short warning for KVM_SEV_RECEIVE_START
  docs: kvm: fix underline too sort warning for
    KVM_SEV_RECEIVE_UPDATE_DATA
  docs: kvm: fix underline too short warning for KVM_SEV_RECEIVE_FINISH
  docs: kvm: fix inline emphasis string warning for KVM_SEV_SEND_START

 Documentation/virt/kvm/amd-memory-encryption.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.17.1

