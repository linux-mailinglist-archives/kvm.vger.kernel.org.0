Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A590F7AEE40
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 15:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbjIZNvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 09:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbjIZNvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 09:51:12 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4FD136
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 06:51:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLP6eisNsvQHQolVMhZvuHpSXMmUJw/tRtro1cjmPwe2lJXCIpgKwzaMYgVgm6l6LtLESybPjOGtDUS1l1DL9nDWRhalIl857sWj2qWo7NrBYfPJYm/AcHsePGiT8KvhTc2qzlZhxjhsmGP5WR7epPLM+IhY0VTB1MWSRGSU3mhcvPxAIFCnw6oXf7q/hYYcPNyveWtaZ5L/MNpDgGVMArhRfzz7u/nd9xzlq2U5dro/oe1S3j95EyM12ZqHnWGCkybRlUtEGQlFCcOuQ6aSibuWFr9PR/6r2qA6KTc4Y2DOOjidDi5XYAs4KlDwCNCLljI08xMAC/uMoIxk3azfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NU4YIcpg3Xr7jRO+O4Z08IRYWWvmtPJe6Sg0Xxha/DM=;
 b=JlBnwOTQABtJe569IWlZI34iGUC826/OPnSA9TpJJ+AgpJz6GzJ57WXgQKxN7nU6sVVPVn2aSjjrQptYkJsvms3zQZ5k4052L8h/3aryuHW0LLGXXXapv412COon85Y5U3BR/65o4qpwqfEq5t2StgvOg6UZWKR0bdOwCdYZ3Xr4F+MhWwHxK1TZxMt6iNpsQRxMl/RVeUs8bPZCyYkTHAW5tkcrqNEFHh0uiiAWPpf87QdixVn9Rs1kS4tyeVWh2OnHySKK+Z/4TI6UVx9MIwZJj9uKcUsjcmmwEEXtkdLUHhEH+iP+Xvdbor/eZeTnoJ/s8pmsMyqmfSXslUP1yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NU4YIcpg3Xr7jRO+O4Z08IRYWWvmtPJe6Sg0Xxha/DM=;
 b=V3Iv99rMuE5P+ulz1jJQLqtfpEu8krDLMeLST9bhfm7rP7rSdpe8r1WY/apm1RPcbnAHhPBqZwHIsV31V8w//3TqWhkVfzrYxYk5rLeKGyOfinfPXIlmCp+ZuaxEJSYuZlaZvWAsTDMncAVAb5DEfcNQD7ANpuBQwuuhQ4Th259/JiEc+JP0AjNr+onkOQQih+7ZT48npfSsvfupPDYi4t04Y11q36PWdNxrv88ybORXoKRYT6cyV9/L1BA7ZSmR4bT/buz3+k2swxrSzAlUjs/JyGV7GWurqbWhXbbIWeKf2Xd9IZfSptI6bDP+XONhBJAM+QV6E10LIJSLdgBWBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Tue, 26 Sep
 2023 13:50:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%5]) with mapi id 15.20.6838.016; Tue, 26 Sep 2023
 13:50:59 +0000
Date:   Tue, 26 Sep 2023 10:50:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230926135057.GO13733@nvidia.com>
References: <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
 <20230925143708-mutt-send-email-mst@kernel.org>
 <20230926004059.GM13733@nvidia.com>
 <20230926014005-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926014005-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: MN2PR19CA0031.namprd19.prod.outlook.com
 (2603:10b6:208:178::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 4801caee-e555-4dca-5731-08dbbe979d2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nxRXNooFjXCnLFUJgxeLWI8zQ+XoKQyUXtVORLj8QVwhZwJWtqaLD8+vpjqrGlieX3BBVn5MyqSvI+2p03uVQ8LeDV58HI4IxIVxMcqzj/Prz3ySkaFLgPJdc8/qBtXMwoydXZbJJKmlvx/J03rWy6fciwsTHXbkrYjZLv6+aUKe0/+HgOVgjm3VAHO4txVuoIRiRfJ7ZQ2rH0AcV3fbcBf0k8cIgdEi/zdk3v9aB3YDJpm5G7vREVj+vUaJBy+Yn8UgnfDxHgDmHjgj/1Y+/bq5kIia01pfQWB3sitIosjAJ/8HCdB752g3GLBNkut3cUCeiXZPCw6nRsdwrcVevs1yodmW0BcxrfDhgnAJuXyzhl8IndWMMWi+HhchZI7lgqibF+fCPEmg/S/LzVv2fLqMoS4lqmjStpO/7gjiaV3CqfcZ+PIMg6G7RYEI1sg6pHRH/QAAYpoU2ik3zxoCv0E3P1U7ECOZ9Q42qmDgDJM7XUB1QPxLyL51neg+T1H9bqXSd2+H491z70nmMuC4L4f27FzVSpnRKMt3D29PYwk0A8pxBDagSE42j2tY2BEO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(366004)(376002)(396003)(230922051799003)(186009)(451199024)(1800799009)(4326008)(66556008)(66476007)(6916009)(26005)(66946007)(1076003)(8936002)(8676002)(5660300002)(41300700001)(2906002)(478600001)(33656002)(38100700002)(6512007)(54906003)(316002)(36756003)(6506007)(6486002)(107886003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dpv2TAYuyYzCCXKPWz/ud0gqEg/HUf/eAQWm+9sBJAlZYbXKn947vkXT8ZWd?=
 =?us-ascii?Q?HzSAp2Y6jia8U6BdeejhT/2J7ph9+6Y0+nKyRFPl3gXNyAbmgbDqnF3GRwJ/?=
 =?us-ascii?Q?/tIFVS8OU3Z+8UYiACM2Bj995ZmOUFfSGGHZjiZVCNWNJIyHwXS9RF2z4Vgk?=
 =?us-ascii?Q?TvePBnFNML4zWNJrpxKaha2fmT7aSwA8IVyONIdxXl8YFFXO2meAldWHWOvo?=
 =?us-ascii?Q?W8nHKSXLcPbl7FGT6RfmwtOrKZ7TbVQ/xu9IpHLy7KLM/9tzIaaQ//UsiMEr?=
 =?us-ascii?Q?zFhyzVkNZRCqbnnBK9PilJFtedY1Qv8nIadbyGsEKCkAI8BjFdLCFNkQtazm?=
 =?us-ascii?Q?SyD6XTrd1ZthSC0hRO/+uVS0ZlSQrgeTX4GrsFq/6QkB5Q1Ipb8P+FYlYs7m?=
 =?us-ascii?Q?dZB2b4A2Bf2Mi2WuwvaWx7/0oVYm+EDZXMBhBDzGOWtKWbcRBDvtQ2GaD2Fs?=
 =?us-ascii?Q?NwMyG/RmQSqZwBH4O8UWikwrfFdckVKMBa9NXuiCYdf8DxGeKkAB++t8sTy2?=
 =?us-ascii?Q?bXi74SHIRoVA8F+VhKcYYRozSluXQciPZeRt38Xe5rfrdmh56FQoooyrsHAh?=
 =?us-ascii?Q?wpsJqfyk8WqMrzf18XK70bVFcZZ2CQr3H1oMU0KTJIVk48vPqjMdD6bMltTN?=
 =?us-ascii?Q?iXlKjVsBUKx73LfloW9VuLPGqWlhXMMsrLsBcMFy5mnA0+LNP0FVNIoNmB4Z?=
 =?us-ascii?Q?01zUSOboyhPJG74VbAPOlVlAYaUmtnLaPAXctzuphuY2vaocQ/XP9o/eg5lJ?=
 =?us-ascii?Q?/0HS1zwyUiGZrOs5CHxFwL1ycIlqkgtI5nzTtqdVWKjDfCP2Eert/cFjg8k3?=
 =?us-ascii?Q?8wshcP3dpg8Jw+e4T1i7bhaXmjMQv/dCZGW2dVwgPx7d6BctiottKVvfP8s8?=
 =?us-ascii?Q?iYcCxLfSfiJoHxOM05otp7iMIU5esDFm9Z3QIw0l2podqAFRw418RtF1ppf8?=
 =?us-ascii?Q?tgistCbwxAf1aJ7RhN5BRy2cZUhZaj231euL9g81W8GLby1hkZcUGXutc5Qm?=
 =?us-ascii?Q?vbgtUHIrHAvH8iDt/26+A3ZGV5ilNBD7nEfPC4yXnJCEcANHrjgXPzf48qJ3?=
 =?us-ascii?Q?rLyCz7FjYK1FXD6f1gX4l6U1jJT3QcKdoKzwulth6s6+kSvYizB+6H+Xww7/?=
 =?us-ascii?Q?Bd5aRm8kr5Mq0+hAPCxOQqZzJ9aHFOErQtB55QYhoMqRYtwHXe3eRnCAvWbT?=
 =?us-ascii?Q?hLwCBg7EmX0P5OLTmrI862RRKrxWTnT+rDerft+S6GnUNua3rvpPJ/R3pOVU?=
 =?us-ascii?Q?bghIpHHuE0+5HuzsXU1FQKAn2XV+zxltAKlCBEpKjPMiulxLD6GV56IFvYPm?=
 =?us-ascii?Q?PdA2tzMCyKLkhAqSFmk6qG2YyrWXklInDbvRKHTxmk5b6w0NzORi4boq/GL3?=
 =?us-ascii?Q?P/cH+nR35rd7Ps9aC6I6tylZNo/xZtRj8Tj6iOjMk8J3Xy/CLhit62j/bDp8?=
 =?us-ascii?Q?UuZ7JtKBBVu2CLZXR4iOlYb/fvztmDJNoFbyx3HqHcwElQhQB4plfVLWFxw8?=
 =?us-ascii?Q?Mwj7Tz3CvpJRRGDPfBNGEjxi35HyH4+f1Y2kSJ/oL1mRQVodb1BFOsGEU2o9?=
 =?us-ascii?Q?XwaERIJiqVgBbKTqd8xuKX84XpT6swjLH/r+URQM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4801caee-e555-4dca-5731-08dbbe979d2f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2023 13:50:59.1594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p58c8UvertsFdu95qOZSaXEgvQyQFouwKEJK6eirQdNhgBgbnlKo7dLmiuiS2/KY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 01:42:52AM -0400, Michael S. Tsirkin wrote:
> On Mon, Sep 25, 2023 at 09:40:59PM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 25, 2023 at 03:44:11PM -0400, Michael S. Tsirkin wrote:
> > > > VDPA is very different from this. You might call them both mediation,
> > > > sure, but then you need another word to describe the additional
> > > > changes VPDA is doing.
> > > 
> > > Sorry about hijacking the thread a little bit, but could you
> > > call out some of the changes that are the most problematic
> > > for you?
> > 
> > I don't really know these details.
> 
> Maybe, you then should desist from saying things like "It entirely fails
> to achieve the most important thing it needs to do!" You are not making
> any new friends with saying this about a piece of software without
> knowing the details.

I can't tell you what cloud operators are doing, but I can say with
confidence that it is not the same as VDPA. As I said, if you want to
know more details you need to ask a cloud operator.

Jason
