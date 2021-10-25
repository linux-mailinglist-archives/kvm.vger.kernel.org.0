Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0DC43A835
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 01:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbhJYXh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 19:37:27 -0400
Received: from mail-sn1anam02on2082.outbound.protection.outlook.com ([40.107.96.82]:38661
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231161AbhJYXh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 19:37:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g59vw9tUtUI3ctM6iHtF0Um+esby8vH687sQHbB5MvvkrV/F+/hHy4LUdJz1DIrHU53ZWNU9Jg1y1ScCKUC3Sh0atL6kEyIeLwJ9ht0Eq1wp2fw24IWGLb4d3j9U5GEkLzT9HZ9O768KpWArF4GwPR7b0e+TMegPE4uIlbD21TfxuEe8Cl2IuJ6hbAD94z0+SqXICbw1bAwE3JSda0DkzNXhTfVZ00uxEKsx9D3+oNg1MM7NB1bo7w5I/QFyQVaAvvigEhvtYBzJbSCiztTVF6j3hxLsjX2d75k+YN5efr6k9Rn9yIWVBX67z4lQPil3B9EZ8TO+ZBOZ7P3Ili9OxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SguOKE8G3wLlsuxpF9GsNrAeL2d6XVzpD7Q9A5I0s7U=;
 b=O27zqGdgox0ozM1Z0Kph4C0UC0p24uHZ+nSbfxXUlXAG64qsQkaahNtyMCuRLelTOgsRTBpA8KsTUjVzUiCrAOeQnyHWsHa4DJv/FmcuHVMfQDDZuZdLScoKKIC1OvyvIVOcqU+v5dvM0AlzqyLavX+a+F/uYcLc2OzfMYsSkaTX76NAGBbpNbzlMbxbze/+vM+Nc09oP7BBx67rB3qwE9CBKMysdIGLMaN7V2XnkMpkOYLpSLIxqG2MYdEglFwTVmMGQEO8KkQszlE+Zt+y9iwiK59VaRg2sHkqaC3QXY6mubMJb63UnS3c7zUYUKfUP8SAGyX7/9wOpgcNoG7JSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SguOKE8G3wLlsuxpF9GsNrAeL2d6XVzpD7Q9A5I0s7U=;
 b=gdV6vALxYvCU2lynkQbpo4jJRfKCawDbvA+Wg57hrePRYfnusOZmQfrjRFF/1U+hGYM3/p8th9b+/fnghVrQ0l2AdAn0dBfBYgWL4jWNYgzlVOWH84zodN4CctTRDKiVlG9oCsJgENoDjr3dDTszrymfnkkdaWoWKOB8wpODw7phkLyN4ZSOrKCTAM0o2jBR0+/1q2mL6goqXI/4PjC+mR0xVb7lATDpP0JW23pudYuZvXTsvsBnpINhzuHotigzxgkY3o8bBgxv6v5gXzOfnVUlDrOUpEYK6MAR28JnKdS99OdSUFflH7VgSFtahgft9S4WT1x94147nTixwf6rPw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (52.135.46.150) by
 BL1PR12MB5253.namprd12.prod.outlook.com (13.101.93.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.15; Mon, 25 Oct 2021 23:35:01 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 23:35:01 +0000
Date:   Mon, 25 Oct 2021 20:34:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20211025233459.GM2744544@nvidia.com>
References: <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
 <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211014154259.GT2744544@nvidia.com>
 <BN9PR11MB543327BB6D58AEF91AD2C9D18CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BL1PR11MB5429973588E4FBCEC8F519A88CBF9@BL1PR11MB5429.namprd11.prod.outlook.com>
 <20211021233036.GN2744544@nvidia.com>
 <BN9PR11MB5433482C3754A8A383C3B6298C809@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433482C3754A8A383C3B6298C809@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: YTOPR0101CA0042.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0042.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:14::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Mon, 25 Oct 2021 23:35:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mf9UZ-001vAa-Cx; Mon, 25 Oct 2021 20:34:59 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4b06b24-bc6d-4f5e-6938-08d998101051
X-MS-TrafficTypeDiagnostic: BL1PR12MB5253:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52536398A4B908E8B3A44F8BC2839@BL1PR12MB5253.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69/nP8CR5QqOaO/2FBxLduB6Cc9DdSJbit6/XD/sgFKxBVVip+ZKHMHlkCgV980OHqati7z45n4fBfWXjc5eb1I204/xiLXc+uG7qc9PXjU8EkWSpu5MjdZPhJFhY3OJijWePDxLKpsuudZR6d08QWigusuZmbpzkjlU6kABtg/lQR99Hs11MKd7gB9qZWz53tQSp+wfz1bFjVPjPFyOUBIC1ys3BaU5xXFkifMn7dCLVy9yqkoumBUrCxRMG3awJMKG/fV7LClOjhhnN3po2jc76bleWmC4Ii/aq4wClTtO0z9NSTbMEf/gOHhqybPUEJoZh5M2Ua+PHn5CvMi8UHsMvI3Ie5e4NhkfRLzhVvYqW7WQY5mZOavvJyeqfAKtdG6U+lx3yglydPbmdaL0UKUs1l3+giSKCBeld8YaDec/x9LJ8c0D1rWYtpU9/RIK0fFfRIMCrJZptbVkSqYxA2fkC0oIVHoqsczFfRh3IAAuLLpaafVGYlXgTQNyzce4567rPDw+Qk8yp7hhOOys0rJaGpVCYd4zoo6lx8XSjBxeJroIdYq8Zxs6QAGgU0coZLAsQqR9gJidnz63t0SXjEObve077axg8S1RsTYoqrVUdxsDzCkXI20K/qdX1Ho0k/c6TUKeGQ0knmHOfgPBIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(33656002)(316002)(9786002)(2906002)(26005)(186003)(4326008)(54906003)(1076003)(2616005)(7416002)(38100700002)(86362001)(9746002)(508600001)(66476007)(66556008)(6916009)(36756003)(5660300002)(83380400001)(426003)(8936002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cPULKCTIhOfvacJS/CfTb5qFmGRSwk7OblABDqzTBq2CoS1NFdKpxg1WouNW?=
 =?us-ascii?Q?/4F3vGre+boBE5YFYNe3Mv6QjpnGtmBYDq21zM7N04YWHZEZLnTsbst/pD1k?=
 =?us-ascii?Q?8yrUVg9iWxTFgExl519C3YpXYFSiqaarw82AXYjyDUJtFKLO0U4Dnx+C4wal?=
 =?us-ascii?Q?VoTSOkTqzD5N9bpvN1kH3S53RpL7c7+HBdZz7qt8UmA7uH7cACpPJdT8IKRt?=
 =?us-ascii?Q?AubSwX8qgl/mF+Wc3bSTDeear+doUtA9Q+CzilOQ3TUP5OmTff9vJZP9cl7f?=
 =?us-ascii?Q?YhR0aIu040kXJf96EMYTImJGxrMlCwbINTavV6MQpFRJW/c+73WJciickb2X?=
 =?us-ascii?Q?Ef+/DLZXS6Hmi6+BCwTnsxkQ9wRZf5bUJyiSBz4he5S4T/0lc/R1iCzMUaw0?=
 =?us-ascii?Q?TpryU/0jbb4yAvYDNgWlQyXJBD7cvSoqOgoAvbqjn4swcT0WlQVtW7N/pk7j?=
 =?us-ascii?Q?ASt3Dve58MsymlcGqMBM3ejPd3Gdy7shMhzAxra1aiqLVTnz419whixIpSjl?=
 =?us-ascii?Q?NpY0EEEWbOeSuDhqPZqhuLwj3VU/ODEOsxQs7XEDLTWEZvgr5/0P0JmbRptd?=
 =?us-ascii?Q?SBWECSM1bVNqlEEHoO6H/bpqA4rnVmg9MCBATU9zbhxCgtQe1VjtmU34ksCz?=
 =?us-ascii?Q?6nUZYZ2Z+tAP+qX0L7t0Sm7X6e3zyxst951sGtJQzhof9svZWXWD4NonJvLf?=
 =?us-ascii?Q?ZN2xo0R6g7OLpKWpPC07cyfBmr2+hf4EnXsAkxC3Okb5P8IPQ/r/P0/TW/U0?=
 =?us-ascii?Q?icKAR7R+7x8CdiX/DWRo2EYh4FKTui4s6kOFFe/OrKHhFUIeYhiDgzgDdyJq?=
 =?us-ascii?Q?nQtXrOTXvtLybnMOTU2oGe4H8RuEug8ISK5wDvf/dJzkGtAjXyV0XAwDcp7l?=
 =?us-ascii?Q?H2+DFX1F34JwWZ1VA3EOXTXrIEdo9soTEmbKxjHcnIIiXJFF0ytpccNisz7x?=
 =?us-ascii?Q?zpWDBMU0Z3FD67ScM3nyDXZz9RdLMGzySeCkidP1UA3OadHQJ4OOin4oJ5wC?=
 =?us-ascii?Q?ku0ZrSlk1McOvZpIVWkG7OOF6sIcO0AIdzESBN+Y9DuvyZtuDQR53+GsgUtz?=
 =?us-ascii?Q?A+h9ZQT/CWGLh8EJa1GY538SFeFHpBaUnBVpt6OePky6osB2r9fGDE5Q75xB?=
 =?us-ascii?Q?EYf8WmmsqbKB5CBJLJNPIcA6D/0pRumWlQ+NSQBqSe7j6rGwtY8AFnWqpplq?=
 =?us-ascii?Q?ispzXSsRt3uc1D3pEF16GyNM6DI9QEK/2RzSZllZM8S/EuKT+4wr86WUvABo?=
 =?us-ascii?Q?WOIq9VEu8Lm5zbjrhib1u9gUY3DZWNfdSj5lwc6/4dcIu7KjtuViXaoCnk2n?=
 =?us-ascii?Q?Ryj4AUHclMYI81JFaZaCwVRANHeZForUc7hER8lmfJjSnwTlj65ytR5Cxw6V?=
 =?us-ascii?Q?UbeXbv2CwZjGI9s0qn/lHrBl8fZ6VO3lSbQD8NjJbagy+7QwTF0qpMe9BWnT?=
 =?us-ascii?Q?7thl8AvRRMAU5zFM6oRXqoYgAuQf8SKEt8nSBkYUnu2DOh6EkhncJ/Z7dqni?=
 =?us-ascii?Q?G0XVkQXovU98zpSID5uot6y+z1dQ8nmAwJ/uAdFFlT95Zj+gwzVIQzskkMHl?=
 =?us-ascii?Q?OCvr6xFvCclL4aqIwvA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b06b24-bc6d-4f5e-6938-08d998101051
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 23:35:01.2585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfN262F/VGGEyqwbTgrl7HZk0bPuS+69eqU6UVsddONR3Y0S3shR9Z803q+GwHkE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021 at 03:08:06AM +0000, Tian, Kevin wrote:

> > I have no idea what security model makes sense for wbinvd, that is the
> > major question you have to answer.
> 
> wbinvd flushes the entire cache in local cpu. It's more a performance
> isolation problem but nothing can prevent it once the user is allowed
> to call this ioctl. This is the main reason why wbinvd is a privileged 
> instruction and is emulated by kvm as a nop unless an assigned device
> has no-snoop requirement. alternatively the user may call clflush
> which is unprivileged and can invalidate a specific cache line, though 
> not efficient for flushing a big buffer.
>
> One tricky thing is that the process might be scheduled to different 
> cpus between writing buffers and calling wbinvd ioctl. Since wbvind 
> only has local behavior, it requires the ioctl to call wbinvd on all
> cpus that this process has previously been scheduled on.

That is such a hassle, you may want to re-open this with the kvm
people as it seems ARM also has different behavior between VM and
process here.

The ideal is already not being met, so maybe we can keep special
casing cache ops?

> Is there any concern if iommufd also follows the same mechanism?
> Currently looks preempt notifier is only  used by kvm. Not sure whether
> there is strong criteria around using it. and this local behavior may
> not apply to all platforms (then better hidden behind arch callback?)

I don't have any desire to see a performance cost to implement an
ioctl that nothing will ever call just to satisify a idealized target
from the kvm folks..

Jason
