Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEB51D12EE
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 14:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732153AbgEMMk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 08:40:27 -0400
Received: from mail-eopbgr40040.outbound.protection.outlook.com ([40.107.4.40]:14094
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726081AbgEMMk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 08:40:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2kjvHymW4tDRyYrH0p5JYnqU0vRRn+/VJJZciuWzlpt+YashS5etHis9b8W2V4IxQ5s2JM/GKf/HkPDiBNhFNdqWl2mkcv5o1yCZ4mFsFq9cyykzOHxBnr5H7O4zGDoHLaMLmUcuwmg/HlxVVGWgL41yZCgg+LXaPpXBNEGLI2RWo0aQwe/L5PR1bFr0dLsE66SZeXfW/xhlBIpLes7JeRWZmgUPrpOzEBeu/uEN1e9X7MgYRKqOBB324u577id77Dji6XiC1yyDkhEbAcvgh7ZRQ1ILgbOL6r9ecSAn7eJ18lXGAO4abDBaHsxr94Hv9q+GyVPNmiXs9PG1ph42w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmPEpvTqPxjr5reJpfzeUxLrpuW2f0+lcXHzCdTnPq0=;
 b=fwfq9h0Q1WNPuerNrE8xzbVPFMgbJus4q+eJr0dLeEsPxncol/hRXYicKQM9oBRjsKLNoD4VJK/xpOCPQGH55BtAe8z0o0FTw9lVu+e0Tklxh0srw6ujvnR7VPCO9MHVa0/qS7e2L2cY7fIH02g6AMvHhuQWL7Fe3ekxBTTlYNlqGzeoV9R7f0YY2ohv6pJbhQ45F2XWamPnFqoCSxP09mX6rRKO01Z3I4f5GmQo9E1eMfe3iL1Chudjmc8pxsN0lMIZOaBrc0CnW0PmpwJpXaBRTfdzvGWWhEBQB3ml5h4zx9TY2wsL5XmBTC0/7zJs4ZM8KrX0zvxNQJOk/2MYHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmPEpvTqPxjr5reJpfzeUxLrpuW2f0+lcXHzCdTnPq0=;
 b=Y3oc9RLhcatilMct7ROAuGR98XPEGlg4o5Er0HGVWm1VxRWpAexhyPlRk3GZhoWbZ2d1vMhgfly2HuGLzm+XB5c/S0BudwvQH7fU27doCOZfFnsVkmQzLpDza/pnWrB0MPBfTXWumfOP9fc91c0eJL5XpMQsOcdYJtnBLqvhwqY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4477.eurprd05.prod.outlook.com (2603:10a6:803:4a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 13 May
 2020 12:40:20 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 12:40:20 +0000
Date:   Wed, 13 May 2020 09:40:16 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200513124016.GG19158@mellanox.com>
References: <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
 <20200508204710.GA78778@otc-nc-03>
 <20200508231610.GO19158@mellanox.com>
 <20200509000909.GA79981@otc-nc-03>
 <20200509122113.GP19158@mellanox.com>
 <MWHPR11MB1645C60468BC6C6009C3DDE28CBF0@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645C60468BC6C6009C3DDE28CBF0@MWHPR11MB1645.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0075.namprd02.prod.outlook.com
 (2603:10b6:208:51::16) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0075.namprd02.prod.outlook.com (2603:10b6:208:51::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 12:40:20 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jYqgK-00088w-M1; Wed, 13 May 2020 09:40:16 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 869f4352-e3e9-4991-79e3-08d7f73acc4a
X-MS-TrafficTypeDiagnostic: VI1PR05MB4477:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB447757648B6A758AC8639E1ACFBF0@VI1PR05MB4477.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vPc3LFu6ZXEVxAYt9jRJ1NCJmkqgYppZTQpHIFSq3wHkIXWbov46inDcQ8hDDcASHY/5RQrOM8Zdn30nvb6mbv6eLYxXDu7fwdleTNyJqc3tVLkJs2FyY5aeCL6rYuvKBTp8EDB27pDCy0jXdmZ8/3Bh6ADXOPVE9Y3woii+IbKhJLOc7FJMJ/ObFXzngmfdqyng04jVP+2mbikrL9Tm8xaOFIz5ZBcgDcdU7/ZKcC8/XlDgLjnt7PvFCfapWTCDgr2s1+jrEl2kM4ZrYq8QIs969BWhPtFN3BB0+DGRBc8H49upxpDb096KByT5+f1D2Hs4nd/wPUBg7c+hG57LG9Jmj6dFHcuOCSx14wYzueFi/mSOG4K3r55A210n5ovZAu7Tp0IHTh+guB28A0auOnbvwPheeoNv6y/Cct1WxtKeyTSgXvuxXdgBqIqoRHaFKFOeGP4joMCWPOlpj++AdzzusPHO9qpc6Gcf/OkHGcKZuouZ2Z93BJfGiV9s0Gc4OQ2j7t+MOJ9ljjpEF86b7BYdbIN4MfrnAoGoIwO8blze0UFzuJrjrmyKwQtqEc4Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(33430700001)(8936002)(7416002)(4326008)(33440700001)(1076003)(478600001)(36756003)(66476007)(66556008)(6916009)(66946007)(316002)(8676002)(9786002)(9746002)(54906003)(5660300002)(86362001)(52116002)(2616005)(186003)(33656002)(26005)(2906002)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ulx7+QNU/rbfUMI/+8sxEsWYQ1QdTRFN7hUeIK1ZStQbNwzLIsQJa538QGYtloEYXcbri+quPoXTKJzAJcJMRaah25JiQpBGoEsEoCJ4kgYwX6PXMZIOenQQfPreGal8KWnvG5tMsGJcSdyPK/P4Iptx6+fEF3qhouabGfhTJIiC9eZfQJApEQ6Nq4f2LPieQjczT/T+g/ufQivZNbXPYlCogkAhEXL8CAAQEmM6Qvy0Mozpn/neuP2jPSuuI1VvQeMtGTrudCVttx3Yv1EVbJZRJa84+/AZmv9ycgg4Lz1Py6Y7VrMLGxSJVvv9ibfMUCRSPHiqBAEnZOXUxG3WEdBkOmiqjuNhrwusVo00elOM7MR3bpFPlQbVTpwCo9aeB7wq/vKQmGBYbEZ1apiUbc4qDPA+5XA2LtpOSQwq0STWEfJVBgRBue7ofgJud7jvoT5e7evRritWx4fHrT4bjl7PtS1kAQ1ATL5kVq1OEp4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869f4352-e3e9-4991-79e3-08d7f73acc4a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 12:40:20.7489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LIqFDznrelc+E+gYioYfw5hBhcezffB652fcsCB2HfEyuFBO0q9HRZJI2RKZq0uxz/KuF1KokdvlI00FDcWxfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4477
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 08:30:15AM +0000, Tian, Kevin wrote:

> When talking about virtualization, here the target is unmodified guest 
> kernel driver which expects seeing the raw controllability of queues 
> as defined by device spec. In idxd, such controllability includes enable/
> disable SVA, dedicated or shared WQ, size, threshold, privilege, fault 
> mode, max batch size, and many other attributes. Different guest OS 
> has its own policy of using all or partial available controllability. 
> 
> When talking about application, we care about providing an efficient
> programming interface to userspace. For example with uacce, we
> allow an application to submit vaddr-based workloads to a reserved
> WQ with kernel bypassed. But it's not necessary to export the raw
> controllability of the reserved WQ to userspace, and we still rely on
> kernel driver to configure it including bind_mm. I'm not sure whether 
> uacce would like to evolve as a generic queue management system
> including non-SVA and all vendor specific raw capabilities as 
> expected by all kinds of guest kernel drivers. It sounds like not 
> worthwhile at this point, given that we already have an highly efficient 
> SVA interface for user applications.

Like I already said, you should get the people who care about this
stuff to support emulation in the kernel. I think it has not been
explained well in past.

Most Intel info on SIOV draws a close parallel to SRIOV and I think
people generally assume, that like SRIOV, SIOV does not include kernel
side MMIO emulations.

> If in the future, there do have such requirement of delegating raw
> WQ controllability to pure userspace applications for DMA engines, 
> and there is be a well-defined uAPI to cover a large common set of 
> controllability across multiple vendors, we will look at that option for
> sure.

All this Kernel bypass stuff is 'HW specific' by nature, you should
not expect to have general interfaces.

Jason
