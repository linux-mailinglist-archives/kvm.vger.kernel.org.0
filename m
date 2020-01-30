Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A68ED14DC61
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 15:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgA3OCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 09:02:19 -0500
Received: from mail-db8eur05on2107.outbound.protection.outlook.com ([40.107.20.107]:9953
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726980AbgA3OCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 09:02:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLsn6bh2jAT7OVTGIW2IMV/RZGW2/01Z5RkFtTPkJeFEnK2Hf+RQW8CraQlH5a25faNQ69qVrdbPNjfscbMhFIjFyJA9f5Zy0aunKPJrhg7shA2jNCuSGxqTJ4XMGSWx65dhVczYFcrGnbN4ImP1inW9X88gmEjzhhx7uxEdqKGfyYdUZLDuHNgYTjAUOeYeTLK/RrwQHz9+NVMT4TNIaDAHscNiwaWOBaGwRF1BVlQItTrBm4ccFPebGtLgGaaLDJXwjBcfsoR7yVJWND1fGtADgnxkOnk4UmeAyoeTbKFV4LB3Vk0xw9sWC8TZEUKwwzdMSSS8W0j0dpR4YOsnTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxwxSFoEZwlZBxajHelkHFfQ3CHrRmks5zABmy+6Puc=;
 b=QkyAeOfeZc9FrIofYCOlpFf2dNsxDGwy62CT4q5H0a4qKIctqBbp531WQHuFZAutjjD/C4R/li0j7xYnGKqhvazBiglMPfC0g6T5ToJ3jenMTxe7nv5WSPxT6WnoWWpxOneamQ4x02kqdLVFVim0L28WJP4QKOpwDrDxns2lN1MeSmOqAlBVUxAPLPBiKB90HGeZPFFUIYzMEH1p73wQtp3Wd7kNMX6np8kPgo7zvrCXrVWQq/k9HEMjKg/l4XYt4ynyzHNxrOTeruj9QeStaQ5z1mDEkEPBsYk+wqX810RqSP9+u1528OUPl9D0a267KZbkA3wQ+wQNCISyjX6OTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxwxSFoEZwlZBxajHelkHFfQ3CHrRmks5zABmy+6Puc=;
 b=P8VJ14JigaXF8txBTjZXtgROM18DL1zvQk0avcWfUW4envWFUW3FlVrJZqIu0UypHXiAl+V1JuF3Yjy77fyjyyNnXDLTxi5qXxA07hGmQRtlXxWQlq1cGnrTH1zyHFVeagKI3LY6JzCHIuvjZDZ4pTrOBmfj3bFvIqfw3lddpWk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vsementsov@virtuozzo.com; 
Received: from AM6PR08MB4423.eurprd08.prod.outlook.com (20.179.7.140) by
 AM6PR08MB3765.eurprd08.prod.outlook.com (20.178.91.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Thu, 30 Jan 2020 14:02:15 +0000
Received: from AM6PR08MB4423.eurprd08.prod.outlook.com
 ([fe80::11a9:a944:c946:3030]) by AM6PR08MB4423.eurprd08.prod.outlook.com
 ([fe80::11a9:a944:c946:3030%7]) with mapi id 15.20.2686.025; Thu, 30 Jan 2020
 14:02:15 +0000
Subject: Re: [PATCH 00/10] python: Explicit usage of Python 3
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Kevin Wolf <kwolf@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <20200129231402.23384-1-philmd@redhat.com>
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
X-Tagtoolbar-Keys: D20200130170211933
Message-ID: <0a858225-685d-3ffd-845c-6c1f8a438307@virtuozzo.com>
Date:   Thu, 30 Jan 2020 17:02:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
In-Reply-To: <20200129231402.23384-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HE1PR0401CA0043.eurprd04.prod.outlook.com
 (2603:10a6:3:19::11) To AM6PR08MB4423.eurprd08.prod.outlook.com
 (2603:10a6:20b:bf::12)
MIME-Version: 1.0
Received: from [172.16.24.200] (185.231.240.5) by HE1PR0401CA0043.eurprd04.prod.outlook.com (2603:10a6:3:19::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Thu, 30 Jan 2020 14:02:13 +0000
X-Tagtoolbar-Keys: D20200130170211933
X-Originating-IP: [185.231.240.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c02e3f0e-44a4-4ea9-7059-08d7a58d0292
X-MS-TrafficTypeDiagnostic: AM6PR08MB3765:
X-Microsoft-Antispam-PRVS: <AM6PR08MB3765DFD222E16286EB8B6E5AC1040@AM6PR08MB3765.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 02981BE340
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39850400004)(346002)(396003)(136003)(366004)(376002)(189003)(199004)(36756003)(7416002)(186003)(16526019)(4326008)(478600001)(2906002)(316002)(8936002)(8676002)(81156014)(52116002)(81166006)(54906003)(966005)(16576012)(66556008)(31686004)(5660300002)(26005)(6486002)(956004)(2616005)(66946007)(31696002)(66476007)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR08MB3765;H:AM6PR08MB4423.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9TEoxTpDai8iLOVJileNgdEUOg5tBbLKxTybuFM+TvzmPESkhtTJO1JEElUTUza0vVKVqejpkj9+nFQ7VDNIKEoEwfcOeI9X/MilFwSIt7nlAm98jVotibtpLB9ED4uG4EkIgBO7pK5+LI+wfWTUMgNLUolj7rXuYeHoM3R89ksR2zj+4dD6MvW5Fd3Ln7DdsIi3dmFzR9Odk2BPzcpOtd+Ubb0GWARivS+e+RNa+TVm+BoPBeGOy+5AElYg5abA7pFpIAO+abndLR3huVEHqpXckNj3kKN6Q0NqSlmryachyGzC2GUfEBozcsOZTBluYIiKzj11C5XkrBzTNUWLr2PVZdjxFkaJXtiXwVWUINzqjmG7CDsNCeEaDumNXgAupwi83eJ6mHFYytxpPdD/bS93eUFS8YCDC8hw7cmhfi1mEKgoQLf1aGnaqMojtK7efpxqd2aeKOsfkk20WCVR1o89ljHCsBZp5KNiKOEHrCwkkZzNwrnYxWto2JF4viJ1VQVBlTJsGD/AQgM/m7jAg==
X-MS-Exchange-AntiSpam-MessageData: SJF2O8JjZqkWm2s2cLtwFYnqrgMr8ESlHAQQt1C8/y6ZR0skBdCVILVViWBNE/4OsmK5P8RiuN2B6GpiumMDRMDub7sB5mD6V1bg0+o7Zu0LvGZDYrX8s64b/xoBYKJm5j/bO6xFHn5PaBJrMlDVYQ==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c02e3f0e-44a4-4ea9-7059-08d7a58d0292
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2020 14:02:15.1216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dE5hNxXmL5eiiVjyShwveANX7EcLRRVaGbYIASBD1+yI7hVIvbYh1jBdcs1mwjgia016JdRTMxLIWbBkTqRGOBrlcSOCSMvmU1I3FbyDlh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3765
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First, thanks for handling this!

30.01.2020 2:13, Philippe Mathieu-Daudé wrote:
> Hello,
> 
> These are mechanical sed patches used to convert the
> code base to Python 3, as suggested on this thread:
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg675024.html
> 
> Regards,
> 
> Phil.
> 
> Philippe Mathieu-Daudé (10):
>    scripts: Explicit usage of Python 3
>    tests/qemu-iotests: Explicit usage of Python 3
>    tests: Explicit usage of Python 3
>    scripts/minikconf: Explicit usage of Python 3
>    tests/acceptance: Remove shebang header
>    scripts/tracetool: Remove shebang header
>    tests/vm: Remove shebang header
>    tests/qemu-iotests: Explicit usage of Python 3
>    scripts: Explicit usage of Python 3
>    tests/qemu-iotests/check: Update to match Python 3 interpreter
> 

Could you please not use same subject for different patches? Such things are hard to manage during patch porting from version to version.

Also, will you update checkpatch.pl, to avoid appearing unversioned python again?

-- 
Best regards,
Vladimir
