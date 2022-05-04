Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E96D51AD41
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 20:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355561AbiEDSvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 14:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377315AbiEDSvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 14:51:12 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8DF17AA8
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 11:47:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1+3GNDt43qx78nwb3DdNNLoe7djaDcVAS81PY/X3dnCA3ZuIQDfV518WkiW4nXIDpQa2S+rLLBLLxQzZLVo0wiEZfGGMH97G291mmdLRqO3Qr9k2kbRtgwnAJdwD9DSe+bpNrq+N5CO8wArm3VXnKWZ3G3jij4+CmT5IuJLQA0Ve/UM1NoYYWb8548Hsh938XwMBHSrnSJg7DA9P+LTt5Y6d8rdLP7z8szF9Ii1LVJHdAKrnLWrzO/QnbyK8+dPxFwOG43+F/9Q5OWmvqGEx1hYC2dLAW8jcb+fT6jB3t/2BhCeKpjbPnSeaMf4xcIT+kET7q7QnQm1zpOwrZM9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvGA7ZiQ2xX7pQFnYyeq2ar59L3lEd5JHAklu+0Bjt4=;
 b=jKF1EumIkZQm4X0NTnyKslrx6szSqobPADi0EM+cx+YyxYsuTaFj/crc4Euq0xVzLu52dgVjJR3ErckSnOQAOk9QtfZEZAd0XMxZbuonZgHbjM/WaDCcIvdOPVZMSPaOpenKkkwlO/h/EH8oMCDNC6c6+9FycWyde+sAzxUX5JqGdeL74N3f9LjozVnGVtzM/MjEGZ4Smh0AhKNankwW/iT1wjT9QMp1qiFTAFNC50JZtR4VUApoPenmM+BYlg4l9DId98n1bSUsRlwCaayeChgimfsrmdospmQizOEn5veA507ZshTEdy7iqjFGKJFyeWjPh0AE2uMdj32jJlDk/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvGA7ZiQ2xX7pQFnYyeq2ar59L3lEd5JHAklu+0Bjt4=;
 b=VasJJkS8DpW/P8SoM24iUgUEdxyYXaxgwBRzPCmX7IYo4wUfieGR32TqdqGqn6HBXgxVfTPmrS+glPJ5CYKwVmKYD06Qqb+OhvVwNbDTHsoHa/IU1WhwEs9Wfxr3kbatLHunQTFji7UXQQ4Uz+8AZLE1SSUrd8QT/EomimOd8vIHBltlM/ZL/Ns0MIGtiRdrzxvp4N4bDd+1B5ELv5oVMJVUohtX8UoSWQquC3UrBjKF2vd+wISYOpwAXJun1tDXeklFUX52/f2cXjQffl/KFHiQOP15ubr52rdpADRJ6waZD2d5O3fF1nCP2vmA2zHjf+WdEX82yZ1L2HUpPwP/Lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1796.namprd12.prod.outlook.com (2603:10b6:404:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 4 May
 2022 18:47:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 18:47:33 +0000
Date:   Wed, 4 May 2022 15:47:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        liulongfang <liulongfang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Remove vfio_device_get_from_dev()
Message-ID: <20220504184731.GA98226@nvidia.com>
References: <0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com>
 <ea998a76810f4f96943de33b01252ae9@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea998a76810f4f96943de33b01252ae9@huawei.com>
X-ClientProxiedBy: MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64b6d18b-2841-4e8f-c671-08da2dfe8c9d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1796:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1796DA3F9C42E6EBC074FC64C2C39@BN6PR12MB1796.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgoP3MEGXBJjnlbgi9b7Gu6x3A5QfQ95zsDUb0vVifXVbIF8CJC9pAQiqoYsqzCfM9AqMyTA7Orf7nDnG2aQllbfBbaNSucj+13/kJLl0YHZvrPDoSsiIpvC+kzJZlBoRPaj4Hlon7ej87vbJSY6rvYO3LxymTwu3NdfY4vwrrFuZFLygkX8oGVGrc9cWH6BkA85yBQIg7F6GyNm96XLLJqBpf5Gyeb6aS/8/HCb+7TwSH9Cnfa0Qsuvsq1zknBfA9xXV8SNgAZb+4d780Z6ovZEwllZRWwOheyxi8KkPM6Uv3TcAmnXqkiQHwCroatUn8MtGXctz6WRuZKX7WQ3k/6zixwnN9dmK71uP+tVLcds5S+VDlc4Iu9uDQg+uDTN5p84tIayRakg062cctTJ70RTuwYLL0OJai6ZlxpQ0XlmtT1m+eqzv40wd2v0+/xhV8G2Vu+XTLKqrWaJGnZ3GyYgjwIPpr562cq6vIKDpwFZwZ/5YNxQzlSj5tVbwLOygLYZSY0BNqe6UUtxiLrVvCooqSaBthjARFcXLOs12WMvrUocTbnUtx6u8XzZXYe/B3Hyhmng4mweJT/Q7TNW/F7B3T59zSUZiFA6M9iQgOU9NuK1cLt5JtUYsbLqT7PHu6P+ilm9l6fw2I21Jb9yyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(33656002)(4326008)(86362001)(66556008)(8676002)(66946007)(66476007)(6486002)(316002)(6916009)(54906003)(38100700002)(36756003)(83380400001)(2616005)(1076003)(186003)(2906002)(4744005)(8936002)(6512007)(5660300002)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hC7/CtWy2iZ9mplvuv/vthUQzQO49xqtrM/Krj7RjHNTDoU8bJRddkPOzL4X?=
 =?us-ascii?Q?2YsprzVB/KxOkp2eA0L4dJd13K5DfOy5Zg0V1XtN17S3kDp6bnmGmmO/gsRZ?=
 =?us-ascii?Q?4OpEPSW3Q8/QNzW88+tvn817oLLrsGbeyBxekXQEAV04y9xnRQt5/XRQR/s8?=
 =?us-ascii?Q?aJIsoOzdFszjWbEjxzKNXFUpx+WoAQ0X0LZkuKAIWdOMPM2PJZoibUsXRJHg?=
 =?us-ascii?Q?CrlYrinYODR07/4Cco1adSR2YqAEn/+9QkXIOjOpssR4KhBQImP8Tidwn4Jl?=
 =?us-ascii?Q?H+ZsGp/qvPgIg2j3emTziigLGB3OimYWRLhBRmzwrVCDoK/k3Ovt2rn3RtCF?=
 =?us-ascii?Q?OJsJ+scWrpQ5c4c8EJN5GPykahXrwmHN2vv+sD/ntkQ4CYACs0MoJsVhLdbq?=
 =?us-ascii?Q?Vnl/MSKZ38/rHY32gD2l4N88L54O81QyJsz6hD79hgbTH4VnBmzkd8WzVsVG?=
 =?us-ascii?Q?t3N1XWc9v8iZkfQNDz2uKODydyfMImFTnU/3ISQNGtJ13uzGjh5f6jzwULVl?=
 =?us-ascii?Q?obGU7rNxK8V6t8hrebd3sgCeKMq+mVve/apD9q6XR/AC20cn0b17f6nw7NCI?=
 =?us-ascii?Q?cUhopuvqVw6fjMEril7chFTnENGtsSwibxgy7OWXa8T5MFunkjUV+7tV35nu?=
 =?us-ascii?Q?Uv15VQiRNgaAMBpPcV8HGEEbXkqrKn+swMyxhwfUmt5cs0ClJ4mce5C7RJyA?=
 =?us-ascii?Q?sMrlB8iWv750nRHBy4Gh1Jtr1RZRbXSs3YSewYJWXzA+/slsj1Dmfo/+TlM4?=
 =?us-ascii?Q?FOQ6CSwt6YWZ7avMEnJJwFrZP227v9UZIr2tx9fAzbUYrPFZEXsmovi8S/2U?=
 =?us-ascii?Q?bTrAqrPYZdbgU6ozGl0PqYDT5Cwj2TM44n4i4wEgG3/T+JcWbO7C02AVE0Fs?=
 =?us-ascii?Q?4xwGqEGzBvf4kFqc3QCDrh3CvCleUOCemB+enwcYY/UKq6Ui1TKe+9ltt3Fw?=
 =?us-ascii?Q?G0ZMfT02x9Ea48wczWcyIb9yx4x7L3UK1L1UhZ6c/gKofu8KRljjmPpdUWd7?=
 =?us-ascii?Q?KSqiBGg0AhvccKWI1ojGi95n3UYIteTHRN6DHjr0aoIyh7eASOnOQFrbfVXa?=
 =?us-ascii?Q?5qUKDGB+CmyLa2oweWrp65fIwlNNHtAhyGgOMUbYsJWEuNMJ4H8XWFqo/bYN?=
 =?us-ascii?Q?IAWihqw4z10URM2dZ1CaGIqvPplr9ZaBmZtnVZnQ5Of1+Bb3rgIFycsN3rC7?=
 =?us-ascii?Q?M77TFxW/0PbzWQ134DnvJxY0x97cWQHx5nSE3Bm/AWnPmcZffU+pZqHFTMh+?=
 =?us-ascii?Q?93DGz5IkufYdVSjIngTwY22KCKzslKMtM5jsMhbqFrlcnrkb3csnPiH5TjcK?=
 =?us-ascii?Q?C97UYtJHygrgFlTKLGsPMt45/Oi7c7PuzY1OcA/ekvAS8oIiob52KWlH3r/p?=
 =?us-ascii?Q?iftbdh8ZfvOp1i9N/X58JHtbnhqbCDCiIJO2ltdI9CrXU1PXVCvhxlu7JHaj?=
 =?us-ascii?Q?miukhhVe7jjF1D35cHLaSxto3oteXB9WI4m80utv79mBtp7iT028oCZtMS2m?=
 =?us-ascii?Q?pyE8Nv2ytvdbown889A35Rl69E7HP39lzHboH1mg3ud7rj06u8bwbCdTwSjo?=
 =?us-ascii?Q?N7ToFXXos/bWXuK9y2wWEHEZ3fUnTN8ceV3PHdpZdTycYkA+NeR3KhjPw889?=
 =?us-ascii?Q?A/ojGquAvhzyMHnfXyiR5DyazGfqRlFVE7yWlaQm7gg9VzcDvE9QnLQe7qxj?=
 =?us-ascii?Q?2OVtL6D3JTiq/Ailg/eSdU1fpTp55zYj81ziHLAztzT0uYS0m5ZIRkCbZ5cI?=
 =?us-ascii?Q?KEFeyP0ZGw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b6d18b-2841-4e8f-c671-08da2dfe8c9d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 18:47:33.1845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fuEZ1MJOEWw14CcZGD+o4nhLtM10VwFCpJUIVo5jfO8FO+R4X7WoJc3Y12eWe3yn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1796
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 04, 2022 at 03:15:35PM +0000, Shameerali Kolothum Thodi wrote:
> > Further, since the drvdata holds a positive refcount on the vfio_device
> > any access of the drvdata, under the driver_lock, from a driver callback
> 
> device_lock() ? (v1 discussion says it's a typo).

Yes, I fixed it

> > needs no further protection or refcounting.
> > 
> > Thus the remark in the vfio_device_get_from_dev() comment does not apply
> > here, VFIO PCI drivers all call vfio_unregister_group_dev() from their
> > remove callbacks under the driver lock and cannot race with the remaining
> > callers.
> 
> May be we can also mention the removal of vfio_group_get_from_dev() as well
> in the commit.

It is in the subject :)

Thanks,
Jason
