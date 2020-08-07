Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A792223F2D9
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 20:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgHGSje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 14:39:34 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14304 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGSjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 14:39:32 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2d9fb10000>; Fri, 07 Aug 2020 11:38:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 07 Aug 2020 11:39:32 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 07 Aug 2020 11:39:32 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 7 Aug
 2020 18:39:30 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.56) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 7 Aug 2020 18:39:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RukYmoJ8Lo85ZtlgoY42H85gbJXZ8A/AyhRbkr79Dj7t09DwSah5a1HCTuWXMLK7OTopgi85JIEEKv8ZE04GvJsZaRJe2vi5lSRHW4s+aXMIsstoxwnf7Qp0NVauTMrqteB6txzwDdXpcBK/LoSTDRbSCgpwwcc4UdY4cQIbk22mK2aYzm0vYGspOPzv0sXO1+v+iidB8Cqveh//GXUOd/Yegkv5NajwxZS+XAQVM+RvdNsiLYnsoCdYGsgaCdIPvWQL8T2UP0pTw9Wb6bH3JRXZc5YTdLx0TP7IByvLNlhhdc4rGcYVXj85YCiuqNw0h6+8MhbMsES4g4EbMXpoVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSedvlXCbDmzOblX/9NK3RwxARgxvJi8yTM9k8MLHb0=;
 b=lTVi4lkhDS+Hjpi7JsqDvjkj9ip2/h3pV0xjNhk8EDFbyRj/wjq/ZL7UDVbDAD08xXYeVeRqAepPuQubR//Re75bhIFn1KBMbQdSWi1zMWNoUrNlfd/NDUjua+aaT//kIN52mbVv5y/x8Eb5c9orLabM4kxNCnwtdtMmyKE3JyUvzSv2vfbAY5ag5zooQjsjdd1lglKuaoN6ZoblWhAa6dsBQp3aOJE81IP3MrwuhSmIGW85ZijzEMca28fMafZtEbGD4wpLu6wxbiWq4d6bDus5+1pLKvLaovWxhbl9OyGT20z36elLbqnlL5BBmMnMBGlZULJISuc9pEWh6amTdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2583.namprd12.prod.outlook.com (2603:10b6:4:b3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 18:39:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3239.024; Fri, 7 Aug 2020
 18:39:28 +0000
Date:   Fri, 7 Aug 2020 15:39:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Dey, Megha" <megha.dey@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200807183927.GY16789@nvidia.com>
References: <20200806001927.GM19097@mellanox.com>
 <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
 <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
 <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
 <87h7tfh6fc.fsf@nanos.tec.linutronix.de> <20200807120650.GR16789@nvidia.com>
 <20200807123831.GA645281@kroah.com> <20200807133428.GT16789@nvidia.com>
 <87v9hufln7.fsf@nanos.tec.linutronix.de>
 <d4e3ce5a-c138-2ebb-06d1-52ef57d987e6@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <d4e3ce5a-c138-2ebb-06d1-52ef57d987e6@intel.com>
X-ClientProxiedBy: MN2PR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:208:236::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR05CA0039.namprd05.prod.outlook.com (2603:10b6:208:236::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.5 via Frontend Transport; Fri, 7 Aug 2020 18:39:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k47H5-004oPA-6I; Fri, 07 Aug 2020 15:39:27 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1de33126-ae2d-46f0-97fa-08d83b013784
X-MS-TrafficTypeDiagnostic: DM5PR12MB2583:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25830E1DFA0F14DB4D99FDC9C2490@DM5PR12MB2583.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqJkOZLIGTQPDdOa/Wae7QbHVKidL28w9W/onH3vEpeFd89luV61ZFp3ebNz5jp1Coywq+SB719AQavae4K19mahNHIOfGnqfsExRpnBfg+7InZhp98oRgK3ST/wBwuH/tWmivCt0AH4wYvhJTbULM23uk1cur4e+wEMY5olXkX/1RVlywlaGSbSsV17gW/K0OV9u3JdvcymxrXMsrgP/YB+JwuvXo4HeMOZkOedug0O1me0gNtu+pF/Hntwa469vUg3Dnhftkrh3tprTcF9s/WxufTtDqOzgPkWd4rbdfChH40PNIfiYIU2Ov4yUBh2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(9746002)(9786002)(54906003)(66556008)(8936002)(478600001)(66476007)(4326008)(66946007)(2906002)(36756003)(1076003)(33656002)(316002)(8676002)(2616005)(6916009)(426003)(7406005)(7416002)(4744005)(86362001)(5660300002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QdgxuRgzxrQKFRtoD2QrnkOFnZTeCn++wsw9Vf64lQcV0pA9uzFO3SLqXTRo3W4QhDb2r3s70mCHbvBCI6Le55aAZJqwBd3rIRNMs1+5iI2/QcRestHazqJmZHYrJ6849d9kX8ib8Pu0Q84aVgdPYuM8o9IbDv1G6Ob5ujlezsDXsZQQGTf7O58WKF6c/ITWc4xN/y3cUiaUYQMBbGDYN0Dn4V0CyNUWzU/PvpKi9ilkqmHBt+nUKcIjW692rl76Ff2z4LNfpoyD5qpvQ5yl+6xmUwFV/+Rsb8styG9QjRmP3PiT5/wvT2vZzaxHIJ8XtrFCHm2dhJnSA4+kwM4ChYb2BZB98MTlurXKU/UYE6SMdemHs6UcvHvJixfBjFKXYcxjYyysQ+vpVXuGozzdE+JsmuoyihGuSgVi4f00JUNQyKO7qvsOu80CVha4Vp22LB98AjUSWUiVRMY1XM9y3MTYNsC8sIMVxn2lQByYjaG+GXRukuMnq4r+FJn2CGygaQfcebRR6GhZQCuzJ9vYaNrtpwTN3e1zZ7n+RNuKHeUeDmGQHXzjWAIikilonOET/6LU4NVuwFgCz6Z/YgXKw+Yce+cD+4uEvgkJ0vPen5nxCDvpWM/xOMhC3UXMV3gax/TqP5aYdXsW9Fp/8k/n9w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de33126-ae2d-46f0-97fa-08d83b013784
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 18:39:28.8925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCIxTAbkdDckG9Iu5G4p6sT5n89I/SkkwXkbr8AaM72dYK84UOstqxF0oPenE9/K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2583
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596825521; bh=CFpBs/oDEPdjTRVHVoJyZycTlbnk0Z4tOWvHDqCnsNw=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-Originating-IP:X-MS-PublicTrafficType:
         X-MS-Office365-Filtering-Correlation-Id:X-MS-TrafficTypeDiagnostic:
         X-LD-Processed:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=R4kYYWeZe0zvR0BuXjAHCRUbn64jTSAtTWBiNNkg0ee2gwYdG0VuoBR+Fd1dJDbJS
         lYnMdqnkfCsY3aWV3Yd+48j6rzIYGWtfbHPDAAOFL7Y6/oSIa1SLi+ZiIz+BplQYKf
         1Y9LEB5omXjqP8WSUk/bpdXkxYfmCnUk5pPFrNTIBBLCvNoC8U88z4qUKAux8sTOGr
         lx1XGpto02Wn8z7szo2LJi1P3I6Hav/5V5GkR78CdlfZDCW7XLKdp7TOjHEKj4M5GG
         PkYDX8Oszd/DbAx7e/KmCZsoNH6mysy3zisYpz8cFc1o3ZAjlXYd8wCr4P+6MF8Go7
         DpQ9DjNxENJdg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 07, 2020 at 10:54:51AM -0700, Dey, Megha wrote:

> So from the hierarchical domain standpoint, we will have:
> - For DSA device: vector->intel-IR->IDXD
> - For Jason's device: root domain-> domain A-> Jason's device's IRQ domai=
n
> - For any other intel IMS device in the future which
> =C2=A0=C2=A0=C2=A0 does not require interrupt remapping: vector->new devi=
ce IRQ domain
> =C2=A0=C2=A0=C2=A0 requires interrupt remapping: vector->intel-IR->new de=
vice IRQ domain

I think you need a better classification than Jason's device or
Intel's device :)

Shouldn't the two cases be either you take the parent domain from the
IOMMU or you take the parent domain from the pci device?

What other choices could a PCI driver make?

Jason
