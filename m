Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D9830CFC7
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 00:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhBBXOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 18:14:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhBBXOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 18:14:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112NA730037592;
        Tue, 2 Feb 2021 23:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=xyshzEY9rl6eMkXnRbpcTb5L8E2kFTcPwj3mIRktV4Q=;
 b=UP2LGaxWkMSFulwbjtZXKzBu2I0J54GU6A6gLpAojfJKftDuoRack/aFsFU3e/Yii7yD
 /WlHNlTj16DyXU04YLAn08GiFQeTOVQ1Yd6+YnEg6Q1GPX6dUWkwz2h7lqp8whSTV680
 rlEZLFPAgMcJhSCqg2ztXUxmpG/X0f6cvNe6J7jUZppgGpOVyrp3XodKl3aCps6YkcDJ
 pHiwemAneXb7QCecOwBVp9UWlkVYsbSe9IzoTT9YcDXtezEisVYr700RD2HOya95bOeQ
 cFEMhhETDLIg4MbxavAzeQwHBLiMVBxbADfN460w7vga9IjVPcaAsfosPDlZmABAuRuv OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36cvyawg6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 23:13:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112NAZp2032374;
        Tue, 2 Feb 2021 23:13:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3030.oracle.com with ESMTP id 36dhcxgc15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 23:13:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZSfN6tJ7joO8cIUUMxAzKgtaWN3RCZDKtg0p6tskpo1XyHOsfhJodUOTN8LeeIJGdEgjry2NtMcoFUQiVtsjic8QvlRAv70LmjO8iHxl8CwftR3ncz+F95Ci3I2cqKIuOsigzAyRu31sacPGqOJVOmEmiVBI/88OpvAF6I9N72fsrT9kfAA9mxkdsitrpIHfXY4kZJuBZ/OeMKNGpbn4avBS4dy0NMFRwpSbFuLi0wpU7XRV6PumQQPzkTtSPew85jHe3HZ24hh1koPVJavoCbj1KfqDe7+nmD30X9cCxNg1/SFeqZkOIEsRwpoYrGMpiLMYT3mHrC5Rx506JZz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyshzEY9rl6eMkXnRbpcTb5L8E2kFTcPwj3mIRktV4Q=;
 b=L+xKTNuXczUAEQsyjUauhTkLG4UB9KWj5lJ41/ksffJlGQ2aeR57k3rdt5+GfhfhwzTU/EoQcdRmnD26d45GCEGcMydtxBU88+Xy6M27JOkLjmoKwYJsiHdIZjTzNrHhaWI9T/ZxUh2q6iJETi8VQ3L8OWGYOz/I8+fGt8CHJRBoXjmFwLtV+md8iU6vXot6FOIZm+QkCGfzOTWKKJtDS+uMapUWByA6fHgwyBpr3w/9xnapqhnbRwqgaH3NKuum1lr3T4zFvG/+DxB/PlpoMUGyMJHu5POLZr/52im87N1xUy48C1lj/Gcwg2OunaEFVvzJHfYS2s1YTCk+MOEhiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyshzEY9rl6eMkXnRbpcTb5L8E2kFTcPwj3mIRktV4Q=;
 b=qLpc0juMbErK3v/8/W/EXb+hbxi512IJrVs+tMD4R5Wq11lwtvgqcugm4WKTSQc0CljwYbQyTwT75EVLbMh0fWkpJw+uirGT+V9ehBjSVvzTY8rWhHocvMhyEZuRMKOMnUYTcE03hRdaqmSOOtC8C8b9aWL03CNEV1Yrh16UeQ4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BYAPR10MB3304.namprd10.prod.outlook.com (2603:10b6:a03:157::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Tue, 2 Feb
 2021 23:13:22 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::e180:1ba2:d87:456]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::e180:1ba2:d87:456%4]) with mapi id 15.20.3825.019; Tue, 2 Feb 2021
 23:13:21 +0000
Date:   Tue, 2 Feb 2021 18:13:16 -0500
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>, joe.jin@oracle.com,
        dongli.zhang@oracle.com
Cc:     Martin Radev <martin.b.radev@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Christoph Hellwig <hch@lst.de>, file@sect.tu-berlin.de,
        robert.buhren@sect.tu-berlin.de, kvm@vger.kernel.org,
        mathias.morbitzer@aisec.fraunhofer.de,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, robin.murphy@arm.com,
        kirill.shutemov@linux.intel.com
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
Message-ID: <YBncjOptRKHd1md/@Konrads-MacBook-Pro.local>
References: <X/27MSbfDGCY9WZu@martin>
 <20210113113017.GA28106@lst.de>
 <YAV0uhfkimXn1izW@martin>
 <20210118151428.GA72213@fedora>
 <YA8O/2qBBzZo5hi7@martin>
 <YBl/4c9j+KCTA0iQ@Konrads-MacBook-Pro.local>
 <62ac054d-f520-6b8e-2dcc-d1a81bbab4ec@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ac054d-f520-6b8e-2dcc-d1a81bbab4ec@amd.com>
X-Originating-IP: [209.6.208.110]
X-ClientProxiedBy: BL1PR13CA0466.namprd13.prod.outlook.com
 (2603:10b6:208:2c4::21) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Konrads-MacBook-Pro.local (209.6.208.110) by BL1PR13CA0466.namprd13.prod.outlook.com (2603:10b6:208:2c4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Tue, 2 Feb 2021 23:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f8313dd-c599-4d17-59c7-08d8c7d02221
X-MS-TrafficTypeDiagnostic: BYAPR10MB3304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3304E01A1B85C51757B2C46B89B59@BYAPR10MB3304.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ac0EtpF82jwbsSaUBKiHYFy3/9IyHTRFBo5oi7bb/xo3g1fHjWaMGACIQ7jOyCjCd0tqk9F/m4LYspzr3RCul7Ky7J0F7QgIziF28NWCp070zDStw4JbeD4DtrGbviSIEuHoPWUsK+bpQw7/pvQwer3nQfGY7vPIN099zxSLuNZY5BCcNUFPvVW5bxFvGd/bNHfmq9MXPj98/zpeR56Hq+nzwtsergBWYdswxhSUdbfwMHEokuZPcrpUm+X5QpVP9UsV8pxjt5KOmxZVw081aIHBUi/RnnBBtVgBQkPRyx5Mrng/5l0DxQQcewm8qnZnfZESCM+m2RtcSPDhUny55OVrKDZPywFysRbe32u9ky/ma9Q83nsQN5JG7Rl4dLgxASqAvPiiojKSCjcuNRzBhQwZUg96Mm+DSTnwY8f0X6FKAICPjoEKMvBUFfq/vN4JaD4JueNLng6J+Dtq0s4Kv+OgCyMbTib7PmhuIPK9XTgCtN0q38ubuZkdZYK483nenqmH4AWuLRZDZXBIuF1TiDoBO/GpvJPFuKqDFY9YtpCChzFxNMOz5J0RbBaRw0HEne1ngjSYovrlwR7HSwee/fuB4yc7wrYYoOlTAQwI6Q4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(136003)(366004)(66946007)(52116002)(7696005)(8936002)(956004)(8676002)(478600001)(54906003)(6636002)(26005)(55016002)(316002)(6666004)(66476007)(45080400002)(66556008)(5660300002)(6506007)(4326008)(53546011)(9686003)(186003)(16526019)(966005)(86362001)(83380400001)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bIVPt+Bspiv8wT17lrjXylLnyXuoTsULDvwRQS00DzwtfW35rlSIkROAsUBY?=
 =?us-ascii?Q?t8fvG+RrGqczFtzXzmBztOq2rLcFjIadSZVpCYQ4hGaz3pt/OYtjxSLH9F5b?=
 =?us-ascii?Q?b/+io7KuVEdPgkU5ISytoj/zfJpvdL0aq+xYFegIktLms6oiVo52uY2OZWkz?=
 =?us-ascii?Q?Ps3CrjKX4StS0GUxf53MK38HCBejE1tFXadoZBJuOY0xPRRzDqm7pjQkj4xc?=
 =?us-ascii?Q?Ttw9mfwE021MltqLE0VPA0U2n/Jrp/LVWuVLJTAUZU/FGAo7ADgQmZA5TTel?=
 =?us-ascii?Q?wUDqr3kO0+lb7bxYRvGC8rfqD+a6TO7PF7GxP5EJbUPXiJ9+j74iFZRaRDme?=
 =?us-ascii?Q?DqxUN+S3/KWKUeclg506m479WlgNPClzMEvGcbBQJja9AqIi3wb+IwSRulVN?=
 =?us-ascii?Q?CSW2a9JGIDq3PhvrEo4Xa8FOuUo7Tv5MkTMvbkwDMBhkWnVxhN4An+94eLu5?=
 =?us-ascii?Q?1XEDaN/Zb6aIWn782dtVfC9ws4pWFdSUHpP2miyjJwhnZsarWpgZLneODZQR?=
 =?us-ascii?Q?6k0jXB3Iq7982BmMnTjJMALjMcl8EZ6GM2FamRRVzlQGbxK2rWfvNmMspefL?=
 =?us-ascii?Q?3EJpjkmJReYsgShxIZ9NM3dK3ON6UHPbUQGSM/GUwm6Gq1skd33x5C9FwxcA?=
 =?us-ascii?Q?5AnvqAdUeDxzRn9movNRwzkmbZS6FDp2DVaP+V7fIAMwGa5+PKkxCOGZSlO8?=
 =?us-ascii?Q?QhufwuK7tC4WGLJr8JxEJU9R6Hdz2YAH2Jup/xi9+txb2R8yYw+Pa0dGxbkZ?=
 =?us-ascii?Q?/BdijPDrmGKMKL8UoeK7slFilQiZst3Dsnj135f7Eg2NPAVSeivypbo/e4IP?=
 =?us-ascii?Q?Gh/JnJ8R2Opd8a1FRTNdNYdRbDA2/8pIiMaG/HCEyAAiDIeKGR/Rjoy8PiIK?=
 =?us-ascii?Q?dcnbPM7rRLTGnESqQIS3L+Nh8Cbdtkg+CWde2eohVui3J10JExWmewXyuU6S?=
 =?us-ascii?Q?xyGaeSlr34EtSlVYE/QyivWfqETZ4iK637/WPEWkn7d/GnylraKs7HXYEJpA?=
 =?us-ascii?Q?1cTdJIW0XJ8bHNW17iEyICnPp7P2q2CjJlsuBgeAk9mI33wvYfNna2Y6/V4j?=
 =?us-ascii?Q?89uGjEpd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f8313dd-c599-4d17-59c7-08d8c7d02221
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 23:13:21.8417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MMKBCidv4pPRgUxF5NqjdhK5UUSuAYEjd7pvljA7BYaOO3WaGYruxrRsuNfSeT/hrugcJeyGKZcTuQEB6a+shA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3304
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020147
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020147
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 04:34:09PM -0600, Tom Lendacky wrote:
> On 2/2/21 10:37 AM, Konrad Rzeszutek Wilk wrote:
> > On Mon, Jan 25, 2021 at 07:33:35PM +0100, Martin Radev wrote:
> >> On Mon, Jan 18, 2021 at 10:14:28AM -0500, Konrad Rzeszutek Wilk wrote:
> >>> On Mon, Jan 18, 2021 at 12:44:58PM +0100, Martin Radev wrote:
> >>>> On Wed, Jan 13, 2021 at 12:30:17PM +0100, Christoph Hellwig wrote:
> >>>>> On Tue, Jan 12, 2021 at 04:07:29PM +0100, Martin Radev wrote:
> >>>>>> The size of the buffer being bounced is not checked if it happens
> >>>>>> to be larger than the size of the mapped buffer. Because the size
> >>>>>> can be controlled by a device, as it's the case with virtio devices,
> >>>>>> this can lead to memory corruption.
> >>>>>>
> >>>>>
> >>>>> I'm really worried about all these hodge podge hacks for not trusted
> >>>>> hypervisors in the I/O stack.  Instead of trying to harden protocols
> >>>>> that are fundamentally not designed for this, how about instead coming
> >>>>> up with a new paravirtualized I/O interface that is specifically
> >>>>> designed for use with an untrusted hypervisor from the start?
> >>>>
> >>>> Your comment makes sense but then that would require the cooperation
> >>>> of these vendors and the cloud providers to agree on something meaningful.
> >>>> I am also not sure whether the end result would be better than hardening
> >>>> this interface to catch corruption. There is already some validation in
> >>>> unmap path anyway.
> >>>>
> >>>> Another possibility is to move this hardening to the common virtio code,
> >>>> but I think the code may become more complicated there since it would
> >>>> require tracking both the dma_addr and length for each descriptor.
> >>>
> >>> Christoph,
> >>>
> >>> I've been wrestling with the same thing - this is specific to busted
> >>> drivers. And in reality you could do the same thing with a hardware
> >>> virtio device (see example in https://nam11.safelinks.protection.outlook.com/?url=http%3A%2F%2Fthunderclap.io%2F&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7Cfc27af49d9a943699f6c08d8c798eed4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637478806973542212%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=aUVqobkOSDfDhCAEauABOUvCAaIcw%2FTh07YFxeBjBDU%3D&amp;reserved=0) - where the
> >>> mitigation is 'enable the IOMMU to do its job.'.
> >>>
> >>> AMD SEV documents speak about utilizing IOMMU to do this (AMD SEV-SNP)..
> >>> and while that is great in the future, SEV without IOMMU is now here.
> >>>
> >>> Doing a full circle here, this issue can be exploited with virtio
> >>> but you could say do that with real hardware too if you hacked the
> >>> firmware, so if you say used Intel SR-IOV NIC that was compromised
> >>> on an AMD SEV machine, and plumbed in the guest - the IOMMU inside
> >>> of the guest would be SWIOTLB code. Last line of defense against
> >>> bad firmware to say.
> >>>
> >>> As such I am leaning towards taking this code, but I am worried
> >>> about the performance hit .. but perhaps I shouldn't as if you
> >>> are using SWIOTLB=force already you are kind of taking a
> >>> performance hit?
> >>>
> >>
> >> I have not measured the performance degradation. This will hit all AMD SEV,
> >> Intel TDX, IBM Protected Virtualization VMs. I don't expect the hit to
> >> be large since there are only few added operations per hundreads of copied
> >> bytes. I could try to measure the performance hit by running some benchmark
> >> with virtio-net/virtio-blk/virtio-rng.
> >>
> >> Earlier I said:
> >>>> Another possibility is to move this hardening to the common virtio code,
> >>>> but I think the code may become more complicated there since it would
> >>>> require tracking both the dma_addr and length for each descriptor.
> >>
> >> Unfortunately, this doesn't make sense. Even if there's validation for
> >> the size in the common virtio layer, there will be some other device
> >> which controls a dma_addr and length passed to dma_unmap* in the
> >> corresponding driver. The device can target a specific dma-mapped private
> >> buffer by changing the dma_addr and set a good length to overwrite buffers
> >> following it.
> >>
> >> So, instead of doing the check in every driver and hitting a performance
> >> cost even when swiotlb is not used, it's probably better to fix it in
> >> swiotlb.
> >>
> >> @Tom Lendacky, do you think that it makes sense to harden swiotlb or
> >> some other approach may be better for the SEV features?
> > 
> > I am not Tom, but this change seems the right way forward regardless if
> > is TDX, AMD SEV, or any other architecture that encrypt memory and use
> > SWIOTLB.
> 
> Sorry, I missed the @Tom before. I'm with Konrad and believe it makes
> sense to add these checks.
> 
> I'm not sure if there would be a better approach for all confidential
> computing technologies. SWIOTLB works nicely, but is limited because of
> the 32-bit compatible memory location. Being able to have buffers above
> the 32-bit limit would alleviate that, but that is support that would have
> to be developed.

Funny you mention that.. Dongli (CCed) is working on exactly that and
should be posting his patches the next couple of days.

> 
> Thanks,
> Tom
> 
> > 
> > Let me queue it up in development branch and do some regression testing.
> >>
