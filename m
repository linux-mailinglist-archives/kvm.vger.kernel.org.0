Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107703E2E24
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhHFQIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 12:08:52 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:65441
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhHFQIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 12:08:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEPEMF1PUXrxGeJhbn84rF9SaYGqNEzU5uFX/DubwWxcNDHS95lsjQR1L5hbzZEOdMwcgFerkZ7g15Jz6tGixOHBD20oDSSU1EIx8RJn02nTjSapejo0CmfGYDJkRz7bolsZknJykkxSwp+U6vYqYmH3nuoL2PnrCatWIqjjP2Si3BoQucZQknNpU09u0bbb8pamjv6utKyyEUWTzzTKxmuIlSwKRVnqrXjP5wrAHl/47QoKUrWZbJPP29pe0q492S2kjCbR2JsgB8rYGOITV9FuJPvoirz4p5/cdn/JuoeplCOprJSm8U0aA5vA1rS2GBPWcShEQB5q77OcsPQWrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCOYBaKexwpc+b+34GEzJ7gXHiWs8OjTU7dBl61d4qE=;
 b=CIzwUG6QOXZaTv6dsVlS+dEyoIKaFK3BoV9eGYiAmk6yegCULQvfRLr/TsEm0EKKo0Oz5CQCKU88lGkD/DEsDq8qiU172Iotf4kSl8Vy+Nh9U1XweBqL8px7qU6g1OoZ+QIqgTJZwRPtLZDKS44m7KtRpspjy8AejtF++JiASAmP43XRF2R2iulOX0A8b52Oax59VrX5uEgteUwiswbNLzN02sCjf85srkMKlbXOkWdbkm0Fu82Jw6jYxpUMYFcUvcThR2pn4feqhdQ1f0ob4BCwAJ6CdQp3BOhXnWdo1c4lF05vyIcWtTcWV+7ft0JUanox5y51+YbKEJWROY7iTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCOYBaKexwpc+b+34GEzJ7gXHiWs8OjTU7dBl61d4qE=;
 b=TTywoUFXFBtUnFQebfGGZDDLcZoWGzIXILmhhoS1uE4JsLo4/zZAxmTTeKr2Y6tHOA5FzSqL+MTi3iMIH6d/aB+Fb9V8PjNSHldpz0vqgJktprvfBISwmcaZily+vpfty/T883sg7xELGnnx37PjinbIVk77xLgClbkCOBiK99o=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1501.namprd12.prod.outlook.com (2603:10b6:301:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Fri, 6 Aug
 2021 16:08:32 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::add0:6be1:b4de:8bf7]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::add0:6be1:b4de:8bf7%7]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 16:08:32 +0000
Subject: [kvm-unit-tests PATCH 0/2] Couple of SVM fixes
From:   Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org, babu.moger@amd.com
Date:   Fri, 06 Aug 2021 11:08:30 -0500
Message-ID: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0152.namprd04.prod.outlook.com
 (2603:10b6:806:125::7) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN7PR04CA0152.namprd04.prod.outlook.com (2603:10b6:806:125::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 16:08:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 646703fa-753d-4a8b-99ca-08d958f46fd5
X-MS-TrafficTypeDiagnostic: MWHPR12MB1501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB150126997D8A2FCC5EA7E8EE95F39@MWHPR12MB1501.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hvrE9KXbOqwhkaFoHGHDB4yqaG683Ir2VcSKupzMroFrkuzGgi6W+ekH/EZJOTHVpwAS98NLAyLOfc1KmF1NB5Z/5HR5Or0y8EdnNsahCgXF39ZqdRib2QXJtaM70mPcj2q9i+aohDOpTWTb1aD9gzSmQ5pXOwjFNu6smJ0MzZaC53AfL38L/voVDmwEvx1+IrX2Weqrd/2icH6PglJpJ4zqCYZl3Az6i5Tmf3jwuOMAT5yIUU+mjQB6Rblkt5/f0grlZxRRuwPLMvZdV5Bw2FmBU3vewouBA3lNa+PlUe7DqJNnxvsGRGypDDW2x3kCiXWJ6pf5tTcPERGtyK4UIlI3QL9xzc4If1cnLecsmHRrB7oAKyBKGW3qD9g29R9tecZ4OlWIu7ya8/D8QevobscJIchsBR2d3uOEZX9xCGme4RV0NzVzS8ZhSb+XyUc3MpqleLta3ysWi1HgTlqrXva0+Becjqn7bukHmqA9vf6L1Vt+KwgB1cIgcDRoqa5I951QT0YH9IFnarUq1JziasDdqB/Mq9Es8ywnL+YSCf28SxrDF+LN70Bl8XruPVD33CzNSAAvHQYoJ2k47wiFMZWYQEgLyUk4D8wXfHPVWX7LnFxE5jLkQ+0DyXR2GAFQlcOfHXiG2MvEuX/bZ42DLJm9NPNfARuh8MkXBNaW2sTEnFJjp4N3pS5nQulUeP3eAAQKJ83TqwgHh9/JQwma8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(136003)(376002)(39860400002)(366004)(346002)(6486002)(52116002)(33716001)(8676002)(38350700002)(5660300002)(86362001)(38100700002)(109986005)(8936002)(478600001)(103116003)(956004)(2906002)(16576012)(316002)(66556008)(4326008)(26005)(66476007)(66946007)(44832011)(186003)(4744005)(9686003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3hMWnNCN1JXcjRKdTdVbm5WT0c0S0RrVmNNVnZ3VmVPc1FYU3VvdGVzVnR0?=
 =?utf-8?B?aHo1aC83SUdZeVRyN05YMjM2MitaZlc3cWd5VEp1NTAxU0IwWVcxSmZpWnJ6?=
 =?utf-8?B?QXJhdzBPMUFoZ3pIWHRrYlBUWnE1WXkxVEpYWnBEdjhxZGErVzAwUTVpRUFW?=
 =?utf-8?B?aFFKaVBJQS84OG52c0o2dmI4OWtGTUZmcXRWOUcvWDljc1RZWmtSYnJDVHBw?=
 =?utf-8?B?VVpsbDNncFNlQXUvTE45b3NLZktTc1dSSkRiRCs4ajBOZUdDLzgwZzdNZUd3?=
 =?utf-8?B?REtlQkswWmFTckcveUs3K3IxWUdKL1U3WllUYkt6WWd2OVZub1k2SUV6eHBR?=
 =?utf-8?B?MjhIb3JwNVhGajFabmxZQncvZDdJN0ZLckZSa0hkU1M0eldlVzZJNWFtSnpD?=
 =?utf-8?B?RXU1L1BSa1ZaWUk1QkpQWlNyM1MyeHFqUUIwQUxXRkoxUFZ2WmtsK2puZzhG?=
 =?utf-8?B?RkZ4YjNVUnFpREQ0VnY5VStncDgwbytGeTQvcnZydVh0a0VrcW9yczRBcVhJ?=
 =?utf-8?B?SkJOY2pVZC91NDBJQnR6YkNmRXZ5QVpLaVJTWFdOeUQ1YjQ3YmZjRXJXRUR0?=
 =?utf-8?B?MlAvNUtEL2xNcnpqb1YyOGEwd2lQS2FiNEt4MUQ4M01yVUc4cHlXaDc3c3Yw?=
 =?utf-8?B?V2dydENhQTVJRnkzMjFQWi93UmxSYXNFaXhYcnBpR2tUcU1ZOVlQMjFNMkEr?=
 =?utf-8?B?cFNmTkZ6RzVKRzFkWW01NnhxZ3dKL1d1Tk8vNGpMQnlRUCtsQm1mYjJoTEJm?=
 =?utf-8?B?NU9Makw1dHVzWDFQZld4dkdqQm80RzI4SEhxblBteTAzVEQxMFY3ZGJsYUhK?=
 =?utf-8?B?SXdNeVZ0emhIYWxVS0JRd0NITEgvM2JNZTIwZWVZa2JmVFp6RHR2eUdocWNE?=
 =?utf-8?B?MmNlYVNDU3ozWUoxWDZaZ0lxWVhCOWREZVFIYy9Dc3hjVnZIcDJQeDg1bkNu?=
 =?utf-8?B?YS9MY2ZYNExPK0U1SHdwNW9CbHN3M1hoU3dNRVYybGN0WlJvRUU0Qkg5c2cw?=
 =?utf-8?B?VCs4Mm1QL0ZoWjh5a3BjZ3R3TGxsOFVybllzU0dBMDhBSEpqNkx1VlNuRDJZ?=
 =?utf-8?B?NzF2bVg4SFhxaHZrN0p1REZremxiaERvYzRlR2pmeklJdml3dEpwb3NBcWIy?=
 =?utf-8?B?SHhLS29Ham1lRHl2QXBDWXZVZ0dQc1U3dGtRUHRkL0l2NWFDaXFoT1ozdkNM?=
 =?utf-8?B?MU5DcWJTUGNDWEZMMjRCWUV6OXdvRzVRRDlhYmY1c0N2OHlhSkFTNXpSY1Y5?=
 =?utf-8?B?akVjQ0RMMG9ocC8xSVZZaHNPczFiUkl6WnVXY3lvQkdCOHlRdi8wUitEZXBN?=
 =?utf-8?B?UnpwM0ZaSE1mV0hRUlBnck9QTE1ZNi8vSlZpU0Z3Q0YwY3B1YTZyelJKcmxE?=
 =?utf-8?B?U3JnbHc0SkJyWTZ1MWRtVTRqWGgxcFY0cjJSUmZCUnZqMGI0Rys1R2ROMW9U?=
 =?utf-8?B?SkdTdWZIZHFIMDR5MHFEYnJ0MjdlOU9udDhieWJZbGFhSlF6SUZaOUJORHhS?=
 =?utf-8?B?Q1owZlJ0ZS96a3ErUjdJUnFyd0I2eVk5dHBHSXY5b3ZtWWxPUDViSGJDdGVY?=
 =?utf-8?B?RjBUTWV3WXlJVEFwemVNYVlNZWRBL1pxNXpYUzJpSlc5WmM3NkcrVHMyUVpF?=
 =?utf-8?B?QUFUMHJUK1EyQWdrY1VXUzlwRDN3M1NZNGg1SThrSnJxRFMycm52QkpjWk4y?=
 =?utf-8?B?YUxOdlRJOGRJZ29iT3BJT0E0VmpTUVQrc3Nqb1ptN3QxdW9zb2UyU3hFczBi?=
 =?utf-8?Q?v5MCZN4A3y9tWKqoZI7rvDNvnIwceM4F6sOvaI+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 646703fa-753d-4a8b-99ca-08d958f46fd5
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 16:08:32.2235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9xVXdGsBNyk6Z+f+GDksuT8ACmyzfspgpb0uiNKFZKJV0v2JYBBzeCQDPrO5vqCt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1501
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes couple of unittest failures for SVM.
1. The test ./x86/access is failing with timeout.
2. The test ./x86/svm failure with infinite loop.
More details in each patch.

---

Babu Moger (2):
      x86: access: Fix timeout failure by limiting number of flag combinations
      nSVM: Fix NPT reserved bits test hang


 lib/x86/processor.h |   10 ++++++++++
 x86/access.c        |    4 ++--
 x86/svm_tests.c     |   25 +++++++++++++++++++------
 3 files changed, 31 insertions(+), 8 deletions(-)

--
