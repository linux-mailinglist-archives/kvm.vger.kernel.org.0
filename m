Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2574246A312
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 18:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbhLFRiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 12:38:02 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:27186
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243207AbhLFRiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 12:38:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbquJPgPEVNyRYfPlxTPjjOumlJQ+3Xdb74CVWHh85EL10XfSKfS/Eu0G3nL6SzwRqdRRaXM1qgDiQVuV8ZB/uzAtYbTe2Pq0cWuLaX/0JzpTEHZGf+Shr/SDqAll1IGNmI62FhwfLtcsAERxmKXtTQVTXSPtItFlYLk3PAuC2RImwzdsyW/C6pfdWvKZDwpL1sS/GWNdvQtdYjDGUtzn+aPXABpeP1+ozGVQ3EysnXIrOsCVMYk+nNQQfazYs8kPdGCHn9vjVZ01J41ZOFyx3gF+Y902v20krftQ2D2dSU4xoFqhlUgOAzYX1lvaelennuIRcEC/SKR+MKqp2zeLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYL+p1e3g7udrKYEKVeTtUiM+DWTu4VgiYnncXieVKo=;
 b=OQmFsSrcxJCLU8VZEOqCyESORARruH8YvjaKxklOPsIKF+LTkvTI7Mkp+3P+fnv9qPoLX7C9CmlEitFw7FmKS54c40CAS5oyJZfFlgUHtuXBxQHVlmbhW+5MISHlrfXFCJsVQUPdYALypTFRYUqp/Q3Gf6zGh3xuYxBaLSVkU9BBBgyHGf8zTLZMXWo79kgCUsiKTJraACVbkFLA9HtiOD5La5FmmZVOtJzR1He3ps5q3D10rVfGwHmVrhJJll3i8JVvCyKE6Tl+/xwlHdwaKn241rtMSIipPf+i2JsmFjrMBui4tZnPCMvotmj+4O7aR9osju1UQInmZBGlmSeZIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYL+p1e3g7udrKYEKVeTtUiM+DWTu4VgiYnncXieVKo=;
 b=GaBnwZV52iE2VNeHNNhaj7IWBJnfPj00eVHoRlkNWa0IkN7QUbj51hTF4WF4G8IJOaTGIV8jR/c0MXZsJcH611vbVTlkloeQ04Sx3rdo0yWe7/Og1c6HniEUyVkPrKfUnGrfhCInxf1NXHwXpWs6ZcL4sHInv4GpXhH+ksIgYgwFxp7yqqpJp9YYoZDtvSqL43i1yvF/xLwOS3i4fD2ivxA4K6dA+fCHJMvYo2azg+ruiBKsn7u7+/ENQ0W7IhuM1/ZfMlPZvi5I2PZEt9IW3ydMmJmfFtvWyOtQafdeBbpMHGEpBqSFgo/bN/iO4uIckV5Ly92AWMMN/O1rH7U+QQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 17:34:31 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 17:34:31 +0000
Date:   Mon, 6 Dec 2021 13:34:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211206173422.GK4670@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
 <20211130102611.71394253.alex.williamson@redhat.com>
 <20211130185910.GD4670@nvidia.com>
 <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgpdu3ez.fsf@redhat.com>
X-ClientProxiedBy: BL1PR13CA0154.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::9) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0154.namprd13.prod.outlook.com (2603:10b6:208:2bd::9) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 6 Dec 2021 17:34:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muHsc-008zwy-HT; Mon, 06 Dec 2021 13:34:22 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 609abe9f-91c9-453f-2383-08d9b8dea930
X-MS-TrafficTypeDiagnostic: BL1PR12MB5157:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB515733480E80A88B203D708BC26D9@BL1PR12MB5157.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzVS/ifSCIc3IPQ1s3fqVi0++Eb0XXwcL86fHgH/VXSn2tILYshzhQ5nQparlWHy7fK55rstSY/90gDITwET7LkLtB/LL4c6q1c6N4HUFWz6k2wGWNMjsy+MNQNr/CY3s2N9eesBclQsJGoddWhJHRQdiiDRQo8wq75LRmolhAaFD37lz+pBBQyKLdVIG/B/InATMFjRU9+TZ7zSf+ldpqiuWWpGVrwJLBzVS9VWct66ciePB2LYBvYFnahgNpOZDdEeKgRnG65qiFPigOvITfQH7Td9I5w/8SaK8XgBrA2lY76vRLHQwC8sdkF9XPjwBU2kEqQisU9n9Hlr4niCM//tHBPZBBOY99IRHd1rp0KX+b36SOUMzsupKP2v87WELJTaJYC1VysUp8WPU+3njgQdtJc2W8mvOd0lSpwTvL73nHRtSarzzTglaNCsv+rqXUjc4cygcteGAkSpaFGhmNbgU/gLFq6s5KYrH95H7IlEu4SA1KCv83OlnMESGYB8iIo4dPjsHfrjKzAADGE5EwVHlwKBgRhhP5IOeEXuHDE2vb/WgYgPz5T/4FW0sZmmyeLKeTCA7T03ZWE7zRXYsWQeJ4sK3NsET5FnDtjj1MvgssomBKDPIjz6bVNr76PNOIvFE87hTTWqKcPFaih97g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(33656002)(8676002)(8936002)(9786002)(6916009)(9746002)(316002)(54906003)(36756003)(26005)(186003)(426003)(5660300002)(86362001)(2906002)(2616005)(107886003)(66556008)(38100700002)(66476007)(66946007)(4326008)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MVDPlp+ImMv2ZtPKSJlMAmAjzF+Nc7w7ZyUBfmoS6J5pE9Mu8RvUJytlXVsG?=
 =?us-ascii?Q?EwMNjKMMftoI8YoRtmP5UWKC7O6uSGWC3z8qonEBebhZ60+LgBzPfj7Lchbh?=
 =?us-ascii?Q?n0fHSivMssvkIB4OoVc7mRO+TytSEnytXRa2JuqrbIWQIvfCSCPzSDTTObeW?=
 =?us-ascii?Q?+LwC1VKYxDToqoNqoWjVhUasLdsozgbHv9gfJdoF3pMk6bD0MZueseHy94Pg?=
 =?us-ascii?Q?9UWc1yawc7Ju/NXpHnsx8TRPXn5kXQ6JMmFuLpeVjk/+AyAb7G1ySaSiLiWY?=
 =?us-ascii?Q?ngdWIw7DKer9gRVD9dSAzJjn7zLOavSN8Ni+4HdU5ZucelQlE+8TmP3Xap1j?=
 =?us-ascii?Q?g669tRTNWwsSUrbV+ZI/xo5+M+K2qOJVyOWB15u3u8H7WTcV5LL/aeksz26w?=
 =?us-ascii?Q?rktL6hGdgI6Lp8lZXVjZ0EtJuPe2uH7vaqlxS2fh2Xk3wYICM26tyTf9tLbc?=
 =?us-ascii?Q?DWlTjTYGCbw/KALXyG/h0Zf4dB6jnToIwWptCJbyZWEWiye7r2TUG2Fm8gA4?=
 =?us-ascii?Q?ekH2RK4UYNOvbPKZzifD2il5RnmClI3ojK9dJ0V2dziP63Llka2n/XGvTfaE?=
 =?us-ascii?Q?x9fDlFko+V/vSSSUq91Zmtb3zt40kKW2F3Zk/SFj4lmpdnoygSipAxC936y5?=
 =?us-ascii?Q?D24GSxARlW6tJx/sLO6d2uOFY9Yp4/f4dmQhIEPgcxVDmI6rkTFMEBd3k1ek?=
 =?us-ascii?Q?yNQDlyNXnVPVhEZN8xdGLI6b24Cm8ojxAibuu38E5yuv+0QCxLZkh17XyH7m?=
 =?us-ascii?Q?ne/BktB9F4v5T+SBNXhstHWdmbEx88X7yznRBVGkklPfKM4Qz+ZpgDdslYOC?=
 =?us-ascii?Q?JkPQeVfNqWu56a3iMTpOUHGPTsuFz0ArMYQg1et1dUmu2UrrznBXoRQQ9XhX?=
 =?us-ascii?Q?Hrtabmmsd8RkhKQkxhFpRQkONyutc0H8KHWK81eTI4qOEvh2MI6gkdnuMfd5?=
 =?us-ascii?Q?fDRFyGA7YX/DTasmcrI2ZLoXq/axJ3rYuNCo5IA06IJPwgm2QLZbw0YkEu/L?=
 =?us-ascii?Q?lh9/7v2fBCZemoOdYLSDZk7jJ3DqXoMDMVQxiVIKZ8zlsXGYromT0U4qnGvc?=
 =?us-ascii?Q?zB/0xdIzBupQaOxs0VOFHvhoBcFGV19VEdM4RmzAIVd81datBYtWnGuKuLr5?=
 =?us-ascii?Q?f6My7BX9ciFhlNWoXjQzvAMArHRD3vFE4hwVXdV1MXDYjc8mylKEBTtZEGT5?=
 =?us-ascii?Q?30aZQ8PwvUpIpZfEbppHDIkDMQlXRKHQobHGpjVaaUyeqRH7nsF9dlxeN6ou?=
 =?us-ascii?Q?1w/JQcxeSj4H1QQQoUIn1sNObpCfe1cxy0aUCNHC2gTQ8ASKgFPxgom2aoA1?=
 =?us-ascii?Q?b5a6u45AZGiiqn/7vbTc5LOygthrvND71nUHqSvomNAjl4AquTj9eyGd28DL?=
 =?us-ascii?Q?cLhl9UbyLmGV72E6Qn1tNNf50ftKoVcQPItGNFW5J61n7q6rPcvWNRmr4TL4?=
 =?us-ascii?Q?z+2v55LVK7ZTXPedIK/eO+c0cb0IEOLbUsH/Wth9nx/pV4nYoY/od28u6K58?=
 =?us-ascii?Q?kFnL55qwiV3yEkGym28rXRYFhcucTzLgZzTnC7gbJGW7xHYd8/PA5LUjb+qT?=
 =?us-ascii?Q?DhbSt5Xd5385B73Zl8c=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609abe9f-91c9-453f-2383-08d9b8dea930
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 17:34:31.2109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PabmC8Mgzxq0muk48KGEP456HkosMyBInlQR7KjRSbEMs6ua7v3znsYmu1fz6fP6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5157
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 05:03:00PM +0100, Cornelia Huck wrote:

> > If we're writing a specification, that's really a MAY statement,
> > userspace MAY issue a reset to abort the RESUMING process and return
> > the device to RUNNING.  They MAY also write the device_state directly,
> > which MAY return an error depending on various factors such as whether
> > data has been written to the migration state and whether that data is
> > complete.  If a failed transitions results in an ERROR device_state,
> > the user MUST issue a reset in order to return it to a RUNNING state
> > without closing the interface.
> 
> Are we actually writing a specification? If yes, we need to be more
> clear on what is mandatory (MUST), advised (SHOULD), or allowed
> (MAY). If I look at the current proposal, I'm not sure into which
> category some of the statements fall.

I deliberately didn't use such formal language because this is far
from what I'd consider an acceptable spec. It is more words about how
things work and some kind of basis for agreement between user and
kernel.

Under Linus's "don't break userspace" guideline whatever userspace
ends up doing becomes the spec the kernel is wedded to, regardless of
what we write down here.

Which basically means whatever mlx5 and qemu does after we go forward
is the definitive spec and we cannot change qemu in a way that is
incompatible with mlx5 or introduce a new driver that is incompatible
with qemu.

Jason
