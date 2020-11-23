Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444FE2BFE37
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 03:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgKWChq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Nov 2020 21:37:46 -0500
Received: from mail-eopbgr30061.outbound.protection.outlook.com ([40.107.3.61]:47867
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbgKWChq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Nov 2020 21:37:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJGS/sU/5RvdNj994HudHX0ORux1SWHhL8tIuq9gXNA=;
 b=lN5KXZlTPQoGY8RHSGsGxWwCizaXF8BAmcbv/CE1g/ZrqT1+oK2fEsmSPfLz49yw0sTOeWCMm0d4v+q1K9Z47tSb6ks+T7kJpCzNfIooqU0TeQUGd9pcHOXQU3a3pChKZ8VULyuu83hsUv+botrMDReRGD7AyYO5pQpzqRHRuvA=
Received: from AS8PR04CA0034.eurprd04.prod.outlook.com (2603:10a6:20b:312::9)
 by HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Mon, 23 Nov
 2020 02:37:40 +0000
Received: from VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:312:cafe::7d) by AS8PR04CA0034.outlook.office365.com
 (2603:10a6:20b:312::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Mon, 23 Nov 2020 02:37:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT041.mail.protection.outlook.com (10.152.19.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Mon, 23 Nov 2020 02:37:39 +0000
Received: ("Tessian outbound e0cdfd2b0406:v71"); Mon, 23 Nov 2020 02:37:39 +0000
X-CR-MTA-TID: 64aa7808
Received: from d7b48872ad75.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 241C2D4C-0E0A-4B85-8DBE-1340494CC5FB.1;
        Mon, 23 Nov 2020 02:37:34 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d7b48872ad75.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 23 Nov 2020 02:37:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4ckw4qhWGlyIAAE3yTmC2rQN/Y0ahYN3ixKcauuKhBX7m2ykveuV6vM/LgeTFEpcabJwoCgqhW7Pd1Y5OcMSq6QZElUCBnrJ6wAQLLevkW6nIWfiuQjyL74hDN2WxOovds/CUN7BCqipYrbwbn75e9tgm0mW5G27aGN+Cxo6Ni577lfVZ3jYDaKEdRYwNs0P87FP8+W8CzX3s03v0l9PI78qcvTi+Cje64bm+yuLwnHm6lwBJQn3SACcZBJqWS5vJch/vZhmwrX0bwqDZQSXTkmcbTLvs4A3Sh0jdJ8tJoc3RQYtY3kyyqXA6k5G4jkthqaE89FWrcTVwgQuu5lwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJGS/sU/5RvdNj994HudHX0ORux1SWHhL8tIuq9gXNA=;
 b=HIKQkGzjmyNq4EzBefte6B2OfOFil3l+JfjS7YG8Zwgx05P73iciJNa/iDwDX3aRhJPBYy8HwC6utJDT+hYknwNtaoWGg/rFMZvNRbFbleEXyk2AM/RnDaxrpWvpdWUn3g2jT+wZabs6h01Q8HzdcZQ71XnSN8066FaUNzaaCa8cBuP2VlyyB+gggZGO5VjJm7sn0Hxr4m10kUk2NfkqBmyXnv6J6Usdq1HCfm++9ke8AGjXv6V4TGWPw0P5jFc6YKiVxuW496/hKkx217H/KACDBPhbEi1gpc4jhyXULuxZ3oEHDeOLEMqE8lTS/yZFyRwBm8GrulJS6kCetVYFsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJGS/sU/5RvdNj994HudHX0ORux1SWHhL8tIuq9gXNA=;
 b=lN5KXZlTPQoGY8RHSGsGxWwCizaXF8BAmcbv/CE1g/ZrqT1+oK2fEsmSPfLz49yw0sTOeWCMm0d4v+q1K9Z47tSb6ks+T7kJpCzNfIooqU0TeQUGd9pcHOXQU3a3pChKZ8VULyuu83hsUv+botrMDReRGD7AyYO5pQpzqRHRuvA=
Received: from AM6PR08MB3224.eurprd08.prod.outlook.com (2603:10a6:209:47::13)
 by AM5PR0802MB2611.eurprd08.prod.outlook.com (2603:10a6:203:a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 02:37:33 +0000
Received: from AM6PR08MB3224.eurprd08.prod.outlook.com
 ([fe80::98:7f10:6467:b45]) by AM6PR08MB3224.eurprd08.prod.outlook.com
 ([fe80::98:7f10:6467:b45%7]) with mapi id 15.20.3564.028; Mon, 23 Nov 2020
 02:37:33 +0000
From:   Justin He <Justin.He@arm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Thread-Topic: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Thread-Index: AQHWvoBE9VjkV/EoWUaRm8NTyyUuUKnPr0MAgARUHrA=
Date:   Mon, 23 Nov 2020 02:37:32 +0000
Message-ID: <AM6PR08MB32248D873EDD8923675F2D3BF7FC0@AM6PR08MB3224.eurprd08.prod.outlook.com>
References: <20201119142737.17574-1-justin.he@arm.com>
 <20201119100508.483c6503@w520.home>
In-Reply-To: <20201119100508.483c6503@w520.home>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: FAAC97BEDA3E504AA760A11F4A68B623.0
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 290f551c-e6d0-4522-4e1a-08d88f58bf09
x-ms-traffictypediagnostic: AM5PR0802MB2611:|HE1PR0802MB2555:
X-Microsoft-Antispam-PRVS: <HE1PR0802MB255586C370D7A8AD4C680F89F7FC0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2150;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: uDdXrTSXs9iApxbrQgRCqcjCCOVoFoA356VEvje7sOtn4n7UyMsdfFIe+KIKCd6m2p2G3oCQ2jCJJFQycG1mztarybZBHpbnStxB+cHcnmyO+/11OKJPA0twDlLH+wvi5ntExvuKBtgci2E5Zr3x+PtK63fXq5Gmr5veC94nKGcRqErxF6Rl11DZnyQuRh5yHf7vAZSDzBjdSSZBs1ZLpnIpkty5ygjvDZS66aWzWdfLxP9s1mxt4YhsL2flkSHkVj70lt0bU3Xr+AOlOowdwLLrRUK0mtqJdPpnquVk/YzlVAWdBmNpgabM1XKL70QztrDG16lwJ6KLaFVcn4sFFzo/Llq9cqs7Ci5+O1Yv5inIGfJUxS8mf32FPEWmUgzkVtRhY3BS4PMPn7M58YjR+A==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3224.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(396003)(376002)(346002)(136003)(6916009)(316002)(186003)(2906002)(54906003)(83380400001)(52536014)(9686003)(6506007)(478600001)(33656002)(966005)(53546011)(26005)(8936002)(8676002)(71200400001)(7696005)(5660300002)(64756008)(66556008)(66446008)(4326008)(66946007)(66476007)(86362001)(55016002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: zD6qQqllVqPAxfO+CXVp9RAoMXg5ww7tx9ajlN4O9VciHZbXFNpCjc0hGJLzDIz6HK2s9Clwp2W3O9yKqL64UcDBpKxCa2XvpRxq+6gyolJ/dXfvsq5z5cy8r8k9NRGeuHe9B3Mtt6Gm+O9pBLPjkSBKDWbBmqN1eXhgzfW3xyp8clCMalpVzLhfA+9mz7wqeQOXhWljY8PWcU7b2yAwUppH4DedUNDUrezmx0u9dHYOr1FxrK6QCqYYFPlnEeBHboR+r1NRzpLSmCkA1N4XCblCSX4Pr3ELa/iuUZsXAFcnH0+iDpADh3FFJ+tJ50xKkZsGFL13XdWbi4xIzoCAC7lDK3hV/S0FEtfSYMwel6jKWNQob/sjdj74K7QRqOA28oYPECl5ESFflePCldNHeSly5XN0B+DeRMNAi8ltZGLQLyp+QIK2s9VW8Tefp3TKlezaRISHJ3H+4uqwrHy8aoSFY9G4dcPZGBhv5KQL4pyFDU10NjOl13e3hcZHAaL1gVdLDYUCy2uyF2Hl/Gr5+ggpXiLWxsD2+IWAAD79AlpCBzm0cmFUVR47zKD7q6kmG6lX5q9/ZO1A8MS3/LFqR+wv3xtO7qAWMp0U+E0UGydKsz/8MvFENjWjxJXxeHpY3R27EHgvCmEMXwYJMo8q3w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0802MB2611
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1d5be055-c652-4720-49b8-08d88f58bb05
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZzS1aFjEpXiLVTyEdlqzeE4mhiiYda5psgHiZgvruyabUtml02yigx3eICeLnafwibcyhxqClHe+e94puxtmDJhNiRAqLWdFhZP+vcN4Uzy/FPjR8IkhNRFz3sNGW1BsPaQtL8tOns5NpkgPLKk0Ut3+g0Otuj6LOAAtu3fi+lU4Bp/3WhhvusNflOViO/ppsoi+xuojfasbVSRSREl+D9lRZErtZ9YI+acs1s6puUGUZz8gnxOfb9ZzJNDgW5m7Hj93eiasClJM5Mr0HiMwaILkN4anoqlLqs5Yve2OHag91NyM8ieI9uqlXk1fPKt5iP5BEt6UO+8IrdiH8GH1RzMO7R07JIarxW95O85ndrCmQGmdUutkH9X4kPV6ZRm1YvMKJOtuPEyS14jMUMNPWPNLbpcTQPJ996Xkv26b6MkHmNiKcUXxps0zF8HpR3/ngB6ngwEwRyvIQYRH+tKYspKEW2ZZHvyBJJrJqgwu30=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39850400004)(346002)(136003)(396003)(376002)(46966005)(186003)(82310400003)(33656002)(55016002)(26005)(4326008)(8676002)(53546011)(6506007)(52536014)(5660300002)(966005)(7696005)(9686003)(6862004)(54906003)(478600001)(70206006)(8936002)(450100002)(83380400001)(86362001)(70586007)(316002)(82740400003)(356005)(2906002)(336012)(47076004)(81166007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2020 02:37:39.6018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 290f551c-e6d0-4522-4e1a-08d88f58bf09
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT041.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2555
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex, thanks for the comments.
See mine below:

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, November 20, 2020 1:05 AM
> To: Justin He <Justin.He@arm.com>
> Cc: Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
> vfio_pin_pages_remote()
>
> On Thu, 19 Nov 2020 22:27:37 +0800
> Jia He <justin.he@arm.com> wrote:
>
> > The permission of vfio iommu is different and incompatible with vma
> > permission. If the iotlb->perm is IOMMU_NONE (e.g. qemu side), qemu wil=
l
> > simply call unmap ioctl() instead of mapping. Hence vfio_dma_map() can'=
t
> > map a dma region with NONE permission.
> >
> > This corner case will be exposed in coming virtio_fs cache_size
> > commit [1]
> >  - mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> >    memory_region_init_ram_ptr()
> >  - re-mmap the above area with read/write authority.
> >  - vfio_dma_map() will be invoked when vfio device is hotplug added.
> >
> > qemu:
> > vfio_listener_region_add()
> > vfio_dma_map(..., readonly=3Dfalse)
> > map.flags is set to VFIO_DMA_MAP_FLAG_READ|VFIO_..._WRITE
> > ioctl(VFIO_IOMMU_MAP_DMA)
> >
> > kernel:
> > vfio_dma_do_map()
> > vfio_pin_map_dma()
> > vfio_pin_pages_remote()
> > vaddr_get_pfn()
> > ...
> > check_vma_flags() failed! because
> > vm_flags hasn't VM_WRITE && gup_flags
> > has FOLL_WRITE
> >
> > It will report error in qemu log when hotplug adding(vfio) a nvme disk
> > to qemu guest on an Ampere EMAG server:
> > "VFIO_MAP_DMA failed: Bad address"
>
> I don't fully understand the argument here, I think this is suggesting
> that because QEMU won't call VFIO_IOMMU_MAP_DMA on a region that has
> NONE permission, the kernel can ignore read/write permission by using
> FOLL_FORCE.  Not only is QEMU not the only userspace driver for vfio,
> but regardless of that, we can't trust the behavior of any given
> userspace driver.  Bypassing the permission check with FOLL_FORCE seems
> like it's placing the trust in the user, which seems like a security
> issue.  Thanks,
Yes, this might have side impact on security.
But besides this simple fix(adding FOLL_FORCE), do you think it is a good
idea that:
Qemu provides a special vfio_dma_map_none_perm() to allow mapping a
region with NONE permission?

Thanks for any suggestion.

--
Cheers,
Justin (Jia He)
>
> Alex
>
>
> > [1] https://gitlab.com/virtio-fs/qemu/-/blob/virtio-fs-
> dev/hw/virtio/vhost-user-fs.c#L502
> >
> > Signed-off-by: Jia He <justin.he@arm.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> > index 67e827638995..33faa6b7dbd4 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -453,7 +453,8 @@ static int vaddr_get_pfn(struct mm_struct *mm,
> unsigned long vaddr,
> >  flags |=3D FOLL_WRITE;
> >
> >  mmap_read_lock(mm);
> > -ret =3D pin_user_pages_remote(mm, vaddr, 1, flags | FOLL_LONGTERM,
> > +ret =3D pin_user_pages_remote(mm, vaddr, 1,
> > +    flags | FOLL_LONGTERM | FOLL_FORCE,
> >      page, NULL, NULL);
> >  if (ret =3D=3D 1) {
> >  *pfn =3D page_to_pfn(page[0]);

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
