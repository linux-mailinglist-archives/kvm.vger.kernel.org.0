Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B5C5F3CF0
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 08:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJDGxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 02:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJDGxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 02:53:16 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE29B2E9FD
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 23:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxHXlTz5PD3Jwy3o9HdqIvrRBvuKYJgumSnCMKIec0rWkwEjz3G1y5+tewZZXk1ykShqUm6IYeWaiuw/52Ylk9OBRazpoqvqLn6OOmXBpLO7nOeZWfEENc0y1hfiq8v637z3Vd4ZmnQu+5S7WlnfUK8lZgOYVh/AZnpJ+B4VBBTBRHfC3l3NFY9OkGNhDN/ptGIWGkGHlsCTpofRumyDUJhAN0LmuZuCEZm7Q7lhkBc61FF/qqJZ82D+8WGmMi6CnKDCP0eSuapUdKcc/zuQpQuMVq9lzRJI77t/0Idpprm/mMN43DI9beS0IQwcCQJsvudW4SQjhCRM/k6qZl8I9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfsx3KM1MqQC8pJFJxp+Gsv7JCkwq9K5gWK8SbbHH6w=;
 b=CiQtVJYFOOjllgQTBTF8KwYrJQzeEI9QlpCPBiPUWkOVw5C+MOtfYOBccRhHz386U1NpH7ytYR9ONk4JjB4vb+iUKn0+5Sy5HsoX+5upcOG1AXNUT1BaO87vWjUxAR0uJTEZQF8CBNnKXSXbGNrNJlh0YS88Uxziebk58yWcssO2HCqG4Z3ufNvzVF0ChMXaC1CTSKW0HokxP5niqvscHxvS9LxNsM4wRR/seYjB+NKkl31opunCyZxE2SxNX4Jxg4bghMO9EqgXvOUMXr/eLP/KPX4Afs69YmobXtDOJoT9zXnj5Yu9EdgtkIhp82OE12kFlmjHf6eYouZTCmckDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfsx3KM1MqQC8pJFJxp+Gsv7JCkwq9K5gWK8SbbHH6w=;
 b=NnBwIGxuwsxe45EnXb+9yyJw5CdSk0C74Gt/tEOrTN56pXwy8UgEJMQNArq/wmRZcIh+kD0BQmfUWVLWcqT2myIERrgCfHrzGSzJd/pTYwdU5fc1KAM7/rbTOq5MolcvkZoWVlM8vPy2yxEdhytCvxaZzD/cWLMPZrGdvvJiLUnB76MNSHXZKDbn/asaYdcKgYdxcCqq055UOFCc5v/4X9hcapwAb+FvcTsX5jD9wQlruUimGdh93iX7PkyZd9aZe/aP6O5nQeT5713HwWCUyZjv+3CgtG5N7T89akhHETA2HxstQ3twLMlyBItUAcFzRPxL8047VeQ21klTRLF8eA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MN0PR12MB6341.namprd12.prod.outlook.com (2603:10b6:208:3c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Tue, 4 Oct
 2022 06:53:11 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4064:6c13:72e5:a936]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4064:6c13:72e5:a936%5]) with mapi id 15.20.5676.023; Tue, 4 Oct 2022
 06:53:11 +0000
References: <20220608123139.19356-1-yi.l.liu@intel.com>
 <20220608123139.19356-14-yi.l.liu@intel.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, qemu-devel@nongnu.org
Subject: Re: [RFC v2 13/15] vfio/iommufd: Implement the iommufd backend
Date:   Tue, 04 Oct 2022 17:47:36 +1100
In-reply-to: <20220608123139.19356-14-yi.l.liu@intel.com>
Message-ID: <87zgecqdv1.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0053.ausprd01.prod.outlook.com
 (2603:10c6:10:e9::22) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|MN0PR12MB6341:EE_
X-MS-Office365-Filtering-Correlation-Id: d309a959-8be8-4776-5cea-08daa5d51a4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5Z2RsEjhgB11Jk5XIFQwkTbOntorzVLmdxheuKUFy45ST3q/G6YLr5Dlw7ycpURE3KvWo5QzSwTdBR91GaUOOavbM+m/W8kEs/xdAOTpayefYk74oizgXaRKuzjxoU9LGsOYKl/MLe+IUkIH6F6mjoFiinyVcYCuZwibljwZnhPEUIn1n4FhkQuPXB2x2peEdh/kY1fG+9ZI1NmsLnwIyaA+N0ZNNKAi/+XQPZO1XBg0uCyrUWdYgQsknZ84wsGTTdco9xMxUu9cuGDuJogxNrTUTTC+FPvgOzwEEMmkHk8PiGWMEWzAYErP9isgXb7+EV7hCPmRdZ1+3d1zW9QDp82oiQe6O0waGYBfk8dCO+REd8JclN3s+bWbW0RNKOr21L/w0cnLzdYjbt+u/7QM87mDVCV8Xmt+Z+bnT//6anvYlRU25ZvFbOy6VPo7yuGPpg0MZI1018p9fd2GpmBM66HNYZiu7zMrAjtgFS1L/D9JAxxHjgdTBeM4q+fYmq24EdrRl1RfuJq2xvd5o0wpA3blK6zMl8hrbhk5i9I5kgLr4UaR3roUZDjJ+iIliL52Uo1y3cxUp4qAhmyVgIR/PTUMP29HsGy7jBKjOkSMlWQcarFyBA8vG5dV0vyxL5x7JiB2vmPNA5cP4oToilfi1E7SK5GXeTK7ZLaQ0EvE1KVESQinWYKVxXsOEmyHP4J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199015)(66476007)(66556008)(4326008)(8676002)(66946007)(6916009)(26005)(6666004)(6506007)(2616005)(186003)(36756003)(316002)(5660300002)(8936002)(2906002)(7416002)(41300700001)(86362001)(6512007)(38100700002)(83380400001)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fCqo44HNSM3fJntyQEgSjZq3gQxnZvp4Pde8Gkq9CQNGVxdR7u1Z7xOCYHFv?=
 =?us-ascii?Q?UvQHLmCm+IQCuj4yYrdIsmhW6liKFACrtDPlw9I/Y+yA8LzD/YsZoo3b+E2S?=
 =?us-ascii?Q?3kS+uBDqih3C+6ZtVJ7ToLJ4QKlgCDhdherMjMptTGXoliyfuZ0++0In7QuW?=
 =?us-ascii?Q?S2Srb3ovEWjYLq4mYKdRT4NEZ/H42LTk8+WU1diSBVWE9MjjLsdVqVLQIFsl?=
 =?us-ascii?Q?IUuFYDp++P69iW8xgarjrr4oHQsaUGQuSPHW8U66VPJyHAid6UEUTSjSwu2e?=
 =?us-ascii?Q?LGbIO3DghGV9Kcc0BLYh0egUuqhLvIqh++19/FOSy3dgrgu78GUkj9lev6eU?=
 =?us-ascii?Q?02xzOYm6M/HPPt9qwgxpvxAvB8qEoIaCyNdSM9c6Vu+bZGMDlx9wW+fIGoS+?=
 =?us-ascii?Q?/yO7tBiTOB68rsVV3Hyqlb7KfCV696hApl+G8wNBosbDKqUxNIKnX6mF8L1H?=
 =?us-ascii?Q?WwymzJjIlfTUWZeliv/U+fDBgS2Qi1v0vbzhA4/gbBS/jGF3WGupocoZYHei?=
 =?us-ascii?Q?u5HudgtVbo6S1XZg77mq5JmQjXCE41GHnIxtrSvG7ieki83qqvg5FiuXZkOt?=
 =?us-ascii?Q?EEg+6pfwAT9axVxocNKHRNh8kjGDuzz6TRSuoGfm8vZ5CdXoFra6LVhiqdfB?=
 =?us-ascii?Q?VmysEKXBDrpp8iGmPrgCNlLG9ewquxcWuenXvC+A8bV13N8UkfxTlhdnZN2C?=
 =?us-ascii?Q?uWWktexfSM9NC+Ff91OgVVoDhRR4KhZ/3dUFBgCUjeHvVackCJGPh/pEzy8b?=
 =?us-ascii?Q?VbbWR+BPAzS/uXkPDZqur22zYXFxkLIreIMryssQyxXJx5mtFmAEjnZilS/4?=
 =?us-ascii?Q?TRgcXCIXlA99B7PKCGoozXLFX+58BnLP6vjPv/uykZjZYOkfiVJ4yznflcLU?=
 =?us-ascii?Q?9BhVfpAq2Gx4YNxtn9CBdDgEKLzL5BI0eC1B+/LP2iO58IHmcMpDJ1/LI2C7?=
 =?us-ascii?Q?0guh1WWeera+5171cGgAdiFKRdU3x9ZIgdH00dpqcKYlV5rcT8bUN1CQeUB8?=
 =?us-ascii?Q?x20SKkTYA3Dd+O7PQ8FsBJJI5SkttceUq6ZkxoKpnIGZnHtP4nsDRE0NqJQs?=
 =?us-ascii?Q?uqshfu84Vk33XYMlU+XmwTyxd518mv6JzjiQXNUjcOadyOCGjK5F8RzWpFZr?=
 =?us-ascii?Q?ODcJNIBzpdXB3uSdtD4yclQd6xuTcYkPovXb7sdR0iMBXIqRypM2KT6oHY/H?=
 =?us-ascii?Q?BPMO7di/MSZfIM6VzxvQjU1LiOamoweKY3whRbpQn/BcFG6a/nakOm4Ev6ED?=
 =?us-ascii?Q?Ue9OuRzWiklH9FJ90BheVdm73TKhxoO4UD0PSd9R/vjRAZnTw9djWn4rG6q7?=
 =?us-ascii?Q?ZcTZuqsh+M3GA2COtryYXDQNhRTdHuUZE441ZT+dMoaDFWVgoixChV+uSuft?=
 =?us-ascii?Q?dN0/XY1dP2MtTr41Eui3GoizKf2ldQr0m5P/Db6RrmPfUipB7hMVw7Juk2Yu?=
 =?us-ascii?Q?ufJHM1Y5hQp/C+LEEhTgoN9BGP1BBc+R8MBEZdx+wrk7WEiXSOGwGNCbqOgd?=
 =?us-ascii?Q?WPK+Sr27weIbJ6OHdHJLOjeFtog4HBSPwrAWemRzE2D0TSbUTTyNZ3gDTkPo?=
 =?us-ascii?Q?jH6a3aov4F1ZpSxMKOo3MJbRYqiHEac7CHxQh/uB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d309a959-8be8-4776-5cea-08daa5d51a4b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 06:53:11.5985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSI3XdIVxaCsoTCr0l2U3iKXf3yq1ipR++aBG7Dd6AFq+pT+UiOkc0HrzqrQSOIUsl6OSMbDxPutMxPq5mec+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6341
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Yi Liu <yi.l.liu@intel.com> writes:

[...]

> +static int vfio_get_devicefd(const char *sysfs_path, Error **errp)
> +{
> +    long int ret = -ENOTTY;
> +    char *path, *vfio_dev_path = NULL, *vfio_path = NULL;
> +    DIR *dir;
> +    struct dirent *dent;
> +    gchar *contents;
> +    struct stat st;
> +    gsize length;
> +    int major, minor;
> +    dev_t vfio_devt;
> +
> +    path = g_strdup_printf("%s/vfio-device", sysfs_path);
> +    if (stat(path, &st) < 0) {
> +        error_setg_errno(errp, errno, "no such host device");
> +        goto out_free_path;
> +    }
> +
> +    dir = opendir(path);
> +    if (!dir) {
> +        error_setg_errno(errp, errno, "couldn't open dirrectory %s", path);
> +        goto out_free_path;
> +    }
> +
> +    while ((dent = readdir(dir))) {
> +        if (!strncmp(dent->d_name, "vfio", 4)) {
> +            vfio_dev_path = g_strdup_printf("%s/%s/dev", path, dent->d_name);
> +            break;
> +        }
> +    }
> +
> +    if (!vfio_dev_path) {
> +        error_setg(errp, "failed to find vfio-device/vfioX/dev");
> +        goto out_free_path;
> +    }
> +
> +    if (!g_file_get_contents(vfio_dev_path, &contents, &length, NULL)) {
> +        error_setg(errp, "failed to load \"%s\"", vfio_dev_path);
> +        goto out_free_dev_path;
> +    }
> +
> +    if (sscanf(contents, "%d:%d", &major, &minor) != 2) {
> +        error_setg(errp, "failed to get major:mino for \"%s\"", vfio_dev_path);
> +        goto out_free_dev_path;
> +    }
> +    g_free(contents);
> +    vfio_devt = makedev(major, minor);
> +
> +    vfio_path = g_strdup_printf("/dev/vfio/devices/%s", dent->d_name);
> +    ret = open_cdev(vfio_path, vfio_devt);
> +    if (ret < 0) {
> +        error_setg(errp, "Failed to open %s", vfio_path);
> +    }
> +
> +    trace_vfio_iommufd_get_devicefd(vfio_path, ret);
> +    g_free(vfio_path);
> +
> +out_free_dev_path:
> +    g_free(vfio_dev_path);
> +out_free_path:
> +    g_free(path);
> +
> +    if (*errp) {
> +        error_prepend(errp, VFIO_MSG_PREFIX, path);

I ran into this while trying to get things running, so haven't reviewed
the patch but noticed path is used after it's freed if !!*errp.

 - Alistair

> +    }
> +    return ret;
> +}
