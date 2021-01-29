Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F5D30827D
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 01:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhA2Ahk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 19:37:40 -0500
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:21985
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231224AbhA2AhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 19:37:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OI+3tnVGtcdTbhopAoZ6ule685svDMKVqoH0pLPSKAMp5dKVcEwCtYD+401Yz0zgYItqDAC87/3fwP5+j9xWU/qSS1Hqstb9oGCZMoyYFA328cSIkxhJ8Jj8/QZQRWUNf3WcGlWCZQcnvqP/uWNafqRD/KaZDNa5mtUwjoYhJ9suF5kHLLu3UB3SN+CIJIR54ueRvTDBq/DIHaqBnOgaDSniJ1U1xbmwq0HljoULVTm+l1t7jN+gq+4j7OPqJDOk14jzd3kg6DleQ/Mfeb9/2K2hEg6Ov0xBdAB0s+133fWye5jOkR7ZInFHLGYgQqsy6w3iinAADzcD7t9CHZxsEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AruFte91wRB3UbNqyw/AX12Rp8NizpbMwBa1k3aBqnE=;
 b=TZTbiBJXXnQ3t9z6/EVTAOFgvwYH5QO3ZuFS3EoZrVdjP58BSIZhWjmqRnlrPQ/5v1BBQ2UBTrd5qwcPWnmPHyF5tbdvStVfTQRhrPrrQh9NxJm6ABIdkMgDZpwRqEJHT5kvg20qwWQ8GYZ5x21c4s80U5dC2UhwOmxYAAeA7DWM8Io+Cs/wFzSyjlnXaO8QGKdhDGyFg6tWiZ01Hv+f9JHec22xCraf12dNDGnhLonkGInTSiMHkmyKD4vHJbonh0iXXQTCo2flRI09L0WuVYAAtNeC48ZjOckKqw/o77bNFRCBZv89pXd+Het8Ff6/AL1iGbvAQrWH7AxFwVURQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AruFte91wRB3UbNqyw/AX12Rp8NizpbMwBa1k3aBqnE=;
 b=tr+VRiL2ebnHaMBq2iZOtseMCn2WqqE6ne28WhzQLKU5Dr4rFpGBVfPDzWkr2OFcemWfU8RC1VSsbsMUOPE/4KmXZdUIwY15U5ApkE1uaPkFe2lov/v7HX/730xTSdewEqzRENInis7Ds7DyUHqBJLdkmXz6ltwpYxbsxuL5nus=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2525.namprd12.prod.outlook.com (2603:10b6:802:29::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 00:36:13 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 00:36:13 +0000
Subject: [kvm-unit-tests PATCH v2 0/2] x86: SPEC_CTRL tests
From:   Babu Moger <babu.moger@amd.com>
Cc:     kvm@vger.kernel.org
Date:   Thu, 28 Jan 2021 18:36:10 -0600
Message-ID: <161188044937.28708.9182196001493811398.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0291.namprd04.prod.outlook.com
 (2603:10b6:806:123::26) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN7PR04CA0291.namprd04.prod.outlook.com (2603:10b6:806:123::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 00:36:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 041bbfad-c033-40ef-933c-08d8c3ede060
X-MS-TrafficTypeDiagnostic: SN1PR12MB2525:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB252588D9DADA067AB4475A2995B99@SN1PR12MB2525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vg4zCzTeVA28k9+kc4lINKRQHeu5D9v2OC6vDDBLYetzbjvWCGJtMD8cX4kXl70hiVtIIa3fby8N2k/n0lhvLMP0q8H+iurYSTiECYZLMizS3tOrIAnvQki92wVc9whhjOvDCjowODLfxQImqpnOnuS2VUCAfjRb+44xlOEu4364mGyLyW61Gn3xhJUwyMszweTCTMAQoN/+mJDCwBseu1EUfavqF0ubnWED+WKZTLW98O3L8cCw3BGIkcq/OjCAbj3JRjY4+XfsoKHt/vk5EkKNGnxHacslKSCrjKPAKrCiHLa3yzslvgn+v7iL6o+Fx9u0+8RbJLaM7rPluC/YRKhFiUkTxdz4CDH4yjuS3XKd9MTRlym6iO0QG9nYQEcIOI0yQBEqI6ckOem1t9xKJd1GXFSfYBOKcFbM/uXG/lvQnHHPwKLIP3U8lUuvwCHeCUwwywWtdgWtLVB3D8bB51/Othh/MAaaob/Nvea9Q4CM4xHgoGZ9pT1eqCcZxvhlJFL8gTMVooWg4LVkaF9EOuxgWiJccul/LXKOTAgzQGykHRvOjko4jwcs+kA2wqOSutmH3+9sKIxC08XaU51qdTlvKi8Rjh6p+iwq5a5aTcY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(39860400002)(366004)(136003)(376002)(83380400001)(2906002)(103116003)(66946007)(8936002)(8676002)(52116002)(4326008)(86362001)(66476007)(66556008)(109986005)(966005)(186003)(6486002)(478600001)(16526019)(26005)(5660300002)(4744005)(33716001)(44832011)(316002)(16576012)(9686003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b2FRejRSVklWRHNhTFdpWFVjWEZiM1cySlhyVEJOWnlENXRyQ3owMU1wSUk5?=
 =?utf-8?B?Tmo1L1lLS2JETXhHT3dSR2twQjMyOThUS1A1RHBEV1VSOWxsS0JYaTQ5RnZD?=
 =?utf-8?B?YVpuVW5BUk91RWYzSVM4a29LeFh2eXBsU1dTdnVEYVRFMUVVOTFqSklSN2lU?=
 =?utf-8?B?bXRQZ1c3azM0eHJDZ0hPZUlJTk9lelZMTFlYVWo5NmQreG9hc3MvcWRMdjFI?=
 =?utf-8?B?eVlITHpZSzNXdWFJNEZCdHZCeWZNZmNGaURzRGV2c0dVOFVwV2t2ZHE5MklE?=
 =?utf-8?B?Q3lmMyswb0ZKTjNHN3BZM3lQSXRpMjZjN2JSRUZMc0x6b1JaUDhKaDllUktB?=
 =?utf-8?B?bFJUMTlyMEdCaHQrSHUvdVIvaXU5Mk81REwrM2YxZmszZHJmMjlZNmpHbVlu?=
 =?utf-8?B?bTRiYUI2WHR4U2lick84amplVDBlVnhYRytEZThDUHRtZktYeE1jREh1WHRu?=
 =?utf-8?B?RjVDTGZ6OHIraEtOQjVKQytQUUhPaWxQYUkxM3lodDlIYWZ0dmlRMEVqWmVy?=
 =?utf-8?B?ekZUdnZKb1lqWEdUNGw4ZG44a2FhR0R6NkNab2VmS0NsSU9VSUdDMEZXZkRw?=
 =?utf-8?B?UWJUTnMvTFpjTUxrbjgrOXVHL2lvUnZiYXpkME5NTGlJMEt2VmxQaU5BanZr?=
 =?utf-8?B?QnJwS01Ib1BBUUYxemkyL2tVbk42dVZJekg1VVdJRVBuZjRySmY4bU1OTmJY?=
 =?utf-8?B?ZWFobDVneVVZY2VHdGplVWswV1FvWi9tbXNIbGJoVzg0ZzJRMGNHNFlOTGRu?=
 =?utf-8?B?U3dwWEdoT2hnZzFFRENPMGJobEJNTGNhUENZQmw2eVlXSzdpNkRyNWsyMlBa?=
 =?utf-8?B?UkJGQ21Zb01uU1VLalk1VEtHNWR3V21pM212b3VtUlkzd1VjcFphMTR5T3h5?=
 =?utf-8?B?TFAyUTQyT05TVlU1eVFJL0dKWG9xL3FjNTRpL2F5SjJOaVUvNmpRTGpYOEFM?=
 =?utf-8?B?NklGVGNBRHJDVHRXT2FmNXlIL1NMeHIxeHc5Tzl1ZHBuUTNjenNnZ0NsemVk?=
 =?utf-8?B?SEYybmN2Q00wRVkvR2JycWtvVW9xR1J3MkFsWmEvK2JVUEFnRXN1T0ZwbEFs?=
 =?utf-8?B?cS9ZbU8vd3ZsVmhuQlluQ2xRRWVwd2RaTExVSUJBRXhrckp2a3NNZDZQTlhr?=
 =?utf-8?B?RXd0TmVBU2t0YmpIbXVpRDJqRHpwejFkcTIwQzhnckExTmZjMVBkajQ1ZU11?=
 =?utf-8?B?ZkExbkVDQzBjeTU3bkVxZzlsekdNT3Zoc2p3K29ubGt5Y3lUTGVJSXlzbWtz?=
 =?utf-8?B?R2k1Vk5XSzlSOFUvU0hFbmVkV3pxemJuV3NiWi9adFg0TTRZVytwRG9vRTJh?=
 =?utf-8?B?MnVMdjJYY0pJMkFZUGhQUjRZb2NRd08vY3JsUmZKcFVuQjAvSzFHejBlejBT?=
 =?utf-8?B?RmFIVDBUQ1VnK2pHeVcwWXdnZmJtMXdxZzBDalg2andabXBzWFBNbmRGbUhC?=
 =?utf-8?Q?dmiLPu/P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041bbfad-c033-40ef-933c-08d8c3ede060
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 00:36:13.2574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFEwliMHljL2QOlUqdhpBE13H5GxpFqXCroeVr71Ej/CgDltJuQIuRvkEmYmnYaj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2525
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add SPEC_CTRL detection and verification tests.
---
v2:
   Added svm SPEC_CTRL verification tests.
   Changed few texts.

v1: https://lore.kernel.org/kvm/160865324865.19910.5159218511905134908.stgit@bmoger-ubuntu/

Babu Moger (2):
      x86: Add SPEC CTRL detection tests
      x86: svm: Add SPEC_CTRL feature test


 lib/x86/processor.h |    5 +++++
 x86/Makefile.x86_64 |    1 +
 x86/spec_ctrl.c     |   30 +++++++++++++++++++++++++++++
 x86/svm_tests.c     |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |    5 +++++
 5 files changed, 93 insertions(+)
 create mode 100644 x86/spec_ctrl.c

--
