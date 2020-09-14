Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A242268A3C
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 13:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgINLjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 07:39:22 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:51091 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgINLjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 07:39:10 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5f56500000>; Mon, 14 Sep 2020 19:38:56 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 04:38:56 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Mon, 14 Sep 2020 04:38:56 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 11:38:51 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 11:38:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aszzz9aCXPrsx2+DbUfU4MMGv5ishmNwIXr4M0VRSv20k8TbzAcl6mwrn2hF9t+7Meql3tDAgQV1mTD6/vxYbOJB6EMRWdSQGG9nmeTI6C/sXw11EPNcgDM85qIgAcrYpASn6rk4DfN1hzfHCODEfHZVvt/+WcXV2BTzUMRnC7w0Db26IKmJeMWUgs0VMLNJA/8q6XVyPOfYi91ax0XiUrEkiPeXW2B8JaONOdzHce0DMTaVEMlF36BfNpkVX4S3R9RlH2okkHmahfRzwykKWvMPq8S00FWavPk+dgLYdZWmBDfg2+6mVX0HM60/HkmbSET2pMdickRVIQf7+l6vlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXsZzUmJitkYW4cx3kqEEsWpV0Prd8msKBrWcp7+LTE=;
 b=O3pyesYYPiGCPKQmpIKiUE7FM0I8w7WiHXyPqyFOT5StejmuhJV8GXqXIH83ZUoV6RQQ0BX8xoLvpxt9wYWfGjQSszAg+fiEikMTV5jelmtYNyzbO93yFLMqhhd8c445JZ8PvcExtOY9YkhTCH9nxOyTr/fclEI43sUGAzhWFFcAd7JzoeiKVf+VRsr1EepdYqNBNA+921jhnvFj+WnTmBxpLNj7bxT0kRs14Q//W4ofNBOc3tS+DWbYTqQOY7TgQpg72hBdrNBpyS1SHUaadq/f5CqsATh1fbh507dPuINnZ/UGHKH06turz3/2PE+nDFOuTgVS/YEeVxx+wkUqIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3305.namprd12.prod.outlook.com (2603:10b6:5:189::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 11:38:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 11:38:48 +0000
Date:   Mon, 14 Sep 2020 08:38:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Wang <jasowang@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, "Wu, Hao" <hao.wu@intel.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200914113847.GW904879@nvidia.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <411c81c0-f13c-37cc-6c26-cafb42b46b15@redhat.com>
 <MWHPR11MB164517F15EF2C4831C191CF28C230@MWHPR11MB1645.namprd11.prod.outlook.com>
 <c3e07f47-3ce9-caf4-8a01-b68fdaae853d@redhat.com>
 <MWHPR11MB1645C702D148A2852B41FCA08C230@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645C702D148A2852B41FCA08C230@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: YTXPR0101CA0044.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTXPR0101CA0044.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 11:38:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kHmop-005v8l-4l; Mon, 14 Sep 2020 08:38:47 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 705fbd55-0fc1-47ff-c211-08d858a2beeb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3305:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3305B9B05FDEEE45A32A4E85C2230@DM6PR12MB3305.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +87kfa9WX0zkEMF7PNBthMXjUL1rWN1oFYN6/QtW+1WdEcjlh9UGlzhxzifiWAOKWR2aUIDtkFtT1J/VeaMHQBYhkfTKBrPBY63IYheTJbjfmBMn0p1VOaBh/h8UFapLK1HTkgDkaPhrB1tS46Pwu73zHGgM8tyQqMUIAEg7jXh7fiPsY1EfI2I/W1HLaKZUv07K4k1K6E6v/8zrvlrBNUXnvj3XBoSUetCGG5YvwMWiyfZ5+cOcwLRTD7Tx5+jT+qLGxK9s5OKxu1fBdC7hD2UEIyqXaBqsCD7c2CgocoaAnPn1F0aKf8bsN5uer9l7tlqOFgN69Tt7xah2fixwOK0zbFuxUwOo8nC5I2YXGQ9P90or0dlDgSCGsQCFI2MV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(2616005)(316002)(426003)(4744005)(478600001)(66946007)(66556008)(5660300002)(66476007)(2906002)(7416002)(54906003)(1076003)(86362001)(9786002)(8676002)(26005)(9746002)(36756003)(8936002)(33656002)(186003)(83380400001)(4326008)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C2LyWd5Fbv7+hJjn9AhU5Bx7YWIW0CzDGS8Zz97pps0uMj8kxF+UvNEKbSewX4qXdMcPUX7gxCe99rV7KSouJXM34mfMLskNB+NcjQn+I1kuwdmQS0X3+ukfnETop6UBoJgvl2lwYtCtW5sgXmB6eCmD4GHEwOnjE2K9BZgEDKPW1bOXBZbmOd3C8eqMSD0dH+XnlWS/PnW2zecpBwvunz6/8Rp6xep2zR96s9MmJaEabbAdj4iR1e/5X4jWi/40GedHzHEWVnamfodMG5053DBK1UM0QpAtNAnb/Pd3lWtnooU57dlNYpUGsP4jwdeKgt9mxn3mowuqO0GmT+NzAHho3HEnQEB6iKwMwe6uDhLChrdiUl+iD3DXCvfjF38H1JJSSh6ed8OoDTubVUaEjdTdsSrAODkDLXD/sHkks3SZ94YYpr9crH5Ss6p9bZ0KRYp1Dx6hwFUL1C3Vmh7ft8XDh9AkkgxxY0sq4Z7MLaOlVvrPyGZEm3OuA4hPu/YkP32kyx8zD9rcfk/kfmIkUAsKIDNGyTxt/saUpNaU+JnR/ZMYN2SOps9VoSDFvojtSjqaF8DwzOBlpC9YWRj3OhWbzO7XKjA2zcy4YB9YP7lW2stWYVajz5Ei3R2WGuaGctTvC98q8ePxSvwKTBrWFg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 705fbd55-0fc1-47ff-c211-08d858a2beeb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 11:38:48.5602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xpjQbEcgF5stukR17fCgYCjVI1asAJ1Ifno625VKN6OHWlfEK7HEEUGzYb0/sxr4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3305
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600083536; bh=LXsZzUmJitkYW4cx3kqEEsWpV0Prd8msKBrWcp7+LTE=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
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
        b=ALmqWV1H7zsgU4U3tifaLuXdewYuW6fwpwDKxNjwHEr1/xPLTdDdFVDtIgIU3I3hc
         Q7szgaUiVl4WMuQ+fvDE9Q4LimcVsgyBFtRIJObMS5+voVExRkoc8SgcbfC+XBp2rj
         XjrSeAoClubX50ORNmbaz5qYDhy7cBfnkfpfSmNN51YC50Ykq9FoiI4AgR/TFuUeXe
         ai2OyRiJ6LRACcfhcdB33dpjoggrjuqPeuJlc8WT1da5sG8eyEydpoyPOzFo5pm65K
         gntdCri5cvFTCqvOKqY0IsjOu+4u/FqbTstj7rnvHE3JR5Wm1p5XugpXn0p1XDSaqo
         5jFgaRl5bOGGg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 10:38:10AM +0000, Tian, Kevin wrote:

> is widely used thus can better help verify the core logic with
> many existing devices. For vSVA, vDPA support has not be started
> while VFIO support is close to be accepted. It doesn't make much
> sense by blocking the VFIO part until vDPA is ready for wide

You keep saying that, but if we keep ignoring the right architecture
we end up with a mess inside VFIO just to save some development
time. That is usually not how the kernel process works.

Jason
