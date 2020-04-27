Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29371BA484
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgD0NW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 09:22:28 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:6025
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726651AbgD0NW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 09:22:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQMSnmnt98/OKT55m5usudNiHoSHaMBeIBe/hTZrebaKi6Z5HFxSyOI/koq32a6+nTBxn1x5/uESD6frJzA9nh5fN2DsiKSEtV9te84YpwP/dCNdFNyirN+K2Ip0M7lHekmpYKPnepRbHMoFxmfgkoHzfq7TVdHFgwFCR8Zl+Lv+yjfc4FefGQfgdVTRRWNKxO5Uv/isfNYg2R1QhnL+cM4MiYcjFI9Lyc7WfB59am+8B7jr1GFPqSIbrN0P8FEHSchy5S9pMXtplbuZ7Gfe97DPL5c3RrPVIPGz/mrDgW3P/oJndfHFdbylDXz1KAtRB4KYziZ1cQilDnkDwtqgXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUA7BtHdVi6/YBBuwQ66BkgS/bRPHzwcZ+I3Qs66TdA=;
 b=ICYjQCVKo6+iU7LcsVeTxwuHDuyIj9f+own5ENhrAet5QtzysoNA3lEBlPbUFL1AbwHW+k8NlA/5UeVhUJ0gjXVkFF3D88elyM/J/rJ2zm3iqotXk8eSCuh7Fioxll+dhXO8LW5dRUk5DXrokjkll6ur6U1OFVSMlLOcLuucRE85FOQJfDzrM75jxKx9A8TFP8HpwfUpTkl4/xTrG2qyOR1fzpgx7/1f5aDtPxQayqbOdnxB9LdkdRpijXb+FU+xQ8nZpN353t/96AGuO+6W3PLpReVF18NYPYK+ZxVSMoWQb5iyqF7O8dFYxQvK3b2BGXghwn+JrY6yccVOlY7etg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUA7BtHdVi6/YBBuwQ66BkgS/bRPHzwcZ+I3Qs66TdA=;
 b=etU4yFKtrRtTjK5R4Kfv/xo5R0D8FNhepje8LRiCMZ458RamLbkBUwyHcNobxVQlf61mIPfkoUzoi6HmxyZ/+FVGPdwYvAechavKcvCyPTMaU7CmG3bB6K998Ony67POFRCZfOlkDzN5xhvSoSv3Vgrmg0T/j+CFFCK6ojJMgJk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB3470.eurprd05.prod.outlook.com (2603:10a6:802:1f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:22:22 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 13:22:22 +0000
Date:   Mon, 27 Apr 2020 10:22:18 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200427132218.GG13640@mellanox.com>
References: <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427071939.06aa300e@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:208:134::23) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:208:134::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:22:22 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jT3iE-000665-Ib; Mon, 27 Apr 2020 10:22:18 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45582a51-9828-4855-cbf9-08d7eaae04ca
X-MS-TrafficTypeDiagnostic: VI1PR05MB3470:|VI1PR05MB3470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3470B66E0448EF5B054FDD2ACFAF0@VI1PR05MB3470.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(1076003)(86362001)(9786002)(9746002)(33656002)(8676002)(81156014)(2906002)(8936002)(36756003)(7416002)(2616005)(66476007)(4744005)(66946007)(66556008)(186003)(6916009)(52116002)(26005)(5660300002)(478600001)(4326008)(54906003)(316002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LghRcKWImbuUtTjSsd5ajft8XUdIH6zZKrhmqp9gD5DlIY2GGv3nG453LkOkyvt2EhCc4/vJGTWgoM8DkEz7iW3Xl6+PgFWDI9kN/WSsYcbB55n6CjnU22Wwik+vUwQnVa5yP1Pmr99QKhdVgb8KwfueBFtMaPcPnMOUeIM//9LvVzoSnRECH4DsrO69enhDLDHo6ksiBur4iTG/gzX5sj1t4qek2R34CzodKN9dCKHNN1gPG/aFlYwGLobJ+vTFPNkPXJP1bXvJqlO0uD6vWcT38tR5pPrcw7sS5TMcr6MWEmPqIHGL2LVePsJLD/SYVz8OUrKm1tYECVmpqAt95Vpswb2flmlhUMFqKtPe7fmN79AE7GBEbdC9GHKq/oDlmziLEjnuI2P2Zt1A82CXDKHudalC8DUdiatFTP5tZc3K8kloPoIWtNN4PdblxZBMEuxwXvf5cBmOhKExgxpHKkszrsRHAZ/nIPbBw/IAFNut0eyIT8NpJ+SwA0mPS18Z
X-MS-Exchange-AntiSpam-MessageData: SmkW0laNse18vQvLYOdpGxISqiDYQkStjtC5gsfFTz+9rFaJVGjWQ01RNt+C7JRpxkAtPskwgUqzEBrk5Vhvxv2Pca3xLwngAVyhwbukK3Cmb33I4ssGn880A+lsXt7V5Hc4D0taDO/VrZYYyYVwluViGKFPasz0hnWbHBf5Wp3AoNFEukeOBjtkebxMRJZWRhTtoP+lrunE/5VcJpIfhw9Q87uZkAE3kW44KkD8GkkdBK34L/xaZY3iJFv7vqosF3/MP8MqgzqbnUbb4AC/ZBS/nMugzfPwA1YHR9DIOfmY/FscDoaKSZjeWcgdAdSLFYetTJPHDXldt8wHrqewgzemyaMx7xrKUzqtZ5Ga2RuaxBmyOEvoh3ZEZd5KK3vyKseMSXrfgVBGeJ9sTmIzljM/QJPGGWoxF9GAxG3XdhXOhPOMAQjv5Z/grT52X8ittxYfjqXQfl/ic+fQ2IxNFV0/2V5VVBwCCv8f3F18mFEMnCjDWkQjg1lLrOCyGLIcrjPSXoeuD0mrjwbjXRmWppqjUhl/zVxAl8Duug1uXL2TybMKyWz20Ln/TG2QL1jUhrrkNziiN8EZCv/29jL8snUuxXzGyN3IhEdtlcGDJbo7cS9WpJqPzY8AVsqqKIQw936Qof2CtUpiQJfN0It4SJ57WQKMAn/njQDVBpNWVCquYP20/em+a+dBWwERc2XfsNoIfBVfqUx9Nwf/ngIUituJtn0xw17SlLfQa9ZwvuAMHsT8d3e/aVopqPNhUjfdS1w3niiZ8xL03WCf1ASjXuZBhUhPruf8eVYAm6G2f4U=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45582a51-9828-4855-cbf9-08d7eaae04ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:22:22.4261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcTQCl5GsCIdV8cdLI8EOTwmy2Ih6ffwvh3fnPac4qWliZ9SkGN9AC9KlTd9LeELKhhL6lM+gCYlz/rtSOcYXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3470
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 07:19:39AM -0600, Alex Williamson wrote:

> > It is not trivial masking. It is a 2000 line patch doing comprehensive
> > emulation.
> 
> Not sure what you're referring to, I see about 30 lines of code in
> vdcm_vidxd_cfg_write() that specifically handle writes to the 4 BARs in
> config space and maybe a couple hundred lines of code in total handling
> config space emulation.  Thanks,

Look around vidxd_do_command()

If I understand this flow properly..

Jason
