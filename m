Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B425D3D88B0
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 09:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhG1HRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 03:17:16 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:20321
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233514AbhG1HRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 03:17:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iD2m9tmdMfFu0fyMrrC0JFzkv1Enn318ExdfwOgdC/YTJC5b9sNMcMy9L+CumbbnECVkQdWtQ6FU4P+2tdBPHBKc/KCs6ySQMmc3iM81NaI32wvXk6MvmyU0kp1WXVpnAMrM9SKDPzQ5gZXOQcEVxclXWfUTYjqgis2C2Eqd1DY/FmDFWMOpfVVckdqJM67t8lN7NnX+CqZXcdVFsLbLM0P2560wdlOzLURnAPqUPyPlQrXl7WRoKq1r+j45gvhIz7rRJ7pCvSjcuKf3T1B5NbBIQh6HXAW8O0+Y3OeRPNjB5mblFMExm5he7lmtMxgAy91/Jn9FONhFeuDwROOh1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvFXaANcq4R4aCRauFDa1l+OyrNUw6WNiqMyvm1CIqM=;
 b=R7SY1KbVmjeTy2N73SqETFFjjUD3KdEWl/47N53ZNZQAlH57ygAZT1NM4g0N+5U8tdFuvLOZ3fOvRucALPUN815sjjGvaYgyAL+AN0+zaz6xrkPtrxw6cytg4rZPJO3yewHEGPs8G2QV/9O/bqbHjpJEdd63m+5I+10hK+UfbJ+Py+kbqm+W9NoCaPVPOmxGj/lvg/kwny/Nl9EzREsn0zRwKFVKrYKSs2fgkTFDdRRIBy/6TF7zqwVmANj5WIhWVSQCFdJKHqQ/KEnUxnV+rUHwsWAs0NEQmvprrphS9MIYNCMWwyOmUd0LcrcSY9SxQxl/VZp6Qf3fubS7X9FAnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvFXaANcq4R4aCRauFDa1l+OyrNUw6WNiqMyvm1CIqM=;
 b=XNQrrjDlhZs52BZeVsnXi+MsIIUzPCGZAT8LlJGD98zsaAFfPbSgw0onHNnXOC7uHAWthjT4TkudiLWBP64y5CQCJ0P/WXlRUHGMJPQTWS5bL41d0TE6k/6DI24ePXHt5HXC8Eju2+ijSl90NzFfnacNtUCKm2kEKKAZhSvZ5KKTK5wmCNf1H9pLhHaWnBuUIYV8VQMZ5J2jf6UdkBuZGiyWVVcDAg1JlHhyFeyla6SNFVh969Ii5S8lsaDRq8m5TzU/F6ObJjqHZJCCmMpKgIQjw5rMnliL+35DACZKNEqG+c7T3hARWspdMqvgVSbIGskr2LRPCQR4pW9crHbb0Q==
Received: from DM5PR19CA0061.namprd19.prod.outlook.com (2603:10b6:3:116::23)
 by MW3PR12MB4556.namprd12.prod.outlook.com (2603:10b6:303:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 07:17:12 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:116:cafe::e0) by DM5PR19CA0061.outlook.office365.com
 (2603:10b6:3:116::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Wed, 28 Jul 2021 07:17:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 07:17:11 +0000
Received: from localhost (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Jul
 2021 07:17:10 +0000
Date:   Wed, 28 Jul 2021 10:17:07 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, Eric Auger <eric.auger@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-pci <linux-pci@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "Linux Kbuild mailing list" <linux-kbuild@vger.kernel.org>,
        <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
Message-ID: <YQEEc9bGA/H75mv8@unreal>
References: <20210721161609.68223-1-yishaih@nvidia.com>
 <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com>
 <20210727230941.GL1721383@nvidia.com>
 <20210728054306.GA3421@lst.de>
 <CAK8P3a3eSVoCYToP=7cNv97DO-fjV1G6a=-OnrNhXhsbBVU7Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK8P3a3eSVoCYToP=7cNv97DO-fjV1G6a=-OnrNhXhsbBVU7Qg@mail.gmail.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d240f5c-2a4b-4c1c-ffe1-08d95197b808
X-MS-TrafficTypeDiagnostic: MW3PR12MB4556:
X-Microsoft-Antispam-PRVS: <MW3PR12MB4556E89F03178F37675D5DCFBDEA9@MW3PR12MB4556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+SyYBp9nb39cNsfNpqjay22apbxFx/Yf2rRaM5ayJ1sIQmHSEXkW0tbicSj4RKRP0Abulv8uZC0meFS2hEZdOwU5QqNy7HN6iKd+0YpTHizmjRjzLldnkExdCmhVwDsTfkcHr9YQa4PshSgSAteRYAyDvT4umuZZLVD+EPykLlU2w0ynxy0kyiXQByozFPSsuoTquF27wwrRxi2Jbgrnz0pNyziKbuCtpCyWocKnF18+iqS6KWfW80yMSUL7oyBR7wX17o+1e0vm0hbnR+tVshVQHHWoXDYdQQWMUkjvzkoYxxorFyvjB6h4289jYWTglTQsyCRYU+DO24FpC+/8UNH48mBkPUrOzTyYk2jRWu/05QjerPqcLZ8C5N9XNPMiPAplKyk2SetLzBavSmxX9vM9HohHQ2+4BACMm+kj0aDapfzJFMa+Jb3Vm20zwKR2QnSwVLifIm9hil7J0i6brfU4+DUiUok9OHp1cwiqsJiiYp0qaVYDwYJdtDSJpNhDv5JZ25V1UPnp0iOd1lb4vg+qj7dPFY4mR9r7KGd9ka9H2YiBI1JGotEm+W4zf8S/qYlsqM1OqfOmz9CCUqaTO3RQwFQ5A7KmcQkPZ8PJ1QUmTkr+BBsF7c4UG0QE++aDcS81VT006ME8xIpQtMZ45FltEy6jejD4j259CzGwLjIELkdq22XxCmP3z62YpZ8sijsIE0KN9IBMeHNux2w5A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(136003)(39860400002)(346002)(396003)(376002)(36840700001)(46966006)(82310400003)(47076005)(86362001)(107886003)(33716001)(54906003)(8676002)(5660300002)(4326008)(356005)(478600001)(7416002)(53546011)(36906005)(8936002)(316002)(83380400001)(70206006)(336012)(2906002)(6666004)(9686003)(70586007)(6916009)(426003)(16526019)(26005)(36860700001)(7636003)(186003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 07:17:11.8135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d240f5c-2a4b-4c1c-ffe1-08d95197b808
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4556
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 09:04:34AM +0200, Arnd Bergmann wrote:
> On Wed, Jul 28, 2021 at 7:43 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Tue, Jul 27, 2021 at 08:09:41PM -0300, Jason Gunthorpe wrote:
> > > On Tue, Jul 27, 2021 at 03:54:40PM -0600, Alex Williamson wrote:
> > >
> > > > I'm still not happy with how this is likely to break users and even
> > > > downstreams when upgrading to a Kconfig with this change.
> > >
> > > I've never heard of Kconfig as stable ABI. Christoph/Arnd, have you
> > > heard of any cases where we want to keep it stable?
> >
> > It isn't an ABI, but we really do try to avoid breaking if we can and
> > I rember Linus shouting at people if they did that for common options.
> 
> This is handled in very different ways depending on the maintainers,
> some people go to great lengths to avoid breaking 'make oldconfig'
> or 'make defconfig', others don't seem to mind at all.
> 
> CONFIG_USB_EHCI_TEGRA is an example of an option that was
> left in place to help users of old config files, another one is
> CONFIG_EXT3_FS. In both cases the idea is that the original
> code was changed, but the old option left in place to point to
> the replacement.

And here starts the problem, when people treat their obscure config
options as first class citizen. The exposure of CONFIG_EXT3_FS is
in magnitudes larger than CONFIG_USB_EHCI_TEGRA.

This is why I think that is generally bad idea to leave old config
options, most of the time such options will rotten for years till
someone actually will notice and delete them.

Thanks
