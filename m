Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0303C9AE5
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 10:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhGOI6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 04:58:32 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:29735 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230523AbhGOI6c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 04:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1626339338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=68NKbrwr4xIWVH0gzIYYeJI4VzOA2QcK1vwRRSxDToI=;
        b=GYonlwAM9n2QYnkS9IPpuAK8H+Tu2k2qeDHeyVEVa+WKQGNkWk3iYP4J2+aIailqjqrZw+
        7c/QbS3cEiQZqIOJ0piF8CSes7yAUggTIKIPv38o9a7FHXhP5eWMxF19AWygTHEdWpHqJg
        7R8PCVspMulClX5eAlzoo4W2DtLPzvQ=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2054.outbound.protection.outlook.com [104.47.2.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-3OjsqvlIMbakg-sYGd4hsg-1; Thu, 15 Jul 2021 10:55:37 +0200
X-MC-Unique: 3OjsqvlIMbakg-sYGd4hsg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9HmjEFwuqCVEBRJAlRHZz3N7eQpMMa6hjVz2LtXVxlNLbljO6VnTorfinVbUpwtqaQ/gz5fxEAw4XS3OBFNV7ffwv4s0/w4bcUiAfhvn/56UjCH7vwaKW0+v6MHFoJuQg9x/7yCj3afAS1hhtrKC9/pSy7omq+p23lSkjQjumV/OADLILD+Zu5OSWo0jBdfhmDkTcf+lxeHaiksLPgv/in8eaqwCgwM+gvLhHk/i6WIPaHIdTlYGYJI0iGGc9ymklCBwFrYmKJE23537jrZbawVyldNPuDKa1Ty9nXsejT+/JEQHd33AjRyO+MTAMNVnshw8UBWqZM5ZXsbdrL51w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fXW5dI0LhZ7Hx1THd5HjUdc0P3eCVsHtCBbnB5zas8=;
 b=ZufkQ3Jgw7KpbfvZ3W2Ip9Gd/JJcDL3KN20S4inwmpSRhrbPVNL3fIZt4GoxbzckzFALmJUQN+9LDElHZU/UoROeOFuQCoyysIvtxNaNaxavS9L8FUTCbRjRoyX137hSNY+hzjuJmm7X/3HAQGtQgNsVL6Owu83THj64A3oHKnNJtSudTGnRoGfXyJSZ3504lhypGcOk0z6JDPpxTLYwHMThIwc51pGpyaWWpN9Y30R1OVRh8l4h868M7wRNOPnl3dyscu3R0aw7jUBGcGGo0M6sUGrrBHvOFnz1XvpsMy8mAbtKvmhd8i3v9IwrAvNpwaashZXas2bXl357u3GnPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com (2603:10a6:20b:105::22)
 by AM5PR0402MB2897.eurprd04.prod.outlook.com (2603:10a6:203:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 08:55:35 +0000
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::816b:1f6a:c279:1b65]) by AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::816b:1f6a:c279:1b65%3]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 08:55:35 +0000
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
From:   Qu Wenruo <wqu@suse.com>
Subject: Any way to disable KVM VHE extension?
Message-ID: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
Date:   Thu, 15 Jul 2021 16:55:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::49) To AM7PR04MB6821.eurprd04.prod.outlook.com
 (2603:10a6:20b:105::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by BYAPR02CA0036.namprd02.prod.outlook.com (2603:10b6:a02:ee::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 08:55:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6c44baf-0b54-48fd-c544-08d9476e4f98
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2897:
X-Microsoft-Antispam-PRVS: <AM5PR0402MB2897485823B3EC5151D5D833D6129@AM5PR0402MB2897.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: udYQc2Q3jFiIZUIIAS1T87nZu6OfwhnlMjM/0f47wXyQSdAy3MyzpKcCCfWq56/HkIF2h78kKRR4c0rlNwJvNmJN7FTAP3fexrZv/1kYw3dYPpZ9TqOTl3s4xNcPdSS+5LBWrZqNpYqvgLV2ooQHjjy2CuDZqRTD1hz7VDnIfGxyMUqr7iEoafLGH14JfbCJafNIsTJmUJ3KDrdsxuxW89ueWOnDYISobWzDwu2tY1OGmvnl76Y63mwFixUVJApUutp0NmiYNjMvZGPbyfVzBEC2NLh0KMnYPkgxpnkLQ4tJCOli4zeFk4SnU0vlLwG1bosZsvQZCLQW5Zqi1ZUDlV5mKxovArxUe2a90JF90AQ6U6jAs5fdMt06/vcYeaRVEp0PdlufkkLpZA5Ac8Cwibug3GK0xn3Rv2/wkbAEqmIt+mv9JkBjp7WI9KhqJ40InlxmB/Do+T+Pu0Xq192+eaSn3LeM29wlnJIDkfSh6TM0XHnRL0+kKPCQCwAO//P2L89Ew2yRsgFmDV4iJk/Ve5MmNvEium1Mn4WlcLmWq8xixqfyVkGXALK8hm+dL/EFBqniz/QthK2Wmht3Xs0wwTIZIUqPEMKkd/IZeg6hbaERJYy46RvyqjAGqoiUQQHDSJqveIDXFCO2VPAkBlrUGIxxfY/Sh6rzanjBeJI3RA+q0FhGL9xTupejaIfCWBGb5FwpirLpikzq7ioeeenrkqgKvThdH2MO2kp5qVYT5KZuYeBc6ZvRFb50/FTTqmWMSSXBPfzO1QnrVvXOgDE7dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6821.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(366004)(39850400004)(83380400001)(31696002)(2906002)(26005)(86362001)(66476007)(478600001)(316002)(66556008)(186003)(5660300002)(8676002)(36756003)(31686004)(6486002)(66946007)(6706004)(8936002)(16576012)(6916009)(2616005)(38100700002)(956004)(6666004)(43043002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f8/xWioPmKANPOyG3lJSIlrUI+ZH5/1ZiTO//RdSgt50SA7TLhgUehHQf6Nh?=
 =?us-ascii?Q?k8ynXcCZh7c4/mLnkagk3G1lSwHEQEEeEoEDKp7pOt0wfZ3G6664yuHD78Cb?=
 =?us-ascii?Q?DV4q7Z3aRrG/7TFMfGBqergBSFct2JojGp/Dh8rtH/2E7M0A/DBsmvKur9XC?=
 =?us-ascii?Q?C/B8lEr8m8fS7u51DLEAULv1utILqJLqlY5IRYljCNadmZMcRpvJIyMnsNw3?=
 =?us-ascii?Q?lkR1plsfHoM8HfPd7z+yYKFQ4a4VQunjENQZfgLb+voA0vH5b0TWmWJCkXXZ?=
 =?us-ascii?Q?LhSIAYPv4Ph/NvKXIedFy/ZZZceHlvrZfOITahe87snQdTtbvJaSp5R5BRkk?=
 =?us-ascii?Q?dFqa0v7XvWkD0NiFLMKtQ8tbqcCWijvZEGqS3ObJqI4hck7rcuqYNVYMX9LC?=
 =?us-ascii?Q?KcxIHfscKpISVQaBXLq8B3GSckDwTu5yEL3pi8TTPH0FaF6AHOZu7+sFQ0I2?=
 =?us-ascii?Q?gatIVNa3yIRl+OBi01Ije+YITByKhFtUx+/VIeGUKUPtSgQR40ROoziPLUPA?=
 =?us-ascii?Q?L2hG/HrFrg8FMIXBZmWnEsRLp5yMnQuwmtuxQ3XZC+hORUFWPrMEdYu+nLPL?=
 =?us-ascii?Q?SAnEBI9dw+HF4cm/DRwd6q3RXe3ExmSr5KfTZpl98ICc+Ieo/8xuKky2zocF?=
 =?us-ascii?Q?g4PJLynsz82gYcBcV62b77cd97cB8dm8fOtS3GMONxwxsxcgNFdNTy6cPtn/?=
 =?us-ascii?Q?h2w0L451YI80QFFJPyg2XH6WNuHK9Li744ktVmY9SPkDf3gShaYN81KHXUPv?=
 =?us-ascii?Q?rKJsEiS3gPSuvLvVCTdSs0J+RRYiEF3+S0kRCRna4cFTr0JOOOmpNlwEn+B5?=
 =?us-ascii?Q?hg/Y/Pp6iGASlzz7RncN77TnMKDC8qpo3qW+StPqFp0Q9WAWtWebDYrOHCFM?=
 =?us-ascii?Q?YJQSA9DDt3UFM6yjEHeIpYJL36bNruis1MHNyQLoE38c9hFNCxzIYR8Arxgq?=
 =?us-ascii?Q?38iVVL92VT8VPRvQjo8kHBSXPILdaLO6DvSh6dV1Z34gXifFVbyDtEGiy/7t?=
 =?us-ascii?Q?SDhiNbMt9fOaCtzOQ79aOH2B1BPUaLqmqd80cik0WTjoGUyYTD9xwR6QwQMj?=
 =?us-ascii?Q?GT1G1KWvLPbMETp6w1ardJ0eJoXoCDefx59Kbfc/05uMkpeRsWwAM2zFwjjX?=
 =?us-ascii?Q?pUJyEsuEv6WaloFMT47O08u0omlOWIgke8RSdaLH6KAVMJoiIbtbBZkJmytp?=
 =?us-ascii?Q?cdNkmCmCz+HJf4ZOsCWYR/I7NaFdgpsIQpH8XR0vpKJrIry8rcsei9J6YL4I?=
 =?us-ascii?Q?/meq0wSn1NHyU6TnQUO7z38sJ4gJ5hOveapOSNDcgBlX94msj4cE5/YDAcTN?=
 =?us-ascii?Q?EHfU1q10eChEvr1EZqOpqtzN?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c44baf-0b54-48fd-c544-08d9476e4f98
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6821.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 08:55:35.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhrfzEerTxdl9UhW19mdanqoOZoa9olitrgzKVtdkKE0pyzZcmdWq+iSIXzqau4F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2897
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Recently I'm playing around the Nvidia Xavier AGX board, which has VHE=20
extension support.

In theory, considering the CPU and memory, it should be pretty powerful=20
compared to boards like RPI CM4.

But to my surprise, KVM runs pretty poor on Xavier.

Just booting the edk2 firmware could take over 10s, and 20s to fully=20
boot the kernel.
Even my VM on RPI CM4 has way faster boot time, even just running on=20
PCIE2.0 x1 lane NVME, and just 4 2.1Ghz A72 core.

This is definitely out of my expectation, I double checked to be sure=20
that it's running in KVM mode.

But further digging shows that, since Xavier AGX CPU supports VHE, kvm=20
is running in VHE mode other than HYP mode on CM4.

Is there anyway to manually disable VHE mode to test the more common HYP=20
mode on Xavier?

BTW, this is the dmesg related to KVM on Xavier, running v5.13 upstream=20
kernel, with 64K page size:
[    0.852357] kvm [1]: IPA Size Limit: 40 bits
[    0.857378] kvm [1]: vgic interrupt IRQ9
[    0.862122] kvm: pmu event creation failed -2
[    0.866734] kvm [1]: VHE mode initialized successfully

While on CM4, the host runs v5.12.10 upstream kernel (with downstream=20
dtb), with 4K page size:
[    1.276818] kvm [1]: IPA Size Limit: 44 bits
[    1.278425] kvm [1]: vgic interrupt IRQ9
[    1.278620] kvm [1]: Hyp mode initialized successfully

Could it be the PAGE size causing problem?

Thanks,
Qu

