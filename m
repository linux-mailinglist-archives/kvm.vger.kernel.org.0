Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F417323151
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 20:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhBWTTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 14:19:48 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7675 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbhBWTSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 14:18:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603554df0001>; Tue, 23 Feb 2021 11:17:51 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 19:17:51 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 23 Feb 2021 19:17:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7O4te2H0NiCD3JaEBl8IWRvvu1zsXXjPV1znlpTOPpm+juCQo1iTtt2uKt+Tlea2OeMj2VpMrdCVPJxZYywzVev7Dr4ftpV48JiksFkTZNuLnzR1QsdzbhjKvHdqI2NlZXZbINZagr8jHawE26SBvzPCg/SZjO+sWdvy9FOT1MdwQjJ16B6Pl5+BVjDZOGedM3RYOa5Kb7Gepw0kpebSZptgP80vqxi46VC3FQP/Py6218ZwFS1lQ7TbM2vm03Buvisl2LcvhA62pg4FW/PxL9babg4PHrwl3QTPXOAJqVKHvv4eWYXUrTIKTwm6tuCvOk5DckaK1muWIedQHXA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEvFFnG5G/GcMyoaDl1jgbqBRpvcbgg2WZ80/0T+MhM=;
 b=Ti2WT2lohY2mRmQk8yvAfgycYScPEKx+H1HTu+N75/4KBkUR1sWdvlOB8XBWI+7C/9TUIzTHts49WBWLrhcSojpVZfN1A5759pLurcoAi+Xy3sx2Nw2XloTMail5djHGK/Ex/u8nV5QpmnypkavYWMdIZ9IIHNwj8OSQcvTwE6PKYPVbuM4CXx3w4YBBuX69hA6n86eyHON3SQQ4OObbYUhW6GSZNf2pmckC6zvPt+boR3i772Mq+msuT6kBd4nskROJCZuNxzOV0MGbEV66UfkwhMINfrRFawzvT1VCaQE2GOVZ8hTxqH3axe9q4+Otw8pCBeK3FrJQc9B2Ax6TlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 19:17:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 19:17:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 0/3] Tidy some parts of the VFIO kconfig world
Date:   Tue, 23 Feb 2021 15:17:45 -0400
Message-ID: <0-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:208:257::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0057.namprd13.prod.outlook.com (2603:10b6:208:257::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.9 via Frontend Transport; Tue, 23 Feb 2021 19:17:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEdBs-00FUTT-Gx; Tue, 23 Feb 2021 15:17:48 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614107871; bh=ezgvw1LUjTmgiG7YLWyTtj/1hC/Tex+d7AIF5J30xd8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Date:Message-ID:Content-Transfer-Encoding:Content-Type:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=PAOvZgeYw5zuG6ygbyct1Ni5+rVQieaXvJ+Uzf8UfS3MIfzKvaGQFe3N21/vpaBAC
         ZBZCHQpL6t2BW7lPM8zJ775autqP+/uiKYgKtyiSsuX3W/EH4m414dL+eLKbbQPn88
         2s6neaheKR+VfEjlD61fH/HJKhMoT+iKd+5xOp3CMW9P6bA6t1h0GzAk1toDnVjKP+
         6V6TVOWFOwtS88HOGoRy0aXQ8W548uspdhMJ0aUCrZyi6HHMyRtoC93PWO/F4lLegR
         Z+qOpSYtqKH/TL0rgJPMx0fU1qH4+QBrldTnrUkMb6yXhN/4mud+GVb7/rylkk9jRb
         a1L+Jix9icvdg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main goal here is to add enough COMPILE_TEST that an ARM cross
compiler is not needed to be able to get compile coverage on VFIO. A
normal x86 compiler with COMPILE_TEST will do the job.

s390 and ppc are still needed, and I'm looking to see if any of that is
reasonable to change too.

Thanks,
Jason

Jason Gunthorpe (3):
  vfio: IOMMU_API should be selected
  vfio-platform: Add COMPILE_TEST to VFIO_PLATFORM
  ARM: amba: Allow some ARM_AMBA users to compile with COMPILE_TEST

 drivers/vfio/Kconfig          |  2 +-
 drivers/vfio/platform/Kconfig |  4 ++--
 include/linux/amba/bus.h      | 11 +++++++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

--=20
2.30.0

