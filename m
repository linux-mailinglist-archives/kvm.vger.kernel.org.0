Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1984C7EB0
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 00:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiB1XsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 18:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiB1Xry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 18:47:54 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC9010E548;
        Mon, 28 Feb 2022 15:47:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AX9JFBVJONe47Nw7Za9BwMVE63hvzlZXWFTuw83H/GQNV+fGq2WtavrSjOltlGDlhPuVL9I2/3kri/La+OIHb+JEFcEOcgkyuVZ+F9zQTSQ7EQxUEQbaPyEVuRYX72E5ZarzCkKOd3plBj+7tyIH09xIrdAIXUy7eCbkqoxfByUTcPyIls3wx0X08kQbk8CQEcGY74zAQsHAK5IVw32FKRpjlaYerV6O3006rCrXlhIEElMFJ7ZeD6Ktij2m6r8xkYEroTDvH4VI8cNJlnO9XHbyIMaRuylYni1+7QiHENM6RdH8BpQHftYjUJWNFVFw4q4IX1BX5mdiyG+f6Oy23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6Efx1Xj9YAqGQdrgT9QD2RAnS6wKagFKdBJvNqxKwU=;
 b=YtkgDCSvZHz52f7SVmXDQbSJ9S/NnXKP/GEQPUEaj7kB7+cvbWyO6smtk9Emt6Cataseq7Y8pfdIxWdwzNOzULQC2N5mKt4qMCQnWcLgk/1SIr1K/li+qNoBDpuGe8IFoFdW8A2zw7f2MXdm//t8U9lWBoVDcYISZO8jGpqyqR805dyWUIYIdmLY7PluY/R2kGRP+okvmtWE3YzKDNH/d6gEJCaTEhuOyanb4W3rXvpRtWsnWFPFNk2wKSomdda7TH7biqO2iQMhuu7lPNqwUl8GNMh+1Mb7YeayDR4vECiWt0XDTNdvczsG+yUGSE9ZbNOMvaMW/BUU/Ih3X8CK2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6Efx1Xj9YAqGQdrgT9QD2RAnS6wKagFKdBJvNqxKwU=;
 b=ugvKJqzIFG0lKM71T1vhgclB/rgR0MjfkVYbCK0z7X0HcG+TmTSbvEeau0TPosRUIo+1yDy9N7ErSnAJWQsGqKFvBL3by98I7HO7zCXkTWAQqo++JxkepZHCkcfB6MkLI67F9LYRnA7Qgr+c97JenlEzGSDFx3eby1QNfkUTlB+FlrHWF5/BzDlTImv/0mt7HssZBvtwow50//6BAaxeUwFncAK/w4tB+3aCI9G6bGWjDIxfAjw6g/rqA0P+nvElm6RTNnlBpt+5V4IjoAlE8kMcCKl5NWnqCcpRJ11IoCXWtZ/AYo0xFiCqXmEjhOoxV8aLZrGDUYjgi264qBvMIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3873.namprd12.prod.outlook.com (2603:10b6:a03:1a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Mon, 28 Feb
 2022 23:47:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 23:47:11 +0000
Date:   Mon, 28 Feb 2022 19:47:09 -0400
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
Message-ID: <20220228234709.GV219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
 <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
 <20220228145731.GH219866@nvidia.com>
 <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
 <20220228180520.GO219866@nvidia.com>
 <20220228131614.27ad37dc.alex.williamson@redhat.com>
 <20220228202919.GP219866@nvidia.com>
 <20220228142034.024e7be6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228142034.024e7be6.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0091.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fde11d3-91d5-4fcc-1673-08d9fb14a376
X-MS-TrafficTypeDiagnostic: BY5PR12MB3873:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB38739D55FBA21B3C88BF0C65C2019@BY5PR12MB3873.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGbkFKu5t4eqzyEkuDwFxdCy0ag8tZXVwCJ8jKL8JJ0M0oaj5DIuib9058k3S9t7ORauJmrt341lNAbd7t8BecRzCAYhEjjtXC17iLfdqmj2fGWlroMBGnTJAmpGZAFcmjfnW3w5BjrC9dzFDDi9Dtf8G9zNxBKaimIKxv4GiGtT5NKpajd6KqZR05qza26rJu4PRM8+rs0bhAcNH/hqZrG3qlbAuueM+Da+o6Q9AuMJpkYHdr5T0YdSK9+EqI70JUmj8q2NGNh4oUkX7Kg/4JgaXwfkpRm8Iig+zEMt+7/Na3BEJ6BTiGN+GRThLsh/rKBrcQcglHDtcNQpRg71desEyRkKcdx1RB8TG26BmXgp6BVG9k8OLs9WwadNnTZ9g+5dI+AkNnFiACHiS+iFB+DC/tXMAZg16ldMEZhySBKOS4PDK3qBwQw48g573o4Ez0UrYSx3lo4C3myt8U26UJBH6hbLl9wHD/sErUN3J7jesQV+tSQyMOSupnzA0pQ9nCYitqBGIDIZlojxM0L42SVsXywtAZE4HabDdUFdM7ngmYwftsHbbjIUI5kZGiH4nAm/Pc7zzqYI3WbPhLOymUVcCK45ki9vg5hjYUMQ0+8loGc/Y6/c9jDgnCPfunzADsNLGcyaFzcWHo0G0y1oZ8/r7Qn83zHub+i5YWj6yx1hXZjTxl9hu1hAlf+1dJY2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(66476007)(2906002)(86362001)(6486002)(36756003)(33656002)(186003)(26005)(2616005)(508600001)(1076003)(6506007)(6512007)(8676002)(4326008)(6916009)(7416002)(8936002)(66556008)(5660300002)(83380400001)(316002)(66946007)(54906003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sHsCxMXjNLBbvf/RMJQJgvesxzJ2ljFwW4uBQVcILhLt8F4fpO9AtSMOhAtd?=
 =?us-ascii?Q?zje2TAlzK/fNEqozGUJqtkTuZGWGVQn4vCNIQBJ69XlKNUKh7Mv3dFhvvZ2R?=
 =?us-ascii?Q?1jbolR9cTZ0Of8stPIKtYxhZ+RajK7Qeb9UuSixolqs47eJGdzPWrMIqdxl2?=
 =?us-ascii?Q?mH8uXqU844GIthniBf/rZSYWARHhbfOxv4TVuh9z1CbQAA5bf2xM55tTsvs+?=
 =?us-ascii?Q?QO1PDBdPrE825EbznnJOoXQkdmh6//rv2QuJTwsVBb3jdeFh4WjMby2si/3e?=
 =?us-ascii?Q?ITOYjJAUzBMQi65s2ddBbIPFO6pGlhBeUnqxjXn6/7WykONvEsIJ/a9AOa/8?=
 =?us-ascii?Q?C6JZvqtLh12QLXv4BtViIQpMwSjZuyUTor5Vt68lxQzprWDym+Piy9xGTyqP?=
 =?us-ascii?Q?m0U87rKQacbj141UZDliY6f7f9tm6ZMwkVTBOofwyAPAGj8mU9+aClcRL0/r?=
 =?us-ascii?Q?2/Jbo3I0blMn9k3uRyrLGT/Ogg7TD5fD2ic2mIMCwzRg1tkNmVRlAgoqVuNW?=
 =?us-ascii?Q?/zUYDeeFFRDXF99pT7EoBWYwl9fMPvpgPPCq3xrNErdoHLYi4kzURtQl+r1s?=
 =?us-ascii?Q?5B7DqhV3GoI71CgYQq4jI4WQ+/03Z2aSm8kbHAJ14k0x+jZkPYVLjalzFm2i?=
 =?us-ascii?Q?lTLvw94PNh7ST9JxnP9ABTobg57XlDGAtAlcsGwLqt06wTL45EpWFVVn1VJr?=
 =?us-ascii?Q?dH8Ug+NowQSqnWie3Z6xJu+ReEQ0G+td8pQLb2kIfXIrk3uSvo70mSQ1syha?=
 =?us-ascii?Q?48SfUmr4S/LHSk7X22X6U3JgtHObpD+gGE/FvXUisBQLYt9sqowp6F779rk2?=
 =?us-ascii?Q?iGFOF6hv8UNckthLl3oySuXvfJLYfcT450Nsmz2WKgGg9d/kDgEs3ao4zhdu?=
 =?us-ascii?Q?MxU53chnxJgpts+Vyvmz8CWJNsHMsvwsIve4essVdummp9+fEXgZ1pNJrkWV?=
 =?us-ascii?Q?nI7jQJNXA0hrhByysF5ejVPThIFF9XV+VS3UPYn9OC55V//z5JXDbZBdTTy6?=
 =?us-ascii?Q?HbJWA6Y/pC7cnD5Gpu53Ad6DqU5nPRaMXNHGkY+jXTIoNHCOHDDijzrxBjor?=
 =?us-ascii?Q?jCkR0CTBDKbqUQcSAKdg5sZYv/rm0Jtwoz0nHCosKnGw0Rlc7WHfMVaJd6bs?=
 =?us-ascii?Q?FAmE9erZB5njha7Vsw5auf1A6IUuXDn4PHrPokUgXKIAXEHSTB2yVovaBH0Z?=
 =?us-ascii?Q?oiWJM0b4pi1Cns7RnRX9wiEsfvwYAFT/zUp8/ygpcOlfAS6XLMzOOPtJoCnv?=
 =?us-ascii?Q?odx1dlKg7cAkAPzH7WQkT7e9m2hltlzL/CoDnHZ91Ta0dHlzct/+OlYRgaix?=
 =?us-ascii?Q?JEwz+IEW+dax4bU7C6lfITqb5AnQO7a3AeNU4mBPAuBZvnIE3uXupC3un1ep?=
 =?us-ascii?Q?lPj1dBD9jT1f8goosrSEeoj2Y4Dmh2CYr0jLTXHATsPmZwkhMvcQDQ0xQV5g?=
 =?us-ascii?Q?zaDbRtlOEvITLPHfL4XoOJ4qMs/uq+yTjjKeSLgAKymwQTHpeogXntur0mAW?=
 =?us-ascii?Q?U8ZKjlVowtGCG81ZQoL/6lqHypVOwbTUujrn9CcQ/ysJyL2g9Gy1MK4me2bO?=
 =?us-ascii?Q?LNm5JYMXvFcqra+9AUg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fde11d3-91d5-4fcc-1673-08d9fb14a376
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 23:47:11.2791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IjHWm8az0f/S9e2sGgu3snOXaNyYcy2ojzux5SjzZ7yehZWKQva6SyMHguMpr8/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3873
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 02:20:34PM -0700, Alex Williamson wrote:

> > Unless you think we should block it.
> 
> What's the meaning of initial_bytes and dirty_bytes while in
> STOP_COPY?

Same as during pre-copy - both numbers are the bytes remaining to be
read() from the FD in each bucket. They should continue to decline as
read() progresses regardless of what state the data_fd is in.

The only special thing about STOP_COPY is that dirty_bytes should not
increase as the device should not be generating new dirty data.

How about:

 * Drivers should attempt to return estimates so that initial_bytes +
 * dirty_bytes matches the amount of data an immediate transition to STOP_COPY
 * will require to be streamed. While in STOP_COPY the initial_bytes
 * and dirty_bytes should continue to be decrease as the data_fd
 * progresses streaming out the data.

Remove the 'in the precopy phase' from the first sentance

Adjust the last paragraph as:

+ * returning readable. ENOMSG may not be returned in STOP_COPY. Support
+ * for this ioctl is required when VFIO_MIGRATION_PRE_COPY is set.

Jason
