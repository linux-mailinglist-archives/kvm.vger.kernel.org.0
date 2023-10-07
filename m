Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8647BC540
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 08:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343601AbjJGG41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 02:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343578AbjJGG4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 02:56:25 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2070.outbound.protection.outlook.com [40.107.255.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EC5101;
        Fri,  6 Oct 2023 23:56:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e02quNJlg2Twk1zXbLJUxMCdnJjH1+LmrdqTrg6yV3QJhPFdFwIh7tAbKUknyZ3uejdWGBHDM0E0oomldcnWH4Gk7yipuMYUGSWtX+9Ivsfvw+77H2E7Zw8cw2LJgiUAPcRG/c0l6i9j3g4cFOUgV/8sYCqhG7D1xOy5ULAZRMP91O+3557M/WsPhNTJ5761zd/c0Tf9lpXsZtD9nqM+R08VsWvFt6LBpmFZvsVHui8NF/qx1NfGBTFEkUEiPwWrRgoOQolNitk1rJUdZap1TapS8eGgyjf7Q3Zi7n0nCcHYoMZk6RhW7rF2IJ1fEGgbPKqhYfU3LfpxO0XaPZuaEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEg3U4C1ZpQnUuz6N6p7iOywx8McgaA7IUuwdRf5TLw=;
 b=BR/rEZ5BkAcmsVcKUs5FMD+EnsN3RoB7HlvitCnXj72HO211xqQ8mdqlA/E8s4WPNJZCrUIAExEUGwjgiooxhehjshtRq6LM6tGR7M/ZqGuNVpleunO3gQyLZkBdFIDixQ413AfkeQkmkfxy+8MpCdLnUz3IDOVy28xWCnCjHJNO53HsvUngxqlwTCWI/IIY1Yyk1jFiiWhjIonIE7xsZrFonFNsqACPxx62UUeO+dl7xa6gzsGbm3zT8dIMHw+DtZ9Uj6RNQ81RUxClALy1sob0kdMUYqgEyQNY+QQF88UoPhTRQyjQcUEC7eSi9gNoa3O5UqoHAOihmvFxhCFBCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEg3U4C1ZpQnUuz6N6p7iOywx8McgaA7IUuwdRf5TLw=;
 b=npBMmhya7jXxt2BaIxg6bGe0KaxhZRzvCWMJthqMSeQF+/sR0HLgL0ikR7dHRg4N4jhPnpYqnF0qgMkdWAF9jWZhpSHHwH7uCe61/anvXSpc5sZ0IwHEy4+urYWBg1CpgtAtw30hZNDxn5PGWWI3ve3TruRqncna862iKWBNhEPe5qVRATQr7wbq9EfQ2aqzWGjYThRB7fjvi0ZocoPG/1uX/UEMUE6ujYl7SJkDuY4sDQ1Mn5i+84Ui7/0jf6zms7wvjksqTPRgtVDH4d7IoQtAP90mWsFXznMK962el4pv0gm+2x3FR3N5trR/GvpEa88waJ5YYD5pUP1D16s3yQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by TYZPR06MB6745.apcprd06.prod.outlook.com (2603:1096:400:45a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.38; Sat, 7 Oct
 2023 06:56:20 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::e5ee:587c:9e8e:1dbd%4]) with mapi id 15.20.6838.033; Sat, 7 Oct 2023
 06:56:20 +0000
From:   liming.wu@jaguarmicro.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liming Wu <liming.wu@jaguarmicro.com>
Subject: [PATCH v2 2/2] tools/virtio: Add hints when module is not installed
Date:   Sat,  7 Oct 2023 14:55:47 +0800
Message-Id: <20231007065547.1028-2-liming.wu@jaguarmicro.com>
X-Mailer: git-send-email 2.34.0.windows.1
In-Reply-To: <20231007065547.1028-1-liming.wu@jaguarmicro.com>
References: <20230927111904-mutt-send-email-mst@kernel.org>
 <20231007065547.1028-1-liming.wu@jaguarmicro.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:196::11) To PSAPR06MB3942.apcprd06.prod.outlook.com
 (2603:1096:301:2b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAPR06MB3942:EE_|TYZPR06MB6745:EE_
X-MS-Office365-Filtering-Correlation-Id: 85edcbce-23c0-40b7-c2f1-08dbc70282c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3tIYaEjRzh3BuaySEjwDCNGNaWQ1nOdjile8U1OUQFjLNJ3ifVR5H/yQLKTE4RShthqN3FsCaV8gY0JxxVBmAzwewbXK62fzslXxAPvQQ0yEcW85yClq+uXLu8aNLk12oFDH5RbuI5ukr8wBaQNXsvObD4Q9QBSrfeGoOUKBlKvieNns4walty1UkLKK4i8wpt9dtPC3TOpSqG1Kk/TTP2QnEZuJlfcY1WwFwpSLtxzbwUkWyg28xfpthdp6Ib/fiksbGIAw+CD27iX/rxinygGTDX5zQa2IhlwQdRotWG4lfUk9Q0GuQyO/5mFelo3+aw1K6PLyaQLCJ1hazBygeukz65JrI1Q6k8KJlTcdXYJTepKopaW2YNVhr/0JS72A4IfR5MVaeeMWh9OdY2QDZgPyQ5jhb72qBSAfrAL2aSJ8agFghC7rOu+962ujkK5uJ3Ff5s8iUWDfNS27OXrB/o9/h3GHwptODvVifN06q0kEE2peIS3B7qJ3qeamx36u9bcdkCl8nVqeA5UTEVmV/v58vopuScXCYElFHACUPlsh+AqaM75+6snflKM86OI1T98GU/bJoNMOsylWnewWF6uvxI1Yi9d5JPYp3TlC+RTRFWde8iPsdEVZobqbMGPr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(346002)(39830400003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(4744005)(2906002)(4326008)(8936002)(5660300002)(8676002)(86362001)(36756003)(316002)(41300700001)(6636002)(66946007)(66556008)(66476007)(110136005)(9686003)(6486002)(6512007)(478600001)(6666004)(2616005)(38100700002)(38350700002)(1076003)(26005)(107886003)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lz52qsTsfDnT+oDL5tNkzHO6TNGgd5zo3lf65HtjKaXszY/aT2chSCGeYqW9?=
 =?us-ascii?Q?vKPc0Py45xZLkFHKX88PxK8ORN1QTacPj56m3DIoInl5zR8JzueNlM/IG7qQ?=
 =?us-ascii?Q?Q9kcs6sVx6cb+ljguIWvJXZkcZnWKZ7jKc0101Yx9xm6/HgJ3U/C36D50ypP?=
 =?us-ascii?Q?NIhodM4r693EeUyNnVWIo1OtxJj48qHXD+xFBz9wra7mLxTSRhrhYxi6r2n0?=
 =?us-ascii?Q?7W/ngbD/6BF88ZjgfnYWhZsou4RsWFZBJWCLfyYImZCdmsyHbY8zlxokF9ti?=
 =?us-ascii?Q?Bxa5yQaciOg4UgbiBEjoEUZJnoBO2dI8tqxHINDKe/h7t2eTab6Hn8bdWVvU?=
 =?us-ascii?Q?KYHTcLp9eFrCP/9hRU4FA/2LFPE2U3l2qK5RqeY/F4yqB9hpo8GajBh4F9RV?=
 =?us-ascii?Q?4DztEiIlk/UsqQ2TpqI1Mvw0NAUJGee/A4uorJi4sF6dHPFAa+KHghI90qk1?=
 =?us-ascii?Q?9KRzUIBZ0oyUP2o/ZmOytc8FDFltGqIJ0WtdQKcX5pbhwg8RGDRlqelBEY14?=
 =?us-ascii?Q?U8B3bXR7SFHSpN9Hd9+/VYJz+KK67akdOjG7z13wwhuYBkrHJuX/AxSjpvUy?=
 =?us-ascii?Q?FWfntoMa36P67GhB+TPUaXEVlSFPEKihhFDEizPxXSR7kfOat+BqlfHL5rKO?=
 =?us-ascii?Q?+Cs9VkeLX4Ku428kKpepVtoCEgie166H99AN/W3yOdz1JZuzqTInUCv4x9OQ?=
 =?us-ascii?Q?4chvePRwWAeoC2TvmyPn6llxJ04cL85PPzmJ7Q/H0DQYNpioLBAcF3IIEIgb?=
 =?us-ascii?Q?P1cZQ3rF4b8UT8eODdBoGVFLv7ERuSwQPVFpzEdawi7GOAFo9D0hFfCIkTQs?=
 =?us-ascii?Q?Mns/An48+u0rP3lwdymhJdXifKOwCdELCs9Q+agRKXPuMnTq6oYWdKWR9TId?=
 =?us-ascii?Q?P6ZQ5EHKjjcqHlowfA1bLSqpMaKb4//OEXc9s3/KdKOZJ/vFOOB1jCqtspiN?=
 =?us-ascii?Q?TlPC1tGPV8pImjn9NKkQ6Da9YUGj+Znu/Aak28QO7Jl4Bo7/1spftQeqMyg9?=
 =?us-ascii?Q?hUL80cWN345GzEYxuWf5dEiLzDhOmY+nviEzSU+xQxmj5VOp8XsXuj8iVXhA?=
 =?us-ascii?Q?WmRrg4IjAq3Zq+WCsuFOvME23pt0RUGSsmPSII+bp5gFX5l7gyZtgSTVTito?=
 =?us-ascii?Q?h3tkirDhlNwOWDAgPqnmQgQtBxbMgAX2T5eK11cF3m+P84Cl99s7cEzeOyFA?=
 =?us-ascii?Q?8nHwASqvdYnHu/lRC9grlx5dsoHdR/W23rsyoJzM+9TqolLBPkm1UcrbN3n+?=
 =?us-ascii?Q?SP+pBvG4cYsv6vX2ZKELu1rIY85+cvUoOYgVhUsZPmJv7C4OpN0O0NjcUd4Z?=
 =?us-ascii?Q?9dv2V8QGC/NOrjV5xuom32Aua4/f+AMyXGoNpowSHBmah/0xqLiReFbZJYC7?=
 =?us-ascii?Q?+Y8mryNbgDzh4yrM/wFh96bodCEgv+fXsWeEApjhHwouqyxssufjjDTew8Gc?=
 =?us-ascii?Q?lfoCPqpe6lAkUKZocGgmjTn0OLc2yQZuyBUQEex6qzwHJ/MCHIyR1bpr5li1?=
 =?us-ascii?Q?F3kC+9sz9xTPT3xH0tyapYoScBkCNJ/5R5uINk7lMAWUnD9Io9Qw6eM1HFj3?=
 =?us-ascii?Q?WXx37Kr22uBf1FSJ69Trax84F7y65RMZUzyJRYJ1gEKPU/T4DbePrWlpRTUk?=
 =?us-ascii?Q?dg=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85edcbce-23c0-40b7-c2f1-08dbc70282c7
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2023 06:56:20.4176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2bXt3TNLi8M3IjzI3BUfgqKZ79xsbFwgbHX91e18OwDP1eI55mqr0ZRubxg+TqXlWON7iWpyTax3OoyWXNOhvkwEhh6ELJ9ePDBvDaESpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6745
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liming Wu <liming.wu@jaguarmicro.com>

Need to insmod vhost_test.ko before run virtio_test.
Give some hints to users.

Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
---
 tools/virtio/virtio_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 028f54e6854a..13572a677c35 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -135,6 +135,10 @@ static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
 	dev->buf = malloc(dev->buf_size);
 	assert(dev->buf);
 	dev->control = open("/dev/vhost-test", O_RDWR);
+
+	if (dev->control < 0)
+		fprintf(stderr,
+			"Install vhost_test module (/vhost_test/vhost_test.ko) first.\n");
 	assert(dev->control >= 0);
 	r = ioctl(dev->control, VHOST_SET_OWNER, NULL);
 	assert(r >= 0);
-- 
2.34.1

