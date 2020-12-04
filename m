Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073C32CF3A2
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387624AbgLDSHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:07:52 -0500
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:26208
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbgLDSHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:07:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyRYQyGQd5+Pa4NAlybcHmqI41wZ4lJr9Msf/ZIJ3hIRvApJ/BCz6W0poSbfMQxBQ+HIIHGYSsXn7ZruGPoo1JopBkvSk9A5qbCrFsBHMb0HWM7EOOaajxZkn+MkpP3GdxrVgzj5onf/FnrA+lWBaJSp1VlXPjgcQ14E5yhgJFLMNylf0+tyEtxUFV5wtQJ0Oxn+qxI7ss4eL2qy0oryD4w2eor56ipFMj4+bFhGu/5Bxq/5FXjqlInFM3HxJsv4ZG+qRRTm7shQFRX57uyL2FHDFuQXQk0kMLZobXKpzNoValDXRnp0NEK6v2eXv7P4fjT+RKnZ6h+bEcK3dObFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqtlYiB7SlsGU27zMvWx80kTuZFINQ3U0kB1mhCHcBc=;
 b=ASLh2CkYjNGWvi77A8jc8IktfmCD1R4kkctHLDp0x3M51ah9g9NPbjkm105vPQgrJTI0qNjmRNdArYUzS0U3J7+BOGZ0FQZBixdGrK5oZCCIPYwnuqtl+KZgfECxZrmEzwIR18su+SoYWJuYj57j2n9yoPoahPEQXjkc+VzoBbcNCZI9bgbPc6qS7J3RvgHj09UiAOtdJnfzeHjk3AtUZD81B5F7OFJ7eWJlCIhDA6SC9ulhwCaHaK/8/RF0u8IcGqi9J3OWzhwr1TOFC5irbjYhH/rZtOPmi/5XBJw+JpvJOXbpK1vqcGBJSppPsjQ4ZEYyuMlVFHz37ny90caQmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqtlYiB7SlsGU27zMvWx80kTuZFINQ3U0kB1mhCHcBc=;
 b=ihTw0CnjznH3bSXPj7t91dGPAjEuQyiTcA/MLjNyke4GGFe1CcOZqQBLfdbgj9NCmKvMU2obLNpwvXZK42HgdaLRcelrLtRdyzCdcZpE2aRQAZ7ytw6vgHVdX0/zw9dMUYA+Sjq4YwksyyMZFisIAAgxMbaGK28W0iQ6aJwxDqk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 18:06:57 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 18:06:57 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     seanjc@google.com
Cc:     Ashish.Kalra@amd.com, Thomas.Lendacky@amd.com, bp@suse.de,
        brijesh.singh@amd.com, hpa@zytor.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rientjes@google.com,
        srutherford@google.com, tglx@linutronix.de,
        venu.busireddy@oracle.com, x86@kernel.org
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Fri,  4 Dec 2020 18:06:45 +0000
Message-Id: <20201204180645.1228-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <X8pocPZzn6C5rtSC@google.com>
References: <X8pocPZzn6C5rtSC@google.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0020.namprd05.prod.outlook.com (2603:10b6:610::33)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH2PR05CA0020.namprd05.prod.outlook.com (2603:10b6:610::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Fri, 4 Dec 2020 18:06:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e1c31409-2e3c-4b9a-1b10-08d8987f639f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495BEC236005715D13CA18E8EF10@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGYVB6tQzH31qxWL9u+murwXEQZ2Xom2Do0QC888ZkYwbigIQGvpIyrpHhelU8Ci6Axbl3XfljqG3hGOG6SE9e9JqyYN4PaS7k6e0pnoVR9678UEzFZ4F5sM0ZRc2rbEFoQharaIL0BWMQQGIw52CwIbO06VWY01MmeLmCr/iiGHZTRf+fp1Z1FSP+0eJ3wrEVi4FKBIdxg1m1BnMX83Ae2xbqSl0q7u3X861ys4ayoAAlocX5jBJRf94Xf/hJp6CoDobd3SmwhuQp2oRMGXbHpq+JgDFUFRuJkxXCKC9y5O172EXowu5MepwqrYqsd/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66556008)(66476007)(66946007)(6916009)(316002)(6666004)(36756003)(26005)(4326008)(186003)(7696005)(558084003)(16526019)(7416002)(1076003)(6486002)(8936002)(5660300002)(956004)(52116002)(2906002)(8676002)(2616005)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+a694h88efJ0lCABl6oYfRdNinRYqt2yOYmqpl8ojzFHLT94G03eGDE/sUCv?=
 =?us-ascii?Q?k5/2SmArqJdAficg0/2BlGDu+wk2v6bUTIrcqc1ReNQfl7gcv4Cx6tBbY3/S?=
 =?us-ascii?Q?4CpcFwI38hJWIo8WIPU0fjwWzNIdAnGvW6hAqAElI1I7NzSUZBU/1Ymy2359?=
 =?us-ascii?Q?rkIzdq4MKcCvYPPmuHmk9k+yLliN01NPt8Mry78tdUTXWA9ySPylY0ES007H?=
 =?us-ascii?Q?9DftYBifKwWUoQfrVQYUkWrUZIQqvwm4bT+pK2M2QUP8Seg7pVKr3RpBL1ZV?=
 =?us-ascii?Q?8lHsy609cDatoUhZL+M5cv3kpo8MgB8gj1muQLZ+fQzwshJN1FmnjxfroSRG?=
 =?us-ascii?Q?MzMkjWhFUPbFFJe7nqSkSRLTMSmRAP0O09Lsc75C2kbvI4C7XsOmTNWQx/sX?=
 =?us-ascii?Q?/zdtw5VGVItvSAutGvQ/X3GTqQ2npjY64R3OH+xNQryp+AEr4DVsOTDH1lNN?=
 =?us-ascii?Q?77vKlNhzX3xSZGi6t4HXM+Dn73seamcJx4519Trhw7WjH/Z28iRbDBvtGBQz?=
 =?us-ascii?Q?PP0qlhN1zDsjljn8kte1PMt1xOq3MBcIsLDKaFzX2zW7JyKRVbyiljTp7ffG?=
 =?us-ascii?Q?vBVAYdyuf9Kr/ZCy1ITqeeAOw5JZFxYzvVQPDZ79WBOx18iCs1qAIymy5JJW?=
 =?us-ascii?Q?Aru6bLGhDWsSvV0VuLuL1O+rQ0NNCrIw4PI3JSdLlgiZhVuL3+w2k3F8QvaX?=
 =?us-ascii?Q?NhzTROjpiuj8q4XS2WY84lrP12kKfFGcdjWySW/EebRYoxbZT6mZFGEORnjg?=
 =?us-ascii?Q?dIGYaujqXxDQc27hpO7M25RXVqN/8CU/OPincgvD3RhQG90Lk1i/oHN4Wm8h?=
 =?us-ascii?Q?jwc8Pm/ocfptHJFvmehNBRxxwn54ZRekA/brNYyfoX72frDtFrqvd6S6Jhhu?=
 =?us-ascii?Q?efCJ/xeIqLUnow9m/WJSkOx2z+VEh7UcgJYnkjuX/Wg7VNsYsYjp6x0uQACg?=
 =?us-ascii?Q?M/ILg3SfoyBUjFZP/Yju0tEhAC4OkewQFkgSWLarAQGqQGDYzDAuX4eM8fB+?=
 =?us-ascii?Q?z9JV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c31409-2e3c-4b9a-1b10-08d8987f639f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 18:06:57.8401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdLly1RbZ9WXe7SlKgWUOJQna8qY93K9tm5sEDgcT5f70A7ExkKcDMKQDpe8gyNmnx3o48LwacCJxgY127jrkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yes i will post a fresh version of the live migration patches. 

Also, can you please check your email settings, we are only able to see your response on the
mailing list but we are not getting your direct responses.

Thanks,
Ashish
