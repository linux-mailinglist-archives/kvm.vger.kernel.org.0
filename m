Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627CF24842A
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 13:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHRLuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 07:50:18 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19029 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgHRLuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 07:50:14 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3bc0390003>; Tue, 18 Aug 2020 04:49:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 04:50:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 04:50:11 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug
 2020 11:50:07 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Aug 2020 11:50:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxpYjlMKttRqKyY857IZR/lVh71lquCm0coEoNavj0Wset8JhzQx4t0L1rp3dHfTHCA20rqyzlDwutZTQJx06T6ay0Q7nmxVisvhhwIZnItdNmMf3QDdfdIQCShCdTy37t8xsF9dbSDjpxYBcJIjHhUConWgkVT3uG4aIchKq2oTvmOemyDYVtaV7vOrx9dTvydCdLlNVjXrZYwr0cEiysUr3A2xX+0/CncE4vRlbDCboB7mM+Oh1ZABKTTr4Ht6RQkvrapUAaY/TZ5z59EdBnOlNd69IOr0jSc4bSrRRNqzrvfGVGIJG6X3tSZvjqxQSvQt4oN3ZuXlRbmY3LLRuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCdRoX6M+VYwEwx9LsISk2ebQUNm597npsJ8PLUobO0=;
 b=AlPwQYxIvZ3Z9XaaRU4iqTS25WpKSPs68SvMiW5dNOzmDVt1OOKKH1l2Q15zy28Amb48ust7jvvSf75BxKXs+O+kD+1f3Li2+KAohEhEhGRO5+67w/gT/TVulG/fkh73pl3iGhHvE7uMzw86r3umyl1bMmZdBZPfmskgAynBs17TpnyH5NjZqXKPd1G80iKY2b6vFy9XYtnb0LOghiUk7H+p3OnO/11uSVoNkMFuJlvDgs8B6rPV4S1m8v4R2d60kSZAAiep0m0dsTOZo/CsqZU2i48oxi8pE0rKa59YsbWzQW+IDH2PtZW9IejyodZAVqhRdNeIGGmHPr3YdSd8xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4546.namprd12.prod.outlook.com (2603:10b6:5:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Tue, 18 Aug
 2020 11:50:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 11:50:05 +0000
Date:   Tue, 18 Aug 2020 08:50:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Message-ID: <20200818115003.GM1152540@nvidia.com>
References: <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200814133522.GE1152540@nvidia.com>
 <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200818004343.GG1152540@nvidia.com>
 <MWHPR11MB164579D1BBBB0F7164B07A228C5C0@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB164579D1BBBB0F7164B07A228C5C0@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0049.namprd19.prod.outlook.com
 (2603:10b6:208:19b::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR19CA0049.namprd19.prod.outlook.com (2603:10b6:208:19b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Tue, 18 Aug 2020 11:50:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k807v-0087US-6m; Tue, 18 Aug 2020 08:50:03 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f470a647-2555-4838-7c95-08d8436cd8bc
X-MS-TrafficTypeDiagnostic: DM6PR12MB4546:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB45461BFF2134183180CB5D5BC25C0@DM6PR12MB4546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oxffq8qYkTZw6U+PVg3E9uPeP/qtCbceu9faVQY2A7Sp9tEOZrWOX/zyCQdyaRZdaqaEQ/MiRPKF80R2RQCV03m7nAXEABp1oNbrdJuWXsintBQrKrJun01HAc9iPDaNmGFsWtpVP+KY95aYpQUg5b2HgJherDa/BfpmEW+SMUJrCwyelyTPGDfASRdKG6TBj9rH9DLh9HU6ssL0cYKQND1PxM/+H6xwmmXcj7A91EAXrwjwDpKKbM2EpuUtSj5vXTXj1R13WutigQ+tiyLJy7GQhU1x+/wifH2JKCZG0+BVFoaBrRCdI88qBja5zCYrvdQVVKQRBXupEWtp3lq62g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(4326008)(9746002)(9786002)(8936002)(2616005)(2906002)(26005)(66476007)(1076003)(36756003)(66946007)(478600001)(54906003)(66556008)(426003)(83380400001)(86362001)(7406005)(316002)(8676002)(33656002)(186003)(7416002)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ibakSZHFwe1xI04EVhlv+19mAGB1qgb85B5kUlL3RXtMl3po42CKLE3ihqIvzPXbEgNSwXigEboZqw8UBbow7Jx/bSf3rZ92m39zMWJa6CSOHztP09Ts/zLtUVHuPPg7Agubw7tPj/KigUNUkOp4f96s+poQEnhW0V82ceH9b0T5jLAri3mDbI8QMGA8+qVb2RlygWaV6jz+J9a4Xdythnfj5HRRcEazfn0hZu8c+z8N9hjzFa5OJswvLzHdzVo1qH2RbvNAo+0uf8KkmeQ3Y7TRIs8GquZTakOhZc1x2Ronx0CTF+1a9dX19N6aH/qbu3p25SAGY4Jt6S27NpxYb/cBgk5Z5iIt/5y1Xd52X7l136zOVrrO15F3LYVqaxBkSuQNtxLEwEc5wjHN0pqe2J1RHwZ7DMI7aWchaoDm1smLbbayDjxBLYSGlb20PGDCTaS71QO15Y66/+AK+GBjZCroWenXRmHJfTL/BRaz39EdjQE9RXTTRp3jDfMReD0fQf/aa5VWo1VMVAwkskOi1Tds05Xek6kIV9iIW6KyhwzqHpN+KQ/o4OermZ3ZUDT8HY6Faif4pM28OPDdCGN2ZzuwLwjh9658/uRJwGiY7vYrpmGTdHR9WoGUcih0Sjs6cD84+MFpYb5oUWlQlInqdg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f470a647-2555-4838-7c95-08d8436cd8bc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 11:50:04.8213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gI6lMYhFkLwlnx4Vj0fteAMHPh0SZEHDf2z1NS9qzwIItQizdCZsF4/l88NISNg1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4546
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597751353; bh=YCdRoX6M+VYwEwx9LsISk2ebQUNm597npsJ8PLUobO0=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-LD-Processed:
         X-MS-Exchange-Transport-Forked:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=eNNpdaCOVXj22taMwn6CHOKlB9vjJA2mQK1qD6MEe5FCkSQZBD+Qr1aur41uSZaM+
         zHkCtbklXKyANY/o8rAZx+r82icT4cIq49PmVaxcdCtIvzIpzrOFugk136daeIe8hx
         Ijvn7PYxwFD15phBo2SoGs9jGBzdb4E2d2P109PR7bdTNC0GcD4YeEu0ZyadK0F6Wg
         qDAtLW16tIh8KOqfT6Ojef/r+ddKOfTf3nt7bEjl7DdSKXNCigUZz6ljhg8WDPmPfT
         8LsDcr7qtgZHSuRCcxOCHwvmTj/p2p5pdnRTWJ3WHFoHIaj+fczRG9Q0yz3neo2eJg
         yBbI5IpGjfQ6A==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 01:09:01AM +0000, Tian, Kevin wrote:
> The difference in my reply is not just about the implementation gap
> of growing a userspace DMA framework to a passthrough framework.
> My real point is about the different goals that each wants to achieve.
> Userspace DMA is purely about allowing userspace to directly access
> the portal and do DMA, but the wq configuration is always under kernel 
> driver's control. On the other hand, passthrough means delegating full 
> control of the wq to the guest and then associated mock-up (live migration,
> vSVA, posted interrupt, etc.) for that to work. I really didn't see the
> value of mixing them together when there is already a good candidate
> to handle passthrough...

In Linux a 'VM' and virtualization has always been a normal system
process that uses a few extra kernel features. This has been more or
less the cornerstone of that design since the start.

In that view it doesn't make any sense to say that uAPI from idxd that
is useful for virtualization somehow doesn't belong as part of the
standard uAPI.

Especially when it is such a small detail like what APIs are used to
configure the wq.

For instance, what about suspend/resume of containers using idxd?
Wouldn't you want to have the same basic approach of controlling the
wq from userspace that virtualization uses?

Jason
