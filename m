Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F384C8C5D
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 14:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbiCANQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 08:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbiCANQP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 08:16:15 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE5E9681F;
        Tue,  1 Mar 2022 05:15:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pwn5EOZVzHY0Uy+dR6qHLgxXJl6uj/TaqCnUMYOl4y3hHrkNQn9UAMBfFt35hpWcn8vPFHcFZk2nEinbX3Wsdn3pBfHg81BoDwFxhqpoBfKekGnxzxiD0k0vq7lnyIoNL+eelzHC3/wVY/Spxad8XU9p2g9ujK9yxfOq4Q+R7GsGh+VWEWCCmZ5Mx3AEp9cjk02W8/Y+U6+iNxYjbSEPAKFLizLJxFZnmutMgCoZI+GgjYs9PzVffeiG2lY1bHz+w88qIR0Hg+Ij4AYj3m7Z5zg9JWq4dxspzIScEDXWQ3T9N3wAezfBSK9jE0gGg0E8Fb49h1VjFmSB32ROUC3IIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEj4fTSSQ/p3SQh0Y/KVEc5qQBLPFoln5c8c7SJBYjc=;
 b=C7UEYpLoN2JT6tfaZrytQM+4Aae+ZkVRYjxvB4ytGRBjq1ldx6os1CaYMeCEwFvMM/UuytRTqd9ryZ3RmO+5eTGs0eS1xYP9Qw0WZTrFdfov993S38nCq3DZ2br9z3HHTqBf/vLQ2v6QhcfUTVON1ZvQvag8ad0a4yrJ0yuYvarWuRbq7wrIuJT7HcxTGZk2C3ERL8x5T1ZCRcEo7VO4qIZwj6fLWfZRPXMPMrL/H6QBjp7zStHyCK0AHILJBskryMXFIubYGq/M0JKZAuooNSVJyr1+D0msnCXVHoZX7huMXV34WtI41b9ZsVvkjXefToajJ5e1FaNaw4x5XBxFoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEj4fTSSQ/p3SQh0Y/KVEc5qQBLPFoln5c8c7SJBYjc=;
 b=YHtexox9C1u7KxS0NhfrKA1LuaTb8pJfcJpVDlNM8n7V4AlvmJmtIqrW2YonCSnGKb5e/KoTYnpqGfOWI5PAM3cpPxdYDYHNI33MYGPAeckyb8r22/tbPoyOdS8POpQUnPLb9GQ8LkGHUg4xfWuO4KH03PbKji/af6qqRUK6Jk0E/1HDFHoMXB2fUMKArp3iOq7mk/cPb+u7HfRC2ONfw9I1n0/nBvjGtZxidOx/jLBr/Cwq/HQ2d93FF5vyxma7QOxokHmGXMDOWMnz7e0KyPP6W2xTqwHqnFThkxq6FI0iYKQcLtncGOkPBrpwh9fl6SwrjrnA/GUHy7gwH6XHqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB2497.namprd12.prod.outlook.com (2603:10b6:207:4c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 13:15:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.014; Tue, 1 Mar 2022
 13:15:31 +0000
Date:   Tue, 1 Mar 2022 09:15:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220301131528.GW219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
 <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
 <20220228145731.GH219866@nvidia.com>
 <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
 <20220228180520.GO219866@nvidia.com>
 <20220228131614.27ad37dc.alex.williamson@redhat.com>
 <20220228202919.GP219866@nvidia.com>
 <20220228142034.024e7be6.alex.williamson@redhat.com>
 <20220228234709.GV219866@nvidia.com>
 <20220228214110.4deb551f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228214110.4deb551f.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:208:23b::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c3f7021-d319-46d1-6083-08d9fb858f96
X-MS-TrafficTypeDiagnostic: BL0PR12MB2497:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB249788B91BF10344CDAAC6EEC2029@BL0PR12MB2497.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rxJ7dyRf0NaXwxKBOLg7F1OE0DWviVFS0T+f5eLsf4NGKsoxFlu5kmMdgBlDoOlfVY1hJyOnOnsHlp3cJ9BRScr2PlmUBzflYUEhoWpNf8Momg88k7K9Nn7RGCqxHTaDkwHepf0Iy+JkM8b+XsSX9Gwuf/ZjAdByDzlPfFiA61ax4QH7JdTX7xuJN99CciNP/2DqdGs4ggQFj/q8fYravAmnVYkQI4v2P0kxH0nTsh0DVHxw3Jkutd6x73bujkNKt32VxKV2Tg1mk5oxOTDZ/Z/j+LDbyi8JvXndnW3BMjyILu6pPUZNavrcXnAp373CYMCdz45ReHmt85uh7ucOPLzjb3toOHKfW2GewsSEN33uQ9V2p6KPINw43ggKXP41sG1m8Q7fJeKkuJ4pD1ZBu1+gW2d86j+SL5hpBYspUh1K3XSd8mC/D5QsdhRyxedoISrE2q2I2a4iVmwGHVqa3ksqKNKOAarhk8mzDe1NZQxUdpdmTEux6BjaxeNygYuhEM6P8PIgOCxBDH6beosbNq7nPHcCguSaq8iGbXhQpMqfmXOyKkn9u7GFom4HjNz1F4LwQpnw+56oOS64fXcodmYuJgfWzZkM46B6UGX0j2WkoV9L22K/mn/8WaNlp4EHtAc7Ea6xO8RSnv3qF1wTB5Wxn/fOj0JF7VAKlzKyNTT6WhiKYUHchXAsnOQSpril
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(26005)(6512007)(1076003)(2616005)(2906002)(6506007)(186003)(33656002)(316002)(6486002)(6666004)(8676002)(4326008)(66946007)(66556008)(66476007)(38100700002)(508600001)(86362001)(5660300002)(7416002)(8936002)(54906003)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?we28gt7Xp/xP65wwedYmaT5OrDaF7Bs3EbN+1rykRJzp36YTJA64NQHLYBtn?=
 =?us-ascii?Q?zdIQjcYjKlgAQZI1HeGmZOpbYVmDBeWtAaCY2uReSJX1Yto68iReSEk18RZI?=
 =?us-ascii?Q?oQw8P/j20DJ8b9NQgKoZq008K0b+dbxyKrfDrdM0OKXbhhcuU/OU48bbZMvD?=
 =?us-ascii?Q?peteR6j/dkiz5Kk+TsesSD/7PRcBOXwPLOeQ9nYZ//UUZJ7wXMYYAs2JepW1?=
 =?us-ascii?Q?/dO9I4ZWA0kOGF206NkNMzoKXkT7kKF0HuA2TqONUCkDzFOFlPdoIVlSKoVw?=
 =?us-ascii?Q?WgHj84ggRKzmYB/x2VVJ8m/bcEXT/Z3NNJfsiYa8VC8GiK0m98KyXtb+vLzb?=
 =?us-ascii?Q?vSKl/LbcH55rd5ooxL1SONE9zNPBrtL2VANHpDvO2eh8CAc7I3woJ8D1ylEP?=
 =?us-ascii?Q?8Wcr2x3GbATVsbp3aTKMvNTHmDP42/RfAv5PcfEpbbT1qG/IvB6P1RD1kKOw?=
 =?us-ascii?Q?/IcD0uIkMnm/z8eY+FAmE+dWpyxpJB19Tj0VituTVNvuVG9Sa+oT8iivzaqQ?=
 =?us-ascii?Q?X/U2Y94fPgINusQgOfyq1x1zuep1ZVGUsOeEvPC8aSqOrTiW6w2QVQ/g/1uv?=
 =?us-ascii?Q?hpKZN15t7hsf0cLwUlCQX9iCzRQhbIA/fwiUX7E1RxL7g+3jl0k2NJIOXM1c?=
 =?us-ascii?Q?Gk6YfeHNO09o3Y3cpcx16M5GULbb28k0kJiAoXbKJTCda/k/uWRahVGWNXMO?=
 =?us-ascii?Q?XY74i2LLM0di6plV1+a2aCDtr/fRoT9olWJpJpEvtO0w7WFQ83x52YAPHK+0?=
 =?us-ascii?Q?uv/mvsQu9P0t8oI8HheJGcyAfmAxAjqw13hYxEI/UCkhUaUjqj6Y/PVcivSs?=
 =?us-ascii?Q?QhaL5318u1rkR8hOdtywcSpUf0/TZW4SI0nr6uYj9+DO+JAryT+izDzHtPTk?=
 =?us-ascii?Q?qEgktMe+Ov72lJaKn6QpdLCLq1HSt5bKv7eXu8X5y+oWJd3WsM2xhF91LyN5?=
 =?us-ascii?Q?lQnfOnX7g3KeOaE1EhIp3IuQJVQHreOG0n5ZIMI3aUjEOUB00j4MMZFQHI4S?=
 =?us-ascii?Q?KE+GW6aBzPrFAqnLdZWxVgQ3HHKoo7oUjenCzdYFq4BC35ZrFE98hShKvCTx?=
 =?us-ascii?Q?7CVrf8nCDSRAnsgA4YmGY5mH08k3x7mK3yosHOctrKBOf7lLyezHbHKqvwUi?=
 =?us-ascii?Q?M/sRYTD+ir84RF9oHs3Qxleu/saLyUZID4sjFKFdbUPiD3fjMq/iNQhpL2Dt?=
 =?us-ascii?Q?+pj0l1ahEtaz3VD1/wBHLEOafwLjxPfCWjgyl5SngUTEZD6BgHh/6RpPe0jD?=
 =?us-ascii?Q?s5MM62hoLUrIkxEnmd1H3bOO760Ud5pXjH7Bs0LDtDKhCLUxgZMXnqYI2x93?=
 =?us-ascii?Q?eA3DvZQPRdMMRBPaxvqMUHI4s7XSw80Q8AB2xP3M8GQSyEQTk9cMJyuloM8K?=
 =?us-ascii?Q?s0tREl0ySPCBECB42hV7u8C/KFIGEc+nYozDLD1MiU6uTYqLO4fM1iX7lkns?=
 =?us-ascii?Q?DQ5fqRMDyAPv42JXG36FpaJGqPfm6Mt65/P/++jcW4eTCMLOKn1TpPuTp5MI?=
 =?us-ascii?Q?HQy+VxBndUjxyZcIqZ01nnN7zXmgfIdPd/6eTv4MJM+fLZg+u/e5Iv5LiEDX?=
 =?us-ascii?Q?x6te+GbqHYi3KbR3X14=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3f7021-d319-46d1-6083-08d9fb858f96
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 13:15:31.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MiBhwWGnMUGBpedAnXup1Jk44AI9l1J+oUtpj4bo7Pn9Q/PPj7+9jEXqE67FYNeU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2497
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 09:41:10PM -0700, Alex Williamson wrote:

> > + * returning readable. ENOMSG may not be returned in STOP_COPY. Support
> > + * for this ioctl is required when VFIO_MIGRATION_PRE_COPY is set.
> 
> This entire ioctl on the data_fd seems a bit strange given the previous
> fuss about how difficult it is for a driver to estimate their migration
> data size.  Now drivers are forced to provide those estimates even if
> they only intend to use PRE_COPY as an early compatibility test?

Well, yes. PRE_COPY is designed to be general, not just to serve for
compatability. Qemu needs data to understand how the internal dirty
accumulation in the device is progressing. So everything has to
provide estimates, and at least for acc this is trivial.

> Obviously it's trivial for the acc driver that doesn't support dirty
> tracking and only has a fixed size migration structure, but it seems to
> contradict your earlier statements. 

mlx5 knows exactly this data size once it completes entering
STOP_COPY, it has a migf->total_size just like acc, so no problem to
generate this ioctl. We just don't have a use case for it and qemu
would never call it, so trying not to add dead things to the kernel.

Are you are talking about the prior discussion about getting this data
before reaching STOP_COPY?

> For instance, can mlx5 implement a PRE_COPY solely for compatibility
> testing or is it blocked by an inability to provide data estimates
> for this ioctl?

I expect it can, it works very similar to acc. It just doesn't match
where we are planning for compatability. mlx5 has a more dynamic
compatability requirement, it needs to be exposed to orchestration not
hidden in pre_copy. acc looks like it is static, so 'have acc' is
enough info for orchestration.

> Now if we propose that this ioctl is useful during the STOP_COPY phase,
> how does a non-PRE_COPY driver opt-in to that beneficial use case?  

Just implement it - userspace will learn if the driver supports it on
the first ioctl = ENOTTY means no support.

> Do we later add a different, optional ioctl for non-PRE_COPY and
> then require userspace to support two different methods of getting
> remaining data estimates for a device in STOP_COPY?

I wouldn't add a new ioctl unless we discover a new requirement when
an implementation is made.

> If our primary goal is to simplify the FSM, I'm actually a little
> surprised we support the PRE_COPY* -> STOP_COPY transition directly
> versus passing through STOP.  

A FSM should not have a hidden 'memory' of its past states.

STOP->STOP_COPY should always do exactly the same thing, regardless of
how the FSM reached STOP

The goal is to make the driver easy to implement, which has been done
by mapping the FSM arcs onto the logical actions a driver needs to
take. 

We can't avoid that the driver does different things on
PRE_COPY->STOP_COPY vs STOP->STOP_COPY, so the input arcs should
reflect these situations directly. Notice the drivers are not deciding
what to do in these arcs based on hidden internal state.

> It seems this exists due to our policy that we can only generate one
> data_fd as a result of any sequence of state transitions, but I
> think there might also be an option to achieve similar if the
> PRE_COPY* states are skipped if they aren't the ultimate end state
> of the arc. 

Are you talking about the other path? The FSM today requires drivers
to implement RUNNING->STOP_COPY - the FSM could also do:

RUNNING->PRE_COPY->STOP_COPY

And just carry forward the data_fd. This would eliminate one arc from
the driver at the cost of always having to turn on internal dirty
tracking/etc.

> I'm sure that raises questions about how we correlate a
> PRE_COPY* session to a STOP_COPY session though, but this PRE_COPY*
> specific but ongoing usage in STOP_COPY ioctl seems ad-hoc.

I do not think it is "pre_copy specific" - the ioctl returns the
estimated length of the data_fd, this is always a valid concept.

Jason
