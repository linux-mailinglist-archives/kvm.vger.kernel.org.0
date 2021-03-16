Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9ED33D4BC
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 14:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhCPNVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 09:21:06 -0400
Received: from mail-eopbgr760088.outbound.protection.outlook.com ([40.107.76.88]:56793
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229585AbhCPNVC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 09:21:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fz+unZ/DoS7Iff+4X92VqfQdMUv1xSZMfQkdkKihCY4wTRmGdgoG89U+If+9S+OvNPFQ8QkT7USAbJq0mr6pnG4Uy1RZjsHEchi1v1evtzrhdcU2kBCEaac03kaOxbBr2LtLtTTCXYEKzvNBe+cgAn9ZPqsUllvJcXpx9MyT/UhsJMpi+kK4+/0Bt6sZo/0fN8Er3xA4Z2nVzp/Z0nJA/6z+SMnqmDWhpO2W6MqmwiahGOQw0qTuJKSqxO9/xvrlNDJEjkyEyB90blI/GrMKUPCLldmuEDKz8Fh+t419BHY2grmx58mwiQfkryCtE1Vr0qGw6oBlPIS11mwTVeFR9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJu9Mh/QrO7teLSEQjCPrCPakQ8l2aP7uaUasjZupW8=;
 b=OsYMQS6XhgQQ19pBnUb7gJlr1nM4RdDJuuzFHgr5bd7+RWm105zAvR6NHKWh9uj507BP2Qo946FzuBmyLuIwGcqEla2f1Z6Pka6lWGQC57jdPxrd7ino6n+AgIqkxdHCb5+Nw7OCdO7XSxHwpUfywt8hAGxD/TDMfh8CcUXSmnRCwGKOXyyJZn6nid/TVFjcPmNUqD7q1XWyQKI9sc2PCNlLayoBD30+zUX6GPWIlbqKXNepnJOv+Rv/l/fih+rF4kU7LQqstk+fY+Ja8XHy7Elo1FAA9qrH9g++VuNBbVJBavlSJvnc10z3qWsxoNbEcZr4eDKp2BzDB6+NoM9AKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJu9Mh/QrO7teLSEQjCPrCPakQ8l2aP7uaUasjZupW8=;
 b=HNvndiIM3Zwwkkca5ytQtwRcKv8igIOYJu6IZIsGqvUVznZ4TXxMvaDV5wrMzDvBhJHbim4H9OFXMuMfs05ojcodGfxOOLTsSuDF0ZvX6rYOHFPqQkWohDMC+lO0kwTirNe6lidtrIOD6VOknIHduGKsO3A21F/jrz9QAquN8vrHLBt4g0hOW4aIoKMiHQRmtsa2gmjLrTAjDW8zxFj5T80OIoKspo9y7+UFE+T74qc51ebDsk2JFprLFkdU8bIR3NNwEkHxjVoSsOSHnyOnGqltqxikOTBfBcJ1/NrsYZRywLtI7hCglXrIASFOF0IpvIRLOMjbHkeLaBgMVIfZLQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0107.namprd12.prod.outlook.com (2603:10b6:4:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 13:21:01 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 13:21:01 +0000
Date:   Tue, 16 Mar 2021 10:20:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 08/14] vfio/pci: Re-order vfio_pci_probe()
Message-ID: <20210316132058.GK2356281@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <8-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB1886D4C304FD9C599FD7A8848C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886D4C304FD9C599FD7A8848C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0271.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0271.namprd13.prod.outlook.com (2603:10b6:208:2bc::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend Transport; Tue, 16 Mar 2021 13:21:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lM9d4-00Fkaz-Of; Tue, 16 Mar 2021 10:20:58 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89345598-5292-4a01-2784-08d8e87e57a6
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0107:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB010767C26F6FB600269E66A7C26B9@DM5PR1201MB0107.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uhnd5wydlPNFmXYCWb8v+rhZzo3e7812ItYUJltVuaY7XdKkkT2YbxBF2ofZoujQGGynalPF7Enw90VALgy3SC+DHtCmyiTnh/MihQu8e/EmiR5ANK5JtIxhM7K7dtqYb686neDVRj9+kjKJ7mbH8raTO7YGGiXzNOJGSzIB74vI9xqn9K9Q+WcR0QJscbbSksRLfzJ8Ff+JRV2sqj8BF0cBISdX2ze5jmBAhve5PQrl/9IkWSpMX6+QcCbTXDJtLyJ6utiqlGCDVipfm/jFXiRguOKFcn3FDaMCyS6x84XBtEjZRbt9wqiC/c7nINod4+ex8aXaOSG8VilnKceXBVEHJtMRJ5+ZDIstPLG69x7gIg49TPoQYSiPLbDsR3K+hEos0gavPmnwMmdtcYJsYzquWQabC1Nz916syg0gI8K7bvlLGLnUGx7Qz3J+hPtKxcboreMxYXnmRy2fVxYoqHI2CubVfk+Zk1/AsQyCeYHiVsan+5LgE1BEPXj3fVwHuBGxHbopLSAN9oLqn2iTUqt66mutB1PgiVNsp+/fGIHOSAVH134jSw1+HIbOeUOFpUm8iUzTOJnXS/reLqwwoN6zycfm7DV6w1/gCWISn4I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(33656002)(9746002)(107886003)(478600001)(6916009)(2906002)(36756003)(8936002)(26005)(316002)(7416002)(83380400001)(54906003)(9786002)(66556008)(1076003)(4744005)(66946007)(86362001)(2616005)(5660300002)(66476007)(426003)(4326008)(8676002)(186003)(169823001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mtvTvTJqh8NUIPMsGuGfv75nlZet7YBOWrtcWr1kgr6N5VTXBWuq3+Jw9mfx?=
 =?us-ascii?Q?nrHbJnVA+gN/OOymeVCnk3xzvIpzXYsx52GSvCV2ZSO26PSKoP8I6TYGg5o6?=
 =?us-ascii?Q?YWGQyeUup704eM8Q0AUgbJPKvPG47Ud6v4FJOp666i7qflS+sRXIP6pgAvFz?=
 =?us-ascii?Q?/mg99bVcIDZs3eONBN2WQmeNjVvg9QHMNiOwmBDOZ++hFHXTIBGdj88Wsli8?=
 =?us-ascii?Q?zULmquTXxPhi8j3tRQ2jgQd8ZLY1ugOqr+q0pLHKexvzLPY/jLJPsWAglsZR?=
 =?us-ascii?Q?Wan/P72H/zh7Ezaph9/wozKMXQxOY5T13zWln2AEE5uMnAzJSlXshYIQ13Ko?=
 =?us-ascii?Q?/GL92YiUITOHwVJN1jplMWUObquoA/BLLjgKXuj834AV1ySsscrbcUqI0ipu?=
 =?us-ascii?Q?PwU67Hjgo/AmA15wJHVIsvGGc2a4Fu/n2jjIt3fvSrxM94Cugzs/6g7uDHch?=
 =?us-ascii?Q?syOIcC7r9Dmw/1DWFsv9qfASj/gp2oGIS0QyDWCZ0qOSRjtqSqcU4IZBCrlk?=
 =?us-ascii?Q?vh4H+ndg74vfQly3ax2sqdx6MBh3ZKSGgpp32HvCZCUlZvJpyqXLbl1Ccp/e?=
 =?us-ascii?Q?+zHRP+LNw06qdzJ5lpMt1MbznAEuWZBKmCMDgYhwYMdS7OhDR+wVixB5jVj5?=
 =?us-ascii?Q?wXZNaBDeCjElBMb7qKk24qP/iuRgeypRABJei4G/daCxJwBGV3GPoWpkslet?=
 =?us-ascii?Q?cb2l2QXf9OWLl4gkZNqy4Ex+yB9ueZbZ2sTM3ehKOEWhIT1VtjhNpAt7SwXP?=
 =?us-ascii?Q?HMVNJIuG5XAM/Eqfh1K1QM9o0R3RJseNulCH/1VJs7XgbNutqAAGRotaCHF1?=
 =?us-ascii?Q?DtGNS5xezUwXKfn315zDfIkahu8Ekrq1j1HfwZ8kD9sZnOdDt5tw895u7p92?=
 =?us-ascii?Q?c4Mdt8Ux07gomxT5T0Xgp363zDXGl4nQYYQCXEjA5kJOfusJY66ouVApGiOg?=
 =?us-ascii?Q?k43O+6tEDOItxvjNagq7el2c5qN3qaaJwTzdf//qVM4keozQ3qbOT6JeNjBZ?=
 =?us-ascii?Q?cOH/hzsmSTTSSx4bMAKSYnnEeVEVVfMyRdATairYzoQJJfHfejB2LS3Kmydb?=
 =?us-ascii?Q?QdeZ9B1+hPt7LRIvFpAmKCfcUBmsoornvLFEfo47BmKVuOR/7cK0bustgQc0?=
 =?us-ascii?Q?cVwT2O+BUeNAnp9gToyFD7gQqoi3C4+k+92NfxTgP0JnNeKvzw7yrHsYOQue?=
 =?us-ascii?Q?KGZSK9ktzhjv4tc0FyDxjvubvS1RjjT8HcaINhBAZlunyExl/4zZyHRgvWkZ?=
 =?us-ascii?Q?8VZif4xv0YOFdIIxAOXCPVq8jo/Qx9Qy6zg3H741442p412JOkljJ1uoX8B5?=
 =?us-ascii?Q?Q8mclyn5iJ/JuwEcQio763m1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89345598-5292-4a01-2784-08d8e87e57a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 13:21:01.0053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ualjevLnRud79eCnMzPIE5PLgcu7vuH3+nIv1DXeO/bec2zoYHPvfoatRW9i8dPg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 08:04:55AM +0000, Tian, Kevin wrote:
> > @@ -2060,15 +2056,20 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> > const struct pci_device_id *id)
> >  		vfio_pci_set_power_state(vdev, PCI_D3hot);
> >  	}
> > 
> > -	return ret;
> > +	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> > +	if (ret)
> > +		goto out_power;
> > +	return 0;
> > 
> > +out_power:
> > +	if (!disable_idle_d3)
> > +		vfio_pci_set_power_state(vdev, PCI_D0);
> 
> Just curious whether the power state must be recovered upon failure here.
> From the comment several lines above, the power state is set to an unknown
> state before doing D3 transaction. From this point it looks fine if leaving the
> device in D3 since there is no expected state to be recovered?

I don't know, this is what the remove function does, so I can't see a
reason why remove should do it but not here.

Jason
