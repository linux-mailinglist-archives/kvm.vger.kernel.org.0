Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04B25AF26F
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 19:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiIFR2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 13:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbiIFR1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 13:27:53 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA0713E25;
        Tue,  6 Sep 2022 10:19:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEj1KnKmRuDG6gdpcv+hjoPF9y1UU9YhBxjpCFU3FdTM4eh5BUcyNptiPyFAcfQUNZpiHJG5TbYFMYlS6U/1AiVSKosYt+PS5Zdw8JYDSx8Agx5UYbtkb7tB9qqPS2nCOLed/3fwXXzAdb3it0TDEx2mIYDq7BYTjtCbEXA0CMj4vZO2MQ7Zl1B4LU7eBIEE74rvbRUiXXLycTtL3kiiVsKQVKFi82U7LienLHAwR2cPJWg2/NOECgdDkAqe20Kd3DqMI6teFW+sYtyrWUzUn+1WPXvHK3mP1uZvFFKc9nNsSkKbn5YGxoiFosBCPpLZGWUNOIESWgtxe7h7+lp47A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sngGjkHHa1MqLFMLOhWEC3i4piJHq6eQEgygLz5SpY=;
 b=I/xbtElb8QhczWHwSeuPZVw5LgSef3a74yG5tGzf+pfpRsjvAoFwN6iio5/vBNdq8GGm6m73aeAZORfrmvzhqIQPSSGrPo1Tq4iY4d1BfDfiHQGZAUuXVJ9iPcgax+6duYLiE4DLA8CPzZ2nigLx1iPDrx6RabyVc7W8EYmXNdJKsKTvsqd/PG70FgvWyyVyJsuFHMRjGJscg+QwiqdOJgqL4JGhBkXzVMxCF0ileDqGHX0v7Emo2SaS2Q1H9J2c959ISNkjPm6K3Pht4iGddccEcCAFClpc8rQrZgD+bOeCa1FBzbiUuTH8UxoZR6JLA/N3q/8/H9UfAyU4chShWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sngGjkHHa1MqLFMLOhWEC3i4piJHq6eQEgygLz5SpY=;
 b=h/cVgicDTP6Dtv3qXhW8ZlFLN3zGY6WXLTx8L3G8vK/1SNwzWS4XMCFDSZklAWfKkSXtUUM3HHFTVknBnGKoWbrAhTnLuB0iRqLw9dpVOzzVD10Yt/LpjEB9P6iUwQV0drmHnGk0TUwL2GUBcy+/5SHi5RGcppfRSDjM9aT39o/oWlwGZ+QCuGTCsUSfjYtZmm6LjSfqPZruLPVAK7O70KGBIs3etKu4yc8t1RD63sWGES8QLz9PXelzq1ykpbNYb+AOc66cEhkWCxKsYVo8+++Vf4BsdV2vtkyDubw9navLxwC1SjeETg0HmliNlURwsmcmMk3CrKJAOwWupnlNaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4037.namprd12.prod.outlook.com (2603:10b6:610:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 17:19:08 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 17:19:08 +0000
Date:   Tue, 6 Sep 2022 14:19:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        eric.auger@redhat.com, alex.williamson@redhat.com,
        cohuck@redhat.com, puneet.gupta@amd.com,
        song.bao.hua@hisilicon.com, mchehab+huawei@kernel.org,
        maz@kernel.org, f.fainelli@gmail.com, jeffrey.l.hugo@gmail.com,
        saravanak@google.com, Michael.Srba@seznam.cz, mani@kernel.org,
        yishaih@nvidia.com, robin.murphy@arm.com, will@kernel.org,
        joro@8bytes.org, masahiroy@kernel.org, ndesaulniers@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kvm@vger.kernel.org, okaya@kernel.org, harpreet.anand@amd.com,
        nikhil.agarwal@amd.com, michal.simek@amd.com,
        aleksandar.radovanovic@amd.com, git@amd.com
Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Message-ID: <YxeBCsA32jnwMjSj@nvidia.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-5-nipun.gupta@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906134801.4079497-5-nipun.gupta@amd.com>
X-ClientProxiedBy: MN2PR01CA0063.prod.exchangelabs.com (2603:10b6:208:23f::32)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9a70c09-a316-461f-9a74-08da902be80d
X-MS-TrafficTypeDiagnostic: CH2PR12MB4037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pUL0ngNZs3U6pYawxFHTqpb6t9csNyFQQtBVImxhWOtJeoM6ncNs0Z7156RUtJ75Aqf6OPnJ68P3jBRIzmxR30nL5/LioNi6dQeM8TE05xgzscLsnSRDTi+gCSApdRvzdYRqZYQPQ/WULij8Tkw4rGOqGE4fjCD9Urj/rH1dUbwtkn3xwaxGQzxNxvUFtC1+e654ewpiNkvhwdbTfB9F083FB5E9YoMtxRWhZs+w/BOT+MO2WZ6333OBVx2pVCf8Qjn6BpqiFI+CLN3uqCHhSKUWGWqJMa3GyJ7c5z1uBxADUIernVDqJoI0rQBRNF/kxlfFFkg8dPF1mFpA4frM8Z2ufzjuNn8HFYRkRgDpoiiU4+DQbJXVX6y3EOwAHlzflzIHzRHFolf5dgPyr3FY6MERW4vuWIr47+hfM9I4GA2PPzvF6X0cTKOeAyRvDuY3qN9hHHw60J7AnDLLOCR61Uy8A6fYR7ns+p2ITm4+JHojFxcpKJLqcILB0AQzGCKFR0LNXQYz17Ia5ZipAKaqCHo34dKKddC/mBjL3nMz4n4Tcc6FjI9hSPF2hK8JIIT+4sP/rqZmwpFxqhk7DPEapdbJEIVHXX5S5/GzRhGIP9O5EtGQ29p6YxGRMQDYx6fomAkC/pqJRbuPml1B72OXqaCgeEIPRRygEdTN01FlrKWm6Av9s9mSfCQCJ63MhnQNir8Yy3GXp+bXlAY0FfWJ2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(2616005)(7416002)(7406005)(26005)(2906002)(5660300002)(4744005)(8936002)(6506007)(6512007)(41300700001)(186003)(36756003)(86362001)(6486002)(478600001)(316002)(8676002)(66476007)(66556008)(66946007)(6916009)(38100700002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XwhUHLWLaub/SXHt0Oqzi7S82UD1Awx1BgOA+zoifLGaz1EYaDr/4CB/8QWY?=
 =?us-ascii?Q?6tNQgE4qw/K7FOhKf1K5kUYewRPHwedgCQHDXgHUGTOhm2hH55060S8fiKoc?=
 =?us-ascii?Q?UfS+p2HysPd2vPe8RNjo+Tj6qdJ5iYZ519GQ9jM/C7yawHIgJHTHrFSa5fK4?=
 =?us-ascii?Q?MTojbByfwyaCp+vyK6bfgJjXpxZvh1NBXNbM//7oyGHnAofpDXZ3ZwizXAWa?=
 =?us-ascii?Q?rN4WH0goAWgBZxw7TpX5psxBeWG8bYlwpEcibhebjvYRm/YxTQBJfwpGNkYV?=
 =?us-ascii?Q?wxOMIOYDN/tEGSvIg6LVOo9RPY4qozOeh+kjgtmgWmWpt3HI1UU08bCogKPU?=
 =?us-ascii?Q?5czPWqKxAdfR6h4MCS4AmR3cdfdevaamGACrdWQOx2h14qzdHCIIAhGJk2Qm?=
 =?us-ascii?Q?En4RltBb1JEMsOR/QwzRMgbBSABKt6IhQhlLbAngKq7+laoc8RVyMGZWfu22?=
 =?us-ascii?Q?yTtcqtyS5cvOsRg+K0uruc67AEI4lt1P0x8rxspcYAQI6IEv+crWOURyeAPd?=
 =?us-ascii?Q?Iy8iHgd1/yIiC869B1svioG8QMxhQE4LXeEXFJmkonUh6/EMETFNP818JKfz?=
 =?us-ascii?Q?pIjlPZQ6jantV82VHSdFsL9ijy1scBlvM35GCXjv/EOP/GwQGrf6oRqasl0z?=
 =?us-ascii?Q?Sv3fUl8xOrgLgHL1lDgL7nVN9R0TYfSuzDy2t3efNpMI/dCQIla4gwfqM2hq?=
 =?us-ascii?Q?RjvSAP+KKnROf/fke8zatMhtJqsixuOOqrsokvRO4ktY5jW5xZKGNlMs/fTk?=
 =?us-ascii?Q?b4KM3PpuXIKpCWn2JCdWbdcqK7cAMCtyDlehajCUAQiZfsoBUwk4YxOHvrjv?=
 =?us-ascii?Q?iGqplNkB3nbtGr6z3a7B/YBLVW0SPNd3zydhokM973S7C3+p5brNbZi459GJ?=
 =?us-ascii?Q?5WPjEjpSbjPr+EirUDwnM/ydSAGacgx7EkgJQyw/qbZ3Pq9QE4HpqQ/rwGYd?=
 =?us-ascii?Q?9S/zIEO4PLY5snussyQRzpYzm4W82B/nvuihAxK5RzD6+yxIgCduNiE6pD6Q?=
 =?us-ascii?Q?DlEhux51tLc1JZIzmUAvlqX3+7+Q/7N05Mz1Nxiv/DR1xH5ydykNrNn/pcv5?=
 =?us-ascii?Q?nQK5SaRc/Hg98ZyTey/voikJ20nJWYCaMp4rVUqLtqmlIQXCuKF7hTOt/zno?=
 =?us-ascii?Q?MRh6e8KiGXrfPDDMSbsvx4ecQGkQTRauQO4vJyUv6tCKGCpVhdyhexeXWdBy?=
 =?us-ascii?Q?huis2bgxY4a8Ik/FCeV/oxWHp0aQEvXrMfZQk81QaZVeTvrfXuajkbTADR5f?=
 =?us-ascii?Q?kQ0RzUnvsODAsGUuk0l9bwMYio8DkJQpw1S68d1ZDjLegnlZCk4jms1rPP1t?=
 =?us-ascii?Q?MS3vBiJhiSha2vVOMWdAW44SonILTe86aDY5QuuO1u4WZ2OAVqZMrngaiEKf?=
 =?us-ascii?Q?IBVbnYjfBoPbkaF/UAk7KaUlqjcyHPH6fv18d3r+1DXpZq78g4mn3Pw05XXj?=
 =?us-ascii?Q?lJwrq5ODDymbXgMAUXdBCFuv8DapcxWB/GC0IAm58W/Gj5PmSgQxoRk9wkE8?=
 =?us-ascii?Q?m/KB2Ua56wnaucP3vxwzLlfV4E9SGZZqEUT6JknBqt9QIwvI3lHXTxGRy2yG?=
 =?us-ascii?Q?cD5cfAHfGXtQ4WXOTCJcBwj25AuIl2EYEftD015L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a70c09-a316-461f-9a74-08da902be80d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 17:19:07.9888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3QgLwFQaqZDzzpDtRClvgKRWQr5PbqhyQWHF3uK5Q6EmhhGLTzhcUxBPrPKHMev
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4037
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 06, 2022 at 07:17:58PM +0530, Nipun Gupta wrote:

> +static void cdx_msi_write_msg(struct irq_data *irq_data,
> +			      struct msi_msg *msg)
> +{
> +	/*
> +	 * Do nothing as CDX devices have these pre-populated
> +	 * in the hardware itself.
> +	 */
> +}

Huh?

There is no way it can be pre-populated, the addr/data pair,
especially on ARM, is completely under SW control. There is some
commonly used IOVA base in Linux for the ITS page, but no HW should
hardwire that.

Jason
