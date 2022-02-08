Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5FD4ADDD9
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 17:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382495AbiBHQBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 11:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbiBHQBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 11:01:15 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D64C061576;
        Tue,  8 Feb 2022 08:01:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLnOzn1YycEwt+nPEuuBV/DK0nZhITievp41qVOeWloiLVxpnrhqoqWJtj062b7od2p+GnGfU60Ib15cJ0TRRAEKwPF05SP7ohI9T6yWeQcIyIatXvC2uYE4mG5guHBqnHc92Lxnjfz09X2Aqi+Mo4sfmGspNnaUKNEZ6NfK6Hb9yNmZ9tdIP2fI0n3QsrcvdUut0OWp/KPahmazxQQFF4hHeRZ9Xlq59FuHtXta/OoaatupRagJmF3Juu83OAPcgRXxmNR2UGZ+oiSAXD/MyeLVcVns9hSzhhztCIW9WLpJpMJEGR412SqJEIzCwjIMMKvH7pw9b0cOOHCEgOR/+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4ik90iqd43IQUHuIsqs12xHo7EzzWxkshmR2Mp8llg=;
 b=cFwWSmXxyVtnmSnFhGaFrOWjzHTfllCWio+nE+SiOgrdV4JaDTohp/mdrFJBhgw8miOBDtwHYxQa892mJwahUih/WfiGcRZmvp8gqLhSZVNm/IA2SeU1efpxhq17XDtBGiwUY1Mqu36fv+JS7l/UcPTcAatQesPxqqR9LB2JptLeLw75msjbEEQvAS8itSEP0j3uwKJ9Ivd8ij3cBPvRco7zlCgePpA8Vk1JPQ+RxoW5weB993agDHPllYfets3bkz1S3581GZGIfJE703eptRjJmUl2q1cefQxk8ElYVaHQ9w9hDxNlN4GB7omjbg4kAnm2sVDFx/uOl/CjcbllEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q4ik90iqd43IQUHuIsqs12xHo7EzzWxkshmR2Mp8llg=;
 b=kCAAK4EATx+73b9Z81/C7L1q2H157lfRGUyxnQvSenRvHTRFD5MMb/CgmPH/G6pioV9t4JsRxCkDGmX6nwkdBw2eTFdPnGZsSesqtv7H0a4kbfEfBFAMwzbYveluPEeR0b0Tk58imXuGT2i8T/bKZ2ymWBDreB5784d7iBcjjtfAQxK6ZcUH89KBY/CpSyB7MFWFxtEHxML0A3uNGZpmW0VofpQtlFLc3iGMxvtJGYTh/yb7pDPfA57P8XlS2CKTsvLXWNBcd/s1lZO8tVW8veyRV66D/bQHWmkNdhHuegpTMrryweB8Yx/osYgHhZJ6uoclcdKsqFWvtDN+Y4KUHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN7PR12MB2833.namprd12.prod.outlook.com (2603:10b6:408:27::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 8 Feb
 2022 16:01:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 16:01:13 +0000
Date:   Tue, 8 Feb 2022 12:01:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v4 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220208160112.GG4160@nvidia.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
 <20220208133425.1096-8-shameerali.kolothum.thodi@huawei.com>
 <20220208152226.GF4160@nvidia.com>
 <bd69bdb6e0664667be868ff799e8629e@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd69bdb6e0664667be868ff799e8629e@huawei.com>
X-ClientProxiedBy: BLAPR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:208:32d::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df152086-afb1-4b41-43d1-08d9eb1c3b2c
X-MS-TrafficTypeDiagnostic: BN7PR12MB2833:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2833177A65EA944C06BEEFA1C22D9@BN7PR12MB2833.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YC6odzYlHq+W5O+RlvWiGGXYBbMq5By15CzULExIZk4HuBLXYUywm/TJuJUeqdROJnzfy1Z3LsjScw7poad78ww5kmd6yVD583qnkJhArzoObmdEuMilOPv2RhmM3ulRPsHta9VvVBR16QAGb5nRguBqDX/1l50d8VZQggTqmFt/ObMO4LtC6MdyXcqtm6ZblUJXARfId7uK2XYPLbrVUBYuANZboubYRtb7bUy/bcuLQEvUp8E0LpL1sDrZnqqQq/APJQ2Q4Wr6YRHInW3t06CwFtZjRLEpuzCbum37PdmZhJPy0CtzJlQ/199xpcxXgdbqQ6D/6/8vz9R8flSkI4kU2d7PX5ygec7kpFE3fUu4d/DIpqWys/nrpS+8spvfGsxz2hQ3x4aba8waEf6zC8N0jbmNrRtbn7NHvys90YLXqnCxP/Tmd2kaljDPYF2sqrVAueH6NX06l6R8sgYjFz4lBSGjv0UaY5h/aLQrhaNG7pHonMcqWEtvvYjUzuCr9U6L9P1CwsUlcOe01tgu2G1MNkQQSo9f2naeWV1xBreUAMEAsMK0BOt9eUIkiXAXZAEGKr4Z2PEtAIkmvLDuDtoRMgIvfUJKLCD6W+Ikqh2vWCTl88TuCPk/ffIETHcdnED75flYNSyIMvj5C38sJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(508600001)(6506007)(38100700002)(6512007)(6486002)(26005)(4326008)(6916009)(8936002)(8676002)(66946007)(1076003)(186003)(2906002)(33656002)(83380400001)(7416002)(5660300002)(2616005)(66556008)(66476007)(316002)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tK2LY2rW25hzC7LszYEOFebCpUdsMaSYiphED/ner8a5YG2hDD/1ahffsaIh?=
 =?us-ascii?Q?oH62f19yYEVwT+89fiZR0qHlcEsu7VD2wZlJxCmgvRqzMM90ilmDu7iUzbM1?=
 =?us-ascii?Q?OkEbVdKizWonnK0zTCOS041t+hmYSQgsLlNK7ZQPpRpGQmlDnuEfcJ1LZfHK?=
 =?us-ascii?Q?wxKkumEH1IL44e9Dd4f29X99Qxj9wGQOnYWYBNHeNffKlS6uHGGgP5TGteYA?=
 =?us-ascii?Q?nE4qt43yGZQx18etVNYwLb2NLu/PoWxbfwWPTm3+PJgUHiqb68fh4EXQFzRA?=
 =?us-ascii?Q?FFAinYiWM5KPyAy6PuFic0wfnkPMxSegaomcDxjT5F787OETtdSI/b72+m6m?=
 =?us-ascii?Q?zfVxgEAOFTfetll0utpveRR2Cb4iuGw3BOalHgKFRvi4XRhwQR13y84lP3IH?=
 =?us-ascii?Q?YxCINnknmnpmKCsfSX7hZXbDrAxvlzeO/NKgwJ5W1ZNbe1rOtSl25UXIO8QV?=
 =?us-ascii?Q?LHFvMJe0Mw0q/BOCdE+hAWTzy3Xb3cfg8+GIaKih9UGD/9UVJ5hcwXLqaosT?=
 =?us-ascii?Q?MASg3SiUsZvnNNRoUUreFLdtN+yabHhjs/Nh5CKgCNVXlIA0sUekS8zBzk2Y?=
 =?us-ascii?Q?qlUeU+egfaj+++ZhHCESbIhWvRgKCMWsdZ9qH3EAduO0yhTM/R2CdTW1PCzM?=
 =?us-ascii?Q?twNwnre6vYdMhaD7bBzjVlHk87vhteHoLJQM7t1/PVpjUNxuojiPSWe8xgb9?=
 =?us-ascii?Q?TdKB4cbXopipEAOws58MbNK8XHnwI0IoZHUmWjqggJtaS3bJ89yH2pNSG3OY?=
 =?us-ascii?Q?q8KzrquaudVLcTmNaidQJuZiF1CC2BOjuuDiF47r+/BGgbiPOxpbM1ahROEo?=
 =?us-ascii?Q?sxIHWiFOQEBePnQd9VmsTTkyfdFAg33UDR7jjsWAWbJWL/2X+FPrqXo7rVXC?=
 =?us-ascii?Q?50mjNS0aoD3H1gLaE1CmX/xv2d/1EUGzZVSJw4SowE3VIR4xjMydUPaqifPv?=
 =?us-ascii?Q?sEGrBZ9RSgOupaAhE4gE3HuDARnxwWutM2BuKKOBxAJrJXB06FUXzcaadoUd?=
 =?us-ascii?Q?w7BDWJvorREFej79AV142wABflXu3Zc9PkiPXQFhKvsjPC5r+Xfrd6mfx+l2?=
 =?us-ascii?Q?s5rWAOy6ZbCndlDz3rSCVhKf+bz/rf1/C3evxr8YfejAI9+cspNeVXycm7KJ?=
 =?us-ascii?Q?iVQNXbB4u2pG5dyIWbAHu44HMEZ8VdmlGokFACAfbAT4fR7Rt7fUQ0WiC6+V?=
 =?us-ascii?Q?mlbozaNhxGuPxvavAekJE3xqp7DufwvqrmubIAIbsppr/HTNc2jgCkwN0/3Y?=
 =?us-ascii?Q?CYcA/7mY/u1KZgqUJgeBlG4RDQL4RyctBuHWi4oQeuerHXZGa78eZ+9vnFAE?=
 =?us-ascii?Q?bnFY4yPmem7vGKYnUwSf7SUHVlDk1wGufDy+8eEgn7mhGO50Nj4vTZmbxXxo?=
 =?us-ascii?Q?7fk91l0D/Bd6WmWstGCzghTKCRxiW/WJErOd+EFmm5ZG6RhkdrWxD5gUQdro?=
 =?us-ascii?Q?+t0+GDklQ+Ezpbed8yrcQ4byxxHpF+pvyjdJ+JIvV4YH2zXDgWvZJBUnkJ11?=
 =?us-ascii?Q?w5F2nd8HbJ/mGkVRVzBTZiO4Pb/B6SME6Gr/EHa8cFh4pb+QMIh7BuNQyLlM?=
 =?us-ascii?Q?ntX4VV5/OeTx2WvqCto=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df152086-afb1-4b41-43d1-08d9eb1c3b2c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 16:01:13.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzlO5Dz2ee+lAPzXu2Wdhi3WfA0941YRvhda2lWjdXpRL+VGI8bF9gBrCkWI2AWL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2833
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 08, 2022 at 03:48:16PM +0000, Shameerali Kolothum Thodi wrote:

> > > +static int hisi_acc_vfio_pci_init(struct hisi_acc_vf_core_device
> > *hisi_acc_vdev)
> > > +{
> > > +	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
> > > +	struct pci_dev *vf_dev = vdev->pdev;
> > > +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> > > +
> > > +	/*
> > > +	 * ACC VF dev BAR2 region consists of both functional register space
> > > +	 * and migration control register space. For migration to work, we
> > > +	 * need access to both. Hence, we map the entire BAR2 region here.
> > > +	 * But from a security point of view, we restrict access to the
> > > +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> > > +	 * override functions).
> > > +	 *
> > > +	 * Also the HiSilicon ACC VF devices supported by this driver on
> > > +	 * HiSilicon hardware platforms are integrated end point devices
> > > +	 * and has no capability to perform PCIe P2P.
> > > +	 */
> > > +	vf_qm->io_base =
> > > +		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
> > > +			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
> > > +	if (!vf_qm->io_base)
> > > +		return -EIO;
> > > +
> > > +	vf_qm->fun_type = QM_HW_VF;
> > > +	vf_qm->pdev = vf_dev;
> > > +	mutex_init(&vf_qm->mailbox_lock);
> > 
> > mailbox_lock seems unused
> 
> I think we need that as that will be used in the QM driver APIs. I will add a
> comment here.

Perhaps you need some 'init hisi_qm' function to make this more clear
instead of opening coding initing so other module's structure?

Jason
