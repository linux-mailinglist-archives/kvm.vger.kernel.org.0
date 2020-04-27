Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DEF1BA41B
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 14:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgD0Mz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 08:55:26 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:16686
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbgD0MzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 08:55:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BO2ZUI4Fe+ccSkfhzJ3pMqQaOaSgXytrhohJ6Npg8e6UIf+4PhZZCzUDm9ee/xS8qC5gU5G9yKaukvrPwoRmLT3otS4QqEfV25pUaAKpx0g2wVQxEypK/lR/yNrEeMUmX1Mn6kpZjutxj7hoxN+mMh20yk5RCEPu/dhu21sSb3YLxlLcTo3ZuoQg4LJsIw13T7Ga8/SKbEmf1j6Jd/3VOXIPi1xJKcGm1NYR+Xqdy4vk/pWAeUsBYC7iYHUNsQx1CE61yTGBGMJckD2Lki75tSknGSjU/F8VhfSSpKbffNz9d6SUkzxL82RSwrXCunU8mGvC2lb/ZbXTZvp1Q7YCOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFImOFr9UyGnIhMldRpFm5XJ3mAWuSQNKYvtiyt4u84=;
 b=SwET2paZyfHBnFzzoDl37949PCvnDCfdCzjrWOmB9R6E7rRBXtnSIuY7vBSYtoGUfpKjuE5RwxcoY82CRI+FxQ8MvuaAjlsinCAuSD3qfrcZiIQmFAjv2X63d97wSdW6IjMuVDzNR7KnrtkkRM4N3xGxDvJo2qbWmnIt+6oMWDERqcJXOLHVoNusGf+cgj4QtMlbb+SS+f4UCFLFTfsv3B1gCHxpM/THplqQjiPFsiHRPkcqd7bZgqUeF4GHKfuiAsR5GrZWLTDH+wJyK0t6oEztgnxmvt8ThFu5r++hQx0XA50EUJCvS/7PvAOWBHcKcRYrzHpvK8elFtKxdrQk5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFImOFr9UyGnIhMldRpFm5XJ3mAWuSQNKYvtiyt4u84=;
 b=aj8gmQmGjoCBJJEPMFR7GxW3xYYXQwYhITTcZASY/b+yp3UUjmDznZ3HK7I/LJfZl5TkuFzF/KmnC4Wt2DmetldgNL6x1gUdZ6UuwWOakADl40PHXzwpzmbM8y4PXIU/vfT29rGvF7yNzW5t0wqDyCxuVipQRJbl1BUc5eHuvfs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4975.eurprd05.prod.outlook.com (2603:10a6:803:5c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 12:55:21 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 12:55:21 +0000
Date:   Mon, 27 Apr 2020 09:55:17 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Message-ID: <20200427125517.GF13640@mellanox.com>
References: <20200422115017.GQ11945@mellanox.com>
 <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8D906E@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D8D906E@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0062.namprd02.prod.outlook.com
 (2603:10b6:207:3d::39) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0062.namprd02.prod.outlook.com (2603:10b6:207:3d::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 12:55:20 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jT3I5-0005Hr-6z; Mon, 27 Apr 2020 09:55:17 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 146a56ea-992e-4367-2ae7-08d7eaaa3e6b
X-MS-TrafficTypeDiagnostic: VI1PR05MB4975:|VI1PR05MB4975:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB497552C365A1148018C06054CFAF0@VI1PR05MB4975.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(2906002)(54906003)(4326008)(1076003)(8676002)(316002)(5660300002)(86362001)(478600001)(2616005)(7416002)(81156014)(36756003)(66556008)(6916009)(66476007)(52116002)(4744005)(33656002)(9786002)(8936002)(186003)(26005)(9746002)(66946007)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XejVNY712vCIk0Ev/gWh7uVnPvcethfJNvPGT9gHK/lhfguKsUqB5hpfvUni5OwuYDcbj0yYx32tQuZCgIkXJ4HopJhFFzD5FyPweRj94l9QempF5LFkd7y/FYdCMpkw4nuDZCb+HXNtDN5AfwWBSgOtfTvAw2PgjbWhnDfNxHuX3uG3+5ITN7aLRZjMEqSjlklJvAN/3xYHPVLCChWCf+xkg5fFP1R05Q6SfamqIl9bGvOv2OxGWfxgkNGrFM3bWpvjnVM3pNxFgNztZgyoaJXtm92H/D9aej024LKlkIwn7DExyQDOne+PwuryIxbxmo13Jbys5ALyP0jcnXImC9gGWlIaf7lEYmc5IvOb2LLEOXstN1iHfSX4QhFuWtMlUBichQ1TuQMLYzfhPrhDA7fWvOfFJv66/a9XWM6TCD1+bGEOncqWHU706AlXF3RWxgXZIKui6DmwmvKp9ApGTREeu/VGTNAywfERHv4OJiWILwj1SutN9X2yXNKqfw02
X-MS-Exchange-AntiSpam-MessageData: Wb+LnKAz2b/UCXm8Ze2RZ8mszentTEoihPj55MozOO4y4oaxatx1ATw8PBXqHt2wJg6wOJBbxTT1rx7KD65e3Sk+n/vx7FA3sw9EbRDA0I2BrC6B5rjfWykQj2xm4Bwg4esVT18N0+jFHmCslHC4jom+/EtrsIwUuwqqpVs5uJs8WqDU07PIk+5xRBmuiw2y4cHPeHylj+EkDD7LZHw+gSUtRxslqZYkyO+hUvtxEW4MKBUFsSbMrHE38z4h5EjmXD2Qt3aG5z0AbX/rszT++AsJST7tRaYhOdsqtO8Z9Ed0GB4l+wIUJxsZo1yVIuo3lyvt4jG9dyu0cUfH8Yg9M8JK+cw91wJltRf7HoVzA/DKKxW6gVPhM9BA/wXpUdzcjgzek+TMC/G2+Dw+Bf9DLvXxN/ZstlJNpKnVwrc5bOQDLHG0E7LaRV3C/S+uz8lDpOxWDALXyRJkzRzg75IgIvehgMZugZKa+hsTsuCh4FVvXsFxESQFqPlXnGGBeaMux1UJbuvZKRp/dku59AIM3q8naCbJ/xMku7CVQiSn4D1bR6bZIL2n5schLNsruGFcmBKhO1haSWZDL+zbiofl4/I05XdiEDyyLGw/2VcZ3Wj6bO6tQJTPdNZs02YGVLGtNI09WHXnTpsORDQpgKy1rCNFZcqwMg1UiwX36qMBL/4LIhfT18v4ONnFPYos2SCkymWmx0xkjSSFFyWk8GqgCIjaPJmLcxx4+KvszQkIZqESATU6na8AKiN1ccLrIljreJXaP6A9KE5MH7qUYCOGwE7XOvcUBAT4WcFnQlKCTc0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146a56ea-992e-4367-2ae7-08d7eaaa3e6b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 12:55:21.1793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6oapRO1F5UAj+SPqquU9rblq03ImkK4vf2aaWsBp5dAsSWzR9kdYsTWrHCy1dY2JMnQ8C/JFMldHm0aOZ5aZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4975
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 12:13:33PM +0000, Tian, Kevin wrote:

> Then back to this context. Almost every newly-born Linux VMM
> (firecracker, crosvm, cloud hypervisor, and some proprietary 
> implementations) support only two types of devices: virtio and 
> vfio, because they want to be simple and slim.

For security. Moving all the sketchy emulation code into the kernel
seems like a worse security posture over all :(

Jason
