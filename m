Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE4E23ED15
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 14:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgHGMHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 08:07:14 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:10879 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbgHGMHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 08:07:01 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2d43e10002>; Fri, 07 Aug 2020 20:06:57 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Fri, 07 Aug 2020 05:06:57 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Fri, 07 Aug 2020 05:06:57 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 7 Aug
 2020 12:06:54 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 7 Aug 2020 12:06:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIv4xpPg4Br912Ed3lZ+k9RFOkWKDXgb0CDU3y4sZGNWh53wXZ0bvnS/BdY7oEKJMUosZrKYX4zhtX/Fhd1sycXrakbBSv9FiPy8SPe+YqbjDfRHMBZUBSEo5bqHhmILTnvILG5AkUqIp886I/FfPOtCgQItRbaFor+pUnuGC+Y1EazoagBv8litlfI28iPxgyRNIP5a/JZZOLTNiC4xKRGY00OS454tROdHkbSr8DR/spgyJgS905tKVM1ZpZzsAhKkNOX2yfEFWy2OG4/x5Mx2OhBmKCblB/dWExcwlbYSSxJRp0iNIM0+6B3J4pogasqPGCNvgC07wM/B0LPCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FA5i77KQ9ekFUbbxsuLCWszZ/MINCIcRJhq0r4T+d6o=;
 b=DHgnyeLS3XBY2gz4nakp3Sj37tljxF6xnxpu3MrcezxAQs+W2GsEazTOxKdqeYj1eTTuGHUOrWUPZSMKzdgPBtBG7GVBLItZk4fVIdxDtDTacMgfiDqx3B3EmlaZfmwzK18FNoypzSj/44RA0FOO+xAs83z9WnMyW+YD2OzueRylaajJfuaKhJRWphh5z23G5GCiS+Nc1oaUy46iPn7Uwh3mO7Pj7WHMy0BGn4SuNw79y2joO1ni7eLKAVA+Ee5fGL5k2bzM8vo0IMd78iPeQuSFbDMA35wi09cqi27mM6dcvcfdeaZm96yAWlGu0lCuISMGz8h67K8VrLjLSsnFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3515.namprd12.prod.outlook.com (2603:10b6:5:15f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 12:06:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3239.024; Fri, 7 Aug 2020
 12:06:51 +0000
Date:   Fri, 7 Aug 2020 09:06:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "Dey, Megha" <megha.dey@intel.com>, Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Message-ID: <20200807120650.GR16789@nvidia.com>
References: <96a1eb5ccc724790b5404a642583919d@intel.com>
 <20200805221548.GK19097@mellanox.com>
 <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
 <630e6a4dc17b49aba32675377f5a50e0@intel.com>
 <20200806001927.GM19097@mellanox.com>
 <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
 <87tuxfhf9u.fsf@nanos.tec.linutronix.de>
 <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
 <87h7tfh6fc.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87h7tfh6fc.fsf@nanos.tec.linutronix.de>
X-ClientProxiedBy: MN2PR20CA0043.namprd20.prod.outlook.com
 (2603:10b6:208:235::12) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0043.namprd20.prod.outlook.com (2603:10b6:208:235::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 12:06:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k4198-004gcU-2d; Fri, 07 Aug 2020 09:06:50 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31593619-ea0c-4b64-da6f-08d83aca5e58
X-MS-TrafficTypeDiagnostic: DM6PR12MB3515:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB35159C3C2458095E38D6D0FCC2490@DM6PR12MB3515.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r4BPTTtoPnpI4hycj/0AG2JkcjoumFjNZ5XkI30JUUH6UQUxthc5Bopz7v+fUBeKFL3xJge7gluMcj8IuqZ6AOgr3pIyk7NgsO+GwmiLEGPjUvw6rLpARjNyW9EtOOA8HaEcWT6hr9ECMl5PLzdgVSuNULJWLt/+6lqUO0UStoNX3kz2UX6kq40yAioeQNungx420YIGACXKzrTfcfOeAq9/a3+cEhh//FNbC1uqAUp9MJdPiqq88TrH5PnKAs16HJ2Crw3w8eThgr5QUGH0qOMFk4fR9mOqsuYhqkC0j4XwA/O+SnddsncAad+Y3OqrGvioN3JkUkhJGgdM2D5b1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(316002)(9746002)(8936002)(2906002)(66476007)(7416002)(66556008)(5660300002)(36756003)(9786002)(66946007)(7406005)(186003)(1076003)(2616005)(54906003)(426003)(26005)(83380400001)(33656002)(86362001)(6916009)(478600001)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ctP9XOdsD+1ANNsN2eTa3ucLJfN1lTRFNzyotm57CT0EF/lODwZUBIVXCTKK1OcuVYXLf+ImfP8JoKk2eO7ELwYMLasZLp7UP5trOQMrWhz2ttvzQzxgobcEhjc1yQIZz9+/tUk73BZFNjbNL+1wgGWrRp1C1IoVEvqxHIxrDAuDjSKGOycRew62+OG/N2lQkYZuch75VxS08eE1aqHWN2jdEVWXIUwY3h/+WpOLwydokXMaFy+6uO+Cojscpupwlf2cu8bp08mNs4JYjFDKC3tPkzBPvTiGVyOP0WSrkGOW7pxzF3YQfVgywe9ybl9f9+n5DDrhnKgK9eGcgjqoacTJZuujjDZZC3D9c+GRD5LaV6GM+1+fkmdc9sSpF40MhNAcOy0RteDGZqq0k2B5IyW4hH3HG/1ZTwuzQkblw9ZGEwCfGxEUL+pq49D3sJP0LdgigPpQ0szhmYG0YCVjbaqqSWVPCIXFPEBhHk1/RSv0QWajgP60TmCC6UEOMxWXgRdV52QngZJD3clK9qIoCd3bkFJTb78Fiv4KI6DTD+g/6mixjt/N6tdeNhOAlMKUizjDgNzz+CVgJPehCkze1Ly0gxok1+5N8lJ0dd4oXJAHd5JZ8cmw2V5q3Js6hrU4fqHfntHgdp6PPScefgDAMg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 31593619-ea0c-4b64-da6f-08d83aca5e58
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 12:06:51.7069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBn4LeXMoL6d4KkfWcdn/dzRXuh3Jf2nNrmupbZ9azvxkTGmMvkmrhsf04KDD2Em
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3515
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596802017; bh=FA5i77KQ9ekFUbbxsuLCWszZ/MINCIcRJhq0r4T+d6o=;
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
        b=jR9JqQGvPWqQcPi5PLWGWqU6twVWqkvoQGR2jHFw4FWk6n/CbsQqE/17h2ne43WdF
         qhZbQII7+Nz/denkH9FCvwCV49Riz4FWwOojKI7r+vApwAJKFcon/6+5aA20mGfQwH
         qGrarW8MX5kVcBbettYVKm4D2S0uqo2bvZa5a2fWoyUR93BYVUrjq2MozW4nxxBpbL
         ceEAd8qL3IIHbpNqC9sY+TKA1rqVPDPQ5fuuPqkYiuikDMVhpnDmfrvLexqQCn1q4y
         Hh0jkXHkGu33Gv00/DuLz4BHMKAAhxQ94djZqcwnvPz1qDzU4bJctDvSVfbwlMzF0g
         IxNUc4KudD6Rg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 06, 2020 at 10:21:11PM +0200, Thomas Gleixner wrote:

> Optionally? Please tell the hardware folks to make this mandatory. We
> have enough pain with non maskable MSI interrupts already so introducing
> yet another non maskable interrupt trainwreck is not an option.

Can you elaborate on the flows where Linux will need to trigger
masking?

I expect that masking will be available in our NIC HW too - but it
will require a spin loop if masking has to be done in an atomic
context.

> It's more than a decade now that I tell HW people not to repeat the
> non-maskable MSI failure, but obviously they still think that
> non-maskable interrupts are a brilliant idea. I know that HW folks
> believe that everything they omit can be fixed in software, but they
> have to finally understand that this particular issue _cannot_ be fixed
> at all.

Sure, the CPU should always be able to shut off an interrupt!

Maybe explaining the goals would help understand the HW perspective.

Today HW can process > 100k queues of work at once. Interrupt delivery
works by having a MSI index in each queue's metadata and the interrupt
indirects through a MSI-X table on-chip which has the
addr/data/mask/etc.

What IMS proposes is that the interrupt data can move into the queue
meta data (which is not required to be on-chip), eg along side the
producer/consumer pointers, and the central MSI-X table is not
needed. This is necessary because the PCI spec has very harsh design
requirements for a MSI-X table that make scaling it prohibitive.

So an IRQ can be silenced by deleting or stopping the queue(s)
triggering it. It can be masked by including masking in the queue
metadata. We can detect pending by checking the producer/consumer
values.

However synchronizing all the HW and all the state is now more
complicated than just writing a mask bit via MMIO to an on-die memory.

Jason
