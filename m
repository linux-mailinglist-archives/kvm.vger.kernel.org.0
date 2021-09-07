Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACD1402763
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 12:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbhIGKwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 06:52:22 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:29096
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233669AbhIGKwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 06:52:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Amd3Ws0WVF5vlA6D1ukC13EdvDfEkKC/RpPyldKv4Pj9utitet86EPacxb9PUTTD1ygSpTtyVuuYHhvRI/7Hj1esiM1dGB5MdwwNLoLRfaFeWjQipbDCnw9WL1LIcrPahqSkioAJFILKQY5oUNhk1KcLvmcJ9ibXYiNZI1gv09XMQd+cQek10fFWqI6F5PbVB72e7BiXlQuLlc9tF2N0J1onzD3/QxhuJpxCjFQQdpRKUsSILM98v4OCRhtgN0Rr8i5sn06iC9OV9rBtvTkY0taqSJSNmGvfB3Timx4QVYVatVzR0NzawU6f1YzUBxrCIE0tTnfKfBn0sh9FXpAr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Tn5AGGrH4UW8Vo4nmKMZSlVY5ldP6FMXoCV9OGM+i5M=;
 b=Kuj9FYYxZ5XvJpbl1CM7YHkEP+2sYf+IiqEDpjD+70JveniTIWbh44yQgnBmNVTPX+tamxl+17VwCnPb3SchH6b7llN2BTmHo1JVCDXXK+t8H6PSGTN4JJV/lqjT9Kd2GnH40h7KEY4ConBNVX9/pgNbW9QBtPWThQUMEYoHqgXwwl0Yugu+yNG3dKovK4cSzqul9T4NgptvmCyJbJXDuef/azbyEbEGSR6Sb42y7mlNnksbKUO348aiBiBFsxi+YZGw1brQqkbkvVEU4k4EneNhtVb/l9ofLf+5RlVKsSZTdwFLe6PBSeG+91ca+YaMajR6RCrgA/7taRC9bZTKEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tn5AGGrH4UW8Vo4nmKMZSlVY5ldP6FMXoCV9OGM+i5M=;
 b=IhaxTLVG2OOrAFGLVAw8B/tvMlmP/vgaSfJw876P7QeSvYujDGZ16qrmLENav8b8Z0AboTUaYEhc2zD/KbO5XFpSnTMtSLzJciJlYXwbr/Lr4b99v6dmB6GsfWRKy+OzXCISjQIwfFdc+Lym8z6UtasPSwbv7Nh3TuCmUIi+bqg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Tue, 7 Sep
 2021 10:51:11 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 10:51:11 +0000
Date:   Tue, 7 Sep 2021 10:51:04 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     "Yao, Yuan" <yuan.yao@intel.com>
Cc:     "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
        "Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [RFC][PATCH v1 00/10] Enable encrypted guest memory access in
 QEMU
Message-ID: <20210907105104.GA17821@ashkalra_ubuntu_server>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
 <20210902140433.12994-1-Ashish.Kalra@amd.com>
 <BYAPR11MB37179FAB0D067E0177498E2795CE9@BYAPR11MB3717.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB37179FAB0D067E0177498E2795CE9@BYAPR11MB3717.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN6PR2101CA0019.namprd21.prod.outlook.com
 (2603:10b6:805:106::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN6PR2101CA0019.namprd21.prod.outlook.com (2603:10b6:805:106::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.3 via Frontend Transport; Tue, 7 Sep 2021 10:51:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 515eec02-d1ec-41b9-e3c3-08d971ed6789
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26856816FC10CA0202358AA18ED39@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PcCpBMdeEaOnI/jIyBsNuSm5MXM9FcS6qW9OTrNj61CR780hj4F7AvCEE++jlt4ME71ZhbAkv/J/HDOqw3IG75qiCnS4DAP9W2V0yHnkP/OJuJBWbs3mQ3Pf6uuhP4bK7Z6rn+blfTAfWEpSFan8aPaL7Fs6oVsSY00sz6Mu/GWGuld6zvYnFtbBnHt0yKXA/cJG8oqWj/lfRL8pVynwJHuxwFEsqZiJlCDqbwrlGWJJH+aoI0ay2BRLgy7T+qRslIGHV5J18Zn98XliKocNQUEYFPhROOKfcDhb3H8IRH8akYCAvMvXdzi0o6LnM1h+WkBnqiOUsQJTKpQAmUtfMkQEPjkZlKsK8pCc7xfMSszTwzZZyF4BcAB5zcDb2bBPuEDtGojSdMFfKQ/Ui/+QVkD0kukUMJV6tSLIFE/B1YU0iTSBgQrgSKrly66618dUvMktiGV4oUNKmF0ZpwQbuox0LQonaDgl8UgKbE2h/7+pt3tpJp4BbMd6JhdaHl+ZQKWmEJuNVkRnUx1/TttN1MIR/vEgTex8sTin8glIHrWsX6DH5SIHqNpV+MIkYANKXCbDkcsajqndMRdDvAzntyswn2+G/9bS4zeQCqKR389b+qzDX4sSbY+PIpxtsRsDt2ozCt2ycq6mwfiBxaOaQAD16+poaeUGaHxtNY933xj0VCUrZVqTBE2EupW/Prn/LrxSB7uwNatkTTODJucRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(66556008)(83380400001)(66476007)(2906002)(33656002)(66946007)(7416002)(38100700002)(956004)(86362001)(8936002)(38350700002)(33716001)(8676002)(316002)(1076003)(6496006)(54906003)(6666004)(478600001)(5660300002)(186003)(55016002)(9686003)(26005)(44832011)(52116002)(4326008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FbX8yN4aWVYAe3eYSjgixS7zCDJX72PmvogBNI8t8UakrcKTH52CCZBKmSeK?=
 =?us-ascii?Q?A4KFcSNJnn2DymbCqQrxpA1FkqN3IAHTvVO3dj692fRi8hh+1Vtd2dH/rDhZ?=
 =?us-ascii?Q?kMihN45bsD708FGfgDVEaSSQQ3VlE4//J8CqEJsuVGCc+xmGjYKdQjNlOhlg?=
 =?us-ascii?Q?/dj8nIST9LqA6RnxCATaq+e10ncHV+WNZrp7+8szw264vWSH7QFafGKIWkzE?=
 =?us-ascii?Q?IY8vonA4g50/ZyRmAYPVKpkjJBc0/letkbpEqKBTsX0tJNPIrgFywcALY2bt?=
 =?us-ascii?Q?XUr4wSpEFVJ4KCwbDzJrNxYWRvFach649luUMo2NVvJVig1tyIRku3vg+FSK?=
 =?us-ascii?Q?csuO2Jl5aJRLKwWay9HDiExaVPzeHbvfCI9+kbCt/qW0roD0Sa+ZOappEhxj?=
 =?us-ascii?Q?kJrBN3hSEmrwvqJ9DUyhJfbbUI/J1CTVdD7+uW4K1n1RIDVy6leJgnQuveWc?=
 =?us-ascii?Q?K8s6rVPUyt/dhV1HJLT9lVticH50uSbe7UtbdDEe0dNiZ+RFLnipaKSoeVPS?=
 =?us-ascii?Q?CbjxTTZhat8bsLURO0TUjl1nhDo/wuy6oFH2VocRjrfGSQsH1PMuzezx1cCj?=
 =?us-ascii?Q?66rmKgD3F0zIPi4zjikRHKR0xL8RaxcFo1QgNJ8tJLovti1W1DnJb+XYDB71?=
 =?us-ascii?Q?6kAKqGQi3SLM9kpbWP/hg3LEYLb5oZ8Xap4urNj6UReQFh9oiQ25Vj00ja7O?=
 =?us-ascii?Q?m0rq+pRzGiGnIia/1mJUimOAaaoiosawm/dshqvXYALaFTQ8NPiCMTtSPUBl?=
 =?us-ascii?Q?g6QD98Ndp6+6ASEodftixHI9r6yRnhg/900Gr3tscbZcKS0D9U2Syr1ONQEH?=
 =?us-ascii?Q?eIbi7ADmec4lfPSDqcxFuMNmxhkMgCpOfCkUC+W2TFHq232HKqxvuHEF8Isz?=
 =?us-ascii?Q?e1Ts65CStEhb/cZoWlTfNBptP66KUhCjiFbhak2qBuT5FUg3Qa/mIeIWWZSa?=
 =?us-ascii?Q?YN0orZRfGdVNDPkQZ5XStXLiuRblhkc4OmLSmlLNG4uOTucEvhvSnFXNgyGN?=
 =?us-ascii?Q?huPVTcmPNl9gxn6BAAWz04jRAi9bgOe6uT+e5GF2JpScfJd0+XGEZK6nP6DZ?=
 =?us-ascii?Q?+zXqKVSzP9PaFzz6HmCxa88NpbEmVvnmtnXpybKsJWI2u0qLTI0NCxQ3AKdv?=
 =?us-ascii?Q?35ut+5hsnbLI6iv/c4g+m97kh+7M77PRDmT3tDw2VPXOa+QmJ/0C6YqAEArE?=
 =?us-ascii?Q?jZfbR/tl7dZxNl3zxQ/y1p44BhMOjykNef4dWVPRIzHp1X+dLVIsV6u2et9I?=
 =?us-ascii?Q?W834fYX64E+fJbDfMSTQofDCOv4LIj0iDw4hqI3uowtk5DATCeLcIASJR4bJ?=
 =?us-ascii?Q?ISSorfBmBlKa2cn4bAfToryg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 515eec02-d1ec-41b9-e3c3-08d971ed6789
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 10:51:11.0981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TkqHLVpK7me1zfTy5aHis+6pPLo4U0M83HzYiPEk7i2hRT+yIKIc3E+S34NzjL7EuvJgas27r+fNf5qbMKdsqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Yuan,

On Thu, Sep 02, 2021 at 11:23:50PM +0000, Yao, Yuan wrote:
> >-----Original Message-----
> >From: Ashish Kalra <Ashish.Kalra@amd.com>
> >Sent: Thursday, September 02, 2021 22:05
> >To: yuan.yao@linux.intel.com
> >Cc: Thomas.Lendacky@amd.com; armbru@redhat.com; ashish.kalra@amd.com; brijesh.singh@amd.com;
> >dgilbert@redhat.com; ehabkost@redhat.com; Yamahata, Isaku <isaku.yamahata@intel.com>; kvm@vger.kernel.org;
> >mst@redhat.com; mtosatti@redhat.com; pbonzini@redhat.com; qemu-devel@nongnu.org; Yao, Yuan
> ><yuan.yao@intel.com>
> >Subject: [RFC][PATCH v1 00/10] Enable encrypted guest memory access in QEMU
> >
> >> - We introduce another new vm level ioctl focus on the encrypted
> >>     guest memory accessing:
> >>
> >>     KVM_MEMORY_ENCRYPT_{READ,WRITE}_MEMORY
> >>
> >>     struct kvm_rw_memory rw;
> >>     rw.addr = gpa_OR_hva;
> >>     rw.buf = (__u64)src;
> >>     rw.len = len;
> >>     kvm_vm_ioctl(kvm_state,
> >>                  KVM_MEMORY_ENCRYPT_{READ,WRITE}_MEMORY,
> >>                  &rw);
> >>
> >>     This new ioctl has more neutral and general name for its
> >>     purpose, the debugging support of AMD SEV and INTEL TDX
> >>     can be covered by a unify QEMU implementation on x86 with this
> >>     ioctl. Although only INTEL TD guest is supported in this series,
> >>     AMD SEV could be also supported with implementation of this
> >>     ioctl in KVM, plus small modifications in QEMU to enable the
> >>     unify part.
> >
> >A general comment, we have sev_ioctl() interface for SEV guests and
> >probably this new vm level ioctl will not work for us.
> >
> >It probably makes more sense to do this TDX/SEV level abstraction
> >using the Memory Region's ram_debug_ops, which can point these to
> >TDX specific vm level ioctl and SEV specific ioctl at the lowest
> >level of this interface.
> >
> Hi Ashish,
> 
> Yes, this new ioctl is now working as the low-level interface for 
> Memory Region's ram_debug_ops. SEV can use 
> kvm_setup_set_memory_region_debug_ops() to install a new
> callback to KVM for installing SEV only low-level implementation,
> then call kvm_set_memory_region_debug_ops() to do Memory
> Region's ram_debug_ops installation later.
> 
> 

Ok. Yes i think that should work. 

Thanks,
Ashish
