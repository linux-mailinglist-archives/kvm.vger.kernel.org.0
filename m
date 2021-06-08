Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB5B39F63A
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 14:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhFHMTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 08:19:43 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:15936
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232452AbhFHMTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 08:19:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDMS8I+lt1CWyop5SQXQrbUGyKpeJ/TjCs7A4mBW3ZUxmtN7qJSPryRJVrDuQGpGIzSZPu8vudZuKtWY8IJHjcn44vZ3KNSSBewGFETZmLjAbMfy+/bejotoV5lhmsa7PKEFdUEJaDv3cwh8EqWsPiiIiQgD232OOQr3rOEouCDPvR2gSKWsNwgClDTq2m2/cyC32wn+r2cYL52mOnDc8r89cimE/SgrF2/urGk5l5AEIryBHtqsBanzXfn0kKVut4qHGF0+NMHb/s1eDnJEQZaC0RK6Kjoba2sciKtKN0yw6R0YQJAv3QMoCQqEEeePyTja/8HS7y//tXfCqEraiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRDas0D+6NRY9b9IC+pH1uzEFcpZhqQpqDU3fkF5he0=;
 b=Eo9C4Og8CBSOzuTubbZClCQIi3B34OKFby7Cibqv1K90XSbeluL/M+fs4oqDorSaPo2QyINnjRRu7nWTr+OnkAo2lRWueYGjMRiEpBDp4Jz6zVktbCXaiBZtbEirq/OzjYOsm5NCUTkBObE04EzUhE2sivodPNQnOWHHcbRyw7yWnH6ZIGDipJwUnIvMmrylrWbLlf5u5m9Ih9UJOAQbrhiQV6vrNOiKqWxSoNKLCDm3YMJ2Vy67/ezKdbVtSTyd04vHK0gfG0Befpi028TI0xEwgmx5W8MqF8U5D3iCA5Ae1hNtEv6yg5AnxHyBn9nvYkF23FuEMnDehmlC8cIDzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRDas0D+6NRY9b9IC+pH1uzEFcpZhqQpqDU3fkF5he0=;
 b=n8fdQPo8L2Fn8b1PaFHD1e5iDWIlTA8J/rQgVQ0fcJ4xfSgwPvPo3hVKjovaa0/p4fC6BNFm6otvTgQ7BfvWsAHPwNyjtttxVH5AGDDCAZ+9lTJJDYD31Fd3LOb42Q7+c0IA8CCIwp5Q6g9AJXOWT08eFX6bluRTn/aa6OEVmgaoi4KPof1v8y37FD9yUEypdFUzsrDZHMDWvLed7KJwxT2xhTOdsezIOSDjfnMBFzpD49c1PUgG0UqzBE50Ek4P9+yPO4SeQr0H9MH5xi8gaNv9bcVxV5iTxneJ+Bw9cOOW1qnilUWVCXjX3HdMAOBj+RexDdoV8JZD3QmymV7+WA==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 8 Jun
 2021 12:17:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 12:17:49 +0000
Date:   Tue, 8 Jun 2021 09:17:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kvm@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 01/10] driver core: Do not continue searching for drivers
 if deferred probe is used
Message-ID: <20210608121748.GY1002214@nvidia.com>
References: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <1-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
 <YL8dtaVoNGFo9PwU@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL8dtaVoNGFo9PwU@kroah.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0446.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0446.namprd13.prod.outlook.com (2603:10b6:208:2c3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Tue, 8 Jun 2021 12:17:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqag0-003onG-Cq; Tue, 08 Jun 2021 09:17:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77c95737-357a-48a1-b201-08d92a776e6d
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:
X-Microsoft-Antispam-PRVS: <BL0PR12MB552172E2AF16CFF14849E426C2379@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vEpRK7AYMcxup7TK50qUMDOQgfiU3+Y8rZkNMRiNE0Sml9r4cjWO/TnvrTENGFowfNHvFbwTY/y0wHlCwWhEAgnqFixM/4vOq4ylFtyyRdyeOjVCGdMaLNPuLG3L0rSw679cl9lcdgeUAIxw8bipRTGcIWEMCwvvb996pz4kEFrUinkMJ0g07L0es0NbKtpdtqm5lVNlbb1rx2FtvwtBbIB5ysHJwGaq2jAwBlf4woCUaEhEyiW6QsmYAvoeEdD9BgRVbN9lm0EByy0uqDzgPMml/CiS8NEIzsk7gZsEsFdb/ybEL5Et/uTX2PeINvB5XWGX+ohpiyp5dplW/Tx0zX67fwSh6X9dg1KIrI32unGdfPqz9zLjsKc+srIaKvoBgzUfR0yLgFRGfDx+HlgKJy6ZM48G+wlELWyrOYfVv60ocoqtBdpvz9H7Qtcc4DRERujXdu3xOZFfh9Iq9N8iBfduh4Lz3VB4T+BFb+yU9Wunaaw6v0m2C4rhHM314I+cePQq4+Sc65hXCS8swPBO6F92Z4/X/475ypUeK433QQigLtm8GjaIbFO9nIs3BIs51nCCvFrPq2oHf3/uSuN1m7gJK2pZGdmpj1GHHs5AUvzFbMAo0VfxkREarOQYwJeomAUbC9BcyEnL1LBg8Qav5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(8676002)(26005)(2906002)(316002)(1076003)(4326008)(86362001)(33656002)(5660300002)(426003)(478600001)(6916009)(9746002)(66556008)(36756003)(66476007)(66946007)(2616005)(9786002)(83380400001)(38100700002)(8936002)(186003)(51383001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pbiYWluNNZX8thnA91Y1HGuyJMxCREVUj9qKF9p5kpNkF2+Nel9Dcr1L+jer?=
 =?us-ascii?Q?HuZc0rYQci6MZq7ueghSSfGBrKCoOqSHFEqaQTn16lszlE9X37dEBboBXGmS?=
 =?us-ascii?Q?hSerl8lzoRBheXk0cR5eKBRKSkiddRfR5VlsMssZFzEMLGfjm/x+ANvcUlCI?=
 =?us-ascii?Q?emC1ReBSRCxCzBvucLDNpDBRDVNrjr3P2gWJLvs7wfkIlcSLTq5mWjK/cYhM?=
 =?us-ascii?Q?zeap5IRs70LPPRVWJ15G1Qdk6Loxhg5FbNu3RXVedZlm0QwhD+NzpDLNTDb/?=
 =?us-ascii?Q?G+5MYXJ5ybShP8NZuvKpcRrHT5aKlTHHzwhBvVcr/ZGxqZo45iY3H0WvR+oM?=
 =?us-ascii?Q?vfVV4NaDLbzgppDX8v8MKPfqat5eWaVEIUZcGQe10EK4YMnnInckC0ESdlzZ?=
 =?us-ascii?Q?UWHh+yCBQYgdaRMNM57XbFS7LAMZzw9QBILH5xbtlH5lHuuNHp8RLCIp2Ma3?=
 =?us-ascii?Q?WlhT9dZhWd+6axHNC/8zDW76lXFSrYlwg8ltqy14xo0lIxKlolp7lUg0/nj/?=
 =?us-ascii?Q?DACDQ7q7EB7j+0IwD9jQGapp2dAFvSKRbjhm4qhDC1oZoNsYpsrJhK552X5f?=
 =?us-ascii?Q?WwNO5YCenzFbc/aBtG8b0l8hMxjl2zJ52A4MJs4D3mAP4Nn3bUksX60o2LId?=
 =?us-ascii?Q?QSDyWU/Bw4SmGNiAFGTNBLvUPUxu1anCksWAqUhCsJtWhCVCP/xd7PCy7Q48?=
 =?us-ascii?Q?Llp1JW9Dov5Tw3i+lnvosnlV0q/Kuhe2duk5hlvBbLXOhnU+12DNo2hIx7/t?=
 =?us-ascii?Q?2ARZ/puiIZRQtKcDTHC6KMY7HD5yhcCRcIgbUmVpS3bXgYU1NWPZzluQQzIK?=
 =?us-ascii?Q?h8oM1gemGQvo0yiR8msXXUB1YVatbBDdmKncFTrts0HKHJthV+Tjq6G36CAr?=
 =?us-ascii?Q?3jx8wWehhYb/0GJE0LIrEFOOrrMAZerXIkl8CFpeqkLeLpn9OszHyhyq85mm?=
 =?us-ascii?Q?NCAl5Ih6HERqW7kJEgo18PYRgLtlxROxsn1bj/w2ukZ0HAZ4RgNwIZ00N4NL?=
 =?us-ascii?Q?GMsSR94aSOS7olxeroLc24H4b2kJcDP44Qlgu88EV+4zc6uunITheDoNbkGQ?=
 =?us-ascii?Q?ehzXiZOA7gxjvPSPKLHTFlCC7aSwGSevvMi3fkn6+y99Z44eiFg4FZezpWG3?=
 =?us-ascii?Q?XJcBXwCD8G6iJHYW6JFouasoaGNgUfUyiUF4e3iq4xeN7l/qULVhewC4lX6i?=
 =?us-ascii?Q?GKtronnFv43/mcMkb90IcBTiEWAKny9JeufGVy+w5kIGiLzklFdDkMW+y09y?=
 =?us-ascii?Q?OEuZkULW+o9T7ECw8CDzlsxUuRBOs5nwL32t8x8N1eSVGxcuEItCnYLvnuWT?=
 =?us-ascii?Q?TfoYDhvZbNn3zTR0bZamt5xp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c95737-357a-48a1-b201-08d92a776e6d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 12:17:49.2818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f2bNXIqaofYRcUtlN7ISn5KB+8TZ/soqj03p21IoHhOdAe16VT+W63qedA0D6YRu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 09:35:17AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 07, 2021 at 09:55:43PM -0300, Jason Gunthorpe wrote:
> > Once a driver has been matched and probe() returns with -EPROBE_DEFER the
> > device is added to a deferred list and will be retried later.
> > 
> > At this point __device_attach_driver() should stop trying other drivers as
> > we have "matched" this driver and already scheduled another probe to
> > happen later.
> > 
> > Return the -EPROBE_DEFER from really_probe() instead of squashing it to
> > zero. This is similar to the code at the top of the function which
> > directly returns -EPROBE_DEFER.
> > 
> > It is not really a bug as, AFAIK, we don't actually have cases where
> > multiple drivers can bind.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/base/dd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > index ecd7cf848daff7..9d79a139290271 100644
> > +++ b/drivers/base/dd.c
> > @@ -656,7 +656,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
> >  		/* Driver requested deferred probing */
> >  		dev_dbg(dev, "Driver %s requests probe deferral\n", drv->name);
> >  		driver_deferred_probe_add_trigger(dev, local_trigger_count);
> > -		break;
> > +		goto done;
> >  	case -ENODEV:
> >  	case -ENXIO:
> >  		pr_debug("%s: probe of %s rejects match %d\n",
> 
> Why is lkml not cc:ed on driver core changes like get_maintainer.pl will
> say?

Sorry, this is my error, it was intended to be cc'd but scripting
seems to have malfunctioned in this case. It is what HCH observed too.

Jason
