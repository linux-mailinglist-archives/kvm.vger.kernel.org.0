Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDDD19C9CE
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 21:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389261AbgDBTRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 15:17:30 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:17967
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbgDBTR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 15:17:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJ04VtWHeSNau6vMFLpCYdzDogGJRGseecq0JrbkhmHenJkrSH4dn11wlj2hPOzchcWkb2PNgh+cYxvGEJCgM9diTS/797a3t2IcubxSvpOqZk9eDQMzAEZTeHKT98QPo7tKnUnEbLNurSEGhaQLwYiXk57GUQ+wwSUcmj9dYiouL0UH9MLsgBDXPZxJ+2AuMAWFXAd5B3A6h4FrJVCeKo5LWgWY7/r4u474TAxJBA92uEuFAv01/4rDiSQm53zr/7Pja9cGUmf3+eWGHPF34A0S86RZU3fHvrfZXuLd/lTxFYj2jD0WGyPv+/GwoJ87mMBtX9qHiUMSzufXQ34Zbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lq8EWO13RqX43qR371MsSf+REL4UESkrNJ1dLG6jgWs=;
 b=ll5PyDALAOexUz/Jf8hiioESuTzLmBIBLDyKrtsdwbUUqKlRhZkRbxER8CY9fABX3GaVxuSTIIT8f46U4wk/A4RUMw6FI++G1efdHvDKjywU8gHRVvm6eoEuG2EtkytS7fCgDWuiOc8MDKVsks9mhFYHaIB9Z4cUQnD771Aa7V4PbHWUTs+SRkJLtJlztpcqLmE9puFQ1KKcFLwYVgW9zkFwKDWeSIwUvH/0+//0elRg/F8pLzpgI9BX3iK+sm1DHCU9PNIyPKfo1BgaVhrijI1wtATq+siok76nS+eDhIIwvsNtLsuNcOVIrPf3uJ+hdqTYKZYmQo3rPIZh+ZXzVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lq8EWO13RqX43qR371MsSf+REL4UESkrNJ1dLG6jgWs=;
 b=rfImJMOC9UD0VpZU5M1JmlUlL57VenIvo1FoCdxTo0eunGbV0GlG6JvP+7mQIqUPOb9jeXLOB86uz3/d66C6+SLcNC+RsZxnTxmDFt5gTWBonDrG7NzYER4TPwCN+nE6YMD6AdFcuGMktC25Wh/8zNyvLRIMaopnr+jwgVB0GJE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Thu, 2 Apr
 2020 19:17:24 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 19:17:24 +0000
Cc:     brijesh.singh@amd.com, Ashish Kalra <Ashish.Kalra@amd.com>,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 01/14] KVM: SVM: Add KVM_SEV SEND_START command
To:     Venu Busireddy <venu.busireddy@oracle.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
 <20200402062726.GA647295@vbusired-dt>
 <89a586e4-8074-0d32-f384-a4597975d129@amd.com>
 <20200402163717.GA653926@vbusired-dt>
 <8b1b4874-11a8-1422-5ea1-ed665f41ab5c@amd.com>
 <20200402185706.GA655878@vbusired-dt>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <6ced22f7-cbe5-a698-e650-7716566d4d8a@amd.com>
Date:   Thu, 2 Apr 2020 14:17:26 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200402185706.GA655878@vbusired-dt>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0501CA0120.namprd05.prod.outlook.com
 (2603:10b6:803:42::37) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN4PR0501CA0120.namprd05.prod.outlook.com (2603:10b6:803:42::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.6 via Frontend Transport; Thu, 2 Apr 2020 19:17:22 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1eda7630-cb20-4f0e-01cf-08d7d73a79ab
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:|SA0PR12MB4349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4349EE03349D23486172E193E5C60@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(7416002)(6486002)(2616005)(6916009)(6512007)(6506007)(36756003)(66946007)(31696002)(53546011)(8936002)(66476007)(956004)(81156014)(81166006)(8676002)(52116002)(86362001)(44832011)(5660300002)(2906002)(4326008)(16526019)(186003)(66556008)(31686004)(478600001)(26005)(316002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXt8vEFTSSp8/RS/yEkk9tZ2+svoePvVkW4TTZD1/gMetdpSUukd0eR3XpYqzTrhzquANA31AtprNNDTgmqgokxCChNM31peAGHRBXGpzw2cNifnbN29SOllbSB4H+Ce4hQPaPd0d1huF7pOgd7GjBkA957vAupX0vMbQZ+I+31gyRPyFQt5v2WEk1mqPiX+VpOb85lh6048YmQc7WmbDFCdUwnzj3jZ0xStNSM/0AV9mK7iusrN4jRizuE9mnBRujj0pVP0pQCAxSVQ80YS+B/zgFvXuUbb9VnLT8y6WlaxJc4rC3/e0qbGrHkWdFw/59Gok5fFaa4JYkJPLPUeX8xh0ua6lDtxrOIGFHHn2hreXn5waedmTtGoDetWBgLXw0sjxkfEDmWbnt/KH4HUqj5CW29s3pCYonoMtYEkCvhbJ1PEyOyg7lijghmBc580
X-MS-Exchange-AntiSpam-MessageData: WJvC5WEfzIKKn/NkQHY6Tq8JVOvYeYx4pLv9FZTGPkvGge2b77GK4RLBHOe9WEpLh+wvy0W1Mg5CxHJN9MQWQcoVsvBdoiVoisaN2qY7DJqLbdoytkKuN5fhGC5RtfNqNetqIBtFnBWV+eZS95FTIQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eda7630-cb20-4f0e-01cf-08d7d73a79ab
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 19:17:24.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hB2R8IYolXLJOTedJWw0vLe+Eh/wIYiiQlqXIZ3Fg3GChrZoSaHTptYJfCgFfoauV2xE2JwJJWs/LfElueY64w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/2/20 1:57 PM, Venu Busireddy wrote:
[snip]...

>> The question is, how does a userspace know the session length ? One
>> method is you can precalculate a value based on your firmware version
>> and have userspace pass that, or another approach is set
>> params.session_len = 0 and query it from the FW. The FW spec allow to
>> query the length, please see the spec. In the qemu patches I choose
>> second approach. This is because session blob can change from one FW
>> version to another and I tried to avoid calculating or hardcoding the
>> length for a one version of the FW. You can certainly choose the first
>> method. We want to ensure that kernel interface works on the both cases.
> I like the fact that you have already implemented the functionality to
> facilitate the user space to obtain the session length from the firmware
> (by setting params.session_len to 0). However, I am trying to address
> the case where the user space sets the params.session_len to a size
> smaller than the size needed.
>
> Let me put it differently. Let us say that the session blob needs 128
> bytes, but the user space sets params.session_len to 16. That results
> in us allocating a buffer of 16 bytes, and set data->session_len to 16.
>
> What does the firmware do now?
>
> Does it copy 128 bytes into data->session_address, or, does it copy
> 16 bytes?
>
> If it copies 128 bytes, we most certainly will end up with a kernel crash.
>
> If it copies 16 bytes, then what does it set in data->session_len? 16,
> or 128? If 16, everything is good. If 128, we end up causing memory
> access violation for the user space.

My interpretation of the spec is, if user provided length is smaller
than the FW expected length then FW will reports an error with
data->session_len set to the expected length. In other words, it should
*not* copy anything into the session buffer in the event of failure. If
FW is touching memory beyond what is specified in the session_len then
its FW bug and we can't do much from kernel. Am I missing something ?


>
> Perhaps, this can be dealt a little differently? Why not always call
> sev_issue_cmd(kvm, SEV_CMD_SEND_START, ...) with zeroed out data? Then,
> if the user space has set params.session_len to 0, we return with the
> needed params.session_len. Otherwise, we check if params.session_len is
> large enough, and if not, we return -EINVAL?

